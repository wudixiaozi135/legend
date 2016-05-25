package com.view.gameWindow.panel.panels.propIcon.icon.role
{
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.propIcon.icon.PropIcon;
	
	public class RoleReinIcon extends PropIcon
	{
		public function RoleReinIcon()
		{
			super();
		}
		
		override public function checkUnLock():Boolean
		{
			// TODO Auto Generated method stub
			return GuideSystem.instance.isUnlock(UnlockFuncId.ROLE_RE);
		}
		
		override protected function getIconUrl():String
		{
			return "small_roleRein.png";
		}
		
		override public function getTipData():Object
		{
			// TODO Auto Generated method stub
			return super.getTipData();
		}
		
		override public function getTipType():int
		{
			// TODO Auto Generated method stub
			return super.getTipType();
		}
	}
}