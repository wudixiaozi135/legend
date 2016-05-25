package com.view.gameWindow.mainUi.subuis.chatframe
{
	import flash.display.DisplayObjectContainer;

	public interface IChatFrame
	{
		function get output():IChatOutput;
		function set output(output:IChatOutput):void;
		
		function set input(value:IChatInput):void;
		function get input():IChatInput;
		
//		function pushOutputData(data:String,color:uint = 0):void; //不应该开放该借口  数据只能通过chatdatamanager的列表来
		function getChannelByIndex(index:int):int;
		function changeChannel(type:int):void;
		function changeInputChannel(type:int):void;
		function get channelType():int;
		
		function showBg():void;
		function hideBg():void;
		
		function showTip(type:int,data:Object):void
		function hideTip():void
			
		function setInputFocus():void;
		
		function get view():DisplayObjectContainer;
		
		function get theY():int;
	}
}