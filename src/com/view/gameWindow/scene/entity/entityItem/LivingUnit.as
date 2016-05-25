package com.view.gameWindow.scene.entity.entityItem
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.configData.cfgdata.BuffCfgData;
    import com.model.configData.cfgdata.SkillCfgData;
    import com.model.consts.HeadHpConst;
    import com.model.consts.TypeInterval;
    import com.view.gameWindow.panel.panels.buff.BuffData;
    import com.view.gameWindow.panel.panels.buff.BuffDataManager;
    import com.view.gameWindow.panel.panels.buff.BuffListData;
    import com.view.gameWindow.scene.effect.item.EffectBase;
    import com.view.gameWindow.scene.effect.item.delay.DelayEffect;
    import com.view.gameWindow.scene.effect.item.interf.IEffectBase;
    import com.view.gameWindow.scene.entity.constants.ActionTypes;
    import com.view.gameWindow.scene.entity.constants.BuffFilterTypes;
    import com.view.gameWindow.scene.entity.constants.BuffSpecials;
    import com.view.gameWindow.scene.entity.constants.Direction;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    import com.view.gameWindow.scene.entity.effect.EntityBuffEffect;
    import com.view.gameWindow.scene.entity.effect.EntityPermanentEffect;
    import com.view.gameWindow.scene.entity.effect.delay.DelayEntityHitEffect;
    import com.view.gameWindow.scene.entity.effect.interf.IEntityPermanentEffect;
    import com.view.gameWindow.scene.entity.entityInfoLabel.LivingUnitInfoLabel;
    import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
    import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
    import com.view.gameWindow.scene.entity.entityItem.interf.ILivingUnit;
    import com.view.gameWindow.scene.entity.model.EntityModelsManager;
    import com.view.gameWindow.scene.entity.model.base.EntityModel;
    import com.view.gameWindow.scene.entity.model.imageItem.ImageItem;
    import com.view.gameWindow.scene.map.path.MapPathManager;
    import com.view.gameWindow.scene.map.utils.MapTileUtils;
    import com.view.gameWindow.scene.stateAlert.StateAlertManager;
    import com.view.gameWindow.util.HtmlUtils;
    
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.filters.ColorMatrixFilter;
    import flash.filters.GlowFilter;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;

    public class LivingUnit extends Unit implements ILivingUnit
    {
        public static const MAX_KNOCK_TIME:int = 2000;
		public static const KNOCK_SPEED_RATE:int = 250;
        protected static var WALK_SPEED_TO_RUN:Number = 0.4;
        protected static var POISON_FILETER:ColorMatrixFilter = new ColorMatrixFilter([0.3, 0, 0, 0, 0, 0.3, 0.3, 0.3, 0, 0, 0, 0, 0.3, 0, 0, 0, 0, 0, 1, 0]);
        protected static var PALSY_FILETER:ColorMatrixFilter = new ColorMatrixFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0]);

        protected var _newEntityModel:EntityModel;

        protected var _hp:int;
        protected var _maxHp:int;
        protected var _speed:int;

        protected var _targetTileX:int;
        protected var _targetTileY:int;
        protected var _targetPixelX:Number;
        protected var _targetPixelY:Number;

        protected const STATE_ALERT_TAP:int = 1;
        protected var stateArray:Array;
        protected var stateAlertCount:int;
        protected var _stateAlertOffsetY:int = -100;

//        protected var _iconCell:IconCellEx;
//        protected var _iconCell2:IconCellEx;
        protected var _hpTitle:TextField;
