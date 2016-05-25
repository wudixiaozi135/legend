package com.view.gameWindow.panel.panels.skill
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.skill.constants.SkillConstants;

	/**
	 * 技能数据对象类
	 * @author Administrator
	 */	
	public class SkillData
	{
		public static const HOLE_SKILL_GROUP_ID:Object = {7501:7501,7511:7511,7521:7521};
		public var group_id:int;
		public var level:int;
		public var proficiency:int;
		/**技能是否打开(仅用于英雄技能)*/
		public var open:int;
		
		private var _oldId:int = -1;
		private var _oldLv:int = -1;
		private var _oldSkillCfg:SkillCfgData;
		
		public function get skillCfgDt():SkillCfgData
		{
			if(_oldId != group_id || _oldLv != level)
			{
				_oldSkillCfg = skillCfgDtBy(level);
				_oldId = group_id;
				_oldLv = level;
			}
			return _oldSkillCfg;//调用频繁
		}
		
		public function get skillCfgDtNext():SkillCfgData
		{
			return skillCfgDtBy(level+1);
		}
		
		private function skillCfgDtBy(level:int):SkillCfgData
		{
			var skillCfgData:SkillCfgData = ConfigDataManager.instance.skillCfgData(0,0,group_id,level);
			return skillCfgData;
		}
		
		public function get proficiencyMax():int
		{
			if(skillCfgDtNext)
			{
				return skillCfgDtNext.proficiency;
			}
			return int.MAX_VALUE;
		}
		/**当前熟练度满*/
		public function get isProficiencyFull():Boolean
		{
			return proficiency >= proficiencyMax;
		}
		/**需要的熟练度*/
		public function get proficiencyNeed():int
		{
			return skillCfgDt.proficiency - proficiency;
		}
		/**下一级技能需要的转生及等级条件满足*/
		public function get isNextNeedLvGet():Boolean
		{
			if(skillCfgDtNext)
			{
				var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(skillCfgDtNext.player_reincarn,skillCfgDtNext.player_level);
				return checkReincarnLevel;
			}
			return false
		}
		
		/**是否是主动技能*/
		public function get isZd():Boolean
		{
			return skillCfgDt ? skillCfgDt.type == SkillConstants.ZD : false;
		}
		/**是否是被动技能*/
		public function get isBd():Boolean
		{
			return skillCfgDt ? skillCfgDt.type == SkillConstants.BD : false;
		}
		/**是否是触发技能*/
		public function get isCf():Boolean
		{
			return skillCfgDt ? skillCfgDt.type == SkillConstants.CF : false;
		}
		/**是否是合击技能*/
		public function get isHj():Boolean
		{
			return skillCfgDt ? skillCfgDt.type == SkillConstants.HJ : false;
		}
		
		public function SkillData()
		{
		}
	}
}