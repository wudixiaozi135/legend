package com.view.gameWindow.panel.panels.forge.extend.select
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.consts.StringConst;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.forge.McExtendSelect;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.cell.CellData;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 强化转移选择装备面板处理类
	 * @author Administrator
	 */	
	public class ExtendSelectHandle
	{
		private var _panel:ExtendSelectPanel;
		private var _mc:McExtendSelect;
		private var _cells:Vector.<ExtendSelectCell>;
		private const NUM_PAGE:int = 10;
		private var _page:int = 1,_totalPage:int;
		
		public function ExtendSelectHandle(panel:ExtendSelectPanel)
		{
			_panel = panel;
			_mc = _panel.skin as McExtendSelect;
			init();
		}
		
		private function init():void
		{
			_mc.txtTitle.text = StringConst.EXTEND_PANEL_0008;
			//
			_panel.addEventListener(MouseEvent.CLICK,onClick);
			//
			var i:int,l:int = NUM_PAGE;
			_cells = new Vector.<ExtendSelectCell>(NUM_PAGE,true);
			for(i=0;i<l;i++)
			{
				var movieClip:MovieClip = _mc["mcReward"+i] as MovieClip;
				var cell:ExtendSelectCell = new ExtendSelectCell(_mc,movieClip.x,movieClip.y,movieClip.width,movieClip.height);
				_cells[i] = cell;
				ToolTipManager.getInstance().attach(cell);
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _mc.btnClose:
					dealClose();
					break;
				case _mc.btnPrev:
					dealPrev();
					break;
				case _mc.btnNext:
					dealNext();
					break;
			}
			dealCell(event)
		}
		
		private function dealClose():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_FORGE_EXTEND_SELECT);
		}
		
		private function dealPrev():void
		{
			if(_page > 1)
			{
				_page--;
				refresh();
			}
			else
			{
				_page = 1;
			}
		}
		
		private function dealNext():void
		{
			if(_page < _totalPage)
			{
				_page++;
				refresh();
			}
			else
			{
				_page = _totalPage;
			}
		}
		
		private function dealCell(event:MouseEvent):void
		{
			var cell:ExtendSelectCell = event.target as ExtendSelectCell;
			if(!cell)
			{
				return;
			}
			if(!cell.cellData)
			{
				return;
			}
			var cellData1:CellData = ExtendSelectData.cellData1;
			if(!cellData1)
			{
				var cellData2:CellData = ExtendSelectData.cellData2;
				if(cellData2)
				{
					/*var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(bagData2.bornSid,bagData2.id);
					var memEquipDataNew:MemEquipData = MemEquipDataManager.instance.memEquipData(cell.bagData.bornSid,cell.bagData.id);
					if(memEquipData && memEquipDataNew)
					{
						var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
						var equipCfgDataNew:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipDataNew.baseId);
						if(equipCfgData && equipCfgDataNew && equipCfgData.type != equipCfgDataNew.type)
						{
							ExtendSelectData.bagData2 = null;//若新装备类型与新选的原装备类型不匹配重置新装备数据
						}
					}*/
					ExtendSelectData.cellData2 = null;
				}
				ExtendSelectData.cellData1 = cell.cellData;
			}
			else
			{
				ExtendSelectData.cellData2 = cell.cellData;
			}
			PanelMediator.instance.closePanel(PanelConst.TYPE_FORGE_EXTEND_SELECT);
			PanelMediator.instance.refreshPanel(PanelConst.TYPE_FORGE);
		}
		
		public function refresh():void
		{
			var type:int,onlyId:int;
			var cellData1:CellData = ExtendSelectData.cellData1;
			if(cellData1)
			{
				var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(cellData1.bornSid,cellData1.id);
				if(memEquipData)
				{
					var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
					if(equipCfgData)
					{
						type = equipCfgData.type;
						onlyId = cellData1.id;
					}
				}
			}
			var filter:int = ExtendSelectData.filter;
			var extendEquipDatas:Vector.<CellData> = new Vector.<CellData>();
			var getExtendEquipDatas:Vector.<EquipData> = RoleDataManager.instance.getExtendEquipDatas(type,onlyId,filter,memEquipData);
			extendEquipDatas = extendEquipDatas.concat(Vector.<CellData>(getExtendEquipDatas));
			var getExtendEquipDatas2:Vector.<BagData> = BagDataManager.instance.getExtendEquipDatas(type,onlyId,filter,memEquipData);
			extendEquipDatas = extendEquipDatas.concat(Vector.<CellData>(getExtendEquipDatas2));
			var getExtendEquipDatas3:Vector.<EquipData> = HeroDataManager.instance.getExtendEquipDatas(type,onlyId,filter,memEquipData);
			extendEquipDatas = extendEquipDatas.concat(Vector.<CellData>(getExtendEquipDatas3));
			var getExtendEquipDatas1:Vector.<BagData> = HeroDataManager.instance.getExtendEquipDatas1(type,onlyId,filter,memEquipData);
			extendEquipDatas = extendEquipDatas.concat(Vector.<CellData>(getExtendEquipDatas1));
			extendEquipDatas.sort(sortVector);
			//
			_totalPage = (extendEquipDatas.length+NUM_PAGE-1)/NUM_PAGE;
			_totalPage = _totalPage ? _totalPage : 1;
			_mc.txtPage.text = _totalPage ? _page+"/"+_totalPage : "";
			var i:int,l:int = 10;
			for(i=0;i<l;i++)
			{
				var index:int = (_page-1)*NUM_PAGE+i;
				if(index < extendEquipDatas.length)
				{
					var cellData:CellData = extendEquipDatas[index];
					if(cellData)
					{
						_cells[i].refreshData(cellData);
					}
					else
					{
						_cells[i].setNull();
					}
				}
				else
				{
					_cells[i].setNull();
				}
			}
		}
		
		private function sortVector(item1:CellData,item2:CellData):int
		{
			var memEquipData1:MemEquipData = MemEquipDataManager.instance.memEquipData(item1.bornSid,item1.id);
			if(!memEquipData1)
			{
				return 1;
			}
			var equipCfgData1:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData1.baseId);
			if(!equipCfgData1)
			{
				return 1;
			}
			var memEquipData2:MemEquipData = MemEquipDataManager.instance.memEquipData(item2.bornSid,item2.id);
			if(!memEquipData2)
			{
				return -1;
			}
			var equipCfgData2:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData2.baseId);
			if(!equipCfgData2)
			{
				return -1;
			}
			var type:int = equipCfgData1.type - equipCfgData2.type;//类型
			if(type)
			{
				return type;
			}
			var strengthen:int = memEquipData2.strengthen - memEquipData1.strengthen;
			if(strengthen)
			{
				return strengthen;
			}
			var level:int = equipCfgData2.level - equipCfgData1.level;
			if(level)
			{
				return level;
			}
			var quality:int = equipCfgData2.quality - equipCfgData1.quality;
			return quality;
		}
		
		public function destroy():void
		{
			for each(var cell:ExtendSelectCell in _cells)
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
	}
}