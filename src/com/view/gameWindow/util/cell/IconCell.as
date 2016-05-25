package com.view.gameWindow.util.cell
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.view.gameWindow.tips.toolTip.interfaces.IToolTipClient;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * 图标单元格类<br>
	 * @author Administrator
	 */	
	public class IconCell extends Sprite implements IUrlBitmapDataLoaderReceiver, IToolTipClient
	{
		/**_bmp：图标，_w：图标宽，_h：图标高*/
		protected var _bmp:Bitmap,_w:int,_h:int;
		
		public function get bmp():Bitmap
		{
			return _bmp;
		}
		public function get IconCellW():int
		{
			return _w;
		}
		
		public function set IconCellW(val:int):void
		{
			_w = val;
		}
		
		public function get IconCellH():int
		{
			return _h;
		}
		
		public function set IconCellH(val:int):void
		{
			_h = val;
		}
		
		private var _urlBitmapDataLoader:UrlBitmapDataLoader;

		private var _url:String;
		
		/**
		 * 构造图标单元格类
		 * @param layer 父容器
		 * @param x 相对于父容器的X
		 * @param y 相对于父容器的Y
		 * @param w 图标单元格宽
		 * @param h 图标单元格高
		 * @param layerIndex icon添加到layer上的层级，默认最上层
		 */		
		public function IconCell(layer:DisplayObjectContainer,x:int,y:int,w:int,h:int,layerIndex:int = -1)
		{
			super();
			this.x = x;
			this.y = y;
			_w = w;
			_h = h;
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
			if(layerIndex == -1)
			{
				layer.addChild(this);
			}
			else
			{
				layer.addChildAt(this,layerIndex);
			}
		}
		
		protected function loadPic(url:String):void
		{
			_url = url;
			_urlBitmapDataLoader = new UrlBitmapDataLoader(this);
			_urlBitmapDataLoader.loadBitmap(_url,null,true);
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			if(_url && url != _url)
			{
				return;
			}
			destroyBmp();
			_bmp = new Bitmap(bitmapData,"auto",true);
			_bmp.width = _w;
			_bmp.height = _h;
			_bmp.name = "iconCellBmp";
			addChildAt(_bmp,0);
			destroyLoader();
		}
		
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			destroyBmp();
			destroyLoader();
		}
		
		public function getTipData():Object
		{
			return null;
		}
		
		public function getTipType():int
		{
			return 0;
		}
		public function getBitmap():Bitmap
		{
			if(_bmp)
			{
				var bitmapData:BitmapData = _bmp.bitmapData.clone();
				return new Bitmap(bitmapData);
			}
				
			return null;
		}
		protected function destroyBmp():void
		{
			if(_bmp)
			{
				if(_bmp.parent)
				{
					_bmp.parent.removeChild(_bmp);
				}
				if(_bmp.bitmapData)
				{
					_bmp.bitmapData.dispose();
				}
				_bmp = null;
			}
		}
		
		public function isEmpty():Boolean
		{
			return _bmp == null;
		}
		
		protected function destroyLoader():void
		{
			if(_urlBitmapDataLoader)
			{
				_urlBitmapDataLoader.destroy();
				_urlBitmapDataLoader = null;
			}
		}
		
		public function destroy():void
		{
			destroyBmp();
			destroyLoader();
			_url = "";
		}
		
		public function getTipCount():int
		{
			// TODO Auto Generated method stub
			return 1;
		}
		
	}
}