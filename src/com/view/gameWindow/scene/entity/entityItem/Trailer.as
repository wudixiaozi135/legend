package com.view.gameWindow.scene.entity.entityItem
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.TrailerCfgData;
	import com.model.consts.HeadHpConst;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.interf.ITrailer;
	import com.view.gameWindow.scene.entity.model.EntityModelsManager;
	import com.view.gameWindow.scene.entity.model.base.EntityModel;
	
	import flash.text.TextField;
	
	public class Trailer extends LivingUnit implements ITrailer
	{
		protected var _trailerId:int;
		protected var _ownerCid:int;
		protected var _ownerSid:int;
		protected var _ownerName:String;
		protected var _trailerCfgData:TrailerCfgData;
		
		override public function get isEnemy():Boolean
		{
			return true;
		}
		
		public function Trailer()
		{
		}
		
		public override function get entityType():int
		{
			return EntityTypes.ET_TRAILER;
		}
		
		public function get trailerId():int
		{
			return _trailerId;
		}
		
		public function set trailerId(value:int):void
		{
			_trailerId = value;
			_trailerCfgData = ConfigDataManager.instance.trailerCfgData(_trailerId);
		}
		
		public function get ownerCid():int
		{
			return _ownerCid;
		}
		
		public function set ownerCid(value:int):void
		{
			_ownerCid = value;
		}
		
		public function get ownerSid():int
		{
			return _ownerSid;
		}
		
		public function set ownerSid(value:int):void
		{
			_ownerSid = value;
		}
		
		public function get ownerName():String
		{
			return _ownerName;
		}
		
		public function set ownerName(value:String):void
		{
			_ownerName = value;
		}
		
		public override function show():void
		{
			super.show();
			var bodyUrl:String = "";
			if (_hp > 1)
			{
				bodyUrl = ResourcePathConstants.ENTITY_RES_MONSTER_LOAD + _trailerCfgData.body + "/";
			}
			else
			{
				bodyUrl = ResourcePathConstants.ENTITY_RES_MONSTER_LOAD + _trailerCfgData.dead_body + "/";
			}
			var oldEntityModel:EntityModel = _entityModel;
			_entityModel = EntityModelsManager.getInstance().getAndUseEntityModel(bodyUrl, "", "", "", "", "", "", "", EntityModel.N_DIRECTION_5);
			EntityModelsManager.getInstance().unUseModel(oldEntityModel);
		}
		
		public override function set hp(value:int):void
		{
			var oldHp:int = _hp;
			super.hp = value;
			var oldEntityModel:EntityModel = _entityModel;
			var bodyUrl:String = "";
			if (oldHp > 1 && _hp <= 1)
			{
				bodyUrl = ResourcePathConstants.ENTITY_RES_MONSTER_LOAD + _trailerCfgData.dead_body + "/";
				_entityModel = EntityModelsManager.getInstance().getAndUseEntityModel(bodyUrl, "", "", "", "", "", "", "", EntityModel.N_DIRECTION_5);
				EntityModelsManager.getInstance().unUseModel(oldEntityModel);
			}
			else if (oldHp <= 1 && _hp > 1)
			{
				bodyUrl = ResourcePathConstants.ENTITY_RES_MONSTER_LOAD + _trailerCfgData.body + "/";
				_entityModel = EntityModelsManager.getInstance().getAndUseEntityModel(bodyUrl, "", "", "", "", "", "", "", EntityModel.N_DIRECTION_5);
				EntityModelsManager.getInstance().unUseModel(oldEntityModel);
			}
		}
		
		override public function showHp(bool:Boolean = true):void
		{
			_maxHp = _trailerCfgData.maxhp;
			_url = HeadHpConst.RED;
			super.showHp(bool);
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
				_nameTxt.htmlText = _entityName;
				_nameTxt.height = _nameTxt.textHeight + 5;
				_nameTxt.width = _nameTxt.textWidth+5;
//				_nameTxt.textColor = _nameColor;
				_nameTxt.filters = _nameTextFilters;
				_nameTxt.cacheAsBitmap = true;
			}
		}
		
		override public function showHpTitle(bool:Boolean = true):void
		{
			_maxHp = _trailerCfgData.maxhp;
			super.showHpTitle(bool);
		}
		
		public override function hurt():void
		{
			
		}
		
		public override function dead():void
		{
			
		}
		
		public override function destory():void
		{
			super.destory();
		}
	}
}