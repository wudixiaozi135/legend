package com.view.gameWindow.tips.toolTip
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * 简单的文本tip
	 * @author jhj
	 */
	public class TextTip extends BaseTip
	{

		protected var text:TextField;
		public function TextTip()
		{
			super();
			initView(_skin);
		}
		
		override public function initView(mc:MovieClip):void
		{
			_skin = new TextTipSkin();
			_skin.skin.resUrl="equipSkin.swf";
			addChild(_skin);
			super.initView(_skin);
			
			text = new TextField();
			addChild(text);
			text.width = 250;
			text.autoSize = TextFieldAutoSize.LEFT;
			text.textColor = 0xffe1aa;
			text.multiline = true;
			text.wordWrap = true;
			text.filters = [_filter];
		}
		
		override public function setData(data:Object):void
		{
			_data = data;
			var htmlStr:String = data as String;
			if(!htmlStr)
				return;
//			var text:TextField = addText(htmlStr);
			text.htmlText=htmlStr;
			text.x = 10;
			text.y = 6;
			width = text.x+text.textWidth+13;
			height = text.y+text.textHeight+10;
		}
		
		/**private function addText(htmlStr:String):TextField
		{
			
			text = new TextField();
			addChild(text);
			text.width = 250;
			text.autoSize = TextFieldAutoSize.LEFT;
			text.htmlText = htmlStr;
			text.multiline = true;
			text.wordWrap = true;
			text.filters = [_filter];
			return text;
		}*/
	}
}