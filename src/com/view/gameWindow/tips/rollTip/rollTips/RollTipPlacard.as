package com.view.gameWindow.tips.rollTip.rollTips
{
	import com.greensock.TweenMax;
	import com.view.gameWindow.rollTip.McPlacardTip;
	import com.view.gameWindow.tips.rollTip.RollTip;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * 公告滚动提示类
	 * @author Administrator
	 */	
	public class RollTipPlacard extends RollTip
	{
		private var _tlMove:TweenMax;
		private var _spacing:int = 30;
		
		public function RollTipPlacard(text:String)
		{
			super(text);
		}
		
		override protected function initSkin():MovieClip
		{
			var skin:MovieClip = new McPlacardTip();
			return skin;
		}
		
		override protected function initText(skin:MovieClip, text:String):void
		{
			super.initText(skin, text);
			/*var movieClip:MovieClip = skin.bg as MovieClip;*/
			var textField:TextField = skin.txt as TextField;
			/*movieClip.width = textField.width+14;*/
		}
		
		override public function deal():void
		{
			TweenMax.from(this,.5,{alpha:0});
			TweenMax.to(this,.5,{alpha:0,onComplete:onComplete,delay:3.5});
		}
		
		override public function move():void
		{
			if(_tlMove)
			{
				_tlMove.kill();
			}
			/*trace("//////////////////////\n"+name+"_startY:"+_startY+",y:"+y+"\n//////////////////");*/
			alpha = 1;
			_startY -= _spacing;
			y = _startY;
			_tlMove = TweenMax.from(this,.5,{y:_startY+_spacing});
		}
		
		override public function onComplete():void
		{
			_tlMove = null;
			super.onComplete();
		}
	}
}