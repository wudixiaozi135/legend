package com.view.gameWindow.scene.entity.model
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EntityLayerCfgData;
	import com.view.gameWindow.scene.entity.constants.ActionTypes;
	import com.view.gameWindow.scene.entity.constants.EntityLayerType;
	import com.view.gameWindow.scene.entity.model.base.EntityModel;
	import com.view.gameWindow.scene.entity.model.imageItem.ImageItem;
	import com.view.gameWindow.util.UtilType2BlendModel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class EntityMutiLayersModel extends EntityModel
	{		
		private var _nUnFinishedImageItem:int;
		private var _readyActionIds:Vector.<Vector.<Boolean>>;
		private var _iGenImage:int;
		
		private var _clothLayer:EntityMutiLayerChildModel;
		private var _hairLayer:EntityMutiLayerChildModel;
		private var _largeWingLayer:EntityMutiLayerChildModel;
		private var _smallWingLayer:EntityMutiLayerChildModel;
		private var _weaponLayer:EntityMutiLayerChildModel;
		private var _weaponEffectLayer:EntityMutiLayerChildModel;
		private var _handEffectLayer:EntityMutiLayerChildModel;
		private var _shieldLayer:EntityMutiLayerChildModel;
		
		private var _blendModeContainer:Sprite;
		private var _blendModeBaseBitmap:Bitmap;
		private var _blendModeEffectBitmap:Bitmap;
		
		public function EntityMutiLayersModel(clothUrl:String, hairUrl:String, largeWingUrl:String, smallWingUrl:String, weaponUrl:String, weaponEffectUrl:String, handEffectUrl:String, shieldUrl:String, nDirection:int)
		{
			_clothUrl = clothUrl;
			_hairUrl = hairUrl;
			_largeWingUrl = largeWingUrl;
			_smallWingUrl = smallWingUrl;
			_weaponUrl = weaponUrl;
			_weaponEffectUrl = weaponEffectUrl;
			_handEffectUrl = handEffectUrl;
			_shieldUrl = shieldUrl;
			_nDirection = nDirection;
			_readyActionIds = new Vector.<Vector.<Boolean>>(ActionTypes.NACTIONS);
			var i:int, j:int;
			for (i = 0; i < ActionTypes.NACTIONS; ++i)
			{
				_readyActionIds[i] = new Vector.<Boolean>(nDirection);
				for (j = 0; j < nDirection; ++j)
				{
					_readyActionIds[i][j] = false;
				}
			}
			_blendModeContainer = new Sprite();
			_blendModeBaseBitmap = new Bitmap();
			_blendModeEffectBitmap = new Bitmap();
			_blendModeContainer.addChild(_blendModeBaseBitmap);
			_blendModeContainer.addChild(_blendModeEffectBitmap);
		}
		
		public override function init():void
		{
			if (_clothUrl)
			{
				_clothLayer = new EntityMutiLayerChildModel(_clothUrl, EntityLayerType.CLOTH, _nDirection);
				_clothLayer.init();
			}
			if (_hairUrl)
			{
				_hairLayer = new EntityMutiLayerChildModel(_hairUrl, EntityLayerType.HAIR, _nDirection);
				_hairLayer.init();
			}
			if (_largeWingUrl)
			{
				_largeWingLayer = new EntityMutiLayerChildModel(_largeWingUrl, EntityLayerType.LARGEWING, _nDirection);
				_largeWingLayer.init();
			}
			if (_smallWingUrl)
			{
				_smallWingLayer = new EntityMutiLayerChildModel(_smallWingUrl, EntityLayerType.SMALLWING, _nDirection);
				_smallWingLayer.init();
			}
			if (_weaponUrl)
			{
				_weaponLayer = new EntityMutiLayerChildModel(_weaponUrl, EntityLayerType.WEAPON, _nDirection);
				_weaponLayer.init();
			}
			if (_weaponEffectUrl)
			{
				_weaponEffectLayer = new EntityMutiLayerChildModel(_weaponEffectUrl, EntityLayerType.WEAPONEFFECT, _nDirection);
				_weaponEffectLayer.init();
			}
			if (_handEffectUrl)
			{
				_handEffectLayer = new EntityMutiLayerChildModel(_handEffectUrl, EntityLayerType.HANDEFFECT, _nDirection);
				_handEffectLayer.init();
			}
			if (_shieldUrl)
			{
				_shieldLayer = new EntityMutiLayerChildModel(_shieldUrl, EntityLayerType.SHIELD, _nDirection);
				_shieldLayer.init();
			}
		}
		
		public override function get available():Boolean
		{
			if (!_available)
			{
				_available = _clothLayer
					&& _clothLayer.available
					&& (!_hairLayer || _hairLayer.available)
					&& (!_largeWingLayer || _largeWingLayer.available)
					&& (!_smallWingLayer || _smallWingLayer.available)
					&& (!_weaponLayer || _weaponLayer.available)
					&& (!_weaponEffectLayer || _weaponEffectLayer.available)
					&& (!_handEffectLayer || _handEffectLayer.available)
					&& (!_shieldLayer || _shieldLayer.available);
				if (_available)
				{
					var baseSingleLayer:EntitySingleLayerModel = _clothLayer.singleLayerModel;
					initInfoByBaseLayer(baseSingleLayer);
					
					if (_clothUrl)
					{
						_clothLayer.initByBaseLayer(baseSingleLayer);
					}
					if (_hairLayer)
					{
						_hairLayer.initByBaseLayer(baseSingleLayer);
					}
					if (_largeWingLayer)
					{
						_largeWingLayer.initByBaseLayer(baseSingleLayer);
					}
					if (_smallWingLayer)
					{
						_smallWingLayer.initByBaseLayer(baseSingleLayer);
					}
					if (_weaponLayer)
					{
						_weaponLayer.initByBaseLayer(baseSingleLayer);
					}
					if (_weaponEffectLayer)
					{
						_weaponEffectLayer.initByBaseLayer(baseSingleLayer);
					}
					if (_handEffectLayer)
					{
						_handEffectLayer.initByBaseLayer(baseSingleLayer);
					}
					if (_shieldLayer)
					{
						_shieldLayer.initByBaseLayer(baseSingleLayer);
					}
				}
			}
			return _available;
		}
		
//		public override function get ready():Boolean
//		{
//			if (!_ready)
//			{
//				_ready = (!_mountLayer || _mountLayer.ready) && (!_cloakLayer || _cloakLayer.ready) && (!_clothLayer || _clothLayer.ready) && (!_weaponLayer || _weaponLayer.ready);
//				if (_ready)
//				{
//					var baseSingleLayer:EntitySingleLayerModel = _clothLayer.singleLayerModel;
//					initInfoByBaseLayer(baseSingleLayer);
//					
//					if (_mountUrl)
//					{
//						initMountInfo();
//						_mountLayer.initByBaseLayer(baseSingleLayer);
//					}
//					if (_cloakUrl)
//					{
//						_cloakLayer.initByBaseLayer(baseSingleLayer);
//					}
//					if (_clothUrl)
//					{
//						_clothLayer.initByBaseLayer(baseSingleLayer);
//					}
//					if (_weaponUrl)
//					{
//						_weaponLayer.initByBaseLayer(baseSingleLayer);
//					}
//				}
//			}
//			return _ready;
//		}
		
		public override function checkReadyByActionIdAndDirection(actionId:int, direction:int):Boolean
		{
			if (!_readyActionIds[actionId - 1][direction])
			{
				var clothReady:Boolean = !_clothLayer || _clothLayer.checkReadyByActionIdAndDirection(actionId, direction);
				var hairReady:Boolean = checkHairLayerReady(actionId, direction);
				var largeWingReady:Boolean = checkLargeWingLayerReady(actionId, direction);
				var smallWingReady:Boolean = checkSmallWingLayerReady(actionId, direction);
				var weaponReady:Boolean = checkWeaponLayerReady(actionId, direction);
				var weaponEffectReady:Boolean = checkWeaponEffectLayerReady(actionId, direction);
				var handEffectReady:Boolean = checkHandEffectLayerReady(actionId, direction);
				var shieldReady:Boolean = checkShieldLayerReady(actionId, direction);
				var ready:Boolean =  clothReady && hairReady && largeWingReady && smallWingReady && weaponReady && weaponEffectReady && handEffectReady && shieldReady;
				_readyActionIds[actionId - 1][direction] = ready;
			}
			return _readyActionIds[actionId - 1][direction];
		}
		
		private function checkHairLayerReady(actionId:int, direction:int):Boolean
		{
			if (!_hairLayer)
			{
				return true;
			}
			return _hairLayer.checkReadyByActionIdAndDirection(actionId, direction);
		}
		
		private function checkLargeWingLayerReady(actionId:int, direction:int):Boolean
		{
			if (!_largeWingLayer)
			{
				return true;
			}
			return _largeWingLayer.checkReadyByActionIdAndDirection(actionId, direction);
		}
		
		private function checkSmallWingLayerReady(actionId:int, direction:int):Boolean
		{
			if (!_smallWingLayer)
			{
				return true;
			}
			return _smallWingLayer.checkReadyByActionIdAndDirection(actionId, direction);
		}
		
		private function checkShieldLayerReady(actionId:int, direction:int):Boolean
		{
			if (!_shieldLayer)
			{
				return true;
			}
			return _shieldLayer.checkReadyByActionIdAndDirection(actionId, direction);
		}
		
		private function checkWeaponLayerReady(actionId:int, direction:int):Boolean
		{
			if (!_weaponLayer)
			{
				return true;
			}
			return _weaponLayer.checkReadyByActionIdAndDirection(actionId, direction);
		}
		
		private function checkWeaponEffectLayerReady(actionId:int, direction:int):Boolean
		{
			if (!_weaponEffectLayer)
			{
				return true;
			}
			return _weaponEffectLayer.checkReadyByActionIdAndDirection(actionId, direction);
		}
		
		private function checkHandEffectLayerReady(actionId:int, direction:int):Boolean
		{
			if (!_handEffectLayer)
			{
				return true;
			}
			return _handEffectLayer.checkReadyByActionIdAndDirection(actionId, direction);
		}
		
//		public override function enterframe():void
//		{
//			if (_nUnFinishedImageItem > 0 && _ready)
//			{
//				while (_imageItems[_iGenImage])
//				{
//					_iGenImage ++;
//				}
//				
//				genImageItem(_iGenImage);
//			}
//		}
		
		protected function initInfoByBaseLayer(baseLayer:EntitySingleLayerModel):void
		{
//			trace("EntityMutiLayersModel.initInfoByBaseLayer(baseLayer) 资源，url："+baseLayer.clothUrl+"单方向总帧数："+baseLayer.nFrame);
			_nFrame = baseLayer.nFrame;
			_width = baseLayer.width;
			_height = baseLayer.height;
			_directions = baseLayer.directions;
			_modelHeight = baseLayer.modelHeight;
			_directions = baseLayer.directions;
			_shadowOffset = baseLayer.shadowOffset;
//			_mountY = baseLayer.mountY;
			_idle = baseLayer.idle;
			_idleFrameRate = baseLayer.idleFrameRate;
			_run = baseLayer.run;
			_runFrameRate = baseLayer.runFrameRate;
			_hurt = baseLayer.hurt;
			_hurtFrameRate = baseLayer.hurtFrameRate;
			_dead = baseLayer.dead;
			_deadFrameRate = baseLayer.deadFrameRate;
			_pattack = baseLayer.pattack;
			_pattackFrameRate = baseLayer.pattackFrameRate;
			_mattack = baseLayer.mattack;
			_mattackFrameRate = baseLayer.mattackFrameRate;
			_rushidle = baseLayer.rushidle;
			_rushidleFrameRate = baseLayer.rushidleFrameRate;
			_rush = baseLayer.rush;
			_rushFrameRate = baseLayer.rushFrameRate;
			_walk = baseLayer.walk;
			_walkFrameRate = baseLayer.walkFrameRate;
			_unknow1 = baseLayer.unknow1;
			_unknow1FrameRate = baseLayer.unknow1FrameRate;
			_jointattack = baseLayer.jointattack;
			_jointattackFrameRate = baseLayer.jointattackFrameRate;
			_sunbathe = baseLayer.sunbathe;
			_sunbatheFrameRate = baseLayer.sunbatheFrameRate;
			_footsie = baseLayer.footsie;
			_footsieFrameRate = baseLayer.footsieFrameRate;
			_massage = baseLayer.massage;
			_massageFrameRate = baseLayer.massageFrameRate;
			_beMassage = baseLayer.beMassage;
			_beMassageFrameRate = baseLayer.beMassageFrameRate;
			_unknow2 = baseLayer.unknow2;
			_unknow2FrameRate = baseLayer.unknow2FrameRate;
			_unknow3 = baseLayer.unknow3;
			_unknow3FrameRate = baseLayer.unknow3FrameRate;
			_unknow4 = baseLayer.unknow4;
			_unknow4FrameRate = baseLayer.unknow4FrameRate;
			_unknow5 = baseLayer.unknow5;
			_unknow5FrameRate = baseLayer.unknow5FrameRate;
			_unknow6 = baseLayer.unknow6;
			_unknow6FrameRate = baseLayer.unknow6FrameRate;
			_gather = baseLayer.gather;
			_gatherFrameRate = baseLayer.gatherFrameRate;
			_reveal = baseLayer.reveal;
			_revealFrameRate = baseLayer.revealFrameRate;
			
			blendModeType = baseLayer.blendModeType;
			
			switch(_directions)
			{
				case N_DIRECTION_1:
				case N_DIRECTION_8:
					_nUnFinishedImageItem = _nFrame * _directions;
					break;
				case N_DIRECTION_5:
					_nUnFinishedImageItem = _nFrame * 8;
					break;
			}
//			clearImageItems();
			_imageItems = new Vector.<ImageItem>(_nUnFinishedImageItem);
			_iGenImage = 0;
			
			super.initInfoBySelf();
		}
		
		public override function getImageItemByFrame(iFrame:int):ImageItem
		{
			if (!_imageItems[iFrame])
			{
				genImageItem(iFrame);
			}
			return super.getImageItemByFrame(iFrame);
		}
		
		private function genImageItem(iFrame:int):void
		{
			if (!_imageItems[iFrame])
			{
				var actionId:int = iFrameToActionId(iFrame);
				var iDir:int = iFrame / _nFrame;
				var actionCurrentFrame:int = iFrame -iDir*_nFrame-getActionStartFrame(actionId);
				if (checkReadyByActionIdAndDirection(actionId, iDir))
				{
					var imageItem:ImageItem;
					var bitmapData:BitmapData;
					var iSubFrame:int = iFrame % _nFrame;
					var layerModels:Vector.<EntityMutiLayerChildModel> = new Vector.<EntityMutiLayerChildModel>();
					setLayerMode(layerModels,actionId,iDir,actionCurrentFrame);
					
					var startX:int = _width;
					var startY:int = _height;
					var endX:int = 0;
					var endY:int = 0;
					var size:int = layerModels.length;
					var i:int;
					var model:EntityMutiLayerChildModel;
					var imageItems:Vector.<ImageItem> = new Vector.<ImageItem>();
					var layerImageItem:ImageItem;
					var clothLayerImageItem:ImageItem;
					for (i = 0; i < size; i++)
					{
						model = layerModels[i];
						layerImageItem = model.getImageItemByFrame(iFrame);
						if (model == _clothLayer)
						{
							clothLayerImageItem = layerImageItem;
						}
						if (layerImageItem)
						{
							imageItems.push(layerImageItem);
							if (layerImageItem.offsetX < startX)
							{
								startX = layerImageItem.offsetX;
							}
							if (layerImageItem.offsetY < startY)
							{
								startY = layerImageItem.offsetY;
							}
							if (layerImageItem.offsetX + layerImageItem.bitmapData.width > endX)
							{
								endX = layerImageItem.offsetX + layerImageItem.bitmapData.width;
							}
							if (layerImageItem.offsetY + layerImageItem.bitmapData.height > endY)
							{
								endY = layerImageItem.offsetY + layerImageItem.bitmapData.height;
							}
						}
					}
					if(endX == 0)
					{
						trace("endX:"+endX.toString());
					}
					if (endX > startX && endY > startY)
					{
						bitmapData = new BitmapData(endX - startX, endY - startY, true, 0x00000000);
						
						size = imageItems.length;
						for (i = 0; i < size; i++)
						{
							layerImageItem = imageItems[i];
							if (layerImageItem.blendType > 0)
							{
								bitmapData.draw(layerImageItem.bitmapData, new Matrix(1, 0, 0, 1, layerImageItem.offsetX - startX, layerImageItem.offsetY - startY), null, UtilType2BlendModel.getBlendModel(layerImageItem.blendType));
							}
							else
							{
								bitmapData.copyPixels(layerImageItem.bitmapData, layerImageItem.bitmapData.rect, new Point(layerImageItem.offsetX - startX, layerImageItem.offsetY - startY), null, null, true);
							}
						}
						imageItem = new ImageItem();
						imageItem.initByBitmapData(bitmapData, startX, startY, clothLayerImageItem.bitmapData, clothLayerImageItem.offsetX, clothLayerImageItem.offsetY, clothLayerImageItem.shadowHeight);
						_imageItems[iFrame] = imageItem;
						
						_nUnFinishedImageItem --;
						
						if (_nUnFinishedImageItem <= 0)
						{
							for (i = 0; i < size; i++)
							{
								model = layerModels[i];
								model.destroy();
							}
							layerModels.length = 0;
							layerModels = null;
							
							_clothLayer = null;
							_hairLayer = null;
							_largeWingLayer = null;
							_clothLayer = null;
							_weaponLayer = null;
							_shieldLayer = null;
						}
					}
				}
			}
		}
		
		private function setLayerMode(_layerModels:Vector.<EntityMutiLayerChildModel>, _actionId:int, _iDir:int,_currentFrame:int):void
		{
			var entityLayerCfgData:EntityLayerCfgData;
			switch(_actionId)
			{
				case ActionTypes.GATHER:
					ConfigDataManager.instance.entityLayerCfgDatas(ActionTypes.GATHER,_iDir);
					entityLayerCfgData = ConfigDataManager.instance.entityLayerCfgData(ActionTypes.GATHER,_iDir,_currentFrame);
					pushLayerMode(_layerModels,entityLayerCfgData);
					break;
				case ActionTypes.IDLE:
					ConfigDataManager.instance.entityLayerCfgDatas(ActionTypes.IDLE,_iDir);
					entityLayerCfgData = ConfigDataManager.instance.entityLayerCfgData(ActionTypes.IDLE,_iDir,_currentFrame);
					pushLayerMode(_layerModels,entityLayerCfgData);
					break;
				case ActionTypes.RUN:
					ConfigDataManager.instance.entityLayerCfgDatas(ActionTypes.RUN,_iDir);
					entityLayerCfgData = ConfigDataManager.instance.entityLayerCfgData(ActionTypes.RUN,_iDir,_currentFrame);
					pushLayerMode(_layerModels,entityLayerCfgData);
					break;
				case ActionTypes.DIE:
					ConfigDataManager.instance.entityLayerCfgDatas(ActionTypes.DIE,_iDir);
					entityLayerCfgData = ConfigDataManager.instance.entityLayerCfgData(ActionTypes.DIE,_iDir,_currentFrame);
					pushLayerMode(_layerModels,entityLayerCfgData);
					break;
				case ActionTypes.PATTACK:
					ConfigDataManager.instance.entityLayerCfgDatas(ActionTypes.PATTACK,_iDir);
					entityLayerCfgData = ConfigDataManager.instance.entityLayerCfgData(ActionTypes.PATTACK,_iDir,_currentFrame);
					pushLayerMode(_layerModels,entityLayerCfgData);
					break;
				case ActionTypes.MATTACK:
					ConfigDataManager.instance.entityLayerCfgDatas(ActionTypes.MATTACK,_iDir);
					entityLayerCfgData = ConfigDataManager.instance.entityLayerCfgData(ActionTypes.MATTACK,_iDir,_currentFrame);
					pushLayerMode(_layerModels,entityLayerCfgData);
					break;
				case ActionTypes.WALK:
					ConfigDataManager.instance.entityLayerCfgDatas(ActionTypes.WALK,_iDir);
					entityLayerCfgData = ConfigDataManager.instance.entityLayerCfgData(ActionTypes.WALK,_iDir,_currentFrame);
					pushLayerMode(_layerModels,entityLayerCfgData);
					break;
				case ActionTypes.REVEAL:
					ConfigDataManager.instance.entityLayerCfgDatas(ActionTypes.REVEAL,_iDir);
					entityLayerCfgData = ConfigDataManager.instance.entityLayerCfgData(ActionTypes.REVEAL,_iDir,_currentFrame);
					pushLayerMode(_layerModels,entityLayerCfgData);
					break;
				case ActionTypes.SUNBATHE:
				case ActionTypes.FOOTSIE:
				case ActionTypes.MASSAGE:
				case ActionTypes.BE_MASSAGE:
					_layerModels.push(_clothLayer);
					break;
				default:
					break
			}
		}
		
		private function pushLayerMode(_layerModels:Vector.<EntityMutiLayerChildModel>,cfg:EntityLayerCfgData):void
		{
			if(getEntityMutilayerChildModel(cfg.layer8) != null)
			{
				_layerModels.push(getEntityMutilayerChildModel(cfg.layer8));
			}
			if(getEntityMutilayerChildModel(cfg.layer7) != null)
			{
				_layerModels.push(getEntityMutilayerChildModel(cfg.layer7));
			}
			if(getEntityMutilayerChildModel(cfg.layer6) != null)
			{
				_layerModels.push(getEntityMutilayerChildModel(cfg.layer6));
			}
			if(getEntityMutilayerChildModel(cfg.layer5) != null)
			{
				_layerModels.push(getEntityMutilayerChildModel(cfg.layer5));
			}
			if(getEntityMutilayerChildModel(cfg.layer4) != null)
			{
				_layerModels.push(getEntityMutilayerChildModel(cfg.layer4));
			}
			if(getEntityMutilayerChildModel(cfg.layer3) != null)
			{
				_layerModels.push(getEntityMutilayerChildModel(cfg.layer3));
			}
			if(getEntityMutilayerChildModel(cfg.layer2) != null)
			{
				_layerModels.push(getEntityMutilayerChildModel(cfg.layer2));
			}
			if(getEntityMutilayerChildModel(cfg.layer1) != null)
			{
				_layerModels.push(getEntityMutilayerChildModel(cfg.layer1));
			}
		}
		private function getEntityMutilayerChildModel(entityLayerType:int):EntityMutiLayerChildModel
		{
			switch(entityLayerType)
			{
				case EntityLayerType.NULL:
					return null;
					break;
				case EntityLayerType.CLOTH:
					if(_clothLayer)
					{
						return _clothLayer;
					}
					break;
				case EntityLayerType.HAIR:
					if(_hairLayer)
					{
						return _hairLayer;
					}
					break;
				case EntityLayerType.SHIELD:
					if(_shieldLayer)
					{
						return _shieldLayer;
					}
					break;
				case EntityLayerType.HANDEFFECT:
					if(_handEffectLayer)
					{
						return _handEffectLayer;
					}
					break;
				case EntityLayerType.WEAPONEFFECT:
					if(_weaponEffectLayer)
					{
						return _weaponEffectLayer;
					}
					break;
				case EntityLayerType.WEAPON:
					if(_weaponLayer)
					{
						return _weaponLayer;
					}
					break;
				case EntityLayerType.SMALLWING:
					if(_smallWingLayer)
					{
						return _smallWingLayer;
					}
					break;
				case EntityLayerType.LARGEWING:
					if(_largeWingLayer)
					{
						return _largeWingLayer;
					}
					break;
				default:
					break;
			}
			return null;
		}
		public override function destroy():void
		{
			if (_clothLayer)
			{
				_clothLayer.destroy();
				_clothLayer = null;
			}
			if (_hairLayer)
			{
				_hairLayer.destroy();
				_hairLayer = null;
			}
			if (_largeWingLayer)
			{
				_largeWingLayer.destroy();
				_largeWingLayer = null;
			}
			if (_smallWingLayer)
			{
				_smallWingLayer.destroy();
				_smallWingLayer = null;
			}
			if (_weaponLayer)
			{
				_weaponLayer.destroy();
				_weaponLayer = null;
			}
			if (_weaponEffectLayer)
			{
				_weaponEffectLayer.destroy();
				_weaponEffectLayer = null;
			}
			if (_handEffectLayer)
			{
				_handEffectLayer.destroy();
				_handEffectLayer = null;
			}
			if (_shieldLayer)
			{
				_shieldLayer.destroy();
				_shieldLayer = null;
			}
			
			super.destroy();
		}
	}
}