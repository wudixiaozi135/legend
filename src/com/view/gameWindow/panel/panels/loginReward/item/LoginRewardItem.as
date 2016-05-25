package com.view.gameWindow.panel.panels.loginReward.item
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.HighlightEffectManager;
    import com.view.gameWindow.panel.panels.loginReward.McLoginItem;

    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    import flash.geom.Rectangle;

    /**
     * Created by Administrator on 2015/2/27.
     */
    public class LoginRewardItem extends McLoginItem
    {
        public var clickHandler:Function;
        private var _day:int;
        private var _hightLightManager:HighlightEffectManager;
        private var _hightLight:Boolean;
        private var _bgLoader:Boolean = false;
        public var state:int = -1;//领取状态  0未领取 1已领取 -1不可领取

        public function LoginRewardItem(day:int)
        {
            _day = day;
            icon.resUrl = "loginReward/day" + day + ResourcePathConstants.POSTFIX_PNG;
            flag.mouseEnabled = false;
            flag.mouseChildren = false;
            icon.mouseEnabled = false;
            icon.mouseChildren = false;
            txt.mouseEnabled = false;
            txt.textColor = 0xff6600;
            txt.text = ConfigDataManager.instance.loginRewardCfg(day).name;

            _hightLightManager = new HighlightEffectManager();
            initSkin();

            mcClick.addEventListener(MouseEvent.ROLL_OUT, onRollHandler, false, 0, true);
            mcClick.addEventListener(MouseEvent.ROLL_OVER, onRollHandler, false, 0, true);
            mcClick.addEventListener(MouseEvent.CLICK, onClickHandler, false, 0, true);
        }

        public function refresh():void
        {
            if (state == 1)
            {
                flag.visible = true;
                hightLight = false;
            } else if (state == -1)
            {
                hightLight = false;
                flag.visible = false;
            } else
            {
                flag.visible = false;
            }
        }

        private function onClickHandler(event:MouseEvent):void
        {
            if (clickHandler != null)
            {
                clickHandler(this);
            }
        }

        private function onRollHandler(event:MouseEvent):void
        {
            if (event.type == MouseEvent.ROLL_OUT)
            {
                selected(false);
            } else if (event.type == MouseEvent.ROLL_OVER)
            {
                selected(true);
            }
        }

        private function initSkin():void
        {
            var rsrLoader:RsrLoader = new RsrLoader();
            addCallBack(rsrLoader);
            rsrLoader.load(this, ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
        }

        private function addCallBack(rsrLoader:RsrLoader):void
        {
            rsrLoader.addCallBack(bg, function ():void
            {
                _bgLoader = true;
                if (_hightLight)
                {
                    _hightLightManager.show(bg, bg, 0, 0);
                } else
                {
                    _hightLightManager.hide(bg);
                }
            });
        }

        public function selected(select:Boolean):void
        {
            if (_hightLight == false)
            {
                if (select)
                {
                    bg.filters = [new GlowFilter(0xffff00, 1, 6, 6, 5, 1, false, false)];
                } else
                {
                    bg.filters = null;
                }
            } else
            {
                bg.filters = null;
            }
        }

        public function getBgRect():Rectangle
        {
            return new Rectangle(0, 0, bg.width, bg.height);
        }

        public function get day():int
        {
            return _day;
        }

        public function destroy():void
        {
            if (mcClick)
            {
                mcClick.removeEventListener(MouseEvent.CLICK, onClickHandler);
                mcClick.removeEventListener(MouseEvent.ROLL_OUT, onRollHandler);
                mcClick.removeEventListener(MouseEvent.ROLL_OVER, onRollHandler);
            }
            if (_hightLightManager)
            {
                if (bg)
                {
                    bg.filters = null;
                    _hightLightManager.hide(bg);
                }
                _hightLightManager = null;
            }
        }

        public function get hightLight():Boolean
        {
            return _hightLight;
        }

        public function set hightLight(value:Boolean):void
        {
            _hightLight = value;
            if (value)
            {
                if (_bgLoader)
                {
                    _hightLightManager.show(bg, bg, 0, 0);
                } else
                {
                    _hightLightManager.hide(bg);
                }
            } else
            {
                _hightLightManager.hide(bg);
            }
        }
    }
}
