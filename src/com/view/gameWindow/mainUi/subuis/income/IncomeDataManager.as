package com.view.gameWindow.mainUi.subuis.income
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.consts.ItemType;
    import com.model.consts.SlotType;
    import com.model.consts.StringConst;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.panel.panels.guardSystem.BenefitType;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.UtilGetCfgData;
    
    import flash.utils.ByteArray;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;

    /**
	 * 收益信息数据控制类
	 * @author Administrator
	 */	
	public class IncomeDataManager extends DataManagerBase
	{
		private static var _instance:IncomeDataManager;
		public static function get instance():IncomeDataManager
		{
			if(!_instance)
			{
				_instance = new IncomeDataManager(new PrivateClass());
			}
			return _instance;
		}
		
		private var _isAddOne:Boolean;
		public function get isAddOne():Boolean
		{
			var _isAddOne2:Boolean = _isAddOne;
			_isAddOne = false;
			return _isAddOne2;
		}
		private const MAX_LENGTH:int = 30;
		public var infos:Vector.<String>;
		public var lineNum:int;
		
		private var _listShow:Vector.<String>;

		private var _timeId:uint;
		
		public function IncomeDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			infos = new Vector.<String>();
			DistributionManager.getInstance().register(GameServiceConstants.SM_GAIN_INFO,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_GAIN_ITEM_INFO,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_HERO_GAIN_INFO,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_EXP_YU_GAIN_INFO,this);
		}
		
		public function clearInstance():void
		{
			_instance = null;
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_HERO_GAIN_INFO:
					readHeroGainDat(data);
					break;
				case GameServiceConstants.SM_GAIN_INFO:
					readGainData(data);
					break;
				case GameServiceConstants.SM_GAIN_ITEM_INFO:
					readGainItemData(data);
					break;
				case GameServiceConstants.SM_EXP_YU_GAIN_INFO:
					readExpYuGainData(data);
					break; 
				default:
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function readHeroGainDat(data:ByteArray):void
		{
			var exp:int = data.readInt();//经验的增长
			var benefitType:int = /*data.readByte()*/1;//防沉迷类型，具体参见BenefitType上面定义的常量
			var isMstExp:int = /*data.readByte()*/0;//exp类型
			lineNum = 1;
			var str:String;
			if(exp)
			{
				if (exp > 0)
				{
					str = int(exp*BenefitType.proportion(benefitType)) +" " + StringConst.INCOME_0002;
					lineNum += 1;
					addLine(HtmlUtils.createHtmlStr(0x00ff00,StringConst.ENTITY_TYPE_HERO + StringConst.INCOME_0001),str,0x00ff00,benefitType,false,null,null,!isMstExp);
				} 
				else if (exp < 0)
				{
					exp = -exp;
					str = int(exp * BenefitType.proportion(benefitType)) + " " + StringConst.INCOME_0002;
					lineNum += 1;
					addLine(HtmlUtils.createHtmlStr(0xff0000, StringConst.ENTITY_TYPE_HERO + StringConst.INCOME_0013), str, 0xff0000, benefitType);
				}
			}
		}
		
		private function readExpYuGainData(data:ByteArray):void
		{
			var exp:int = data.readInt();//经验玉的经验增长
			var str:String;
			str = exp + " " + StringConst.INCOME_0014;
			addLine(HtmlUtils.createHtmlStr(0x00ff00,StringConst.INCOME_0001),str,0x00ff00,BenefitType.BT_NORMAL,false,["VIP"],[HtmlUtils.createHtmlStr(0xffcc00,"VIP",12,false,2,"SimSun",true)],false);
		}
		
		private function readGainItemData(data:ByteArray):void
		{
			var size:int = data.readInt();
			var name:String;
			lineNum = 1;
			while(size--)
			{
				var color:uint;
				var str:String;
				var utilGetCfg:UtilGetCfgData = new UtilGetCfgData();
				var type:int = data.readByte();//类型
				var id:int = data.readInt();
				var count:int = data.readInt();//数量
				if(type == SlotType.IT_ITEM)
				{
					if(utilGetCfg.GetItemCfgData(id).type == ItemType.IT_EXP || utilGetCfg.GetItemCfgData(id).type == ItemType.IT_MONEY || utilGetCfg.GetItemCfgData(id).type ==ItemType.IT_MONEY_BIND || utilGetCfg.GetItemCfgData(id).type ==ItemType.IT_GOLD || utilGetCfg.GetItemCfgData(id).type ==ItemType.IT_GOLD_BIND)
					{
						continue;
					}
					name = utilGetCfg.GetItemCfgData(id).name;
					str = name + "*" + count;
					lineNum += 1;
					color = ItemType.getColorByQuality(utilGetCfg.GetItemCfgData(id).quality);
					addLine(HtmlUtils.createHtmlStr(0x00ff00,StringConst.INCOME_0001),str,color,BenefitType.BT_NORMAL,true,null,null,false);
				}
				else if(type == SlotType.IT_EQUIP)
				{
					name = utilGetCfg.GetEquipCfgData(id).name;
					str = name + "*" + count;
					lineNum += 1;
					color = ItemType.getColorByQuality(utilGetCfg.GetEquipCfgData(id).color);
					addLine(HtmlUtils.createHtmlStr(0x00ff00,StringConst.INCOME_0001),str,color,BenefitType.BT_NORMAL,true,null,null,false);
				}
			}
		}
		
		private function readGainData(data:ByteArray):void
		{
			var exp:int = data.readInt();//经验的增长
			var bindCoin:int = data.readInt();//绑定金币的增长
			var unbindCoin:int = data.readInt();//非绑定金币的增长
			var bindGold:int = data.readInt();//绑定元宝的增长
			var unbindGold:int = data.readInt();//非绑定元宝的增长
			var roleEnergy:int = data.readInt();//玩家活力值
			var heroEnergy:int = data.readInt();//英雄活力值
			var benefitType:int = data.readByte();//防沉迷类型，具体参见BenefitType上面定义的常量
			var vipAddExp:int = data.readInt();//Vip额外所增加的经验
			var vipAddBindGold:int = data.readInt();//Vip额外所增加的绑定元宝
			var worldLvAddExp:int = data.readInt();//世界等级加成的经验
			var gongxun:int = data.readInt();//功勋
			var hlzl:int = data.readInt();//火龙之心
			var amz:int = data.readInt();//爱慕值
			var bpgx:int = data.readInt();//帮派贡献
			var sdzl:int = data.readInt();//神盾之力
			var isMstExp:int = data.readByte();//exp类型
			lineNum = 1;
			/*trace("IncomeDataManager.readGainData exp:"+exp+",bindCoin:"+bindCoin+",unbindCoin:"+unbindCoin+",bindGold:"+bindGold+",unbindGold:"+unbindGold+",benefitType:"+benefitType);*/
			var str:String;
			if(exp)
			{
				if(worldLvAddExp!=0)
				{
					str = int(exp*BenefitType.proportion(benefitType)) +" " + StringConst.INCOME_0002 + 
						" " + StringConst.INCOME_0016.replace("XX",int(vipAddExp*BenefitType.proportion(benefitType)))
						+" " + StringConst.INCOME_0015.replace("YY",int(worldLvAddExp*BenefitType.proportion(benefitType)));
					lineNum += 1;
					var replace:Array = ["VIP","世界等级"];
					var toArray:Array = [HtmlUtils.createHtmlStr(0xffcc00,"VIP",12,false,2,"SimSun",true),HtmlUtils.createHtmlStr(0xffcc00,"世界等级",12,false,2,"SimSun",true)];
					addLine(HtmlUtils.createHtmlStr(0x00ff00,StringConst.INCOME_0001),str,0x00ff00,benefitType,false,replace,toArray,!isMstExp);
				}
				else
				{
					if(vipAddExp != 0)
					{
						str = int(exp*BenefitType.proportion(benefitType)) +" " + StringConst.INCOME_0002 + " " 
							+ StringConst.INCOME_0010.replace("XX",int(vipAddExp*BenefitType.proportion(benefitType)));
						lineNum += 1;
						replace = ["VIP"];
						toArray = [HtmlUtils.createHtmlStr(0xffcc00,"VIP",12,false,2,"SimSun",true)];
						addLine(HtmlUtils.createHtmlStr(0x00ff00,StringConst.INCOME_0001),str,0x00ff00,benefitType,false,replace,toArray,!isMstExp);
					}
					else
					{
						str = int(exp*BenefitType.proportion(benefitType)) +" " + StringConst.INCOME_0002;
						lineNum += 1;
						addLine(HtmlUtils.createHtmlStr(0x00ff00,StringConst.INCOME_0001),str,0x00ff00,benefitType,false,null,null,!isMstExp);
					}
				}
			}
			if (bindCoin > 0)
			{
				str = int(bindCoin*BenefitType.proportion(benefitType)) +" " + StringConst.INCOME_0003;
				lineNum += 1;
				addLine(HtmlUtils.createHtmlStr(0xffcc00,StringConst.INCOME_0001),str,0xffcc00,benefitType);
			} 
			else if (bindCoin < 0)
			{
				bindCoin = -bindCoin;
				str = int(bindCoin * BenefitType.proportion(benefitType)) + " " + StringConst.INCOME_0003;
				lineNum += 1;
				addLine(HtmlUtils.createHtmlStr(0xff0000, StringConst.INCOME_0013), str, 0xff0000, benefitType);
			}
			if (unbindCoin > 0)
			{
				str = int(unbindCoin*BenefitType.proportion(benefitType)) + " " + StringConst.INCOME_0004;
				lineNum += 1;
				addLine(HtmlUtils.createHtmlStr(0xffcc00,StringConst.INCOME_0001),str,0xffcc00,benefitType);
			} 
			else if (unbindCoin < 0)
			{
				unbindCoin = -unbindCoin;
				str = int(unbindCoin * BenefitType.proportion(benefitType)) + " " + StringConst.INCOME_0004;
				lineNum += 1;
				addLine(HtmlUtils.createHtmlStr(0xff0000, StringConst.INCOME_0013), str, 0xff0000, benefitType);
			}
			if (bindGold > 0)
			{
				var strVipAdd:String = vipAddBindGold ? " " + StringConst.INCOME_0010.replace("XX",int(vipAddBindGold*BenefitType.proportion(benefitType))) : "";
				str = int(bindGold*BenefitType.proportion(benefitType)) + " " + StringConst.INCOME_0005 + strVipAdd;
				lineNum += 1;
				replace = vipAddBindGold ? ["VIP"] : null;
				toArray = vipAddBindGold ? [HtmlUtils.createHtmlStr(0xffcc00,"VIP",12,false,2,"SimSun",true)] : null;
				addLine(HtmlUtils.createHtmlStr(0xe616b6,StringConst.INCOME_0001),str,0xe616b6,benefitType,false,replace,toArray);
			} 
			else if (bindGold < 0)
			{
				bindGold = -bindGold;
				str = int(bindGold * BenefitType.proportion(benefitType)) + " " + StringConst.INCOME_0005;
				lineNum += 1;
				addLine(HtmlUtils.createHtmlStr(0xff0000, StringConst.INCOME_0013), str, 0xff0000, benefitType);
			}
			if (unbindGold > 0)
			{
				str = int(unbindGold*BenefitType.proportion(benefitType)) + " " + StringConst.INCOME_0006;
				lineNum += 1;
				addLine(HtmlUtils.createHtmlStr(0xe616b6,StringConst.INCOME_0001),str,0xe616b6,benefitType);
			} 
			else if (unbindGold < 0)
			{
				unbindGold = -unbindGold;
				str = int(unbindGold * BenefitType.proportion(benefitType)) + " " + StringConst.INCOME_0006;
				lineNum += 1;
				addLine(HtmlUtils.createHtmlStr(0xff0000, StringConst.INCOME_0013), str, 0xff0000, benefitType);
			}
			if(roleEnergy)
			{
				str = int(roleEnergy*BenefitType.proportion(benefitType)) +" " + StringConst.INCOME_0011;
				lineNum += 1;
				addLine(HtmlUtils.createHtmlStr(0x00ff00,StringConst.INCOME_0001),str,0x00ff00,benefitType);
			}
			if(heroEnergy)
			{
				str =  int(heroEnergy*BenefitType.proportion(benefitType)) + " " + StringConst.INCOME_0012;
				lineNum += 1;
				addLine(HtmlUtils.createHtmlStr(0x00ff00,StringConst.INCOME_0001),str,0x00ff00,benefitType);
			}
			
			if(gongxun > 0)
			{
				str =  int(gongxun*BenefitType.proportion(benefitType)) + " " + StringConst.INCOME_0017;
				lineNum += 1;
				addLine(HtmlUtils.createHtmlStr(0x00ff00,StringConst.INCOME_0001),str,0x00ff00,benefitType);
			}
			else if(gongxun < 0)
			{
				gongxun = -gongxun;
				str = int(gongxun * BenefitType.proportion(benefitType)) + " " + StringConst.INCOME_0017;
				lineNum += 1;
				addLine(HtmlUtils.createHtmlStr(0xff0000, StringConst.INCOME_0013), str, 0xff0000, benefitType);
			}
			
			if(hlzl > 0)
			{
				str =  int(hlzl*BenefitType.proportion(benefitType)) + " " + StringConst.INCOME_0018;
				lineNum += 1;
				addLine(HtmlUtils.createHtmlStr(0x00ff00,StringConst.INCOME_0001),str,0x00ff00,benefitType);
			}
			else if(hlzl < 0)
			{
				hlzl = -hlzl;
				str = int(hlzl * BenefitType.proportion(benefitType)) + " " + StringConst.INCOME_0018;
				lineNum += 1;
				addLine(HtmlUtils.createHtmlStr(0xff0000, StringConst.INCOME_0013), str, 0xff0000, benefitType);
			}
			
			if(amz > 0)
			{
				str =  int(amz*BenefitType.proportion(benefitType)) + " " + StringConst.INCOME_0019;
				lineNum += 1;
				addLine(HtmlUtils.createHtmlStr(0x00ff00,StringConst.INCOME_0001),str,0x00ff00,benefitType);
			}
			else if(amz < 0)
			{
				amz = -amz;
				str = int(amz * BenefitType.proportion(benefitType)) + " " + StringConst.INCOME_0019;
				lineNum += 1;
				addLine(HtmlUtils.createHtmlStr(0xff0000, StringConst.INCOME_0013), str, 0xff0000, benefitType);
			}
			
			if(bpgx > 0)
			{
				str =  int(bpgx*BenefitType.proportion(benefitType)) + " " + StringConst.INCOME_0020;
				lineNum += 1;
				addLine(HtmlUtils.createHtmlStr(0x00ff00,StringConst.INCOME_0001),str,0x00ff00,benefitType);
			}
			else if(bpgx < 0)
			{
				bpgx = -bpgx;
				str = int(bpgx * BenefitType.proportion(benefitType)) + " " + StringConst.INCOME_0020;
				lineNum += 1;
				addLine(HtmlUtils.createHtmlStr(0xff0000, StringConst.INCOME_0013), str, 0xff0000, benefitType);
			}
			
			if(sdzl > 0)
			{
				str =  int(sdzl*BenefitType.proportion(benefitType)) + " " + StringConst.INCOME_0021;
				lineNum += 1;
				addLine(HtmlUtils.createHtmlStr(0x00ff00,StringConst.INCOME_0001),str,0x00ff00,benefitType);
			}
			else if(sdzl < 0)
			{
				sdzl = -sdzl;
				str = int(sdzl * BenefitType.proportion(benefitType)) + " " + StringConst.INCOME_0021;
				lineNum += 1;
				addLine(HtmlUtils.createHtmlStr(0xff0000, StringConst.INCOME_0013), str, 0xff0000, benefitType);
			}
		}
		
		private function addLine(headStr:String,str:String,color:uint,benefitType:int,underLine:Boolean = false,replace:Array =null,to:Array =null,isRollTipRewardShow:Boolean = true):void
		{
			if(benefitType == BenefitType.BT_TIRED)
			{
				str += StringConst.INCOME_0007;
			}
			else if(benefitType == BenefitType.BT_HURT)
			{
				str += StringConst.INCOME_0008;
			}
			str = HtmlUtils.createHtmlStr(color,str,12,false,2,"SimSun",underLine);
			if(replace&&replace.length)
			{
				for(var i:int = 0;i<replace.length;i++)
				{
					str = str.replace(replace[i],to[i]);
				}
			}
			var info:String = headStr + " " + str;
			infos.push(info);
			_isAddOne = true;
			if(infos.length >= MAX_LENGTH)
			{
				infos.shift();
			}
			//
			if(isRollTipRewardShow)
			{
				showRewardTips(info);
			}
		}
		
		private function showRewardTips(info:String):void
		{
			if(!_listShow)
			{
				_listShow = new Vector.<String>();
			}
			_listShow.push(info);
			if(_timeId)
			{
				return;
			}
			_timeId = setTimeout(onTimer,500);
		}
		
		private function onTimer():void
		{
			clearTimeout(_timeId);
			_timeId = 0;
			RollTipMediator.instance.showRollTip(RollTipType.REWARD,_listShow.shift());
			if(_listShow.length)
			{
				_timeId = setTimeout(onTimer,500);
			}
		}
		
		public function addOneLine(lineStr:String):void
		{
			lineStr = HtmlUtils.createHtmlStr(0x00ff00,lineStr);
			infos.push(lineStr);
			_isAddOne = true;
			if(infos.length >= MAX_LENGTH)
			{
				infos.shift();
			}
			notify(0);
		}
	}
}
class PrivateClass{}