package com.view.gameWindow.panel.panels.school.complex.member
{
	import com.model.consts.SchoolConst;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.util.scrollBar.ScrollBar;
	import com.view.gameWindow.util.scrollBar.ScrollBarType;
	

	public class SchoolMemberHandler
	{

		private var _panel:SchoolMemberPanel;
		private var _skin:MCMemberPanel;
		public var schoolMemberGroup:SchoolMemberGroup;
		private var _scrollBar:ScrollBar;
		public function SchoolMemberHandler(panel:SchoolMemberPanel)
		{
			this._panel = panel;
			_skin=panel.skin as MCMemberPanel;
			
			schoolMemberGroup = new SchoolMemberGroup();
			_skin.bgGroup.addChild(schoolMemberGroup);
		}
		
		public function initScrollBar():void
		{
			schoolMemberGroup.setScrollRectWH(662,352);
			_scrollBar=new ScrollBar(schoolMemberGroup,_skin.mcScrollBar,ScrollBarType.TYPE_DEFAULT,null,44);
			_scrollBar.resetHeight(352);
		}
		
		public function updatePanel():void
		{
			var schoolMembers:Vector.<SchoolMemberData> = SchoolElseDataManager.getInstance().schoolMembers;
			if(schoolMembers==null||_scrollBar==null)return;
			schoolMembers=schoolMembers.filter(filterMembersByPosition);
			schoolMemberGroup.updateMember(schoolMembers);
			_scrollBar.resetScroll();
			_scrollBar.scrollTo(0);
		}
		
		public function updateJurisdiction():void
		{
			_skin.btn1.visible=SchoolElseDataManager.getInstance().getSchoolJurisdictionCMD(SchoolConst.JURISDICTION_ADMIN);
			_skin.btn2.visible=SchoolElseDataManager.getInstance().getSchoolJurisdictionCMD(SchoolConst.JURISDICTION_ADMIN);
			_skin.btn3.visible=SchoolElseDataManager.getInstance().getSchoolJurisdictionCMD(SchoolConst.JURISDICTION_ADMIN);
			_skin.txtb1.visible=_skin.btn1.visible;
			_skin.txtb2.visible=_skin.btn2.visible;
			_skin.txtb3.visible=_skin.btn3.visible;
		}
		
		private function filterMembersByPosition(schoolMember:SchoolMemberData,index:int,schoolMembers:Vector.<SchoolMemberData>):Boolean
		{
			var selectMemberPosition:int = SchoolElseDataManager.getInstance().selectMemberPosition;
			if(schoolMember.position==selectMemberPosition||selectMemberPosition==0)
			{
				return true;
			}
			return false;
		}		
		
		
		public function destroy():void
		{
			if(_scrollBar)
			{
				_scrollBar.destroy();
				_scrollBar=null;
			}
			if(schoolMemberGroup)
			{
				schoolMemberGroup.destroy();
				schoolMemberGroup.parent&&schoolMemberGroup.parent.removeChild(schoolMemberGroup);
				schoolMemberGroup=null;
			}
		}
		
		public function hideMouseBuf():void
		{
			schoolMemberGroup.mcMouseBuf.visible=false;
		}
		
		public function hideSelectBuf():void
		{
			schoolMemberGroup.mcSelectBuf.visible=false;
		}
	}
}