package com.view.gameWindow.panel.panels.onhook.states.pickUp
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.WaitingState;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.Monster;
	import com.view.gameWindow.scene.entity.entityItem.interf.IMonster;
	import com.view.selectRole.SelectRoleDataManager;
	
	
	/**
	 * @author wqhk
	 * 2014-12-26
	 */
	public class DiggingState implements IState
	{
		private var _entityId:int;
		private var _lastCount:int = -1;
		public function DiggingState(mousetEntityId:int)
		{
			_entityId = mousetEntityId;
		}
		
		public function next(i:IIntention=null):IState
		{
			var mst:Monster = AxFuncs.getEntity(EntityTypes.ET_MONSTER,_entityId) as Monster;
			if(!mst || !mst.isShow)
			{
				return new WaitingState();
			}
			
			if(_lastCount == -1)
			{
				_lastCount = mst.digCount;
				
				if(!mst.canDig)//发生了变化
				{
					return new WaitingState();
				}
			}
			else if(mst.digCount  > _lastCount)
			{
				return new WaitingState();
			}
			
			return this;
		}
			
	}
}