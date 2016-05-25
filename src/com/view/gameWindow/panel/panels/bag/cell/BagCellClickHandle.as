package com.view.gameWindow.panel.panels.bag.cell
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
    import com.view.gameWindow.mainUi.subuis.lasting.LastingDataMananger;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.IPanelBase;
    import com.view.gameWindow.panel.panels.bag.BagData;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.bag.BagPanel;
    import com.view.gameWindow.panel.panels.bag.McBag;
    import com.view.gameWindow.panel.panels.bag.menu.BagCellMenuDataManager;
    import com.view.gameWindow.panel.panels.bag.menu.ConstBagCellMenu;
    import com.view.gameWindow.panel.panels.batchUse.PanelBatchUseData;
    import com.view.gameWindow.panel.panels.chests.PanelChests;
    import com.view.gameWindow.panel.panels.closet.ClosetDataManager;
    import com.view.gameWindow.panel.panels.expStone.ExpStoneDataManager;
    import com.view.gameWindow.panel.panels.expStone.ExpStonePanel;
    import com.view.gameWindow.panel.panels.guideSystem.UICenter;
    import com.view.gameWindow.panel.panels.guideSystem.action.OpenPanelAction;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    import com.view.gameWindow.panel.panels.mall.coupon.CouponDataManager;
    import com.view.gameWindow.panel.panels.prompt.Panel1BtnPromptData;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
    import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
    import com.view.gameWindow.panel.panels.skill.SkillDataManager;
    import com.view.gameWindow.panel.panels.split.PanelSplitData;
    import com.view.gameWindow.panel.panels.stall.StallDataManager;
    import com.view.gameWindow.panel.panels.storage.StorageDataMannager;
    import com.view.gameWindow.panel.panels.vip.VipDataManager;
    import com.view.gameWindow.scene.entity.EntityLayerManager;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
    import com.view.gameWindow.scene.entity.entityItem.interf.IUnit;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
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
	public class BagCellClickHandle
	{
		public function BagCellClickHandle(panel:BagPanel)
		{
			_panel = panel;
			_mc = _panel.skin as McBag;
			_mc.addEventListener(MouseEvent.MOUSE_UP, onUp);
			_mc.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_mc.doubleClickEnabled = true;
			_mc.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			_mc.addEventListener(MouseEvent.CLICK, onClickFunc);
		}

		/**取消一次点击UP事件的触发*/
		internal var cancelOnce:Boolean;
		private var _panel:BagPanel;
		private var _mc:McBag;
		/**点击的单元格<br>在双击或点击后置空，除了单击弹出菜单情况，该情况在菜单执行具体操作或关闭时置空*/
		private var _bagCell:BagCell;
		private var _timerId:int;

		public function dealNotify(proc:int):void
		{
			switch (proc)
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

		public function destory():void
		{
			clearTimeout(_timerId);
			_bagCell = null;
			if (_mc)
			{
				_mc.removeEventListener(MouseEvent.MOUSE_UP, onUp);
				_mc.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
				_mc.removeEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
				_mc.removeEventListener(MouseEvent.CLICK, onClickFunc);
			}
			_mc = null;
			_panel = null;
		}

		/**处理丢弃*/
		internal function dealLitter(bagCell:BagCell, isDrag:Boolean = false):void
		{
			if (!bagCell)
			{
				return;
			}
			if (isDrag && _panel.isMouseOn())
			{
				return;
			}
			var panelHero:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_HERO);
			if (panelHero && panelHero.isMouseOn())
			{
				return;
			}
			var panelRole:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_ROLE_PROPERTY);
			if (panelRole && panelRole.isMouseOn())
			{
				return;
			}

			var panelTrade:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_TRADE);
			if (panelTrade && panelTrade.isMouseOn())
			{
				return;
			}

			var panelStall:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_STALL_PANEL);
			if (panelStall && panelStall.isMouseOn())
			{
				return;
			}
			if (panelStall && RoleDataManager.instance.stallStatue)
			{
				return;
			}
			var panelOtherStall:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_STALL_OTHER);
			if (panelOtherStall && panelOtherStall.isMouseOn())
			{
				return;
			}
			if (StallDataManager.instance.checkLimit)
			{
				return;
			}
			var bagData:BagData = bagCell.bagData;
			var bind:int = bagData.bind;
			var type:int = bagData.type;
			var utilGetCfgData:UtilGetCfgData = new UtilGetCfgData();
			var cfgData:Object = type == SlotType.IT_EQUIP ? utilGetCfgData.GetEquipCfgData(bagData.id, bagData.bornSid) : utilGetCfgData.GetItemCfgData(bagData.id);
			if (!cfgData)
			{
				trace("BagCellClickHandle.dealLitter 配置信息不存在");
				return;
			}
			if (!cfgData.hasOwnProperty("can_sell"))
			{
				trace("BagCellClickHandle.dealLitter 配置信息中所取的变量不存在");
				return;
			}
			var can_sell:int = cfgData.can_sell;
			if(type==SlotType.IT_EQUIP)
			{
				if(cfgData.type==ConstEquipCell.TYPE_HUOLONGZHIXIN||cfgData.type==ConstEquipCell.TYPE_XUNZHANG
					||cfgData.type==ConstEquipCell.TYPE_DUNPAI||cfgData.type==ConstEquipCell.TYPE_HUANJIE)
					return;
			}
			if (bind && !can_sell)//绑定且不能出售，销毁道具
			{
				dealDestory(bagCell);
			}
			else if (bind && can_sell)//绑定且可出售，出售道具
			{
				dealSell(bagCell);
			}
			else//不绑定，丢弃道具
			{
				dealTrueLitter(bagCell);
			}
		}

		private function openLockFunc():void
		{
			Panel1BtnPromptData.strName = StringConst.BAG_PANEL_OPEN_CELL_0001;
			Panel1BtnPromptData.strContent = StringConst.BAG_PANEL_OPEN_CELL_0002;
			Panel1BtnPromptData.strBtn = StringConst.BAG_PANEL_OPEN_CELL_0003;
			Panel1BtnPromptData.funcBtn = function ():void
			{
				PanelMediator.instance.switchPanel(PanelConst.TYPE_VIP);
			};
			PanelMediator.instance.switchPanel(PanelConst.TYPE_1BTN_PROMPT);
		}

		private function dealUseWear():void
		{
			if (!_bagCell)
			{
				return;
			}
			if (_bagCell.type == SlotType.IT_ITEM)
			{
				var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
				if (firstPlayer.isPalsy && _bagCell.storageType == ConstStorage.ST_CHR_BAG)
				{
					return;
				}
				var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(_bagCell.id);
				if (!itemCfgData)
				{
					return;
				}
				
				if(itemCfgData.type == ItemType.IT_GIFT_FAMILY && SchoolDataManager.getInstance().schoolBaseData.schoolId == 0)
				{
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0041);
					return;
				}
				
				var job:int = RoleDataManager.instance.job;
				if (itemCfgData.job && itemCfgData.job != job)
				{
					trace("in BagCellClickHandle.dealUseWear 职业不对");
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0013);
					return;
				}
				var sex:int = RoleDataManager.instance.sex;
				if (itemCfgData.entity && itemCfgData.entity != EntityTypes.ET_PLAYER)
				{
					trace("in BagCellClickHandle.dealUseWear 使用者不对");
					var replace:String = StringConst.BAG_PANEL_0016.replace("&x", StringConst.BAG_PANEL_0017).replace("&y", itemCfgData.name);
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, replace);
					return;
				}
				var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(itemCfgData.reincarn,itemCfgData.level);
				if (!checkReincarnLevel)
				{
					trace("in BagCellClickHandle.dealUseWear 等级不够");
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0015);
					return;
				}
				if(itemCfgData.type==ItemType.IT_BATTLE_YOU)
				{
					if(LastingDataMananger.getInstance().roleLasting==false)
					{
						Alert.warning(StringConst.BAG_PANEL_0040);
						return ;
					}
				}
				if (itemCfgData.type == ItemType.SKILL_BOOK || itemCfgData.type == ItemType.HERO_SKILL_BOOK)
				{
					SkillDataManager.instance.useSkillBook(_bagCell.id, _bagCell.cellId);
				}
				else if (itemCfgData.type == ItemType.EXP_STONE||itemCfgData.type==ItemType.EXP_STONE_A)
				{
                    ExpStoneDataManager.bagCell = _bagCell;
					ExpStonePanel.show(_bagCell.storageType, _bagCell.cellId);
				}
