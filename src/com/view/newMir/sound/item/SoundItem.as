package com.view.newMir.sound.item
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.VoiceEffectCfgData;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	public class SoundItem
	{
		protected var _id:int;
		protected var _sound:Sound;
		protected var _soundChannel:SoundChannel;
		protected var _volume:int;
		
		public function SoundItem(id:int)
		{
			_id = id;
			_volume = 0;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function play(volume:int):void
		{
		}
		
		protected function loadSound():void
		{
			if (!_sound)
			{
				var cfg:VoiceEffectCfgData = ConfigDataManager.instance.voiceEffectCfgData(_id);
				if (cfg)
				{
					var url:String = ResourcePathConstants.VOICE_EFFECT_LOAD + cfg.url;
					var request:URLRequest = new URLRequest(url);
					var lc:SoundLoaderContext =new SoundLoaderContext(1000, true);
					_sound = new Sound();
					_sound.addEventListener(Event.COMPLETE, loadCompleteHandle, false, 0, true);
					_sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
					_sound.load(request, lc);
					doPlayerSound();
				}
			}
		}
		
		private function loadCompleteHandle(event:Event):void
		{
			_sound.removeEventListener(Event.COMPLETE, loadCompleteHandle, false);
			_sound.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			_sound.removeEventListener(Event.COMPLETE, loadCompleteHandle, false);
			_sound.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false);
		}
		
		public function get volume():int
		{
			return _volume;
		}
		
		public function set volume(value:int):void
		{
			if (_volume != value)
			{
				_volume = value;
				if (_soundChannel)
				{
					_soundChannel.soundTransform = new SoundTransform(_volume / 100);
				}
			}
		}
		
		protected function doPlayerSound():void
		{
			if (!_soundChannel && _sound)
			{
				var soundTransform:SoundTransform = new SoundTransform(_volume / 100);
				try
				{
					_soundChannel = _sound.play(0, 0, soundTransform);
				}
				catch (e:Error)
				{
					throw new Error("播放声音失败，声音id为" + _id + "，错误信息为：" + e.message);
				}
			}
		}
	}
}