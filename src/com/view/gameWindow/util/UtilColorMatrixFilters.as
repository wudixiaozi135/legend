package com.view.gameWindow.util
{
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;

	/**
	 * 
	 * @author Administrator
	 */	
	public class UtilColorMatrixFilters
	{
		private static const mat:Array = [0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0];
		private static const colorMat:ColorMatrixFilter = new ColorMatrixFilter(mat);
		public static const GREY_FILTERS:Array = [colorMat];
		
		public static const RED_COLOR_FILTER:GlowFilter=new GlowFilter(0xff0000,1,2,2,10);
		public static const YELLOW_COLOR_FILTER:GlowFilter=new GlowFilter(0xffff00,.5,5,5,10);
		public static const BLACK_COLOR_FILTER:GlowFilter = new GlowFilter(0,1,2,2,10);
		
		public static const DGN_TOWER_0:GlowFilter = new GlowFilter(0x0033ff,1,10,10,3);
		public static const DGN_TOWER_1:GlowFilter = new GlowFilter(0xcc3300,1,10,10,3);
		public static const DGN_TOWER_2:GlowFilter = new GlowFilter(0x0066ff,1,10,10,3);
		public static const DGN_TOWER_3:GlowFilter = new GlowFilter(0x006600,1,10,10,3);
		
		public function UtilColorMatrixFilters()
		{
		}
		
	}
}