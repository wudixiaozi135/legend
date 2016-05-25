package com.view.gameWindow.mainUi.subuis.bottombar
{
    import com.event.GameDispatcher;
    import com.event.GameEvent;
    import com.event.GameEventConst;
    import com.greensock.TweenLite;
    import com.greensock.easing.Circ;
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipExchangeCfgData;
    import com.model.configData.cfgdata.LevelCfgData;
    import com.model.configData.cfgdata.SkillCfgData;
    import com.model.consts.EffectConst;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.mem.MemEquipDataManager;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.mainUi.MainUi;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarCellHandle;
    import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarDataManager;
    import com.view.gameWindow.mainUi.subuis.bottombar.heji.AngryHandler;
    import com.view.gameWindow.mainUi.subuis.bottombar.heji.HejiSkillIconHandler;
    import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.ISysAlert;
    import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.SysAlert;
    import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.SysAlertDataManage;
    import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.TeamHintDataManager;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.bag.BagPanelClickHander;
    import com.view.gameWindow.panel.panels.boss.BossDataManager;
    import com.view.gameWindow.panel.panels.convert.ConvertListPanelNew;
    import com.view.gameWindow.panel.panels.daily.DailyDataManager;
    import com.view.gameWindow.panel.panels.equipRecycle.EquipRecycleDataManager;
    import com.view.gameWindow.panel.panels.forge.ForgeDataManager;
    import com.view.gameWindow.panel.panels.friend.ContactDataManager;
    import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
    import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockObserver;
    import com.view.gameWindow.panel.panels.guideSystem.view.GuideArrow;
    import com.view.gameWindow.panel.panels.guideSystem.view.GuideArrowTalk;
    import com.view.gameWindow.panel.panels.hejiSkill.HejiSkillDataManager;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    import com.view.gameWindow.panel.panels.hero.HeroPanel;
    import com.view.gameWindow.panel.panels.onhook.AutoDataManager;
    import com.view.gameWindow.panel.panels.onhook.AutoSystem;
    import com.view.gameWindow.panel.panels.onhook.states.common.FightPlace;
    import com.view.gameWindow.panel.panels.position.PositionDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
    import com.view.gameWindow.panel.panels.specialRing.SpecialRingDataManager;
    import com.view.gameWindow.panel.panels.team.TeamDataManager;
    import com.view.gameWindow.panel.panels.trade.TradeDataManager;
    import com.view.gameWindow.panel.panels.unlock.UnlockAnim;
    import com.view.gameWindow.panel.panels.vip.VipDataManager;
    import com.view.gameWindow.panel.panels.wing.PanelWingDataManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.tips.toolTip.TipVO;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.UIEffectLoader;
    import com.view.gameWindow.util.cell.IconCellSkill;
    
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.filters.ColorMatrixFilter;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
     * 主界面底部条类
     * @author Administrator
     */
    public class BottomBar extends MainUi implements IBottomBar,IObserver
    {
        public function BottomBar()
        {
            super();

            mouseEnabled = false;

            ActionBarDataManager.instance.attach(this);
            RoleDataManager.instance.attach(this);
            BagDataManager.instance.attach(this);
            HeroDataManager.instance.attach(this);
            TeamHintDataManager.instance.attach(this);
            ContactDataManager.instance.attach(this);
            SysAlertDataManage.getInstance().attach(this);
            AutoDataManager.instance.attach(this);
            TradeDataManager.instance.attach(this);
            MemEquipDataManager.instance.attach(this);
            HejiSkillDataManager.instance.attach(this);
            GameDispatcher.addEventListener(GameEventConst.THING_INTO_BAG_EFFECT, handlerEffect, false, 0, true);
            GameDispatcher.addEventListener(GameEventConst.EXP_INTO_BOTTOM, handlerExpEffect, false, 0, true);
        }

        private var _cellHandle:ActionBarCellHandle;
        private var _angryHandler:AngryHandler;
        private var _iconHandler:HejiSkillIconHandler;
        private var _effectLaoder:UIEffectLoader;
        private var _unlockObserver:UnlockObserver;
        private var _unlockAnimObserver:UnlockObserver;
        private var _grayFilter:ColorMatrixFilter;
        private var _mcMainUIBottom:McMainUIBottom;
        private var _vector:Vector.<Number>;
        private var _isInitExp:Boolean = false;//是否初始化经验条动画
        private var _initExpCount:int;
        private var _lastExp:int;
        private var _exp:int;
        private var _count:int;
        private var _skillLock:Bitmap;
        private var _sysAlert:SysAlert;

        public function get sysAlert():ISysAlert
        {
            return _sysAlert;
        }

        private var lvValue:int;

        private var _bottomBarHandler:BottomBarHandler;
        private var sprite:Sprite;

        private var _uiEffectLoader:UIEffectLoader;
        private var _uiEnterBagEffect:UIEffectLoader;//有东西进入背包时，播放的特效
        private var _uiEnterBagContainer:Sprite;//进入背包时，承载特效的容器
        private var _uiExpEffectLoader:UIEffectLoader;
        private var _uiExpExplosionContainer:Sprite;//回收经验时，承载特效的容器
        override public function initView():void
        {
            _skin = new McMainUIBottom();
            _skin.mouseEnabled = false;
            _skin.hpTxt.mouseEnabled = false;
            _skin.maxHpTxt.mouseEnabled = false;
            _skin.mpTxt.mouseEnabled = false;
            _skin.maxMpTxt.mouseEnabled = false;
			_skin.hpTxt.visible = false;
			_skin.maxHpTxt.visible = false;
			_skin.mpTxt.visible = false;
			_skin.maxMpTxt.visible = false;
			_skin.txtSpecialRingCountBG.mouseEnabled = false;
			_skin.txtBagCountBG.mouseEnabled = false;
			_skin.txtHeroCountBG.mouseEnabled = false;
			_skin.txtPositionCountBG.mouseEnabled = false;
            _mcMainUIBottom = _skin as McMainUIBottom;

            _sysAlert = new SysAlert();
            addChild(_sysAlert);
            _sysAlert.x = 200;
            _sysAlert.y = 0;

			addChild(_skin);
            super.initView();
			this.mouseEnabled = false;
            //
            addEventListener(MouseEvent.CLICK, onClick);
            _cellHandle = new ActionBarCellHandle(_mcMainUIBottom);
            _angryHandler = new AngryHandler(this);
            _iconHandler = new HejiSkillIconHandler(this);
            _bottomBarHandler = new BottomBarHandler(this);
            addExpTipListener();
            addHpTips();
            addMpTips();


            _grayFilter = new ColorMatrixFilter();
            _grayFilter.matrix = [0.15, 0.15, 0.15, 0, 0,
                0.15, 0.15, 0.15, 0, 0,
                0.15, 0.15, 0.15, 0, 0,
                0, 0, 0, 1, 0];
            //开启状态
            _unlockObserver = new UnlockObserver();
            _unlockObserver.setCallback(updateFunctionBtn);
            GuideSystem.instance.unlockStateNotice.attach(_unlockObserver);
            //开启动画
            _unlockAnimObserver = new UnlockObserver();
            _unlockAnimObserver.setCallback(updateFunctionBtnAnim);
            GuideSystem.instance.unlockAnimNotice.attach(_unlockAnimObserver);
            _vector = new Vector.<Number>();
            sprite = new Sprite();
            _skin.addChild(sprite);
            sprite.visible = false;
            _uiEnterBagContainer = new Sprite();
            _skin.addChild(_uiEnterBagContainer);
            _uiEnterBagContainer.mouseEnabled = false;
            _uiEnterBagContainer.mouseChildren = false;

            _uiExpExplosionContainer = new Sprite();
            _skin.addChild(_uiExpExplosionContainer);
            _uiExpExplosionContainer.mouseEnabled = false;
            _uiExpExplosionContainer.mouseChildren = false;

            _uiEffectLoader = new UIEffectLoader(sprite, _mcMainUIBottom.mcExp.x, _mcMainUIBottom.mcExp.y + 5, 1, 1, EffectConst.RES_EXP_EFFECT);
			_effectLaoder = new UIEffectLoader(_mcMainUIBottom.vipBtn.parent,_mcMainUIBottom.vipBtn.x + _mcMainUIBottom.vipBtn.width*.5,_mcMainUIBottom.vipBtn.y + _mcMainUIBottom.vipBtn.height*.5,1,1,EffectConst.RES_VIP);
        }

        protected function onClick(event:MouseEvent):void
        {
            var movieClip:MovieClip = event.target as MovieClip;
            var mcMainUIBottom:McMainUIBottom = _skin as McMainUIBottom;
            switch (movieClip)
            {
                case mcMainUIBottom.btnBag:
                    dealBtnBag();
                    break;
                case mcMainUIBottom.roleBtn:
                    dealBtnRole();
                    break;
                case mcMainUIBottom.skillBtn:
                    dealBtnSkill();
                    break;
                case mcMainUIBottom.forgeBtn:
                    dealBtnForge();
                    break;
                case mcMainUIBottom.onhookBtn:
                    dealBtnAssistSet();
                    break;
                case mcMainUIBottom.onConvertStartBtn:
                    dealBtnConvertStart();
                    break;
                case mcMainUIBottom.ringUpBtn:
                    dealBtnConvertList();
                    break;
                case mcMainUIBottom.btnSpecialRing:
                    dealBtnSpecialRing();
                    break;
                case mcMainUIBottom.teamBtn:
                    dealBtnTeam();
                    break;
                case mcMainUIBottom.btnWing:
                    dealWing();
                    break;
                case mcMainUIBottom.factionBtn:
                    dealBtnFaction();
                    break;
                case mcMainUIBottom.btnCloset:
                    dealBtnPosition();
                    break;
                case mcMainUIBottom.shopBtn:
                    dealBtnShop();
                    break;
                case mcMainUIBottom.btnHero:
                    dealBtnHero();
                    break;
                case mcMainUIBottom.vipBtn:
                    dealBtnVip();
                    break;
                default:
                    dealOthers(event);
                    break;
            }
        }

        private function dealWing():void
        {
            PanelWingDataManager.instance.dealPanel();
        }

        private function handlerExpEffect(event:GameEvent):void
        {
            var centerP:Point;
            var mc:MovieClip = _mcMainUIBottom.mcExp;
            var lv:int = ExpRecorder.record_lv;
            var exp:int = ExpRecorder.record_exp;
            var levelCfgData:LevelCfgData = ConfigDataManager.instance.levelCfgData(lv);
            if (!levelCfgData)
            {
                return;
            }
            var scaleX:Number = exp / levelCfgData.player_exp;
            var mcExpWidth:Number = scaleX * mc.width;
            centerP = new Point(mc.x + mcExpWidth, mc.y + (mc.height * .3));

            if (_uiExpEffectLoader)
            {
                _uiExpEffectLoader.destroy();
                _uiExpEffectLoader = null;
            }
            _uiExpEffectLoader = new UIEffectLoader(_uiExpExplosionContainer, centerP.x, centerP.y, 1, 1, EffectConst.RES_EXP_EXPLOSION,null, true, function ():void
			{
				refreshStoneExp();
			});
        }
        private function handlerEffect(event:GameEvent):void
        {
            var mcMainUIBottom:McMainUIBottom = _skin as McMainUIBottom;
            var type:int = event.param.type;
            if (_uiEnterBagEffect)
            {
                _uiEffectLoader.destroy();
                _uiEffectLoader = null;
            }
            var centerP:Point;
            var mc:MovieClip;
            //type 1角色 2背包 3技能 4帮会 5锻造 6官印 7神炉 8特戒 9英雄 10商城 11翅膀
            if (type == 1)
            {
                if (mcMainUIBottom && mcMainUIBottom.roleBtn)
                {
                    mc = mcMainUIBottom.roleBtn;
                    centerP = new Point(mc.x + (mc.width >> 1), mc.y + (mc.height >> 1));
                }
            } else if (type == 2)
            {
                if (mcMainUIBottom && mcMainUIBottom.btnBag)
                {
                    mc = mcMainUIBottom.btnBag;
                    centerP = new Point(mc.x + (mc.width >> 1), mc.y + (mc.height >> 1));
                }
            } else if (type == 3)
            {
                if (mcMainUIBottom && mcMainUIBottom.skillBtn)
                {
                    mc = mcMainUIBottom.skillBtn;
                    centerP = new Point(mc.x + (mc.width >> 1), mc.y + (mc.height >> 1));
                }
            } else if (type == 4)
            {
                if (mcMainUIBottom && mcMainUIBottom.factionBtn)
                {
                    mc = mcMainUIBottom.factionBtn;
                    centerP = new Point(mc.x + (mc.width >> 1), mc.y + (mc.height >> 1));
                }
            } else if (type == 5)
            {
                if (mcMainUIBottom && mcMainUIBottom.forgeBtn)
                {
                    mc = mcMainUIBottom.forgeBtn;
                    centerP = new Point(mc.x + (mc.width >> 1), mc.y + (mc.height >> 1));
                }
            } else if (type == 6)
            {
                if (mcMainUIBottom && mcMainUIBottom.btnCloset)
                {
                    mc = mcMainUIBottom.btnCloset;
                    centerP = new Point(mc.x + (mc.width >> 1), mc.y + (mc.height >> 1));
                }
            } else if (type == 7)
            {
                if (mcMainUIBottom && mcMainUIBottom.ringUpBtn)
                {
                    mc = mcMainUIBottom.ringUpBtn;
                    centerP = new Point(mc.x + (mc.width >> 1), mc.y + (mc.height >> 1));
                }
            } else if (type == 8)
            {
                if (mcMainUIBottom && mcMainUIBottom.btnSpecialRing)
                {
                    mc = mcMainUIBottom.btnSpecialRing;
                    centerP = new Point(mc.x + (mc.width >> 1), mc.y + (mc.height >> 1));
                }
            } else if (type == 9)
            {
                if (mcMainUIBottom && mcMainUIBottom.btnHero)
                {
                    mc = mcMainUIBottom.btnHero;
                    centerP = new Point(mc.x + (mc.width >> 1), mc.y + (mc.height >> 1));
                }
            } else if (type == 10)
            {
                if (mcMainUIBottom && mcMainUIBottom.shopBtn)
                {
                    mc = mcMainUIBottom.shopBtn;
                    centerP = new Point(mc.x + (mc.width >> 1), mc.y + (mc.height >> 1));
                }
            } else if (type == 11)
            {
                if (mcMainUIBottom && mcMainUIBottom.btnWing)
                {
                    mc = mcMainUIBottom.btnWing;
                    centerP = new Point(mc.x + (mc.width >> 1), mc.y + (mc.height >> 1));
                }
            }
            _uiEffectLoader = new UIEffectLoader(_uiEnterBagContainer, centerP.x, centerP.y, 1, 1, EffectConst.RES_BAG_DOWN, null, true);
        }

        private function dealBtnVip():void
        {
            // TODO Auto Generated method stub
            VipDataManager.instance.queryVipInfo();
            PanelMediator.instance.switchPanel(PanelConst.TYPE_VIP);
        }

        private function dealOthers(event:MouseEvent):void
        {
            var cell:IconCellSkill = event.target as IconCellSkill;
            if (cell)
            {
                cell.onClick();
            }
        }

        private function dealBtnShop():void
        {
            if (checkBottomBtnOpenState(UnlockFuncId.MALL))
            {
                var mediator:PanelMediator = PanelMediator.instance;
                if (mediator.openedPanel(PanelConst.TYPE_MALL))
                {
                    mediator.closePanel(PanelConst.TYPE_MALL);
                }
                else
                {
                    mediator.openPanel(PanelConst.TYPE_MALL);
                }
            }
        }

        private function dealBtnPosition():void
        {
            /*RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0007);*/
            if (checkBottomBtnOpenState(UnlockFuncId.POSITION))
            {
                var mediator:PanelMediator = PanelMediator.instance;
                if (mediator.openedPanel(PanelConst.TYPE_POSITION))
                {
                    mediator.closePanel(PanelConst.TYPE_POSITION);
                }
                else
                {
                    /*ClosetDataManager.instance.request();
                     PositionDataManager.instance.requestInfo();*/
                    mediator.openPanel(PanelConst.TYPE_POSITION);
                }
            }
        }

        private function dealBtnFaction():void
        {
            if (checkBottomBtnOpenState(UnlockFuncId.GUILD))
            {
                //帮会
                if (SchoolDataManager.getInstance().schoolBaseData.schoolId != 0)  //如果已经有门派了
                {
                    PanelMediator.instance.switchPanel(PanelConst.TYPE_SCHOOL);
                }
                else
                {
                    PanelMediator.instance.switchPanel(PanelConst.TYPE_SCHOOL_CREATE);//测试代码
                }
            }
        }

        private function dealBtnHeji():void
        {
            if (checkBottomBtnOpenState(UnlockFuncId.ATTACK_HEJI))
            {
                PanelMediator.instance.switchPanel(PanelConst.TYPE_HEJI);
            }
        }

        private function dealBtnBag():void
        {
            HeroDataManager.instance.isExchange = false;
            PanelMediator.instance.closePanel(PanelConst.TYPE_KEY_SELL);
            PanelMediator.instance.switchPanel(PanelConst.TYPE_BAG, true);
        }

        private function dealBtnRole():void
        {
            PanelMediator.instance.switchPanel(PanelConst.TYPE_ROLE_PROPERTY);
        }

        private function dealBtnForge():void
        {
            if (checkBottomBtnOpenState(UnlockFuncId.FORGE))
            {
                ForgeDataManager.instance.dealSwitchPanel();
            }
        }

        private function dealBtnAssistSet():void
        {
            if (RoleDataManager.instance.stallStatue)
            {
                RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
                return;
            }
            var isFight:Boolean = AutoSystem.instance.isAutoFight();
            if (isFight)
            {
                AutoSystem.instance.stopAuto();
            }
            else
            {
                AutoSystem.instance.startAutoFight(FightPlace.FIGHT_PLACE_AUTO);
            }
        }

        private function dealBtnSkill():void
        {
            if (checkBottomBtnOpenState(UnlockFuncId.SKILL))
            {
                PanelMediator.instance.switchPanel(PanelConst.TYPE_SKILL);
            }
        }

        private function dealBtnConvertStart():void
        {
            PanelMediator.instance.switchPanel(PanelConst.TYPE_CONVERT_START);
        }

        private function dealBtnConvertList():void
        {
			var mcMainUIBottom:McMainUIBottom = _skin as McMainUIBottom;
            if (checkBottomBtnOpenState(UnlockFuncId.CONVERT_LIST))
            {
				var cfg:EquipExchangeCfgData  = ConfigDataManager.instance.equipExchangeCfgData(RoleDataManager.instance.getFireHeartId());
				if(cfg)
				{
					if(cfg.current_star<5)
						ConvertListPanelNew.DEFAULT_SELECTED_INDEX = cfg.step-1;
					else
						ConvertListPanelNew.DEFAULT_SELECTED_INDEX = cfg.step;
				}
                PanelMediator.instance.switchPanel(PanelConst.TYPE_CONVERT_LIST);
            }

        }

        private function dealBtnSpecialRing():void
        {
            if (checkBottomBtnOpenState(UnlockFuncId.SPECIAL_RING))
            {
				var num:int;
				if(GuideSystem.instance.isUnlock(UnlockFuncId.SPECIAL_RING_DGN))
				{
					num = DailyDataManager.instance.player_daily_vit/20;
				}
				if(num>0)
				{
					SpecialRingDataManager.instance.selectTab = 1;
				}	
				PanelMediator.instance.switchPanel(PanelConst.TYPE_SPECIAL_RING);
            }
        }

        private function dealBtnTeam():void
        {
            TeamDataManager.instance.dealSwitchPanelDaily();
        }

        private function dealBtnHero():void
        {
            if (checkBottomBtnOpenState(UnlockFuncId.HERO))
            {
                HeroDataManager.instance.isExchange = false;
				var num1:int = HeroDataManager.instance.getChannelsNum();
				var num2:int = HeroDataManager.instance.getCanWearEquipNum();
				PanelMediator.instance.switchPanel(PanelConst.TYPE_HERO);
				var panel:HeroPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_HERO) as HeroPanel;
				if(panel){
					if(num2>0||num1 == 0||!GuideSystem.instance.isUnlock(UnlockFuncId.HERO_RE))
						panel.showIndex(0);
					else
						panel.showIndex(1);
				}
            }
        }

        override protected function addCallBack(rsrLoader:RsrLoader):void
        {
            var mcMainUIBottom:McMainUIBottom = _skin as McMainUIBottom;
            rsrLoader.addCallBack(mcMainUIBottom.mcHp.mcHpBar, function (mc:MovieClip):void
            {
                mc.scaleX = 0;
                mc.scaleY = 0;
            });
            rsrLoader.addCallBack(mcMainUIBottom.mcMp.mcMpBar, function (mc:MovieClip):void
            {
                mc.scaleX = 0;
                mc.scaleY = 0;
            });
//			rsrLoader.addCallBack(mcMainUIBottom.onConvertStartBtn, function (mc:MovieClip):void
//			{
//				var x:int = mcMainUIBottom.onConvertStartBtn.x + mcMainUIBottom.onConvertStartBtn.width / 2;
//				var y:int = mcMainUIBottom.onConvertStartBtn.y + mcMainUIBottom.onConvertStartBtn.height / 2;
//				//_effectLaoder = new UIEffectLoader(mcMainUIBottom.onConvertStartBtn.parent,x,y,1,1,EffectConst.RES_RING_OO);
//				initFunctionBtns();
//			});
            addFunctionBtnCallback(rsrLoader, mcMainUIBottom.ringUpBtn);
            addFunctionBtnCallback(rsrLoader, mcMainUIBottom.btnSpecialRing);
            addFunctionBtnCallback(rsrLoader, mcMainUIBottom.btnHero);
            addFunctionBtnCallback(rsrLoader, mcMainUIBottom.skillBtn);
            addFunctionBtnCallback(rsrLoader, mcMainUIBottom.factionBtn);
            addFunctionBtnCallback(rsrLoader, mcMainUIBottom.forgeBtn);
            addFunctionBtnCallback(rsrLoader, mcMainUIBottom.btnCloset);
            addFunctionBtnCallback(rsrLoader, mcMainUIBottom.shopBtn);
            addFunctionBtnCallback(rsrLoader, mcMainUIBottom.btnWing);
			
			
			rsrLoader.addCallBack(mcMainUIBottom.txtSpecialRingCountBG, function (mc:MovieClip):void
			{
				mcMainUIBottom.txtSpecialRingCountBG.mouseEnabled = false;
			});
			rsrLoader.addCallBack(mcMainUIBottom.txtBagCountBG, function (mc:MovieClip):void
			{
				mcMainUIBottom.txtBagCountBG.mouseEnabled = false;
			});
			rsrLoader.addCallBack(mcMainUIBottom.txtHeroCountBG, function (mc:MovieClip):void
			{
				mcMainUIBottom.txtHeroCountBG.mouseEnabled = false;
				mcMainUIBottom.txtHeroCountBG.visible = mcMainUIBottom.txtHeroCount.visible = false;
			});

			rsrLoader.addCallBack(mcMainUIBottom.txtPositionCountBG, function (mc:MovieClip):void
			{
				mcMainUIBottom.txtPositionCountBG.mouseEnabled = false;
			});



            rsrLoader.addCallBack(mcMainUIBottom.onhookBtn, function (mc:MovieClip):void
            {
                mcMainUIBottom.onhookBtn.buttonMode = true;
                InterObjCollector.instance.add(mcMainUIBottom.onhookBtn);
                ToolTipManager.getInstance().attachByTipVO(mcMainUIBottom.onhookBtn, ToolTipConst.TEXT_TIP, StringConst.BTNTIPS_0011);
            });
            rsrLoader.addCallBack(mcMainUIBottom.btnBag, function (mc:MovieClip):void
            {
                mcMainUIBottom.btnBag.buttonMode = true;
                ToolTipManager.getInstance().attachByTipVO(mcMainUIBottom.btnBag, ToolTipConst.TEXT_TIP, StringConst.BTNTIPS_0002);
            });
            rsrLoader.addCallBack(mcMainUIBottom.roleBtn, function (mc:MovieClip):void
            {
                mcMainUIBottom.roleBtn.buttonMode = true;
                ToolTipManager.getInstance().attachByTipVO(mcMainUIBottom.roleBtn, ToolTipConst.TEXT_TIP, StringConst.BTNTIPS_0001);
            });
            rsrLoader.addCallBack(mcMainUIBottom.teamBtn, function (mc:MovieClip):void
            {
                mcMainUIBottom.teamBtn.buttonMode = true;
                ToolTipManager.getInstance().attachByTipVO(mcMainUIBottom.teamBtn, ToolTipConst.TEXT_TIP, StringConst.BTNTIPS_0010);
            });
			/*rsrLoader.addCallBack(mcMainUIBottom.mcAngryValue.mcBg.mc, function (mc:MovieClip):void
			{
				mcMainUIBottom.mcAngryValue.mcBg.mc.x += mcMainUIBottom.mcAngryValue.mcBg.width*.5+1;
				mcMainUIBottom.mcAngryValue.mcBg.mc.y += mcMainUIBottom.mcAngryValue.mcBg.height*.5;
			});*/
			
			
        }

        public function update(proc:int = 0):void
        {
            if (proc == GameServiceConstants.SM_ACTION_LIST || proc == GameServiceConstants.SM_BAG_ITEMS ||
                    proc == AutoDataManager.EVENT_UPDATE_ONE_TARGET_SKILL || proc == AutoDataManager.EVENT_UPDATE_MULTI_TARGET_SKILL)
            {
                _cellHandle.refreshActionBar();
//                _bottomBarHandler.checkHeroScript();
                updateSpecialRingTxt();
				updateRingUpTxt();
				updatePositionTxt();
                updateBagTxt();
				checkShowRecycleShow();
            }
            else if (proc == GameServiceConstants.SM_HERO_INFO || proc == GameServiceConstants.SM_QUERY_HERO_GRADE)
            {
//                _bottomBarHandler.checkHeroScript();
				updateHeroTxt();
				updatePositionTxt();
            }
            else if (proc == GameServiceConstants.SM_CHR_INFO)
            {
                if (RoleDataManager.instance.isExpStoneState == 0 && BossDataManager.instance.dungeonId == 0)
                {
                    refreshExp();
                }

				refreshHpMp();
//                _bottomBarHandler.checkHeroScript();
                updateSpecialRingTxt();
				updatePositionTxt();
				updateRingUpTxt();
            }
            else if (proc == GameServiceConstants.SM_CREATE_EXCHANGE)
            {
//                _bottomBarHandler.checkHeroScript();
            }
			else if(proc == GameServiceConstants.SM_DAILY_INFO)
			{
				updateSpecialRingTxt();
			}
            var cfgDt:SkillCfgData = HejiSkillDataManager.instance.cfgDtHeji;
            if (cfgDt)
            {
                var mcMainUIBottom:McMainUIBottom = _skin as McMainUIBottom;
                mcMainUIBottom.hjUnopen.visible = false;
            }

        }
		
		private var _recycleGuide:GuideArrow;
		private function checkShowRecycleShow():void
		{
			//需要去掉次数的限制
			
			if(BagDataManager.instance.needShowRecycleGuide /*&& BagDataManager.instance.numRecycleShown == 0*/)
			{
				var mcMainUIBottom:McMainUIBottom = _skin as McMainUIBottom;
				if(mcMainUIBottom.btnBag.buttonMode == true)//已加载
				{
					++BagDataManager.instance.numRecycleShown;
					
					if(_recycleGuide)
					{
						return;
					}
					
					_recycleGuide = GuideArrowTalk.show(EquipRecycleDataManager.instance.getGuideTip(),
						mcMainUIBottom.btnBag.x + mcMainUIBottom.btnBag.width/2,mcMainUIBottom.btnBag.y + 8,200,mcMainUIBottom.btnBag.parent,recycleCloseHandler,recycleLinkHandler);
					
					//如果bottombar上的 引导显示 就去掉英雄头像上的可能出现的引导
					if(HeroDataManager.instance.needShowRecycleGuide)
					{
						HeroDataManager.instance.updateRecycleGuide();
					}
				}
			}
			else/* if(!BagDataManager.instance.needShowRecycleGuide)*/
			{
				if(_recycleGuide)
				{
					_recycleGuide.destroy();
					_recycleGuide = null;
				}
			}
		}
		
		private function recycleCloseHandler(g:GuideArrowTalk):void
		{
			if(_recycleGuide)
			{
				_recycleGuide.destroy();
				_recycleGuide = null;
			}
		}
		
		private var _bagHandler:BagPanelClickHander;
		private function recycleLinkHandler(g:GuideArrowTalk,link:String):void
		{
			if(!_bagHandler)
			{
				_bagHandler = new BagPanelClickHander();
			}
			
			_bagHandler.dealVip(false);
			if(_recycleGuide)
			{
				_recycleGuide.destroy();
				_recycleGuide = null;
			}
		}

        private function updateBagTxt():void
        {
            var mcMainUIBottom:McMainUIBottom = _skin as McMainUIBottom;
            var remainCellNum:int = BagDataManager.instance.remainCellNum;
            mcMainUIBottom.txtBagCount.text = remainCellNum + "";
            mcMainUIBottom.txtBagCount.visible = mcMainUIBottom.txtBagCountBG.visible = mcMainUIBottom.btnBag.visible && remainCellNum <= 8;
        }

        public function playCoolDownEffect(groupId:int):void
        {
            _cellHandle.playCoolDownEffect(groupId);
            /*_cellHandle.palyPublicCollDownEffect();*///不播放公共CD冷却
        }

        public function refreshHpMp():void
        {
            var attrHp:int = RoleDataManager.instance.attrHp;
            var attrMaxHp:int = RoleDataManager.instance.attrMaxHp;
            var attrMp:int = RoleDataManager.instance.attrMp;
            var attrMaxMp:int = RoleDataManager.instance.attrMaxMp;
            var mcMainUIBottom:McMainUIBottom = _skin as McMainUIBottom;
			var hpScaleY:Number = attrHp / attrMaxHp;
			var mpScaleY:Number = attrMp / attrMaxMp;
            mcMainUIBottom.mcHp.mcMask.scaleY = attrHp / attrMaxHp;
            mcMainUIBottom.mcMp.mcMask.scaleY = attrMp / attrMaxMp;
            mcMainUIBottom.mcHp.mcHpBar.y = mcMainUIBottom.mcHp.mcMask.y - mcMainUIBottom.mcHp.mcMask.height;
            mcMainUIBottom.mcMp.mcMpBar.y = mcMainUIBottom.mcMp.mcMask.y - mcMainUIBottom.mcMp.mcMask.height;
            _skin.hpTxt.text = RoleDataManager.instance.attrHp.toString();
            _skin.maxHpTxt.text = RoleDataManager.instance.attrMaxHp.toString();
            _skin.mpTxt.text = RoleDataManager.instance.attrMp.toString();
            _skin.maxMpTxt.text = RoleDataManager.instance.attrMaxMp.toString();
        }

        private function updateFunctionBtnAnim(id:int):void
        {
            var mcMainUIBottom:McMainUIBottom = _skin as McMainUIBottom;
            switch (id)
            {
                case UnlockFuncId.CONVERT_START:
                    UnlockAnim.moveToDis(mcMainUIBottom.onConvertStartBtn);
                    break;
                case UnlockFuncId.CONVERT_LIST:
                    UnlockAnim.moveToDis(mcMainUIBottom.ringUpBtn);
                    break;
                case UnlockFuncId.SPECIAL_RING:
                    UnlockAnim.moveToDis(mcMainUIBottom.btnSpecialRing);
                    break;
                case UnlockFuncId.HERO:
                    UnlockAnim.moveToDis(mcMainUIBottom.btnHero);
                    break;
                case UnlockFuncId.SKILL:
                    UnlockAnim.moveToDis(mcMainUIBottom.skillBtn);
                    break;
                case UnlockFuncId.GUILD:
                    UnlockAnim.moveToDis(mcMainUIBottom.factionBtn);
                    break;
                case UnlockFuncId.FORGE:
                    UnlockAnim.moveToDis(mcMainUIBottom.forgeBtn);
                    break;
                case UnlockFuncId.POSITION:
                    UnlockAnim.moveToDis(mcMainUIBottom.btnCloset);
                    break;
                case UnlockFuncId.MALL:
                    UnlockAnim.moveToDis(mcMainUIBottom.shopBtn);
                    break;
//                case UnlockFuncId.JOINSKILL:
//                    UnlockAnim.moveToDis(mcMainUIBottom.joinSkillBtn);
//                    break;
            }
        }

        private function updateFunctionBtn(id:int):void
        {
            if (id == UnlockFuncId.CONVERT_START
                    || id == UnlockFuncId.CONVERT_LIST
                    || id == UnlockFuncId.SPECIAL_RING
                    || id == UnlockFuncId.HERO
                    || id == UnlockFuncId.FORGE
                    || id == UnlockFuncId.SKILL
                    || id == UnlockFuncId.GUILD
                    || id == UnlockFuncId.POSITION
                    || id == UnlockFuncId.MALL
                    || id == UnlockFuncId.JOINSKILL)
            {
                initFunctionBtns();
            }
        }

        private function initFunctionBtns():void
        {
//			var mcMainUIBottom:McMainUIBottom = _skin as McMainUIBottom;

//			mcMainUIBottom.onConvertStartBtn.visible = GuideSystem.instance.isUnlock(UnlockFuncId.CONVERT_START);
//			mcMainUIBottom.ringUpBtn.visible = GuideSystem.instance.isUnlock(UnlockFuncId.CONVERT_LIST);
//			mcMainUIBottom.btnSpecialRing.visible = GuideSystem.instance.isUnlock(UnlockFuncId.SPECIAL_RING);
//			mcMainUIBottom.btnHero.visible = GuideSystem.instance.isUnlock(UnlockFuncId.HERO);

//			mcMainUIBottom.forgeBtn.filters = GuideSystem.instance.isUnlock(UnlockFuncId.FORGE) ? null:[_grayFilter];//UtilColorMatrixFilters.GREY_FILTERS;
//			mcMainUIBottom.skillBtn.filters = GuideSystem.instance.isUnlock(UnlockFuncId.SKILL) ? null:[_grayFilter];
//			mcMainUIBottom.factionBtn.filters = GuideSystem.instance.isUnlock(UnlockFuncId.GUILD) ? null:[_grayFilter];
//			mcMainUIBottom.btnCloset.filters = GuideSystem.instance.isUnlock(UnlockFuncId.POSITION) ? null:[_grayFilter];
//			mcMainUIBottom.shopBtn.filters = GuideSystem.instance.isUnlock(UnlockFuncId.MALL) ? null:[_grayFilter];
            //
            updateSpecialRingTxt();
        }

        private function updateSpecialRingTxt():void
        {
			var mcMainUIBottom:McMainUIBottom = _skin as McMainUIBottom;
			if (GuideSystem.instance.isUnlock(UnlockFuncId.SPECIAL_RING))
			{
				var upableNum:int = SpecialRingDataManager.instance.upableNum();
				var num2:int;
				if(GuideSystem.instance.isUnlock(UnlockFuncId.SPECIAL_RING_DGN))
				{
					num2 = DailyDataManager.instance.player_daily_vit/20;
				}
				upableNum +=num2;
				mcMainUIBottom.txtSpecialRingCount.text = upableNum + "";
				mcMainUIBottom.txtSpecialRingCountBG.visible = mcMainUIBottom.txtSpecialRingCount.visible = mcMainUIBottom.btnSpecialRing.visible && upableNum;
			}else
			{
				mcMainUIBottom.txtSpecialRingCountBG.visible = mcMainUIBottom.txtSpecialRingCount.visible = false;
			}
        }
		
		private function updateRingUpTxt():void
		{
			var mcMainUIBottom:McMainUIBottom = _skin as McMainUIBottom;
			var upableNum:int = RoleDataManager.instance.canDoRingUp();
			if(!GuideSystem.instance.isUnlock(UnlockFuncId.CONVERT_LIST))
				upableNum = 0;
			mcMainUIBottom.txtRingUpCount.text = upableNum + "";
			mcMainUIBottom.txtRingUpCountBG.visible = mcMainUIBottom.txtRingUpCount.visible = mcMainUIBottom.ringUpBtn.visible && upableNum;
		}
		
		private function updatePositionTxt():void
		{
			var mcMainUIBottom:McMainUIBottom = _skin as McMainUIBottom;
			var upableNum:int = PositionDataManager.instance.getPositionNum();
			if(!GuideSystem.instance.isUnlock(UnlockFuncId.POSITION))
				upableNum = 0;
			mcMainUIBottom.txtPositionCount.text = upableNum + "";
			mcMainUIBottom.txtPositionCountBG.visible = mcMainUIBottom.txtPositionCount.visible = mcMainUIBottom.btnCloset.visible && upableNum;
		}
		
		private function updateHeroTxt():void
		{
			var mcMainUIBottom:McMainUIBottom = _skin as McMainUIBottom;
			var upableNum:int = HeroDataManager.instance.getChannelsNum();
			if(!GuideSystem.instance.isUnlock(UnlockFuncId.HERO_RE))
			{
				upableNum = 0;
			}
			upableNum += HeroDataManager.instance.getCanWearEquipNum();
			mcMainUIBottom.txtHeroCount.text = upableNum + "";
			mcMainUIBottom.txtHeroCountBG.visible = mcMainUIBottom.txtHeroCount.visible = mcMainUIBottom.btnHero.visible && upableNum;
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

        private function addFunctionBtnCallback(rsrLoader:RsrLoader, mc:MovieClip):void
        {
            rsrLoader.addCallBack(mc, function (mc:MovieClip):void
            {
                initFunctionBtns();
                if (mc == _mcMainUIBottom.skillBtn)
                {
                    ToolTipManager.getInstance().attachByTipVO(_mcMainUIBottom.skillBtn, ToolTipConst.TEXT_TIP, StringConst.BTNTIPS_0003);
                }
                else if (mc == _mcMainUIBottom.factionBtn)
                {
                    ToolTipManager.getInstance().attachByTipVO(_mcMainUIBottom.factionBtn, ToolTipConst.TEXT_TIP, StringConst.BTNTIPS_0004);
                }
                else if (mc == _mcMainUIBottom.forgeBtn)
                {
                    ToolTipManager.getInstance().attachByTipVO(_mcMainUIBottom.forgeBtn, ToolTipConst.TEXT_TIP, StringConst.BTNTIPS_0005);
                }
                else if (mc == _mcMainUIBottom.shopBtn)
                {
                    ToolTipManager.getInstance().attachByTipVO(_mcMainUIBottom.shopBtn, ToolTipConst.TEXT_TIP, StringConst.BTNTIPS_0007);
                }
                else if (mc == _mcMainUIBottom.btnCloset)
                {
                    ToolTipManager.getInstance().attachByTipVO(_mcMainUIBottom.btnCloset, ToolTipConst.TEXT_TIP, StringConst.BTNTIPS_0006);
                }
                mc.buttonMode = true;
            });
        }

        private function addExpTipListener():void
        {
            var tipVO:TipVO = new TipVO();
            tipVO.tipType = ToolTipConst.TEXT_TIP;
            tipVO.tipData = expTip;
            ToolTipManager.getInstance().hashTipInfo(_skin.alphaLay, tipVO);
            ToolTipManager.getInstance().attach(_skin.alphaLay);
        }

        private function addHpTips():void
        {
            var tipHp:TipVO = new TipVO();
            tipHp.tipType = ToolTipConst.TEXT_TIP;
            tipHp.tipData = hpTip;
            ToolTipManager.getInstance().hashTipInfo(_skin.mcHp, tipHp);
            ToolTipManager.getInstance().attach(_skin.mcHp);
        }

        private function addMpTips():void
        {
            var tipHp:TipVO = new TipVO();
            tipHp.tipType = ToolTipConst.TEXT_TIP;
            tipHp.tipData = mpTip;
            ToolTipManager.getInstance().hashTipInfo(_skin.mcMp, tipHp);
            ToolTipManager.getInstance().attach(_skin.mcMp);
        }

        private function refreshStoneExp():void
        {
            initExpMask();
            var exp:int = RoleDataManager.instance.exp;
            var lv:int = RoleDataManager.instance.lv;

            var levelCfgData:LevelCfgData = ConfigDataManager.instance.levelCfgData(lv);
            if (!levelCfgData)
            {
                return;
            }
            var scaleX:Number = exp / levelCfgData.player_exp;
            TweenLite.to(_mcMainUIBottom.mcExp.mcMask, .5, {
                scaleX: scaleX,
                onComplete: onComplete,
                ease: Circ.easeOut
            });

            sprite.visible = true;
            sprite.x = _mcMainUIBottom.mcExp.width * getLastScale() - 20;

            TweenLite.to(sprite, .5, {
                x: _mcMainUIBottom.mcExp.width * scaleX - 20,
                onComplete: onComplete2,
                ease: Circ.easeOut
            });
        }
        private function refreshExp():void
        {
            initExpMask();
            if (_initExpCount >= 2)
            {
                _initExpCount = 0;
            }
            _initExpCount++;
            if (_initExpCount != 2)
            {
                _lastExp = _exp;
                _exp = RoleDataManager.instance.exp;
                lvValue = RoleDataManager.instance.lv - RoleDataManager.instance.oldLv;//升了几级
                return;
            }
            var lv:int = RoleDataManager.instance.lv;
            if (RoleDataManager.instance.oldLv == 0)
            {
                return;
            }
            var levelCfgData:LevelCfgData = ConfigDataManager.instance.levelCfgData(lv);
            if (!levelCfgData)
            {
                return;
            }
            var scaleX:Number = _exp / levelCfgData.player_exp;
            for (var i:int = 0; i < lvValue; i++)
            {
                _vector.push(1);
            }
            if (lvValue < 0)
            {
                _mcMainUIBottom.mcExp.mcMask.scaleX = 0;
            }
            if (_lastExp - _exp != 0 || lvValue != 0)
            {
                _vector.push(scaleX);
            }
            if (_vector.length)
            {
                if (_vector[0] == 0)
                {
                    _vector.shift();
                    _mcMainUIBottom.mcExp.mcMask.scaleX = 0;
                }
                else
                {
                    TweenLite.to(_mcMainUIBottom.mcExp.mcMask, .5, {
                        scaleX: _vector[0],
                        onComplete: onComplete,
                        ease: Circ.easeOut
                    });
                    if (_vector.length == 1)
                    {
                        sprite.visible = true;
                        TweenLite.to(sprite, .5, {
                            x: _mcMainUIBottom.mcExp.width * _vector[0] - 20,
                            onComplete: onComplete2,
                            ease: Circ.easeOut
                        });
                    }
                }
            }
            _initExpCount = 0;
        }

        private function initExpMask():void
        {
            if (_isInitExp == false)
            {
				var exp:int = RoleDataManager.instance.exp;
				var lv:int = RoleDataManager.instance.lv;
				var levelCfgData:LevelCfgData = ConfigDataManager.instance.levelCfgData(lv);
				_mcMainUIBottom.mcExp.mcMask.scaleX = levelCfgData ? exp / levelCfgData.player_exp : 1;
                _isInitExp = true;
            }
        }

        public function getCurrentExpRect():Rectangle
        {
            var mcExp:MovieClip = _mcMainUIBottom.mcExp;
//            var mcExpWidth:Number = mcExp.mcMask.scaleX * mcExp.width;

            var mcExpWidth:Number = 0;
            var scaleW:Number = 0;
            scaleW = getLastScale();
            mcExpWidth = scaleW * mcExp.width;
            return new Rectangle(x, y, mcExp.x + mcExpWidth, mcExp.y + mcExp.height);
        }

        private function getLastScale():Number
        {
            var mcExpWidth:Number = 0;
            var scaleW:Number = 0;
            var exp:int = ExpRecorder.record_exp;
            var lv:int = ExpRecorder.record_lv;
            var levelCfgData:LevelCfgData = ConfigDataManager.instance.levelCfgData(lv);
            scaleW = levelCfgData ? exp / levelCfgData.player_exp : 1;
            return scaleW;
        }

        public function onComplete():void
        {
            TweenLite.killTweensOf(_mcMainUIBottom.mcExp.mcMask, true);
            if (_vector.length != 0 && _vector[0] == 1)
            {
                if (_vector.length > 1)
                {
                    _mcMainUIBottom.mcExp.mcMask.scaleX = 0;
                }
                else
                {
                    _mcMainUIBottom.mcExp.mcMask.scaleX = _vector[0];
                }
            }
            _vector.shift();
            if (_vector.length != 0)
            {
                if (_vector[0] == 0)
                {
                    _vector.shift();
                }
            }
            if (_vector.length != 0)
            {
                TweenLite.to(_mcMainUIBottom.mcExp.mcMask, .5, {
                    scaleX: _vector[0],
                    onComplete: onComplete,
                    ease: Circ.easeOut
                });
            }
            if (_vector.length == 1)
            {
                sprite.visible = true;
                sprite.x = 0;
                TweenLite.to(sprite, .5, {
                    x: _mcMainUIBottom.mcExp.width * _vector[0] - 20,
                    onComplete: onComplete2,
                    ease: Circ.easeOut
                });
            }
        }

        private function onComplete2():void
        {
            sprite.visible = false;
            TweenLite.killTweensOf(sprite, true);
        }

        private function expTip():String
        {
            var exp:int = RoleDataManager.instance.exp;
            var lv:int = RoleDataManager.instance.lv;
            var levelCfgData:LevelCfgData = ConfigDataManager.instance.levelCfgData(lv);
            var percentStr:String = HtmlUtils.createHtmlStr(0xffffff, (exp / levelCfgData.player_exp * 100).toFixed(1) + "%");
            return HtmlUtils.createHtmlStr(0xe9d447, StringConst.EXP_TIP + "\n", 12, false, 4) + HtmlUtils.createHtmlStr(0xffffff, exp + "/" + levelCfgData.player_exp + "\n", 12, false, 4) + percentStr;
        }

        private function hpTip():String
        {
            var hp:int = RoleDataManager.instance.attrHp;
            var maxHp:int = RoleDataManager.instance.attrMaxHp;
            return HtmlUtils.createHtmlStr(0xd4a460, StringConst.TIP_HP_0001 + String(hp) + "   " + StringConst.TIP_HP_0002 + String(maxHp), 12, false, 4) + HtmlUtils.createHtmlStr(0x00ff00, "\n" + StringConst.TIP_HP_0003, 12, false, 4);
        }

        private function mpTip():String
        {
            var mp:int = RoleDataManager.instance.attrMp;
            var maxMp:int = RoleDataManager.instance.attrMaxMp;
            return HtmlUtils.createHtmlStr(0xd4a460, StringConst.TIP_MP_0001 + String(mp) + "   " + StringConst.TIP_MP_0002 + String(maxMp), 12, false, 4) + HtmlUtils.createHtmlStr(0x00ff00, "\n" + StringConst.TIP_MP_0003, 12, false, 4);
        }
    }
}