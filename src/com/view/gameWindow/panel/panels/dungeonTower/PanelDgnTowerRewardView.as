package com.view.gameWindow.panel.panels.dungeonTower
{
	import com.model.configData.cfgdata.DgnRewardMultipleCfgData;
	import com.model.consts.ItemType;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UtilColorMatrixFilters;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * 塔防副本奖励面板显示处理类
	 * @author Administrator
	 */	
	internal class PanelDgnTowerRewardView
	{
		private var _panel:PanelDgnTowerReward;
		private var _skin:McDgnTowerReward;
		
		private var _btnWords:Array = [StringConst.DGN_TOWER_0018,StringConst.DGN_TOWER_0019,StringConst.DGN_TOWER_0020,StringConst.DGN_TOWER_0021];
		private var _cells:Vector.<IconCellEx>;
		
		/*private var _highlightEffect:HighlightEffectManager;*/

		private var _vipLv:int;
		
		public function PanelDgnTowerRewardView(panel:PanelDgnTowerReward)
		{
			_panel = panel;
			_skin = _panel.skin as McDgnTowerReward;
			initialize();
		}
		
		private function initialize():void
		{
			var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
			_cells = new Vector.<IconCellEx>();
			assignTxtTitle();
			assignTxtExpUnget();
			assignTxtExpUngetValue();
			var i:int,l:int = manager.multipleCfgDts.length;
			for (i=0;i<l;i++) 
			{
				initCells(i);
				assignTxtInMc(i);
				assignTxtAboveBtn(i);
				assignTxtVipCost(i);
			}
			//
			/*var isInMainDgnTower:Boolean = manager.isInMainDgnTower;
			if(isInMainDgnTower)
			{
				_highlightEffect = new HighlightEffectManager();
				_highlightEffect.show(_skin.btn3.parent,_skin.btn3);
			}*/
		}
		
		private function initCells(index:int):void
		{
			var mc:MovieClip = _skin["mc"+index] as MovieClip;
			var cell:IconCellEx = new IconCellEx(mc,0,0,mc.width,mc.height,0);
			var dt:ThingsData = new ThingsData();
			dt.id = ItemType.IT_EXP;
			dt.type = SlotType.IT_ITEM;
			IconCellEx.setItemByThingsData(cell,dt);
			ToolTipManager.getInstance().attach(cell);
			_cells.push(cell);
		}
		
		private function assignTxtTitle():void
		{
			_skin.txtTitle.htmlText = HtmlUtils.createHtmlStr(_skin.txtTitle.textColor,StringConst.DGN_TOWER_0017,12,true);
		}
		
		private function assignTxtExpUnget():void
		{
			_skin.txtExpUnGet.text = StringConst.DGN_TOWER_0011;
		}
		
		internal function assignTxtExpUngetValue():void
		{
			var expGain:int = DgnTowerDataManger.instance.expGainMultiple;
			_skin.txtExpUnGetValue.text = expGain+'';
		}
		
		internal function switchGlow(isGlow:Boolean):void
		{
			if(isGlow)
			{
				_skin.txtExpUnGetValue.filters = [UtilColorMatrixFilters.RED_COLOR_FILTER];
			}
			else
			{
				_skin.txtExpUnGetValue.filters = null;
			}
		}
		
		private function assignTxtInMc(index:int):void
		{
			var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
			var expGain:int = manager.expGainMultipleBy(index);
			var txt:TextField = _skin["mc"+index].txt as TextField;
			txt.text = expGain + "";
		}
		
		private function assignTxtAboveBtn(index:int):void
		{
			var str:String = _btnWords[index] as String;
			var txt:TextField = _skin["txtBtn"+index] as TextField;
			txt.text = str;
			txt.mouseEnabled = false;
		}
		
		private function assignTxtVipCost(index:int):void
		{
			var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
			var cfgDt:DgnRewardMultipleCfgData = manager.dgnRewardMultipleCfgDt(index);
			var txt:TextField = _skin["txt"+index] as TextField;
			if(index == 0)
			{
				txt.text = StringConst.DGN_TOWER_0022;
			}
			else
			{
				txt.text = cfgDt.gold+'';
			}
			//
			if(index > 0)
			{
				var txtVip:TextField = _skin["txtVip"+index] as TextField;
				txtVip.text = StringConst.DGN_TOWER_0047.replace("&x",cfgDt.vip);
				txtVip.textColor = index == 1 ? 0x00ff00 : (index == 2 ? 0x1047df : 0xe616b6);
				//
				var mcGold:MovieClip = _skin["mcGold"+index] as MovieClip;
				var lv:int = VipDataManager.instance.lv;
				var boolean:Boolean = lv >= cfgDt.vip;
				txtVip.visible = !boolean;
				mcGold.visible = txt.visible = boolean;
			}
		}
		
		public function updateTxtVipCost():void
		{
			var vipLv:int = VipDataManager.instance.lv;
			if(vipLv == _vipLv)
			{
				return;
			}
			_vipLv = vipLv;
			var i:int,l:int = DgnTowerDataManger.instance.multipleCfgDts.length;
			for (i=0;i<l;i++) 
			{
				assignTxtVipCost(i);
			}
		}
		
		internal function destroy():void
		{
			/*if(_highlightEffect)
			{
				_highlightEffect.hide(_skin.btn3);
			}*/
			var cell:IconCellEx;
			for each(cell in _cells)
			{
				ToolTipManager.getInstance().detach(cell);
				cell.destroy();
			}
			_cells = null;
			_skin = null;
			_panel = null;
		}
	}
}