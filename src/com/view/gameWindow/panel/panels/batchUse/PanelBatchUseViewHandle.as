package com.view.gameWindow.panel.panels.batchUse
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.ItemTypeCfgData;
	import com.model.consts.ConstStorage;
	import com.model.consts.ItemType;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.thingNew.itemNew.ItemCell;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;

	public class PanelBatchUseViewHandle
	{
		private var _panel:PanelBatchUse;
		private var _mc:McBatchUse;
		private var _cell:ItemCell;
		internal var id:int,type:int;
		internal var total:int,storage:int,slot:int;
		private var _numUse:int;
		
		public function PanelBatchUseViewHandle(panel:PanelBatchUse)
		{
			_panel = panel;
			_mc = _panel.skin as McBatchUse;
			init();
		}
		
		private function init():void
		{
			var tipVO:TipVO = new TipVO();
			id = PanelBatchUseData.id;
			type = PanelBatchUseData.type;
			storage = PanelBatchUseData.storage;
			slot = PanelBatchUseData.slot;
			//
			_cell = new ItemCell(_mc.mc);
			_cell.refreshData(id);
			//
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(id);
			tipVO.tipType = ToolTipConst.ITEM_BASE_TIP;
			tipVO.tipData = itemCfgData;
			_mc.txtName.text = itemCfgData.name;
			ToolTipManager.getInstance().hashTipInfo(_cell,tipVO);
			ToolTipManager.getInstance().attach(_cell);
			_mc.txtName.textColor = ItemType.getColorByQuality(itemCfgData.quality);
			//
			_mc.txt.text = StringConst.BATCH_USE_PANEL_0001;
			//
			refresh();
		}
		
		internal function refresh(useNum:int = -1,isDrag:Boolean = false):void
		{
			useNum = useNum != -1 ? useNum : defaultUseNum();
			if(!isDrag)
			{
				getTotal();
				_mc.txtNum.text = total +"";
				//
				var scaleX:Number = useNum/total;
				_mc.mcProgress.mcMask.scaleX = scaleX;
				scaleX = scaleX > 1 ? 1 : (scaleX < 0 ? 0 : scaleX);
				var theX:Number = (_mc.mcProgress.width - _mc.mcVernier.width)*scaleX + _mc.mcProgress.x;
				theX = theX < _mc.mcProgress.x ? _mc.mcProgress.x : theX;
				_mc.mcVernier.x = theX;
			}
			if(_numUse != useNum)
			{
				_mc.txtValue.text = useNum+"";
				_numUse = useNum;
			}
		}
		
		private function defaultUseNum():int
		{
			if(_numUse)
			{
				return _numUse;
			}
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(id);
			var itemTypeCfgData:ItemTypeCfgData = ConfigDataManager.instance.itemTypeCfgData(itemCfgData.type);
			if(itemTypeCfgData.batch_default == 1)
			{
				return 1;
			}
			else
			{
				getTotal();
				return total;
			}
		}
		
		private function getTotal():void
		{
			var num:int;
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(id);
			var itemTypeCfgData:ItemTypeCfgData = ConfigDataManager.instance.itemTypeCfgData(itemCfgData.type);
			var data:BagData;
			if(storage == ConstStorage.ST_CHR_BAG)
			{
				data = BagDataManager.instance.getBagCellData(slot);
			}
			else if(storage == ConstStorage.ST_HERO_BAG)
			{
				data = HeroDataManager.instance.getBagCellData(slot);
			}
			if(!data)
			{
				return;
			}
			if(itemTypeCfgData.batch == ItemTypeCfgData.Muti)//取所有包裹数量
			{
				num += HeroDataManager.instance.getItemNumById(id,data.bind);
				num += BagDataManager.instance.getItemNumById(id,data.bind);
			}
			else if(itemTypeCfgData.batch == ItemTypeCfgData.Single)
			{
				if(storage == ConstStorage.ST_CHR_BAG)
				{
					num += BagDataManager.instance.getItemNumById(id,data.bind);
				}
				else if(storage == ConstStorage.ST_HERO_BAG)
				{
					num += HeroDataManager.instance.getItemNumById(id,data.bind);
				}
			}
			total = num;
		}
		
		public function destroy():void
		{
			if(_cell)
			{
				ToolTipManager.getInstance().detach(_cell);
				_cell.destroy();
				_cell = null;
			}
			_mc = null;
			_panel = null;
		}
	}
}