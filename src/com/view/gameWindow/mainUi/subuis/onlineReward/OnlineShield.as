package com.view.gameWindow.mainUi.subuis.onlineReward
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.OnlineRewardShieldCfgData;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.flyEffect.FlyEffectMediator;
    import com.view.gameWindow.mainUi.MainUi;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.IPanelBase;
    import com.view.gameWindow.panel.panels.convert.ConvertListPanelNew;
    import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockObserver;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;

    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.geom.Point;

    public class OnlineShield extends MainUi implements IObserver
    {
        internal var mouseHandle:OnlineShieldMouseEvent;
        internal var _onlineRewardShieldCfg:OnlineRewardShieldCfgData;
        private var _unlockObserver:UnlockObserver;

        private var _tipIcon:OnlineTip;
        private var _onLineIcon:OnlineShieldIcon;
        private var _flyBmp:Bitmap;
        private var _mouseSp:Sprite;
        public function OnlineShield()
        {
            super();
            _skin = new MovieClip();
            _skin.mouseEnabled = false;
            _skin.mouseChildren = false;
            addChild(_skin);

            mouseEnabled = false;
            addMouseClickSp();

            RoleDataManager.instance.attach(this);
            OnlineRewardDataManager.instance.attach(this);
        }

        private function addMouseClickSp():void
        {
            _mouseSp = new Sprite();
            _mouseSp.graphics.beginFill(0xffffff, 0);
            _mouseSp.graphics.drawRect(0, 0, 80, 97);
            _mouseSp.graphics.endFill();
            addChildAt(_mouseSp, numChildren - 1);
        }

        public function get mouseSp():Sprite
        {
            return _mouseSp;
        }
        override public function initView():void
        {
            initData();
        }

        /**根据解锁顺序显示icon*/
        private function updateIcon():void
        {
            _onlineRewardShieldCfg = getOnlineRewardShieldCfg();
            if (_onlineRewardShieldCfg)
            {
                destroyIcon();

                var iconName:String = getIconName(_onlineRewardShieldCfg.icon);
                var url:String = "shield/" + iconName + ResourcePathConstants.POSTFIX_PNG;
                _onLineIcon = new OnlineShieldIcon(url, _onlineRewardShieldCfg);
                _skin.addChild(_onLineIcon);
                if (_onLineIcon)
                {
                    _onLineIcon.show(true);
                    _onLineIcon.updateTxt(_onlineRewardShieldCfg.reincarn, _onlineRewardShieldCfg.level);
                }
            } else
            {//全部领完
                if (_onLineIcon)
                    _onLineIcon.show(false);
            }
        }

        private function getIconName(desc:String):String
        {
            var job:int = RoleDataManager.instance.job;
            var sex:int = RoleDataManager.instance.sex;
            var arr:Array = desc.split("|");
            if (arr.length <= 1)
            {
                return arr[0];
            }

            var adds:Array, itemJob:int, itemSex:int;
            for each(var str:String in arr)
            {
                adds = str.split("_");
                itemJob = adds[0];
                itemSex = adds[1];
                if (itemJob == 0 || itemJob == job)
                {
                    if (itemSex == 0 || itemSex == sex)
                    {
                        return str;
                    }
                }
            }
            return null;
        }

        private function initData():void
        {
            mouseHandle = new OnlineShieldMouseEvent(this);
            initLockStateObserver();
            checkLockState(UnlockFuncId.UNLOCK_ONLINE_EQUIP);
        }

        private function initLockStateObserver():void
        {
            if (!_unlockObserver)
            {
                _unlockObserver = new UnlockObserver();
                _unlockObserver.setCallback(checkLockState);
                GuideSystem.instance.unlockStateNotice.attach(_unlockObserver);
            }
        }

        private function destroyLockStateObserver():void
        {
            if (_unlockObserver)
            {
                _unlockObserver.destroy();
                GuideSystem.instance.unlockStateNotice.detach(_unlockObserver);
                _unlockObserver = null;
            }
        }

        private function checkLockState(id:int):void
        {
            if (id == UnlockFuncId.UNLOCK_ONLINE_EQUIP)
            {
                visible = GuideSystem.instance.isUnlock(id);
            }
        }

        public function update(proc:int = 0):void
        {
            if (proc == GameServiceConstants.SM_ONLINE_SHIELD_REWARD_GET)
            {
                updateIcon();
            } else if (proc == GameServiceConstants.CM_GET_ONLINE_SHIELD_REWARD)
            {
                successHandler();
            } else if (proc == GameServiceConstants.SM_CHR_INFO)
            {
                if (RoleDataManager.instance.oldLv != RoleDataManager.instance.lv)
                {
                    if (OnlineRewardDataManager.instance.count != -1)
                    {
                        if (_onLineIcon && _onlineRewardShieldCfg)
                        {
                            _onLineIcon.refresh();
                        }
                    }
                }
            }
        }

        public function storeBmp():void
        {
            _flyBmp = _onLineIcon.getBitmap();
        }

        private function successHandler():void
        {
            var mgt:OnlineRewardDataManager = OnlineRewardDataManager.instance;
            var rewardId:int = mgt.rewardId;
            var cfg:OnlineRewardShieldCfgData = ConfigDataManager.instance.onlineRewardShieldCfgData(rewardId);
            var mc:McMainUIBottom = (MainUiMediator.getInstance().bottomBar as BottomBar).skin as McMainUIBottom;
            if (cfg)
            {
                var startPoint:Point, endPoint:Point, type:int;
                if (_skin)
                    startPoint = _skin.localToGlobal(new Point(_skin.x + ((_skin.width) >> 1), _skin.y + 20));
                if (cfg.isuse)
                {
                    if (cfg.id == OnlineRewardDataManager.FIRE_DRAGON_TYPE || cfg.id == OnlineRewardDataManager.SHIELD_TYPE)
                    {
                        if (mc)
                            endPoint = mc.localToGlobal(new Point(mc.ringUpBtn.x + (mc.ringUpBtn.width) * .5 - 5, mc.ringUpBtn.y + ((mc.ringUpBtn.height) >> 1)));
                        type = 1;
                    } else if (cfg.id == OnlineRewardDataManager.WING_TYPE)
                    {//飘翅膀
                        if (mc)
                            endPoint = mc.localToGlobal(new Point(mc.btnWing.x + (mc.btnWing.width) * .5 - 5, mc.btnWing.y + ((mc.btnWing.height) >> 1)));
                        type = 2;
                    }
                } else
                {
                    if (mc)
                        endPoint = mc.localToGlobal(new Point(mc.btnBag.x + (mc.btnBag.width) * .5 - 5, mc.btnBag.y + ((mc.btnBag.height) >> 1)));
                    type = 0;
                }
                ////flyAnimal
                if (_flyBmp)
                {
                    FlyEffectMediator.instance.doFlyOnlineShield(type, _flyBmp, startPoint, endPoint);
                    _flyBmp = null;
                }
                if (cfg.isuse)
                {
                    var panelName:String;
                    if (rewardId == OnlineRewardDataManager.FIRE_DRAGON_TYPE || rewardId == OnlineRewardDataManager.SHIELD_TYPE)
                    {
                        panelName = PanelConst.TYPE_CONVERT_LIST;
                    } else if (rewardId == OnlineRewardDataManager.WING_TYPE)
                    {
                        panelName = PanelConst.TYPE_WING;
                    }

                    PanelMediator.instance.openPanel(panelName);
                    var panelBase:IPanelBase = PanelMediator.instance.openedPanel(panelName);
                    if (rewardId == OnlineRewardDataManager.FIRE_DRAGON_TYPE)
                    {
                        if (panelBase is ConvertListPanelNew)
                        {
                            (panelBase as ConvertListPanelNew).setSelectTabShow(0);
                        }
                    } else if (rewardId == OnlineRewardDataManager.SHIELD_TYPE)
                    {
                        if (panelBase is ConvertListPanelNew)
                        {
                            (panelBase as ConvertListPanelNew).setSelectTabShow(1);
                        }
                    } else if (rewardId == OnlineRewardDataManager.WING_TYPE)
                    {

                    }
                }
            }
            if (!ConfigDataManager.instance.onlineRewardShieldCfgData(rewardId + 1))
            {
                destory();
            }
        }

        public function showTips(visible:Boolean):void
        {
            if (visible)
            {
                var cfg:OnlineRewardShieldCfgData = getOnlineRewardShieldCfg();
                if (cfg)
                {
                    _tipIcon = new OnlineTip();
                    _tipIcon.x = 81;
                    _tipIcon.y = 97;
                    _skin.addChild(_tipIcon);
                    _tipIcon.setData(cfg);
                }
            } else
            {
                if (_tipIcon)
                {
                    if (_skin.contains(_tipIcon))
                    {
                        _skin.removeChild(_tipIcon);
                        _tipIcon.destroy();
                    }
                    _tipIcon = null;
                }
            }
        }

        private function getOnlineRewardShieldCfg():OnlineRewardShieldCfgData
        {
            var index:int = OnlineRewardDataManager.instance.count + 1;
            return ConfigDataManager.instance.onlineRewardShieldCfgData(index);
        }

        private function destroyIcon():void
        {
            if (_onLineIcon)
            {
                if (_onLineIcon.parent)
                {
                    _skin.removeChild(_onLineIcon);
                    _onLineIcon.destroy();
                    _onLineIcon = null;
                }
            }
        }

        private function destory():void
        {
            destroyLockStateObserver();
            OnlineRewardDataManager.instance.detach(this);
            RoleDataManager.instance.detach(this);
            if (mouseHandle)
            {
                mouseHandle.destory();
                mouseHandle = null;

                if (_mouseSp)
                {
                    if (contains(_mouseSp))
                    {
                        removeChild(_mouseSp);
                        _mouseSp = null;
                    }
                }
            }
            if (_tipIcon)
            {
                if (_tipIcon.parent)
                {
                    _skin.removeChild(_tipIcon);
                }
                _tipIcon.destroy();
                _tipIcon = null;
            }
            if (_skin)
            {
                if (_onLineIcon)
                {
                    destroyIcon();
                    _onLineIcon = null;
                }
                if (_skin.parent)
                {
                    removeChild(_skin);
                }
                _skin = null;
            }
            _onlineRewardShieldCfg = null;
        }

        public function get onLineIcon():OnlineShieldIcon
        {
            return _onLineIcon;
        }
    }
}

