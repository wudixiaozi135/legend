package  com.pattern.state
{
	public interface IStateMachine extends IState
	{
		function init(state:IState):void
	}
}