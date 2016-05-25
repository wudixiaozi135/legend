package com.view.gameWindow.panel.panels.forge.strengthen
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipPolishCfgData;
	import com.model.consts.StringConst;
	import com.model.gameWindow.mem.MemEquipData;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.forge.ForgeDataManager;
	import com.view.gameWindow.panel.panels.forge.McIntensify;
	import com.view.gameWindow.panel.panels.prompt.Panel1BtnPromptData;
	import com.view.gameWindow.util.HtmlUtils;

	/**
	 * 强化面板累计打磨信息处理类
	 * @author Administrator
	 */	
	public class StrengthenAccruePolish
	{
		private var _skin:McIntensify;
		/**打磨等级*/
		private var _polishLv:int;
		/**锋利度*/
		private var _polishExp:int;
		/**起始锋利度*/
		private var _polishExpStart:int;
		/**锋利度增加*/
		private var _polishExpAdd:int;
		/**总锋利度*/
		private var _polishExpTotal:int;
		/**打磨次数*/
		private var _num:int;
		/**暴击次数*/
		private var _numCrit:int;
		/**大暴击次数*/
		private var _numBigCrit:int;
		/**累计消耗金币*/
		private var _coinCost:int;
		/**累计消耗元宝*/
		private var _goldCost:int;
		/**累计消耗道具*/
		private var _itemCost:int;
		/**道具名称*/
		private var _itemName:String;
		
		public function StrengthenAccruePolish(skin:McIntensify,dt:MemEquipData)
		{
			_skin = skin;
			_polishLv = dt.polish;
			_polishExpStart = _polishExp = dt.polishExp;
			var equipPolishCfgData:EquipPolishCfgData = ConfigDataManager.instance.equipPolishCfgData(dt.polish+1);
			_polishExpTotal = equipPolishCfgData ? equipPolishCfgData.max_exp : 0;
			_itemName = ConfigDataManager.instance.itemCfgData(equipPolishCfgData.stone).name;
			trace("StrengthenAccruePolish.StrengthenAccruePolish(dt) equipPolishCfgData is null");
		}
		
		public function accruePolishCost(memEquipData:MemEquipData):void
		{
			var goldNeed:int = int(_skin.txtGoldValue.text);
			_goldCost += goldNeed;
			var equipPolishCfgData:EquipPolishCfgData = ConfigDataManager.instance.equipPolishCfgData(memEquipData.polish+1);
			_coinCost += equipPolishCfgData.coin;
			var itemNum:int = BagDataManager.instance.getItemNumById(equipPolishCfgData.stone);
			_itemCost += itemNum > equipPolishCfgData.stone_count ? equipPolishCfgData.stone_count : itemNum;
		}
		
		public function accruePolishInfo(dt:MemEquipData):void
		{
			var polishExp:int = dt.polishExp ? dt.polishExp : _polishExpTotal;
			var dValue:int = polishExp - _polishExp;
			_polishExp = polishExp;
			if(dValue > 0)
			{
				_num++;
				if(dValue > 2)
				{
					_numBigCrit++;
				}
				else if(dValue > 1)
				{
					_numCrit++;
				}
			}
			_polishExpAdd = polishExp - _polishExpStart;
			
			/*trace("StrengthenAccruePolish.accruePolishInfo(dt) //////////////////////////");
			trace("dValue:"+dValue);
			trace("_num:"+_num);
			trace("_polishExpAdd:"+_polishExpAdd);
			trace("_coinCost:"+_coinCost);
			trace("_goldCost:"+_goldCost);
			trace("_itemCost:"+_itemCost);
			trace("_numCrit:"+_numCrit);
			trace("_numBigCrit:"+_numBigCrit);
			trace("_polishLv:"+_polishLv);
			trace("StrengthenAccruePolish.accruePolishInfo(dt) //////////////////////////");*/
			
			if(dt.polish > _polishLv)
			{
				_polishLv = dt.polish;
				//弹出结果面板
				ForgeDataManager.instance.stopIntervalPolishRequest();
			}
		}
		
		public function showPrompt():void
		{
			Panel1BtnPromptData.strName = StringConst.STRENGTH_PANEL_0028;
			var txt:String = StringConst.STRENGTH_PANEL_0029 + HtmlUtils.createHtmlStr(0x009900,_num+"")+"\n";
			txt += StringConst.STRENGTH_PANEL_0030 + HtmlUtils.createHtmlStr(0xffcc00,_polishExpAdd+"")+"\n";
			txt += StringConst.STRENGTH_PANEL_0031 + HtmlUtils.createHtmlStr(0xffcc00,_coinCost + StringConst.FORGE_PANEL_0006)+"\n";
			txt += "\t\t   " + HtmlUtils.createHtmlStr(0xffcc00,_goldCost + StringConst.FORGE_PANEL_0007)+"\n";
			txt += "\t\t   " + HtmlUtils.createHtmlStr(0xffcc00,_itemCost + _itemName)+"\n";
			txt += StringConst.STRENGTH_PANEL_0032 + HtmlUtils.createHtmlStr(0xac00ff,_numCrit+"")+"\n";
			txt += StringConst.STRENGTH_PANEL_0033 + HtmlUtils.createHtmlStr(0xac00ff,_numBigCrit+"")+"\n";
			txt += StringConst.STRENGTH_PANEL_0034 + HtmlUtils.createHtmlStr(0xffe1aa,_polishLv+"")+"\n";
			Panel1BtnPromptData.strContent = HtmlUtils.createHtmlStr(0xd4a460,txt,14,false,4);
			Panel1BtnPromptData.strBtn = StringConst.PROMPT_PANEL_0003;
			PanelMediator.instance.switchPanel(PanelConst.TYPE_1BTN_PROMPT);
		}
		
		public function destroy():void
		{
			_skin = null;
			/**打磨等级*/
			_polishLv = 0;
			/**锋利度*/
			_polishExp = 0;
			/**起始锋利度*/
			_polishExpStart = 0;
			/**锋利度增加*/
			_polishExpAdd = 0;
			/**总锋利度*/
			_polishExpTotal = 0;
			/**打磨次数*/
			_num = 0;
			/**暴击次数*/
			_numCrit = 0;
			/**大暴击次数*/
			_numBigCrit = 0;
			/**累计消耗金币*/
			_coinCost = 0;
			/**累计消耗元宝*/
			_goldCost = 0;
			/**累计消耗道具*/
			_itemCost = 0;
			/**道具名称*/
			_itemName = "";
		}
	}
}