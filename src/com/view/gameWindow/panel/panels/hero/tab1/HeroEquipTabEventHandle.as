package com.view.gameWindow.panel.panels.hero.tab1
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.consts.ConstStorage;
	import com.model.consts.GameConst;
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.herohead.McHeroEquipPanel;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.IBagPanel;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.hero.tab1.equip.HeroEquipCellHandle;
	import com.view.gameWindow.panel.panels.hero.tab1.equip.HeroFashionCellHandle;
	import com.view.gameWindow.panel.panels.keyBuy.KeyBuyPanel;
	import com.view.gameWindow.panel.panels.skill.SkillDataManager;
	import com.view.gameWindow.panel.panels.skill.constants.SkillConstants;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.Timer;

	public class HeroEquipTabEventHandle
	{
		public var heroFashionCellHandle:HeroFashionCellHandle;
		public var heroEquipCellHandle:HeroEquipCellHandle;
		private var _mc:McHeroEquipPanel;

		private var _timer:Timer;
		public var _heroEquipTab:HeroEquipTab;
		
		public function HeroEquipTabEventHandle(mc:McHeroEquipPanel)
		{
			_mc = mc;
			init();
		}
		
		private function init():void
		{
			_mc.txtBtnBatch.text = StringConst.HERO_PANEL_003;
			_mc.txtBtnBatch.mouseEnabled = false;
			_mc.txtBtnSort.text = StringConst.HERO_PANEL_004;
			_mc.txtBtnSort.mouseEnabled = false;
			_mc.txtBtnPurchase.text=StringConst.HERO_PANEL_59;
			_mc.txtBtnPurchase.mouseEnabled=false;
			
			_mc.addEventListener(MouseEvent.CLICK,clickHandle);
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			switch(evt.target)
			{
				case _mc.btnClose:
					HeroDataManager.instance.isExchange = false;
					PanelMediator.instance.switchPanel(PanelConst.TYPE_HERO);
					break;
				case _mc.btnChange:
					heroFashionCellHandle.visible = _mc.btnChange.selected;
					heroEquipCellHandle.visible = !_mc.btnChange.selected;
					_mc.mcCellBg.visible = !_mc.btnChange.selected;
					/*if(_mc.btnChange.selected)
					{
						PanelMediator.instance.switchPanel(PanelConst.TYPE_COLSET);
					}
					else
					{
						PanelMediator.instance.closePanel(PanelConst.TYPE_COLSET);
					}*/
					break;
				case _mc.btnBatch://批量
					batch();
					break;
				case _mc.btnSort://整理
					arrange();
					break;
				case _mc.btnPurchase:
					KeyBuyPanel.HOR=GameConst.HERO;
					KeyBuyPanel.TYPE = 0;
					PanelMediator.instance.switchPanel(PanelConst.TYPE_BAG_KEYBUY);
					break;
				case _heroEquipTab.heroPropertyMcBtn:
//					_heroEquipTab.addHeroPropertyPanel();
					SkillDataManager.instance.entity_type = SkillConstants.TYPE_HERO;
					PanelMediator.instance.switchPanel(PanelConst.TYPE_SKILL);
					break;
				
//				case _heroPanel.skillMcBtn:
//					SkillDataManager.instance.entity_type = SkillConstants.TYPE_HERO;
//					PanelMediator.instance.switchPanel(PanelConst.TYPE_SKILL);
//					break;
			}
		}
		
		/**批量处理*/
		private function batch():void
		{
			var bagPanel:IBagPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_BAG) as IBagPanel;
			var isExchange:Boolean = HeroDataManager.instance.isExchange;
			if(bagPanel && bagPanel.isShow)
			{
				if(isExchange)
				{
					HeroDataManager.instance.isExchange = false;
					PanelMediator.instance.closePanel(PanelConst.TYPE_BAG);
				}
				else
				{
					HeroDataManager.instance.isExchange = true;
				}
			}
			else
			{
				if(!isExchange)
				{
					PanelMediator.instance.openPanel(PanelConst.TYPE_BAG);
					HeroDataManager.instance.isExchange = true;
				}
			}
		}
		
		/*private function batchDeal():void
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
		}*/
		/**整理包裹*/
		private function arrange():void
		{
			if(!_timer)
			{
				var byteArray:ByteArray = new ByteArray();
				byteArray.endian = Endian.LITTLE_ENDIAN;
				byteArray.writeByte(ConstStorage.ST_HERO_BAG);
				ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SORT_BAG,byteArray);
				//启动冷却
				_timer = new Timer(1000,10);
				_mc.btnSort.btnEnabled = false;
				_mc.txtBtnSort.text = _timer.repeatCount+"";
				_timer.addEventListener(TimerEvent.TIMER,onTimer);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComolete);
				_timer.start();
			}
		}
		
		protected function onTimer(event:TimerEvent):void
		{
			_mc.txtBtnSort.text = (_timer.repeatCount - _timer.currentCount)+"";
		}
		
		protected function onTimerComolete(event:TimerEvent):void
		{
			_mc.btnSort.btnEnabled = true;
			_mc.txtBtnSort.text = StringConst.HERO_PANEL_004;
			destroyTimer();
		}
		
		private function destroyTimer():void
		{
			if(_timer)
			{
				var sortCDTime:int = HeroDataManager.instance.sortCDTime;
				if(sortCDTime <= 0)
				{
					HeroDataManager.instance.sortCDTime = _timer.repeatCount - _timer.currentCount;
				}
				_timer.removeEventListener(TimerEvent.TIMER,onTimer);
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimerComolete);
				_timer.stop();
				_timer = null;
			}
		}
		
		public function initBtnSort():void
		{
			var sortCDTime:int = HeroDataManager.instance.sortCDTime;
			if(sortCDTime > 0)//若整理CD还有冷却时间则添加定时器
			{
				_timer = new Timer(1000,sortCDTime);
				_mc.btnSort.btnEnabled = false;
				_mc.txtBtnSort.text = _timer.repeatCount+"";
				_timer.addEventListener(TimerEvent.TIMER,onTimer);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComolete);
				_timer.start();
			}
		}
		
		public function destroy():void
		{
			destroyTimer();
			_mc.removeEventListener(MouseEvent.CLICK,clickHandle);
			_mc = null;
		}
	}
}