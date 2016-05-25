package com.view.gameWindow.scene.entity.entityItem
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.consts.HeadHpConst;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.Direction;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstTrailer;
	import com.view.gameWindow.scene.map.path.MapPathManager;
	import com.view.gameWindow.scene.map.utils.MapTileUtils;
	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class FirstTrailer extends Trailer implements IFirstTrailer
	{
		private static const MAX_TILE_DIST_FROM_PLAYER:int = 12;
		private static const MIN_TILE_DIST_FROM_PLAYER:int = 2;
		
		private var _readyToMove:Boolean;
		private var _moveTime:int;
		
		override public function get isEnemy():Boolean
		{
			return false;
		}
		
		public function FirstTrailer()
		{
			_readyToMove = true;
			_moveTime = 0;
		}
		
		public override function updatePos(timeDiff:int):void
		{
			var oldTileX:int = _tileX;
			var oldTileY:int = _tileY;
			super.updatePos(timeDiff);
			_moveTime += timeDiff;
			if (_tileX != oldTileX || _tileY != oldTileY || _moveTime > 500)
			{
				_readyToMove = true;
			}
			autoMove();
		}
		
		private function autoMove():void
		{
			if (!_readyToMove || _isPalsy || _isFrozen)
			{
				return;
			}
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			if (!firstPlayer || firstPlayer.tileDistance(_tileX, _tileY) > MAX_TILE_DIST_FROM_PLAYER || firstPlayer.tileDistance(_tileX, _tileY) <= MIN_TILE_DIST_FROM_PLAYER)
			{
				_readyToMove = false;
				_moveTime = 0;
				return;
			}
			var path:Array = MapPathManager.getInstance().findPath(new Point(_tileX, _tileY), new Point(firstPlayer.tileX, firstPlayer.tileY), _tileX - MAX_TILE_DIST_FROM_PLAYER, _tileY - MAX_TILE_DIST_FROM_PLAYER, _tileX + MAX_TILE_DIST_FROM_PLAYER, _tileY + MAX_TILE_DIST_FROM_PLAYER, MIN_TILE_DIST_FROM_PLAYER);
			{
				if (path && path.length >= 2)
				{
					_readyToMove = false;
					_moveTime = 0;
					var targetCandidatePos:Point = path[1];
					var dir:int = Direction.getDirectionByTile(_tileX, _tileY, targetCandidatePos.x, targetCandidatePos.y);
					var targetPos:Point = MapTileUtils.getAroundTile(_tileX, _tileY, dir);
					sendServerMove(targetPos.x, targetPos.y);
				}
			}
		}
		
		override public function showHp(bool:Boolean = true):void
		{
			_maxHp = _trailerCfgData.maxhp;
			_url = HeadHpConst.GREEN;
			super.showHp(bool);
		}
		
		private function sendServerMove(targetX:int, targetY:int):void
		{
			var data:ByteArray=new ByteArray();
			data.endian=Endian.LITTLE_ENDIAN;
			data.writeShort(_tileX);
			data.writeShort(_tileY);
			data.writeShort(targetX);
			data.writeShort(targetY);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_TRAILER_MOVE, data);
		}
		
		public override function destory():void
		{
			super.destory();
		}
	}
}