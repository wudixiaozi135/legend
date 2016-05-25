package com.view.gameWindow.mainUi.subuis.chatframe.msg
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.chatframe.MessageCfg;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.engine.BreakOpportunity;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	
	/**
	 * @author wqhk
	 * 2014-8-8
	 */
	public class MessageFactoryNotice extends MessageFactory
	{
		public function MessageFactoryNotice()
		{
			_formatColor = MessageCfg.COLOR_SYSTEM;
			bannedOpen = 0;
		}
		
		override protected function parseMsg(msg:String):Object
		{
			var pattern:RegExp = /^style\{(.*)\} head\{(.*)\} (.*)$/;
			var result:Object = pattern.exec(msg);
			
			_resultSpeakerIndex = -1;
			_resultListenerIndex = -1;
			_resultStyleIndex = 1;
			_resultHeadIndex = 2;
			_resultBodyIndex = 3;
			
			return result;
		}
		
		
		override protected function createChannelFlag(format:ElementFormat,output:Vector.<ContentElement>):void
		{
			var iconData:BitmapData = MessageCfg.IMG_STORE[MessageCfg.URL_SYSTEM];
			var iconBmp:Bitmap = new Bitmap(iconData);
			var _text:TextField = new TextField();
			_text.mouseEnabled = false;
			_text.width = 35;
			_text.autoSize = TextFieldAutoSize.CENTER;
			_text.textColor = 0xff002c;
//			_text.filters = [new GlowFilter(0,1,2,2,10)];
			_text.text = StringConst.CHAT_0010;
			_text.x = 5;
			_text.y = -1;
			var sp:Sprite = new Sprite();
			sp.addChild(iconBmp);
			sp.addChild(_text);
			var graphicElement:GraphicElement = new GraphicElement(sp,sp.width,sp.height,format);
//			var graphicElement:GraphicElement = new GraphicElement(iconBmp,iconData.width,iconData.height,format);
			output.push(graphicElement);
		}
		
		override protected function createLines(msg:Message,block:TextBlock,lineLength:int):void
		{
			msg.createTextLines(block,0);
		}
	}
}