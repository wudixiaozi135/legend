package com.view.gameWindow.scene.map.utils
{
	import com.view.gameWindow.scene.entity.constants.Direction;
	
	import flash.geom.Point;

	public class MapTileUtils
	{
		public static const TILE_WIDTH:int = 48;
		public static const TILE_HEIGHT:int = 34;
		public static const TILE_BEVEL:int = Math.sqrt(TILE_WIDTH * TILE_WIDTH + TILE_HEIGHT * TILE_HEIGHT);
		
		public static function tileToPixel(tileX:int, tileY:int):Point
		{
			var point:Point = new Point(tileX * TILE_WIDTH + TILE_WIDTH / 2, tileY * TILE_HEIGHT + TILE_HEIGHT / 2);
			return point;
		}
		
		public static function tileXToPixelX(tileX:int):int
		{
			return tileX * TILE_WIDTH + TILE_WIDTH / 2;
		}
		
		public static function tileYToPixelY(tileY:int):int
		{
			return tileY * TILE_HEIGHT + TILE_HEIGHT / 2;
		}
		
		public static function pixelToTile(pixelX:int, pixelY:int):Point
		{
			var tileX:int = pixelX / TILE_WIDTH;
			var tileY:int = pixelY / TILE_HEIGHT;
			var point:Point = new Point(tileX, tileY);
			return point;
		}
		
		public static function pixelXToTileX(pixelX:int):int
		{
			return pixelX / TILE_WIDTH;
		}
		
		public static function pixelYToTileY(pixelY:int):int
		{
			return pixelY / TILE_HEIGHT;
		}
		
		public static function getAroundTile(tileX:int, tileY:int, dir:int):Point
		{
			var newTileX:int = tileX;
			var newTileY:int = tileY;
			switch (dir)
			{
				case Direction.DOWN:
					newTileY += 1;
					break;
				case Direction.DOWN_RIGHT:
					newTileX += 1;
					newTileY += 1;
					break;
				case Direction.RIGHT:
					newTileX += 1;
					break;
				case Direction.UP_RIGHT:
					newTileX += 1;
					newTileY -= 1;
					break;
				case Direction.UP:
					newTileY -= 1;
					break;
				case Direction.UP_LEFT:
					newTileX -= 1;
					newTileY -= 1;
					break;
				case Direction.LEFT:
					newTileX -= 1;
					break;
				case Direction.DOWN_LEFT:
					newTileX -= 1;
					newTileY += 1;
					break;
			}
			return new Point(newTileX, newTileY);
		}
		
		public static function tileDistance(tileX1:int, tileY1:int, tileX2:int, tileY2:int):int
		{
			return Math.max(Math.abs(tileX1 - tileX2), Math.abs(tileY1- tileY2));
		}
	}
}