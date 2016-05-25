package com.view.gameWindow.panel.panels.hero.tab1.HeroProperty
{
	import com.view.gameWindow.panel.panels.hero.HeroProperty.McHeroPropertyPanel;

	com.view.gameWindow.panel.panels.hero.HeroProperty.McHeroPropertyPanel;
	
	import flash.events.MouseEvent;

	public class HeroPropertyClickHandler
	{
		private var _skin:McHeroPropertyPanel;
		private var _panel:HeroPropertyPanel;
		
		public function HeroPropertyClickHandler(skin:McHeroPropertyPanel,panel:HeroPropertyPanel)
		{
			_skin = skin;
			_panel = panel;
			init();
		}
		
		private function init():void
		{
			_skin.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			switch(event.target)
			{
				 case _skin.btnClose:
					 _panel.removePanel();
			}
		}
		
		public function destroy():void
		{
			_skin.removeEventListener(MouseEvent.CLICK,clickHandler);
			_skin = null;
			_panel = null;
		}
	}
}