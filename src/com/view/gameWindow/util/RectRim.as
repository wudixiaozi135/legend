package com.view.gameWindow.util
{
	import flash.display.Sprite;
	
	/**
	 * 长方形边框类
	 * @author Administrator
	 */	
	public class RectRim extends Sprite
	{
		public function RectRim(color:int,width:int,height:int,thickness:Number = 3.0,alpha:Number = 1.0)
		{
			super();
			initData(color,width,height,thickness,alpha);
		}
		
		private function initData(color:int,width:int,height:int,thickness:Number,alpha:Number):void
		{
			mouseEnabled = false;
			mouseChildren = false;
			graphics.lineStyle(thickness,color,alpha);
			graphics.lineTo(0,height-1);
			graphics.lineTo(width-1,height-1);
			graphics.lineTo(width-1,0);
			graphics.lineTo(0,0);
		}
	}
}