package com.view.gameWindow.panel.panels.forge.extend
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.util.NumPic;
	import com.view.gameWindow.util.cell.CellData;
	import com.view.gameWindow.util.cell.IconCell;
	
	import flash.display.MovieClip;
	
	public class ExtendCell extends IconCell
	{
		private var _cellData:CellData;
		private var _bg:MovieClip;
		private var _numPicLayer:MovieClip;
		
		private var _urlPic:String;
		private var _strengthen:int;
		
		public function ExtendCell(bg:MovieClip, x:int, y:int, w:int, h:int)
		{
			_bg = bg;
			super(bg.parent, x, y, w, h);
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
			_bg.visible = false;
			_cellData = cellData;
			var url:String = getEquipUrl();
			if(_urlPic != url)
			{
				_urlPic = url;
				loadPic(url);
			}
			if(_cellData.memEquipData && _strengthen != _cellData.memEquipData.strengthen)
			{
				_strengthen = _cellData.memEquipData.strengthen;
				setNumPic();
			}
		}
		
		private function isSamePic(cellData:CellData):Boolean
		{
			return _cellData && cellData && _cellData.bornSid == cellData.bornSid && _cellData.id == cellData.id;
		}
		
		private function isSameStrengthen(celData:CellData):Boolean
		{
			return _cellData && celData && _cellData.memEquipData && celData.memEquipData && _cellData.memEquipData.strengthen == celData.memEquipData.strengthen;
		}
		
		private function getEquipUrl():String
		{
			var url:String = "";
			var memEquipData:MemEquipData = _cellData.memEquipData;
			if(!memEquipData)
			{
				return url;
			}
			var equipCfgData:EquipCfgData = memEquipData.equipCfgData;
			if(!equipCfgData)
			{
				return url;
			}
			url = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD + equipCfgData.icon + ResourcePathConstants.POSTFIX_PNG;
			return url;
		}
		
		private function setNumPic():void
		{
			destroyNumPic();
			var memEquipData:MemEquipData = _cellData.memEquipData;
			if(memEquipData && memEquipData.strengthen)
			{
				var numPic:NumPic = new NumPic();
				numPic.init("strength","+"+memEquipData.strengthen,_numPicLayer);
			}
		}
		
		public function setNull():void
		{
			_urlPic = "";
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