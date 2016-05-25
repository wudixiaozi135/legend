package com.view.gameWindow.panel.panels.artifact
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelBase;

	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class ArtifactDataManager extends DataManagerBase
	{
		//ArtifactCfgData 里的part
		public const TYPE_WEAPON:int = 1;
		public const TYPE_HELMET:int = 2;
		public const TYPE_NECK_LACE:int = 3;
		public const TYPE_CLOTH:int = 4;
		public const TYPE_BRACELET:int = 5;
		public const TYPE_RING:int = 6;
		public const TYPE_BELT:int = 7;
		public const TYPE_SHOE:int = 8;

		//服务端下发数据 身上八个部位
		public var ownDatas:Vector.<int> = new <int>[0, 0, 0, 0, 0, 0, 0, 0];
		public var ownDataParts:Vector.<int> = new <int>[TYPE_WEAPON, TYPE_HELMET, TYPE_NECK_LACE, TYPE_CLOTH, TYPE_BRACELET, TYPE_RING, TYPE_BELT, TYPE_SHOE];

		private static var _instance:ArtifactDataManager;
		
		public static function get instance():ArtifactDataManager
		{
			if(!_instance)
				_instance = new ArtifactDataManager(new PrivateClass());
			return _instance;
		}
		
		public function ArtifactDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_GOD_MAGIC_WEAPON,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_GOD_MAGIC_WEAPON_GETTED, this);
		}

		override public function resolveData(proc:int, data:ByteArray):void
		{
			if (proc == GameServiceConstants.SM_GOD_MAGIC_WEAPON_GETTED)
			{
				handlerSM_GOD_MAGIC_WEAPON_GETTED(data);
			}
			super.resolveData(proc, data);
		}

		private function handlerSM_GOD_MAGIC_WEAPON_GETTED(data:ByteArray):void
		{
			ownDatas[0] = data.readInt();
			ownDatas[1] = data.readInt();
			ownDatas[2] = data.readInt();
			ownDatas[3] = data.readInt();
			ownDatas[4] = data.readInt();
			ownDatas[5] = data.readInt();
			ownDatas[6] = data.readInt();
			ownDatas[7] = data.readInt();
		}
		
		public function sendData(id:int,storage:int,slot:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(id);
			byteArray.writeByte(storage);
			byteArray.writeInt(slot);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GOD_MAGIC_WEAPON,byteArray);
		}
		
		public function dealSwitchPanleArtifact():void
		{
			var openedPanel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_ARTIFACT);
			if (!openedPanel)
			{
				PanelMediator.instance.openPanel(PanelConst.TYPE_ARTIFACT);
			}
			else
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_ARTIFACT);
			}
		}
	}
}
class PrivateClass{}