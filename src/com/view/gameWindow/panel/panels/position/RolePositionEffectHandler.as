package com.view.gameWindow.panel.panels.position
{
    import com.event.GameDispatcher;
    import com.event.GameEvent;
    import com.event.GameEventConst;
    import com.greensock.TweenMax;
    import com.model.business.fileService.UrlBitmapDataLoader;
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.consts.EffectConst;
    import com.view.gameWindow.flyEffect.FlyEffectMediator;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.util.ObjectUtils;
    import com.view.gameWindow.util.UIEffectLoader;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Point;

    /**
     * Created by Administrator on 2015/2/12.
     */
    public class RolePositionEffectHandler implements IUrlBitmapDataLoaderReceiver
    {
        private var _panel:PositionPanel;
        private var _upEffect:UIEffectLoader;
        private var _container:Sprite;
        private var _bmpContainer:Sprite;
        private var _flyContainer:Sprite;
        private var _urlBitmapDataLoader:UrlBitmapDataLoader;
        private var _equipCfg:EquipCfgData;
        private var _type:int;

        public function RolePositionEffectHandler(panel:PositionPanel)
        {
            this._panel = panel;
            _flyContainer = FlyEffectMediator.instance.layer;

            _container = new Sprite();
            _bmpContainer = new Sprite();
            _container.mouseEnabled = false;
            _bmpContainer.mouseEnabled = false;
            _flyContainer.addChild(_bmpContainer);

            GameDispatcher.addEventListener(GameEventConst.POSITION_EFFECT, onEffectHandler, false, 0, true);
        }

        private function onEffectHandler(event:GameEvent):void
        {
            _type = event.param.type;
            if (_type == 1)
            {
                _panel._mcPosition.btnGet.addChild(_container);
                _container.x = _panel._mcPosition.btnGet.width >> 1;
                _container.y = _panel._mcPosition.btnGet.height >> 1;
            } else if (_type == 2)
            {
                _panel._mcPosition.btnGet2.addChild(_container);
                _container.x = _panel._mcPosition.btnGet2.width >> 1;
                _container.y = _panel._mcPosition.btnGet2.height >> 1;
            }
            _equipCfg = ConfigDataManager.instance.equipCfgData(event.param.id);

            var url:String = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD + _equipCfg.icon + ResourcePathConstants.POSTFIX_PNG;
            _urlBitmapDataLoader = new UrlBitmapDataLoader(this);
            _urlBitmapDataLoader.loadBitmap(url, null, true);
        }

        public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
        {
            _upEffect = new UIEffectLoader(_container, 0, 0, 1, 1, EffectConst.RES_BAG_UP, null, true);
            var bmp:Bitmap;
            if (bitmapData)
            {
                bmp = new Bitmap(bitmapData);
                bmp.width = bmp.height = 40;
                _bmpContainer.addChild(bmp);
            }
            var startP:Point;
            var endP:Point;
            var mc:McMainUIBottom = (MainUiMediator.getInstance().bottomBar as BottomBar).skin as McMainUIBottom;
            if (_type == 1)
            {
                startP = _panel._mcPosition.localToGlobal(new Point(_panel._mcPosition.btnGet.x, _panel._mcPosition.btnGet.y));
                if (mc)
                {
                    endP = mc.localToGlobal(new Point(mc.roleBtn.x, mc.roleBtn.y));
                }
            } else if (_type == 2)
            {
                startP = _panel._mcPosition.localToGlobal(new Point(_panel._mcPosition.btnGet2.x, _panel._mcPosition.btnGet2.y));
                if (mc)
                {
                    endP = mc.localToGlobal(new Point(mc.btnHero.x, mc.btnHero.y));
                }
            }
            if (bmp && startP && endP)
            {
                TweenMax.fromTo(bmp, 1, {x: startP.x, y: startP.y}, {
                    x: endP.x,
                    y: endP.y,
                    onComplete: onCompleteHandler
                });
            }
        }

        private function onCompleteHandler():void
        {
            if (_type == 1)
            {
                GameDispatcher.dispatchEvent(GameEventConst.THING_INTO_BAG_EFFECT, {type: 1});
            } else if (_type == 2)
            {
                GameDispatcher.dispatchEvent(GameEventConst.THING_INTO_BAG_EFFECT, {type: 9});
            }
            if (_bmpContainer)
            {
                TweenMax.killTweensOf(_bmpContainer);
                ObjectUtils.clearAllChild(_bmpContainer);
            }
        }

        public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
        {
        }

        public function urlBitmapDataError(url:String, info:Object):void
        {
        }

        public function destroy():void
        {
            GameDispatcher.removeEventListener(GameEventConst.POSITION_EFFECT, onEffectHandler);
            if (_upEffect)
            {
                _upEffect.destroy();
                _upEffect = null;
            }
            if (_container && _container.parent)
            {
                _container.parent.removeChild(_container);
                _container = null;
            }

            if (_bmpContainer && _bmpContainer.parent)
            {
                _flyContainer.removeChild(_bmpContainer);
                ObjectUtils.clearAllChild(_bmpContainer);
                _bmpContainer = null;
                _flyContainer = null;
            }

            if (_urlBitmapDataLoader)
            {
                _urlBitmapDataLoader.destroy();
                _urlBitmapDataLoader = null;
            }

            if (_equipCfg)
            {
                _equipCfg = null;
            }

            if (_panel)
            {
                _panel = null;
            }
        }
    }
}
