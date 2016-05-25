package com.view.gameWindow.util.cell
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.CombineCfgData;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.ItemType;
	import com.model.consts.SlotType;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.UtilColorMatrixFilters;
	import com.view.gameWindow.util.UtilNumChange;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * @author wqhk
	 * 2014-8-27
	 */
	public class CompoundCell extends IconCell
	{
		private var _url:String;
		private var _tipData:Object;
		private var _tipType:int;
		private var _text:TextField;
		private var _cellEffectLoader:UIEffectLoader;
		
		public var isShowFilters:Boolean = false;//灰暗效果
		
		public function CompoundCell(layer:DisplayObjectContainer, x:int, y:int, w:int, h:int)
		{
			super(layer, x, y, w, h);
		}
		
		override public function destroy():void
		{
			setNull();
			super.destroy();
		}
		
		public function setNull():void
		{
			url = "";
			_tipData = null;
			_tipType = ToolTipConst.NONE_TIP;
			isShowFilters=false;
			destroyEffect();
		}
		
		public function set url(value:String):void
		{
			if(_url != value)
			{
				_url = value;
				if(!_url)
				{
					destroyBmp();
					destroyLoader();
				}
				else
				{
					loadPic(value);
				}
			}
		}
		
		public function loadEffect(value:String):void
		{
			destroyEffect();
			if(!_cellEffectLoader)
			{
				var theX:int = x + _w/2;
				var theY:int = y + _h/2;
				_cellEffectLoader = new UIEffectLoader(parent as MovieClip,theX,theY,_w/60,_h/60);
			}
			_cellEffectLoader.url = value;
		}
		
		private function destroyEffect():void
		{
			if(_cellEffectLoader)
			{
				_cellEffectLoader.destroy();
				_cellEffectLoader = null;
			}
		}
		
		public function setTipData(tipData:Object):void
		{
			_tipData = tipData
		}
		
		public function setTipType(type:int):void
		{
			_tipType = type;
		}
		
		override public function getTipData():Object
		{
			return _tipData;
		}
		
		override public function getTipType():int
		{
			return _tipType;
		}
		
		public function setItem(icon:CompoundCell,type:int,id:int):void
		{
			if(type == SlotType.IT_ITEM)
			{
				var itemCfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(id);
				if(itemCfg == null)
				{
					icon.setNull();
				}
				else
				{
					icon.url = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD + itemCfg.icon + ResourcePathConstants.POSTFIX_PNG;
					icon.setTipType(ToolTipConst.ITEM_BASE_TIP);
					icon.setTipData(itemCfg);
				}
			}
			else if(type == SlotType.IT_EQUIP)
			{
				var equipCfg:EquipCfgData = ConfigDataManager.instance.equipCfgData(id);
				if(equipCfg == null)
				{
					icon.setNull();
				}
				else
				{
					icon.url = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD + equipCfg.icon + ResourcePathConstants.POSTFIX_PNG;
					icon.setTipType(ToolTipConst.EQUIP_BASE_TIP);
					icon.setTipData(equipCfg);
				}
			}
			
			if(isShowFilters)
			{
				this.filters = UtilColorMatrixFilters.GREY_FILTERS;
			}
			else
			{
				this.filters = null;
			}
		}
		
		public static function setItemByThingsData(icon:IconCellEx,dt:ThingsData):void
		{
			var preUrl:String,typeTip:int;
			if(dt.type == SlotType.IT_ITEM)
			{
				preUrl = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD;
				typeTip = ToolTipConst.ITEM_BASE_TIP;
			}
			else if(dt.type == SlotType.IT_EQUIP)
			{
				preUrl = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD;
				typeTip = ToolTipConst.EQUIP_BASE_TIP;
			}
			icon.url = preUrl+dt.cfgData.icon+ResourcePathConstants.POSTFIX_PNG;
			var effectUrl:String = ItemType.getEffectUrlByQuality(dt.cfgData.quality);
			icon.loadEffect(effectUrl);
			icon.setTipType(typeTip);
			icon.setTipData(dt.cfgData);
			if(dt.count)
			{
				var cfgDt:CombineCfgData = ConfigDataManager.instance.getCombineDataByID(dt.type,dt.id);
				if(!(cfgDt && cfgDt.isMaterialAllSame))
				{
					var nc:UtilNumChange = new UtilNumChange();
					icon.text = nc.changeNum(dt.count);
				}
			}
		}
	}
}