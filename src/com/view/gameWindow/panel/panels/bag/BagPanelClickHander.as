package com.view.gameWindow.panel.panels.bag
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.consts.ConstStorage;
	import com.model.consts.GameConst;
	import com.model.consts.StringConst;
	import com.model.dataManager.TeleportDatamanager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.hero.IHeroPanel;
	import com.view.gameWindow.panel.panels.keyBuy.KeyBuyPanel;
	import com.view.gameWindow.panel.panels.keySell.KeySellDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.stall.StallDataManager;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.scene.GameFlyManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.newMir.NewMirMediator;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.Timer;

	public class BagPanelClickHander
	{
		public var mcBag:McBag;
		private var _skin:PanelBase;
		private var _timer:Timer;
		
		public function BagPanelClickHander()
		{
		}
		
		public function addEvent(eventDispatcher:EventDispatcher):void
		{
			eventDispatcher.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			/*trace(event.target);*/
			switch (event.target)
			{
				case mcBag.btnArrange:
				case mcBag.btnSell:
				case mcBag.btnBtach:
//				case mcBag.btnRecovery:
					if (RoleDataManager.instance.stallStatue)
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
						return;
					}
				default :
					break;
			}
			switch(event.target)
			{
				case mcBag.btnClose:
					HeroDataManager.instance.isExchange = false;
					PanelMediator.instance.closePanel(PanelConst.TYPE_KEY_SELL);
					PanelMediator.instance.closePanel(PanelConst.TYPE_BAG);
					break;
				case mcBag.btnRole:
					setSelected(mcBag.btnRole,StringConst.BAG_PANEL_0003,mcBag.btnHero,StringConst.BAG_PANEL_0004);
					break;
				case mcBag.btnHero:
					setSelected(mcBag.btnHero,StringConst.BAG_PANEL_0004,mcBag.btnRole,StringConst.BAG_PANEL_0003);
					break;
				case mcBag.btnLock:
					break;
				case mcBag.btnStall:
					dealStall();
					break;
				case mcBag.btnBtach:
					dealBatch();
					break;
				case mcBag.btnBuy:
					KeyBuyPanel.HOR=GameConst.ROLE;
					KeyBuyPanel.TYPE = 0;
					PanelMediator.instance.switchPanel(PanelConst.TYPE_BAG_KEYBUY);
					break;
				case mcBag.btnSell:
					dealSell();
					break;
				case mcBag.btnArrange:
					arrange();
					break;
				case mcBag.btnRecovery:
					//RecycleEquipDataManager.instance.requestData();
					//PanelMediator.instance.switchPanel(PanelConst.TYPE_RECYCLE_EQUIP);
					//PanelMediator.instance.switchPanel(PanelConst.TYPE_EQUIP_RECYCLE);
					//RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0007);
					dealVip();
					break;
				case mcBag.txtGetGold:
					break;
			}
		}

		private function dealStall():void
		{
			StallDataManager.instance.dealStallPanel();
		}
		
		public function dealVip(showWarnPanel:Boolean = true):void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			
			var lv:int = VipDataManager.instance.lv;
			if(lv == 0)
			{
				if(showWarnPanel)
				{
					PanelMediator.instance.openPanel(PanelConst.TYPE_EQUIP_RECYCLE_WARN);
				}
				else
				{
					if(RoleDataManager.instance.isCanFly > 0)
					{
						TeleportDatamanager.instance.setTargetEntity(10409,EntityTypes.ET_NPC);
						GameFlyManager.getInstance().flyToMapByNPC(10409);
					}
					else
					{
						AutoJobManager.getInstance().setAutoTargetData(10409,EntityTypes.ET_NPC);
					}
				}
				return;
			}
			var flag:int = ConfigDataManager.instance.vipCfgData(lv).recycle_btn;
 
			flag == 0 ?PanelMediator.instance.openPanel(PanelConst.TYPE_EQUIP_RECYCLE_WARN):PanelMediator.instance.switchPanel(PanelConst.TYPE_EQUIP_RECYCLE);
		}
		
		private function setSelected(lastMc:MovieClip,text1:String,nowMc:MovieClip,text2:String):void
		{
			var textField:TextField;
			
			lastMc.selected = true;
			lastMc.mouseEnabled = false;
			textField = lastMc.txt as TextField;
			textField.text = text1;
			textField.textColor = 0xffe1aa;
			
			nowMc.selected = false;
			nowMc.mouseEnabled = true;
			textField = nowMc.txt as TextField;
			textField.text = text2;
			textField.textColor = 0x675138;
		}
		/**批量处理*/
		private function dealBatch():void
		{
			var manager:HeroDataManager = HeroDataManager.instance;
			if(!manager.isHeroExist)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.BAG_PANEL_0035);
				return;
			}
			var heroPanel:IHeroPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_HERO) as IHeroPanel;
			var isExchange:Boolean = manager.isExchange;
			if(heroPanel)
			{
				if(isExchange)
				{
					HeroDataManager.instance.isExchange = false;
					PanelMediator.instance.closePanel(PanelConst.TYPE_HERO);
					var bagPanel:BagPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_BAG) as BagPanel;
					bagPanel.setPostion();
				}
				else
				{
					batchDeal();
				}
			}
			else
			{
				if(!isExchange)
				{
					PanelMediator.instance.openPanel(PanelConst.TYPE_HERO);
					batchDeal();
				}
			}
		}
		
		private function batchDeal():void
		{
			var bagPanel:IBagPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_BAG) as IBagPanel;
			var heroPanel:IHeroPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_HERO) as IHeroPanel;
			HeroDataManager.instance.isExchange = true;
			var heroRect:Rectangle = heroPanel.getPanelRect();
			var bagRect:Rectangle = bagPanel.getPanelRect();
			var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
			var x:int = int((newMirMediator.width - heroRect.width - bagRect.width)*.5);
			var y:int = int((newMirMediator.height - heroRect.height)*.5);
			heroPanel.postion = new Point(x,y);
			bagPanel.postion = new Point(x+heroRect.width,y+(heroRect.height-bagRect.height)*.5);
		}
		/**快捷出售*/
		private function dealSell():void
		{
			var manager:KeySellDataManager = KeySellDataManager.instance;
			manager.dealBagItems();
			if(!manager.datas || !manager.datas.length)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.BAG_PANEL_0030);
				return;
			}
			PanelMediator.instance.switchPanel(PanelConst.TYPE_KEY_SELL);
		}
		/**整理包裹*/
		private function arrange():void
		{
			var remainCellNum:int = BagDataManager.instance.remainCellNum;
			if(!remainCellNum)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0024);
			}
			else if(remainCellNum < 5)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0025);
			}
			if(!_timer)
			{
				var byteArray:ByteArray = new ByteArray();
				byteArray.endian = Endian.LITTLE_ENDIAN;
				byteArray.writeByte(ConstStorage.ST_CHR_BAG);
				ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SORT_BAG,byteArray);
				//启动冷却
				_timer = new Timer(1000,10);
				mcBag.btnArrange.btnEnabled = false;
				mcBag.btnArrange.txt.text = _timer.repeatCount+"";
				_timer.addEventListener(TimerEvent.TIMER,onTimer);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComolete);
				_timer.start();
			}
		}
		
		protected function onTimer(event:TimerEvent):void
		{
			mcBag.btnArrange.txt.text = (_timer.repeatCount - _timer.currentCount)+"";
		}
		
		protected function onTimerComolete(event:TimerEvent):void
		{
			mcBag.btnArrange.btnEnabled = true;
			mcBag.btnArrange.txt.text = StringConst.BAG_PANEL_0007;
			mcBag.btnArrange.txt.textColor = 0xd4a460;
			destroyTimer();
		}
		
		public function initBtnSort():void
		{
			var sortCDTime:int = BagDataManager.instance.sortCDTime;
			if(sortCDTime > 0)//若整理CD还有冷却时间则添加定时器
			{
				_timer = new Timer(1000,sortCDTime);
				mcBag.btnArrange.btnEnabled = false;
				mcBag.btnArrange.txt.text = _timer.repeatCount+"";
				mcBag.btnArrange.txt.textColor = 0xd4a460;
				_timer.addEventListener(TimerEvent.TIMER,onTimer);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComolete);
				_timer.start();
			}
		}
		
		private function destroyTimer():void
		{
			if(_timer)
			{
				var sortCDTime:int = BagDataManager.instance.sortCDTime;
				if(sortCDTime <= 0)
				{
					BagDataManager.instance.sortCDTime = _timer.repeatCount - _timer.currentCount;
				}
				_timer.removeEventListener(TimerEvent.TIMER,onTimer);
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimerComolete);
				_timer.stop();
				_timer = null;
			}
		}
		
		public function removeEvent(eventDispatcher:EventDispatcher):void
		{
			destroyTimer();
			eventDispatcher.removeEventListener(MouseEvent.CLICK,onClick);
			mcBag = null;
		}
	}
}