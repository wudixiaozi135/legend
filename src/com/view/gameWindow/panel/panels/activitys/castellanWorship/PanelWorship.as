package com.view.gameWindow.panel.panels.activitys.castellanWorship
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.consts.FontFamily;
	import com.model.consts.SexConst;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.ModelEvents;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.mainUi.subuis.activityTrace.constants.ActivityFuncTypes;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelBase;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.menus.handlers.MenuFuncs;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	import com.view.newMir.NewMirMediator;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	/**
	 * 城主膜拜面板类
	 * @author Administrator
	 */	
	public class PanelWorship extends PanelBase
	{
		public function PanelWorship()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McCastellanWorship = new McCastellanWorship();
			_skin = skin;
			addChild(_skin);
			setTitleBar(skin.mcDrag);
		}
		
		override protected function initData():void
		{
			ActivityDataManager.instance.attach(this);
			ActivityDataManager.instance.worshipDataManager.attach(this);
			//
			initText();
			_skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function initText():void
		{
			var dtInfo:DataWorshipInfo = ActivityDataManager.instance.worshipDataManager.dtInfo;
			var skin:McCastellanWorship = _skin as McCastellanWorship;
			//
			skin.txtTitle.text = StringConst.WORSHIP_0001;
			var defaultTextFormat:TextFormat = skin.txtTitle.defaultTextFormat;
			defaultTextFormat.bold = true;
			skin.txtTitle.defaultTextFormat = defaultTextFormat;
			skin.txtTitle.setTextFormat(defaultTextFormat);
			//
			skin.txtDialog.text = StringConst.WORSHIP_0002;
			//
			skin.txtCastellanNow.text = StringConst.WORSHIP_0003;
			//
			skin.btnEquip.htmlText = HtmlUtils.createHtmlStr(skin.btnEquip.textColor,StringConst.WORSHIP_0004,12,false,2,FontFamily.FONT_NAME,true);
			//活动内
			skin.mcActvIn.txtDignityNow.text = StringConst.WORSHIP_0005;
			//
			skin.mcActvIn.btnInfos.htmlText = HtmlUtils.createHtmlStr(skin.btnEquip.textColor,StringConst.WORSHIP_0006,12,false,2,FontFamily.FONT_NAME,true);
			//
			skin.mcActvIn.txtDesc0.text = StringConst.WORSHIP_0007.replace("&x",dtInfo.cfgDt.glitter_dignity);
			skin.mcActvIn.txtDesc1.text = StringConst.WORSHIP_0008;
			skin.mcActvIn.txtDesc2.text = StringConst.WORSHIP_0009.replace("&x",dtInfo.cfgDt.rust_dignity);
			skin.mcActvIn.txtDesc3.text = StringConst.WORSHIP_0010;
			skin.mcActvIn.txtDesc4.text = StringConst.WORSHIP_0011.replace("&x",dtInfo.cfgDt.rust_dignity).replace("&y",dtInfo.cfgDt.glitter_dignity);
			skin.mcActvIn.txtDesc5.text = StringConst.WORSHIP_0012;
			//
			var textType:String = DataWorshipInfo.textType(DataWorshipInfo.TYPE_OPERATE_1);
			skin.mcActvIn.btn0.htmlText = HtmlUtils.createHtmlStr(skin.btnEquip.textColor,textType,12,false,2,FontFamily.FONT_NAME,true);
			//
			textType = DataWorshipInfo.textType(dtInfo.sex == SexConst.TYPE_FEMALE ? DataWorshipInfo.TYPE_OPERATE_3 : DataWorshipInfo.TYPE_OPERATE_2);
			skin.mcActvIn.btn1.htmlText = HtmlUtils.createHtmlStr(skin.btnEquip.textColor,textType,12,false,2,FontFamily.FONT_NAME,true);
			//
			textType = DataWorshipInfo.textType(DataWorshipInfo.TYPE_OPERATE_4);
			skin.mcActvIn.btn2.htmlText = HtmlUtils.createHtmlStr(skin.btnEquip.textColor,textType,12,false,2,FontFamily.FONT_NAME,true);
			//
			textType = DataWorshipInfo.textType(DataWorshipInfo.TYPE_OPERATE_5);
			skin.mcActvIn.btn3.htmlText = HtmlUtils.createHtmlStr(skin.btnEquip.textColor,textType,12,false,2,FontFamily.FONT_NAME,true);
			//
			skin.mcActvIn.txtNumNow0.text = StringConst.WORSHIP_0014;
			//
			skin.mcActvIn.txtNumNow1.text = StringConst.WORSHIP_0014;
			skin.mcActvIn.visible = false;
			//活动外
			var cfgDt:ActivityCfgData = ConfigDataManager.instance.activityCfgData2(ActivityFuncTypes.AFT_WORSHIP);
			skin.mcActvOut.txtTime.text = StringConst.WORSHIP_0016;
			skin.mcActvOut.txtTimeValue.text = cfgDt.start_time_str + StringConst.WORSHIP_0017;
			skin.mcActvOut.txtDesc.text = StringConst.WORSHIP_0018;
			var htmlText:String = CfgDataParse.pareseDesToStr(cfgDt.desc,0xffffff,12);
			skin.mcActvOut.txtDescValue.htmlText = htmlText;
			skin.mcActvOut.visible = false;
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var skin:McCastellanWorship = _skin as McCastellanWorship;
			switch(event.target)
			{
				case skin.btnClose:
					dealBtnClose();
					break;
				case skin.btnEquip:
					dealBtnEquip();
					break;
				case skin.mcActvIn.btnInfos:
					dealBtnInfos();
					break;
				case skin.mcActvIn.btn0:
					dealBtn0();
					break;
				case skin.mcActvIn.btn1:
					dealBtn1();
					break;
				case skin.mcActvIn.btn2:
					dealBtn2();
					break;
				case skin.mcActvIn.btn3:
					dealBtn3();
					break;
				default:
					break;
			}
		}
		
		private function dealBtnClose():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_WORSHIP);
		}
		
		private function dealBtnEquip():void
		{
			var dtInfo:DataWorshipInfo = ActivityDataManager.instance.worshipDataManager.dtInfo;
			if(dtInfo.cid)
			{
				MenuFuncs.dealLook(dtInfo.sid,dtInfo.cid);
			}
		}
		
		private function dealBtnInfos():void
		{
			var panel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_WORSHIP_INFOS);
			if(!panel)
			{
				ActivityDataManager.instance.worshipDataManager.cmQueryMasterWorshipRecord();
				PanelMediator.instance.openPanel(PanelConst.TYPE_WORSHIP_INFOS);
			}
			else
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_WORSHIP_INFOS);
			}
		}
		
		private function dealBtn0():void
		{
			var manager:WorshipDataManager = ActivityDataManager.instance.worshipDataManager;
			manager.cmMasterWorshipAction(DataWorshipInfo.TYPE_OPERATE_1);
		}
		
		private function dealBtn1():void
		{
			var manager:WorshipDataManager = ActivityDataManager.instance.worshipDataManager;
			manager.cmMasterWorshipAction(manager.dtInfo.sex == SexConst.TYPE_FEMALE ? DataWorshipInfo.TYPE_OPERATE_3 : DataWorshipInfo.TYPE_OPERATE_2);
		}
		
		private function dealBtn2():void
		{
			var manager:WorshipDataManager = ActivityDataManager.instance.worshipDataManager;
			manager.cmMasterWorshipAction(DataWorshipInfo.TYPE_OPERATE_4);
		}
		
		private function dealBtn3():void
		{
			var manager:WorshipDataManager = ActivityDataManager.instance.worshipDataManager;
			manager.cmMasterWorshipAction(DataWorshipInfo.TYPE_OPERATE_5);
		}
		
		override public function update(proc:int=GameServiceConstants.SM_QUERY_MASTER_WORSHIP):void
		{
			if(proc != GameServiceConstants.SM_QUERY_MASTER_WORSHIP && proc != GameServiceConstants.SM_MASTER_WORSHIP_STATUS_BROADCAST && proc != ModelEvents.UPDATE_MAP_ACTIVITY)
			{
				return;
			}
			var manager:WorshipDataManager = ActivityDataManager.instance.worshipDataManager;
			var skin:McCastellanWorship = _skin as McCastellanWorship;
			var isInActv:Boolean = manager.actvCfgDt.isInActv;
			var isReinLvEnough:Boolean = manager.isReinLvEnough;
			skin.mcActvIn.visible = isInActv && isReinLvEnough;
			skin.mcActvOut.visible = !skin.mcActvIn.visible;
			//
			skin.txtCastellanName.text = manager.dtInfo.name != "" ? manager.dtInfo.name : StringConst.WORSHIP_0015;
			skin.btnEquip.visible = manager.dtInfo.name != "";
			//
			skin.mcActvIn.txtDignityValue.text = manager.dtInfo.dignity + "";
			//
			skin.mcActvIn.txtNumValue0.text = manager.dtInfo.strFirstNum;
			//
			skin.mcActvIn.mcDelimiter.visible = manager.dtInfo.isHead;
			skin.mcActvIn.btn2.visible = manager.dtInfo.isHead;
			skin.mcActvIn.btn3.visible = manager.dtInfo.isHead;
			skin.mcActvIn.txtNumNow1.visible = manager.dtInfo.isHead;
			skin.mcActvIn.txtNumValue1.visible = manager.dtInfo.isHead;
			skin.mcActvIn.txtNumValue1.text = manager.dtInfo.strFamilyNum;
			//刷新进度箭头位置
			skin.mcActvIn.mcArrow.x = skin.mcActvIn.mcProgress.x + skin.mcActvIn.mcProgress.width*manager.dtInfo.dignityScale;
		}
		
		override public function setPostion():void
		{
			var rect:Rectangle = getPanelRect();
			var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
			var newX:int = int((newMirMediator.width - rect.width)*.5) + 300;
			x != newX ? x = newX : null;
			var newY:int = int((newMirMediator.height - rect.height)*.5);
			y != newY ? y = newY : null;
		}
		
		override public function destroy():void
		{
			ActivityDataManager.instance.detach(this);
			ActivityDataManager.instance.worshipDataManager.detach(this);
			_skin.removeEventListener(MouseEvent.CLICK,onClick);
			super.destroy();
		}
	}
}