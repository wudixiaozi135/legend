package com.view.gameWindow.panel.panels.dragonTreasure.treasureShop.tab
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.TreasureShopCfgData;
    import com.model.consts.ItemType;
    import com.model.consts.SlotType;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.panel.panels.dragonTreasure.DragonTreasureManager;
    import com.view.gameWindow.panel.panels.dragonTreasure.treasureShop.McTreasureItem;
    import com.view.gameWindow.panel.panels.dragonTreasure.treasureShop.TreasureShopManager;
    import com.view.gameWindow.panel.panels.dragonTreasure.treasureShop.data.TreasureShopData;
    import com.view.gameWindow.panel.panels.mall.mallItem.*;
    import com.view.gameWindow.panel.panels.prompt.SelectPromptBtnManager;
    import com.view.gameWindow.panel.panels.prompt.SelectPromptType;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.cell.IconCellEx;
    import com.view.gameWindow.util.cell.ThingsData;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.utils.Dictionary;

    import mx.utils.StringUtil;

    /**
	 * Created by Administrator on 2014/11/19.
	 * 积分商店的物品项
	 */
	public class TreasureShopItem extends MallItemBase
	{
		private var _itemCfg:Object;//有可能是物品表，或者装备表
		private var _dt:ThingsData;
		private var _cellEx:IconCellEx;
		private var _data:TreasureShopCfgData;

		public function TreasureShopItem()
		{
			mouseEnabled = false;
			_skin = new McTreasureItem();
			_skin.mouseEnabled = false;

			var mc:McTreasureItem = _skin as McTreasureItem;
			mc.iconContainer.mouseEnabled = false;

			addChild(_skin);
			initTxt();
			initView();
			_skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}


        override public function get width():Number
        {
            return _skin.bg.width;
        }


        override public function get height():Number
        {
            return _skin.bg.height;
        }

        public function get data():TreasureShopCfgData
		{
			return _data;
		}

		public function set data(value:TreasureShopCfgData):void
		{
			_data = value;
			if (_data)
			{
				var mc:McTreasureItem = _skin as McTreasureItem;
				if (_data.item_type == SlotType.IT_ITEM)
				{
					_itemCfg = ConfigDataManager.instance.itemCfgData(_data.item_id);
				} else
				{
					_itemCfg = ConfigDataManager.instance.equipCfgData(_data.item_id);
				}

				if (_itemCfg)
				{
					mc.txtName.textColor = ItemType.getColorByQuality(_itemCfg.quality);
					mc.txtName.text = _itemCfg.name;

					_cellEx = new IconCellEx(mc.iconContainer, 0, 0, 60, 60);
					_dt = new ThingsData();
					_dt.id = _data.item_id;
					_dt.type = _data.item_type;
					_dt.bind = _data.is_bind;
					IconCellEx.setItemByThingsData(_cellEx, _dt);
					ToolTipManager.getInstance().attach(_cellEx);
				}
				mc.txtCostValue.text = _data.cost_value + " " + StringConst.PANEL_DRAGON_TREASURE_015;
				if (_data.is_limit)
				{
					var dic:Dictionary = TreasureShopManager.instance.itemShopDatas, limitData:TreasureShopData;
					if (dic)
					{
						limitData = dic[_data.id];
					}
					if (limitData)
					{
						mc.txtRemainValue.text = (_data.limit_num - limitData.num).toString();
					} else
					{
						mc.txtRemainValue.text = _data.limit_num.toString();
					}
				} else
				{
					mc.txtRemainValue.text = StringConst.PANEL_DRAGON_TREASURE_020;
				}
				if (ConfigDataManager.instance.positionCfgData(_data.position_limit))
				{
					mc.txtPosition.text = ConfigDataManager.instance.positionCfgData(_data.position_limit).name;
					mc.txtPosition.visible = true;
				} else
				{
					mc.txtPosition.visible = false;
				}
			}
		}

		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McTreasureItem = _skin as McTreasureItem;
			rsrLoader.addCallBack(skin.bg, function (mc:MovieClip):void
			{
				mc.mouseChildren = false;
				mc.mouseEnabled = false;
			});
		}

		/**购买*/
		private function buyHandler():void
		{
			if (data)
			{
				TreasureShopManager.buyData = data;
				var dic:Dictionary = TreasureShopManager.instance.itemShopDatas, limitData:TreasureShopData, remains:int;
				if (dic)
				{
					limitData = dic[_data.id];
				}
				if (limitData)
				{
					remains = data.limit_num - limitData.num;
				} else
				{
					remains = data.limit_num;
				}
				if (data.is_limit)
				{//限量
					if (remains <= 0)
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PANEL_DRAGON_ERROR_6);
						return;
					}
				}
				var myScore:int = DragonTreasureManager.instance.score;
				if (RoleDataManager.instance.position < data.position_limit)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PANEL_DRAGON_ERROR_5);
					return;
				}
				if (myScore < data.cost_value)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PANEL_DRAGON_ERROR_4);
					return;
				}

				var cfg:Object, color:uint;
				if (data.item_type == SlotType.IT_EQUIP)
				{
					cfg = ConfigDataManager.instance.equipCfgData(data.item_id);
					color = ItemType.getColorByQuality(cfg.color);
				} else
				{
					cfg = ConfigDataManager.instance.itemCfgData(data.item_id);
					color = ItemType.getColorByQuality(cfg.quality);
				}

				var select:Boolean = SelectPromptBtnManager.getSelect(SelectPromptType.SELEC_TTREASURE_SHOP);
				if (select)
				{
					TreasureShopManager.instance.sendCM_BUY_FIND_TREASURE_SHOP(data.id, 1);

				} else
				{
					var msg:String = StringUtil.substitute(StringConst.PANEL_DRAGON_TIP_2, cfg.name, data.cost_value);
					Alert.show3(msg, function ():void
					{
						TreasureShopManager.instance.sendCM_BUY_FIND_TREASURE_SHOP(data.id, 1);
					}, null, function (bol:Boolean):void
					{
						SelectPromptBtnManager.setSelect(SelectPromptType.SELEC_TTREASURE_SHOP, bol);
					}, null, StringConst.PROMPT_PANEL_0033,"","",null,"left");
				}
			}
		}

		private function initTxt():void
		{
			var mc:McTreasureItem = _skin as McTreasureItem;
			mc.txtRemain.text = StringConst.PANEL_DRAGON_TREASURE_013;
			mc.txtRemain.mouseEnabled = false;

			mc.txtCost.text = StringConst.PANEL_DRAGON_TREASURE_012;
			mc.txtCost.mouseEnabled = false;

			mc.txtBuy.text = StringConst.PANEL_DRAGON_TREASURE_014;
			mc.txtBuy.mouseEnabled = false;

			mc.txtPosition.textColor = 0xffcc00;
			mc.txtPosition.mouseEnabled = false;
		}

		private function onClick(event:MouseEvent):void
		{
			var mc:McTreasureItem = _skin as McTreasureItem;
			switch (event.target)
			{
				default :
					break;
				case mc.btnBuy:
					buyHandler();
					break;
			}
		}

		override public function destroy():void
		{
			if (_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK, onClick);
				_skin = null;
			}
			if (_itemCfg)
			{
				_itemCfg = null;
			}
			if (_dt)
			{
				_dt = null;
			}
			if (_cellEx)
			{
				ToolTipManager.getInstance().detach(_cellEx);
				_cellEx.destroy();
				_cellEx = null;
			}
			super.destroy();
		}
	}
}