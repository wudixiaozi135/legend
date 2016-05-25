package com.view.gameWindow.panel.panels.school.complex.storage
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.EquipRecycleCfgData;
	import com.model.consts.ConstStorage;
	import com.model.consts.ItemType;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.cell.BagCell;
	import com.view.gameWindow.panel.panels.school.McStorage;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.events.MouseEvent;
	
	import mx.utils.StringUtil;

	public class SchoolStorageMouseHandler
	{

		private var panel:SchoolStoragePanel;
		private var skin:McStorage;
		public function SchoolStorageMouseHandler(panel:SchoolStoragePanel)
		{
			this.panel = panel;
			skin = panel.skin as McStorage;
			skin.addEventListener(MouseEvent.CLICK,onClickFunc);
		}
		
		protected function onClickFunc(event:MouseEvent):void
		{
			if(event.target is BagCell)
			{
				var cell:BagCell =event.target as BagCell;
				panel.setSelect(cell);
				return;
			}
			switch(event.target)
			{
				case skin.btnUp:
					if(SchoolElseDataManager.getInstance().schoolBagListPage.prev())
					{
						panel.updateSchoolBag();
						return;
					}
					break;
				case skin.btnDown:
					if(SchoolElseDataManager.getInstance().schoolBagListPage.next())
					{
						panel.updateSchoolBag();
						return;
					}
					break;
				case skin.btn1:
					clickDonate();
					break;
				case skin.btn2:
					clickDistroyEquip();
					break;
				case skin.btn4:
					clickExchangeEquip();
					break;
				case skin.singleBtn1:
					panel.updateSchoolBag();
					break;
				case skin.singleBtn2:
					panel.updateSchoolBag();
					break;
			}
			
		}		
		
		private function clickDistroyEquip():void
		{
			var selectCell:BagCell = panel.selectCell;
			
			if(selectCell==null||selectCell.bagData==null||selectCell.storageType==ConstStorage.ST_SCHOOL_MY_BAG)
			{
				Alert.warning(StringConst.SCHOOL_PANEL_6012);
				return;
			}
			var equipCfgData:EquipCfgData = selectCell.bagData.memEquipData.equipCfgData;
			var color:int = ItemType.getColorByQuality(equipCfgData.color);
			var equipName:String = HtmlUtils.createHtmlStr(color,equipCfgData.name);
			Alert.show2(StringUtil.substitute(StringConst.SCHOOL_PANEL_6014,equipName),function ():void
			{
				var bagData:BagData = selectCell.bagData;
				SchoolElseDataManager.getInstance().sendEquipDistroyRequest(bagData.id,bagData.bornSid,bagData.slot);
				panel.setSelect(null);
			});
		}
		
		private function clickExchangeEquip():void
		{
			var selectCell:BagCell = panel.selectCell;
			
			if(selectCell==null||selectCell.bagData==null||selectCell.storageType==ConstStorage.ST_SCHOOL_MY_BAG)
			{
				Alert.warning(StringConst.SCHOOL_PANEL_6011);
				return;
			}
			var equipCfgData:EquipCfgData = selectCell.bagData.memEquipData.equipCfgData;
			var equipRecycleCfgData:EquipRecycleCfgData = ConfigDataManager.instance.equipRecycleCfgData(equipCfgData.type,equipCfgData.quality,equipCfgData.level);
			if(equipRecycleCfgData.family_contribute>SchoolElseDataManager.getInstance().schoolInfoData.contribute)
			{
				Alert.warning(StringConst.SCHOOL_PANEL_6013);
				return;
			}
			var bagData:BagData = selectCell.bagData;
			SchoolElseDataManager.getInstance().sendEquipExchangeRequest(bagData.id,bagData.bornSid,bagData.slot);
			panel.setSelect(null);
		}
		
		private function clickDonate():void
		{
			var selectCell:BagCell = panel.selectCell;
			if(selectCell==null||selectCell.storageType==ConstStorage.ST_SCHOOL_BAG)
			{
				Alert.warning(StringConst.SCHOOL_PANEL_6010);
				return;
			}
			SchoolElseDataManager.getInstance().sendEquipDonateRequest(selectCell.bagData.storageType,selectCell.bagData.slot);
			panel.setSelect(null);
		}
		
		public function destroy():void
		{
			skin.removeEventListener(MouseEvent.CLICK,onClickFunc);
		}
	}
}