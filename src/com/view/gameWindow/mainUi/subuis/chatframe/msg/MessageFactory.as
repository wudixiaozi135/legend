package com.view.gameWindow.mainUi.subuis.chatframe.msg
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.chatframe.MessageCfg;
	import com.view.gameWindow.panel.panels.guardSystem.GuardManager;
	import com.view.gameWindow.util.McAnimControl;
	
	import flash.display.MovieClip;
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
	 * 2014-8-16
	 */
	public class MessageFactory implements IMessageFactory
	{
		protected var _formatColor:uint = 0xffffff;
		protected var _formatSize:int = MessageCfg.FONT_SIZE;
		protected var _resultSpeakerIndex:int = -1;
		protected var _resultListenerIndex:int = -1;
		protected var _resultHeadIndex:int = -1;
		protected var _resultBodyIndex:int = -1;
		protected var _resultStyleIndex:int = -1;
		protected var _channelType:int = -1;
		
		public var flagOpen:int = 1;
		public var bannedOpen:int = 1;
		
		

		public static var createExpressionHandler:Function;//擦 感觉这样就破坏结构了Orz
		
		private static var mcAnimCtl:McAnimControl = new McAnimControl(24);; //清理暂时没做 容易溢出
		
		public function MessageFactory()
		{
		}
		
		public function createMessage(roughData:String,type:int,color:uint = 0,lineLength:int = 310/*MessageCfg.LINE_LENGTH*/):Message
		{
			var result:Object = parseMsg(roughData);
			
			if(color)
			{
				_formatColor = color;
			}
			else
			{
				//新加颜色
				var innerColor:uint = getColor(result);
				if(innerColor)
				{
					_formatColor = int(innerColor);
				}
			}
			
			_channelType = type;
			var format:ElementFormat = createFormat();
			var textBlock:TextBlock = createTextBlock();
			var groupVector:Vector.<ContentElement> = new Vector.<ContentElement>();
			
			createChannelFlag(format,groupVector);
			
			
			
			var recordLinks:Vector.<LinkWordView> = new Vector.<LinkWordView>;
			createSpeakerAndListener(getSpeaker(result),getListener(result),format,groupVector,recordLinks);
			createContent(getHead(result),getBody(result),format,groupVector,recordLinks);
			
			var groupElement:GroupElement = new GroupElement(groupVector);
			textBlock.content = groupElement;

			var msg:Message = new Message();
			msg.recordLinks = recordLinks;
			createLines(msg,textBlock,lineLength);
			
			return msg;
		}
		
		protected function get formatColor():uint
		{
			return _formatColor;
		}
		
		protected function get formatSize():int
		{
			return _formatSize;
		}
		
		public function get channelType():int
		{
			if(_channelType == 0)
				_channelType = 10;
			return _channelType;
		}
		
		protected function parseMsg(msg:String):Object
		{
			return null;
		}
		
		
		protected function createChannelFlag(format:ElementFormat,output:Vector.<ContentElement>):void
		{
			
		}
		
		protected function createLines(msg:Message,block:TextBlock,lineLength:int):void
		{
			
		}
		
		protected function getSpeaker(parsedResult:Object):String
		{
			if(!parsedResult || _resultSpeakerIndex == -1)
			{
				return null;
			}
			return parsedResult[_resultSpeakerIndex];
		}
		
		protected function getListener(parsedResult:Object):String
		{
			if(!parsedResult || _resultListenerIndex == -1)
			{
				return null;
			}
			return parsedResult[_resultListenerIndex];
		}
		
		protected function getHead(parsedResult:Object):String
		{
			if(!parsedResult || _resultHeadIndex == -1)
			{
				return null;
			}
			return parsedResult[_resultHeadIndex];
		}
		
		protected function getColor(parsedResult:Object):uint
		{
			if(!parsedResult || _resultStyleIndex == -1)
			{
				return 0;
			}
			
			var txt:String = parsedResult[_resultStyleIndex];
			
			if(txt)
			{
				return parseInt(txt);
			}
			
			return 0; //暂时只解析一个颜色
		}
		
		protected function getBody(parsedResult:Object):String
		{
			if(!parsedResult || _resultBodyIndex == -1)
			{
				return null;
			}
			return parsedResult[_resultBodyIndex];
		}
		
		
		protected function createSpeakerAndListener(speakerData:String,listenerData:String,format:ElementFormat,output:Vector.<ContentElement>,recordLink:Vector.<LinkWordView>):void
		{
			if(!speakerData)
				return;
			
			var graphicElement:GraphicElement;
			var textElement:TextElement;
			
			var speaker:LinkWord = LinkWord.createLinkWord(LinkWord.TYPE_ROLE_NAME);
			speaker.data = speakerData;
			var speakerView:LinkWordView;
			
			if(!listenerData)
			{
				speakerView = new LinkWordView(speaker);
				recordLink.push(speakerView);
				graphicElement = new GraphicElement(speakerView,speakerView.getWidth(),speakerView.getHeight(),format);
				output.push(graphicElement);
				
				textElement = new TextElement("：",format);
				output.push(textElement);
			}
			else
			{
				if(speaker.getUnderline())
				{
					speakerView = new LinkWordView(speaker);
					recordLink.push(speakerView);
					graphicElement = new GraphicElement(speakerView,speakerView.getWidth(),speakerView.getHeight(),format);
					output.push(graphicElement);
				}
				else
				{
					textElement = new TextElement(StringConst.CHAT_YOU_TO,format);
					output.push(textElement);
				}
				
				var listener:LinkWord = LinkWord.createLinkWord(LinkWord.TYPE_ROLE_NAME);
				listener.data = listenerData;
				
				if(listener.getUnderline())
				{
					var listenerView:LinkWordView = new LinkWordView(listener);
					recordLink.push(listenerView);
					graphicElement = new GraphicElement(listenerView,listenerView.getWidth(),listenerView.getHeight(),format);
					output.push(graphicElement);
				}
				else
				{
					textElement = new TextElement(StringConst.CHAT_TO_YOU,format);
					output.push(textElement);
				}
				
				textElement = new TextElement(StringConst.CHAT_SPEAK,format);
				output.push(textElement);
			}
		}
		
		protected function createContent(head:String,body:String,format:ElementFormat,output:Vector.<ContentElement>,recordLink:Vector.<LinkWordView>):void
		{
			var textElement:TextElement;
			var graphicElement:GraphicElement;
			
			if(!head)
			{
//				textElement = new TextElement(replaceBannedWord(body),format);
				createTextAndExpression(body,format,output);
//				output.push(textElement); 
			}
			else
			{
				var words:Vector.<LinkWord> = LinkWord.parseMsgHead(head);
				var txts:Array = [];
				var totalLen:int = body.length;
				var wordIndex:int = 0;
				var word:LinkWord = null;
				var currentCaretIndex:int = 0;
				for(wordIndex = 0; wordIndex < words.length; ++wordIndex)
				{
					word = words[wordIndex];
					if(currentCaretIndex < word.caretIndexBegin)
					{
//						textElement = new TextElement(replaceBannedWord(body.slice(currentCaretIndex,word.caretIndexBegin)),format);
						createTextAndExpression(body.slice(currentCaretIndex,word.caretIndexBegin),format,output);
//						output.push(textElement);
					}
					
					if(word.type == LinkWord.TYPE_TXT)//具有其他颜色的文本
					{
						createTextAndExpression(word.getDescription(),createFormat(word.getColor()),output);
					}
					else
					{
						var wordView:LinkWordView = new LinkWordView(word);
						recordLink.push(wordView);
						graphicElement = new GraphicElement(wordView,wordView.getWidth(),wordView.getHeight(),format);
						output.push(graphicElement);
					}
					
					currentCaretIndex = word.caretIndexEnd;
				}
				if(currentCaretIndex < body.length)
				{
//					textElement = new TextElement(replaceBannedWord(body.slice(currentCaretIndex,body.length)),format);
//					output.push(textElement);
					createTextAndExpression(body.slice(currentCaretIndex,body.length),format,output);
					currentCaretIndex = body.length;
				}
			}
		}
		
		protected function replaceBannedWord(data:String):String
		{
			if(bannedOpen)
			{
				return GuardManager.getInstance().replaceBannedWord(data);
			}
			return data;
		}
		
		protected function createTextAndExpression(data:String,format:ElementFormat,output:Vector.<ContentElement>):void
		{
			if(!data)
			{
				return;
			}
			
			var index:int = data.search(/#\d\d\d/);
			
			var textElement:TextElement; 
			if(index == -1)
			{
				textElement = new TextElement(replaceBannedWord(data),format);
				output.push(textElement);
				return;
			}
			
			var frontText:String = data.slice(0,index);
			var midText:String = data.slice(index+1,index+4);
			var backText:String = data.slice(index+4);
			
			if(frontText)
			{
				textElement = new TextElement(replaceBannedWord(frontText),format);
				output.push(textElement);
			}
			
			var graphicElement:GraphicElement;
			if(createExpressionHandler != null)
			{
				var exp:MovieClip = createExpressionHandler(parseInt(midText));
				if(exp)
				{
					mcAnimCtl.push(exp);
					graphicElement = new GraphicElement(exp,exp.width,exp.height,format);
					output.push(graphicElement);
				}
				else
				{
					textElement = new TextElement("#"+midText,format);
					output.push(textElement);
				}
			}
			
			createTextAndExpression(backText,format,output);
		}
		
		
		protected function createFormat(color:uint = 0):ElementFormat
		{
			var format:ElementFormat = new ElementFormat();
			var fontDescription:FontDescription = new FontDescription(MessageCfg.FONT_NAME);
			var textBlock:TextBlock = new TextBlock();
			
			format.fontSize = formatSize;
			format.fontDescription = fontDescription;
			format.trackingLeft = 1;
			format.color = color ? color : formatColor;
			format.breakOpportunity = BreakOpportunity.ANY;
			
			format.dominantBaseline = TextBaseline.IDEOGRAPHIC_CENTER;
			format.baselineShift = -2;
			
			return format
		}
		
		protected function createTextBlock():TextBlock
		{
			var textBlock:TextBlock = new TextBlock();
			textBlock.baselineFontSize = 0;
			
			return textBlock;
		}
	}
}