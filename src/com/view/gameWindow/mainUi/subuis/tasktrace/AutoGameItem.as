package com.view.gameWindow.mainUi.subuis.tasktrace
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.LevelCfgData;
    import com.model.configData.cfgdata.MapRegionCfgData;
    import com.model.configData.cfgdata.TaskCfgData;
    import com.model.consts.FontFamily;
    import com.model.consts.StringConst;
    import com.model.dataManager.TeleportDatamanager;
    import com.view.gameWindow.flyEffect.FlyEffectMediator;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.dragonTreasure.DragonTreasureManager;
    import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
    import com.view.gameWindow.panel.panels.guideSystem.action.OpenPanelAction;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UIUnlockHandler;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.task.TaskDataManager;
    import com.view.gameWindow.panel.panels.trailer.TrailerDataManager;
    import com.view.gameWindow.panel.panels.vip.VipDataManager;
    import com.view.gameWindow.scene.GameFlyManager;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.HtmlUtils;
    
    import flash.display.Sprite;
    import flash.events.TextEvent;
    import flash.filters.GlowFilter;
    import flash.text.TextField;
    import flash.text.TextFormat;

    public class AutoGameItem extends Sprite /*implements IUrlSwfLoaderReceiver*/
	{
		public static const NUM:int = 4;
		public static const HEIGHT:int = 22;
		
		public static const NPC:int = 10499;
		private var txt:TextField;

        private var itemList:Vector.<TextField>;
		
		private var _isFly:Boolean;
		private var _icon:Sprite;
		private var _height:Number;

		private var region:int;
		
		private var unlock:UIUnlockHandler;

		public function AutoGameItem()
		{
			super();
			_height = HEIGHT;
			
			itemList = new Vector.<TextField>(NUM);
			for(var i:int = 0;i < NUM; ++i)
			{
				itemList[i] = createTxt();
				itemList[i].addEventListener(TextEvent.LINK,linkHandler,false,0,true);
			}
			
			unlock = new UIUnlockHandler(null,0,updateUnlock);
			unlock.updateUIStates([UnlockFuncId.FORGE_DEGREE,UnlockFuncId.BOSS,UnlockFuncId.DRAGEON_TREASURE,
				UnlockFuncId.EQUIP_RECYCLE,UnlockFuncId.BODYGUARD_TASK/*UnlockFuncId.DRAGEON_TREASURE*/]);
			updateUpgrade();
			updateCoin();
			updateStreng();
		}
		
		private function updateStreng():void
		{
			var isStreng:Boolean =RoleDataManager.instance.lv>60;
			
			var link0:String = HtmlUtils.createHtmlStr(0x00ff00,StringConst.INSTRUCTION_11,12,false,2,FontFamily.FONT_NAME,true,"linkStreng0") ;
			
			var book:Array = [link0];
			
			if(!isStreng)
			{
				if(itemList[3].parent)
				{
					itemList[3].parent.removeChild(itemList[3]);
				}
			}
			else
			{
				var txt:String = HtmlUtils.createHtmlStr(0xffcc00,StringConst.INSTRUCTION_12);
				for each(var link:String in book)
				{
					if(link)
					{
						txt += link + " ";
					}
				}
				itemList[3].htmlText = txt;
				itemList[3].height = itemList[3].textHeight + 5;
				addChild(itemList[3]);
			}
			updatePos();
		}
		
		private function updateUnlock(id:int):void
		{
			if(id == UnlockFuncId.FORGE_DEGREE 
				|| id == UnlockFuncId.BOSS 
				/*|| id == UnlockFuncId.DRAGEON_TREASURE*/
				|| id == UnlockFuncId.DRAGEON_TREASURE)
			{
				updateEquip();
			}else if(id==UnlockFuncId.BODYGUARD_TASK)
			{
				updateCoin();
			}
			else
			{
				updateUpgrade();
				
			}
		}
		
		private function updateCoin():void
		{
			// TODO Auto Generated method stub
			var isTrailer:Boolean = GuideSystem.instance.isUnlock(UnlockFuncId.BODYGUARD_TASK);
			var isBuy:Boolean =RoleDataManager.instance.lv>60;
			
			var link0:String = isTrailer ? HtmlUtils.createHtmlStr(0x00ff00,StringConst.TRAILER_HINT_STRING_010,12,false,2,FontFamily.FONT_NAME,true,"linkCoin0") : "";
			var link1:String = isBuy ? HtmlUtils.createHtmlStr(0x00ff00,StringConst.INSTRUCTION_14,12,false,2,FontFamily.FONT_NAME,true,"linkCoin1") : "";
			
			var book:Array = [link0,link1];
			
			if(!isTrailer && !isBuy)
			{
				if(itemList[2].parent)
				{
					itemList[2].parent.removeChild(itemList[2]);
				}
			}
			else
			{
				var txt:String = HtmlUtils.createHtmlStr(0xffcc00,StringConst.INSTRUCTION_15);
				for each(var link:String in book)
				{
					if(link)
					{
						txt += link + " ";
					}
				}
				itemList[2].htmlText = txt;
				itemList[2].height = itemList[2].textHeight + 5;
				addChild(itemList[2]);
			}
			updatePos();
		}
		
		public function updateLv():void
		{
			updateUpgrade();
			updateCoin();
			updateStreng();
		}
		
		private function updateUpgrade():void
		{
			var isRecycle:Boolean = GuideSystem.instance.isUnlock(UnlockFuncId.EQUIP_RECYCLE);
			var isAuto:Boolean =TaskDataManager.instance.checkMainTaskDone(11250);
			var isStone:Boolean =false
//			GuideSystem.instance.isUnlock(UnlockFuncId.EXP_STONE);
			
			var link0:String = isRecycle ? HtmlUtils.createHtmlStr(0x00ff00,StringConst.RECYCLE_EQUIP_PANEL_0011,12,false,2,FontFamily.FONT_NAME,true,"linkUpgrade0") : "";
			var link1:String = isAuto ? HtmlUtils.createHtmlStr(0x00ff00,StringConst.INSTRUCTION_7,12,false,2,FontFamily.FONT_NAME,true,"linkUpgrade1") : "";
			var link2:String = isStone ? HtmlUtils.createHtmlStr(0x00ff00,StringConst.FORGE_PANEL_0126,12,false,2,FontFamily.FONT_NAME,true,"linkUpgrade2") : "";
			
			var book:Array = [link0,link1,link2];
			
			if(!isRecycle && !isAuto && !isStone)
			{
				if(itemList[1].parent)
				{
					itemList[1].parent.removeChild(itemList[1]);
				}
			}
			else
			{
				var txt:String = HtmlUtils.createHtmlStr(0xffcc00,StringConst.INSTRUCTION_6);
				for each(var link:String in book)
				{
					if(link)
					{
						txt += link + " ";
					}
				}
				itemList[1].htmlText = txt;
				itemList[1].height = itemList[1].textHeight + 5;
				addChild(itemList[1]);
			}
			updatePos();
		}
		
		public function updateEquip():void
		{
			var isUp:Boolean = GuideSystem.instance.isUnlock(UnlockFuncId.FORGE_DEGREE);
			var isBoss:Boolean = GuideSystem.instance.isUnlock(UnlockFuncId.BOSS);
//			var isDragon:Boolean = GuideSystem.instance.isUnlock(UnlockFuncId.DRAGEON_TREASURE);
//			var isDgn:Boolean = GuideSystem.instance.isUnlock(UnlockFuncId.DUNGEON_EQUIP);
			var isTreasure:Boolean = GuideSystem.instance.isUnlock(UnlockFuncId.DRAGEON_TREASURE);
			
			var link0:String = isUp ? HtmlUtils.createHtmlStr(0x00ff00,StringConst.FORGE_PANEL_00012,12,false,2,FontFamily.FONT_NAME,true,"linkEquip0") : "";
			var link1:String = isBoss ? HtmlUtils.createHtmlStr(0x00ff00,StringConst.INSTRUCTION_9,12,false,2,FontFamily.FONT_NAME,true,"linkEquip1") : "";
			var link2:String = isTreasure ? HtmlUtils.createHtmlStr(0x00ff00,StringConst.INSTRUCTION_10,12,false,2,FontFamily.FONT_NAME,true,"linkEquip2") : "";
			
			var book:Array = [link0,link1,link2];
			
			if(!isUp && !isBoss && !isTreasure)
			{
				if(itemList[0].parent)
				{
					itemList[0].parent.removeChild(itemList[0]);
				}
			}
			else
			{
				var txt:String = HtmlUtils.createHtmlStr(0xffcc00,StringConst.INSTRUCTION_5);
				for each(var link:String in book)
				{
					if(link)
					{
						txt += link + " ";
					}
				}
				itemList[0].htmlText = txt;
				itemList[0].height = itemList[0].textHeight + 5;
				addChild(itemList[0]);
			}
			
			updatePos();
		}
		
		private var lastLv:int;
		private var lastRe:int;
		public function updateLvUp():void
		{
			if(lastLv != RoleDataManager.instance.lv || lastRe != RoleDataManager.instance.reincarn)
			{
				lastLv = RoleDataManager.instance.lv;
				lastRe = RoleDataManager.instance.reincarn;
				var isLv:Boolean = RoleDataManager.instance.reincarn > 0 || RoleDataManager.instance.lv >= 50;
				region = 0;
				if(isLv)
				{
					var levelCfgData:LevelCfgData = ConfigDataManager.instance.levelCfgData(RoleDataManager.instance.lv);
					if(levelCfgData)
					{
						region = levelCfgData.region;
						var mapRegionCfgData:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(levelCfgData.region);
						if(mapRegionCfgData)
						{
							var link0:String = HtmlUtils.createHtmlStr(0x00ff00,StringConst.INSTRUCTION_8,12,false,2,FontFamily.FONT_NAME,true,"linkLvUp0");
							var link1:String = HtmlUtils.createHtmlStr(0x00ff00,StringConst.INSTRUCTION_7,12,false,2,FontFamily.FONT_NAME,true,"linkLvUp1");
							var txt:String = HtmlUtils.createHtmlStr(0xffcc00,StringConst.INSTRUCTION_6) + link0 + " " + link1;
							
							itemList[1].htmlText = txt;
							itemList[1].height = itemList[1].textHeight + 5;
							addChild(itemList[1]);
							
							updatePos();
							return;
						}
					}
				}
				
				if(itemList[1].parent)
				{
					itemList[1].parent.removeChild(itemList[1]);
				}
				updatePos();
			}
		}
		
		private function updatePos():void
		{
			var index:int = 0;
			for each(var item:TextField in itemList)
			{
				if(item.parent)
				{
					item.y = index*HEIGHT;
					++index;
				}
			}
		}
		
		private function createTxt():TextField
		{
			var re:TextField = new TextField;
			re.selectable = false;
			re.width = 200;
			re.filters = [new GlowFilter(0,1,3,3,10)];
			var defaultTextFormat:TextFormat = re.defaultTextFormat;
			defaultTextFormat.font = FontFamily.FONT_NAME;
			re.defaultTextFormat = defaultTextFormat;
			re.setTextFormat(defaultTextFormat);
			return re;
		}
		
		private function get isFly():Boolean
		{
			return RoleDataManager.instance.isCanFly > 0 && 
					FlyEffectMediator.instance.isDoFiy == false;
		}
		
		private function linkHandler(e:TextEvent):void
		{
			var open:OpenPanelAction;
			switch(e.text)
			{
				case "linkEquip0":
					open = new OpenPanelAction(PanelConst.TYPE_FORGE,1);
					open.act();
					break;
				case "linkEquip1":
					open = new OpenPanelAction(PanelConst.TYPE_BOSS,0);
					open.act();
					break;
				case "linkEquip2":
                    DragonTreasureManager.instance.dealSwitchPanleDragon();
					break;
				case "linkUpgrade0":
					dealVip();
					break;
				case "linkUpgrade1":
					dealOnHook();
					break;
				case "linkUpgrade2":
					open = new OpenPanelAction(PanelConst.TYPE_MALL,5);
					open.act();
				case "linkStreng0":
					dealOnHook();
					break;
				case "linkCoin0":
					if(RoleDataManager.instance.stallStatue)
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
						return;
					}
					
					var taskCfgData:TaskCfgData = TrailerDataManager.getInstance().getTasktrailerCfg();
					if(isFly)
					{
						TeleportDatamanager.instance.setTargetEntity(taskCfgData.start_npc,EntityTypes.ET_NPC);
						GameFlyManager.getInstance().flyToMapByNPC(taskCfgData.start_npc);
					}
					else
					{
						AutoJobManager.getInstance().setAutoTargetData(taskCfgData.start_npc,EntityTypes.ET_NPC);
					}
					break;
				case "linkCoin1":
					open = new OpenPanelAction(PanelConst.TYPE_MALL,5);
					open.act();
					break;
			}
		}
		
		public function dealVip():void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			
			var lv:int = VipDataManager.instance.lv;
			if(lv == 0)
			{
				PanelMediator.instance.openPanel(PanelConst.TYPE_EQUIP_RECYCLE_WARN);
				return;
			}
			var flag:int = ConfigDataManager.instance.vipCfgData(lv).recycle_btn;
			
			flag == 0 ?PanelMediator.instance.openPanel(PanelConst.TYPE_EQUIP_RECYCLE_WARN):PanelMediator.instance.switchPanel(PanelConst.TYPE_EQUIP_RECYCLE);
		}
		
		private function dealOnHook():void
		{
			if(RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			
			if(isFly)
			{
				TeleportDatamanager.instance.setTargetEntity(NPC,EntityTypes.ET_NPC);
				GameFlyManager.getInstance().flyToMapByNPC(NPC);
			}
			else
			{
				AutoJobManager.getInstance().setAutoTargetData(NPC,EntityTypes.ET_NPC);
			}
		}
		
		
		public function destroy():void
		{
			unlock.destroy();
			for each(var txt:TextField in itemList)
			{
				txt.removeEventListener(TextEvent.LINK,linkHandler);
				if(txt.parent)
				{
					txt.parent.removeChild(txt);
				}
			}
		}
	}
}