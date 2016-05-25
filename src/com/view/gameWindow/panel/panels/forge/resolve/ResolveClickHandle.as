package com.view.gameWindow.panel.panels.forge.resolve
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.consts.EffectConst;
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.income.IncomeDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.forge.ForgeDataManager;
	import com.view.gameWindow.panel.panels.forge.McResolve;
	import com.view.gameWindow.panel.panels.prompt.Panel1BtnPromptData;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.UIEffectLoader;
	
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * 锻造分解面板点击处理类
	 * @author Administrator
	 */	
	public class ResolveClickHandle
	{
		private var _panel:TabResolve;
		private var _mc:McResolve;
		private var _effectLoader:UIEffectLoader;
		
		public function ResolveClickHandle(panel:TabResolve)
		{
			_panel = panel;
			_mc = _panel.skin as McResolve;
			init();
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
					dealResolve();
					break;
			}
		}
		
		private function dealResolve():void
		{
			var selectResolveData:BagData = ForgeDataManager.instance.selectResolveData;
			var timer2Id:uint;
			if(!selectResolveData)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.RESOLVE_PANEL_0004);
				return;
			}
			var replace:String;
			var costType:int,costValue:int,isEnough:Boolean;
			costType = _panel.resolveViewHandle.costType;
			costValue = _panel.resolveViewHandle.costValue;
			isEnough = _panel.resolveViewHandle.isEnough;
			if(costType == 0)
			{
				if(!isEnough)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.RESOLVE_PANEL_0005);
					return;
				}
				replace = StringConst.FORGE_PANEL_0008.replace(/&x/g,StringConst.FORGE_PANEL_0006).replace(/&y/,costValue);
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,replace);
				IncomeDataManager.instance.addOneLine(replace);
			}
			else if(costType == 1)
			{
				if(!isEnough)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.RESOLVE_PANEL_0006);
					return;
				}
				replace = StringConst.FORGE_PANEL_0008.replace(/&x/g,StringConst.FORGE_PANEL_0007).replace(/&y/,costValue);
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,replace);
				IncomeDataManager.instance.addOneLine(replace);
			}
			else if(costType == 2)
			{
				replace = StringConst.FORGE_PANEL_0008.replace(/&x/g,StringConst.FORGE_PANEL_0007).replace(/&y/,costValue);
				Panel1BtnPromptData.strName = StringConst.RESOLVE_PANEL_0007;
				Panel1BtnPromptData.strContent = StringConst.RESOLVE_PANEL_0008;
				Panel1BtnPromptData.strBtn = StringConst.RESOLVE_PANEL_0009;
				Panel1BtnPromptData.funcBtn = function(infos:Array):void
				{
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,infos[1]);
					IncomeDataManager.instance.addOneLine(infos[1]);
					sendData(infos[0]);
				};
				Panel1BtnPromptData.funcBtnParam = [selectResolveData,replace];
				PanelMediator.instance.switchPanel(PanelConst.TYPE_1BTN_PROMPT);
				return;
			}
			if(!_effectLoader)
			{
				_effectLoader = new UIEffectLoader(_panel,58,58,1,1,EffectConst.RES_RESOLVING);
			}
			var object:Object = new Object();
			object.timerId = setTimeout(function(object:Object):void
			{
				clearTimeout(object.timerId);
				_effectLoader.destroy();
				_effectLoader = null;
				_effectLoader = new UIEffectLoader(_panel,375,18,1,1,EffectConst.RES_RESOLVE_SUCCESS);
			},1500,object);
			object.timer2Id = setTimeout(function(object:Object):void
			{
				if(_effectLoader)
				{
					clearTimeout(object.timer2Id);
					_effectLoader.destroy();
					_effectLoader = null;
				}
			},3000,object);
			sendData(selectResolveData);
		}
		
		private function sendData(selectResolveData:BagData):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(selectResolveData.storageType);
			byteArray.writeByte(selectResolveData.slot);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_EQUIP_DISASSEMBLE,byteArray);
		}
		
		public function destory():void
		{
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.CLICK,clickHandle);
				_mc = null;
			}
			if(_effectLoader)
			{
				_effectLoader.destroy();
				_effectLoader = null;
			}
			_panel = null;
		}
	}
}