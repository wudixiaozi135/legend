package com.view.gameWindow.panel.panels.hero.tab1.equip
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.HeroEquipUpgradeCfgData;
	import com.model.consts.ConstStorage;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.mainUi.subuis.herohead.McHeroEquipPanel;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.hero.tab1.equip.activate.HeroEquipActivateCell;
	import com.view.gameWindow.panel.panels.hero.tab1.equip.activate.HeroEquipActivateData;
	import com.view.gameWindow.panel.panels.hero.tab1.equip.activate.HeroEquipActivateEventHandle;
	import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipCell;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;

	/**
	 * 英雄装备格子处理类
	 * @author Administrator
	 */	
	public class HeroEquipCellHandle
	{
		private var _equipCells:Vector.<EquipCell>;
		private var _equipCellEventHandle:HeroEquipCellEventHandle;
//		private var _heroEquipUpgradeCell:HeroEquipActivateCell;
//		private var _heroEUCMouseHandler:HeroEquipActivateEventHandle;
		
		public function HeroEquipCellHandle()
		{
			_equipCells = new Vector.<EquipCell>();
		}
		public function initData(mc:McHeroEquipPanel):void
		{
			var equipCell:EquipCell;
			equipCell = new EquipCell(mc.mcArmsBg,ConstEquipCell.HP_WUQI,ConstEquipCell.TYPE_WUQI);//武器
			equipCell.storageType = ConstStorage.ST_HERO_EQUIP;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mc.mcHelmBg,ConstEquipCell.HP_TOUKUI,ConstEquipCell.TYPE_TOUKUI);//头盔
			equipCell.storageType = ConstStorage.ST_HERO_EQUIP;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mc.mcNecklaceBg,ConstEquipCell.HP_XIANGLIAN,ConstEquipCell.TYPE_XIANGLIAN);//项链
			equipCell.storageType = ConstStorage.ST_HERO_EQUIP;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mc.mcClothesBg,ConstEquipCell.HP_YIFU,ConstEquipCell.TYPE_YIFU);//衣服
			equipCell.storageType = ConstStorage.ST_HERO_EQUIP;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mc.mcBraceletBg0,ConstEquipCell.HP_SHOUZHUO_LEFT,ConstEquipCell.TYPE_SHOUZHUO);//手镯左
			equipCell.storageType = ConstStorage.ST_HERO_EQUIP;
			equipCell.notComplete = true;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mc.mcBraceletBg1,ConstEquipCell.HP_SHOUZHUO_RIGHT,ConstEquipCell.TYPE_SHOUZHUO);//手镯右
			equipCell.storageType = ConstStorage.ST_HERO_EQUIP;
			equipCell.notComplete = true;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mc.mcRingBg0,ConstEquipCell.HP_JIEZHI_LEFT,ConstEquipCell.TYPE_JIEZHI);//戒指左
			equipCell.storageType = ConstStorage.ST_HERO_EQUIP;
			equipCell.notComplete = true;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mc.mcRingBg1,ConstEquipCell.HP_JIEZHI_RIGHT,ConstEquipCell.TYPE_JIEZHI);//戒指右
			equipCell.storageType = ConstStorage.ST_HERO_EQUIP;
			equipCell.notComplete = true;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mc.mcBeltBg,ConstEquipCell.HP_YAODAI,ConstEquipCell.TYPE_YAODAI);//腰带
			equipCell.storageType = ConstStorage.ST_HERO_EQUIP;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mc.mcShoesBg,ConstEquipCell.HP_XIEZI,ConstEquipCell.TYPE_XIEZI);//鞋子
			equipCell.storageType = ConstStorage.ST_HERO_EQUIP;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mc.mcMedalBg,ConstEquipCell.HP_XUNZHANG,ConstEquipCell.TYPE_XUNZHANG);//勋章
			equipCell.storageType = ConstStorage.ST_HERO_EQUIP;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mc.mcMagicRingBg,ConstEquipCell.HP_HUANJIE,ConstEquipCell.TYPE_HUANJIE);//幻戒
			equipCell.storageType = ConstStorage.ST_HERO_EQUIP;
			_equipCells.push(equipCell);
			//
			var i:int,l:int = _equipCells.length;
			for (i=0;i<l;i++) 
			{
				equipCell = _equipCells[i];
				if(equipCell.type != ConstEquipCell.TYPE_XUNZHANG)
				{
					equipCell.doubleClickEnabled = true;
				}
			}
			//
			_equipCellEventHandle = new HeroEquipCellEventHandle(mc);
			_equipCellEventHandle.equipCells = _equipCells;
