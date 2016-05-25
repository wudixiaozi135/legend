package com.pattern.Observer
{
	/**
	 * 被观察者类
	 * @author Administrator
	 */	
	public class Observe
	{
		private var _observers:Vector.<IObserver>;
		
		public function Observe()
		{
			_observers = new Vector.<IObserver>();
		}
		/**注册观察对象*/
		public function attach(observer:IObserver):void
		{
			var index:int = _observers.indexOf(observer);
			if (index == -1)
			{
				_observers.push(observer);
			}
			else
			{
				trace("Observe.attach(observer) 重复注册对象");
			}
		}
		/**注销观察对象*/
		public function detach(observer:IObserver):void
		{
			var index:int = _observers.indexOf(observer);
			if (index != -1)
			{
				_observers.splice(index, 1);
			}
			else
			{
				trace("Observe.detach(observer) 注销的对象未注册");
			}
		}
		/**调用所有观察对象的update方法*/
		public function notify(proc:int):void
		{
			var newObservers:Vector.<IObserver> = _observers.concat();
			for each (var observer:IObserver in newObservers)
			{
				observer.update(proc);
			}
			newObservers.length = 0;
		}
		
		/**调用所有IObserverEx观察对象的updateData方法*/
		public function notifyData(proc:int,data:*):void
		{
			for each (var observer:IObserver in _observers)
			{
				if(observer is IObserverEx)
				{
					IObserverEx(observer).updateData(proc,data);
				}
			}
		}
	}
}