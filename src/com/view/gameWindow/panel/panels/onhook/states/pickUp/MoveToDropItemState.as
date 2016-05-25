package com.view.gameWindow.panel.panels.onhook.states.pickUp
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.panel.panels.onhook.states.common.AsFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AutoFuncs;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
	
	
	/**
	 * @author wqhk
	 * 2014-9-29
	 */
	public class MoveToDropItemState implements IState
	{
		public var target:IEntity;
		private var checkAroundState:IState;
		
		public function MoveToDropItemState(target:IEntity,checkAroundState:IState)
		{
			this.target = target;
			this.checkAroundState = checkAroundState;
			AutoFuncs.move(EntityLayerManager.getInstance().firstPlayer, target.tileX, target.tileY, target.tileDistToReach);
		}
		
		public function next(i:IIntention=null):IState
		{
			var dis:int = EntityLayerManager.getInstance().firstPlayer.tileDistance(target.tileX,target.tileY);
			if(dis == 0)
			{
				AsFuncs.sendPickDropitem(target.entityId);
				return checkAroundState;
			}
			else
			{
				if(AutoFuncs.isAutoAttack())
				{
					return checkAroundState;
				}
				else if(!AutoFuncs.isAutoMove())
				{
					AutoFuncs.move(EntityLayerManager.getInstance().firstPlayer, target.tileX, target.tileY, target.tileDistToReach);
					return this;
				}
				else
				{
					return this;
				}
			}
		}
	}
}