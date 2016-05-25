package com.model.dataManager
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.ServerMessagesManager;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.consts.ConstKickOut;
    import com.model.consts.StringConst;
    import com.view.gameWindow.util.HttpServiceUtil;
    import com.view.gameWindow.util.ServerTime;
    import com.view.newMir.NewMirMediator;
    import com.view.newMir.login.LoginMediator;
    import com.view.newMir.prompt.PanelPromptData;
    import com.view.newMir.sound.SoundManager;
    import com.view.selectRole.SelectRoleDataManager;
    
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    public class LoginDataManager extends DataManagerBase
	{
		private static var _instance:LoginDataManager;
		public static function get instance():LoginDataManager
		{
			return _instance ||= new LoginDataManager(new PrivateClass());
		}
		public static function clearInstance():void
		{
			_instance = null;
		}
		
		private var _gamewindowLoaded:Boolean;
		public function set gamewindowLoaded(value:Boolean):void
		{
			_gamewindowLoaded = value;
		}
		private var _isCreateRoleEnter:Boolean;
		public function set isCreateRoleEnter(value:Boolean):void
		{
			_isCreateRoleEnter = value;
		}
		
		public function LoginDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			DistributionManager.getInstance().register(GameServiceConstants.SM_USER_TOKEN,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_CHARACTER_LIST,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_SERVER_TIME,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_KICK_OUT,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_NEW_CHARACTER, this);
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_USER_TOKEN:
					userTokenHandle(data);
					break;
				case GameServiceConstants.SM_CHARACTER_LIST:
					characterListHandle(data);
					break;
				case GameServiceConstants.SM_SERVER_TIME:
					serverTimeHandler(data);
					break;
				case GameServiceConstants.CM_NEW_CHARACTER://创建角色成功
					createRoleSuccess();
					break;
				case GameServiceConstants.SM_KICK_OUT://被T掉线
					kickOut(data);
					break;
				default:
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function kickOut(data:ByteArray):void
		{
			var type:int = data.readInt();
			if(type == ConstKickOut.LR_KICK_SELF)
			{
				PanelPromptData.txtContent = StringConst.PROMPT_PANEL_0044;
				PanelPromptData.txtBtn = StringConst.PROMPT_PANEL_0003;
				NewMirMediator.getInstance().showOffLine(true);
            } else if (type == ConstKickOut.LR_KICK_BY_GM)
            {
                PanelPromptData.txtContent = StringConst.PROMPT_PANEL_0046;
                PanelPromptData.txtBtn = StringConst.PROMPT_PANEL_0003;
                NewMirMediator.getInstance().showOffLine(true);
            }
		}
		
		//收到创建角色成功反馈后再隐藏不必要的界面
		private function createRoleSuccess():void
		{
			LoginDataManager.instance.isCreateRoleEnter = true;
			NewMirMediator.getInstance().hideCreateRoleSelectRole();
		}
		
		private function serverTimeHandler(data:ByteArray):void
		{
			var i:int = 8;
			var base:Number = 1;
			var tick:Number = 0;
			while (i-- > 0)
			{
				tick += data.readUnsignedByte() * base;
				base *= 256;
			}
			ServerTime.update(tick);
		}
		
		private function userTokenHandle(data:ByteArray):void
		{
			var uid:String = data.readUTF();
			var sid:int = data.readInt();
			var token:String = data.readUTF();
			
			LoginMediator.getInstance().gateLogin(uid, sid, token);
		}
		
		private function characterListHandle(data:ByteArray):void
		{
			var bytes:ByteArray = new ByteArray();
			var count:int = data.readByte();
			if (count > 0)
			{
				SelectRoleDataManager.getInstance().readData(data,count);
				var lastSelectCid:int = SelectRoleDataManager.getInstance().selectCid;
				bytes.endian = Endian.LITTLE_ENDIAN;
				bytes.writeInt(lastSelectCid);
				 
				enterGame(bytes);
				return;
				 
				if(_isCreateRoleEnter)
				{
					_isCreateRoleEnter = false;
					ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_ENTER_GAME, bytes);
				}
				else
				{
					NewMirMediator.getInstance().initSelectRole();
				}
				
				ServerMessagesManager.getInstance().blocked = !_gamewindowLoaded;
			}
			else
			{
				HttpServiceUtil.getInst().sendHttp(HttpServiceUtil.STEP5,1);
				NewMirMediator.getInstance().initCreateRole();
			}
		}
		
		private function enterGame(bytes:ByteArray):void
		{
			ServerMessagesManager.getInstance().blocked = !_gamewindowLoaded;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_ENTER_GAME, bytes);
			var mediator:NewMirMediator = NewMirMediator.getInstance();
			mediator.hideCreateRole();
			mediator.hideSelectRole();
			SoundManager.getInstance().newMir = mediator.iNewMir;
			mediator.initGameWindow();
			mediator.setLoadVisible(mediator.loadGwIndex,true);
		}
	}
}
class PrivateClass{}