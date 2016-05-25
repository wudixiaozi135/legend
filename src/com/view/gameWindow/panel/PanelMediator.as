package  com.view.gameWindow.panel
{
    import com.view.gameWindow.panel.panelbase.IPanelBase;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.achievement.AchievementPanel;
    import com.view.gameWindow.panel.panels.activityNow.PanelActivityNow;
    import com.view.gameWindow.panel.panels.activitys.PanelActivityEnter;
    import com.view.gameWindow.panel.panels.activitys.PanelActvOverTrans;
    import com.view.gameWindow.panel.panels.activitys.castellanWorship.PanelWorship;
    import com.view.gameWindow.panel.panels.activitys.castellanWorship.PanelWorshipInfos;
    import com.view.gameWindow.panel.panels.activitys.godDevil.PanelGodDevil;
    import com.view.gameWindow.panel.panels.activitys.loongWar.PanelLoongWar;
    import com.view.gameWindow.panel.panels.activitys.loongWar.panelList.PanelLoongWarListRank;
    import com.view.gameWindow.panel.panels.activitys.loongWar.panelList.PanelLoongWarListSet;
    import com.view.gameWindow.panel.panels.activitys.loongWar.panelList.PanelLoongWarListUnion;
    import com.view.gameWindow.panel.panels.activitys.loongWar.tabInfo.PanelLoongWarChange;
    import com.view.gameWindow.panel.panels.activitys.nightFight.PanelNightFightChange;
    import com.view.gameWindow.panel.panels.activitys.nightFight.PanelNightFightRank;
    import com.view.gameWindow.panel.panels.activitys.seaFeast.PanelSeaFeastBtns;
    import com.view.gameWindow.panel.panels.activitys.seaFeast.PanelSeaFeastNpc;
    import com.view.gameWindow.panel.panels.actvPrompt.PanelActvPrompt;
    import com.view.gameWindow.panel.panels.artifact.ArtifactPanel;
    import com.view.gameWindow.panel.panels.bag.BagPanel;
    import com.view.gameWindow.panel.panels.bag.menu.PanelBagCellMenu;
    import com.view.gameWindow.panel.panels.batchUse.PanelBatchUse;
    import com.view.gameWindow.panel.panels.boss.PanelBoss;
    import com.view.gameWindow.panel.panels.boss.dungeonindividualboss.PanelIndividualBoss;
    import com.view.gameWindow.panel.panels.buyitemconfirm.PanelBuyItemConfirm;
    import com.view.gameWindow.panel.panels.charge.PanelCharge;
    import com.view.gameWindow.panel.panels.chests.PanelChests;
    import com.view.gameWindow.panel.panels.closet.ClosetPanel;
    import com.view.gameWindow.panel.panels.closet.putIn.ClosetPutInPanel;
    import com.view.gameWindow.panel.panels.convert.ConvertListPanelNew;
    import com.view.gameWindow.panel.panels.convert.ConvertStartPanel;
    import com.view.gameWindow.panel.panels.createHero.HeroWakeUpPanel;
    import com.view.gameWindow.panel.panels.createHero.PanelCreateHero;
    import com.view.gameWindow.panel.panels.daily.PanelDaily;
    import com.view.gameWindow.panel.panels.deadRevive.DeadRevivePanel;
    import com.view.gameWindow.panel.panels.demonTower.PanelDemonTower;
    import com.view.gameWindow.panel.panels.dragonTreasure.PanelTreasure;
    import com.view.gameWindow.panel.panels.dragonTreasure.treasureReward.PanelTreasureReward;
    import com.view.gameWindow.panel.panels.dragonTreasure.treasureRewardAlert.PanelTreasureRewardAlert;
    import com.view.gameWindow.panel.panels.dragonTreasure.treasureShop.PanelTreasureShop;
    import com.view.gameWindow.panel.panels.dragonTreasure.treasureWareHouse.PanelTreasureWareHouse;
    import com.view.gameWindow.panel.panels.dungeon.DgnGoalsPanel;
    import com.view.gameWindow.panel.panels.dungeon.DgnRewardPanel;
    import com.view.gameWindow.panel.panels.dungeon.DgnStarPanel;
    import com.view.gameWindow.panel.panels.dungeon.DungeonPanel;
    import com.view.gameWindow.panel.panels.dungeon.DungeonPanelIn;
    import com.view.gameWindow.panel.panels.dungeon.rewardCard.PanelDgnRewardCard;
    import com.view.gameWindow.panel.panels.dungeonTower.PanelDgnTowerBtns;
    import com.view.gameWindow.panel.panels.dungeonTower.PanelDgnTowerBuy;
    import com.view.gameWindow.panel.panels.dungeonTower.PanelDgnTowerEnter;
    import com.view.gameWindow.panel.panels.dungeonTower.PanelDgnTowerExchange;
    import com.view.gameWindow.panel.panels.dungeonTower.PanelDgnTowerInfo;
    import com.view.gameWindow.panel.panels.dungeonTower.PanelDgnTowerReward;
    import com.view.gameWindow.panel.panels.equipRecycle.PanelEquipRecycle;
    import com.view.gameWindow.panel.panels.equipRecycle.PanelEquipRecycleWarn;
    import com.view.gameWindow.panel.panels.everydayOnlineReward.PanelEverydayOnlineReward;
    import com.view.gameWindow.panel.panels.everydayReward.PanelEverydayReward;
    import com.view.gameWindow.panel.panels.exchangeShop.PanelExchangeShop;
    import com.view.gameWindow.panel.panels.expStone.AlertExpStone;
    import com.view.gameWindow.panel.panels.expStone.AlertExpStone2;
    import com.view.gameWindow.panel.panels.expStone.ExpStonePanel;
    import com.view.gameWindow.panel.panels.forge.PanelForge;
    import com.view.gameWindow.panel.panels.forge.extend.select.ExtendSelectPanel;
    import com.view.gameWindow.panel.panels.friend.PanelFriend;
    import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockObserver;
    import com.view.gameWindow.panel.panels.hejiSkill.PanelHejiSkill;
    import com.view.gameWindow.panel.panels.hejiSkill.replace.ReplacePanel;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    import com.view.gameWindow.panel.panels.hero.HeroPanel;
    import com.view.gameWindow.panel.panels.income.PanelIncome;
    import com.view.gameWindow.panel.panels.input.PanelInput;
    import com.view.gameWindow.panel.panels.keyBuy.KeyBuyPanel;
    import com.view.gameWindow.panel.panels.keySell.PanelKeySell;
    import com.view.gameWindow.panel.panels.lasting.PanelLasting;
    import com.view.gameWindow.panel.panels.levelReward.PanelLevelReward;
    import com.view.gameWindow.panel.panels.loginReward.PanelLoginReward;
    import com.view.gameWindow.panel.panels.mail.PanelMail;
    import com.view.gameWindow.panel.panels.mail.content.PanelMailContent;
    import com.view.gameWindow.panel.panels.mall.PanelMall;
    import com.view.gameWindow.panel.panels.mall.coupon.PanelCoupon;
    import com.view.gameWindow.panel.panels.mall.mallacquire.PanelAcquire;
    import com.view.gameWindow.panel.panels.mall.mallbuy.PanelMallBuy;
    import com.view.gameWindow.panel.panels.mall.mallgive.PanelMallGive;
    import com.view.gameWindow.panel.panels.map.MapPanel;
    import com.view.gameWindow.panel.panels.mining.PanelMining;
    import com.view.gameWindow.panel.panels.npcVIP.PanelNpcVIPOnHook;
    import com.view.gameWindow.panel.panels.npcfunc.PanelNpcFunc;
    import com.view.gameWindow.panel.panels.npcshop.PanelNpcShop;
    import com.view.gameWindow.panel.panels.onhook.AutoPanel;
    import com.view.gameWindow.panel.panels.openGift.PanelOpenGift;
    import com.view.gameWindow.panel.panels.position.PositionPanel;
    import com.view.gameWindow.panel.panels.pray.PanelPray;
    import com.view.gameWindow.panel.panels.prompt.Panel1BtnPrompt;
    import com.view.gameWindow.panel.panels.prompt.Panel1ImgPrompt;
    import com.view.gameWindow.panel.panels.prompt.Panel2BtnPrompt;
    import com.view.gameWindow.panel.panels.rank.PanelRank;
    import com.view.gameWindow.panel.panels.roleProperty.RolePropertyPanel;
    import com.view.gameWindow.panel.panels.roleProperty.otherRole.OtherRolePanel;
    import com.view.gameWindow.panel.panels.school.complex.SchoolPanelElse;
    import com.view.gameWindow.panel.panels.school.complex.information.donate.DonatePanel;
    import com.view.gameWindow.panel.panels.school.complex.information.eventList.SchoolEventListPanel;
    import com.view.gameWindow.panel.panels.school.complex.list.card.CardPanel;
    import com.view.gameWindow.panel.panels.school.complex.member.auditList.SchoolAuditListPanel;
    import com.view.gameWindow.panel.panels.school.complex.member.nickName.NickNamePanel;
    import com.view.gameWindow.panel.panels.school.simpleness.SchoolPanel;
    import com.view.gameWindow.panel.panels.search.SearchBlackPanel;
    import com.view.gameWindow.panel.panels.search.SearchEnemyPanel;
    import com.view.gameWindow.panel.panels.search.SearchFriendPanel;
    import com.view.gameWindow.panel.panels.search.SearchSchoolPanel;
    import com.view.gameWindow.panel.panels.skill.PanelSkill;
    import com.view.gameWindow.panel.panels.skill.panelskillset.PanelSkillSet;
    import com.view.gameWindow.panel.panels.smartLoad.PanelSmartLoad;
    import com.view.gameWindow.panel.panels.specialRing.PanelSpecialRing;
    import com.view.gameWindow.panel.panels.specialRingPrompt.PanelSpecialRingPrompt;
    import com.view.gameWindow.panel.panels.split.PanelSplit;
    import com.view.gameWindow.panel.panels.stall.PanelStall;
    import com.view.gameWindow.panel.panels.stall.alert.PanelStallAlert;
    import com.view.gameWindow.panel.panels.stall.log.PanelStallLog;
    import com.view.gameWindow.panel.panels.stall.otherstall.PanelOtherStall;
    import com.view.gameWindow.panel.panels.stall.stallBuy.PanelStallBuy;
    import com.view.gameWindow.panel.panels.stall.stallSell.PanelStallSell;
    import com.view.gameWindow.panel.panels.storage.PanelStorage;
    import com.view.gameWindow.panel.panels.storage.access.PanelAccess;
    import com.view.gameWindow.panel.panels.storage.code.PanelStoreCode;
    import com.view.gameWindow.panel.panels.stronger.PanelStronger;
    import com.view.gameWindow.panel.panels.task.npctask.NpcTaskPanel;
    import com.view.gameWindow.panel.panels.taskBoss.TaskBossPanel;
    import com.view.gameWindow.panel.panels.taskStar.PanelTaskStar;
    import com.view.gameWindow.panel.panels.taskStar.over.PanelTaskStarOver;
    import com.view.gameWindow.panel.panels.taskTrans.PanelTaskTrans;
    import com.view.gameWindow.panel.panels.team.PanelTeam;
    import com.view.gameWindow.panel.panels.team.prompt.PanelTeamPrompt;
    import com.view.gameWindow.panel.panels.thingNew.equipAlert.PanelEquipAlert;
    import com.view.gameWindow.panel.panels.thingNew.equipNew.PanelEquipNew;
    import com.view.gameWindow.panel.panels.thingNew.equipUpgrade.PanelEquipUpgradeAlert;
    import com.view.gameWindow.panel.panels.thingNew.itemNew.PanelItemNew;
    import com.view.gameWindow.panel.panels.thingNew.skillNew.PanelSkillNew;
    import com.view.gameWindow.panel.panels.trade.PanelTrade;
    import com.view.gameWindow.panel.panels.trailer.TrailerPanel;
    import com.view.gameWindow.panel.panels.trailer.complete.TrailerComplete;
    import com.view.gameWindow.panel.panels.trailer.enter.TrailerEnter;
    import com.view.gameWindow.panel.panels.trailer.hint.TrailerHint;
    import com.view.gameWindow.panel.panels.trans.MapTransPanel;
    import com.view.gameWindow.panel.panels.trans.PanelSpecialTrans;
    import com.view.gameWindow.panel.panels.trans.PanelTrans;
    import com.view.gameWindow.panel.panels.unlock.CoverPanel;
    import com.view.gameWindow.panel.panels.unlock.ExperiencePanel;
    import com.view.gameWindow.panel.panels.unlock.UnlockPanel;
    import com.view.gameWindow.panel.panels.vip.PanelVip;
    import com.view.gameWindow.panel.panels.welcome.PanelWelcome;
    import com.view.gameWindow.panel.panels.welfare.PanelWelfare;
    import com.view.gameWindow.panel.panels.wing.PanelWing;
    import com.view.newMir.sound.SoundManager;
    import com.view.newMir.sound.constants.SoundIds;
    
    import flash.display.Sprite;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;

    /**
	 * 面板介质类
	 * @author Administrator
	 */
	public class PanelMediator implements IPanelMediator
	{
		private static var _instance:PanelMediator;
		public static function get instance():PanelMediator
		{
			if (!_instance)
				_instance = new PanelMediator(hideFun);
			return _instance;
		}

		private static function hideFun():void
		{
		}
		
		private var _openPanels:Dictionary;
		private var _opendPanels:Vector.<String>;
		private var _layer:Sprite;//界面解锁相关
		private var _unlockObserver:UnlockObserver;
		private var _maskTop:Sprite;
		private var gcPoint:int;
		private const MAX_PANEL_COUNT:int=3;
		/**鼠标是否在任何面板上*/	
		public function get isMouseOnPanel():Boolean
		{
			var panelBases:Vector.<PanelBase>;
			var panelBase:PanelBase;
			for each(panelBases in _openPanels)
			{
				for each(panelBase in panelBases)
				{
					if(panelBase && panelBase.isMouseOn())
					{
						return true;
					}
				}
			}
			return false;
		}
		
		public function PanelMediator(fun:Function)
		{
			if (fun != hideFun)
			{
				throw new Error("该类使用单例模式");
			}
		}

		public function initData(layer:Sprite,maskTop:Sprite):void
		{
			_openPanels = new Dictionary();
			_opendPanels=new Vector.<String>();
			_layer = layer;
			_maskTop = maskTop;
			_maskTop.graphics.beginFill(0,0);
			_maskTop.graphics.drawRect(0,0,10,10);
			_maskTop.graphics.endFill();

			//界面解锁相关
			initUnlockState();
			_unlockObserver = new UnlockObserver();
			_unlockObserver.setCallback(updateUnlockState);
			GuideSystem.instance.unlockStateNotice.attach(_unlockObserver);
		}
		
		public function showMaskTop(visible:Boolean):void
		{
			if(_maskTop)
			{
				_maskTop.visible = visible;
			}
		}

		public function openPanel(type:String, isOnly:Boolean = true, ...args):void
		{
			var panelBases:Vector.<PanelBase> = _openPanels[type] as Vector.<PanelBase>;
			if (!panelBases)
			{
				panelBases = new Vector.<PanelBase>();
				_openPanels[type] = panelBases;
			}
			var panelBase:PanelBase = panelBases.length ? panelBases[0] : null;
			var index:int = 0;
			if (isOnly && panelBase)
			{
				if(panelBase.isSingleton)   //防止外部调用错误
				{
					showPanel(panelBase);
				}
				if (panelBase.parent.getChildIndex(panelBase) != panelBase.parent.numChildren - 1)
				{
					panelBase.parent.setChildIndex(panelBase, panelBase.parent.numChildren - 1);
				}
			}
			else
			{
				panelBase = getPanel(type);
				if (panelBase)
				{
					panelBase.args = args;
					//
					panelBases.push(panelBase);
					_openPanels[type] = panelBases;
					index = panelBases.indexOf(panelBase);
					panelBase.index = index;
					//
					panelBase.initView();
					_layer.addChild(panelBase);
					if (panelBase.isMound)
					{
						PanelFlyHandler.getInstance().panelRunShowMount(panelBase);
					}
					SoundManager.getInstance().playEffectSound(SoundIds.SOUND_ID_OPEN_PANEL);
				}
				else
				{
					trace("in PanelMediator.openPanel 该面板不存在，类型：" + type);
				}
			}
			if(panelBase!=null&&panelBase.isMound && _opendPanels.indexOf(type)==-1 )
			{
				_opendPanels.push(type);
			}
			if(_opendPanels.length>MAX_PANEL_COUNT)
			{
				closePanel(_opendPanels[0]);
			}
		}

		public function openDefaultIndexPanel(type:String, defaultIndex:int, isOnly:Boolean = true, ...args):void
		{
			var panelBases:Vector.<PanelBase> = _openPanels[type] as Vector.<PanelBase>;
			if (!panelBases)
			{
				panelBases = new Vector.<PanelBase>();
				_openPanels[type] = panelBases;
			}
			var panelBase:PanelBase = panelBases.length ? panelBases[0] : null;
			if (isOnly && panelBase)
			{
				if(panelBase.isSingleton)  //防止外部调用错误
				{
					showPanel(panelBase);
				}
				if (panelBase.parent && panelBase.parent && panelBase.parent.getChildIndex(panelBase) != panelBase.parent.numChildren - 1)
				{
					panelBase.parent.setChildIndex(panelBase, panelBase.parent.numChildren - 1);
				}
			}
			else
			{
				panelBase = getPanel(type);
				if (panelBase)
				{
					panelBase.args = args;
					//
					panelBases.push(panelBase);
					var index:int = panelBases.indexOf(panelBase);
					panelBase.index = index;
					//
					panelBase.initView();
					panelBase.setSelectTabShow(defaultIndex);
					_layer.addChild(panelBase);
					if (panelBase.isMound)
					{
						PanelFlyHandler.getInstance().panelRunShowMount(panelBase);
					}
				}
				else
				{
					trace("in PanelMediator.openPanel 该面板不存在，类型：" + type);
				}
			}
		}
		/**
		 * 显示面板，若面板未打开则打开面板
		 * @param type
		 * @param index
		 * @param isOnly
		 * @param args
		 */		
		private function showPanel(panel:PanelBase):void
		{
			if (panel)
			{
				if(!panel.parent)
				{
					panel.show(_layer);
					if (panel.isMound)
					{
						PanelFlyHandler.getInstance().panelRunShowMount(panel);
					}
				}
			}
		}
		
		private function hidePnael(panel:PanelBase):void
		{
			if (panel)
			{
				if (panel.isMound)
				{
					PanelFlyHandler.getInstance().panelRunHideMount(panel);
				} 
				else
				{
					panel.hide();
				}
			}
		}
		
		public function closePanel(type:String, index:int = 0):void
		{
			if(!_openPanels)
			{
				return;
			}
			var typeIndex:int = _opendPanels.indexOf(type);
			if(typeIndex!=-1)
			{
				_opendPanels.splice(typeIndex,1);
			}
			var panel:PanelBase;
			var panels:Vector.<PanelBase> = _openPanels[type] as Vector.<PanelBase>;
			if (panels)
			{
				if (panels.length > index)
				{
					panel = panels[index];
					if (panel)
					{
						if(panel.isSingleton)  //防止外部调用错误
						{
							hidePnael(panel);
							return;
						}
						if (panel.isMound)
						{
							PanelFlyHandler.getInstance().panelRunHideMount(panel);
						}
						else
						{
							panel.destroy();
						}
						panels[index] = null;
					}
				}
				for each(panel in panels)
				{
					if (panel)
					{
						return;
					}
				}
				delete _openPanels[type];
			}
		}
		
		public function switchPanel(type:String,isShowHide:Boolean = false):void
		{
			var panel:PanelBase = openedPanel(type) as PanelBase;
			if (panel==null)
			{
				openPanel(type);
			}
			else
			{
				if(panel.parent!=null)
				{
					closePanel(type);
				}else
				{
					openPanel(type);
				}
			}
		}
		
		/**
		 * 定期清理超过五分钟没有使用的单例面板  资源释放有问题
		 * 暂时没有使用，后期单态的数据类太多的时候可以使用
		 */
		private function timeDestroy():void
		{
			if(getTimer()-gcPoint>300000)
			{
				var obj:Object;
				for each (obj in _openPanels)
				{
					var panel:PanelBase;
					var panels:Vector.<PanelBase> = obj as Vector.<PanelBase>;
					if (panels)
					{
						for (var i:int=0;i<panels.length;i++)
						{
							panel=panels[i];
							if (panel&&panel.parent==null)
							{
								panel.destroy();
								panels[i]=null;
							}
						}
					}
				}
				gcPoint=getTimer();
			}
		}
		
		public function openedPanel(type:String, index:int = 0):IPanelBase
		{
			if(!_openPanels)
			{
				return null;
			}
			var panels:Vector.<PanelBase> = _openPanels[type] as Vector.<PanelBase>;
			if (panels && index < panels.length)
			{
				return panels[index];
			}
			return null;
		}
		
		public function openedPanels(type:String):Vector.<PanelBase>
		{
			var panels:Vector.<PanelBase> = _openPanels[type] as Vector.<PanelBase>;
			return panels;
		}
		
		public function refreshPanel(type:String, index:int = 0):void
		{
			var panel:PanelBase;
			var panels:Vector.<PanelBase> = _openPanels[type] as Vector.<PanelBase>;
			if (panels)
			{
				panel = panels[index];
				if (panel)
				{
					panel.update();
				}
			}
		}

        /**临时关闭已打开的全部面板*/
        public function closeAllOpenedPanel():void
        {
            for (var type:String in _openPanels)
            {
				if(type==PanelConst.TYPE_TRAILER_HINT)continue;
                var panels:Vector.<PanelBase> = _openPanels[type] as Vector.<PanelBase>;
                if (panels)
                {
                    panels.forEach(function (element:PanelBase, index:int, vec:Vector.<PanelBase>):void
                    {
                        if (element && element.canEscExit)
                        {
                            closePanel(type);
                        }
                    });
                }
            }
        }
		/**屏幕缩放*/
		public function resize(stageWidth:int, stageHeight:int):void
		{
			var obj:Object;
			for each (obj in _openPanels)
			{
				var panel:PanelBase;
				var panels:Vector.<PanelBase> = obj as Vector.<PanelBase>;
				if (panels)
				{
					for each(panel in panels)
					{
						if (panel&&panel.parent)
						{
							panel.setPostion();
							panel.resetPosInParent();
						}
					}
				}
			}
			
			if(_maskTop)
			{
				_maskTop.width = stageWidth;
				_maskTop.height = stageHeight;
			}
		}
		
		private function updateUnlockState(func_id:int):void
		{
			if (func_id == UnlockFuncId.HERO)
			{
				if (HeroDataManager.instance.isHeroExist == false)
				{
					openPanel(PanelConst.TYPE_HERO_CREATE);
				}
			}
		}

		private function initUnlockState():void
		{
			if (GuideSystem.instance.isUnlock(UnlockFuncId.HERO))
			{
				updateUnlockState(UnlockFuncId.HERO);
			}
		}

		/**获取面板对象*/
		private function getPanel(type:String):PanelBase
		{
			switch (type)
			{
				default:
					return null;
				case PanelConst.TYPE_GOD_DEVIL:
					return new PanelGodDevil();
				case PanelConst.TYPE_WELCOME:
					return new PanelWelcome();
				case PanelConst.TYPE_WORSHIP:
					return new PanelWorship();
				case PanelConst.TYPE_VIP_GUAJI:
					return new PanelNpcVIPOnHook();
				case PanelConst.TYPE_WORSHIP_INFOS:
					return new PanelWorshipInfos();
				case PanelConst.TYPE_BAG:
					return new BagPanel();
				case PanelConst.TYPE_TASK_ACCEPT_COMPLETE:
					return new NpcTaskPanel();
				case PanelConst.TYPE_TASK_STAR:
					return new PanelTaskStar();
				case PanelConst.TYPE_TASK_STAR_OVER:
					return new PanelTaskStarOver();
				case PanelConst.TYPE_ROLE_PROPERTY:
					return new RolePropertyPanel();
				case PanelConst.TYPE_SKILL:
					return new PanelSkill();
				case PanelConst.TYPE_SKILL_SET:
					return new PanelSkillSet();
				case PanelConst.TYPE_BAG_KEYBUY:
					return new KeyBuyPanel();
				case PanelConst.TYPE_NPC_FUNC:
					return new PanelNpcFunc();
				case PanelConst.TYPE_TRANS:
					return new PanelTrans();
				case PanelConst.TYPE_SPECIAL_TRANS:
					return new PanelSpecialTrans();
				case PanelConst.TYPE_MAP:
					return new MapPanel();
				case PanelConst.TYPE_1BTN_PROMPT:
					return new Panel1BtnPrompt(type);
				case PanelConst.TYPE_1IMG_PROMPT:
					return new Panel1ImgPrompt();
				case PanelConst.TYPE_NPC_SHOP:
					return new PanelNpcShop();
				case PanelConst.TYPE_BUY_ITEM_CONFIRM:
					return new PanelBuyItemConfirm();
				case PanelConst.TYPE_DUNGEON:
					return new DungeonPanel();
				case PanelConst.TYPE_DUNGEON_IN:
					return new DungeonPanelIn();
				case PanelConst.TYPE_MAP_TRANS:
					return new MapTransPanel();
				case PanelConst.TYPE_HERO:
					return new HeroPanel();
				case PanelConst.TYPE_CLOSET:
					return new ClosetPanel();
				case PanelConst.TYPE_CLOSET_PROMPT:
					return new Panel1BtnPrompt(type);
				case PanelConst.TYPE_CLOSET_PUT_IN:
					return new ClosetPutInPanel();
				case PanelConst.TYPE_FORGE:
					return new PanelForge();
				case PanelConst.TYPE_FORGE_EXTEND_SELECT:
					return new ExtendSelectPanel();
				/*case PanelConst.TYPE_RECYCLE_EQUIP:
					return new RecycleEquipPanel();*/
				case PanelConst.TYPE_ANTIWALLOW_HINT:
					return new Panel1BtnPrompt(type);
				case PanelConst.TYPE_INCOME:
					return new PanelIncome();
				case PanelConst.TYPE_MAIL:
					return new PanelMail();
				case PanelConst.TYPE_MAIL_CONTENT:
					return new PanelMailContent();
				case PanelConst.TYPE_MALL:
					return new PanelMall();
				case PanelConst.TYPE_MALL_BUY:
					return new PanelMallBuy();
				case PanelConst.TYPE_MALL_GIVE:
					return new PanelMallGive();
				case PanelConst.TYPE_MALL_ACQUIRE:
					return new PanelAcquire();
				case PanelConst.TYPE_MALL_COUPON:
					return new PanelCoupon();
				case PanelConst.TYPE_ASSIST_SET:
					return new AutoPanel();
				case PanelConst.TYPE_TASK_BOSS:
					return new TaskBossPanel();
				case PanelConst.TYPE_FRIEND:
					return new PanelFriend();
				case PanelConst.TYPE_EQUIP_NEW:
					return new PanelEquipNew();
				case PanelConst.TYPE_SKILL_NEW:
					return new PanelSkillNew();
				case PanelConst.TYPE_ITEM_NEW:
					return new PanelItemNew();
				case PanelConst.TYPE_CONVERT_START:
					return new ConvertStartPanel();
				case PanelConst.TYPE_CONVERT_LIST:
					return new ConvertListPanelNew();
				case PanelConst.TYPE_BAGCELL_MENU:
					return new PanelBagCellMenu();
				case PanelConst.TYPE_BATCH:
					return new PanelBatchUse();
				case PanelConst.TYPE_SPLIT:
					return new PanelSplit();
				case PanelConst.TYPE_VIP:
					return new PanelVip();
				case PanelConst.TYPE_KEY_SELL:
					return new PanelKeySell();
				case PanelConst.TYPE_DUNGEON_GOALS:
					return new DgnGoalsPanel();
				case PanelConst.TYPE_DUNGEON_STAR:
					return new DgnStarPanel();
				case PanelConst.TYPE_DUNGEON_REWARD:
					return new DgnRewardPanel();
				case PanelConst.TYPE_DUNGEON_REWARD_CARD:
					return new PanelDgnRewardCard();
				case PanelConst.TYPE_SPECIAL_RING:
					return new PanelSpecialRing();
				case PanelConst.TYPE_SPECIAL_RING_PROMPT:
					return new PanelSpecialRingPrompt();
				case PanelConst.TYPE_DAILY:
					return new PanelDaily();
				case PanelConst.TYPE_DAILY_PEP_PROMPT:
					return new Panel1BtnPrompt(type);
				case PanelConst.TYPE_DEAD_REVIVE:
					return new DeadRevivePanel();
				case PanelConst.TYPE_TASK_TRANS:
					return new PanelTaskTrans();
				case PanelConst.TYPE_ACTV_PROMPT:
					return new PanelActvPrompt();
				case PanelConst.TYPE_ACTV_OVER_TRANS:
					return new PanelActvOverTrans();
				case PanelConst.TYPE_HEJI:
					return new PanelHejiSkill();
				case PanelConst.TYPE_BOSS:
					return new PanelBoss();
				case PanelConst.TYPE_2BTN_PROMPT:
					return new Panel2BtnPrompt();
				case PanelConst.TYPE_HERO_CREATE:
					return new PanelCreateHero();
				case PanelConst.TYPE_MINING:
					return new PanelMining();
				case PanelConst.TYPE_UNLOCK:
					return new UnlockPanel();
				case PanelConst.TYPE_COVER:
					return new CoverPanel();
				case PanelConst.TYPE_DUNGEON_TOWER_ENTER:
					return new PanelDgnTowerEnter();
				case PanelConst.TYPE_DUNGEON_TOWER_REWARD:
					return new PanelDgnTowerReward();
				case PanelConst.TYPE_DUNGEON_TOWER_INFO:
					return new PanelDgnTowerInfo();
				case PanelConst.TYPE_DUNGEON_TOWER_BTNS:
					return new PanelDgnTowerBtns();
				case PanelConst.TYPE_DUNGEON_TOWER_EXCHANGE:
					return new PanelDgnTowerExchange();
				case PanelConst.TYPE_DUNGEON_TOWER_BUY:
					return new PanelDgnTowerBuy();
				case PanelConst.TYPE_ACTIVITY_ENTER:
					return new PanelActivityEnter();
				case PanelConst.TYPE_SEA_FEAST_BTNS:
					return new PanelSeaFeastBtns();
				case PanelConst.TYPE_LOONG_WAR:
					return new PanelLoongWar();
				case PanelConst.TYPE_LOONG_WAR_LIST_UNION:
					return new PanelLoongWarListUnion();
				case PanelConst.TYPE_LOONG_WAR_LIST_SET:
					return new PanelLoongWarListSet();
				case PanelConst.TYPE_LOONG_WAR_CHANGE:
					return new PanelLoongWarChange();
				case PanelConst.TYPE_LOONG_WAR_LIST_RANK:
					return new PanelLoongWarListRank();
				case PanelConst.TYPE_NIGHT_CHANGE:
					return new PanelNightFightChange();
				case PanelConst.TYPE_NIGHT_FIGHT_RANK:
					return new PanelNightFightRank();
				case PanelConst.TYPE_TEAM:
					return new PanelTeam();
				case PanelConst.TYPE_TEAM_HINT:
					return new PanelTeamPrompt();
				case PanelConst.TYPE_ACHI:
					return new AchievementPanel();
				case PanelConst.TYPE_SEARCH_FOR_FRIEND:
					return new SearchFriendPanel();
				case PanelConst.TYPE_SEARCH_FOR_ENEMY:
					return new SearchEnemyPanel();
				case PanelConst.TYPE_SEARCH_FOR_BLACK:
					return new SearchBlackPanel();
				case PanelConst.TYPE_SEARCH_FOR_SCHOOL:
					return new SearchSchoolPanel();
				case PanelConst.TYPE_EXP_STONE:
					return new ExpStonePanel();
				case PanelConst.TYPE_DUNGEON_INDIVIDUALBOSS_INFO:
					return new PanelIndividualBoss();
				case PanelConst.TYPE_STORAGE:
					return new PanelStorage();
				case PanelConst.TYPE_STORAGE_ACCESS:
					return new PanelAccess();
				case PanelConst.TYPE_STORAGE_CODE:
					return new PanelStoreCode();
				case PanelConst.TYPE_REPLACE:
					return new ReplacePanel();			
				case PanelConst.TYPE_SCHOOL_CREATE:
					return new SchoolPanel();
				case PanelConst.TYPE_SCHOOL:
					return new SchoolPanelElse();
				case PanelConst.TYPE_PRAY:
					return new PanelPray();
				case PanelConst.TYPE_POSITION:
					return new PositionPanel();
				case PanelConst.TYPE_DRAGON_TREASURE:
					return new PanelTreasure();
				case PanelConst.TYPE_DRAGON_TREASURE_REWARD:
					return new PanelTreasureReward();
				case PanelConst.TYPE_DRAGON_TREASURE_WAREHOUSE:
					return new PanelTreasureWareHouse();
				case PanelConst.TYPE_EQUIP_RECYCLE:
					return new PanelEquipRecycle();
				case PanelConst.TYPE_DONATE:
					return new DonatePanel();
				case PanelConst.TYPE_SCHOOL_EVENT:
					return new SchoolEventListPanel();
				case PanelConst.TYPE_DRAGON_TREASURE_SHOP:
					return new PanelTreasureShop();
				case PanelConst.TYPE_SCHOOL_CARD:
					return new CardPanel();
				case PanelConst.TYPE_SCHOOL_APPLY:
					return new SchoolAuditListPanel();
				case PanelConst.TYPE_ACTIVITY_ENTER:
					return new PanelActivityEnter();
				case PanelConst.TYPE_OTHER_PLAYER:
					return new OtherRolePanel();
				case PanelConst.TYPE_ARTIFACT:
					return new ArtifactPanel();
				case PanelConst.TYPE_SCHOOL_NICKNAME:
					return new NickNamePanel();
				case PanelConst.TYPE_EQUIP_RECYCLE_WARN:
					return new PanelEquipRecycleWarn();
				case PanelConst.TYPE_LEVEL_REWARD:
					return new PanelLevelReward();
				case PanelConst.TYPE_WELFARE:
					return new PanelWelfare();
				case PanelConst.TYPE_TRADE:
					return new PanelTrade();
				case PanelConst.TYPE_INPUT:
					return new PanelInput();
				case PanelConst.TYPE_ALERT_EXP_STONE:
					return new AlertExpStone();
				case PanelConst.TYPE_BECOME_STRONGER:
					return new PanelStronger();
				case PanelConst.TYPE_TRAILER_IN:
					return new TrailerEnter();
				case PanelConst.TYPE_TRAILER_COMPLETE:
					return new TrailerComplete();
				case PanelConst.TYPE_TRAILER_PANEL:
					return new TrailerPanel();
				case PanelConst.TYPE_CHESTS:
					return new PanelChests();
				case PanelConst.TYPE_TRAILER_HINT:
					return new TrailerHint();
				case PanelConst.TYPE_STALL_PANEL:
					return new PanelStall();
				case PanelConst.TYPE_STALL_SELL:
					return new PanelStallSell();
				case PanelConst.TYPE_STALL_LOG:
					return new PanelStallLog();
				case PanelConst.TYPE_STALL_BUY:
					return new PanelStallBuy();
				case PanelConst.TYPE_STALL_OTHER:
					return new PanelOtherStall();
				case PanelConst.TYPE_STALL_ALERT:
					return new PanelStallAlert();
				case PanelConst.TYPE_ACTIVITY_NOW:
					return new PanelActivityNow();
				case PanelConst.TYPE_RANK:
					return new PanelRank();
				case PanelConst.TYPE_DEMON_TOWER:
					return new PanelDemonTower();
				case PanelConst.TYPE_SEA_FEAST_NPC:
					return new PanelSeaFeastNpc();
				case PanelConst.TYPE_HERO_WAKEUP:
					return new HeroWakeUpPanel();
				case PanelConst.TYPE_EQUIP_REPAIR_ALERT:
					return new PanelLasting();
                case PanelConst.TYPE_TREASURE_REWARD_ALERT:
                    return new PanelTreasureRewardAlert();
                case PanelConst.TYPE_EQUIP_UPGRADE_ALERT:
                    return new PanelEquipUpgradeAlert();
                case PanelConst.TYPE_EQUIP_WEAR_ALERT:
                    return new PanelEquipAlert();
                case PanelConst.TYPE_CHARGE_PANEL:
                    return new PanelCharge();
                case PanelConst.TYPE_LOGIN_REWARD_PANEL:
                    return new PanelLoginReward();
				case PanelConst.TYPE_ALERT_EXP_STONE2:
					return new AlertExpStone2();
                case PanelConst.TYPE_EVERYDAY_REWARD_PANEL:
                    return new PanelEverydayReward();
				case PanelConst.TYPE_OPEN_GIFT_PANEL:
					return new PanelOpenGift();
                case PanelConst.TYPE_EXCHANGE_SHOP:
                    return new PanelExchangeShop();
				case PanelConst.TYPE_SMART_LOAD:
					return new PanelSmartLoad();
                case PanelConst.TYPE_WING:
                    return new PanelWing();
				case PanelConst.TYPE_EVERYDAY_ONLINE_REWARD:
					return new PanelEverydayOnlineReward();
				case PanelConst.TYPE_EXPERIENCE:
					return new ExperiencePanel();
			}
		}
	}
}