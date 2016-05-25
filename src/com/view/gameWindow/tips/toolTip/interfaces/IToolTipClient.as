package com.view.gameWindow.tips.toolTip.interfaces
{
	/**
	 * 要显示tip的对象接口
	 * @author jhj
	 */	
	public interface IToolTipClient
	{
		function getTipData():Object;
		function getTipType():int;
		function getTipCount():int;
	}
}