package com.view.gameWindow.panel.panels.mail.content
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.mail.data.PanelMailDataManager;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 邮件内容面板类
	 * @author Administrator
	 */	
	public class PanelMailContent extends PanelBase
	{
		internal var viewHandle:PanelMailContentViewHandle;
		internal var clickHandle:PanelMailContentClickHandle;
		
		public function PanelMailContent()
		{
			super();
			PanelMailDataManager.instance.attach(this);
		}
		
		override protected function initSkin():void
		{
			_skin = new McMailContent();
			initTxt();
			addChild(_skin);
			setTitleBar((_skin as McMailContent).dragBox);
		}
		
		private function initTxt():void
		{
			var mcMail:McMailContent = _skin as McMailContent;
			var defaultTextFormat:TextFormat = mcMail.txtTitle.defaultTextFormat;
			defaultTextFormat.bold = true;
			mcMail.txtTitle.defaultTextFormat = defaultTextFormat;
			mcMail.txtTitle.setTextFormat(defaultTextFormat);
			mcMail.txtTitle.text = StringConst.MAIL_PANEL_0006;
			//
			mcMail.txtSender.text = StringConst.MAIL_PANEL_0007;
			mcMail.txtTheme.text = StringConst.MAIL_PANEL_0008;
			mcMail.txtContent.text = StringConst.MAIL_PANEL_0009;
			mcMail.txtReward.text = StringConst.MAIL_PANEL_0010;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var mcMail:McMailContent = _skin as McMailContent;
			rsrLoader.addCallBack(mcMail.btnGet,function (mc:MovieClip):void
			{
				(mc.txt as TextField).text = StringConst.MAIL_PANEL_0011;
			});
		}
		
		override protected function initData():void
		{
			viewHandle = new PanelMailContentViewHandle(this);
			clickHandle = new PanelMailContentClickHandle(this);
		}
		
		override public function update(proc:int=0):void
		{
			viewHandle.refresh();
		}
		
		override public function destroy():void
		{
			PanelMailDataManager.instance.detach(this);
			if(clickHandle)
			{
				clickHandle.destroy();
				clickHandle = null;
			}
			if(viewHandle)
			{
				viewHandle.destroy();
				viewHandle = null;
			}
			super.destroy();
		}
	}
}