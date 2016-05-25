package com.view.gameWindow.tips.toolTip
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class EntityChatTip extends BaseTip
	{
		protected var text:TextField;
		
		public function EntityChatTip()
		{
			super();
			initView(_skin);
		}
		
		override public function initView(mc:MovieClip):void
		{
			_skin = new EntityChatSkin();
			_skin.addev
			addChild(_skin);
			super.initView(_skin);
			
			text = new TextField();
			addChild(text);
			text.width = 200;
			text.autoSize = TextFieldAutoSize.LEFT;
			
			text.multiline = true;
			text.wordWrap = true;
			text.filters = [_filter];
		}
		
		override public function setData(data:Object):void
		{
			_data = data;
			var htmlStr:String = data as String;
			if(!htmlStr)
			{
				return;
			}
			text.htmlText=htmlStr;
			text.x = 3;
			text.y = 4;
			width = text.x+text.textWidth+9;
			height = text.y+text.textHeight+20;
		}
	}
}