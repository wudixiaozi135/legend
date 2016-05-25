package com.view.gameWindow.panel.panels.mining
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.TrapCfgData;
	import com.model.consts.ItemType;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.mainUi.subuis.progress.ActionProgressData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.TimeUtils;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	internal class PanelMiningViewHandler implements IObserver
	{
		/**矿物id数组*/
		internal const minerals:Array = [ItemType.IT_5001,ItemType.IT_5002,ItemType.IT_5003,ItemType.IT_5004,ItemType.IT_5005,ItemType.IT_101,ItemType.IT_102,ItemType.IT_103,ItemType.IT_104];
		
		private var _panel:PanelMining;
		private var _skin:McMining;

		private var _timeStart:int,_timeLast:int;
		private var _indexTime:int,_indexRemain:int,_indexExpect:int;
		
		public function PanelMiningViewHandler(panel:PanelMining)
		{
			_panel = panel;
			_skin = _panel.skin as McMining;
			initialize();
			BagDataManager.instance.attach(this);
		}
		
		private function initialize():void
		{
			_skin.txtCoin.text = StringConst.MINING_PANEL_0001;
			_skin.txtStrengthen.text = StringConst.MINING_PANEL_0002;
			_skin.txtSell.text = StringConst.MINING_PANEL_0003;
			_skin.txtSell.mouseEnabled = false;
			var lvCanAutoSellStrongstone:int = VipDataManager.instance.lvCanAutoSellStrongstone;
			_skin.txtAutoSell.text = StringConst.MINING_PANEL_0004.replace("&x",lvCanAutoSellStrongstone);
			_skin.txtTime.text = StringConst.MINING_PANEL_0005;
			_indexTime = _skin.txtTime.length - 1;
			_skin.txtRemain.text = StringConst.MINING_PANEL_0006;
			_indexRemain = _skin.txtRemain.length - 1;
			_skin.txtExpect.text = StringConst.MINING_PANEL_0007;
			_indexExpect = _skin.txtExpect.length - 2;
			initializeTip();
			startTime();
		}
		
		private function initializeTip():void
		{
			var manager:ToolTipManager = ToolTipManager.getInstance();
			manager.attachByTipVO(_skin.txtAutoSell,ToolTipConst.TEXT_TIP,StringConst.MINING_PANEL_0010);
		}
		/**显示挖掘持续时间*/
		private function startTime():void
		{
			_skin.addEventListener(Event.ENTER_FRAME,onFrame);
			_timeStart = getTimer();
		}
		
		protected function onFrame(event:Event):void
		{
			var timeNow:int = getTimer();
			if(timeNow - _timeLast >= 1000)
			{
				_timeLast = timeNow;
				var endIndex:int = _skin.txtTime.length;
				var formatClock:String = TimeUtils.formatClock1((timeNow - _timeStart)*.001);
				_skin.txtTime.replaceText(_indexTime,endIndex,formatClock);
			}
		}
		
		public function update(proc:int=0):void
		{
			switch(proc)
			{
				default:
					break;
				case GameServiceConstants.SM_BAG_ITEMS:
					refresh();
					break;
			}
		}
		
		internal function refresh():void
		{
			refreshMinerals();
			refreshRemain();
			refreshExpect();
			dealAutoSell();
		}
		
		private function refreshMinerals():void
		{
			var i:int,l:int = minerals.length;
			for (i=0;i<l;i++) 
			{
				var itemId:int = minerals[i];
				var txtMineral:TextField = _skin["txtMineral"+i] as TextField;
				var txtMineralValue:TextField = _skin["txtMineralValue"+i] as TextField;
				//
				var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(itemId);
				if(itemCfgData)
				{
					txtMineral.text = itemCfgData.name;
				}
				else
				{
					txtMineral.text = "";
					trace("PanelMiningViewHandler.refreshMinerals() 配置NULL");
				}
				//
				var itemNum:int = BagDataManager.instance.getItemNumById(itemId);
				txtMineralValue.text = itemNum+StringConst.MINING_PANEL_0008;
			}
		}
		
		private function refreshRemain():void
		{
			var remainCellNum:int = BagDataManager.instance.remainCellNum;
			var numCelUnLock:int = BagDataManager.instance.numCelUnLock;
			var txt:TextField = _skin.txtRemain;
			var endIndex:int = txt.length;
			_skin.txtRemain.replaceText(_indexRemain,endIndex,remainCellNum+""/* + "/" + numCelUnLock*/);
			endIndex = txt.length;
			var textFormat:TextFormat = txt.defaultTextFormat;
			var color:int = remainCellNum <= 0 ? 0xff0000 : 0x00ff00;
			textFormat.color = color;
			txt.setTextFormat(textFormat,_indexRemain,endIndex);
			txt.width = txt.textWidth + 5;
		}
		
		private function refreshExpect():void
		{
			var miningTime:int;
			if(_panel.args.length == 1)
			{
				var id:int = _panel.args[0] as int;
				var cfgDt:TrapCfgData = ConfigDataManager.instance.trapCfgData(id);
				if(cfgDt && cfgDt.trigger_type == TrapCfgData.TRIGGER_TYPE_READING)
				{
					miningTime = cfgDt.trigger_param*.001;
				}
				else
				{
					miningTime = ActionProgressData.MINING_TIME_MAP*.001;
				}
			}
			else
			{
				miningTime = ActionProgressData.MINING_TIME_MAP*.001;
			}
			var remainCellNum:int = BagDataManager.instance.remainCellNum;
			var txt:TextField = _skin.txtExpect;
			var endIndex:int = txt.length - 1;
			var calcTime:Object = TimeUtils.calcTime(remainCellNum*miningTime);
			var formatS:String = TimeUtils.format(calcTime);
			txt.replaceText(_indexExpect,endIndex,formatS);
			endIndex = txt.length - 1;
			var textFormat:TextFormat = txt.defaultTextFormat;
			textFormat.color = 0xffcc00;
			txt.setTextFormat(textFormat,_indexExpect,endIndex);
			txt.width = txt.textWidth + 5;
			txt.x = _skin.txtRemain.x + _skin.txtRemain.width;
		}
		
		private function dealAutoSell():void
		{
			var lv:int = VipDataManager.instance.lv;
			if(!lv)
			{
				return;
			}
			var isAutoSell:Boolean = _panel.mouseHandler.isAutoSell;
			if(!isAutoSell)
			{
				return;
			}
			var remainCellNum:int = BagDataManager.instance.remainCellNum;
			if(remainCellNum > 0)
			{
				return;
			}
			_panel.mouseHandler.dealSell();
		}
		
		internal function destroy():void
		{
			ToolTipManager.getInstance().detach(_skin.txtAutoSell);
			BagDataManager.instance.detach(this);
			if(_skin)
			{
				_skin.removeEventListener(Event.ENTER_FRAME,onFrame);
			}
			_skin = null;
			_panel = null;
		}
	}
}