//        protected var _hpMask:Shape;
		protected var _hpBar:LivingUnitHpBar;

        protected var _url:String;

        public var isShowTitle:Boolean;
        public var isShowHp:Boolean;
        protected var _nameInBody:Boolean = false;
        protected var _topBuffEffects:Dictionary;
        protected var _bottomBuffEffects:Dictionary;
        protected var _buffFilters:Array;

        protected var _delayEffects:Vector.<DelayEffect>;

		protected var _knockSpeed:int;
		protected var _knocking:Boolean;
		protected var _lastKnockTick:int;
        protected var _beKnockPushingSpeed:int;
        protected var _beKnockPushing:Boolean;
        protected var _lastBeKnockPushTick:int;

        protected var _buffHiding:Boolean;

        protected var _isPalsy:Boolean;
        protected var _isFrozen:Boolean;
        private var _hpScaleX:Number;

        public function LivingUnit()
        {
            _hp = 0;
            _buffFilters = [];
			_knocking = false;
			_lastKnockTick = 0;
            _beKnockPushing = false;
            _lastBeKnockPushTick = 0;
            _buffHiding = false;

            _isPalsy = false;
            _isFrozen = false;
        }

        public function get maxHp():int
        {
            return _maxHp;
        }

        public function set maxHp(value:int):void
        {
            _maxHp = value;
        }

        public override function show():void
        {
            super.show();
            refreshBuffs();
            if (_hp <= 0)
            {
                dead();
            }
        }

        public override function hide():void
        {
            super.hide();
            hideBuff();
        }

        public override function initViewBitmap():void
        {
            super.initViewBitmap();
            if (_viewBitmap && _buffFilters.length > 0)
            {
                _viewBitmap.filters = [].concat(_buffFilters);
            }
        }

        public override function initInfoLabel():void
        {
            _infoLabel = new LivingUnitInfoLabel();
        }

        public function get direction():int
        {
            /*trace("get"+this.toString()+_direction);*/
            return _direction;
        }

        public function set direction(value:int):void
        {
            if (_direction != value && value != Direction.INVALID_DIRECTION)
            {
                _direction = value;
            }
        }

        override public function setSelected(value:Boolean):void
        {
            _isShowName = value;
            if (value)
            {
                initUpHeadContent();
                addSelectEffect();
            }
            else
            {
                if (entityType != EntityTypes.ET_PLAYER && entityType != EntityTypes.ET_HERO && entityType != EntityTypes.ET_PET)//修复英雄名字会闪烁
                {
                    clearUpHeadContent();
                }
                if (_hp == 0 || _hp == _maxHp)
                {
                    if (entityType != EntityTypes.ET_PLAYER)
                    {
                        hideHp();
                    } else
                    {
                        if (_hp == 0)
                        {
                            hideHp();
                        }
                    }
                }
                removeSelectEffect();
            }
        }

        public override function addSelectEffect():void
        {
            if (!_selectEffect)
            {
                _selectEffect = addPermanentBottomEffect("foot_01:1");
            }
        }

        public function get directSpeed():int
        {
			if (_knocking)
			{
				if (getTimer() - _lastKnockTick >= MAX_KNOCK_TIME)
				{
					_knocking = false;
				}
			}
			if (_knocking)
			{
				switch (_direction)
				{
					case Direction.LEFT:
					case Direction.RIGHT:
						return _knockSpeed;
					case Direction.DOWN:
					case Direction.UP:
						return _knockSpeed * MapTileUtils.TILE_HEIGHT / MapTileUtils.TILE_WIDTH;
					case Direction.DOWN_LEFT:
					case Direction.DOWN_RIGHT:
					case Direction.UP_LEFT:
					case Direction.UP_RIGHT:
						return _knockSpeed * MapTileUtils.TILE_BEVEL / MapTileUtils.TILE_WIDTH;
					default:
						return 0;
				}
			}
			else if (_beKnockPushing)
            {
                switch (_direction)
                {
                    case Direction.LEFT:
                    case Direction.RIGHT:
                        return _beKnockPushingSpeed;
                    case Direction.DOWN:
                    case Direction.UP:
                        return _beKnockPushingSpeed * MapTileUtils.TILE_HEIGHT / MapTileUtils.TILE_WIDTH;
                    case Direction.DOWN_LEFT:
                    case Direction.DOWN_RIGHT:
                    case Direction.UP_LEFT:
                    case Direction.UP_RIGHT:
                        return _beKnockPushingSpeed * MapTileUtils.TILE_BEVEL / MapTileUtils.TILE_WIDTH;
                    default:
                        return 0;
                }
            }
            else
            {
                var speedRatio:Number = 1.0;
                if (_currentActionId == ActionTypes.WALK)
                {
                    speedRatio = WALK_SPEED_TO_RUN;
                }
                switch (_direction)
                {
                    case Direction.LEFT:
                    case Direction.RIGHT:
                        return _speed * speedRatio;
                    case Direction.DOWN:
                    case Direction.UP:
                        return _speed * MapTileUtils.TILE_HEIGHT / MapTileUtils.TILE_WIDTH * speedRatio;
                    case Direction.DOWN_LEFT:
                    case Direction.DOWN_RIGHT:
                    case Direction.UP_LEFT:
                    case Direction.UP_RIGHT:
                        return _speed * MapTileUtils.TILE_BEVEL / MapTileUtils.TILE_WIDTH * speedRatio;
                    default:
                        return 0;
                }
            }
            return 0;
        }

        public function get isEnemy():Boolean
        {
            return false;
        }

        override protected function refreshNameTxtPos():void
        {
            if (_nameTxt && (_entityModel && _entityModel.available || isHideModel))
            {
                _infoLabel.refreshNameTextPos(_nameTxt, modelHeight);
            }
        }

        public function get hp():int
        {
            return _hp;
        }

        public function set hp(value:int):void
        {
            if (value < _hp)
            {
                for each (var effect:EffectBase in _topEffects)
                {
                    var buffEffect:EntityBuffEffect = effect as EntityBuffEffect;
                    if (buffEffect)
                    {
                        buffEffect.hit();
                    }
                }
                if (_currentActionId == ActionTypes.IDLE || _currentActionId == ActionTypes.WALK || _currentActionId == ActionTypes.RUN)
                {
                    hurt();
                }
            }
            _hp = value;
        }

        public function get speed():int
        {
            return _speed;
        }

        public function set speed(value:int):void
        {
            _speed = value;
        }

        public function get targetTileX():int
        {
            return _targetTileX;
        }

        public function get targetTileY():int
        {
            return _targetTileY;
        }

        public function set targetTileX(value:int):void
        {
            _targetTileX = value;
            _targetPixelX = MapTileUtils.tileXToPixelX(_targetTileX);
        }

        public function set targetTileY(value:int):void
        {
            _targetTileY = value;
            _targetPixelY = MapTileUtils.tileYToPixelY(_targetTileY);
        }

        public function get targetPixelX():Number
        {
            return _targetPixelX;
        }

        public function get targetPixelY():Number
        {
            return _targetPixelY;
        }

        public function set targetPixelX(value:Number):void
        {
            _targetPixelX = value;
            _targetTileX = MapTileUtils.pixelXToTileX(_targetPixelX);
        }

        public function set targetPixelY(value:Number):void
        {
            _targetPixelY = value;
            _targetTileY = MapTileUtils.pixelYToTileY(_targetPixelY);
        }

        public function isArriveTarget():Boolean
        {
            return _pixelX == _targetPixelX && _pixelY == _targetPixelY;
        }

        public override function updateFrame(timeDiff:int):void
        {
            super.updateFrame(timeDiff);
            updateDelayEffect(timeDiff);
            if (timeDiff > FRAME_TIME_INT && timeDiff < FRAME_TIME_INT * 2)  //如果帧率已经不稳定的情况下
            {
                return;  //控制频率，以下的内容，不需要每帧都更新
            }
            updateStateAlert();
            if (_entityModel)
            {
                if (!isShowHp)
                {
                    showHp(true);
                }
                if (!isShowTitle)
                {
                    showHpTitle(true);
                }
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
                if (_direction != Direction.INVALID_DIRECTION && _currentActionId != ActionTypes.NOACTION && (_newEntityModel && _newEntityModel.checkReadyByActionIdAndDirection(ActionTypes.getShowActionByCurrentAction(_currentActionId), _direction) && _newEntityModel.available || _entityModel && _entityModel.checkReadyByActionIdAndDirection(ActionTypes.getShowActionByCurrentAction(_currentActionId), _direction) && _entityModel.available))
                {
                    if (_frameStartTime >= (_frameRate - 0.5) * FRAME_TIME)
                    {
                        _frameStartTime = 0;
                        if (_currentFrame >= _endFrame)
                        {
                            if (_actionRepeat)
                            {
                                _currentFrame = _startFrame + 1;
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
                            if (_viewBitmap.x != -_entityModel.width / 2 + imageItem.offsetX)
                            {
                                _viewBitmap.x = -_entityModel.width / 2 + imageItem.offsetX;
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
                                var skewX:Number = -0.5;
                                var yScale:Number = 0.5;
                                var tx:Number = -_entityModel.width * 0.5 + imageItem.baseOffsetX - skewX * (_entityModel.height - _entityModel.shadowOffset - imageItem.baseOffsetY);
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
            else if (_isHideModel)
            {
                addHideForPlayer();
                addHideForMonster();
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

        public function showHpTitle(bool:Boolean = true):void
        {
            if (!_hpTitle)
            {
                _hpTitle = new TextField();
                _hpTitle.mouseEnabled = false;
                _hpTitle.filters = [new GlowFilter(0x0, 1, 2, 2, 10)];
                addChild(_hpTitle);

                resetLayer();
            }

            var isPlayerHp:Boolean = false;
            if (entityType == EntityTypes.ET_PLAYER || entityType == EntityTypes.ET_HERO)
            {
                isPlayerHp = (_hp <= _maxHp);
            } else if (entityType == EntityTypes.ET_PET)
            {
                if (_isHideModel)
                {
                    isPlayerHp = (_hp <= _maxHp);
                } else
                {
                    isPlayerHp = (_hp < _maxHp);
                }
            }
            else
            {
                isPlayerHp = (_hp < _maxHp);
            }

            if ((isPlayerHp || !bool) && _hp)
            {
                var hpTip:String = HtmlUtils.createHtmlStr(0xffffff, String(_hp) + "/" + String(_maxHp));
                if (hpTip != _hpTitle.htmlText)
                {
                    _hpTitle.htmlText = hpTip;
                    _hpTitle.width = _hpTitle.textWidth + 3;
                    _hpTitle.height = _hpTitle.textHeight + 3;
                }
                if (_entityModel && modelHeight)
                {
                    _hpTitle.x = int(-_hpTitle.width / 2);
                    _hpTitle.y = -_entityModel.modelHeight - 8;
                    isShowTitle = true;
                }
                else
                {
                    if (_isHideModel)
                    {
                        _hpTitle.x = int(-_hpTitle.width / 2);
                        _hpTitle.y = -modelHeight - 8;
                        isShowTitle = true;
                    }
                }
                _hpTitle.visible = true;
            }
            else
            {
                hideHpTile();
            }
        }

        public function hideHpTile():void
        {
            _hpTitle ? _hpTitle.visible = false : null;
        }

        public function showHp(bool:Boolean = true):void
        {
            if (_entityModel && _entityModel.modelHeight)
            {
                initHpIcon(bool);
            }
            else
            {
                if (isHideModel)
                {
                    initHpIcon(bool);
                }
            }
        }

        private function initHpIcon(bool:Boolean):void
        {
//            if (!_iconCell && !_iconCell2)
			if(!_hpBar)
            {
                var isPlayerHp:Boolean = false;
                if (entityType == EntityTypes.ET_PLAYER || entityType == EntityTypes.ET_HERO)
                {
                    isPlayerHp = (_hp <= _maxHp);
                } else if (entityType == EntityTypes.ET_MONSTER)
                {//策划需求，怪物在屏蔽模型时，血条需要显示
                    if (_isHideModel)
                    {
                        isPlayerHp = (_hp <= _maxHp);
                    } else
                    {
                        isPlayerHp = (_hp < _maxHp);
                    }
                } else if (entityType == EntityTypes.ET_PET)
                {
                    if (_isHideModel)
                    {
                        isPlayerHp = (_hp <= _maxHp);
                    } else
                    {
                        isPlayerHp = (_hp < _maxHp);
                    }
                }
                else
                {
                    isPlayerHp = (_hp < _maxHp);
                }

                if ((isPlayerHp || !bool) && _hp)
                {
                    var hpPosY:int = modelHeight - 8;
                    var hpPosX:int = 49 / 2;
//                    _iconCell = new IconCellEx(this, -hpPosX, -hpPosY, 49, 4);
//
//                    _iconCell.mouseChildren = false;
//                    _iconCell.mouseEnabled = false;
//                    _iconCell.url = ResourcePathConstants.IMAGE_NPC_HEAD_HP_LOAD + HeadHpConst.BOTTOM + ResourcePathConstants.POSTFIX_PNG;
//                    _iconCell2 = new IconCellEx(this, -hpPosX, -hpPosY, 49, 4);
//
//                    _iconCell2.mouseChildren = false;
//                    _iconCell2.mouseEnabled = false;
//                    _iconCell2.url = ResourcePathConstants.IMAGE_NPC_HEAD_HP_LOAD + _url + ResourcePathConstants.POSTFIX_PNG;
//                    _hpScaleX = (_hp / _maxHp);
//
//                    _hpMask = new Shape();
//                    _hpMask.graphics.beginFill(0xcccccc);
//                    _hpMask.graphics.drawRect(0, 0, 49, 4);
//                    _hpMask.graphics.endFill();
//                    addChild(_hpMask);
//                    _hpMask.x = -hpPosX;
//                    _hpMask.y = -hpPosY;
//                    _iconCell2.mask = _hpMask;
//
////                    _iconCell2.scaleX = _hpScaleX;
//                    _hpMask.scaleX = _hpScaleX;
//                    _iconCell.visible = true;
//                    _iconCell2.visible = true;
					
					_hpBar = new LivingUnitHpBar(49,4,
						ResourcePathConstants.IMAGE_NPC_HEAD_HP_LOAD + HeadHpConst.BOTTOM + ResourcePathConstants.POSTFIX_PNG,
						ResourcePathConstants.IMAGE_NPC_HEAD_HP_LOAD + _url + ResourcePathConstants.POSTFIX_PNG);
					_hpBar.x = -hpPosX;
					_hpBar.y = -hpPosY;
					addChild(_hpBar);
					_hpBar.setValue(_hp,_maxHp,true);
                    isShowHp = true;

                    resetLayer();
                }
            }
            else
            {
//				_iconCell2.scaleX = _hp / _maxHp;
//                if (_hpScaleX != _hp / _maxHp)
//                {
//                    _hpScaleX = _hp / _maxHp;
//                    TweenMax.killTweensOf(_iconCell2);
//                    TweenMax.to(_hpMask, (1 - _hpScaleX), {scaleX: _hpScaleX});
//                }
				
				if(_hpBar)
				{
					_hpBar.setValue(_hp,_maxHp,false);
				}
				
                if (_hp <= 0)
                {
                    hideHp();
                }
                if (entityType == EntityTypes.ET_PET)
                {
                    if (_isHideModel == false)
                    {
                        if (_hp == _maxHp)
                        {
                            hideHp();
                        }
                    }
                }
            }
        }

        public function hideHp():void
        {
//            if (_iconCell && _iconCell2)
//            {
//                _iconCell.visible = false;
//                _iconCell2.visible = false;
//            }
//            if (_iconCell)
//            {
//                if (_iconCell.parent)
//                {
//                    _iconCell.parent.removeChild(_iconCell);
//                    _iconCell2.parent.removeChild(_iconCell2);
//                }
//                _iconCell = null;
//                _iconCell2 = null;
//            }
//            if (_hpMask)
//            {
//                if (_hpMask.parent)
//                {
//                    _hpMask.parent.removeChild(_hpMask);
//                }
//                _hpMask = null;
//            }
			if(_hpBar)
			{
				if(_hpBar.parent)
				{
					_hpBar.parent.removeChild(_hpBar);
				}
				_hpBar.destroy();
				_hpBar = null;
			}
        }

        public override function resetLayer():void
        {
            var index:int = 0;
            if (_shadow && contains(_shadow))
            {
                setChildIndex(_shadow, index++);
            }
            if (_bottomEffectContainer && contains(_bottomEffectContainer))
            {
                setChildIndex(_bottomEffectContainer, index++);
            }
            if (_viewBitmap && contains(_viewBitmap))
            {
                setChildIndex(_viewBitmap, index++);
            }
            if (_topEffectContainer && contains(_topEffectContainer))
            {
                setChildIndex(_topEffectContainer, index++);
            }
//            if (_iconCell && contains(_iconCell))
//            {
//                setChildIndex(_iconCell, index++);
//            }
//            if (_iconCell2 && contains(_iconCell2))
//            {
//                setChildIndex(_iconCell2, index++);
//            }
//            if (_hpMask && contains(_hpMask))
//            {
//                setChildIndex(_hpMask, index++);
//            }
			
			if(_hpBar && _hpBar.parent)
			{
				setChildIndex(_hpBar, index++);
			}
			
            if (_hpTitle && contains(_hpTitle))
            {
                setChildIndex(_hpTitle, index++);
            }
        }

        public function updatePos(timeDiff:int):void
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
                if (_beKnockPushing && _pixelX == _targetPixelX && _pixelY == _targetPixelY)
                {
                    _beKnockPushing = false;
                    _lastBeKnockPushTick = getTimer();
                }
                if (!_beKnockPushing)
                {
                    var newDir:int = Direction.getDirectionByPixel(_pixelX, _pixelY, _targetPixelX, _targetPixelY, _direction);
                    if (newDir != Direction.INVALID_DIRECTION && _direction != newDir)
                    {
                        _direction = newDir;
                    }
                }
            }
        }

        protected override function updateAlpha():void
        {
            if (_viewBitmap)
            {
                if (MapPathManager.getInstance().checkAlpha(_tileX, _tileY) || _buffHiding)
                {
                    if (_viewBitmap.alpha != HALF_ALPHA)
                    {
                        _viewBitmap.alpha = HALF_ALPHA;
                    }
                }
                else
                {
                    if (_viewBitmap.alpha != FULL_ALPHA)
                    {
                        _viewBitmap.alpha = FULL_ALPHA;
                    }
                }
            }
        }

        public function run():void
        {
            if (_currentActionId != ActionTypes.RUN)
            {
                _endFrame = 0;
                if (_entityModel && _entityModel.available)
                {
                    _currentFrame = _startFrame = _entityModel.runStart - 1;
                    _endFrame = _entityModel.runEnd;
                    _frameRate = _entityModel.runFrameRate;
                    _frameStartTime = _frameRate * FRAME_TIME;
                }
                _currentActionId = ActionTypes.RUN;
            }
            _actionRepeat = true;
        }

        public function pAttackPrepare():void
        {
            if (_entityModel && _entityModel.available)
            {
                _currentFrame = _startFrame = _entityModel.pattackStart - 1;
                _endFrame = _entityModel.pattackStart;
                _frameRate = 60;
                _frameStartTime = _frameRate * FRAME_TIME;
            }
            _currentActionId = ActionTypes.PATTACK_PREPARE;
            _actionRepeat = false;
        }

        public function pAttack():void
        {
            if (_currentActionId != ActionTypes.PATTACK)
            {
                _endFrame = 0;
                if (_entityModel && _entityModel.available)
                {
                    _currentFrame = _startFrame = _entityModel.pattackStart - 1;
                    _endFrame = _entityModel.pattackEnd;
                    _frameRate = _entityModel.pattackFrameRate;
                    _frameStartTime = _frameRate * FRAME_TIME;
                }
                _currentActionId = ActionTypes.PATTACK;
            }
            _actionRepeat = false;
        }

        public function pAttackLoop():void
        {
            if (_currentActionId != ActionTypes.PATTACK)
            {
                _endFrame = 0;
                if (_entityModel && _entityModel.available)
                {
                    _currentFrame = _startFrame = _entityModel.pattackStart - 1;
                    _endFrame = _entityModel.pattackEnd;
                    _frameRate = _entityModel.pattackFrameRate;
                    _frameStartTime = _frameRate * FRAME_TIME;
                }
                _currentActionId = ActionTypes.PATTACK;
            }
            _actionRepeat = true;
        }

        public function mAttackPrepare():void
        {
            if (_entityModel && _entityModel.available)
            {
                _currentFrame = _startFrame = _entityModel.mattackStart - 1;
                _endFrame = _entityModel.mattackStart;
                _frameRate = 60;
                _frameStartTime = _frameRate * FRAME_TIME;
            }
            _currentActionId = ActionTypes.MATTACK_PREPARE;
            _actionRepeat = false;
        }

        public function mAttack():void
        {
            if (_currentActionId != ActionTypes.MATTACK)
            {
                _endFrame = 0;
                if (_entityModel && _entityModel.available)
                {
                    _currentFrame = _startFrame = _entityModel.mattackStart - 1;
                    _endFrame = _entityModel.mattackEnd;
                    _frameRate = _entityModel.mattackFrameRate;
                    _frameStartTime = _frameRate * FRAME_TIME;
                }
                _currentActionId = ActionTypes.MATTACK;
            }
            _actionRepeat = false;
        }

        public function mAttackEnd():void
        {
            if (_entityModel && _entityModel.available)
            {
                _currentFrame = _startFrame = _entityModel.mattackEnd - 1;
                _endFrame = _entityModel.mattackEnd;
                _frameRate = 12;
                _frameStartTime = _frameRate * FRAME_TIME;
            }
            _currentActionId = ActionTypes.MATTACK_END;
            _actionRepeat = false;
        }

        public function hurt():void
        {
            if (_currentActionId != ActionTypes.HURT)
            {
                _endFrame = 0;
                if (_entityModel && _entityModel.available)
                {
                    _currentFrame = _startFrame = _entityModel.hurtStart - 1;
                    _endFrame = _entityModel.hurtEnd;
                    _frameRate = _entityModel.hurtFrameRate;
                    _frameStartTime = _frameRate * FRAME_TIME;
                }
                _currentActionId = ActionTypes.HURT;
            }
            _actionRepeat = false;
        }

        public function die():void
        {
            if (_currentActionId != ActionTypes.DIE)
            {
                _endFrame = 0;
                if (_entityModel && _entityModel.available)
                {
                    _currentFrame = _startFrame = _entityModel.deadStart - 1;
                    _endFrame = _entityModel.deadEnd;
                    _frameRate = _entityModel.deadFrameRate;
                    _frameStartTime = _frameRate * FRAME_TIME;
                }
                _currentActionId = ActionTypes.DIE;
            }
            _actionRepeat = false;
        }

        public function dead():void
        {
            if (_currentActionId != ActionTypes.DIE)
            {
                _endFrame = 0;
                if (_entityModel && _entityModel.available)
                {
                    _currentFrame = _startFrame = _entityModel.deadEnd - 1;
                    _endFrame = _entityModel.deadEnd;
                    _frameRate = _entityModel.deadFrameRate;
                    _frameStartTime = _frameRate * FRAME_TIME;
                }
                _currentActionId = ActionTypes.DIE;
            }
            _actionRepeat = false;
            hideHp();
        }

        public function gather():void
        {
            if (_currentActionId != ActionTypes.GATHER)
            {
                _endFrame = 0;
                if (_entityModel && _entityModel.available)
                {
                    _currentFrame = _startFrame = _entityModel.gatherStart - 1;
                    _endFrame = _entityModel.gatherEnd;
                    _frameRate = _entityModel.gatherFrameRate;
                    _frameStartTime = _frameRate * FRAME_TIME;
                }
                _currentActionId = ActionTypes.GATHER;
            }
            _actionRepeat = true;
        }

        public override function updateAction():void
        {
            if (_hp <= 0)
            {
                die();
            }
            else if (_currentActionId == ActionTypes.NOACTION || _currentActionId == ActionTypes.IDLE || _currentActionId == ActionTypes.RUN || _currentActionId == ActionTypes.WALK || (!_actionRepeat && _currentFrame >= _endFrame && _frameStartTime >= (_frameRate - 0.5) * FRAME_TIME))
            {
                if (_targetPixelX == _pixelX && _targetPixelY == _pixelY)
                {
                    if (_actionRepeat && _currentActionId == ActionTypes.GATHER)
                    {
                        gather();
                    }
                    else
                    {
                        idle();
                    }
                }
                else if (_currentActionId != ActionTypes.RUN && _currentActionId != ActionTypes.WALK && !_beKnockPushing)
                {
                    run();
                }
            }
        }

        public override function initAction():void
        {
            if (_endFrame == 0)
            {
                switch (_currentActionId)
                {
                    case ActionTypes.RUN:
                        _currentActionId = ActionTypes.NOACTION;
                        run();
                        break;
                    case ActionTypes.PATTACK:
                        _currentActionId = ActionTypes.NOACTION;
                        pAttack();
                        break;
                    case ActionTypes.MATTACK:
                        _currentActionId = ActionTypes.NOACTION;
                        mAttack();
                        break;
                    case ActionTypes.DIE:
                        _currentActionId = ActionTypes.NOACTION;
                        dead();
                        break;
                    case ActionTypes.GATHER:
                        _currentActionId = ActionTypes.GATHER;
                        gather();
                        break;
                    default:
                        super.initAction();
                        break;
                }
            }
        }

        /**
         * 显示状态信息，比如掉血，暴击等
         * @param targetHPChange
         * @param targetMPChange
         * @param actState
         */
        public function showStateAlert(targetHPChange:int, actState:int):void
        {
            if (isShow)
            {
                if (!stateArray)
                {
                    stateArray = [];
                }
                if (stateArray.length <= 1)//避免过多飘字，太多的就不显示了
                {
                    stateArray.push(targetHPChange);
                    stateArray.push(actState);
                }
            }
        }

        private function updateStateAlert():void
        {
            stateAlertCount++;
            if (stateArray)
            {
                if (stateArray.length > 0 && stateAlertCount > STATE_ALERT_TAP)
                {
                    var targetHPChange:int = stateArray.shift();
                    var actState:int = stateArray.shift();
                    addStateAlert(targetHPChange, actState);
                    if (stateArray.length == 0)
                    {
                        stateArray = null;
                    }
                    stateAlertCount = 0;
                }
            }
        }

        /**
         * SAS_NORMAL = 0<br> SAS_VIOLENT = 1,//暴击<br> SAS_CRIT = 2,//会心一击<br> SAS_DODGE = 3,//闪避<br> SAS_PARRY = 4,//格挡<br>5抵挡
         * @param targetHPChange
         * @param actState
         */
        protected function addStateAlert(targetHPChange:int, actState:int):void
        {
            var stateAlertManage:StateAlertManager = StateAlertManager.getInstance();

            var normalState:Boolean = actState == 0;
            var voilentState:Boolean = actState == 1;//暴击
            var critState:Boolean = actState == 2;//会心一击
            var dodgeState:Boolean = actState == 3;//闪避
            var parryState:Boolean = actState == 4;//格挡
            var didangState:Boolean = actState == 5;//抵挡
            var startY:int = (_entityModel && _entityModel.modelHeight) ? -_entityModel.modelHeight : _stateAlertOffsetY;
            if (normalState)//受伤
            {

            }
            if (voilentState)//暴击
            {
                stateAlertManage.showOrdinaryState(StateAlertManager.VOILENT, this, 0, startY);
            }
            if (critState)//会心一击
            {
                stateAlertManage.showOrdinaryState(StateAlertManager.CRIT, this, 0, startY);
            }
            if (dodgeState)//闪避
            {
                stateAlertManage.showOrdinaryState(StateAlertManager.DODGE, this, 0, startY);
            }
            if (parryState)//格挡
            {
                stateAlertManage.showOrdinaryState(StateAlertManager.PARRY, this, 0, startY);
            }
            if (didangState)//抵挡
            {
                stateAlertManage.showOrdinaryState(StateAlertManager.DIDANG, this, 0, startY);
            }
            if (targetHPChange != 0)
            {
                if (actState == -1)
                {
                    showMpStateAlert(targetHPChange);
                    return;
                }
                showHpStateAlert(targetHPChange, /*voilentState*/false);
            }
        }

        protected function showMpStateAlert(targetHPChange:int):void
        {
            /*var stateAlertManage:StateAlertManager = StateAlertManager.getInstance();
             stateAlertManage.showNum( StateAlertManager.BLUE , targetHPChange , true , "" , this , 0 , _stateAlertOffsetY );*/
        }

        protected function showHpStateAlert(targetHPChange:int, voilentState:Boolean):void
        {
            var stateAlertManage:StateAlertManager = StateAlertManager.getInstance();
            if (0 > targetHPChange)
            {
                stateAlertManage.showNum(StateAlertManager.RED, targetHPChange, true, "", this, 0, 0, voilentState);
            }
            else
            {
                stateAlertManage.showNum(StateAlertManager.HP, targetHPChange, true, "", this, 0, 0);
            }
        }

        private function updateDelayEffect(timeDiff:int):void
        {
            if (_delayEffects)
            {
                for (var i:int = 0; i < _delayEffects.length;)
                {
                    var delayEffect:DelayEffect = _delayEffects[i];
                    delayEffect.delay -= timeDiff;
                    if (delayEffect.delay <= 0)
                    {
                        var effect:IEffectBase = delayEffect.genEffect();
                        _topEffects.push(effect);
                        _topEffectContainer.addChild(effect as DisplayObject);
                        _delayEffects.splice(i, 1);
                        delayEffect = null;
                    }
                    else
                    {
                        ++i;
                    }
                }
                if (_delayEffects.length <= 0)
                {
                    _delayEffects = null;
                }
            }
        }

        protected override function refreshBuffPos():void
        {
            /*if(_buff)
             {
             if(_buff.y != -_entityModel.modelHeight-35)
             {
             _buff.y = -_entityModel.modelHeight-_buff.size - 10;
             }

             if(_buff.x != int(-_buff.width/2))
             {
             _buff.x = int(-_buff.width/2);
             }

             if(!_buff.parent)
             {
             addChild(_buff);
             }
             }*/
        }

        public function refreshBuffs():void
        {
            _buffFilters.length = 0;
            var newTopBuffEffects:Dictionary = new Dictionary();
            var newBottomBuffEffects:Dictionary = new Dictionary();
            var data:BuffListData = BuffDataManager.instance.getBuffList(entityType, entityId);
            if (data)
            {
                if (!_topBuffEffects)
                {
                    _topBuffEffects = new Dictionary();
                }
                if (!_bottomBuffEffects)
                {
                    _bottomBuffEffects = new Dictionary();
                }
                _buffHiding = false;
                _isPalsy = false;
                _isFrozen = false;
                for each (var buff:BuffData in data.list)
                {
                    if (_topBuffEffects[buff.id])
                    {
                        newTopBuffEffects[buff.id] = _topBuffEffects[buff.id];
                        delete _topBuffEffects[buff.id];
                    }
                    else if (buff.cfg && buff.cfg.top_effect && buff.cfg.top_effect != "0")
                    {
                        newTopBuffEffects[buff.id] = addTopBuffEffect(buff.cfg);
                    }
                    else
                    {
                        newTopBuffEffects[buff.id] = true;
                    }
                    if (_bottomBuffEffects[buff.id])
                    {
                        newBottomBuffEffects[buff.id] = _bottomBuffEffects[buff.id];
                        delete _bottomBuffEffects[buff.id];
                    }
                    else if (buff.cfg && buff.cfg.bottom_effect && buff.cfg.bottom_effect != "0")
                    {
                        newBottomBuffEffects[buff.id] = addBottomBuffEffect(buff.cfg);
                    }
                    else
                    {
                        newBottomBuffEffects[buff.id] = true;
                    }
                    if (buff.cfg.filter == BuffFilterTypes.GREEN_POISON_FILTER && _buffFilters.indexOf(POISON_FILETER) == -1)
                    {
                        _buffFilters.push(POISON_FILETER);
                    }
                    if (buff.cfg.special == BuffSpecials.BS_HIDING)
                    {
                        _buffHiding = true;
                    }
                    else if (buff.cfg.special == BuffSpecials.BS_PALSY)
                    {
                        _isPalsy = true;
                        if (_buffFilters.indexOf(PALSY_FILETER) == -1)
                        {
                            _buffFilters.push(PALSY_FILETER);
                        }
                    }
                    else if (buff.cfg.special == BuffSpecials.BS_FROZON)
                    {
                        _isFrozen = true;
                    }
                }
            }
            var key:String = "";
            var effect:EntityPermanentEffect = null;
            for (key in _topBuffEffects)
            {
                effect = _topBuffEffects[key] as EntityPermanentEffect;
                if (effect)
                {
                    removeEffect(effect);
                }
            }
            _topBuffEffects = newTopBuffEffects;
            for (key in _bottomBuffEffects)
            {
                effect = _bottomBuffEffects[key] as EntityPermanentEffect;
                if (effect)
                {
                    removeEffect(effect);
                }
            }
            _bottomBuffEffects = newBottomBuffEffects;
            setFilter();
        }

        public function hideBuff():void
        {
            for (var key:String in _topBuffEffects)
            {
                var effect:EntityPermanentEffect = _topBuffEffects[key] as EntityPermanentEffect;
                if (effect)
                {
                    removeEffect(effect);
                }
            }
            _topBuffEffects = null;
            _buffFilters.length = 0;
            _buffHiding = false;
            setFilter();
        }

        public function get isPalsy():Boolean
        {
            return _isPalsy;
        }

        public function get isFrozen():Boolean
        {
            return _isFrozen;
        }

        public function addTopBuffEffect(buffCfg:BuffCfgData):IEntityPermanentEffect
        {
            if (!_topEffects)
            {
                _topEffects = new Vector.<EffectBase>();
            }
            var split:Array = buffCfg.top_effect.split(":");
            if (split.length != 2)
            {
                return null;
            }
            var folder:String = split[0];
            var totalDir:int = int(split[1]);
            if (totalDir != 1)
            {
                return null;
            }
            var splitHit:Array = buffCfg.top_effect_hit.split(":");
            var effect:EntityPermanentEffect;
            if (splitHit.length != 2)
            {
                effect = new EntityPermanentEffect(folder + "/1");
                _topEffects.push(effect);
                _topEffectContainer.addChild(effect);
                return effect;
            }
            var folderHit:String = splitHit[0];
            var totalDirHit:int = int(splitHit[1]);
            if (totalDirHit != 1)
            {
                return null;
            }
            effect = new EntityBuffEffect(folder + "/1", folderHit + "/1");
            _topEffects.push(effect);
            _topEffectContainer.addChild(effect);
            return effect;
        }

        public function addBottomBuffEffect(buffCfg:BuffCfgData):IEntityPermanentEffect
        {
            if (!_bottomEffects)
            {
                _bottomEffects = new Vector.<EffectBase>();
            }
            var split:Array = buffCfg.bottom_effect.split(":");
            if (split.length != 2)
            {
                return null;
            }
            var folder:String = split[0];
            var totalDir:int = int(split[1]);
            if (totalDir != 1)
            {
                return null;
            }
            var effect:EntityPermanentEffect = new EntityPermanentEffect(folder + "/1");
            _bottomEffects.push(effect);
            _bottomEffectContainer.addChild(effect);
            return effect;
        }

        public function addTopHitEffect(skillCfgData:SkillCfgData, launcherPos:Point, groundPos:Point):void
        {
            var delay:int = 0;
            if (skillCfgData.after_interval_type == TypeInterval.FIXED)
            {
                delay = skillCfgData.before_interval + skillCfgData.after_interval;
            }
            else if (skillCfgData.after_interval_type == TypeInterval.VARIABLE)
            {
                var tileDist:Number = MapTileUtils.tileDistance(launcherPos.x, launcherPos.y, groundPos.x, groundPos.y);
                if (skillCfgData.speed)
                {
                    delay = skillCfgData.before_interval + tileDist * MapTileUtils.TILE_WIDTH / skillCfgData.speed * 1000;
                }
            }
            var split:Array = skillCfgData.effect_hit.split(":");
            if (split.length != 2)
            {
                return;
            }
            var folder:String = split[0];
            var totalDir:int = int(split[1]);
            if (totalDir != 1)
            {
                return;
            }
            var delayEffect:DelayEntityHitEffect = new DelayEntityHitEffect(delay, folder + "/1", skillCfgData.sound_hit);
            if (!_delayEffects)
            {
                _delayEffects = new Vector.<DelayEffect>();
            }
            _delayEffects.push(delayEffect);
        }

        public function showBornEffect():void
        {

        }

        protected override function setFilter():void
        {
            super.setFilter();
            if (_viewBitmap && _buffFilters.length > 0)
            {
                _viewBitmap.filters = _viewBitmap.filters.concat(_buffFilters);
            }
        }

        public function knockTo(currentTileX:int, currentTileY:int, nextTileX:int, nextTileY:int, targetX:int, targetY:int, isPushBack:Boolean):void
        {
            if (isPushBack)
            {
                tileX = currentTileX;
                tileY = currentTileY;
            }
            targetTileX = nextTileX;
            targetTileY = nextTileY;
			_knocking = true;
			_knockSpeed = _speed * LivingUnit.KNOCK_SPEED_RATE / 100;
        }

        public function knockedTo(tileX:int, tileY:int, speed:int):void
        {
            if (speed > 0)
            {
                targetTileX = tileX;
                targetTileY = tileY;
                var dir:int = Direction.getDirectionByTile(_targetTileX, _targetTileY, _tileX, _tileY);
                if (dir != Direction.INVALID_DIRECTION)
                {
                    _direction = dir;
                }
                _beKnockPushing = true;
                _beKnockPushingSpeed = speed;
            }
            else
            {
                _beKnockPushing = false;
                _beKnockPushingSpeed = 0;
            }
        }

        public function pushBackTo(tileX:int, tileY:int, speed:int):void
        {
            if (speed > 0)
            {
                targetTileX = tileX;
                targetTileY = tileY;
                var dir:int = Direction.getDirectionByTile(_targetTileX, _targetTileY, _tileX, _tileY);
                if (dir != Direction.INVALID_DIRECTION)
                {
                    _direction = dir;
                }
                _beKnockPushing = true;
                _beKnockPushingSpeed = speed;
            }
            else
            {
                _beKnockPushing = false;
                _beKnockPushingSpeed = 0;
            }
        }

        public function get beKnocking():Boolean
        {
            if (_beKnockPushing && getTimer() - _lastBeKnockPushTick >= MAX_KNOCK_TIME)
            {
                _beKnockPushing = false;
            }
            return _beKnockPushing;
        }

        public function get lastBeKnockTick():int
        {
            return _lastBeKnockPushTick;
        }

        public function get nameInBody():Boolean
        {
            return _nameInBody;
        }

        public function set nameInBody(value:Boolean):void
        {
            _nameInBody = value;
        }

        public override function destory():void
        {
			var selectEntity:IEntity = AutoJobManager.getInstance().selectEntity;
			if(selectEntity == this)
			{
				AutoJobManager.getInstance().selectEntity = null;
			}
            if (stateArray && stateArray.length)
            {

            }
//            if (_iconCell)
//            {
//                _iconCell.parent && _iconCell.parent.removeChild(_iconCell);
//            }
//            _iconCell = null;
//            if (_iconCell2)
//            {
//                _iconCell2.parent && _iconCell2.parent.removeChild(_iconCell2);
//            }
//            _iconCell2 = null;
//            if (_hpMask)
//            {
//                _hpMask.parent && _hpMask.parent.removeChild(_hpMask);
//            }
//            _hpMask = null;
			
			if(_hpBar)
			{
				if(_hpBar.parent)
				{
					_hpBar.parent.removeChild(_hpBar);
				}
				
				_hpBar.destroy();
				_hpBar = null;
			}
			
            if (_hpTitle)
            {
                _hpTitle.parent && _hpTitle.parent.removeChild(_hpTitle);
            }
            _hpTitle = null;

            while (_delayEffects && _delayEffects.length > 0)
            {
                var effect:DelayEffect = _delayEffects.shift();
                effect = null;
            }
            _delayEffects = null;
            super.destory();
            _topBuffEffects = null;

            EntityModelsManager.getInstance().unUseModel(_newEntityModel);
        }
		
		override protected function checkDie():Boolean
		{
			return hp<=0;
		}
		
	}
}