package com.view.gameWindow.panel.panels.school.complex.member.auditList
{
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.panel.panels.school.complex.member.MCAuditList;
	import com.view.gameWindow.panel.panels.school.complex.member.auditList.item.SchoolAuditListItem;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	import com.view.gameWindow.util.PageListData;

	public class SchoolAuditListHandler
	{
		private var _panel:SchoolAuditListPanel;
		private var _skin:MCAuditList;
		private var list:Vector.<SchoolAuditListItem>;
		
		public function SchoolAuditListHandler(panel:SchoolAuditListPanel)
		{
			this._panel = panel;
			_skin=panel.skin as MCAuditList;
			initListItem();
		}
		
		public function destroy():void
		{
			while(list.length>0)
			{
				var item:SchoolAuditListItem=list.shift();
				item.destroy();
				item.parent&&item.parent.removeChild(item);
				item=null;
			}
		}
		
		private function initListItem():void
		{
			list=new Vector.<SchoolAuditListItem>();
			for(var i:int=0;i<SchoolDataManager.PAGE_DATA_COUNT;i++)
			{
				var item:SchoolAuditListItem=new SchoolAuditListItem();
				_skin.addChild(item);
				item.y=83.35+i*24;
				item.x=38;
				list.push(item);
			}
		}
		
		public function updateList():void
		{
			var schoolApplyListPage:PageListData = SchoolElseDataManager.getInstance().schoolApplyListPage;
			var arr:Array=schoolApplyListPage.getCurrentPageData();
			_skin.txtPage.text=schoolApplyListPage.curPage+"/"+schoolApplyListPage.totalPage;
			if(arr.length==0)
			{
				_skin.mcMouseBuf.visible=false;
				_skin.mcSelectBuf.visible=false;
			}
			for(var i:int=0;i<SchoolElseDataManager.PAGE_DATA_COUNT;i++)
			{
				var item:SchoolAuditListItem=list[i];
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