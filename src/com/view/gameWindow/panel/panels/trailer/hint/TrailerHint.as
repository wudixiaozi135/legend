package com.view.gameWindow.panel.panels.trailer.hint
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	import com.view.gameWindow.panel.panels.trailer.TrailerConst;
	import com.view.gameWindow.panel.panels.trailer.TrailerData;
	import com.view.gameWindow.panel.panels.trailer.TrailerDataManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.ServerTime;
	import com.view.gameWindow.util.TimeUtils;
	import com.view.gameWindow.util.TimerManager;
	import com.view.newMir.NewMirMediator;
	
	import flash.geom.Rectangle;
	
	import mx.utils.StringUtil;
	
	public class TrailerHint extends PanelBase
	{

		private var mouseHandler:TrailerHineMouseHandler;
		public function TrailerHint()
		{
			super();
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			super.addCallBack(rsrLoader);
		}
		
		override public function destroy():void
		{
			mouseHandler.destroy();
			TrailerDataManager.getInstance().detach(this);
			TimerManager.getInstance().remove(updatePanel);
			super.destroy();
		}
		
		override protected function initData():void
		{
			TrailerDataManager.getInstance().attach(this);
			super.initData();
		}
		
		override protected function initSkin():void
		{
			var skin:MCHint = new MCHint();
			_skin = skin;
			addChild(_skin);
			setTitleBar(_skin.mcTitle);
			_skin.txtTitle.htmlText=HtmlUtils.createHtmlStr(0xFFE1AA,StringConst.TRAILER_HINT_STRING_001,14,true);
			initText();
			mouseHandler = new TrailerHineMouseHandler(this);
			
		}
		
		private function initText():void
		{
			var mCHint:MCHint = _skin as MCHint;
			mCHint.txt3.text=StringConst.TRAILER_HINT_STRING_002;
			mCHint.txt4.text=StringConst.TRAILER_HINT_STRING_003;
			mCHint.txt5.text=StringConst.TRAILER_HINT_STRING_004;
			
			mCHint.txt3.mouseEnabled=false;
			mCHint.txt4.mouseEnabled=false;
			mCHint.txt5.mouseEnabled=false;
			
			mCHint.txt6.text=StringConst.TRAILER_HINT_STRING_005;
			mCHint.txt7.text=StringConst.TRAILER_HINT_STRING_006;
			mCHint.txt8.text=StringConst.TRAILER_HINT_STRING_007;
			mCHint.txtAlert.text=StringConst.TRAILER_HINT_STRING_013;
			TimerManager.getInstance().add(1000,updatePanel);
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
			var mCHint:MCHint = _skin as MCHint;
			var trailerData:TrailerData = TrailerDataManager.getInstance().trailerData;
			if(trailerData.state==TaskStates.TS_DOING)
			{
				var name:String = HtmlUtils.createHtmlStr(TrailerConst.colors[trailerData.quality-1],TrailerConst.names[trailerData.quality-1]);
				var createStr:String = HtmlUtils.createHtmlStr(0xd4a460,StringUtil.substitute(StringConst.TRAILER_HINT_STRING_008,name));
				mCHint.txt1.htmlText=createStr;
				var timeStr:String = TimeUtils.formatClock1(trailerData.expire-ServerTime.time);
				mCHint.txt2.htmlText=HtmlUtils.createHtmlStr(0xd4a460,StringConst.TRAILER_HINT_STRING_009+"<font color='#ff0000'>"+timeStr+"</font>");
			}else
			{
				PanelMediator.instance.switchPanel(PanelConst.TYPE_TRAILER_HINT);
			}
		}
		
		override public function setPostion():void
		{
			var rect:Rectangle = getPanelRect();
			var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
			var newX:int = int(newMirMediator.width - rect.width);
			x != newX ? x = newX : null;
			var newY:int = int(newMirMediator.height - rect.height);
			y != newY ? y = newY : null;
		}		
	}
}