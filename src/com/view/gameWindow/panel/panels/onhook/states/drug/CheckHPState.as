package com.view.gameWindow.panel.panels.onhook.states.drug
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	
	
	
	/**
	 * @author wqhk
	 * 2014-9-27
	 */
	public class CheckHPState implements IState
	{
		public function CheckHPState()
		{
		}
		
		public function next(i:IIntention = null):IState
		{
			if(RoleDataManager.instance.attrHp <= 0 || RoleDataManager.instance.attrHp >= RoleDataManager.instance.attrMaxHp)
			{
				return this;
			}
			else if(i)
			{
				return i.check(this);
			}
			else
			{
				return this;
			}
		}
	}
}