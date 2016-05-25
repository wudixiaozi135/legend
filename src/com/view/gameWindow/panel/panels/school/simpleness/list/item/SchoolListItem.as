package com.view.gameWindow.panel.panels.school.simpleness.list.item
{
	import com.model.configData.cfgdata.FamilyCfgData;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.school.McListItem;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.events.MouseEvent;
	
	import mx.utils.StringUtil;
	
	public class SchoolListItem extends McListItem
	{

		private var rsrLoader:RsrLoader;

		private var _data:SchoolData;
		private const NO_SCHOOL:int=0;
		public function SchoolListItem()
		{
			super();
			init();
		}
		
		private function init():void
		{
			txt6.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			txt6.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			txt6.addEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(data.count>=data.maxCount)
			{
				return;
			}
			if(data.type==NO_SCHOOL)
			{
				var cfg:FamilyCfgData=SchoolDataManager.getInstance().getSchoolCreateCfg();
				if(RoleDataManager.instance.lv<cfg.join_level)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringUtil.substitute(StringConst.SCHOOL_PANEL_0038,cfg.join_level));
					return;
				}
				SchoolDataManager.getInstance().joinSchoolRequest(data.id,data.sid);
			}else
			{
				SchoolDataManager.getInstance().cancelJoinSchoolRequest(data.id,data.sid);
			}
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			if(data==null||data.count>=data.maxCount)return;
			txt6.textColor=0xff0000;
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(data==null||data.count>=data.maxCount)return;
			txt6.textColor=0x00ff00;
		}
		
		public function update(data:SchoolData):void
		{
			this.data = data;
			txt1.text=data.rank+"";
			txt2.text=data.name;
			txt3.text=data.leaderName;
			txt4.text=data.level+"";
			txt5.text=data.count+"/"+data.maxCount;
			if(data.count>=data.maxCount)
			{
				txt6.text=StringConst.SCHOOL_PANEL_0033;
				txt6.textColor=0xff0000;
			}else
			{
				txt6.htmlText=HtmlUtils.createHtmlStr(0x00ff00,"<u>"+(data.type==1?StringConst.SCHOOL_PANEL_0032:StringConst.SCHOOL_PANEL_0031)+"</u>");
			}
		}
		
		public function destroy():void
		{
			txt6.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			txt6.removeEventListener(MouseEvent.MOUSE_UP,onMouseOver);
			txt6.removeEventListener(MouseEvent.CLICK,onMouseClick);
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