package com.view.gameWindow.panel.panels.forge.compound
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.consts.ConstStorage;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.forge.McCompound;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;

	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class CompoundMouseEvent
	{
		private var _tab:TabCompound;
		private var _skin:McCompound;
		
		public function CompoundMouseEvent(tabCompound:TabCompound)
		{
			_tab = tabCompound;
		}
		
		public function addEvent(mc:McCompound):void
		{
			_skin = mc;
			_skin.addEventListener(MouseEvent.CLICK,clickHandle);
			_skin.txtCount.addEventListener(FocusEvent.FOCUS_OUT,onKeyFunc);
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			if (evt.target == _skin.btnSure)
			{
				if (RoleDataManager.instance.stallStatue)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
					return;
				}
			}
			switch(evt.target)
			{
				case _skin.addBtn:
					_tab.clickOnAddFunc();
					break;
				case _skin.reduceBtn:
					_tab.clickOnReduce();
					break;
				case _skin.btnSure:
					compoundHandler();
					break;
				case _skin.chooseBtn:
					showCombineMaterialHandler();
					break;
				default:
					break;
			}
		}
		
		private function onKeyFunc(event:FocusEvent):void
		{
			_tab.checkComPoundCount();
		}
		
		/**开始合成*/
		private function compoundHandler():void
		{
			var coin:int;
			var unbindGold:int;
			var needCoin:int;
			var needUnbindGold:int;
			//当前已有的该材料的数量
			var matrial1Num:int;
			var matrial2Num:int;
			var matrial3Num:int;
			var allMatrialNum:int;
			//
			if(!_tab.currentCfgDt)
			{
				Alert.warning(StringConst.FORGE_PANEL_0028);
				return;
			}
			var manager:BagDataManager = BagDataManager.instance;
			coin = manager.coinBind+manager.coinUnBind;
			unbindGold = manager.goldUnBind;
			needCoin = int(_skin.coinTxt.text);
			needUnbindGold = int(_skin.unbindGoldTxt.text);
			if(coin<needCoin)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.FORGE_PANEL_0012);
				return;
			}
			if(unbindGold<needUnbindGold)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.FORGE_PANEL_0013);
				return;
			}
			if(_tab.compoundType == -1)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.FORGE_PANEL_0014);
				return;
			}
			sendReviveData(_tab.compoundType,_tab.isUseBag);
		}
		/**请求合成*/
		private function sendReviveData(compoundType:int,isUseBag:Boolean):void
		{
			var i:int;
			var slot:int;
			var bagType:int;
			var matrialCellNum:int;
			var bagCellVec:Vector.<BagData>;
			var count:int= int(_skin.txtCount.text);
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(_tab.currentCfgDt.id);
			byteArray.writeInt(count);
			var bagManager:BagDataManager = BagDataManager.instance;
			var heroManager:HeroDataManager = HeroDataManager.instance;
			//材料一部分
			if(isUseBag)
			{
				bagType=ConstStorage.ST_CHR_BAG;
				bagCellVec = bagManager.getItemVectorById(_tab.currentCfgDt.material1_id,compoundType);
			}
			else
			{
				bagType=ConstStorage.ST_HERO_BAG;
				bagCellVec = heroManager.getItemsNumById(_tab.currentCfgDt.material1_id,compoundType);
			}
			matrialCellNum=bagCellVec.length;
			byteArray.writeByte(matrialCellNum);
			for(i=0;i<matrialCellNum;i++)
			{
				slot=bagCellVec[i].slot;
				byteArray.writeByte(bagType);
				byteArray.writeByte(slot);
			}
			//材料二部分
			if(isUseBag)
			{
				bagType=ConstStorage.ST_CHR_BAG;
				bagCellVec = bagManager.getItemVectorById(_tab.currentCfgDt.material2_id,compoundType);
			}
			else
			{
				bagType=ConstStorage.ST_HERO_BAG;
				bagCellVec = heroManager.getItemsNumById(_tab.currentCfgDt.material2_id,compoundType);
			}
			matrialCellNum = bagCellVec.length;
			byteArray.writeByte(matrialCellNum);
			for(i=0;i<matrialCellNum;i++)
			{
				slot = bagCellVec[i].slot;
				byteArray.writeByte(bagType);
				byteArray.writeByte(slot);
			}
			//材料三部分
			if(isUseBag)
			{
				bagType=ConstStorage.ST_CHR_BAG;
				bagCellVec = bagManager.getItemVectorById(_tab.currentCfgDt.material3_id,compoundType);
			}
			else
			{
				bagType=ConstStorage.ST_HERO_BAG;
				bagCellVec = heroManager.getItemsNumById(_tab.currentCfgDt.material3_id,compoundType);
			}
			matrialCellNum=bagCellVec.length;
			byteArray.writeByte(matrialCellNum);
			for(i=0;i<matrialCellNum;i++)
			{
				slot=bagCellVec[i].slot;
				byteArray.writeByte(bagType);
				byteArray.writeByte(slot);
			}
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_COMBINE,byteArray);
		}
		
		private function showCombineMaterialHandler():void
		{
			Alert.warning(StringConst.PROMPT_PANEL_0007);
			_tab.isShowCombine = !_tab.isShowCombine;
			//addSigns();
		}
		
		public function destoryEvent():void
		{
			_skin.txtCount.removeEventListener(FocusEvent.FOCUS_OUT,onKeyFunc);
			_skin.removeEventListener(MouseEvent.CLICK,clickHandle);
			_skin = null;
			_tab = null;
		}
	}
}