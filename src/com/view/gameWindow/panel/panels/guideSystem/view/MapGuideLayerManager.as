package com.view.gameWindow.panel.panels.guideSystem.view
{
	import flash.display.Sprite;
	
	/**
	 * @author wqhk
	 * 2014-11-24
	 */
	public class MapGuideLayerManager
	{
		private var _container:Sprite;
		
		private static var _instance:MapGuideLayerManager;
		public static function getInstance():MapGuideLayerManager
		{
			if(!_instance)
				_instance = new MapGuideLayerManager();
			return _instance;
		}
		
		public function MapGuideLayerManager()
		{
		}
		
		public function init(container:Sprite):void
		{
			_container = container;
		}
		
		public function get container():Sprite
		{
			return _container;
		}
	}
}