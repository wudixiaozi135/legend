package com.view.gameWindow.panel.panels.trailer
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.DropDownListWithLoad;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.css.GameStyleSheet;
	
	import flash.events.Event;
	
	import mx.utils.StringUtil;
	
	public class TrailerPanel extends PanelBase
	{
		private var _mouseHandler:TrailerMouseHandler;
		private var _handler:TrailerHandler;
		public var combox:DropDownListWithLoad;
		private const ACTIVITE_ID:int=801;
		public function TrailerPanel()
		{
			super();
			TrailerDataManager.getInstance().attach(this);
			VipDataManager.instance.attach(this);
		}
		
		override protected function initSkin():void
		{
			var skin:MCTrailerPanel = new MCTrailerPanel();
			_skin = skin;
			addChild(_skin);
			setTitleBar(_skin.mcTitle);
			_skin.txtTitle.htmlText=HtmlUtils.createHtmlStr(0xFFE1AA,StringConst.TRAILER_STRING_5,14,true);
			_handler=new TrailerHandler(this);
			_mouseHandler=new TrailerMouseHandler(this);
			initText();
		}
		
		private function initText():void
		{
			var panel:MCTrailerPanel = _skin as MCTrailerPanel;
			panel.txt1.text=StringConst.TRAILER_STRING_6;
			panel.txt2.text=StringConst.TRAILER_STRING_7;
			panel.txt22.htmlText=HtmlUtils.createHtmlStr(0x53b436,StringConst.STRENGTH_PANEL_0036,12,false,2,"SimSun",true,"this");
			panel.txt3.htmlText=HtmlUtils.createHtmlStr(0x53b436,StringConst.TRAILER_STRING_8,12,false,2,"SimSun",true,"this");
			panel.txt3.visible=false;
			panel.txt22.styleSheet=GameStyleSheet.linkStyle;
			panel.txt3.styleSheet=GameStyleSheet.linkStyle;
			panel.txt4.text=StringConst.TRAILER_STRING_9;
			panel.txt5.text=StringConst.TRAILER_STRING_10;
			panel.txt6.text=StringConst.TRAILER_STRING_11;
			panel.txt5.mouseEnabled=false;
			panel.txtv5.mouseEnabled=false;
			panel.txt6.mouseEnabled=false;
			panel.txt7.text=StringConst.TRAILER_STRING_12;
			panel.txtv6.text=StringConst.TRAILER_STRING_14;
			panel.txtb1.text=StringConst.TRAILER_STRING_13;
			panel.txtb2.text=StringConst.TRAILER_STRING_15;
			panel.txtb1.mouseEnabled=false;
			panel.txtb2.mouseEnabled=false;
			
			TrailerDataManager.getInstance().queryTrailerInfo();
			var num1:int = ConfigDataManager.instance.vipCfgData(1).add_task_trailer_num+3;
			var num2:int = ConfigDataManager.instance.vipCfgData(2).add_task_trailer_num+3;
			var num3:int = ConfigDataManager.instance.vipCfgData(3).add_task_trailer_num+3;
			var num4:int = ConfigDataManager.instance.vipCfgData(4).add_task_trailer_num+3;
			var num5:int = ConfigDataManager.instance.vipCfgData(5).add_task_trailer_num+3;
			var num6:int = ConfigDataManager.instance.vipCfgData(6).add_task_trailer_num+3;
			var num7:int = ConfigDataManager.instance.vipCfgData(7).add_task_trailer_num+3;
			var num8:int = ConfigDataManager.instance.vipCfgData(8).add_task_trailer_num+3;
			var num9:int = ConfigDataManager.instance.vipCfgData(9).add_task_trailer_num+3;
			var num10:int = ConfigDataManager.instance.vipCfgData(10).add_task_trailer_num+3;
			var vipValue:String = StringUtil.substitute(StringConst.TRAILER_STRING_24,VipDataManager.instance.lv,num1,num2,num3,num4,num5,num6,num7,num8,num9,num10);
			var vipStr:String = HtmlUtils.createHtmlStr(0xb4b4b4,vipValue);
			ToolTipManager.getInstance().attachByTipVO(panel.txt22,ToolTipConst.TEXT_TIP,vipStr);
			var textStr:String = HtmlUtils.createHtmlStr(0xb4b4b4,StringConst.TRAILER_STRING_30);
			ToolTipManager.getInstance().attachByTipVO(panel.txt3,ToolTipConst.TEXT_TIP,textStr);
			var textStr2:String = HtmlUtils.createHtmlStr(0xb4b4b4,StringConst.TRAILER_STRING_26);
			ToolTipManager.getInstance().attachByTipVO(panel.txtv6,ToolTipConst.TEXT_TIP,textStr2);
			
			var activityCfgData:ActivityCfgData = ConfigDataManager.instance.activityCfgData(ACTIVITE_ID);
			if(activityCfgData.isInActv==false)
			{
//				panel.mcAlert.visible=true;
				panel.txtAlert.htmlText=HtmlUtils.createHtmlStr(0xff0000,StringConst.TRAILER_STRING_35);
			}else
			{
//				panel.mcAlert.visible=false;
				panel.txtAlert.htmlText=HtmlUtils.createHtmlStr(0x00a2ff,StringConst.TRAILER_STRING_36);
			}
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			combox=new DropDownListWithLoad(TrailerConst.names,_skin.txt8,81,rsrLoader,_skin,"downItem","downListBtn",TrailerConst.names[0]);
			combox.selectedIndex=TrailerConst.names.length-1;
			combox.addEventListener(Event.CHANGE,onComBoxChange);
			super.addCallBack(rsrLoader);
		}
		
		protected function onComBoxChange(event:Event):void
		{
			if(skin.protectSingleBtn1.selected==true)
			{
				TrailerDataManager.getInstance().refreshTrailerId=combox.selectedIndex+1;
			}else
			{
				TrailerDataManager.getInstance().refreshTrailerId=0;
			}
		}
		
		override public function destroy():void
		{
			VipDataManager.instance.detach(this);
			ToolTipManager.getInstance().detach(_skin.txt22);
			ToolTipManager.getInstance().detach(_skin.txt3);
			ToolTipManager.getInstance().detach(_skin.txtv6);
			TrailerDataManager.getInstance().detach(this);
			if(combox)
			{
				combox.removeEventListener(Event.CHANGE,onComBoxChange);
				combox.destroy();
				combox=null;
			}
			_mouseHandler&&_mouseHandler.destroy();
			_mouseHandler=null;
			_handler&&_handler.destroy();
			_handler=null;
			super.destroy();
		}
		
		override protected function initData():void
		{
			
		}		
		
		override public function update(proc:int=0):void
		{
			if(proc==GameServiceConstants.SM_TASK_TRAILER_INFO||proc==GameServiceConstants.SM_VIP_INFO)
			{
				_handler.updatePanel();
			}else if(proc==GameServiceConstants.CM_REFERSH_TASK_TRAILER)
			{
				_handler.showRefreshResult();
			}
			super.update(proc);
		}
		
		override public function setPostion():void
		{
			isMount(true);
		}
		
	}
}