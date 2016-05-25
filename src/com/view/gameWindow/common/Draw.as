package com.view.gameWindow.common
{
	import flash.display.Graphics;
	
	/**
	 * from net
	 * 2014-9-16
	 */
	public class Draw
	{
		//from net
		public static function drawSector(g:Graphics,x:Number, y:Number, radius:Number, startFrom:Number, angle:Number):void
		{
			g.moveTo(x,y);
			var angle:Number=(Math.abs(angle)>360)?360:angle;
			var n:Number=Math.ceil(Math.abs(angle)/45);
			var angleA:Number=angle/n;
			angleA=angleA*Math.PI/180;
			startFrom=startFrom*Math.PI/180;
			g.lineTo(x+radius*Math.cos(startFrom),y+radius*Math.sin(startFrom));
			
			for (var i:int=1; i<=n; i++) 
			{
				startFrom+=angleA;
				var angleMid:Number=startFrom-angleA/2;
				var bx:Number=x+radius/Math.cos(angleA/2)*Math.cos(angleMid);
				var by:Number=y+radius/Math.cos(angleA/2)*Math.sin(angleMid);
				var cx:Number=x+radius*Math.cos(startFrom);
				var cy:Number=y+radius*Math.sin(startFrom);
				g.curveTo(bx,by,cx,cy);
			}
			
			if(angle!=360)
			{
				g.lineTo(x,y);
			}
		}
	}
}