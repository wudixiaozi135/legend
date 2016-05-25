package com.view.gameWindow.panel.panels.school.complex.information.eventList
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.FamilyPositionCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.panel.panels.school.complex.information.eventList.item.SchoolEventData;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	
	import mx.utils.StringUtil;
	import flash.utils.Dictionary;

	public class EventParseUtil
	{
		public function EventParseUtil()
		{
		}
		
		public static function parseEvent(data:SchoolEventData):String
		{
			var content:String="";
			switch(data.eventTpye)
			{
				case 1:
					content=StringUtil.substitute(StringConst.SCHOOL_PANEL_3007,"<font color='#53b436'>"+data.name+"</font>");
					break;
				case 2:
					content=StringUtil.substitute(StringConst.SCHOOL_PANEL_3008,"<font color='#53b436'>"+data.name+"</font>");
					break;
				case 3:
					content=StringUtil.substitute(StringConst.SCHOOL_PANEL_3009,"<font color='#53b436'>"+data.name+"</font>");
					break;
				case 4:
					content=StringUtil.substitute(StringConst.SCHOOL_PANEL_3010,"<font color='#53b436'>"+data.content+"</font>","<font color='#53b436'>"+data.name+"</font>");
					break;
				case 5:
					var paras:Array= data.content.split(":");
					var positionDic:Dictionary = SchoolDataManager.getInstance().positionDic;
//					var familyPositionCfgData:FamilyPositionCfgData =SchoolElseDataManager.getInstance().(paras[0]);
//					var familyPositionCfgData2:FamilyPositionCfgData = ConfigDataManager.instance.familyPositionCfgData(paras[1]);
					content=StringUtil.substitute(StringConst.SCHOOL_PANEL_3011,"<font color='#53b436'>"+data.name+"</font>",positionDic[paras[0]],positionDic[paras[1]]);
					break;
				case 6:
					var paras1:Array= data.content.split(":");
					var positionDic1:Dictionary = SchoolDataManager.getInstance().positionDic;
//					var familyPositionCfgData3:FamilyPositionCfgData = ConfigDataManager.instance.familyPositionCfgData(paras1[0]);
//					var familyPositionCfgData4:FamilyPositionCfgData = ConfigDataManager.instance.familyPositionCfgData(paras1[1]);
					content=StringUtil.substitute(StringConst.SCHOOL_PANEL_3012,"<font color='#53b436'>"+data.name+"</font>",positionDic1[paras1[0]],positionDic1[paras1[1]]);
					break;
				case 7:
					content=StringUtil.substitute(StringConst.SCHOOL_PANEL_3013,"<font color='#53b436'>"+data.name+"</font>");
					break;
				case 8:
					content=StringUtil.substitute(StringConst.SCHOOL_PANEL_3014,"<font color='#53b436'>"+data.name+"</font>");
					break;
				case 9:
					content=StringUtil.substitute(StringConst.SCHOOL_PANEL_3015,"<font color='#53b436'>"+data.name+"</font>");
					break;
				case 10:
					content=StringUtil.substitute(StringConst.SCHOOL_PANEL_3016,"<font color='#53b436'>"+data.name+"</font>");
					break;
				case 11:
					content=StringUtil.substitute(StringConst.SCHOOL_PANEL_3017,"<font color='#53b436'>"+data.name+"</font>","<font color='#d4a460'>"+data.content+"</font>");
					break;
			}
			return content;
		}
	}
}