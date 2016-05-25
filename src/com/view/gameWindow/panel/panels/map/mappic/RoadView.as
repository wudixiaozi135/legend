package com.view.gameWindow.panel.panels.map.mappic
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	
	/**
	 * @author wqhk
	 * 2015-1-9
	 */
	public class RoadView extends Sprite
	{
		//200 5
		public function RoadView()
		{
			super();
		}
		
		private const GAP_EX:int = 6;
		private const STEP_EX:Number = 0.1; //还有bug 不能调过快
		private var GAP:int = 40;
		private var STEP:int = 1;
		private var _path:Array = [];
		private var _pointsList:Array = [];
		private var _storePoints:Array = [];
		private var _roadLength:Number;
		
		private var _ratioX:Number = 1;

		public function get ratioX():Number
		{
			return _ratioX;
		}

		public function set ratioX(value:Number):void
		{
			_ratioX = value;
			
			GAP = int(GAP_EX/_ratioX);
			STEP = int(STEP_EX/_ratioX);
		}

		public var ratioY:Number = 1;
		public var anchorX:Number = 0;
		public var anchorY:Number = 0;
		
		public function clear():void
		{
			for each(var p:RoadPoint in _pointsList)
			{
				releasePoint(p);
			}
			
			_pointsList = [];
			_path = [];
			_roadLength = 0;
		}
		
		public function isRunning():Boolean
		{
			return _pointsList.length > 0;
		}
		
		public function initPath(path:Array):void
		{
			if(!path || path.length<=1)
			{
				clear();
			}
			else if(_path.length == 0)
			{
				_path = path;
			}
			else
			{
				_path = path;
				
				var newLength:Number = calcRoadLength();
				
				//假设是在同一条路径上！
				if(newLength < _roadLength) 
				{
					var d:Number = _roadLength - newLength;
					
					var newList:Array = [];
					var p:RoadPoint;
					for each(p in _pointsList)
					{
						if(p.pos > d)
						{
							newList.push(p);
						}
						else
						{
							releasePoint(p);
						}
					}
					
					_pointsList = newList;
					
					for each(p in _pointsList)
					{
						p.pos -= d;
					}
				}
				
				_roadLength = newLength;
			}
		}
		
		private function releasePoint(p:RoadPoint):void
		{
			if(p)
			{
				if(p.parent)
				{
					p.parent.removeChild(p);
				}
				
				_storePoints.push(p);
			}
		}
		
		private function createPoint():RoadPoint
		{
			if(_storePoints.length > 0)
			{
				return _storePoints.pop();
			}
			return new RoadPoint();
		}
		
		public function addPointAtOnce():void
		{
			if(_path.length <= 1)
			{
				return;
			}
			
			var num:int = numLine;
			var gap:Number = GAP;
			
			var vPoint:RoadPoint = createPoint();
			vPoint.pos = 0;
			
			addChild(vPoint);
			_pointsList.push(vPoint);
			
			
			_roadLength = 0;
			for(var i:int = 0; i < num; ++i)
			{
				var points:Array = getPoints(i);
				var start:Point = points[0];
				var end:Point = points[1];
				
				var dis:Number = calcDis(start.x,start.y,end.x,end.y);
				
				var len:Number = 0;
				var lastPos:Number = _roadLength;
				while(len + gap <= dis)
				{
					vPoint = createPoint();
					
					lastPos += gap;
					vPoint.pos = lastPos;
					
					addChild(vPoint);
					_pointsList.push(vPoint);
					
					len += gap;
					gap = GAP;
				}
				
				
				gap = len + gap - dis;
				
				_roadLength += dis;
			}
		}
		
		public function updatePointPos(point:RoadPoint):void
		{
			var num:int = numLine;
			var step:Number = STEP;
			
			point.pos = (point.pos + step)%_roadLength;
			
			var length:Number = 0;
			for(var i:int = 0; i < num; ++i)
			{
				var list:Array = getPoints(i);
				var start:Point = list[0];
				var end:Point = list[1];
				
				var dis:Number = calcDis(start.x,start.y,end.x,end.y);
				
				if(length + dis >= point.pos)
				{
					var d:Number = point.pos - length;
					point.x = (start.x + (end.x - start.x)/dis*d)*ratioX + anchorX;
					point.y = (start.y + (end.y - start.y)/dis*d)*ratioY + anchorY;
					return;
				}
				length += dis;
			}
		}
		
		public function update():void
		{
			for(var i:int = 0; i < _pointsList.length; ++i)
			{
				updatePointPos(_pointsList[i]);
			}
		}
		
		public function calcRoadLength():Number
		{
			var length:Number = 0;
			var num:int = numLine;
			
			for(var i:int = 0; i < num; ++i)
			{	
				var points:Array = getPoints(i);
				var start:Point = points[0];
				var end:Point = points[1];
				
				var dis:Number = calcDis(start.x,start.y,end.x,end.y);
				length += dis;
			}
			
			return length;
		}
		
		
		public function get numLine():int
		{
			return _path.length - 1;
		}
		
		private var retGetPoints:Array = [];
		private function getPoints(index:int):Array
		{
			var start:Point = _path[index];
			var end:Point = _path[index+1];
			retGetPoints[0] = start;
			retGetPoints[1] = end;
			return retGetPoints;
		}
		
		
		private var retGetPointDisList:Array = [];
		private function getPointDisList(x:Number,y:Number,start:Point,end:Point):Array
		{
			var dis0:Number = calcDis(start.x,start.y,x,y);
			var dis1:Number = calcDis(x,y,end.x,end.y);
			var dis:Number = calcDis(start.x,start.y,end.x,end.y);
			
			retGetPointDisList[0] = dis0;
			retGetPointDisList[1] = dis1;
			retGetPointDisList[2] = dis;
			
			return [dis0,dis1,dis];
		}
		
		private function calcDis(x0:Number,y0:Number,x1:Number,y1:Number):Number
		{
			var dx:Number = x1 - x0;
			var dy:Number = y1 - y0;
			var dis:Number = Math.sqrt(dx*dx+dy*dy);
			return dis;
		}
	}
}