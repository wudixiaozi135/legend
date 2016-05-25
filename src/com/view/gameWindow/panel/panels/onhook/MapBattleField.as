package com.view.gameWindow.panel.panels.onhook
{
	import com.view.gameWindow.panel.panels.guideSystem.view.MapGuideLayerManager;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.scene.map.path.MapPathManager;
	import com.view.gameWindow.scene.map.utils.MapTileUtils;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * @author wqhk
	 * 2014-12-1
	 */
	public class MapBattleField implements IBattleField
	{
		private var _mapId:int;
		private var _mapChanged:Boolean = true;
		private var _field:BattleField;
		private var _isCalc:Boolean = false;
		private var _area:Rectangle;
		private var _startX:int;
		private var _startY:int;
		
		public function MapBattleField()
		{
			_field = new BattleField(AxFuncs.isBlock);
		}
		
		public function isInField(x:int,y:int):Boolean
		{
			if(!MapPathManager.getInstance().ready || !_field)
			{
				return false;
			}
			
			if(!_isCalc)
			{
				_field.calc(_startX,_startY,_area);
				_isCalc = true;
			}
			
			return _field.isInField(x,y);
		}
		
		/**
		 * 显示区域
		 */
		private function drawField(area:Rectangle):void
		{
			var ctner:Sprite = MapGuideLayerManager.getInstance().container;
			
			ctner.graphics.clear();
			ctner.graphics.lineStyle(1,0xffff00,0.5);
			ctner.graphics.beginFill(0xff0000,0.5);
			for(var i:int = area.x; i < area.right; ++i)
			{
				for(var j:int = area.y; j < area.bottom; ++j)
				{
					ctner.graphics.drawRect(i*MapTileUtils.TILE_WIDTH,j*MapTileUtils.TILE_HEIGHT,MapTileUtils.TILE_WIDTH,MapTileUtils.TILE_HEIGHT);
				}
			}
			
			ctner.graphics.endFill();
		}
		
		public function startFight(startX:int,startY:int,radius:int):void
		{
			var col:int = SceneMapManager.getInstance().mapWidth / MapTileUtils.TILE_WIDTH;
			var row:int = SceneMapManager.getInstance().mapHeight / MapTileUtils.TILE_HEIGHT;
			_startX = startX;
			_startY = startY;
			
			var area:Rectangle = new Rectangle(startX-radius,startY-radius,radius*2,radius*2);
			
			if(area.x < 0)
			{
				area.x = 0;
			}
			
			if(area.y < 0)
			{
				area.y = 0;
			}
			
			if(area.right > col)
			{
				area.right = col;
			}
			
			if(area.bottom > row)
			{
				area.bottom = row;
			}
			
			_area = area;
			
			_isCalc = false;
			
//			drawField(_area);
		}
	}
}