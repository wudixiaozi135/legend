package com.view.gameWindow.common
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * 不能用来做太大的东西，dropTest计算会比较多
	 * 而且路径包围出后就没存 其实相同类型的控件可以就算一次，以后再优化
	 * @author wqhk
	 * 2015-2-2
	 */
	public class MoveAroundAnim
	{
		private static var dropTest:DropTest;
		private var planet:BitmapData;
		private var path:Array;//point
		private var disList:Array;
		private var isDropComplete:Boolean;
		private var planetCenter:Point;
		private var planetPos:Point;
		private var targetList:Array;
		private var targetIndexList:Array;
		private var pathLength:Number;
		private var span:Number;
		private var ctner:DisplayObjectContainer;
		private var numDrop:int = 0;
		private var speed:Number;
		private var OFFSET:int = 5;
		private var lastTime:int = 0;
		
		public function MoveAroundAnim(center:DisplayObject,centerPos:Point,ctner:DisplayObjectContainer,targetList:Array,span:Number,speed:Number)
		{
			if(!dropTest)
			{
				dropTest = new DropTest();
			}
			
			this.targetList = targetList.concat();
			this.span = span;
			this.ctner = ctner;
			this.speed = speed;
			var centerRect:Rectangle = center.getBounds(ctner);
			var boundRect:Rectangle = new Rectangle(centerRect.x - OFFSET,centerRect.y - OFFSET,centerRect.width+OFFSET*2,centerRect.height+OFFSET*2);
			path = dropTest.calcBounds(boundRect,OFFSET);
			planet = new BitmapData(boundRect.width,boundRect.height,true,0);
			planet.draw(center,new Matrix(1,0,0,1,centerPos.x+OFFSET,centerPos.y+OFFSET));
			
			planetPos = new Point(boundRect.x,boundRect.y);
			planetCenter = new Point(centerRect.x + centerRect.width/2,centerRect.y + centerRect.height/2);
			isDropComplete = false;
			
			//检查 图像是否正确
//			var img:Bitmap = new Bitmap(planet);
//			ctner.addChild(img);
			
			ctner.addEventListener(Event.ENTER_FRAME,enterFrame,false,0,true);
		}
		
		public function destroy():void
		{
			if(ctner)
			{
				ctner.removeEventListener(Event.ENTER_FRAME,enterFrame);
				ctner = null;
			}
			
			if(targetList)
			{
				for each(var d:DisplayObject in targetList)
				{
					if(d.parent)
					{
						d.parent.removeChild(d);
					}
				}
				
				targetList = null;
			}
			
			planet = null;
		}
		
		private function enterFrame(e:Event):void
		{
			run();
		}
		
		public function run():void
		{
			if(!targetList)
			{
				return;
			}
			
			if(!isDropComplete)
			{
				numDrop = 0;
				for each(var pos:Point in path)
				{
					if(dropTest.checkDrop(pos,planet,planetPos,planetCenter,1))
					{
						++numDrop;
					}
				}
				
				if(numDrop == 0)
				{
					isDropComplete = true;
				}
			}
			
			if(isDropComplete)
			{
				if(!targetIndexList)
				{
					initTarget();
				}
				
				moveTargets();
			}
		}
		
		private function moveTargets():void
		{
			var time:Number = (getTimer() - lastTime)/1000;
			if(time*speed >= OFFSET*2)
			{
				lastTime = getTimer();
				for(var index:int = 0; index < targetList.length; ++index)
				{
					moveTarget(index);
				}
			}
		}
		
		private function moveTarget(index:int):void
		{
			var target:DisplayObject = targetList[index];
			var pathIndex:int = targetIndexList[index];
			
			if(pathIndex == -1)
			{
				return;
			}
			
			var dis:Number = disList[pathIndex];
			
			while(dis < OFFSET*2)
			{
				++pathIndex;
				pathIndex = pathIndex%path.length;
				
				dis += disList[pathIndex];
			}
			
			var moonPos:Point = path[pathIndex];
			
			target.x = moonPos.x;
			target.y = moonPos.y;
			
			if(!target.parent)
			{
				ctner.addChild(target);
			}
			
			++pathIndex;
			pathIndex = pathIndex%path.length;
			
			targetIndexList[index] = pathIndex;
		}
		
		private function initTarget():void
		{
			disList = dropTest.calcDis(path);
			pathLength = dropTest.calTotalDis(disList);
				
			targetIndexList = [];
			
			var curIndex:int = 0;
			var pathDis:Number = 0;
			var targetDis:Number = span;
			for(var index:int = 0; index < targetList.length; ++index)
			{
				while(pathDis < targetDis)
				{
					pathDis += disList[curIndex];
					++curIndex;
					
					if(curIndex == disList.length - 1)
					{
						curIndex = 0;
					}
				}
				
				targetDis = pathDis+span;//修正误差
				
				targetIndexList[targetList.length - index - 1] = curIndex == 0 ? targetList.length - 1:curIndex - 1; 
			}
		}
	}
}