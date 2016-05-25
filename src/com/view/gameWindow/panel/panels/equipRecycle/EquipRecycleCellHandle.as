package com.view.gameWindow.panel.panels.equipRecycle
{
	import com.view.gameWindow.panel.panels.McEquipRecycle;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.cell.BagCell;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.RectRim;
	import com.view.gameWindow.util.scrollBar.PageScrollBar;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class EquipRecycleCellHandle
	{
		private var _panel:PanelEquipRecycle;
		private var _skin:McEquipRecycle;
		private const _numCell:int = 35;
		private var _bagCells:Vector.<BagCell>;
		private var _pageScrollBar:PageScrollBar;
		private var lastCell:BagCell;
		private var _rectRim:RectRim;
		private var _rectRim2:RectRim;
		private var _hasLastRectRim:Boolean;

		public function EquipRecycleCellHandle(panel:PanelEquipRecycle)
		{
			_panel = panel;
			_skin = panel.skin as McEquipRecycle;
			init();
			initBagCells();
			 
		}

		public function get bagCells():Vector.<BagCell>
		{
			return _bagCells;
		}

		private function init():void
		{
 
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			_skin.addEventListener(MouseEvent.MOUSE_MOVE,onOver);
			_skin.addEventListener(MouseEvent.MOUSE_OUT,onOut);
			_skin.addEventListener(Event.ADDED_TO_STAGE,onAdd);
			_skin.addEventListener(Event.REMOVED_FROM_STAGE,onRemove);
		}
		private function onAdd(e:Event):void
		{
			_skin.stage.addEventListener(MouseEvent.CLICK,onStageCLick);
			_rectRim = new RectRim(0xffff00,46,46);
			_rectRim.visible = false;
			_skin.addChild(_rectRim);
			
			
			_rectRim2 = new RectRim(0xffff00,46,46);
			_rectRim2.visible = false;
			_skin.addChild(_rectRim2);
		}
		private function onRemove(e:Event):void
		{
			if(_skin)
			{
				_skin.stage.removeEventListener(MouseEvent.CLICK,onStageCLick);	
				_skin.removeEventListener(Event.REMOVED_FROM_STAGE,onRemove);
				_skin.removeEventListener(Event.ADDED_TO_STAGE,onAdd);
			}

		}
		private function onStageCLick(e:MouseEvent):void
		{
			var cell:BagCell = e.target as BagCell;
			if(cell)
			{
				if(lastCell!=cell)
				{
					cell.isClick = false;
				}
			}
		}
		private function onOver(e:MouseEvent):void
		{
			var cell:BagCell = e.target as BagCell;
			if(cell)
			{
	 			_skin.setChildIndex(_skin.selectCellEfc,_skin.numChildren-1);
				_skin.selectCellEfc.x=cell.x+5;
				_skin.selectCellEfc.y=cell.y+5;
				_skin.selectCellEfc.visible=true; 
 
			}
		}
		
		private function onOut(e:MouseEvent):void
		{
			var cell:BagCell = e.target as BagCell;
			if(cell)
			{  
				 _skin.selectCellEfc.visible=false; 
				 
			}
		}
		private function onClick(event:Object):void
		{
			var bagCell:BagCell = event.target as BagCell;
			if(!bagCell || bagCell.isEmpty())
			{
				return;
			}
			 
			EquipRecycleDataManager.instance.setSelectData(bagCell.id);
			_panel.viewhandle.refreshEquip();
			bagCell.isClick = true;
			lastCell = bagCell;
			
			_skin.setChildIndex(_rectRim2,_skin.numChildren-1);
			_rectRim2.x=bagCell.x;
			_rectRim2.y=bagCell.y;
			_rectRim2.visible=true;
			_rectRim.visible=false;
			 
		}
		 
		private function initBagCells():void
		{
			var i:int;
			_bagCells = new Vector.<BagCell>();
			for(i=0;i<_numCell;i++)
			{
				var bagCell:BagCell = new BagCell();
				bagCell.initView();
				bagCell.refreshLockState(false);
				/*bagCell.x = 46*(i%5)+398;
				bagCell.y = 46*int(i/5)+160;*/
				bagCell.x = 46*(i%5)+37;
				bagCell.y = 46*int(i/5)+160;
				_skin.addChild(bagCell);
				_bagCells.push(bagCell);
				ToolTipManager.getInstance().attach(bagCell);
			}
		}
				
		public function addScrollBar(mc:MovieClip):void
		{
 
			var realEquipRecycleDatas:Vector.<BagData>,totalPage:int;
			realEquipRecycleDatas = EquipRecycleDataManager.instance.realEquipRecycleDatas;
			if(realEquipRecycleDatas.length)
			{
				totalPage = int((realEquipRecycleDatas.length+_numCell-1)/_numCell);
			}
			else
			{
				totalPage = 1;
			}
			if(!_pageScrollBar)
			{
				_pageScrollBar = new PageScrollBar(mc,322,refresh,totalPage); 
				_pageScrollBar.refresh(totalPage);
			}		
			else
			{
				_pageScrollBar.refresh(totalPage);
			}
				
			
		}
		
		
		public function refresh():void
		{
			var bagCell:BagCell,recycleEquips:Vector.<BagData>,bagData:BagData,i:int,len:int,page:int,index:int,selectData:BagData;
			recycleEquips =EquipRecycleDataManager.instance.realEquipRecycleDatas;	
			len = recycleEquips.length;	
			if(len == 0)
			{
				clearCells();
				return;
			}
				
			if(EquipRecycleDataManager.instance.isAllRecycle)
			{
				index = -1;
				for each(bagCell in _bagCells)
				{
					if(index < recycleEquips.length)
					{
					}
					index++;
				}	
				return;	
			}
			page = _pageScrollBar == null ? 1 : _pageScrollBar.page;
			EquipRecycleDataManager.instance._page = page;
  
			for each(bagCell in _bagCells)
			{
				index = (page-1)*_numCell+i;
				if(index < len)
				{
					bagData = recycleEquips[index];
					bagCell.cellId = bagData.slot;
					bagCell.refreshData(bagData);
					bagCell.storageType = bagData.storageType;
					ToolTipManager.getInstance().attach(bagCell);
					selectData = EquipRecycleDataManager.instance.selectData;
					if(i == 0)
					{
						EquipRecycleDataManager.instance.selectData = bagData;
						setRectRim(bagCell);
					}
				}
				else
				{
					bagCell.setNull();
					ToolTipManager.getInstance().detach(bagCell);
				}
				i++;
			}
			
			
		}
		
		public function clearCells():void
		{			
			var len:int = _bagCells.length; 
			var bagCell:BagCell; 
			for(var i:int = 0;i < len; i++)
			{
				bagCell = _bagCells[i];
				ToolTipManager.getInstance().detach(bagCell);
				bagCell.setNull();
			}
			_rectRim2.visible = false;
			_rectRim.visible = false;
			//EquipRecycleDataManager.instance.isAllRecycle = false;
		} 
		public function setRectRim(bagCell:BagCell):void
		{ 
			_rectRim2.x = bagCell.x;
			_rectRim2.y = bagCell.y;
			_rectRim2.visible = true;
			EquipRecycleDataManager.instance._rectRim = _rectRim2;
			_hasLastRectRim = true;
			_panel.viewhandle.refreshEquip();
		}
		public function destroy():void
		{
			if(_skin)
			{
				_skin.removeChild(_rectRim);
				_skin.removeChild(_rectRim2);
				_skin.removeEventListener(MouseEvent.CLICK,onClick);
				_skin.removeEventListener(MouseEvent.MOUSE_MOVE,onOver);
				_skin.removeEventListener(MouseEvent.MOUSE_OUT,onOut);	 
			}
			for each(var bagCell:BagCell in _bagCells)
			{					 
				ToolTipManager.getInstance().detach(bagCell);
				bagCell.setNull(); 
			}
			_bagCells.length = 0;
			_hasLastRectRim = false;
			_rectRim = null;
			_rectRim2 = null;
			if (_pageScrollBar)
			{
				_pageScrollBar.destroy();
				_pageScrollBar = null;
			}
			_skin = null;
		}
		
	}
}