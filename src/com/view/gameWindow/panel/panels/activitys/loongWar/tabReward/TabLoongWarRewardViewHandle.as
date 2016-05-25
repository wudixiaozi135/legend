package com.view.gameWindow.panel.panels.activitys.loongWar.tabReward
{
	import com.model.consts.FontFamily;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.panel.panels.activitys.loongWar.LoongWarDataManager;
	import com.view.gameWindow.panel.panels.activitys.loongWar.McLoongWarMouseLayer;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.cell.IconCellEx;
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	internal class TabLoongWarRewardViewHandle
	{
		private var _tab:TabLoongWarReward;
		private var _skin:McLoongWarReward;

		private var _modeHandle0:TabLoongWarRewardModeHandle;
		private var _modeHandle1:TabLoongWarRewardModeHandle;
		private var _modeHandle2:TabLoongWarRewardModeHandle;
		
		private var _cellsType:Dictionary;
		
		public function TabLoongWarRewardViewHandle(tab:TabLoongWarReward)
		{
			_tab = tab;
			_skin = tab.skin as McLoongWarReward;
			initialize();
		}
		
		private function initialize():void
		{
			_skin.txtRule.htmlText = HtmlUtils.createHtmlStr(_skin.txtRule.textColor,StringConst.LOONG_WAR_0032,12,false,2,FontFamily.FONT_NAME,true);
			ToolTipManager.getInstance().attachByTipVO(_skin.txtRule,ToolTipConst.TEXT_TIP,StringConst.LOONG_WAR_0065);
			_skin.txtBtnGet.text = StringConst.LOONG_WAR_0033;
			_skin.txtBtnGet.mouseEnabled = false;
			//
			_modeHandle0 = new TabLoongWarRewardModeHandle(_skin.mcLayer0,DataLoongWarReward.SCORE_RANK_0);
			_modeHandle1 = new TabLoongWarRewardModeHandle(_skin.mcLayer1,DataLoongWarReward.SCORE_RANK_1);
			_modeHandle2 = new TabLoongWarRewardModeHandle(_skin.mcLayer2,DataLoongWarReward.SCORE_RANK_2);
			//
			var k:int,l:int = 3;
			for (k=0;k<l;k++) 
			{
				var layer:McLoongWarMouseLayer = _skin["mcMouse"+k];
				var dtsReward:Dictionary = ActivityDataManager.instance.loongWarDataManager.dtsReward;
				var dt:DataLoongWarReward = dtsReward[k] as DataLoongWarReward;
				ToolTipManager.getInstance().attachByTipVO(layer,ToolTipConst.FASHION_TIP,dt.equipCfgData);
			}
			//
			_cellsType = new Dictionary();
			var i:int,il:int = 3;
			var j:int,jl:int = 4;
			for (i=0;i<il;i++) 
			{
				var cells:Vector.<IconCellEx> = new Vector.<IconCellEx>();
				for (j=0;j<jl;j++) 
				{
					var bg:MovieClip = _skin["mcReward"+i+j] as MovieClip;
					var cell:IconCellEx = new IconCellEx(_skin,bg.x,bg.y,bg.width,bg.height);
					cells.push(cell);
				}
				_cellsType[i] = cells;
			}
		}
		
		public function update():void
		{
			_modeHandle0.changeModel();
			_modeHandle1.changeModel();
			_modeHandle2.changeModel();
			//
			updatebtnEnabled();
			//
			var manager:LoongWarDataManager = ActivityDataManager.instance.loongWarDataManager;
			var dts:Dictionary = manager.dtsReward;
			var dt:DataLoongWarReward;
			for each (dt in dts)
			{
				_skin["txtOwner"+dt.scoreRank].text = dt.familyName ? StringConst.LOONG_WAR_0028 + dt.familyName : "";
				var cells:Vector.<IconCellEx> = _cellsType[dt.scoreRank] as Vector.<IconCellEx>;
				var i:int,l:int = cells.length;
				for (i=0;i<l;i++) 
				{
					IconCellEx.setItemByThingsData(cells[i],dt.loongWarRewardDts[i]);
					ToolTipManager.getInstance().attach(cells[i]);
				}
			}
			//
			if(manager.isTheGuildOccupy)
			{
				_skin.txtTip.text = StringConst.LOONG_WAR_0029;
			}
			else if(manager.isTheGuildFirst)
			{
				_skin.txtTip.text = StringConst.LOONG_WAR_0030 + StringConst.LOONG_WAR_00301;
			}
			else if(manager.isTheGuildSecond)
			{
				_skin.txtTip.text = StringConst.LOONG_WAR_0030 + StringConst.LOONG_WAR_00302;
			}
			else
			{
				_skin.txtTip.text = StringConst.LOONG_WAR_0031;
			}
		}
		
		internal function updatebtnEnabled():void
		{
			var manager:LoongWarDataManager = ActivityDataManager.instance.loongWarDataManager;
			var isCanGet:Boolean = manager.isFashionGet == 1 || manager.isRewardGet == 1;
			_skin.btnGet.btnEnabled = isCanGet;
		}
		
		public function destroy():void
		{
			var k:int,l:int = 3;
			for (k=0;k<l;k++) 
			{
				var layer:McLoongWarMouseLayer = _skin["mcMouse"+k];
				ToolTipManager.getInstance().detach(layer);
			}
			ToolTipManager.getInstance().detach(_skin.txtRule);
			var cells:Vector.<IconCellEx>;
			for each (cells in _cellsType)
			{
				var cell:IconCellEx;
				for each (cell in cells)
				{
					ToolTipManager.getInstance().attach(cell);
					cell.destroy();
				}
			}
			_cellsType = null;
			if(_modeHandle0)
			{
				_modeHandle0.destroy();
				_modeHandle0 = null;
			}
			if(_modeHandle1)
			{
				_modeHandle1.destroy();
				_modeHandle1 = null;
			}
			if(_modeHandle2)
			{
				_modeHandle2.destroy();
				_modeHandle2 = null;
			}
			_skin = null;
			_tab = null;
		}
	}
}