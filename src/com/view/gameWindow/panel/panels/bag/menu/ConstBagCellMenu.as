package com.view.gameWindow.panel.panels.bag.menu
{
	import com.model.consts.StringConst;

	public class ConstBagCellMenu
	{
		/**使用*/
		public static const TYPE_USE:int = 1000000;
		/**穿戴*/
		public static const TYPE_WEAR:int = 1000001;
		/**批量*/
		public static const TYPE_BATCH:int = 1000002;
		/**移动*/
		public static const TYPE_MOVE:int = 1000003;
		/**拆分*/
		public static const TYPE_SPLIT:int = 1000004;
		/**展示*/
		public static const TYPE_SHOW:int = 1000005;
		/**丢弃*/
		public static const TYPE_LITTER:int = 1000006;
		/**和平*/
		public static const TYPE_PEACE:int = 1000010;
		/**组队*/
		public static const TYPE_TROOPS:int = 1000011;
		/**帮会*/
		public static const TYPE_GUILD:int = 1000012;
		/**善恶*/
		public static const TYPE_GOODANDEVIL:int = 1000013;
		/**全体*/
		public static const TYPE_ALL:int = 1000014;
		/**主动*/
		public static const TYPE_INITIATIVE:int = 1000020;
		/**跟随*/
		public static const TYPE_FOLLOW:int = 1000021;
		/**待机*/
		public static const TYPE_STAND:int = 1000022;
		
		public static function getWordByType(type:int):String
		{
			var str:String = "";
			switch(type)
			{
				default:
					break;
				case TYPE_USE:
					str = StringConst.BAGCELL_MENU_PANEL_0001;
					break;
				case TYPE_WEAR:
					str = StringConst.BAGCELL_MENU_PANEL_0002;
					break;
				case TYPE_BATCH:
					str = StringConst.BAGCELL_MENU_PANEL_0003;
					break;
				case TYPE_MOVE:
					str = StringConst.BAGCELL_MENU_PANEL_0004;
					break;
				case TYPE_SPLIT:
					str = StringConst.BAGCELL_MENU_PANEL_0005;
					break;
				case TYPE_SHOW:
					str = StringConst.BAGCELL_MENU_PANEL_0006;
					break;
				case TYPE_LITTER:
					str = StringConst.BAGCELL_MENU_PANEL_0007;
					break;
				case TYPE_PEACE:
					str = StringConst.ROLE_HEAD_0014;
					break;
				case TYPE_TROOPS:
					str = StringConst.ROLE_HEAD_0015;
					break;
				case TYPE_GUILD:
					str = StringConst.ROLE_HEAD_0016;
					break;
				case TYPE_GOODANDEVIL:
					str = StringConst.ROLE_HEAD_0017;
					break;
				case TYPE_ALL:
					str = StringConst.ROLE_HEAD_0018;
					break;
				case TYPE_INITIATIVE:
					str = StringConst.HERO_HEAD_0001;
					break;
				case TYPE_FOLLOW:
					str = StringConst.HERO_HEAD_0002;
					break;
				case TYPE_STAND:
					str = StringConst.HERO_HEAD_0003;
					break;
			}
			return str;
		}
		
		public function ConstBagCellMenu()
		{
		}
	}
}