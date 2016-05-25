package com.view.gameWindow.scene.movie
{
	public interface IMovieControl
	{
		function movieBegin(mid:int,isCover:Boolean):void;
		function movieEnd(mid:int):void;
		function createMovieQueue(mid:int,list:*):Array;
		
		function moveMonster(data:Array):void;
		function moveFirstPlayer(data:Array):void;
		
		function addMonster(data:Array):void;
		function monsterAttack(data:Array):void;
		function monsterDied(data:Array):void;
		function monsterStand(data:Array):void;	
		function monsterFacing(data:Array,time:Object = null):void;
		
		function spellSkill(data:Array):void;
		
		function removeUnit(data:Array):void;	
		
		function chat(data:Array):void;
		
		function moveCamera(data:Array):void;
		
		
		function openCurtain(time:Number):void;
		function closeCurtain(time:Number):void;
		
		function showCover(data:Array):void;
		function hideCover():void;
		function addSubtitle(data:Array):void;
			
	}
}