package com.view.gameWindow.mainUi.subuis.musicSet
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.MapCfgData;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subuis.musicSet.item.MusicItem;
    import com.view.gameWindow.scene.map.SceneMapManager;
    import com.view.newMir.sound.SoundManager;

    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.utils.Dictionary;

    /**
	 * Created by Administrator on 2014/12/27.
	 */
	public class MusicSettingManager implements IMusicSettingManager
	{
		private var _menuCheck:MusicMenuCheck;
		private var _obj:DisplayObjectContainer;
		private var _stage:Stage;
		private var _musicSettingData:Array;
		public function MusicSettingManager()
		{
			_musicSettingData = new MusicSettingData().datas;
			_menuCheck = new MusicMenuCheck();
			if (_musicSettingData)
				_menuCheck.data = _musicSettingData;
			MusicSettingEvent.addEventListener(MusicSettingEvent.MUSIC_SETTING, onMusicSetting, false, 0, true);
		}
		
		/**获取当前某个音乐设置状态
		 * @param musicType 0：基础音乐 1：技能  2：怪物  3：背景音乐
		 * @return  true：暂停, false:播放
		 * */
		public function getMusicSettingState(musicType:int):Boolean
		{
			var item:MusicItem = getCurrent(musicType.toString());
			if (item)
			{
				return (item.checked);
			}
			return false;
		}
		
		private function getCurrent(id:String):MusicItem
		{
            var dic:Dictionary;
            dic = _menuCheck.dic;
            if (dic)
            {
                return dic[id];
            }
			return null;
		}
		
		private function onMusicSetting(event:MusicSettingEvent):void
		{
			var param:MusicItem = event.value as MusicItem;
			if (_menuCheck)
			{
				var data:Array = _menuCheck.data;
				switchMusic(parseInt(param.id), param.checked);
				MainUiMediator.getInstance().miniMap.setBtnMuisc(btnMusicSelected);
			}
		}

		private function get btnMusicSelected():Boolean
		{
			if (_menuCheck)
			{
				for each(var item:MusicItem in _menuCheck.data)
				{
					if (item.checked) return true;
				}
				return false;
			}
			return false;
		}

		private function switchMusic(id:int, stopMusic:Boolean):void
		{
			if (id == MusicConst.BASIC_MUSIC || id == MusicConst.SKILL_MUSIC || id == MusicConst.MONSTER_MUSIC)
			{
				if (stopMusic)
				{
					SoundManager.getInstance().stopEffect();
				}
			} else if (id == MusicConst.BG_MUSIC)
			{
				if (stopMusic)
				{
					SoundManager.getInstance().stopBgSound();
					return;
				}
				playCurrentBgMusic();
			}
		}
		
		public function defaultSetting(state:Boolean):void
		{
			if (_menuCheck && _menuCheck.data)
			{
				var data:Array = _menuCheck.data;
				var param:MusicItem = data[MusicConst.MONSTER_MUSIC] as MusicItem;
				param.checked = state;
				dispatchEvt(param);
				param = data[MusicConst.BG_MUSIC] as MusicItem;
				param.checked = state;
				dispatchEvt(param);
				_menuCheck.data = data;
			}
		}
		
		/**播放当前的背景音乐*/
		private function playCurrentBgMusic():void
		{
			var mapId:int = SceneMapManager.getInstance().mapId;
			var mapConfig:MapCfgData = ConfigDataManager.instance.mapCfgData(mapId);
			if (mapConfig)
			{
				SoundManager.getInstance().playBgSound(mapConfig.sound);
			} else
			{
				SoundManager.getInstance().stopBgSound();
			}
		}
		
		public function addEvent(dis:DisplayObjectContainer):void
		{
			_obj = dis;
			_obj.addEventListener(MouseEvent.ROLL_OVER, onRollHandler, false, 0, true);
			_obj.addEventListener(MouseEvent.ROLL_OUT, onRollHandler, false, 0, true);
		}
		
		private function onRollHandler(event:MouseEvent):void
		{
			var settingPanel:Sprite = MainUiMediator.getInstance().settingPanel;
			if (event.type == MouseEvent.ROLL_OVER)
			{
				if (_obj && _obj.stage)
				{
					_stage = _obj.stage;
					if (!settingPanel.contains(_menuCheck))
					{
						settingPanel.addChild(_menuCheck);
					}
					_menuCheck.visible = true;
					_menuCheck.x = 19;
					_menuCheck.y = -22;
				}
			} else
			{
//				if (_stage.mouseX > settingPanel.x + _menuCheck.width || _stage.mouseY < settingPanel.y)
//					_menuCheck.visible = false;
				var offX:int = settingPanel.x + _menuCheck.x + _menuCheck.width;
				var offY:int = settingPanel.y + _menuCheck.y;
				if (_stage.mouseX > offX || _stage.mouseY < offY)
					_menuCheck.visible = false;
			}
		}
		
		public function removeEvent(dis:DisplayObjectContainer):void
		{
			dis.removeEventListener(MouseEvent.ROLL_OVER, onRollHandler);
			dis.removeEventListener(MouseEvent.ROLL_OUT, onRollHandler);
		}
		
		public function dispatchEvt(param:Object):void
		{
			var evt:MusicSettingEvent = new MusicSettingEvent(MusicSettingEvent.MUSIC_SETTING, param);
			MusicSettingEvent.dispatchEvent(evt);
			evt = null;
		}
		
		private static var _instance:MusicSettingManager = null;
		public static function get instance():MusicSettingManager
		{
			if (_instance == null)
			{
				_instance = new MusicSettingManager();
			}
			return _instance;
		}
	}
}
