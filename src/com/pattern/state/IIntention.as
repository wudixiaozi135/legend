package com.pattern.state
{
	public interface IIntention
	{
		function check(state:IState):IState;
	}
}