package com.view.gameWindow.common
{
	import com.greensock.TweenLite;
	import com.model.business.fileService.constants.ResourcePathConstants;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.events.Request;
	
	/**
	 * @eventType mx.events.Request.Request
	 */
	[Event(name="select", type="flash.events.Event")]
	/**
	 * 简陋的……</br>
	 * 
	 * 注意setStyle
	 * 
	 * @event Event.SELECT
	 * @author wqhk
	 * 2014-9-17
	 */
	public class Accordion extends Sprite
	{
		private var _headerFactory:McFactory;
		private var _headerList:Array;
		private var _contentList:Array;
		private var _headerStates:Array;
		private var _changeStateCallback:Function;
		
		public var onlyOneSelected:Boolean = false;
		public var selectHandler:Function;
		
		public function Accordion()
		{
			super();
			
			_headerList = [];
			_contentList = [];
			_headerStates = [];
		}
		
		public function get num():int
		{
			return _headerList.length;
		}
		
		public function destroy():void
		{
			_headerFactory = null;
			_changeStateCallback = null;
			selectHandler = null;
			
			clear();
		}
		
		public function clear():void
		{
			if(updatePosTime)
			{
				clearTimeout(updatePosTime);
				updatePosTime = 0;
			}
			
			_headerList = [];
			_contentList = [];
			_headerStates = [];
			while(numChildren)
			{
				removeChildAt(0);
			}
		}
		
		/**
		 * 
		 * @param headerClass 需要name为“txt”的Textfiled控件
		 * @param changeStateCallback  function f(mc:MovieClip,state:int):void
		 * @param headerCallback {propertyName:callback,...}
		 * 
		 */
		public function setStyle(headerClass:Class,changeStateCallback:Function,headerCallback:Object):void
		{
			_headerFactory = new McFactory(headerClass);
			_headerFactory.prefixUrl = ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD;
			_headerFactory.callbacks = headerCallback;
			_changeStateCallback = changeStateCallback;
		}
		
		public function setContentLabel(index:int,value:String):void
		{
			_headerList[index].txt.htmlText = value;
		}
		
		public function addContent(index:int,label:String,content:DisplayObject):void
		{
			var header:MovieClip = _headerFactory.create();
			
			header.txt.text = label;
			header.addEventListener(MouseEvent.CLICK,headerClickHandler,false,0,true);
			
			addChild(header);
			addChild(content);
			
			if(index>_headerList.length)
			{
				index = _headerList.length;
			}
			_headerList.splice(index,0,header);
			_contentList.splice(index,0,content);
			
			if(onlyOneSelected)
			{
				if(_headerStates.length == 0)
				{
					_headerStates.splice(index,0,1);
				}
				else
				{
					_headerStates.splice(index,0,0);
				}
			}
			else
			{
				_headerStates.splice(index,0,1);
			}
			
			
			updatePos();
		}
		
		private function headerClickHandler(e:MouseEvent):void
		{
			//header//
			var target:Object = e.currentTarget;
			var index:int = _headerList.indexOf(target);
			
			var state:int = _headerStates[index];
			
			changeState(index,state == 1 ? 0 : 1);
			
			updatePos();
		}
		
		private function updateHeaderState(index:int):void
		{
			if(_changeStateCallback != null)
			{
				_changeStateCallback(_headerList[index],_headerStates[index]);
			}
			
			if(selectHandler != null)
			{
				var state:int = _headerStates[index];
				if(state)
				{
					dispatchEvent(new Request(Event.SELECT,false,false,index));
				}
			}
		}
		
		public function updateHeaderStateAll():void
		{
			for(var i:int = 0; i < _headerStates.length; ++i)
			{
				updateHeaderState(i);
			}
		}
		
		private function changeState(index:int,state:int):void
		{
			if(onlyOneSelected)
			{
				for(var i:int = 0; i < _headerStates.length;++i)
				{
					if(index != i)
					{
						_headerStates[i] = 0;
					}
					else
					{
						_headerStates[i] = 1;
					}
					
					updateHeaderState(i);
				}
			}
			else
			{
				_headerStates[index] = state;
				updateHeaderState(index);
			}
		}
		
		public function updatePos():void
		{
			var y:int = 0;
			for(var i:int = 0;i < _headerStates.length;++i)
			{
				var state:int = _headerStates[i];
				var header:DisplayObject = _headerList[i];
				var content:DisplayObject = _contentList[i];
				
//				header.y = y;
				//header y
				TweenLite.to(header,0.25,{y:y});
					
				y+=header.height;
				
				if(state)
				{
//					content.y = y;
					//content y
					TweenLite.to(content,0.25,{y:y});
					y+=content.height;
					if(!content.parent)
					{
						content.alpha = 0;
						addChildAt(content,0);
						//alhpa
						TweenLite.to(content,1,{alpha:1});
					}
				}
				else
				{
					if(content.parent)
					{
						removeChild(content);
					}
				}
			}
			
			if(updatePosTime)
			{
				clearTimeout(updatePosTime);
				updatePosTime = 0;
			}
			updatePosTime = setTimeout(updatePosComplete,300);
		}
		
		private var updatePosTime:int = 0;
		
		private function updatePosComplete():void
		{
			if(updatePosTime)
			{
				clearTimeout(updatePosTime);
				updatePosTime = 0;
			}
			this.dispatchEvent(new Event(Event.CHANGE,false,false));
		}
		
		public function foldContent(index:int,isShow:Boolean):void
		{
			changeState(index,isShow?1:0);
			
			updatePos();
		}
		
		public function removeContent(index:int):void
		{
			if(_headerList.length == 0)
			{
				return;
			}
			
			if(index>=_headerList.length)
			{
				index = _headerList.length - 1;
			}
			
			var header:DisplayObject = _headerList[index];
			var content:DisplayObject = _contentList[index];
			
			if(header.parent)
			{
				header.parent.removeChild(header);
			}
			
			if(content.parent)
			{
				content.parent.removeChild(content);
			}
			
			_headerList.splice(index,1);
			_contentList.splice(index,1);
			_headerStates.splice(index,1);
			
			updatePos();
		}
	}
}