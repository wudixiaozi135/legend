package com.view.gameWindow.tips.rollTip.rollTips
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	import com.view.gameWindow.rollTip.McRewardTip;
	import com.view.gameWindow.tips.rollTip.RollTip;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * 奖励滚动提示类
	 * @author Administrator
	 */	
	public class RollTipReward extends RollTip
	{
		private var _tlMove:TweenMax;
		private var _textColor:uint;
		private var _spacing:int = 30;
		
		public function RollTipReward(text:String)
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
			text = text.replace(/size='\d*'/g,"size='20'");
			super.initText(skin, text);
			var textField:TextField = skin.txt as TextField;
		}
		
		override public function deal():void
		{
			TweenMax.to(this,1,{y:"-50",ease:Circ.easeOut});
			TweenMax.to(this,.5,{alpha:0,onComplete:onComplete,delay:1});
			/*_tlMove = TweenLite.from(this,.5,{y:_startY+_spacing,alpha:0});
			TweenLite.to(this,.5,{alpha:0,onComplete:onComplete,delay:5.5});*/
		}
		
		override public function move():void
		{
			/*if(_tlMove)
			{
				_tlMove.kill();
			}
			alpha = 1;
			_startY -= _spacing;
			y = _startY;
			_tlMove = TweenLite.from(this,.5,{y:_startY+_spacing});*/
		}
		
		override public function onComplete():void
		{
			_tlMove = null;
			_textColor = 0;
			super.onComplete();
		}
	}
}