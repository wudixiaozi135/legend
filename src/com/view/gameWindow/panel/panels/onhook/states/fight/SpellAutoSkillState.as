package com.view.gameWindow.panel.panels.onhook.states.fight
{
	import com.model.configData.cfgdata.SkillCfgData;
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.panel.panels.onhook.states.common.AutoFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.scene.entity.constants.ActionTypes;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
	
	
	/**
	 * @author wqhk
	 * 2014-11-18
	 */
	public class SpellAutoSkillState implements IState
	{
		private var attacker:IPlayer;
		public function SpellAutoSkillState()
		{
			
		}
		
		private function isAllowAuto(actionId:int):Boolean
		{
			var re:Boolean = 	attacker.currentAcionId == ActionTypes.IDLE ||
								attacker.currentAcionId == ActionTypes.RUN ||
								attacker.currentAcionId == ActionTypes.HURT ||
								attacker.currentAcionId == ActionTypes.WALK;
			return re;
		}
		
		private function isAllowAutoEx(actionId:int):Boolean
		{
			var re:Boolean = 	attacker.currentAcionId == ActionTypes.IDLE ||
				attacker.currentAcionId == ActionTypes.RUN ||
				attacker.currentAcionId == ActionTypes.HURT ||
				attacker.currentAcionId == ActionTypes.WALK ||
				attacker.currentAcionId == ActionTypes.PATTACK || 
				attacker.currentAcionId == ActionTypes.MATTACK || 
				attacker.currentAcionId == ActionTypes.PATTACK || 
				attacker.currentAcionId == ActionTypes.RUSH_IDLE ||
				attacker.currentAcionId == ActionTypes.RUSH ||
				attacker.currentAcionId == ActionTypes.JOINT_ATTACK ||
				attacker.currentAcionId == ActionTypes.PATTACK_PREPARE ||
				attacker.currentAcionId == ActionTypes.MATTACK_END ||
				attacker.currentAcionId == ActionTypes.MATTACK_PREPARE;
			return re;
		}
		
		public function next(i:IIntention=null):IState
		{
			attacker = AxFuncs.firstPlayer;
			
			if(!attacker)
			{
				return this;
			}
			if(attacker.stallStatue)
				return this;
			var skill:SkillCfgData = AxFuncs.selectSkill(attacker,attacker,
												[],
												AxFuncs.getSkillAuto(attacker.job),
												0,AxFuncs.isSkillBeneficial);
			
			if(skill)
			{
				if(!skill.no_public_cd)
				{
					if(!isAllowAuto(attacker.currentAcionId))
					{
						return this;
					}
				}
				else //烈火
				{
					if(!isAllowAutoEx(attacker.currentAcionId))
					{
						return this;
					}
				}
				
				if(AutoFuncs.isAutoMove())
				{
					AutoFuncs.stopMove();
				}
				
//				if(/*AxFuncs.isAtPixel(attacker) && */skill.no_public_cd || !AxFuncs.isRigor())
//				{
					AxFuncs.attack(attacker,attacker,skill);
//				}
			}
			
			return this;
		}
	}
}