package com.model.configData.cfgdata
{
	public class SkillCfgData
	{
		public var id:int;
		public var group_id:int;
		public var name:String;
		public var type:int;
		/**使用EntityTypes中的常量*/
		public var view_type:int;
		public var level:int;
		public var beneficial:int;
		public var pre_desc:String;
		public var post_desc:String;
		public var entity_type:int;
		public var job:int;
		public var job_mate:int;
		public var action_type:int;
		public var attack_type:int;
		/**延迟类型，1：固定时间间隔，2：飞行一段时间间隔*/
		public var before_interval:int;
		public var after_interval_type:int;
		public var after_interval:int;
		public var speed:int;
		public var buff_remain:int;
		public var buff_id:int;
		public var dist:int;
		public var center:int;
		public var range:int;
		public var tile0:int;
		public var tile1:int;
		public var tile2:int;
		public var tile3:int;
		public var tile4:int;
		public var tile5:int;
		public var tile6:int;
		public var tile7:int;
		public var tile8:int;
		public var max_target:int;
		public var special:int;
		public var special_rate:int;
		public var special_param:int;
		public var target_type:int;
		public var auto_buff:int;
		public var attack_group:int;
		public var order:int;
		public var effect_action:String;
		public var effect_path:String;
		public var effect_hit:String;
		public var effect_ground:String;
		public var effect_ground_random:String;
		public var effect_joint:String;
		public var effect_delay:int;
		public var player_reincarn:int;
		public var player_level:int;
		public var ring_id:int;
		public var ring_level:int;
		public var joint_halo_id:int;
		public var joint_halo_level:int;
		public var proficiency:int;
		public var skill_point:int;
		public var icon:String;
		public var book:int;
		public var cd:int;
		public var no_public_cd:int;
		public var mp_cost:int;
		public var angry_cost:int;
		public var neili_cost:int;
		public var damage_rate:int;
		public var min_damage_addon:int;
		public var max_damage_addon:int;
		public var damage_immediate:int;
		public var sound:int;
		public var sound_action:int;
		public var sound_hit:int;
		public var study_desc:String;
		public var damage_monster_addition:int;
		public function SkillCfgData()
		{
		}
	}
}