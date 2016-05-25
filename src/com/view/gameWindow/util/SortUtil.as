package com.view.gameWindow.util
{
	public class SortUtil
	{
		public function SortUtil()
		{
		}
		
		public static function sortId(tmp:Object,tmp1:Object):int
		{
			if(tmp.id>tmp1.id)
				return 1;
			return -1;
		}
		
		public static function sortGroupId(tmp:Object,tmp1:Object):int
		{
			if(tmp.monster_group_id>tmp1.monster_group_id)
				return 1;
			return -1;
		}
	}
}