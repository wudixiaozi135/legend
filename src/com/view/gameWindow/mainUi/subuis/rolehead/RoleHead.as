package com.view.gameWindow.mainUi.subuis.rolehead
{
    import com.event.GameDispatcher;
    import com.event.GameEventConst;
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.MapCfgData;
    import com.model.consts.ConstPkMode;
    import com.model.consts.MapPKMode;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.mainUi.MainUi;
    import com.view.gameWindow.mainUi.subclass.McRoleHead;
    import com.view.gameWindow.mainUi.subclass._McRoleHead;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.buff.BuffDataManager;
    import com.view.gameWindow.panel.panels.buff.BuffListView;
    import com.view.gameWindow.panel.panels.menus.others.MenuRoundBg;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.scene.entity.EntityLayerManager;
    import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
    import com.view.gameWindow.scene.map.SceneMapManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.NumPic;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class RoleHead extends MainUi implements IRoleHead,IObserver
	{
		private var _skinRoleHead:McRoleHead;
		private var mcIcon:_McRoleHead;
		private var _mc:MovieClip;
		private var fightNum:String;
		
		private var isLoadRoleHead:Boolean = false;
		private var buff:BuffListView;
		
		private var _numPic:NumPic;

		private var _menuRoundBg:MenuRoundBg;
		
		public function RoleHead()
		{
			super();
			RoleDataManager.instance.attach(this);
			PkDataManager.instance.attach(this);
			BuffDataManager.instance.attach(this);
		}
		
		override public function initView():void
		{
			_skin = new McRoleHead();
			addChild(_skin);
			_skinRoleHead = _skin as McRoleHead;
			//
			mcIcon = new _McRoleHead();
			addChild(mcIcon);
			mcIcon.x = 37;
			mcIcon.y = 27;
			//
			_mc = new MovieClip();
			_mc.x = getFightNumPosition(RoleDataManager.instance.getRoleMaxAttack());
			_mc.y = 57;
			addChild(_mc);
			//
			buff = new BuffListView(24);
			buff.x = 114;
			buff.y = 86;
			addChild(buff);
			//
			mouseEnabled = false;
			_skin.mouseEnabled = false;
			_skin.txt_00.mouseEnabled = false;
			//
			//
			addEventListener(MouseEvent.CLICK,clickHandle);
			super.initView();
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(_skinRoleHead.btnCharge,function():void
			{
				_skinRoleHead.btnCharge.buttonMode = true;
			});
			rsrLoader.addCallBack(_skinRoleHead.btn_00,function():void
			{
				_skinRoleHead.btn_00.buttonMode = true;
			});
		}
		
		private function clickHandle(event:MouseEvent):void
		{
			if(event.target == _skinRoleHead.btnCharge)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0007);
			}
			else if(event.target == _skinRoleHead.btn_00)
			{
				var cfgDt:MapCfgData = ConfigDataManager.instance.mapCfgData(SceneMapManager.getInstance().mapId);
				if(cfgDt.pk_mode != MapPKMode.FREEDOM_PK)
				{
					PanelMediator.instance.closePanel(PanelConst.TYPE_BAGCELL_MENU);
					Alert.warning(StringConst.ROLE_HEAD_WARN_0001);
					return;
				}
                GameDispatcher.dispatchEvent(GameEventConst.PK_MODE_EVENT, event);
			}
		}
		
		public function updateBuff():void
		{
			var iself:IEntity = EntityLayerManager.getInstance().firstPlayer;
			if(iself)
			{
				buff.data = BuffDataManager.instance.getBuffList(iself.entityType,iself.entityId);
			}
		}
		
		public function update(proc:int = 0):void
		{
			if(proc == GameServiceConstants.SM_PLAYER_BUFF_LIST || proc == GameServiceConstants.SM_UNITS_BUFF_LIST)
			{
				updateBuff();
			}
			else
			{
				if(!isLoadRoleHead)
				{
					isLoadRoleHead = true;
					initRoleHead();
				}
				refreshText();
				refreshFightNum();
			}
		}
		
		public function refreshText():void
		{
			var _job:int = RoleDataManager.instance.job;
			var _level:int = RoleDataManager.instance.lv;
			_skinRoleHead.txt_00.htmlText = ConstPkMode.getStringByPkMode(PkDataManager.instance.pkMode);
			_skinRoleHead.txtName.text = RoleDataManager.instance.name;
			_skinRoleHead.txtLevel.text = (RoleDataManager.instance.reincarn?StringConst.ROLE_HEAD_0002.replace("X",String(RoleDataManager.instance.reincarn)):"") + _level+StringConst.ROLE_HEAD_0001;
		}
		
		private function refreshFightNum():void
		{
			if(!_numPic)
			{
				_numPic = new NumPic();
			}
			fightNum = RoleDataManager.instance.getRoleMaxAttack().toString();
			if(RoleDataManager.instance.getRoleMaxAttack() == RoleDataManager.instance.oldFightNum)
			{
				return;
			}
			_numPic.destory();
			_numPic.init("fight_",fightNum,_mc,function():void
			{
				_mc.x = getFightNumPosition(RoleDataManager.instance.getRoleMaxAttack());
			});
		}
		
		public function initRoleHead():void
		{
			var job:int = RoleDataManager.instance.job;
			var sex:int = RoleDataManager.instance.sex;
			mcIcon.roleHead.resUrl = String(job) + "_" + String(sex) + ".png";
			var rsrLoader:RsrLoader = new RsrLoader();
			rsrLoader.load(mcIcon,ResourcePathConstants.IMAGE_CREATEROLE_FOLDER_LOAD);
		}
		
		private function getFightNumPosition(num:int):int
		{
			if(num < 10)
			{
				return 230;
			}
			else if(num < 100)
			{
				return 222;
			}
			else if(num < 1000)
			{
				return 214;
			}
			else if(num < 10000)
			{
				return 206;
			}
			else if(num < 100000)
			{
				return 198;
			}
			else if(num < 1000000)
			{
				return 190;
			}
			else
			{
				return 182;
			}
		}
	}
}