package com.view.gameWindow.scene.entity.entityItem
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.ActivityCfgData;
    import com.model.consts.HeadHpConst;
    import com.model.consts.StringConst;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
    import com.view.gameWindow.mainUi.subuis.activityTrace.constants.ActivityFuncTypes;
    import com.view.gameWindow.mainUi.subuis.rolehead.PkDataManager;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.activitys.loongWar.LoongWarDataManager;
    import com.view.gameWindow.panel.panels.activitys.loongWar.tabApply.DataLoongWarApplyGuild;
    import com.view.gameWindow.panel.panels.map.IMapPanel;
    import com.view.gameWindow.panel.panels.roleProperty.role.HideFactionData;
    import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
    import com.view.gameWindow.panel.panels.school.simpleness.SchoolBasicData;
    import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
    import com.view.gameWindow.scene.entity.constants.ActionTypes;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    import com.view.gameWindow.scene.entity.constants.SpecialActionTypes;
    import com.view.gameWindow.scene.entity.effect.interf.IEntityPermanentEffect;
    import com.view.gameWindow.scene.entity.entityInfoLabel.PlayerInfoLabel;
    import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
    import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
    import com.view.gameWindow.scene.entity.model.EntityModelsManager;
    import com.view.gameWindow.scene.entity.model.base.EntityModel;
    import com.view.gameWindow.scene.entity.model.utils.EntityModelUtil;
    import com.view.gameWindow.util.HtmlUtils;
    
    import flash.text.TextField;

    public class Player extends LivingUnit implements IPlayer
	{
		protected var _cid:int;
		protected var _sid:int;
		protected var _stallStatue:int;
		protected var _pkMode:int;
		protected var _sex:int;
		protected var _job:int;
		protected var _vip:int;
		protected var _reincarn:int;
		protected var _teamStatus:int;
		protected var _teamMemberCount:int;
		protected var _familyId:int;
		protected var _familySid:int;
		protected var _familyName:String;
		protected var _familyPositionName:String;
		protected var _position:int;
		protected var _specialAction:int;
		protected var _pkValue:int;
		protected var _isGrey:int;
		protected var _pkCamp:int;
		protected var _isHide:int;
		protected var _cloth:int;
		protected var _weapon:int;
		protected var _shield:int;
		protected var _wing:int;
		protected var _hair:int; 
		protected var _fashion:int;
		protected var _magicWeapon:int;
		protected var _nameIsUpdate:Boolean;
		protected var _isWingShow:Boolean = true;
		protected var _isFamilyNameShow:Boolean = true;
		protected var _hideWeaponEffect:Boolean = false;
		protected var _baitanEffect:IEntityPermanentEffect;
		protected var _familyRelation:int;
		protected var _hideFactionData:HideFactionData;
		
		public function get isHide():int
		{
			return _isHide;
		}

		public function set isHide(value:int):void
		{
			_isHide = value;
			_hideFactionData = new HideFactionData();
			_hideFactionData.setData(_isHide);
		}

		public override function initInfoLabel():void
		{
			_infoLabel = new PlayerInfoLabel();
		}
		
		public function get isGrey():int
		{
			return _isGrey;
		}

		public function set isGrey(value:int):void
		{
			if(_isGrey!=value)
			{
				_nameIsUpdate=true;
			}
			_isGrey = value;
		}
		
		public function get pkCamp():int
		{
			return _pkCamp;
		}
		
		public function set pkCamp(value:int):void
		{
			_pkCamp = value;
			initUpHeadContent();
		}

		public function get pkValue():int
		{
			return _pkValue;
		}

		public function set pkValue(value:int):void
		{
			if(_pkValue!=value)
			{
				_nameIsUpdate=true;
			}
			_pkValue = value;
		}

		public override function show():void
		{
			super.show();
			changeModel();
			var mapPanel:IMapPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_MAP) as IMapPanel;
			if(mapPanel)
			{
				mapPanel.addPlayerSign(entityId);
			}
			
			if(MainUiMediator.getInstance().miniMap)
			{
				MainUiMediator.getInstance().miniMap.addPlayerSign(entityId);
			}
		}
		
		public function changeModel():void
		{
			if (!_isShow)
			{
				return;
			}
			if (_isHideModel) return;

			var isEqual:Boolean = ActivityDataManager.instance.isAcitivtyTypeEqualValue(ActivityFuncTypes.AFT_SEA_SIDE);
			if (isEqual)
			{
				_newEntityModel = EntityModelUtil.getEntityModel(0, 0, 0, 0, 0, 0, 0, _sex, _currentActionId, EntityModel.N_DIRECTION_8);
			}
			else
			{
				_newEntityModel = EntityModelUtil.getEntityModel(_cloth, _hideFactionData.hideShizhuang == 1?0:_fashion, _weapon, _hideFactionData.hideHuanwu == 1?0:_magicWeapon,
                        _hideFactionData.hideDouli == 1 ? 0 : _hair, _shield, (_hideFactionData.hideChibang == 1) ? 0 : _isWingShow ? _wing : 0, _sex, _currentActionId, EntityModel.N_DIRECTION_8, _hideWeaponEffect);
			}
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
					changeModel();
					initUpHeadContent();
				}
			}
		}

		private function rebuildHeadContent():void
		{
			if (_entityModel)
			{
				EntityModelsManager.getInstance().unUseModel(_entityModel);
				_entityModel = null;
			}
			clearViewBitmap();//消除人物位图数据及影子

			initUpHeadContent();
//			if (!_iconCell && !_iconCell2)
			if(!_hpBar)
			{
				showHp();
				showHpTitle();
			}
		}

		override public function get isHideModel():Boolean
		{
			return _isHideModel;
		}

		public override function updatePos(timeDiff:int):void
		{
			super.updatePos(timeDiff);
			var mapPanel:IMapPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_MAP) as IMapPanel;
			if(mapPanel)
			{
				mapPanel.refreshPlayerSign(entityId);
				mapPanel.refreshMousePoint();
			}
			
			if(MainUiMediator.getInstance().miniMap)
			{
				MainUiMediator.getInstance().miniMap.refreshPlayerSign(entityId);
			}
		}

		override public function initUpHeadContent():void
		{
			if( _entityName/* && _isShowName*/)
			{
				_nameTxt = _nameTxt|| new TextField();
				_nameTxt.mouseEnabled = false;
				_nameTxt.tabEnabled = false;
				_nameTxt.multiline = true;

				var content:String = "", positionName:String = "", familiyName:String = "", vipName:String = "", reincarnName:String = "";
				if (_position != 0)
				{
					positionName = ConfigDataManager.instance.positionCfgData(_position).name;
					positionName = "<font color='#ffcc00'>&lt;" + positionName + "&gt;</font><br>";
				}
				if (_familyName != "")
				{
					if(ActivityDataManager.instance.loongWarDataManager.isInLeaderFamily(_familyId,_familySid))
						familiyName = "<font color='#ff6600'>" + _familyName + "[" + _familyPositionName + "]</font><br>";
					else
						familiyName = "<font color='#00ff00'>" + _familyName + "[" + _familyPositionName + "]</font><br>";
				}
				if (vip > 0)
				{
					vipName = "[VIP]&nbsp;"
				}
				/*if (reincarn > 0)
				{
					reincarnName = "[" + reincarn + StringConst.ROLE_PROPERTY_PANEL_0071 + "] ";
				}*/
				if (isFamilyNameShow)
				{
					if (isTitleShow)
					{
						content = positionName + familiyName + vipName + reincarnName;
					}
					else
					{
						content = familiyName + vipName + reincarnName;
					}
				}
				else
				{
					if (isTitleShow)
					{
						content = positionName + vipName + reincarnName;
					}
					else
					{
						content = vipName + reincarnName;
					}
				}
				content += _entityName;
				
				if(SchoolElseDataManager.getInstance().checkHostilitySchool(_familyId,_familySid))
				{
					content+=StringConst.SCHOOL_PANEL_5020;
				}
				assignNameColorDefault();
				//0不灰名1灰名
				if(_isGrey == 1)
				{
					_nameColor = 0xb4b4b4;
				}
				if(_pkValue >= 100)
				{
					_nameColor = 0xffcc00;
				}
				if(_pkValue >= 200)
				{
					_nameColor = 0xfe0000;
				}
				//
				assignNameColorBySth();
				_nameTxt.htmlText = HtmlUtils.createHtmlStr(_nameColor, content, 12, false, 2, "SimSun", false, "", "center");
				_nameTxt.height = _nameTxt.textHeight + 5;
				_nameTxt.width = _nameTxt.textWidth+35;
				_nameTxt.filters = _nameTextFilters;
				_nameTxt.cacheAsBitmap = true;
			}
		}
		/**获得默认nameColor*/
		protected function assignNameColorDefault():void
		{
			_nameColor = 0xededed;
		}
		/**根据需要改变nameColor*/
		protected function assignNameColorBySth():void
		{
			var cfgDt:ActivityCfgData = ActivityDataManager.instance.currentActvCfgDtAtMap;
			if(cfgDt)
			{
				if(cfgDt.func_type == ActivityFuncTypes.AFT_LOONG_WAR)
				{
					_nameColor = nameColorLoongWar;
				}
				else if(cfgDt.func_type == ActivityFuncTypes.AFT_NIGHT_FIGHT)
				{
					_nameColor = nameColorNightFight;
				}
				_nameIsUpdate = true;
			}
		}
		
		private function get nameColorNightFight():int
		{
			var pkCampMine:int = PkDataManager.instance.pkCamp;
			if(pkCampMine && pkCamp)
			{
				if(pkCampMine != pkCamp)
				{
					return 0xff0000;
				}
				else
				{
					return 0x00ff00;
				}
			}
			return _nameColor;
		}
		
		private function get nameColorLoongWar():int
		{
			var manager:LoongWarDataManager = ActivityDataManager.instance.loongWarDataManager;
			//已报名同帮会
			var schoolBaseData:SchoolBasicData = SchoolDataManager.getInstance().schoolBaseData;
			if(schoolBaseData && schoolBaseData.schoolId && schoolBaseData.schoolSid && schoolBaseData.isSameFamily(_familyId,_familySid))
			{
				return 0x00a2ff;
			}
			//已报名同联盟
			var dts:Vector.<DataLoongWarApplyGuild> = manager.dtsApplyLeagueMine;
			var dt:DataLoongWarApplyGuild;
			for each(dt in dts)
			{
				if(dt.familyId == _familyId && dt.familySid == _familySid)
				{
					return 0x00a2ff;
				}
			}
			//已报名其他
			dts = manager.dtsApplyGuild;
			for each(dt in dts)
			{
				if(dt.familyId == _familyId && dt.familySid == _familySid)
				{
					return 0xff6600;
				}
			}
			//守城帮会
			if(manager.familyIdDefense && manager.familySidDefense && manager.familyIdDefense == _familyId && manager.familySidDefense == _familySid)
			{
				return 0xff6600;
			}
			//未报名
			return 0x00ff00;
		}
		
		override protected function refreshNameTxtPos():void
		{
			if (_nameIsUpdate)
			{
				initUpHeadContent();
				var playerInfoLabel:PlayerInfoLabel = _infoLabel as PlayerInfoLabel;
				playerInfoLabel.vip=vip;
				_infoLabel.refreshNameTextContent(_nameTxt);
				_nameIsUpdate = false;
			}
			_infoLabel.refreshNameTextPos(_nameTxt, getHeadContentPosY());
		}

		private function getHeadContentPosY():Number
		{
			var theY:Number = 0;
			if (_isHideModel)
			{//隐藏模型
				if (_hpTitle)
					theY = modelHeight * .5;
			}
			else
			{
				if (_entityModel)
					theY = modelHeight * .5;
			}

			if (_nameTxt)
			{
                if (_nameInBody == false)
				{
                    if (_hpTitle)
                    {
                        theY = -_hpTitle.y + _nameTxt.height;
                    } else
                    {
                        theY = modelHeight;
                    }
				}
			}
			return theY;
		}

		override public function showHp(bool:Boolean = true):void
		{
			_url = HeadHpConst.GREEN;
			super.showHp(bool);
		}
		
		public function get specialAction():int
		{
			return _specialAction;
		}
		
		public function set specialAction(value:int):void
		{
			_specialAction = value;
			
			if (_specialAction == SpecialActionTypes.PSA_LAY)
			{
				sunbathe();
				if(this is FirstPlayer)
				{
					ActivityDataManager.instance.seaFeastDataManager.startSunBatheBubble();
				}
			}
			else if (_specialAction == SpecialActionTypes.PSA_PUSH_OIL)
			{
				massage();
				/*if(this is FirstPlayer)//由于推油时为止重叠导致气泡重叠，故推油者的气泡不显示
				{
					ActivityDataManager.instance.seaFeastDataManager.startMassageBubble()
				}*/
			}
			else if (_specialAction == SpecialActionTypes.PSA_BE_PUSH_OIL)
			{
				beMassage();
				if(this is FirstPlayer)
				{
					ActivityDataManager.instance.seaFeastDataManager.startBeMassageBubble();
				}
			}
			else if (_specialAction == SpecialActionTypes.PSA_NO)
			{
				if (_currentActionId == ActionTypes.SUNBATHE || _currentActionId == ActionTypes.MASSAGE || _currentActionId == ActionTypes.BE_MASSAGE)
				{
					idle();
				}
				if(this is FirstPlayer)
				{
					ActivityDataManager.instance.seaFeastDataManager.stopBubble();
				}
			}
		}
		
		public function walk():void
		{
			if (_currentActionId != ActionTypes.WALK)
			{
				_endFrame = 0;
				if (_entityModel && _entityModel.available)
				{
					_currentFrame = _startFrame = _entityModel.walkStart - 1;
					_endFrame = _entityModel.walkEnd;
					_frameRate = _entityModel.walkFrameRate;
					_frameStartTime = _frameRate * FRAME_TIME;
				}
				_currentActionId = ActionTypes.WALK;
			}
			_actionRepeat = true;
		}
		
		public override function hurt():void
		{
			
		}
		
		public function mining():void
		{
			if (_currentActionId != ActionTypes.MINING)
			{
				_endFrame = 0;
				if (_entityModel && _entityModel.available)
				{
					_currentFrame = _startFrame = _entityModel.pattackStart - 1;
					_endFrame = _entityModel.pattackEnd;
					_frameRate = _entityModel.pattackFrameRate*1.8;
					_frameStartTime = _frameRate * FRAME_TIME;
				}
				_currentActionId = ActionTypes.MINING;
			}
			_actionRepeat = true;
		}
		
		public function sunbathe():void
		{
			if (_currentActionId != ActionTypes.SUNBATHE)
			{
				_endFrame = 0;
				if (_entityModel && _entityModel.available)
				{
					_currentFrame = _startFrame = _entityModel.sunbatheStart - 1;
					_endFrame = _entityModel.sunbatheEnd;
					_frameRate = _entityModel.sunbatheFrameRate;
					_frameStartTime = _frameRate * FRAME_TIME;
				}
				_currentActionId = ActionTypes.SUNBATHE;
			}
			_actionRepeat = true;
		}
		
		public function footsie():void
		{
			if (_currentActionId != ActionTypes.FOOTSIE)
			{
				_endFrame = 0;
				if (_entityModel && _entityModel.available)
				{
					_currentFrame = _startFrame = _entityModel.footsieStart - 1;
					_endFrame = _entityModel.footsieEnd;
					_frameRate = _entityModel.footsieFrameRate;
					_frameStartTime = _frameRate * FRAME_TIME;
				}
				_currentActionId = ActionTypes.FOOTSIE;
			}
			_actionRepeat = false;
		}
		
		public function massage():void
		{
			if (_currentActionId != ActionTypes.MASSAGE)
			{
				_endFrame = 0;
				if (_entityModel && _entityModel.available)
				{
					_currentFrame = _startFrame = _entityModel.massageStart - 1;
					_endFrame = _entityModel.massageEnd;
					_frameRate = _entityModel.massageFrameRate;
					_frameStartTime = _frameRate * FRAME_TIME;
				}
				_currentActionId = ActionTypes.MASSAGE;
			}
			_actionRepeat = true;
		}
		
		public function beMassage():void
		{
			if (_currentActionId != ActionTypes.BE_MASSAGE)
			{
				_endFrame = 0;
				if (_entityModel && _entityModel.available)
				{
					_currentFrame = _startFrame = _entityModel.beMassageStart - 1;
					_endFrame = _entityModel.beMassageEnd;
					_frameRate = _entityModel.beMassageFrameRate;
					_frameStartTime = _frameRate * FRAME_TIME;
				}
				_currentActionId = ActionTypes.BE_MASSAGE;
			}
			_actionRepeat = true;
		}
		
		public function watermelon():void
		{
			if (_currentActionId != ActionTypes.WATERMELON)
			{
				_endFrame = 0;
				if (_entityModel && _entityModel.available)
				{
					_currentFrame = _startFrame = _entityModel.pattackStart - 1;
					_endFrame = _entityModel.pattackEnd;
					_frameRate = _entityModel.pattackFrameRate*1.8;
					_frameStartTime = _frameRate * FRAME_TIME;
				}
				_currentActionId = ActionTypes.WATERMELON;
			}
			_actionRepeat = false;
		}
		
		public override function updateAction():void
		{
			/*trace("Player.updateAction() isInNormalAction:"+isInNormalAction);*/
			if (_hp <= 0)
			{
				die();
			}
			else if (isInNormalAction)
			{
				if (_currentActionId == ActionTypes.PATTACK)
				{
					pAttackPrepare();
				}
				else if (_currentActionId == ActionTypes.MATTACK)
				{
					mAttackEnd();
				}
				else if (_currentActionId == ActionTypes.MATTACK_END)
				{
					mAttackPrepare();
				}
				else if (_currentActionId == ActionTypes.WATERMELON)
				{
					idle();
					changeModel();
				}
				else if (_targetPixelX == _pixelX && _targetPixelY == _pixelY)
				{
					if(_actionRepeat && _currentActionId == ActionTypes.GATHER)
					{
						gather();
					}
					else if(_actionRepeat && _currentActionId == ActionTypes.MINING)
					{
						mining();
					}
					else if (_specialAction == SpecialActionTypes.PSA_LAY)
					{
						sunbathe();
					}
					else if (_specialAction == SpecialActionTypes.PSA_PUSH_OIL)
					{
						massage();
					}
					else if (_specialAction == SpecialActionTypes.PSA_BE_PUSH_OIL)
					{
						beMassage();
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
		
		private function get isInNormalAction():Boolean
		{
			var boolean:Boolean = _currentActionId == ActionTypes.NOACTION || _currentActionId == ActionTypes.IDLE || _currentActionId == ActionTypes.RUN || _currentActionId == ActionTypes.WALK;
			boolean ||= (!_actionRepeat && _currentFrame >= _endFrame && _frameStartTime >= (_frameRate - 0.5) * FRAME_TIME);
			return boolean;
		}
		
		public override function initAction():void
		{
			if (_endFrame == 0)
			{
				switch (_currentActionId)
				{
					case ActionTypes.WALK:
						_currentActionId = ActionTypes.NOACTION;
						walk();
						break;
					case ActionTypes.SUNBATHE:
						_currentActionId = ActionTypes.NOACTION;
						sunbathe();
						break;
					case ActionTypes.MASSAGE:
						_currentActionId = ActionTypes.NOACTION;
						massage();
						break;
					case ActionTypes.BE_MASSAGE:
						_currentActionId = ActionTypes.NOACTION;
						beMassage();
						break;
					default:
						super.initAction();
						break;
				}
			}
		}
		
		public function get cid():int
		{
			return _cid;
		}
		
		public function set cid(value:int):void
		{
			_cid = value;
		}
		
		public function get sid():int
		{
			return _sid;
		}
		
		public function set sid(value:int):void
		{
			_sid = value;
		}
		
		public override function get entityType():int
		{
			return EntityTypes.ET_PLAYER;
		}
		
		public function get isTitleShow():Boolean
		{
			return _isTitleShow;
		}
		
		public function set isTitleShow(value:Boolean):void
		{
			_isTitleShow = value;
			initUpHeadContent();
			_nameIsUpdate = true;
		}
		
		public function get isFamilyNameShow():Boolean
		{
			return _isFamilyNameShow;
		}
		
		public function set isFamilyNameShow(value:Boolean):void
		{
			if (_isFamilyNameShow != value)
			{
				_isFamilyNameShow = value;
				initUpHeadContent();
				_nameIsUpdate = true;
			}
		}

		public function get pkMode():int
		{
			return _pkMode;
		}
		
		public function set pkMode(value:int):void
		{
			_pkMode = value;
		}
		
		override public function get isEnemy():Boolean
		{
			return true;
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
		
		public function get vip():int
		{
			return _vip;
		}
		
		public function set vip(value:int):void
		{
			if(_vip!=value)
			{
				_nameIsUpdate=true;
			}
			_vip = value;
		}
		
		public function get reincarn():int
		{
			return _reincarn;
		}
		
		public function set reincarn(value:int):void
		{
			if(_reincarn!=value)
			{
				_nameIsUpdate=true;
			}
			_reincarn = value;
		}
		
		public function get teamStatus():int
		{
			return _teamStatus;
		}
		
		public function set teamStatus(value:int):void
		{
			_teamStatus = value;
		}
		
		public function get teamMemberCount():int
		{
			return _teamMemberCount;
		}
		
		public function set teamMemberCount(value:int):void
		{
			_teamMemberCount = value;
		}
		
		public function get familyId():int
		{
			return _familyId;
		}
		
		public function set familyId(value:int):void
		{
			_familyId = value;
		}
		
		public function get familySid():int
		{
			return _familySid;
		}
		
		public function set familySid(value:int):void
		{
			_familySid = value;
		}
		
		public function get familyName():String
		{
			return _familyName;
		}
		
		public function set familyName(value:String):void
		{
			if(_familyName!=value)
			{
				_nameIsUpdate=true;
			}
			_familyName = value;
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
		
		public function get shield():int
		{
			return _shield;
		}
		
		public function set shield(value:int):void
		{
			_shield = value;
		}

		public function get wing():int
		{
			return _wing;
		}

		public function set wing(value:int):void
		{
			_wing = value;
		}
		
		public function get hair():int
		{
			return _hair;
		}

		public function set hair(value:int):void
		{
			_hair = value;
		}
		
		public function get fashion():int
		{
			return _fashion;
		}
		
		public function set fashion(value:int):void
		{
			_fashion = value;
		}
		
		public function get magicWeapon():int
		{
			return _magicWeapon;
		}
		
		public function set magicWeapon(value:int):void
		{
			_magicWeapon = value;
		}

		public function get familyPositionName():String
		{

			return _familyPositionName;
		}

		public function set familyPositionName(value:String):void
		{
			if(_familyPositionName!=value&&_familyPositionName!="")
			{
				_nameIsUpdate=true;
			}
			_familyPositionName = value;
		}

		
		public override function get pixelY():Number
		{
			if (_specialAction == SpecialActionTypes.PSA_PUSH_OIL)
			{
				return _pixelY + 1;
			}
			return _pixelY;
		}
		
		public function hideEffects():void
		{
			_topEffectContainer.visible = false;
		}
		
		public function showEffects():void
		{
			_topEffectContainer.visible = true;
		}
		
		public override function destory():void
		{
			var mapPanel:IMapPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_MAP) as IMapPanel;
			if(mapPanel)
			{
				mapPanel.removePlayerSign(entityId);
			}
			
			if(MainUiMediator.getInstance().miniMap)
			{
				MainUiMediator.getInstance().miniMap.removePlayerSign(entityId);
			}
			
			super.destory();
		}

		public function get position():int
		{
			return _position;
		}

		public function set position(value:int):void
		{
			if(_position!=value)
			{
				_nameIsUpdate=true;
			}
			_position = value;
		}

		public function get isWingShow():Boolean
		{
			return _isWingShow;
		}

		public function set isWingShow(value:Boolean):void
		{
			_isWingShow = value;
		}

		public function get hideWeaponEffect():Boolean
		{
			return _hideWeaponEffect;
		}

		public function set hideWeaponEffect(value:Boolean):void
		{
			_hideWeaponEffect = value;
			changeModel();
		}

		override public function addHideForPlayer():void
		{
			refreshNameTxtPos();
			refreshBuffPos();
		}

		public function get stallStatue():int
		{
			return _stallStatue;
		}

		public function set stallStatue(value:int):void
		{
			if (value)
			{
				idle();
			}
			if (_stallStatue != value)
			{
				_stallStatue = value;
				if (_stallStatue)
				{
					_baitanEffect = addPermanentBottomEffect("baitan:1");
				} else
				{
					if (_baitanEffect)
					{
						removeEffect(_baitanEffect);
						_baitanEffect.destory();
						_baitanEffect = null;
					}
				}
			}
		}

		public function get familyRelation():int
		{
			return _familyRelation;
		}

		public function set familyRelation(value:int):void
		{
			if(_familyRelation!=value&&_familyRelation!=0)
			{
				_nameIsUpdate=true;
			}
			_familyRelation = 0;
		}
		
		public override function get tileDistToReach():int
		{
			return specialAction == SpecialActionTypes.PSA_LAY ? AutoJobManager.TO_PLAYER_TILE_DIST0 : AutoJobManager.TO_PLAYER_TILE_DIST;
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