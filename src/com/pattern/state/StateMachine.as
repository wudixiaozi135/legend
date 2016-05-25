package  com.pattern.state
{
	import com.view.gameWindow.panel.panels.onhook.states.common.WaitingState;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * @author wqhk
	 * 2014-9-26
	 */
	public class StateMachine implements IState
	{
		/**
		 * 用于并行的xx之间的交互，有没其他好方法=.=  
		 * 
		 */
		public static const eventCenter:EventDispatcher = new EventDispatcher();
		
		private var _curState:IState;
		private var _oldState:IState;
		
		public function StateMachine()
		{
		}
		
		public function get curState():IState
		{
			return _curState;
		}
		
		public function init(state:IState):void
		{
			_curState = state;
		}
		
		public function next(i:IIntention = null):IState
		{
			if(_curState)
			{
				return _curState = _curState.next(i);
			}
			else
			{
				return null;
			}
		}
		
		public function pause():void
		{
			if(_curState is WaitingState)
			{
				return;
			}
			
			_oldState = _curState;
			init(new WaitingState());
		}
		
		public function resume():void
		{
			if(_curState is WaitingState)
			{
				return;
			}
			
			_curState = _oldState;
			_oldState = null;
		}
	}
}