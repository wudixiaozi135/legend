package com.view.gameWindow.panel.panels.task.npctask
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.SlotType;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.UtilGetCfgData;
	import com.view.gameWindow.util.UtilNumChange;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	
	/**
	 * 奖励处理类<br>处理奖励图片加载数量信息等
	 * @author Administrator
	 */	
	public class NpcTaskRewardCell implements IUrlBitmapDataLoaderReceiver
	{
		public static const TYPE_ITEM:int = 1;
		public static const TYPE_EQUIP:int = 2;
		
		private var _urlBitmapDataLoader:UrlBitmapDataLoader;
		private var _layer:MovieClip;
		private var _data:NpcTaskItemInfo;
		private var callBack:Function;
		
		public function get data():NpcTaskItemInfo
		{
			return _data;
		}
		
		public function NpcTaskRewardCell()
		{
			
		}
		
		public function load(layer:MovieClip,data:NpcTaskItemInfo,callBack:Function):void
		{
			_layer = layer;
			_data = data;
			var utilNumChange:UtilNumChange = new UtilNumChange();
			var changeNum:String = utilNumChange.changeNum(data.count);
			_layer.txt.text = changeNum;
			var url:String;
			url = getUrl(data);
			_urlBitmapDataLoader = new UrlBitmapDataLoader(this);
			_urlBitmapDataLoader.loadBitmap(url,null,true);
			this.callBack = callBack;
			initTip();
		}
		
		private function initTip():void
		{
			var tipVO:TipVO = new TipVO();
			tipVO.tipType = getTipType();
			tipVO.tipData = getTipData;
			tipVO.tipCount = _data.count;
			ToolTipManager.getInstance().hashTipInfo(_layer,tipVO);
			ToolTipManager.getInstance().attach(_layer);
		}
		
		private function getTipData():Object
		{
			if(!_data)
			{
				return null;
			}
			var util:UtilGetCfgData = new UtilGetCfgData();
			return _data.type == SlotType.IT_ITEM ? util.GetItemCfgData(_data.id) : util.GetEquipCfgData(_data.id);
		}
		
		private function getTipType():int
		{
			if(!_data)
			{
				return 0;
			}
			return _data.type == SlotType.IT_ITEM ? ToolTipConst.ITEM_BASE_TIP : ToolTipConst.EQUIP_BASE_TIP;
		}
		
		private function getUrl(data:NpcTaskItemInfo):String
		{
			var url:String = "";
			var configDataManager:ConfigDataManager = ConfigDataManager.instance;
			if (data.type == SlotType.IT_ITEM && data.id > 0)
			{
				var itemConfig:ItemCfgData = configDataManager.itemCfgData(data.id);
				if (itemConfig)
				{
					url = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD + itemConfig.icon + ResourcePathConstants.POSTFIX_PNG;
				}
			}
			else if (data.type == SlotType.IT_EQUIP && data.id > 0)
			{
				var eid:int = data.id;					
				var equipConfig:EquipCfgData = configDataManager.equipCfgData(eid);
				if (equipConfig)
				{
					url = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD + equipConfig.icon + ResourcePathConstants.POSTFIX_PNG;
				}
			}
			return url;
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			var bitmap:Bitmap = new Bitmap(bitmapData,"auto",true);
			bitmap.width = _layer.width;
			bitmap.height = _layer.height;
			bitmap.name = _data.id.toString();
			_layer.addChildAt(bitmap,0);
			
			if(callBack!=null)
			{
				callBack.apply();			
			}
			destroyLoader();
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			destroyLoader();
		}
		
		private function destroyLoader():void
		{
			if(_urlBitmapDataLoader)
				_urlBitmapDataLoader.destroy();
			_urlBitmapDataLoader = null;
		}
		
		public function destory():void
		{
			ToolTipManager.getInstance().detach(_layer);
			_data = null;
			destroyLoader();
			while(_layer.numChildren)
			{
				_layer.removeChildAt(0);
			}
			callBack = null;
			_layer = null;
		}
	}
}