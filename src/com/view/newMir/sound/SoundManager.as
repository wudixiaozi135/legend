package com.view.newMir.sound
{
	import com.view.gameWindow.mainUi.subuis.musicSet.MusicConst;
	import com.view.newMir.INewMir;
	import com.view.newMir.sound.item.BgSoundItem;
	import com.view.newMir.sound.item.VoiceEffectSoundItem;
	
	import flash.utils.Dictionary;

	public class SoundManager
	{
		private static const DEFAULT_SOUND_VOLUME:int = 80;
		
		private static var _instance:SoundManager;
		
		private var _bgSounds:Dictionary;
		private var _bgSound:BgSoundItem;
		private var _voiceEffectSounds:Dictionary;
		private var _effectSound:VoiceEffectSoundItem;
		
		private var _bgSoundVolume:int;
		private var _effectSoundVolume:int;
		
		private var _newMir:INewMir;
		public function set newMir(value:INewMir):void
		{
			_newMir = value;
		}
		
		public static function getInstance():SoundManager
		{
			if (!_instance)
			{
				_instance = new SoundManager(new PrivateClass());
			}
			return _instance;
		}
		
		public function SoundManager(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error();
			}
			_bgSounds = new Dictionary();
			_voiceEffectSounds = new Dictionary();
			_bgSoundVolume = _effectSoundVolume = DEFAULT_SOUND_VOLUME;
		}
		
		public function playBgSound(sid:int):void
		{
			if (sid > 0)
			{
				if (_bgSound)
				{
					if (_bgSound.id == sid)
					{
						return;
					}
					else
					{
						_bgSound.stop();
					}
				}
				if (!_bgSounds[sid])
				{
					_bgSounds[sid] = new BgSoundItem(sid);
				}
				_bgSound = _bgSounds[sid];
				_bgSound.play(_bgSoundVolume);
			}
		}
		
		public function playEffectSound(sid:int):void
		{
			if (sid > 0)
			{
				var musicBasicState:Boolean = _newMir.musicBasicState(MusicConst.BASIC_MUSIC);
				if (musicBasicState) return;//屏蔽基础音效
				playEffect(sid);
			}
		}

		public function playSkillEffect(sid:int):void
		{
			if (sid > 0)
			{
				var musicSkillState:Boolean = _newMir.musicBasicState(MusicConst.SKILL_MUSIC);
				if (musicSkillState) return;//屏蔽技能音效
				playEffect(sid);
			}
		}

		public function playMonsterSound(sid:int):void
		{
			if (sid > 0)
			{
				var musicMonsterState:Boolean = _newMir.musicBasicState(MusicConst.MONSTER_MUSIC);
				if (musicMonsterState) return;//屏蔽怪物音效
				playEffect(sid);
			}
		}

		private function playEffect(sid:int):void
		{
			if (!_voiceEffectSounds[sid])
			{
				_voiceEffectSounds[sid] = new VoiceEffectSoundItem(sid);
			}
			_effectSound = _voiceEffectSounds[sid];
			_effectSound.play(_effectSoundVolume);
		}

		public function stopEffect():void
		{
			if (_effectSound)
			{
				_effectSound.stop();
				_effectSound = null;
			}
		}
		public function stopBgSound():void
		{
			if (_bgSound)
			{
				_bgSound.stop();
				_bgSound = null;
			}
		}
		
		public function set bgSoundVolume(value:int):void
		{
			if (_bgSoundVolume != value)
			{
				_bgSoundVolume = value;
				if (_bgSound)
				{
					_bgSound.volume = _bgSoundVolume;
				}
			}
		}
		
		public function set effectSoundVolume(value:int):void
		{
			if (_effectSoundVolume != value)
			{
				_effectSoundVolume = value;
				for each (var soundItem:VoiceEffectSoundItem in _voiceEffectSounds)
				{
					soundItem.volume = _effectSoundVolume;
				}
			}
		}
		
		public function get bgSoundVolume():int
		{
			return _bgSoundVolume;
		}
		
		public function get effectSoundVolume():int
		{
			return _effectSoundVolume;
		}
	}
}

class PrivateClass{}