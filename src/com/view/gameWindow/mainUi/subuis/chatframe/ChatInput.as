package com.view.gameWindow.mainUi.subuis.chatframe
{
	import com.model.consts.ItemType;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.common.InputHandler;
	import com.view.gameWindow.mainUi.subuis.chatframe.msg.LinkWord;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.prompt.Panel1BtnPromptData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	import com.view.gameWindow.panel.panels.team.TeamDataManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import mx.utils.StringUtil;
	
	/**
	 * @author wqhk
	 * 2014-8-13
	 */
	public class ChatInput implements IChatInput
	{
		private var _input:TextField;//输入框
		public var _inputLinkWords:Vector.<LinkWord>;
		
		private var _beginIndex:int;
		private var _endIndex:int;
		private var _keyCode:int;
		private var _currentInputText:String;
		private var _currentSelectedText:String;
		private var _channelType:int;
		private var _privateTarget:Object;//私聊对象
		private var _privateTargetView:TextField;
		private var _ctner:Sprite;
		
		private var _width:Number;
		private var _height:Number;
		private var _onelineMaxChar:int;
		public function ChatInput()
		{
			var format:TextFormat = new TextFormat(MessageCfg.FONT_NAME,12,0xffffff);
			format.align = TextFormatAlign.LEFT;
			
			_input = new TextField();
			_input.type = TextFieldType.INPUT;
			_input.multiline = true;
			_input.wordWrap = true;
			_input.autoSize = TextFieldAutoSize.LEFT;
			_input.mouseWheelEnabled = false; 
			_input.defaultTextFormat = format;
			_input.addEventListener(Event.CHANGE,textChangeHandler);
			_input.addEventListener(TextEvent.TEXT_INPUT,inputHandler);
			_input.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);//会屏蔽鼠标右键的复制黏贴 所以只需要考虑键盘
			
			_privateTargetView = new TextField();
			_privateTargetView.selectable = false;
			_privateTargetView.defaultTextFormat = format;
			_privateTargetView.visible = false;
			_privateTargetView.mouseEnabled = false;
			
			_ctner = new Sprite();
			_ctner.addChild(_input);
			_ctner.addChild(_privateTargetView);
			
			_onelineMaxChar = MessageCfg.PRIVATE_ONELINE_MAXCHAR;
			
			_ctner.addEventListener(MouseEvent.CLICK,ctnerClickHandler);
		}
		
		private function ctnerClickHandler(e:MouseEvent):void
		{
			setFocus();
		}
		
		public function setPrivateTarget(value:Object):void
		{
			_privateTarget = value;
			
			_privateTargetView.htmlText = _privateTarget? StringConst.CHAT_TO+"  "+StringConst.CHAT_ROLE_NAME.replace("xx",_privateTarget.name)+"     "+StringConst.CHAT_SPEAK_color:"";
		}
		
		public function set channelType(value:int):void
		{
			_channelType = value;
			
			if(_channelType == MessageCfg.CHANNEL_PRIVATE)
			{
				if(_input.multiline)
				{
					_input.multiline = false;
					_input.wordWrap = false;
					
					_privateTargetView.visible = true;
					_input.autoSize = TextFieldAutoSize.NONE;
					_input.x = 0;
					_input.y = 12;
					_input.width = _width;
					_input.height = 20;
				}
			}
			else
			{
				if(!_input.multiline)
				{
					_input.multiline = true;
					_input.wordWrap = true;
					_input.x = 0;
					_input.y = 0;
					_input.width = _width;
					_input.height = _height;
					_privateTargetView.visible = false;
					_input.autoSize = TextFieldAutoSize.LEFT;
				}
			}
		}
		
		public function get channelType():int
		{
			return _channelType;
		}
		
		private function inputHandler(event:TextEvent):void
		{
			if(event.text.indexOf("\n")!=-1)
			{
				if(_input.length>0)
				{
					sendTalk();
				}
				
				event.preventDefault();
			}
			
			_currentInputText = event.text;
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			_beginIndex = _input.selectionBeginIndex;
			_endIndex = _input.selectionEndIndex;
			_keyCode = event.keyCode;
			_currentSelectedText = _input.selectedText;
			
			if(!_input.multiline && _keyCode == Keyboard.ENTER && _input.length > 0)
			{
				sendTalk();
			}
		}
		
		private var lastTalkTime:int = 0;
		private var lastWoldTalkTime:int = 0;		
		public function sendTalk():void//要根据当前频道来
		{
			if(!StringUtil.trim(inputText))
				return;
			
			if(channelType == MessageCfg.CHANNEL_FAMILY)
			{
				//提示以后会改
				if(SchoolDataManager.getInstance().schoolBaseData.schoolId == 0)
				{
					Alert.message(StringConst.CHAT_PROMPT_FAMILY);
					return;
				}
			}
			if(channelType == MessageCfg.CHANNEL_TEAM)
			{
				//提示以后会改
				if(!TeamDataManager.instance.hasTeam)
				{
					Alert.message(StringConst.CHAT_PROMPT_TEAM);
					return;
				}
			}
			
			if(channelType == MessageCfg.CHANNEL_WOLD_SUPER)
			{
				var num:int = BagDataManager.instance.getItemNumByType(ItemType.LOUD_SPEAK);
				if(num == 0)
				{
					Alert.message(StringConst.CHAT_PROMPT_LOUD);
					return;
				}
			}
			
			if(channelType == MessageCfg.CHANNEL_PRIVATE)
			{
				if(RoleDataManager.instance.lv<30)
				{
					Alert.message(StringConst.CHAT_PROMPT_PRIVATE_LV);
					return;
				}
			}
			
			if(channelType == MessageCfg.CHANNEL_WOLD)
			{
				if(RoleDataManager.instance.lv<50)
				{
					Alert.message(StringConst.CHAT_PROMPT_WORLD_LV);
					return;
				}
			}
			
			if(ChatDataManager.instance.checkCmd(inputText))
			{
				inputText = "";
				return;
			}
			
			var curTime:int = getTimer();
			if(channelType == MessageCfg.CHANNEL_WOLD)
			{
				if(lastWoldTalkTime != 0 && curTime - lastWoldTalkTime < 60000)
				{
					Alert.message(StringConst.CHAT_PROMPT_TOO_FAST_SYSTEM);
					return;
				}
				else
				{
					lastWoldTalkTime = curTime;
				}
			}
			else
			{
				if(lastTalkTime != 0 && curTime - lastTalkTime < 1000)
				{
					Alert.message(StringConst.CHAT_PROMPT_TOO_FAST);
					return;
				}
				else
				{
					lastTalkTime = curTime;
				}
			}
			
			var style:String = "style{} ";
			
			if(_inputLinkWords && _inputLinkWords.length>0)
			{
				var equips:Array = [];
				var inputWords:Vector.<LinkWord> = _inputLinkWords;
				var head:String = "";
				for each(var word:LinkWord in inputWords)
				{
					if(word.type == 1)
					{
						var data:Array = LinkWord.splitData(word.data);
						equips.push(data[0]);
						equips.push(data[1]);
					}
					if(head == "")
					{
						head = "head{"+word.stringify()
					}
					else
					{
						head+= ","+word.stringify();
					}
					
				}
				
				head += "} ";
				
				var args:Array;
				
				if(channelType == MessageCfg.CHANNEL_PRIVATE)
				{
					if(_privateTarget)
					{
						args = [_privateTarget.sid,_privateTarget.cid,style+head+inputText,equips.length/2];
						args = args.concat(equips);
						ChatDataManager.instance.sendPrivateTalk.apply(null,args);
					}
					else
					{
						//提示以后会改
						Panel1BtnPromptData.strName = StringConst.PROMPT_PANEL_0005;
						Panel1BtnPromptData.strContent = StringConst.CHAT_PROMPT_PRIVATE;
						Panel1BtnPromptData.strBtn = StringConst.PROMPT_PANEL_0003;
						PanelMediator.instance.switchPanel(PanelConst.TYPE_1BTN_PROMPT);
					}
				}
				else
				{
					args = [channelType,style+head+inputText,equips.length/2];
					args = args.concat(equips);
					ChatDataManager.instance.sendPublicTalk.apply(null,args);
				}
				
				
				_inputLinkWords = null;
				
			}
			else
			{
				if(channelType == MessageCfg.CHANNEL_PRIVATE)
				{
					if(_privateTarget)
					{
						ChatDataManager.instance.sendPrivateTalk(_privateTarget.sid,_privateTarget.cid,style+"head{} "+inputText,0);
					}
					else
					{
						//提示以后会改
						Panel1BtnPromptData.strName = StringConst.PROMPT_PANEL_0005;
						Panel1BtnPromptData.strContent = StringConst.CHAT_PROMPT_PRIVATE;
						Panel1BtnPromptData.strBtn = StringConst.PROMPT_PANEL_0003;
						PanelMediator.instance.switchPanel(PanelConst.TYPE_1BTN_PROMPT);
					}
				}
				else
				{
					ChatDataManager.instance.sendPublicTalk(channelType,style+"head{} "+inputText,0);
				}
			}
			inputText = "";
		}
		
		/**
		 * @param type 0 txt 1 equip
		 */
		public function appendItem(value:String,type:int = 0):void
		{
			if(_input)
			{
				if(type == LinkWord.TYPE_TXT)
				{
					_input.appendText(value as String);
				}
				else
				{
					if(!_inputLinkWords)
					{
						_inputLinkWords = new Vector.<LinkWord>();
					}
					
					var wd:LinkWord = LinkWord.createLinkWord(type);
					wd.caretIndexBegin = _input.text.length;
					wd.type = type;
					wd.data = value;
					var des:String = wd.getDescription();
					wd.caretIndexEnd = wd.caretIndexBegin + des.length;
					_input.appendText(des);
					
					if(checkTextLength(des.length))
						_inputLinkWords.push(wd);
					
				}
				_input.setSelection(_input.text.length,_input.text.length);
			}
		}
		
		public function get isFocus():Boolean
		{
			if(_input && _input.stage && _input.stage.focus === _input)
			{
				return true; 
			}
			
			return false;
		}
		
		/**
		 * 判断</br>
		 * 1.LinkWord 是否需要删除</br>
		 * 2.LinkWord 中的caretIndex 是否需要改变</br>
		 */
		private function checkLinkWordsChange(startIndex:int,delNum:int,addNum:int):void
		{
			
			if(_inputLinkWords && _inputLinkWords.length>0)
			{
				var discardIndexs:Array = [];
				var changeLen:int = addNum - delNum;
				var index:int = 0;
				for(index = 0;index < _inputLinkWords.length; ++index)
				{
					var word:LinkWord = _inputLinkWords[index];
					
					var beginIndex:int = startIndex;
					var endIndex:int = startIndex+delNum;
					
					//1需要删除的 （输入增加的情况）
					if(delNum == 0 && beginIndex > word.caretIndexBegin && beginIndex < word.caretIndexEnd)
					{
						discardIndexs.push(index);
					}
					//1需要删除的 （输入删除的情况）
					else if(word.caretIndexBegin >= beginIndex && word.caretIndexBegin < endIndex 
						|| word.caretIndexEnd > beginIndex && word.caretIndexEnd <= endIndex)
					{
						discardIndexs.push(index);
					}
					//2需要改变的
					else if(word.caretIndexBegin >= beginIndex)
					{
						word.caretIndexBegin += changeLen;
						word.caretIndexEnd += changeLen;
					}
				}
				
				for(index = discardIndexs.length-1; index >= 0; --index)
				{
					_inputLinkWords.splice(discardIndexs[index],1);
				}
			}
		}
		
		public function get caretIndex():int
		{
			return _input.caretIndex;
		}
		
		public function insertText(index:int,text:String):void
		{
			if(index<0)
			{
				index = 0;
			}
			
			if(index>_input.length)
			{
				index = _input.length;
			}
			
			var frontTxt:String = _input.text.slice(0,index);
			var backTxt:String = _input.text.slice(index,_input.text.length);
			frontTxt += text;
			_input.text = frontTxt + backTxt;
			setSelection(frontTxt.length,frontTxt.length);
			
			if(checkTextLength(text.length,frontTxt.length))
			{
				checkLinkWordsChange(index,0,text.length);
			}
			
			setFocus();
		}
		
		private function textChangeHandler(e:Event):void
		{
			
			if(_beginIndex == _endIndex)
			{
				if(_keyCode == Keyboard.BACKSPACE)
				{
					checkLinkWordsChange(_input.caretIndex,1,0);
				}
				else if(_keyCode == Keyboard.DELETE)
				{
					checkLinkWordsChange(_input.caretIndex,1,0);
				}
				else
				{
					if(checkTextLength(_currentInputText.length,_input.caretIndex))
					{
						checkLinkWordsChange(_input.caretIndex - _currentInputText.length,0,_currentInputText.length);
					}
				}
			}
			else
			{
				var plusNum:int = _currentInputText.length - _endIndex + _beginIndex;
				
				if(plusNum<0 || plusNum > 0 && checkTextLength(_currentInputText.length,_input.caretIndex,_currentSelectedText))
				{
					checkLinkWordsChange(_input.caretIndex,_endIndex - _beginIndex,_currentInputText.length);
				}
				
			}
			
			_currentInputText = "";
			_currentSelectedText = "";
		}
		
		/**
		 * 判断新输入的字符是否超出长度
		 * 
		
		 * 
		 * @param currentIndex index+1 已经增加后的光标位置
		 * 
		 * @return true:符合长度 false:超出长度
		 */
		private function checkTextLength(addedNum:int = 1,currentIndex:int = -1,lastSelectedText:String = ""):Boolean
		{
			if(_input.multiline && _input.numLines>2 || !_input.multiline && _input.length>_onelineMaxChar)//先暂时两行 三行要加滚动 没时间
			{
//				if(currentIndex == -1)
//				{
//					currentIndex = _input.text.length;
//				}
//				
//				var preText:String = _input.text.slice(0,currentIndex-addedNum);
//				preText += lastSelectedText;
//				
//				if(currentIndex<_input.text.length)
//				{
//					preText += _input.text.slice(currentIndex,_input.text.length);
//				}
//				 _input.text = preText;
				_input.text = InputHandler.fixTextLength(_input.text,addedNum,currentIndex,lastSelectedText);
				
				return false;
			}
			else
			{
				return true;
			}
		}
		
//		public static function fixText(txt:String,addedNum:int,currentIndex:int = -1,lastSelectedText:String = ""):String
//		{
//			if(currentIndex == -1)
//			{
//				currentIndex = txt.length;
//			}
//			
//			var preText:String = txt.slice(0,currentIndex-addedNum);
//			preText += lastSelectedText;
//			
//			if(currentIndex < txt.length)
//			{
//				preText += txt.slice(currentIndex,txt.length);
//			}
//			
//			return preText;
//		}
		
		public function setSize(x:Number,y:Number,width:Number,height:Number):void
		{
			_width = width;
			_height = height;
			_input.width = _width;
			_input.height = _height;
			_privateTargetView.width = _width;
			_privateTargetView.height = 20;
			_ctner.x = x;
			_ctner.y = y;
			_ctner.graphics.clear();
			_ctner.graphics.beginFill(0xff0000,0);
			_ctner.graphics.drawRect(0,0,_width,_height);
			_ctner.graphics.endFill();
		}
		
		
		public function setSelection(beginIndex:int,endIndex:int):void
		{
			_input.setSelection(beginIndex,endIndex);
		}
		
		public function setFocus(value:Boolean = true):void
		{
			if(_input.stage)
			{
				if(value)
				{
					_input.stage.focus = _input;
				}
				else
				{
					_input.stage.focus = _input.stage;
				}
			}
		}
		
		public function get view():DisplayObject
		{
			return _ctner;
		}
		
		
		public function set inputText(value:String):void
		{
			_input.text = value ? value : "";
		}
		
		public function get inputText():String
		{
			return _input.text;
		}
		
		
	}
}