package com.view.gameWindow.panel.panels.guideSystem.action
{
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
	
	/**
	 * @author wqhk
	 * 2014-11-25
	 */
	public class MapPlayerPosCKAction extends MapPosCKAction
	{
		public function MapPlayerPosCKAction(mapId:int, tileX:int, tileY:int)
		{
			super(mapId, tileX, tileY);
		}
		
		override protected function atSameMapHandler():void
		{
			var self:IPlayer = EntityLayerManager.getInstance().firstPlayer;
			
			if(self)
			{
				if(self.tileX == tileX && self.tileY == tileY)
				{
					_isComplete = true;
				}
			}
		}
	}
}