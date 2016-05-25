package com.view.gameWindow.mainUi.subuis.chatframe
{
	import flash.display.DisplayObject;
	import flash.text.TextField;

	public interface IChatInput
	{
		function get view():DisplayObject;
		function setFocus(value:Boolean = true):void;
		function get isFocus():Boolean;
		
		function setSize(x:Number,y:Number,width:Number,height:Number):void;
		function set inputText(value:String):void;
		function get inputText():String;
		function setSelection(startIndex:int,endIndex:int):void;
		function get caretIndex():int;
		
		function appendItem(value:String,type:int = 0):void;
		
		function insertText(index:int,text:String):void;
		
		function sendTalk():void;
		
		function set channelType(value:int):void;
		function get channelType():int;
		
		function setPrivateTarget(value:Object):void;
	
	}
}