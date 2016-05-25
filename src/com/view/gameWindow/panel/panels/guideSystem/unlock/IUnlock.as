package com.view.gameWindow.panel.panels.guideSystem.unlock
{
	import com.pattern.Observer.Observe;

	public interface IUnlock
	{
		function get unlockStateNotice():Observe;
		function get unlockAnimNotice():Observe;
			
		function isUnlock(id:int):Boolean;
		function getUnlockTip(id:int):String;
	}
}