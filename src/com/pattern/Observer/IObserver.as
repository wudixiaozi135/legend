package com.pattern.Observer
{
	/**
	 * 观察者接口
	 * @author Administrator
	 */	
	public interface IObserver
	{
		/**由被观察者在需要时调用*/
		function update(proc:int = 0):void;
	}
}