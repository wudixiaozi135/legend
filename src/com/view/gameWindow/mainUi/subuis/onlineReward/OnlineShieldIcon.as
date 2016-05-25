package com.view.gameWindow.mainUi.subuis.onlineReward
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.configData.cfgdata.OnlineRewardShieldCfgData;
    import com.model.consts.EffectConst;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.HighlightEffectManager;
    import com.view.gameWindow.mainUi.subuis.McOnlineShieldIcon;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.util.UIEffectLoader;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.filters.GlowFilter;
    import flash.text.TextField;

    import mx.utils.StringUtil;

    /**
     * Created by Administrator on 2015/3/7.
     */
    public class OnlineShieldIcon extends McOnlineShieldIcon
    {
        private var _rsrLoader:RsrLoader;
        private var _text:TextField;
        private var _hightLight:HighlightEffectManager;
        private var _cfg:OnlineRewardShieldCfgData;
        private var _isLoaded:Boolean;
        private var _effect:UIEffectLoader;
        private var _effectContainer:Sprite;
        public function OnlineShieldIcon(url:String, cfg:OnlineRewardShieldCfgData = null)
        {
            super();
            this._cfg = cfg;
            _rsrLoader = new RsrLoader();
            shilelds.resUrl = url;
            _rsrLoader.addCallBack(shilelds, callBack);
            _rsrLoader.load(this, ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD);
            mouseChildren = false;
            mouseEnabled = false;
            initText();
            _effectContainer = new Sprite();
            _effectContainer.mouseEnabled = false;
            _effectContainer.mouseChildren = false;
            addChild(_effectContainer);
            _hightLight = new HighlightEffectManager();
        }

        private function callBack(mc:MovieClip):void
        {
            _isLoaded = true;
//            if (_cfg)
//            {
//                if (RoleDataManager.instance.checkReincarnLevel(_cfg.reincarn, _cfg.level))
//                {
//                    _hightLight.show(mc, mc);
//                } else
//                {
//                    _hightLight.hide(mc);
//                }
//            }
            addEffect();
        }

        public function getBitmap():Bitmap
        {
            var bmd:BitmapData = new BitmapData(shilelds.width, shilelds.height, true, 0xf);
            bmd.draw(shilelds);
            var bmp:Bitmap = new Bitmap(bmd);
            return bmp;
        }

        private function initText():void
        {
            _text = new TextField();
            _text.height = 20;
            _text.mouseEnabled = false;
            _text.textColor = 0x00ff00;
            _text.autoSize = "center";
            _text.filters = [new GlowFilter(0, 1, 2, 2, 10)];
            addChild(_text);
            _text.y = this.height;
            _text.x = (width - _text.width) * .5;
        }

        public function updateTxt(reincarn:int, lv:int):void
        {
            if (RoleDataManager.instance.checkReincarnLevel(reincarn, lv))
            {
                _text.textColor = 0x00ff00;
                _text.text = StringConst.SHIELD_0002;
            } else
            {
                _text.textColor = 0x6a6a6a;
                if (reincarn > 0)
                {
                    _text.text = StringUtil.substitute(StringConst.SHIELD_0005, reincarn, lv);
                } else
                {
                    _text.text = StringUtil.substitute(StringConst.SHIELD_0004, lv);
                }
            }
        }

        public function refresh():void
        {
            if (_cfg)
            {
                if (RoleDataManager.instance.checkReincarnLevel(_cfg.reincarn, _cfg.level))
                {
                    _text.textColor = 0x00ff00;
                    _text.text = StringConst.SHIELD_0002;
                }
            }
        }

        public function addEffect():void
        {
            if (shilelds && _isLoaded)
            {
//                _hightLight.show(shilelds, shilelds);
                var posX:Number = (width + 80) >> 1;
                var posY:Number = (height + 20) >> 1;
                if (_effect == null)
                {
                    _effect = new UIEffectLoader(_effectContainer, 0, 0, 1, 1, EffectConst.RES_ONLINE_EQUIP_EFFECT, function ():void
                    {
                        if (_effectContainer)
                        {
                            _effectContainer.x = -posX;
                            _effectContainer.y = -posY;
                        }
                    });
                }
            }
        }

        public function show(bool:Boolean):void
        {
            visible = bool;
        }

        public function destroy():void
        {
            if (_effect)
            {
                _effect.destroy();
                _effect = null;
            }
            if (_effectContainer)
            {
                if (contains(_effectContainer))
                {
                    removeChild(_effectContainer);
                }
                _effectContainer = null;
            }
            if (contains(_text))
            {
                _text.filters = null;
                removeChild(_text);
                _text = null;
            }
            if (_hightLight)
            {
                if (shilelds)
                {
                    _hightLight.hide(shilelds);
                }
                _hightLight = null;
            }
            if (_rsrLoader)
            {
                _rsrLoader.destroy();
                _rsrLoader = null;
            }
            if (_cfg)
            {
                _cfg = null;
            }
        }
    }
}
