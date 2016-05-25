package com.view.gameWindow.scene.skillDeal
{
	import com.view.gameWindow.scene.entity.entityItem.interf.ILivingUnit;

	public class SkillResultData
	{
		public var _attackState:int;
		public var _damage:int;
		public var _target:ILivingUnit;
		
		public function SkillResultData()
		{
		}
		
		public function copyData(attackState:int,damage:int,target:ILivingUnit):SkillResultData
		{
			var skillResultData:SkillResultData = new SkillResultData();
			skillResultData._attackState = attackState;
			skillResultData._damage  = damage;
			skillResultData._target = target;
			return skillResultData;
		}
	}
}