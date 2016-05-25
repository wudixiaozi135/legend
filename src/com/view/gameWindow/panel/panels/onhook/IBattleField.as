package com.view.gameWindow.panel.panels.onhook
{
	public interface IBattleField
	{
		function isInField(x:int,y:int):Boolean;
		function startFight(x:int,y:int,radius:int):void;
	}
}