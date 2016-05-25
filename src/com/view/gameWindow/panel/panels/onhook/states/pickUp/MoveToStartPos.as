package com.view.gameWindow.panel.panels.onhook.states.pickUp
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.panel.panels.onhook.states.common.AutoFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
	
	import flash.geom.Point;
	
	
	/**
	 * 定点时 需要捡起物品 然后回到原点继续战斗
	 * @author wqhk
	 * 2014-11-20
	 */
	public class MoveToStartPos implements IState
	{
		public function MoveToStartPos()
		{
		}
		
		public function next(i:IIntention=null):IState
		{
			var self:IPlayer = AxFuncs.firstPlayer;
			
			if(!AutoFuncs.isAutoMove())
			{
				var pos:Point = AxFuncs.starFightPos;
				AutoFuncs.move(self, pos.x, pos.y, 0);
			}
			
			if(!AutoFuncs.isAutoMove())
			{
				if(AxFuncs.isAtPixel(self))
				{
					AutoFuncs.startAttack();
					return new CheckAroundDropItem();
				}
			}
			
			return this;
		}
	}
}