import com.model.business.fileService.constants.ResourcePathConstants;
import com.model.configData.ConfigDataManager;
import com.model.configData.cfgdata.EquipCfgData;
import com.model.configData.cfgdata.OnlineRewardShieldCfgData;
import com.model.consts.SlotType;
import com.model.consts.StringConst;
import com.model.gameWindow.rsr.RsrLoader;
import com.view.gameWindow.mainUi.subuis.McOnlineShield;
import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
import com.view.gameWindow.util.UIEffectLoader;
import com.view.gameWindow.util.UtilItemParse;
import com.view.gameWindow.util.propertyParse.CfgDataParse;

import flash.display.Sprite;

class OnlineTip extends Sprite
{
    private var _rsrLoader:RsrLoader;
    private var _mcShield:McOnlineShield;
    private var _effect:UIEffectLoader;

    public function OnlineTip()
    {
        initIcon();
        initTxt();
        mouseChildren = false;
        mouseEnabled = false;
    }

    private function initIcon():void
    {
        _rsrLoader = new RsrLoader();
        _mcShield = new McOnlineShield();

        _rsrLoader.load(_mcShield, ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD, false);
        addChild(_mcShield);
    }

    private function initTxt():void
    {
        _mcShield.mouseEnabled = false;
        _mcShield.txt_06.mouseEnabled = false;
        _mcShield.txt_02.text = StringConst.SHIELD_0003;
    }

