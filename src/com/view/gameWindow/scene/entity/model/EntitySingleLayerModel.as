package com.view.gameWindow.scene.entity.model
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.view.gameWindow.scene.entity.constants.ActionTypes;
	import com.view.gameWindow.scene.entity.constants.EntityLayerType;
	import com.view.gameWindow.scene.entity.model.actionDirItem.ActionDirLoadItem;
	import com.view.gameWindow.scene.entity.model.base.EntityModel;
	import com.view.gameWindow.scene.entity.model.imageItem.ImageItem;
	

	public class EntitySingleLayerModel extends EntityModel
	{
		private var _layerUrl:String;
		
		private var _actionDirItems:Vector.<Vector.<ActionDirLoadItem>>;
		
		private var _layerType : int;
		
		public function EntitySingleLayerModel(layerUrl:String, layerType:int, nDirection:int)
		{
			_layerUrl = layerUrl;
			_layerType = layerType;
			_nDirection = nDirection;
			_actionDirItems = new Vector.<Vector.<ActionDirLoadItem>>(ActionTypes.NACTIONS);
			for (var i:int = 0; i < _actionDirItems.length; ++i)
			{
				_actionDirItems[i] = new Vector.<ActionDirLoadItem>(_nDirection);
			}
			
			if (layerType == EntityLayerType.CLOTH)
			{
				_clothUrl = layerUrl;
			}
			else if (layerType == EntityLayerType.HAIR)
			{
				_hairUrl = layerUrl;
			}
			else if (layerType == EntityLayerType.LARGEWING)
			{
				_largeWingUrl = layerUrl;
			}
			else if (layerType == EntityLayerType.SMALLWING)
			{
				_smallWingUrl = layerUrl;
			}
			else if (layerType == EntityLayerType.WEAPON)
			{
				_weaponUrl = layerUrl;
			}
			else if (layerType == EntityLayerType.WEAPONEFFECT)
			{
				_weaponEffectUrl = layerUrl;
			}
			else if (layerType == EntityLayerType.HANDEFFECT)
			{
				_handEffectUrl = layerUrl;
			}
			else if (layerType == EntityLayerType.SHIELD)
			{
				_shieldUrl = layerUrl;
			}
		}
		
		public override function getImageItemByFrame(iFrame:int):ImageItem
		{
//			var i:int = iFrame/_nFrame;
//			if(i > 0)
//			{
//				iFrame = (8 - i)*_nFrame + iFrame%_nFrame;
//			}
			var imageItem:ImageItem = super.getImageItemByFrame(iFrame);
			if (imageItem)
			{
				return imageItem;
			}
			else
			{
				var iDir:int = iFrame / _nFrame;
				var iSubFrame:int = iFrame % _nFrame;
				if (_directions == N_DIRECTION_5 && iDir >= _directions)
				{
					iDir = N_DIRECTION_8 - iDir;
					var oriImageItem:ImageItem = super.getImageItemByFrame(iDir * _nFrame + iSubFrame);
					if (!oriImageItem)
					{
						getImageFromActionItem(iFrame);
						oriImageItem = super.getImageItemByFrame(iDir * _nFrame + iSubFrame);
					}
					if (oriImageItem && oriImageItem.ready)
					{
						imageItem = new ImageItem();
						imageItem.initBySymItem(oriImageItem, _width);
						_imageItems[iFrame] = imageItem;
						return imageItem;
					}
				}
				else
				{
					getImageFromActionItem(iFrame);
					return super.getImageItemByFrame(iFrame);
				}
			}
			return null;
		}
		
		private function getImageFromActionItem(iFrame:int):void
		{
			var actionId:int = iFrameToActionId(iFrame);
			var iDir:int = iFrame / _nFrame;
			if (_actionDirItems.length >= actionId)
			{
				if (_directions == N_DIRECTION_5 && iDir >= _directions)
				{
					iDir = N_DIRECTION_8 - iDir;
				}
				if(actionId - 1 >= _actionDirItems.length)
				{
					trace("EntitySingleLayerModel.getImageFromActionItem(iFrame) 动作" + actionId + "资源不存在");
					return;
				}
				if(iDir >= _actionDirItems[actionId - 1].length)
				{
					trace("EntitySingleLayerModel.getImageFromActionItem(iFrame) 方向" + iDir + "资源不存在");
					return;
				}
				var actionLoadItem:ActionDirLoadItem = _actionDirItems[actionId - 1][iDir];
				if (actionLoadItem && actionLoadItem.ready)
				{
					var actionStart:int = getActionStartFrame(actionId);
					var nActionFrame:int = getNActionFrame(actionId);
					
					for (var i:int = 0; i < nActionFrame; i++)
					{
						if (iDir * _nFrame + actionStart + i >= _imageItems.length)
						{
							trace("EntitySingleLayerModel.getImageFromActionItem(iFrame) actionItemError:imageItem iItem:" + (iDir * _nFrame + actionStart + i) + "\n url:" + _layerUrl);
						}
						else if (i >= actionLoadItem.imageItems.length)
						{
							trace("EntitySingleLayerModel.getImageFromActionItem(iFrame) actionItemError:actionLoadItem.imageItem iItem:" + (actionStart + i) + "\n url:" + _layerUrl);
						}
						else
						{
							_imageItems[iDir * _nFrame + actionStart + i] = actionLoadItem.imageItems[i];
						}
					}
				}
			}
		}
		
		public override function get available():Boolean
		{
			if (!_available)
			{
				var isAvailable:Boolean = false;
				var availableActionDirLoadItem:ActionDirLoadItem;
				for each (var actionDirLoadItems:Vector.<ActionDirLoadItem> in _actionDirItems)
				{
					for each (var actionDirLoadItem:ActionDirLoadItem in actionDirLoadItems)
					{
						if (actionDirLoadItem)
						{
							if (actionDirLoadItem.available)
							{
								isAvailable = true;
								availableActionDirLoadItem = actionDirLoadItem;
								break;
							}
						}
					}
					if (isAvailable)
					{
						break;
					}
				}
				if (isAvailable && availableActionDirLoadItem)
				{
					_available = true;
					initActionInfo(availableActionDirLoadItem);
				}
			}
			return _available;
		}
		
		private function initActionInfo(actionLoadItem:ActionDirLoadItem):void
		{
//			trace("EntitySingleLayerModel.initActionInfo(actionLoadItem) 资源，url："+actionLoadItem.url+"单方向总帧数："+actionLoadItem.nFrame);
			_nFrame = actionLoadItem.nFrame;
			_width = actionLoadItem.width;
			_height = actionLoadItem.height;
			_directions = actionLoadItem.directions;
			_modelHeight = actionLoadItem.modelHeight;
			_shadowOffset = actionLoadItem.shadowOffset;
//			_mountY = actionLoadItem.mountY;
			_idle = actionLoadItem.idle;
			_idleFrameRate = actionLoadItem.idleFrameRate;
			_run = actionLoadItem.run;
			_runFrameRate = actionLoadItem.runFrameRate;
			_hurt = actionLoadItem.hurt;
			_hurtFrameRate = actionLoadItem.hurtFrameRate;
			_dead = actionLoadItem.dead;
			_deadFrameRate = actionLoadItem.deadFrameRate;
			_pattack = actionLoadItem.pattack;
			_pattackFrameRate = actionLoadItem.pattackFrameRate;
			_mattack = actionLoadItem.mattack;
			_mattackFrameRate = actionLoadItem.mattackFrameRate;
			_rushidle = actionLoadItem.rushidle;
			_rushidleFrameRate = actionLoadItem.rushidleFrameRate;
			_rush = actionLoadItem.rush;
			_rushFrameRate = actionLoadItem.rushFrameRate;
			_walk = actionLoadItem.walk;
			_walkFrameRate = actionLoadItem.walkFrameRate;
			_unknow1 = actionLoadItem.unknow1;
			_unknow1FrameRate = actionLoadItem.unknow1FrameRate;
			_jointattack = actionLoadItem.jointattack;
			_jointattackFrameRate = actionLoadItem.jointattackFrameRate;
			_sunbathe = actionLoadItem.sunbathe;
			_sunbatheFrameRate = actionLoadItem.continuattack1FrameRate;
			_footsie = actionLoadItem.footsie;
			_footsieFrameRate = actionLoadItem.continuattack2FrameRate;
			_massage = actionLoadItem.massage;
			_massageFrameRate = actionLoadItem.continuattack3FrameRate;
			_beMassage = actionLoadItem.beMassage;
			_beMassageFrameRate = actionLoadItem.continuattack4FrameRate;
			_unknow2 = actionLoadItem.unknow2;
			_unknow2FrameRate = actionLoadItem.unknow2FrameRate;
			_unknow3 = actionLoadItem.unknow3;
			_unknow3FrameRate = actionLoadItem.unknow3FrameRate;
			_unknow4 = actionLoadItem.unknow4;
			_unknow4FrameRate = actionLoadItem.unknow4FrameRate;
			_unknow5 = actionLoadItem.unknow5;
			_unknow5FrameRate = actionLoadItem.unknow5FrameRate;
			_unknow6 = actionLoadItem.unknow6;
			_unknow6FrameRate = actionLoadItem.unknow6FrameRate;
			_gather = actionLoadItem.gather;
			_gatherFrameRate = actionLoadItem.gatherFrameRate;
			_reveal = actionLoadItem.reveal;
			_revealFrameRate = actionLoadItem.revealFrameRate;
			
			blendModeType = actionLoadItem.blendModeType;
			
			initInfoBySelf();
//			clearImageItems();
			
			switch(_directions)
			{
				case 1:
					_imageItems = new Vector.<ImageItem>(_nFrame);
					break;
				case 8:
					_imageItems = new Vector.<ImageItem>(_nFrame * _directions);
					break;
				case 5:
					_imageItems = new Vector.<ImageItem>(_nFrame * 8);
					break;
			}
			_unReadyImageItems = new Vector.<ImageItem>();
		}
		
		public function initByBaseLayer(baseLayer:EntityModel):void
		{
//			trace("EntitySingleLayerModel.initByBaseLayer(baseLayer) 资源，url："+baseLayer.clothUrl+"单方向总帧数："+baseLayer.nFrame);
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
			
			initInfoBySelf();
			var nImageItems:int;
			switch(baseLayer.directions)
			{
				case 1:
					nImageItems = _nFrame;
					break;
				case 8:
					nImageItems = _nFrame * baseLayer.directions;
					break;
				case 5:
					nImageItems = _nFrame * 8;
					break;
			}
//			clearImageItems();
			_imageItems = new Vector.<ImageItem>(nImageItems);
		}
		
//		public override function get ready():Boolean
//		{
//			if (!available)
//			{
//				return false;
//			}
//			if (!_ready)
//			{
//				testReady();
//			}
//			return super.ready;
//		}
		
//		public function testReady():void
//		{
//			if (_unReadyImageItems)
//			{
//				while (_unReadyImageItems.length > 0)
//				{
//					var imageItem:ImageItem = _unReadyImageItems[0];
//					if (imageItem.ready)
//					{
//						_unReadyImageItems.shift();
//					}
//					else
//					{
//						return;
//					}
//				}
//				_available = true;
//				_ready = true;
//			}
//		}
		
		public override function checkReadyByActionIdAndDirection(actionId:int, direction:int):Boolean
		{
			var trueDir:int = direction;
			if (_nDirection == N_DIRECTION_5 && direction >= N_DIRECTION_5)
			{
				trueDir = N_DIRECTION_8 - direction;
			}
			var actionLoadItem:ActionDirLoadItem =_actionDirItems[actionId - 1][trueDir] =( _actionDirItems[actionId - 1][trueDir] || new ActionDirLoadItem(actionId, _layerUrl + actionId + "_" + (trueDir + 1) + ResourcePathConstants.POSTFIX_UNIT));
			if (!actionLoadItem.inited)
			{
				actionLoadItem.init();
			}
			return actionLoadItem.ready;
		}
		
		public function resetImageItemsByBaseLayer(model:EntityModel):void
		{
			
		}
		
		public override function destroy():void
		{
			
			if (_actionDirItems)
			{
				for each (var actionDirLoadItems:Vector.<ActionDirLoadItem> in _actionDirItems)
				{
					for each (var actionDirLoadItem:ActionDirLoadItem in actionDirLoadItems)
					{
						if (actionDirLoadItem)
						{
							actionDirLoadItem.destroy();
						}
					}
				}
				_actionDirItems.length = 0;
				_actionDirItems = null;
			}
			super.destroy();
			_available = false;
		}
	}
}