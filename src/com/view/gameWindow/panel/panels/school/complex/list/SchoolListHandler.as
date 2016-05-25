package com.view.gameWindow.panel.panels.school.complex.list
{
	import com.view.gameWindow.panel.panels.school.complex.list.item.SchoolListItem;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	import com.view.gameWindow.util.PageListData;
	import com.view.gameWindow.util.TimeUtils;
	import com.view.gameWindow.util.TimerManager;

	public class SchoolListHandler
	{
		private var _panel:SchoolListPanel;
		private var _skin:McListPanel;
		private var list:Vector.<SchoolListItem>;
		
		public function SchoolListHandler(panel:SchoolListPanel)
		{
			this._panel = panel;
			_skin=panel.skin as McListPanel;
			initListItem();
		}
		
		public function destroy():void
		{
			TimerManager.getInstance().remove(updateList);
			while(list.length>0)
			{
				var item:SchoolListItem=list.shift();
				item.destroy();
				item.parent&&item.parent.removeChild(item);
				item=null;
			}
		}
		
		private function initListItem():void
		{
			list=new Vector.<SchoolListItem>();
			for(var i:int=0;i<SchoolDataManager.PAGE_DATA_COUNT;i++)
			{
				var item:SchoolListItem=new SchoolListItem();
				_skin.addChild(item);
				item.y=66+i*34.8;
				list.push(item);
			}
			TimerManager.getInstance().add(1000,updateList);
		}
		
		public function updateList():void
		{
			var pageData:PageListData= SchoolDataManager.getInstance().schoolListPage;
			var arr:Array=pageData.getCurrentPageData();
			_skin.txtPage.text=pageData.curPage+"/"+pageData.totalPage;
			if(arr.length==0)
			{
				_skin.mcMouseBuf.visible=false;
				_skin.mcSelectBuf.visible=false;
			}
			for(var i:int=0;i<SchoolDataManager.PAGE_DATA_COUNT;i++)
			{
				var item:SchoolListItem=list[i];
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