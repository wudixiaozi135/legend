package com.view.gameWindow.panel.panels.trailer.enter
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.model.configData.cfgdata.TaskCfgData;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.npcfunc.PanelNpcFuncData;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	import com.view.gameWindow.panel.panels.trailer.MCTrailerEnter;
	import com.view.gameWindow.panel.panels.trailer.TrailerData;
	import com.view.gameWindow.panel.panels.trailer.TrailerDataManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.css.GameStyleSheet;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import mx.utils.StringUtil;
	import com.model.configData.cfgdata.ActivityCfgData;
	
	public class TrailerEnter extends PanelBase
	{

		private var mouseHandler:TrailerEnterMouseHandler;
		public var isStar:Boolean;
		public function TrailerEnter()
		{
			super();
			TrailerDataManager.getInstance().attach(this);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			super.addCallBack(rsrLoader);
		}
		
		override protected function initSkin():void
		{
			var skin:MCTrailerEnter = new MCTrailerEnter();
			_skin = skin;
			addChild(_skin);
			setTitleBar(_skin.mcTitleBar);
			_skin.txtTitle.htmlText=HtmlUtils.createHtmlStr(0xFFE1AA,StringConst.TRAILER_STRING_1,14,true);
			initText();
			TrailerDataManager.getInstance().queryTrailerInfo();
			mouseHandler = new TrailerEnterMouseHandler(this);
		}
		
		private function initText():void
		{
			var npcId:int = PanelNpcFuncData.npcId;
			var npcCfgData:NpcCfgData = ConfigDataManager.instance.npcCfgData(npcId);
			_skin.txtDesc.text= npcCfgData.default_dialog;
			var activityCfgData:ActivityCfgData = ConfigDataManager.instance.activityCfgData(801);
			_skin.txtNext.htmlText=CfgDataParse.pareseDesToStr(activityCfgData.desc);
			_skin.txt1.styleSheet=GameStyleSheet.linkStyle;
			
		}
		
		private function setEnd():void
		{
		}
		
		private function setStar():void
		{
		}		
		
		override public function update(proc:int=0):void
		{
			if(proc==GameServiceConstants.SM_TASK_TRAILER_INFO)
			{
				updatePanel();
			}
			super.update(proc);
		}
		
		private function updatePanel():void
		{
			var trailerData:TrailerData = TrailerDataManager.getInstance().trailerData;
			
			var cfgData:TaskCfgData = TrailerDataManager.getInstance().getTasktrailerCfg();
			var npcId:int = PanelNpcFuncData.npcId;
			if(cfgData.start_npc==npcId)
			{
				isStar=true;
				setStar();
			}else
			{
				isStar=false;
				setEnd();
			}
			
			if(isStar)
			{
				var counStr:String = StringUtil.substitute(StringConst.TRAILER_STRING_2,trailerData.count,trailerData.totalCount);
				_skin.txt1.htmlText=HtmlUtils.createHtmlStr(0xffcc00,counStr,12,false,2,"SimSun",true,"this");
			}else
			{
				if(trailerData.state==TaskStates.TS_CAN_SUBMIT)
				{
					_skin.txt1.htmlText=HtmlUtils.createHtmlStr(0xffcc00,StringConst.TRAILER_STRING_04,12,false,2,"SimSun",true,"this");
				}else
				{
					_skin.txt1.htmlText=HtmlUtils.createHtmlStr(0xffcc00,StringConst.TRAILER_STRING_4,12,false,2,"SimSun",true,"this");
				}
			}
		}
		
		override public function destroy():void
		{
			TrailerDataManager.getInstance().detach(this);
			mouseHandler.destroy();
			mouseHandler=null;
			super.destroy();
		}
	}
}