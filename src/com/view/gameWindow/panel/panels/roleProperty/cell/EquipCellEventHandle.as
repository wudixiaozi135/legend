package com.view.gameWindow.panel.panels.roleProperty.cell
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.consts.ConstStorage;
    import com.model.consts.SlotType;
    import com.model.gameWindow.mem.MemEquipData;
    import com.model.gameWindow.mem.MemEquipDataManager;
    import com.view.gameWindow.mainUi.subuis.lasting.LastingDataMananger;
    import com.view.gameWindow.panel.panels.bag.BagData;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.bag.cell.BagCell;
    import com.view.gameWindow.panel.panels.roleProperty.McRole;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.scene.GameSceneManager;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;

    import flash.display.Bitmap;
    import flash.events.MouseEvent;
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    /**
	 * 装备格子事件处理类
	 * @author Administrator
	 */	
	public class EquipCellEventHandle
	{
		public var equipCells:Vector.<EquipCell>;
		
		private var _mcRoleProperty:McRole;
		private var _clickEquipCell:EquipCell,_overEquipCell:EquipCell,_dragBitmap:Bitmap;
		
		public function get clickEquipCell():EquipCell
		{
			return _clickEquipCell;
		}
		
		public function EquipCellEventHandle(mcRoleProperty:McRole)
		{
			_mcRoleProperty = mcRoleProperty;
			_mcRoleProperty.addEventListener(MouseEvent.ROLL_OVER,onOver,true);
			_mcRoleProperty.addEventListener(MouseEvent.ROLL_OUT,onOut,true);
			
			_mcRoleProperty.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			_mcRoleProperty.parent.doubleClickEnabled = true;
			_mcRoleProperty.parent.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick);
		}
		
		protected function onDoubleClick(event:MouseEvent):void
		{
			var manager:BagDataManager = BagDataManager.instance;
			var slot:int = manager.getFirstEmptyCellId();
			if(slot == -1)
			{
				manager.promptBagPacked();
				return;
			}
			var equipCell:EquipCell;
			equipCell = event.target as EquipCell;
			if(!equipCell)
			{
				return;
			}
			if(equipCell.isEmpty())
			{
				return;
			}
			
			if(equipCell.type==ConstEquipCell.TYPE_HUOLONGZHIXIN||equipCell.type==ConstEquipCell.TYPE_XUNZHANG
                    || equipCell.type == ConstEquipCell.TYPE_DUNPAI || equipCell.type == ConstEquipCell.TYPE_HUANJIE
                    || equipCell.type == ConstEquipCell.TYPE_CHIBANG)
			{
				return;
			}
			
			equipCell.txtNum.text = "";
			sendData(equipCell.storageType,equipCell.slot,ConstStorage.ST_CHR_BAG,slot);
		}		
		
		private function sendData(oldStorage:int,oldSlot:int,newStorage:int,newSlot:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(oldStorage);
			byteArray.writeByte(oldSlot);
			byteArray.writeByte(newStorage);
			byteArray.writeByte(newSlot);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_MOVE_ITEM,byteArray);
		}
		
		protected function onDown(event:MouseEvent):void
		{
			var equipCell:EquipCell;
			equipCell = event.target as EquipCell;
			if(!equipCell) return;
			if(equipCell && equipCell.isEmpty())
				equipCell = null;
			_clickEquipCell = equipCell;
			if(!_clickEquipCell) return;
			if(_clickEquipCell.type==ConstEquipCell.TYPE_HUOLONGZHIXIN||_clickEquipCell.type==ConstEquipCell.TYPE_XUNZHANG
                    || _clickEquipCell.type == ConstEquipCell.TYPE_DUNPAI || _clickEquipCell.type == ConstEquipCell.TYPE_HUANJIE
                    || _clickEquipCell.type == ConstEquipCell.TYPE_CHIBANG)
			{
				return;
			}
			if(LastingDataMananger.getInstance().isRepair)
			{
				LastingDataMananger.getInstance().repairEquip(equipCell);
				return;
			}
			RoleDataManager.instance.setUsedCellOnlyId(_clickEquipCell.slot);
			_mcRoleProperty.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			_mcRoleProperty.stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		protected function onMove(event:MouseEvent):void
		{
			if(_clickEquipCell)
			{
				if(!_dragBitmap)
				{
					_dragBitmap = _clickEquipCell.getBitmap();
					_mcRoleProperty.stage.addChild(_dragBitmap);
				}
				_clickEquipCell.txtNum.text = "";
				_dragBitmap.x = _mcRoleProperty.stage.mouseX-_dragBitmap.width/2;
				_dragBitmap.y = _mcRoleProperty.stage.mouseY-_dragBitmap.height/2;
			}
			else
			{
				_mcRoleProperty.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
				_mcRoleProperty.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			}
		}
		
		protected function onUp(event:MouseEvent):void
		{
			if(_clickEquipCell && _dragBitmap)
			{
				if(_overEquipCell && _overEquipCell != _clickEquipCell)
				{
					sendData(ConstStorage.ST_CHR_EQUIP,_clickEquipCell.slot,_overEquipCell.storageType,_overEquipCell.slot);
					var overBitmap:Bitmap;
					var equipData:EquipData;
					if(_overEquipCell.type == _clickEquipCell.type)
						RoleDataManager.instance.exchangeEquipCellPicId(_overEquipCell.slot,_clickEquipCell.slot);
					equipData = RoleDataManager.instance.equipDatas[_overEquipCell.slot];//目标格的数据
					if(equipData)//目标格不为空
					{
						equipData = RoleDataManager.instance.equipDatas[_clickEquipCell.slot];
						overBitmap = _overEquipCell.getBitmap();//不论是否为同一类物品始终取出目标格的图片
						if(equipData && overBitmap)//交换后点击格数据存在表示格子中为不同类物品
							_clickEquipCell.setBitmap(overBitmap, equipData.id, equipData.bornSid);
					}
					_mcRoleProperty.stage.removeChild(_dragBitmap);
					equipData = RoleDataManager.instance.equipDatas[_overEquipCell.slot];
					_overEquipCell.setBitmap(_dragBitmap, equipData.id, equipData.bornSid);
				}
				else
				{
					if(!onBagUp(event)/* && !onHeroEquipUp(event)*/)
					{
						_mcRoleProperty.stage.removeChild(_dragBitmap);
						equipData = RoleDataManager.instance.equipDatas[_clickEquipCell.slot];
						_clickEquipCell.setBitmap(_dragBitmap, equipData.id, equipData.bornSid);
						ToolTipManager.getInstance().attach(_clickEquipCell);
						if(MemEquipDataManager.instance.memEquipData(_clickEquipCell.bornSid,_clickEquipCell.onlyId).strengthen)
						{
							_clickEquipCell.setChildIndex(_clickEquipCell.txtNum,_clickEquipCell.numChildren-2);
							_clickEquipCell.txtNum.text = "+" + MemEquipDataManager.instance.memEquipData(_clickEquipCell.bornSid,_clickEquipCell.onlyId).strengthen;
						}	
					}
				}
			}
			
			_clickEquipCell = null;
			_overEquipCell = null;
			_dragBitmap = null;
			_mcRoleProperty.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			_mcRoleProperty.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		/**在背包格子中放开鼠标*/
		private function onBagUp(event:MouseEvent):Boolean
		{
			var bagCell:BagCell = event.target as BagCell;
			if(!bagCell || bagCell.storageType != ConstStorage.ST_CHR_BAG)
			{
				return false;
			}
			var equipData:EquipData = RoleDataManager.instance.getAndUsedCellEquipData();
			if(!equipData) return false;
			var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(equipData.bornSid, equipData.id);
			if(!memEquipData) return false;
			/*var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
			if(!equipCfgData) return;*/
			if(bagCell.isLock || !bagCell.isEmpty()) return false;
			var usedCellSlot:int = RoleDataManager.instance.usedCellSlot;
			if(usedCellSlot < 0) return false;
			_mcRoleProperty.stage.removeChild(_dragBitmap);
			var bagData:BagData = new BagData();
			bagData.id = equipData.id;
			bagData.bornSid = equipData.bornSid;
			bagData.type = SlotType.IT_EQUIP;
			bagData.count = 1;
			bagData.bind = memEquipData.bind;
			bagCell.refreshData(bagData);
			sendData(ConstStorage.ST_CHR_EQUIP,usedCellSlot,bagCell.storageType,bagCell.cellId);
			return true;
		}
		/**在角色属性面板装备格中放开鼠标*/
		private function onHeroEquipUp(event:MouseEvent):Boolean
		{
			var equipCell:EquipCell = event.target as EquipCell;
			if(!equipCell || equipCell.storageType != ConstStorage.ST_HERO_EQUIP)
			{
				return false;
			}
			var usedCellSlot:int = RoleDataManager.instance.usedCellSlot;
			if(usedCellSlot < 0)
			{
				return false;
			}
			_mcRoleProperty.stage.removeChild(_dragBitmap);
			sendData(ConstStorage.ST_HERO_EQUIP,usedCellSlot,equipCell.storageType,equipCell.slot);
			return true;
		}
		
		protected function onOver(event:MouseEvent):void
		{
			
		}
		
		protected function onOut(event:MouseEvent):void
		{
			
		}
		
		public function destory():void
		{
			_clickEquipCell = null;
			_overEquipCell = null;
			_dragBitmap = null;
			_mcRoleProperty.parent.removeEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick);
			_mcRoleProperty.removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
			_mcRoleProperty.removeEventListener(MouseEvent.ROLL_OVER,onOver,true);
			_mcRoleProperty.removeEventListener(MouseEvent.ROLL_OUT,onOut,true);
			GameSceneManager.getInstance().stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			GameSceneManager.getInstance().stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
//			if(_mcRoleProperty.stage)
//			{
//				_mcRoleProperty.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
//				_mcRoleProperty.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
//			}	
			equipCells = null;
			_mcRoleProperty = null;
		}

		public function get dragBitmap():Bitmap
		{
			return _dragBitmap;
		}

	}
}