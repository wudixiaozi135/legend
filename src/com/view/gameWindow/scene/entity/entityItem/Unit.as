package com.view.gameWindow.scene.entity.entityItem
{
	import com.greensock.TweenLite;
	import com.view.gameWindow.scene.effect.item.EffectBase;
	import com.view.gameWindow.scene.effect.item.interf.IEffectBase;
	import com.view.gameWindow.scene.entity.constants.ActionTypes;
	import com.view.gameWindow.scene.entity.constants.Direction;
	import com.view.gameWindow.scene.entity.effect.EntityPermanentEffect;
	import com.view.gameWindow.scene.entity.effect.EntityUnPermEffect;
	import com.view.gameWindow.scene.entity.effect.interf.IEntityPermanentEffect;
	import com.view.gameWindow.scene.entity.effect.interf.IEntityUnPermEffect;
	import com.view.gameWindow.scene.entity.entityInfoLabel.UnitInfoLabel;
	import com.view.gameWindow.scene.entity.entityItem.interf.IUnit;
	import com.view.gameWindow.scene.entity.model.EntityModelsManager;
	import com.view.gameWindow.scene.entity.model.base.EntityModel;
	import com.view.gameWindow.scene.entity.model.imageItem.ImageItem;
	import com.view.gameWindow.tips.toolTip.EntityChatTip;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	public class Unit extends Entity implements IUnit
	{
		private const DEFAULT_HEIGHT:int = 115;
		protected var _level:int;
		
		protected var _currentFrame:int;
		protected var _startFrame:int;
		protected var _endFrame:int;
		protected var _frameRate:int;
		protected var _frameStartTime:int;
		protected var _actionRepeat:Boolean;
		protected var _currentActionId:int;
		protected var _direction:int;
		
		protected var _entityModel:EntityModel;
		
		protected var _selectEffect:IEntityPermanentEffect;
		
		protected var _bottomEffects:Vector.<EffectBase>;
		protected var _topEffects:Vector.<EffectBase>;
		
		protected var _bottomEffectContainer:Sprite;
		protected var _topEffectContainer:Sprite;
		
		protected var _chatTxt:EntityChatTip;
		protected var _chatTimeId:int;
		private var _chatBubbleId:int;
		private var _chatBubbleCount:int;
		protected var _isHideModel:Boolean = false;//默认不隐藏模型
		
		public function Unit()
		{
			_level = 0;
			_bottomEffectContainer = new Sprite();
			addChild(_bottomEffectContainer);
			_topEffectContainer = new Sprite();
			addChild(_topEffectContainer);
			_direction = Direction.DOWN;
		}
		
		public override function show():void
		{
			_currentActionId = ActionTypes.NOACTION;
			super.show();
		}
		
		public override function hide():void
		{
			cancelBubble();  //为性能安全，父类中强制消除自动说话,避免内纯泄漏
			EntityModelsManager.getInstance().unUseModel(_entityModel);
			_entityModel = null;
			super.hide();
		}
		
		public override function initInfoLabel():void
		{
			_infoLabel = new UnitInfoLabel();
		}
		
		public function say(value:String):void
		{
			if(!isShow)
			{
				return;
			}
			if(value == "")
			{
				return;
			}
			if(null == _viewBitmap)
			{
				return;
			}
			if(checkDie())
			{
				return;
			}
			clearTimeout(_chatTimeId);
			clearCahtText();
			_chatTxt = new EntityChatTip();
			_chatTxt.setData(HtmlUtils.createHtmlStr(0xffffff,value));
			_chatTxt.x = -18;
			var theY:Number = -(_viewBitmap.height + _chatTxt.height - 5);
			_chatTxt.y = theY;
			this.addChild(_chatTxt);
			_chatTimeId=setTimeout(hideChatSkin,3000);
		}
		
		protected function checkDie():Boolean
		{
			return false;
		}
		
		protected function chatBubble():void
		{
			_chatBubbleCount=0;
			clearTimeout(_chatBubbleId);
			_chatBubbleId=setTimeout(whileSay,getBubbledTime()*1000);
		}
		
		private function cancelBubble():void
		{
			clearTimeout(_chatBubbleId);
			clearCahtText();
			clearTimeout(_chatTimeId);
		}
		
		private function clearCahtText():void
		{
			if (_chatTxt)
			{
				_chatTxt.dispose();
				if (_chatTxt.parent)
				{
					_chatTxt.parent.removeChild(_chatTxt);
				}
				_chatTxt = null;
			}
		}
		
		protected function whileSay():void
		{
			say(getBubbledString());
			_chatBubbleCount++;
			_chatBubbleId=setTimeout(whileSay,getBubbledTime()*1000);
		}
		/**
		 * 
		 * 支持重写说话内容
		 */
		protected function getBubbledString():String
		{
			return "";
		}
		
		/**
		 * 支持重写时间规则
		 */
		protected function getBubbledTime():int
		{
			if(_chatBubbleCount==0)
				return Math.random()*180;
			return Math.random()*120+180;
		}
		
		private function hideChatSkin():void
		{
			if(_chatTxt==null)return;
			TweenLite.to(_chatTxt,2,{alpha:0,onComplete:function ():void{
				clearCahtText();
			}});
		}
		
		public override function updateFrame(timeDiff:int):void
		{
			super.updateFrame(timeDiff);
			
			updateView(timeDiff);
			
			updateEffects(timeDiff);
		}
		
		protected override function updateView(timeDiff:int):void
		{
			if (_entityModel)
			{
				_frameStartTime += timeDiff;
				updateAction();
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
		
		private var buffTime:int;
		private var timeDiffTotal:int;
		protected override function updateEffects(timeDiff:int):void
		{
			var time:int = getTimer();
			if(time - buffTime < 50)
			{
				timeDiffTotal += timeDiff;
				return;
			}
			
			timeDiff += timeDiffTotal;
			timeDiffTotal = 0;
			buffTime = time;
			
			var entityEffect:EffectBase;
			var newEffects:Vector.<EffectBase>;
			newEffects = new Vector.<EffectBase>();

			while(_bottomEffects&&_bottomEffects.length>0)
			{
				entityEffect=_bottomEffects.shift();
				entityEffect.updateFrame(timeDiff);
				if (entityEffect.expire())
				{
					if (_bottomEffectContainer.contains(entityEffect))
					{
						_bottomEffectContainer.removeChild(entityEffect);
					}else if(entityEffect.parent)
					{
						trace("youemi特殊的特效发生异常");
					}
					entityEffect.destory();
					entityEffect=null;
				}
				else
				{
					newEffects.push(entityEffect);
				}
			}
			_bottomEffects=null;
			_bottomEffects = newEffects;
			
			newEffects = new Vector.<EffectBase>();
			
			while(_topEffects&&_topEffects.length>0)
			{
				entityEffect=_topEffects.shift();
				entityEffect.updateFrame(timeDiff);
				if (entityEffect.expire())
				{
					if (_topEffectContainer.contains(entityEffect))
					{
						_topEffectContainer.removeChild(entityEffect);
					}else if(entityEffect.parent)
					{
						trace("youemi特殊的特效发生异常");
					}
					entityEffect.destory();
					entityEffect=null;
				}
				else
				{
					newEffects.push(entityEffect);
				}
			}

			_topEffects=null;
			_topEffects = newEffects;
		}
		
		public function addPermanentBottomEffect(path:String):IEntityPermanentEffect
		{
			if(_bottomEffectContainer==null)return null;
			if (!_bottomEffects)
			{
				_bottomEffects = new Vector.<EffectBase>();
			}
			var split:Array = path.split(":");
			if(split.length != 2)
			{
				return null;
			}
			var folder:String = split[0];
			var totalDir:int = int(split[1]);
			if(totalDir != 1)
			{
				return null;
			}
			var effect:EntityPermanentEffect = new EntityPermanentEffect(folder + "/1");
			_bottomEffects.push(effect);
			_bottomEffectContainer.addChild(effect);
			return effect;
		}
		
		public function addPermanentTopEffect(path:String):IEntityPermanentEffect
		{
			if(_topEffectContainer==null)return null;
			if (!_topEffects)
			{
				_topEffects = new Vector.<EffectBase>();
			}
			var split:Array = path.split(":");
			if(split.length != 2)
			{
				return null;
			}
			var folder:String = split[0];
			var totalDir:int = int(split[1]);
			if(totalDir != 1)
			{
				return null;
			}
			var effect:EntityPermanentEffect = new EntityPermanentEffect(folder + "/1");
			_topEffects.push(effect);
			_topEffectContainer.addChild(effect);
			return effect;
		}
		
		public function addUnPermBottomEffect(path:String):IEntityUnPermEffect
		{
			if(_bottomEffectContainer==null)return null;
			if (!_bottomEffects)
			{
				_bottomEffects = new Vector.<EffectBase>();
			}
			var split:Array = path.split(":");
			if(split.length != 2)
			{
				return null;
			}
			var folder:String = split[0];
			var totalDir:int = int(split[1]);
			if(totalDir != 1)
			{
				return null;
			}
			var effect:EntityUnPermEffect = new EntityUnPermEffect(folder + "/1", false);
			_bottomEffects.push(effect);
			_bottomEffectContainer.addChild(effect);
			return effect;
		}
		
		public function addUnPermBottomEffect1(effect:EntityUnPermEffect):IEntityUnPermEffect
		{
			if(_bottomEffectContainer==null)return null;
			if (!_bottomEffects)
			{
				_bottomEffects = new Vector.<EffectBase>();
			}
			_bottomEffects.push(effect);
			_bottomEffectContainer.addChild(effect);
			return effect;
		}
		
		public function addUnPermTopEffect(path:String,isTween:Boolean = false):IEntityUnPermEffect
		{
			if(_topEffectContainer==null)return null;
			var split:Array = path.split(":");
			if(split.length != 2)
			{
				return null;
			}
			var folder:String = split[0];
			var totalDir:int = int(split[1]);
			var dir:int;
			var reverse:Boolean = false;
			if(totalDir == 1)
			{
				dir = 0;
			}
			else if(totalDir == 5)
			{
				if (_direction < 5)
				{
					dir = _direction;
				}
				else
				{
					dir = Direction.TOTAL_DIRECTION - _direction;
					reverse = true;
				}
			}
			else if (totalDir == 8)
			{
				dir = _direction;
			}
			

			var effect:EntityUnPermEffect = new EntityUnPermEffect(folder + "/" + (dir+1), reverse);
			effect.isTween = isTween;
			
			if(totalDir!=1&&(this._direction==Direction.UP||this._direction==Direction.UP_LEFT||this._direction==Direction.UP_RIGHT))
			{
				return addUnPermBottomEffect1(effect);
			}
			
			if (!_topEffects)
			{
				_topEffects = new Vector.<EffectBase>();
			}
			_topEffects.push(effect);
			_topEffectContainer.addChild(effect);
			return effect;
		}
		
		public function removeEffect(effect:IEffectBase):void
		{
			if (!effect)
			{
				return;
			}
			var effectDisplayObj:DisplayObject = effect as DisplayObject;
			
			var index:int;
			if(_bottomEffects)
			{
				index = _bottomEffects.indexOf(effect);
				if (index != -1)
				{
					_bottomEffects.splice(index, 1);
					if (_bottomEffectContainer.contains(effectDisplayObj))
					{
						_bottomEffectContainer.removeChild(effectDisplayObj);
					}
				}
			}
			if (_topEffects)
			{
				index = _topEffects.indexOf(effect);
				if (index != -1)
				{
					_topEffects.splice(index, 1);
					if (_topEffectContainer.contains(effectDisplayObj))
					{
						_topEffectContainer.removeChild(effectDisplayObj);
					}
				}
			}
			effect.destory();
			effect=null;
		}
		
		public function addSelectEffect():void
		{
			
		}
		
		public function removeSelectEffect():void
		{
			if (_selectEffect)
			{
				removeEffect(_selectEffect);
				_selectEffect = null;
			}
		}
		
		public function idle():void
		{
			if (_currentActionId != ActionTypes.IDLE)
			{
				_endFrame = 0;
				if (_entityModel && _entityModel.available)
				{
					_currentFrame = _startFrame = _entityModel.idleStart - 1;
					_endFrame = _entityModel.idleEnd;
					_frameRate = _entityModel.idleFrameRate;
					_frameStartTime = _frameRate * FRAME_TIME;
				}
				_currentActionId = ActionTypes.IDLE;
			}
			_actionRepeat = true;
		}
		
		public function get currentAcionId():int
		{
			return _currentActionId;
		}
		
		public function set currentAcionId(value:int):void
		{
			_currentActionId = value;
		}
		
		public function updateAction():void
		{
			
		}
		
		protected override function refreshNameTxtPos():void
		{
			if(_nameTxt && _entityModel && _entityModel.available)
			{
				_infoLabel.refreshNameTextPos(_nameTxt, _entityModel.modelHeight);
			}
		}
		
		public function initAction():void
		{
			if (_endFrame == 0)
			{
				switch (_currentActionId)
				{
					case ActionTypes.IDLE:
						_currentActionId = ActionTypes.NOACTION;
						idle();
						break;
					default:
						break;
				}
			}
		}
		
		public function get level():int
		{
			return _level;
		}
		
		public function set level(value:int):void
		{
			if (_level > 0 && value > _level)
			{
				addUnPermTopEffect("levelup:1");
			}
			_level = value;
		}
		
		public function get modelHeight():int
		{
			if (_entityModel)
			{
				return _entityModel.modelHeight;
			}
			return DEFAULT_HEIGHT;
		}
		
		protected function refreshBuffPos():void
		{
			
		}
		
		protected function get isShowShadow():Boolean
		{
			return true;
		}

		public function set isHideModel(value:Boolean):void
		{
			_isHideModel = value;
		}

		public function get isHideModel():Boolean
		{
			return _isHideModel;
		}
		public override function destory():void
		{
			super.destory();
			
			removeSelectEffect();
			cancelBubble();
			EntityModelsManager.getInstance().unUseModel(_entityModel);
			_entityModel = null;

			var effect:EffectBase;
			while(_bottomEffects&&_bottomEffects.length>0)
			{
				effect=_bottomEffects.shift();
				effect.destory();
				if (_bottomEffectContainer && _bottomEffectContainer.contains(effect))
				{
					_bottomEffectContainer.removeChild(effect);
				}
				effect=null;
			}
			_bottomEffects = null;
			
			if(_bottomEffectContainer)
			{
				if(_bottomEffectContainer.numChildren>0){throw new Error("特效的释放出现了问题");}
				_bottomEffectContainer.parent&&_bottomEffectContainer.parent.removeChild(_bottomEffectContainer);
				_bottomEffectContainer=null;
			}
			
			while(_topEffects&&_topEffects.length>0)
			{
				effect=_topEffects.shift();
				effect.parent&&effect.parent.removeChild(effect);
				effect.destory();
//				if (_topEffectContainer && _topEffectContainer.contains(effect))
//				{
//					_topEffectContainer.removeChild(effect);
//				}
				effect=null;
			}
			
			if(_topEffectContainer)
			{
				if(_topEffectContainer.numChildren>0){throw new Error("特效的释放出现了问题");}
				_topEffectContainer.parent&&_topEffectContainer.parent.removeChild(_topEffectContainer);
				_topEffectContainer=null;
			}
			_topEffects = null;
		}

		public function addHideForMonster():void
		{
		}

		public function addHideForPlayer():void
		{
		}
	}
}