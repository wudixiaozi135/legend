package com.view.gameWindow.util
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.NpcShopCfgData;
	import com.model.configData.cfgdata.NpcTeleportCfgData;
	import com.model.consts.ConstPriceType;
	import com.model.consts.ItemType;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;

	public class UtilCostRollTip
	{
		private static var _str:String;
		public function UtilCostRollTip()
		{
		}
		
		public static function get str():String
		{
			return _str;
		}

		/**
		 * 判断传送消耗是否足够
		 * @return 
		 * 
		 */		
		public static function costEnough(data:NpcTeleportCfgData):Boolean
		{
			if(data.coin > (BagDataManager.instance.coinBind + BagDataManager.instance.coinUnBind))
			{
				_str = StringConst.TRANS_PANEL_0018.replace("xx",StringConst.TRANS_PANEL_0008);
				return false;
			}
			if( data.unbind_coin >  BagDataManager.instance.coinUnBind)
			{
				_str = StringConst.TRANS_PANEL_0018.replace("xx",StringConst.TRANS_PANEL_0021);
				return false;
			}
			if( data.bind_gold > BagDataManager.instance.goldBind)
			{
				_str = StringConst.TRANS_PANEL_0018.replace("xx",StringConst.TRANS_PANEL_0019);
				return false;
			}
			if(data.unbind_gold > BagDataManager.instance.goldUnBind)
			{
				_str = StringConst.TRANS_PANEL_0018.replace("xx",StringConst.TRANS_PANEL_0010);
				return false;
			}
			if(data.item_count > BagDataManager.instance.getItemNumById(data.item))
			{
				_str = StringConst.TRANS_PANEL_0018.replace("xx",ConfigDataManager.instance.itemCfgData(data.item).name);
				return false;
			}
			return true;
		}
		
		/**
		 * 判断传送消耗是否足够（只需要其中一种满足即可）
		 * @return 
		 * 
		 */		
		public static function costEnoughOnlyOne(cfgDt:NpcTeleportCfgData):Boolean
		{
			if(cfgDt.coin > (BagDataManager.instance.coinBind + BagDataManager.instance.coinUnBind))
			{
				_str = StringConst.TRANS_PANEL_0018.replace("xx",StringConst.TRANS_PANEL_0008);
				return false;
			}
			else
			{
				if(cfgDt.coin)
				{
					return true;
				}
			}
			if( cfgDt.unbind_coin >  BagDataManager.instance.coinUnBind)
			{
				_str = StringConst.TRANS_PANEL_0018.replace("xx",StringConst.TRANS_PANEL_0021);
				return false;
			}
			else
			{
				if(cfgDt.unbind_coin)
				{
					return true;
				}
			}
			if( cfgDt.bind_gold > BagDataManager.instance.goldBind)
			{
				_str = StringConst.TRANS_PANEL_0018.replace("xx",StringConst.TRANS_PANEL_0019);
				return false;
			}
			else
			{
				if(cfgDt.bind_gold)
				{
					return true;
				}
			}
			if(cfgDt.unbind_gold > BagDataManager.instance.goldUnBind)
			{
				_str = StringConst.TRANS_PANEL_0018.replace("xx",StringConst.TRANS_PANEL_0010);
				return false;
			}
			else
			{
				if(cfgDt.unbind_gold)
				{
					return true;
				}
			}
			if(!cfgDt.itemCfgData)
			{
				trace("UtilCostRollTip.costEnoughOnlyOne(cfgDt) 配置信息错误，需要消耗的道具不存在");
				return true;
			}
			var count:int = BagDataManager.instance.getItemNumById(cfgDt.item);
			count += HeroDataManager.instance.getItemNumById(cfgDt.item);
			if(cfgDt.item_count > count)
			{
				_str = StringConst.TRANS_PANEL_0018.replace("xx",cfgDt.itemCfgData.name);
				return false;
			}
			else
			{
				if(cfgDt.item_count)
				{
					return true;
				}
			}
			return true;
		}
		
		/**
		 *传送成功消耗的系统提示 
		 * @param data
		 * @return 
		 * 
		 */		
		public static function costTeleport(data:NpcTeleportCfgData,type:int):String
		{
			var str:String = "";
			if(type == ItemType.NTUT_ITEM && data.item_count)
			{
				str = ConfigDataManager.instance.itemCfgData(data.item).name + "x" + String(data.item_count);
				return StringConst.TRANS_PANEL_0020.replace("xx",str);
			}
			if(type == ItemType.NTUT_COIN && data.coin)
			{
				str = String(data.coin) + StringConst.TRANS_PANEL_0008;
				return StringConst.TRANS_PANEL_0020.replace("xx",str);
			}
			if(type == ItemType.NTUT_COIN && data.unbind_coin)
			{
				str = String(data.unbind_coin) + StringConst.TRANS_PANEL_0021;
				return StringConst.TRANS_PANEL_0020.replace("xx",str);
			}
			if(type == ItemType.NTUT_BINDGOLD && data.bind_gold)
			{
				str = String(data.bind_gold) + StringConst.TRANS_PANEL_0019;
				return StringConst.TRANS_PANEL_0020.replace("xx",str);
			}
			if(type == ItemType.NTUT_UNGOLD && data.unbind_gold)
			{
				_str = String(data.unbind_gold) + StringConst.TRANS_PANEL_0010;
				return StringConst.TRANS_PANEL_0020.replace("xx",str);
			}
			return "";
		}
		
		/**
		 *商店购买消耗是否足够 
		 * @param data
		 * @param num
		 * @return 
		 * 
		 */		
		public static function costShopBuy(data:NpcShopCfgData,num:int = 1):Boolean
		{
			if(data.price_type == 1)
			{
				if(num*data.price_value >  BagDataManager.instance.coinUnBind)
				{
					_str = StringConst.PROMPT_PANEL_0017.replace("XX",StringConst.PROMPT_PANEL_0018);
					return false;
				}
			}
			if(data.price_type == 2)
			{
				if(num*data.price_value > (BagDataManager.instance.coinBind + BagDataManager.instance.coinUnBind))
				{
					_str = StringConst.PROMPT_PANEL_0017.replace("XX",StringConst.PROMPT_PANEL_0015);
					return false;
				}
			}
			if(data.price_type == 3)
			{
				if(num*data.price_value > BagDataManager.instance.goldUnBind)
				{
					_str = StringConst.PROMPT_PANEL_0017.replace("XX",StringConst.PROMPT_PANEL_0019);
					return false;
				}
			}
			if(data.price_type == 4)
			{
				if(num*data.price_value > BagDataManager.instance.goldBind)
				{
					_str = StringConst.PROMPT_PANEL_0017.replace("XX",StringConst.PROMPT_PANEL_0020);
					return false;
				}
			}
			return true;
		}
		
		/**
		 *成功购买商店物品提示 
		 * @param data
		 * @return 
		 * 
		 */		
		public static function successShoping(_cfgDt:NpcShopCfgData,num:int = 1):String
		{
			var str:String;
			var name:String;
			if(_cfgDt.type == SlotType.IT_EQUIP)
			{
				var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(_cfgDt.base);
				name = equipCfgData.name;
			}
			else if(_cfgDt.type == SlotType.IT_ITEM)
			{
				var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(_cfgDt.base);
				name = itemCfgData.name;
			}
			str = StringConst.PROMPT_PANEL_0016.replace("XX",name + "x" + String(num)).replace("XX",String(_cfgDt.price_value*num) + ConstPriceType.getPriceStr(_cfgDt.price_type));
			return str;
		}
	}
}