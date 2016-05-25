package com.view.gameWindow.util
{
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;

	public class FilterUtil
	{

		private static var glowFilter:GlowFilter;
		private static var textFilter:GlowFilter;
		private static var glowFilter1:GlowFilter;
		private static var glowFilter2:GlowFilter;
		public static function getGrayfiltes():ColorMatrixFilter
		{
			var matrix:Array=[0.3086, 0.6094, 0.0820, 0, 0,  
				0.3086, 0.6094, 0.0820, 0, 0,  
				0.3086, 0.6094, 0.0820, 0, 0,  
				0,      0,      0,      1, 0];  
			
			var filter:ColorMatrixFilter=new ColorMatrixFilter(matrix);
			return filter;
		}
		
		public static function getTextFilter():GlowFilter
		{
			if(textFilter==null)
			{
				textFilter=  new GlowFilter(0,1,2,2,10);
			}
			return textFilter;
		}
		
		public static function getClolorFilter():GlowFilter
		{
			if(glowFilter==null)
			{
				glowFilter=new GlowFilter(0xff6600,1,15,15);
			}
			return glowFilter;
		}
		
		public static function getClolorFilter1():GlowFilter
		{
			if(glowFilter1==null)
			{
				glowFilter1=new GlowFilter(0xe616b6,1,15,15);
			}
			return glowFilter1;
		}
		
		public static function getClolorFilterByColor(color:int):GlowFilter
		{
			if(glowFilter2==null)
			{
				glowFilter2=new GlowFilter(0xe616b6,1,15,15);
			}else
			{
				glowFilter2.color=color;
			}
			return glowFilter2;
		}
		
		public  static function  brightness(val:Number):ColorMatrixFilter {	
			var Brightness_Matrix:Array=new Array()
			Brightness_Matrix =[1,0,0,0,val,
				0,1,0,0,val,
				0,0,1,0,val,
				0,0,0,1,0];
			var ColorMatrix_filter:ColorMatrixFilter = new ColorMatrixFilter(Brightness_Matrix);//亮度
			return ColorMatrix_filter
		}
	}
}