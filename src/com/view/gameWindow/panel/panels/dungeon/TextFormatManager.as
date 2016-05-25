package com.view.gameWindow.panel.panels.dungeon
{
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class TextFormatManager
	{
		private static var _instance:TextFormatManager;
		public static function get instance():TextFormatManager
		{
			if(!_instance)
			{
				_instance = new TextFormatManager(new PrivateClass());
			}
			return _instance;
		}
		public function TextFormatManager(pc:PrivateClass)
		{
			
		}
		/**
		 *设置文本样式 
		 * @param txt
		 * @param color 设置颜色
		 * @param hasUnderline 是否带下划线
		 * @param hasBold 是否粗体
		 * 
		 */		
		public function setTextFormat(txt:TextField,color:uint,hasUnderline:Boolean,hasBold:Boolean):void
		{
			var _textFormat:TextFormat;
			txt.textColor = color;
			_textFormat = txt.defaultTextFormat;
			_textFormat.underline = hasUnderline;
			_textFormat.bold = hasBold;
			txt.defaultTextFormat = _textFormat;
			txt.setTextFormat(_textFormat);
		}
		
		public function setFont(txt:TextField,str:String):void
		{
			var _textFormat:TextFormat;
			_textFormat = txt.defaultTextFormat;
			_textFormat.font = str;
			txt.defaultTextFormat = _textFormat;
			txt.setTextFormat(_textFormat);
		}
	}
}
class PrivateClass{}