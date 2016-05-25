package com.view.gameWindow.panel.panels.onhook.states.common
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
	
	
	/**
	 * @author wqhk
	 * 2014-12-30
	 */
	public class WaitingMoveStopState implements IState
	{
		public function WaitingMoveStopState()
		{
		}
		
		public function next(i:IIntention=null):IState
		{
			var f:IPlayer = AxFuncs.firstPlayer;
			
			if(f.tileX == f.targetTileX && f.tileY == f.targetTileY)
			{
				if(AxFuncs.isAtPixel(f))
				{
					return new WaitingState();
				}
			}
			return this;
		}
	}
}