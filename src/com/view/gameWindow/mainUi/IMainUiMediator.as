package com.view.gameWindow.mainUi
{
	import com.view.gameWindow.mainUi.subuis.autoSign.IAutoSign;
	import com.view.gameWindow.mainUi.subuis.bottombar.IBottomBar;
	import com.view.gameWindow.mainUi.subuis.chatframe.IChatFrame;
	import com.view.gameWindow.mainUi.subuis.herohead.IHeroHead;
	import com.view.gameWindow.mainUi.subuis.income.IIncome;
	import com.view.gameWindow.mainUi.subuis.minimap.IMiniMap;
	import com.view.gameWindow.mainUi.subuis.monsterhp.IMonsterHp;
	import com.view.gameWindow.mainUi.subuis.rolehead.IRoleHead;
	import com.view.gameWindow.mainUi.subuis.tasktrace.ITaskTrace;

	public interface IMainUiMediator
	{
		function get taskTrace():ITaskTrace;
		function get miniMap():IMiniMap;
		function get bottomBar():IBottomBar;
		function get roleHead():IRoleHead;
		function get monsterHp():IMonsterHp;
		function get heroHead():IHeroHead;
		function get income():IIncome;
		function get chatFrame():IChatFrame;
		function get autoSign():IAutoSign;
		
		function getUI(type:String):*;
	}
}