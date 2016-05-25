package com.view.gameWindow.panel.panels.onhook.states.fight
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.pattern.state.StateMachine;
	import com.view.gameWindow.panel.panels.onhook.states.EventNames;
	import com.view.gameWindow.panel.panels.onhook.states.StateEvent;
	import com.view.gameWindow.panel.panels.onhook.states.common.AuFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AutoFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.WaitingState;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
	
	
	/**
	 * 负责寻找怪物 移动并攻击
	 * @author wqhk
	 * 2014-9-27
	 */
	public class AutoAttack extends StateMachine
	{
		public function AutoAttack()
		{
			super();
			
			StateMachine.eventCenter.addEventListener(EventNames.FIGHT,fightHandler);
		}
		
		private function fightHandler(e:StateEvent):void
		{
			next(e.intent);
		}
		
		public function destroy():void
		{
			StateMachine.eventCenter.removeEventListener(EventNames.FIGHT,fightHandler);
		}
		
		override public function next(i:IIntention=null):IState
		{
			var re:IState = super.next(i);
			
//			if(re is WaitingState)
//			{
//				AuFuncs.showFightEffect(false);
//			}
//			else
//			{
//				AuFuncs.showFightEffect(true);
//			}
			
			return re;
		}
	}
}