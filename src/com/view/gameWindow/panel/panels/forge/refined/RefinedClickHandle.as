package com.view.gameWindow.panel.panels.forge.refined
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.consts.ConstStorage;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.mainUi.subuis.income.IncomeDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.cell.CellData;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * 锻造进阶面板点击处理类
	 * @author Administrator
	 */	
	public class RefinedClickHandle
	{
		private var _tab:TabRefined;
		private var _skin:McRefined;
		
		internal var selectMain:CellData;
		internal var selectSubstitute:CellData;
		
		internal var attrSelectIndex:int = -1;
		
		public function RefinedClickHandle(tab:TabRefined)
		{
			_tab = tab;
			_skin = _tab.skin as McRefined;
			initialize();
		}
		
		private function initialize():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _skin.btnSure:
					dealRefined();
					break;
				default:
					dealDefault(event);
					break;
			}
		}
		/**处理点击升阶按钮*/
		private function dealRefined():void
		{
			if(!selectMain)
			{
				Alert.warning(StringConst.REFINED_PANEL_0003);
				return;
			}
			if(!selectSubstitute)
			{
				Alert.warning(StringConst.REFINED_PANEL_0004);
				return;
			}
			if(attrSelectIndex == -1)
			{
				Alert.warning(StringConst.REFINED_PANEL_0005);
				return;
			}
			if(!_tab.viewHandle.isCoinEnough)
			{
				Alert.warning(StringConst.REFINED_PANEL_0006);
				return;
			}
			showTip();
			//
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(selectMain.storageType);
			byteArray.writeByte(selectMain.slot);
			byteArray.writeByte(selectSubstitute.storageType);
			byteArray.writeByte(selectSubstitute.slot);
			byteArray.writeByte(attrSelectIndex);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_EQUIP_BAPTIZE,byteArray);
			substituteSetNull();
		}
		/**显示系统提示及收益提示*/
		private function showTip():void
		{
			var coin:String = _skin.txtCostValue.text;
			var replace:String = StringConst.FORGE_PANEL_0008.replace(/&x/g,StringConst.FORGE_PANEL_0006).replace(/&y/,coin);
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,replace);
			IncomeDataManager.instance.addOneLine(replace);
		}
		
		protected function dealDefault(event:MouseEvent):void
		{
			var attrSelect:McRefinedBtnSelect = (event.target as DisplayObject).parent as McRefinedBtnSelect;
			if(attrSelect)
			{
				dealAttrSelect(attrSelect);
				return;
			}
			var mcEquipItem:McEquipItem = event.target as McEquipItem || (event.target as DisplayObject).parent as McEquipItem;
			if(mcEquipItem)
			{
				dealEquipSelect(mcEquipItem);
				return;
			}
			var cell:RefinedCell = event.target as RefinedCell;
			if(cell)
			{
				dealEquipRemove(cell.cellData);
			}
		}
		
		private function dealAttrSelect(attrSelect:McRefinedBtnSelect):void
		{
			if(attrSelectIndex != -1)
			{
				var btnSelect:McRefinedBtnSelect = _skin["mcSelect"+attrSelectIndex] as McRefinedBtnSelect;
				if(btnSelect)
				{
					btnSelect.btn.selected = false;
					btnSelect.btn.mouseChildren = true;
					btnSelect.btn.mouseEnabled = true;
				}
			}
			if(attrSelect)
			{
				attrSelect.btn.mouseChildren = false;
				attrSelect.btn.mouseEnabled = false;
				attrSelectIndex = attrSelect.theIndex as int;
			}
		}
		
		private function dealEquipRemove(dt:CellData):void
		{
			if(dt)
			{
				if(selectMain && selectMain.id == dt.id)
				{
					selectMain = null;
					_skin.mcSelectEffect.visible = false;
					_tab.viewHandle.update();
				}
				else if(selectSubstitute && selectSubstitute.id == dt.id)
				{
					substituteSetNull();
					attrSelectIndex = -1;
					_tab.viewHandle.update();
				}
			}
		}
		
		private function dealEquipSelect(mcEquipItem:McEquipItem):void
		{
			var index:int = int(mcEquipItem.name.slice(mcEquipItem.name.length-1));
			var cell:RefinedCell = _tab.cellHandle.cells[index];
			if(cell && cell.cellData)
			{
				var dt:CellData = cell.cellData;
				if(dt.storageType == ConstStorage.ST_CHR_EQUIP || dt.storageType == ConstStorage.ST_HERO_EQUIP)
				{
					selectMain = dt;
					_skin.mcSelectEffect.y = mcEquipItem.y;
					_skin.mcSelectEffect.visible = true;
					_tab.viewHandle.update();
				}
				else if(dt.storageType == ConstStorage.ST_CHR_BAG)
				{
					if(selectMain)
					{
						if(dt == selectMain)
						{
							Alert.warning(StringConst.REFINED_PANEL_0007);
						}
						else
						{
							var isSameEquipType:Boolean = isSameType(dt,selectMain);
							if(!isSameEquipType)
							{
								Alert.warning(StringConst.REFINED_PANEL_0001);
							}
							else
							{
								selectSubstitute = dt;
								_tab.viewHandle.update();
							}
						}
					}
					else
					{
						if(selectSubstitute && selectSubstitute == dt)
						{
							substituteSetNull();
						}
						selectMain = dt;
						_skin.mcSelectEffect.y = mcEquipItem.y;
						_skin.mcSelectEffect.visible = true;
						_tab.viewHandle.update();
					}
				}
				if(selectMain && selectSubstitute && !isSameType(selectMain,selectSubstitute))
				{
					substituteSetNull();
					_tab.viewHandle.update();
				}
				_tab.cellHandle.refreshSign();
			}
		}
		
		private function isSameType(dt1:CellData,dt2:CellData):Boolean
		{
			var boolean1:Boolean = dt1 && dt1.memEquipData && dt1.memEquipData.equipCfgData;
			var boolean2:Boolean = dt2 && dt2.memEquipData && dt2.memEquipData.equipCfgData;
			if(boolean1 && boolean2)
			{
				var type1:int = dt1.memEquipData.equipCfgData.type;
				var type2:int = dt2.memEquipData.equipCfgData.type;
				return type1 == type2;
			}
			return false;
		}
		
		public function substituteSetNull():void
		{
			selectSubstitute = null;
			dealAttrSelect(null);
			attrSelectIndex = -1;
		}
		
		public function destroy():void
		{
			selectMain = null;
			substituteSetNull();
			if(_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK,onClick);
				_skin = null;
			}
			_tab = null;
		}
	}
}