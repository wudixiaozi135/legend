package com.view.gameWindow.panel.panels.hero.tab1
{
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
	import com.view.gameWindow.scene.entity.constants.ActionTypes;
	import com.view.gameWindow.scene.entity.constants.Direction;
	import com.view.gameWindow.scene.entity.model.EntityModelsManager;
	import com.view.gameWindow.scene.entity.model.base.EntityModel;
	import com.view.gameWindow.scene.entity.model.imageItem.ImageItem;
	import com.view.gameWindow.scene.entity.model.utils.EntityModelUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * 界面中模型处理类<br>默认处理英雄模型
	 * @author Administrator
	 */	
	public class EntityModeInUIlHandle
	{
		protected var _entityModel:EntityModel;
		protected var _direction:int;
		protected var _frameRateCount:int;
		protected var _frameRate:int;
		protected var _currentFrame:int;
		protected var _endFrame:int;
		protected var _actionRepeat:Boolean;
		protected var _startFrame:int;
		protected var _viewBitmap:Bitmap;
		protected var _timer:Timer;
		protected var isInit:Boolean;
		
		public function EntityModeInUIlHandle(layer:MovieClip)
		{
			_viewBitmap = new Bitmap();
			_viewBitmap.smoothing = true;
			layer.addChild(_viewBitmap);
			layer.mouseEnabled = false;
			_endFrame = 0;
			_direction = Direction.RIGHT;
			_actionRepeat = true;
			_timer = new Timer(16.67);
			_timer.addEventListener(TimerEvent.TIMER,refreshModel);
			_timer.start();
		}
		
		public function changeModel():void
		{
			isInit = false;
			var sex:int = HeroDataManager.instance.sex;
			var cloth:int = getBaseId(ConstEquipCell.HP_YIFU);
			var weapon:int = getBaseId(ConstEquipCell.HP_WUQI);
			var oldEntityModel:EntityModel = _entityModel;
			_entityModel = EntityModelUtil.getEntityModel(cloth, HeroDataManager.instance.fashionId, weapon, 0, 0, 0, 0, sex, ActionTypes.NOACTION, EntityModel.N_DIRECTION_8);
			EntityModelsManager.getInstance().unUseModel(oldEntityModel);
		}
		/**获取基础id*/
		protected function getBaseId(equipSlot:int):int
		{
			var equipDatas:Vector.<EquipData>,equipData:EquipData;
			equipDatas = HeroDataManager.instance.equipDatas;
			if(equipDatas.length <= equipSlot)
			{
				return 0;
			}
			equipData = equipDatas[equipSlot];
			if(!equipData)
			{
				return 0;
			}
			var memEquipData:MemEquipData;
			memEquipData = MemEquipDataManager.instance.memEquipData(equipData.bornSid,equipData.id);
			if(!memEquipData)
			{
				return 0;
			}
			return memEquipData.baseId;
		}
		
		protected function refreshModel(event:TimerEvent):void
		{
			if(_direction == Direction.INVALID_DIRECTION)
			{
				return;
			}
			if(!_entityModel)
			{
				return;
			}
			if(!_entityModel.checkReadyByActionIdAndDirection(ActionTypes.REVEAL, _direction))
			{
				return;
			}
			if(!_entityModel.available)
			{
				return;
			}
			if(!isInit)
			{
				isInit = true;
				_currentFrame = _startFrame = _entityModel.revealStart - 1;
				_endFrame = _entityModel.revealEnd;
				_frameRate = _entityModel.revealFrameRate;
				_frameRateCount = _frameRate;
			}
			_frameRateCount++;
			if(_frameRateCount>_frameRate)
			{
				_frameRateCount=0;
				if(_currentFrame>=_endFrame)
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
					_viewBitmap.bitmapData = bitmapData;
					updatePostion(imageItem);
				}
			}
		}
		
		protected function updatePostion(imageItem:ImageItem):void
		{
			_viewBitmap.x = -_entityModel.width/2 + imageItem.offsetX;
			_viewBitmap.y = -_entityModel.height + _entityModel.shadowOffset + imageItem.offsetY-80;
		}
		
		public function destroy():void
		{
			if(_timer)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER,refreshModel);
			}
			_timer = null;
			EntityModelsManager.getInstance().unUseModel(_entityModel);
			_entityModel = null;
			if(_viewBitmap)
			{
				if(_viewBitmap.bitmapData)
					_viewBitmap.bitmapData = null;
				if(_viewBitmap.parent)
					_viewBitmap.parent.removeChild(_viewBitmap);
			}
			_viewBitmap = null;
			_direction = Direction.INVALID_DIRECTION;
			reset();
			_actionRepeat = false;
		}
		
		protected function reset():void
		{
			_frameRateCount = 0;
			_frameRate = 0;
			_currentFrame = 0;
			_endFrame = 0;
			_startFrame = 0;
		}
	}
}