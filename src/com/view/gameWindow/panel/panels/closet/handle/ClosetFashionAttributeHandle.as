package com.view.gameWindow.panel.panels.closet.handle
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.view.gameWindow.panel.panels.closet.ClosetData;
	import com.view.gameWindow.panel.panels.closet.ClosetDataManager;
	import com.view.gameWindow.panel.panels.closet.McClosetPanel;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * 衣柜时装属性处理类
	 * @author Administrator
	 */	
	public class ClosetFashionAttributeHandle implements IUrlBitmapDataLoaderReceiver
	{
		private var _mc:McClosetPanel;
		private var _urlBitmapDataLoader:UrlBitmapDataLoader;
		private var _bitmap:Bitmap;

		private var _closetModeHandel:ClosetModeHandel;
		
		public function ClosetFashionAttributeHandle(mc:McClosetPanel)
		{
			_mc = mc;
			_closetModeHandel = new ClosetModeHandel(_mc.mcModelLayer);
		}
		
		public function refresh():void
		{
			var currentClosetData:ClosetData = ClosetDataManager.instance.currentClosetData();
			if(_mc.btnPutIn.txt)
				_mc.btnPutIn.txt.text = currentClosetData.textPutInBtn;
			var equipCfgData:EquipCfgData = currentClosetData ? currentClosetData.equipCfgData() : null;
			if(!equipCfgData)
			{
				_mc.mcFashionName.visible = false;
				_mc.mcFashionLevel.visible = false;
				_mc.mcEmptyBg.visible = true;
				removeBitmap();
				_mc.txtFasionAttribute.text = "";
			}
			else
			{
				_mc.mcFashionName.visible = true;
				_mc.mcFashionLevel.visible = true;
				_mc.mcFashionLevel.gotoAndStop(equipCfgData.level);
				_mc.mcEmptyBg.visible = false;
				loadPic(equipCfgData.name_url);
				var strAnalyzeAttribute:String = analyzeAttribute(equipCfgData.attr);
				_mc.txtFasionAttribute.text = strAnalyzeAttribute;
			}
			_closetModeHandel.changeModel();
		}
		
		private function loadPic(name:String):void
		{
			var url:String = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD+name+ResourcePathConstants.POSTFIX_PNG;
			_urlBitmapDataLoader = new UrlBitmapDataLoader(this);
			_urlBitmapDataLoader.loadBitmap(url);
		}
		
		private function analyzeAttribute(attribute:String):String
		{
			var str:String = "";
			var attStringArray:Vector.<String> = CfgDataParse.getAttStringArray(attribute);
			while(attStringArray.length)
			{
				var shift:String = attStringArray.shift();
				str += shift+(attStringArray.length == 0 ? "" : "\n");
			}
			return str;
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			destroyLoader();
			removeBitmap();
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			destroyLoader();
			removeBitmap();
			while(_mc.mcFashionName.numChildren)
			{
				_mc.mcFashionName.removeChildAt(0);
			}
			_bitmap = new Bitmap(bitmapData,"auto",true);
			_mc.mcFashionName.addChild(_bitmap);
		}
		
		private function destroyLoader():void
		{
			if(_urlBitmapDataLoader)
			{
				_urlBitmapDataLoader.destroy();
				_urlBitmapDataLoader = null;
			}
		}
		
		private function removeBitmap():void
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
				_bitmap = null;
			}
		}
		
		public function destroy():void
		{
			if(_closetModeHandel)
			{
				_closetModeHandel.destroy();
				_closetModeHandel = null;
			}
			destroyLoader();
			removeBitmap();
			_mc = null;
		}
	}
}