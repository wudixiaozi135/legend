package com.view.gameWindow.panel.panels.trailer
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.ResManager;
	import com.view.gameWindow.util.Cover;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UtilText;
	import com.view.gameWindow.util.Progress.Progress;
	import com.view.gameWindow.util.Progress.ProgressText;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class ProgressGroup extends Sprite
	{

		private var progress:Progress;
		private var progressText:ProgressText;
		private var btn:MovieClip;
		private var btnLabel:TextField;
		private var cover:Cover;
		
		public function ProgressGroup()
		{
			initProgress();
		}
		
		private function initProgress():void
		{
//			cover=new Cover(0x000000,0.6);
//			addChild(cover);
			
			progress = new Progress();
			addChild(progress);
			progress.setProgressInfo(1,"刷新中...");
			progress.mouseEnabled=progress.mouseChildren=false;
			
			progressText = new ProgressText();
			addChild(progressText);
			progressText.x=80;
			progressText.y=30;
			var btnStr:String = ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD+"common/longBtn.swf";
			ResManager.getInstance().loadSwf(btnStr,onCompleFunc);
		}
		
		public function star():void
		{
			progress.show2();
		}
		
		public function addMessage(value:String):void
		{
			progressText.addStr(value);
		}
		
		public function setStarFunc(func:Function):void
		{
			progress.startFunc=func;
		}
		
		public function setCompleFunc(func:Function):void
		{
			progress.compleFunc=func;
		}
		
		private function onCompleFunc(mc:MovieClip):void
		{
			this.btn = mc;
			addChild(btn);
			btn.addEventListener(MouseEvent.CLICK,onClickFunc);
			btn.x=222;
			btn.y=4;
			
			btnLabel=UtilText.getLabel();
			btnLabel.htmlText=HtmlUtils.createHtmlStr(0xd4a460,StringConst.TRAILER_STRING_22);
			addChild(btnLabel);
			btnLabel.x=240;
			btnLabel.y=9;
		}
		
		protected function onClickFunc(event:MouseEvent):void
		{
			this.destroy();
			this.parent&&this.parent.removeChild(this);
		}
		
		public function destroy():void
		{
			if(progress)
			{
				progress.destroy();
				progress.parent.removeChild(progress);
			}
			progress=null;
			
			if(progressText)
			{
				progressText.destroy();
				progressText.parent.removeChild(progressText);
			}
			progressText=null;
			
			if(btnLabel)
			{
				btnLabel.parent.removeChild(btnLabel);
			}
			btnLabel=null;
			
			if(btn)
			{
				btn.removeEventListener(MouseEvent.CLICK,onClickFunc);
				btn.parent.removeChild(btn);
			}
			btn=null;
		}
	}
}