    public function setData(cfg:OnlineRewardShieldCfgData):void
    {
        var url:String = "shield/" + getIconName(cfg.icon) + ResourcePathConstants.POSTFIX_SWF;
        _effect = new UIEffectLoader(_mcShield.icon, 0, 0, 1, 1, url);

        var onlineRewardCfg:OnlineRewardShieldCfgData = cfg;
        var attrs:Vector.<String> = new Vector.<String>();

        var giftId:int = getRewardId(onlineRewardCfg.gift_reward);
        var equipCfg:EquipCfgData = ConfigDataManager.instance.equipCfgData(giftId);
        _mcShield.txtName.text = equipCfg.name;
        attrs.push(equipCfg.attr);
        if (equipCfg && attrs.length > 0)
        {
            var vecAttrs:Vector.<String> = CfgDataParse.getAttHtmlStringArray2(attrs);
            _mcShield.txt_06.htmlText = CfgDataParse.VectorToString(vecAttrs);
        }
    }

    private function getRewardId(desc:String):int
    {
        var arr:Array = desc.split("|");
        if (arr && arr.length <= 1)
        {
            return int(UtilItemParse.getItemString(arr[0])[3]);
        }

        var job:int = RoleDataManager.instance.job;
        var sex:int = RoleDataManager.instance.sex;
        var adds:Array, item_sex:int, item_job:int;

        for (var i:int = 0, len:int = arr.length; i < len; i++)
        {
            adds = UtilItemParse.getLoginReward(arr[i]);
            if (adds[1] == SlotType.IT_EQUIP)
            {
                item_job = adds[3];
                item_sex = adds[4];
                if (item_job == 0 || item_job == job)
                {
                    if (item_sex == 0 || item_sex == sex)
                    {
                        return adds[0];
                    }
                }
            }
        }
        return 0;
    }

    private function getIconName(desc:String):String
    {
        var job:int = RoleDataManager.instance.job;
        var sex:int = RoleDataManager.instance.sex;
        var arr:Array = desc.split("|");
        if (arr.length <= 1)
        {
            return arr[0];
        }

        var adds:Array;
        for each(var str:String in arr)
        {
            adds = str.split("_");
            if (adds[0] == 0 || adds[0] == job)
            {
                if (adds[1] == 0 || adds[1] == sex)
                {
                    return str;
                }
            }
        }
        return null;
    }

    public function destroy():void
    {
        if (_rsrLoader)
        {
            _rsrLoader.destroy();
            _rsrLoader = null;
        }
        if (_effect)
        {
            _effect.destroy();
            _effect = null;
        }

        if (_mcShield)
        {
            if (contains(_mcShield))
            {
                removeChild(_mcShield);
                _mcShield = null;
            }
        }
    }
}