package com.view.gameWindow.panel.panels.menus
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.mainUi.subuis.chatframe.MessageCfg;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.events.Request;
	import com.view.gameWindow.panel.panels.menus.handlers.MenuHandler;
	
	/**
	 * 适用于选项都做在flash中菜单</br>
	 * 
	 * initSkin
	 * dispatchSelectEvent
	 * @author wqhk
	 * 2014-8-15
	 */
	public class MenuBase extends PanelBase
	{
		protected var itemNum:int;
		protected var isSkinLoad:Boolean = true;
		protected var handler:MenuHandler = null;
		public function MenuBase(handler:MenuHandler = null)
		{
			this.handler = handler;
			super();
		}
		
		private var _rsrLoader:RsrLoader;
		override public function initView():void
		{
			initSkin();
			addChild(_skin);
			
			if(isSkinLoad)
			{
				_rsrLoader = new RsrLoader();
				addCallBack(_rsrLoader);
				_rsrLoader.load(_skin,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD,true);
			}
			
			initData();
			update();
			
			
			if(stage)
			{
//				stage.addEventListener(MouseEvent.MOUSE_DOWN,clickHandler);
				setClickListener();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE,addedHandler);
			}
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			super.addCallBack(rsrLoader);
		}
		
		override protected function initData():void
		{
			var index:int = 0;
			while(_skin.hasOwnProperty('item'+index))
			{
				++index;
			}
			itemNum = index;
		}
		
		private function addedHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,addedHandler);
			timeId = setTimeout(setClickListener,50);
		}
		
		private var timeId:int;
		
		private function setClickListener():void
		{
			if(timeId)
			{
				clearTimeout(timeId);
				timeId = 0;
			}
			stage.addEventListener(MouseEvent.MOUSE_DOWN,clickHandler);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL,wheelHandler);
		}
		
		override public function destroy():void
		{
			handler = null;
			
			if(_rsrLoader)
			{
				_rsrLoader.destroy();
				_rsrLoader = null;
			}
			
			if(timeId)
			{
				clearTimeout(timeId);
				timeId = 0;
			}
			
			removeEventListener(Event.ADDED_TO_STAGE,addedHandler);
			if(stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_DOWN,clickHandler);
				stage.removeEventListener(MouseEvent.MOUSE_WHEEL,wheelHandler);
			}
			
			_skin = null;//不想从parent移除；
			super.destroy();
		}
		
		
		protected function clickHandler(e:MouseEvent):void
		{
			var mousePos:Point = new Point(e.stageX,e.stageY);
			var panelPos:Point = parent.localToGlobal(new Point(x,y));
			var panelRect:Rectangle = new Rectangle(panelPos.x,panelPos.y,width,height);
			
			if(mousePos.x < panelPos.x || mousePos.x > panelRect.right 
				|| mousePos.y < panelPos.y || mousePos.y > panelRect.bottom)
			{
				dispatchEvent(new Request(Event.SELECT,false,false,createSelectedData(-1)));
				return;
			}
			
			onItemClick(e);
		}
		
		protected function wheelHandler(e:MouseEvent):void
		{
			dispatchEvent(new Request(Event.SELECT,false,false,createSelectedData(-1)));
		}
		
		protected function onItemClick(e:MouseEvent):void
		{
			for(var index:int = 0; index < itemNum; ++index)
			{
				if(e.target == _skin['item'+index])
				{
					dispatchEvent(new Request(Event.SELECT,false,false,createSelectedData(index)));
					
					if(handler)
					{
						handler.selected(index);
					}
					return;
				}
			}
		}
		
		
		protected function createSelectedData(index:int):Object
		{
			return index;
		}
	}
}