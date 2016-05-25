package com.view.gameWindow.panel.panels.roleProperty.cell
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.consts.ItemType;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.panels.roleProperty.McEquipCell;
	import com.view.gameWindow.tips.toolTip.interfaces.IToolTipClient;
	import com.view.gameWindow.util.UIEffectLoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	
	/**
	 * 时装格子类
	 * @author Administrator
	 */	
	public class FashionCell extends McEquipCell implements IUrlBitmapDataLoaderReceiver,IToolTipClient
	{
		private var _urlBitmapDataLoader:UrlBitmapDataLoader;
		private var _bitmap:Bitmap;
		private var _bg:MovieClip;
		private var _fashionId:int;
		private var _bornSid:int;
		private var _cellEffectLoader:UIEffectLoader;
		
		public function get fashionId():int
		{
			return _fashionId;
		}
		
		public function FashionCell(bg:MovieClip)
		{
			mcBindSign.mouseEnabled = false;
			txtNum.mouseEnabled = false;
			_bg = bg;
			x = _bg.x;
			y = _bg.y;
			_bg.parent.addChild(this);
		}
		
		public function refreshData(fashionId:int):void
		{
			if(_fashionId != fashionId)
			{
				_fashionId = fashionId;
				loadPic();
				loadEffect();
			}
		}
		
		private function loadPic():void
		{
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(_fashionId);
			if(!equipCfgData)
			{
				return;
			}
			var url:String = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD+equipCfgData.icon+ResourcePathConstants.POSTFIX_PNG;
			_urlBitmapDataLoader = new UrlBitmapDataLoader(this);
			_urlBitmapDataLoader.loadBitmap(url);
		}
		
		public function loadEffect():void
		{
			destroyEffect();
			var url:String;
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(_fashionId);
			if(!equipCfgData)
			{
				trace("in BagCell.loadPic 不存在id"+_fashionId);
				return;
			}
			url = ItemType.getEffectUrlByQuality(equipCfgData.color);
			if(url)
			{
				var theX:int = x + _bg.width/2;
				var theY:int = y + _bg.height/2;
				_cellEffectLoader = new UIEffectLoader(parent as MovieClip,theX,theY,_bg.width/60,_bg.height/60,url);
			}
		}
		
		private function destroyEffect():void
		{
			if(_cellEffectLoader)
			{
				_cellEffectLoader.destroy();
				_cellEffectLoader = null;
			}
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			if(_bitmap)
			{
				if(_bitmap.parent)
				{
					_bitmap.parent.removeChild(_bitmap);
				}
				if(_bitmap.bitmapData)
				{
					_bitmap.bitmapData.dispose();
				}
			}
			_bitmap = new Bitmap(bitmapData,"auto",true);
			_bitmap.width = _bg.width;
			_bitmap.height = _bg.height;
			addChild(_bitmap);
			_bg.visible = false;
			destroyLoader();
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			trace("加载图片出错："+url+"in FashionCell.urlBitmapDataError");
			destroyLoader();
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			if(value)
			{
				if(_bitmap)
					_bg.visible = false;
				else
					_bg.visible = true;
			}
			else
			{
				_bg.visible = false;
			}
			if(_cellEffectLoader && _cellEffectLoader.effect)
			{
				_cellEffectLoader.effect.visible = value;
			}
		}
		
		public function destroyLoader():void
		{
			if(_urlBitmapDataLoader)
				_urlBitmapDataLoader.destroy();
			_urlBitmapDataLoader = null;
		}
		
		public function setNull():void
		{
			destroyEffect();
			if(_bitmap)
			{
				if(_bitmap.parent)
				{
					_bitmap.parent.removeChild(_bitmap);
				}
				if(_bitmap.bitmapData)
				{
					_bitmap.bitmapData.dispose();
				}
				_bitmap = null;
			}
			_bg.visible = true && visible;
			_fashionId = 0;
		}
		
		public function getTipType():int
		{
			return ToolTipConst.FASHION_TIP;
		}
		
		public function getTipData():Object
		{
			return ConfigDataManager.instance.equipCfgData(_fashionId);
		}
		
		public function destroy():void
		{
			setNull();
			destroyLoader();
		}
		
		public function getTipCount():int
		{
			// TODO Auto Generated method stub
			return 1;
		}
		
	}
}