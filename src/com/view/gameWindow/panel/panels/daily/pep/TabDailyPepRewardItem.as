package com.view.gameWindow.panel.panels.daily.pep
{
	import com.model.configData.cfgdata.DailyVitRewardCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;

	/**
	 * 日常活跃度奖励项
	 * @author Administrator
	 */	
	internal class TabDailyPepRewardItem
	{
		private var _order:int;
		private var _skin:McDailyPepRewardItem;
		private var _cells:Vector.<IconCellEx>;
		private var _awardNum:int = 0;
		
		public function TabDailyPepRewardItem(skin:McDailyPepRewardItem,order:int)
		{
			_order = order;
			_skin = skin;
			_skin.mouseEnabled = false;
			init();
		}
		
		private function init():void
		{
			_skin.mcMaskbtn.mouseEnabled = false;
			_skin.txtPepNeed0.text = StringConst.DAILY_PANEL_0015;
			_skin.txtPepNeed1.text = StringConst.DAILY_PANEL_0016;
			_skin.txtBtn.mouseEnabled = false;
			var manager:DailyDataManager = DailyDataManager.instance;
			var cfgDt:DailyVitRewardCfgData = manager.getDailyVitRewardCfgData(_order);
			if(cfgDt)
			{
				_skin.txtPepNeedValue.text = cfgDt.daily_vit+"";
				var isRewardCanGet:Boolean = manager.isRewardCanGet(_order);
				var isRewardGetted:Boolean = manager.isRewardGetted(_order);
				_skin.txtPepNeedValue.textColor = isRewardCanGet || isRewardGetted ? 0x53b436 : 0xff0000;
				//
				_cells = new Vector.<IconCellEx>(3,true);
				var dts:Vector.<ThingsData>,i:int,l:int;
				dts = UtilItemParse.getThingsDatas(cfgDt.item);
				l = dts.length;
				_awardNum = dts.length;
				for(i=0;i<l;i++)
				{
					var bg:MovieClip = _skin["mcIcon"+i] as MovieClip;
					var cell:IconCellEx = new IconCellEx(bg.parent,bg.x,bg.y,bg.width,bg.height);
					IconCellEx.setItemByThingsData(cell,dts[i]);
					ToolTipManager.getInstance().attach(cell);
					_cells[i] = cell;
				}
			}
			else
			{
				trace("TabDailyPepRewardItem.init DailyVitRewardCfgData配置信息不存在");
			}
		}
		
		internal function refersh():void
		{
			var manager:DailyDataManager = DailyDataManager.instance;
			//
			_skin.mcMaskbtn.visible = true;
			if(!manager.isRewardCanGet(_order))
			{
				_skin.txtBtn.text = StringConst.DAILY_PANEL_0014;
				_skin.mcMaskbtn.btn.mouseEnabled = false;
			}
			else
			{
				if(manager.isRewardGetted(_order))
				{
					_skin.txtBtn.text = StringConst.DAILY_PANEL_0018;
					_skin.mcMaskbtn.btn.mouseEnabled = false;
					_skin.mcMaskbtn.visible = false;
				}
				else
				{
					_skin.txtBtn.text = StringConst.DAILY_PANEL_0017;
					_skin.mcMaskbtn.btn.mouseEnabled = true;
				}
			}
			//
			var cfgDtPrev:DailyVitRewardCfgData = manager.getDailyVitRewardCfgData(_order-1);
			var start:int = cfgDtPrev ? cfgDtPrev.daily_vit : 0;
			var cfgDt:DailyVitRewardCfgData = manager.getDailyVitRewardCfgData(_order);
			var scaleX:Number = (manager.vit_today_total - start)/(cfgDt.daily_vit - start);
			scaleX = scaleX < 0 ? 0 : (scaleX > 1 ? 1 : scaleX);
			_skin.mcMaskbtn.mcMask.scaleX = scaleX;
		}
		
		internal function onClick(item:TabDailyPepRewardItem):void
		{
			var manager:DailyDataManager = DailyDataManager.instance;
			if(!manager.isRewardCanGet(_order))
			{
				/*RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DAILY_PANEL_0001);*/
				trace("TabDailyPepRewardItem onClick 未达成");
				return;
			}
			if(BagDataManager.instance.remainCellNum == 0)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0029);	
				return;
			}
			FlyEffectMediator.instance.doFlyReceiveThings2(getAwardIcon());
			manager.requestGetDailyVitTotalReward(_order);
		}
		private function getAwardIcon():Array
		{
			var cell:IconCellEx;
			var data:Array = [];
			var bitmap:Bitmap;
			for each(cell in _cells)
			{
				if(cell)
				{
					bitmap =Bitmap(cell.getChildAt(0));	
					data.push(bitmap);
				}
			}
			return data;
		}
		internal function destroy():void
		{
			var cell:IconCellEx;
			for each(cell in _cells)
			{
				if(cell)
				{
					ToolTipManager.getInstance().detach(cell);
					cell.destroy();
				}
			}
			_cells = null;
			_skin = null;
		}
	}
}