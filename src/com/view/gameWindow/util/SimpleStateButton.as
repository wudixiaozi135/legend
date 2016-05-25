package com.view.gameWindow.util
{
    import flash.display.InteractiveObject;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.utils.Dictionary;

    public class SimpleStateButton
	{
		private static var stateObj:Dictionary = new Dictionary(true);
		public static function addState(skin:InteractiveObject,isTextNeed:String = ''):void
		{
			if(!stateObj[skin])
			{
				stateObj[skin] = new SimpleStateButton(skin,isTextNeed);
			}
			
		}
		
		public static function removeState(skin:InteractiveObject):void
		{
			if(stateObj[skin])
			{
				var temp:SimpleStateButton = stateObj[skin] as SimpleStateButton;
				temp.destroy();
				stateObj[skin] = null;
				delete stateObj[skin];
			}
		}

		public static function addLinkState(skin:InteractiveObject, content:String = "", linkStr:String = "", color:String = "#00ff00"):void
		{
			addState(skin, content);
			if (stateObj[skin])
			{
				if (skin is TextField)
				{
					var tf:TextField = skin as TextField;
                    tf.selectable = false;
					if (tf.text)
					{
						tf.htmlText = "<font color='" + color + "'><a href=\'event:" + linkStr + "\'><u>" + tf.text + "<u></a></font>";
					}
				} else
				{
					throw new TypeError("typeError");
				}
			}
		}

		private var _skin:InteractiveObject;
		
		public function SimpleStateButton(skin:InteractiveObject,isTextNeed:String = '')
		{
			_skin = skin;
			if(_skin is MovieClip)
			{
				var temp:MovieClip = _skin as MovieClip;
				temp.buttonMode = true;
			}
			if(_skin is TextField)
			{
				if(isTextNeed)
				{	
					var temp1:TextField = _skin as TextField;
					temp1.htmlText ='<u>'+isTextNeed+'</u>';
				}
			}
			_skin.addEventListener(MouseEvent.MOUSE_DOWN,onDown,false,0,true);
		}

		private function onUp(event:MouseEvent):void
		{
			onUpHandler();
		}

		private function onDown(event:MouseEvent):void
		{
			onDownHandler();
		}

		private function onRollOut(event:MouseEvent):void
		{
			onUpHandler();
		}

		private function onUpHandler():void
		{
			if (_skin && _skin.hasEventListener(MouseEvent.MOUSE_UP))
			{
				_skin.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
				_skin.removeEventListener(MouseEvent.MOUSE_UP, onUp);
				_skin.x -= 1;
				_skin.y -= 1;
			}
		}

		private function onDownHandler():void
		{
			if (_skin && (!_skin.hasEventListener(MouseEvent.MOUSE_UP)))
			{
				_skin.addEventListener(MouseEvent.MOUSE_UP, onUp, false, 0, true);
				_skin.addEventListener(MouseEvent.ROLL_OUT, onRollOut, false, 0, true);
				_skin.x += 1;
				_skin.y += 1;
			}
		}

		public function destroy():void
		{
			_skin.removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
			_skin.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			_skin.removeEventListener(MouseEvent.ROLL_OVER, onRollOut);
		}
		
	}
}