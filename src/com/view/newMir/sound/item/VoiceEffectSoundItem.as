package com.view.newMir.sound.item
{
	import flash.media.SoundTransform;

	public class VoiceEffectSoundItem extends SoundItem
	{
		public function VoiceEffectSoundItem(id:int)
		{
			super(id);
		}
		
		public override function play(volume:int):void
		{
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

		public function stop():void
		{
			if (_soundChannel)
			{
				_soundChannel.stop();
				_soundChannel = null;
			}
		}
		protected override function doPlayerSound():void
		{
			var soundTransform:SoundTransform = new SoundTransform(_volume / 100);
			try
			{
				_sound.play(0, 0, soundTransform);
			}
			catch (e:Error)
			{
				throw new Error("播放声音失败，声音id为" + _id + "，错误信息为：" + e.message);
			}
		}
	}
}