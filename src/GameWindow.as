package
{
    import com.model.business.gameService.serverMessageManager.ServerMessagesManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataGameWindow;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.OnlineWelfareCfgData;
    import com.model.dataManager.LoginDataManager;
    import com.model.dataManager.TeleportDatamanager;
    import com.model.gameWindow.mem.MemEquipDataManager;
    import com.view.gameWindow.GameWindowKeyHandle;
    import com.view.gameWindow.IGameWindow;
    import com.view.gameWindow.common.UIEffectManager;
    import com.view.gameWindow.flyEffect.FlyEffectMediator;
    import com.view.gameWindow.mainUi.IMainUiMediator;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subuis.announcement.AnnouncementDataManager;
    import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.TeamHintDataManager;
    import com.view.gameWindow.mainUi.subuis.broadcast.SystemBroAdcast;
    import com.view.gameWindow.mainUi.subuis.chatframe.ChatDataManager;
    import com.view.gameWindow.mainUi.subuis.displaySetting.DisplaySettingManager;
    import com.view.gameWindow.mainUi.subuis.income.IncomeDataManager;
    import com.view.gameWindow.mainUi.subuis.musicSet.IMusicSettingManager;
    import com.view.gameWindow.mainUi.subuis.musicSet.MusicSettingManager;
    import com.view.gameWindow.mainUi.subuis.onlineReward.OnlineRewardDataManager;
    import com.view.gameWindow.mainUi.subuis.pet.PetDataManager;
    import com.view.gameWindow.mainUi.subuis.rolehead.PkDataManager;
    import com.view.gameWindow.panel.IPanelMediator;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.artifact.ArtifactDataManager;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.buff.BuffDataManager;
    import com.view.gameWindow.panel.panels.charge.ChargeDataManager;
    import com.view.gameWindow.panel.panels.closet.ClosetDataManager;
    import com.view.gameWindow.panel.panels.convert.ConvertDataManager;
    import com.view.gameWindow.panel.panels.daily.DailyDataManager;
    import com.view.gameWindow.panel.panels.deadRevive.DeadReviveDataManager;
    import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
    import com.view.gameWindow.panel.panels.dungeonTower.DgnTowerDataManger;
    import com.view.gameWindow.panel.panels.everydayOnlineReward.EverydayOnlineRewardDatamanager;
    import com.view.gameWindow.panel.panels.everydayReward.EveryDayRewardDataManager;
    import com.view.gameWindow.panel.panels.expStone.ExpStoneDataManager;
    import com.view.gameWindow.panel.panels.friend.ContactDataManager;
    import com.view.gameWindow.panel.panels.guideSystem.GuideDataManager;
    import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
    import com.view.gameWindow.panel.panels.hejiSkill.HejiSkillDataManager;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    import com.view.gameWindow.panel.panels.keySell.KeySellDataManager;
    import com.view.gameWindow.panel.panels.levelReward.LevelRewardDataManager;
    import com.view.gameWindow.panel.panels.loginReward.LoginRewardDataManager;
    import com.view.gameWindow.panel.panels.mail.data.PanelMailDataManager;
    import com.view.gameWindow.panel.panels.menus.MenuMediator;
    import com.view.gameWindow.panel.panels.onhook.AutoDataManager;
    import com.view.gameWindow.panel.panels.onhook.AutoSystem;
    import com.view.gameWindow.panel.panels.openGift.data.OpenServiceActivityDatamanager;
    import com.view.gameWindow.panel.panels.position.PositionDataManager;
    import com.view.gameWindow.panel.panels.pray.PrayDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.UserDataManager;
    import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
    import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
    import com.view.gameWindow.panel.panels.skill.SkillDataManager;
    import com.view.gameWindow.panel.panels.smartLoad.SmartLoadDatamanager;
    import com.view.gameWindow.panel.panels.specialRing.SpecialRingDataManager;
    import com.view.gameWindow.panel.panels.task.TaskDataManager;
    import com.view.gameWindow.panel.panels.team.TeamDataManager;
    import com.view.gameWindow.panel.panels.thingNew.equipAlert.EquipCanWearManager;
    import com.view.gameWindow.panel.panels.trailer.TrailerDataManager;
    import com.view.gameWindow.panel.panels.vip.VipDataManager;
    import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
    import com.view.gameWindow.scene.GameScene;
    import com.view.gameWindow.scene.GameSceneManager;
    import com.view.gameWindow.scene.announcement.Announcement;
    import com.view.gameWindow.scene.darkmask.DarkMask;
    import com.view.gameWindow.scene.entity.EntityLayerManager;
    import com.view.gameWindow.scene.map.SceneMapManager;
    import com.view.gameWindow.scene.skillDeal.SkillDealManager;
    import com.view.gameWindow.scene.stateAlert.HorizontalAlert;
    import com.view.gameWindow.scene.stateAlert.TaskAlert;
    import com.view.gameWindow.tips.iconTip.IconTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.toolTip.ToolTipLayMediator;
    import com.view.gameWindow.tips.toolTip.ToolTipLayer;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.ContextMenuUtil;
    import com.view.gameWindow.util.FPS;
    
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageQuality;
    import flash.display.StageScaleMode;
    import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;

    public class GameWindow extends Sprite implements IGameWindow
	{
		private var _gameScene:GameScene;
		private var _darkMask:DarkMask;
		private var _mainUILayer:Sprite;
		private var _panelUILayer:Sprite;
		private var _toolTipLayer:ToolTipLayer;
		private var _rollTipLayer:Sprite;
		private var _iconTipLayer:Sprite;
		private var _taskAlertLayer:Sprite;
		private var _horizontalAlert:Sprite;
		private var _flyEffectLayer:Sprite;
		private var _menuLayer:Sprite;
		private var _maskTopLayer:Sprite;
		private var _width:int;
		private var _height:int;
		private var _lastTimeStamp:Number;
		private var _lastRenderStamp:Number;
		private var _fps:FPS;
		private var _announcementlayer:Sprite;
		private var _systemBroadcastLayer:Sprite;

		private var systemBroAdcast:SystemBroAdcast;
		
		public function GameWindow()
		{
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandle);
		}
		
		private function addToStageHandle(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandle);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.BEST;
			stage.frameRate = 60;//帧频
			stage.stageFocusRect = false;//tab键不会出现黄色的框框
			
			init();
		}
		
		private function init():void
		{
			//初始化配置信息
			var configData:ConfigDataGameWindow = new ConfigDataGameWindow();
			ConfigDataManager.instance.initData(configData.getAllConfigData());
			LoginDataManager.instance.gamewindowLoaded = true;
			ServerMessagesManager.getInstance().blocked = false;
			//初始化显示图层
			_gameScene = new GameScene();
			addChild(_gameScene);
			_gameScene.init();
			
			_darkMask = new DarkMask();
			_darkMask.mouseEnabled = false;
			_darkMask.mouseChildren = false;
			addChild(_darkMask);
			_mainUILayer = new Sprite();
			_mainUILayer.mouseEnabled = false;
			addChild(_mainUILayer);
			_panelUILayer = new Sprite();
			_panelUILayer.mouseEnabled = false;
			addChild(_panelUILayer);
			_toolTipLayer = new ToolTipLayer();
			_toolTipLayer.mouseEnabled = false;
			//_toolTipLayer.mouseChildren = false;
			addChild(_toolTipLayer);
			_rollTipLayer = new Sprite();
			_rollTipLayer.mouseChildren = false;
			_rollTipLayer.mouseEnabled = false;
			addChild(_rollTipLayer);
			_iconTipLayer = new Sprite();
			addChild(_iconTipLayer);
			_taskAlertLayer = new Sprite();
			_taskAlertLayer.mouseChildren = false;
			_taskAlertLayer.mouseEnabled = false;
			addChild(_taskAlertLayer);
			_horizontalAlert = new Sprite();
			_horizontalAlert.mouseChildren = false;
			_horizontalAlert.mouseEnabled = false;
			addChild(_horizontalAlert);
			
			_announcementlayer = new Sprite;
			_announcementlayer.mouseEnabled = false;
			_announcementlayer.mouseChildren = false;
			addChild(_announcementlayer);
			
			_systemBroadcastLayer=new Sprite();
			_systemBroadcastLayer.mouseEnabled=false;
			addChild(_systemBroadcastLayer);
			
			
			_flyEffectLayer = new Sprite();
			_flyEffectLayer.mouseChildren = false;
			_flyEffectLayer.mouseEnabled = false;
			addChild(_flyEffectLayer);
			
			
			
			_menuLayer = new Sprite();
			_menuLayer.mouseEnabled = false;
			addChild(_menuLayer);
			
			_maskTopLayer = new Sprite();
			_maskTopLayer.visible = false;
			addChild(_maskTopLayer);

			if (DEF::CLIENTLOGIN)
			{
				_fps = new FPS();
				addChild(_fps);
				_fps.x=420;
			}
			
			//初始化游戏场景管理者
			var gameSceneMananger:GameSceneManager = GameSceneManager.getInstance();
			gameSceneMananger.init(_gameScene, _darkMask);
			gameSceneMananger.resize(_width, _height);
			//初始化主界面介质
			var mainUiMediator:MainUiMediator = MainUiMediator.getInstance();
			mainUiMediator.initView();
			mainUiMediator.resize(_width, _height);
			//初始化面板介质
			var panelMediator:PanelMediator = PanelMediator.instance;
			panelMediator.initData(_panelUILayer,_maskTopLayer);
			panelMediator.resize(_width,_height);
			//初始化tip介质
			var toolTipMediator:ToolTipLayMediator = ToolTipLayMediator.getInstance();
			toolTipMediator.initView(_toolTipLayer);
			ToolTipManager.getInstance().setStage(_toolTipLayer.stage);
			//初始化滚动提示文字介质
			var rollTipMediator:RollTipMediator = RollTipMediator.instance;
			rollTipMediator.initData(_rollTipLayer);
			//初始化任务提示文字介质
			var taskAlert:TaskAlert = TaskAlert.getInstance();
			taskAlert.initData(_taskAlertLayer);
			//初始化事件提示文字介质
			var horizontalAlert:HorizontalAlert = HorizontalAlert.getInstance();
			horizontalAlert.initData(_horizontalAlert);
			// GM 公告
			Announcement.Instance.init(_announcementlayer);
			
			systemBroAdcast = new SystemBroAdcast();
			systemBroAdcast.init(_systemBroadcastLayer);
			
			//初始化图标提示介质
			var iconTipMediator:IconTipMediator = IconTipMediator.instance;
			iconTipMediator.initData(_iconTipLayer);
			//初始化飞行特效介质
			var flyEffectMediator:FlyEffectMediator = FlyEffectMediator.instance;
			flyEffectMediator.initData(_flyEffectLayer);
			//初始化菜单介质
			var menuMediator:MenuMediator = MenuMediator.instance;
			menuMediator.initData(_menuLayer);
			
			initDataManagers();
			
			addEventListener(Event.ENTER_FRAME, enterframeHandle, false, 0, true);
			stage.addEventListener(Event.RENDER, onRender, false, 0, true);
			_lastTimeStamp = getTimer();
			test();
		}

		private function test():void
		{
			var sp:Sprite=new Sprite();
			sp.graphics.beginFill(0xcccccc);
			sp.graphics.drawRect(0,0,70,35);
			sp.graphics.endFill();
			sp.buttonMode=true;
			addChild(sp);
			sp.x=10;
			sp.y=150;
			sp.addEventListener(MouseEvent.CLICK, function():void{
				var byte:ByteArray=new ByteArray();
				byte.endian=Endian.LITTLE_ENDIAN;
				byte.writeUTF("xiaoding");
				byte.writeByte(1);
				byte.writeInt(25);
				ClientSocketManager.getInstance().asyncCall(243,byte);
				byte=null;
			});
		}
		
		private function initDataManagers():void
		{
			TaskDataManager.instance;
			UserDataManager.getInstance();
			RoleDataManager.instance;
			HeroDataManager.instance;
			BagDataManager.instance;
			MemEquipDataManager.instance;
			SkillDataManager.instance;
			EntityLayerManager.getInstance();
			SkillDealManager.instance;
			ClosetDataManager.instance;
			//RecycleEquipDataManager.instance;
			IncomeDataManager.instance;
			ChatDataManager.instance;
			PanelMailDataManager.instance;
			ConvertDataManager.instance;
			KeySellDataManager.instance;
			VipDataManager.instance;
			SpecialRingDataManager.instance;
			BuffDataManager.instance;
			DailyDataManager.instance;
            OnlineRewardDataManager.instance;
			DgnDataManager.instance;
			DeadReviveDataManager.instance;
			AutoDataManager.instance;
			TeleportDatamanager.instance;
			DgnTowerDataManger.instance;
			TeamDataManager.instance;
			TeamHintDataManager.instance;
			ContactDataManager.instance;
			ExpStoneDataManager.instance;
			AnnouncementDataManager.instance;
			PositionDataManager.instance;
			PrayDataManager.instance;
			SchoolElseDataManager.getInstance();
			SchoolDataManager.getInstance();
			LevelRewardDataManager.instance;
			ArtifactDataManager.instance;
			GuideDataManager.instance;
			PetDataManager.instance;
			WelfareDataMannager.instance;
			HejiSkillDataManager.instance;
			PkDataManager.instance;
			TrailerDataManager.getInstance();
            DisplaySettingManager.instance;
            EquipCanWearManager.instance;
            ChargeDataManager.instance;
            LoginRewardDataManager.instance;
			PositionDataManager.instance;
            EveryDayRewardDataManager.instance;
			OpenServiceActivityDatamanager.instance;
			SmartLoadDatamanager.instance;
			EverydayOnlineRewardDatamanager.instance;
			//EquipUpgradeDataManager.instance;//屏蔽掉装备进阶提示
		}
		
		private function enterframeHandle(event:Event):void
		{
			var newTimeStamp:Number = getTimer();
			var timeDiff:int = newTimeStamp - _lastTimeStamp;
			_lastTimeStamp = newTimeStamp;
			

			GameSceneManager.getInstance().update(timeDiff);
			UIEffectManager.instance.update(timeDiff);
			//stage.invalidate();
			
			if (SceneMapManager.getInstance().ready)
			{
				EntityLayerManager.getInstance().updateFirstPlayerPos(timeDiff);
				GameSceneManager.getInstance().resetScenePos();
	
				GuideSystem.instance.checkDoingGuides();
				AutoSystem.instance.run();//之前在firstplayer中的update中 ，可是取不到EntityLayerManger中inViewEntities,暂时放这
				GameSceneManager.getInstance().checkOpertaion();
			}
		}
		
		private function onRender(event:Event):void
		{
			//var newTimeStamp:Number = getTimer();
			//var timeDiff:int = newTimeStamp - _lastRenderStamp;
			//_lastRenderStamp = newTimeStamp;
			//if (SceneMapManager.getInstance().ready)
			//{
			//	EntityLayerManager.getInstance().updateFirstPlayerPos(timeDiff);
			//	GameSceneManager.getInstance().resetScenePos();
			//	//AutoSystem.instance.run();//之前在firstplayer中的update中 ，可是取不到EntityLayerManger中inViewEntities,暂时放这
			//}
		}
		
		public function resize(newWidth:int, newHeight:int):void
		{
			_width = newWidth;
			_height = newHeight;
			_darkMask.resize(_width, _height);
			EntityLayerManager.getInstance().resize(newWidth, newHeight);
			GameSceneManager.getInstance().resize(newWidth, newHeight);
			MainUiMediator.getInstance().resize(newWidth, newHeight);
			PanelMediator.instance.resize(newWidth,newHeight);
			MenuMediator.instance.resize(newWidth,newHeight);
			IconTipMediator.instance.resize(newWidth,newHeight);
			Announcement.Instance.resize(newWidth,newHeight);
			systemBroAdcast.resize(newWidth,newHeight);
			RollTipMediator.instance.resize();
		}
		
		public function showMainUI():void
		{
			//添加键盘事件
			var gameWindowKeyHandle:GameWindowKeyHandle = new GameWindowKeyHandle();
			gameWindowKeyHandle.addEvent(stage);
			var mainUiMediator:MainUiMediator = MainUiMediator.getInstance();
			mainUiMediator.showUI(_mainUILayer);
			mainUiMediator.resize(_width, _height);
		}
		
		public function panelMediator():IPanelMediator
		{
			return PanelMediator.instance;
		}
		
		public function get mainUiMediator():IMainUiMediator
		{
			return MainUiMediator.getInstance();
		}
		
		public function get musicSetingManager():IMusicSettingManager
		{
			return MusicSettingManager.instance;
		}
	}
}