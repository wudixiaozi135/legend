package com.view.gameWindow.panel.panels.onhook.states.pickUp
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.panel.panels.onhook.states.common.AsFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AutoFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.WaitingState;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IDropItem;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	
	
	/**
	 * @author wqhk
	 * 2014-9-29
	 */
	public class CheckAroundDropItem implements IState
	{
		private var afterState:IState;
		private var isFightConsideRange:Boolean = true;
		
		/**
		 * @param afterState 拾取结束后如果不在战斗状态中执行afterState，如果没有afterState 进入WaitingState
		 * 
		 */
		public function CheckAroundDropItem(afterState:IState = null,isFightConsideRange:Boolean = true)
		{
			this.afterState = afterState;
			this.isFightConsideRange = isFightConsideRange;
		}
		
		public function next(i:IIntention=null):IState
		{
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			
			var dropItem:IDropItem = AxFuncs.findNearestEntity(firstPlayer,EntityLayerManager.getInstance().dropEquipListForPickUp,AxFuncs.dropItemFilter) as IDropItem;
			
			if(!dropItem)
			{
				dropItem = AxFuncs.findNearestEntity(firstPlayer,EntityLayerManager.getInstance().dropOtherListForPickUp,AxFuncs.dropItemFilter) as IDropItem;
			}
			
			if(!dropItem)
			{
//				if(!AutoFuncs.isAutoAttack())
//				{
//					AutoFuncs.startAttack();
//				}
				if(AutoFuncs.isAutoFight())
				{
					if(!AutoFuncs.isAutoAttack())
					{
						if(AutoFuncs.isAnchorRange())
						{
							return new MoveToStartPos();
						}
						else
						{
							AutoFuncs.startAttack(isFightConsideRange);
						}
					}
				}
				else
				{
					if(afterState)
					{
						return afterState;
					}
					else
					{
						return new WaitingState();
					}
				}
			}
			else
			{
				var dist:int = firstPlayer.tileDistance(dropItem.tileX,dropItem.tileY);
				if(AutoFuncs.isAutoAttack())
				{
					AutoFuncs.stopAttack();
				}
				if(dist == 0)
				{
					AsFuncs.sendPickDropitem(dropItem.entityId);
				}
				else
				{
					return new MoveToDropItemState(dropItem,this);
				}
			}
			
			return this;
		}
	}
}