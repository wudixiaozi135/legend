package com.view.gameWindow.panel.panels.school.complex.storage
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.EquipRecycleCfgData;
	import com.model.consts.ConstStorage;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.cell.BagCell;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import com.model.gameWindow.mem.MemEquipData;

	/**
	 * 背包单元格拖动处理类
	 * @author Administrator
	 */
	public class SchoolBagCellDragHandle
	{
		private var _panel:SchoolStoragePanel;
		public var stage:Stage;
		private var _clickBagCell:BagCell, _overBagCell:BagCell, _dragBitmap:Bitmap;
		
		public function get clickBagCell():BagCell
		{
			return _clickBagCell;
		}
		/**取消一次点击UP事件的触发*/
		internal var cancelOnce:Boolean;

		public function SchoolBagCellDragHandle()
		{
		}

		public function addEvent(eventDispatcher:EventDispatcher):void
		{
			_panel = eventDispatcher as SchoolStoragePanel;
			eventDispatcher.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			eventDispatcher.addEventListener(MouseEvent.ROLL_OVER, onOver, true);
			eventDispatcher.addEventListener(MouseEvent.ROLL_OUT, onOut, true);
		}

		protected function onDown(event:MouseEvent):void
		{
			if (_clickBagCell)
			{
				onUp(null);
				return;
			}
			
			if (event.target is BagCell)
			{
				_clickBagCell = event.target as BagCell;
				if (_clickBagCell && _clickBagCell.isEmpty())
				{
					_clickBagCell = null;
				}
				if (_clickBagCell)
				{
					dealOnDown(_clickBagCell);
				}
			}
		}

		internal function dealOnDown(bagCell:BagCell):void
		{
			_clickBagCell = bagCell;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
		}

		internal function onMove(event:MouseEvent):void
		{
			if (_clickBagCell)
			{
				if (!_dragBitmap)
				{
					_dragBitmap = _clickBagCell.getBitmap();
					if (_dragBitmap)
					{
						stage.addChild(_dragBitmap);
					}
				}
				if (_dragBitmap)
				{
					_dragBitmap.x = stage.mouseX - _dragBitmap.width / 2;
					_dragBitmap.y = stage.mouseY - _dragBitmap.height / 2;
				}
				_panel.setSelect(null);
			}
			else
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			}
		}

		protected function onUp(event:MouseEvent):void
		{
			if (cancelOnce)
			{
				cancelOnce = false;
				return;
			}
			
			if (_clickBagCell && _dragBitmap)
			{
				var overBitmap:Bitmap, overInfos:BagData,clickInfos:BagData;
				var currentPageData:Array = SchoolElseDataManager.getInstance().schoolBagListPage.getCurrentPageData()
				
				if(_clickBagCell.storageType==ConstStorage.ST_SCHOOL_MY_BAG)
				{
					clickInfos=SchoolElseDataManager.getInstance().bagDatas[_clickBagCell.cellId];
				}else
				{
					clickInfos=currentPageData[_clickBagCell.cellId];
				}
				
				if (_overBagCell && !_overBagCell.isLock && _overBagCell != null&&_overBagCell.storageType==_clickBagCell.storageType)
				{
					stage.removeChild(_dragBitmap);
					_clickBagCell.setBitmap(_dragBitmap, clickInfos);
				}
				else
				{
					if (!onStorageBagUp(event)&&!onMyBagUp(event))
					{
						stage.removeChild(_dragBitmap);
						_clickBagCell.setBitmap(_dragBitmap, clickInfos);
					}
				}
			}
			_clickBagCell = null;
			_overBagCell = null;
			_dragBitmap = null;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
		}


		/**在仓库面板品格中放开鼠标*/
		private function onStorageBagUp(event:MouseEvent):Boolean
		{
			if (!event)
			{
				return false;
			}
			var bagCell:BagCell = event.target as BagCell;
			var storgeId:int = ConstStorage.ST_SCHOOL_BAG;
			if (!bagCell || bagCell.storageType != storgeId || bagCell.isLock)
			{
				return false;
			}
			stage.removeChild(_dragBitmap);
			
			clickDonate();
//			ToolTipManager.getInstance().attach(bagCell);
			return true;
		}
		
		/**在仓库面板品格中放开鼠标*/
		private function onMyBagUp(event:MouseEvent):Boolean
		{
			if (!event)
			{
				return false;
			}
			var bagCell:BagCell = event.target as BagCell;
			var storgeId:int = ConstStorage.ST_SCHOOL_MY_BAG;
			if (!bagCell || bagCell.storageType != storgeId || bagCell.isLock)
			{
				return false;
			}
			stage.removeChild(_dragBitmap);
//			ToolTipManager.getInstance().attach(bagCell);
			clickExchangeEquip();
			return true;
		}

		protected function onOver(event:MouseEvent):void
		{
			/*trace("over");*/
			if (event.target is BagCell)
				_overBagCell = event.target as BagCell;
			/*if(_overBagCell)
			 trace(_overBagCell.cellId);*/
		}

		protected function onOut(event:MouseEvent):void
		{
			/*trace("out");*/
			if (event.target is BagCell)
				_overBagCell = null;
		}
		
		private function clickExchangeEquip():void
		{
			var clickInfos:BagData;
			var currentPageData:Array = SchoolElseDataManager.getInstance().schoolBagListPage.getCurrentPageData()
			if(_clickBagCell.storageType==ConstStorage.ST_SCHOOL_MY_BAG)
			{
				clickInfos=SchoolElseDataManager.getInstance().bagDatas[_clickBagCell.cellId];
			}else
			{
				clickInfos=currentPageData[_clickBagCell.cellId];
			}
			
			if(clickInfos==null||_clickBagCell.bagType==ConstStorage.ST_SCHOOL_MY_BAG)
			{
				Alert.warning(StringConst.SCHOOL_PANEL_6011);
				_clickBagCell.setBitmap(_dragBitmap, clickInfos);
				return;
			}
			var memEquipData:MemEquipData = SchoolElseDataManager.getInstance().getMemEquipData(clickInfos.bornSid,clickInfos.id);
			var equipCfgData:EquipCfgData = memEquipData.equipCfgData;
			var equipRecycleCfgData:EquipRecycleCfgData = ConfigDataManager.instance.equipRecycleCfgData(equipCfgData.type,equipCfgData.quality,equipCfgData.level);
			if(equipRecycleCfgData.family_contribute>SchoolElseDataManager.getInstance().schoolInfoData.contribute)
			{
				Alert.warning(StringConst.SCHOOL_PANEL_6013);
				_clickBagCell.setBitmap(_dragBitmap, clickInfos);
				return;
			}
			var bagData:BagData = clickInfos;
			SchoolElseDataManager.getInstance().sendEquipExchangeRequest(bagData.id,bagData.bornSid,bagData.slot);
		}
		
		private function clickDonate():void
		{
			var clickInfos:BagData;
			var currentPageData:Array = SchoolElseDataManager.getInstance().schoolBagListPage.getCurrentPageData()
			if(_clickBagCell.storageType==ConstStorage.ST_SCHOOL_MY_BAG)
			{
				clickInfos=SchoolElseDataManager.getInstance().bagDatas[_clickBagCell.cellId];
			}else
			{
				clickInfos=currentPageData[_clickBagCell.cellId];
			}
			
			if(clickInfos==null||_clickBagCell.bagType==ConstStorage.ST_SCHOOL_MY_BAG)
			{
				Alert.warning(StringConst.SCHOOL_PANEL_6011);
				_clickBagCell.setBitmap(_dragBitmap, clickInfos);
				return;
			}
			if(clickInfos==null||_clickBagCell.bagType==ConstStorage.ST_SCHOOL_BAG)
			{
				Alert.warning(StringConst.SCHOOL_PANEL_6010);
				_clickBagCell.setBitmap(_dragBitmap, clickInfos);
				return;
			}
			SchoolElseDataManager.getInstance().sendEquipDonateRequest(clickInfos.storageType,clickInfos.slot);
		}

		public function removeEvent(eventDispatcher:EventDispatcher):void
		{
			_clickBagCell = null;
			_overBagCell = null;
			_dragBitmap = null;
			eventDispatcher.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			eventDispatcher.removeEventListener(MouseEvent.ROLL_OVER, onOver, true);
			eventDispatcher.removeEventListener(MouseEvent.ROLL_OUT, onOut, true);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			stage = null;
			_panel = null;
		}
	}
}