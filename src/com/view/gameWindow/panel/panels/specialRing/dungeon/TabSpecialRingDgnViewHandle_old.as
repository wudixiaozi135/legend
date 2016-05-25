package com.view.gameWindow.panel.panels.specialRing.dungeon
{
	import com.model.configData.cfgdata.DungeonCfgData;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UtilItemParse;
	
	import flash.display.MovieClip;
	import flash.text.TextFormat;

	/**
	 * 特戒副本页显示处理类
	 * @author Administrator
	 */	
	public class TabSpecialRingDgnViewHandle
	{
		private var _tab:TabSpecialRingDungeon;
		private var _skin:McSpecialRingDungeon;
		private var _cell:RoleCell;
		
		public function TabSpecialRingDgnViewHandle(tab:TabSpecialRingDungeon)
		{
			_tab = tab;
			_skin = _tab.skin as McSpecialRingDungeon;
			init();
			addDungeonTip();
			addVitTip();
			addRuleTip();
		}
		
		private function init():void
		{
			_skin.txtVit.text = StringConst.SPECIAL_RING_PANEL_0016;
			_skin.txtWantVit.text = StringConst.SPECIAL_RING_PANEL_0017;
			var defaultTextFormat:TextFormat = _skin.txtWantVit.defaultTextFormat;
			defaultTextFormat.underline = true;
			_skin.txtWantVit.defaultTextFormat = defaultTextFormat;
			_skin.txtWantVit.setTextFormat(defaultTextFormat);
			_skin.txtRule.text = StringConst.SPECIAL_RING_PANEL_0018;
			defaultTextFormat = _skin.txtRule.defaultTextFormat;
			defaultTextFormat.underline = true;
			_skin.txtRule.defaultTextFormat = defaultTextFormat;
			_skin.txtRule.setTextFormat(defaultTextFormat);
			_skin.txtRollCost.text = StringConst.SPECIAL_RING_PANEL_0019;
			_skin.txtRollCostValue.text = StringConst.SPECIAL_RING_PANEL_0022;
			//
			_cell = new RoleCell(_skin.mcIconLayer);
		}
		
		private function addDungeonTip():void
		{
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var i:int,l:int = 5;
			for(i=0;i<l;i++)
			{
				var cell:int = 2*i+1;
				var cfgData:DungeonCfgData = manager.getDungeonCfgData(cell);
				if(cfgData)
				{
					var tipVO:TipVO = new TipVO();
					tipVO.tipType = ToolTipConst.TEXT_TIP;
					var str:String = StringConst.SPECIAL_RING_PANEL_0027 + "\n" + cfgData.desc + "\n\n";
					var itemStr:Array = UtilItemParse.getItemString(cfgData.finally_reward);
					str += StringConst.SPECIAL_RING_PANEL_0028 + "\n" + itemStr[1]+"*"+itemStr[2] + "\n\n";
					str += StringConst.SPECIAL_RING_PANEL_0029 + "\n" + cfgData.player_daily_vit + StringConst.SPECIAL_RING_PANEL_0030;
					str = HtmlUtils.createHtmlStr(0x5b436,str);
					tipVO.tipData = str;
					var mcEnter:MovieClip = _skin["mcEnter"+i] as MovieClip;
					ToolTipManager.getInstance().hashTipInfo(mcEnter,tipVO);
					ToolTipManager.getInstance().attach(mcEnter);
				}
				else
				{
					trace("ViewHandle.addDungeonTip 副本配置信息不存在");
				}
			}
		}
		
		private function addVitTip():void
		{
			var tipVO:TipVO = new TipVO();
			tipVO.tipType = ToolTipConst.TEXT_TIP;
			tipVO.tipData = getVitTipData;
			ToolTipManager.getInstance().hashTipInfo(_skin.txtVitValue,tipVO);
			ToolTipManager.getInstance().attach(_skin.txtVitValue);
		}
		
		private function getVitTipData():String
		{
			var str:String = "";
			var manager:DailyDataManager = DailyDataManager.instance;
			str += StringConst.SPECIAL_RING_PANEL_0016 + manager.player_daily_vit+"/"+manager.daily_vit_max+"\n";
			str += StringConst.SPECIAL_RING_PANEL_0021;
			str = HtmlUtils.createHtmlStr(0x53b436,str);
			return str;
		}
		
		private function addRuleTip():void
		{
			var tipVO:TipVO = new TipVO();
			tipVO.tipType = ToolTipConst.TEXT_TIP;
			var str:String = HtmlUtils.createHtmlStr(0x5b436,StringConst.SPECIAL_RING_PANEL_0023);
			tipVO.tipData = str;
			ToolTipManager.getInstance().hashTipInfo(_skin.txtRule,tipVO);
			ToolTipManager.getInstance().attach(_skin.txtRule);
		}
		
		internal function refreshIcon():void
		{
			_cell.refreshData();
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var dungeon_point:int = manager.dungeon_point;
			var mcIconBg:MovieClip = _skin["mcIconBg"+dungeon_point] as MovieClip;
			var cX:int = mcIconBg.x + mcIconBg.width/2;
			var cY:int = mcIconBg.y + mcIconBg.height/2;
			_skin.mcIconLayer.x = cX - _skin.mcIconLayer.width/2;
			_skin.mcIconLayer.y = cY - _skin.mcIconLayer.height/2;
			//
			var cfgData:DungeonCfgData = manager.getDungeonCfgData();
			if(cfgData)
			{
				_skin.txtEnterCost.text = StringConst.SPECIAL_RING_PANEL_0020.replace("&x",cfgData.name);
				_skin.txtEnterCostValue.text = cfgData.player_daily_vit+StringConst.SPECIAL_RING_PANEL_0024;
			}
			else
			{
				_skin.txtEnterCost.text = "";
				_skin.txtEnterCostValue.text = "";
			}
		}
		
		internal function refreshVit():void
		{
			var manager:DailyDataManager = DailyDataManager.instance;
			var vit:int = manager.player_daily_vit;
			var VIT_TOTAL:int = manager.daily_vit_max;
			_skin.txtVitValue.text = vit+"/"+VIT_TOTAL;
			_skin.mcVit.mcMask.scaleX = vit > 0 ? (vit < VIT_TOTAL ? vit/VIT_TOTAL : 1) : 0;
		}
		
		internal function refershBtn():void
		{
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var isCanEnter:Boolean = manager.isCanEnter();
			isCanEnter ? _skin.btn.gotoAndStop(2) : _skin.btn.gotoAndStop(1);
		}
		
		internal function isVitEnough():Boolean
		{
			var vit:int = DailyDataManager.instance.player_daily_vit;
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var isCanEnter:Boolean = manager.isCanEnter();
			if(isCanEnter)
			{
				if(vit < manager.getDungeonCfgData().player_daily_vit)
				{
					return false;
				}
				else
				{
					return true;
				}
			}
			else
			{
				if(vit < SpecialRingDataManager.VIT_COST_VALUE)
				{
					return false;
				}
				else
				{
					return true;
				}
			}
		}
		
		internal function destroy():void
		{
			var i:int,l:int = 5;
			for(i=0;i<l;i++)
			{
				var mcEnter:MovieClip = _skin["mcEnter"+i] as MovieClip;
				ToolTipManager.getInstance().detach(mcEnter);
			}
			ToolTipManager.getInstance().detach(_skin.txtRule);
			ToolTipManager.getInstance().detach(_skin.txtVitValue);
			if(_cell)
			{
				_cell.destroy();
				_cell = null;
			}
			_skin = null;
			_tab = null;
		}
	}
}