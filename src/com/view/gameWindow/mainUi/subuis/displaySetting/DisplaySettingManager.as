package com.view.gameWindow.mainUi.subuis.displaySetting
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subuis.displaySetting.item.DisplaySettingItem;

    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;

    /**
     * Created by Administrator on 2014/12/29.
     */
    public class DisplaySettingManager extends DataManagerBase
    {
        private static const HIDE_ALL:int = 0;//隐藏全部
        private static const HIDE_OTHER_PLAYER:int = 1;//	隐藏其他玩家
        private static const HIDE_OTHER_HERO:int = 2;//	隐藏其他英雄
        private static const HIDE_ALL_MONSTER:int = 3;//	隐藏所有怪物
        private static const HIDE_ALL_SKILL_EFFECT:int = 4;//	隐藏全部技能特效
        private static const HIDE_MONSTER_EFFECT:int = 5;//隐藏怪物技能特效
        private static const HIDE_FIRE_WALL_EFFECT:int = 6;//	隐藏火墙特效
        private static const HIDE_FACTION_NAME:int = 6;//	隐藏帮会名称
        private static const HIDE_SAME_FACTION_MEMBER:int = 7;//	隐藏同帮成员
        private static const HIDE_SAME_TEAM_MEMBER:int = 9;//	隐藏同组成员
        private static const HIDE_WING:int = 10;//	隐藏羽翼
        private static const HIDE_WEAPON_EFFECT:int = 11;//	隐藏其他武器特效
        private static const HIDE_OTHER_PLAYER_DESIGNATION:int = 12;//	隐藏其他玩家称号
        private static const NAME_IN_BODY:int = 13;//	名字置于中间

        private var _obj:DisplayObjectContainer;
        private var _stage:Stage;
        private var _displaySettingData:Array;
        private var _menuCheck:DisplaySettingMenu;

        private var _localData:DisplaySettingStorageData;

        public function DisplaySettingManager()
        {
            _displaySettingData = new DisplaySettingData().datas;
            _menuCheck = new DisplaySettingMenu();
            if (_displaySettingData)
            {
                _menuCheck.data = _displaySettingData;
            }
            DistributionManager.getInstance().register(GameServiceConstants.SM_HIDE_MERORY, this);
            DisplaySettingEvent.addEventListener(DisplaySettingEvent.DISPLAY_SETTING, onDisplaySetting, false, 0, true);
            DisplaySettingHandlers.instance;
        }

        override public function resolveData(proc:int, data:ByteArray):void
        {
            switch (proc)
            {
                case GameServiceConstants.SM_HIDE_MERORY:
                    handler(data);
                    break;
                default:
                    break;
            }
            super.resolveData(proc, data);
        }

        private function handler(data:ByteArray):void
        {
            _localData = new DisplaySettingStorageData();
            _localData.hide_1 = Boolean(data.readByte());
            _localData.hide_2 = Boolean(data.readByte());
            _localData.hide_3 = Boolean(data.readByte());
            _localData.hide_4 = Boolean(data.readByte());
            _localData.hide_5 = Boolean(data.readByte());
            _localData.hide_6 = Boolean(data.readByte());
            _localData.hide_7 = Boolean(data.readByte());
            _localData.hide_8 = Boolean(data.readByte());
            _localData.hide_9 = Boolean(data.readByte());
            _localData.hide_10 = Boolean(data.readByte());
            _localData.hide_11 = Boolean(data.readByte());
            _localData.hide_12 = Boolean(data.readByte());
            _localData.hide_13 = Boolean(data.readByte());
            _localData.hide_14 = Boolean(data.readByte());
            setDefaultData();
        }

        override public function clearDataManager():void
        {
            _instance = null;
        }

        private function setDefaultData():void
        {
            if (_menuCheck && _menuCheck.data)
            {
                var localData:Object = _localData;
                for each(var data:DisplaySettingItem in _menuCheck.data)
                {
                    switch (data.id)
                    {
                        case DisplaySettingConst.HIDE_ALL.toString():
                            if (localData)
                            {
                                data.checked = localData.hide_1;
                            } else
                            {
                                data.checked = false;
                            }
                            break;
                        case DisplaySettingConst.HIDE_OTHER_PLAYER.toString():
                            if (localData)
                            {
                                data.checked = localData.hide_2;
                            } else
                            {
                                data.checked = false;
                            }
                            break;
                        case DisplaySettingConst.HIDE_OTHER_HERO.toString():
                            if (localData)
                            {
                                data.checked = localData.hide_3;
                            } else
                            {
                                data.checked = false;
                            }
                            break;
                        case DisplaySettingConst.HIDE_ALL_MONSTER.toString():
                            if (localData)
                            {
                                data.checked = localData.hide_4;
                            } else
                            {
                                data.checked = false;
                            }
                            break;
                        case DisplaySettingConst.HIDE_ALL_SKILL_EFFECT.toString():
                            if (localData)
                            {
                                data.checked = localData.hide_5;
                            } else
                            {
                                data.checked = false;
                            }
                            break;
                        case DisplaySettingConst.HIDE_MONSTER_EFFECT.toString():
                            if (localData)
                            {
                                data.checked = localData.hide_6;
                            } else
                            {
                                data.checked = false;
                            }
                            break;
                        case DisplaySettingConst.HIDE_FIRE_WALL_EFFECT.toString():
                            if (localData)
                            {
                                data.checked = localData.hide_7;
                            } else
                            {
                                data.checked = false;
                            }
                            break;
                        case DisplaySettingConst.HIDE_FACTION_NAME.toString():
                            if (localData)
                            {
                                data.checked = localData.hide_8;
                            } else
                            {
                                data.checked = false;
                            }
                            break;
                        case DisplaySettingConst.HIDE_SAME_FACTION_MEMBER.toString():
                            if (localData)
                            {
                                data.checked = localData.hide_9;
                            } else
                            {
                                data.checked = false;
                            }
                            break;
                        case DisplaySettingConst.HIDE_SAME_TEAM_MEMBER.toString():
                            if (localData)
                            {
                                data.checked = localData.hide_10;
                            } else
                            {
                                data.checked = false;
                            }
                            break;
                        case DisplaySettingConst.HIDE_WING.toString():
                            if (localData)
                            {
                                data.checked = localData.hide_11;
                            } else
                            {
                                data.checked = false;
                            }
                            break;
                        case DisplaySettingConst.HIDE_WEAPON_EFFECT.toString():
                            if (localData)
                            {
                                data.checked = localData.hide_12;
                            } else
                            {
                                data.checked = false;
                            }
                            break;
                        case DisplaySettingConst.HIDE_OTHER_PLAYER_DESIGNATION.toString():
                            if (localData)
                            {
                                data.checked = localData.hide_13;
                            } else
                            {
                                data.checked = false;
                            }
                            break;
                        case DisplaySettingConst.NAME_IN_MIDDLE.toString():
                            if (localData)
                            {
                                data.checked = localData.hide_14;
                            } else
                            {
                                data.checked = false;
                            }
                            break;
                        default :
                            break;
                    }
                }
				
				if(MainUiMediator.getInstance().miniMap)
				{
                	MainUiMediator.getInstance().miniMap.setBtnHide(getBtnSelected);
				}
            }
        }

        private function onDisplaySetting(event:DisplaySettingEvent):void
        {
            var param:DisplaySettingItem = event.value as DisplaySettingItem;
            if (_menuCheck)
            {
                switchDisplaySetting(parseInt(param.id), param.checked);

                if (param.id == DisplaySettingConst.HIDE_ALL.toString())
                {
                    setAllSetting(param.checked);
                } else if (param.id == DisplaySettingConst.HIDE_ALL_SKILL_EFFECT.toString())
                {
                    setAllSkillSetting(param.checked);
                } else if (param.id == DisplaySettingConst.HIDE_MONSTER_EFFECT.toString() || param.id == DisplaySettingConst.HIDE_FIRE_WALL_EFFECT.toString())
                {
                    setAllSkillHide(param.checked);
                }
                else
                {
                    if (getDisplaySettingState(DisplaySettingConst.HIDE_ALL))
                    {
                        var data:Array = _menuCheck.data;
                        data[HIDE_ALL].checked = false;
                        _menuCheck.data = data;
                    }
                    DisplaySettingHandlers.instance.checkDisplaySettingState();
                }
                MainUiMediator.getInstance().miniMap.setBtnHide(getBtnSelected);
            }
        }

        private function setAllSkillHide(checked:Boolean):void
        {
            var data:Array = _menuCheck.data;
            if (getDisplaySettingState(DisplaySettingConst.HIDE_ALL_SKILL_EFFECT))
            {
                data[HIDE_ALL_SKILL_EFFECT].checked = false;
            }
            _menuCheck.data = data;
            DisplaySettingHandlers.instance.checkDisplaySettingState();
        }

        private function setAllSkillSetting(checked:Boolean):void
        {
            if (_menuCheck && _menuCheck.data)
            {
                var data:Array = _menuCheck.data;
                for each(var item:DisplaySettingItem in data)
                {
                    switch (item.id)
                    {
                        case DisplaySettingConst.HIDE_MONSTER_EFFECT.toString():
                        case DisplaySettingConst.HIDE_FIRE_WALL_EFFECT.toString():
                            item.checked = checked;
                            break;
                        default :
                            break;
                    }
                }
                _menuCheck.data = data;
                DisplaySettingHandlers.instance.checkDisplaySettingState();
            }
        }

        private function get getBtnSelected():Boolean
        {
            if (_menuCheck)
            {
                for each(var item:DisplaySettingItem in _menuCheck.data)
                {
                    if (item.checked) return true;
                }
                return false;
            }
            return false;
        }

        private function setAllSetting(checked:Boolean):void
        {
            if (_menuCheck && _menuCheck.data)
            {
                for each(var item:DisplaySettingItem in _menuCheck.data)
                {
                    if (item.id == DisplaySettingConst.HIDE_ALL.toString()) continue;
                    item.checked = checked;
                }
                var data:Array = _menuCheck.data;
                _menuCheck.data = data;
                DisplaySettingHandlers.instance.checkDisplaySettingState();
            }
        }

        private function switchDisplaySetting(type:int, checked:Boolean):void
        {
            DisplaySettingHandlers.instance.checkDisplaySettingState();
        }

        public function dispatchEvt(param:Object):void
        {
            var evt:DisplaySettingEvent = new DisplaySettingEvent(DisplaySettingEvent.DISPLAY_SETTING, param);
            DisplaySettingEvent.dispatchEvent(evt);
            evt = null;
        }

        public function defaultSetting(state:Boolean):void
        {
            if (_menuCheck && _menuCheck.data)
            {
                var data:Array = _menuCheck.data;
                data[HIDE_OTHER_PLAYER].checked = state;
                data[HIDE_OTHER_HERO].checked = state;
                _menuCheck.data = data;

                if (!state)
                {
                    if (getDisplaySettingState(DisplaySettingConst.HIDE_ALL))
                    {
                        data = _menuCheck.data;
                        data[HIDE_ALL].checked = false;
                        _menuCheck.data = data;
                    }
                }
                DisplaySettingHandlers.instance.checkDisplaySettingState();
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
                    
                }
            } else
            {
                var offX:int = settingPanel.x + _menuCheck.x + _menuCheck.width;
                var offY:int = settingPanel.y + _menuCheck.y;
                if (_stage.mouseX > offX || _stage.mouseY < offY)
                    _menuCheck.visible = false;
            }
        }

        /**获取当前某个音乐设置状态
         * @param displayType 对应DisplaySettingConst的常量
         * @return  true：隐藏, false:显示
         * */
        public function getDisplaySettingState(displayType:int):Boolean
        {
            if (getCurrent(DisplaySettingConst.HIDE_ALL.toString()).checked)
            {
                return true;
            }
            var item:DisplaySettingItem = getCurrent(displayType.toString());
            if (item)
            {
                return (item.checked);
            }
            return false;
        }

        private function getCurrent(id:String):DisplaySettingItem
        {
            var dic:Dictionary;
            if (_menuCheck)
            {
                dic = _menuCheck.dic;
            }
            if (dic)
            {
                return dic[id];
            }
            return null;
        }


        /*
         * @param type 隐藏怪物 DisplaySettingConst.HIDE_MONSTER_EFFECT
         * @param type 隐藏火墙 DisplaySettingConst.HIDE_FIRE_WALL_EFFECT
         * */
        public function hideSkillEffect(type:int):Boolean
        {
            var state:Boolean = getDisplaySettingState(DisplaySettingConst.HIDE_ALL);//隐藏全部
            if (state) return state;

            state = getDisplaySettingState(DisplaySettingConst.HIDE_ALL_SKILL_EFFECT);//隐藏全部技能特效
            if (state) return state;

            return getDisplaySettingState(type);
        }

        public function sendDisplaySetting(data:DisplaySettingStorageData):void
        {
            var hide_all:int = int(data.hide_1);
            var players:int = int(data.hide_2);
            var heros:int = int(data.hide_3);
            var monsters:int = int(data.hide_4);
            var skills:int = int(data.hide_5);
            var monster_skill:int = int(data.hide_6);
            var fire:int = int(data.hide_7);
            var familyname:int = int(data.hide_8);
            var family_member:int = int(data.hide_9);
            var team_member:int = int(data.hide_10);
            var chest:int = int(data.hide_11);
            var equip:int = int(data.hide_12);
            var play_title:int = int(data.hide_13);
            var name_site:int = int(data.hide_14);

            var data1:ByteArray = new ByteArray();
            data1.writeByte(hide_all);
            data1.writeByte(players);
            data1.writeByte(heros);
            data1.writeByte(monsters);
            data1.writeByte(skills);
            data1.writeByte(monster_skill);
            data1.writeByte(fire);
            data1.writeByte(familyname);
            data1.writeByte(family_member);
            data1.writeByte(team_member);
            data1.writeByte(chest);
            data1.writeByte(equip);
            data1.writeByte(play_title);
            data1.writeByte(name_site);
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_HIDE_MEMORY, data1);
            data1 = null;
        }

        private static var _instance:DisplaySettingManager = null;
        public static function get instance():DisplaySettingManager
        {
            if (_instance == null)
            {
                _instance = new DisplaySettingManager();
            }
            return _instance;
        }
    }
}
