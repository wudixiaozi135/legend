package com.view.gameWindow.panel.panels.forge.degree
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.mainUi.subuis.income.IncomeDataManager;
	import com.view.gameWindow.panel.panels.forge.McUpDegree;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.cell.CellData;
	
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * 锻造进阶面板点击处理类
	 * @author Administrator
	 */	
	public class DegreeClickHandle
	{
		private var _panel:TabDegree;
		private var _mc:McUpDegree;
		
		public function DegreeClickHandle(panel:TabDegree)
		{
			_panel = panel;
			_mc = _panel.skin as McUpDegree;
			init();
		}
		
		public function destroy():void
		{
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.CLICK,clickHandle);
				_mc = null;
			}
			_panel = null;
		}
		
		private function init():void
		{
			_mc.addEventListener(MouseEvent.CLICK,clickHandle);
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			switch(evt.target)
			{
				case _mc.btnSure:
					dealDegree();
					break;
				case _mc.btnUseYB:
					dealUseYB();
					break;
			}
		}
		/**处理点击升阶按钮*/
		private function dealDegree():void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			var select:CellData = _panel.degreeCellHandle.select;
			if(!select)
			{
				Alert.warning(StringConst.DEGREE_PANEL_0012);
				return;
			}
			if(_panel.degreeViewHandle.isNextLvOut == 1)
			{
				Alert.warning(StringConst.DEGREE_PANEL_0011);
				return;
			}
			else if(_panel.degreeViewHandle.isNextLvOut == 2)
			{
				Alert.warning(StringConst.DEGREE_PANEL_0013);
				return;
			}
			if(!_panel.degreeViewHandle.isMaterialsEnough)
			{
				if(_mc.btnUseYB.selected)
				{
					if(!_panel.degreeViewHandle.isYBEnough)
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DEGREE_PANEL_0009);
						return;
					}
				}
				else
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DEGREE_PANEL_0008);
					return;
				}
			}
			if(!_panel.degreeViewHandle.isJBEnough)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DEGREE_PANEL_0010);
				return;
			}
			showTip();
			//
			select = _panel.degreeCellHandle.select;
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(select.storageType);
			byteArray.writeByte(select.slot);
			var isUseGold:int = int(_mc.btnUseYB.selected);
			byteArray.writeByte(isUseGold);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_EQUIP_UPGRADE,byteArray);
		}
		/**显示系统提示及收益提示*/
		private function showTip():void
		{
			var coin:String = _mc.txtJBValue.text;
			var replace:String = StringConst.FORGE_PANEL_0008.replace(/&x/g,StringConst.FORGE_PANEL_0006).replace(/&y/,coin);
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,replace);
			IncomeDataManager.instance.addOneLine(replace);
		}
		
		private function dealUseYB():void
		{
			_panel.degreeViewHandle.refreshYBTxt(_mc.btnUseYB.selected);
		}
	}
}