package com.view.gameWindow.util
{
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class UtilText
	{
		private static var defaultFormat:TextFormat;
		public function UtilText()
		{
		}
		
		public static function getText():TextField
		{
			var text:TextField = new TextField();
			text.autoSize = TextFieldAutoSize.LEFT;
			if(defaultFormat)
				text.defaultTextFormat = defaultFormat;
			text.wordWrap = true;
			text.selectable=text.mouseWheelEnabled=false
			text.multiline =true;
			text.filters = [FilterUtil.getTextFilter()];
			return text;	
		}
		
		public static function getLabel():TextField
		{
			var text:TextField = new TextField();
			text.autoSize = TextFieldAutoSize.LEFT;
			if(defaultFormat)
				text.defaultTextFormat = defaultFormat;
			text.mouseEnabled=text.mouseWheelEnabled=false;
			text.wordWrap = true;
			text.multiline =true;
			text.filters = [FilterUtil.getTextFilter()];
			return text;	
		}
		/**
		 * 文字溢出省略号表示<br>不适用用于htmltext文本
		 * @param txt 带有完整内容的文本框
		 */
		public static function ellipsesText(txt:TextField):void
		{
			if(txt.textWidth + 3 <= txt.width)
			{
				return;
			}
			ToolTipManager.getInstance().attachByTipVO(txt,ToolTipConst.TEXT_TIP,txt.text);
			txt.addEventListener(Event.REMOVED_FROM_STAGE,function onRemove(event:Event):void
			{
				ToolTipManager.getInstance().detach(txt);
				txt.removeEventListener(Event.REMOVED_FROM_STAGE,onRemove);
			});
			while(txt.textWidth + 3 > txt.width)
			{
				txt.text = txt.text.slice(0,txt.text.length-2);
				txt.appendText(StringConst.ELLIPSES);
			}
		}
	}
}