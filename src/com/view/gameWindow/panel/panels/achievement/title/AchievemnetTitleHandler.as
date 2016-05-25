package com.view.gameWindow.panel.panels.achievement.title
{
	import com.view.gameWindow.panel.panels.achievement.AchievementPanel;
	import com.view.gameWindow.panel.panels.achievement.MCAchievementPanel;
	import com.view.gameWindow.util.scrollBar.ScrollBar;
	import com.view.gameWindow.util.scrollBar.ScrollBarType;

	public class AchievemnetTitleHandler
	{
		private var _achi:AchievementPanel;
		private var _skin:MCAchievementPanel;
		private var _scrollBar:ScrollBar;
		private var _titlePanel:AchievementTitlePanel;
		
		public function AchievemnetTitleHandler(achi:AchievementPanel)
		{
			this._achi=achi;
			_skin=achi.mcAcPanel;
			_titlePanel=new AchievementTitlePanel();
			_skin.addChild(_titlePanel);
			_titlePanel.x=41.35;
			_titlePanel.y=105;
			initView();
		}
		
		public function initScroll():void
		{
			_titlePanel.setScrollRectWH(158,390);
			_scrollBar=new ScrollBar(_titlePanel,_skin.mcScrollBar);
			_scrollBar.resetHeight(390);
		}
		
		private function initView():void
		{
			_titlePanel.initView();
		}
		
		public function setSelect(titleItem:AchievementTitleItem):void
		{
			if(titleItem.select)return;
			_titlePanel.setItemSelect(titleItem);
		}
		
		public function destroy():void
		{
			_scrollBar&&_scrollBar.destroy();
			_scrollBar=null;
			_titlePanel&&_titlePanel.destroy();
			_titlePanel=null;
		}
		
		public function refreshTitle():void
		{
			_titlePanel.updateView();
		}
	}
}