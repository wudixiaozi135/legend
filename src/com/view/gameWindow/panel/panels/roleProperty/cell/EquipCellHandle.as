package com.view.gameWindow.panel.panels.roleProperty.cell
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.consts.ConstRoleType;
    import com.model.consts.ConstStorage;
    import com.model.gameWindow.mem.MemEquipData;
    import com.model.gameWindow.mem.MemEquipDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.McRole;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.otherRole.OtherPlayerDataManager;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;

    /**
	 * 装备格子处理类
	 * @author Administrator
	 */	
	public class EquipCellHandle
	{
		private var _equipCells:Vector.<EquipCell>;
		private var _equipCellEventHandle:EquipCellEventHandle;
		private var _type:int;
		
		public function EquipCellHandle()
		{
			_equipCells = new Vector.<EquipCell>();
		}
		
		public function initData(mcRoleProperty:McRole,type:int = 0):void
		{
			var equipCell:EquipCell;
			_type = type;
			equipCell = new EquipCell(mcRoleProperty.mcArmsBg,ConstEquipCell.CP_WUQI,ConstEquipCell.TYPE_WUQI);//武器
			equipCell.roleType = _type;
			equipCell.storageType = ConstStorage.ST_CHR_EQUIP;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mcRoleProperty.mcHelmBg,ConstEquipCell.CP_TOUKUI,ConstEquipCell.TYPE_TOUKUI);//头盔
			equipCell.roleType = _type;
			equipCell.storageType = ConstStorage.ST_CHR_EQUIP;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mcRoleProperty.mcNecklaceBg,ConstEquipCell.CP_XIANGLIAN,ConstEquipCell.TYPE_XIANGLIAN);//项链
			equipCell.roleType = _type;
			equipCell.storageType = ConstStorage.ST_CHR_EQUIP;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mcRoleProperty.mcClothesBg,ConstEquipCell.CP_YIFU,ConstEquipCell.TYPE_YIFU);//衣服
			equipCell.roleType = _type;
			equipCell.storageType = ConstStorage.ST_CHR_EQUIP;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mcRoleProperty.mcBraceletBg0,ConstEquipCell.CP_SHOUZHUO_LEFT,ConstEquipCell.TYPE_SHOUZHUO);//手镯左
			equipCell.roleType = _type;
			equipCell.storageType = ConstStorage.ST_CHR_EQUIP;
			equipCell.notComplete = true;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mcRoleProperty.mcBraceletBg1,ConstEquipCell.CP_SHOUZHUO_RIGHT,ConstEquipCell.TYPE_SHOUZHUO);//手镯右
			equipCell.roleType = _type;
			equipCell.notComplete = true;
			equipCell.storageType = ConstStorage.ST_CHR_EQUIP;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mcRoleProperty.mcRingBg0,ConstEquipCell.CP_JIEZHI_LEFT,ConstEquipCell.TYPE_JIEZHI);//戒指左
			equipCell.roleType = _type;
			equipCell.storageType = ConstStorage.ST_CHR_EQUIP;
			equipCell.notComplete = true;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mcRoleProperty.mcRingBg1,ConstEquipCell.CP_JIEZHI_RIGHT,ConstEquipCell.TYPE_JIEZHI);//戒指右
			equipCell.roleType = _type;
			equipCell.storageType = ConstStorage.ST_CHR_EQUIP;
			equipCell.notComplete = true;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mcRoleProperty.mcBeltBg,ConstEquipCell.CP_YAODAI,ConstEquipCell.TYPE_YAODAI);//腰带
			equipCell.roleType = _type;
			equipCell.storageType = ConstStorage.ST_CHR_EQUIP;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mcRoleProperty.mcShoesBg,ConstEquipCell.CP_XIEZI,ConstEquipCell.TYPE_XIEZI);//鞋子
			equipCell.roleType = _type;
			equipCell.storageType = ConstStorage.ST_CHR_EQUIP;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mcRoleProperty.mcMedalBg,ConstEquipCell.CP_XUNZHANG,ConstEquipCell.TYPE_XUNZHANG);//勋章
			equipCell.roleType = _type;
			equipCell.storageType = ConstStorage.ST_CHR_EQUIP;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mcRoleProperty.mcHeartBg,ConstEquipCell.CP_HUOLONGZHIXIN,ConstEquipCell.TYPE_HUOLONGZHIXIN);//火龙之心
			equipCell.roleType = _type;
			equipCell.storageType = ConstStorage.ST_CHR_EQUIP;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mcRoleProperty.mcMagicRingBg,ConstEquipCell.CP_HUANJIE,ConstEquipCell.TYPE_HUANJIE);//幻戒
			equipCell.roleType = _type;
			equipCell.storageType = ConstStorage.ST_CHR_EQUIP;
			_equipCells.push(equipCell);
			equipCell = new EquipCell(mcRoleProperty.mcShieldBg,ConstEquipCell.CP_DUNPAI,ConstEquipCell.TYPE_DUNPAI);//盾牌
			equipCell.roleType = _type;
			equipCell.storageType = ConstStorage.ST_CHR_EQUIP;
			_equipCells.push(equipCell);
            equipCell = new EquipCell(mcRoleProperty.mcWingBg, ConstEquipCell.CP_CHIBANG, ConstEquipCell.TYPE_CHIBANG);//翅膀
            equipCell.roleType = _type;
            equipCell.storageType = ConstStorage.ST_CHR_EQUIP;
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
			if(_type == ConstRoleType.ROLE)
			{
				_equipCellEventHandle = new EquipCellEventHandle(mcRoleProperty);
				_equipCellEventHandle.equipCells = _equipCells;
			}
		}
		
		public function refreshEquips():void
		{
			var i:int;
			var l:int;
			var equipDatas:Vector.<EquipData> = (_type == ConstRoleType.ROLE?RoleDataManager.instance.equipDatas:OtherPlayerDataManager.instance.equipDatas);
			l = equipDatas.length;
			for(i=0;i<l;i++)
			{
				var equipData:EquipData = equipDatas[i];
				if(!equipData) 
				{
					_equipCells[i].setNull();
					ToolTipManager.getInstance().detach(_equipCells[i]);
					continue;
				}
				if(_equipCellEventHandle && _equipCellEventHandle.clickEquipCell && _equipCells[i].slot == _equipCellEventHandle.clickEquipCell.slot)
				{
					continue;
				}
				var memEquipData:MemEquipData = _type == ConstRoleType.ROLE?MemEquipDataManager.instance.memEquipData(equipData.bornSid, equipData.id):OtherPlayerDataManager.instance.memEquipData(equipData.bornSid, equipData.id);
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
				ToolTipManager.getInstance().attach(_equipCells[i]);
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
		
		public function takeOffEquip(slot:int):void
		{
			_equipCells[slot].setNull();
			ToolTipManager.getInstance().detach(_equipCells[slot]);
		}
		
		public function destory():void
		{
			if(_equipCellEventHandle)
			{
				_equipCellEventHandle.destory();
			}
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