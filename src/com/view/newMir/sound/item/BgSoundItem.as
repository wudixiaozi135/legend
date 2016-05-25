package com.view.newMir.sound.item
{
	import flash.media.SoundTransform;

	public class BgSoundItem extends SoundItem
	{
		private var _playing:Boolean;
		
		public function BgSoundItem(id:int)
		{
			super(id);
			_playing = false;
		}
		
		public override function play(volume:int):void
		{
			if (!_playing)
			{
				_playing = true;
				_volume = volume;
				if (!_sound)
				{
					loadSound();
				}
				else
				{
					doPlayerSound();
				}
			}
		}
		
		public function stop():void
		{
			if (_playing)
			{
				_playing = false;
				if (_soundChannel)
				{
					_soundChannel.stop();
					_soundChannel = null;
				}
			}
		}
		
		protected override function doPlayerSound():void
		{
			if (!_soundChannel && _sound)
			{
				var soundTransform:SoundTransform = new SoundTransform(_volume / 100);
				try
				{
					_soundChannel = _sound.play(0, int.MAX_VALUE, soundTransform);
				}
				catch (e:Error)
				{
					throw new Error("播放声音失败，声音id为" + _id + "，错误信息为：" + e.message);
				}
			}
		}
	}
}