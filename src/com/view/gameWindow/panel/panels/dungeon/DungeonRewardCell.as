package com.view.gameWindow.panel.panels.dungeon
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.ItemType;
	import com.model.consts.SlotType;
	import com.view.gameWindow.util.UIEffectLoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;

	public class DungeonRewardCell implements IUrlBitmapDataLoaderReceiver
	{
		private var _mc:MovieClip;
		private var _cellEffectLoader:UIEffectLoader;
		public function DungeonRewardCell()
		{
			
		}
		public function loadIcon(mc:MovieClip,id:int,type:int):void
		{
			var url:String;
			var urlBitmapLoad:UrlBitmapDataLoader = new UrlBitmapDataLoader(this);
			_mc = mc;
			url = getUrl(id,type);
			urlBitmapLoad.loadBitmap(url);
		}
		
		public function loadEffect(mc:MovieClip,id:int,type:int):void
		{
			destroyEffect();
			var url:String;
			if(type == SlotType.IT_EQUIP)
			{
				var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(id);
				if(!equipCfgData)
				{
					trace("不存在id"+id);
					return;
				}
				url = ItemType.getEffectUrlByQuality(equipCfgData.color);
			}
			else if(type == SlotType.IT_ITEM)
			{
				var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(id);
				if(!itemCfgData)
				{
					trace("不存在id"+id);
					return;
				}
				url = ItemType.getEffectUrlByQuality(itemCfgData.quality);
			}
			if(url)
			{
				var theX:int = mc.x + mc.width/2;
				var theY:int = mc.y + mc.height/2;
				_cellEffectLoader = new UIEffectLoader(mc.parent,theX,theY,mc.width/60,mc.height/60,url);
			}
		}
		
		public function destroyEffect():void
		{
			if(_cellEffectLoader)
			{
				_cellEffectLoader.destroy();
				_cellEffectLoader = null;
			}
		}
		
		private function getUrl(id:int,type:int):String
		{
			var icon:String;
			if(type == SlotType.IT_ITEM)
			{
				icon = ConfigDataManager.instance.itemCfgData(id).icon;
				return ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD + icon + ResourcePathConstants.POSTFIX_PNG;
			}
			if(type == SlotType.IT_EQUIP)
			{
				icon = ConfigDataManager.instance.equipCfgData(id).icon;
				return ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD + icon + ResourcePathConstants.POSTFIX_PNG;
			}
			return "";
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			// TODO Auto Generated method stub

			var bitmap:Bitmap = new Bitmap(bitmapData,"auto",true );
			bitmap.width = _mc.width;
			bitmap.height = _mc.height;
			_mc.addChild(bitmap);
		}
		
	}
}