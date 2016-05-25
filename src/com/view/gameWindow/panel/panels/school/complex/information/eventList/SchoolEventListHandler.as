package com.view.gameWindow.panel.panels.school.complex.information.eventList
{
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.panel.panels.school.complex.information.eventList.item.SchoolEventListItem;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	import com.view.gameWindow.util.PageListData;

	public class SchoolEventListHandler
	{
		private var _panel:SchoolEventListPanel;
		private var _skin:McEventPanel;
		private var list:Vector.<SchoolEventListItem>;
		
		public function SchoolEventListHandler(panel:SchoolEventListPanel)
		{
			this._panel = panel;
			_skin=panel.skin as McEventPanel;
			initListItem();
		}
		
		public function destroy():void
		{
			while(list.length>0)
			{
				var item:SchoolEventListItem=list.shift();
				item.destroy();
				item.parent&&item.parent.removeChild(item);
				item=null;
			}
		}
		
		private function initListItem():void
		{
			list=new Vector.<SchoolEventListItem>();
			for(var i:int=0;i<SchoolDataManager.PAGE_DATA_COUNT;i++)
			{
				var item:SchoolEventListItem=new SchoolEventListItem();
				_skin.addChild(item);
				item.y=83.35+i*24;
				item.x=38;
				list.push(item);
			}
		}
		
		public function updateList():void
		{
			var schoolEventListPage:PageListData = SchoolElseDataManager.getInstance().schoolEventListPage;
			var arr:Array=schoolEventListPage.getCurrentPageData();
			_skin.txtPage.text=schoolEventListPage.curPage+"/"+schoolEventListPage.totalPage;
			if(arr.length==0)
			{
				_skin.mcMouseBuf.visible=false;
				_skin.mcSelectBuf.visible=false;
			}
			for(var i:int=0;i<SchoolElseDataManager.PAGE_DATA_COUNT;i++)
			{
				var item:SchoolEventListItem=list[i];
				if(i>=arr.length)
				{
					item.visible=false;
					continue;
				}
				item.update(arr[i]);
				item.visible=true;
			}
		}
	}
}