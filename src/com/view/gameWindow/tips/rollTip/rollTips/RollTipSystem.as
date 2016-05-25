package com.view.gameWindow.tips.rollTip.rollTips
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.view.gameWindow.rollTip.McSystemTip;
	import com.view.gameWindow.tips.rollTip.RollTip;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * 系统滚动提示类
	 * @author Administrator
	 */	
	public class RollTipSystem extends RollTip
	{
		
		public static const SPACING:int = 28;
		private var _tlMove:TweenLite;
		protected var _spacing:int = SPACING;
	
		public function RollTipSystem(text:String)
		{
			super(text);
		}
		
		override protected function initSkin():MovieClip
		{
			var skin:MovieClip = new McSystemTip();
			return skin;
		}
		
		override protected function initText(skin:MovieClip, text:String):void
		{
			var textField:TextField = skin.txt as TextField;
			textField.htmlText = text;
			/*textField.cacheAsBitmap = true;*/
		}
		
		override public function deal():void
		{
			if(isBottom)
			{
				return;
			}
			
			_tlMove = TweenMax.from(this,.5,{y:_startY+_spacing,alpha:0});
			TweenMax.to(this,.5,{alpha:0,onComplete:onComplete,delay:3});
		}
		
		override public function move():void
		{
			if(isBottom)
			{
				return;
			}
			
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
//			_tlMove = null;
			super.onComplete();
		}
	}
}