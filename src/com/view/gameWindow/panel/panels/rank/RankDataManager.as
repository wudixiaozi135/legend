package com.view.gameWindow.panel.panels.rank
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.panel.panels.rank.data.RankMemberData;
	
	import flash.display.MovieClip;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class RankDataManager extends DataManagerBase
	{
		private static var _instance:RankDataManager;
		
		public static const PAGE_DATA_COUNT:int=10;
		public static var selectIndex:int;
		public static var lastMc:MovieClip;
		
		public static const RLT_LEVEL:int = 1;//等级榜
		public static const RLT_SOLDIER_ATTACK_POWER:int = 2;//战士攻击力
		public static const RLT_MAGE_ATTACK_POWER:int = 3;//法师攻击力
		public static const RLT_TAOLIST_ATTACK_POWER:int = 4;//道士攻击力
		public static const RLT_HERO_LEVEL:int = 5;//英雄等级
		public static const RLT_POSITION:int = 6;//玩家官位
		public static const RLT_UNBIND_COIN:int = 7;//财富
			
		public var rankType:int;
		public var rankTotal:int;
		public var myRank:int;
		public var rankList:Array;

		public function RankDataManager()
		{
			if(_instance==null)
			{
				_instance=this;
			}
			DistributionManager.getInstance().register(GameServiceConstants.SM_RANK_LIST,this);
		}	
		
		public static function getInstance():RankDataManager
		{
			return _instance||new RankDataManager();
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_RANK_LIST:
					dealRankList(data);
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function dealRankList(data:ByteArray):void
		{
			rankType=data.readByte();
			rankTotal=data.readShort();
			if(rankTotal>100)rankTotal=100;
				
			myRank=data.readShort();
			data.readShort();
			switch (rankType)
			{
				case RLT_LEVEL:
					dealLevel(data);
					break;
				case RLT_SOLDIER_ATTACK_POWER:
				case	RLT_MAGE_ATTACK_POWER:
				case RLT_TAOLIST_ATTACK_POWER:
					dealPower(data);
					break;
				case RLT_HERO_LEVEL:
					dealHeroLevel(data);
					break;
				case RLT_POSITION:
					dealPosition(data);
					break;
				case RLT_UNBIND_COIN:
					dealUnbingCoin(data);
					break;
			}
		}
		
		private function dealUnbingCoin(data:ByteArray):void
		{
			rankList=null;
			rankList=[];
			var count:int = data.readShort();
			while(count>0)
			{
				var rankMemberData:RankMemberData = new RankMemberData;
				rankMemberData.rank=data.readShort();
				rankMemberData.sid=data.readInt();
				rankMemberData.cid=data.readInt();
				rankMemberData.name=data.readUTF();
				rankMemberData.familySid=data.readInt();
				rankMemberData.familyId=data.readInt();
				rankMemberData.familyName=data.readUTF();
				if(rankMemberData.familyName=="")rankMemberData.familyName=StringConst.RANK_PANEL_0010;
				rankMemberData.sex=data.readByte();
				rankMemberData.job=data.readByte();
				rankMemberData.unbindCoin=data.readInt();
				rankMemberData.vip=data.readByte();
				rankMemberData.isOnLine=data.readByte();
				rankList.push(rankMemberData);
				count--;
			}
		}
		
		private function dealPosition(data:ByteArray):void
		{
			rankList=null;
			rankList=[];
			var count:int = data.readShort();
			while(count>0)
			{
				var rankMemberData:RankMemberData = new RankMemberData;
				rankMemberData.rank=data.readShort();
				rankMemberData.sid=data.readInt();
				rankMemberData.cid=data.readInt();
				rankMemberData.name=data.readUTF();
				rankMemberData.familySid=data.readInt();
				rankMemberData.familyId=data.readInt();
				rankMemberData.familyName=data.readUTF();
				if(rankMemberData.familyName=="")rankMemberData.familyName=StringConst.RANK_PANEL_0010;
				rankMemberData.position=data.readInt();
				rankMemberData.vip=data.readByte();
				rankMemberData.isOnLine=data.readByte();
				rankList.push(rankMemberData);
				count--;
			}
			
		}
		
		private function dealHeroLevel(data:ByteArray):void
		{
			rankList=null;
			rankList=[];
			var count:int = data.readShort();
			while(count>0)
			{
				var rankMemberData:RankMemberData = new RankMemberData;
				rankMemberData.rank=data.readShort();
				rankMemberData.sid=data.readInt();
				rankMemberData.cid=data.readInt();
				rankMemberData.name=data.readUTF();
				rankMemberData.reincarn=data.readByte();
				rankMemberData.level=data.readShort();
				rankMemberData.job=data.readByte();
				rankMemberData.sex=data.readByte();
				rankMemberData.isOnLine=data.readByte();
				rankList.push(rankMemberData);
				count--;
			}
		}
		
		private function dealPower(data:ByteArray):void
		{
			rankList=null;
			rankList=[];
			var count:int = data.readShort();
			while(count>0)
			{
				var rankMemberData:RankMemberData = new RankMemberData;
				rankMemberData.rank=data.readShort();
				rankMemberData.sid=data.readInt();
				rankMemberData.cid=data.readInt();
				rankMemberData.name=data.readUTF();
				rankMemberData.reincarn=data.readByte();
				rankMemberData.level=data.readShort();
				rankMemberData.sex=data.readByte();
				rankMemberData.job=data.readByte();
				rankMemberData.attackPower=data.readInt();
				rankMemberData.vip=data.readByte();
				rankMemberData.familyId= data.readInt();//家族的id
				rankMemberData.familySid= data.readInt();//家族的服务器id
				rankMemberData.familyName=data.readUTF();//家族名
				rankMemberData.isOnLine=data.readByte();
				if(rankMemberData.familyName=="")rankMemberData.familyName=StringConst.RANK_PANEL_0010;
				rankList.push(rankMemberData);
				count--;
			}
		}
		
		private function dealLevel(data:ByteArray):void
		{
			rankList=null;
			rankList=[];
			var count:int = data.readShort();
			while(count>0)
			{
				var rankMemberData:RankMemberData = new RankMemberData;
				rankMemberData.rank=data.readShort();
				rankMemberData.sid=data.readInt();
				rankMemberData.cid=data.readInt();
				rankMemberData.name=data.readUTF();
				rankMemberData.reincarn=data.readByte();
				rankMemberData.level=data.readShort();
				rankMemberData.sex=data.readByte();
				rankMemberData.job=data.readByte();
				rankMemberData.familySid=data.readInt();
				rankMemberData.familyId=data.readInt();
				rankMemberData.familyName=data.readUTF();
				if(rankMemberData.familyName=="")rankMemberData.familyName=StringConst.RANK_PANEL_0010;
				rankMemberData.vip=data.readByte();
				rankMemberData.isOnLine=data.readByte();
				rankList.push(rankMemberData);
				count--;
			}
		}
		
		public function queryRankList(type:int,starIndex:int=0,endIndex:int=10):void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			byteArray.writeByte(type);
			byteArray.writeShort(starIndex);
			byteArray.writeShort(endIndex);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_RANK_LIST,byteArray);
		}	
	}
}