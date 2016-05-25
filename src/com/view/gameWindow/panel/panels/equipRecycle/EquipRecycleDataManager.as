package com.view.gameWindow.panel.panels.equipRecycle
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.EquipRecycleCfgData;
	import com.model.consts.FontFamily;
	import com.model.consts.JobConst;
	import com.model.consts.SexConst;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.RectRim;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.utils.StringUtil;

	public class EquipRecycleDataManager extends DataManagerBase
	{
		private static var _instance:EquipRecycleDataManager;
		public static function get instance():EquipRecycleDataManager
		{
			return _instance ||= new EquipRecycleDataManager(new PrivateClass());
		}
		
		public var awardInfo:Array = [0,0,0];
		public var awardInfoId:Array = [111,112,113];
		public var isAllRecycle:Boolean = false;
		//soldierBtn   wizardBtn   taoistBtn   noRoleBtn
		public var selcetOption:Array = [{flag:1,lv:0,job:1},{flag:1,lv:0,job:2},{flag:1,lv:0,job:3},{flag:1,lv:-1,job:0}];
		public var equipRecycleDatas:Vector.<BagData>;
		public var realEquipRecycleDatas:Vector.<BagData> = new Vector.<BagData>;
		public var selectData:BagData;
		
		public var _rectRim:RectRim;
		public var _page:int;
		
		public var progress:int;
		public var currentIndex:int = 0;
		public var getRewardCount:int;
		public var recycleExp:int;
		////////////
		public static var oneKeyRecycle:Boolean = false;//是否一键回收
		public static var playEffect:Boolean = false;//开始播放动画
		public static var totalExpShow:Boolean = false;//
		////////////////
		public function EquipRecycleDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			
			DistributionManager.getInstance().register(GameServiceConstants.SM_EQUIP_RECYCLE_INFO,this);//请求装备回收信息：
			DistributionManager.getInstance().register(GameServiceConstants.SM_EQUIP_RECYCLE_GET_INFO,this);//请求装备回收信息
			DistributionManager.getInstance().register(GameServiceConstants.SM_ONICE_EQUIP_RECYCLE_INFO, this);//请求装备回收信息

			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_EQUIP_RECYCLE,this);//请求装备回收信息：
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_EQUIP_RECYCLE_GET_DAILY_REWARD,this);//请求装备回收奖励：	
		}
		 
		override public function resolveData(proc:int, data:ByteArray):void 
		{
			switch(proc)
			{
				case GameServiceConstants.SM_EQUIP_RECYCLE_INFO:
					dealEquipRecycle(data);
					break;
				case GameServiceConstants.SM_ONICE_EQUIP_RECYCLE_INFO:
					handlerSM_ONICE_EQUIP_RECYCLE_INFO(data);
					break;
				case GameServiceConstants.CM_EQUIP_RECYCLE:
				 	getEecyaleEquipDatas();
				 	filterEecyaleEquipDatas();
					break;
				case GameServiceConstants.CM_EQUIP_RECYCLE_GET_DAILY_REWARD:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.EQUIPRECYCLE_PANEL_0027);
					//currentIndex++;
					break;
				case GameServiceConstants.SM_EQUIP_RECYCLE_GET_INFO:
					dealEquipRecycleGetInfo(data);
					break;
				 
			}
			super.resolveData(proc, data);
		}

		private function handlerSM_ONICE_EQUIP_RECYCLE_INFO(data:ByteArray):void
		{
//			equip_base 4字节整形，装备的baseid
//			exp 4字节整形，获取经验
//			item_id 4字节整形，获取装备石id
//			item_count 4字节整形，获取装备石个数

			var equipId:int = data.readInt();
			var exp:int = data.readInt();
			var stoneId:int = data.readInt();
			var count:int = data.readInt();
			var equipName:String = '', stoneName:String = '',msg:String = '';
			if (ConfigDataManager.instance.equipCfgData(equipId))
			{
				equipName = ConfigDataManager.instance.equipCfgData(equipId).name;
			}
			if (count && ConfigDataManager.instance.itemCfgData(stoneId))
			{
				stoneName = ConfigDataManager.instance.itemCfgData(stoneId).name;
				msg = StringUtil.substitute(StringConst.EQUIPRECYCLE_PANEL_0028, equipName, exp, stoneName, count);
			}
			else
			{
				msg = StringUtil.substitute(StringConst.EQUIPRECYCLE_PANEL_0029, equipName, exp);
			}
			
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, msg);
		}
		
		private function dealEquipRecycle(data:ByteArray):void
		{
			progress = data.readInt();   //今日积分
			getRewardCount = data.readInt();  //表示今日已领取次数
			var reincarn:int = RoleDataManager.instance.reincarn;
			var max:int = ConfigDataManager.instance.equipRecycleRwdCfgDataLength(reincarn);
			currentIndex =  getRewardCount+1 >=max?max: getRewardCount+1;
		}
		
		private function dealEquipRecycleGetInfo(data:ByteArray):void
		{
			/*if(isAllRecycle)*/
			/*awardInfo[0] += data.readInt();
			awardInfo[1] += data.readInt();
			awardInfo[2] += data.readInt();
			awardInfo[3] += data.readInt();
			awardInfo[4] += data.readInt();
			awardInfo[5] += data.readInt();*/
			awardInfo=[0,0,0];
			recycleExp=data.readInt();
			var count:int = data.readInt();
			var item_id:int,item_count:int,index:int;
			while(count--)
			{
				
				item_id = data.readInt();
				item_count = data.readInt();
				index = awardInfoId.indexOf(item_id);
				if(index!=-1)
				{
					awardInfo[index] = item_count;
				}
			}
			
			playEffect = true;
		}

		public function queryEquipRecycleIinfo():void
		{
			var byte:ByteArray = new ByteArray(); 
			byte.endian = Endian.LITTLE_ENDIAN;			 
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_EQUIP_RECYCLE_INFO,byte);
		}

		/**
		 * @param type 1 单件回收  2一键回收
		 * */
		public function requestEquipRecycle(realEquipRecycleDatas:Vector.<BagData>, type:int):void
		{
			var storagetype:int,slot:int,count:int;
			var byte:ByteArray = new ByteArray(); 
			byte.endian = Endian.LITTLE_ENDIAN;	
			if(realEquipRecycleDatas.length == 0)
				return;
			byte.writeByte(type);
			if (type == 1)
			{
				byte.writeInt(1);//数量1写死
			} else
			{
				count = realEquipRecycleDatas.length;
				byte.writeInt(count);
			}
			for each(var bagData:BagData in realEquipRecycleDatas)
			{
				byte.writeByte(bagData.storageType);
				byte.writeByte(bagData.slot);
			}
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_EQUIP_RECYCLE,byte);
		}
		
		public function equipRecycleGetDailyReward(rewardPoint:int):void
		{
			if(rewardPoint > progress)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.EQUIPRECYCLE_PANEL_0019);
				return;
			}
				
			var reincarn:int = RoleDataManager.instance.reincarn;
			var max:int = ConfigDataManager.instance.equipRecycleRwdCfgDataLength(reincarn);
			if(getRewardCount >= max)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.EQUIPRECYCLE_PANEL_0015);
				return;
			}
			var byte:ByteArray = new ByteArray(); 
			byte.endian = Endian.LITTLE_ENDIAN;	
			byte.writeInt(rewardPoint);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_EQUIP_RECYCLE_GET_DAILY_REWARD,byte);
		}
		
		public function getEecyaleEquipDatas():void
		{
			equipRecycleDatas = BagDataManager.instance.getRecycleEquipDatas();
			var getRecycleEquipDatas:Vector.<BagData> = HeroDataManager.instance.getRecycleEquipDatas();
			equipRecycleDatas = equipRecycleDatas.concat(getRecycleEquipDatas);
			
		}
		
		private var _guideTip:String;
		public function getGuideTip():String
		{
			if(!_guideTip)
			{
				var link:String = HtmlUtils.createHtmlStr(0x00ff00,StringConst.RECYCEL_EQUIP_LINK,12,false,2,FontFamily.FONT_NAME,true,"link");
				_guideTip = HtmlUtils.createHtmlStr(0xffffff,StringUtil.substitute(StringConst.RECYCEL_EQUIP_GUIDE,link),12,false,8);
			}
			
			return _guideTip;
		}
		
		private var _guideTipForHero:String;
		public function getGuideTipForHero():String
		{
			if(!_guideTipForHero)
			{
				var link:String = HtmlUtils.createHtmlStr(0x00ff00,StringConst.RECYCEL_EQUIP_LINK,12,false,2,FontFamily.FONT_NAME,true,"link");
				_guideTipForHero = HtmlUtils.createHtmlStr(0xffffff,StringUtil.substitute(StringConst.RECYCEL_EQUIP_GUIDE2,link),12,false,8);
			}
			
			return _guideTipForHero;
		}
		
		public function filterEecyaleEquipDatas():void
		{
			//soldierBtn   wizardBtn   taoistBtn   noRoleBtn
			realEquipRecycleDatas.length = 0;
			var temprealEquipRecycleDatas:Array = [];
			var soldier:Vector.<BagData>,wizard:Vector.<BagData>,taoist:Vector.<BagData>,noRole:Vector.<BagData>,flag:Boolean;
			soldier =  equipRecycleDatas.filter(filterSoldier);
			wizard = equipRecycleDatas.filter(filterWizard);
			taoist = equipRecycleDatas.filter(filterTaoist);
			//noRole = equipRecycleDatas.filter(filterFilghtPower);
			flag = selcetOption[0].flag>0?true:false;
			checkData(soldier,flag);
			flag = selcetOption[1].flag>0?true:false;
			checkData(wizard,flag);
			flag = selcetOption[2].flag >0?true:false;
			checkData(taoist,flag);
			flag = selcetOption[3].flag >0?true:false;
			if(flag){
				realEquipRecycleDatas = realEquipRecycleDatas.filter(filterFilghtPower);
				//realEquipRecycleDatas = realEquipRecycleDatas.filter(filterFilghtPower2);
			}
			realEquipRecycleDatas = realEquipRecycleDatas.filter(filterIsOperation);
			
			function filterSoldier(item:BagData,index:int,data:Vector.<BagData>):Boolean
			{
				var optionObj:Object = selcetOption[0];
				if(item.memEquipData.equipCfgData.job == optionObj.job && (optionObj.lv == 0 || optionObj.lv > item.memEquipData.equipCfgData.level))
					return true;
				else
					return false;
			}
			
			 
			function filterWizard(item:BagData,index:int,data:Vector.<BagData>):Boolean
			{
				var optionObj:Object = selcetOption[1];
				if(item.memEquipData.equipCfgData.job == optionObj.job && (optionObj.lv == 0 || optionObj.lv > item.memEquipData.equipCfgData.level))
					return true;
				else
					return false;
			}
			 
		
			function filterTaoist(item:BagData,index:int,data:Vector.<BagData>):Boolean
			{
				var optionObj:Object = selcetOption[2];
				if(item.memEquipData.equipCfgData.job == optionObj.job && (optionObj.lv == 0 || optionObj.lv > item.memEquipData.equipCfgData.level))
					return true;
				else
					return false;
			}
			
			function filterFilghtPower(item:BagData,index:int,data:Vector.<BagData>):Boolean
			{
				var selfJob:int = RoleDataManager.instance.job;
				var heroJob:int = HeroDataManager.instance.job;
				
				var selfSex:int = RoleDataManager.instance.sex;
				var heroSex:int = HeroDataManager.instance.sex;
				
				var flag:Boolean;
				var equipDatas:Vector.<EquipData> = RoleDataManager.instance.equipDatas;
				var heroDatas:Vector.<EquipData> = HeroDataManager.instance.equipDatas;
				
				if(!item.memEquipData)
				{
					return false;
				}
				
				//新加职业判断:
				/*
				1.主角和英雄为相同职业，选取主角和英雄身上相同部位战斗力最小的那件装备，低于这件装备战斗力的装备显示出来。
				2.主角和英雄为不同职业，主角和英雄根据自身职业对比，相同职业低于身上装备战斗力的装备显示出来。
				*/
				//装备都为通用所以没考虑entity
				var itemJob:int = item.memEquipData.equipCfgData.job;
				var itemType:int = item.memEquipData.equipCfgData.type;
				var itemSex:int = item.memEquipData.equipCfgData.sex;
				var itemStorage:int = item.storageType;
				var equippedFigth:int;
				var q:EquipData;
				
				if(itemJob != JobConst.TYPE_NO && itemJob!=selfJob && itemJob!=heroJob)
				{
					return true;
				}
				
				var isHigherRole:Boolean = BagDataManager.instance.isFightPowerHigher(item.memEquipData);
				var isHigherHero:Boolean = HeroDataManager.instance.isFightPowerHigher(item.memEquipData);
				
				var isRoleWear:Boolean = (itemSex == SexConst.TYPE_NO || itemSex ==  selfSex) && (itemJob == JobConst.TYPE_NO || itemJob == selfJob);//至于等级  之前的过滤应该已经判断过
				var isHeroWear:Boolean = (itemSex == SexConst.TYPE_NO || itemSex ==  heroSex) && (itemJob == JobConst.TYPE_NO || itemJob == heroJob);//至于等级 之前的过滤应该已经判断过
				
				if(isRoleWear && isHeroWear)
				{
					if(!isHigherRole && !isHigherHero)
					{
						return true;
					}
				}
				else if(isRoleWear)
				{
					if(!isHigherRole)
					{
						return true;
					}
				}
				else if(isHeroWear)
				{
					if(!isHigherHero)
					{
						return true;
					}
				}
				else
				{
					return true;
				}
				
				return false;
				
//				//特殊情况  需要判断性别
//				if(itemSex != SexConst.TYPE_NO && selfSex != heroSex)
//				{
//					if(isRoleWear)
//					{
//						if(!isHigherRole)
//						{
//							return true;
//						}
//					}
//					else(isHeroWear)
//					{
//						if(!isHigherHero)
//						{
//							return true;
//						}
//					}
//				}
//				
//				if(selfJob == heroJob || itemJob == JobConst.TYPE_NO)
//				{
//					return !isHigherRole && !isHigherHero;
//				}
//				else
//				{
//					if(itemJob == selfJob)
//					{
//						return !isHigherRole;
//					}
//					else if(itemJob == heroJob)
//					{
//						return !isHigherHero;
//					}
//					
//					return true;
//				}
			}
 
			function filterFilghtPower2(item:BagData,index:int,data:Vector.<BagData>):Boolean
			{
				var equipDatas:Vector.<EquipData> = HeroDataManager.instance.equipDatas, flag:Boolean;
				for each(var equip:EquipData in equipDatas)
				{
					if(equip.id==0)continue;
					/*var equipMem:MemEquipData=MemEquipDataManager.instance.memEquipData(equip.bornSid,equip.id);
					var equipCfg:EquipCfgData=ConfigDataManager.instance.equipCfgData(equipMem.baseId);*/
					var fight0:int = equip.memEquipData.getTotalFightPower();//  //身上
					var fight1:int = item.memEquipData.getTotalFightPower();//   //背包里		
					if(equip.memEquipData.equipCfgData.type == item.memEquipData.equipCfgData.type)
					{
						flag = fight1 > fight0?false:true;
						break;	
					}
				}
				return flag;
				
			}
			
			function filterIsOperation(item:BagData,index:int,data:Vector.<BagData>):Boolean
			{
				 
				var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(item.memEquipData.baseId);
				var equipRecycleCfgData:EquipRecycleCfgData = ConfigDataManager.instance.equipRecycleCfgData(equipCfgData.type,equipCfgData.quality,equipCfgData.level);
				
				if(equipRecycleCfgData.is_operation == 0 || equipRecycleCfgData.is_operation == 2)
					return false;
				else
					return true;
			}
			
			function checkData(data:Vector.<BagData>,flag:Boolean):void
			{
 				/*var index:int;
				for each(var item:BagData  in data)
				{
					index = realEquipRecycleDatas.indexOf(item);
					if(index == -1 && flag)
					{
						realEquipRecycleDatas.push(item);				
					}
					else if(index !=-1 && !flag)
					{
						realEquipRecycleDatas.splice(index,1);
					}	 
				} */
				//realEquipRecycleDatas   temprealEquipRecycleDatas
			 	data.forEach(fitlerData);
				function fitlerData(item:BagData, index:int, vector:Vector.<BagData>):void
				{
					var i:int = realEquipRecycleDatas.indexOf(item);
					if(i == -1 && flag)
					{
						realEquipRecycleDatas.push(item);				
					}
					else if(i !=-1 && !flag)
					{
						realEquipRecycleDatas.splice(i,1);
					}	
				} 
				/*temprealEquipRecycleDatas.sortOn(["job","sex","level","totalFightPower"],[Array.,Array.NUMERIC,Array.NUMERIC,Array.NUMERIC]);
				temprealEquipRecycleDatas.forEach(pushfun);
				function pushfun(item:BagData,index:int, arr:Array):void
				{
					var i:int = realEquipRecycleDatas.indexOf(item);
					if(i == -1)
						realEquipRecycleDatas.push(item);
				}*/
			}
			
			if(realEquipRecycleDatas.length)
			{
				selectData = realEquipRecycleDatas[0];
			}
			else
			{
				selectData = null;
			}
		}
		public function setSelectData(id:int):void
		{
			var bagData:BagData;
			if(selectData && selectData.id == id)
				return;				
			for each(bagData in realEquipRecycleDatas)
			{
				if(bagData.id == id)
				{
					selectData = bagData;
					break;
				}
			}
		}
		
		public function reset():void
		{
			selcetOption = [{flag:1,lv:0,job:1},{flag:1,lv:0,job:2},{flag:1,lv:0,job:3},{flag:1,lv:-1,job:0}];
			isAllRecycle = false;
			currentIndex = 0;
			getRewardCount = 0;
			if(equipRecycleDatas)
			{
				equipRecycleDatas.length = 0;
			}
			realEquipRecycleDatas.length = 0;
			progress = 0;
			currentIndex = 0;
			awardInfo = [0,0,0];
			selectData = null;

//			oneKeyRecycle = false;//是否一键回收
			playEffect = false;//开始播放动画
//			totalExpShow = false;//
		}

		/**重新设置播放动画*/
		public function resetPlay():void
		{
//			EquipRecycleDataManager.oneKeyRecycle = false;
			EquipRecycleDataManager.playEffect = false;
		}

		public function getTotalExp():int
		{
			var total:int = 0;
			if (realEquipRecycleDatas && realEquipRecycleDatas.length)
			{
				var reincarn:int = RoleDataManager.instance.reincarn;
				var max:int = ConfigDataManager.instance.equipRecycleRwdCfgDataMax(reincarn).reward_point;
				var num:int = EquipRecycleDataManager.instance.progress;
				for each(var bagData:BagData in realEquipRecycleDatas)
				{
					var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(bagData.bornSid, bagData.id);
					var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
					var equipRecycleCfgData:EquipRecycleCfgData = ConfigDataManager.instance.equipRecycleCfgData(equipCfgData.type, equipCfgData.quality, equipCfgData.level);
					var exp:int;
					if (equipRecycleCfgData)
					{
						exp = equipRecycleCfgData.exp;
						if ((equipRecycleCfgData.exp + num) >= max)
						{
							exp = max - num;
						}
					}
					total += exp;
				}
			}
			return total;
		}
	}
}
class PrivateClass{}