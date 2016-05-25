package com.view.gameWindow.panel.panels.storage
{
	import com.model.consts.ConstStorage;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.cell.BagCell;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;

	public class StorageCellDragHandle
	{
		private var _panel:PanelStorage;
		private var _clickBagCell:BagCell,_dragBitmap:Bitmap;
		internal var cancelOnce:Boolean;
		
		public function StorageCellDragHandle(panel:PanelStorage)
		{
			_panel = panel;
			_panel.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
		}
 
		protected function onDown(event:MouseEvent):void
		{
			if(_clickBagCell)
			{
				onUp(null);
				_panel.mouseHandle.cellClickHandle.cancelOnce = true;
				return;
			}
			if(event.target is BagCell)
			{
				_clickBagCell = event.target as BagCell;
				if(_clickBagCell && _clickBagCell.isEmpty())
				{
					_clickBagCell = null;
				}
				if(_clickBagCell)
				{
					dealOnDown(_clickBagCell);
				}
			}
		}
		
		internal function dealOnDown(bagCell:BagCell):void
		{
			_clickBagCell = bagCell;
			StorageDataMannager.instance.setUsedCellData(bagCell.cellId);
			_panel.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			_panel.stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		internal function onMove(event:MouseEvent):void
		{
			if(_clickBagCell)
			{
				if(!_dragBitmap)
				{
					_dragBitmap = _clickBagCell.getBitmap();
					_panel.stage.addChild(_dragBitmap);
				}
				_dragBitmap.x =_panel.stage.mouseX-_dragBitmap.width/2;
				_dragBitmap.y = _panel.stage.mouseY-_dragBitmap.height/2;
			}
			else
			{
				_panel.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
				_panel.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			}
		}
		
		protected function onUp(event:MouseEvent):void
		{
			if(cancelOnce)
			{
				cancelOnce = false;
				return;
			}
			var infos:BagData;
			
			if(_clickBagCell && _dragBitmap)
			{
				if(!onchrbag(event))
				{
					_panel.stage.removeChild(_dragBitmap);
					infos = StorageDataMannager.instance.storageCellDatas[_clickBagCell.cellId];
					_clickBagCell.setBitmap(_dragBitmap,infos);
					ToolTipManager.getInstance().attach(_clickBagCell);
					_panel.mouseHandle.cellClickHandle.dealLitter(_clickBagCell,infos,true);
				}	
			} 
			_clickBagCell = null;
			_dragBitmap = null;
			_panel.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			_panel.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		 
		private function onchrbag(event:MouseEvent):Boolean
		{
			if(!event)
			{
				return false;
			}
			var storageId:int = StorageDataMannager.instance.storageId;
			storageId = ConstStorage.ST_STORAGE[storageId];
			var bagCell:BagCell;
			bagCell = event.target as BagCell;
			if(!bagCell || bagCell.storageType != ConstStorage.ST_CHR_BAG || bagCell.isLock || bagCell.storageType == storageId)
			{
				return false;
			}
			var usedCellData:BagData = StorageDataMannager.instance.usedCellData;
			if(!usedCellData) 
			{
				return false;
			}
			_panel.stage.removeChild(_dragBitmap);
			ToolTipManager.getInstance().attach(bagCell);
			var id:int = ConstStorage.ST_STORAGE[StorageDataMannager.instance.storageId];
			StorageDataMannager.instance.moveStorageItem(id,usedCellData.slot,bagCell.storageType);
			return true;
		}
 
		internal function destroy():void
		{
			if(_panel)
			{
				_panel.removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
				if(_panel.stage)
				{
					_panel.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
					_panel.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
				}
			}
			_panel = null;
			_clickBagCell = null;
			_dragBitmap = null;
			
		}
 
	}
}