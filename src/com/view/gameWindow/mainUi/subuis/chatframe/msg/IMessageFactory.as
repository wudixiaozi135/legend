package com.view.gameWindow.mainUi.subuis.chatframe.msg
{
	import com.view.gameWindow.mainUi.subuis.chatframe.MessageCfg;

	public interface IMessageFactory
	{
		function createMessage(roughData:String,type:int,color:uint = 0,lineLength:int = 309):Message;
	}
}