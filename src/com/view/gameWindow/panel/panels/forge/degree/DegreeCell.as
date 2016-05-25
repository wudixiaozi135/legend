package com.view.gameWindow.panel.panels.forge.degree
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.EquipDegreeCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.SlotType;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
	import com.view.gameWindow.util.NumPic;
	import com.view.gameWindow.util.cell.CellData;
	import com.view.gameWindow.util.cell.IconCell;
	
	import flash.display.MovieClip;
	
	public class DegreeCell extends IconCell
	{
		private var _cellData:CellData;
		private var _bg:MovieClip;
		private var _numPicLayer:MovieClip;
		
		private var _url:String;
		private var _strengthen:int;
		
		public function DegreeCell(bg:MovieClip, x:int, y:int, w:int, h:int)
		{
			_bg = bg;
			super(bg.parent, x, y, w, h);
			_numPicLayer = new MovieClip();
			_numPicLayer.mouseChildren = false;
			_numPicLayer.mouseEnabled = false;
			addChild(_numPicLayer);
		}
		
		public function get cellData():CellData
		{
			return _cellData;
		}
		
		override public function getTipData():Object
		{
			if(!_cellData)
			{
				return null;
			}
			var memEquipData:MemEquipData;
			if(_cellData is EquipData)
			{
				memEquipData = MemEquipDataManager.instance.memEquipData(_cellData.bornSid,_cellData.id);
				if(!memEquipData)
				{
					return null;
				}
				return memEquipData;
			}
			else if(_cellData is BagData)
			{
				var bagData:BagData = _cellData as BagData;
				if(bagData.type == SlotType.IT_EQUIP)
				{
					memEquipData = MemEquipDataManager.instance.memEquipData(_cellData.bornSid,_cellData.id);
					if(!memEquipData)
					{
						return null;
					}
					return memEquipData;
				}
				else
				{
					return cellData;
				}
			}
			else
			{
				return ConfigDataManager.instance.equipCfgData(_cellData.id);
			}
		}
		
		override public function getTipType():int
		{
			if(_cellData is EquipData)
			{
				return ToolTipConst.EQUIP_BASE_TIP;
			}
			else if(_cellData is BagData)
			{
				var bagData:BagData = _cellData as BagData;
				if(bagData.type == SlotType.IT_EQUIP)
				{
					return ToolTipConst.EQUIP_BASE_TIP;
				}
				else
				{
					return ToolTipConst.ITEM_BASE_TIP;
				}
			}
			else
			{
				return ToolTipConst.FASHION_TIP;
			}
		}
		
		public function refreshData(celData:CellData):void
		{
			_bg.visible = false;
			_cellData = celData;
			var url:String;
			if(_cellData is EquipData)
			{
				url = getEquipUrl();
			}
			else if(_cellData is BagData)
			{
				var bagData:BagData = _cellData as BagData;
				if(bagData.type == SlotType.IT_EQUIP)
				{
					url = getEquipUrl();
				}
				else
				{
					url = getItemUrl();
				}
			}
			if(_url != url)
			{
				_url = url;
				loadPic(url);
			}
			var memEquipData:MemEquipData = _cellData.memEquipData;
			if(memEquipData)
			{
				if(_strengthen != memEquipData.strengthen)
				{
					_strengthen = memEquipData.strengthen;
					setNumPic(memEquipData.strengthen);
				}
			}
		}
		
		public function refreshDataByCfg(cfgData:ItemCfgData):void
		{
			if(_cellData && _cellData.id == cfgData.id)
			{
				return;
			}
			_bg.visible = false;
			var bagData:BagData = new BagData();
			bagData.id = cfgData.id;
			bagData.type = SlotType.IT_ITEM;
			_cellData = bagData;
			var url:String = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD + cfgData.icon + ResourcePathConstants.POSTFIX_PNG;
			if(_url != url)
			{
				_url = url;
				loadPic(url);
			}
		}
		
		/**刷新下一阶*/
		public function refreshNext(equipDegreeCfgData:EquipDegreeCfgData,strengthen:int):void
		{
			_bg.visible = false;
			_cellData = new CellData();
			_cellData.id = equipDegreeCfgData.next_id;
			var url:String;
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(equipDegreeCfgData.next_id);
			if(!equipCfgData)
			{
				return;
			}
			url = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD + equipCfgData.icon + ResourcePathConstants.POSTFIX_PNG;
			if(_url != url)
			{
				_url = url;
				loadPic(url);
			}
			if(_strengthen != strengthen)
			{
				_strengthen = strengthen;
				setNumPic(strengthen);
			}
		}
		
		private function getEquipUrl():String
		{
			var url:String = "";
			var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(_cellData.bornSid,_cellData.id);
			if(!memEquipData)
			{
				return url;
			}
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
			if(!equipCfgData)
			{
				return url;
			}
			url = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD + equipCfgData.icon + ResourcePathConstants.POSTFIX_PNG;
			return url;
		}
		
		private function getItemUrl():String
		{
			var url:String = "";
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(_cellData.id);
			if(!itemCfgData)
			{
				return "";
			}
			url = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD + itemCfgData.icon + ResourcePathConstants.POSTFIX_PNG;
			return url;
		}
		
		private function setNumPic(strengthen:int):void
		{
			destroyNumPic();
			if(strengthen)
			{
				var numPic:NumPic = new NumPic();
				numPic.init("strength","+"+strengthen,_numPicLayer);
			}
		}
		
		public function setNull():void
		{
			_url = "";
			_strengthen = 0;
			destroyNumPic();
			_bg.visible = true;
			_cellData = null;
			destroyBmp();
		}
		
		override public function isEmpty():Boolean
		{
			return super.isEmpty() && _cellData == null;
		}
		
		private function destroyNumPic():void
		{
			while(_numPicLayer.numChildren)
			{
				_numPicLayer.removeChildAt(0);
			}
		}
		
		override public function destroy():void
		{
			destroyNumPic();
			_numPicLayer = null;
			_cellData = null;
			super.destroy();
		}
	}
}