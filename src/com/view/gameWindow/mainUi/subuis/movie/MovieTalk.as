package com.view.gameWindow.mainUi.subuis.movie
{
	import com.greensock.TweenLite;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.AnimShow;
	import com.view.gameWindow.util.cell.IconCellEx;
	
	import flash.display.Sprite;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	
	/**
	 * @author wqhk
	 * 2014-12-8
	 */
	public class MovieTalk extends Sprite
	{
		public static const GAP:int = 5;
		private var _borderSize:int;
		private var _icon:IconCellEx;
		private var _mc:McMovieTalkUI;
		private var _loader:RsrLoader;
		private var _text:String;
		private var _textLen:int;
		private var _textIndex:int;
		private var _textTimer:int;
		private var _iconWidth:int;
		private var _showAnim:AnimShow;
		private var _fixedTime:int;
		private var _speed:int;
		
		public function MovieTalk(speed:int = 10,iconWidth:int = 64,borderSize:int = 10)
		{
			super();
			_mc = new McMovieTalkUI();
			_mc.txt.mouseEnabled = false;
			addChild(_mc);
			
			_borderSize = borderSize;
			_iconWidth = iconWidth;
			_icon = new IconCellEx(this,_borderSize,_borderSize,_iconWidth,_iconWidth);
			
			_loader = new RsrLoader();
			_loader.load(_mc,ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD,true);
			
			_showAnim = new AnimShow(this);
			
			_speed = speed;
		}
		
		private function clearFixedTime():void
		{
			if(_fixedTime > 0)
			{
				clearTimeout(_fixedTime);
				_fixedTime = 0;
			}
		}
		
		public function show(time:int = 0):void
		{
			clearFixedTime();	
			_showAnim.show();
			
			if(time > 0)
			{
				_fixedTime = setTimeout(hide,time*1000);
			}
		}
		
		public function hide():void
		{
			_showAnim.hide();
		}
		
		public function set icon(url:String):void
		{
			_icon.url = url;
		}
		
		public function set text(value:String):void
		{
			_text = value;
			_textLen = value.length;
			_textIndex = -1;
			_mc.txt.text = "";
			traverse();
		}
		
		public function set pos(type:int):void
		{
			if(type == 0)
			{
				_icon.x = _borderSize;
				_mc.txt.x = _icon.x + _iconWidth + GAP;
			}
			else if(type == 1)
			{
				_icon.x = _mc.width - _borderSize - _iconWidth;
				_mc.txt.x = _icon.x - GAP - _mc.txt.width;
			}
		}
		
		private function stopTextTraverse():void
		{
			if(_textTimer)
			{
				clearInterval(_textTimer);
				_textTimer = 0;
			}
		}
		
		protected function traverse():void
		{
			if(_textLen == 0 || ++_textIndex == _textLen)
			{
				stopTextTraverse();
				return;
			}
			
			_mc.txt.appendText(_text.charAt(_textIndex));
			
			if(_textTimer == 0)
			{
				_textTimer = setInterval(traverse,1000/_speed);
			}
		}
		
		public function destroy():void
		{
			if(_showAnim)
			{
				_showAnim.destroy();
				_showAnim = null;
			}
			clearFixedTime();
			
			stopTextTraverse();
			
			if(_loader)
			{
				_loader.destroy();
				_loader = null;
			}
			
			if(_icon)
			{
				_icon.destroy();
				_icon = null;
			}
		}
	}
}