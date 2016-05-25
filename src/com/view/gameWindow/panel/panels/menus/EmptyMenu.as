package com.view.gameWindow.panel.panels.menus
{
	import com.view.gameWindow.panel.panels.menus.handlers.MenuHandler;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.Request;
	
	
	/**
	 * 仅仅作为一个容器使用 ，在点击外部时仍然会收到 Event.SELECT value==-1 的消息
	 * @author wqhk
	 * 2014-11-12
	 */
	public class EmptyMenu extends MenuBase
	{
		private static const PADDING:int = 5;
		private var mc:McTextMenu;
		private var content:DisplayObject;
		
		public function EmptyMenu(handler:MenuHandler=null)
		{
			super(handler);
		}
		
		override public function destroy():void
		{
			content = null;
			super.destroy();
		}
		
		override protected function initSkin():void
		{
			mc = new McTextMenu();
			_skin = mc;
		}
		
		override protected function initData():void
		{
			updateSize();
		}
		
		public function addContent(dis:DisplayObject):void
		{
			if(content && content.parent)
			{
				content.parent.removeChild(content);
			}
			content = dis;
			content.x = PADDING;
			content.y = PADDING;
			updateSize();
		}
		
		protected function updateSize():void
		{
			if(_skin && content)
			{
				addChild(content);
				
				var w:int = content.width+PADDING*2;
				var h:int = content.height+PADDING*2;
				
				if(_skin.bg)
				{
					_skin.bg.width = w;
					_skin.bg.height = h;
				}
				
				_skin.width = w;
				_skin.height = h;
			}
		}
		
		override protected function onItemClick(e:MouseEvent):void
		{
			//比较特殊不做处理			
		}
		
		private var _firstShow:Boolean = true;
		override public function resetPosInParent():void
		{
			super.resetPosInParent();
			
			if(!_firstShow)
			{
				//当窗口改变时 直接清掉
				dispatchEvent(new Request(Event.SELECT,false,false,createSelectedData(-1)));
			}
			
			_firstShow = false;
		}
	}
}