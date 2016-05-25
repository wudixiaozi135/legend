package com.view.gameWindow.panel.panels.npcshop
{
	import com.model.consts.SlotType;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.tips.toolTip.interfaces.IToolTipClient;
	
	import flash.display.MovieClip;
	
	public class PanelNpcShopItemBoxTip extends MovieClip implements IToolTipClient
	{
		private var _layer:PanelNpcShopItemBox;
		
		public function PanelNpcShopItemBoxTip(layer:PanelNpcShopItemBox)
		{
			super();
			_layer = layer;
			x = _layer.__id2_.x;
			y = _layer.__id2_.y;
			graphics.beginFill(0,.1);
			graphics.drawRect(0,0,_layer.__id2_.width,_layer.__id2_.height);
			graphics.endFill();
			_layer.addChild(this);
		}
		
		public function getTipType():int
		{
			if(_layer._cfgDt && _layer._cfgDt.type == SlotType.IT_EQUIP)
				return ToolTipConst.SHOP_EQUIP_TIP;
			else if(_layer._cfgDt && _layer._cfgDt.type == SlotType.IT_ITEM)
				return ToolTipConst.SHOP_ITEM_TIP;
			else 
				return ToolTipConst.NONE_TIP;
		}
		
		public function getTipData():Object
		{
			return _layer._cfgDt;
		}
		
		public function destroy():void
		{
			_layer = null;
		}
		
		public function getTipCount():int
		{
			// TODO Auto Generated method stub
			return 1;
		}
		
	}
}