package com.view.gameWindow.panel.panels.menus
{
	import com.greensock.TweenLite;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * @author wqhk
	 * 2014-8-14
	 */
	public class MenuMediator
	{
		private static var _instance:MenuMediator;
		public static function get instance():MenuMediator
		{
			if(!_instance)
				_instance = new MenuMediator(new PrivateClass());
			return _instance;
		}
		
		private var _layer:Sprite;
		private var _menus:Dictionary;
		
		public function MenuMediator(pc:PrivateClass)
		{
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			
			_menus = new Dictionary(true);
		}
		
		public function initData(layer:Sprite):void
		{
			_layer = layer;
		}
		
		public function get layer():Sprite
		{
			return _layer;
		}
		
		public function get mouseX():Number
		{
			return _layer.mouseX;
		}
		
		public function get mouseY():Number
		{
			return _layer.mouseY;
		}
		
		
		public function showMenu(menu:PanelBase):void
		{
			if(_layer)
			{
				if(_menus[menu])
					return;
				
				menu.initView();
				menu.resetPosInParent();
				menu.alpha = 0;
				_layer.addChild(menu);
				_menus[menu] = menu;
				TweenLite.to(menu,0.5,{alpha:1});
			}
		}
		
		public function hideMenu(menu:PanelBase):void
		{
			TweenLite.to(menu,0.25,{alpha:0,onComplete:hideMenuReally,onCompleteParams:[menu]})
		}
		
		private function hideMenuReally(menu:PanelBase):void
		{
			menu.destroy();
			if(menu.parent)
			{
				menu.parent.removeChild(menu);
			}
			delete _menus[menu];
		}
		
		
		/**屏幕缩放*/
		public function resize(stageWidth:int, stageHeight:int):void
		{
			for each(var menu:PanelBase in _menus)
			{
				menu.resetPosInParent();
			}
		}
	}
}

class PrivateClass{}