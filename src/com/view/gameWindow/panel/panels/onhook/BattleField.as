package com.view.gameWindow.panel.panels.onhook
{
	import flash.geom.Rectangle;
	
	/**
	 * 
	 * book记录可通过的点
	 * 
	 * @author wqhk
	 * 2014-12-1
	 */
	public class BattleField
	{
		private var book:Vector.<int>;
		private var blockHandler:Function;
		private var area:Rectangle;
		
		
		public function BattleField(blockHandler:Function)
		{
			this.blockHandler = blockHandler;
		}
		
		public function calc(startX:int,startY:int,area:Rectangle):void
		{
			this.area = area;
			book = new Vector.<int>(area.width*area.height);
			
			search(startX,startY);
		}
		
		public function isInField(x:int,y:int):Boolean
		{
			if(isOut(x,y))
			{
				return false;
			}
			
			var index:int = getIndex(x,y);
			var isBook:Boolean  = book[index] == 1;
			return isBook;
		}
		
		private function isOut(x:int,y:int):Boolean
		{
			if(x < area.x || y < area.y || x >= area.right || y >= area.bottom)
			{
				return true;
			}
			
			return false;
		}
		
		private function isBlock(x:int,y:int):Boolean
		{
			if(isOut(x,y))
			{
				return true;
			}
			
			var isBlock:Boolean = blockHandler(x,y);
			
			return isBlock;
		}
		
		private function search(x:int,y:int):void
		{
			if(isBlock(x,y))
			{
				return;
			}
			
			var index:int = getIndex(x,y);
			if(book[index] == 1)
			{
				return;
			}
			
			book[index] = 1;
			
			search(x+1,y);
			search(x+1,y+1);
			search(x,y+1);
			search(x-1,y+1);
			search(x-1,y);
			search(x-1,y-1);
			search(x,y-1);
			search(x+1,y-1);
			
		}
		
		private function getIndex(x:int,y:int):int
		{
			var dx:int = x - area.x;
			var dy:int = y - area.y;
			
			return dy*area.width + dx;
		}
		
	}
}