package com.view.gameWindow.panel.panels.vip.vipPrivilege
{
	/**
	 * 特权数据类
	 * @author Administrator
	 */	
	public class PrivilegeData
	{
		public var name:String;
		public var privileges:Vector.<int>;
		
		public function PrivilegeData()
		{
			privileges = new Vector.<int>();
			privileges.push(0);
		}
	}
}