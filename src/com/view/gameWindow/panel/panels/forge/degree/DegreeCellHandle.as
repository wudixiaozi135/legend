package com.view.gameWindow.panel.panels.forge.degree
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.consts.ItemType;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.panel.panels.forge.McUpDegree;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.cell.CellData;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * 锻造进阶面板单元格处理类
	 * @author Administrator
	 */	
	public class DegreeCellHandle
	{
		private var _panel:TabDegree;
		private var _mc:McUpDegree;
		private var _cells:Vector.<DegreeCell>;
		private const length:int = 7;
		private var _initY:int;
		internal var select:CellData;
		internal var selectIndex:int;
		
		public function DegreeCellHandle(panel:TabDegree)
		{
			_panel = panel;
			_mc = _panel.skin as McUpDegree;
			init();
		}
		
		public function destroy():void
		{
			select = null;
			var cell:DegreeCell;
			for each(cell in _cells)
			{
				ToolTipManager.getInstance().detach(cell);
				cell.destroy();
			}
			_cells = null;
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.CLICK,onClick);
				_mc = null;
			}
			_panel = null;
		}
		
		private function init():void
		{
			_mc.addEventListener(MouseEvent.CLICK,onClick);
			_initY = _mc.mcSelectEffect.y;
			_mc.mcSelectEffect.mouseEnabled = false;
			_mc.mcSelectEffect.mouseChildren = false;
			_cells = new Vector.<DegreeCell>(length,true);
			var i:int;
			for(i=0;i<length;i++)
			{
				var mcEquipItem:McEquipItem = _mc["mcEquipItem"+i] as McEquipItem;
				var bg:MovieClip = mcEquipItem.mcBg;
				var cell:DegreeCell = new DegreeCell(bg,bg.x,bg.y,bg.width,bg.height);
				_cells[i] = cell;
				ToolTipManager.getInstance().attach(cell);
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var mcEquipItem:McEquipItem = event.target as McEquipItem || (event.target as DisplayObject).parent as McEquipItem;
			if(!mcEquipItem)
			{
				return;
			}
			var index:int = int(mcEquipItem.name.slice(mcEquipItem.name.length-1));
			dealSelect(index);
		}
		
		private function dealSelect(index:int):void
		{
			var cell:DegreeCell = _cells[index];
			var dt:CellData = cell ? cell.cellData : null;
			setSelect(index,dt);
			_panel.degreeViewHandle.refresh();
		}
		
		internal function setSelect(index:int,dt:CellData):void
		{
			_mc.mcSelectEffect.y = _mc["mcEquipItem" + index].y;
			selectIndex = index;
			select = dt;
		}
		
		/**
		 * 取本列表中第一个可以操作的装备
		 */
		private function getValidIndex(datas:Vector.<CellData>):int
		{
			for(var i:int = 0; i < datas.length; ++i)
			{
				var data:CellData = datas[i];
				
				if(_panel.degreeViewHandle.checkMaterialEnough(data))
				{
					return i;
				}
			}
			
			return 0;
		}
		
		internal function refreshData(datas:Vector.<CellData>,isReset:Boolean = false):void
		{
			var i:int;
			for(i=0;i<length;i++)
			{
				if(i < datas.length)
				{
					var cellData:CellData = datas[i];
					_cells[i].refreshData(cellData);
					setEquipName(cellData,i);
				}
				else
				{
					_cells[i].setNull();
					setEquipName(null,i);
				}
			}
			
			if(isReset)
			{
				_panel && _panel.degreeRightClickHandle ? _panel.degreeRightClickHandle.isInited = true : null;
				_mc.mcSelectEffect.y = _initY;
				
				selectIndex = getValidIndex(datas);
				dealSelect(selectIndex);
			}
			if(datas && datas.length > 0)//有数据
			{
				if (_cells[selectIndex].isEmpty())
				{
					dealSelect(selectIndex);
				}
				else
				{
					dealSelect(selectIndex);
				}
			}
			else
			{
				select = null;
			}
			_mc.mcSelectEffect.visible = _cells[selectIndex] && !_cells[selectIndex].isEmpty();
		}
		
		private function setEquipName(cellData:CellData,i:int):void
		{
			var mcEquipItem:McEquipItem = _mc["mcEquipItem"+i] as McEquipItem;
			if(!cellData)
			{
				mcEquipItem.txt.text = "";
			}
			else
			{
				var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(cellData.bornSid,cellData.id);
				if(memEquipData)
				{
					var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
					if(equipCfgData)
					{
						mcEquipItem.txt.text = equipCfgData.name;
						mcEquipItem.txt.textColor = ItemType.getColorByQuality(equipCfgData.color);
					}
				}
			}
		}
	}
}