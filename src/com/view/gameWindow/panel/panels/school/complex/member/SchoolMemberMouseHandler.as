package com.view.gameWindow.panel.panels.school.complex.member
{
	import com.model.consts.SchoolConst;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.menus.MenuMediator;
	import com.view.gameWindow.panel.panels.menus.SchoolItemMenu;
	import com.view.gameWindow.panel.panels.menus.handlers.SchoolMemberItemHandler;
	import com.view.gameWindow.panel.panels.prompt.SelectPromptBtnManager;
	import com.view.gameWindow.panel.panels.prompt.SelectPromptType;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.panel.panels.school.complex.information.SchoolInfoData;
	import com.view.gameWindow.panel.panels.school.complex.member.MCMemberPanel.MCGroup;
	import com.view.gameWindow.panel.panels.school.complex.member.item.SchoolMemberItem;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.Request;
	import mx.utils.StringUtil;

	public class SchoolMemberMouseHandler
	{

		private var panel:SchoolMemberPanel;
		private var skin:MCMemberPanel;
		private var itemMenu:SchoolItemMenu;
		private var _selectMemberItem:SchoolMemberData;
		public function SchoolMemberMouseHandler(panel:SchoolMemberPanel)
		{
			this.panel = panel;
			skin = panel.skin as MCMemberPanel;
			skin.addEventListener(MouseEvent.CLICK,onClickFunc);
			skin.addEventListener(MouseEvent.MOUSE_OVER,onOverFunc);
			skin.addEventListener(MouseEvent.MOUSE_OUT,onOutFunc);
		}
		
		protected function onOutFunc(event:MouseEvent):void
		{
			if(event.target==skin.txt9)
			{
				skin.txt9.textColor=0x00ff00;
			}
		}
		
		protected function onOverFunc(event:MouseEvent):void
		{
			if(event.target==skin.txt9)
			{
				skin.txt9.textColor=0xff0000;
			}
			
			var item:SchoolMemberItem=event.target.parent as SchoolMemberItem;
			if(item)
			{
				var mCGroup:MCGroup = item.parent as MCGroup;
				mCGroup.mcMouseBuf.y=	item.y;
				mCGroup.setChildIndex(mCGroup.mcMouseBuf,mCGroup.numChildren-1);
				mCGroup.mcMouseBuf.visible=true;
				event.stopPropagation();
			}else
			{
				panel.hideMouseBuf();
			}
		}		
		
		
		protected function onClickFunc(event:MouseEvent):void
		{
			var item:SchoolMemberItem=event.target.parent as SchoolMemberItem;
			if(item)
			{
				_selectMemberItem=item.data;
				var mCGroup:MCGroup = item.parent as MCGroup;
				mCGroup.mcSelectBuf.y=item.y;
				mCGroup.setChildIndex(mCGroup.mcSelectBuf,mCGroup.numChildren-1);
				mCGroup.mcSelectBuf.visible=true;
				if(event.target==item.txt7)
				{
					onCallMember(item.data.cid,item.data.sid,item.data.name);
					return;
				}
				if(!itemMenu)
				{
					event.stopImmediatePropagation();
					var sch:SchoolMemberData=item.data;
					itemMenu = new SchoolItemMenu(new SchoolMemberItemHandler(sch));
					itemMenu.addEventListener(Event.SELECT,itemMenuSelectHandler);
					MenuMediator.instance.showMenu(itemMenu);
					
					itemMenu.x = event.stageX + 10;
					itemMenu.y = event.stageY - itemMenu.height - 10;
				}
				return;
			}
			switch(event.target)
			{
				case skin.btn1:
					PanelMediator.instance.switchPanel(PanelConst.TYPE_SCHOOL_APPLY);
					break;
				case skin.btn2:
					PanelMediator.instance.switchPanel(PanelConst.TYPE_SEARCH_FOR_SCHOOL);
					break;
				case skin.btn3:
					dealExpelMember();
					break;
				case skin.btn4:
					onClickExitSchool();
					break;
				case skin.txt9:
					onRedactNickName();
					break;
			}
		}		
		
		private function onCallMember(cid:int, sid:int,name:String):void
		{
			if(BagDataManager.instance.goldUnBind<30)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.POSITION_PANEL_0038);	
				return;
			}
			
			var getSelect:Boolean = SelectPromptBtnManager.getSelect(SelectPromptType.SELEC_CALL);
			if(getSelect)
			{
				SchoolElseDataManager.getInstance().sendCallMember(cid,sid);
			}else
			{
				var title:String=StringUtil.substitute(StringConst.SCHOOL_PANEL_2026,name);
				Alert.show3(title,function ():void
					{
						SchoolElseDataManager.getInstance().sendCallMember(cid,sid);
					},null,selectAuction,getSelect,StringConst.PROMPT_PANEL_0033,"","",null,"left")
			}
		}
		
		private function selectAuction(boolean:Boolean):void
		{
			SelectPromptBtnManager.setSelect(SelectPromptType.SELEC_CALL,boolean);
		}
		
		private function onRedactNickName():void
		{
			if(SchoolElseDataManager.getInstance().getSchoolJurisdictionCMD(SchoolConst.JURISDICTION_ADMIN)==false)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0137);	
				return;
			}
			PanelMediator.instance.switchPanel(PanelConst.TYPE_SCHOOL_NICKNAME);
		}
		
		private function dealExpelMember():void
		{
			if(_selectMemberItem==null)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0136);	
				return;
			}
			SchoolElseDataManager.getInstance().expelMemberReq(_selectMemberItem.cid,_selectMemberItem.sid);
			panel.hideSelectBuf();
			_selectMemberItem=null;
		}
		
		private function itemMenuSelectHandler(e:Request):void
		{
			itemMenu.removeEventListener(Event.SELECT,itemMenuSelectHandler);
			MenuMediator.instance.hideMenu(itemMenu);
			itemMenu = null;
		}
		
		private function onClickExitSchool():void
		{
			var schoolInfoData:SchoolInfoData = SchoolElseDataManager.getInstance().schoolInfoData;
			if(schoolInfoData.position==1)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0130);	
				return;
			}
			Alert.show2(StringConst.SCHOOL_PANEL_0131,function ():void
			{
				SchoolElseDataManager.getInstance().exitSchoolRequest();
			});
		}
		
		public function clearSelect():void
		{
			_selectMemberItem=null;
			panel.hideSelectBuf();
		}
		
		public function destroy():void
		{
			if(itemMenu)
			{
				itemMenu.removeEventListener(Event.SELECT,itemMenuSelectHandler);
				MenuMediator.instance.hideMenu(itemMenu);
			}
			itemMenu = null;
			
			skin.removeEventListener(MouseEvent.MOUSE_OVER,onOverFunc);
			skin.removeEventListener(MouseEvent.MOUSE_OUT,onOutFunc);
			skin.removeEventListener(MouseEvent.CLICK,onClickFunc);
		}
	}
}