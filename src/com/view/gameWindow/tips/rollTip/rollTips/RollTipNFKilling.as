package com.view.gameWindow.tips.rollTip.rollTips
{
	import flash.display.MovieClip;
	
	/**
	 * 夜战比奇击杀提示类
	 * @author Administrator
	 */	
	public class RollTipNFKilling extends RollTipSystem
	{
		public function RollTipNFKilling(text:String)
		{
			_spacing = 28;
			super(text);
		}
		
		override protected function initSkin():MovieClip
		{
			var skin:McNightFightKilling = new McNightFightKilling();
			return skin;
		}
	}
}