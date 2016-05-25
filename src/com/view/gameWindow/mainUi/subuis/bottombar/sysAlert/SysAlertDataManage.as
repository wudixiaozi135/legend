package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.panel.panels.school.complex.member.SchoolMemberData;
	import com.view.gameWindow.panel.panels.school.simpleness.list.item.SchoolData;
	
	import flash.utils.ByteArray;

	public class SysAlertDataManage extends DataManagerBase
	{
		public var callperson:SchoolMemberData;
		public var requestSchool:SchoolData;
		public function SysAlertDataManage()
		{
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_CALL,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_APPLY,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_INVITE,this);
		}
		
		private static var _instance:SysAlertDataManage;
		
		public  static function getInstance():SysAlertDataManage
		{
			if(_instance==null)
			{
				_instance=new SysAlertDataManage();
			}
			return _instance;
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_FAMILY_CALL:
					dealSchoolCallt(data);
					break;
				case GameServiceConstants.SM_FAMILY_APPLY:
					break;
				case GameServiceConstants.SM_FAMILY_INVITE:
					dealSchoolData(data);
					break;
			}
			
			super.resolveData(proc, data);
		}
		
		private function dealSchoolData(data:ByteArray):void
		{
			requestSchool=requestSchool||new SchoolData();
			requestSchool.id=data.readInt();
			requestSchool.sid=data.readInt();
			requestSchool.name=data.readUTF();
			requestSchool.leaderCid=data.readInt(); //邀请者的id
			requestSchool.leaderSid=data.readInt();
		}
		
		private function dealSchoolCallt(data:ByteArray):void
		{
			callperson=callperson||new SchoolMemberData();
			callperson.cid=data.readInt();
			callperson.sid=data.readInt();
			callperson.name= data.readUTF();
		}
	}
}