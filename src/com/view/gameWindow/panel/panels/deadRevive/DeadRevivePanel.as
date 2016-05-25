package com.view.gameWindow.panel.panels.deadRevive
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapCfgData;
	import com.model.configData.cfgdata.NpcShopCfgData;
	import com.model.consts.ItemType;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.mainUi.subuis.activityTrace.constants.ActivityFuncTypes;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.buyitemconfirm.PanelBuyItemConfirmData;
	import com.view.gameWindow.panel.panels.convert.ConvertDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import mx.utils.StringUtil;
	
	public class DeadRevivePanel extends PanelBase implements IDeadRevivePanel
	{
		private var _deadRevivePanelOnClick:DeadReviveClickHandler;
		private var _dataManager:ConvertDataManager;
		private var _totalRoseNum:int;
		private var _mapName:String;
		
		private var _delay:int=30;
		private var _duration:int=1000;
		private var _intervalId:uint;
		
		public function DeadRevivePanel()
		{
			super();
			canEscExit = false;
			RoleDataManager.instance.attach(this);
			DeadReviveDataManager.instance.attach(this);
			BagDataManager.instance.attach(this);
		}
		
		override protected function initSkin():void
		{
			_skin = new McDeadRevive();
			addChild(_skin);
			setTitleBar((_skin as McDeadRevive).mcTitleBar);
		}
		
		override protected function initData():void
		{
			init();
			_deadRevivePanelOnClick = new DeadReviveClickHandler();
			_deadRevivePanelOnClick.mcDeadRevive = _skin as McDeadRevive;
			_deadRevivePanelOnClick.deadRevivePanel=this;
			_deadRevivePanelOnClick.addEvent(this);
			addEventListener(Event.ADDED_TO_STAGE,onAdded2Stage);
		}
		/**调整复活按钮和购买按钮状态*/
		public function changeBtnStatus():void
		{
			var manager:ActivityDataManager = ActivityDataManager.instance;
			var isEqual:Boolean = manager.isAcitivtyTypeEqualValue(ActivityFuncTypes.AFT_LOONG_WAR) || manager.isAcitivtyTypeEqualValue(ActivityFuncTypes.AFT_NIGHT_FIGHT);
			if(isEqual)
			{
				var isInActv:Boolean = manager.currentActvCfgDtAtMap ? manager.currentActvCfgDtAtMap.isInActv : false;
				if(isInActv)
				{
					Alert.warning(StringConst.LOONG_WAR_ERROR_0007);
					return;
				}
			}
			var mcDeadRevive:McDeadRevive;
			mcDeadRevive=_skin as McDeadRevive;
			//可以玫瑰复活
			if(_totalRoseNum>=1)
			{
				clearInterval(_intervalId);
				PanelMediator.instance.closePanel(PanelConst.TYPE_DEAD_REVIVE);
				MainUiMediator.getInstance().addDelayTimer();
				sendReviveData(2);
			}
			else
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.Dead_PANEL_0001);
				setRosebtnStatus(true);
			}
		}
		/**隐藏自己*/
		public function changeStatus():void
		{
			this.visible=false;
			this.mouseChildren=false;
			this.mouseEnabled=false;
		}
		/**购买玫瑰*/
		public function purchaseRose():void
		{
			var manager:ActivityDataManager = ActivityDataManager.instance;
			var isEqual:Boolean = manager.isAcitivtyTypeEqualValue(ActivityFuncTypes.AFT_LOONG_WAR);
			if(isEqual)
			{
				var isInActv:Boolean = manager.currentActvCfgDtAtMap ? manager.currentActvCfgDtAtMap.isInActv : false;
				if(isInActv)
				{
					Alert.warning(StringConst.LOONG_WAR_ERROR_0007);
					return;
				}
			}
			var data:NpcShopCfgData=ConfigDataManager.instance.npcShopCfgDataByBase(ItemType.REVIVE_ROSE_ID);
			if(data)
			{
				PanelBuyItemConfirmData.cfgDt = data;
				PanelMediator.instance.switchPanel(PanelConst.TYPE_BUY_ITEM_CONFIRM);
			}
		}
		/**初始化文本*/
		private function init():void
		{
			_dataManager = ConvertDataManager.instance;
			
			var mcDeadRevive:McDeadRevive,defaultTextFormat:TextFormat;
			mcDeadRevive = _skin as McDeadRevive;
			defaultTextFormat = mcDeadRevive.txtName.defaultTextFormat;
			defaultTextFormat.bold = true;
			mcDeadRevive.txtName.defaultTextFormat = defaultTextFormat;
			mcDeadRevive.txtName.setTextFormat(defaultTextFormat);
			mcDeadRevive.txtName.text = StringConst.DEADREVIVE_PANEL_001;
			
			setBackReviveTimer();
			
			var mydate:Date = new Date();
			var hour:Number = mydate.getHours();
			var minute:Number = mydate.getMinutes();
			var second:Number = mydate.getSeconds();
			var curTime:String=String(hour)+":"+String(minute)+":"+String(second);
			mcDeadRevive.txtDeadTime.htmlText=StringUtil.substitute(StringConst.DEADREVIVE_PANEL_003,curTime);
			
			var mapId:int = SceneMapManager.getInstance().mapId;
			var mapCfgData:MapCfgData = ConfigDataManager.instance.mapCfgData(mapId);
			_mapName=mapCfgData.name;
		}
		//30秒后回城复活
		private function setBackReviveTimer():void
		{
			var mcDeadRevive:McDeadRevive;
			mcDeadRevive = _skin as McDeadRevive;
			mcDeadRevive.txtBackHomeRevive.text=StringUtil.substitute(StringConst.DEADREVIVE_PANEL_002,_delay);
			
			_intervalId=setInterval(countTimer,_duration);
		}
		
		private function countTimer():void
		{
			_delay--;
			var mcDeadRevive:McDeadRevive;
			mcDeadRevive = _skin as McDeadRevive;
			mcDeadRevive.txtBackHomeRevive.text=StringUtil.substitute(StringConst.DEADREVIVE_PANEL_002,_delay);
			
			//30秒倒计时结束，回城复活
			if(_delay==0)
			{
				clearInterval(_intervalId);
				sendReviveData(1);
				removeMaskAndSelf();
			}
		}
		/**获取复活玫瑰数量*/
		private function getRoseNum():void
		{
			if(!_skin)
			{
				return;
			}
			var mcDeadRevive:McDeadRevive;
			mcDeadRevive = _skin as McDeadRevive;
			_totalRoseNum=BagDataManager.instance.getItemNumByType(ItemType.REVIVE_ROSE_TYPE);
			mcDeadRevive.txtNeedRose.htmlText=StringUtil.substitute(StringConst.DEADREVIVE_PANEL_006,_totalRoseNum,1);
			if(_totalRoseNum>0)
			{
				setRosebtnStatus(false);
			}
			else
			{
				setRosebtnStatus(true);
			}
		}
		
		private function setRosebtnStatus(isPurchase:Boolean):void
		{
			var mcDeadRevive:McDeadRevive;
			mcDeadRevive = _skin as McDeadRevive;
			
			if(isPurchase)
			{
				mcDeadRevive.purchaseRose.x=mcDeadRevive.revive.x;
			}
			else
			{
				mcDeadRevive.purchaseRose.x=504;
			}
			mcDeadRevive.purchaseRose.visible=isPurchase;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var mcDeadRevive:McDeadRevive;
			mcDeadRevive = _skin as McDeadRevive;
			rsrLoader.addCallBack(mcDeadRevive.btnBackHomeRevive,function (mc:MovieClip):void
			{
			});
			rsrLoader.addCallBack(mcDeadRevive.purchaseRose,function (mc:MovieClip):void
			{
				getRoseNum();
			});
		}
		/**请求复活数据*/
		public function sendReviveData(type:int):void
		{
			var manager:ActivityDataManager = ActivityDataManager.instance;
			var isEqual:Boolean = manager.isAcitivtyTypeEqualValue(ActivityFuncTypes.AFT_LOONG_WAR);
			if(isEqual)
			{
				var isInActv:Boolean = manager.currentActvCfgDtAtMap ? manager.currentActvCfgDtAtMap.isInActv : false;
				if(isInActv)
				{
					manager.loongWarDataManager.cmLongchengRevive();
					return;
				}
			}
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(type);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_REVIVE,byteArray);
		}
		
		public function removeMaskAndSelf():void
		{
			clearInterval(_intervalId);
			MainUiMediator.getInstance().removeMask();
			PanelMediator.instance.closePanel(PanelConst.TYPE_DEAD_REVIVE);
		}
		
		private function onAdded2Stage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAdded2Stage);
		}
		
		override public function update(proc:int = 0):void
		{
			if(proc == GameServiceConstants.SM_CHR_INFO)
			{
				var attrHp:int = RoleDataManager.instance.attrHp;
				if(attrHp > 0)
				{
					removeMaskAndSelf();
				}
			}
			refreshRoseData();
			refreshHurtName();
		}
		
		private function refreshHurtName():void
		{
			var isMonster:Boolean=DeadReviveDataManager.instance.isMonster;
			var hurtName:String=DeadReviveDataManager.instance.hurtName;
			var mcDeadRevive:McDeadRevive;
			mcDeadRevive = _skin as McDeadRevive;
			var msg:String;
			if(isMonster)
			{
				msg=StringConst.DEADREVIVE_PANEL_004;
			}
			else
			{
				msg=StringConst.DEADREVIVE_PANEL_005;
			}
			mcDeadRevive.txtDeadCauses.htmlText=StringUtil.substitute(msg,_mapName,hurtName);
		}
		
		private function stringFormat(num:int):String
		{
			var s:String=String(num);
			var ret:String='';
			var symbol:String ="";
			if(s.charAt(0)=="+"||s.charAt(0)=="-")
			{
				symbol = s.charAt(0);
				s =s.substr(1);
			}
			for(var i:int=s.length-3;i>0;i-=3)
			{
				ret=','+s.substr(i,3)+ret;
			}
			ret=symbol+s.substr(0,i+3)+ret;
			return ret;
		}
		
		private function refreshRoseData():void
		{
			getRoseNum();
		}
		
		override public function destroy():void
		{
			RoleDataManager.instance.detach(this);
			DeadReviveDataManager.instance.detach(this);
			BagDataManager.instance.detach(this);
			
			_deadRevivePanelOnClick.removeEvent(this);
			this._deadRevivePanelOnClick=null;
			removeEventListener(Event.ADDED_TO_STAGE,onAdded2Stage);
			super.destroy();
		}
	}
}