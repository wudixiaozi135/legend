package com.view.gameWindow.scene.entity.entityItem
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.NpcCfgData;
    import com.model.configData.cfgdata.TaskCfgData;
    import com.model.consts.EffectConst;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subuis.tasktrace.TaskTraceItemInfo;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.task.TaskDataManager;
    import com.view.gameWindow.panel.panels.task.constants.TaskStates;
    import com.view.gameWindow.panel.panels.task.npcfunc.NpcFuncItem;
    import com.view.gameWindow.panel.panels.task.npcfunc.NpcFuncs;
    import com.view.gameWindow.scene.entity.constants.Direction;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
    import com.view.gameWindow.scene.entity.entityItem.interf.INpcStatic;
    import com.view.gameWindow.scene.entity.model.EntityModelsManager;
    import com.view.gameWindow.scene.entity.model.base.EntityModel;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.UIEffectLoader;
    import com.view.gameWindow.util.UtilMouse;
    import com.view.gameWindow.util.cell.IconCellEx;
    
    import flash.filters.GlowFilter;
    import flash.text.TextField;

    public class NpcStatic extends Unit implements INpcStatic
	{
		protected var _config:NpcCfgData;
		private var _typeTaskEffect:String = "";
		private var _effectLoader:UIEffectLoader;

		private var _isTaskEffectChange:Boolean;

		private var _dutyFlag:IconCellEx;
		private var _dutyTitle:TextField;
        ////0 不显示 1显示名字 2称号  3全部显示
        private var _showMapType:int;
		private const CHUANSONG:String = 'chuansong';
		
		public function NpcStatic(cfgData:NpcCfgData)
		{
			_config = cfgData;
            _showMapType = _config.ismapShowName;
			_entityName = _config.name;

            if (_showMapType == 1 || _showMapType == 3)
            {
                _isShowName = true;
            } else
            {
                _isShowName = false;
            }

			tileX = _config.x;
			tileY = _config.y;
			_entityId = _config.id;
		}
		
		public override function show():void
		{
			super.show();
			alpha = 1;
			changeMode();
			idle();
			showTaskEffect();
            if (_config)
            {//0 不显示 1显示名字 2称号  3全部显示
                if (_showMapType == 0)
                {
                    hideDutyTitle();
                } else if (_showMapType == 1)
                {
                    hideDutyTitle();
                } else if (_showMapType == 2)
                {
                    showDutyTitle();
                } else if (_showMapType == 3)
                {
                    showDutyTitle();
                }
                showDutyFlag();
            }
			chatBubble();
		}
		
		public function changeMode():void
		{
			var oldEntityModel:EntityModel = _entityModel;
			_entityModel = EntityModelsManager.getInstance().getAndUseEntityModel(ResourcePathConstants.ENTITY_RES_NPC_LOAD + _config.body+"/", "", "", "", "", "", "", "", EntityModel.N_DIRECTION_1);
			_direction = Direction.DOWN;
			EntityModelsManager.getInstance().unUseModel(oldEntityModel);
		}

		public function refreshDutyFlagPos():void
		{
			if(_dutyFlag && _dutyFlag.visible)
			{
				if(_entityModel)
				{
                    if (_showMapType == 0)
                    {
                        _dutyFlag.y = -_entityModel.modelHeight - 3;//35
                    } else if (_showMapType == 1)
                    {
                        _dutyFlag.y = -_entityModel.modelHeight - 23;//55
                    } else if (_showMapType == 2)
                    {
                        if (_isShowName == false)
                        {
                            _dutyFlag.y = -_entityModel.modelHeight - 23;//55
                        }
                    } else if (_showMapType == 3)
                    {
                        _dutyFlag.y = -_entityModel.modelHeight - 38;//70
                    }
				}
			}
			
			if(_dutyTitle && _dutyTitle.visible)
			{
				if(_entityModel)
				{
					_dutyTitle.x = int(-_dutyTitle.width/2);
                    if (_showMapType == 0)
                    {
                        _dutyTitle.y = -_entityModel.modelHeight - 13;
                    } else if (_showMapType == 1)
                    {
//                        _dutyTitle.y = -_entityModel.modelHeight - 13;
                    } else if (_showMapType == 2)
                    {
                        if (_isShowName == false)
                        {
                            _dutyTitle.y = -_entityModel.modelHeight;
                        }
                    } else if (_showMapType == 3)
                    {
                        _dutyTitle.y = -_entityModel.modelHeight - 13;
                    }
				}
			}
		}

        public function showDutyTitle():void
		{
			if(!_dutyTitle)
			{
				_dutyTitle = new TextField();
				_dutyTitle.mouseEnabled = false;
				_dutyTitle.filters = [new GlowFilter(0x0,1,2,2,10)];
				addChild(_dutyTitle);
			}
			
			if(_config.title)
			{
				_dutyTitle.htmlText = HtmlUtils.createHtmlStr(0x00ff00,_config.title);
				_dutyTitle.width = _dutyTitle.textWidth+3;
				_dutyTitle.height = _dutyTitle.textHeight+3;
				_dutyTitle.visible = true;
			}
			else
			{
				hideDutyTitle();
			}
		}
		
		public function hideDutyTitle():void
		{
			if(_dutyTitle)
			{
				_dutyTitle.visible = false;
			}
		}
		
		public function showDutyFlag():void
		{
			if(!_dutyFlag)
			{
				_dutyFlag = new IconCellEx(this,-100/2,-160,100,28);   //76  60
				_dutyFlag.mouseChildren = false;
				_dutyFlag.mouseEnabled = false;
			}
			
			if(_config.func_url)
			{
				if(_config.func_url == CHUANSONG)
				{
					_dutyFlag.y = -70; 
					_dutyFlag.x = -53;
					_dutyFlag.loadEffect2(ResourcePathConstants.IMAGE_NPC_DUTY_FOLDER_LOAD+_config.func_url+ResourcePathConstants.POSTFIX_SWF); 
				}
				else
				{
					_dutyFlag.url = ResourcePathConstants.IMAGE_NPC_DUTY_FOLDER_LOAD+_config.func_url+ResourcePathConstants.POSTFIX_PNG;
				}
				
			}
			else
			{
				hideDutyFlag();
			}
			
			_dutyFlag.visible = true;
			
		}
		
		public function hideDutyFlag():void
		{
			if(_dutyFlag)
			{
				_dutyFlag.url = null;
				_dutyFlag.visible = false;
			}
		}
		
		public function showTaskEffect():void
		{
			hideTaskEffect();
			var npcFuncs:NpcFuncs = new NpcFuncs();
			var allTasks:Vector.<NpcFuncItem> = npcFuncs.getAllTasks(_entityId),npcFuncItem:NpcFuncItem;
			if(!allTasks.length)
			{
				return;
			}
			var taskList:Vector.<TaskTraceItemInfo> = TaskDataManager.instance.taskList,tasktraceItemInfo:TaskTraceItemInfo;//玩家在做的所有任务
			var typeTaskEffect:String = "",canAccept:Boolean,canSubmit:Boolean,isNone:Boolean;
			for each(npcFuncItem in allTasks)
			{
				for each (tasktraceItemInfo in taskList)
				{
					if(npcFuncItem.taskId == tasktraceItemInfo.taskId)
					{
						var state:int = TaskDataManager.instance.getTaskState(tasktraceItemInfo.taskId);
						switch(state)
						{
							case TaskStates.TS_UNKNOWN:
								break;
							case TaskStates.TS_NOT_RECEIVABLE:
								break;
							case TaskStates.TS_RECEIVABLE:
								var taskCfgData:TaskCfgData = ConfigDataManager.instance.taskCfgData(tasktraceItemInfo.taskId);
								var lv:int = RoleDataManager.instance.lv;
								typeTaskEffect = lv >= taskCfgData.level ? EffectConst.RES_NPCTASK_GOLDEXCLAMATIONMARK : EffectConst.RES_NPCTASK_GRAYEXCLAMATIONMARK;
								break;
							case TaskStates.TS_DOING:
								typeTaskEffect = EffectConst.RES_NPCTASK_GRAYQUESTIONMARK;
								break;
							case TaskStates.TS_CAN_SUBMIT:
								typeTaskEffect = EffectConst.RES_NPCTASK_GOLDQUESTIONMARK;
								break;
							case TaskStates.TS_DONE:
								break;
							default:
								break;
						}
						break;
					}
				}
			}
			if(typeTaskEffect && !_effectLoader || _typeTaskEffect != typeTaskEffect)
			{
				_typeTaskEffect = typeTaskEffect;
				_isTaskEffectChange = true;
			}
		}
		
		override protected function getBubbledString():String
		{
			return _config.bubble_dialog;
		}
		
		override public function updateFrame(timeDiff:int):void
		{
			super.updateFrame(timeDiff);
			updateTaskEffect();
			refreshDutyFlagPos();
			refreshNameTxtPos();
		}
		
		protected override function get isShowShadow():Boolean
		{
			return _config && _config.hide_shadow <= 0;
		}
		
		private function updateTaskEffect():void
		{
			if(!isShow || !viewBitmapExist || !_isTaskEffectChange)
			{
				return;
			}
			if(_entityModel && _entityModel.available && _typeTaskEffect)
			{
				_isTaskEffectChange = false;
				_effectLoader = new UIEffectLoader(this,0,-_entityModel.modelHeight-5,1,1,_typeTaskEffect);
			}
		}
		
		override public function hide():void
		{
			hideDutyTitle();
			hideDutyFlag();
			hideTaskEffect();
			super.hide();
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
				_selectEffect = addPermanentBottomEffect("Selected_01:1");
			}
		}
		
		private function hideTaskEffect():void
		{
			if(_effectLoader)
			{
				_effectLoader.destroy();
				_effectLoader = null;
			}
			_typeTaskEffect = "";
		}
		
		public override function get entityType():int
		{
			return EntityTypes.ET_NPC;
		}
		
		override public function setOver(value:Boolean):void
		{
			if(value)
			{
				if(!PanelMediator.instance.isMouseOnPanel && !MainUiMediator.getInstance().isMouseOn)
				{
//					UtilMouse.setMouseStyle(UtilMouse.TALK);
				}
			}
			else
			{
				UtilMouse.cancelMouseStyle();
			}
			super.setOver(value);
		}
		
		public override function get tileDistToReach():int
		{
			return AutoJobManager.TO_NPC_TILE_DIST;
		}
		
		public override function destory():void
		{
			hideDutyFlag();
			super.destory();
		}
	}
}