package com.view.gameWindow.panel.panels.chests
{
    import com.greensock.TweenLite;
    import com.view.gameWindow.flyEffect.FlyEffectMediator;
    import com.view.newMir.NewMirMediator;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.utils.Dictionary;

    /**
     * Created by Administrator on 2015/1/10.
     */
    public class ChestsEffectHandler
    {
        private var _panel:Sprite;
        private var _awardInfos:Vector.<ChestRewardData>;
        private var _flyDatas:Array = [];
        private var _bmpPools:Dictionary;
        private var _stoneLayer:Sprite;

        public function ChestsEffectHandler(panel:Sprite)
        {
            _panel = panel;
            _stoneLayer = new Sprite();
            _panel.addChild(_stoneLayer);

            _bmpPools = new Dictionary(true);
            stoneLayerHandler();
        }

        private function stoneLayerHandler():void
        {
            _awardInfos = ChestsDataManager.instance.chestDatas;//奖励

            var totalCount:int = 0;//统计总个数
            _awardInfos.forEach(function (element:ChestRewardData, index:int, vec:Vector.<ChestRewardData>):void
            {
                totalCount += element.count;
            });

            var obj:Object, key:String, chest:ChestRewardData;
            for (var i:int = 0, len:int = _awardInfos.length; i < len; i++)
            {
                chest = _awardInfos[i];
                key = chest.id + "_" + chest.type;
                for (var j:int = 0; j < chest.count; j++)
                {
                    if (!_bmpPools[key])
                    {
                        var stone:StoneIcon = new StoneIcon(chest);
                        stone.callBack = callBack;
                        obj = {
                            id: key,
                            count: 1
                        };
                        _bmpPools[key] = obj;
                    } else
                    {
                        obj = _bmpPools[key];
                        obj.count++;
                    }
                }
            }

            ////资源回调
            function callBack(bmd:BitmapData, key:String):void
            {
                var size:int = _bmpPools[key].count;
                for (var t:int = 0; t < size; t++)
                {
                    var bmp:Bitmap = new Bitmap(bmd, "auto", true);
                    bmp.visible = false;
                    bmp.name = key.split("_")[0];
                    _stoneLayer.addChild(bmp);
                    _flyDatas.push(bmp);
                    check();
                }
            }

            function check():void
            {
                totalCount--;
                if (totalCount <= 0)
                {
                    if (_flyDatas)
                    {
                        var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
                        if (_stoneLayer)
                        {
                            _stoneLayer.x = (newMirMediator.width - _stoneLayer.width) >> 1;
                            _stoneLayer.y = (newMirMediator.height - _stoneLayer.height) >> 1;
                        }
                        FlyEffectMediator.instance.doFlyReceiveThings3(_flyDatas);
                    }
                    destroy();
                }
            }
        }

        public function destroy():void
        {
            if (_bmpPools)
            {
                _bmpPools = null;
            }

            if (_flyDatas)
            {
                _flyDatas.forEach(function (element:Bitmap, index:int, array:Array):void
                {
                    if (_stoneLayer && _stoneLayer.contains(element))
                    {
                        _stoneLayer.removeChild(element);
                        element = null;
                    }
                });
                _flyDatas.length = 0;
                _flyDatas = null;
            }
            if (_stoneLayer)
            {
                TweenLite.killTweensOf(_stoneLayer);
                if (_panel && _panel.contains(_stoneLayer))
                {
                    _panel.removeChild(_stoneLayer);
                    _stoneLayer = null;
                }
            }
            if (_awardInfos)
            {
                _awardInfos.length = 0;
                _awardInfos = null;
            }
        }
    }
}

import com.model.business.fileService.UrlBitmapDataLoader;
import com.model.business.fileService.constants.ResourcePathConstants;
import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
import com.model.configData.ConfigDataManager;
import com.model.consts.SlotType;
import com.model.gameWindow.mem.MemEquipDataManager;
import com.view.gameWindow.panel.panels.chests.ChestRewardData;
import com.view.gameWindow.util.Zoom9Grid;

import flash.display.BitmapData;
import flash.geom.Rectangle;

class StoneIcon implements IUrlBitmapDataLoaderReceiver
{
    public var callBack:Function;
    private var _key:String;

    public function StoneIcon(data:ChestRewardData)
    {
        _key = data.id + "_" + data.type;

        var urlLoader:UrlBitmapDataLoader = new UrlBitmapDataLoader(this);
        var url:String;
        var cfg:*;
        if (data.type == SlotType.IT_ITEM)
        {
            cfg = ConfigDataManager.instance.itemCfgData(data.id);
            url = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD + cfg.icon + ResourcePathConstants.POSTFIX_PNG;
        } else if (data.type == SlotType.IT_EQUIP)
        {
            cfg = MemEquipDataManager.instance.memEquipData(data.bornId, data.id).equipCfgData;
            url = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD + cfg.icon + ResourcePathConstants.POSTFIX_PNG;
        }
        urlLoader.loadBitmap(url);
    }

    public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
    {
        if (callBack != null)
        {
            if (bitmapData)
            {
                var zoom:Zoom9Grid = new Zoom9Grid(bitmapData, new Rectangle(0, 0, bitmapData.width, bitmapData.height));
                zoom.width = 40;
                zoom.height = 40;
                if (zoom.bitmapData)
                {
                    callBack(zoom.bitmapData, _key);
                }
                zoom.destroy();
                zoom = null;
            }
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
        if (callBack != null)
            callBack = null;
    }
}