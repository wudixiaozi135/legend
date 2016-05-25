package com.view.gameWindow.tips.toolTip
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.JointHaloCfgData;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hejiSkill.HejiSkillDataManager;
	import com.view.gameWindow.panel.panels.hejiSkill.tabHejiBuff.JointHaloData;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.skill.SkillData;
	import com.view.gameWindow.panel.panels.skill.SkillDataManager;
	import com.view.gameWindow.panel.panels.skill.constants.SkillConstants;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingData;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingDataManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.TimeUtils;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * @author wqhk
	 * 2014-9-12
	 */
	public class SkillToolTip extends BaseTip
	{
		public static const NAME_X:int = 90;
		public static const PROPERTY_X:int = 18;
		public static const S_LINE_X:int = 13;
		public static const NAME_Y:int = 25;
		public static const GAP_L:int = 9;
		public static const GAP_S:int = 2;
		
		private static var TYPE_LIST:Array;
		private static var TARGET_TYPE:Array;
		
		public function SkillToolTip()
		{
			super();
			initView(null);
			
			TYPE_LIST = ["",StringConst.TIP_SKILL_TYPE1,
							StringConst.TIP_SKILL_TYPE2,
							StringConst.TIP_SKILL_TYPE3,
							StringConst.TIP_SKILL_TYPE4];
			TARGET_TYPE = ["",
							StringConst.TIP_SKILL_TARGET_TYPE1,
							StringConst.TIP_SKILL_TARGET_TYPE2,
							StringConst.TIP_SKILL_TARGET_TYPE3,
							"",
							StringConst.TIP_SKILL_TARGET_TYPE4,
							StringConst.TIP_SKILL_TARGET_TYPE4,
							StringConst.TIP_SKILL_TARGET_TYPE4];
		}
		
		override public function initView(mc:MovieClip):void
		{
			if(!mc)
			{
				_skin = new PropTipSkin();
				addChildAt(_skin,0);
				mc = _skin
			}
			super.initView(mc);
		}
		
		override public function setData(obj:Object):void
		{
			_data = obj;
			parseCfgData(_data as SkillCfgData);
		}
		
		
		
		private function parseCfgData(data:SkillCfgData):void
		{
			if(!data)
			{
				return;
			}
			
			var skillData:SkillData = SkillDataManager.instance.skillData(data.group_id);
			
			var nextData:SkillCfgData;
		
			var isStudy:Boolean;
			
			if(!skillData || skillData.level == 0)
			{
				isStudy = false;
				nextData = data;
			}
			else
			{
				isStudy = true;
				nextData = SkillDataManager.instance.getNextSkillCfgData(data);
			}
			
			parseSelf(isStudy,data,nextData);
			
			if(nextData)
			{
				maxHeight += GAP_S;
				addSplitLine(S_LINE_X,maxHeight+4);
				maxHeight += GAP_L;
				
				parseNext(isStudy,data,nextData);
			}
			else
			{
				maxHeight += GAP_S*4;
			}
			maxHeight += GAP_S*2;
			
			height = maxHeight;
		}
		
		
		protected function parseSelf(isStudy:Boolean,data:SkillCfgData,nextData:SkillCfgData):void
		{
			var timeObj:Object;
			var timeClock:String;
			loadPic(ResourcePathConstants.IMAGE_ICON_SKILL_FOLDER_LOAD+data.icon+ResourcePathConstants.POSTFIX_PNG);
			
			maxHeight = NAME_Y;
			var txt:TextField;
			
			//name
			txt = addProperty(HtmlUtils.createHtmlStr(/*ItemType.getColorByQuality(2)*/0x00b0f0,data.name,15,true),NAME_X,maxHeight);
			maxHeight += txt.textHeight + GAP_L;
			
			//type
			txt = addProperty(HtmlUtils.createHtmlStr(0x00f7f7,TYPE_LIST[data.type]),NAME_X,maxHeight);
			maxHeight += txt.textHeight + GAP_L*2;	
			
			maxHeight += GAP_S;
			addSplitLine(S_LINE_X,maxHeight);
			maxHeight += GAP_L;
			if(isStudy)
			{
				//lv
				txt = addProperty(HtmlUtils.createHtmlStr(0xb4b4b4,StringConst.TIP_SKILL_LV+StringConst.COLON)+
					HtmlUtils.createHtmlStr(0xb4b4b4,isStudy?data.level+(nextData ?"":StringConst.TIP_FULL_LV):StringConst.TIP_SKILL_STUDY_NOT),PROPERTY_X,maxHeight);
				maxHeight += txt.textHeight;
				//mpClost
				if(data.mp_cost > 0)
				{
					var isMpEnough:Boolean = SkillDataManager.instance.checkSkillMpCost(data);
					var color:int = isMpEnough ? 0xbfbfbf : 0xff0000;
					maxHeight += GAP_S;
					txt = addProperty(HtmlUtils.createHtmlStr(color,StringConst.TIP_COST_MAGIC+StringConst.COLON+data.mp_cost),PROPERTY_X,maxHeight);
					maxHeight += txt.textHeight;
				}	
				//cd
				if(data.cd>0)
				{
					maxHeight += GAP_S;
					timeObj = TimeUtils.calcTime(data.cd/1000);
					timeClock = TimeUtils.formatS(timeObj);
					txt = addProperty(HtmlUtils.createHtmlStr(0xb4b4b4,StringConst.TIP_CD+StringConst.COLON+timeClock),PROPERTY_X,maxHeight);
					maxHeight += txt.textHeight;
				}
				
				//属性加成 待定				
				//target_type
				maxHeight += GAP_S;
				txt = addProperty(HtmlUtils.createHtmlStr(0xb4b4b4,StringConst.TIP_SKILL_TYPE+StringConst.COLON+TARGET_TYPE[data.range]),PROPERTY_X,maxHeight);
				maxHeight += txt.textHeight;
				
				//des
				maxHeight -= 9;
				addDes(data.post_desc);
			}
			else
			{
				maxHeight -= 12;
				//des
				addDes(data.pre_desc);
				maxHeight += GAP_S+2;
				addSplitLine(S_LINE_X,maxHeight+5);
				maxHeight += GAP_L+2;
				
				//lv
				txt = addProperty(HtmlUtils.createHtmlStr(0xb4b4b4,StringConst.TIP_SKILL_LV+StringConst.COLON)+
					HtmlUtils.createHtmlStr(0xb4b4b4,(data.ring_level||data.joint_halo_level)?StringConst.TIP_SKILL_JIHUO_NOT:StringConst.TIP_SKILL_STUDY_NOT),PROPERTY_X,maxHeight);
				maxHeight += txt.textHeight;
				//cd
				if(data.cd>0)
				{
					maxHeight += GAP_S;
					timeObj = TimeUtils.calcTime(data.cd/1000);
					timeClock = TimeUtils.formatS(timeObj);
					txt = addProperty(HtmlUtils.createHtmlStr(0xb4b4b4,StringConst.TIP_CD+StringConst.COLON+timeClock),PROPERTY_X,maxHeight);
					maxHeight += txt.textHeight;
				}
			}
		}
		
		protected function parseNext(isStudy:Boolean,data:SkillCfgData,nextData:SkillCfgData):void
		{
			var txt:TextField = new TextField();
			txt = addProperty(HtmlUtils.createHtmlStr(0xffc000,StringConst.TIP_NEXT_LV +　nextData.level),PROPERTY_X,maxHeight);
			maxHeight += txt.textHeight;
			
			//player lv
			var roleReincarn:int = SkillDataManager.instance.entity_type == SkillConstants.TYPE_ROLE?RoleDataManager.instance.reincarn:HeroDataManager.instance.grade;
			var roleLv:int = SkillDataManager.instance.entity_type == SkillConstants.TYPE_ROLE?RoleDataManager.instance.lv:HeroDataManager.instance.lv;
			if(nextData.player_level)
			{
				maxHeight += GAP_S;
				if(nextData.player_reincarn>roleReincarn || 
					nextData.player_reincarn==roleReincarn && nextData.player_level>roleLv)
				{
					txt = addProperty(HtmlUtils.createHtmlStr(0xc00000,StringConst.TIP_ROLE_LV+StringConst.COLON+
						(nextData.player_reincarn?nextData.player_reincarn+StringConst.REINCARN:"")+nextData.player_level+StringConst.LEVEL),PROPERTY_X,maxHeight);
				}
				else
				{

						txt = addProperty(HtmlUtils.createHtmlStr(0x00ff00,StringConst.TIP_ROLE_LV+StringConst.COLON+
							(nextData.player_reincarn?nextData.player_reincarn+StringConst.REINCARN:"")+nextData.player_level+StringConst.LEVEL),PROPERTY_X,maxHeight);
				}
				maxHeight += txt.textHeight;
			}
			if(nextData.ring_level)
			{
				var specialRingData:SpecialRingData = SpecialRingDataManager.instance.getDataById(nextData.ring_id);
				maxHeight += GAP_S;
				if(specialRingData.level < nextData.ring_level)
				{
					txt = addProperty(HtmlUtils.createHtmlStr(0xff0000,specialRingData.specialRingCfgData.name+StringConst.COLON+nextData.ring_level + StringConst.LEVEL),PROPERTY_X,maxHeight);
				}
				else
				{
					txt = addProperty(HtmlUtils.createHtmlStr(0x00ff00,specialRingData.specialRingCfgData.name+StringConst.COLON+nextData.ring_level + StringConst.LEVEL),PROPERTY_X,maxHeight);
				}
				maxHeight += txt.textHeight;
			}
			if(nextData.joint_halo_level)
			{
				var jointHaloData:JointHaloData = HejiSkillDataManager.instance.buffArr[nextData.joint_halo_id - 1];
				var jointHaloCfg:JointHaloCfgData;
				maxHeight += GAP_S;
				if(jointHaloData)
				{
					jointHaloCfg = ConfigDataManager.instance.jointHaloCfgData(jointHaloData.id,jointHaloData.level);
					if(jointHaloData.level < nextData.joint_halo_level)
					{
						txt = addProperty(HtmlUtils.createHtmlStr(0xff0000,jointHaloCfg.des+StringConst.COLON+nextData.joint_halo_level + StringConst.LEVEL),PROPERTY_X,maxHeight);
					}
					else
					{
						txt = addProperty(HtmlUtils.createHtmlStr(0x00ff00,jointHaloCfg.des+StringConst.COLON+nextData.joint_halo_level + StringConst.LEVEL),PROPERTY_X,maxHeight);
					}
				}
				else
				{
					jointHaloCfg = ConfigDataManager.instance.jointHaloCfgData(nextData.joint_halo_id,1);
					txt = addProperty(HtmlUtils.createHtmlStr(0xff0000,jointHaloCfg.des+StringConst.COLON+nextData.joint_halo_level + StringConst.LEVEL),PROPERTY_X,maxHeight);
				}
				maxHeight += txt.textHeight;
			}
			//proficiency
			var skillData:SkillData = SkillDataManager.instance.skillData(nextData.group_id);
			var curProfi:int = skillData?skillData.proficiency:0;
			
			if(isStudy && data.proficiency>0)
			{
				//proficiency
				maxHeight += GAP_S;
				if(curProfi<data.proficiency)
				{
					txt = addProperty(HtmlUtils.createHtmlStr(0xff0000,StringConst.TIP_PROFICIENCY+StringConst.COLON)+
									HtmlUtils.createHtmlStr(0xff0000,curProfi+"/"+data.proficiency),
									PROPERTY_X,maxHeight);
				}	
				else
				{
					if(nextData.book>0)
					{
						//book
						var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(nextData.book);
						if(itemCfgData)
						{
							var bagItem:* = BagDataManager.instance.getItemById(itemCfgData.id);
							
							maxHeight += GAP_S;
							txt = addProperty(HtmlUtils.createHtmlStr(0xffc000,StringConst.TIP_SKILL_BOOK+StringConst.COLON)+
								HtmlUtils.createHtmlStr(bagItem?0xffc000:0xc00000,itemCfgData.name),PROPERTY_X,maxHeight);
							maxHeight += txt.textHeight;
						}
					}
					else
					{
						txt = addProperty(HtmlUtils.createHtmlStr(0x00ff00,StringConst.TIP_PROFICIENCY+StringConst.COLON)+
							HtmlUtils.createHtmlStr(0x00ff00,data.proficiency+"/"+data.proficiency),
							PROPERTY_X,maxHeight);
					}
				}
				maxHeight += txt.textHeight;
			}
			
			//cd
			if(isStudy && nextData.cd>0)
			{
				maxHeight += GAP_S;
				var timeObj:Object = TimeUtils.calcTime(nextData.cd/1000);
				var timeClock:String = TimeUtils.formatS(timeObj);
				txt = addProperty(HtmlUtils.createHtmlStr(0xb4b4b4,StringConst.TIP_CD+StringConst.COLON+timeClock),PROPERTY_X,maxHeight);
				maxHeight += txt.textHeight;
			}
			
			//des
			maxHeight -= 9;
			addDes(nextData.post_desc);
			
			//proficiency tip
			if(nextData.proficiency>0 && curProfi<nextData.proficiency)
			{
				maxHeight += GAP_S+2;
				txt = addProperty(HtmlUtils.createHtmlStr(0xea5bcd,StringConst.TIP_SKILL_001),PROPERTY_X,maxHeight);
				maxHeight += GAP_S*4;
				maxHeight += txt.textHeight;
			}
			else
			{
				maxHeight += GAP_S*4;
			}
		}
	}
}