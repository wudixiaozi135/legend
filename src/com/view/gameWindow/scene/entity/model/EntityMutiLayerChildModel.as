package com.view.gameWindow.scene.entity.model
{
	import com.view.gameWindow.scene.entity.model.base.EntityModel;
	import com.view.gameWindow.scene.entity.model.imageItem.ImageItem;
	
	public class EntityMutiLayerChildModel extends EntityModel
	{
		private var _layerUrl:String;
		private var _layerType:int;
		
		private var _singleLayerModel:EntitySingleLayerModel;
		
		public function EntityMutiLayerChildModel(layerUrl:String, layerType:int, nDirection:int)
		{
			_layerUrl = layerUrl;
			_layerType = layerType;
			_nDirection = nDirection;
		}
		
		public override function init():void
		{
			_singleLayerModel = EntityModelsManager.getInstance().getAndUseSingleLayerModel(_layerUrl, _layerType, _nDirection);
		}
		
		public override function get available():Boolean
		{
			return _singleLayerModel && _singleLayerModel.available;
		}
		
//		public override function get ready():Boolean
//		{
//			return _singleLayerModel && _singleLayerModel.ready;
//		}
		
		public function initByBaseLayer(baseLayer:EntityModel):void
		{
			_singleLayerModel.initByBaseLayer(baseLayer);
		}
		
		private function initBySingleLayerItem(baseLayer:EntityModel):void
		{
			var iFrame:int = 0;
			if (_idle <= _singleLayerModel.idle)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.idleStart, _idle);
			}
			iFrame += _idle;
			if (_run <= _singleLayerModel.run)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.runStart, _run);
			}
			iFrame += _run;
			if (_hurt <= _singleLayerModel.hurt)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.hurtStart, _hurt);
			}
			iFrame += _hurt;
			if (_dead <= _singleLayerModel.dead)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.deadStart, _dead);
			}
			iFrame += _dead;
			if (_pattack <= _singleLayerModel.pattack)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.pattackStart, _pattack);
			}
			iFrame += _pattack;
			if (_mattack <= _singleLayerModel.mattack)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.mattackStart, _mattack);
			}
			iFrame += _mattack;
			if (_rushidle <= _singleLayerModel.rushidle)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.rushidle, _rushidle);
			}
			iFrame += _rushidle;
			if (_rush <= _singleLayerModel.rush)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.rushStart, _rush);
			}
			iFrame += _rush;
			if (_walk <= _singleLayerModel.walk)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.walkStart, _walk);
			}
			iFrame += _walk;
			if (_unknow1 <= _singleLayerModel.unknow1)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.unknow1Start, unknow1);
			}
			iFrame += unknow1;
			if (_jointattack <= _singleLayerModel.jointattack)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.jointattackStart, _jointattack);
			}
			iFrame += _jointattack;
			if (_sunbathe <= _singleLayerModel.sunbathe)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.sunbatheStart, _sunbathe);
			}
			iFrame += _sunbathe;
			if (_footsie <= _singleLayerModel.footsie)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.footsieStart, _footsie);
			}
			iFrame += _footsie;
			if (_massage <= _singleLayerModel.massage)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.massageStart, _massage);
			}
			iFrame += _massage;
			if (_beMassage <= _singleLayerModel.beMassage)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.beMassageStart, _beMassage);
			}
			iFrame += _beMassage;
			if (_unknow2 <= _singleLayerModel.unknow2)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.unknow2Start, _unknow2);
			}
			iFrame += _unknow2;
			if (_unknow3 <= _singleLayerModel.unknow3)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.unknow3Start, _unknow3);
			}
			iFrame += _unknow3;
			if (_unknow4 <= _singleLayerModel.unknow4)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.unknow4Start, _unknow4);
			}
			iFrame += _unknow4;
			if (_unknow5 <= _singleLayerModel.unknow5)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.unknow5Start, _unknow5);
			}
			iFrame += _unknow5;
			if (_unknow6 <= _singleLayerModel.unknow6)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.unknow6Start, _unknow6);
			}
			iFrame += _unknow6;
			if (_gather <= _singleLayerModel.gather)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.gatherStart, _gather);
			}
			iFrame += _gather;
			if (_reveal <= _singleLayerModel.reveal)
			{
				addImageItems(baseLayer, iFrame, _singleLayerModel.revealStart, _reveal);
			}
			iFrame += _reveal;
		}
		
		private function addImageItems(baseLayer:EntityModel, startFrame:int, singleLayerStart:int, nAddItem:int):void
		{
			var nDir:int;
			switch(baseLayer.directions)
			{
				case 1:
				case 8:
					nDir = baseLayer.directions;
					break;
				case 5:
					nDir = 8;
					break;
			}
			for (var iDir:int = 0; iDir < nDir; iDir++)
			{
				var endFrame:int = iDir * baseLayer.nFrame + startFrame + nAddItem;
				var dirStart:int = iDir * baseLayer.nFrame + startFrame;
				var singleLayerDirStart:int = iDir * _singleLayerModel.nFrame + singleLayerStart;
				for (var i:int = 0; i < nAddItem; i++)
				{
					_imageItems[dirStart + i] = _singleLayerModel.getImageItemByFrame(singleLayerDirStart + i);
				}
			}
		}
		
		public override function checkReadyByActionIdAndDirection(actionId:int, direction:int):Boolean
		{
			return _singleLayerModel.checkReadyByActionIdAndDirection(actionId, direction);
		}
		
		public function get singleLayerModel():EntitySingleLayerModel
		{
			return _singleLayerModel;
		}
		
		public override function getImageItemByFrame(iFrame:int):ImageItem
		{
			return _singleLayerModel.getImageItemByFrame(iFrame);
		}
		
		public override function destroy():void
		{
			super.destroy();
			if (_singleLayerModel)
			{
				EntityModelsManager.getInstance().unUseModel(_singleLayerModel);
				_singleLayerModel = null;
			}
		}
	}
}