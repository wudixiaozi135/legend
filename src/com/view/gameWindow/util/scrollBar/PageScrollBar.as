package com.view.gameWindow.util.scrollBar
{
	import com.view.gameWindow.scene.GameSceneManager;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * 翻页滚动条类
	 * @author Administrator
	 */	
	public class PageScrollBar
	{
		public var page:int = 1
		public var totalPage:int;
		private var _skin:MovieClip;
		private var _stage:Stage;
		private var _btnUp:MovieClip;
		private var _btnDown:MovieClip;
		private var _btnThumb:MovieClip;
		private var _btnBg:MovieClip;
		private var _thumbH:Number;
		private var _maxScrollPosition:int;
		private var _refresh:Function;
		/**
		 * 构造翻页滚动条
		 * @param skin 滚动条皮肤
		 * @param height 滚动条高度
		 * @param refresh 滚动条滚动刷新函数
		 * @param totalPage 滚动条页数
		 */		
		public function PageScrollBar(skin:MovieClip,height:int,refresh:Function,totalPage:int = 1)
		{
			super();
			init(skin,height,refresh,totalPage);
		}
		
		public function init(skin:MovieClip,height:int,refresh:Function,totalPage:int):void
		{
			_skin = skin;
			_stage = GameSceneManager.getInstance().stage;
			_btnUp = _skin.btnUp;
			_btnDown = _skin.btnDown;
			_btnThumb = _skin.btnThumb;
			_btnBg = _skin.btnBg;
			_btnDown.y = height - _btnDown.height;
			_btnBg.height = _btnDown.y - _btnUp.height;
			
			
			_thumbH = _btnBg.height/totalPage;          
			_btnThumb.getChildAt(0).height = _thumbH;	//滚动changdu		
			_maxScrollPosition = _btnDown.y - _thumbH;  //最大滚动区域
			
			
			_skin.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			_refresh = refresh;
			this.totalPage = totalPage;
		}
		
		public function refresh(totalPage:int):void
		{
			_thumbH = _btnBg.height/totalPage;
			_btnThumb.getChildAt(0).height = _thumbH; 
			_maxScrollPosition = _btnDown.y - _thumbH;
		 	 if(totalPage > this.totalPage)
			{
				 page = page == 1?page:page++;
				 _btnThumb.y = _thumbH*(page-1)+_btnUp.height;
			} 
		    if(this.totalPage > totalPage)
			{
				page = page - 1 > 0 ? page - 1:1;
				_btnThumb.y = _thumbH*(page-1)+_btnUp.height;
			}   
			this.totalPage = totalPage;		
			if(this.totalPage==1)
			{
				_btnThumb.y = _btnUp.height;
				_btnThumb.visible = false;
			}
			else
			{
				_btnThumb.visible = true;
			}	
		}
		/**上下按钮点击翻页*/
		protected function onDown(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _btnUp:
					if(_btnThumb.y <= _btnUp.height || page == 1)
					{
						_btnThumb.y = _btnUp.height;
						page = 1;
					}
					else
					{
						page--;
						_btnThumb.y = _thumbH*(page-1)+_btnUp.height;
						_refresh();
					}
					break;
				case _btnDown:
					if(_btnThumb.y >= _maxScrollPosition || page == totalPage)
					{
						_btnThumb.y = _maxScrollPosition;
						page = totalPage;
					}
					else
					{
						page++;
						_btnThumb.y = _thumbH*(page-1)+_btnUp.height;
						_refresh();
					}
					break;
				case _btnThumb:
					onThumbMouseDow(event);
					break;
			}
		}
		
		private function onThumbMouseDow(event:MouseEvent):void
		{
			//滚动条滚动区域
			var scrollRect:Rectangle = new Rectangle(_btnThumb.x,_btnUp.height,0,_maxScrollPosition - _btnUp.height);
			_btnThumb.startDrag(false,scrollRect);
			_stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			_stage.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		private function onStageMouseUp(event:MouseEvent):void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			_stage.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			_btnThumb.stopDrag();
		}
		
		private function onEnterFrame(event:Event):void
		{
			var scrollIndex:int = Math.round((_btnThumb.y-_btnUp.height)/_thumbH+1);
			if(page == scrollIndex)
				return;
			
			page = scrollIndex;
			_refresh();
		}
		
		public function destroy():void
		{
			_btnUp = null;
			_btnDown = null;
			_btnThumb = null;
			_btnBg = null;
			_skin.removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
			_skin = null;
			
			_stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			_stage.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			_stage = null;
		}
	}
}