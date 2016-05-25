package com.view.gameWindow.panel.panels.forge.strengthen
{
	import com.model.configData.cfgdata.NpcShopCfgData;
	import com.model.consts.ConstProtect;
	import com.model.consts.ConstStorage;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.forge.McIntensify;
	import com.view.gameWindow.panel.panels.npcshop.NpcShopDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.UtilCostRollTip;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class StrengthenMouseEvent
	{
		private var _skin:McIntensify;
		private var _view:TabStrengthen;
		
		public function StrengthenMouseEvent()
		{
		}
		
		public function addEvent(skin:McIntensify,view:TabStrengthen):void
		{
			_view = view;
			_skin = skin;
			_skin.addEventListener(MouseEvent.CLICK,clickHandle);
			_view.skinThis.mcMaterialBuy.stone1AmountText.text = "1";
			_view.skinThis.mcMaterialBuy.stone2AmountText.text = "1";
		}
		
		public function clickHandle(evt:MouseEvent):void
		{
			switch (evt.target)
			{
				case _skin.btnSure:
				case _skin.keyStrengthenBtn:
					if (RoleDataManager.instance.stallStatue)
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
						return;
					}
				default :
					break;
			}
			switch(evt.target)
			{
				case _skin.btnRoleEquip:
					setSelected(_skin.btnRoleEquip);
					break;
				case _skin.btnHeroEquip:
					setSelected(_skin.btnHeroEquip);
					break;
				case _skin.btnBagItem:
					setSelected(_skin.btnBagItem);
					break;
				case _skin.lastPage:
					_view.strengthenHandle.onLastPageHandler();
					break;
				case _skin.nextPage:
					_view.strengthenHandle.onNextPageHandler();
					break;
				case _skin.mcUseProtect.protectSingleBtn:
					_view.strengthenHandle.onProtectedSingleHandler();
					break;
				case _skin.btnTabStrengthen:
					setModeSelected(_skin.btnTabStrengthen);
					_view.strengthenHandle.switchMode(StrengthenHandle.MODE_STRENGTHEN);
					break;
				case _skin.btnTabPolish:
					setModeSelected(_skin.btnTabPolish);
					_view.strengthenHandle.switchMode(StrengthenHandle.MODE_POLISH);
					break;
				case _skin.btnSure://强化
					var isProtect:int = _skin.mcUseProtect.protectSingleBtn.selected ? ConstProtect.USE : ConstProtect.NO_USE;
					var isUseGold:int = _skin.mcMaterialLack.goldBuyBtn.selected ? ConstProtect.USE : ConstProtect.NO_USE;
					_view.strengthenHandle.requestStrengthenOrPolish(isProtect,isUseGold);
					break;
				case _skin.keyStrengthenBtn:
					_view.strengthenHandle.keyPolishBtnHandler();
					break;
				case _skin.mcMaterialLack.goldBuyBtn:
					_view.strengthenHandle.updateGlod();
					break;
				case _skin.mcMaterialBuy.stone1UpBtn:
					onStoneAmountHanlder(_skin.mcMaterialBuy.stone1UpBtn);
					break;
				case _skin.mcMaterialBuy.stone1DownBtn:
					onStoneAmountHanlder(_skin.mcMaterialBuy.stone1DownBtn);
					break;
				case _skin.mcMaterialBuy.stone2UpBtn:
					onStoneAmountHanlder(_skin.mcMaterialBuy.stone2UpBtn);
					break;
				case _skin.mcMaterialBuy.stone2DownBtn:
					onStoneAmountHanlder(_skin.mcMaterialBuy.stone2DownBtn);
					break;
				case _skin.mcMaterialBuy.stone1BuyBtn:
					var totalPrice1:int = int(_view.skinThis.mcMaterialBuy.stone1AmountText.text)*int(_view.skinThis.mcMaterialBuy.stone1PriceText.text);
					var num:int = int(_view.skinThis.mcMaterialBuy.stone1AmountText.text);
					if(!UtilCostRollTip.costShopBuy(_view.stone1Icon.npcShopCfgData,num))//元宝
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR,UtilCostRollTip.str);
						return;
					}
					var itemCfg:NpcShopCfgData = _view.stone1Icon.npcShopCfgData;
					sendData(itemCfg,int(_view.skinThis.mcMaterialBuy.stone1AmountText.text));
					break;
				case _skin.mcMaterialBuy.stone2BuyBtn:
					var totalPrice2:int = int(_view.skinThis.mcMaterialBuy.stone2AmountText.text)*int(_view.skinThis.mcMaterialBuy.stone2PriceText.text);
					num = int(_view.skinThis.mcMaterialBuy.stone2AmountText.text);
					if(!UtilCostRollTip.costShopBuy(_view.stone2Icon.npcShopCfgData,num))//元宝
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR,UtilCostRollTip.str);
						return;
					}
					var itemCfg2:NpcShopCfgData = _view.stone2Icon.npcShopCfgData;
					sendData(itemCfg2,int(_view.skinThis.mcMaterialBuy.stone2AmountText.text));
					break;
			}
		}
		
		private function sendData(cfgDt:NpcShopCfgData,num:int):void
		{
			NpcShopDataManager.instance.cmNpcShopBuy(cfgDt.id,num,ConstStorage.ST_CHR_BAG);
		}
		
		private function onStoneAmountHanlder(mc:MovieClip):void
		{
			switch(mc)
			{
				case _view.skinThis.mcMaterialBuy.stone1UpBtn:
					_view.stone1Amount = _view.stone1Amount >= 99? 99: _view.stone1Amount+1;
					_view.skinThis.mcMaterialBuy.stone1AmountText.text = _view.stone1Amount.toString();
					_view.skinThis.mcMaterialBuy.stone3PriceText.text = int(_view.skinThis.mcMaterialBuy.stone1PriceText.text)*_view.stone1Amount + "";
					break;
				case _view.skinThis.mcMaterialBuy.stone1DownBtn:
					_view.stone1Amount = _view.stone1Amount <= 1? 1  : _view.stone1Amount-1;
					_view.skinThis.mcMaterialBuy.stone1AmountText.text = _view.stone1Amount.toString();
					_view.skinThis.mcMaterialBuy.stone3PriceText.text = int(_view.skinThis.mcMaterialBuy.stone1PriceText.text)*_view.stone1Amount + "";
					break;
				case _view.skinThis.mcMaterialBuy.stone2UpBtn:
					_view.stone2Amount = _view.stone2Amount >= 99? 99: _view.stone2Amount+1;
					_view.skinThis.mcMaterialBuy.stone2AmountText.text = _view.stone2Amount.toString();
					_view.skinThis.mcMaterialBuy.stone4PriceText.text = int(_view.skinThis.mcMaterialBuy.stone2PriceText.text)*_view.stone2Amount + "";
					break;
				case _view.skinThis.mcMaterialBuy.stone2DownBtn:
					_view.stone2Amount = _view.stone2Amount  <= 1? 1 : _view.stone2Amount-1;
					_view.skinThis.mcMaterialBuy.stone2AmountText.text = _view.stone2Amount.toString();
					_view.skinThis.mcMaterialBuy.stone4PriceText.text = int(_view.skinThis.mcMaterialBuy.stone2PriceText.text)*_view.stone2Amount + "";
					break;
			}
		}
		
		private function setSelected(mc:MovieClip):void
		{
			_skin.btnRoleEquip.selected = false;
			_skin.btnHeroEquip.selected = false;
			_skin.btnBagItem.selected = false;
			_skin.btnRoleEquip.txt.textColor = 0x675138;
			_skin.btnHeroEquip.txt.textColor = 0x675138;
			_skin.btnBagItem.txt.textColor = 0x675138;
			mc.selected = true;
			mc.txt.textColor = 0xffe1aa;	
		}
		
		private function setModeSelected(mc:MovieClip):void
		{
			_skin.btnTabStrengthen.selected = false;
			_skin.btnTabPolish.selected = false;
			_skin.btnTabStrengthen.txt.textColor = 0x675138;
			_skin.btnTabPolish.txt.textColor = 0x675138;
			mc.selected = true;
			mc.txt.textColor = 0xffe1aa;
		}
		
		public function destoryEvent():void
		{
			_skin.removeEventListener(MouseEvent.CLICK,clickHandle);
			_skin = null;
			_view = null;
		}
	}
}