package com.view.gameWindow.panel.panels.dungeonTower
{
	import com.model.configData.cfgdata.DgnShopCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.ItemType;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * 塔防副本兑换面板显示处理类
	 * @author Administrator
	 */	
	internal class PanelDgnTowerExchangeView
	{
		private var _panel:PanelDgnTowerExchange;
		private var _skin:McDgnTowerExchange;

		private var _cell:IconCellEx;
		
		public function PanelDgnTowerExchangeView(panel:PanelDgnTowerExchange)
		{
			_panel = panel;
			_skin = _panel.skin as McDgnTowerExchange;
			initialize();
		}
		
		private function initialize():void
		{
			initCell();
			assignTxtTitle();
			assignTxtName();
			assignTxtAuto();
			assignTxtCost();
			assignTxtBtn();
		}
		
		private function initCell():void
		{
			var mc:MovieClip = _skin.mc;
			mc.mouseEnabled = false;
			_cell = new IconCellEx(mc,0,0,mc.width,mc.height,0);
			var dt:ThingsData = new ThingsData();
			dt.id = DgnTowerDataManger.instance.exchange;
			dt.type = SlotType.IT_ITEM;
			IconCellEx.setItemByThingsData(_cell,dt);
			ToolTipManager.getInstance().attach(_cell);
		}
		
		internal function initSelect():void
		{
			var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
			var exchange:int = manager.exchange;
			var isAuto:Boolean = manager.isAutos[exchange] as Boolean;
			_skin.btnSelect.selected = isAuto;
		}
		
		private function assignTxtTitle():void
		{
			var txt:TextField = _skin.txtTitle;
			txt.htmlText = HtmlUtils.createHtmlStr(txt.textColor,StringConst.DGN_TOWER_0028,12,true);
		}
		
		private function assignTxtName():void
		{
			var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
			var exchange:int = manager.exchange;
			var cfgDt:ItemCfgData = manager.itemCfgData(exchange);
			_skin.txtName.text = cfgDt.name;
			_skin.txtName.textColor = ItemType.getColorByQuality(cfgDt.quality);
		}
		
		private function assignTxtAuto():void
		{
			_skin.txtAuto.text = StringConst.DGN_TOWER_0029;
		}
		
		private function assignTxtCost():void
		{
			var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
			var exchange:int = manager.exchange;
			var cfgDt:DgnShopCfgData = manager.dgnShopCfgData(exchange);
			_skin.txtCost.htmlText = StringConst.DGN_TOWER_0030.replace("&x",cfgDt.strExp);
		}
		
		private function assignTxtBtn():void
		{
			_skin.txtBtn.text = StringConst.DGN_TOWER_0031;
			_skin.txtBtn.mouseEnabled = false;
		}
		
		internal function destroy():void
		{
			ToolTipManager.getInstance().detach(_cell);
			_cell.destroy();
			_skin = null;
			_panel = null;
		}
	}
}