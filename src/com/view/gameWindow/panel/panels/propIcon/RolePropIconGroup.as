package com.view.gameWindow.panel.panels.propIcon
{
	import com.view.gameWindow.panel.panels.propIcon.icon.role.RoleEquipUpgradeIcon;
	import com.view.gameWindow.panel.panels.propIcon.icon.role.RoleBaptizeIcon;
	import com.view.gameWindow.panel.panels.propIcon.icon.role.RolePositionIcon;
	import com.view.gameWindow.panel.panels.propIcon.icon.role.RoleReinIcon;

	public class RolePropIconGroup extends PropIconGroup
	{
		public function RolePropIconGroup()
		{
			super();
			
			initRoleProps();
		}
		
		private function initRoleProps():void
		{
			addIcon(new RoleEquipUpgradeIcon());
			addIcon(new RoleBaptizeIcon());
			addIcon(new RolePositionIcon());
//			addIcon(new RoleReinIcon());
		}
	}
}