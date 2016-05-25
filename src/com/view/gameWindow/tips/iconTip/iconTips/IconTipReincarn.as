package com.view.gameWindow.tips.iconTip.iconTips
{
	import com.greensock.TweenLite;
	import com.view.gameWindow.tips.iconTip.IconTip;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import com.view.gameWindow.mainUi.subuis.effect.iconTip.iconTips.McReincarn;
	
	public class IconTipReincarn extends IconTip
	{
		private var _spacing:int = 40;
		
		public function IconTipReincarn(text:String,callback:Function)
		{
			super(text,callback);
		}
		
		override protected function initSkin():MovieClip
		{
			var skin:MovieClip = new McReincarn();
			return skin;
		}
		
		override public function deal():void
		{
			TweenLite.to(this,2.5,{y:"225",alpha:1,onComplete:onComplete,delay:1});
		}
		
		override public function onComplete():void
		{
			super.onComplete();
		}
	}
}