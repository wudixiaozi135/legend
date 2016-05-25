package com.view.gameWindow.panel.panels.guideSystem.completeCond
{
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	
	/**
	 * @author wqhk
	 * 2015-2-28
	 */
	public class RunToMapCheck implements ICheckCondition
	{
		private var _mapId:int;
		private var _x:int;
		private var _y:int;
		
		public function RunToMapCheck(mapId:int,x:int,y:int)
		{
			_mapId = mapId;
			_x = x;
			_y = y;
		}
		
		public function isDoing():Boolean
		{
			return AutoSystem.instance.isAutoMap();
		}
		
		public function isComplete():Boolean
		{
			return AxFuncs.isPlayerAt(_mapId,_x,_y);
		}
		
		public function toDo():void
		{
			if(!AxFuncs.isPlayerAt(_mapId,_x,_y))
			{
				AutoSystem.instance.startAutoMap(_mapId,_x,_y);
			}
		}
	}
}