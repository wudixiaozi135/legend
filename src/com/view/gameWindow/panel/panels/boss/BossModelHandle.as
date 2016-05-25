package com.view.gameWindow.panel.panels.boss
{
 
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.view.gameWindow.panel.panels.hero.tab1.EntityModeInUIlHandle;
	import com.view.gameWindow.scene.entity.constants.ActionTypes;
	import com.view.gameWindow.scene.entity.constants.Direction;
	import com.view.gameWindow.scene.entity.model.EntityModelsManager;
	import com.view.gameWindow.scene.entity.model.base.EntityModel;
	import com.view.gameWindow.scene.entity.model.imageItem.ImageItem;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;

	public class BossModelHandle extends EntityModeInUIlHandle
	{
		public var data:MonsterCfgData;
		private var _w:Number;
		private var _h:Number;
		private var layer:MovieClip;
		public function BossModelHandle(layer:MovieClip)
		{
			super(layer);
			this.layer = layer;
			_direction = Direction.DOWN;
			 
		}
		public function get width():Number
		{
			return layer.width;
		}
		public function get height():Number
		{
			return layer.height;
		}
		
		override public function changeModel():void
		{
			isInit = false;			
			var clothPath:String  = ResourcePathConstants.ENTITY_RES_MONSTER_LOAD + data.monster_body + "/"; 
			var oldEntityModel:EntityModel = _entityModel;
			_entityModel = EntityModelsManager.getInstance().getAndUseEntityModel(clothPath, "", "", "", "", "", "", "", EntityModel.N_DIRECTION_5);
			EntityModelsManager.getInstance().unUseModel(oldEntityModel);
		}
		
		
		public function setBitmapSize(w:Number,h:Number):void
		{
			 _w = w;
			 _h= h;
		}
		
		public function setOffet():void
		{
			
		}
		
		override protected function refreshModel(event:TimerEvent):void
		{
			if(_direction == Direction.INVALID_DIRECTION)
			{
				return;
			}
			if(!_entityModel)
			{
				return;
			}
			if(!_entityModel.checkReadyByActionIdAndDirection(ActionTypes.IDLE, _direction))
			{
				return;
			}
			if(!_entityModel.available)
			{
				return;
			}
			if(!isInit)
			{
				isInit = true;
				_currentFrame = _startFrame = _entityModel.idleStart - 1;
				_endFrame = _entityModel.idleEnd;
				_frameRate = _entityModel.idleFrameRate;
				_frameRateCount = _frameRate;
			}
			_frameRateCount++;
			if(_frameRateCount>_frameRate)
			{
				_frameRateCount=0;
				if(_currentFrame>=_endFrame)
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
					_viewBitmap.bitmapData = bitmapData;
					_viewBitmap.width = _w;
					_viewBitmap.height =_h;
					updatePostion(imageItem);
				}
			}
		}
		
		protected override function updatePostion(imageItem:ImageItem):void
		{
			_viewBitmap.x = -_entityModel.width/2 + imageItem.offsetX;
			_viewBitmap.y = -_entityModel.height + _entityModel.shadowOffset + imageItem.offsetY-40;
		}
		
	}
}