package com.view.gameWindow.scene.entity.entityItem.interf
{
	import com.view.gameWindow.scene.entity.model.base.EntityModel;

	public interface IFirstPlayer extends IPlayer
	{
		function get entityModel():EntityModel;
		
		function get knocking():Boolean;
		function startKnock():void;
	}
}