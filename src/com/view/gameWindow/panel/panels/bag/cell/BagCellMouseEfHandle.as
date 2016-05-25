package com.view.gameWindow.panel.panels.bag.cell
{
	import com.view.gameWindow.panel.panels.bag.BagPanel;
	import com.view.gameWindow.panel.panels.bag.McBag;
	
	import flash.events.MouseEvent;

	public class BagCellMouseEfHandle
	{
		private var _panel:BagPanel;
		private var _mc:McBag;
		/**点击的单元格<br>在双击或点击后置空，除了单击弹出菜单情况，该情况在菜单执行具体操作或关闭时置空*/
		private var _bagCell:BagCell;
		
		public function BagCellMouseEfHandle(panel:BagPanel)
		{
			_panel = panel;
			_mc = _panel.skin as McBag;
			_mc.addEventListener(MouseEvent.MOUSE_OVER,onOverFunc);
			_mc.addEventListener(MouseEvent.MOUSE_OUT,onOutFunc);
		}
		
		private function onOverFunc(event:MouseEvent):void
		{
			_bagCell = event.target as BagCell;
			if(!_bagCell)
			{
				return;
			}
			_mc.setChildIndex(_mc.selectCellEfc,_mc.numChildren-1);
			_mc.selectCellEfc.x=_bagCell.x+5;
			_mc.selectCellEfc.y=_bagCell.y+5;
			_mc.selectCellEfc.visible=true;
		}
		
		private function onOutFunc(event:MouseEvent):void
		{
			_bagCell = event.target as BagCell;
			if(!_bagCell)
			{
				return;
			}
			_mc.selectCellEfc.visible=false;
		}
		
		public function destory():void
		{
			_bagCell = null;
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.MOUSE_OVER,onOverFunc);
				_mc.removeEventListener(MouseEvent.MOUSE_OUT,onOutFunc);
			}
			_mc = null;
			_panel = null;
		}
	}
}