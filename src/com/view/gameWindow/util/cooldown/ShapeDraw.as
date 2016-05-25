package com.view.gameWindow.util.cooldown
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	/**
	 * 形状绘制
	 * @author Administrator
	 */	
	public class ShapeDraw
	{
		public function ShapeDraw()
		{
			
		}
		
		public static function drawFan(graphics:Graphics, radius:Number, startAngle:Number, endAngle:Number, centerX:Number = 0, centerY:Number = 0, step:Number = 5):void
		{
			if(startAngle == endAngle || step == 0)
			{
				return;
			}
			
			const PI:Number = Math.PI;
			const PI2:Number = PI*2;
			
			var startR:Number = startAngle / 180 * PI;
			var endR:Number = endAngle / 180 * PI;
			step = step / 180 * PI;
			
			var p:Point = new Point();
			var radian:Number = 0;
			graphics.moveTo(centerX, centerY);
			if(startR < endR)
			{
				if(endR - startR >= PI2)
				{
					startR = 0;
					endR = PI2;
				}
				if(step < 0)
				{
					step = -step;
				}
				
				radian = startR;
				do
				{
					getPointOfCircleByRadian(radius,radian,centerX,centerY,p);
					graphics.lineTo(p.x,p.y);
					
					radian += step;
				}while(radian < endR);
			}
			else
			{
				if(startR - endR >= PI2)
				{
					startR = PI2;
					endR = 0;
				}
				if(step > 0)
				{
					step = -step;
				}
				
				radian = startR;
				do
				{
					getPointOfCircleByRadian(radius,radian,centerX,centerY,p);
					graphics.lineTo(p.x,p.y);
					
					radian += step;
				}while(radian > endR);
			}
			
			getPointOfCircleByRadian(radius,endR,centerX,centerY,p);
			graphics.lineTo(p.x, p.y);
			graphics.lineTo(centerX, centerY);
		}
		/**
		 * 获取圆上的一点
		 * @param radius 半径
		 * @param radian 弧度
		 * @param centerX 中心点X坐标
		 * @param centerY 中心点Y坐标
		 * @param point 运算完成后会将结果值设置到此对象上
		 * @return 圆上的一点
		 */
		public static function getPointOfCircleByRadian(radius:Number, radian:Number, centerX:Number, centerY:Number, point:Point):Point
		{
			if(!point)
			{
				point = new Point();
			}
			
			point.x = radius * Math.cos(radian);
			point.y = radius * Math.sin(radian);
			point.offset(centerX, centerY);
			
			return point;
		}
		/**
		 * 获取圆上的一点
		 * @param radius 半径
		 * @param angle 角度
		 * @param centerX 中心点X坐标
		 * @param centerY 中心点Y坐标
		 * @param point 运算完成后会将结果值设置到此对象上
		 * @return 圆上的一点
		 */
		public static function getPointOfCircleByAngle(radius:Number, angle:Number, centerX:Number, centerY:Number, point:Point):Point
		{
			return getPointOfCircleByRadian(radius,angle / 180 * Math.PI,centerX,centerY,point);
		}
	}
}