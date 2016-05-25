package com.view.gameWindow.panel.panels.hero.tab1.equip
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.consts.ConstStorage;
	import com.model.consts.SlotType;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.mainUi.subuis.herohead.McHeroEquipPanel;
	import com.view.gameWindow.mainUi.subuis.lasting.LastingDataMananger;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.cell.BagCell;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipCell;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * 英雄装备格子事件处理类
	 * @author Administrator
	 */	
	public class HeroEquipCellEventHandle
	{
		public var equipCells:Vector.<EquipCell>;
		
		private var _mc:McHeroEquipPanel;
		private var _clickEquipCell:EquipCell,_overEquipCell:EquipCell,_dragBitmap:Bitmap;
		
		public function HeroEquipCellEventHandle(mc:McHeroEquipPanel)
		{
			_mc = mc;
			init();
		}
		
		private function init():void
		{
			_mc.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			_mc.addEventListener(MouseEvent.ROLL_OVER,onOver,true);
			_mc.addEventListener(MouseEvent.ROLL_OUT,onOut,true);
			_mc.parent.doubleClickEnabled = true;
			_mc.parent.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick);
		}
		
		protected function onDoubleClick(event:MouseEvent):void
		{
			var manager:HeroDataManager = HeroDataManager.instance;
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
			if(equipCell.type == ConstEquipCell.TYPE_XUNZHANG)
			{
				return;
			}
			if(equipCell.isEmpty())
			{
				return;
			}
			
			if(equipCell.type==ConstEquipCell.TYPE_HUOLONGZHIXIN||equipCell.type==ConstEquipCell.TYPE_XUNZHANG
				||equipCell.type==ConstEquipCell.TYPE_DUNPAI||equipCell.type==ConstEquipCell.TYPE_HUANJIE)
			{
				return;
			}
			
			equipCell.txtNum.text = "";
			sendData(equipCell.storageType,equipCell.slot,ConstStorage.ST_HERO_BAG,slot);
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
			if(!equipCell)
			{
				return;
			}
			if(equipCell && equipCell.isEmpty())
			{
				equipCell = null;
			}
			_clickEquipCell = equipCell;
			if(!_clickEquipCell)
			{
				return;
			}
			if(_clickEquipCell.type==ConstEquipCell.TYPE_HUOLONGZHIXIN||_clickEquipCell.type==ConstEquipCell.TYPE_XUNZHANG
				||_clickEquipCell.type==ConstEquipCell.TYPE_DUNPAI||_clickEquipCell.type==ConstEquipCell.TYPE_HUANJIE)
			{
				return;
			}
			if(LastingDataMananger.getInstance().isRepair)
			{
				LastingDataMananger.getInstance().repairEquip(equipCell);
				return;
			}
			
//			if(_clickEquipCell.type == ConstEquipCell.TYPE_HUANJIE || _clickEquipCell.type == ConstEquipCell.TYPE_XUNZHANG)
//			{
				HeroDataManager.instance.setUsedCellOnlyId(_clickEquipCell.slot);
				_mc.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
				_mc.stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
//			}
		}
		
		protected function onMove(event:MouseEvent):void
		{
			if(_clickEquipCell)
			{
				if(!_dragBitmap)
				{
					_dragBitmap = _clickEquipCell.getBitmap();
					_mc.stage.addChild(_dragBitmap);
				}
				_clickEquipCell.txtNum.text = "";
				_dragBitmap.x = _mc.stage.mouseX-_dragBitmap.width/2;
				_dragBitmap.y = _mc.stage.mouseY-_dragBitmap.height/2;
			}
			else
			{
				_mc.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
				_mc.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			}
		}
		
		protected function onUp(event:MouseEvent):void
		{
			if(_clickEquipCell && _dragBitmap)
			{
				if(_overEquipCell && _overEquipCell != _clickEquipCell)
				{
					sendData(ConstStorage.ST_HERO_EQUIP,_clickEquipCell.slot,_overEquipCell.storageType,_overEquipCell.slot);
					var overBitmap:Bitmap;
					var equipData:EquipData;
					if(_overEquipCell.type == _clickEquipCell.type)
						HeroDataManager.instance.exchangeEquipCellPicId(_overEquipCell.slot,_clickEquipCell.slot);
					equipData = HeroDataManager.instance.equipDatas[_overEquipCell.slot];//目标格的数据
					if(equipData)//目标格不为空
					{
						equipData = HeroDataManager.instance.equipDatas[_clickEquipCell.slot];
						overBitmap = _overEquipCell.getBitmap();//不论是否为同一类物品始终取出目标格的图片
						if(equipData && overBitmap)//交换后点击格数据存在表示格子中为不同类物品
							_clickEquipCell.setBitmap(overBitmap, equipData.id, equipData.bornSid);
					}
					_mc.stage.removeChild(_dragBitmap);
					equipData = HeroDataManager.instance.equipDatas[_overEquipCell.slot];
					_overEquipCell.setBitmap(_dragBitmap, equipData.id, equipData.bornSid);
				}
				else
				{
					if(!onBagUp(event)/* && !onRoleEquipUp(event)*/)
					{
						_mc.stage.removeChild(_dragBitmap);
						equipData = HeroDataManager.instance.equipDatas[_clickEquipCell.slot];
						_clickEquipCell.setBitmap(_dragBitmap, equipData.id, equipData.bornSid);
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
			_mc.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			_mc.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		/**在英雄面板物品格子中放开鼠标*/
		private function onBagUp(event:MouseEvent):Boolean
		{
			var bagCell:BagCell = event.target as BagCell;
			if(!bagCell || bagCell.storageType != ConstStorage.ST_HERO_BAG)
			{
				return false;
			}
			var equipData:EquipData = HeroDataManager.instance.getAndUsedCellEquipData();
			if(!equipData) return false;
			var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(equipData.bornSid, equipData.id);
			if(!memEquipData) return false;
			/*var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
			if(!equipCfgData) return;*/
			if(bagCell.isLock || !bagCell.isEmpty()) return false;
			var usedCellSlot:int = HeroDataManager.instance.usedCellSlot;
			if(usedCellSlot < 0) return false;
			_mc.stage.removeChild(_dragBitmap);
			var bagData:BagData = new BagData();
			bagData.id = equipData.id;
			bagData.bornSid = equipData.bornSid;
			bagData.type = SlotType.IT_EQUIP;
			bagData.count = 1;
			bagData.bind = memEquipData.bind;
			bagCell.refreshData(bagData);
			sendData(ConstStorage.ST_HERO_EQUIP,usedCellSlot,bagCell.storageType,bagCell.cellId);
			return true;
		}
		/**在角色属性面板装备格中放开鼠标*/
		private function onRoleEquipUp(event:MouseEvent):Boolean
		{
			var equipCell:EquipCell = event.target as EquipCell;
			if(!equipCell || equipCell.storageType != ConstStorage.ST_CHR_EQUIP)
			{
				return false;
			}
			var usedCellSlot:int = HeroDataManager.instance.usedCellSlot;
			if(usedCellSlot < 0)
			{
				return false;
			}
			_mc.stage.removeChild(_dragBitmap);
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
			_mc.removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
			_mc.removeEventListener(MouseEvent.ROLL_OVER,onOver,true);
			_mc.removeEventListener(MouseEvent.ROLL_OUT,onOut,true);
			_mc.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			_mc.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			_mc.parent.removeEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick);
			equipCells = null;
			_mc = null;
		}
		
		public function get dragBitmap():Bitmap
		{
			return _dragBitmap;
		}
	}
}