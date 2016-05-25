package com.view.gameWindow.panel.panels.forge.extend
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.consts.EffectConst;
	import com.model.consts.StringConst;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.mainUi.subuis.income.IncomeDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.forge.McExtend;
	import com.view.gameWindow.panel.panels.forge.extend.select.ExtendSelectData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.cell.CellData;

	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * 强化转移面板点击处理类
	 * @author Administrator
	 */	
	public class ExtendClickHandle
	{
		private var _tab:TabExtend;
		private var _skin:McExtend;
		private var _selectType:int;
		private var _effectLoader:UIEffectLoader;
		
		private var _isExtended:Boolean;
		
		public function ExtendClickHandle(tab:TabExtend)
		{
			_tab = tab;
			_skin = _tab.skin as McExtend;
			init();
		}
		
		private function init():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _tab.cell0:
					dealCell0();
					break;
				case _tab.cell1:
					dealCell1();
					break;
				case _skin.btnMoveSP:
					dealSelect();
					break;
				case _skin.btnMoveRd:
					dealSelect();
					break;
				case _skin.btn:
					dealBtn();
					break;
				default:
					break;
			}
		}
		
		private function dealCell0():void
		{
			var filter:int = ExtendSelectData.filter;
			if(!filter)
			{
				Alert.warning(StringConst.EXTEND_PANEL_0018);
				return;
			}
			ExtendSelectData.cellData1 = null;
			_tab.extendCellHandle.refreshData();
			_tab.extendViewHandle.refresh();
			PanelMediator.instance.openPanel(PanelConst.TYPE_FORGE_EXTEND_SELECT);
			_isExtended = false;
		}
		
		private function dealCell1():void
		{
			var cellData1:CellData = ExtendSelectData.cellData1;
			if(!cellData1)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.EXTEND_PANEL_0015);
				return;
			}
			PanelMediator.instance.openPanel(PanelConst.TYPE_FORGE_EXTEND_SELECT);
		}
		
		private function dealSelect():void
		{
			var selectedSP:Boolean = _skin.btnMoveSP.selected as Boolean;
			var selectedRd:Boolean = _skin.btnMoveRd.selected as Boolean;
			if(selectedSP && selectedRd)
			{
				ExtendSelectData.filter = 1;
			}
			else if(selectedSP && !selectedRd)
			{
				ExtendSelectData.filter = 2;
			}
			else if(!selectedSP && selectedRd)
			{
				ExtendSelectData.filter = 3;
			}
			else
			{
				ExtendSelectData.filter = 0;
			}
			checkSatisfy(selectedSP,selectedRd);
			_tab.extendViewHandle.refresh();
			_tab.extendCellHandle.refreshData();
		}
		
		private function checkSatisfy(selectedSP:Boolean,selectedRd:Boolean):void
		{
			var cellData1:CellData = ExtendSelectData.cellData1;
			var cellData2:CellData = ExtendSelectData.cellData2;
			if(cellData1 && cellData1.memEquipData)
			{
				var memEquipData1:MemEquipData = cellData1.memEquipData;
				if(selectedSP && !memEquipData1.strengthen)
				{
					ExtendSelectData.cellData1 = null;
				}
				if(selectedRd && !memEquipData1.attrRdCount)
				{
					ExtendSelectData.cellData1 = null;
				}
				if(cellData2 && cellData2.memEquipData)
				{
					var memEquipData2:MemEquipData = cellData2.memEquipData;
					if(selectedSP && memEquipData1.strengthen < memEquipData2.strengthen || (memEquipData1.strengthen == memEquipData2.strengthen && memEquipData1.polish < memEquipData2.polish))
					{
						ExtendSelectData.cellData2 = null;
					}
					if(selectedRd && memEquipData1.attrRdCount > memEquipData2.attrRdCount)
					{
						ExtendSelectData.cellData2 = null;
					}
				}
			}
		}
		
		private function dealBtn():void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			var cellData1:CellData = ExtendSelectData.cellData1;
			var cellData2:CellData = ExtendSelectData.cellData2;
			if(!cellData1)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.EXTEND_PANEL_0012);
				return;
			}
			if(!cellData2)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.EXTEND_PANEL_0013);
				return;
			}
			var isCoinEnough:Boolean = _tab.extendViewHandle.isCoinEnough;
			if(!isCoinEnough)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.EXTEND_PANEL_0014.replace("&x",StringConst.GOLD_COIN));
				return;
			}
			if(_isExtended)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.EXTEND_PANEL_0016);
				return;
			}
			var filter:int = ExtendSelectData.filter;
			var memEquipData1:MemEquipData = MemEquipDataManager.instance.memEquipData(cellData1.bornSid,cellData1.id);
			var memEquipData2:MemEquipData = MemEquipDataManager.instance.memEquipData(cellData2.bornSid,cellData2.id);
			var equipCfgData2:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData2.baseId);
			if((filter == 1 || filter == 2) && memEquipData1 && memEquipData2 && memEquipData1.strengthen > equipCfgData2.strengthen)
			{
				var txt:String = StringConst.EXTEND_PANEL_0010.replace("&x",memEquipData1.strengthen).replace("&x",memEquipData2.strengthen);
				Alert.show(txt,sendData,null,null,null,"","left");
				return;
			}
			if((filter == 1 || filter == 3) && memEquipData1.attrRdStars < memEquipData2.attrRdStars)
			{
				txt = StringConst.EXTEND_PANEL_0019.replace("&x",memEquipData1.attrRdStars).replace("&x",memEquipData2.attrRdStars);
				Alert.show(txt,sendData,null,null,null,"","left");
				return;
			}
			sendData();
		}
		
		private function sendData():void
		{
			var filter:int = ExtendSelectData.filter;
			var cellData1:CellData = ExtendSelectData.cellData1;
			var cellData2:CellData = ExtendSelectData.cellData2;
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(cellData1.storageType);
			byteArray.writeByte(cellData1.slot);
			byteArray.writeByte(cellData2.storageType);
			byteArray.writeByte(cellData2.slot);
			byteArray.writeByte(filter);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_EQUIP_STRENGTHEN_MOVE,byteArray);
			showTip();
			addEffect();
			_isExtended = true;
		}
		/**显示系统提示及收益提示*/
		private function showTip():void
		{
			var costCoin:int = _tab.extendViewHandle.costCoin;
			if(costCoin)
			{
				var replace:String = StringConst.FORGE_PANEL_0008.replace(/&x/g,StringConst.GOLD_COIN).replace(/&y/,costCoin);
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,replace);
				IncomeDataManager.instance.addOneLine(replace);
			}
		}
		
		private function addEffect():void
		{
			if(!_effectLoader)
			{
				_effectLoader = new UIEffectLoader(_tab,592,0,1,1,EffectConst.RES_EXTEND_EXTEND,function ():void
				{
					var object:Object = {};
					object.timerId = setTimeout(function(object:Object):void
					{
						clearTimeout(object.timerId);
						if(_effectLoader)
						{
							_effectLoader.destroy();
							_effectLoader = null;
						}
					},1500,object);
				});
			}
		}
		
		public function destroy():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_1BTN_PROMPT);
			PanelMediator.instance.closePanel(PanelConst.TYPE_FORGE_EXTEND_SELECT);
			if(_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK,onClick);
				_skin = null;
			}
			if(_effectLoader)
			{
				_effectLoader.destroy();
				_effectLoader = null;
			}
			_tab = null;
		}

		public function set selectType(value:int):void
		{
			_selectType = value;
		}
	}
}