package com.view.gameWindow.scene.entity.entityItem
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.cfgdata.MapTeleportCfgData;
	import com.view.gameWindow.scene.entity.constants.ActionTypes;
	import com.view.gameWindow.scene.entity.constants.Direction;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.interf.ITeleporter;
	import com.view.gameWindow.scene.entity.model.EntityModelsManager;
	import com.view.gameWindow.scene.entity.model.base.EntityModel;
	import com.view.gameWindow.scene.entity.model.imageItem.ImageItem;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	
	public class Teleporter extends Unit implements ITeleporter
	{
		private var _config:MapTeleportCfgData;
		
		public function Teleporter(cfgData:MapTeleportCfgData)
		{
			_config = cfgData;
			_entityId = _config.id;
			tileX = _config.x_from;
			tileY = _config.y_from;
		}
		
		public function get teleportId():int
		{
			return _config.id;
		}
		/**传送阵是否在副本完成前隐藏*/
		public function get isHide():Boolean
		{
			return Boolean(_config.is_hide);
		}
		
		public override function show():void
		{
			super.show();
			alpha = 1;
			_entityModel = EntityModelsManager.getInstance().getAndUseEntityModel(ResourcePathConstants.ENTITY_RES_OTHER_LOAD + _config.url + "/", "", "", "", "", "", "", "", EntityModel.N_DIRECTION_1);
			_direction = Direction.DOWN;
			idle();
		}
		
		public override function get entityType():int
		{
			return EntityTypes.ET_TELEPORTER;
		}
		
		public override function initViewBitmap():void
		{
			super.initViewBitmap();
			_viewBitmap.blendMode = BlendMode.LIGHTEN;
		}
		
		protected override function updateView(timeDiff:int):void
		{
			if (_entityModel)
			{
				_frameStartTime += timeDiff;
				initAction();
				if(_direction != Direction.INVALID_DIRECTION && _currentActionId != ActionTypes.NOACTION && _entityModel.checkReadyByActionIdAndDirection(ActionTypes.getShowActionByCurrentAction(_currentActionId), _direction) && _entityModel.available)
				{
					if(_frameStartTime >= (_frameRate - 0.5) * FRAME_TIME)
					{
						_frameStartTime = 0;
						if(_currentFrame >= _endFrame)
						{
							if(_actionRepeat)
							{
								_currentFrame = _startFrame + 1;
							}
						}
						else
						{
							_currentFrame++;
						}
						var imageItem:ImageItem = _entityModel.getImageItemByFrame(_currentFrame + _direction * _entityModel.nFrame);
						if (imageItem)
						{
							var bitmapData:BitmapData = imageItem.bitmapData;
							if (!_viewBitmap || !contains(_viewBitmap))
							{
								initViewBitmap();
							}
							if (_viewBitmap.bitmapData != bitmapData)
							{
								_viewBitmap.bitmapData = bitmapData;
							}
							if (_viewBitmap.x != -_entityModel.width/2 + imageItem.offsetX)
							{
								_viewBitmap.x = -_entityModel.width/2 + imageItem.offsetX;
							}
							if (_viewBitmap.y != -_entityModel.height + _entityModel.shadowOffset + imageItem.offsetY)
							{
								_viewBitmap.y = -_entityModel.height + _entityModel.shadowOffset + imageItem.offsetY;
							}
							refreshNameTxtPos();
						}
					}
				}
			}
		}
		
		public override function get tileDistToReach():int
		{
			return 0;
		}
		
		public override function destory():void
		{
			super.destory();
		}
	}
}