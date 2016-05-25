package com.view.gameWindow.panel.panels.hero.tab1.bag
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.ItemTypeCfgData;
	import com.model.consts.ConstStorage;
	import com.model.consts.ItemType;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.mainUi.subuis.chatframe.msg.LinkWord;
	import com.view.gameWindow.mainUi.subuis.herohead.McHeroEquipPanel;
	import com.view.gameWindow.mainUi.subuis.lasting.LastingDataMananger;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelBase;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.bag.cell.BagCell;
	import com.view.gameWindow.panel.panels.bag.menu.ConstBagCellMenu;
	import com.view.gameWindow.panel.panels.batchUse.PanelBatchUseData;
	import com.view.gameWindow.panel.panels.closet.ClosetDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.UICenter;
	import com.view.gameWindow.panel.panels.guideSystem.action.OpenPanelAction;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.hero.tab1.HeroEquipTab;
	import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
	import com.view.gameWindow.panel.panels.skill.SkillDataManager;
	import com.view.gameWindow.panel.panels.split.PanelSplitData;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.SayUtil;
	import com.view.gameWindow.util.UtilGetCfgData;
	import com.view.newMir.NewMirMediator;
	
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.utils.StringUtil;

	/**
	 * 背包单元格点击处理类
	 * @author Administrator
	 */	
	public class HeroBagCellClickHandle
	{
		private var _panel:HeroEquipTab;
		private var _mc:McHeroEquipPanel;
		/**点击的单元格<br>在双击或点击后置空，除了单击弹出菜单情况，该情况在菜单执行具体操作或关闭时置空*/
		private var _bagCell:BagCell;
		private var _timerId:int;
		/**取消一次点击UP事件的触发*/
		internal var cancelOnce:Boolean;

		public function HeroBagCellClickHandle(panel:HeroEquipTab)
		{
			if(panel)
			{
				_panel = panel;
				_mc = _panel.skin as McHeroEquipPanel;
				init();
			}
		}
		
		private function init():void
		{
			_mc.addEventListener(MouseEvent.MOUSE_UP,onUp);
			_mc.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			_mc.doubleClickEnabled = true;
			_mc.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick);
		}
		
		protected function onDoubleClick(event:MouseEvent):void
		{
			_bagCell = event.target as BagCell;
			if(!_bagCell || _bagCell.isLock || _bagCell.isEmpty())
			{
				return;
			}
			clearTimeout(_timerId);
			dealUseWear();
			_bagCell = null;
		}
		
		public function dealUseWear(data:BagData = null,showTip:Boolean = true):Boolean
		{
			if(!_bagCell && !data)
			{
				return false;
			}
			
			var bagData:BagData = data ? data : _bagCell.bagData;
			
			if(bagData.type == SlotType.IT_ITEM)
			{
				var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
				if (firstPlayer.isPalsy)
				{
					return false;
				}
				var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(bagData.id);
				if(!itemCfgData)
				{
					return false;
				}
				var job:int = HeroDataManager.instance.job;
				if(itemCfgData.job && itemCfgData.job != job)
				{
					if(showTip)
					{
						trace("in HeroBagCellClickHandle.dealUseWear 职业不对");
						RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0013);
					}
					return false;
				}
				var sex:int = HeroDataManager.instance.sex;
				if(itemCfgData.entity && itemCfgData.entity != EntityTypes.ET_HERO)
				{
					if(showTip)
					{
						trace("in HeroBagCellClickHandle.dealUseWear 使用者不对");
						var replace:String = StringConst.BAG_PANEL_0016.replace("&x",StringConst.BAG_PANEL_0017).replace("&y",itemCfgData.name);
						RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,replace);
					}
					return false;
				}
				var lv:int = HeroDataManager.instance.lv;
				if(itemCfgData.level > lv)
				{
					if(showTip)
					{
						trace("in HeroBagCellClickHandle.dealUseWear 等级不够");
						RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0015);
					}
					return false;
				}
				if(itemCfgData.type==ItemType.IT_BATTLE_YOU)
				{
					if(LastingDataMananger.getInstance().heroLasting==false)
					{
						if(showTip)
						{
							Alert.warning(StringConst.BAG_PANEL_0040);
						}
						return false;
					}
				}
				
				if(itemCfgData.type == ItemType.SKILL_BOOK || itemCfgData.type == ItemType.HERO_SKILL_BOOK)
				{
					SkillDataManager.instance.useSkillBook(bagData.id,bagData.slot);
					return true;
				}
				else
				{
					var itemTypeCfgData:ItemTypeCfgData = ConfigDataManager.instance.itemTypeCfgData(itemCfgData.type);
					if(itemTypeCfgData && itemTypeCfgData.canBatch && bagData.count > 1)
					{
						dealBatch();
						return true;
					}
//					if(itemTypeCfgData.panel)
//					{
//						return;
//					}
					if(itemTypeCfgData.batch == ItemTypeCfgData.CantUse)
					{
						if(itemTypeCfgData.panel>0)
						{
							new OpenPanelAction(UICenter.getUINameFromMenu(itemTypeCfgData.panel+""),itemTypeCfgData.panel_param-1).act();
						}else
						{
							if(showTip)
							{
								RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.BAG_PANEL_0026);
							}
						}
						
						return false;
					}
					sendUseData(bagData);
					return true;
				}
			}
			else if(bagData.type == SlotType.IT_EQUIP)
			{
				if(LastingDataMananger.getInstance().isRepair)
				{
					return false;
				}
				var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(bagData.bornSid,bagData.id);
				var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
				var type:int = equipCfgData.type;
				if(type == ConstEquipCell.TYPE_XUNZHANG)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.BAG_PANEL_0032);
					return false;  //目前只有幻戒和勋章不可以手动替换
				}
				if(equipCfgData.entity && equipCfgData.entity != EntityTypes.ET_HERO)
				{
					trace("in BagCellDragHandle.onRoleUp 使用类型不对");
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0034);
					return false;
				}
				job = HeroDataManager.instance.job;
				if(equipCfgData.job && equipCfgData.job != job)
				{
					trace("in HeroBagCellClickHandle.dealUseWear 职业不对");
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0013);
					return false;
				}
				sex = HeroDataManager.instance.sex;
				if(equipCfgData.sex && equipCfgData.sex != sex)
				{
					trace("in HeroBagCellClickHandle.dealUseWear 性别不对");
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0014);
					return false;
				}
				lv = HeroDataManager.instance.lv;
				if(equipCfgData.level > lv)
				{
					trace("in HeroBagCellClickHandle.dealUseWear 等级不够");
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0015);
					return false;
				}
				if(BagDataManager.instance.isBagHeroFightPowerHigher(bagData))
				{
//					var myHero:IHero = EntityLayerManager.getInstance().myHero;
//					if(myHero)
//					{
//						var randomIndex:int= Math.random()*StringConst.HERO_SAY_0001.length;
//						myHero.say(StringConst.HERO_SAY_0001[randomIndex]);
//					}
					SayUtil.heroSayEquip();
				}
				var shizhuang:int = ConstEquipCell.TYPE_SHIZHUANG;
				var chibang:int = ConstEquipCell.TYPE_CHIBANG;
				var zuji:int = ConstEquipCell.TYPE_ZUJI;
				var huanwu:int = ConstEquipCell.TYPE_HUANWU;
				var douli:int = ConstEquipCell.TYPE_DOULI;
				if(type == shizhuang || type == chibang || type == zuji || type == douli || type == huanwu)
				{
					/*ClosetDataManager.instance.request();
					ClosetPutInData.selectCellId = _bagCell.cellId;
					PanelMediator.instance.switchPanel(PanelConst.TYPE_CLOSET_PUT_IN);*/
				}
				else if(type==ConstEquipCell.TYPE_HERO_SHIZHUANG)
				{
					ClosetDataManager.instance.requestHero(bagData.storageType,bagData.slot);
				}
				else
				{
					var slot:int = ConstEquipCell.getHeroEquipSlot(equipCfgData.type);
					sendMoveData(bagData.storageType,bagData.slot,ConstStorage.ST_HERO_EQUIP,slot);
				}
				
				return true;
			}
			
			return false;
		}
		
		private function sendUseData(bagData:BagData):void
		{
			BagDataManager.instance.sendUseData(bagData.slot,ConstStorage.ST_HERO_BAG);
		}
		
		private function sendMoveData(oldStorage:int,oldSlot:int,newStorage:int,newSlot:int):void
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
			_bagCell = event.target as BagCell;
			if(!_bagCell || _bagCell.isLock || _bagCell.isEmpty())
			{
				return;
			}
			
			if(LastingDataMananger.getInstance().isRepair)
			{
				LastingDataMananger.getInstance().repairBagEquip(_bagCell);
				return;
			}
		}
		
		protected function onUp(event:MouseEvent):void
		{
			if(cancelOnce)
			{
				cancelOnce = false;
				return;
			}
			_bagCell = event.target as BagCell;
			if(_bagCell && _bagCell.isLock)
			{
				if(_bagCell.cellId > 11 && _bagCell.cellId <= 17)
				{
					Alert.warning(StringUtil.substitute(StringConst.HERO_PANEL_65,"65"));
				}
				else if(_bagCell.cellId > 17 && _bagCell.cellId <= 23)
				{
					Alert.warning(StringUtil.substitute(StringConst.HERO_PANEL_65,"70"));
				}
				else if(_bagCell.cellId > 23 && _bagCell.cellId <= 29)
				{
					Alert.warning(StringUtil.substitute(StringConst.HERO_PANEL_65,"75"));
				}
				return;
			}
			if(!_bagCell || _bagCell.isEmpty())
			{
				return;
			}
			//
			if(event.shiftKey)
			{
				dealShow();
				_bagCell = null;
				return;
			}
			
			if(event.ctrlKey)
			{
				dealSplit();
				_bagCell=null;
				return;
			}
			
			var isExchange:Boolean = HeroDataManager.instance.isExchange;
			if(isExchange)
			{
				var cellId:int = BagDataManager.instance.getFirstEmptyCellId();
				if(cellId == -1)
				{
					return;
				}
				sendMoveData(_bagCell.storageType,_bagCell.cellId,ConstStorage.ST_CHR_BAG,cellId);
				_bagCell = null;
				return;
			}
//			if(_bagCell.type == SlotType.IT_EQUIP && _panel.bagCellHandle.heroBagCellDragHandle.clickBagCell == _bagCell)
//			{
//				dealMove();
//				_panel.bagCellHandle.heroBagCellDragHandle.cancelOnce = true;
//				_bagCell = null;
//				return;
//			}
//			//弹出选择框
//			dealShowMenu();
		}
		
		private function dealShow():void
		{
			if(!_bagCell)
			{
				return;
			}
			NewMirMediator.getInstance().gameWindow.mainUiMediator.chatFrame.input.setFocus();
			
			var bagData:Object = _bagCell.getTipData();
			if(bagData is MemEquipData)
			{
				var equipData:MemEquipData = MemEquipData(bagData);
				var equipCfg:EquipCfgData = ConfigDataManager.instance.equipCfgData(bagData.baseId);
				NewMirMediator.getInstance().gameWindow.mainUiMediator.chatFrame.input.appendItem(LinkWord.joinData(equipData.bornSid,equipData.onlyId),LinkWord.TYPE_EQUIP);
			}
			else if(bagData is BagData)
			{
				NewMirMediator.getInstance().gameWindow.mainUiMediator.chatFrame.input.appendItem(LinkWord.joinData(BagData(bagData).id,BagData(bagData).bind),LinkWord.TYPE_ITEM);
			}
		}
		
		private function dealShowMenu():void
		{
			_timerId = setTimeout(function ():void
			{
				clearTimeout(_timerId);
				if(!_bagCell)
				{
					return;
				}
				var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(_bagCell.id);
				if(!itemCfgData)
				{
					return;
				}
				var list:Vector.<int> = new Vector.<int>();
				list.push(ConstBagCellMenu.TYPE_USE);
				var itemTypeCfgData:ItemTypeCfgData = ConfigDataManager.instance.itemTypeCfgData(itemCfgData.type);
				if(itemTypeCfgData && itemTypeCfgData.canBatch)
				{
					list.push(ConstBagCellMenu.TYPE_BATCH);
				}
				list.push(ConstBagCellMenu.TYPE_MOVE);
				if(_bagCell.bagData && _bagCell.bagData.count > 1)
				{
					list.push(ConstBagCellMenu.TYPE_SPLIT);
				}
				list.push(ConstBagCellMenu.TYPE_SHOW);
				list.push(ConstBagCellMenu.TYPE_LITTER);
//				BagCellMenuDataManager.instance.list = list;
				PanelMediator.instance.openPanel(PanelConst.TYPE_BAGCELL_MENU);
			},300);
		}
		
		public function dealNotify(proc:int):void
		{
			switch(proc)
			{
				default:
					break;
				case ConstBagCellMenu.TYPE_USE:
					dealUseWear();
					break;
				case ConstBagCellMenu.TYPE_WEAR:
					dealUseWear();
					break;
				case ConstBagCellMenu.TYPE_BATCH:
					dealBatch();
					break;
				case ConstBagCellMenu.TYPE_MOVE:
					dealMove();
					break;
				case ConstBagCellMenu.TYPE_SPLIT:
					dealSplit();
					break;
				case ConstBagCellMenu.TYPE_SHOW:
					dealShow();
					break;
				case ConstBagCellMenu.TYPE_LITTER:
					dealLitter(_bagCell);
					break;
			}
			_bagCell = null;
		}
		/**处理批量*/
		private function dealBatch():void
		{
			if(!_bagCell)
			{
				return;
			}
			PanelBatchUseData.id = _bagCell.id;
			PanelBatchUseData.type = _bagCell.type;
			PanelBatchUseData.storage = _bagCell.storageType;
			PanelBatchUseData.slot = _bagCell.cellId;
			PanelMediator.instance.openPanel(PanelConst.TYPE_BATCH);
		}
		/**处理移动*/
		private function dealMove():void
		{
			if(!_bagCell)
			{
				return;
			}
			//
			_panel.bagCellHandle.heroBagCellDragHandle.dealOnDown(_bagCell);
			_panel.bagCellHandle.heroBagCellDragHandle.onMove(null);
		}
		/**处理拆分*/
		private function dealSplit():void
		{
			if(!_bagCell||_bagCell.bagData.count<2)
			{
				return;
			}
			PanelSplitData.id = _bagCell.id;
			PanelSplitData.type = _bagCell.type;
			PanelSplitData.cout = _bagCell.bagData.count;
			PanelSplitData.storage = _bagCell.storageType;
			PanelSplitData.slot = _bagCell.cellId;
			PanelMediator.instance.openPanel(PanelConst.TYPE_SPLIT);
		}
		/**处理丢弃*/
		internal function dealLitter(bagCell:BagCell,isDrag:Boolean = false):void
		{
			if(!bagCell)
			{
				return;
			}
			var panelHero:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_HERO);
			if(isDrag && panelHero && panelHero.isMouseOn())
			{
				return;
			}
			var panelBag:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_BAG);
			if(panelBag && panelBag.isMouseOn())
			{
				return;
			}
			var panelRole:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_ROLE_PROPERTY);
			if(panelRole && panelRole.isMouseOn())
			{
				return;
			}
			var bagData:BagData = bagCell.bagData;
			var bind:int = bagData.bind;
			var type:int = bagData.type;
			var utilGetCfgData:UtilGetCfgData = new UtilGetCfgData();
			var cfgData:Object = type == SlotType.IT_EQUIP ? utilGetCfgData.GetEquipCfgData(bagData.id,bagData.bornSid) : utilGetCfgData.GetItemCfgData(bagData.id);
			if(!cfgData)
			{
				trace("HeroBagCellClickHandle.dealLitter 配置信息不存在");
				return;
			}
			if(!cfgData.hasOwnProperty("can_sell"))
			{
				trace("HeroBagCellClickHandle.dealLitter 配置信息中所取的变量不存在");
				return;
			}
			if(type==SlotType.IT_EQUIP)
			{
				if(cfgData.type==ConstEquipCell.TYPE_HUOLONGZHIXIN||cfgData.type==ConstEquipCell.TYPE_XUNZHANG
					||cfgData.type==ConstEquipCell.TYPE_DUNPAI||cfgData.type==ConstEquipCell.TYPE_HUANJIE)
					return;
			}
			
			var can_sell:int = cfgData.can_sell;
			if(bind && !can_sell)//绑定且不能出售，销毁道具
			{
				dealDestory(bagCell);
			}
			else if(bind && can_sell)//绑定且可出售，出售道具
			{
				dealSell(bagCell);
			}
			else//不绑定，丢弃道具
			{
				dealTrueLitter(bagCell);
			}
		}
		
		private function dealDestory(bagCell:BagCell):void
		{
			Alert.show2(StringConst.BAG_PANEL_0020,function (bagCell:BagCell):void
			{
				var byteArray:ByteArray = new ByteArray();
				byteArray.endian = Endian.LITTLE_ENDIAN;
				byteArray.writeByte(bagCell.storageType);
				byteArray.writeByte(bagCell.cellId);
				ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DESTORY_ITEM,byteArray);
			},bagCell,StringConst.BAG_PANEL_0021);
		}
		
		private function dealSell(bagCell:BagCell):void
		{
			Alert.show2(StringConst.BAG_PANEL_0043,function (bagCell:BagCell):void
			{
				BagDataManager.instance.sendSellDatas(Vector.<BagData>([bagCell.bagData]));
			},bagCell,StringConst.BAG_PANEL_0044);
		}
		
		private function dealTrueLitter(bagCell:BagCell):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(bagCell.storageType);
			byteArray.writeByte(bagCell.cellId);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DROP_ITEM,byteArray);
		}
		public function destory():void
		{
			clearTimeout(_timerId);
			_bagCell = null;
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.MOUSE_UP,onUp);
				_mc.removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
				_mc.removeEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick);
			}
			_mc = null;
			_panel = null;
		}
	}
}