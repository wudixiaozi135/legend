package com.view.gameWindow.scene.stateAlert
{
	
	import com.model.consts.StringConst;
	
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class TaskAlert
	{
		private static const _filter:GlowFilter = new GlowFilter(0xac4d00,0.7,8,8,8,BitmapFilterQuality.MEDIUM,false,false);
		
		private var _fadeAlphaFrom : Number;
		private var _fadeAlphaTo : Number;
		
		private var _fadeDuration : int;
		
		private var _totalFrame : int;
		private var _currentFrame : int;
		
		private var _fadeOffsetAlpha : Number;
		private var msg:TextField;
		private static var _instance:TaskAlert;
		private var _nofade:Boolean;
		
		private var _layer:Sprite;
		
		public static function getInstance() : TaskAlert
		{
			if ( ! _instance )
			{
				_instance = new TaskAlert();
			}
			return _instance;
		}
		
		public function initData(layer:Sprite):void
		{
			_layer = layer;
			init();
		}
		
		private function init():void
		{
			_fadeAlphaFrom = 1.0;
			_fadeAlphaTo = 0;
			var tf:TextFormat=new TextFormat();
			tf.size=18;
			tf.align=TextFormatAlign.CENTER;
			tf.bold=true;
			tf.font = StringConst.STRING_0001;
			msg=new TextField();
			msg.defaultTextFormat=tf;
			msg.autoSize = TextFieldAutoSize.LEFT;
			msg.width=600;
			msg.x=200;
			msg.y=0;
			msg.filters = [_filter];
			_layer.addChild(msg);
		}
		
		public function showMSG(message:String, noFade:Boolean = false) : void
		{
			this.msg.htmlText = message;
			/*this.msg.textColor=0xffffff;*/
			msg.x = (_layer.stage.stageWidth - msg.width) / 2.0;
			msg.y =_layer.stage.stageHeight - 244;
			_layer.alpha = 1;
			
			_fadeDuration = 50;
			
			_fadeOffsetAlpha = ( _fadeAlphaTo - _fadeAlphaFrom ) / _fadeDuration;
			
			_totalFrame = 150;
			_currentFrame = -18; //停留下
			_nofade = noFade
			
			enterframe();
		}
		
		
		public function enterframe() : void
		{
			if(!over && !_nofade)
			{
				if(_currentFrame > 0)
				{
					if ( _currentFrame >= _totalFrame - _fadeDuration)
					{
						_layer.alpha = Math.max( 0 , 1 + _fadeOffsetAlpha * (_currentFrame -_totalFrame + _fadeDuration) );
					}
					else
					{
						_layer.alpha = 1;
					}
				}
				_currentFrame ++;
			}else
			{
				if(_layer.alpha!=0)
				_layer.alpha=0;
			}
		}
		
		public function get over() : Boolean
		{
			return _currentFrame >= _totalFrame;
		}
		
		public function forceFade():void
		{
			if (_nofade)
			{
				_nofade = false;
				_currentFrame = _totalFrame - _fadeDuration;
			}
		}
		
		public function destroy() : void
		{
			
		}
	}
}