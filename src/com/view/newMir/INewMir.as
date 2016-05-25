package com.view.newMir
{
	import com.view.gameLoader.IGameLoader;

	public interface INewMir
	{
		function resize(newWidth:int, newHeight:int):void;
		/**打开创建角色界面*/
		function dealCreateRole():void;
		function newCharacter(name:String,sex:int,job:int):void;
		/**打开选择角色界面*/
		function dealSelectRole():void;
		function enterGame():void;
		function delCharacter():void;
		function setGameLoader(gameLoader:IGameLoader):void;
		function musicBasicState(type:int):Boolean;
		
		function get width():Number;
		function get height():Number;
	}
}