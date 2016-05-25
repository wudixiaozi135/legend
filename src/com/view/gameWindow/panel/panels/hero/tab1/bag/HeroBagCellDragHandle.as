package com.view.gameWindow.panel.panels.hero.tab1.bag
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
	import com.view.gameWindow.mainUi.subuis.herohead.McHeroEquipPanel;
	import com.view.gameWindow.mainUi.subuis.lasting.LastingDataMananger;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.bag.cell.BagCell;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.hero.tab1.HeroEquipTab;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipCell;
	import com.view.gameWindow.scene.GameSceneManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.SayUtil;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class HeroBagCellDragHandle
	{
		private var _panel:HeroEquipTab;
		private var _mc:McHeroEquipPanel;
		private var _clickBagCell:BagCell,_overBagCell:BagCell,_dragBitmap:Bitmap;
		
		internal function get clickBagCell():BagCell
		{
			return _clickBagCell;
		}
		/**取消一次点击UP事件的触发*/
		internal var cancelOnce:Boolean;
		
		public function HeroBagCellDragHandle(panel:HeroEquipTab)
		{
			_panel = panel;
			_mc = _panel.skin as McHeroEquipPanel;
			init();
		}
		
		private function init():void
		{
			_mc.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			_mc.addEventListener(MouseEvent.ROLL_OVER,onOver,true);
			_mc.addEventListener(MouseEvent.ROLL_OUT,onOut,true);
		}
		
		protected function onDown(event:MouseEvent):void
		{
			if(LastingDataMananger.getInstance().isRepair)return;
			if(_clickBagCell)
			{
				onUp(null);
				_panel.bagCellHandle.heroBagCellClickHandle.cancelOnce = true;
				return;
			}
			if(event.target is BagCell)
			{
				_clickBagCell = event.target as BagCell;
				if(_clickBagCell && _clickBagCell.isEmpty())
					_clickBagCell = null;
				if(_clickBagCell)
				{
					dealOnDown(_clickBagCell);
				}
			}
		}
		
		internal function dealOnDown(bagCell:BagCell):void
		{
			_clickBagCell = bagCell;
			HeroDataManager.instance.setUsedCellData(bagCell.cellId);
			_mc.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			_mc.stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		internal function onMove(event:MouseEvent):void
		{
			if(_clickBagCell)
			{
				if(!_dragBitmap)
				{
					_dragBitmap = _clickBagCell.getBitmap();
					_mc.stage.addChild(_dragBitmap);
				}
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
			if(cancelOnce)
			{
				cancelOnce = false;
				return;
			}
			if(_clickBagCell && _dragBitmap)
			{
				if(_overBagCell && !_overBagCell.isLock && _overBagCell != _clickBagCell)
				{
					sendData(ConstStorage.ST_HERO_BAG,_clickBagCell.cellId,_overBagCell.storageType,_overBagCell.cellId);
					var overBitmap:Bitmap,infos:BagData;
					HeroDataManager.instance.exchangeBagCellData(_clickBagCell.cellId,_overBagCell.cellId);//数据以交换或叠加
					infos = HeroDataManager.instance.bagCellDatas[_overBagCell.cellId];//目标格的数据
					if(infos)//目标格不为空
					{
						infos = HeroDataManager.instance.bagCellDatas[_clickBagCell.cellId];
						overBitmap = _overBagCell.getBitmap();//不论是否为同一类物品始终取出目标格的图片
						if(infos && overBitmap)//交换后点击格数据存在表示格子中为不同类物品
							_clickBagCell.setBitmap(overBitmap,infos);
					}
					_mc.stage.removeChild(_dragBitmap);
					infos = HeroDataManager.instance.bagCellDatas[_overBagCell.cellId];
					_overBagCell.setBitmap(_dragBitmap,infos);
					ToolTipManager.getInstance().attach(_overBagCell);
				}
				else
				{
					if(!onEquipUp(event) && !onRoleBagUp(event) && !onRoleEquipUp(event)/* && !onActionBarUp(event)*/)
					{
						_mc.stage.removeChild(_dragBitmap);
						infos = HeroDataManager.instance.bagCellDatas[_clickBagCell.cellId];
						_clickBagCell.setBitmap(_dragBitmap,infos);
						ToolTipManager.getInstance().attach(_clickBagCell);
						_panel.bagCellHandle.heroBagCellClickHandle.dealLitter(_clickBagCell,true);
					}
				}
			}
			_clickBagCell = null;
			_overBagCell = null;
			_dragBitmap = null;
			_mc.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			_mc.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		/**在英雄面板装备格中放开鼠标*/
		private function onEquipUp(event:MouseEvent):Boolean
		{
			if(!event)
			{
				return false;
			}
			var equipCell:EquipCell;
			equipCell = event.target as EquipCell;
			if(!equipCell || equipCell.storageType != ConstStorage.ST_HERO_EQUIP)
			{
				return false;
			}
			if(equipCell.type != ConstEquipCell.TYPE_XUNZHANG )
			{
				var usedCellData:BagData = HeroDataManager.instance.usedCellData;
				if(!usedCellData) 
				{
					return false;
				}
				var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(usedCellData.bornSid, usedCellData.id);
				if(!memEquipData) 
				{
					trace("in BagCellDragHandle.onRoleUp 不存在id"+usedCellData.id);
					return false;
				}
				var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
				if(!equipCfgData) 
				{
					trace("in BagCellDragHandle.onRoleUp 不存在id"+memEquipData.baseId);
					return false;
				}
				if(equipCfgData.entity && equipCfgData.entity != EntityTypes.ET_HERO)
				{
					trace("in BagCellDragHandle.onRoleUp 使用类型不对");
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0034);
					return false;
				}
				if(equipCfgData.type != equipCell.type)
				{
					trace("in BagCellDragHandle.onRoleUp 类型不对");
					return false;
				}
				var job:int = HeroDataManager.instance.job;
				if(equipCfgData.job && equipCfgData.job != job)
				{
					trace("in BagCellDragHandle.onRoleUp 职业不对");
					return false;
				}
				var sex:int = HeroDataManager.instance.sex;
				if(equipCfgData.sex && equipCfgData.sex != sex)
				{
					trace("in BagCellDragHandle.onRoleUp 性别不对");
					return false;
				}
				var lv:int = HeroDataManager.instance.lv;
				if(equipCfgData.level > lv)
				{
					trace("in BagCellDragHandle.onRoleUp 等级不够");
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
				_mc.stage.removeChild(_dragBitmap);
				equipCell.refreshData(usedCellData.id, usedCellData.bornSid);
				ToolTipManager.getInstance().attach(equipCell);
				sendData(ConstStorage.ST_HERO_BAG,usedCellData.slot,equipCell.storageType,equipCell.slot);
				return true;
			}
			else
			{
				_mc.stage.removeChild(_dragBitmap);
				var infos:BagData = HeroDataManager.instance.bagCellDatas[_clickBagCell.cellId];
				_clickBagCell.setBitmap(_dragBitmap,infos);
				ToolTipManager.getInstance().attach(_clickBagCell);
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.BAG_PANEL_0032);
				return true;
			}
		}
		/**在角色面板装备格中放开鼠标*/
		private function onRoleEquipUp(event:MouseEvent):Boolean
		{
			if(!event)
			{
				return false;
			}
			var equipCell:EquipCell;
			equipCell = event.target as EquipCell;
			if(!equipCell) 
			{
				return false;
			}
			if(equipCell.storageType != ConstStorage.ST_CHR_EQUIP)
			{
				return false;
			}
			var usedCellData:BagData = HeroDataManager.instance.usedCellData;
			if(!usedCellData) 
			{
				return false;
			}
			var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(usedCellData.bornSid, usedCellData.id);
			if(!memEquipData) 
			{
				trace("in BagCellDragHandle.onRoleUp 不存在id"+usedCellData.id);
				return false;
			}
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
			if(!equipCfgData) 
			{
				trace("in BagCellDragHandle.onRoleUp 不存在id"+memEquipData.baseId);
				return false;
			}
			if(equipCfgData.entity && equipCfgData.entity != EntityTypes.ET_PLAYER)
			{
				trace("in BagCellDragHandle.onRoleUp 使用类型不对");
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0033);
				return false;
			}
			if(equipCfgData.type != equipCell.type)
			{
				trace("in BagCellDragHandle.onRoleUp 类型不对");
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0012);
				return false;
			}
			var job:int = RoleDataManager.instance.job;
			if(equipCfgData.job && equipCfgData.job != job)
			{
				trace("in BagCellDragHandle.onRoleUp 职业不对");
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0013);
				return false;
			}
			var sex:int = RoleDataManager.instance.sex;
			if(equipCfgData.sex && equipCfgData.sex != sex)
			{
				trace("in BagCellDragHandle.onRoleUp 性别不对");
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0014);
				return false;
			}
			var lv:int = RoleDataManager.instance.lv;
			if(equipCfgData.level > lv)
			{
				trace("in BagCellDragHandle.onRoleUp 等级不够");
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0015);
				return false;
			}
			_mc.stage.removeChild(_dragBitmap);
			equipCell.refreshData(usedCellData.id, usedCellData.bornSid);
			ToolTipManager.getInstance().attach(equipCell);
			sendData(ConstStorage.ST_HERO_BAG,usedCellData.slot,equipCell.storageType,equipCell.slot);
			return true;
		}
		/**在背包面板物品格中放开鼠标*/
		private function onRoleBagUp(event:MouseEvent):Boolean
		{
			if(!event)
			{
				return false;
			}
			var bagCell:BagCell = event.target as BagCell;
			if(!bagCell || bagCell.storageType != ConstStorage.ST_CHR_BAG || bagCell.isLock)
			{
				return false;
			}
			var usedCellData:BagData = HeroDataManager.instance.usedCellData;
			if(!usedCellData) 
			{
				return false;
			}
			_mc.stage.removeChild(_dragBitmap);
			ToolTipManager.getInstance().attach(bagCell);
			sendData(ConstStorage.ST_HERO_BAG,usedCellData.slot,bagCell.storageType,bagCell.cellId);
			return true;
		}
		
		private function onActionBarUp(event:MouseEvent):Boolean
		{
			if(!event)
			{
				return false;
			}
			var cell:ActionBarCell;
			cell = event.target as ActionBarCell;
			if(!cell) 
			{
				return false;
			}
			var usedCellData:BagData = HeroDataManager.instance.usedCellData;
			if(!usedCellData) 
			{
				return false;
			}
			if(usedCellData.type != SlotType.IT_ITEM)
			{
				return false;
			}
			cell.refreshData(usedCellData.id,usedCellData.type);
			ToolTipManager.getInstance().attach(cell);
			sendKeyData(cell.key,cell.id);
			_mc.stage.removeChild(_dragBitmap);
			var infos:BagData = HeroDataManager.instance.bagCellDatas[_clickBagCell.cellId];
			_clickBagCell.setBitmap(_dragBitmap,infos);
			ToolTipManager.getInstance().attach(_clickBagCell);
			return true;
		}
		
		private function sendKeyData(key:int,id:int):void
		{
			ActionBarDataManager.instance.sendSetItemData(key,id);
		}
		
		protected function onOver(event:MouseEvent):void
		{
			/*trace("over");*/
			if(event.target is BagCell)
				_overBagCell = event.target as BagCell;
			/*if(_overBagCell)
			trace(_overBagCell.cellId);*/
		}
		
		protected function onOut(event:MouseEvent):void
		{
			/*trace("out");*/
			if(event.target is BagCell)
				_overBagCell = null;
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
		
		public function destroy():void
		{
			_clickBagCell = null;
			_overBagCell = null;
			_dragBitmap = null;
			_mc.removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
			_mc.removeEventListener(MouseEvent.ROLL_OVER,onOver,true);
			_mc.removeEventListener(MouseEvent.ROLL_OUT,onOut,true);
			GameSceneManager.getInstance().stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			GameSceneManager.getInstance().stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			_mc = null;
			_panel = null;
		}
	}
}