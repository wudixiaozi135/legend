package com.view.gameWindow.mainUi.subuis.chatframe.msg
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.chatframe.MessageCfg;
	import com.view.gameWindow.panel.panels.guardSystem.GuardManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.engine.BreakOpportunity;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	
	import flashx.textLayout.formats.TextAlign;

	/**
	 * @author wqhk
	 * 2014-8-15
	 */
	public class MessageFactoryPrivate extends MessageFactory
	{
		public function MessageFactoryPrivate()
		{
			_formatColor = 0xff78fc;
		}
		
		override protected function parseMsg(msg:String):Object
		{
			var pattern:RegExp = /^\[(.+)\] \[(.+)\] style\{(.*)\} head\{(.*)\} (.*)$/;
			var result:Object = pattern.exec(msg);
			
			_resultSpeakerIndex = 1;
			_resultListenerIndex = 2;
			_resultStyleIndex = 3;
			
			_resultHeadIndex = 4;
			_resultBodyIndex = 5;
			
			return result;
		}
		
		override protected function createChannelFlag(format:ElementFormat,output:Vector.<ContentElement>):void
		{
			var iconData:BitmapData = MessageCfg.IMG_STORE[MessageCfg.URL_PRIVATE];
			var iconBmp:Bitmap = new Bitmap(iconData);
			var _text:TextField = new TextField();
			_text.mouseEnabled = false;
			_text.width = 35;
			_text.autoSize = TextFieldAutoSize.CENTER;
			_text.textColor = formatColor;
			_text.filters = [new GlowFilter(0,1,2,2,10)];
			_text.text = MessageCfg.getChannelName(channelType);
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