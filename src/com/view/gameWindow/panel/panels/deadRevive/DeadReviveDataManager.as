package com.view.gameWindow.panel.panels.deadRevive
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MonsterCfgData;
	
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	
	import flash.utils.ByteArray;
	
	public class DeadReviveDataManager extends DataManagerBase
	{
		private static var _instance:DeadReviveDataManager;
		private var _hurtType:int;
		private var _hurtName:String;
		private var _isMonster:Boolean;
		
		public static function get instance():DeadReviveDataManager
		{
			if(!_instance)
				_instance = new DeadReviveDataManager(hideFun);
			return _instance;
		}
		private static function hideFun():void{}
		
		public function DeadReviveDataManager(fun:Function)
		{
			super();
			if(fun != hideFun)
				throw new Error("该类使用单例模式");
			DistributionManager.getInstance().register(GameServiceConstants.SM_KILLED_INFO,this);
		}

		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				//死亡信息
				case GameServiceConstants.SM_KILLED_INFO:
					readData(data);
					break;
				default:
					break;
			}
			super.resolveData(proc, data);
		}
		
		
		private function readData(data:ByteArray):void
		{
			var mapId:int=data.readInt();
			_hurtType=data.readByte();
			var cid:int;
			var sid:int;
			var monsterId:int;
			var monsterCfgData:MonsterCfgData;
			//伤害者是玩家/英雄/宠物
			if(_hurtType==EntityTypes.ET_PLAYER || _hurtType==EntityTypes.ET_PET || _hurtType==EntityTypes.ET_HERO)
			{
				cid=data.readInt();
				sid=data.readInt();
				_hurtName=data.readUTF();
				_isMonster=false;
			}
			else if(_hurtType==EntityTypes.ET_MONSTER)
			{
				monsterId=data.readInt();
				monsterCfgData=ConfigDataManager.instance.monsterCfgData(monsterId);
				_hurtName = monsterCfgData ? monsterCfgData.name : "";
				_isMonster=true;
			}
			else if(_hurtType==EntityTypes.ET_TRAP)	
			{
				cid=data.readInt();
				sid=data.readInt();
				_hurtName=data.readUTF();
				_isMonster=false;
			}
			else
			{
			}
		}
		
		public function get isMonster():Boolean
		{
		    return _isMonster;	
		}
		
		public function get hurtName():String
		{
			return _hurtName;
		}
	}
}