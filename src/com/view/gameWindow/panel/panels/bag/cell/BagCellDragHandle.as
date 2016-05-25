package com.view.gameWindow.panel.panels.bag.cell
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.consts.ConstStorage;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarCell;
	import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarDataManager;
	import com.view.gameWindow.mainUi.subuis.lasting.LastingDataMananger;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.bag.BagPanel;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipCell;
	import com.view.gameWindow.panel.panels.stall.PanelStall;
	import com.view.gameWindow.panel.panels.stall.StallDataManager;
	import com.view.gameWindow.panel.panels.stall.stallSell.StallSellDataManager;
	import com.view.gameWindow.panel.panels.storage.StorageDataMannager;
	import com.view.gameWindow.panel.panels.trade.TradeDataManager;
	import com.view.gameWindow.panel.panels.trade.data.OppositeDataInfo;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.SayUtil;
	
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * 背包单元格拖动处理类
	 * @author Administrator
	 */
	public class BagCellDragHandle
	{
		private var _panel:BagPanel;
		public var stage:Stage;
		private var _clickBagCell:BagCell, _overBagCell:BagCell, _dragBitmap:Bitmap;
		
		public function get clickBagCell():BagCell
		{
			return _clickBagCell;
		}
		/**取消一次点击UP事件的触发*/
		internal var cancelOnce:Boolean;

		public function BagCellDragHandle()
		{
		}

		public function addEvent(eventDispatcher:EventDispatcher):void
		{
			_panel = eventDispatcher as BagPanel;
			eventDispatcher.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			eventDispatcher.addEventListener(MouseEvent.ROLL_OVER, onOver, true);
			eventDispatcher.addEventListener(MouseEvent.ROLL_OUT, onOut, true);
		}

		protected function onDown(event:MouseEvent):void
		{
			/*trace("BagCellDragHandle.onDown");*/
			if (LastingDataMananger.getInstance().isRepair)return;
			if (RoleDataManager.instance.stallStatue)
			{
				return;
			}
			
			if (_clickBagCell)
			{
				onUp(null);
				_panel.bagCellClickHandle.cancelOnce = true;
				return;
			}
			if (event.target is BagCell)
			{
				_clickBagCell = event.target as BagCell;
				if (_clickBagCell && _clickBagCell.isEmpty())
				{
					_clickBagCell = null;
				}
				if (_clickBagCell)
				{
					dealOnDown(_clickBagCell);
				}
			}
		}

		internal function dealOnDown(bagCell:BagCell):void
		{
			_clickBagCell = bagCell;
			BagDataManager.instance.setUsedCellData(bagCell.cellId);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
		}

		internal function onMove(event:MouseEvent):void
		{
			if (_clickBagCell)
			{
				if (!_dragBitmap)
				{
					_dragBitmap = _clickBagCell.getBitmap();
					if (_dragBitmap)
					{
						stage.addChild(_dragBitmap);
					}
				}
				if (_dragBitmap)
				{
					_dragBitmap.x = stage.mouseX - _dragBitmap.width / 2;
					_dragBitmap.y = stage.mouseY - _dragBitmap.height / 2;
				}
			}
			else
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			}
		}

		protected function onUp(event:MouseEvent):void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				return;
			}
			/*trace("BagCellDragHandle.onUp");*/
			if (cancelOnce)
			{
				cancelOnce = false;
				return;
			}
			if (_clickBagCell && _dragBitmap)
			{
				if (_overBagCell && !_overBagCell.isLock && _overBagCell != _clickBagCell)
				{
					sendData(ConstStorage.ST_CHR_BAG, _clickBagCell.cellId, _overBagCell.storageType, _overBagCell.cellId);
					var overBitmap:Bitmap, infos:BagData;
					BagDataManager.instance.exchangeBagCellData(_clickBagCell.cellId, _overBagCell.cellId);//数据以交换或叠加
					infos = BagDataManager.instance.bagCellDatas[_overBagCell.cellId];//目标格的数据
					if (infos)//目标格不为空
					{
						infos = BagDataManager.instance.bagCellDatas[_clickBagCell.cellId];
						overBitmap = _overBagCell.getBitmap();//不论是否为同一类物品始终取出目标格的图片
						if (infos && overBitmap)//交换后点击格数据存在表示格子中为不同类物品
						{
							_clickBagCell.setBitmap(overBitmap, infos);
							ToolTipManager.getInstance().attach(_clickBagCell);
						}
					}
					stage.removeChild(_dragBitmap);
					infos = BagDataManager.instance.bagCellDatas[_overBagCell.cellId];
					_overBagCell.setBitmap(_dragBitmap, infos);
					ToolTipManager.getInstance().attach(_overBagCell);
				}
				else
				{
					if (!onEquipUp(event) && !onHeroBagUp(event) && !onHeroEquipUp(event) && !onActionBarUp(event) && !onStorageBagUp(event) && !onTradeBagUp(event) && !onStallBagUp(event))
					{
						stage.removeChild(_dragBitmap);
						infos = BagDataManager.instance.bagCellDatas[_clickBagCell.cellId];
						_clickBagCell.setBitmap(_dragBitmap, infos);
						ToolTipManager.getInstance().attach(_clickBagCell);
						_panel.bagCellClickHandle.dealLitter(_clickBagCell, true);
					}
				}
			}
			_clickBagCell = null;
			_overBagCell = null;
			_dragBitmap = null;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
		}

		/**在角色属性面板装备格中放开鼠标*/
		private function onEquipUp(event:MouseEvent):Boolean
		{
			if (!event)
			{
				return false;
			}
			var equipCell:EquipCell;
			equipCell = event.target as EquipCell;
			if (!equipCell)
			{
				return false;
			}
			if (equipCell.storageType != ConstStorage.ST_CHR_EQUIP)
			{
				return false;
			}
			var usedCellData:BagData = BagDataManager.instance.usedCellData;
			if (!usedCellData)
			{
				return false;
			}
			var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(usedCellData.bornSid, usedCellData.id);
			if (!memEquipData)
			{
				trace("in BagCellDragHandle.onRoleUp 不存在id" + usedCellData.id);
				return false;
			}
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
			if (!equipCfgData)
			{
				trace("in BagCellDragHandle.onRoleUp 不存在id" + memEquipData.baseId);
				return false;
			}
			if (equipCfgData.entity && equipCfgData.entity != EntityTypes.ET_PLAYER)
			{
				trace("in BagCellDragHandle.onRoleUp 使用类型不对");
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0033);
				return false;
			}
			if (equipCfgData.type != equipCell.type)
			{
				trace("in BagCellDragHandle.onRoleUp 类型不对");
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0012);
				return false;
			}
			var job:int = RoleDataManager.instance.job;
			if (equipCfgData.job && equipCfgData.job != job)
			{
				trace("in BagCellDragHandle.onRoleUp 职业不对");
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0013);
				return false;
			}
			var sex:int = RoleDataManager.instance.sex;
			if (equipCfgData.sex && equipCfgData.sex != sex)
			{
				trace("in BagCellDragHandle.onRoleUp 性别不对");
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0014);
				return false;
			}
			var lv:int = RoleDataManager.instance.lv;
			if (equipCfgData.level > lv)
			{
				trace("in BagCellDragHandle.onRoleUp 等级不够");
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0015);
				return false;
			}
			stage.removeChild(_dragBitmap);
			equipCell.refreshData(usedCellData.id, usedCellData.bornSid);
			ToolTipManager.getInstance().attach(equipCell);
			sendData(ConstStorage.ST_CHR_BAG, usedCellData.slot, equipCell.storageType, equipCell.slot);
			return true;
		}

		/**在英雄面板装备格中放开鼠标*/
		private function onHeroEquipUp(event:MouseEvent):Boolean
		{
			if (!event)
			{
				return false;
			}
			var equipCell:EquipCell;
			equipCell = event.target as EquipCell;
			if (!equipCell)
			{
				return false;
			}
			if (equipCell.storageType != ConstStorage.ST_HERO_EQUIP)
			{
				return false;
			}
//			if (equipCell.type == ConstEquipCell.TYPE_XUNZHANG || equipCell.type == ConstEquipCell.TYPE_HUANJIE)
//			{
				var usedCellData:BagData = BagDataManager.instance.usedCellData;
				if (!usedCellData)
				{
					return false;
				}
				var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(usedCellData.bornSid, usedCellData.id);
				if (!memEquipData)
				{
					trace("in BagCellDragHandle.onRoleUp 不存在id" + usedCellData.id);
					return false;
				}
				var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
				if (!equipCfgData)
				{
					trace("in BagCellDragHandle.onRoleUp 不存在id" + memEquipData.baseId);
					return false;
				}
				if (equipCfgData.entity && equipCfgData.entity != EntityTypes.ET_HERO)
				{
					trace("in BagCellDragHandle.onRoleUp 使用类型不对");
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0034);
					return false;
				}
				if (equipCfgData.type != equipCell.type)
				{
					trace("in BagCellDragHandle.onRoleUp 类型不对");
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0012);
					return false;
				}
				var job:int = HeroDataManager.instance.job;
				if (equipCfgData.job && equipCfgData.job != job)
				{
					trace("in BagCellDragHandle.onRoleUp 职业不对");
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0013);
					return false;
				}
				var sex:int = HeroDataManager.instance.sex;
				if (equipCfgData.sex && equipCfgData.sex != sex)
				{
					trace("in BagCellDragHandle.onRoleUp 性别不对");
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0014);
					return false;
				}
				var lv:int = HeroDataManager.instance.lv;
				if (equipCfgData.level > lv)
				{
					trace("in BagCellDragHandle.onRoleUp 等级不够");
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0015);
					return false;
				}
				if(BagDataManager.instance.isBagHeroFightPowerHigher(usedCellData))
				{
//					var myHero:IHero = EntityLayerManager.getInstance().myHero;
//					if(myHero)
//					{
//						var randomIndex:int= Math.random()*StringConst.HERO_SAY_0001.length;
//						myHero.say(StringConst.HERO_SAY_0001[randomIndex]);
//					}
					SayUtil.heroSayEquip();
				}
				stage.removeChild(_dragBitmap);
				equipCell.refreshData(usedCellData.id, usedCellData.bornSid);
				ToolTipManager.getInstance().attach(equipCell);
				
				sendData(ConstStorage.ST_CHR_BAG, usedCellData.slot, equipCell.storageType, equipCell.slot);
				return true;
