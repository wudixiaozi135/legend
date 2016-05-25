package com.view.gameWindow.scene.darkmask
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapCfgData;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.map.SceneMapManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	public class DarkMask extends Sprite implements IObserver
	{
		private var _ready:Boolean;
		private var _darkMaskBitmap:Bitmap;
		private var _darkMaskBitmapData:BitmapData;
		private var _edgeMaskBitmapData:BitmapData;
		private var _leftMaskBitmap:Bitmap;
		private var _rightMaskBitmap:Bitmap;
		private var _topMaskBitmap:Bitmap;
		private var _bottomMaskBitmap:Bitmap;
		
		private var _width:int;
		private var _height:int;
		
		public function DarkMask()
		{
			_ready = false;
			visible = false;
			cacheAsBitmap = true;
			
			EntityLayerManager.getInstance().attach(this);
		}
		
		private function build():void
		{
			var bitmapData1:BitmapData = new BitmapData(80, 80, false, 0xA0A0A0);
			var drawItem:Sprite = new Sprite();
			drawItem.graphics.clear();
			drawItem.graphics.beginFill(0x000000, 1.0);
			drawItem.graphics.drawCircle(40, 40, 10);
			drawItem.graphics.endFill();
			var filter:GlowFilter = new GlowFilter(0x000000, 1.0, 40, 40, 5);
			drawItem.filters = [filter];
			bitmapData1.draw(drawItem);
			drawItem.graphics.clear();
			var bitmapData2:BitmapData = new BitmapData(80, 80, true, 0x00000000);
			bitmapData2.copyChannel(bitmapData1, bitmapData1.rect, new Point(), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
			bitmapData1.dispose();
			
			_darkMaskBitmap = new Bitmap();
			_darkMaskBitmap.bitmapData = bitmapData2;
			_darkMaskBitmap.width = 1200;
			_darkMaskBitmap.height = 900;
			_darkMaskBitmap.smoothing = true;
			_darkMaskBitmap.x = -600;
			_darkMaskBitmap.y = -500;
			addChild(_darkMaskBitmap);
			
			_edgeMaskBitmapData = new BitmapData(100, 100, true, 0xA0000000);
			_leftMaskBitmap = new Bitmap();
			_leftMaskBitmap.bitmapData = _edgeMaskBitmapData;
			addChild(_leftMaskBitmap);
			_rightMaskBitmap = new Bitmap();
			_rightMaskBitmap.bitmapData = _edgeMaskBitmapData;
			addChild(_rightMaskBitmap);
			_topMaskBitmap = new Bitmap();
			_topMaskBitmap.bitmapData = _edgeMaskBitmapData;
			addChild(_topMaskBitmap);
			_bottomMaskBitmap = new Bitmap();
			_bottomMaskBitmap.bitmapData = _edgeMaskBitmapData;
			addChild(_bottomMaskBitmap);
			
			_ready = true;
		}
		
		private function clear():void
		{
			if (_ready)
			{
				if (_darkMaskBitmapData)
				{
					_darkMaskBitmapData.dispose();
				}
				if (_edgeMaskBitmapData)
				{
					_edgeMaskBitmapData.dispose();
				}
				_darkMaskBitmap.bitmapData = null;
				_leftMaskBitmap.bitmapData = null;
				_rightMaskBitmap.bitmapData = null;
				_topMaskBitmap.bitmapData = null;
				_bottomMaskBitmap.bitmapData = null;
				if (contains(_darkMaskBitmap))
				{
					removeChild(_darkMaskBitmap);
				}
				if (contains(_leftMaskBitmap))
				{
					removeChild(_leftMaskBitmap);
				}
				if (contains(_rightMaskBitmap))
				{
					removeChild(_rightMaskBitmap);
				}
				if (contains(_topMaskBitmap))
				{
					removeChild(_topMaskBitmap);
				}
				if (contains(_bottomMaskBitmap))
				{
					removeChild(_bottomMaskBitmap);
				}
				_darkMaskBitmap = null;
				_leftMaskBitmap = null;
				_rightMaskBitmap = null;
				_topMaskBitmap = null;
				_bottomMaskBitmap = null;
				_ready = false;
			}
		}
		
		private function resetSubItems():void
		{
			if (visible && _ready)
			{
				_leftMaskBitmap.width = _width - _darkMaskBitmap.width / 2;
				_leftMaskBitmap.height = _height * 2;
				_leftMaskBitmap.x = _darkMaskBitmap.x - _leftMaskBitmap.width;
				_leftMaskBitmap.y = -_leftMaskBitmap.height / 2;
				_rightMaskBitmap.width = _width - _darkMaskBitmap.width / 2;
				_rightMaskBitmap.height = _height * 2;
				_rightMaskBitmap.x = _darkMaskBitmap.x + _darkMaskBitmap.width;
				_rightMaskBitmap.y = -_rightMaskBitmap.height / 2;
				_topMaskBitmap.width = _darkMaskBitmap.width;
				_topMaskBitmap.height = _height - _darkMaskBitmap.height / 2;
				_topMaskBitmap.x = _darkMaskBitmap.x;
				_topMaskBitmap.y = _darkMaskBitmap.y - _topMaskBitmap.height;
				_bottomMaskBitmap.width = _darkMaskBitmap.width;
				_bottomMaskBitmap.height = _height - _darkMaskBitmap.height / 2;
				_bottomMaskBitmap.x = _darkMaskBitmap.x;
				_bottomMaskBitmap.y = _darkMaskBitmap.y + _darkMaskBitmap.height;
			}
		}
		
		public function resetCenterPos(xPos:int, yPos:int):void
		{
			var change:Boolean = false;
			if (x != xPos)
			{
				x = xPos;
				change = true;
			}
			if (y != yPos)
			{
				y = yPos;
				change = true;
			}
			if (change)
			{
				resetSubItems();
			}
		}
		
		public function resize(newWidth:int, newHeight:int):void
		{
			_width = newWidth;
			_height = newHeight;
			resetSubItems();
		}
		
		public function showMask(show:Boolean):void
		{
			if (visible != show)
			{
				visible = show;
				if (show)
				{
					build();
					resetSubItems();
				}
				else
				{
					clear();
				}
			}
		}
		
		public function update(proc:int = 0):void
		{
			if (proc == GameServiceConstants.SM_ENTER_MAP)
			{
				var mapCfg:MapCfgData = ConfigDataManager.instance.mapCfgData(SceneMapManager.getInstance().mapId);
				if (mapCfg)
				{
					showMask(mapCfg.darkmask > 0);
				}
			}
		}
	}
}