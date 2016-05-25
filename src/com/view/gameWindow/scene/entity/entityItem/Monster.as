package com.view.gameWindow.scene.entity.entityItem
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.model.configData.cfgdata.MstDigCfgData;
	import com.model.consts.HeadHpConst;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.dungeonTower.DgnTowerDataManger;
	import com.view.gameWindow.panel.panels.map.IMapPanel;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.scene.entity.constants.ActionTypes;
	import com.view.gameWindow.scene.entity.constants.Direction;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.constants.MonsterSideTypes;
	import com.view.gameWindow.scene.entity.effect.interf.IEntityPermanentEffect;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IMonster;
	import com.view.gameWindow.scene.entity.model.EntityModelsManager;
	import com.view.gameWindow.scene.entity.model.base.EntityModel;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.newMir.sound.SoundManager;
	import com.view.selectRole.SelectRoleDataManager;
	
	import flash.display.Sprite;
	import flash.text.TextField;

	public class Monster extends LivingUnit implements IMonster
	{
		private var _monsterId:int;
		private var _monsterCfgData:MonsterCfgData;
		private var _side:int;
		
		private var _mstDig:MonsterDig;
		internal var digLayer:Sprite;
		public var killerSid:int;
		public var killerCid:int;
		public var digCount:int;
		public var endTime:int;
		
		private var _bottomEffect:IEntityPermanentEffect;
		private var _topEffect:IEntityPermanentEffect;
		
		override public function initViewBitmap():void
		{
			super.initViewBitmap();
			digLayer ? addChild(digLayer) : null;
		}
		
		public override function show():void
		{
			var str:String;
			var str2:String;
			entityName = _monsterCfgData.name;
			_isShowName = false;
			super.show();

			if (_isHideModel == false)
			{
				buildModel();
			}
			var mapPanel:IMapPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_MAP) as IMapPanel;
			if(mapPanel)
			{
				mapPanel.addMstSign(entityId);
			}
			
			if(MainUiMediator.getInstance().miniMap)
			{
				MainUiMediator.getInstance().miniMap.addMstSign(entityId);
			}
			if (!_bottomEffect && _monsterCfgData.bottom_effect && _monsterCfgData.bottom_effect != "0")
			{
				_bottomEffect = addPermanentBottomEffect(_monsterCfgData.bottom_effect + ":1");
			}
			if (!_topEffect && _monsterCfgData.top_effect && _monsterCfgData.top_effect != "0")
			{
				_topEffect = addPermanentTopEffect(_monsterCfgData.top_effect + ":1");
			}
			if(this.hp>0)
			{
				chatBubble();
			}
			if (_monsterCfgData.standby > 0)
			{
				direction = _monsterCfgData.standby - 1;
			}
			else
			{
				direction = _monsterCfgData.direction > 1 ? int(Math.random()*Direction.TOTAL_DIRECTION) : Direction.DOWN;
			}
		}

		private function buildModel():void
		{
			var bodyUrl:String = "";
			var hairUrl:String = "";
			var wingUrl:String = "";
			var weaponUrl:String = "";
			var shieldUrl:String = "";
			var nDir:int = _monsterCfgData.direction;

			if (_monsterCfgData.monster_body)
			{
				bodyUrl = ResourcePathConstants.ENTITY_RES_MONSTER_LOAD + _monsterCfgData.monster_body + "/";
			}
			else
			{
				if (_monsterCfgData.avatar_body)
				{
					bodyUrl = ResourcePathConstants.ENTITY_RES_PLAYER_LOAD + _monsterCfgData.avatar_body + "/";
				}
				if (_monsterCfgData.hair)
				{
					hairUrl = ResourcePathConstants.ENTITY_RES_PLAYER_LOAD + _monsterCfgData.hair + "/";
				}
				if (_monsterCfgData.wing)
				{
					wingUrl = ResourcePathConstants.ENTITY_RES_PLAYER_LOAD + _monsterCfgData.wing + "/";
				}
				if (_monsterCfgData.weapon)
				{
					weaponUrl = ResourcePathConstants.ENTITY_RES_PLAYER_LOAD + _monsterCfgData.weapon + "/";
				}
				if (_monsterCfgData.shield)
				{
					shieldUrl = ResourcePathConstants.ENTITY_RES_PLAYER_LOAD + _monsterCfgData.shield + "/";
				}
			}
			if(_entityModel!=null)
			{
				EntityModelsManager.getInstance().unUseModel(_entityModel);
			}
			_entityModel = EntityModelsManager.getInstance().getAndUseEntityModel(bodyUrl, hairUrl, wingUrl, "", weaponUrl, "", "", shieldUrl, nDir);
		}
		
		public override function updateAction():void
		{
			if (_hp <= 0)
			{
				die();
			}
			else if (_currentActionId == ActionTypes.NOACTION || _currentActionId == ActionTypes.IDLE || _currentActionId == ActionTypes.RUN || _currentActionId == ActionTypes.WALK || (!_actionRepeat && _currentFrame >= _endFrame && _frameStartTime >= (_frameRate - 0.5) * FRAME_TIME))
			{
				if (_currentActionId == ActionTypes.PATTACK && !_monsterCfgData.monster_body)
				{
					pAttackPrepare();
				}
				else if (_currentActionId == ActionTypes.MATTACK && !_monsterCfgData.monster_body)
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
				else if (_currentActionId != ActionTypes.RUN && _currentActionId != ActionTypes.WALK && !_beKnockPushing)
				{
					run();
				}
			}
		}
		
		override public function setOver(value:Boolean):void
		{
			_isShowName = value;
			if(value)
			{
				initUpHeadContent();
			}
			else
			{
				super.clearUpHeadContent();
			}
			super.setOver(value);
		}

		override protected function refreshNameTxtPos():void
		{
			if (_isHideModel)
			{
				resetHeadContentPos(-modelHeight);
			} else
			{
                if (_nameTxt && (_entityModel && _entityModel.available))
                {
					_infoLabel.refreshNameTextPos(_nameTxt, modelHeight);
                }
			}
		}

		private function resetHeadContentPos(theY:Number):void
		{
//            if (_hpTitle && _iconCell && _iconCell2 && _hpMask)
//			{
//				if (_hpTitle.y != theY)
//					_hpTitle.y = theY;
//				if (_iconCell.y != _hpTitle.y + _hpTitle.height)
//					_iconCell.y = _hpTitle.y + _hpTitle.height;
//				if (_iconCell2.y != _iconCell.y)
//					_iconCell2.y = _iconCell.y;
//                if (_hpMask.y != _iconCell2.y)
//                    _hpMask.y = _iconCell2.y;
//			}
			
			if(_hpTitle && _hpBar)
			{
				if (_hpTitle.y != theY)
					_hpTitle.y = theY;
				
				if (_hpBar.y != _hpTitle.y + _hpTitle.height)
					_hpBar.y = _hpTitle.y + _hpTitle.height;
			}
		}

		private function rebuildHeadContent():void
		{
			if (_entityModel)
			{
				EntityModelsManager.getInstance().unUseModel(_entityModel);
				_entityModel = null;
			}
			clearViewBitmap();
			clearUpHeadContent();
//			if (!_iconCell && !_iconCell2)
			if(!_hpBar)
			{
				showHp();
				showHpTitle();
			}
		}
		override public function updateFrame(timeDiff:int):void
		{
			super.updateFrame(timeDiff);
			if(_mstDig)
			{
				_mstDig.updateDuration();
			}
		}
		
		public override function addSelectEffect():void
		{
			if (!_selectEffect)
			{
				_selectEffect = addPermanentBottomEffect("Selected_02:1");
			}
		}
		
		public override function set hp(value:int):void
		{
			if (value < _hp && value > 0)
			{
				SoundManager.getInstance().playEffectSound(_monsterCfgData.hurt_sound);
			}
			super.hp = value;
		}
		
		override public function showHp(bool:Boolean = true):void
		{
			_maxHp = _monsterCfgData.maxhp;
			_url = HeadHpConst.RED;
			super.showHp(bool);
		}
		
		override public function showHpTitle(bool:Boolean = true):void
		{
			_maxHp = _monsterCfgData.maxhp;
			super.showHpTitle(bool);
		}
		
		protected override function whileSay():void
		{
			super.whileSay();
			SoundManager.getInstance().playMonsterSound(_monsterCfgData.sound);
		}
		
		override protected function getBubbledString():String
		{
			if(_monsterCfgData)
			{
				return _monsterCfgData.bubble;
			}
			return "";
		}
		
		public override function updatePos(timeDiff:int):void
		{
			super.updatePos(timeDiff);
			var mapPanel:IMapPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_MAP) as IMapPanel;
			if(mapPanel)
			{
				mapPanel.refreshMstSign(entityId);
			}
			
			if(MainUiMediator.getInstance().miniMap)
			{
				MainUiMediator.getInstance().miniMap.refreshMstSign(entityId);
			}
		}
		
		public function set monsterId(value:int):void
		{
			_monsterId = value;
			if (!_monsterCfgData || _monsterCfgData.id != _monsterId)
			{
				_monsterCfgData = ConfigDataManager.instance.monsterCfgData(_monsterId);
			}
		}
		
		public function get monsterId():int
		{
			return _monsterId;
		}
		
		public function set side(value:int):void
		{
			_side = value;
		}
		
		public function get side():int
		{
			return _side;
		}
		
		override public function get isEnemy():Boolean
		{
			return _side == MonsterSideTypes.MS_ENEMY || _side == MonsterSideTypes.MS_OTHERFORCE;
		}
		
		public override function get entityType():int
		{
			return EntityTypes.ET_MONSTER;
		}
		
		override public function die():void
		{
			if (_currentActionId != ActionTypes.DIE)
			{
				super.die();
				initDig();
				SoundManager.getInstance().playMonsterSound(_monsterCfgData.dead_sound);
			}
		}
		
		override public function dead():void
		{
			super.dead();
			initDig();
		}
		
		private function initDig():void
		{
			if(!mstCfgData)
			{
				/*trace("Monster.initDig mstCfgData不存在");*/
				return;
			}
			if(!mstDigCfgData)
			{
				/*trace("Monster.initDig mstDigCfgData不存在");*/
				return;
			}
			if(mstCfgData.corpse_dig == 0)
			{
				return;
			}
			var cid:int = SelectRoleDataManager.getInstance().selectCid;
			var sid:int = SelectRoleDataManager.getInstance().selectSid;
			if(mstCfgData.corpse_dig == 1 && cid != killerCid && sid != killerSid)
			{
				return;
			}
			if(!_mstDig)
			{
				!digLayer ? digLayer = new Sprite() : null;
				digLayer.mouseChildren = false;
				digLayer.mouseEnabled = false;
				_viewBitmap ? addChild(digLayer) : null;
				_mstDig = new MonsterDig(this,monsterId);
			}
		}
		
		public function get canDig():Boolean
		{
			return _mstDig != null;
		}
		
		/**刷新挖掘次数*/
		public function updateDigCount():void
		{
			if(_mstDig)
			{
				_mstDig.updateDigCount();
			}
		}
		
		override public function initUpHeadContent():void
		{
			if( _entityName && _isShowName)
			{
				_nameTxt = _nameTxt|| new TextField();
				_nameTxt.mouseEnabled = false;
				_nameTxt.tabEnabled = false;
				_nameTxt.multiline = true;
				
				var content:String = ""; 
				var positionName:String = _monsterCfgData.position_name;
				var familiyName:String = _monsterCfgData.family_name;
				var _familyPositionName:String=_monsterCfgData.family_position;
				if (positionName!= "")
				{
					positionName = "<font color='#008ddf'>&lt;" + positionName + "&gt;</font><br>";
				}
				if (familiyName != "")
				{
					familiyName = "<font color='#ffc000'>" + familiyName + "[" + _familyPositionName + "]</font><br>";
				}
				if (_isTitleShow)
				{
					content = familiyName + positionName ;
				} else
				{
					content = familiyName;
				}
				content += _entityName;
				if(_monsterCfgData.level<RoleDataManager.instance.lv-10)
					_nameColor = 0xb4b4b4;
				else if(_monsterCfgData.level>=RoleDataManager.instance.lv-10&&_monsterCfgData.level<=RoleDataManager.instance.lv+10)
					_nameColor = 0xffffff;
				else
					_nameColor = 0xfe0000;
				_nameTxt.htmlText = HtmlUtils.createHtmlStr(_nameColor, content, 12, false, 2, "SimSun", false, "", "center");
				_nameTxt.height = _nameTxt.textHeight + 5;
				_nameTxt.width = _nameTxt.textWidth+5;
				_nameTxt.filters = _nameTextFilters;
				_nameTxt.cacheAsBitmap = true;
			}
		}
		
		internal function destroyMstDig():void
		{
			if(_mstDig)
			{
				_mstDig.destroy();
				_mstDig = null;
			}
		}
		
		public function get mstCfgData():MonsterCfgData
		{
			return _monsterCfgData;
		}
		
		public function get mstDigCfgData():MstDigCfgData
		{
			return ConfigDataManager.instance.mstDigCfgData(_monsterId,digCount);
		}
		
		override public function get totalTime():int
		{
			return mstDigCfgData ? mstDigCfgData.remain : 0;
		}
		
		override public function isMouseOn():Boolean
		{
			canDig  ? _mstDig.isMouseOnCell() : null;
			var isInDgnTower:Boolean = DgnTowerDataManger.instance.isInDgnTower;
			if(isInDgnTower)
			{
				return false;
			}
			var isInMainDgnTower:Boolean = DgnTowerDataManger.instance.isInMainDgnTower;
			if(isInMainDgnTower)
			{
				return false;
			}
			if(hp <= 0 && !canDig)
			{
				return false;
			}
			return super.isMouseOn();
		}

		override public function set isHideModel(value:Boolean):void
		{
			if (_isHideModel != value)
			{
				_isHideModel = value;
				if (_isHideModel)
				{
					rebuildHeadContent();
				}
				else
				{
					buildModel();
					initUpHeadContent();
					hideHp();
					hideHpTile();
				}
			}
		}

		override public function addHideForMonster():void
		{
			refreshNameTxtPos();
		}

		public override function get tileDistToReach():int
		{
			return (hp > 0 || canDig) ? AutoJobManager.TO_MONSTER_TILE_DIST1 : AutoJobManager.TO_MONSTER_TILE_DIST0;
		}
		
		public override function destory():void
		{
			destroyMstDig();
			if(digLayer && digLayer.parent)
			{
				digLayer.parent.removeChild(digLayer);
			}
			digLayer = null;
			//
			var mapPanel:IMapPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_MAP) as IMapPanel;
			if(mapPanel)
			{
				mapPanel.removeMstSign(_entityId);
			}
			//
			if(MainUiMediator.getInstance().miniMap)
			{
				MainUiMediator.getInstance().miniMap.removeMstSign(_entityId);
			}
			super.destory();
			if(_topEffect!=null)
			{
				throw new Error("我要找的就是你");
			}
			_bottomEffect = null;
			_topEffect = null;
		}
		
		override public function get maxHp():int
		{
			if(_maxHp==0&&mstCfgData!=null)
			{
				return mstCfgData.maxhp;
			}
			return _maxHp;
		}
		
		override public function set direction(value:int):void
		{
			if(mstCfgData.direction==EntityModel.N_DIRECTION_1)
			{
				value=0;
			}
			super.direction = value;
		}
	}
}