package com.view.gameWindow.panel.panels.npcshop
{
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.mainUi.subuis.lasting.LastingDataMananger;
	import com.view.gameWindow.mainUi.subuis.lasting.LastingHandler;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UtilMouse;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.utils.StringUtil;
	
	/**
	 * NPC商店面板类
	 * @author Administrator
	 */	
	public class PanelNpcShop extends PanelBase implements IPanelNpcShop
	{
		private var _panelNpcShopClickHandle:PanelNpcShopClickHandle;
		private var _panelNpcShopItemBoxHandle:PanelNpcShopItemBoxHandle;
		
		public function PanelNpcShop()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			_skin = new McPanelNpcShop();
			addChild(_skin);
			setTitleBar((_skin as McPanelNpcShop).mcTitleBar);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var mcNpcShop:McPanelNpcShop;
			mcNpcShop = _skin as McPanelNpcShop;
			rsrLoader.addCallBack(mcNpcShop.btnPurchase,function (mc:MovieClip):void
			{
				mcNpcShop.btnPurchase.selected = true;
				mcNpcShop.btnPurchase.mouseEnabled = false;
				var textField:TextField = mcNpcShop.btnPurchase.txt as TextField;
				textField.text = StringConst.NPC_SHOP_PANEL_0002;
				textField.textColor = 0xffe1aa;
			});
			rsrLoader.addCallBack(mcNpcShop.btnBuy,function (mc:MovieClip):void
			{
				var textField:TextField = mcNpcShop.btnBuy.txt as TextField;
				textField.text = StringConst.NPC_SHOP_PANEL_0003;
				textField.textColor = 0x675138;
			});
			rsrLoader.addCallBack(mcNpcShop.mcScrollBar,function (mc:MovieClip):void
			{
				_panelNpcShopItemBoxHandle.initPageScrollBar(mc);
			});
			rsrLoader.addCallBack(mcNpcShop.btnAllFix,function (mc:MovieClip):void
			{
				var lasting:String =HtmlUtils.createHtmlStr(0xffe1aa,StringUtil.substitute(StringConst.LASTING_STRING_0006,LastingHandler.checkEquipDuralibity()));
				ToolTipManager.getInstance().attachByTipVO( mcNpcShop.btnAllFix,ToolTipConst.TEXT_TIP,lasting);
			});
		}
		
		override public function setPostion():void
		{
			isMount(true);
		}
		
		override public function getPanelRect():Rectangle
		{
			return new Rectangle(0,0,470,522);//由子类继承实现
		}
		
		override protected function initData():void
		{
			initText();
			_panelNpcShopClickHandle = new PanelNpcShopClickHandle(_skin as McPanelNpcShop);
			_panelNpcShopItemBoxHandle = new PanelNpcShopItemBoxHandle(_skin as McPanelNpcShop);
		}
		
		private function initText():void
		{
			var mc:McPanelNpcShop,defaultTextFormat:TextFormat;
			mc = _skin as McPanelNpcShop;
			defaultTextFormat = mc.txtName.defaultTextFormat;
			defaultTextFormat.bold = true;
			mc.txtName.defaultTextFormat = defaultTextFormat;
			mc.txtName.setTextFormat(defaultTextFormat);
			mc.txtName.text = StringConst.NPC_SHOP_PANEL_0001;
			
			mc.txtAllFix.mouseEnabled = false;
			mc.txtAllFix.text = StringConst.NPC_SHOP_PANEL_0006;
			mc.txtOneFix.mouseEnabled = false;
			mc.txtOneFix.text = StringConst.NPC_SHOP_PANEL_0007;
			
		}
		
		override public function update(proc:int = 0):void
		{
			
		}
		
		override public function destroy():void
		{
			ToolTipManager.getInstance().detach( skin.btnAllFix);
			LastingDataMananger.getInstance().isRepair=false;
			UtilMouse.setMouseRpair(false);
			if(_panelNpcShopClickHandle)
			{
				_panelNpcShopClickHandle.destroy();
			}
			if(_panelNpcShopItemBoxHandle)
			{
				_panelNpcShopClickHandle.destroy();
			}
			_panelNpcShopClickHandle = null;
			super.destroy();
		}
	}
}