package com.view.gameWindow.panel.panels.school.complex.information
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.FamilyAddMemberCfgData;
	import com.model.consts.SchoolConst;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.guardSystem.GuardManager;
	import com.view.gameWindow.panel.panels.prompt.SelectPromptBtnManager;
	import com.view.gameWindow.panel.panels.prompt.SelectPromptType;
	import com.view.gameWindow.panel.panels.school.McInformation;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	
	import mx.utils.StringUtil;

	public class SchoolInfoMouseHandler
	{

		private var panel:SchoolInfoPanel;
		private var skin:McInformation;
		public function SchoolInfoMouseHandler(panel:SchoolInfoPanel)
		{
			this.panel = panel;
			skin = panel.skin as McInformation;
			skin.addEventListener(MouseEvent.CLICK,onClickFunc);
			skin.addEventListener(MouseEvent.MOUSE_OVER,onOverFunc);
			skin.addEventListener(MouseEvent.MOUSE_OUT,onOutFunc);
		}
		
		protected function onOutFunc(event:MouseEvent):void
		{
			if(event.target==skin.txt8)
			{
				skin.txt8.textColor=0x00ff00;
			}
			if(event.target==skin.txt9)
			{
				skin.txt9.textColor=0x00ff00;
			}
			if(event.target==skin.txt10)
			{
				skin.txt10.textColor=0x00ff00;
			}
			if(event.target==skin.txt15)
			{
				skin.txt15.textColor=0x00ff00;
			}
		}
		
		protected function onOverFunc(event:MouseEvent):void
		{
			if(event.target==skin.txt8)
			{
				skin.txt8.textColor=0xff0000;
			}
			if(event.target==skin.txt9)
			{
				skin.txt9.textColor=0xff0000;
			}
			if(event.target==skin.txt10)
			{
				skin.txt10.textColor=0xff0000;
			}
			if(event.target==skin.txt15)
			{
				skin.txt15.textColor=0xff0000;
			}
		}		
		
		protected function onClickFunc(event:MouseEvent):void
		{
			var schoolInfoData:SchoolInfoData = SchoolElseDataManager.getInstance().schoolInfoData;
			switch(event.target)
			{
				case skin.tab0:
					skin.txt13.textColor=0xd4a460;
					skin.txt12.textColor=0xffe1aa;
					setBtnState(skin.tab0);
					skin.txt14.text=schoolInfoData.notice;
					break;
				case skin.tab1:
					skin.txt12.textColor=0xd4a460;
					skin.txt13.textColor=0xffe1aa;
					setBtnState(skin.tab1);
					skin.txt14.text=schoolInfoData.noticeExter;
					break;
				case skin.txt15:  
					onclickRedact();
					break;
				case skin.btnAuction:
					onCLickAuction();
					break;
				case skin.txt9:
					onclickAddCount();
					break;
				case skin.txt10:
					onclickAddCoin();
					break;
				case skin.btnDissolve:
					onClickDissolve();
					break;
				case skin.btnRecruit:
					PanelMediator.instance.switchPanel(PanelConst.TYPE_SEARCH_FOR_SCHOOL);
					break;
				case skin.btnExit:
					onClickExitSchool();
					break;
				case skin.mcEvent1:
					onClickEvent();
					break;
			}
		}		
		
		private function onClickEvent():void
		{
			PanelMediator.instance.switchPanel(PanelConst.TYPE_SCHOOL_EVENT);
		}
		
		private function onClickDissolve():void
		{
			Alert.show2(StringConst.SCHOOL_PANEL_0133,function ():void
			{
				SchoolElseDataManager.getInstance().dissolveSchoolRequest();
			},null,StringConst.SCHOOL_PANEL_0118,"",null,"center");
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
		
		private function onclickAddCoin():void
		{
			PanelMediator.instance.switchPanel(PanelConst.TYPE_DONATE);
		}
		
		private function onclickAddCount():void
		{
			var schoolInfoData:SchoolInfoData = SchoolElseDataManager.getInstance().schoolInfoData;
			var number:Number = (schoolInfoData.maxCount-30)/SchoolConst.EVERY_ADD_COUNT;
			var familyAddMemberCfgData:FamilyAddMemberCfgData = ConfigDataManager.instance.familyAddMemberCfgData(number+1);
			if(familyAddMemberCfgData==null)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0044);	
				return;
			}
			var gold:int = familyAddMemberCfgData.gold;
			

			Alert.show2(StringUtil.substitute(StringConst.SCHOOL_PANEL_0127,gold,schoolInfoData.maxCount+5),function ():void
			{
				if(BagDataManager.instance.goldUnBind<gold)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DGN_GOALS_026);	
					return;
				}
				SchoolElseDataManager.getInstance().schoolAddMember();
			});
		}
		
		private function onCLickAuction():void
		{
			var getSelect:Boolean = SelectPromptBtnManager.getSelect(SelectPromptType.SELECT_AUCTION_TICKET);
			if(getSelect)
			{
				if(BagDataManager.instance.goldUnBind<50)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DGN_GOALS_026);	
					return;
				}
				SchoolElseDataManager.getInstance().sendAuctionReq();
			}else
			{
				Alert.show3(StringUtil.substitute(StringConst.SCHOOL_PANEL_0123,50),yesAuction,null,selectAuction,getSelect,StringConst.PROMPT_PANEL_0033,"","",null,"left");
			}
		}
		
		private function selectAuction(boolean:Boolean):void
		{
			SelectPromptBtnManager.setSelect(SelectPromptType.SELECT_AUCTION_TICKET,boolean);
		}
		
		private function yesAuction():void
		{
			if(BagDataManager.instance.goldUnBind<50)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DGN_GOALS_026);	
				return;
			}
			SchoolElseDataManager.getInstance().sendAuctionReq();
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.SCHOOL_PANEL_0124);
		}
		
		private function onclickRedact():void
		{
			if(skin.txt15.text==StringConst.SCHOOL_PANEL_0113)
			{
				skin.txt14.type=TextFieldType.INPUT;
				skin.txt14.border=true;
				skin.txt14.borderColor=0x413a34;
				skin.txt14.background=true;
				skin.txt14.backgroundColor=0x000000;
				skin.txt14.maxChars=100;
				skin.txt15.htmlText=HtmlUtils.createHtmlStr(0x00ff00,"<u>"+StringConst.SCHOOL_PANEL_0213+"</u>");
			}else
			{
				if(sendUpdateNoticeReq()==false)return;
				
				skin.txt14.type=TextFieldType.DYNAMIC;
				skin.txt14.border=false;
				skin.txt14.background=false;
				skin.txt15.htmlText=HtmlUtils.createHtmlStr(0x00ff00,"<u>"+StringConst.SCHOOL_PANEL_0113+"</u>");
			}
		}
		
		private function sendUpdateNoticeReq():Boolean
		{
			var value:String=skin.txt14.text;
			if(GuardManager.getInstance().containBannedWord(value) == true)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0122);
				return false;
			}
			var type:int=1;
			if(panel.lastBtn==skin.tab1)
			{
				type=2;
			}
			SchoolElseDataManager.getInstance().updateNoticeRequest(type,value);
			return true;
			
		}
		
		private function setBtnState(nowBtn:MovieClip):void
		{
			if(panel.lastBtn)
			{
				panel.lastBtn.selected = false;
				panel.lastBtn.mouseEnabled = true;
			}
			nowBtn.selected = true;
			nowBtn.mouseEnabled = false;
			panel.lastBtn = nowBtn;
			
			skin.txt14.type=TextFieldType.DYNAMIC;
			skin.txt14.border=false;
			skin.txt14.background=false;
			skin.txt15.htmlText=HtmlUtils.createHtmlStr(0x00ff00,"<u>"+StringConst.SCHOOL_PANEL_0113+"</u>");
		}
		
		public function destroy():void
		{
			skin.removeEventListener(MouseEvent.MOUSE_OVER,onOverFunc);
			skin.removeEventListener(MouseEvent.MOUSE_OUT,onOutFunc);
			skin.removeEventListener(MouseEvent.CLICK,onClickFunc);
		}
	}
}