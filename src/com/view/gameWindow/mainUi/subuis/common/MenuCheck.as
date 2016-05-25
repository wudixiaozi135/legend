package com.view.gameWindow.mainUi.subuis.common
{
    import com.model.business.fileService.UrlSwfLoader;
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.business.fileService.interf.IUrlSwfLoaderReceiver;
    import com.view.gameWindow.util.Zoom9Grid;

    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    /**
     * Created by Administrator on 2014/12/27.
     */
    public class MenuCheck extends Sprite implements IUrlSwfLoaderReceiver
    {
        private var _swfLoader:UrlSwfLoader;
        private var _bitmap:Bitmap;
        private var _zoom9Grid:Zoom9Grid;
        protected var _container:Sprite;
        private var _data:Array;
        private var _dic:Dictionary;
        public function MenuCheck()
        {
            super();
            _swfLoader = new UrlSwfLoader(this);
            _swfLoader.loadSwf(url);
            _bitmap = new Bitmap();
            addChild(_bitmap);

            _container = new Sprite();
            addChild(_container);
            _dic = new Dictionary(true);
            initialize();
        }

        private function initialize():void
        {
            initChildren();
            addEvent();
        }

        protected function initChildren():void
        {

        }

        protected function addEvent():void
        {

        }

        public function get dic():Dictionary
        {
            return _dic;
        }
        public function get data():Array
        {
            return _data;
        }

        public function set data(value:Array):void
        {
            _data = value;
            if (_data)
            {
                for (var i:int = 0, len:int = _data.length; i < len; i++)
                {
                    var item:CheckItemBase = _data[i];
                    _dic[item.id] = item;
                    if (!_container.contains(item))
                        _container.addChild(item);
                }
                resetLayout();
            }
        }

        protected function resetLayout():void
        {
            for (var i:int = 0, len:int = _data.length; i < len; i++)
            {
                var child:CheckItemBase = _data[i] as CheckItemBase;
                child.x = 0;
                child.y = (child.height + 1) * i;
            }
            resetWH(_container.width, _container.height);
        }

        protected function get url():String
        {
            return ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD + "bagPanel/menuBg" + ResourcePathConstants.POSTFIX_SWF;
        }

        public function swfReceive(url:String, swf:Sprite, info:Object):void
        {
            _zoom9Grid = new Zoom9Grid(swf, new Rectangle(8, 8, swf.width - 16, swf.height - 16));
            resetLayout();
        }

        protected function resetWH(w:int, h:int):void
        {
            if (_zoom9Grid)
            {
                _zoom9Grid.width = w + 10;
                _zoom9Grid.height = h + 10;
                _bitmap.cacheAsBitmap = true;
                _bitmap.smoothing = true;
                _bitmap.bitmapData = _zoom9Grid.bitmapData;

                _container.x = (width - _container.width) >> 1;
                _container.y = (height - _container.height) >> 1;
            }
        }

        public function swfProgress(url:String, progress:Number, info:Object):void
        {
        }

        public function swfError(url:String, info:Object):void
        {
        }

        public function destroy():void
        {
            if (_swfLoader)
            {
                _swfLoader.destroy();
            }
            if (_bitmap && _bitmap.bitmapData)
            {
                _bitmap.bitmapData.dispose();
                if (contains(_bitmap))
                {
                    removeChild(_bitmap);
                    _bitmap = null;
                }
            }
            if (_zoom9Grid)
            {
                _zoom9Grid.destroy();
                _zoom9Grid = null;
            }
            if (contains(_container))
            {
                removeChild(_container);
                _container = null;
            }
            if (_data)
            {
                _data.forEach(function (element:CheckItemBase, index:int, array:Array):void
                {
                    element.destroy();
                    element = null;
                });
                _data.length = 0;
                _data = null;
            }
        }
    }
}