//				else if (itemCfgData.type == ItemType.IT_BATTLE_YOU)
//				{
//					ExpStonePanel.show(_bagCell.storageType, _bagCell.cellId);
//				}
				else if (itemCfgData.type == ItemType.CHESTS)
				{
					PanelChests.show(itemCfgData);
				}
				else if (itemCfgData.type == ItemType.IT_COUPON)//优惠券type
				{
					CouponDataManager.itemCfg = null;
					CouponDataManager.itemCfg = itemCfgData;
					CouponDataManager.bagData = null;
					CouponDataManager.bagData = _bagCell.bagData;
					PanelMediator.instance.openPanel(PanelConst.TYPE_MALL_COUPON);
				}
				else
				{
					var itemTypeCfgData:ItemTypeCfgData = ConfigDataManager.instance.itemTypeCfgData(itemCfgData.type);
					if (itemTypeCfgData && itemTypeCfgData.canBatch && _bagCell.bagData.count > 1)
					{
						dealBatch();
						return;
					}
					if (itemTypeCfgData && itemTypeCfgData.batch == ItemTypeCfgData.CantUse)
					{
						if(itemTypeCfgData.panel>0)
						{
							new OpenPanelAction(UICenter.getUINameFromMenu(itemTypeCfgData.panel+""),itemTypeCfgData.panel_param-1).act();
						}
						else
						{
							RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.BAG_PANEL_0026);
						}
						return;
					}
					var str:String = ItemType.itemTypeName(itemCfgData.type);
					if (str != "")
					{
						if (itemCfgData.type == ItemType.IT_ENERGY || itemCfgData.type == ItemType.IT_ENERGY2)
						{
							str = str.replace("xx", itemCfgData.effect).replace("xx", itemCfgData.effect);
						}
						else
						{
							str = str + itemCfgData.effect;
						}
						RollTipMediator.instance.showRollTip(RollTipType.REWARD, str);
					}
					/**public static const INTERVAL_HP_DRUG:int = 321;
					 public static const INTERVAL_MP_DRUG:int = 322;
					 public static const NSTANTANEOUS_HP_DRUG:int = 323;
					 public static const NSTANTANEOUS_MP_DRUG:int = 324;
					 public static const NSTANTANEOUS_HP_AND_MP_DRUG:int = 325;**/
					if (itemCfgData.type == ItemType.INTERVAL_HP_DRUG || itemCfgData.type == 322 || itemCfgData.type == 323 || itemCfgData.type == 324 || itemCfgData.type == 325)
					{
						var r:int = int(Math.random() * 10);
						if (r == 3)
						{
							var unit:IUnit = EntityLayerManager.getInstance().firstPlayer;
							unit && unit.say(StringConst.HERO_SAY_0002);
						}
					}

                    if (itemCfgData.type == ItemType.IT_GIFT_NEED_COST)//付费礼包
                    {
                        var roleGoldCount:int = BagDataManager.instance.goldUnBind;
                        var temp:BagCell = _bagCell;//_bagCell会置空
                        Alert.show2(StringUtil.substitute(StringConst.FIRST_CHARGE_TIP_001, itemCfgData.effect), function ():void
                        {
                            if (roleGoldCount < int(itemCfgData.effect))
                            {
                                RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.RESOURCE_LACK_1);
                                return;
                            }
                            sendUseData(temp);
                            temp = null;
                        });
                        return;
                    }
					if (itemCfgData.type == ItemType.IT_GIFT_NEED_VIP)
                    {
                        if (VipDataManager.instance.lv < int(itemCfgData.effect))
                        {
                            RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringUtil.substitute(StringConst.RESOURCE_LACK_5, itemCfgData.effect));
                            return;
                        }
                    }
					sendUseData(_bagCell);
				}
			}
			else if (_bagCell.type == SlotType.IT_EQUIP)
			{
				if (LastingDataMananger.getInstance().isRepair)
				{
					return;
				}
				var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(_bagCell.bornSid, _bagCell.id);
				var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
				if (equipCfgData.entity && equipCfgData.entity != EntityTypes.ET_PLAYER)
				{
					trace("in BagCellDragHandle.onRoleUp 使用类型不对");
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0033);
					return;
				}
				job = RoleDataManager.instance.job;
				if (equipCfgData.job && equipCfgData.job != job)
				{
					trace("in BagCellClickHandle.dealUseWear 职业不对");
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0013);
					return;
				}
				sex = RoleDataManager.instance.sex;
				if (equipCfgData.sex && equipCfgData.sex != sex)
				{
					trace("in BagCellClickHandle.dealUseWear 性别不对");
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0014);
					return;
				}
				checkReincarnLevel = RoleDataManager.instance.checkReincarnLevel(equipCfgData.reincarn, equipCfgData.level);
				if (!checkReincarnLevel)
				{
					trace("in BagCellClickHandle.dealUseWear 等级不够");
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0015);
					return;
				}
				var type:int = equipCfgData.type;
				var shizhuang:int = ConstEquipCell.TYPE_SHIZHUANG;
				var chibang:int = ConstEquipCell.TYPE_CHIBANG;
				var zuji:int = ConstEquipCell.TYPE_ZUJI;
				var douli:int = ConstEquipCell.TYPE_DOULI;
				var huanwu:int = ConstEquipCell.TYPE_HUANWU;
                if (type == shizhuang || type == zuji || type == douli || type == huanwu)
				{
					ClosetDataManager.instance.request(type, _bagCell.cellId);
					PanelMediator.instance.openPanel(PanelConst.TYPE_CLOSET);
				}else if(type==ConstEquipCell.TYPE_HERO_SHIZHUANG)
				{
					ClosetDataManager.instance.requestHero(_bagCell.storageType,_bagCell.bagData.slot);
				}
				else
				{
					var slot:int = ConstEquipCell.getRoleEquipSlot(equipCfgData.type);
					sendMoveData(_bagCell.storageType, _bagCell.cellId, ConstStorage.ST_CHR_EQUIP, slot);
				}
			}
		}

		private function sendUseData(bagCell:BagCell):void
		{
			BagDataManager.instance.sendUseData(bagCell.cellId);
		}

		private function sendMoveData(oldStorage:int, oldSlot:int, newStorage:int, newSlot:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(oldStorage);
			byteArray.writeByte(oldSlot);
			byteArray.writeByte(newStorage);
			byteArray.writeByte(newSlot);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_MOVE_ITEM, byteArray);
		}

		private function dealShow():void
		{
			if (!_bagCell)
			{
				return;
			}
			NewMirMediator.getInstance().gameWindow.mainUiMediator.chatFrame.input.setFocus();

			var bagData:Object = _bagCell.getTipData();
			if (bagData is MemEquipData)
			{
				var equipData:MemEquipData = MemEquipData(bagData);
				var equipCfg:EquipCfgData = ConfigDataManager.instance.equipCfgData(bagData.baseId);
				NewMirMediator.getInstance().gameWindow.mainUiMediator.chatFrame.input.appendItem(LinkWord.joinData(equipData.bornSid, equipData.onlyId), LinkWord.TYPE_EQUIP);
			}
			else if (bagData is BagData)
			{
				NewMirMediator.getInstance().gameWindow.mainUiMediator.chatFrame.input.appendItem(LinkWord.joinData(BagData(bagData).id, BagData(bagData).bind), LinkWord.TYPE_ITEM);
			}
		}

		private function dealShowMenu():void
		{
			_timerId = setTimeout(function ():void
			{
				clearTimeout(_timerId);
				if (!_bagCell)
				{
					return;
				}
				var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(_bagCell.id);
				if (!itemCfgData)
				{
					return;
				}
				var itemTypeCfgData:ItemTypeCfgData = ConfigDataManager.instance.itemTypeCfgData(itemCfgData.type);
				var list:Vector.<int> = new Vector.<int>();
				list.push(ConstBagCellMenu.TYPE_USE);
				if (itemTypeCfgData.canBatch)
				{
					list.push(ConstBagCellMenu.TYPE_BATCH);
				}
				list.push(ConstBagCellMenu.TYPE_MOVE);
				if (_bagCell.bagData.count > 1)
				{
					list.push(ConstBagCellMenu.TYPE_SPLIT);
				}
				list.push(ConstBagCellMenu.TYPE_SHOW);
				list.push(ConstBagCellMenu.TYPE_LITTER);
				BagCellMenuDataManager.instance.list = list;
				PanelMediator.instance.openPanel(PanelConst.TYPE_BAGCELL_MENU);
			}, 300, _timerId);
		}

		/**处理批量*/
		private function dealBatch():void
		{
			if (!_bagCell)
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
			if (!_bagCell)
			{
				return;
			}
			//
			_panel.bagCellDragHander.dealOnDown(_bagCell);
			_panel.bagCellDragHander.onMove(null);
		}

		/**处理拆分*/
		private function dealSplit():void
		{
			if (!_bagCell||_bagCell.bagData.count<2)
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

		private function dealDestory(bagCell:BagCell):void
		{
			Alert.show2(StringConst.BAG_PANEL_0020,function (bagCell:BagCell):void
			{
				var byteArray:ByteArray = new ByteArray();
				byteArray.endian = Endian.LITTLE_ENDIAN;
				byteArray.writeByte(bagCell.storageType);
				byteArray.writeByte(bagCell.cellId);
				ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DESTORY_ITEM, byteArray);
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
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DROP_ITEM, byteArray);
		}

		protected function onDoubleClick(event:MouseEvent):void
		{
			_bagCell = event.target as BagCell;
			if (!_bagCell || _bagCell.isLock || _bagCell.isEmpty())
			{
				return;
			}

			clearTimeout(_timerId);

			var panel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_STORAGE);
			if (!panel)
			{
				dealUseWear();
			}
			else
			{
				var storageId:int = ConstStorage.ST_STORAGE[StorageDataMannager.instance.storageId];
				StorageDataMannager.instance.moveStorageItem(ConstStorage.ST_CHR_BAG, _bagCell.bagData.slot, storageId);
			}
			_bagCell = null;
		}

		protected function onUp(event:MouseEvent):void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			/*trace("BagCellClickHandle.onUp");*/
			if (cancelOnce)
			{
				cancelOnce = false;
				return;
			}
			_bagCell = event.target as BagCell;
			if (!_bagCell || _bagCell.isLock || _bagCell.isEmpty())
			{
				return;
			}
			//
			if (event.shiftKey)
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
			if (isExchange)
			{
				var cellId:int = HeroDataManager.instance.getFirstEmptyCellId();
				if (cellId == -1)
				{
					return;
				}
				sendMoveData(_bagCell.storageType, _bagCell.cellId, ConstStorage.ST_HERO_BAG, cellId);
				_bagCell = null;

            }
//			if (_bagCell.type == SlotType.IT_EQUIP && _panel.bagCellDragHander.clickBagCell == _bagCell)
//			{
//				dealMove();
//				_panel.bagCellDragHander.cancelOnce = true;
//				_bagCell = null;
//				return;
//			}
			//弹出选择框
//			dealShowMenu();
		}

		private function onClickFunc(event:MouseEvent):void
		{
			_bagCell = event.target as BagCell;
			if (!_bagCell)
			{
				return;
			}

			if (_bagCell.isLock)
			{
				openLockFunc();

			}
		}

		private function onDown(event:MouseEvent):void
		{
			_bagCell = event.target as BagCell;
			if (!_bagCell)
			{
				return;
			}

			if (_bagCell.isLock)
			{
				return;
			}

			if (_bagCell.type == SlotType.IT_EQUIP)
			{
				if (LastingDataMananger.getInstance().isRepair)
				{
					LastingDataMananger.getInstance().repairBagEquip(_bagCell);
				}
			}
		}
	}
}