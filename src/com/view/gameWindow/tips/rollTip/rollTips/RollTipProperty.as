package com.view.gameWindow.tips.rollTip.rollTips
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	import com.view.gameWindow.rollTip.McRewardTip;
	import com.view.gameWindow.tips.rollTip.RollTip;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * 人物属性变化提示类
	 * @author Administrator
	 */
	public class RollTipProperty extends RollTip
	{
		private var _tlMove:TweenMax;
		private var _textColor:uint;
		private var _spacing:int = 30;
		
		public function RollTipProperty(text:String)
		{
			super(text);
		}
		
		override protected function initSkin():MovieClip
		{
			var skin:MovieClip = new McRewardTip();
			return skin;
		}
		
		override protected function initText(skin:MovieClip, text:String):void
		{
			super.initText(skin, text);
			var textField:TextField = skin.txt as TextField;
		}
		
		override public function deal():void
		{
			TweenMax.to(this,1,{y:"-50",ease:Circ.easeOut});
			TweenMax.to(this,.5,{alpha:0,onComplete:onComplete,delay:1});
		}
		
		override public function move():void
		{
			
		}
		
		override public function onComplete():void
		{
			_tlMove = null;
			_textColor = 0;
			super.onComplete();
		}
	}
}