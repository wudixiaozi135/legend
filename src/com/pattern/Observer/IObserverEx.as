package com.pattern.Observer
{
	public interface IObserverEx extends IObserver
	{
		/**由被观察者在需要时调用*/
		function updateData(proc:int,data:*):void;
	}
}