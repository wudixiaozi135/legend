package com.view.gameWindow.tips.rollTip
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * 滚动提示类
	 * @author Administrator
	 */	
	public class RollTip extends Sprite
	{
		public var isBottom:Boolean = false;
		protected var _startY:int;
		override public function set y(value:Number):void
		{
			super.y = value;
			if(!_startY)
			{
				_startY = y;
			}
		}
		
		private var _rsrLoader:RsrLoader;
		
		public function RollTip(text:String)
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
			var skin:MovieClip = initSkin();
			addChild(skin);
			_rsrLoader = new RsrLoader();
			_rsrLoader.load(skin,ResourcePathConstants.IMAGE_ROLLTIP_FOLDER_LOAD);
			initText(skin,text);
		}
		
		protected function initSkin():MovieClip
		{
			var skin:MovieClip = new MovieClip();
			return skin;
		}
		
		protected function initText(skin:MovieClip,text:String):void
		{
			var textField:TextField = skin.txt as TextField;
			textField.htmlText = text;
			textField.width = textField.textWidth+5;
		}
		
		public function deal():void
		{
			
		}
		
		public function move():void
		{
			
		}
		
		public function onComplete():void
		{
			RollTipMediator.instance.removeRolltip(this);
			TweenMax.killTweensOf(this,true);
			if(parent)
			{
				parent.removeChild(this);
			}
			if(_rsrLoader)
			{
				_rsrLoader.destroy();
				_rsrLoader = null;
			}
		}
	}
}