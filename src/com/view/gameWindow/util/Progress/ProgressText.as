package com.view.gameWindow.util.Progress
{
	import com.greensock.TweenLite;
	import com.view.gameWindow.util.UtilText;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	public class ProgressText extends Sprite
	{
		private var count:int;
		public function ProgressText()
		{
			super();
			this.mouseEnabled=this.mouseChildren=false;
		}
		
		public function addStr(str:String):void
		{
			var text:TextField=UtilText.getText();
			text.htmlText=str;
			text.y=this.numChildren*20;
			addChild(text);
			setTimeout(removeText,1500,text);
		}
		
		private function removeText(text:TextField):void
		{
			TweenLite.to(text,0.5,{alpha:0,onComplete:onFinishTween,onCompleteParams:[text]});
		}
		
		private function onFinishTween(text:TextField):void
		{
			text.parent.removeChild(text);
			text=null;
		}
		
		public function destroy():void
		{
			
		}
	}
}