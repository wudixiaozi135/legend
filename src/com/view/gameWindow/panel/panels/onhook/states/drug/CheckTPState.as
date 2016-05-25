package com.view.gameWindow.panel.panels.onhook.states.drug
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.panel.panels.onhook.AutoDataManager;
	import com.view.gameWindow.panel.panels.onhook.states.common.AsFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AutoFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.CDState;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
	
	
	/**
	 * @author wqhk
	 * 2014-11-20
	 */
	public class CheckTPState implements IState
	{
		public function CheckTPState()
		{
			
		}
		
		public function next(i:IIntention=null):IState
		{
			if(!AutoDataManager.instance.isHPTP)
			{
				return this;
			}
			
			if(RoleDataManager.instance.attrHp<=0 || RoleDataManager.instance.attrHp >= RoleDataManager.instance.attrMaxHp)
			{
				return this;
			}
			
			var self:IPlayer = AxFuncs.firstPlayer;
			if(!self)
			{
				return this;
			}
			
			var dangerous:Boolean = AxFuncs.isInDangerousPlace(AxFuncs.getCurMapId(),self.tileX,self.tileY);
			
			if(!dangerous)
			{
				return this;
			}
			
			
			if(getHPRate() > AutoDataManager.instance.hpTPPercent/100)
			{
				return this;
			}
			
			if(AxFuncs.useTp()==0)
			{
				return this;
			}
			
			TaskDataManager.instance.setAutoTask(false,"CheckTPState");
			AutoJobManager.getInstance().reset();
			AutoFuncs.stopAuto();
			
			return new CDState(3,this);
		}
		
		private function getHPRate():Number
		{
			return RoleDataManager.instance.attrHp/RoleDataManager.instance.attrMaxHp;
		}
	}
}