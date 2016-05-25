package com.view.gameWindow.panel.panels.mall.tab
{
	import com.view.gameWindow.util.tabsSwitch.TabBase;

	/**
	 * Created by Administrator on 2014/11/19.
	 */
	public class MallTabBase extends TabBase
	{
		public function MallTabBase()
		{
			super();
		}

		override public function initView():void
		{
			initData();
			update();
		}

		override public function destroy():void
		{
			super.destroy();
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			super.detach();
		}
		
	}
}
