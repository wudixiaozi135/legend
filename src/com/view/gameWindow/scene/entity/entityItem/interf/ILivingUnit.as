package com.view.gameWindow.scene.entity.entityItem.interf
{
	import com.model.configData.cfgdata.SkillCfgData;
	
	import flash.geom.Point;

	public interface ILivingUnit extends IUnit
	{
		function get direction():int;
		function set direction(value:int):void;
		function get directSpeed():int;
		
		function get hp():int;
		function set hp(value:int):void;
		
		function get maxHp():int;
		function set maxHp(value:int):void;
		
		function get speed():int;
		function set speed(value:int):void;
		
		function get targetTileX():int;
		function get targetTileY():int;
		function set targetTileX(value:int):void;
		function set targetTileY(value:int):void;
		function get targetPixelX():Number;
		function get targetPixelY():Number;
		function set targetPixelX(value:Number):void;
		function set targetPixelY(value:Number):void;
		
		function get isEnemy():Boolean;
		
		function isArriveTarget():Boolean;
		
		function run():void;
		function pAttack():void;
		function pAttackLoop():void;
		function mAttack():void;
		function hurt():void;
		function die():void;
		function dead():void;
		function gather():void;
		
		function showStateAlert(targetHPChange:int, actState:int):void;
		function showHpTitle(bool:Boolean = true):void;
		function hideHpTile():void;
		function showHp(bool:Boolean = true):void;
		function hideHp():void;
		
		function refreshBuffs():void;
		function hideBuff():void;
		
		function get isPalsy():Boolean;
		function get isFrozen():Boolean;
		
		function addTopHitEffect(skillCfgData:SkillCfgData, launcherPos:Point, groundPos:Point):void;
		function showBornEffect():void;
		
		function knockTo(currentTileX:int, currentTileY:int, nextTileX:int, nextTileY:int, targetX:int, targetY:int, isPushBack:Boolean):void;
		function knockedTo(tileX:int, tileY:int, speed:int):void;
		function pushBackTo(tileX:int, tileY:int, speed:int):void;
		
		function get beKnocking():Boolean;
		function get lastBeKnockTick():int;
	}
}