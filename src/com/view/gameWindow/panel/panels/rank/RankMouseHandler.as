package com.view.gameWindow.panel.panels.rank
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.rank.coin.CoinListPanel;
	import com.view.gameWindow.panel.panels.rank.hero.HeroListPanel;
	import com.view.gameWindow.panel.panels.rank.level.LevelListPanel;
	import com.view.gameWindow.panel.panels.rank.position.PositionListPanel;
	import com.view.gameWindow.panel.panels.rank.power.PowerListPanel;
	import com.view.gameWindow.util.ObjectUtils;
	import com.view.gameWindow.util.tabsSwitch.TabsSwitch;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	

	public class RankMouseHandler
	{
		private var rank:PanelRank;
		private var _skin:mcRankPanel;
		internal var lastBtn:MovieClip;
		private var _tabsSwitch:TabsSwitch;
		private var _tabLayer:Sprite;
		
		public function RankMouseHandler(rank:PanelRank)
		{
			this.rank = rank;
			_skin = rank.skin as mcRankPanel;
			init();
		}
		
		private function init():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			_tabLayer=new Sprite();
			_skin.addChild(_tabLayer);
			_tabLayer.x=190;
			_tabLayer.y=67;
			var selectTab:int = RankDataManager.selectIndex
			_tabsSwitch = new TabsSwitch(_tabLayer,Vector.<Class>([LevelListPanel,PowerListPanel,PowerListPanel,PowerListPanel,HeroListPanel,PositionListPanel,CoinListPanel]),selectTab);
		}
		
		private function onClick(evt:MouseEvent):void
		{
			switch(evt.target)
			{
				case _skin.btnClose:
					dealClose();
					break;
				case _skin.tab0:
					dealTab(_skin.tab0, 0);
					break;
				case _skin.tab1:
					dealTab(_skin.tab1, 1);
					break;
				case _skin.tab2:
					dealTab(_skin.tab2,2);
					break;
				case _skin.tab3:
					dealTab(_skin.tab3,3);
					break;
				case _skin.tab4:
					dealTab(_skin.tab4,4);
					break;
				case _skin.tab5:
					dealTab(_skin.tab5,5);
					break;
				case _skin.tab6:
					dealTab(_skin.tab6, 6);
					break;
				default:
					break;
			}
		}
		
		private function dealTab(tab:MovieClip, type:int):void
		{
			var lastMc:MovieClip = RankDataManager.lastMc;
			if (lastMc)
			{
				lastMc.selected = false;
				lastMc.mouseEnabled = true;
			}
			
			tab.selected = true;
			tab.mouseEnabled = false;
			
			RankDataManager.lastMc = tab;
			RankDataManager.selectIndex = type;
			updateMcTxt(_skin["pic" + type]);
			_tabsSwitch.onClick(type);
		}
		
		private function updateMcTxt(mc:MovieClip):void
		{
			for (var i:int = 0; i < 8; i++)
			{
				if (_skin["pic" + i])
				{
					_skin["pic" + i].filters = null;
				}
			}
			mc.filters = [ObjectUtils.btnlightFilter];
		}
		
		private function dealClose():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_RANK);
		}
		
		public function destroy():void
		{
			if(_tabLayer)
			{
				_tabLayer.parent&&_tabLayer.parent.removeChild(_tabLayer);
			}
			_tabLayer=null;
			if(_tabsSwitch)
			{
				_tabsSwitch.destroy();
				_tabsSwitch = null;
			}
			if(_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK,onClick);
				_skin = null;
			}
		}
	}
}