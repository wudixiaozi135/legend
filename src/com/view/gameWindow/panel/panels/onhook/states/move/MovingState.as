package com.view.gameWindow.panel.panels.onhook.states.move
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.panel.panels.onhook.states.common.AsFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.WaitingState;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
	
	import flash.geom.Point;
	
	
	/**
	 * @author wqhk
	 * 2014-9-28
	 */
	public class MovingState implements IState
	{
		public var destinationList:Array;
		public var entity:IPlayer;
		public var pkMode:Boolean;
		public function MovingState(path:Array,entity:IPlayer,pkMode:Boolean,immediate:Boolean = false)
		{
			this.destinationList = path;
			this.entity = entity;
			this.pkMode = pkMode;
			
			if(immediate)
			{
				next();
			}
		}
		
		public function next(i:IIntention=null):IState
		{
			if(i)
			{
				return i.check(this);
			}
			
			if(!destinationList || destinationList.length == 0)
			{
//				return new WaitingMoveStopState();
				return new WaitingState();
			}
			
			if(AxFuncs.isRigor() || entity.isPalsy || entity.isFrozen)
			{
				return this;
			}
			
			//其实 只有fp可以移动……
//			var p:IFirstPlayer = AxFuncs.firstPlayer;
			
			if(AxFuncs.isAtPixel(entity))
			{
				var destination:Point = destinationList[0] as Point;
				
				var dis:int = entity.tileDistance(destination.x,destination.y);
				
				if(dis == 0)
				{
					destinationList.shift();
//					AsFuncs.sendMove(p.tileX,p.tileY,p.targetTileX,p.targetTileY);
				}
				else
				{
					if (dis > AutoJobManager.WALK_DIST)
					{
						var xOffset:int = destination.x - entity.tileX;
						var yOffset:int = destination.y - entity.tileY;
						
						//最后一个目标点的最后两格放缓速度，用走。可以减少自动打怪时和怪物的位置重叠的情况
						//增加pkMode 在pk时全跑动
						var slowDist:int;
						if(pkMode)
						{
							slowDist = 0;
						}
						else
						{
							slowDist = AutoJobManager.RUN_DIST;//AutoJobManager.RUN_DIST + 1;
						}
						
						if(destinationList.length == 1 && dis <= slowDist)
						{
							if (xOffset != 0)
							{
								entity.targetTileX += xOffset / Math.abs(xOffset) * AutoJobManager.WALK_DIST;
							}
							if (yOffset != 0)
							{
								entity.targetTileY += yOffset / Math.abs(yOffset) * AutoJobManager.WALK_DIST;
							}
							
							entity.walk();
						}
						else
						{
							if (xOffset != 0)
							{
								entity.targetTileX += xOffset / Math.abs(xOffset) * AutoJobManager.RUN_DIST;
							}
							if (yOffset != 0)
							{
								entity.targetTileY += yOffset / Math.abs(yOffset) * AutoJobManager.RUN_DIST;
							}
							
							entity.run();
						}
					}
					else
					{
						entity.targetTileX = destination.x;
						entity.targetTileY = destination.y;
						entity.walk();
					}
					
//					AsFuncs.sendMove(p.tileX,p.tileY,p.targetTileX,p.targetTileY);
					AsFuncs.sendMove(entity.tileX,entity.tileY,entity.targetTileX,entity.targetTileY);
				}
			}
			
			return this;
		}
	}
}