package  com.pattern.state
{
	import flash.events.Event;

	public interface IState
	{
		function next(i:IIntention = null):IState;
	}
}