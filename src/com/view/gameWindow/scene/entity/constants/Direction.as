package com.view.gameWindow.scene.entity.constants
{
	import com.view.gameWindow.scene.map.utils.MapTileUtils;

	public class Direction
	{
		public static const DOWN:int = 0;
		public static const DOWN_RIGHT:int = 1;
		public static const RIGHT:int = 2;
		public static const UP_RIGHT:int = 3;
		public static const UP:int = 4;
		public static const UP_LEFT:int = 5;
		public static const LEFT:int = 6;
		public static const DOWN_LEFT:int = 7;
		public static const INVALID_DIRECTION:int = -1;
		public static const TOTAL_DIRECTION:int = 8;
		
		public static const DIR_TOLERATE:Number = 0.9;
		
		public static function getDirectionByTile(x:int, y:int, targetX:int, targetY:int):int
		{
			if (targetX == x)
			{
				if (targetY == y)
				{
					return INVALID_DIRECTION;
				}
				else if (targetY < y)
				{
					return UP;
				}
				else
				{
					return DOWN;
				}
			}
			else if (targetX < x)
			{
				if (targetY == y)
				{
					return LEFT;
				}
				else if (targetY < y)
				{
					return UP_LEFT;
				}
				else
				{
					return DOWN_LEFT;
				}
			}
			else
			{
				if (targetY == y)
				{
					return RIGHT;
				}
				else if (targetY < y)
				{
					return UP_RIGHT;
				}
				else
				{
					return DOWN_RIGHT;
				}
			}
			return INVALID_DIRECTION;
		}
		
		public static function getDirectionByPixel(x:int, y:int, targetX:int, targetY:int, candidateDir:int):int
		{
			if (Math.abs(targetX - x) < MapTileUtils.TILE_WIDTH / 2 && Math.abs(targetY - y) < MapTileUtils.TILE_HEIGHT / 2)
			{
				return candidateDir;
			}
			if (candidateDir == UP)
			{
				if (Math.abs(targetX - x) * DIR_TOLERATE / MapTileUtils.TILE_WIDTH < Math.abs(targetY - y) / (2 * MapTileUtils.TILE_HEIGHT) && targetY < y)
				{
					return candidateDir;
				}
			}
			else if (candidateDir == DOWN)
			{
				if (Math.abs(targetX - x) * DIR_TOLERATE / MapTileUtils.TILE_WIDTH < Math.abs(targetY - y) * DIR_TOLERATE / (2 * MapTileUtils.TILE_HEIGHT) && targetY > y)
				{
					return candidateDir;
				}
			}
			else if (candidateDir == LEFT)
			{
				if (Math.abs(targetY - y) * DIR_TOLERATE / MapTileUtils.TILE_HEIGHT < Math.abs(targetX - x) / (2 * MapTileUtils.TILE_WIDTH) && targetX < x)
				{
					return candidateDir;
				}
			}
			else if (candidateDir == RIGHT)
			{
				if (Math.abs(targetY - y) * DIR_TOLERATE / MapTileUtils.TILE_HEIGHT < Math.abs(targetX - x) / (2 * MapTileUtils.TILE_WIDTH) && targetX > x)
				{
					return candidateDir;
				}
			}
			else if (candidateDir == UP_LEFT)
			{
				if (Math.abs(targetY - y) / MapTileUtils.TILE_HEIGHT >= Math.abs(targetX - x) * DIR_TOLERATE / (2 * MapTileUtils.TILE_WIDTH) && targetX < x && Math.abs(targetX - x) / MapTileUtils.TILE_WIDTH >= Math.abs(targetY - y) * DIR_TOLERATE / (2 * MapTileUtils.TILE_HEIGHT) && targetY < y)
				{
					return candidateDir;
				}
			}
			else if (candidateDir == UP_RIGHT)
			{
				if (Math.abs(targetY - y) / MapTileUtils.TILE_HEIGHT >= Math.abs(targetX - x) * DIR_TOLERATE / (2 * MapTileUtils.TILE_WIDTH) && targetX > x && Math.abs(targetX - x) / MapTileUtils.TILE_WIDTH >= Math.abs(targetY - y) * DIR_TOLERATE / (2 * MapTileUtils.TILE_HEIGHT) && targetY < y)
				{
					return candidateDir;
				}
			}
			else if (candidateDir == DOWN_LEFT)
			{
				if (Math.abs(targetY - y) / MapTileUtils.TILE_HEIGHT >= Math.abs(targetX - x) * DIR_TOLERATE / (2 * MapTileUtils.TILE_WIDTH) && targetX < x && Math.abs(targetX - x) / MapTileUtils.TILE_WIDTH >= Math.abs(targetY - y) * DIR_TOLERATE / (2 * MapTileUtils.TILE_HEIGHT) && targetY > y)
				{
					return candidateDir;
				}
			}
			else if (candidateDir == DOWN_RIGHT)
			{
				if (Math.abs(targetY - y) / MapTileUtils.TILE_HEIGHT >= Math.abs(targetX - x) * DIR_TOLERATE / (2 * MapTileUtils.TILE_WIDTH) && targetX > x && Math.abs(targetX - x) / MapTileUtils.TILE_WIDTH >= Math.abs(targetY - y) * DIR_TOLERATE / (2 * MapTileUtils.TILE_HEIGHT) && targetY > y)
				{
					return candidateDir;
				}
			}
			
			if (Math.abs(targetX - x) / MapTileUtils.TILE_WIDTH < Math.abs(targetY - y) / (2 * MapTileUtils.TILE_HEIGHT))
			{
				if (targetY == y)
				{
					return INVALID_DIRECTION;
				}
				else if (targetY < y)
				{
					return UP;
				}
				else
				{
					return DOWN;
				}
			}
			else if (targetX < x)
			{
				if (Math.abs(targetY - y) / MapTileUtils.TILE_HEIGHT < Math.abs(targetX - x) / (2 * MapTileUtils.TILE_WIDTH))
				{
					return LEFT;
				}
				else if (targetY < y)
				{
					return UP_LEFT;
				}
				else if (targetY > y)
				{
					return DOWN_LEFT;
				}
			}
			else
			{
				if (Math.abs(targetY - y) / MapTileUtils.TILE_HEIGHT < Math.abs(targetX - x) / (2 * MapTileUtils.TILE_WIDTH))
				{
					return RIGHT;
				}
				else if (targetY < y)
				{
					return UP_RIGHT;
				}
				else if (targetY > y)
				{
					return DOWN_RIGHT;
				}
			}
			return INVALID_DIRECTION;
		}
		
		public static function getOffsetXByDir(dir:int):int
		{
			if (dir == UP_RIGHT || dir == RIGHT || dir == DOWN_RIGHT)
			{
				return 1;
			}
			else if (dir == UP_LEFT || dir == LEFT || dir == DOWN_LEFT)
			{
				return -1;
			}
			return 0;
		}
		
		public static function getOffsetYByDir(dir:int):int
		{
			if (dir == DOWN_LEFT || dir == DOWN || dir == DOWN_RIGHT)
			{
				return 1;
			}
			else if (dir == UP_LEFT || dir == UP || dir == UP_RIGHT)
			{
				return -1;
			}
			return 0;
		}
		
		public static function getRoateDirToPos(dir:int, currentX:int, currentY:int, targetX:int, targetY:int):int
		{
			var offsetX:int = targetX - currentX;
			var offsetY:int = targetY - currentY;
			if (dir == DOWN)
			{
				if (offsetX >= 0)
				{
					return 1;
				}
				else
				{
					return -1;
				}
			}
			else if (dir == DOWN_RIGHT)
			{
				if (offsetX >= - offsetY)
				{
					return 1;
				}
				else
				{
					return -1;
				}
			}
			else if (dir == RIGHT)
			{
				if (offsetY >= 0)
				{
					return 1;
				}
				else
				{
					return -1;
				}
			}
			else if (dir == UP_RIGHT)
			{
				if (offsetY >= offsetX)
				{
					return 1;
				}
				else
				{
					return -1;
				}
			}
			else if (dir == UP)
			{
				if (offsetX <= 0)
				{
					return 1;
				}
				else
				{
					return -1;
				}
			}
			else if (dir == UP_LEFT)
			{
				if (offsetX <= -offsetY)
				{
					return 1;
				}
				else
				{
					return -1;
				}
			}
			else if (dir == LEFT)
			{
				if (offsetY <= 0)
				{
					return 1;
				}
				else
				{
					return -1;
				}
			}
			else if (dir == DOWN_LEFT)
			{
				if (offsetY <= offsetX)
				{
					return 1;
				}
				else
				{
					return -1;
				}
			}
			return 1;
		}
	}
}