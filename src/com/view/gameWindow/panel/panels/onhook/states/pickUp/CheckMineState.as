package com.view.gameWindow.panel.panels.onhook.states.pickUp
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.panel.panels.onhook.states.common.AsFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AutoFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.CDState;
	import com.view.gameWindow.panel.panels.onhook.states.common.EmptyState;
	import com.view.gameWindow.panel.panels.onhook.states.common.WaitingState;
	import com.view.gameWindow.scene.entity.constants.ActionTypes;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.scene.map.path.MapPathManager;
	
	import flash.geom.Point;
	
	
	/**
	 * @author wqhk
	 * 2014-12-26
	 */
	public class CheckMineState implements IState
	{
		public function CheckMineState()
		{
		}
		
		private static var dx:Array = [1,1,0,-1,-1,-1,0,1];
		private static var dy:Array = [0,1,1,-1,0,-1,-1,-1];
		
		//注意 这里没有判断同mapId
		public function next(i:IIntention=null):IState
		{
			var p:IFirstPlayer = AxFuncs.firstPlayer;
			
			if(p)
			{
				if(p.currentAcionId != ActionTypes.IDLE)
				{
					return this;
				}
				
				if(AutoFuncs.isAutoMove() || AutoFuncs.isAutoMap())
				{
					return this;
				}
				
				if(p.isArriveTarget())
				{
					startX = p.tileX;
					startY = p.tileY;
					points = [];
					book = [];
					result = -1;
					index = 0;
					calcAround(startX,startY);
					traversePoints();
					
					if(result != -1)
					{
						var pos:Point = points[result];
						if(p.tileDistance(pos.x,pos.y) <= 1)
						{
							AsFuncs.sendBeginMining(pos.x,pos.y);
							trace(points.length);
							return new CDState(2,new CheckActionBreak(ActionTypes.MINING,null));
						}
						else
						{
							var newPos:Point = AxFuncs.getCanMoveLct(pos.x,pos.y);
							AutoFuncs.move(p,newPos.x,newPos.y, 0);
						}
					}
					else
					{
						return new WaitingState;
					}
				}
			}
			return this;
		}
		
		private var index:int = 0;
		private var points:Array = [];
		private var book:Array = [];
		private var startX:int;
		private var startY:int;
		private var space:int = 4;
		private var result:int = -1;
		
		private function calcAround(x:int,y:int):void
		{
			var ax:int;
			var ay:int;
			var isMine:Boolean;
			for(var index:int = 0; index < 8; ++index)
			{
				ax = x + dx[index];
				ay = y + dy[index];
				
				if(Math.abs(startX - ax) > space || Math.abs(startY - ay) > space)
				{
					continue;
				}
				
				if(isBook(ax,ay))
				{
					continue;
				}
				
				points.push(new Point(ax,ay));
			}
			book.push(new Point(x,y));
		}
		
		private function traversePoints():void
		{
			if(index < points.length)
			{
				var manager:MapPathManager = MapPathManager.getInstance();
				
				var total:int = points.length;
				var i:int;
				var p:Point;
				for(i = index; i < total; ++i)
				{
					p = points[i];
					var isMine:Boolean = manager.isMine(p.x,p.y);
					if(isMine)
					{
						result = i;
						index = total;
						return;
					}
				}
				
				for(i = index; i < total; ++i)
				{
					p = points[i];
					calcAround(p.x,p.y);
				}
				
				index = total;
				traversePoints();
			}
		}
		
		private function isBook(x:int,y:int):Boolean
		{
			for(var i:int = 0; i < book.length; ++i)
			{
				var pos:Point = book[i] as Point;
				
				if(pos.x == x && pos.y == y)
				{
					return true;
				}
			}
			
			return false;
		}
	}
}