package com.view.gameWindow.panel.panels.equipRecycle
{
    import com.event.GameDispatcher;
    import com.event.GameEventConst;
    import com.greensock.TweenLite;
    import com.greensock.TweenMax;
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.consts.EffectConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.flyEffect.FlyEffectMediator;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.McEquipStoneEffect;
    import com.view.gameWindow.util.LoaderCallBackAdapter;
    import com.view.gameWindow.util.UIEffectLoader;
    import com.view.newMir.NewMirMediator;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    import flash.utils.setTimeout;

    /**
     * Created by Administrator on 2015/1/10.
     */
    public class EquipRecycleEffectHandler
    {
        private  var isAllFinish:int = 0;
        private var _panel:Sprite;
        private var _stoneNum:Vector.<CountDownPic>;
        private var _awardInfos:Array;
        private var _flyDatas:Array = [];
        private var _bmpPools:Dictionary;

        private var _stoneLayer:McEquipStoneEffect;
        private var _expBallContainer:Sprite;
        private var _expBallEffect:UIEffectLoader;
        private var _expShow:Boolean = false;
		public var doing:Boolean;
        public function EquipRecycleEffectHandler(panel:Sprite)
        {
			doing=true;
            _panel = panel;
            _awardInfos = EquipRecycleDataManager.instance.awardInfo;
            _expShow = EquipRecycleDataManager.totalExpShow;
            _expBallContainer = new Sprite();
            _expBallContainer.mouseEnabled = false;
            _expBallContainer.mouseChildren = false;
            _expBallEffect = new UIEffectLoader(_expBallContainer, 0, 0, 1, 1, EffectConst.RES_EXP_BALL);

            _stoneLayer = new McEquipStoneEffect();
            var stoneRsrloader:RsrLoader = new RsrLoader();
            var adapt2:LoaderCallBackAdapter = new LoaderCallBackAdapter();
            adapt2.addCallBack(stoneRsrloader, function ():void
            {
				if(doing==false)return;
                adapt2 = null;
                _panel.addChild(_stoneLayer);

                var panelEquip:PanelEquipRecycle = PanelMediator.instance.openedPanel(PanelConst.TYPE_EQUIP_RECYCLE) as PanelEquipRecycle;
                if (panelEquip)
                {
                    _stoneLayer.x = panelEquip.x + 190;
                    _stoneLayer.y = panelEquip.y + 100;
                } else
                {
                    _stoneLayer.x = (NewMirMediator.getInstance().width - _stoneLayer.width) >> 1;
                    _stoneLayer.y = (NewMirMediator.getInstance().height - _stoneLayer.height) >> 1;
                }
				initShow();
            }, _stoneLayer.bg);
            stoneRsrloader.load(_stoneLayer, ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
			isAllFinish = 0;
        }

        public function initShow():void
        {
            _bmpPools = new Dictionary(true);

			var exp:int = EquipRecycleDataManager.instance.recycleExp;
            var bool:Boolean =  exp>0;
            if (bool)
            {
                addExpBallEffect();
            }

            var data:Array = _awardInfos;
            _stoneNum = new Vector.<CountDownPic>();
            for (var i:int = 0, len:int = data.length; i < len; i++)
            {
                var countPic:CountDownPic = new CountDownPic(_stoneLayer["numContainer" + (i + 1)], data[i], 100);
                countPic.callBack = numLoaderCompleFunc;
                _stoneNum.push(countPic);
            }
		
			_expNum = new CountDownPicGreen(_stoneLayer.numContainer4,exp);
			_expNum.callBack=numLoaderCompleFunc;
        }

        //奖励石头消失
        private function rewardStoneLayerHandler():void
        {
			if(doing==false)return;
            TweenMax.fromTo(_stoneLayer, 1.5, {alpha: 1}, {
                alpha: 0, scaleX: 0, scaleY: 0,
                onComplete: function ():void
                {
                    if (_stoneLayer)
                    {
                        TweenLite.killTweensOf(_stoneLayer);
                        _stoneLayer.visible = false;
                    }
                    stoneLayerHandler();
                }
            });
        }

        private var _during:Number = 1;

        private var _expNum:CountDownPicGreen;
        private function addExpBallEffect():void
        {
            _panel.addChildAt(_expBallContainer, _panel.numChildren - 1);
            var offX:Number = (NewMirMediator.getInstance().width - 50) >> 1;
            var offY:Number = (NewMirMediator.getInstance().height - _expBallContainer.height) >> 1;
            _expBallContainer.x = offX;
            _expBallContainer.y = offY;

            tweenFly();
        }

        public function tweenFly():void
        {
            var rect:Rectangle = MainUiMediator.getInstance().bottomBar.getCurrentExpRect();
            var endX:Number = rect.x + rect.width;
            var endY:Number = rect.y + rect.height;
            TweenMax.to(_expBallContainer, _during, {
                x: endX,
                y: endY,
                scaleX: 0.6,
                scaleY: 0.6,
//                onUpdate: onUpdateHandler,
                onComplete: onFlyExpBall
            });
        }

        private function onUpdateHandler():void
        {
            TweenMax.killTweensOf(_expBallContainer);
            _during -= 0.02;
            tweenFly();
        }

        private function onFlyExpBall():void
        {
            if (_expBallEffect)
            {
                _expBallEffect.destroy();
                _expBallEffect = null;
            }
            if (_expBallContainer && _expBallContainer.parent)
            {
                TweenMax.killTweensOf(_expBallContainer);
                _panel.removeChild(_expBallContainer);
                _expBallContainer = null;
            }
            GameDispatcher.dispatchEvent(GameEventConst.EXP_INTO_BOTTOM);
        }

        private function stoneLayerHandler():void
        {
			if(doing==false)return;
            var stoneIds:Array = [111, 112, 113];
            var data:Array = _awardInfos;

            var totalCount:int = 0;
            data.forEach(function (element:int, index:int, array:Array):void
            {
                totalCount += element;
            });

            for (var i:int = 0, len:int = stoneIds.length; i < len; i++)
            {
                var itemId:int = stoneIds[i];
                for (var j:int = 0; j < data[i]; j++)
                {
                    var obj:Object;
                    if (!_bmpPools[itemId])
                    {
                        var stone:StoneIcon = new StoneIcon(itemId);
                        stone.callBack = callBack;
                        obj = {
                            id: itemId,
                            count: 1
                        };
                        _bmpPools[itemId] = obj;
                    } else
                    {
                        obj = _bmpPools[itemId];
                        obj.count++;
                    }
                }
            }

            ////资源回调
            function callBack(bmd:BitmapData, id:int):void
            {
				if(doing==false)return;
                var size:int = _bmpPools[id].count;
                for (var t:int = 0; t < size; t++)
                {
                    if (bmd)
                    {
                        var bmp:Bitmap = new Bitmap(bmd, "auto", true);
                        bmp.name = id.toString();
                        bmp.visible = false;
                        _stoneLayer.addChild(bmp);
                        _flyDatas.push(bmp);
                    }
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
                        FlyEffectMediator.instance.doFlyItemsIntoBag(_flyDatas);
                        destroy();
                    }
                }
            }
        }

        public function destroy():void
        {
			doing=false;
			_stoneLayer&&_stoneLayer.bg.stop();
            if (_stoneNum)
            {
                _stoneNum.forEach(function (element:CountDownPic, index:int, array:Vector.<CountDownPic>):void
                {
                    element.destroy();
                    element = null;
                });
                _stoneNum = null;
            }
			
			if(_expNum)
			{
				_expNum.destroy();
				_expNum=null;
			}
			
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
            isAllFinish = 0;
        }
		
		protected function numLoaderCompleFunc():void
		{
			// TODO Auto Generated method stub
			isAllFinish++;
			if (isAllFinish >= 4)
			{
				setTimeout(rewardStoneLayerHandler,1000);
				isAllFinish = 0;
			}
		}
	}
}

