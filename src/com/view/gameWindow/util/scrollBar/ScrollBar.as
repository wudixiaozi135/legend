package com.view.gameWindow.util.scrollBar
{
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.utils.Timer;

    public class ScrollBar
	{
		public static const SCROLL_OFFSET:int = 3;
		
		private var _height:int;
		private var _skin:MovieClip;
		private var _upBtn:MovieClip;
		private var _downBtn:MovieClip;
		private var _thumbBtn:MovieClip;
		private var _bg:MovieClip;
		private var _mouseWheelTarget:IEventDispatcher;
		
		private var _scrollee:IScrollee;
		
		private var _contentHeight:int;
		private var _scrollRectHeight:int;
		private var _scrollRectY:int;
		
		private var _upBtnDown:Boolean;
		private var _downBtnDown:Boolean;
		private var _thumbBtnDown:Boolean;
		private var _type:int;

		private var _timer:Timer;
		
		private var _mouseWheelSpeed:int;
		private var _mouseWheelDelta:int;
		
		/**
		 * @param mouseWheelSpeed count = e.delta × mouseWheelSpeed
		 */
		public function ScrollBar(scrollee:IScrollee,skin:MovieClip,type:int = 0,mouseWheelTarget:IEventDispatcher = null,mouseWheelSpeed:int = 8)
		{
			_type=type;
			
			_skin = skin;
			_upBtn = _skin.btnUp;
			_upBtn.btnEnabled = false;
			_downBtn = _skin.btnDown;
			_downBtn.btnEnabled = false;
			_thumbBtn = _skin.btnThumb;
			_thumbBtn.visible = false;
			_bg = _skin.btnBg;
			_mouseWheelTarget = mouseWheelTarget;
			_mouseWheelSpeed = mouseWheelSpeed;
			_mouseWheelDelta = 0;
			
			_scrollee = scrollee;
			
			_upBtn.addEventListener(MouseEvent.MOUSE_DOWN, upBtnMouseDownHandle);
			_upBtn.addEventListener(MouseEvent.MOUSE_UP, upBtnMouseUpHandle);
			_upBtn.addEventListener(MouseEvent.ROLL_OUT, upBtnRollOutHandle);
			_downBtn.addEventListener(MouseEvent.MOUSE_DOWN, downBtnMouseDownHandle);
			_downBtn.addEventListener(MouseEvent.MOUSE_UP, downBtnMouseUpHandle);
			_downBtn.addEventListener(MouseEvent.ROLL_OUT, downBtnRollOutHandle);
			_skin.parent.addEventListener(Event.ENTER_FRAME, enterframeHandle);
			if(_mouseWheelTarget)
			{
				_mouseWheelTarget.addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler);
			}
			
			_upBtnDown = false;
			_downBtnDown = false;
			_thumbBtnDown = false;
		}
		
		
		private function mouseWheelHandler(e:MouseEvent):void
		{
			_mouseWheelDelta = e.delta*_mouseWheelSpeed;
		}
		
		public function resetHeight(value:int):void
		{
			_height = value;
			_upBtn.y = 0;
			_downBtn.y = _height - _downBtn.height;
			_bg.height = _downBtn.y;
			resetScroll();
			_mouseWheelDelta = 0;
		}
		
		public function get height():int
		{
			return _height;
		}
		
		public function resetScroll():void
		{
			_contentHeight = _scrollee.contentHeight;
			_scrollRectHeight = _scrollee.scrollRectHeight;
			_scrollRectY = _scrollee.scrollRectY;
			
			if (_scrollRectHeight >= _contentHeight)
			{
				if (_thumbBtn.visible)
				{
					_thumbBtn.visible = false;
					_thumbBtn.removeEventListener(MouseEvent.MOUSE_DOWN, thumbBtnMouseDownHandle);
					if (_skin.stage)
						_skin.stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandle);
					_thumbBtn.stopDrag();
					//
					_upBtn.btnEnabled = false;
					_downBtn.btnEnabled = false;
				}
				
				scrollTo(0,true);
				
				_upBtn.enabled = false;
				_downBtn.enabled = false;
				_upBtnDown = false;
				_downBtnDown = false;
			}
			else
			{
				if (!_thumbBtn.visible)
				{
					_thumbBtn.visible = true;
					_thumbBtn.addEventListener(MouseEvent.MOUSE_DOWN, thumbBtnMouseDownHandle, false, 0, true);
					//
					_upBtn.btnEnabled = true;
					_downBtn.btnEnabled = true;
				}
				if(_type == ScrollBarType.TYPE_DEFAULT)
				{
					var tmpHeight:Number = (_height - _upBtn.height - _downBtn.height) * _scrollRectHeight / _contentHeight;
					_thumbBtn.getChildAt(0).height = tmpHeight < 20 ? 20 : tmpHeight;
				}
//				_thumbBtn.y = _upBtn.height + (_height - _upBtn.height - _downBtn.height - _thumbBtn.height) * _scrollRectY / (_contentHeight - _scrollRectHeight);
				scrollTo(_scrollRectY,true);
				
				_upBtn.enabled = true;
				_downBtn.enabled = true;
			}
		}
		
		private function thumbBtnMouseDownHandle(event:MouseEvent):void
		{
			_thumbBtn.startDrag(false, new Rectangle(_thumbBtn.x, _upBtn.height, 0, _height - _thumbBtn.height - _downBtn.height - _upBtn.height));
			_skin.stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandle, false, 0, true);
			_thumbBtnDown = true;
		}
		private function stageMouseUpHandle(event:MouseEvent):void
		{
            if (_skin && _skin.stage)
            {
                _skin.stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandle);
            }
			_thumbBtnDown = false;
			_thumbBtn.stopDrag();
		}
		
		private function upBtnMouseDownHandle(event:MouseEvent):void
		{
			_upBtnDown = true;
		}
		
		private function upBtnMouseUpHandle(event:MouseEvent):void
		{
			_upBtnDown = false;
		}
		
		private function upBtnRollOutHandle(event:MouseEvent):void
		{
			_upBtnDown = false;
		}
		
		private function downBtnMouseDownHandle(event:MouseEvent):void
		{
			_downBtnDown = true;
		}
		
		private function downBtnMouseUpHandle(event:MouseEvent):void
		{
			_downBtnDown = false;
		}
		
		private function downBtnRollOutHandle(event:MouseEvent):void
		{
			_downBtnDown = false;
		}
		
		private function enterframeHandle(event:Event):void
		{
			var scrollOffset:int = SCROLL_OFFSET;
			
			if(_mouseWheelDelta<0)
			{
				_downBtnDown = true;
				//2
				scrollOffset*=_mouseWheelSpeed;
			}
			else if(_mouseWheelDelta>0)
			{
				_upBtnDown = true;
				//2
				scrollOffset*=_mouseWheelSpeed;
			}
			
			if (_upBtnDown && _upBtn.enabled || _downBtnDown && _downBtn.enabled)
			{
				if (_upBtnDown)
				{
					if (_scrollRectY > 0)
					{
						if (_scrollRectY - scrollOffset > 0)
						{
							_scrollRectY -= scrollOffset;
						}
						else
						{
							_scrollRectY = 0;
						}
						_scrollee.scrollTo(_scrollRectY);
					}
				}
				if (_downBtnDown)
				{
					if (_scrollRectY < _contentHeight - _scrollRectHeight)
					{
						if (_scrollRectY + scrollOffset < _contentHeight - _scrollRectHeight)
						{
							_scrollRectY += scrollOffset;
						}
						else
						{
							_scrollRectY = _contentHeight - _scrollRectHeight;
						}
						_scrollee.scrollTo(_scrollRectY);
					}
				}
				if(_thumbBtn)
				{
					_thumbBtn.y = _upBtn.height + (_height - _upBtn.height - _downBtn.height - _thumbBtn.height) * _scrollRectY / (_contentHeight - _scrollRectHeight);
				}				
			}
			else if (_thumbBtnDown && _thumbBtn)
			{
				_scrollRectY = (_contentHeight - _scrollRectHeight) * (_thumbBtn.y - _upBtn.height) / (_height - _upBtn.height - _downBtn.height - _thumbBtn.height);
				_scrollee.scrollTo(_scrollRectY);
			}
			
			//1
//			if(_mouseWheelDelta<0)
//			{
//				_downBtnDown = false;
//				++_mouseWheelDelta;
//			}
//			else if(_mouseWheelDelta>0)
//			{
//				_upBtnDown = false;
//				--_mouseWheelDelta;
//			}
			
			//2 原偷懒方法滚动太慢 
			if(_mouseWheelDelta<0)
			{
				_downBtnDown = false;
				_mouseWheelDelta = 0;
			}
			else if(_mouseWheelDelta>0)
			{
				_upBtnDown = false;
				_mouseWheelDelta = 0;
			}
		}
		
		public function scroll(offset:int):void
		{
			if (_upBtn.enabled || _downBtn.enabled)
			{
				if (offset < 0 && _scrollRectY > 0)
				{
					if (_scrollRectY + offset > 0)
					{
						_scrollRectY += offset;
					}
					else
					{
						_scrollRectY = 0;
					}
					_scrollee.scrollTo(_scrollRectY);
				}
				else if (offset > 0 && _scrollRectY < _contentHeight - _scrollRectHeight)
				{
					if (_scrollRectY + offset < _contentHeight - _scrollRectHeight)
					{
						_scrollRectY += offset;
					}
					else
					{
						_scrollRectY = _contentHeight - _scrollRectHeight;
					}
					_scrollee.scrollTo(_scrollRectY);
				}
				if(_thumbBtn)
				{
					_thumbBtn.y = _upBtn.height + (_height - _upBtn.height - _downBtn.height - _thumbBtn.height) * _scrollRectY / (_contentHeight - _scrollRectHeight);
				}				
			}
		}
		
		public function scrollTo(offsetY:int,force:Boolean = false):void
		{
			if (_upBtn.enabled || _downBtn.enabled || force)
			{
				_scrollRectY = offsetY;
				
				if (_scrollRectY > _contentHeight - _scrollRectHeight)
				{
					_scrollRectY = _contentHeight - _scrollRectHeight;
				}
				
				if(_scrollRectY < 0)
				{
					_scrollRectY = 0;
				}
				
				_scrollee.scrollTo(_scrollRectY);
				if(_thumbBtn)
				{
					_thumbBtn.y = _upBtn.height + (_height - _upBtn.height - _downBtn.height - _thumbBtn.height) * _scrollRectY / (_contentHeight - _scrollRectHeight);
				}				
			}
		}
		
		public function get scrollable():Boolean
		{
			_contentHeight = _scrollee.contentHeight;
			_scrollRectHeight = _scrollee.scrollRectHeight;
			
			return _scrollRectHeight < _contentHeight;
		}
		
		
		public function get scrollRectY():int
		{
			return _scrollRectY;
		}
		
		public function setVisible(bool:Boolean):void
		{
			_skin.visible = bool;
		}
		
		public function destroy():void
		{
			_mouseWheelDelta = 0;
			_upBtn.removeEventListener(MouseEvent.MOUSE_DOWN, upBtnMouseDownHandle);
			_upBtn.removeEventListener(MouseEvent.MOUSE_UP, upBtnMouseUpHandle);
			_upBtn.removeEventListener(MouseEvent.ROLL_OUT, upBtnRollOutHandle);
			_downBtn.removeEventListener(MouseEvent.MOUSE_DOWN, downBtnMouseDownHandle);
			_downBtn.removeEventListener(MouseEvent.MOUSE_UP, downBtnMouseUpHandle);
			_downBtn.removeEventListener(MouseEvent.ROLL_OUT, downBtnRollOutHandle);
			_skin.parent.removeEventListener(Event.ENTER_FRAME, enterframeHandle);
			if(_mouseWheelTarget)
			{
				_mouseWheelTarget.removeEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler);
			}
		}
	}
}