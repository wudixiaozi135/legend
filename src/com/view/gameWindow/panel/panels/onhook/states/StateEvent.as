package com.view.gameWindow.panel.panels.onhook.states
{
	import com.pattern.state.IIntention;
	import com.pattern.state.StateMachine;
	
	import flash.events.Event;
	
	
	/**
	 * @author wqhk
	 * 2014-9-28
	 */
	public class StateEvent extends Event
	{
		public function StateEvent(type:String, intent:IIntention = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.intent = intent;
		}
		
		public var intent:IIntention;
		
		override public function clone():Event
		{
			return new StateEvent(this.type,this.intent,this.bubbles,this.cancelable);
		}
		
		public static function dispatchMachine(type:String,intent:IIntention):void
		{
			var e:StateEvent = new StateEvent(type,intent);
			StateMachine.eventCenter.dispatchEvent(e);
		}
	}
}