package com.view.gameWindow.panel.panels.school.complex.member.nickName
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.util.HtmlUtils;
	
	public class NickNamePanel extends PanelBase
	{
		private var _mouseHandler:NickNameMouseHandler;
		private var _handler:NickNameHandler;
		public function NickNamePanel()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:MCNickName = new MCNickName();
			_skin = skin;
			addChild(_skin);
			setTitleBar(_skin.mcTitle);
			_skin.txtTitle.htmlText=HtmlUtils.createHtmlStr(0xFFE1AA,StringConst.SCHOOL_PANEL_2016,14,true);
			_handler=new NickNameHandler(this);
			_mouseHandler=new NickNameMouseHandler(this);
			initText();
		}
		
		private function initText():void
		{
			var panel:MCNickName = _skin as MCNickName;
			panel.txt1.htmlText=HtmlUtils.createHtmlStr(0xd4a460,StringConst.SCHOOL_PANEL_0055);
			panel.txt2.text=StringConst.SCHOOL_PANEL_0056;
			panel.txt3.text=StringConst.SCHOOL_PANEL_0057;
			panel.txt2.mouseEnabled=false;
			panel.txt3.mouseEnabled=false;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			super.addCallBack(rsrLoader);
		}
		
		override public function destroy():void
		{
			_mouseHandler&&_mouseHandler.destroy();
			_mouseHandler=null;
			_handler&&_handler.destroy();
			_handler=null;
			super.destroy();
		}
		
		override protected function initData():void
		{
			_handler&&_handler.updatePanel();	
		}		
		override public function update(proc:int=0):void
		{
			super.update(proc);
		}
		
		override public function setPostion():void
		{
			isMount(true);
		}
		
	}
}