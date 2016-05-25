package com.view.gameWindow.scene.effect.item.delay
{
	import com.view.gameWindow.scene.effect.item.interf.IEffectBase;

	public class DelayEffect
	{
		protected var _delay:int;
		protected var _path:String;
		protected var _sound:int;
		
		public function DelayEffect(delay:int, path:String, sound:int)
		{
			_delay = delay;
			_path = path;
			_sound = sound;
		}
		
		public function get delay():int
		{
			return _delay;
		}
		
		public function set delay(value:int):void
		{
			_delay = value;
		}
		
		public function get path():String
		{
			return _path;
		}
		
		public function set sound(value:int):void
		{
			_sound = value;
		}
		
		public function get sound():int
		{
			return _sound;
		}
		
		public function genEffect():IEffectBase
		{
			return null;
		}
	}
}