import com.model.business.fileService.UrlBitmapDataLoader;
import com.model.business.fileService.constants.ResourcePathConstants;
import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
import com.model.configData.ConfigDataManager;
import com.model.configData.cfgdata.ItemCfgData;
import com.view.gameWindow.common.ResManager;
import com.view.gameWindow.panel.panels.equipRecycle.common.McPlayUtil;
import com.view.gameWindow.util.Zoom9Grid;

import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.geom.Rectangle;

class StoneIcon implements IUrlBitmapDataLoaderReceiver
{
    public var callBack:Function;
    private var _id:int;
    private var _zoom:Zoom9Grid;
    public function StoneIcon(id:int)
    {
        _id = id;
        var urlLoader:UrlBitmapDataLoader = new UrlBitmapDataLoader(this);
        var cfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(id);
        if (cfg)
        {
            var url:String = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD + cfg.icon + ResourcePathConstants.POSTFIX_PNG;
            urlLoader.loadBitmap(url);
        }
    }

    public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
    {
        if (callBack != null)
        {
            if (bitmapData)
            {
                _zoom = new Zoom9Grid(bitmapData, new Rectangle(0, 0, bitmapData.width, bitmapData.height));
                _zoom.width = 40;
                _zoom.height = 40;
                if (_zoom.bitmapData)
                {
                    callBack(_zoom.bitmapData, _id);
                }
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
        if (_zoom)
        {
            _zoom.destroy();
            _zoom = null;
        }
    }
}

class CountDownPic
{
    private var _num:String;
    private var _container:MovieClip;
    private var _nums:Array = [];
    private var _frames:Array = [];
    private var _interval:int;
    public var callBack:Function;

    public function CountDownPic(container:MovieClip, num:int, interval:int = 50)
    {
        _container = container;
        _num = num.toString();
        _interval = interval;
        init();
    }

    private function init():void
    {
        for (var i:int = 0, len:int = _num.length; i < len; i++)
        {
            ResManager.getInstance().loadSwf(ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD + "equipRecycle/yellowNum" + ResourcePathConstants.POSTFIX_SWF, function (swf:*):void
            {
                _nums.push(swf);
                _container.addChild(swf);
                if (_nums.length == len)
                {
                    layout();
                }
            });
        }
    }

    private function layout():void
    {
        for (var i:int = 0, len:int = _nums.length; i < len; i++)
        {
            var swf:MovieClip = _nums[i] as MovieClip;
            swf.x = swf.width * i + 2;
            _frames[i] = int(_num.charAt(i));
            swf.gotoAndStop(1);
        }
        if (int(_num) > 0)
        {
            play();
        } else
        {
            if (callBack != null)
            {
                callBack();
            }
        }
    }

    private function play():void
    {
        if (_nums && _nums.length > 0)
        {
            var mc:MovieClip = _nums.shift() as MovieClip;
            McPlayUtil.toNum(mc, _frames.shift(), _interval, function ():void
            {
                play();
            });
        } else
        {
            if (callBack != null)
            {
                callBack();
            }
        }
    }

    public function destroy():void
    {
        if (_container)
        {
            while (_container.numChildren)
            {
                _container.removeChildAt(0);
            }
        }
        if (_num)
            _num = null;
        if (_nums)
        {
            _nums.length = 0;
            _nums = null;
        }
        if (_frames)
        {
            _frames.length = 0;
            _frames = null;
        }

        if (callBack != null)
            callBack = null;
    }
}

class CountDownPicGreen
{
	private var _num:String;
	private var _container:MovieClip;
	private var _nums:Array = [];
	private var _frames:Array = [];
	private var _interval:int;
	public var callBack:Function;
	
	public function CountDownPicGreen(container:MovieClip, num:int, interval:int = 50)
	{
		_container = container;
		_num = num.toString();
		_interval = interval;
		init();
	}
	
	private function init():void
	{
		for (var i:int = 0, len:int = _num.length; i < len; i++)
		{
			ResManager.getInstance().loadSwf(ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD + "equipRecycle/greenNum" + ResourcePathConstants.POSTFIX_SWF, function (swf:*):void
			{
				_nums.push(swf);
				_container.addChild(swf);
				if (_nums.length == len)
				{
					layout();
				}
			});
		}
	}
	
	private function layout():void
	{
		for (var i:int = 0, len:int = _nums.length; i < len; i++)
		{
			var swf:MovieClip = _nums[i] as MovieClip;
			swf.x = (swf.width-3) * i ;
			_frames[i] = int(_num.charAt(i));
			swf.gotoAndStop(1);
		}
		if (int(_num) > 0)
		{
			play();
		} else
		{
			if (callBack != null)
			{
				callBack();
			}
		}
	}
	
	private function play():void
	{
		if (_nums && _nums.length > 0)
		{
			var mc:MovieClip = _nums.pop() as MovieClip;
			McPlayUtil.toNum(mc, _frames.pop(), _interval, function ():void
			{
				play();
			});
		} else
		{
			if (callBack != null)
			{
				callBack();
			}
		}
	}
	
	public function destroy():void
	{
		if (_container)
		{
			while (_container.numChildren)
			{
				_container.removeChildAt(0);
			}
		}
		if (_num)
			_num = null;
		if (_nums)
		{
			_nums.length = 0;
			_nums = null;
		}
		if (_frames)
		{
			_frames.length = 0;
			_frames = null;
		}
		
		if (callBack != null)
			callBack = null;
	}
}