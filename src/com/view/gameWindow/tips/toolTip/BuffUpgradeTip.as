package com.view.gameWindow.tips.toolTip
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.JointHaloCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hejiSkill.tabHejiBuff.JointHaloData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import mx.utils.StringUtil;

	public class BuffUpgradeTip extends BaseTip
	{
		public function BuffUpgradeTip()
		{
			super();
			_skin = new BigTextTipSkin();
			addChild(_skin);
			initView(_skin);
		}
		
		override public function setData(obj:Object):void
		{
			_data=obj;
			var title:String=HtmlUtils.createHtmlStr(0xff6600,StringConst.JOINT_PANEL_0023);
			addProperty(title,19,10);
			maxHeight=43;
			
			var jointData:JointHaloData=obj as JointHaloData;
//			var jointCfgData:JointHaloCfgData=ConfigDataManager.instance.jointHaloCfgData(jointData.id,jointData.level);
			var jointNLCfgData:JointHaloCfgData=ConfigDataManager.instance.jointHaloCfgData(jointData.id,jointData.level+1);
			if(jointNLCfgData==null)
			{
				return;
			}
			var color:int=0x00ff00;
			
			 if(jointNLCfgData.reincarn>RoleDataManager.instance.reincarn||(RoleDataManager.instance.reincarn<=jointNLCfgData.reincarn&&jointNLCfgData.start_level>RoleDataManager.instance.lv))
			{
				color=0xff0000;
			}
			 
			 var str:String=HtmlUtils.createHtmlStr(color,StringUtil.substitute(StringConst.JOINT_PANEL_0026,jointNLCfgData.reincarn,jointNLCfgData.start_level),12,false,4);
			 if(jointNLCfgData.reincarn==0)
			 {
				 str=HtmlUtils.createHtmlStr(color,StringUtil.substitute(StringConst.JOINT_PANEL_0028,jointNLCfgData.start_level),12,false,4);
			 }
			 
			 if(jointNLCfgData.gold>BagDataManager.instance.goldUnBind)   //元宝不足
			 {
				 color=0xff0000;
			 }else
			 {
				 color=0x00ff00;
			 }
			 str+="\n"+HtmlUtils.createHtmlStr(color,StringUtil.substitute(StringConst.JOINT_PANEL_0027,jointNLCfgData.gold),12,false,4);
			 addProperty(str,19,maxHeight);
			 maxHeight=90;

			 addSplitLine(19,maxHeight);
			 
			 maxHeight=100;
			 addProperty(HtmlUtils.createHtmlStr(0xff6600,StringConst.JOINT_PANEL_0024),19,maxHeight);
			 maxHeight=124;
			 var attr:String="";
			 var attrs:Vector.<String>= CfgDataParse.getAttHtmlStringArray(jointNLCfgData.attr,4);
			 for each(var tt:String in attrs)
			 {
				 attr+=tt+"<font color='#00ff00'>  <b>"+StringConst.TIP_UP+"</b></font>+\n";
				 maxHeight+=19.2;
			 }
			 HtmlUtils.createHtmlStr(0xffffff,attr,12,false,4);
			 addProperty(attr,35,124);
			 addProperty(HtmlUtils.createHtmlStr(0xff0000,StringUtil.substitute(StringConst.JOINT_PANEL_0025,jointNLCfgData.vice_halo_add_rate/10)),19,maxHeight);
			 maxHeight+=35;
			 width=280;
			 height=maxHeight;
		}
	}
}