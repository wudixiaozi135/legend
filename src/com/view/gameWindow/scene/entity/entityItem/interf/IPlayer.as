package com.view.gameWindow.scene.entity.entityItem.interf
{
	public interface IPlayer extends ILivingUnit
	{
		function get cid():int;
		function set cid(value:int):void;
		function get sid():int;
		function set sid(value:int):void;
		function get isTitleShow():Boolean;
		function set isTitleShow(value:Boolean):void;

		function get stallStatue():int;

		function set stallStatue(value:int):void;
		
		function get cloth():int;
		function set cloth(value:int):void;
		function get weapon():int;
		function set weapon(value:int):void;
		function get shield():int;
		function set shield(value:int):void;
		function get wing():int;
		function set wing(value:int):void;
		function get hair():int;
		function set hair(value:int):void;
		function get fashion():int;
		function set fashion(value:int):void;
		function get magicWeapon():int;
		function set magicWeapon(value:int):void;
		function get isWingShow():Boolean;
		function set isWingShow(value:Boolean):void;
		function get hideWeaponEffect():Boolean;
		function set hideWeaponEffect(value:Boolean):void;

		function get isFamilyNameShow():Boolean;
		function set isFamilyNameShow(value:Boolean):void;
		function get pkMode():int;
		function set pkMode(value:int):void;
		function set pkValue(value:int):void;
		function get pkValue():int;
		function set isGrey(value:int):void;
		function get isGrey():int;
		function set pkCamp(value:int):void;
		function get pkCamp():int;
		function get sex():int;
		function set sex(value:int):void;
		function get job():int;
		function set job(value:int):void;
		function get vip():int;
		function set vip(value:int):void;
		function get reincarn():int;
		function set reincarn(value:int):void;
		function get teamStatus():int;
		function set teamStatus(value:int):void;
		function get teamMemberCount():int;
		function set teamMemberCount(value:int):void;
		function get familyId():int;
		function set familyId(value:int):void;
		function get familySid():int;
		function set familySid(value:int):void;
		function get familyName():String;
		function set familyName(value:String):void;
		
		function walk():void;
		function mining():void;
		function sunbathe():void;
		function footsie():void;
		function massage():void;
		function beMassage():void;
		function watermelon():void;
		function get specialAction():int;
		function set specialAction(value:int):void;
		function changeModel():void;

		function set isHideModel(value:Boolean):void;

		function get isHideModel():Boolean;

	}
}