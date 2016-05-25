package com.view.gameWindow.panel.panels.school.complex.list.item
{
	import com.model.consts.SchoolConst;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.prompt.SelectPromptBtnManager;
	import com.view.gameWindow.panel.panels.prompt.SelectPromptType;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.panel.panels.school.complex.list.McListItem;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	import com.view.gameWindow.panel.panels.school.simpleness.list.item.SchoolData;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.ServerTime;
	
	import flash.events.MouseEvent;
	
	public class SchoolListItem extends McListItem
	{


		private var _data:SchoolData;
		private const NO_SCHOOL:int=0;
		public function SchoolListItem()
		{
			super();
			init();
		}
		
		private function init():void
		{
			txt7.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			txt7.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			txt7.addEventListener(MouseEvent.CLICK,onMouseClick);
			txt8.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			txt8.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			txt8.addEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			if(event.currentTarget==txt8)
			{
				SchoolDataManager.getInstance().lookSchoolData=this.data;
				PanelMediator.instance.switchPanel(PanelConst.TYPE_SCHOOL_CARD);
			}else if(event.currentTarget==txt7)
			{
				declareWar();
			}
		}
		
		private function declareWar():void
		{
			if(SchoolElseDataManager.getInstance().schoolInfoData.money<200)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0064);	
				return;
			}
			if(SchoolElseDataManager.getInstance().getSchoolJurisdictionCMD(SchoolConst.JURISDICTION_ADMIN)==false)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SCHOOL_PANEL_0065);	
				return;
			}
			
			var getSelect:Boolean = SelectPromptBtnManager.getSelect(SelectPromptType.SELEC_CALL);
			if(getSelect)
			{
				SchoolDataManager.getInstance().sendCallMember(_data.id,_data.sid);
			}else
			{
				var title:String=HtmlUtils.createHtmlStr(0xff6600,StringConst.SCHOOL_PANEL_2028);
				Alert.show3(title,function ():void
				{
					SchoolDataManager.getInstance().sendCallMember(_data.id,_data.sid);
				},null,selectAuction,getSelect,StringConst.PROMPT_PANEL_0033,"","",null,"left");
			}
		}
		
		private function selectAuction(boolean:Boolean):void
		{
			SelectPromptBtnManager.setSelect(SelectPromptType.SELECT_ATTACK,boolean);
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			if(data.count>=data.maxCount)return;
			event.currentTarget.textColor=0xff0000;
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(data.count>=data.maxCount)return;
			event.currentTarget.textColor=0x00ff00;
		}
		
		public function update(data:SchoolData):void
		{
			this.data = data;
			txt1.text=data.rank+"";
			txt2.text=data.name;
			txt3.text=data.leaderName;
			txt4.text=data.count+"/"+data.maxCount;
			//SCHOOL_PANEL_00333
			var item:* = SchoolDataManager.getInstance().attackSchoolDic[data.id+"|"+data.sid];
			if(item!=null)
			{
				var diff:Number = (item as int)-ServerTime.time;
				var m:int = diff/60;
				var s:int=diff%60;
				txt5.text=StringConst.SCHOOL_PANEL_00335;
				txt6.text=StringConst.SCHOOL_PANEL_00333+"("+m+StringConst.MINIUTE+s+StringConst.SECOND+")";
				txt7.htmlText=HtmlUtils.createHtmlStr(0xff0000,"<u>"+StringConst.SCHOOL_PANEL_00333+"</u>");
				txt7.mouseEnabled=false;
			}else
			{
				txt5.text=StringConst.SCHOOL_PANEL_00331;
				txt6.text=StringConst.SCHOOL_PANEL_00332;
				txt7.mouseEnabled=true;
				txt7.htmlText=HtmlUtils.createHtmlStr(0x00ff00,"<u>"+StringConst.SCHOOL_PANEL_00333+"</u>");
			}
			txt8.htmlText=HtmlUtils.createHtmlStr(0x00ff00,"<u>"+StringConst.SCHOOL_PANEL_00334+"</u>");
		}
		
		public function destroy():void
		{
			txt7.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			txt7.removeEventListener(MouseEvent.MOUSE_UP,onMouseOver);
			txt7.removeEventListener(MouseEvent.CLICK,onMouseClick);
			txt8.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			txt8.removeEventListener(MouseEvent.MOUSE_UP,onMouseOver);
			txt8.removeEventListener(MouseEvent.CLICK,onMouseClick);
		}

		public function get data():SchoolData
		{
			return _data;
		}

		public function set data(value:SchoolData):void
		{
			_data = value;
		}


	}
}