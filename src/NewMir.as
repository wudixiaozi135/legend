package
{
	import com.model.business.flashVars.FlashVarsManager;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataCreateRole;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.ConfigDataNewMir;
	import com.view.gameLoader.IGameLoader;
	import com.view.gameWindow.panel.panels.guardSystem.GuardManager;
	import com.view.gameWindow.util.HttpServiceUtil;
	import com.view.newMir.INewMir;
	import com.view.newMir.NewMirMediator;
	import com.view.newMir.login.LoginMediator;
	import com.view.newMir.login.LoginPanel;
	import com.view.selectRole.SelectRoleDataManager;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class NewMir extends Sprite implements INewMir
	{
		private var _loginPanel:LoginPanel;
		
		public function NewMir()
		{
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandle);
		}
		
		private function addToStageHandle(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandle);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.BEST;
			stage.stageFocusRect = false;//tab键不会出现黄色的框框
			init();
		}
		
		private function init():void
		{
			NewMirMediator.getInstance().init(this);
			
			var configData:ConfigDataNewMir = new ConfigDataNewMir();
			ConfigDataManager.instance.initData(configData.getAllConfigData());
			ConfigDataManager.instance.initData(ConfigDataCreateRole.getAllConfigData());
			ConfigDataManager.instance.setLastNameConfig(ConfigDataCreateRole.lastName_Config);
			ConfigDataManager.instance.setMaleNameConfig(ConfigDataCreateRole.male_Config);
			ConfigDataManager.instance.setFemaleNameConfig(ConfigDataCreateRole.female_Config);
			GuardManager.getInstance().init();
			
			if (DEF::CLIENTLOGIN)
			{
				NewMirMediator.getInstance().hideLoadingInGameLoad();
				_loginPanel = new LoginPanel();
				addChild(_loginPanel);
				_loginPanel.init();
			}
			else
			{
				var flashVarsManager:FlashVarsManager = FlashVarsManager.getInstance();
				var serverIp:String = flashVarsManager.serverIp;
				LoginMediator.getInstance().nameText = flashVarsManager.passport;
				var port:int = flashVarsManager.port;
				var uid:String = flashVarsManager.uid;
				var sid:int = flashVarsManager.sid;
				var token:String = flashVarsManager.token;
				LoginMediator.getInstance().connectAndGateLogin(serverIp, port, uid, sid, token);
			}
		}
		
		public function resize(newWidth:int, newHeight:int):void
		{
			NewMirMediator.getInstance().resize(newWidth, newHeight);
		}
		
		public function dealCreateRole():void
		{
			NewMirMediator.getInstance().dealCreateRole();
		}
		
		public function dealSelectRole():void
		{
			NewMirMediator.getInstance().dealSelectRole();
		}
		
		public function enterGame():void
		{
			HttpServiceUtil.getInst().sendHttp(HttpServiceUtil.STEP7,1);
			var bytes:ByteArray = new ByteArray();
			var lastSelectCid:int = SelectRoleDataManager.getInstance().selectCid;
			bytes.endian = Endian.LITTLE_ENDIAN;
			bytes.writeInt(lastSelectCid);
			/*trace(lastSelectCid);*/
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_ENTER_GAME, bytes);
			var mediator:NewMirMediator = NewMirMediator.getInstance();
			mediator.setLoadVisible(mediator.loadGwIndex,true);
			mediator.hideCreateRole();
			mediator.hideSelectRole();
		}
		
		public function delCharacter():void
		{
			var byteArr:ByteArray = new ByteArray();
			var lastSelectCid:int = SelectRoleDataManager.getInstance().selectCid;
			byteArr.endian = Endian.LITTLE_ENDIAN;
			byteArr.writeInt(lastSelectCid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DEL_CHARACTER,byteArr);
		}
		
		public function newCharacter(name:String,sex:int,job:int):void
		{
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			bytes.writeUTF(name);//name
			bytes.writeInt(sex);
			bytes.writeInt(job);
			bytes.writeInt(1);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_NEW_CHARACTER, bytes);
		}

		public function setGameLoader(gameLoader:IGameLoader):void
		{
			NewMirMediator.getInstance().gameLoader = gameLoader;
		}
		
		public function musicBasicState(type:int):Boolean
		{
			var state:Boolean = NewMirMediator.getInstance().gameWindow.musicSetingManager.getMusicSettingState(type);
			return state;
		}
	}
}