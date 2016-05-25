package com.view.gameWindow.panel.panels.forge.extend.select
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.util.NumPic;
	import com.view.gameWindow.util.cell.CellData;
	import com.view.gameWindow.util.cell.IconCell;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	/**
	 * 强化转移选择装备面板单元格类
	 * @author Administrator
	 */	
	public class ExtendSelectCell extends IconCell
	{
		private var _cellData:CellData;
		private var _numPicLayer:MovieClip;
		
		public function ExtendSelectCell(layer:DisplayObjectContainer, x:int, y:int, w:int, h:int)
		{
			super(layer, x, y, w, h);
			_numPicLayer = new MovieClip();
			_numPicLayer.mouseChildren = false;
			_numPicLayer.mouseEnabled = false;
			addChild(_numPicLayer);
		}
		
		override public function getTipData():Object
		{
			if(!_cellData)
			{
				return null;
			}
			var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(_cellData.bornSid,_cellData.id);
			if(!memEquipData)
			{
				return null;
			}
			return memEquipData;
		}
		
		override public function getTipType():int
		{
			return ToolTipConst.EQUIP_BASE_TIP;
		}
		
		public function refreshData(cellData:CellData):void
		{
			_cellData = cellData;
			var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(cellData.bornSid,cellData.id);
			if(!memEquipData)
			{
				return;
			}
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
			if(!equipCfgData)
			{
				return;
			}
			var url:String = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD + equipCfgData.icon + ResourcePathConstants.POSTFIX_PNG;
			loadPic(url);
			destroyNumPic();
			if(memEquipData.strengthen)
			{
				var numPic:NumPic = new NumPic();
				numPic.init("strength","+"+memEquipData.strengthen,_numPicLayer);
			}
		}
		
		public function setNull():void
		{
			destroyNumPic();
			_cellData = null;
			destroyBmp();
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

		public function get cellData():CellData
		{
			return _cellData;
		}
	}
}