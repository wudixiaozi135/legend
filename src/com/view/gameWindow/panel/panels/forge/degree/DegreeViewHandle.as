package com.view.gameWindow.panel.panels.forge.degree
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.EquipDegreeCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.RolePropertyConst;
	import com.model.consts.StringConst;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.forge.McUpDegree;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UtilGetStrLv;
	import com.view.gameWindow.util.cell.CellData;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	import com.view.gameWindow.util.propertyParse.PropertyData;

	/**
	 * 锻造进阶面板显示处理类
	 * @author Administrator
	 */	
	public class DegreeViewHandle
	{
		private var _panel:TabDegree;
		private var _skin:McUpDegree;

		private var _selectCell:DegreeCell;
		private var _nextCell:DegreeCell;
		private var _materialstCell:DegreeCell;
		
		internal var isMaterialsEnough:Boolean;
		internal var isYBEnough:Boolean;
		internal var isJBEnough:Boolean;
		/**0未超出，1超出人物，2超出英雄*/
		internal var isNextLvOut:int;
		
		public function DegreeViewHandle(panel:TabDegree)
		{
			_panel = panel;
			_skin = _panel.skin as McUpDegree;
			init();
		}
		
		public function destroy():void
		{
			if(_materialstCell)
			{
				ToolTipManager.getInstance().detach(_materialstCell);
				_materialstCell.destroy();
				_materialstCell = null;
			}
			if(_nextCell)
			{
				ToolTipManager.getInstance().detach(_nextCell);
				_nextCell.destroy();
				_nextCell = null;
			}
			if(_selectCell)
			{
				ToolTipManager.getInstance().detach(_selectCell);
				_selectCell.destroy();
				_selectCell = null;
			}
			_skin = null;
			_panel = null;
		}
		
		private function init():void
		{
			_skin.txtMaterialsGet.htmlText = HtmlUtils.createHtmlStr(0x53b436,StringConst.DEGREE_PANEL_0001,12,false,2,"SimSun",true);
			_skin.txtAttr.text = StringConst.DEGREE_PANEL_0003;
			_skin.txtJB.text = StringConst.DEGREE_PANEL_0004;
			_skin.txtYB.text = StringConst.DEGREE_PANEL_0005;
			_skin.txtUseYB.text = StringConst.DEGREE_PANEL_0006;
			_skin.mcUseYB.visible = false;
			_skin.txtUseYB.visible = false;
			_skin.btnUseYB.visible = false;
			_skin.txtInfo.text = StringConst.DEGREE_PANEL_0007;
			_skin.txtJBValue.text = "0";
			_skin.txtYBValue.text = "0";
			_selectCell = new DegreeCell(_skin.mcSelectBg,_skin.mcSelectBg.x,_skin.mcSelectBg.y,_skin.mcSelectBg.width,_skin.mcSelectBg.height);
			ToolTipManager.getInstance().attach(_selectCell);
			_nextCell = new DegreeCell(_skin.mcNextBg,_skin.mcNextBg.x,_skin.mcNextBg.y,_skin.mcNextBg.width,_skin.mcNextBg.height);
			ToolTipManager.getInstance().attach(_nextCell);
			_materialstCell = new DegreeCell(_skin.mcMaterialsBg,_skin.mcMaterialsBg.x,_skin.mcMaterialsBg.y,_skin.mcMaterialsBg.width,_skin.mcMaterialsBg.height);
			ToolTipManager.getInstance().attach(_materialstCell);
		}
		
		public function getEquipDegreeCfg(data:CellData):EquipDegreeCfgData
		{
			var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(data.bornSid,data.id);
			if(!memEquipData)
			{
				return null;
			}
			
			var equipDegreeCfgData:EquipDegreeCfgData = ConfigDataManager.instance.equipDegreeCfgData(memEquipData.baseId);
			
			return equipDegreeCfgData;
		}
		
		public function checkMaterialEnough(data:CellData):Boolean
		{
			var equipDegreeCfgData:EquipDegreeCfgData = getEquipDegreeCfg(data);
			
			if(!equipDegreeCfgData)
			{
				return false;
			}
			
			var num:int = BagDataManager.instance.getItemNumById(equipDegreeCfgData.material_id);
			num += HeroDataManager.instance.getItemNumById(equipDegreeCfgData.material_id);
			
			return num >= equipDegreeCfgData.material_count;
		}
		
		public function refresh():void
		{
			var select:CellData = _panel.degreeCellHandle.select;
			if(!select)
			{
				setNull();
				return;
			}
			//刷新装备框
			_selectCell.refreshData(select);
			var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(select.bornSid,select.id);
			if(!memEquipData)
			{
				setNull();
				return;
			}
			var equipDegreeCfgData:EquipDegreeCfgData = ConfigDataManager.instance.equipDegreeCfgData(memEquipData.baseId);
			if(!equipDegreeCfgData)
			{
				setNull();
				return;
			}
			//刷新材料框
			var num:int;
			var bagData:BagData = BagDataManager.instance.getItemById(equipDegreeCfgData.material_id);
			if(!bagData)
			{
				var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(equipDegreeCfgData.material_id);
				if(!itemCfgData)
				{
					setNull();
					return;
				}
				_materialstCell.refreshDataByCfg(itemCfgData);
				num = 0;
			}
			else
			{
				_materialstCell.refreshData(bagData);
				num = BagDataManager.instance.getItemNumById(equipDegreeCfgData.material_id);
				num += HeroDataManager.instance.getItemNumById(equipDegreeCfgData.material_id);
			}
			_skin.txtMaterialsNum.text = num+"/"+equipDegreeCfgData.material_count;
			if(num >= equipDegreeCfgData.material_count)
			{
				_skin.txtMaterialsNum.textColor = 0x53B436;
				isMaterialsEnough = true;
			}
			else
			{
				_skin.txtMaterialsNum.textColor = 0xff0000;
				isMaterialsEnough = false;
			}
			//刷新下一阶装备框
			var equipCfgData0:EquipCfgData = ConfigDataManager.instance.equipCfgData(equipDegreeCfgData.id);
			var equipCfgData1:EquipCfgData = ConfigDataManager.instance.equipCfgData(equipDegreeCfgData.next_id);
			if(!equipCfgData0 || !equipCfgData1)
			{
				setNull();
				return;
			}
			_skin.txtLevel0.text = UtilGetStrLv.strReincarnLevel(equipCfgData0.reincarn,equipCfgData0.level);
			_skin.txtLevel1.text = UtilGetStrLv.strReincarnLevel(equipCfgData1.reincarn,equipCfgData1.level);
			if(_panel.degreeRightClickHandle.isTypeRoleEquip)
			{
				var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(equipCfgData1.reincarn,equipCfgData1.level);
				isNextLvOut = checkReincarnLevel ? 0 : 1;
			}
			else if(_panel.degreeRightClickHandle.isTypeHeroEquip)
			{
				checkReincarnLevel = HeroDataManager.instance.checkReincarnLevel(equipCfgData1.reincarn,equipCfgData1.level);
				isNextLvOut = checkReincarnLevel ? 0 : 2;
			}
			else
			{
				isNextLvOut = 0;
			}
			//
			_skin.txtJBValue.text = equipDegreeCfgData.coin+"";
			var JB:int = BagDataManager.instance.coinBind+BagDataManager.instance.coinUnBind;
			if(JB >= equipDegreeCfgData.coin)
			{
				_skin.txtJBValue.textColor = 0x53B436;
				isJBEnough = true;
			}
			else
			{
				_skin.txtJBValue.textColor = 0xff0000;
				isJBEnough = false;
			}
			//
			_nextCell.refreshNext(equipDegreeCfgData,memEquipData.strengthen);
			//
			var dAttr:Vector.<PropertyData> = CfgDataParse.getDAttStringArray(equipCfgData0.attr,equipCfgData1.attr);
			var i:int,l:int = dAttr.length,str:String = "";
			for(i=0;i<l;i++)
			{
				var propertyData:PropertyData = dAttr[i];
				if(propertyData.type == RolePropertyConst.NUM_TYPE)
				{
					if(propertyData.value)
					{
						str += propertyData.name + " " + (!propertyData.isMain ? "+" + propertyData.value : propertyData.value + "-" + propertyData.value1) + "\n";
					}
				}
				else if(propertyData.type == RolePropertyConst.PERCENT_TYPE)
				{  
					if(propertyData.value)
					{
						str = propertyData.name + " " + CfgDataParse.getPercentValue(propertyData.value) + "%" + "\n";
					}
				}
			}
			_skin.txtAttrValue.text = str;
			//
			refreshYBTxt(_skin.btnUseYB.selected);
			trace("DegreeViewHandle.refresh isJBEnough:"+isJBEnough+",isMaterialsEnough:"+isMaterialsEnough+",isYBEnough:"+isYBEnough);
		}
		
		internal function refreshYBTxt(visible:Boolean):void
		{
			if(!visible)
			{
				_skin.txtYBValue.text = "0";
				_skin.txtYBValue.textColor = 0x53B436;
				isYBEnough = false;
				return;
			}
			var select:CellData = _panel.degreeCellHandle.select;
			if(!select)
			{
				setNull();
				return;
			}
			//刷新装备框
			_selectCell.refreshData(select);
			var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(select.bornSid,select.id);
			if(!memEquipData)
			{
				setNull();
				return;
			}
			var equipDegreeCfgData:EquipDegreeCfgData = ConfigDataManager.instance.equipDegreeCfgData(memEquipData.baseId);
			if(!equipDegreeCfgData)
			{
				setNull();
				return;
			}
			var num:int = BagDataManager.instance.getItemNumById(equipDegreeCfgData.material_id);
			var material_count:int = equipDegreeCfgData.material_count;
			var needYB:int = num < material_count ? (material_count - num)*equipDegreeCfgData.material_price : 0;
			_skin.txtYBValue.text = needYB+"";
			var goldUnBind:int = BagDataManager.instance.goldUnBind;
			if(goldUnBind >= needYB)
			{
				_skin.txtYBValue.textColor = 0x53B436;
				isYBEnough = true;
			}
			else
			{
				_skin.txtYBValue.textColor = 0xff0000;
				isYBEnough = false;
			}
		}
		
		private function setNull():void
		{
			isNextLvOut = 0;
			isJBEnough = false;
			isYBEnough = false;
			isMaterialsEnough = false;
			_skin.txtJBValue.text = "0";
			_skin.txtYBValue.text = "0";
			_skin.txtMaterialsNum.text = "";
			_selectCell.setNull();
			_materialstCell.setNull();
			_nextCell.setNull();
		}
	}
}