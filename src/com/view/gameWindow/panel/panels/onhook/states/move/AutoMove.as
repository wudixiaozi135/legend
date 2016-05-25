package com.view.gameWindow.panel.panels.onhook.states.move
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.pattern.state.StateMachine;
	import com.view.gameWindow.panel.panels.onhook.states.EventNames;
	import com.view.gameWindow.panel.panels.onhook.states.StateEvent;
	import com.view.gameWindow.panel.panels.onhook.states.common.AuFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AutoFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.WaitingState;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
	
	import flash.events.Event;
	
	
	/**
	 * 负责单张地图中的移动
	 * @author wqhk
	 * 2014-9-28
	 */
	public class AutoMove extends StateMachine
	{
		public function AutoMove()
		{
			super();
			
		
			StateMachine.eventCenter.addEventListener(EventNames.MOVE,moveHandler,false,0,true);
		}
		
		private function moveHandler(e:StateEvent):void
		{
			next(e.intent);
		}
		
		public function destroy():void
		{
			StateMachine.eventCenter.removeEventListener(EventNames.MOVE,moveHandler);
		}
		
		override public function next(i:IIntention=null):IState
		{
			var re:IState = super.next(i);
			
//			if(re is WaitingState)
//			{
//				AuFuncs.showMoveEffect(false);
//			}
//			else
//			{
//				AuFuncs.showMoveEffect(true);
//			}
			
			return re;
		}
	}
}