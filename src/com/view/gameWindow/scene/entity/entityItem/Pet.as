package com.view.gameWindow.scene.entity.entityItem
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.PetCfgData;
    import com.model.consts.HeadHpConst;
    import com.view.gameWindow.scene.entity.constants.Direction;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    import com.view.gameWindow.scene.entity.entityInfoLabel.PetInfoLabel;
    import com.view.gameWindow.scene.entity.entityItem.interf.IPet;
    import com.view.gameWindow.scene.entity.model.EntityModelsManager;
    import com.view.gameWindow.scene.entity.model.base.EntityModel;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.selectRole.SelectRoleDataManager;
    
    import flash.text.TextField;

    public class Pet extends LivingUnit implements IPet
	{
		private var _petId:int;
		private var _exp:int;
		private var _ownId:int;
		private var _sid:int;
		private var _grade:int;

		public function get grade():int
		{
			return _grade;
		}

		public function set grade(value:int):void
		{
			_grade = value;
		}

		public function get sid():int
		{
			return _sid;
		}
		
		public function set sid(value:int):void
		{
			_sid = value;
		}
		
		public function get ownId():int
		{
			return _ownId;
		}
		
		public function set ownId(value:int):void
		{
			_ownId = value;
		}
		
		override public function get isEnemy():Boolean
		{
			var cid:int = SelectRoleDataManager.getInstance().selectCid;
			var sid:int = SelectRoleDataManager.getInstance().selectSid;
			if(cid == _ownId && sid == _sid)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
		public function Pet()
		{
		}
		
		public override function get entityType():int
		{
			return EntityTypes.ET_PET;
		}

        override public function initInfoLabel():void
        {
            _infoLabel = new PetInfoLabel();
        }

        public override function show():void
		{
//			var petConfigData:PetCfgData = ConfigDataManager.instance.petCfgData(_petId);
//			entityName = petConfigData.name;
			super.show();
			if (_isHideModel == false)
			{
				buildModel();
			}
		}

        override protected function refreshNameTxtPos():void
        {
            if (_nameTxt && (_entityModel && _entityModel.available || isHideModel))
            {
                _infoLabel = _infoLabel as PetInfoLabel;
				_infoLabel.refreshNameTextContent(_nameTxt);
                _infoLabel.refreshNameTextPos(_nameTxt, getHeadContentPosY());
            }
        }

        private function getHeadContentPosY():int
        {
            var theY:Number = 0;
            if (_nameTxt)
            {
                if (_nameInBody == false)
                {
                    if (_hpTitle && _hpTitle.visible)
                    {
                        theY = -_hpTitle.y + _nameTxt.height;
                    } else
                    {
                        theY = modelHeight + 20;
                    }
//                    theY = modelHeight+24;
                } else
                {
                    theY = modelHeight * .5;//为预留宝宝名字在身上而用
                }
            }
            return theY;
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
				_nameTxt.htmlText = HtmlUtils.createHtmlStr(0x00a2ff,_entityName+"["+_grade+"级]");
				_nameTxt.height = _nameTxt.textHeight + 5;
				_nameTxt.width = _nameTxt.textWidth+5;
//				_nameTxt.textColor = _nameColor;
				_nameTxt.filters = _nameTextFilters;
				_nameTxt.cacheAsBitmap = true;
			}
		}
		
		 
		 public function refreshName():void
		 {
			 if(_nameTxt && _entityName && _isShowName)
			 {
				 _nameTxt.htmlText = HtmlUtils.createHtmlStr(0x00a2ff,_entityName+"["+_grade+"级]");
			 }
//			 clearViewBitmap();
//			 refreshNameTxtPos();
//			 buildModel();
		 }
		
		private function buildModel():void
		{
			var petConfigData:PetCfgData = ConfigDataManager.instance.petCfgData(_petId);
			EntityModelsManager.getInstance().unUseModel(_entityModel);
			var bodyUrl:String = "";
			var nDir:int = EntityModel.N_DIRECTION_5;
			bodyUrl = ResourcePathConstants.ENTITY_RES_MONSTER_LOAD + petConfigData.body + "/";
			_entityModel = EntityModelsManager.getInstance().getAndUseEntityModel(bodyUrl, "", "", "", "", "", "", "", nDir);
			_direction = int(Math.random() * Direction.TOTAL_DIRECTION);
		}
		
		override public function showHp(bool:Boolean = true):void
		{
			_url = HeadHpConst.BLUE;
			super.showHp(bool);
		}
		
		public function get petId():int
		{
			return _petId;
		}
		
		public function set petId(value:int):void
		{
			_petId = value;
		}
		
		public function get exp():int
		{
			return _exp;
		}
		
		public function set exp(value:int):void
		{
			_exp = value;
		}
		
		public override function showBornEffect():void
		{
			var petConfigData:PetCfgData = ConfigDataManager.instance.petCfgData(_petId);
			if (petConfigData.born_effect && petConfigData.born_effect != "0")
			{
				addUnPermTopEffect(petConfigData.born_effect);
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
					buildModel();
					hideHp();
					hideHpTile();
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

			showHp();
			showHpTitle();
		}

		public override function destory():void
		{
			super.destory();
		}
	}
}