package com.view.gameWindow.scene.entity.entityItem
{
    import com.model.consts.HeadHpConst;
    import com.view.gameWindow.scene.entity.constants.ActionTypes;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    import com.view.gameWindow.scene.entity.entityInfoLabel.HeroInfoLabel;
    import com.view.gameWindow.scene.entity.entityItem.interf.IHero;
    import com.view.gameWindow.scene.entity.model.base.EntityModel;
    import com.view.gameWindow.scene.entity.model.utils.EntityModelUtil;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.selectRole.SelectRoleDataManager;

    import flash.text.TextField;

    public class Hero extends LivingUnit implements IHero
	{
		protected static const BORN_EFFECT:String = "ty_zhyx:1";
		
		protected var _ownerId:int;
		protected var _sid:int;
		protected var _sex:int;
		protected var _job:int;
		protected var _cloth:int;
		protected var _weapon:int;
		protected var _fashionId:int;
		
		public function Hero()
		{
		}
		
		override public function showHp(bool:Boolean = true):void
		{
			_url = HeadHpConst.BLUE;
			super.showHp(bool);
			refreshNameTxtPos();
		}


        override public function initInfoLabel():void
        {
            _infoLabel = new HeroInfoLabel();
        }

        public override function show():void
		{
			super.show();
			changeModel();
		}
		
		override public function initUpHeadContent():void
		{
			if(!_nameTxt && _entityName && _isShowName)
			{
				_nameTxt = new TextField();
				_nameTxt.mouseEnabled = false;
				_nameTxt.tabEnabled = false;
				_nameTxt.multiline = false;
				_nameTxt.wordWrap = false;
				_nameTxt.htmlText = HtmlUtils.createHtmlStr(0x00a2ff,_entityName);
				_nameTxt.height = _nameTxt.textHeight + 5;
				_nameTxt.width = _nameTxt.textWidth+5;
//				_nameTxt.textColor = _nameColor;
				_nameTxt.filters = _nameTextFilters;
				_nameTxt.cacheAsBitmap = true;
			}
		}
		
		public function changeModel():void
		{
			if(!isShow)
			{
				return;
			}
			_newEntityModel = EntityModelUtil.getEntityModel(_cloth, _fashionId, _weapon, 0, 0, 0, 0, _sex, ActionTypes.NOACTION, EntityModel.N_DIRECTION_8);
		}
		
		public override function get entityType():int
		{
			return EntityTypes.ET_HERO;
		}
		
		public function get ownerId():int
		{
			return _ownerId;
		}
		
		public function set ownerId(value:int):void
		{
			_ownerId = value;
		}
		
		public function get sid():int
		{
			return _sid;
		}
		
		public function set sid(value:int):void
		{
			_sid = value;
		}

		public function get cloth():int
		{
			return _cloth;
		}

		public function set cloth(value:int):void
		{
			_cloth = value;
		}

		public function get weapon():int
		{
			return _weapon;
		}

		public function set weapon(value:int):void
		{
			_weapon = value;
		}

		public function get sex():int
		{
			return _sex;
		}

		public function set sex(value:int):void
		{
			_sex = value;
		}

		public function get job():int
		{
			return _job;
		}

		public function set job(value:int):void
		{
			_job = value;
		}
		
		override public function get isEnemy():Boolean
		{
			var cid:int = SelectRoleDataManager.getInstance().selectCid;
			var sid:int = SelectRoleDataManager.getInstance().selectSid;
			if(cid == _ownerId && sid == _sid)
			{
				return true;//袁凯提的需求改为所有英雄都可以被自己攻击
			}
			else
			{
				return true;
			}
		}
		
		public override function get directSpeed():int
		{
			return super.directSpeed * 0.95;//减少英雄在跑动中的切换行走的可能性
		}
		
		public override function updateAction():void
		{
			if (_hp <= 0)
			{
				die();
			}
			else if (_currentActionId == ActionTypes.NOACTION || _currentActionId == ActionTypes.IDLE || _currentActionId == ActionTypes.RUN || _currentActionId == ActionTypes.WALK || (!_actionRepeat && _currentFrame >= _endFrame && _frameStartTime >= (_frameRate - 0.5) * FRAME_TIME))
			{
				if (_currentActionId == ActionTypes.PATTACK)
				{
					pAttackPrepare();
				}
				else if (_currentActionId == ActionTypes.MATTACK)
				{
					mAttackPrepare();
				}
				else if (_targetPixelX == _pixelX && _targetPixelY == _pixelY)
				{
					if(_actionRepeat && _currentActionId == ActionTypes.GATHER)
					{
						gather();
					}
					else
					{
						idle();
					}
				}
				else if (_currentActionId != ActionTypes.RUN && _currentActionId != ActionTypes.WALK)
				{
					run();
				}
			}
		}

        override protected function refreshNameTxtPos():void
        {
            if (_nameTxt && (_entityModel && _entityModel.available || isHideModel))
            {
                var heroLabel:HeroInfoLabel = _infoLabel as HeroInfoLabel;
                heroLabel.refreshNameTextPos(_nameTxt, getHeadContentPosY());
            }
        }

        private function getHeadContentPosY():Number
        {
            var theY:Number = 0;
            if (_nameTxt)
            {
                if (_nameInBody == false)
                {
//                    if (_hpTitle && _hpTitle.visible)
//                    {
//                        theY = -_hpTitle.y + _nameTxt.height;
//                    } else
//                    {
//                        theY = modelHeight+20;
//                    }
					theY = modelHeight+24;
                } else
                {
                    theY = modelHeight * .5;
                }
            }
            return theY;
        }
		public override function showBornEffect():void
		{
			addUnPermTopEffect(BORN_EFFECT);
		}
		
		public override function destory():void
		{
			super.destory();
		}

		public function get fashionId():int
		{
			return _fashionId;
		}

		public function set fashionId(value:int):void
		{
			_fashionId = value;
		}

		override public function isMouseOn():Boolean
		{
			if(_targetPixelX != _pixelX || _targetPixelY != _pixelY)
			{
				if(_viewBitmap && _viewBitmap.bitmapData)
				{
					var mx:Number = _viewBitmap.mouseX*_viewBitmap.scaleX;//返回相对图像的起始点位置
					var my:Number = _viewBitmap.mouseY*_viewBitmap.scaleY;
					var result:Boolean = mx > -_viewBitmap.x-30 && mx <= -_viewBitmap.x+30 && my > 0 && my <= _viewBitmap.height && _viewBitmap.bitmapData;
					return result;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return super.isMouseOn();
			}
		}
	}
}