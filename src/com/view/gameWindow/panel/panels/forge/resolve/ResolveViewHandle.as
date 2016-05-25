package com.view.gameWindow.panel.panels.forge.resolve
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipResolveCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.EffectConst;
	import com.model.consts.StringConst;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.forge.ForgeDataManager;
	import com.view.gameWindow.panel.panels.forge.McResolve;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.cell.CellData;
	
	import flash.display.MovieClip;

	/**
	 * 锻造分解面板显示处理类
	 * @author Administrator
	 */	
	public class ResolveViewHandle
	{
		private var _panel:TabResolve;
		private var _mc:McResolve;

		internal var equipCell:ResolveCell;
		internal var resolventCell0:ResolveCell;
		internal var resolventCell1:ResolveCell;
		/**消耗货币类型，0金币，1元宝，2弹窗，3无消耗*/
		internal var costType:int;
		internal var costValue:int;
		internal var isEnough:Boolean;
		private var _effectLoader:UIEffectLoader;
		
		public function ResolveViewHandle(panel:TabResolve)
		{
			_panel = panel;
			_mc = _panel.skin as McResolve;
			init();
		}
		
		private function init():void
		{
			equipCell = new ResolveCell(_mc.mcEquipBg,_mc.mcEquipBg.x,_mc.mcEquipBg.y,_mc.mcEquipBg.width,_mc.mcEquipBg.height);
			ToolTipManager.getInstance().attach(equipCell);
			var mcBg:MovieClip = _mc.mcResolvent0.mcBg;
			resolventCell0 = new ResolveCell(mcBg,mcBg.x,mcBg.y,mcBg.width,mcBg.height);
			ToolTipManager.getInstance().attach(resolventCell0);
			mcBg = _mc.mcResolvent1.mcBg;
			resolventCell1 = new ResolveCell(mcBg,mcBg.x,mcBg.y,mcBg.width,mcBg.height);
			ToolTipManager.getInstance().attach(resolventCell1);
			//
			_mc.txtInfo.text = StringConst.RESOLVE_PANEL_0001;
			_mc.txtJB.text = StringConst.RESOLVE_PANEL_0002;
			_mc.txtYB.text = StringConst.RESOLVE_PANEL_0003;
		}
		
		public function refresh():void
		{
			var cellData:CellData = ForgeDataManager.instance.selectResolveData;
			if(!cellData)
			{
				_mc.txtJBNum.text = "";
				_mc.txtYBNum.text = "";
				equipCell.setNull();
				resolventCell0.setNull();
				_mc.mcResolvent0.x = 459;
				_mc.mcResolvent0.txtNum.text = "";
				resolventCell1.setNull();
				_mc.mcResolvent1.visible = false;
				_mc.mcResolvent1.txtNum.text = "";
				if(_effectLoader)
				{
					_effectLoader.destroy();
					_effectLoader = null;
				}
				return;
			}
			if(!_effectLoader)
			{
				_effectLoader = new UIEffectLoader(_mc,58,57,1,1,EffectConst.RES_RESOLVE_BG);
			}
			equipCell.refreshData(cellData);
			var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(cellData.bornSid,cellData.id);
			if(!memEquipData)
			{
				trace("ResolveCellHandle.refreshRightCells 装备不存在");
				return;
			}
			var equipResolveCfgData:EquipResolveCfgData = ConfigDataManager.instance.equipResolveCfgData(memEquipData.baseId);
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(equipResolveCfgData.item);
			if(!itemCfgData)
			{
				trace("ResolveCellHandle.refreshRightCells 分级物物品配置信息不存在");
				return;
			}
			resolventCell0.refreshDataByCfg(itemCfgData);
			_mc.mcResolvent0.txtNum.text = equipResolveCfgData.count;
			var randomResolventId:int = isRandomResolvent(equipResolveCfgData);
			if(randomResolventId)//若有随机分解物
			{
				_mc.mcResolvent0.x = 368;
				_mc.mcResolvent1.visible = true;
				itemCfgData = ConfigDataManager.instance.itemCfgData(randomResolventId);
				if(!itemCfgData)
				{
					trace("ResolveCellHandle.refreshRightCells 随机分级物物品配置信息不存在");
					return;
				}
				resolventCell1.refreshDataByCfg(itemCfgData);
			}
			else
			{
				_mc.mcResolvent0.x = 427;
				_mc.mcResolvent1.visible = false;
			}
			//
			var coinNeed:int = equipResolveCfgData.coin;
			var goldNeed:int = equipResolveCfgData.bind_gold || equipResolveCfgData.unbind_gold;
			if(coinNeed)
			{
				costType = 0;
				costValue = coinNeed;
				var coin:int = BagDataManager.instance.coinBind + BagDataManager.instance.coinUnBind;
				coin >= coinNeed ? isEnough = true : isEnough = false;
				_mc.txtJBNum.text = ""+coinNeed;
				coin >= coinNeed ? _mc.txtJBNum.textColor = 0x009900 : _mc.txtJBNum.textColor = 0xff0000;
				_mc.txtYBNum.text = "0";
				_mc.txtYBNum.textColor = 0x009900;
			}
			else if(goldNeed)
			{
				var goldBind:int = BagDataManager.instance.goldBind;
				var gold:int = BagDataManager.instance.goldUnBind;
				goldBind < goldNeed && gold >= goldNeed ? costType = 2 : costType = 1;
				costValue = goldNeed;
				goldBind < goldNeed && gold < goldNeed ? isEnough = false : isEnough = true;
				_mc.txtJBNum.text = "0";
				_mc.txtJBNum.textColor = 0x009900;
				_mc.txtYBNum.text = ""+goldNeed;
				goldBind < goldNeed && gold < goldNeed ? _mc.txtYBNum.textColor = 0xff0000 : _mc.txtYBNum.textColor = 0x009900;
			}
			else
			{
				costType = 3;
				costValue = 0;
				isEnough = true;
				_mc.txtJBNum.text = "0";
				_mc.txtJBNum.textColor = 0x009900;
				_mc.txtYBNum.text = "0";
				_mc.txtYBNum.textColor = 0x009900;
			}
		}
		/**
		 * 
		 * @return 随机分级物id
		 */		
		public function isRandomResolvent(equipResolveCfgData:EquipResolveCfgData):int
		{
			var id:int,time:int;
			if(equipResolveCfgData.prob_item1)
			{
				id = equipResolveCfgData.prob_item1;
				_mc.mcResolvent1.txtNum.text = ""+equipResolveCfgData.prob_count1;
				time++;
			}
			if(equipResolveCfgData.prob_item2)
			{
				id = equipResolveCfgData.prob_item2;
				_mc.mcResolvent1.txtNum.text = ""+equipResolveCfgData.prob_count2;
				time++;
			}
			if(equipResolveCfgData.prob_item3)
			{
				id = equipResolveCfgData.prob_item3;
				_mc.mcResolvent1.txtNum.text = ""+equipResolveCfgData.prob_count3;
				time++;
			}
			if(time > 1)
			{
				id = 11;
				_mc.mcResolvent1.txtNum.text = "";
			}
			return id;
		}
		
		public function destroy():void
		{
			if(equipCell)
			{
				ToolTipManager.getInstance().detach(equipCell);
				equipCell.destroy();
				equipCell = null;
			}
			if(resolventCell0)
			{
				ToolTipManager.getInstance().detach(resolventCell0);
				resolventCell0.destroy();
				resolventCell0 = null;
			}
			if(resolventCell1)
			{
				ToolTipManager.getInstance().detach(resolventCell1);
				resolventCell1.destroy();
				resolventCell1 = null;
			}
			if(_effectLoader)
			{
				_effectLoader.destroy();
				_effectLoader = null;
			}
			_mc = null;
			_panel = null;
		}
	}
}