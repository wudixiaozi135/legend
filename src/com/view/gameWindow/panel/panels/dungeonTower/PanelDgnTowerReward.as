package com.view.gameWindow.panel.panels.dungeonTower
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.cfgdata.DgnRewardMultipleCfgData;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * 塔防副本奖励面板类
	 * @author Administrator
	 */	
	public class PanelDgnTowerReward extends PanelBase
	{
		internal var view:PanelDgnTowerRewardView;
		
		public function PanelDgnTowerReward()
		{
			super();
			canEscExit = false;
			VipDataManager.instance.attach(this);
		}
		
		override protected function initSkin():void
		{
			var skin:McDgnTowerReward = new McDgnTowerReward();
			_skin = skin;
			addChild(_skin);
			setTitleBar(skin.mcDrag);
		}
		
		override protected function initData():void
		{
			view = new PanelDgnTowerRewardView(this);
			//
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			_skin.addEventListener(MouseEvent.ROLL_OVER,onOver,true);
			_skin.addEventListener(MouseEvent.ROLL_OUT,onOut,true);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(skin.btn3,function(mc:MovieClip):void
			{
				InterObjCollector.instance.add(mc);
				InterObjCollector.autoCollector.add(mc);
			});
			super.addCallBack(rsrLoader);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var skin:McDgnTowerReward = _skin as McDgnTowerReward;
			switch(event.target)
			{
				default:
					break;
				case skin.btn0:
					dealBtnClick(0);
					break;
				case skin.btn1:
					dealBtnClick(1);
					break;
				case skin.btn2:
					dealBtnClick(2);
					break;
				case skin.btn3:
					dealBtnClick(3);
					break;
				case skin.btnClose:
					dealBtnClose();
					break;
			}
		}
		
		private function dealBtnClose():void
		{
			var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
			if(manager.isInMainDgnTower)
			{
				var cfgDt:DgnRewardMultipleCfgData = manager.dgnRewardMultipleCfgDt(3);
				var str:String = HtmlUtils.createHtmlStr(0x53b436,StringConst.DGN_TOWER_0046.replace("&x",cfgDt.gold),12,false,3);
				Alert.show2(str,deal);
				function deal():void
				{
					manager.cmGetTowerDungeonExp(cfgDt.multiple);
					PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_TOWER_REWARD);
				}
			}
			else
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_TOWER_REWARD);
			}
		}
		
		private function dealBtnClick(index:int):void
		{
			var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
			var cfgDt:DgnRewardMultipleCfgData = manager.dgnRewardMultipleCfgDt(index);
			if(manager.isInMainDgnTower)
			{
				if(index != 3)
				{
					Alert.warning(StringConst.DGN_TOWER_0045);
				}
				else
				{
					var str:String = HtmlUtils.createHtmlStr(0x53b436,StringConst.DGN_TOWER_0046.replace("&x",cfgDt.gold),12,false,3);
					Alert.show2(str,deal);
				}
			}
			else
			{
				var lv:int = VipDataManager.instance.lv;
				if(lv < cfgDt.vip)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DGN_TOWER_0023);
					return;
				}
				var goldUnBind:int = BagDataManager.instance.goldUnBind;
				if(goldUnBind < cfgDt.gold)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DGN_TOWER_0024);
					return;
				}
				deal();
			}
			function deal():void
			{
				manager.cmGetTowerDungeonExp(cfgDt.multiple);
				if(manager.isInDgnTower || manager.isInMainDgnTower)
				{
					manager.cmLeaveDungeon();
				}
				PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_TOWER_REWARD);
			}
		}
		
		protected function onOver(event:MouseEvent):void
		{
			var skin:McDgnTowerReward = _skin as McDgnTowerReward;
			if(!skin)
			{
				return;
			}
			switch(event.target)
			{
				default:
					break;
				case skin.btn0:
					dealBtnOver(0);
					break;
				case skin.btn1:
					dealBtnOver(1);
					break;
				case skin.btn2:
					dealBtnOver(2);
					break;
				case skin.btn3:
					dealBtnOver(3);
					break;
			}
		}
		
		private function dealBtnOver(index:int):void
		{
			DgnTowerDataManger.instance.index = index;
			view.assignTxtExpUngetValue();
			/*view.switchGlow(true);*/
		}
		
		protected function onOut(event:MouseEvent):void
		{
			var skin:McDgnTowerReward = _skin as McDgnTowerReward;
			if(!skin)
			{
				return;
			}
			switch(event.target)
			{
				default:
					break;
				case skin.btn0:
				case skin.btn1:
				case skin.btn2:
				case skin.btn3:
					dealBtnOut();
					break;
			}
		}
		
		private function dealBtnOut():void
		{
			DgnTowerDataManger.instance.index = 0;
			view.assignTxtExpUngetValue();
			/*view.switchGlow(false);*/
		}
		
		override public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_VIP_INFO)
			{
				if(view)
				{
					view.updateTxtVipCost();
				}
			}
		}
		
		override public function destroy():void
		{
			VipDataManager.instance.detach(this);
			InterObjCollector.instance.remove(_skin.btn3);
			InterObjCollector.autoCollector.remove(_skin.btn3);
			_skin.removeEventListener(MouseEvent.CLICK,onClick);
			_skin.removeEventListener(MouseEvent.ROLL_OVER,onOver);
			_skin.removeEventListener(MouseEvent.ROLL_OUT,onOut);
			view.destroy();
			super.destroy();
		}
	}
}