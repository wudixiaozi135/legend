package com.view.gameWindow.panel.panels.forge.resolve
{
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.cell.BagCell;
	import com.view.gameWindow.panel.panels.forge.ForgeDataManager;
	import com.view.gameWindow.panel.panels.forge.McResolve;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.RectRim;
	import com.view.gameWindow.util.scrollBar.PageScrollBar;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 锻造分解面板单元格处理类
	 * @author Administrator
	 */	
	public class ResolveCellHandle
	{
		private var _panel:TabResolve;
		private var _mc:McResolve;
		
		private var _numCell:int = 40;
		private var _itemContainer:MovieClip,vector:Vector.<BagCell>;
		private var _pageScrollBar:PageScrollBar;
		private var _rectRim:RectRim;
		
		public function ResolveCellHandle(panel:TabResolve)
		{
			_panel = panel;
			_mc = _panel.skin as McResolve;
			init();
			initBagCells();
			_mc.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function init():void
		{
			_itemContainer = new MovieClip();
			_itemContainer.x = 619;
			_itemContainer.y = 74;
			_mc.addChild(_itemContainer);
		}
		
		private function initBagCells():void
		{
			var i:int;
			vector = new Vector.<BagCell>();
			for(i=0;i<_numCell;i++)
			{
				var bagCell:BagCell = new BagCell();
				bagCell.initView();
				bagCell.refreshLockState(false);
				bagCell.x = 46*(i%5);
				bagCell.y = 46*int(i/5);
				_itemContainer.addChild(bagCell);
				vector.push(bagCell);
				ToolTipManager.getInstance().attach(bagCell);
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var bagCell:BagCell = event.target as BagCell;
			if(!bagCell || bagCell.isEmpty())
			{
				return;
			}
			setRectRim(bagCell);
			ForgeDataManager.instance.setSelectResolveData(bagCell.id);
			_panel.resolveViewHandle.refresh();
		}
		
		private function setRectRim(bagCell:BagCell):void
		{
			if(!_rectRim)
			{
				_rectRim = new RectRim(0xffff00,bagCell.width,bagCell.height);
				bagCell.parent.addChild(_rectRim);
			}
			_rectRim.x = bagCell.x;
			_rectRim.y = bagCell.y;
		}
		
		public function addScrollBar(mc:MovieClip):void
		{
			var equipDatas:Vector.<BagData>,totalPage:int;
			equipDatas = ForgeDataManager.instance.equipResolveDatas;
			if(equipDatas.length)
			{
				totalPage = int((equipDatas.length+_numCell-1)/_numCell);
			}
			else
			{
				totalPage = 1;
			}
			_pageScrollBar = new PageScrollBar(mc,368,refresh,totalPage);
		}
		
		public function refresh():void
		{
			var bagCell:BagCell,equipDatas:Vector.<BagData>,bagData:BagData,i:int;
			ForgeDataManager.instance.getResolveEquipDatas();
			equipDatas = ForgeDataManager.instance.equipResolveDatas;
			for each(bagCell in vector)
			{
				if(i < equipDatas.length)
				{
					bagData = equipDatas[i];
					bagCell.cellId = bagData.slot;
					bagCell.refreshData(bagData);
					bagCell.storageType = bagData.storageType;
					var selectData:BagData = ForgeDataManager.instance.selectResolveData;
					if(bagCell.id == selectData.id)
					{
						setRectRim(bagCell);
					}
				}
				else
				{
					bagCell.setNull();
				}
				i++;
			}
			if(equipDatas.length == 0)
			{
				destroyRectRim();
			}
		}
		
		public function destroy():void
		{
			destroyRectRim();
			while(_itemContainer && _itemContainer.numChildren)
			{
				var bagCell:BagCell = _itemContainer.removeChildAt(0) as BagCell;
				ToolTipManager.getInstance().detach(bagCell);
				bagCell.destory();
			}
			if(_pageScrollBar)
			{
				_pageScrollBar.destroy();
				_pageScrollBar = null;
			}
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.CLICK,onClick);
				_mc = null;
			}
			_panel = null;
		}
		
		private function destroyRectRim():void
		{
			if(_rectRim)
			{
				if(_rectRim.parent)
				{
					_rectRim.parent.removeChild(_rectRim);
				}
				_rectRim = null;
			}
		}
	}
}