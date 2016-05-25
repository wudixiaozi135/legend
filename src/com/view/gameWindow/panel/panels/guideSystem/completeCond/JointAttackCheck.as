package com.view.gameWindow.panel.panels.guideSystem.completeCond
{
	import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
	import com.view.gameWindow.panel.panels.hejiSkill.HejiSkillDataManager;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.ILivingUnit;
	import com.view.gameWindow.scene.entity.entityItem.interf.IMonster;
	
	/**
	 * @author wqhk
	 * 2015-1-24
	 */
	public class JointAttackCheck implements ICheckCondition
	{
		public function JointAttackCheck()
		{
		}
		
		public function toDo():void
		{
			
		}
		
		public function isDoing():Boolean
		{
			var isAngryFull:Boolean = HejiSkillDataManager.instance.isAngryFull;
			
			if(!isAngryFull)
			{
				return true;
			}
			
			if(AutoJobManager.getInstance().selectEntity)
			{
				return !AxFuncs.monsterFilter(AutoJobManager.getInstance().selectEntity as ILivingUnit);
			}
			return true;
		}
		
		public function isComplete():Boolean
		{
			var isInDgn:Boolean = DgnDataManager.instance.isInDgn;
//			var isAngryFull:Boolean = HejiSkillDataManager.instance.isAngryFull;
			
			var angry:int = RoleDataManager.instance.angry;
			
			return !isInDgn|| angry == 0;
		}
	}
}