package com.view.newMir
{
    import com.model.business.gameService.serverMessageManager.ServerMessagesManager;
    import com.model.consts.StringConst;
    import com.view.createRole.ICreateRole;
    import com.view.gameLoader.IGameLoader;
    import com.view.gameWindow.IGameWindow;
    import com.view.gameWindow.util.JsUtils;
    import com.view.newMir.prompt.SimplePromptPanel;
    import com.view.selectRole.ISelectRole;

    import flash.display.DisplayObject;
    import flash.events.Event;

    public class NewMirMediator
	{
		private static var _instance:NewMirMediator;
		
		private var _gameLoader:IGameLoader;
		private var _newMir:NewMir;
		private var _gameWindow:IGameWindow;
		private var _createRole:ICreateRole;
		private var _selectRole:ISelectRole;
		
		private var _width:int;
		private var _height:int;

		public var loadGwIndex:int = -1;
		public var loadSrIndex:int = -1;
		public var loadCrIndex:int = -1;
        private var _nameExistPanel:SimplePromptPanel;//名字已经存在
		public static function getInstance():NewMirMediator
		{
			if (!_instance)
			{
				_instance = new NewMirMediator(new PrivateClass());
			}
			return _instance;
		}
		
		public function NewMirMediator(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error();
			}
		}
		
		public function init(newMir:NewMir):void
		{
			_newMir = newMir;
			_newMir.addEventListener(Event.ENTER_FRAME, enterframeHandle, false, 0, true);
		}
		
		private function enterframeHandle(event:Event):void
		{
			ServerMessagesManager.getInstance().checkMsgQueue();
		}
		
		public function initGameWindow():void
		{
			if(loadGwIndex == -1 && !_gameWindow)
			{
				var gameWindowModuleLoader:GameWindowLoader = new GameWindowLoader();
				gameWindowModuleLoader.initData();
				loadGwIndex = showLoading(StringConst.LOADING_TIP_0001,false);
			}
		}
		
		public function showLoading(text:String,visible:Boolean = true):int
		{
			return _gameLoader.showLoading(text,visible);
		}
		
		public function setLoadVisible(index:int,visible:Boolean):void
		{
			_gameLoader.setLoadVisible(index,visible);
		}
		
		public function setLoading(index:int,progress:Number):void
		{
			_gameLoader.setLoading(index,progress);
		}
		
		public function hideLoading(index:int):void
		{
			_gameLoader.hideLoading(index);
		}
		/**移除gameLoader中加载NewMir.swf的加载进度界面*/
		public function hideLoadingInGameLoad():void
		{
			_gameLoader.hideLoading(_gameLoader.loadIndex);
		}
		
		public function set gameLoader(value:IGameLoader):void
		{
			_gameLoader = value;
		}

		public function set gameWindow(gameWindow:IGameWindow):void
		{
			_gameWindow = gameWindow;
			_newMir.addChild(_gameWindow as DisplayObject);
			_gameWindow.resize(_width, _height);
		}
		
		public function get gameWindow():IGameWindow
		{
			return _gameWindow;
		}
		
		public function get iNewMir():INewMir
		{
			return _newMir;
		}
		
		public function dealCreateRole():void
		{
			if(!createRole)
			{
				initCreateRole();
			}
			else
			{
				showCreateRole();
				refreshCreateRole();
			}
			hideSelectRole();
		}
		
		public function initCreateRole():void
		{
			if(!createRole)
			{
				var createRoleLoader:CreateRoleLoader = new CreateRoleLoader();
				createRoleLoader.initData();
				loadCrIndex = showLoading(StringConst.LOADING_TIP_0001);
				hideLoadingInGameLoad();
			}
		}
		
		public function get createRole():ICreateRole
		{
			return _createRole;
		}
		
		public function set createRole(value:ICreateRole):void
		{
			_createRole = value;
			_createRole.newMir = _newMir;
		}
		
		public function showCreateRole():void
		{
			if(!_createRole) return;
			_newMir.addChild(_createRole as DisplayObject);
			_createRole.resize(_width,_height);
		}
		
		public function refreshCreateRole():void
		{
			if(!_createRole) return;
			_createRole.refreshData();
		}
		
		public function hideCreateRole():void
		{
			if(_createRole)
			{
				_createRole.destroy();
				_createRole = null;
			}
		}
		
		public function dealSelectRole():void
		{
			if(selectRole)
			{
				showSelectRole();
				refreshSelectRole();
			}
			else
			{
				initSelectRole();
			}
			hideCreateRole();
		}
		
		public function initSelectRole():void
		{
			if(!selectRole)
			{
				var selectRoleLoader:SelectRoleLoader = new SelectRoleLoader();
				selectRoleLoader.initData();
				loadSrIndex = showLoading(StringConst.LOADING_TIP_0001);
				hideLoadingInGameLoad();
			}
		}
		
		public function get selectRole():ISelectRole
		{
			return _selectRole;
		}
		
		public function set selectRole(value:ISelectRole):void
		{
			_selectRole = value;
			_selectRole.newMir = _newMir;
		}
		
		public function showSelectRole():void
		{
			if(!_selectRole) return;
			_newMir.addChild(_selectRole as DisplayObject);
			_selectRole.resize(_width,_height);
		}
		
		public function refreshSelectRole():void
		{
			if(!_selectRole) return;
			_selectRole.refreshData();
		}
		
		public function hideSelectRole():void
		{
			if(_selectRole)
			{
				_selectRole.destroy();
				_selectRole = null;
			}
		}
		
		public function showOffLine(show:Boolean):void
		{
			if(show)
			{
				var prompt:SimplePromptPanel = new SimplePromptPanel();
				prompt.init(_newMir.stage);
                prompt.clickHandler = function ():void
                {
                    JsUtils.refreshGameWindow();
                };
			}
			else
			{
				
			}
		}

		public function showNameExist():void
		{
            if (_nameExistPanel)
            {
                _nameExistPanel.destroy();
                _nameExistPanel = null;
            }
            _nameExistPanel = new SimplePromptPanel();
            _nameExistPanel.init(_newMir.stage);
		}
		public function hideCreateRoleSelectRole():void
		{
			var mediator:NewMirMediator = NewMirMediator.getInstance();
			if (mediator)
			{
				mediator.setLoadVisible(mediator.loadGwIndex, true);
				mediator.hideCreateRole();
				mediator.hideSelectRole();
                if (_nameExistPanel)
                {
                    _nameExistPanel.destroy();
                    _nameExistPanel = null;
                }
			}
		}
		public function resize(newWidth:int, newHeight:int):void
		{
			_width = newWidth;
			_height = newHeight;
			if(_gameWindow)
				_gameWindow.resize(newWidth, newHeight);
			if(_createRole)
				_createRole.resize(newWidth, newHeight);
			if(_selectRole)
				_selectRole.resize(newWidth, newHeight);
		}

		public function get width():int
		{
			return _width;
		}

		public function get height():int
		{
			return _height;
		}
	}
}

class PrivateClass{}