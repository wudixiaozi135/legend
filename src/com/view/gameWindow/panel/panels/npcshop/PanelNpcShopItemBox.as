package com.view.gameWindow.panel.panels.npcshop
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.NpcShopCfgData;
	import com.model.consts.ConstPriceType;
	import com.model.consts.ItemType;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.buyitemconfirm.PanelBuyItemConfirmData;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.text.TextFieldAutoSize;

	/**
	 * NPC商店物品框类
	 * @author Administrator
	 */	
	public class PanelNpcShopItemBox extends McPanelNpcShopItemBox implements IUrlBitmapDataLoaderReceiver
	{
		private const cellW:int = 36,cellH:int = 36;
		
		private var _bitmap:Bitmap;
		private var _urlBitmapDataLoader:UrlBitmapDataLoader;
		internal var _cfgDt:NpcShopCfgData;
		private var _tipMc:PanelNpcShopItemBoxTip;
		
		private var _url:String;
		
		public function PanelNpcShopItemBox()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_bitmap = new Bitmap();
			var rsrLoader:RsrLoader = new RsrLoader();
			rsrLoader.load(this,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
			txtBtn.mouseEnabled = false;
			__id2_.mouseEnabled = false;
			mc.mouseEnabled = false;
			_tipMc = new PanelNpcShopItemBoxTip(this);
		}
		
		public function refreshData(cfgDt:NpcShopCfgData):void
		{
			_cfgDt = cfgDt;
			var url:String,name:String,color:int,lvValue:String;
			if(cfgDt.type == SlotType.IT_EQUIP)
			{
				var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(cfgDt.base);
				if(!equipCfgData)
				{
					trace("in PanelNpcShopItemBox.refreshData 不存在id"+cfgDt.base);
					return;
				}
				url = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD+equipCfgData.icon+ResourcePathConstants.POSTFIX_PNG;
				name = equipCfgData.name;
				color = ItemType.getColorByQuality(equipCfgData.color);
				lvValue = equipCfgData.level+"";
			}
			else if(cfgDt.type == SlotType.IT_ITEM)
			{
				var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(cfgDt.base);
				if(!itemCfgData)
				{
					trace("in PanelNpcShopItemBox.refreshData 不存在id"+cfgDt.base);
					return;
				}
				url = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD+itemCfgData.icon+ResourcePathConstants.POSTFIX_PNG;
				name = itemCfgData.name;
				color = ItemType.getColorByQuality(itemCfgData.quality);
				lvValue = itemCfgData.level+"";
			}
			loadPic(url);
			__id3_.visible = true;
			btn.visible = true;
			txtItemName.text = name;
			txtItemName.textColor = color;
			txtLv.text = StringConst.NPC_SHOP_PANEL_0004;
			
			txtPrice.text = StringConst.NPC_SHOP_PANEL_0005;
			txtBtn.text = StringConst.NPC_SHOP_PANEL_0002;
			txtLvValue.text = lvValue;
			txtPriceValue.autoSize = TextFieldAutoSize.LEFT;
			txtPriceValue.text = cfgDt.price_value+"";
			__id3_.resUrl = ConstPriceType.getResUrl(cfgDt.price_type);
			var oneSize:int = txtPriceValue.getCharBoundaries(0).width;
			txtPriceValue.x = __id3_.x-oneSize*txtPriceValue.text.length-4;
		}
		
		private function loadPic(url:String):void
		{
			if(_url != url)
			{
				_url = url;
				_urlBitmapDataLoader = new UrlBitmapDataLoader(this);
				_urlBitmapDataLoader.loadBitmap(_url);
			}
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			destroyLoader();
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			if(!_cfgDt || (_url && url.search(_url) == -1))
			{
				return;
			}
			if(_bitmap)
			{
				if(_bitmap.parent)
					_bitmap.parent.removeChild(_bitmap);
				if(_bitmap.bitmapData)
					_bitmap.bitmapData.dispose();
				_bitmap = null;
			}
			_bitmap = new Bitmap(bitmapData,"auto",true);
			_bitmap.width = cellW;
			_bitmap.height = cellH;
			mc.addChild(_bitmap);
			destroyLoader();
		}
		
		public function onClick():void
		{
			if(!_cfgDt)
			{
				return;
			}
			PanelBuyItemConfirmData.cfgDt = _cfgDt;
			PanelMediator.instance.switchPanel(PanelConst.TYPE_BUY_ITEM_CONFIRM);
		}
		
		public function setNull():void
		{
			if(_bitmap)
			{
				if(_bitmap.parent)
					mc.removeChild(_bitmap);
				if(_bitmap.bitmapData)
					_bitmap.bitmapData.dispose();
				_bitmap = null;
			}
			_url = "";
			txtItemName.text = "";
			txtLv.text = "";
			txtLvValue.text = "";
			txtPrice.text = "";
			txtPriceValue.text = "";
			txtBtn.text = "";
			_cfgDt = null;
			__id3_.visible = false; 
			btn.visible = false;
		}
		
		private function destroyLoader():void
		{
			if(_urlBitmapDataLoader)
				_urlBitmapDataLoader.destroy();
			_urlBitmapDataLoader = null;
		}
		
		public function destroy():void
		{
			if(_tipMc)
			{
				_tipMc.destroy();
				_tipMc = null;
			}
			setNull();
			destroyLoader();
		}

		public function get tipMc():MovieClip
		{
			return _tipMc;
		}
	}
}