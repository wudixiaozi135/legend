package com.view.gameWindow.panel.panels.onhook.states.fight
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.onhook.states.common.AutoFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.FightPlace;
	import com.view.gameWindow.scene.entity.constants.ActionTypes;
	
	import flash.utils.getTimer;
	
	
	/**
	 * @author wqhk
	 * 2015-3-2
	 */
	public class CheckAutoFight implements IState
	{
		public static const TIME:int = 30000;
		public function CheckAutoFight()
		{
			time = getTimer();
		}
		
		private var time:int = 0;
		public function next(i:IIntention=null):IState
		{
			if(!AxFuncs.firstPlayer)
			{
				return this;
			}
			
			if(AutoFuncs.isAutoFight()
				|| AutoFuncs.isAutoMove()
				||!AxFuncs.isAtPixel(AxFuncs.firstPlayer) 
				|| !(AxFuncs.firstPlayer.currentAcionId == ActionTypes.IDLE || 
					AxFuncs.firstPlayer.currentAcionId == ActionTypes.HURT))
			{
				time = getTimer();
			}
			else
			{
				var curt:int = getTimer();
				
				if(curt - time >= TIME)
				{
					AutoSystem.instance.startAutoFight(FightPlace.FIGHT_PLACE_AUTO,true,AxFuncs.isBossPriority());
					time = curt;
				}
			}
			
			return this;
		}
		
		
	}
}