package com.view.gameWindow.tips.iconTip
{
	import com.greensock.TweenLite;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.toolTip.ToolTipLayMediator;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class IconTip extends Sprite
	{
		private var _rsrLoader:RsrLoader;
		
		protected var _startY:int;
		protected var _callback:Function;
		protected var _text:String;
		override public function set y(value:Number):void
		{
			super.y = value;
			if(!_startY)
			{
				_startY = y;
			}
		}
		
		public function IconTip(text:String,callback:Function)
		{
			super();
			var skin:MovieClip = initSkin();
			addChild(skin);
			_rsrLoader = new RsrLoader();
			_rsrLoader.load(skin,ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD);
			_text = text;
			_callback = callback;
		}
		
		protected function initSkin():MovieClip
		{
			var skin:MovieClip = new MovieClip();
			return skin;
		}
		
		public function deal():void
		{
			
		}
		
		public function move():void
		{
			
		}
		
		public function onComplete():void
		{
			var tipVo:TipVO = new TipVO();
			tipVo.tipType = ToolTipConst.TEXT_TIP;
			tipVo.tipData = HtmlUtils.createHtmlStr(0xffffff,_text);
			ToolTipManager.getInstance().hashTipInfo(this,tipVo);
			ToolTipManager.getInstance().attach(this);
			this.addEventListener(MouseEvent.CLICK,clickHandle);
		}
		
		
		private function clickHandle(evt:MouseEvent):void
		{
			ToolTipManager.getInstance().detach(this);
			this.removeEventListener(MouseEvent.CLICK,clickHandle);
			TweenLite.killTweensOf(this,true);
			IconTipMediator.instance.removeIcontip(this);
			if(parent)
			{
				parent.removeChild(this);
			}
			if(_rsrLoader)
			{
				_rsrLoader.destroy();
				_rsrLoader = null;
			}
			_callback();
		}
	}
}