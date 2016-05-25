package com.view.gameWindow.panel.panels.dungeon.rewardCard
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.DgnRewardCardGoldCfgData;
	import com.model.configData.cfgdata.VipCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.utils.Dictionary;

	public class DataDgnRewardCard
	{
		public var rewardGroupId:int;
		/**点击牌位置*/
		public var postion:int;
		/**获得道具id<br>使用当次postion作为key*/
		public var ids:Dictionary;
		
		public function DataDgnRewardCard()
		{
			ids = new Dictionary();
		}
		/**当前是第几次翻牌*/
		public var count:int;
		/**总翻牌次数*/
		public function get countTotal():int
		{
			var vipCfgDt:VipCfgData = VipDataManager.instance.vipCfgDataByLv(VipDataManager.instance.lv);
			return (vipCfgDt ? vipCfgDt.dungeon_card_num : 1);
		}
		/**翻牌次数文字*/
		public function get countText():String
		{
			return count + "/" + countTotal;
		}
		/**是否一次都没翻过牌*/
		public function get isUnTurn():Boolean
		{
			return count == 0;
		}
		/**翻牌次数有剩余*/
		public function get isCountRemain():Boolean
		{
			return countTotal - count > 0;
		}
		/**消耗元宝文字*/
		public function get goldText():String
		{
			var cfgDt:DgnRewardCardGoldCfgData = ConfigDataManager.instance.dgnRewardCardGoldCfgData(count+1);
			if(!cfgDt)
			{
				return "";
			}
			return cfgDt.gold ? StringConst.DUNGEON_REWARD_CARD_0005 + HtmlUtils.createHtmlStr(0xffe1aa,cfgDt.gold+"") : "";
		}
		/**消耗元宝提示文字*/
		public function get goldTipText():String
		{
			var cfgDt:DgnRewardCardGoldCfgData = ConfigDataManager.instance.dgnRewardCardGoldCfgData(count+1);
			return cfgDt && isCountRemain ? StringConst.DUNGEON_REWARD_CARD_TIP_0003.replace("&x",cfgDt.gold) : "";
		}
		/**是否需要消耗元宝*/
		public function get isGoldNeed():Boolean
		{
			var cfgDt:DgnRewardCardGoldCfgData = ConfigDataManager.instance.dgnRewardCardGoldCfgData(count+1);
			if(!cfgDt)
			{
				return false;
			}
			return cfgDt.gold != 0;
		}
		/**元宝是否足够*/
		public function get isGoldEnough():Boolean
		{
			var cfgDt:DgnRewardCardGoldCfgData = ConfigDataManager.instance.dgnRewardCardGoldCfgData(count+1);
			if(!cfgDt)
			{
				return true;
			}
			var goldUnBind:int = BagDataManager.instance.goldUnBind;
			return goldUnBind - cfgDt.gold >= 0;
		}
		/**是否选中不在提示*/
		public var isSelect:Boolean;
		
		public function reset():void
		{
			rewardGroupId = 0;
			postion = 0;
			ids = new Dictionary();
			count = 0;
			isSelect = false;
		}
	}
}