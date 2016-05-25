package com.view.gameWindow.util.css
{
	import flash.text.StyleSheet;

	public class GameStyleSheet
	{

		private static var _linkStyle:StyleSheet;
		
		public static function get linkStyle():StyleSheet
		{
			if(_linkStyle==null)
			{
				_linkStyle = new StyleSheet();
				_linkStyle.parseCSS("a:hover { color:#FF0000; }");
			}
			return _linkStyle;
		}
		
		private static var _linkStyle1:StyleSheet;
		
		public static function get linkStyle1():StyleSheet
		{
			if(_linkStyle1==null)
			{
				_linkStyle1 = new StyleSheet();
				_linkStyle1.parseCSS("a:hover { color:#ffe1aa; }");
			}
			return _linkStyle1;
		}
		
		public function GameStyleSheet()
		{
		}
	}
}