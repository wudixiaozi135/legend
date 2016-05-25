package com.view.gameWindow.panel.panels.guideSystem.unlock
{
	import com.pattern.Observer.IObserver;
	
	
	/**
	 * @author wqhk
	 * 2014-10-29
	 */
	public class UnlockObserver implements IObserver
	{
		public function UnlockObserver()
		{
		}
		
		private var callback:Function;
		
		public function setCallback(value:Function):void
		{
			callback = value
		}
		
		public function update(proc:int=0):void
		{
			if(callback != null)
			{
				callback(proc);
			}
		}
		
		public function destroy():void
		{
			setCallback(null);
		}
	}
}