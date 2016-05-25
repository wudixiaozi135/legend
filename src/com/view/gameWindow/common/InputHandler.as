package com.view.gameWindow.common
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import mx.utils.StringUtil;
	
	/**
	 * 
	 * 1.控制行数<\br>
	 * 2.当失去焦点时 处理回调
	 * 
	 * @author wqhk
	 * 2014-11-12
	 */
	public class InputHandler
	{
		private var text:TextField;
		private var checkTimeId:int = 0;
		
		private var lastInputTxt:String;
		private var lastSelectedTxt:String;
		private var defaultTxt:String;
		private var maxLine:int;
		
		public var focusOutCallback:Function;
		public var changeCallback:Function;
		/**
		 * 
		 */
		public function InputHandler(text:TextField,defaultTxt:String = "",maxLine:int = -1,focuseOutCallback:Function = null,changeCallback:Function = null)
		{
			this.text = text;
			
			this.text.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			this.text.addEventListener(TextEvent.TEXT_INPUT,txtInputHandler);
			this.text.addEventListener(Event.CHANGE,txtChangeHandler);
			this.text.addEventListener(MouseEvent.CLICK,txtClickHandle);
			this.text.addEventListener(FocusEvent.FOCUS_OUT,txtFocusOutHandler);
			this.defaultTxt = defaultTxt;
			this.maxLine = maxLine;
			this.focusOutCallback = focuseOutCallback;
			this.changeCallback = changeCallback;
			
			if(StringUtil.trim(this.text.text) == "")
			{
				this.text.text = this.defaultTxt;
			}
		}
		
		private function txtClickHandle(e:MouseEvent):void
		{
			if(defaultTxt && StringUtil.trim(text.text) == defaultTxt)
			{
				text.text = "";
			}
			
//			clearCheckTime();
//			addCheckTime();
		}
		
		private function moodTxtInputHandler(e:TextEvent):void
		{
			lastInputTxt = e.text;
		}
		
		private function clearCheckTime():void
		{
			if(checkTimeId)
			{
				clearInterval(checkTimeId);
				checkTimeId = 0;
			}
		}
		
//		private function addCheckTime():void
//		{
//			checkTimeId = setInterval(txtFocuseCheckHandler,500);
//		}
		
		private function txtFocusOutHandler(e:Event):void
		{
			txtFocuseCheckHandler();
		}
		
		private function keyDownHandler(e:KeyboardEvent):void
		{
			lastSelectedTxt = text.selectedText;
			
//			clearCheckTime();
//			addCheckTime();
		}
		
		private function txtInputHandler(e:TextEvent):void
		{
			lastInputTxt = e.text;
		}
		
		private function txtChangeHandler(e:Event):void
		{
			if(maxLine != -1 && text.numLines>maxLine)
			{
				var txt:String = text.text;
				text.text = fixTextLength(txt,lastInputTxt.length,text.caretIndex,lastSelectedTxt);
			}
			
			if(changeCallback != null)
			{
				changeCallback(StringUtil.trim(text.text));
			}
			
			lastSelectedTxt = "";
			lastInputTxt = "";
		}
		
		public function destroy():void
		{
			focusOutCallback = null;
			changeCallback = null;
			text.removeEventListener(FocusEvent.FOCUS_OUT,txtFocusOutHandler);
			text.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			text.removeEventListener(TextEvent.TEXT_INPUT,txtInputHandler);
			text.removeEventListener(Event.CHANGE,txtChangeHandler);
			text.removeEventListener(MouseEvent.CLICK,txtClickHandle);
			text = null;
		}
		
		private function txtFocuseCheckHandler():void
		{
			if(text && (!text.stage || text.stage.focus != text))
			{
//				clearCheckTime();
				
				var txt:String = StringUtil.trim(text.text);
				
				if(txt)
				{
					if(focusOutCallback != null)
					{
						focusOutCallback(txt);
					}
				}
				else
				{
					text.text = defaultTxt;
				}
			}
		}
		
		public static function fixTextLength(txt:String,addedNum:int,currentIndex:int = -1,lastSelectedText:String = ""):String
		{
			if(currentIndex == -1)
			{
				currentIndex = txt.length;
			}
			
			var preText:String = txt.slice(0,currentIndex-addedNum);
			preText += lastSelectedText;
			
			if(currentIndex < txt.length)
			{
				preText += txt.slice(currentIndex,txt.length);
			}
			
			return preText;
		}
	}
}