package com.view.gameWindow.panel.panels.rank.position
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.rank.RankDataManager;
	import com.view.gameWindow.panel.panels.rank.position.item.PositionListItem;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.PageUtil;

	public class PositionListHandler
	{
		private var _panel:PositionListPanel;
		private var _skin:McPositionlPanel;
		private var list:Vector.<PositionListItem>;
		
		public function PositionListHandler(panel:PositionListPanel)
		{
			this._panel = panel;
			_skin=panel.skin as McPositionlPanel;
			initListItem();
		}
		
		public function destroy():void
		{
			while(list.length>0)
			{
				var item:PositionListItem=list.shift();
				item.destroy();
				item.parent&&item.parent.removeChild(item);
				item=null;
			}
		}
		
		private function initListItem():void
		{
			list=new Vector.<PositionListItem>();
			for(var i:int=0;i<RankDataManager.PAGE_DATA_COUNT;i++)
			{
				var item:PositionListItem=new PositionListItem();
				_skin.addChild(item);
				item.y=34.35+i*31.95;
				list.push(item);
			}
		}
		
		public function updateList():void
		{
			var rankList:Array = RankDataManager.getInstance().rankList;
			var myRank:int = RankDataManager.getInstance().myRank;
			if(myRank>100)
			{
				_skin.txt8.htmlText=HtmlUtils.createHtmlStr(0xd4a460,StringConst.RANK_PANEL_0007)+HtmlUtils.createHtmlStr(0xffe1aa,StringConst.RANK_PANEL_0008);
			}else
			{
				_skin.txt8.htmlText=HtmlUtils.createHtmlStr(0xd4a460,StringConst.RANK_PANEL_0007)+HtmlUtils.createHtmlStr(0xffe1aa,myRank+"");
			}
			
			var page:PageUtil = _panel.page;
			page.setTotalCount(RankDataManager.getInstance().rankTotal);
			_skin.txtPage.text=page.currentPageIndex+"/"+page.getPageCount();
			if(rankList.length==0)
			{
				_skin.mcMouseBuf.visible=false;
				_skin.mcSelectBuf.visible=false;
			}
			for(var i:int=0;i<RankDataManager.PAGE_DATA_COUNT;i++)
			{
				var item:PositionListItem=list[i];
				if(i>=rankList.length)
				{
					item.visible=false;
					continue;
				}
				item.update(rankList[i]);
				item.visible=true;
			}
		}
	}
}