package com.view.gameWindow.panel.panels.guideSystem
{
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.dragonTreasure.DragonTreasureManager;
    import com.view.gameWindow.panel.panels.guideSystem.view.IPanelNano;
    import com.view.gameWindow.panel.panels.menus.MenuMediator;
    
    import flash.display.DisplayObjectContainer;

    /**
	 * @author wqhk
	 * 2014-10-28
	 */
	public class UICenter
	{
		private static var menus:Object = null;
		public function UICenter()
		{
			initMenus();
		}
		
		public static function initMenus():void
		{
			if(!menus)
			{
				menus = {	
							1:PanelConst.TYPE_MAIN_BOTTOMBAR,
							101:PanelConst.TYPE_ROLE_PROPERTY,
							102:PanelConst.TYPE_BAG,
							103:PanelConst.TYPE_SKILL,
							104:PanelConst.TYPE_FORGE,
							105:PanelConst.TYPE_ARTIFACT,
							
							111:PanelConst.TYPE_CONVERT_START,
							112:PanelConst.TYPE_CONVERT_LIST,
							113:PanelConst.TYPE_SPECIAL_RING,
							114:PanelConst.TYPE_HERO,
							115:PanelConst.TYPE_ASSIST_SET,
							
							121:PanelConst.TYPE_DUNGEON,
							122:PanelConst.TYPE_DUNGEON_IN,
							123:PanelConst.TYPE_TRANS,
							124:PanelConst.TYPE_EQUIP_RECYCLE,
							125:PanelConst.TYPE_TASK_STAR,
							126:PanelConst.TYPE_TASK_BOSS,
							127:PanelConst.TYPE_TASK_ACCEPT_COMPLETE,
							128:PanelConst.TYPE_EQUIP_NEW,
							129:PanelConst.TYPE_ITEM_NEW,
							130:PanelConst.TYPE_SKILL_NEW,
							131:PanelConst.TYPE_DUNGEON_GOALS,
							132:PanelConst.TYPE_DUNGEON_REWARD,
							133:PanelConst.TYPE_TASK_STAR_OVER,
							
							134:PanelConst.TYPE_SPECIAL_RING_PROMPT,
							135:PanelConst.TYPE_FORGE_EXTEND_SELECT,
							136:PanelConst.TYPE_ACHI,
							137:PanelConst.TYPE_DUNGEON_TOWER_BTNS,
							138:PanelConst.TYPE_DUNGEON_TOWER_REWARD,
							
							139:PanelConst.TYPE_KEY_SELL,
							140:PanelConst.TYPE_POSITION,
							141:PanelConst.TYPE_DRAGON_TREASURE,
							142:PanelConst.TYPE_DRAGON_TREASURE_REWARD,
							143:PanelConst.TYPE_DRAGON_TREASURE_SHOP,
							144:PanelConst.TYPE_DRAGON_TREASURE_SHOP_BUY,
							145:PanelConst.TYPE_DRAGON_TREASURE_WAREHOUSE,
							146:PanelConst.TYPE_MAP_TRANS,//传送的子面板
							147:PanelConst.TYPE_DUNGEON_INDIVIDUALBOSS_INFO,
							148:PanelConst.TYPE_ALERT_EXP_STONE,
							149:PanelConst.TYPE_BAG_KEYBUY,
							150:PanelConst.TYPE_LOONG_WAR,//龙城争霸
							151:PanelConst.TYPE_PRAY,//祈福
							152:PanelConst.TYPE_VIP,//vip面板
							153:PanelConst.TYPE_MALL,//商城
							154:PanelConst.TYPE_WELCOME,//欢迎界面
							155:PanelConst.TYPE_2BTN_PROMPT,//提示框
							156:PanelConst.TYPE_SPECIAL_TRANS,//特殊传送
							157:PanelConst.TYPE_EQUIP_RECYCLE_WARN,//装备回收提示
							158:PanelConst.TYPE_WING,//翅膀
							159:PanelConst.TYPE_BECOME_STRONGER,//我要变强
							
							2:PanelConst.TYPE_MAIN_TASKTRACE,
							201:PanelConst.TYPE_DUNGEON_TOWER_INFO,
							
							3:PanelConst.TYPE_MAIN_ROLEHEAD,
							301:PanelConst.TYPE_VIP,
							
							4:PanelConst.TYPE_MAIN_HEROHEAD,
							5:PanelConst.TYPE_MAIN_MINIMAP,
							6:PanelConst.TYPE_MAIN_ACTVENTER,//顶部的一排活动按钮
							601:PanelConst.TYPE_DAILY,//日常
							602:PanelConst.TYPE_WELFARE,//福利
							603:PanelConst.TYPE_BOSS,//boss
							604:PanelConst.TYPE_OPEN_GIFT_PANEL,//开服活动
							605:PanelConst.TYPE_CHARGE_PANEL//首充送礼
						}
			}
		}
		
		public static function isTaskTrace(id:*):Boolean
		{
			return id == 2;//menus 中的键值
		}
		
		public static function getUINameFromMenu(value:String):String
		{
			initMenus();
			return menus[value];
		}
		
		public static function isCanSkip(ui:String):Boolean
		{
			return ui == PanelConst.TYPE_MAIN_TASKTRACE;
		}
		
		public static function hideMainUI():void
		{
			MainUiMediator.getInstance().hide();
		}
		
		public static function hidePanels():void
		{
			PanelMediator.instance.closeAllOpenedPanel();
		}
		
		public static function showMainUI():void
		{
			MainUiMediator.getInstance().show();
		}
		
		public static function showMaskTop(visible:Boolean):void
		{
			PanelMediator.instance.showMaskTop(visible);
		}
		
		public static function getUI(name:String):*
		{
			if(!name)
			{
				return null;
			}
			
			var parts:Array = name.split(":");
			
			var name:String = getRealUIName(name);
			
			var panel:DisplayObjectContainer = getPanel(name);
			
			if(panel is IPanelNano)
			{
				if(parts && parts.length == 2)
				{
					var id:String = parts[1];
					panel = IPanelNano(panel).getNano(id);
				}
			}
			
			return panel;
		}
		
		public static function getPanel(name:String):DisplayObjectContainer
		{
			if(!name)
			{
				return null;
			}
			
			var parts:Array = name.split(":");
			
			var name:String = getRealUIName(name);
			
			var panel:DisplayObjectContainer = null;
			
			panel = MainUiMediator.getInstance().getUI(name) as DisplayObjectContainer;
			
			if(!panel)
			{
				panel = PanelMediator.instance.openedPanel(name) as DisplayObjectContainer;
			}
			
			return panel;
		}
		
		private static function getRealUIName(name:String):String
		{
			var parts:Array = name.split(":");
			if(parts && parts.length == 2)
			{
				name = parts[0];
			}
			
			return name;
		}
		
		public function openUI(name:String):void
		{
			name = getRealUIName(name);
			
//			PanelMediator.instance.openPanel(name);
            if (name == PanelConst.TYPE_DRAGON_TREASURE)
            {
                DragonTreasureManager.instance.dealSwitchPanleDragon();
            } else
            {
                PanelMediator.instance.openPanel(name);
            }
		}
		
		public function closeUI(name:String):void
		{
			name = getRealUIName(name);
			PanelMediator.instance.closePanel(name);
		}
		
		public static function openCurtain(time:Number):void
		{
			MainUiMediator.getInstance().movieCurtain.open(time);
		}
		
		public static function closeCurtain(time:Number):void
		{
			MainUiMediator.getInstance().movieCurtain.close(time);
		}
		
		public static function showCover(color:int, time:int, percent:int):void
		{
			MainUiMediator.getInstance().movieCurtain.showCover(color, time, percent);
		}
		public static function hideCover():void
		{
			MainUiMediator.getInstance().movieCurtain.hideCover();
		}
		
		public static function addSubtitle(txt:String,time:int,color:int):void
		{
			MainUiMediator.getInstance().movieCurtain.addSubtitle(txt,time,color);
		}
		
		/**
		 * @param position 0:left 1:right
		 */
		public static function addMovieTalk(txt:String,position:int,icon:String,time:Number):void
		{
			MainUiMediator.getInstance().movieCurtain.addTalk(txt,position,icon,time);
		}
		
		public static function getTopLayer():DisplayObjectContainer
		{
			return MenuMediator.instance.layer;
		}
	}
}