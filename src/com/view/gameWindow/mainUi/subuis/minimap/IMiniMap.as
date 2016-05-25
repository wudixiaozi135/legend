package com.view.gameWindow.mainUi.subuis.minimap
{
	public interface IMiniMap
	{
		function addMstSign(id:int):void;
		function removeMstSign(id:int):void;
		function refreshMstSign(id:int):void;
		function addPlayerSign(id:int):void;
		function removePlayerSign(id:int):void;
		function refreshPlayerSign(id:int):void;

		function setBtnHide(selected:Boolean):void;

		function setBtnMuisc(selected:Boolean):void;
	}
}