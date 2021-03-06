package com.view.gameWindow.panel.panels.hero.tab1.bag
{
	import com.view.gameWindow.mainUi.subuis.herohead.McHeroEquipPanel;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.util.RectRim;

	/**
	 * 英雄背包单元格黄色边框处理类
	 * @author Administrator
	 */	
	public class HeroBagCellRectRimHandle
	{
		private var _rectRim:RectRim;
		
		public function HeroBagCellRectRimHandle(mc:McHeroEquipPanel)
		{
			init(mc);
		}
		
		private function init(mc:McHeroEquipPanel):void
		{
			if(!_rectRim)
			{
				_rectRim = new RectRim(0xffff00,mc.mcCellsBg.width,mc.mcCellsBg.height-35);
				_rectRim.x = mc.mcCellsBg.x;
				_rectRim.y = mc.mcCellsBg.y;
				_rectRim.visible = false;
				mc.addChild(_rectRim);
			}
		}
		
		public function switchVisible():void
		{
			var isExchange:Boolean = HeroDataManager.instance.isExchange;
			_rectRim.visible = isExchange;
		}
		
		public function destroy():void
		{
			if(_rectRim)
			{
				if(_rectRim.parent)
				{
					_rectRim.parent.removeChild(_rectRim);
				}
				_rectRim = null;
			}
		}
	}
}