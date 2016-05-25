package com.view.gameWindow.common
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * @author wqhk
	 * 2015-2-2
	 */
	public class DropTest
	{
		public function DropTest()
		{
		}
		
		/**
		 * 顺时针的点
		 * @return  path
		 */
		public function calcBounds(rect:Rectangle,span:int):Array
		{
			var col:int = Math.ceil(rect.width/span)+1; 
			var row:int = Math.ceil(rect.height/span)+1;
			
			var pos:Point = null;
			var list:Array = [];
			
			var a:Array = [];
			var b:Array = [];
			var c:Array = [];
			var d:Array = [];
			
			for(var i:int = 0;i < row; ++i)
			{
				pos = new Point(rect.x,rect.y + i*span);
				d.push(pos);
				
				pos = new Point(rect.x + (col - 1)*span,rect.y + i*span);
				b.push(pos);
			}
			d = d.reverse();
			
			for(var j:int = 1; j < col - 1; ++j)
			{
				pos = new Point(rect.x + j*span,rect.y);
				a.push(pos);
				
				pos = new Point(rect.x + j*span,rect.y + (row - 1)*span);
				c.push(pos);
			}
			c = c.reverse();
			
			list = list.concat(a,b,c,d);
			
			return list;
		}
		
		/**
		 * path 中相邻点之间的距离。 最后一个点和第一点相连
		 */
		public function calcDis(path:Array):Array
		{
			var re:Array = [];
			for(var i:int = 0; i < path.length; ++i)
			{
				var a:Point = path[i];
				var nextI:int = i == path.length - 1 ? 0 : i + 1;
				var b:Point = path[nextI];
				
				var dx:Number = a.x - b.x;
				var dy:Number = a.y - b.y;
				
				var dis:Number = Math.sqrt(dx*dx + dy*dy);
				
				re.push(dis);
			}
			
			return re;
		}
		
		public function calTotalDis(disList:Array):Number
		{
			var sum:Number = 0;
			for each(var dis:Number in disList)
			{
				sum += dis;	
			}
			
			return sum;
		}
		
		/**
		 * @param moonPos 如果通过检测会改变moonPos的值
		 * @param planetCenter moonPos点向该点位移
		 * @param dis 位移
		 * @return false 代表没有通过检测，位置不变 
		 */
		public function checkDrop(moonPos:Point,planet:BitmapData,planetPos:Point,planetCenter:Point,dis:Number):Boolean
		{
			var newPos:Point = calcNewPos(moonPos,planetCenter,dis);
			var testPos:Point = newPos.subtract(planetPos);
			
			if(!planet.hitTest(new Point(),0x66,testPos))
			{
				moonPos.x = newPos.x;
				moonPos.y = newPos.y;
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private function calcNewPos(moonPos:Point,planetCenter:Point,dis:Number):Point
		{
			
			var d:Point = planetCenter.subtract(moonPos);
			
			var len:Number = Math.sqrt(d.x*d.x+d.y*d.y);
			
			var newX:Number = dis*d.x/len;
			var newY:Number = dis*d.y/len;
			
			return new Point(moonPos.x+newX,moonPos.y+newY);
		}
	}
}