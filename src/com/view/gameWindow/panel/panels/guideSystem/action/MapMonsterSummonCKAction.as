package com.view.gameWindow.panel.panels.guideSystem.action
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.guideSystem.view.MapGuideLayerManager;
	import com.view.gameWindow.panel.panels.guideSystem.view.MapMarker;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.entityItem.Monster;
	import com.view.gameWindow.scene.entity.entityItem.interf.IMonster;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.scene.map.utils.MapTileUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * 检测 在地图指定位置 怪物是否召唤 (有可能会残留在列表中)
	 * @author wqhk
	 * 2014-11-23
	 */
	public class MapMonsterSummonCKAction extends MapPosCKAction
	{
		private static const INTERVAL:int = 1000;
		private var _id:int;
		private var _lastTime:int = 0;
		private var _view:MapMarker;
		
		public function MapMonsterSummonCKAction(mapId:int,tileX:int,tileY:int,monsterGroupId:int)
		{
			super(mapId,tileX,tileY);
			_id = monsterGroupId;
		}
		
		override protected function atDifferentMapHandler():void
		{
			removeMarker();
		}
		
		override protected function atSameMapHandler():void
		{
			addMarker();
			
			var monster:IMonster = EntityLayerManager.getInstance().getMonsterAt(tileX,tileY);
			
			if(monster && monster.mstCfgData && _id == monster.mstCfgData.group_id)
			{
				_isComplete = true;
			}
		}
		
		
		private function addMarker():void
		{
			if(!_view)
			{
				_view = new MapMarker(StringConst.GUIDE_01);
				var pos:Point = MapTileUtils.tileToPixel(tileX,tileY);
				_view.x = pos.x;
				_view.y = pos.y;
				container.addChild(_view);
			}
		}
		
		private function removeMarker():void
		{
			if(_view)
			{
				if(_view.parent)
				{
					_view.parent.removeChild(_view);
				}
				
				_view.destroy();
				_view = null;
			}
		}
			
		
		override public function destroy():void
		{
			removeMarker();
		}
		
		private function get container():DisplayObjectContainer
		{
			return MapGuideLayerManager.getInstance().container;
		}
		
		override public function act():void
		{
			
		}
	}
}