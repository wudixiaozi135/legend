package com.view.gameWindow.panel.panels.achievement.content
{
	import com.model.configData.cfgdata.AchievementCfgData;
	import com.view.gameWindow.panel.panels.achievement.AchievementDataManager;
	import com.view.gameWindow.panel.panels.achievement.AchievementPanel;
	import com.view.gameWindow.panel.panels.achievement.MCAchievementPanel;
	import com.view.gameWindow.util.scrollBar.ScrollBar;
	import com.view.gameWindow.util.scrollBar.ScrollBarType;
	import flash.utils.Dictionary;

	public class AchievementContentHandler
	{
		private var _scrollBar:ScrollBar;
		private var _skin:MCAchievementPanel;
		private var _contentPanel:AchievementContentPanel;
		private var _achi:AchievementPanel;
		public function AchievementContentHandler(achi:AchievementPanel)
		{
			_achi=achi;
			_skin=achi.mcAcPanel;
			_contentPanel=new AchievementContentPanel();
			_skin.addChild(_contentPanel);
			_contentPanel.x=217.85;
			_contentPanel.y=103.3;
		}
		
		public function initScroll():void
		{
			_contentPanel.setScrollRectWH(431,390);
			_scrollBar=new ScrollBar(_contentPanel,_skin.mcScrollBarC);
			_scrollBar.resetHeight(390);
		}
		
		public function initView():void
		{
			var cfgArr:Vector.<AchievementCfgData>= AchievementDataManager.getInstance().getContentCfgByType();
			if(_achi.isFilter)
			{
				cfgArr=cfgArr.filter(filterFunc);
			}
			_contentPanel.initView(cfgArr);
			_scrollBar.resetScroll();
			_scrollBar.scrollTo(0);
			var contentDatas:Dictionary = AchievementDataManager.getInstance().contentDatas
			for(var i:int=0;i<cfgArr.length;i++)
			{
				var contentData:ContentData=contentDatas[cfgArr[i].achievement_id];
				if(contentData!=null&&contentData.isCompled==false||contentData.state==0)
				{
					_scrollBar.scroll(i*98);
					break;
				}
			}
		}
		
		private function filterFunc(cfg:AchievementCfgData,index:int,array:Vector.<AchievementCfgData>):Boolean
		{
			var contentData:ContentData=AchievementDataManager.getInstance().contentDatas[cfg.achievement_id];
			if(contentData==null)return true;
			if(contentData.state>0)return false;
			return true;
		}
		
		public function refreshView():void
		{
			_contentPanel.updateView();
		}
		
		public function destroy():void
		{
			_contentPanel&&_contentPanel.destroy();
			_contentPanel=null;
			_scrollBar&&_scrollBar.destroy();
			_scrollBar=null;
		}
	}
}