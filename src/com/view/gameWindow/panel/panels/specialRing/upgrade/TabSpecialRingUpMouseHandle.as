package com.view.gameWindow.panel.panels.specialRing.upgrade
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.SpecialRingLevelCfgData;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.specialRing.PanelSpecialRing;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingData;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingDataManager;
	import com.view.gameWindow.panel.panels.stronger.PanelStronger;
	import com.view.gameWindow.panel.panels.stronger.data.StrongerTabType;
	import com.view.gameWindow.panel.panels.task.linkText.LinkText;
	import com.view.gameWindow.panel.panels.task.linkText.item.LinkTextItem;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * 特戒升级页鼠标相关处理类
	 * @author Administrator
	 */	
	public class TabSpecialRingUpMouseHandle
	{
		private var _tab:TabSpecialRingUpgrade;
		private var _skin:McSpecialRingUpgrade;
		
		public function TabSpecialRingUpMouseHandle(tab:TabSpecialRingUpgrade)
		{
			_tab = tab;
			_skin = _tab.skin as McSpecialRingUpgrade;
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			_skin.addEventListener(TextEvent.LINK,onLink);
		}
		
		private function onLink(e:TextEvent):void
		{
			var data:SpecialRingData=SpecialRingDataManager.instance.getSelectData();
			var linkTexts:Vector.<LinkText>= data.linkTexts;
			var para:String=e.text;
			if(para=="getCoinLine")
			{
				dealGoldGet();
				return ;
			}
			if(para=="getShardLine")
			{
				dealChipGet();
				return ;
			}
			var paras:Array= para.split("|");
			var lid:int=paras[0];
			for each(var link:LinkText in linkTexts)
			{
				if(link && link.lId==lid)
				{
					var linkItem:LinkTextItem = link.getItemById(1);
					if(linkItem.type == LinkTextItem.TYPE_TO_NPC)
					{
						AutoJobManager.getInstance().setAutoTargetData(linkItem.npcId,EntityTypes.ET_NPC);
						/*AutoSystem.instance.setTarget(linkItem.npcId,EntityTypes.ET_NPC);*/
					}
					else if(linkItem.type == LinkTextItem.TYPE_TO_MONSTER)
					{
						/*AutoJobManager.getInstance().setAutoTargetData(linkItem.monsterId,EntityTypes.ET_MONSTER);*/
						AutoSystem.instance.setTarget(linkItem.monsterId,EntityTypes.ET_MONSTER);
					}
					else if(linkItem.type == LinkTextItem.TYPE_TO_PLANT)
					{
						AutoJobManager.getInstance().setAutoTargetData(linkItem.plantId,EntityTypes.ET_PLANT);
						/*AutoSystem.instance.setTarget(linkItem.plantId,EntityTypes.ET_PLANT);*/
					}
					else if(linkItem.type==LinkTextItem.TYPE_TO_SHOW_ITEM_TIP)
					{
						/*PanelMediator.instance.openPanel(PanelConst.TYPE_SHORT_KEY);*/
						trace("要打开商店");
					}
					else if(linkItem.type == LinkTextItem.TYPE_TO_DUNGEON)
					{
						if(!SceneMapManager.getInstance().isDungeon)
						{
							var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
							manager.enterDungeonByUpgrade(manager.select,linkItem.dungeonId);
							PanelMediator.instance.closePanel(PanelConst.TYPE_SPECIAL_RING);
						}
					}
					else if(linkItem.type == LinkTextItem.TYPE_TO_OPEN_PANEL)
					{
						if(linkItem.panelName==PanelConst.TYPE_SPECIAL_RING)
						{
							dealChangeRing(linkItem.itemid);
						}
					}
					else
					{
						trace("TabSpecialRingUpMouseHandle.onLink(e) 未知的链接去向"+linkItem.type);
					}
					break;
				}
			}
		}
		
		private function dealGoldGet():void
		{
			if (checkBottomBtnOpenState(UnlockFuncId.STRONGER))
			{
				var panel:PanelStronger = PanelMediator.instance.openedPanel(PanelConst.TYPE_BECOME_STRONGER) as PanelStronger;
				if (panel)
				{
					panel.switchToTab(StrongerTabType.TAB_WEALTH);
				}
				else
				{
					PanelMediator.instance.openPanel(PanelConst.TYPE_BECOME_STRONGER);
					panel = PanelMediator.instance.openedPanel(PanelConst.TYPE_BECOME_STRONGER) as PanelStronger;
					panel.switchToTab(StrongerTabType.TAB_WEALTH);
				}
			}
		}
		
		private function dealChipGet():void
		{
			if (checkBottomBtnOpenState(UnlockFuncId.SPECIAL_RING_DGN))
			{
				var panel:PanelSpecialRing = PanelMediator.instance.openedPanel(PanelConst.TYPE_SPECIAL_RING) as PanelSpecialRing;
				panel.setTabIndex(1);
			}
		}
		
		private function checkBottomBtnOpenState(id:int):Boolean
		{
			var isOpen:Boolean = GuideSystem.instance.isUnlock(id);
			if (!isOpen)
			{
				var tip:String = GuideSystem.instance.getUnlockTip(id);
				Alert.warning(tip);
			}
			
			return isOpen;
		}
		
		
		protected function onClick(event:MouseEvent):void
		{
			var target:MovieClip = event.target as MovieClip;
			if(!target)
			{
				return;
			}
			switch(event.target)
			{
				case _skin.mcRing1:
					dealChangeRing(SpecialRingData.RING_INDEX_1);
					break;
				case _skin.mcRing2:
					dealChangeRing(SpecialRingData.RING_INDEX_2);
					break;
				case _skin.mcRing3:
					dealChangeRing(SpecialRingData.RING_INDEX_3);
					break;
				case _skin.mcRing4:
					dealChangeRing(SpecialRingData.RING_INDEX_4);
					break;
				case _skin.mcRing5:
					dealChangeRing(SpecialRingData.RING_INDEX_5);
					break;
				case _skin.mcRing6:
					dealChangeRing(SpecialRingData.RING_INDEX_6);
					break;
				case _skin.mcRing7:
					dealChangeRing(SpecialRingData.RING_INDEX_7);
					break;
				case _skin.mcRing8:
					dealChangeRing(SpecialRingData.RING_INDEX_8);
					break;
				case _skin.btnUse:
					useSpeciaFunc();
					break;
				default:
					dealUpgrade(target);
					break;
			}
		}
		
		private function useSpeciaFunc():void
		{
			var paras:ByteArray=new ByteArray();
			paras.endian=Endian.LITTLE_ENDIAN;
			var select:int = SpecialRingDataManager.instance.select;
			paras.writeInt(select);
			var proc:int = _skin.txtBtnUse.text==StringConst.SPECIAL_RING_PANEL_0038 ? GameServiceConstants.CM_CANCEL_USE_RING : GameServiceConstants.CM_USE_RING;
			ClientSocketManager.getInstance().asyncCall(proc,paras);
		}
		
		private function dealUpgrade(target:MovieClip):Boolean
		{
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var j:int,jl:int = 10;
			var mc:McSpecialRingStarsBtns = _skin.mcUpgrade.mcStarsBtns;
			for(j=0;j<jl;j++)
			{
				var btn:MovieClip = mc["btn"+(j+1)] as MovieClip;
				if(btn.currentFrame != 2 && btn.currentFrame != 5 && btn == target.parent)
				{
					if(btn.currentFrame == 3 || btn.currentFrame == 6)
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.SPECIAL_RING_PANEL_0036);
						return false;
					}
					var level:int = SpecialRingDataManager.instance.getSelectData().level;
					var page:int = level/jl;
					var lvCfgDt:SpecialRingLevelCfgData = ConfigDataManager.instance.specialRingLevelCfgData(manager.select,page*jl+(j+1));
					if(!lvCfgDt)
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.TIP_COIN_NOT_ENOUGH);
						return false;
					}
					if(!manager.isItemEnough(lvCfgDt))
					{
						var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(lvCfgDt.item_id);
						var string:String = itemCfgData.name+StringConst.SPECIAL_RING_PANEL_0015;
						RollTipMediator.instance.showRollTip(RollTipType.ERROR,string);
						return false;
					}
					if(!manager.isCoinEnough(lvCfgDt))
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.TIP_COIN_NOT_ENOUGH);
						return false;
					}
					if(!manager.isLvEnough(lvCfgDt))
					{
						Alert.warning(StringConst.SPECIAL_RING_PANEL_0041);
						return false;
					}
					if(manager.select == manager.ringIdBy(SpecialRingData.RING_INDEX_1) && level == 4)//如果是激活了小飞鞋的功能
					{
						var sp:Point= _skin.mcUpgrade.mcKey1.localToGlobal(new Point(0,0));
						FlyEffectMediator.instance.doFlySpeciaToTask(sp);
					}
					var nextLvCfgDt:SpecialRingLevelCfgData = ConfigDataManager.instance.specialRingLevelCfgData(manager.select,page*jl+(j+1+1));
					var select:int = manager.select;
					if(!nextLvCfgDt)
					{
						ToolTipManager.getInstance().removeTip(ToolTipConst.TEXT_TIP);
						manager.select=SpecialRingDataManager.instance.ringIdBy(SpecialRingData.RING_INDEX_1);
					}
					manager.upgradeRing(select);
					showAttrReward(lvCfgDt);
					return true;
				}
			}
			return false;
		}
		
		private function showAttrReward(lvCfgDt:SpecialRingLevelCfgData):void
		{
			var lvCfgDtAttrs:Vector.<String> = CfgDataParse.getAttStringArray(lvCfgDt.attr);
			var k:int,u:int = lvCfgDtAttrs.length;
			for(k=0;k<u;k++)
			{
				if(k == 0)
				{
					RollTipMediator.instance.showRollTip(RollTipType.REWARD,lvCfgDtAttrs[k]);
				}
				else
				{
					var object:Object = new Object();
					object.k = k;
					object.timerId = setTimeout(function (obj:Object):void
					{
						clearTimeout(obj.timerId);
						RollTipMediator.instance.showRollTip(RollTipType.REWARD,lvCfgDtAttrs[obj.k]);
					},500,object);
				}
			}
		}
		
		private function dealChangeRing(index:int):void
		{
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var select:int = manager.select;
			var ringId:int = manager.ringIdBy(index);
			if(select != ringId)
			{
				SpecialRingDataManager.instance.select = ringId;
				_tab.viewHandle.refreshChangeRing();
			}
		}
		
		internal function destroy():void
		{
			_skin.removeEventListener(MouseEvent.CLICK,onClick);
			_skin.removeEventListener(TextEvent.LINK,onLink);
			_skin = null;
			_tab = null;
		}
	}
}