package com.view.gameWindow.panel.panels.keySell
{
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.cell.BagCell;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.scrollBar.PageScrollBar;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 单元格及翻页处理类
	 * @author Administrator
	 */	
	internal class PanelKeySellCellHandle
	{
		private var _panel:PanelKeySell;
		private var _mc:McKeySell;
		private var _pageScrollBar:PageScrollBar;
		private var _cells:Vector.<BagCell>;

		public function PanelKeySellCellHandle(panel:PanelKeySell)
		{
			_panel = panel;
			_mc = _panel.skin as McKeySell;
			init();
		}
		
		private function init():void
		{
			var i:int;
			_cells = new Vector.<BagCell>();
			var num:int = KeySellDataManager.NUM_PAGE_CELL;
			for(i=0;i<num;i++)
			{
				var cell:BagCell = new BagCell();
				cell.initView();
				cell.refreshLockState(false);
				cell.x = 46*(i%5);
				cell.y = 46*int(i/5);
				_mc.mcLayer.addChild(cell);
				_cells.push(cell);
				ToolTipManager.getInstance().attach(cell);
			}
			_mc.mcLayer.addEventListener(MouseEvent.CLICK,onClick);
			refresh();
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var cell:BagCell = event.target as BagCell;
			if(cell)
			{
				var cellId:int = cell.cellId;
				var datas:Vector.<BagData> = KeySellDataManager.instance.datas;
				datas.splice(cellId,1);
				refresh();
			}
		}
		
		internal function addScrollBar(mc:MovieClip):void
		{
			var datas:Vector.<BagData>,totalPage:int;
			datas = KeySellDataManager.instance.datas;
			var num:int = KeySellDataManager.NUM_PAGE_CELL;
			if(datas.length)
			{
				totalPage = int((datas.length+num-1)/num);
			}
			else
			{
				totalPage = 1;
			}
			_pageScrollBar = new PageScrollBar(mc,_mc.mcLayer.height,refresh,totalPage);
		}
		
		internal function refresh():void
		{
			var cell:BagCell,datas:Vector.<BagData>,bagData:BagData,i:int,index:int;
			var page:int = _pageScrollBar ? _pageScrollBar.page : 1;
			datas = KeySellDataManager.instance.datas;
			var num:int = KeySellDataManager.NUM_PAGE_CELL;
			for each(cell in _cells)
			{
				index = (page-1)*num+i;
				if(index < datas.length)
				{
					bagData = datas[index];
					cell.cellId = index;
					cell.refreshData(bagData);
					cell.storageType = bagData.storageType;
				}
				else
				{
					cell.setNull();
				}
				i++;
			}
		}
		
		internal function destroy():void
		{
			if(_pageScrollBar)
			{
				_pageScrollBar.destroy();
				_pageScrollBar = null;
			}
			while(_cells && _cells.length)
			{
				var cell:BagCell = _cells.pop();
				ToolTipManager.getInstance().detach(cell);
				cell.destory();
			}
			_cells = null;
			if(_mc)
			{
				_mc.mcLayer.removeEventListener(MouseEvent.CLICK,onClick);
				_mc = null;
			}
			_panel = null;
		}
	}
}