package com.view.gameWindow.panel
{
	import com.view.gameWindow.panel.panelbase.IPanelBase;

	public interface IPanelMediator
	{
		/**打开面板*/
		function openPanel(type:String,isOnly:Boolean = true,...args):void;
//		/**显示面板*/
//		function showPanel(panel:PanelBase):void;
//		/**隐藏面板*/
//		function hidePnael(panel:PanelBase):void;
		/**关闭面板*/
		function closePanel(type:String,index:int = 0):void;
		/**开关面板<br>关闭时开启，开启式关闭*/
		function switchPanel(type:String,isShowHide:Boolean = false):void;
		/**根据类型获取打开的面板接口*/
		function openedPanel(type:String,index:int = 0):IPanelBase;
		/**根据类型刷新打开的界面*/
		function refreshPanel(type:String,index:int = 0):void;
	}
}