//			}
//			else
//			{
//				stage.removeChild(_dragBitmap);
//				var infos:BagData = BagDataManager.instance.bagCellDatas[_clickBagCell.cellId];
//				_clickBagCell.setBitmap(_dragBitmap, infos);
//				ToolTipManager.getInstance().attach(_clickBagCell);
//				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.BAG_PANEL_0032);
//				return true;
//			}
		}

		/**在英雄面板物品格中放开鼠标*/
		private function onHeroBagUp(event:MouseEvent):Boolean
		{
			if (!event)
			{
				return false;
			}
			var bagCell:BagCell = event.target as BagCell;
			if (!bagCell || bagCell.storageType != ConstStorage.ST_HERO_BAG || bagCell.isLock)
			{
				return false;
			}
			var usedCellData:BagData = BagDataManager.instance.usedCellData;
			if (!usedCellData)
			{
				return false;
			}
			stage.removeChild(_dragBitmap);
			ToolTipManager.getInstance().attach(bagCell);
			sendData(ConstStorage.ST_CHR_BAG, usedCellData.slot, bagCell.storageType, bagCell.cellId);
			return true;
		}

		/**在仓库面板品格中放开鼠标*/
		private function onStorageBagUp(event:MouseEvent):Boolean
		{
			if (!event)
			{
				return false;
			}
			var bagCell:BagCell = event.target as BagCell;
			var storgeId:int = ConstStorage.ST_STORAGE[StorageDataMannager.instance.storageId];
			if (!bagCell || bagCell.storageType != storgeId || bagCell.isLock)
			{
				return false;
			}
			var usedCellData:BagData = BagDataManager.instance.usedCellData;
			if (!usedCellData)
			{
				return false;
			}
			stage.removeChild(_dragBitmap);
			ToolTipManager.getInstance().attach(bagCell);
			StorageDataMannager.instance.moveStorageItem(ConstStorage.ST_CHR_BAG, usedCellData.slot, bagCell.storageType);
			return true;
		}

		private function onActionBarUp(event:MouseEvent):Boolean
		{
			if (!event)
			{
				return false;
			}
			var cell:ActionBarCell;
			cell = event.target as ActionBarCell;
			if (!cell)
			{
				return false;
			}
			var usedCellData:BagData = BagDataManager.instance.usedCellData;
			if (!usedCellData)
			{
				return false;
			}
			if (usedCellData.type != SlotType.IT_ITEM)
			{
				return false;
			}
			cell.refreshData(usedCellData.id, usedCellData.type);
			ToolTipManager.getInstance().attach(cell);
			sendKeyData(cell.key, cell.id);
			stage.removeChild(_dragBitmap);
			var infos:BagData = BagDataManager.instance.bagCellDatas[_clickBagCell.cellId];
			_clickBagCell.setBitmap(_dragBitmap, infos);
			ToolTipManager.getInstance().attach(_clickBagCell);
			return true;
		}

		private function onTradeBagUp(event:MouseEvent):Boolean
		{
			if (!event)
			{
				return false;
			}
			var bagCell:BagCell = event.target as BagCell;
			if (!bagCell || bagCell.storageType != ConstStorage.ST_TRADE_SELF_BAG || bagCell.isLock)
			{
				return false;
			}
			if (TradeDataManager.lock_state_self == true)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TRADE_0027);
				return false;
			}
			var usedCellData:BagData = BagDataManager.instance.usedCellData;
			if (!usedCellData)
			{
				return false;
			}
			if (usedCellData.bind == 1)
			{
				return false;
			}
			if (TradeDataManager.instance.checkLimit)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TRADE_0032);
				return false;
			}
			if (TradeDataManager.instance.checkSurpassOtherBagSizes)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TRADE_009);
				return false;
			}
			stage.removeChild(_dragBitmap);
			var opposite:OppositeDataInfo = TradeDataManager.instance.oppositeData;
			TradeDataManager.instance.sendCM_BEGIN_CHANGE(opposite.cid, opposite.sid, TradeDataManager.TRADE_TYPE_ITEM, usedCellData.storageType, usedCellData.slot, usedCellData.count);
			return true;
		}

		private function onStallBagUp(event:MouseEvent):Boolean
		{
			if (!event)
			{
				return false;
			}
			var panelStall:PanelStall = PanelMediator.instance.openedPanel(PanelConst.TYPE_STALL_PANEL) as PanelStall;
			if (!panelStall || (!panelStall.checkValidArea()))
			{
				return false;
			}
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0027);
				return false;
			}
			var usedCellData:BagData = BagDataManager.instance.usedCellData;
			if (!usedCellData)
			{
				return false;
			}
			if (usedCellData.bind)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0016);
				return false;
			}
			if (StallDataManager.instance.checkLimit)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0015);
				return false;
			}

			StallSellDataManager.bagData = usedCellData;
			StallSellDataManager.instance.dealPanelStallSell();
			stage.removeChild(_dragBitmap);
			return true;
		}

		private function sendKeyData(key:int, id:int):void
		{
			ActionBarDataManager.instance.sendSetItemData(key, id);
		}

		protected function onOver(event:MouseEvent):void
		{
			/*trace("over");*/
			if (event.target is BagCell)
				_overBagCell = event.target as BagCell;
			/*if(_overBagCell)
			 trace(_overBagCell.cellId);*/
		}

		protected function onOut(event:MouseEvent):void
		{
			/*trace("out");*/
			if (event.target is BagCell)
				_overBagCell = null;
		}

		private function sendData(oldStorage:int, oldSlot:int, newStorage:int, newSlot:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(oldStorage);
			byteArray.writeByte(oldSlot);
			byteArray.writeByte(newStorage);
			byteArray.writeByte(newSlot);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_MOVE_ITEM, byteArray);
		}

		public function removeEvent(eventDispatcher:EventDispatcher):void
		{
			_clickBagCell = null;
			_overBagCell = null;
			_dragBitmap = null;
			eventDispatcher.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			eventDispatcher.removeEventListener(MouseEvent.ROLL_OVER, onOver, true);
			eventDispatcher.removeEventListener(MouseEvent.ROLL_OUT, onOut, true);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			stage = null;
			_panel = null;
		}
	}
}