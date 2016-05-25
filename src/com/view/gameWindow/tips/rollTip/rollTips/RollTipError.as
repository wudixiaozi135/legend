package com.view.gameWindow.tips.rollTip.rollTips
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	import com.view.gameWindow.rollTip.McErrorTip;
	import com.view.gameWindow.tips.rollTip.RollTip;
	
	import flash.display.MovieClip;
	
	/**
	 * 错误滚动提示类
	 * @author Administrator
	 */	
	public class RollTipError extends RollTip
	{
		public function RollTipError(text:String)
		{
			super(text);
		}
		
		override protected function initSkin():MovieClip
		{
			var skin:MovieClip = new McErrorTip();
			return skin;
		}
		
		override public function deal():void
		{
			TweenMax.to(this,1,{y:"-50",ease:Circ.easeOut});
			TweenMax.to(this,.5,{alpha:0,onComplete:onComplete,delay:1});
		}
	}
}