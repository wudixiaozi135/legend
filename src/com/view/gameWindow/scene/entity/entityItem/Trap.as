package com.view.gameWindow.scene.entity.entityItem
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.TrapCfgData;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.scene.entity.constants.ActionTypes;
	import com.view.gameWindow.scene.entity.constants.Direction;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.constants.TrapTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.ITrap;
	import com.view.gameWindow.scene.entity.model.EntityModelsManager;
	import com.view.gameWindow.scene.entity.model.base.EntityModel;
	import com.view.gameWindow.util.UtilMouse;

	/**
	 * 机关类
	 * @author Administrator
	 */	
	public class Trap extends Unit implements ITrap
	{
		private var _trapId:int;
		private var _state:int;
		
		private var _trapConfigData:TrapCfgData;
		public var useSmallAvatarShow:Boolean = false;//是否使用小火
		public function Trap()
		{
			super();
		}
		
		public function set trapId(value:int):void
		{
			_trapId = value;
			_trapConfigData = ConfigDataManager.instance.trapCfgData(_trapId);
		}
		
		public function get trapId():int
		{
			return _trapId;
		}
		
		public override function get entityType():int
		{
			return EntityTypes.ET_TRAP;
		}
		
		public function set state(value:int):void
		{
			_state = value;
			if (_state == TrapTypes.TS_IDLE || _state == TrapTypes.TS_WORK)
			{
				idle();
			}
			else if (_state == TrapTypes.TS_CORPSE)
			{
				work();
			}
		}
		
		public function get state():int
		{
			return _state;
		}
		
		public function get trapType():int
		{
			if (_trapConfigData)
			{
				return _trapConfigData.trap_type;
			}
			return TrapCfgData.TRAP_TYPE_NO;
		}
		
		public function get triggerType():int
		{
			if (_trapConfigData)
			{
				return _trapConfigData.trigger_type;
			}
			return TrapCfgData.TRIGGER_TYPE_NO;
		}
		
		public function get isMine():Boolean
		{
			return _trapConfigData.trap_type == TrapCfgData.TRAP_TYPE_MINING;
		}
		
		public override function show():void
		{
			super.show();
			EntityModelsManager.getInstance().unUseModel(_entityModel);
			if(_trapConfigData)
			{
				if (_trapConfigData.show_name)
				{
					entityName = _trapConfigData.name;
				}
				if (useSmallAvatarShow)
				{
					_entityModel = EntityModelsManager.getInstance().getAndUseEntityModel(ResourcePathConstants.ENTITY_RES_TRAP_LOAD + _trapConfigData.small_avatar + "/", "", "", "", "", "", "", "", EntityModel.N_DIRECTION_1);
				} else
				{
					_entityModel = EntityModelsManager.getInstance().getAndUseEntityModel(ResourcePathConstants.ENTITY_RES_TRAP_LOAD + _trapConfigData.avatar + "/", "", "", "", "", "", "", "", EntityModel.N_DIRECTION_1);
				}
			}
			_direction = Direction.DOWN;
			idle();
		}

		override public function setSelected(value:Boolean):void
		{
			_isShowName = value;
			if(value)
			{
				addSelectEffect();
			}
			else
			{
				removeSelectEffect();
			}
			UtilMouse.cancelMouseStyle();
		}
		
		public override function addSelectEffect():void
		{
			if (!_selectEffect)
			{
				_selectEffect = addPermanentBottomEffect("Selected_02:1");
			}
		}
		
		override public function get totalTime():int
		{
			if(_trapConfigData && _trapConfigData.trigger_type == TrapCfgData.TRIGGER_TYPE_READING)
			{
				return _trapConfigData.trigger_param;
			}
			else
			{
				return 0;
			}
		}
		
		public override function get selectable():Boolean
		{
			return _trapConfigData && _trapConfigData.unselectable == 0;
		}
		
		public override function isMouseOn():Boolean
		{
			if (selectable)
			{
				return super.isMouseOn();
			}
			return false;
		}
		
		protected override function get isShowShadow():Boolean
		{
			if (_trapConfigData)
			{
				return _trapConfigData.hide_shadow <= 0;
			}
			return false;
		}
		
		public function work():void
		{
			if (_currentActionId != ActionTypes.DIE)
			{
				_endFrame = 0;
				if (_entityModel && _entityModel.available)
				{
					_currentFrame = _startFrame = _entityModel.deadStart - 1;
					_endFrame = _entityModel.deadEnd;
					_frameRate = _entityModel.deadFrameRate;
					_frameStartTime = _frameRate * FRAME_TIME;
				}
				_currentActionId = ActionTypes.DIE;
			}
			_actionRepeat = false;
		}
		
		override public function setOver(value:Boolean):void
		{
			if(isMine)
			{
				if(value)
				{
					if(!PanelMediator.instance.isMouseOnPanel && !MainUiMediator.getInstance().isMouseOn)
					{
						UtilMouse.setMouseStyle(UtilMouse.WAKUANG);
					}	
				}
				else
				{
					UtilMouse.cancelMouseStyle();
				}
			}
			super.setOver(value);
		}
		
		public override function get tileDistToReach():int
		{
			return AutoJobManager.TO_TRAP_TILE_DIST;
		}
		
		public override function destory():void
		{
			super.destory();
		}
	}
}