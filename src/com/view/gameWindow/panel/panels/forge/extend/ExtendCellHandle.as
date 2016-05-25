package com.view.gameWindow.panel.panels.forge.extend
{
	import com.model.consts.EffectConst;
	import com.view.gameWindow.panel.panels.forge.McExtend;
	import com.view.gameWindow.panel.panels.forge.extend.select.ExtendSelectData;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.cell.CellData;

	/**
	 * 强化转移面板单元格处理类
	 * @author Administrator
	 */	
	public class ExtendCellHandle
	{
		private var _panel:TabExtend;
		private var _mc:McExtend;
		private var _cell0:ExtendCell;
		private var _cell1:ExtendCell;
		private var _effectLoader:UIEffectLoader;
		
		public function ExtendCellHandle(panel:TabExtend)
		{
			_panel = panel;
			_mc = _panel.skin as McExtend;
			init();
		}
		
		private function init():void
		{
			_cell0 = new ExtendCell(_mc.btn0,_mc.btn0.x,_mc.btn0.y,_mc.btn0.width,_mc.btn0.height);
			ToolTipManager.getInstance().attach(_cell0);
			_cell1 = new ExtendCell(_mc.btn1,_mc.btn1.x,_mc.btn1.y,_mc.btn1.width,_mc.btn1.height);
			ToolTipManager.getInstance().attach(_cell1);
		}
		
		public function destroy():void
		{
			if(_cell0)
			{
				ToolTipManager.getInstance().detach(_cell0);
				_cell0.destroy();
				_cell0 = null;
			}
			if(_cell1)
			{
				ToolTipManager.getInstance().detach(_cell1);
				_cell1.destroy();
				_cell1 = null;
			}
			if(_effectLoader)
			{
				_effectLoader.destroy();
				_effectLoader = null;
			}
			_mc = null;
			_panel = null;
		}
		
		public function refreshData():void
		{
			var cellData1:CellData = ExtendSelectData.cellData1;
			if(cellData1)
			{
				_cell0.refreshData(cellData1);
				if(!_effectLoader)
				{
					_effectLoader = new UIEffectLoader(_mc,_mc.arrow.x-5,_mc.arrow.y-15,1,1,EffectConst.RES_EXTEND_ARROW);
				}
			}
			else
			{
				_cell0.setNull();
				if(_effectLoader)
				{
					_effectLoader.destroy();
					_effectLoader = null;
				}
			}
			var cellData2:CellData = ExtendSelectData.cellData2;
			if(cellData2)
			{
				_cell1.refreshData(cellData2);
			}
			else
			{
				_cell1.setNull();
			}
		}

		public function get cell0():ExtendCell
		{
			return _cell0;
		}

		public function get cell1():ExtendCell
		{
			return _cell1;
		}
	}
}