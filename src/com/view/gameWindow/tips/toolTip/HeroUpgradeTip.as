package com.view.gameWindow.tips.toolTip
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.HeroEquipUpgradeCfgData;
	import com.model.configData.cfgdata.HeroMeridiansCfgData;
	import com.model.configData.cfgdata.JointHaloCfgData;
	import com.model.configData.cfgdata.VipCfgData;
	import com.model.consts.JobConst;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.hejiSkill.HejiSkillDataManager;
	import com.view.gameWindow.panel.panels.hejiSkill.tabHejiBuff.JointHaloData;
	import com.view.gameWindow.panel.panels.hero.ConditionConst;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.hero.tab1.equip.activate.HeroEquipActivateData;
	import com.view.gameWindow.panel.panels.hero.tab2.HeroUpgradeData;
	import com.view.gameWindow.panel.panels.position.PositionDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
	import com.view.gameWindow.panel.panels.trans.ReawardData;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import mx.utils.StringUtil;

	public class HeroUpgradeTip extends BaseTip
	{
		public function HeroUpgradeTip()
		{
			super();
			_skin = new BigTextTipSkin();
			addChild(_skin);
			initView(_skin);
		}
		
		override public function setData(obj:Object):void
		{
			_data=obj;
			var heroMeridiansCfg:HeroMeridiansCfgData=obj as HeroMeridiansCfgData;
			var heroUpgradeData:HeroUpgradeData = HeroDataManager.instance.heroUpgradeData;
			var title:String=HtmlUtils.createHtmlStr(0xff6600,StringUtil.substitute(StringConst.HERO_UPGRADE_1005,heroUpgradeData.grade,heroMeridiansCfg.meridians_level));
			addProperty(title,19,10);
			maxHeight=44;
			
			 var attr:String="";
			 if(heroMeridiansCfg==null)return;
			 var job:int = HeroDataManager.instance.job;
			 if(job==JobConst.TYPE_ZS)
			 {
				 attr=heroMeridiansCfg.soldier_attr;
			 }else if(job==JobConst.TYPE_FS)
			 {
				 attr=heroMeridiansCfg.mage_attr;
			 }else
			 {
				 attr=heroMeridiansCfg.taolist_attr;
			 }
			 var attrs:Vector.<String>= CfgDataParse.getAttHtmlStringArray(attr,4);
			 attr="";
			 for each(var tt:String in attrs)
			 {
				 attr+=tt+"<font color='#00ff00'>  <b>"+StringConst.TIP_UP+"</b></font>\n";
				 maxHeight+=19.2;
			 }
			 attr=HtmlUtils.createHtmlStr(0xffffff,attr,12,false,4);
			 addProperty(attr,19,44);
			 width=200;
			 maxHeight+=8;
			 height=maxHeight;
			 if(heroUpgradeData.meridians>=heroMeridiansCfg.meridians_level)return;
			 var line:DelimiterLine = addSplitLine(19,maxHeight-4);
			 line.width=width-19*2;
			 addProperty(HtmlUtils.createHtmlStr(0xffcc00,StringConst.HERO_UPGRADE_1006),19,maxHeight);
			 maxHeight+=19;
			 checkEquip(heroMeridiansCfg);
			 checkPosition(heroMeridiansCfg);
			 checkBuffer(heroMeridiansCfg);
			 checkDuiJie(heroMeridiansCfg);
			 checkExp(heroMeridiansCfg);
			 setRate(heroMeridiansCfg);
			 height=maxHeight+8;
		}
		
		private function setRate(heroMeridiansCfg:HeroMeridiansCfgData):void
		{
			var vipCfgData:VipCfgData = ConfigDataManager.instance.vipCfgData(VipDataManager.instance.lv);
			var vipRate:int=0;
			if(vipCfgData!=null)
			{
				vipRate=vipCfgData.add_hero_grade_rate;
			}
			var rateStr:String=StringUtil.substitute(StringConst.HERO_UPGRADE_1012,"<font color='#00ff00'>"+(heroMeridiansCfg.rate+vipRate)+"</font>",vipRate);
			addProperty(HtmlUtils.createHtmlStr(0xffcc00,rateStr),19,maxHeight);
			maxHeight+=19;
		}
		
		private function checkExp(heroMeridiansCfg:HeroMeridiansCfgData):void
		{
			var equipStr:String ="";
			var isCompled:Boolean=HeroDataManager.instance.heroUpgradeData.exp>=heroMeridiansCfg.cost_hero_exp;
			if(isCompled)
			{
				equipStr= StringConst.HERO_UPGRADE_1011+"<font color='#00ff00'>"+heroMeridiansCfg.cost_hero_exp+"</font>";
			}else
			{
				equipStr=StringConst.HERO_UPGRADE_1011+"<font color='#ff0000'>"+heroMeridiansCfg.cost_hero_exp+"</font>";
			}
			addProperty(HtmlUtils.createHtmlStr(0xffcc00,equipStr),19,maxHeight);
			maxHeight+=19;
		}
		
		private function checkBuffer(heroMeridiansCfg:HeroMeridiansCfgData):void
		{
			if(heroMeridiansCfg.bi_condition==ConditionConst.BUFFER)
			{
				var split:Array = heroMeridiansCfg.bi_request.split(":");
				var jointHaloCfgData:JointHaloCfgData = ConfigDataManager.instance.jointHaloCfgData(split[0],split[1]);
				var buffArr:Array = HejiSkillDataManager.instance.buffArr;
				var item:JointHaloData = buffArr[split[0]-1] as JointHaloData;
				var isCompled:Boolean = item!==null&&item.level>=int(split[1]);
				
				var equipStr:String ="";
				if(isCompled)
				{
					equipStr= StringUtil.substitute(StringConst.HERO_UPGRADE_1009,"<font color='#00ff00'>"+jointHaloCfgData.des+split[1]+"</font>");
				}else
				{
					equipStr= StringUtil.substitute(StringConst.HERO_UPGRADE_1009,"<font color='#ff0000'>"+jointHaloCfgData.des+split[1]+"</font>");
				}
				addProperty(HtmlUtils.createHtmlStr(0xffcc00,equipStr),19,maxHeight);
				maxHeight+=19;
			}
		}
		
		private function checkDuiJie(heroMeridiansCfg:HeroMeridiansCfgData):void
		{
			if(heroMeridiansCfg.bi_condition==ConditionConst.DUIJIE)
			{
				var id:int =int( heroMeridiansCfg.bi_request);
				var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(id);
				var item:EquipData= HeroDataManager.instance.equipDatas[ConstEquipCell.TYPE_HUANJIE];
				var isCompled:Boolean = 	item.id>=id;
				if(equipCfgData!=null)
				{
					var equipStr:String ="";
					if(isCompled)
					{
						equipStr= StringConst.HERO_UPGRADE_1010+"<font color='#00ff00'>"+equipCfgData.name+"</font>";
					}else
					{
						equipStr= StringConst.HERO_UPGRADE_1010+"<font color='#ff0000'>"+equipCfgData.name+"</font>";
					}
					addProperty(HtmlUtils.createHtmlStr(0xffcc00,equipStr),19,maxHeight);
					maxHeight+=19;
				}
			}
		}
		
		private function checkPosition(heroMeridiansCfg:HeroMeridiansCfgData):void
		{
			if(heroMeridiansCfg.bi_condition==ConditionConst.CHOP)
			{
				var id:int = int(heroMeridiansCfg.bi_request);
				var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(id);
				var isCompled:Boolean = PositionDataManager.instance.hero_chopid>=id;
				if(equipCfgData!=null)
				{
					var equipStr:String ="";
					if(isCompled)
					{
						equipStr= StringConst.HERO_UPGRADE_1008+"<font color='#00ff00'>"+equipCfgData.name+"</font>";
					}else
					{
						equipStr= StringConst.HERO_UPGRADE_1008+"<font color='#ff0000'>"+equipCfgData.name+"</font>";
					}
					addProperty(HtmlUtils.createHtmlStr(0xffcc00,equipStr),19,maxHeight);
					maxHeight+=19;
				}
			}
		}
		
		private function checkEquip(heroMeridiansCfg:HeroMeridiansCfgData):void
		{
			if(heroMeridiansCfg.bi_condition==ConditionConst.EQUIP)
			{
//				var split:Array = heroMeridiansCfg.bi_request.split(":");
//				var heroEquipUpgradeCfgData:HeroEquipUpgradeCfgData = ConfigDataManager.instance.heroEquipUpgradeCfgData(split[0],split[1]);
				var heroActivateData:HeroEquipActivateData = HeroDataManager.instance.heroActivateData;
//				var isCompled:Boolean = heroActivateData.grade>=int(split[0])&&heroActivateData.order>int(split[1]);
				
				var itemStr:String =heroMeridiansCfg.bi_equip ;
				var itemArr:Array = itemStr.split("|");
				var picData:ReawardData;
				for each(var str:String in itemArr)
				{
					var strArr:Array = str.split(":");
					var rewardData:ReawardData = new ReawardData();
					rewardData.type = strArr[1];
					rewardData.id = strArr[0];
					rewardData.count = strArr[2];
					if(rewardData.type == SlotType.IT_EQUIP)
					{
						if(ConfigDataManager.instance.equipCfgData(rewardData.id).sex == 0 || HeroDataManager.instance.sex == ConfigDataManager.instance.equipCfgData(rewardData.id).sex)
						{
							if(ConfigDataManager.instance.equipCfgData(rewardData.id).job == 0 || HeroDataManager.instance.job == ConfigDataManager.instance.equipCfgData(rewardData.id).job)
							{
								picData=rewardData;	
							}
						}
					}
				}
				
				if(picData!=null)
				{
					var equipCfgData:EquipCfgData=ConfigDataManager.instance.equipCfgData(picData.id);
					var equipStr:String ="";
					var isCompled:Boolean = HeroDataManager.instance.checkEquuiplvByType(equipCfgData.type,equipCfgData.level);
					if(isCompled)
					{
						equipStr= StringConst.HERO_UPGRADE_1007+"<font color='#00ff00'>"+equipCfgData.name+"</font>";
					}else
					{
						equipStr= StringConst.HERO_UPGRADE_1007+"<font color='#ff0000'>"+equipCfgData.name+"</font>";
					}
					addProperty(HtmlUtils.createHtmlStr(0xffcc00,equipStr),19,maxHeight);
					maxHeight+=19;
				}
			}
		}		
	}
}