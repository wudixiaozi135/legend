package com.view.gameWindow.mainUi.subuis.bottombar
{
    import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.ISysAlert;

    import flash.geom.Rectangle;

    public interface IBottomBar
	{
		function refreshHpMp():void;
		function playCoolDownEffect(groupId:int):void;
		function get sysAlert():ISysAlert;

        function getCurrentExpRect():Rectangle;
	}
}