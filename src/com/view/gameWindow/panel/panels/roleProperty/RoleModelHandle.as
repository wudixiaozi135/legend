package com.view.gameWindow.panel.panels.roleProperty
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.ActionTypes;
	import com.view.gameWindow.scene.entity.constants.Direction;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.scene.entity.model.EntityModelsManager;
	import com.view.gameWindow.scene.entity.model.base.EntityModel;
	import com.view.gameWindow.scene.entity.model.imageItem.ImageItem;
	import com.view.gameWindow.scene.entity.model.utils.EntityModelUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * 角色模型处理类
	 * @author Administrator
	 */	
	public class RoleModelHandle implements IObserver
	{
		protected var _entityModel:EntityModel;
		protected var _newEntityModel:EntityModel;
		private var _direction:int;
		private var _frameRateCount:int;
		private var _frameRate:int;
		private var _currentFrame:int;
		private var _endFrame:int;
		private var _actionRepeat:Boolean;
		private var _startFrame:int;
		private var _viewBitmap:Bitmap;
		private var _timer:Timer;
		protected var isInit:Boolean;
		private var _roleDatamanager:RoleDataManager = RoleDataManager.instance;
		
		public function RoleModelHandle(layer:MovieClip)
		{
			_viewBitmap = new Bitmap();
			_viewBitmap.smoothing = true;
			layer.addChild(_viewBitmap);
			layer.mouseEnabled = false;
			layer.mouseChildren = false;
			_endFrame = 0;
			_direction = Direction.RIGHT;
			_actionRepeat = true;
			_timer = new Timer(16.67);
			_timer.addEventListener(TimerEvent.TIMER,refreshModel);
			_timer.start();
			//
			EntityLayerManager.getInstance().attach(this);
			
			isInit = false;
		}
		
		private function refreshModel(event:TimerEvent):void
		{
			if(_direction != Direction.INVALID_DIRECTION && (_newEntityModel && _newEntityModel.checkReadyByActionIdAndDirection(ActionTypes.getShowActionByCurrentAction(ActionTypes.REVEAL), _direction) && _newEntityModel.available || _entityModel && _entityModel.checkReadyByActionIdAndDirection(ActionTypes.getShowActionByCurrentAction(ActionTypes.REVEAL), _direction) && _entityModel.available))
			{
				if(!isInit)
				{
					var model:EntityModel = _entityModel || _newEntityModel;
					if (model)
					{
						isInit = true;
						_currentFrame = _startFrame = model.revealStart - 1;
						_endFrame = model.revealEnd;
						_frameRate = model.revealFrameRate;
						_frameRateCount = _frameRate;
					}
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
					var imageItem:ImageItem = null;
					if (_newEntityModel && _newEntityModel.checkReadyByActionIdAndDirection(ActionTypes.getShowActionByCurrentAction(ActionTypes.REVEAL), _direction) && _newEntityModel.available)
					{
						imageItem = _newEntityModel.getImageItemByFrame(_currentFrame + _direction * _newEntityModel.nFrame);
						if (imageItem)
						{
							EntityModelsManager.getInstance().unUseModel(_entityModel);
							_entityModel = _newEntityModel;
							_newEntityModel = null;
						}
					}
					if (!imageItem && _entityModel)
					{
						imageItem = _entityModel.getImageItemByFrame(_currentFrame + _direction * _entityModel.nFrame);
					}
					if (imageItem)
					{
						var bitmapData:BitmapData = imageItem.bitmapData;
						_viewBitmap.bitmapData = bitmapData;
						_viewBitmap.x = -_entityModel.width/2 + imageItem.offsetX;
						_viewBitmap.y = -_entityModel.height + _entityModel.shadowOffset + imageItem.offsetY-80;
					}
				}
			}
		}
		
		public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_PLAYER_STATUS)
			{
				changeModel();
			}
		}
		
		public function changeModel():void
		{
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			if (firstPlayer)
			{
				_newEntityModel = EntityModelUtil.getEntityModel(firstPlayer.cloth, _roleDatamanager.hideFactionData.hideShizhuang == 1?0:firstPlayer.fashion, firstPlayer.weapon, _roleDatamanager.hideFactionData.hideHuanwu == 1?0:firstPlayer.magicWeapon, 
					_roleDatamanager.hideFactionData.hideDouli == 1?0:firstPlayer.hair, firstPlayer.shield, firstPlayer.isWingShow&&(_roleDatamanager.hideFactionData.hideChibang == 1)?0:firstPlayer.wing, firstPlayer.sex, firstPlayer.currentAcionId, EntityModel.N_DIRECTION_8, firstPlayer.hideWeaponEffect)
			}
		}
		
		public function destroy():void
		{
			EntityLayerManager.getInstance().detach(this);
			if(_timer)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER,refreshModel);
			}
			_timer = null;
			_entityModel = null;
			if(_viewBitmap)
			{
				if(_viewBitmap.bitmapData)
					_viewBitmap.bitmapData = null;
				if(_viewBitmap.parent)
					_viewBitmap.parent.removeChild(_viewBitmap);
			}
			_viewBitmap = null;
			_direction = 0;
			_frameRateCount = 0;
			_frameRate = 0;
			_currentFrame = 0;
			_endFrame = 0;
			_actionRepeat = false;
			_startFrame = 0;
		}
	}
}