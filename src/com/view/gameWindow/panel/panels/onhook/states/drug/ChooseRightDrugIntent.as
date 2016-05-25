package com.view.gameWindow.panel.panels.onhook.states.drug
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.onhook.states.common.AutoFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.CDState;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	
	
	/**
	 * @author wqhk
	 * 2014-9-27
	 */
	public class ChooseRightDrugIntent implements IIntention
	{
		public var rateConditon:Number = 0.8;
		public var drugList:Array = [];
		public var cdSecond:int = 3;
		public function ChooseRightDrugIntent()
		{
		}
		
		public function check(state:IState):IState
		{
			var bag:BagDataManager = BagDataManager.instance;
			var num:int;
			var rate:Number;
			if(state is CheckHPState)
			{
				rate = getHPRate();
				if(rate <= rateConditon)
				{
					for each(var hpDrug:int in drugList)
					{
						if(bag.requestUseItem(hpDrug,1))
						{
							trace("使用红药:" + hpDrug);
							return new CDState(cdSecond,new CheckHPState());
						}
					}
				}
			}
			else if(state is CheckMPState)
			{
				rate = getMPRate();
				if(rate <= rateConditon)
				{
					for each(var mpDrug:int in drugList)
					{
						if(bag.requestUseItem(mpDrug,1))
						{
							trace("使用蓝药:" + mpDrug);
							return new CDState(cdSecond,new CheckMPState());
						}
					}
				}
			}
			
			return state;
		}
		
		private function getHPRate():Number
		{
			return RoleDataManager.instance.attrHp/RoleDataManager.instance.attrMaxHp;
		}
		
		private function getMPRate():Number
		{
			return RoleDataManager.instance.attrMp/RoleDataManager.instance.attrMaxMp;
		}
	}
}