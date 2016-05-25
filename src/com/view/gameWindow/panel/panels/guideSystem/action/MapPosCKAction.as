package com.view.gameWindow.panel.panels.guideSystem.action
{
	import com.view.gameWindow.scene.map.SceneMapManager;
	
	import flash.utils.getTimer;
	
	/**
	 * @author wqhk
	 * 2014-11-25
	 */
	public class MapPosCKAction extends GuideAction
	{
		private static const INTERVAL:int = 1000;
		private var _mapId:int;
		private var _tileX:int;
		private var _tileY:int;
		private var _lastTime:int = 0;
		
		
		public function MapPosCKAction(mapId:int,tileX:int,tileY:int)
		{
			_mapId = mapId;
			_tileX = tileX;
			_tileY = tileY;
			super();
		}
		
		protected function atSameMapHandler():void
		{
			
		}
		
		protected function atDifferentMapHandler():void
		{
			
		}
		
		override public function check():void
		{
			if(SceneMapManager.getInstance().mapId == _mapId)
			{
				if(getTimer() - _lastTime > INTERVAL)
				{
					atSameMapHandler();
					
					_lastTime = getTimer();
				}
			}
			else
			{
				atDifferentMapHandler();
			}
		}

		protected function get mapId():int
		{
			return _mapId;
		}

		public function get tileX():int
		{
			return _tileX;
		}

		public function get tileY():int
		{
			return _tileY;
		}


	}
}