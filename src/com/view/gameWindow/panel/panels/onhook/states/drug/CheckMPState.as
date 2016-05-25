package com.view.gameWindow.panel.panels.onhook.states.drug
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	
	
	/**
	 * @author wqhk
	 * 2014-10-9
	 */
	public class CheckMPState implements IState
	{
		public function CheckMPState()
		{
		}
		
		public function next(i:IIntention = null):IState
		{
			if(RoleDataManager.instance.attrHp <= 0 || RoleDataManager.instance.attrMp >= RoleDataManager.instance.attrMaxMp)
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