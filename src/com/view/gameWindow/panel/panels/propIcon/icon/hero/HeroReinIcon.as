package com.view.gameWindow.panel.panels.propIcon.icon.hero
{
	import com.view.gameWindow.panel.panels.propIcon.icon.PropIcon;
	
	public class HeroReinIcon extends PropIcon
	{
		public function HeroReinIcon()
		{
			super();
		}
		
		override public function checkUnLock():Boolean
		{
			// TODO Auto Generated method stub
			return true;
		}
		
		override protected function getIconUrl():String
		{
			return "small_roleRein.png";
		}
		
		override public function getTipData():Object
		{
			// TODO Auto Generated method stub
			return super.getTipData();
		}
		
		override public function getTipType():int
		{
			// TODO Auto Generated method stub
			return super.getTipType();
		}
	}
}