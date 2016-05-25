package com.view.gameWindow.panel.panels.achievement
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.AchievementCfgData;
	import com.model.configData.cfgdata.EquipExchangeCfgData;
	import com.model.configData.cfgdata.WingUpgradeCfgData;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.panel.panels.achievement.content.ContentData;
	import com.view.gameWindow.panel.panels.achievement.title.TitleData;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.position.PositionDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.SortUtil;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	public class AchievementDataManager extends DataManagerBase
	{
		private static var _instance:AchievementDataManager;
		private const DEFAULT_TYPE:int=1;
		public var selectTitleType:int;
		public var liquan:int;
		public var exploit:int;
		public var contentDatas:Dictionary;
		private var contentArr:Vector.<AchievementCfgData>;
		private var titleDatas:Dictionary;
		private var _noRequstCount:int;
		public function AchievementDataManager()
		{
			super();
			
			contentArr=new Vector.<AchievementCfgData>();
			titleDatas=new Dictionary();
			contentDatas=new Dictionary();
			selectTitleType=DEFAULT_TYPE;
			
			DistributionManager.getInstance().register(GameServiceConstants.SM_ACHIEVEMENT_LIST,this);
			DistributionManager.getInstance().register(GameServiceConstants.CM_GET_ACHIEVEMENT_AWRAD,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_KEY_GET_ACHIEVEMENT_INFO,this);
		}
		
		public static function getInstance():AchievementDataManager
		{
			if(_instance==null)
			{
				_instance=new AchievementDataManager();
			}
			return _instance;
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch (proc)
			{
				case GameServiceConstants.SM_ACHIEVEMENT_LIST:
					dealAchiData(data);
					break;
				case GameServiceConstants.SM_KEY_GET_ACHIEVEMENT_INFO:
					dealOneKeyAward(data);
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function dealAchiData(data:ByteArray):void
		{
			liquan=data.readInt();
			exploit=data.readInt();
			var refreshType:int = data.readByte();
			var l:int=data.readInt();
			var achievementCfgData:Dictionary = ConfigDataManager.instance.achievementCfgData();
			var nocount:int,cc:int;
			if(refreshType==0)
			{
				titleDatas=null;
				titleDatas=new Dictionary;
			}else
			{
				delete titleDatas[refreshType];
			}
			
			while(l--)
			{
				var achiData:ContentData = new ContentData();
				achiData.id = data.readInt();
				achiData.state=data.readInt();
				var type:int = data.readByte();
				var achiCfg:AchievementCfgData = achievementCfgData[achiData.id];
				var titleData:TitleData= titleDatas[type]||new TitleData;
				titleData.count+=1;
				var iscompled:Boolean=false;
				switch(type)
				{
					case 1:
						iscompled=RoleDataManager.instance.reincarn>=achiCfg.num&&RoleDataManager.instance.lv>=achiCfg.level||RoleDataManager.instance.reincarn>achiCfg.num;
						achiData.gress=iscompled?100:0;
						break;
					case 3:
						iscompled=HeroDataManager.instance.grade>=achiCfg.num;
						achiData.gress=HeroDataManager.instance.grade/achiCfg.num*100;
						break;
					case 4:
						iscompled=PositionDataManager.instance.position>=achiCfg.num;
						achiData.gress=PositionDataManager.instance.position/achiCfg.num*100;
						break;
					case 6:
						if(achiCfg.other_type==5)
						{
							var equipData:EquipData = RoleDataManager.instance.equipDatas[ConstEquipCell.CP_CHIBANG];
							if(equipData!=null&&equipData.memEquipData!=null)
							{
								var wingUpgradeCfg:WingUpgradeCfgData = ConfigDataManager.instance.wingUpgradeCfg(equipData.memEquipData.baseId);
								iscompled=wingUpgradeCfg.upgrade>=achiCfg.num;
								achiData.gress=wingUpgradeCfg.upgrade/achiCfg.num*100;
							}
						}
						else if(achiCfg.other_type==7)
						{
							var hulong:EquipData = RoleDataManager.instance.equipDatas[ConstEquipCell.CP_HUOLONGZHIXIN];
							if(hulong!=null&&hulong.memEquipData!=null)
							{
								var equipExchangeCfgData:EquipExchangeCfgData = ConfigDataManager.instance.equipExchangeCfgData(hulong.memEquipData.baseId);
								iscompled=equipExchangeCfgData.step>achiCfg.num||(equipExchangeCfgData.step==achiCfg.num&&equipExchangeCfgData.current_star>=achiCfg.level);
								achiData.gress=iscompled?100:0;
							}
						}
						else if(achiCfg.other_type==6)
						{
							var dunPai:EquipData = RoleDataManager.instance.equipDatas[ConstEquipCell.CP_DUNPAI];
							if(dunPai!=null&&dunPai.memEquipData!=null)
							{
								var dunPaiExchangeCfgData:EquipExchangeCfgData = ConfigDataManager.instance.equipExchangeCfgData(dunPai.memEquipData.baseId);
								iscompled=dunPaiExchangeCfgData.step>achiCfg.num||(dunPaiExchangeCfgData.step==achiCfg.num&&dunPaiExchangeCfgData.current_star>=achiCfg.level);
								achiData.gress=iscompled?100:0;
							}
						}
						break;
					case 9:
						iscompled=RoleDataManager.instance.loginCount>=achiCfg.num;
						achiData.gress=RoleDataManager.instance.loginCount/achiCfg.num*100;
						break;
					default:
						achiData.num=data.readInt();
						iscompled=achiData.num>=achiCfg.num;
						achiData.gress=achiData.num/achiCfg.num*100;
						break;
				}
				
				if(iscompled)
				{
					titleData.gress+=1;
					if(achiData.state==0)  //如果可领取又未领取
					{
						titleData.awardC+=1;
					}
				}
				
				achiData.isCompled=iscompled;
				titleDatas[type]=titleData;
				contentDatas[achiData.id]=achiData;
			}
		}
		
		private function dealOneKeyAward(data:ByteArray):void
		{
			if(noRequstCount==0)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.ACHI_PANEL_0022);
				return;
			}
			var serverNum1:int=data.readInt();
			var serverNum2:int=data.readInt();
			/*if(serverNum1>0)
			{
				UtilsTimeOut.dealTimeOut(StringConst.ACHI_PANEL_0017+serverNum1,0);
			}
			if(serverNum2>0)
			{
				UtilsTimeOut.dealTimeOut(StringConst.ACHI_PANEL_0018+serverNum1,500);
			}*/
		}
		
		public function getContentCfgByType():Vector.<AchievementCfgData>
		{
			while(contentArr.length>0)
			{
				 var cfg:AchievementCfgData=contentArr.shift();
				 cfg=null;
			}
			var dic:Dictionary=ConfigDataManager.instance.achievementCfgData();
			for each(var cfgData:AchievementCfgData in dic)
			{
				if(cfgData.type==selectTitleType)
				{
					contentArr.push(cfgData);
				}
			}
			contentArr.sort(SortUtil.sortId);
			return contentArr;
		}
		
		public function getTitleData(type:int):TitleData
		{
			return titleDatas[type];
		}
		
		public function getAchievementData():void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_ACHIEVEMENT,byteArray);
		}
		
		public function getAchievementAward(id:int,type:int):void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			byteArray.writeInt(id);
			byteArray.writeInt(type);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_ACHIEVEMENT_AWRAD,byteArray);
		}
		
		public function oneKeyAchievementAward():void
		{
			var byteArray:ByteArray=new ByteArray();
			byteArray.endian=Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_KEY_GET_ACHIEVEMENT_AWRAD,byteArray);
		}
		
		override public function clearDataManager():void
		{
			while(contentArr.length>0)
			{
				var cfg:AchievementCfgData=contentArr.shift();
				cfg=null;
			}
			contentArr=null;
			selectTitleType=DEFAULT_TYPE;
			super.clearDataManager();
		}

		public function get noRequstCount():int
		{
			_noRequstCount=0;
			for each(var item:TitleData in titleDatas)
			{
				_noRequstCount+=item.awardC;
			}
			return _noRequstCount;
		}

	}
}