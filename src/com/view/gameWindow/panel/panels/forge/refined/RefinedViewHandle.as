package com.view.gameWindow.panel.panels.forge.refined
{
	import com.model.configData.cfgdata.EquipRefinedCostCfgData;
	import com.model.consts.StringConst;
	import com.model.gameWindow.mem.AttrRandomData;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.cell.CellData;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	import com.view.gameWindow.util.propertyParse.PropertyData;
	
	import flash.display.MovieClip;

	public class RefinedViewHandle implements IObserver
	{
		private var _tab:TabRefined;
		private var _skin:McRefined;

		private var _cellMain:RefinedCell;
		private var _cellSubstitute:RefinedCell;
		
		private const _strMain:String = "Main",_strSubstitute:String = "Substitute";
		
		public function RefinedViewHandle(tab:TabRefined)
		{
			_tab = tab;
			_skin = _tab.skin as McRefined;
			initialize();
			//
			MemEquipDataManager.instance.attach(this);
		}
		
		private function initialize():void
		{
			_skin.txtBtn.text = StringConst.FORGE_PANEL_00016;
			_skin.txtBtn.mouseEnabled = false;
			_skin.txtCost.text = StringConst.FORGE_PANEL_0027;
			//
			var mcMain:MovieClip = _skin.mcMain;
			_cellMain = new RefinedCell(mcMain,mcMain.x,mcMain.y,mcMain.width,mcMain.height);
			ToolTipManager.getInstance().attach(_cellMain);
			var mcSubstitute:MovieClip = _skin.mcSubstitute;
			_cellSubstitute = new RefinedCell(mcSubstitute,mcSubstitute.x,mcSubstitute.y,mcSubstitute.width,mcSubstitute.height);
			ToolTipManager.getInstance().attach(_cellSubstitute);
			//
			var i:int,l:int = 6;
			for(i=0;i<l;i++)
			{
				_skin["mcMainValue"+i].visible = false;
				_skin["mcSubstituteValue"+i].visible = false;
				_skin["mcSelect"+i].visible = false;
				_skin["mcSelect"+i].mouseEnabled = false;
			}
		}
		
		internal function get isCoinEnough():Boolean
		{
			var manager:BagDataManager = BagDataManager.instance;
			var coin:int = manager.coinBind+manager.coinUnBind;
			var coinNeed:int = int(_skin.txtCostValue.text);
			return coin >= coinNeed;
		}
		
		public function update(proc:int=0):void
		{
			if(_tab && _tab.clickHandle && _tab.viewHandle && _tab.cellHandle)
			{
				updateMain();
				updateSubstitute();
				updateCost();
			}
		}
		
		private function updateMain():void
		{
			var selectMain:CellData = _tab.clickHandle.selectMain;
			var memEquipData:MemEquipData = selectMain ? selectMain.memEquipData : null;
			selectMain ? _cellMain.refreshData(selectMain) : _cellMain.setNull();
			updateEquip(memEquipData,_strMain);
		}
		
		private function updateSubstitute():void
		{
			var selectSubstitute:CellData = _tab.clickHandle.selectSubstitute;
			var memEquipData:MemEquipData = selectSubstitute ? selectSubstitute.memEquipData : null;
			selectSubstitute ? _cellSubstitute.refreshData(selectSubstitute) : _cellSubstitute.setNull();
			updateEquip(memEquipData,_strSubstitute);
		}
		
		private function updateEquip(memEquipData:MemEquipData,str:String):void
		{
			var i:int,l:int = 6;
			for (i=0;i<l;i++)
			{
				if(memEquipData)
				{
					var attrRdCount:int = memEquipData.attrRdCount;
					if(i < attrRdCount)
					{
						var attrRdDt:AttrRandomData = memEquipData.attrRdDt(i);
						var attrDt:PropertyData = attrRdDt ? attrRdDt.attrDt : null;
						if(attrRdDt && attrDt)
						{
							var text:String = CfgDataParse.propertyToStr(attrDt,2,0xffcc00,0xffcc00);
							_skin["txt"+str+i].htmlText = text;
							_skin["txt"+str+"Value"+i].text = attrRdDt.star+"";
							_skin["txt"+str+"Value"+i].textColor = attrRdDt.starColor;
							var ceil:Number = Math.ceil(attrRdDt.star/3);
							_skin["mc"+str+"Value"+i].gotoAndStop(ceil);
							_skin["mc"+str+"Value"+i].visible = true;
							if(str == _strSubstitute)
							{
								_skin["mcSelect"+i].visible = true;
								_skin["mcSelect"+i].theIndex = i;
							}
						}
						else
						{
							clear(StringConst.REFINED_PANEL_0002);
						}
					}
					else
					{
						clear("");
					}
				}
				else
				{
					clear("");
				}
			}
			function clear(text:String):void
			{
				_skin["txt"+str+i].htmlText = text;
				_skin["txt"+str+"Value"+i].text = "";
				_skin["mc"+str+"Value"+i].visible = false;
				str == _strSubstitute ? _skin["mcSelect"+i].visible = false : null;
			}
		}
		
		private function updateCost():void
		{
			var selectMain:CellData = _tab.clickHandle.selectMain;
			if(selectMain && selectMain.memEquipData && selectMain.memEquipData.equipRefinedCostCfgData)
			{
				var costCfgDt:EquipRefinedCostCfgData = selectMain.memEquipData.equipRefinedCostCfgData;
				var coin:int = costCfgDt.coin;
				_skin.txtCostValue.text = coin+"";
			}
			else
			{
				_skin.txtCostValue.text = "";
			}
		}
		
		public function destory():void
		{
			MemEquipDataManager.instance.detach(this);
			if(_cellSubstitute)
			{
				ToolTipManager.getInstance().detach(_cellSubstitute);
				_cellSubstitute.destroy();
				_cellSubstitute = null;
			}
			if(_cellMain)
			{
				ToolTipManager.getInstance().detach(_cellMain);
				_cellMain.destroy();
				_cellMain = null;
			}
			_skin = null;
			_tab = null;
		}
	}
}