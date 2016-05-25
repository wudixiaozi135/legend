package com.view.gameWindow.panel.panels.hero.tab3.chest
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.view.gameWindow.common.ResManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.util.FilterUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class HeroFashionChest extends Sprite
	{
		private var _box:Bitmap;
		private var _image:Bitmap;

		private var _id:int;
		public function HeroFashionChest()
		{
			super();
			initBox();
		}
		
		private function initBox():void
		{
			_box=new Bitmap();
			_image=new Bitmap();
			addChild(_box);
			addChild(_image);
			ResManager.getInstance().loadBitmap(ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD+"hero/imageBox.png",onLoadBoxComple);
		}
		
		public function setFashion(id:int):void
		{
			if(_id==id)return;
			this._id = id;
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(id);
			if(equipCfgData==null)return;
			var url:String = ResourcePathConstants.IMAGE_EFFECT_FOLDER_LOAD+equipCfgData.chest_url+ResourcePathConstants.POSTFIX_PNG;
			
			ResManager.getInstance().loadBitmap(url,onLoadImageComple);
		}
		
		private function onLoadImageComple(bitmap:BitmapData,url:String):void
		{
			if(_image)
			{
				_image.bitmapData=bitmap;
			}else
			{
				bitmap.dispose();
			}
		}
		
		public function setNull():void
		{
			_id=0;
			if(_image)
			{
				_image.bitmapData&&_image.bitmapData.dispose();
			}
		}
		
		private function onLoadBoxComple(bitmap:BitmapData,url:String):void
		{
			if(_box)
			{
				_box.bitmapData=bitmap;
			}else
			{
				bitmap.dispose();
			}
		}
		
		public function destroy():void
		{
			if(_box)
			{
				_box.bitmapData&&_box.bitmapData.dispose();
				_box.parent&&_box.parent.removeChild(_box);
			}
			_box=null;
			
			if(_image)
			{
				_image.bitmapData&&_image.bitmapData.dispose();
				_image.parent&&_image.parent.removeChild(_image);
			}
			_image=null;
		}

		public function get id():int
		{
			return _id;
		}
	}
}