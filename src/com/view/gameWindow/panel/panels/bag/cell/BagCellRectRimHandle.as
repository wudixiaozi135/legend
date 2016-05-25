package com.view.gameWindow.panel.panels.bag.cell
{
	import com.view.gameWindow.panel.panels.bag.McBag;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.util.RectRim;

	/**
	 * 背包单元格黄色边框处理类
	 * @author Administrator
	 */	
	public class BagCellRectRimHandle
	{
		private var _rectRim:RectRim;
		
		public function BagCellRectRimHandle(mc:McBag)
		{
			init(mc);
		}
		
		private function init(mc:McBag):void
		{
			if(!_rectRim)
			{
				_rectRim = new RectRim(0xffff00,mc.mcCellsBg.width,mc.mcCellsBg.height);
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