//			_heroEquipUpgradeCell = new HeroEquipActivateCell();
//			_heroEquipUpgradeCell.visible=false;
//			mc.addChild(_heroEquipUpgradeCell);
			
//			_heroEUCMouseHandler=new HeroEquipActivateEventHandle(_heroEquipUpgradeCell);
		}
		
		public function refreshEquips():void
		{
			var upgradeData:HeroEquipActivateData=HeroDataManager.instance.heroActivateData;
			var upgradeCfg:HeroEquipUpgradeCfgData=ConfigDataManager.instance.heroEquipUpgradeCfgData(upgradeData.grade,upgradeData.order);
			
			var i:int;
			var l:int;
			var equipDatas:Vector.<EquipData> = HeroDataManager.instance.equipDatas;
			l = equipDatas.length;
			for(i=0;i<l;i++)
			{
				var equipData:EquipData = equipDatas[i];
				
//				if(_equipCells[i].slot==upgradeCfg.slot)
//				{
//					_heroEquipUpgradeCell.equipCell=_equipCells[i];
//					_heroEquipUpgradeCell.updateView();
//					ToolTipManager.getInstance().attach(_heroEquipUpgradeCell,false,false);
//				}
				
				if(!equipData) 
				{
					_equipCells[i].setNull();
					ToolTipManager.getInstance().detach(_equipCells[i]);
					continue;
				}
				var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(equipData.bornSid, equipData.id);
				if(!memEquipData)
				{
					_equipCells[i].setNull();
					ToolTipManager.getInstance().detach(_equipCells[i]);
					continue;
				}
				var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
				if(!equipCfgData)
				{
					_equipCells[i].setNull();
					ToolTipManager.getInstance().detach(_equipCells[i]);
					continue;
				}
				if(equipCfgData.type != _equipCells[i].type)
				{
					_equipCells[i].setNull();
					ToolTipManager.getInstance().detach(_equipCells[i]);
					continue;
				}
				_equipCells[i].refreshData(equipData.id, equipData.bornSid);
				_equipCells[i].tipType = ToolTipConst.EQUIP_BASE_TIP_HERO;
				ToolTipManager.getInstance().attach(_equipCells[i],false);
			}
		}
		
		public function set visible(value:Boolean):void
		{
			var i:int,l:int;
			l = _equipCells.length;
			for(i=0;i<l;i++)
			{
				_equipCells[i].visible = value;
			}
		}
		
//		public function timer():void
//		{
//			_heroEquipUpgradeCell.timer();
//		}
		
		public function takeOffEquip(slot:int):void
		{
			_equipCells[slot].setNull();
			ToolTipManager.getInstance().detach(_equipCells[slot]);
		}
		
		public function destory():void
		{
//			ToolTipManager.getInstance().detach(_heroEquipUpgradeCell);
			_equipCellEventHandle.destory();
//			if(_heroEUCMouseHandler)
//			{
//				_heroEUCMouseHandler.destroy();
//			}
//			_heroEUCMouseHandler=null;
			
//			if(_heroEquipUpgradeCell)
//			{
//				_heroEquipUpgradeCell.destory();
//				_heroEquipUpgradeCell.parent&&_heroEquipUpgradeCell.parent.removeChild(_heroEquipUpgradeCell);
//			}
//			_heroEquipUpgradeCell=null;
			
			while(_equipCells && _equipCells.length)
			{
				var pop:EquipCell = _equipCells.pop();
				pop.destory();
				ToolTipManager.getInstance().detach(pop);
			}
			_equipCells = null;
		}
	}
}