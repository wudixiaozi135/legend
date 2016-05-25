package com.view.gameWindow.panel.panels.rank.coin
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.rank.RankDataManager;
	import com.view.gameWindow.panel.panels.rank.coin.item.CoinListItem;
	import com.view.gameWindow.panel.panels.rank.gold.McGoldlPanel;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.PageUtil;

	public class CoinListHandler
	{
		private var _panel:CoinListPanel;
		private var _skin:McGoldlPanel;
		private var list:Vector.<CoinListItem>;
		
		public function CoinListHandler(panel:CoinListPanel)
		{
			this._panel = panel;
			_skin=panel.skin as McGoldlPanel;
			initListItem();
		}
		
		public function destroy():void
		{
			while(list.length>0)
			{
				var item:CoinListItem=list.shift();
				item.destroy();
				item.parent&&item.parent.removeChild(item);
				item=null;
			}
		}
		
		private function initListItem():void
		{
			list=new Vector.<CoinListItem>();
			for(var i:int=0;i<RankDataManager.PAGE_DATA_COUNT;i++)
			{
				var item:CoinListItem=new CoinListItem();
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
				var item:CoinListItem=list[i];
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