package com.view.gameWindow.panel.panels.dungeonTower
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.NpcShopCfgData;
	import com.model.consts.ConstStorage;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.npcshop.NpcShopDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	/**
	 * 塔防副本购买令牌面板类
	 * @author Administrator
	 */	
	public class PanelDgnTowerBuy extends PanelBase
	{
		private const _npcShopIds:Vector.<int> = new <int>[54101,54102,54103,54104];
		private var _icons:Vector.<IconCellEx>;
		
		public function PanelDgnTowerBuy()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McDgnTowerBuy = new McDgnTowerBuy();
			_skin = skin;
			addChild(skin);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McDgnTowerBuy = _skin as McDgnTowerBuy;
			var i:int,l:int = _npcShopIds.length;
			for (i=0;i<l;i++) 
			{
				var btn:MovieClip = skin["mcItem"+i].btnBuy as MovieClip;
				rsrLoader.addCallBack(btn,dealSth(btn));
			}
			function dealSth(btn:MovieClip):Function
			{
				var func:Function = function(mc:MovieClip):void
				{
					setBuyItem(btn.theIndex);
				}
				return func;
			}
		}
		
		override protected function initData():void
		{
			var skin:McDgnTowerBuy = _skin as McDgnTowerBuy;
			setTitleBar(skin.mcDrag);
			//
			var defaultTextFormat:TextFormat = skin.txtTitle.defaultTextFormat;
			defaultTextFormat.bold = true;
			skin.txtTitle.defaultTextFormat = defaultTextFormat;
			skin.txtTitle.setTextFormat(defaultTextFormat);
			skin.txtTitle.text = StringConst.DGN_TOWER_0003;
			//
			_icons = new Vector.<IconCellEx>();
			var i:int,l:int = _npcShopIds.length;
			for (i=0;i<l;i++) 
			{
				setBuyItem(i);
			}
			//
			skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function setBuyItem(theIndex:int):void
		{
			var mcDgnTowerBuyItem:McDgnTowerBuyItem = skin["mcItem"+theIndex] as McDgnTowerBuyItem;
			var npcShopCfgData:NpcShopCfgData = ConfigDataManager.instance.npcShopCfgData1(_npcShopIds[theIndex]);
			if(!npcShopCfgData.itemCfgData)
			{
				trace("PanelDgnTowerBuy.setBuyItem(theIndex) 物品配置信息错误");
				return;
			}
			//
			mcDgnTowerBuyItem.btnBuy.theIndex = theIndex;
			//
			mcDgnTowerBuyItem.txtName.text = npcShopCfgData.itemCfgData.name;
			mcDgnTowerBuyItem.txtName.textColor = npcShopCfgData.itemCfgData.textColor;
			//
			var mcLayer:MovieClip = mcDgnTowerBuyItem.mcLayer;
			var icon:IconCellEx = new IconCellEx(mcLayer.parent,mcLayer.x,mcLayer.y,mcLayer.width,mcLayer.height);
			IconCellEx.setItem(icon,npcShopCfgData.type,npcShopCfgData.itemCfgData.id,0);
			ToolTipManager.getInstance().attach(icon);
			_icons.push(icon);
			//
			var pareseDesToStr:String = CfgDataParse.pareseDesToStr(npcShopCfgData.itemCfgData.desc_short);
			mcDgnTowerBuyItem.txtDesc.htmlText = pareseDesToStr;
			//
			mcDgnTowerBuyItem.txtCost.text = StringConst.KEY_BUY_PANEL_0009;
			//
			mcDgnTowerBuyItem.txtCostValue.text = npcShopCfgData.price_value+"";
			//
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0xffffff, 0);
			sp.graphics.drawRect(0, 0, mcDgnTowerBuyItem.mcMoneyIcon.width, mcDgnTowerBuyItem.mcMoneyIcon.height);
			sp.graphics.endFill();
			mcDgnTowerBuyItem.mcMoneyIcon.addChild(sp);
			ToolTipManager.getInstance().attachByTipVO(mcDgnTowerBuyItem.mcMoneyIcon,ToolTipConst.TEXT_TIP,HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_1));
			//
			mcDgnTowerBuyItem.txtAboveBtn.text = StringConst.KEY_BUY_PANEL_0010;
			mcDgnTowerBuyItem.txtAboveBtn.mouseEnabled = false;
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var skin:McDgnTowerBuy = _skin as McDgnTowerBuy;
			switch(event.target)
			{
				case skin.mcItem0.btnBuy:
				case skin.mcItem1.btnBuy:
				case skin.mcItem2.btnBuy:
				case skin.mcItem3.btnBuy:
					dealBuy(event.target.theIndex);
					break;
				case skin.btnClose:
					dealClose();
					break;
				default:
					break;
			}
		}
		
		private function dealBuy(theIndex:int):void
		{
			var gold:Number=BagDataManager.instance.goldUnBind;
			var npcShopId:int = _npcShopIds[theIndex];
			var npcShopCfgData:NpcShopCfgData = ConfigDataManager.instance.npcShopCfgData1(npcShopId);
			if(npcShopCfgData.price_value>gold)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.TIP_GOLD_NOT_ENOUGH);
				return;
			}
			NpcShopDataManager.instance.cmNpcShopBuy(npcShopId,1,ConstStorage.ST_CHR_BAG);
		}
		
		private function dealClose():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_TOWER_BUY);
		}
		
		override public function destroy():void
		{
			var i:int,l:int = _npcShopIds.length;
			for (i=0;i<l;i++) 
			{
				var mcDgnTowerBuyItem:McDgnTowerBuyItem = skin["mcItem"+i] as McDgnTowerBuyItem;
				ToolTipManager.getInstance().detach(mcDgnTowerBuyItem.mcMoneyIcon);
			}
			var icon:IconCellEx;
			for each (icon in _icons) 
			{
				icon.destroy();
				ToolTipManager.getInstance().detach(icon);
			}
			skin.removeEventListener(MouseEvent.CLICK,onClick);
			super.destroy();
		}
	}
}