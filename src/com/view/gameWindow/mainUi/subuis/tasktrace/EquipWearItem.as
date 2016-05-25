package com.view.gameWindow.mainUi.subuis.tasktrace
{
    import com.model.business.fileService.UrlSwfLoader;
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.business.fileService.interf.IUrlSwfLoaderReceiver;
    import com.model.consts.FontFamily;
    import com.model.consts.MapConst;
    import com.model.consts.StringConst;
    import com.model.dataManager.TeleportDatamanager;
    import com.view.gameWindow.flyEffect.FlyEffectMediator;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.boss.BossDataManager;
    import com.view.gameWindow.panel.panels.dragonTreasure.DragonTreasureManager;
    import com.view.gameWindow.panel.panels.forge.ForgeDataManager;
    import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
    import com.view.gameWindow.panel.panels.guideSystem.action.OpenPanelAction;
    import com.view.gameWindow.panel.panels.onhook.AutoSystem;
    import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
    import com.view.gameWindow.panel.panels.onhook.states.common.FightPlace;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.scene.GameFlyManager;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
    import com.view.gameWindow.scene.map.SceneMapManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.UtilNumChange;
    
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.events.TextEvent;
    import flash.filters.GlowFilter;
    import flash.text.TextField;
    import flash.text.TextFormat;

    /**
	 * @author wqhk
	 * 2014-12-24
	 */
	public class EquipWearItem extends Sprite implements IUrlSwfLoaderReceiver /*implements IUrlBitmapDataLoaderReceiver*/
	{
		public static const NUM:int = 5;
		public static const HEIGHT:int = 22;
		private var linkList:Vector.<TextField>;
		private var icon:Sprite;
		private var expTxt:TextField;
		private var _exp:int = -1;
		private var _isStarUnlock:int = -1;
		private static var auto_index:Array = [0,1,4];
		private static var fly_index:Array = [0,1];
		public function doAuto():void
		{
			for(var i:int = 0; i < linkList.length; ++i)
			{
				var l:TextField = linkList[i];
				if(l && l.parent)
				{
					if(auto_index.indexOf(i)!=-1)//
					{
						executeLink(i,true);
						break;
					}
				}
			}
		}
		
		public function doFly():void
		{
			for(var i:int = 0; i < linkList.length; ++i)
			{
				var l:TextField = linkList[i];
				if(l && l.parent)
				{
					if(fly_index.indexOf(i)!=-1)//
					{
						executeCloud(i);
						break;
					}
				}
			}
		}
		
		public function EquipWearItem()
		{
			super();
			
			var pre:String = StringConst.TASK_WEAR_01;
			var links:Array = [StringConst.TASK_WEAR_03,StringConst.TASK_WEAR_07,StringConst.TASK_WEAR_04,StringConst.TASK_WEAR_05,StringConst.TASK_WEAR_06];
			
			linkList = new Vector.<TextField>(NUM);
			for(var i:int = 0; i < NUM; ++i)
			{
				var lk:TextField = createTxt();
				lk.htmlText = HtmlUtils.createHtmlStr(0xbfbfbf,pre)+HtmlUtils.createHtmlStr(0x00ff00,links[i],12,false,2,FontFamily.FONT_NAME,true,i.toString());
				lk.height = lk.textHeight + 5;
				linkList[i] = lk;
			}
			
			expTxt = createTxt();
			
			icon = new Sprite();
			icon.buttonMode = true;
			icon.addEventListener(MouseEvent.CLICK, cloudClickHandle, false, 0, true);
			
			InterObjCollector.instance.add(icon);
			
			var swfLoader:UrlSwfLoader = new UrlSwfLoader(this);//小飞鞋资源
			swfLoader.loadSwf(ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD + "common/flyShoe" + ResourcePathConstants.POSTFIX_SWF);
			
			addEventListener(TextEvent.LINK,linkHandler,false,0,true);
		}
		
		public function destroy():void
		{
			InterObjCollector.instance.remove(icon);
		}
		
		private function cloudClickHandle(e:MouseEvent):void
		{
			doFly();
		}
		
//		public function urlBitmapDataError(url:String, info:Object):void
//		{
//			// TODO Auto Generated method stub
//			
//		}
//		
//		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
//		{
//			// TODO Auto Generated method stub
//			
//		}
//		
//		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
//		{
//			var bmp:Bitmap = new Bitmap(bitmapData);
//			bmp.scaleX=HEIGHT/bmp.width;
//			bmp.scaleY=HEIGHT/bmp.height;
//			bmp.smoothing=true;
//			
//			icon.addChild(bmp);
//		}
		
		public function swfReceive(url:String, swf:Sprite, info:Object):void
		{
			if (icon && !icon.contains(swf))
			{
				icon.addChild(swf);
			}
		}
		
		public function swfProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function swfError(url:String, info:Object):void
		{
		}
		
		public function updateFlyVisible(visible:Boolean):void
		{
			if(!visible)
			{
				if(icon.parent)
				{
					icon.parent.removeChild(icon);
				}
			}
			else
			{
				if(!icon.parent || !icon.visible)
				{
					addChild(icon);
					icon.visible = RoleDataManager.instance.isCanFly > 0 && FlyEffectMediator.instance.isDoFiy == false;
				}
			}
		}
		
		private function linkHandler(e:TextEvent):void
		{
			e.stopPropagation();
			var code:int = parseInt(e.text);
			
			executeLink(code);
		}
		
		private function executeCloud(code:int):void
		{
			if(code == 0)
			{
				TeleportDatamanager.instance.setTargetEntity(TaskTraceItem.EQUIP_NPC,EntityTypes.ET_NPC);//这样设置了后 autoTask 有可能断掉 
				GameFlyManager.getInstance().flyToMapByNPC(TaskTraceItem.EQUIP_NPC);//
			}
			else if(code == 1)
			{
				TeleportDatamanager.instance.setTargetEntity(TaskTraceItem.EQUIP_NPC_BOSS,EntityTypes.ET_NPC);//这样设置了后 autoTask 有可能断掉 
				GameFlyManager.getInstance().flyToMapByNPC(TaskTraceItem.EQUIP_NPC_BOSS);//
			}
		}
		
		private function executeLink(code:int,isAuto:Boolean = false):void
		{
			var open:OpenPanelAction;
			if(code == 0)
			{
				if(SceneMapManager.getInstance().mapId == MapConst.EMOGUANGCHANG)
				{
					AutoSystem.instance.startAutoFight(FightPlace.FIGHT_PLACE_AUTO);
				}
				else
				{
					AutoJobManager.getInstance().setAutoTargetData(TaskTraceItem.EQUIP_NPC,EntityTypes.ET_NPC);
				}
			}
			else if(code == 1)
			{
				AutoJobManager.getInstance().setAutoTargetData(TaskTraceItem.EQUIP_NPC_BOSS,EntityTypes.ET_NPC);
			}
			else if(code == 2)
			{
				open = new OpenPanelAction(PanelConst.TYPE_FORGE,ForgeDataManager.typeDegree);
				open.act();
			}
			else if(code == 3)
			{
//				Alert.warning(StringConst.PROMPT_PANEL_0007);
                if (openPanel == PanelConst.TYPE_DRAGON_TREASURE)
                {//龙族宝藏须向服务器请求数据
                    DragonTreasureManager.instance.dealSwitchPanleDragon();
                } else
                {
                    PanelMediator.instance.openPanel(openPanel);
                }
			}
			else if(code == 4)
			{
				if(isAuto)
				{
					if(!SceneMapManager.getInstance().isDungeon)
					{
						//特殊做  个人boss ，以后再想个好方法
						var index:int = BossDataManager.instance.getIndividualBossValidIndex([701751]);
						if(index != -1)
						{
							open = new OpenPanelAction(PanelConst.TYPE_BOSS,BossDataManager.INDIVIDUAL_BOSS_INDEX);
							open.act();
						}
					}
				}
				else
				{
					open = new OpenPanelAction(PanelConst.TYPE_BOSS,BossDataManager.INDIVIDUAL_BOSS_INDEX);
					open.act();
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
		
		private var oldState:Object = {};
		private var openPanel:String;
		/**
		 * @param isShowIndex0 恶魔广场
		 * @param isShowIndex1 神舰
		 * @param isShowIndex2 装备进阶
		 * @param isShowIndex3 轻松获取
		 * @param isShowIndex4 挑战个人BOSS
		 */
		public function setData(exp:int,isStarUnlock:int,isShowIndex0:Boolean = true,isShowIndex1:Boolean = true,isShowIndex2:Boolean = true,isShowIndex3:Boolean = false,isShowIndex4:Boolean = false,openPanel:String = ""):void
		{
			this.openPanel = openPanel;
			var isPosChanged:Boolean = false;
			var isIndex0:Boolean = _isStarUnlock && isShowIndex0;
			
			
			if(updateLink(0,isIndex0))
			{
				isPosChanged = true;
			}
			
			if(updateLink(1,isShowIndex1))
			{
				isPosChanged = true;
			}
			
			//改变小飞鞋
			if(oldState[0] || oldState[1])
			{
				updateFlyVisible(true);
			}
			else
			{
				updateFlyVisible(false);
			}
			
			if(updateLink(2,isShowIndex2))
			{
				isPosChanged = true;
			}
			
			if(updateLink(3,isShowIndex3))
			{
				isPosChanged = true;
			}
			
			if(updateLink(4,isShowIndex4))
			{
				isPosChanged = true;
			}
		
			if(_exp != exp)
			{
				_exp = exp;
				var c:UtilNumChange = new UtilNumChange();
				expTxt.htmlText = HtmlUtils.createHtmlStr(0xbfbfbf,StringConst.TASK_WEAR_02)+HtmlUtils.createHtmlStr(0xf541cc,c.changeNum(_exp)+StringConst.TIP_EXP);
				expTxt.height = expTxt.textHeight + 5;
				if(!expTxt.parent)
				{
					addChild(expTxt);
				}
			}
			
			var h:int = 0;
			var gap:int = 0;
			if(isPosChanged)
			{
				for each(var l:TextField in linkList)
				{
					if(l.parent)
					{
						l.y = h;
						h += l.height + gap;
					}
				}
				
				icon.x = linkList[0].x + linkList[0].textWidth + 5;
				icon.y = linkList[0].y;
				
				expTxt.y = h;
			}
		}
		
		private function updateLink(index:int,isShow:Boolean):Boolean
		{
			if(oldState[index] != isShow)
			{
				oldState[index] = isShow;
				if(isShow)
				{
					addChild(linkList[index]);
				}
				else
				{
					if(linkList[index].parent)
					{
						linkList[index].parent.removeChild(linkList[index]);
					}
				}
				return true;
			}
			
			return false;
		}
	}
}