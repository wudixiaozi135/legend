package com.view.gameWindow.scene.entity.entityItem
{
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subuis.minimap.MiniMap;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.map.IMapPanel;
    import com.view.gameWindow.scene.entity.constants.ActionTypes;
    import com.view.gameWindow.scene.entity.constants.Direction;
    import com.view.gameWindow.scene.entity.effect.interf.IEntityPermanentEffect;
    import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
    import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
    import com.view.gameWindow.scene.entity.model.EntityModelsManager;
    import com.view.gameWindow.scene.entity.model.base.EntityModel;
    import com.view.gameWindow.scene.entity.model.imageItem.ImageItem;
    import com.view.newMir.sound.SoundManager;
    import com.view.newMir.sound.constants.SoundIds;
    
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.utils.getTimer;

    public class FirstPlayer extends Player implements IFirstPlayer
	{
		private var _autoJobManager:AutoJobManager;
		
		private var _bottomEffect:IEntityPermanentEffect;
		
		public function FirstPlayer()
		{
			_autoJobManager = AutoJobManager.getInstance();
		}
		
		override protected function assignNameColorDefault():void
		{
//			_nameColor = 0x90ff00;
			_nameColor = 0xffffff;
		}
		
		override protected function assignNameColorBySth():void
		{
			//玩家自己的名字不需要根据需要改变
		}
		
		public override function show():void
		{
			super.show();
			if (!_bottomEffect)
			{
//				_bottomEffect = addPermanentBottomEffect("foot_01:1");
				resetLayer();
			}
		}
		
		public override function updateFrame(timeDiff:int):void
		{
			_autoJobManager.update();
			super.updateFrame(timeDiff);
		}
		
		public override function updatePos(timeDiff:int):void
		{
			if (_hp > 0 && (_targetPixelX != _pixelX || _targetPixelY != _pixelY))
			{
				var distance:Number = Math.sqrt((_targetPixelX - _pixelX) * (_targetPixelX - _pixelX) + (_targetPixelY - _pixelY) * (_targetPixelY - _pixelY));
				var moveDist:Number = timeDiff / 1000 * directSpeed;
				if (moveDist >= distance)
				{
					pixelX = _targetPixelX;
					pixelY = _targetPixelY;
					_knocking = false;
				}
				else
				{
					var newPixelX:Number = _pixelX + moveDist * (_targetPixelX - _pixelX) / distance;
					var newPixelY:Number = _pixelY + moveDist * (_targetPixelY - _pixelY) / distance;
					if (Math.abs(_targetPixelX - newPixelX) < 1)
					{
						pixelX = targetPixelX;
					}
					else
					{
						pixelX = newPixelX;
					}
					if (Math.abs(_targetPixelY - newPixelY) < 1)
					{
						pixelY = targetPixelY;
					}
					else
					{
						pixelY = newPixelY;
					}
				}
				if (!knocking && !_beKnockPushing)
				{
					var newDir:int = Direction.getDirectionByPixel(_pixelX, _pixelY, _targetPixelX, _targetPixelY, _direction);
					if (newDir != Direction.INVALID_DIRECTION && _direction != newDir)
					{
						_direction = newDir;
					}
				}
			}
			//
//			var miniMap:MiniMap = MainUiMediator.getInstance().miniMap as MiniMap;
//			miniMap.refreshMiniMapPos(pixelX, pixelY);
//			miniMap.refreshPlayerSign(entityId);
			
			var miniMap:MiniMap = MainUiMediator.getInstance().miniMap as MiniMap;
			if(miniMap)
			{
				miniMap.refreshMiniMapPos(tileX, tileY);
				miniMap.refreshPlayerSign(entityId);
			}
			
			
			var mapPanel:IMapPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_MAP) as IMapPanel;
			if(mapPanel)
			{
				mapPanel.refreshFirstPlayerSign();
			}
		}
		
		protected override function updateView(timeDiff:int):void
		{
			updateAlpha();
			if (_entityModel || _newEntityModel)
			{
				_frameStartTime += timeDiff;
				updateAction();
				initAction();
				if(_direction != Direction.INVALID_DIRECTION && _currentActionId != ActionTypes.NOACTION && (_newEntityModel && _newEntityModel.checkReadyByActionIdAndDirection(ActionTypes.getShowActionByCurrentAction(_currentActionId), _direction) && _newEntityModel.available || _entityModel && _entityModel.checkReadyByActionIdAndDirection(ActionTypes.getShowActionByCurrentAction(_currentActionId), _direction) && _entityModel.available))
				{
					if(_frameStartTime >= (_frameRate - 0.5) * FRAME_TIME)
					{
						_frameStartTime = 0;
						if(_currentFrame >= _endFrame)
						{
							if(_actionRepeat)
							{
								_currentFrame = _startFrame + 1;
								if (_entityModel && _entityModel.available)
								{
									if (_currentActionId == ActionTypes.RUN)
									{
										SoundManager.getInstance().playEffectSound(SoundIds.SOUND_ID_RUN);
									}
									else if (_currentActionId == ActionTypes.WALK)
									{
										SoundManager.getInstance().playEffectSound(SoundIds.SOUND_ID_WALK);
									}
								}
							}
						}
						else
						{
							_currentFrame++;
						}
						var imageItem:ImageItem = null;
						if (_newEntityModel && _newEntityModel.checkReadyByActionIdAndDirection(ActionTypes.getShowActionByCurrentAction(_currentActionId), _direction) && _newEntityModel.available)
						{
							imageItem = _newEntityModel.getImageItemByFrame(_currentFrame + _direction * _newEntityModel.nFrame);
							if (imageItem)
							{
								EntityModelsManager.getInstance().unUseModel(_entityModel);
								_entityModel = _newEntityModel;
								_newEntityModel = null;
								if (_entityModel)
								{
									var iDir:int = Direction.DOWN;
									for (; iDir < Direction.TOTAL_DIRECTION; ++iDir)
									{
										_entityModel.checkReadyByActionIdAndDirection(ActionTypes.RUN, iDir);
										_entityModel.checkReadyByActionIdAndDirection(ActionTypes.WALK, iDir);
									}
								}
							}
						}
						if (!imageItem && _entityModel)
						{
							imageItem = _entityModel.getImageItemByFrame(_currentFrame + _direction * _entityModel.nFrame);
						}
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
							if (isShowShadow)
							{
								if (_shadow.bitmapData != imageItem.shadow)
								{
									_shadow.bitmapData = imageItem.shadow;
								}
								var skewX:Number = - 0.5;
								var yScale:Number = 0.5;
								var tx:Number = - _entityModel.width * 0.5 + imageItem.baseOffsetX - skewX * (_entityModel.height - _entityModel.shadowOffset - imageItem.baseOffsetY);
								var ty:Number = -_entityModel.height + _entityModel.shadowOffset + imageItem.baseOffsetY;
								var matrix:Matrix = new Matrix(1, 0, skewX, yScale, tx, -skewX * ty);
								_shadow.transform.matrix = matrix;
								refreshNameTxtPos();
								refreshBuffPos();
							}
						}
						else
						{
							if (_viewBitmap && _viewBitmap.bitmapData)
							{
								_viewBitmap.bitmapData = null;
							}
							if (_shadow && _shadow.bitmapData)
							{
								_shadow.bitmapData = null;
							}
						}
					}
				}
				else
				{
					if (_viewBitmap && _viewBitmap.bitmapData)
					{
						_viewBitmap.bitmapData = null;
					}
					if (_shadow && _shadow.bitmapData)
					{
						_shadow.bitmapData = null;
					}
				}
			}
			else
			{
				if (_viewBitmap && _viewBitmap.bitmapData)
				{
					_viewBitmap.bitmapData = null;
				}
				if (_shadow && _shadow.bitmapData)
				{
					_shadow.bitmapData = null;
				}
			}
		}
		
		override public function get isEnemy():Boolean
		{
			return false;
		}
		
		public function get entityModel():EntityModel
		{
			return _entityModel;
		}
		
		override public function isMouseOn():Boolean
		{
			return false;
		}
		
		public function get knocking():Boolean
		{
			if (_knocking)
			{
				if (getTimer() - _lastKnockTick >= MAX_KNOCK_TIME)
				{
					_knocking = false;
				}
			}
			return _knocking;
		}
		
		public function startKnock():void
		{
			_lastKnockTick = getTimer();
		}
		
		public override function knockTo(currentTileX:int, currentTileY:int, nextTileX:int, nextTileY:int, targetX:int, targetY:int, isPushBack:Boolean):void
		{
			if (isPushBack)
			{
				tileX = currentTileX;
				tileY = currentTileY;
			}
			targetTileX = targetX;
			targetTileY = targetY;
			_knocking = true;
			_knockSpeed = _speed * LivingUnit.KNOCK_SPEED_RATE / 100;
			if (currentTileX == targetX && currentTileY == targetY)
			{
				_knocking = false;
				_lastKnockTick = 0;
			}
		}
		
		public override function run():void
		{
			if (_currentActionId != ActionTypes.RUN && _entityModel && _entityModel.available)
			{
				SoundManager.getInstance().playEffectSound(SoundIds.SOUND_ID_RUN);
			}
			super.run();
		}
		
		public override function walk():void
		{
			if (_currentActionId != ActionTypes.WALK)
			{
				SoundManager.getInstance().playEffectSound(SoundIds.SOUND_ID_WALK);
			}
			super.walk();
		}

		override public function set isWingShow(value:Boolean):void
		{
			super.isWingShow = value;
			changeModel();
		}

		override public function set stallStatue(value:int):void
		{
			if (value)
			{
				if (_bottomEffect)
				{
					removeEffect(_bottomEffect);
					_bottomEffect.destory();
					_bottomEffect = null;
				}
                idle();
			} else
			{
				if (!_bottomEffect)
				{
//					_bottomEffect = addPermanentBottomEffect("foot_01:1");
				}
			}
			super.stallStatue = value;
		}

		public override function destory():void
		{
			super.destory();
			_bottomEffect = null;
		}
	}
}