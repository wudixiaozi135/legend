package com.view.gameWindow.mainUi.subuis.chatframe
{
	import com.core.bind_t;
	import com.greensock.TweenLite;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.mainUi.MainUi;
	import com.view.gameWindow.mainUi.subclass.McChatFrame;
	import com.view.gameWindow.mainUi.subuis.chatframe.msg.LinkWord;
	import com.view.gameWindow.mainUi.subuis.chatframe.msg.LinkWordView;
	import com.view.gameWindow.mainUi.subuis.chatframe.msg.Message;
	import com.view.gameWindow.panel.panels.menus.ChatChannelMenu;
	import com.view.gameWindow.tips.toolTip.EquipBaseTip;
	import com.view.gameWindow.tips.toolTip.ItemBaseTip;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.McAnimControl;
	import com.view.gameWindow.util.scrollBar.IScrollee;
	import com.view.gameWindow.util.scrollBar.ScrollBar;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.events.Request;
	
	
	public class ChatFrame extends MainUi implements IScrollee,IChatFrame,IObserver
	{
		public static const OUTPUT_WIDTH:int = 310;
		public static const OUTPUT_HEIGHT:int = 185;
		public static const OUTPUT_HEIGHT_MAX:int = 400;
		public static const ALPHA:Number = 0.15;
		public static const TWEEN_TIME:Number = 1;
		private var _scrollBar:ScrollBar;
		private var _scrollRect:Rectangle;
//		private var _chatFramMouseEvent:ChatFrameMouseEventHandle;
		private var _output:IChatOutput;//输出框
		private var _input:IChatInput;
		private var _channelType:int;
		private var _visionTween:TweenLite;
		private var _isBgShown:Boolean;
		private var _outputLoud:IChatOutput;//喇叭
		private var _mcAnimCtl:McAnimControl;//控制表情的动画帧数
		private var _channelMenu:ChatChannelMenu;//频道
		private var _expressionMenu:ExpressionMenu;//表情
		
		private var _equipBaseTip:EquipBaseTip;
		private var _itemBaseTip:ItemBaseTip;
		
		public function get theY():int
		{
			return y;
		}
		
		public function ChatFrame()
		{
			super();
			
			_mcAnimCtl = new McAnimControl(24);
		}
		
		public function get view():DisplayObjectContainer
		{
			return this
		}
		
		public function showBg():void
		{
			if(_isBgShown)
			{
				return;
			}
			
//			if(_visionTween && _visionTween.isActive())
			if(_visionTween)
			{
				_visionTween.kill();
			}
			
			_visionTween = TweenLite.to(_skin,TWEEN_TIME,{alpha:1});
			_isBgShown = true;
			
			
			stage.addEventListener(MouseEvent.CLICK,stageClickHandler);
		}
		
		public function hideBg():void
		{
			if(!_isBgShown)
			{
				return;
			}
			
//			if(_visionTween && _visionTween.isActive())
			if(_visionTween )
			{
				_visionTween.kill();
			}
			_visionTween = TweenLite.to(_skin,TWEEN_TIME,{alpha:ALPHA});
			_isBgShown = false;
			
			stage.removeEventListener(MouseEvent.CLICK,stageClickHandler);
		}
		
		
		/**由观察者在需要时调用*/
		public function update(proc:int = 0):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_PUBLIC_CHAT:
				case GameServiceConstants.SM_PRIVATE_CHAT:
					traverseTalk();
					break;
			}
		}
		
		private function traverseTalk():void
		{
//			while(ChatDataManager.instance.updateIndex<ChatDataManager.instance.chatList.length-1)
//			{
//				++ChatDataManager.instance.updateIndex;
//				var chatData:ChatData = 
//					ChatDataManager.instance.chatList[ChatDataManager.instance.updateIndex];
			
			var chatList:Vector.<ChatData> = ChatDataManager.instance.chatList;
			while(chatList.length)
			{
				var chatData:ChatData = chatList.shift();
				if(chatData.channel == MessageCfg.CHANNEL_WOLD 
					|| chatData.channel == MessageCfg.CHANNEL_AREA
					|| chatData.channel == MessageCfg.CHANNEL_WOLD_SUPER
					|| chatData.channel == MessageCfg.CHANNEL_FAMILY
					|| chatData.channel == MessageCfg.CHANNEL_TEAM)
				{
					if(chatData.sid)
					{
						pushOutputData("/"+chatData.channel+" ["+LinkWord.joinData(chatData.name,chatData.sid,chatData.cid,chatData.sex)+"] "+chatData.buff);
					}
					else
					{
						pushOutputData("/"+chatData.channel+" "+chatData.buff,chatData.color);
					}
				}
				else if(chatData.channel == MessageCfg.CHANNEL_PRIVATE)
				{
					pushOutputData("/"+chatData.channel+" ["+LinkWord.joinData(chatData.name,chatData.sid,chatData.cid,chatData.sex)+"] [" 
							+LinkWord.joinData(chatData.toName,chatData.toSid,chatData.toCid,chatData.toSex)+"] "+chatData.buff);
				}
				else if(chatData.channel == MessageCfg.CHANNEL_SYSTEM)
				{
					pushOutputData("/"+chatData.channel+" "+chatData.buff,chatData.color);
				}
			}
		}
		
		private function startTalk():void
		{
			ChatDataManager.instance.sendSystemNotice(StringConst.CHAT_WELCOME,0xfff100);
			ChatDataManager.instance.sendSystemNotice(StringConst.CHAT_GAME_WARNING,0xff002c);
		}
		
		public function get channelType():int
		{
			return _channelType;
		}
		
		public function changeChannel(type:int):void
		{
			_channelType = type;
			if(_output)
			{
				_output.changeChannel(type);
				changeInputChannel(type);
				
				scrollToBottom();
			}
		}
		
		public function changeInputChannel(type:int):void
		{
			if(type == MessageCfg.CHANNEL_SYSTEM)
			{
				return;
			}
			var mcChatFrame:McChatFrame = _skin as McChatFrame;
			if(type == MessageCfg.CHANNEL_PRIVATE)
			{
//				mcChatFrame.btnAdd.visible = true;
			}else
			{
				mcChatFrame.btnAdd.visible = false;
			}
			
			
			var txt:* = mcChatFrame.btn_07.txt;
			
			txt.text = MessageCfg.getChannelName(type);
			
			if(_input)
			{
				_input.channelType = type;
				_input.setFocus();
			}
		}
		
		override public function initView():void
		{
//			_chatFramMouseEvent = new ChatFrameMouseEventHandle();
			_skin = new McChatFrame();
			
			_skin.alpha = ALPHA;
			addChild(_skin);
			
//			_chatFramMouseEvent.addEvent(_skin as McChatFrame);
			
			addEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
			addEventListener(MouseEvent.CLICK,clickHandle);
//			McChatFrame(_skin).mcHorn.visible = false;
			McChatFrame(_skin).btnAdd.visible = false;
			McChatFrame(_skin).btnDrag.alpha = 0;
			McChatFrame(_skin).mcbig.visible = true;
			McChatFrame(_skin).mcsmall.visible = false;
			hideBg();
			
			McChatFrame(_skin).btnDrag.buttonMode = true;
			McChatFrame(_skin).btnDrag.addEventListener(MouseEvent.MOUSE_DOWN,dragMouseDownHandler);
			McChatFrame(_skin).btnDrag.addEventListener(MouseEvent.MOUSE_UP,dragMouseUpHandler);
			McChatFrame(_skin).btnDrag.addEventListener(MouseEvent.CLICK,autoMove);
			
//			super.initView();
			
			var rsrLoader:RsrLoader = new RsrLoader();
			addCallBack(rsrLoader);
			rsrLoader.load(_skin,ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD,true);
			
			ToolTipManager.getInstance().attachByTipVO(McChatFrame(_skin).btnDrag,ToolTipConst.TEXT_TIP,StringConst.BTNTIPS_0025);
		}
		
		public function showTip(type:int,data:Object):void
		{
			if(type == SlotType.IT_EQUIP)
			{
				hideTip();
				if(_equipBaseTip)
				{
					_equipBaseTip.dispose();
				}
				_equipBaseTip = new EquipBaseTip(ToolTipConst.EQUIP_BASE_TIP);
				_equipBaseTip.setData(data);
				addChild(_equipBaseTip);
				_equipBaseTip.x = 335;
				_equipBaseTip.y = -230  - (_equipBaseTip.height - 325);
			}
			else if(type == SlotType.IT_ITEM)
			{
				hideTip();
				if(_itemBaseTip)
				{
					_itemBaseTip.dispose();
				}
				_itemBaseTip = new ItemBaseTip();
				_itemBaseTip.setData(data);
				addChild(_itemBaseTip);
				_itemBaseTip.x = 335;
				_itemBaseTip.y = -230 - (_itemBaseTip.height - 325);
			}
			this.parent.parent.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			if((_equipBaseTip &&(contains(_equipBaseTip)) || (_itemBaseTip && contains(_itemBaseTip))))
			{
				if(event.target is LinkWordView)
				{
					
				}
				else
				{
					hideTip();
				}
			}
		}
		
		public function hideTip():void
		{
			if(_equipBaseTip && contains(_equipBaseTip))
			{
				removeChild(_equipBaseTip);
			}
			if(_itemBaseTip && contains(_itemBaseTip))
			{
				removeChild(_itemBaseTip);
			}
			if(this.parent)
			{
				this.parent.parent.removeEventListener(MouseEvent.CLICK,clickHandler);
			}
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			var mc:MovieClip = evt.target as MovieClip;
			var lastBtn:MovieClip;
			
			switch(mc)
			{
				case _skin.btn_00:
					initBtn();
					_skin.btn_00.selected = true;
					changeChannel(getChannelByIndex(0));
					break;
				case _skin.btn_01:
					initBtn();
					_skin.btn_01.selected = true;
					changeChannel(getChannelByIndex(1));
					break;
				case _skin.btn_02:
					initBtn();
					_skin.btn_02.selected = true;
					changeChannel(getChannelByIndex(2));
					break;
				case _skin.btn_03:
					initBtn();
					_skin.btn_03.selected = true;
					changeChannel(getChannelByIndex(3));
					break;
				case _skin.btn_04:
					initBtn();
					_skin.btn_04.selected = true;
					changeChannel(getChannelByIndex(4));
					break;
				case _skin.btn_05:
					initBtn();
					_skin.btn_05.selected = true;
					changeChannel(getChannelByIndex(5));
					break;
				case _skin.btn_06:
					initBtn();
					_skin.btn_06.selected = true;
					changeChannel(getChannelByIndex(6));
					break;
				case _skin.btn_07:
					evt.stopImmediatePropagation();
					if(!_channelMenu)
					{
						var pos:Point =/* _skin.localToGlobal(*/new Point(_skin.btn_07.x,_skin.btn_07.y)/*)*/;
						_channelMenu = new ChatChannelMenu();
						_channelMenu.initView();
						addChild(_channelMenu);
						_channelMenu.x = pos.x;
						_channelMenu.y = pos.y - _channelMenu.height;
						_channelMenu.addEventListener(Event.SELECT,menuChangeHandler);
					}
					break;
				case _skin.btn_08:
					input.sendTalk();
					break;
				case _skin.btn_express:
					evt.stopImmediatePropagation();
					showExpression();
					break;
				case _skin.btn_fold:
					showPanels(!_skin.btn_fold.selected);
					break;
				default:
					break;	
			}
			
		}
		
		private function showPanels(value:Boolean):void
		{
			_skin.visible = value;
			_output.view.visible = value;
			
			if(value)
			{
				_skin.addChild(_skin.btn_fold);
			}
			else
			{
				addChild(_skin.btn_fold);
			}
		}
		
		private function expMenuChangeHandler(e:Request):void
		{
			var type:int = int(e.value);
			
			if(type != -1)
			{
				_input.insertText(_input.caretIndex,"#0"+ (type>9 ? type : "0"+type)); 
			}
			
			_expressionMenu.destroy();
			if(_expressionMenu.parent)
			{
				_expressionMenu.parent.removeChild(_expressionMenu);
			}
			
			_expressionMenu.removeEventListener(Event.CHANGE,expMenuChangeHandler);
			_expressionMenu = null;
		}
		
		private function menuChangeHandler(e:Request):void
		{
			var type:int = int(e.value);
			if(type != -1)
			{
				changeInputChannel(type);
			}
			
			_channelMenu.destroy();
			if(_channelMenu.parent)
			{
				_channelMenu.parent.removeChild(_channelMenu);
			}
			
			_channelMenu.removeEventListener(Event.CHANGE,menuChangeHandler);
			_channelMenu = null;
		}
		
		private function initBtn():void
		{
			_skin.btn_00.selected = false;
			_skin.btn_01.selected = false;
			_skin.btn_02.selected = false;
			_skin.btn_03.selected = false;
			_skin.btn_04.selected = false;
			_skin.btn_05.selected = false;
			_skin.btn_06.selected = false;
		}
		
		public function setInputFocus():void
		{
			_isMouseOut = -1;
			showBg();
			_input.setFocus(true);
		}
		
		
		private var _isMouseOut:int = -1;
		private function rollOverHandler(e:MouseEvent):void
		{
			showBg();
			_isMouseOut = 0;
		}
		
		
		private function rollOutHandler(e:MouseEvent):void
		{
			if(!input.isFocus)
			{
				hideBg();
			}
			
			_isMouseOut = 1;
		}
		
		private function stageClickHandler(e:MouseEvent):void
		{
			if(_isMouseOut == -1)
			{
				_isMouseOut = 1;
			}
			else if(_isMouseOut == 1)
			{
				stage.removeEventListener(MouseEvent.CLICK,stageClickHandler);
				hideBg();
//				hideTip();
			}
			/*if(e.target != _equipBaseTip && e.target != _itemBaseTip)
			{
				hideTip();
			}*/
		}
		
		private var _changeHeight:Number;
		private var lastDragMouseY:Number;
		private var dragStopListener:Boolean;
		private function dragMouseDownHandler(e:MouseEvent):void
		{
			if(_isMoving)
			{
				return;
			}
			var drag:DisplayObject = e.currentTarget as DisplayObject;
			
			lastDragMouseY = e.stageY;
			trace("lastDragMouseY"+lastDragMouseY);
			
			dragStopListener = false;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,dragMouseMoveHandler);
		}
		
		private function autoMove(e:MouseEvent):void
		{
			var mc:McChatFrame = McChatFrame(_skin);
			if(mc.mcbig.visible)
				_changeHeight = 5;
			else
				_changeHeight = -5;
			stage.addEventListener(Event.ENTER_FRAME,onEnter);
			_isMoving = true;
		}
		
		private var _isMoving:Boolean = false;
		
		protected function onEnter(event:Event):void
		{
			// TODO Auto-generated method stub
			
			var newHeight:Number = _scrollRect.height + _changeHeight;
			if(newHeight >= OUTPUT_HEIGHT && newHeight <= OUTPUT_HEIGHT_MAX)
			{
				changeHeight(newHeight);
			}else{
				var mc:McChatFrame = McChatFrame(_skin);
				mc.mcbig.visible = !mc.mcbig.visible;
				mc.mcsmall.visible = !mc.mcsmall.visible;
				stage.removeEventListener(Event.ENTER_FRAME,onEnter);
				_isMoving = false;
			}
		}
		
		private function dragMouseMoveHandler(e:MouseEvent):void
		{
//			trace(e.stageY);
			if(Math.abs(lastDragMouseY - e.stageY)>5)
			{
				var newHeight:Number = _scrollRect.height + lastDragMouseY - e.stageY;
				trace(newHeight);
				if(newHeight >= OUTPUT_HEIGHT && newHeight <= OUTPUT_HEIGHT_MAX)
				{
					changeHeight(newHeight);
					lastDragMouseY = e.stageY;
				}else{
					var mc:McChatFrame = McChatFrame(_skin);
					if(newHeight>=OUTPUT_HEIGHT_MAX){
						mc.mcbig.visible = false;
						mc.mcsmall.visible = true;
					}else if(newHeight<=OUTPUT_HEIGHT){
						mc.mcbig.visible = true;
						mc.mcsmall.visible = false;
					}
				}
			}
			
			if(!dragStopListener)
			{
				dragStopListener = true;
				stage.addEventListener(MouseEvent.MOUSE_UP,dragMouseUpHandler);
			}
		}
		
		private function dragMouseUpHandler(e:MouseEvent):void
		{
			dragStopListener = true;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,dragMouseMoveHandler);
		}
		
		public function changeHeight(value:int):void
		{
			var mc:McChatFrame = McChatFrame(_skin);
			
			var oldY:Number = mc.mcOutputBg.y;
			var oldHeight:Number = mc.mcOutputBg.height;
			
			var changeValue:Number = value - oldHeight;
			
			mc.mcOutputBg.y -= changeValue;
//			mc.mcTopBg.y -= changeValue;
//			mc.mcDrag.y -= changeValue;
			mc.btnDrag.y -= changeValue;
			mc.mcsmall.y -= changeValue;
			mc.mcbig.y -= changeValue;
			output.view.y -= changeValue;
			mc.mcScrollBar.y -= changeValue;
			_outputLoud.view.y -= changeValue;
			
			mc.mcOutputBg.height = value;
			_scrollRect.height = value;
			output.view.scrollRect = _scrollRect;
			
			_scrollBar.resetHeight(value);
			scrollToBottom();
		}
		
		public function get output():IChatOutput
		{
			return _output;
		}
		
		public function set output(value:IChatOutput):void
		{
			_output = value;
			
			var panel:DisplayObject = value.view;
			
			panel.y = _skin.mcScrollBar.y;
			
			if(!_scrollRect)
				_scrollRect = new Rectangle(0,0,OUTPUT_WIDTH,OUTPUT_HEIGHT);
			panel.scrollRect = _scrollRect;
			panel.x = 23;
			
			addChild(panel);
			
			//test
//			_chatFramMouseEvent.chatFrame = this;
			
			
//			ChatDataManager.instance.attach(this);
		}
		
		public function set input(value:IChatInput):void
		{
			_input = value;
			_input.setSize(_skin.mcInput.x,_skin.mcInput.y,_skin.mcInput.width,_skin.mcInput.height);
			_skin.addChild(_input.view);
			var mc:MovieClip = McChatFrame(_skin).btnAdd;
			McChatFrame(_skin).addChild(McChatFrame(_skin).removeChild(mc));
			mc.visible = false;
		}
		
		public function get input():IChatInput
		{
			return _input;
		}
		
		public function set outputLoud(value:IChatOutput):void
		{
			_outputLoud = value;
			_outputLoud.changeChannel(MessageCfg.CHANNEL_WOLD_SUPER);
			
			var mc:McChatFrame = McChatFrame(_skin);
			addChild(_outputLoud.view);
			
		}
		
		//
		private function pushOutputData(data:String,color:uint = 0):void
		{
			if(_output)
			{
				_output.pushData(data,color);
				
				scrollToBottom();//这个以后要改 并不是所有情况都底部
			}
			
//			if(_outputLoud)
//			{
//				_outputLoud.pushData(data,color);//要改 不然每次生成两个消息
//			}
		}
		
		
		public function scrollToBottom():void
		{
			_scrollBar.resetScroll();
			_scrollBar.scrollTo(contentHeight - scrollRectHeight,true);
		}
		
		private static var CHANNELS:Array = [MessageCfg.CHANNEL_SYSTEM,MessageCfg.CHANNEL_AREA,
			MessageCfg.CHANNEL_TEAM,MessageCfg.CHANNEL_FAMILY,
			MessageCfg.CHANNEL_WOLD,MessageCfg.CHANNEL_PRIVATE,
			MessageCfg.CHANNEL_WOLD_SUPER];
		
		public function getChannelByIndex(index:int):int
		{
			return CHANNELS[index];
		}
		
		public function getChannelName(index:int):String
		{
			return MessageCfg.getChannelName(getChannelByIndex(index));
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var _mcChatFrame:McChatFrame = _skin as McChatFrame;
			var _textFormat:TextFormat;
			var _txt:TextField;
			
			
//			rsrLoader.addCallBack(_mcChatFrame.mcDrag,function():void
//			{
//				_mcChatFrame.mcDrag.mouseEnabled = true;
//				_mcChatFrame.mcDrag.addEventListener(MouseEvent.MOUSE_DOWN,dragMouseDownHandler);
//			});
			rsrLoader.addCallBack(_mcChatFrame.btn_00,function():void
			{
				_txt = _mcChatFrame.btn_00.txt as TextField;
				_textFormat = _txt.defaultTextFormat;
				_mcChatFrame.btn_00.selected = true;
				_txt.text = getChannelName(0);
			});
			rsrLoader.addCallBack(_mcChatFrame.btn_01,function():void
			{
				_txt = _mcChatFrame.btn_01.txt as TextField;
				_mcChatFrame.btn_01.selected = false;
				_txt.text = getChannelName(1);
			});
			rsrLoader.addCallBack(_mcChatFrame.btn_02,function():void
			{
				_txt = _mcChatFrame.btn_02.txt as TextField;
				_mcChatFrame.btn_02.selected = false;
				_txt.text = getChannelName(2);
			});
			rsrLoader.addCallBack(_mcChatFrame.btn_03,function():void
			{
				_txt = _mcChatFrame.btn_03.txt as TextField;
				_mcChatFrame.btn_03.selected = false;
				_txt.text = getChannelName(3);
			});
			rsrLoader.addCallBack(_mcChatFrame.btn_04,function():void
			{
				_txt = _mcChatFrame.btn_04.txt as TextField;
				_mcChatFrame.btn_04.selected = false;
				_txt.text = getChannelName(4);
			});
			rsrLoader.addCallBack(_mcChatFrame.btn_05,function():void
			{
				_txt = _mcChatFrame.btn_05.txt as TextField;
				_mcChatFrame.btn_05.selected = false;
				_txt.text = getChannelName(5);
			});
			rsrLoader.addCallBack(_mcChatFrame.btn_06,function():void
			{
				_txt = _mcChatFrame.btn_06.txt as TextField;
				_mcChatFrame.btn_06.selected = false;
				_txt.text = getChannelName(6);
			});
			rsrLoader.addCallBack(_mcChatFrame.btn_07,function():void
			{
				_txt = _mcChatFrame.btn_07.txt as TextField;
//				_mcChatFrame.btn_07.selected = false;
				
				changeInputChannel(MessageCfg.CHANNEL_WOLD);
			});
//			rsrLoader.addCallBack(_mcChatFrame.btn_08,function():void
//			{
//				_txt = _mcChatFrame.btn_08.txt as TextField;
//				_txt.text = StringConst.CHAT_0008;
//			});
			
//			rsrLoader.addCallBack(_mcChatFrame.btn_00,function():void
//			{
//				_txt = _mcChatFrame.btn_00.txt as TextField;
//				_textFormat = _txt.defaultTextFormat;
//				_mcChatFrame.btn_00.selected = true;
//				_txt.text = StringConst.CHAT_0001;
//			});
			
			rsrLoader.addCallBack(_mcChatFrame.mcScrollBar,function (mc:MovieClip):void//滚动条资源加载完成后构造滚动条控制类
			{
				if(!_scrollBar)
				{
					_scrollBar = new ScrollBar(_skin.parent as IScrollee,mc);
					_scrollBar.resetHeight(OUTPUT_HEIGHT);
					
					_checkInit.push(true);
					_checkInit.call();
					
				}
			});
			
			rsrLoader.addCallBack(_mcChatFrame.expressPanel.exp,function(mc:MovieClip):void
			{
				_expressionGroup = mc;
				_expressionPanel = _expressionGroup.parent as MovieClip;
				var expNum:int = _expressionGroup.numChildren;
				var expList:Array = [];
				for(var expIndex:int = 0; expIndex < expNum; ++expIndex)
				{
					expList.push(_expressionGroup.getChildAt(expIndex));
				}
				
				_mcAnimCtl.push.apply(null,expList);
				
				_checkInit.push(true);
				_checkInit.call();
				
				_expressionGroup.parent.parent.removeChild(_expressionGroup.parent);
			});
			
			
//			rsrLoader.addCallBack(_mcChatFrame.btn_fold,function(mc:MovieClip):void
//			{
//				addChild(mc);
//			});
		}
		
		private var _checkInit:bind_t = new bind_t(CheckInitHandler);
		private var _expressionGroup:MovieClip;
		private var _expressionPanel:MovieClip;
		private function CheckInitHandler(...args):void
		{
			if(args.length == 2)
			{
				MessageCfg.initImg(imgInitComplete);
			}
		}
		
		private function showExpression():void
		{
			if(!_expressionMenu)
			{
				var pos:Point =/* _skin.localToGlobal(*/new Point(_skin.btn_express.x,_skin.btn_express.y)/*)*/;
				_expressionMenu = new ExpressionMenu(_expressionPanel);
				_expressionMenu.initView();
				addChild(_expressionMenu);
				_expressionMenu.x = pos.x;
				_expressionMenu.y = pos.y - _expressionMenu.height;
				_expressionMenu.addEventListener(Event.SELECT,expMenuChangeHandler);
			}
		}
		
		private var _inited:Boolean = false;
		
		private function imgInitComplete():void
		{
			_output.init(outputShowHandler);
			_output.setExpCreateFunc(createExp);
			_outputLoud.init(outputLoudShowHandler);
			
			startTalk();
			_inited = true;
			
			ChatDataManager.instance.attach(this);
			update(GameServiceConstants.SM_PUBLIC_CHAT);
		}
		
		private function createExp(index:int):DisplayObject
		{
			if(index<0)
			{
				return null;
			}
			else if(index >= _expressionGroup.numChildren)
			{
				return null;
			}
			
			var type:Class =  _expressionGroup.getDef(index);
			
			return new type();
		}
		
		private function outputShowHandler(ctner:DisplayObjectContainer,currentMsg:Message,lastMsg:Message):void
		{
			if(!lastMsg)
			{
				currentMsg.y = 0;
			}
			else
			{
				currentMsg.y = lastMsg.y + lastMsg.totalHeight + MessageCfg.LINE_SPACE;
			}
			ctner.addChild(currentMsg);
		}
		
		
		private var _msgLoud:Message = null;
		private var _loudTimeId:int = 0;
		private function outputLoudShowHandler(ctner:DisplayObjectContainer,currentMsg:Message,lastMsg:Message):void
		{
			if(lastMsg && lastMsg.parent)
			{
				lastMsg.parent.removeChild(lastMsg);
			}
			
			if(_loudTimeId != 0)
			{
				clearTimeout(_loudTimeId);
				_loudTimeId = 0;
			}
			var mc:McChatFrame = McChatFrame(_skin);
//			mc.mcHorn.visible = true;
//			currentMsg.y = mc.mcTopBg.y + int((mc.mcTopBg.height - currentMsg.totalHeight))/2;
//			currentMsg.x = mc.mcTopBg.x + 30;
			currentMsg.hideBg();
			
			ctner.addChild(currentMsg);
			
//			ctner.addChild(mc.mcHorn);
			
			_msgLoud = currentMsg;
			_loudTimeId = setTimeout(loudTimeOut,20*1000);
		}
		
		private function loudTimeOut():void
		{
			if(_msgLoud && _msgLoud.parent)
			{
				_msgLoud.parent.removeChild(_msgLoud);
				
			}
			
			var mc:McChatFrame = McChatFrame(_skin);
//			mc.mcHorn.visible = false;
		}
		
//		private function outputInitComplete():void
//		{
//			startTalk();
//			update(GameServiceConstants.SM_PUBLIC_CHAT);
//		}
		
		/**
		 * 
		 * @param pos 被滚动内容的scrollRect的y坐标
		 */		
		public function scrollTo(pos:int):void
		{
			_scrollRect.y = pos;
			_output.view.scrollRect = _scrollRect;
		}
		public function get contentHeight():int
		{
			return _output.getHeight();
		}
		
		public function get scrollRectHeight():int
		{
			return _scrollRect.height;
		}
		public function get scrollRectY():int
		{
			return _scrollRect.y;
		}
	}
}