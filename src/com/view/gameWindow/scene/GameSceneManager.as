package com.view.gameWindow.scene
{
    import com.event.GameEvent;
    import com.greensock.TweenLite;
    import com.model.business.flashVars.FlashVarsManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.MapCfgData;
    import com.model.consts.StringConst;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
    import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarDataManager;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.map.IMapPanel;
    import com.view.gameWindow.panel.panels.onhook.AutoDataManager;
    import com.view.gameWindow.panel.panels.onhook.AutoSystem;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.task.TaskDataManager;
    import com.view.gameWindow.scene.darkmask.DarkMask;
    import com.view.gameWindow.scene.effect.SceneEffectManager;
    import com.view.gameWindow.scene.entity.EntityLayerManager;
    import com.view.gameWindow.scene.entity.constants.Direction;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    import com.view.gameWindow.scene.entity.constants.RunTypes;
    import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
    import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
    import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
    import com.view.gameWindow.scene.map.SceneMapManager;
    import com.view.gameWindow.scene.map.path.MapPathManager;
    import com.view.gameWindow.scene.map.utils.MapTileUtils;
    import com.view.gameWindow.scene.shake.interf.IShaker;
    import com.view.gameWindow.scene.stateAlert.HorizontalAlert;
    import com.view.gameWindow.scene.stateAlert.StateAlertManager;
    import com.view.gameWindow.scene.stateAlert.TaskAlert;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.UtilMouse;
    
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.external.ExternalInterface;
    import flash.geom.Point;
    import flash.system.Security;
    import flash.ui.Mouse;
    import flash.utils.getTimer;

    public class GameSceneManager
	{
		private static var _instance:GameSceneManager;
		
		private var _container:GameScene;
		private var _darkMask:DarkMask;
		private var _mapManager:SceneMapManager;
		private var _entityManager:EntityLayerManager;
		private var _sceneEffectManager:SceneEffectManager;
		private var _stateAlertManager:StateAlertManager;
		private var _taskAlert:TaskAlert;
		private var _horizontalAlert:HorizontalAlert;
		
		private var _width:int;
		private var _height:int;
		
		public var isShiftKeyDown:Boolean;
		public var isCtrlKeyDown:Boolean;
		public var barKeyDowns:Vector.<int>;
		public var lastPressKeyTime:int;
		
		private var _mouseDown:Boolean;
		private var _runType:int;

		private var _mouseOffsetX:int;
		private var _mouseOffsetY:int;
		
		private var _lastMouseMoveTime:int;
		private var _lastClickTime:int;
		
		private var _cameraMoveData:Point = new Point();
		private var _cameraAnimate:TweenLite = null;
		private var _isCameraAnchor:Boolean = false;
		private var _cameraPos:Point = new Point;
		
		private var _oldPixelToTile:Point;
		private var _oldEntity:IEntity;
		
		public static function getInstance():GameSceneManager
		{
			if (!_instance)
			{
				_instance = new GameSceneManager(new PrivateClass());
			}
			return _instance;
		}
		
		public function GameSceneManager(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error();
			}
			//
			barKeyDowns = new Vector.<int>();
		}
		
		public function init(container:GameScene, darkMask:DarkMask):void
		{
			_container = container;
			_darkMask = darkMask;
			_mapManager = SceneMapManager.getInstance();
			_entityManager = EntityLayerManager.getInstance();
			_sceneEffectManager = SceneEffectManager.instance;
			_stateAlertManager = StateAlertManager.getInstance();
			_taskAlert = TaskAlert.getInstance();
			_horizontalAlert = HorizontalAlert.getInstance();
			StateAlertManager.loadImage();
			_container.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandle);
			_container.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandle);
			_container.addEventListener(Event.ENTER_FRAME,onFrame);
			
			Security.allowDomain("*");
			ExternalInterface.addCallback("rightBtnHandle", rightBtnHandle);
		}
		
		private function rightBtnHandle(type:int, xPos:int, yPos:int, shiftKey:int):void
		{
			if (type == 2)
			{
				mouseKeyDown(RunTypes.RT_FORCE_RUN, shiftKey > 0);
			}
			else if (type == 3)
			{
				_mouseDown = false;
				_runType = RunTypes.RT_NORMAL;
			}
		}

		private function onRightMouseHandle(ev:GameEvent):void
		{
			if (ev.param.type == 2)
			{
				mouseKeyDown(RunTypes.RT_FORCE_RUN, ev.param.shiftKey > 0);
			}
			else if (ev.param.type == 3)
			{
				_mouseDown = false;
				_runType = RunTypes.RT_NORMAL;
			}
		}
		
		public function get mouseDown():Boolean
		{
			return _mouseDown;
		}
		
		public function get gameScene():IShaker
		{
			return _container;
		}

		public function resumeCamera():void
		{
			_isCameraAnchor = false;
		}
		
		public function cameraMove(x:Number,y:Number,time:int = 0,isCameraAnchor:Boolean = false):void
		{
			var mapWidth:int = _mapManager.mapRealWidth;
			var mapHeight:int = _mapManager.mapRealHeight;
			
			x = x - _width/2;
			y = y - _height/2;
			
			if(x + _width > mapWidth)
			{
				x = mapWidth - _width;
			}
			
			if(y + _height > mapHeight)
			{
				y = mapHeight - _height;
			}
			
			if(x < 0)
			{
				x = 0;
			}
			
			if(y < 0)
			{
				y = 0;
			}
			
			if(_cameraAnimate)
			{
				camerAnimateComplete();
			}
			
			if(time > 0)
			{
				_cameraMoveData.x = -_container.x;
				_cameraMoveData.y = -_container.y;
				_cameraAnimate = TweenLite.to(_cameraMoveData,
												time,
												{x:x,y:y,
												onUpdate:cameraMoveBase,onUpdateParams:[_cameraMoveData],
												onComplete:camerAnimateComplete});
			}
			else
			{
				_cameraMoveData.x = x;
				_cameraMoveData.y = y;
				cameraMoveBase(_cameraMoveData);
			}
			
			_isCameraAnchor = isCameraAnchor;
		}
		
		/**
		 * 移动镜头中（电影）
		 */
		public function get isCameraAnchor():Boolean
		{
			return _isCameraAnchor;
		}
		
		private function camerAnimateComplete():void
		{
			_cameraAnimate.kill();
			_cameraAnimate = null;
		}
		
		private function cameraMoveBase(pos:Point):void
		{
			_container.x = -pos.x;
			_container.y = -pos.y;
			
			_mapManager.showMap(pos.x, pos.y);
		}
		
		public function get cameraCenterPos():Point
		{
			_cameraPos.x = -_container.x + _width/2;
			_cameraPos.y = -_container.y + _height/2;
			
			return _cameraPos;
		}
		
		private function mouseDownHandle(event:MouseEvent):void
		{
			var runType:int = RunTypes.RT_NORMAL;
			if (FlashVarsManager.getInstance().isMini != 0)
			{
				runType = RunTypes.RT_FORCE_WALK;
			}
			mouseKeyDown(runType, event.shiftKey);
		}

		private function mouseKeyDown(runType:int, shiftKey:Boolean):void
		{
			if (!_mapManager.ready)
			{
				return;
			}
			
			if(checkAutoSystemMouseDown)
			{
				return;
			}
			
			var isBePushOil:Boolean = ActivityDataManager.instance.seaFeastDataManager.isBePusheOil;
			if(isBePushOil)
			{
				return;
			}
			
			var stallStatue:int = RoleDataManager.instance.stallStatue;
			if (stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			
			/*if (AutoJobManager.getInstance().checkRigor())
			{
				AutoJobManager.getInstance().reset();
				return;
			}*/
			
			var firstPlayer:IFirstPlayer = _entityManager.firstPlayer;
			var entity:IEntity = _entityManager.getEntityUnderMouse();
			if (entity)
			{
				AutoJobManager.getInstance().selectEntity = entity;
				var isSeaFeastInteractive:Boolean = ActivityDataManager.instance.seaFeastDataManager.isSeaFeastInteractive;
				if(!isSeaFeastInteractive)
				{
					var isCanUseSkillTarget:Boolean = AutoJobManager.getInstance().isCanUseSkillTarget(entity);
					if(isCanUseSkillTarget)
					{
						if(entity.entityType == EntityTypes.ET_PLAYER)
						{
							var isStallStatue:Boolean = AutoJobManager.getInstance().isStallStatue(entity);
							if(isStallStatue)
							{
								AutoJobManager.getInstance().runToEntity(entity);
								return;
							}
							var isWithoutShift:Boolean = AutoDataManager.instance.isWithoutShift;
							if(isWithoutShift)
							{
								AutoSystem.instance.startIndepentAttack(entity.entityType,entity.entityId);
							}
						}
						else
						{
							AutoSystem.instance.startIndepentAttack(entity.entityType,entity.entityId);
						}
					}
					else
					{
						AutoJobManager.getInstance().runToEntity(entity);
					}
				}
			}
			else if(isTileInteractive())
			{
				var pixelToTile:Point = MapTileUtils.pixelToTile(_container.mouseX,_container.mouseY);
				AutoJobManager.getInstance().runToTile(pixelToTile.x,pixelToTile.y, 0);
			}
			else
			{
				if(!AutoJobManager.getInstance().isAutoPath())
				{
					_mouseDown = true;
					_runType = runType;
					if(shiftKey)
					{
						isShiftKeyDown = true;
						return;
					}
				}
				if (firstPlayer && firstPlayer.pixelX == firstPlayer.targetPixelX && firstPlayer.pixelY == firstPlayer.targetPixelY)
				{
					AutoJobManager.getInstance().directMove(_container.mouseX, _container.mouseY, _runType);		
					_mouseOffsetX = _container.mouseX - firstPlayer.pixelX;
					_mouseOffsetY = _container.mouseY - firstPlayer.pixelY;
				}
				if(AutoJobManager.getInstance().isAutoPath())
				{
					var nowTime:int = getTimer();
					if(nowTime - _lastClickTime >= 10000)
					{
						_lastClickTime = nowTime;
						RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.FindPath_001);
					}
					else
					{
						AutoJobManager.getInstance().reset(true);
						AutoSystem.instance.stopAuto();
						_lastClickTime = 0;
						AutoJobManager.getInstance().directMove(_container.mouseX, _container.mouseY, _runType);		
						_mouseDown = true;
						_runType = runType;
						_mouseOffsetX = _container.mouseX - firstPlayer.pixelX;
						_mouseOffsetY = _container.mouseY - firstPlayer.pixelY;
					}
				}
			}
			clearMoveState();
		}
		
		public function clearMoveState():void
		{
			AutoJobManager.getInstance().resetOverLapMoveLct();
			TaskDataManager.instance.setAutoTask(false,"GameSceneManager::clearMoveState");
			var mapPanel:IMapPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_MAP) as IMapPanel;
			if(mapPanel)
			{
				mapPanel.removePathSigns();
			}
		}
		
		private function get checkAutoSystemMouseDown():int
		{
			var code:int = AutoSystem.instance.onMouseDown();
			if(code == 1)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.FindPath_001);
			}
			else if(code == 2)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.MAP_CLICK_STOP_FIGHT);
			}
			
			return code;
		}
		/**格子是否可交互*/
		public function isTileInteractive():Boolean
		{
			var pixelToTile:Point = MapTileUtils.pixelToTile(_container.mouseX,_container.mouseY);
			var isMine:Boolean = MapPathManager.getInstance().isMine(pixelToTile.x,pixelToTile.y);
			return isMine;
		}
		
		private function mouseUpHandle(event:MouseEvent):void
		{
			_mouseDown = false;
		}
		
		protected function onFrame(event:Event):void
		{
			var nowMouseMoveTime:int = getTimer();
			if(nowMouseMoveTime - _lastMouseMoveTime >= 50)
			{
				_lastMouseMoveTime = nowMouseMoveTime;	
				var entity:IEntity = EntityLayerManager.getInstance().getEntityUnderMouse();
				if(entity)
				{
					if(entity != _oldEntity)
					{
						var overEntity:IEntity = AutoJobManager.getInstance().overEntity;
						if(entity == overEntity)
						{
							return;
						}
						AutoJobManager.getInstance().overEntity = entity;
					}
				}
				else
				{
					AutoJobManager.getInstance().overEntity = null;
				}
				_oldEntity = EntityLayerManager.getInstance().getEntityUnderMouse();
				refreshMouseCursor();
			}
		}
		
		private function refreshMouseCursor():void
		{
			if(MapTileUtils.pixelToTile(_container.mouseX,_container.mouseY) != _oldPixelToTile)
			{
				if(isTileInteractive() && AutoJobManager.getInstance().overEntity == null)
				{
					if(!PanelMediator.instance.isMouseOnPanel && !MainUiMediator.getInstance().isMouseOn)
					{
						UtilMouse.setMouseStyle(UtilMouse.WAKUANG);
					}
				}
				else
				{
					if(Mouse.cursor == UtilMouse.WAKUANG)
					{
						UtilMouse.cancelMouseStyle(); 
					}
				}
			}
			_oldPixelToTile = MapTileUtils.pixelToTile(_container.mouseX,_container.mouseY);
		}		
		
		public function switchMap(mapId:int, xTile:int, yTile:int):void
		{
			if(isCameraAnchor)
			{
				return;
			}
			var mapCenterPos:Point = MapTileUtils.tileToPixel(xTile, yTile);
			var mapConfig:MapCfgData = ConfigDataManager.instance.mapCfgData(mapId);
			var topLeftPos:Point = new Point(mapCenterPos.x - _width / 2, mapCenterPos.y - _height / 2);
			if (topLeftPos.x < 0)
			{
				topLeftPos.x = 0;
			}
			if (topLeftPos.y < 0)
			{
				topLeftPos.y = 0;
			}
			var mapWidth:int = int(mapConfig.width / MapTileUtils.TILE_WIDTH) * MapTileUtils.TILE_WIDTH;
			var mapHeight:int = int(mapConfig.height / MapTileUtils.TILE_HEIGHT) * MapTileUtils.TILE_HEIGHT;
			if (topLeftPos.x + _width > mapWidth)
			{
				topLeftPos.x = mapWidth - _width;
			}
			if (topLeftPos.y + _height > mapHeight)
			{
				topLeftPos.y = mapHeight - _height;
			}
			_entityManager.switchMap(mapId);
			_mapManager.switchMap(mapId, topLeftPos.x , topLeftPos.y);
			MapPathManager.getInstance().loadMapPathData(mapId);
			_sceneEffectManager.onEnterMap();
			_stateAlertManager.clear();
			_lastClickTime -= 10000;
		}
		
		public function resize(newWidth:int, newHeight:int):void
		{
			_width = newWidth;
			_height = newHeight;
			
			_mapManager.resize(_width, _height);
		}
		
		public function resetScenePos():void
		{
			if(isCameraAnchor)
			{
				return;
			}
			var firstPlayer:IFirstPlayer = _entityManager.firstPlayer;
			if (!firstPlayer)
			{
				return;
			}
			
			cameraMove(int(firstPlayer.pixelX),int(firstPlayer.pixelY));
			if (_darkMask)
			{
				_darkMask.resetCenterPos(firstPlayer.pixelX + _container.x, firstPlayer.pixelY + _container.y);
			}
		}
		//从update中分离出来是因为 GameWindow中firstplayer位置的更新放在了后面
		public function checkOpertaion():void
		{
			if(!_mapManager.ready)
			{
				return;
			}
			
			var firstPlayer:IFirstPlayer = _entityManager.firstPlayer;
			var key:int = barKeyDowns.length ? barKeyDowns[barKeyDowns.length-1] : -1;
			var isRigor:Boolean = AutoJobManager.getInstance().checkRigor();
			var isGetTargetTile:Boolean = firstPlayer && firstPlayer.tileX == firstPlayer.targetTileX && firstPlayer.tileY == firstPlayer.targetTileY && !isRigor;
			
			if(_mouseDown && isShiftKeyDown && isGetTargetTile)
			{
				var direction:int = Direction.getDirectionByPixel(firstPlayer.pixelX, firstPlayer.pixelY, _container.mouseX, _container.mouseY, Direction.INVALID_DIRECTION);
				
				AutoSystem.instance.stopAuto();
				AutoJobManager.getInstance().reset(true);
				clearMoveState();
				AutoJobManager.getInstance().useSkillByShift(direction);
			}
			else if(key != -1)
			{
				var nowTime:int = getTimer();
				if(nowTime - lastPressKeyTime > 333)
				{
					lastPressKeyTime = nowTime;
					
					if(ActionBarDataManager.instance.isSkillKey(key))
					{
						var isAutoAttack:Boolean = AutoSystem.instance.isAutoAttack();
						var isPickUp:Boolean = AutoSystem.instance.isAutoPickUp();
						if(!isAutoAttack && !isPickUp)
						{
							AutoSystem.instance.stopAuto();
							AutoJobManager.getInstance().reset(true);
							clearMoveState();
						}
					}
					ActionBarDataManager.instance.pressKey(key);
				}
			}
			else if(_mouseDown)
			{
				_mouseOffsetX = _container.mouseX - firstPlayer.pixelX;
				_mouseOffsetY = _container.mouseY - firstPlayer.pixelY;
				if(isGetTargetTile)
				{
					AutoJobManager.getInstance().directMove(firstPlayer.pixelX + _mouseOffsetX, firstPlayer.pixelY + _mouseOffsetY, _runType, false);
				}
			}
		}
		
		public function update(timeDiff:int):void
		{
			if (_mapManager.ready)
			{
				_mapManager.update();
				_entityManager.update(timeDiff);
				_sceneEffectManager.updateView(timeDiff);
				_stateAlertManager.update(timeDiff);
				_taskAlert.enterframe();
				_horizontalAlert.enterframe();
			}
		}
		
		public function get stage():Stage
		{
			return _container.stage;
		}
		
		public function get mouseTile():Point
		{
			var pixelToTile:Point = MapTileUtils.pixelToTile(_container.mouseX,_container.mouseY);
			return pixelToTile;
		}

		public function get width():int
		{
			return _width;
		}

		public function get height():int
		{
			return _height;
		}
		
		public function resetBarKeyDowns():void
		{
			_mouseDown = false;
			_runType = RunTypes.RT_NORMAL;
			isCtrlKeyDown = false;
			isShiftKeyDown = false;
			barKeyDowns.length = 0;
		}
	}
}

class PrivateClass
{
}