package com.view.gameWindow.panel.panels.guideSystem.completeCond
{
	import com.view.gameWindow.panel.panels.position.PositionDataManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	
	/**
	 * @author wqhk
	 * 2015-2-15
	 */
	public class PositionChopidCheck implements ICheckCondition
	{
		private var _id:int;
		private var _type:int;
		public function PositionChopidCheck(type:int,id:int)
		{
			_type = type;
			_id = id;
		}
		
		public function toDo():void
		{
			
		}
		
		public function isDoing():Boolean
		{
			return false;
		}
		
		public function isComplete():Boolean
		{
			if(_type == EntityTypes.ET_PLAYER)
			{
				if(PositionDataManager.instance.role_chopid == _id)
				{
					return true;
				}
			}
			else
			{
				if(PositionDataManager.instance.hero_chopid == _id)
				{
					return true;
				}
			}
			
			return false;
		}
	}
}