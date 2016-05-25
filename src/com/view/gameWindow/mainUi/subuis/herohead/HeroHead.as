package com.view.gameWindow.mainUi.subuis.herohead
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.ConstHeroMode;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.common.ModelEvents;
    import com.view.gameWindow.mainUi.MainUi;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McHeroHead;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.mainUi.subuis.rolehead.RoleHead;
    import com.view.gameWindow.mainUi.subuis.teamhead.TeamHeadLayer;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.bag.BagPanelClickHander;
    import com.view.gameWindow.panel.panels.equipRecycle.EquipRecycleDataManager;
    import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
    import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
    import com.view.gameWindow.panel.panels.guideSystem.action.GuideAction;
    import com.view.gameWindow.panel.panels.guideSystem.constants.GuidesID;
    import com.view.gameWindow.panel.panels.guideSystem.view.GuideArrow;
    import com.view.gameWindow.panel.panels.guideSystem.view.GuideArrowTalk;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    import com.view.gameWindow.panel.panels.team.TeamDataManager;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.ServerTime;
    import com.view.gameWindow.util.cooldown.SectorMaskEffect;
    import com.view.newMir.NewMirMediator;
    
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFormat;

    public class HeroHead extends MainUi implements IHeroHead,IObserver
	{
		private var _hp:int;
		private var _maxHp:int;
		public var mcHeroHead:McHeroHead;
		public var sectorMaskEffect:SectorMaskEffect;
		
		public var _isDead:Boolean;
		private var _mouseEvent:HeroHeadMouseEvent;
		private var role:DisplayObject;
		private var _bottomBar:DisplayObject;
        private var _isHasGuideBattle:Boolean;//是否有引导
		private var _width:Number;
		private var _height:Number;
		private var _hpAutoBar:int=-1;
		private var _modeState:int=-1;
		
		public function HeroHead()
		{
			super();
//			EntityLayerManager.getInstance().attach(this);
			HeroDataManager.instance.attach(this);
			TeamDataManager.instance.attach(this);
		}
		
		override public function initView():void
		{
			_skin = new McHeroHead();
			mcHeroHead = _skin as McHeroHead;
			addChild(_skin);
			_width = mcHeroHead.width;
			_height = mcHeroHead.height;
			
			_mouseEvent = new HeroHeadMouseEvent(this);
			super.initView();
			
			_skin.txt.visible = false;
			_skin.txts1.visible = false;
			_skin.txts2.visible = false;
			_skin.txts3.visible = false;
			_skin.txts1.mouseEnabled = false;
			_skin.txts2.mouseEnabled = false;
			_skin.txts3.mouseEnabled = false;
			mcHeroHead.forBar.visible=false;
			_skin.txts1.text = StringConst.HERO_HEAD_0005;
			_skin.txts2.text = StringConst.HERO_HEAD_0006;
			_skin.txts3.text = StringConst.HERO_HEAD_0007;
			
			role = MainUiMediator.getInstance().roleHead as RoleHead;
			_bottomBar = MainUiMediator.getInstance().bottomBar as BottomBar;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(mcHeroHead.btnHero,function():void{
				mcHeroHead.btnHero.buttonMode = true;
			});
			
			rsrLoader.addCallBack(mcHeroHead.fightBtn,function():void{
				mcHeroHead.fightBtn.buttonMode = true;
				refreshHeroMode();
			});
			
			rsrLoader.addCallBack(_skin.heroBottom,function():void
			{
				_skin.heroBottom.mouseEnabled = false;
				refreshHeroMode();
			});
			
			rsrLoader.addCallBack(_skin.btnHero,function (mc:MovieClip):void
			{
				_skin.btnHero.load=true;
				setHeroState();
				ToolTipManager.getInstance().attachByTipVO(_skin.btnHero.btn1,ToolTipConst.TEXT_TIP,StringConst.HERO_HEAD_TIP_0004);
				ToolTipManager.getInstance().attachByTipVO(_skin.btnHero.btn2,ToolTipConst.TEXT_TIP,StringConst.HERO_HEAD_TIP_0005);
				ToolTipManager.getInstance().attachByTipVO(_skin.btnHero.btn3,ToolTipConst.TEXT_TIP,StringConst.HERO_HEAD_TIP_0006);
				
				_skin.btnHero.btn1.mouseChildren = false;
				_skin.btnHero.btn2.mouseChildren = false;
				_skin.btnHero.btn3.mouseChildren = false;
				InterObjCollector.autoCollector.add(_skin.btnHero.btn1);
				InterObjCollector.autoCollector.add(_skin.btnHero.btn2);
				InterObjCollector.autoCollector.add(_skin.btnHero.btn3);
				
				InterObjCollector.instance.add(_skin.btnHero.btn1);
				InterObjCollector.instance.add(_skin.btnHero.btn2);
				InterObjCollector.instance.add(_skin.btnHero.btn3);
			});
		}
		
		public function refreshHp(hp:int , maxHp:int):void
		{	
			if(_hp==hp&&maxHp==_maxHp)
			{
				return ; 
			}
			var _textFormat:TextFormat;
			_hp =hp;
			_maxHp = maxHp;
			_textFormat = mcHeroHead.txt.defaultTextFormat;
			mcHeroHead.txt.defaultTextFormat = _textFormat;
			mcHeroHead.txt.setTextFormat(_textFormat);
			mcHeroHead.txt.text = _hp + "/" + _maxHp;
			if(mcHeroHead.heroBottom.hps)
			{
				mcHeroHead.heroBottom.hps.scaleX = _hp/_maxHp > 1?1:_hp/_maxHp;
			}
		}
		
		public function setHPAutoBar(value:int):void
		{
			if(_hpAutoBar==value)return;
			
			_hpAutoBar=value;
			var barx:Number=value/100*76-mcHeroHead.forBar.btnForBar.width*0.5;
			mcHeroHead.forBar.btnForBar.x=barx;
		}
		
		public function refreshHeroMode():void
		{	
			_modeState=HeroDataManager.instance.mode;
			if(HeroDataManager.instance.mode == ConstHeroMode.HM_HIDE_ACTIVE ||HeroDataManager.instance.mode == ConstHeroMode.HM_HIDE_HOLD||HeroDataManager.instance.mode == ConstHeroMode.HM_HIDE_IDLE)
			{
				mcHeroHead.fightBtn.selected = false;
				mcHeroHead.heroBottom.selected = false;
				mcHeroHead.txt.visible = false;
				mcHeroHead.txts1.visible = false;
				mcHeroHead.txts2.visible = false;
				mcHeroHead.txts3.visible = false;
				mcHeroHead.btnHero.visible = false;
				mcHeroHead.forBar.visible=false;
			}
			else
			{			
				mcHeroHead.fightBtn.selected = true;
				mcHeroHead.heroBottom.selected = true;
				mcHeroHead.txt.visible = true;
				mcHeroHead.txts1.visible = true;
				mcHeroHead.txts2.visible = true;
				mcHeroHead.txts3.visible = true;
				mcHeroHead.btnHero.visible = true;
				mcHeroHead.forBar.visible=true;
				setHeroState();
			}
			
			resize();
			checkShowBattleGuide();
		}
		
		private function setHeroState():void
		{
			if(HeroDataManager.instance.mode == ConstHeroMode.HM_ACTIVE)
			{
				setHeroBtn(1);
			}
			else if(HeroDataManager.instance.mode == ConstHeroMode.HM_HOLD)
			{
				setHeroBtn(2);
			}
			else
			{
				setHeroBtn(3);
			}
		}
		
		private function setHeroBtn(index:int):void
		{
			var hasLoader:Boolean = mcHeroHead.btnHero.hasOwnProperty("load");
			if(hasLoader)
			{
				for (var i:int=1;i<4;i++)
				{
					var mc:MovieClip = mcHeroHead.btnHero["btn"+i];
					var txt:TextField= mcHeroHead["txts"+i] as TextField;
					if(index==i)
					{
						txt.textColor=0xfffffff;
						mc.gotoAndStop(2);
					}else
					{
						txt.textColor=0x6a6a6a;
						mc.gotoAndStop(1);
					}
				}
			}
		}
		
		public function update(proc:int=0):void
		{
			if(HeroDataManager.instance.isHeroExist)
			{
				mcHeroHead.visible = true;
			}
			else
			{
				mcHeroHead.visible = false;
//				return;
			}
			
			if(proc==GameServiceConstants.SM_HERO_INFO ||proc==GameServiceConstants.SM_HERO_BASIC_INFO)
			{
				var hpAuto:int=HeroDataManager.instance.hpAutoNum;
				if(hpAuto==0)
				{
					setHPAutoBar(80);
				}
				else
				{
					setHPAutoBar(hpAuto);
				}
				
				refreshMask();
				
				refreshHp(HeroDataManager.instance.attrHp,HeroDataManager.instance.attrMaxHp);
				
				if(_modeState!=HeroDataManager.instance.mode)
				{
					refreshHeroMode();
				}
				
                var job:int = HeroDataManager.instance.job;
                var sex:int = HeroDataManager.instance.sex;
                if (mcHeroHead.iconContainer.icon.resUrl != String(job) + "_" + String(sex) + ".png")
                {
                    mcHeroHead.iconContainer.icon.resUrl = String(job) + "_" + String(sex) + ".png";
                    var rsrLoader:RsrLoader = new RsrLoader();
                    rsrLoader.load(mcHeroHead.iconContainer, ResourcePathConstants.IMAGE_CREATEROLE_FOLDER_LOAD);
                }
				checkShowRecycleShow();
			}
			else if(proc == ModelEvents.HERO_RECYCLE_CHANGE)
			{
				checkShowRecycleShow();
			}
			else if(proc == GameServiceConstants.SM_TEAM_INFO)
			{
				resize();
			}
//			else if(proc == ModelEvents.HERO_BATTLE_MODE_CHANGE)
//			{
//				checkShowBattleGuide();
//			}
		}

        private var battleGuide:GuideAction;
		private function checkShowBattleGuide():void
		{
			var b0:Boolean = HeroDataManager.instance.isHeroExist;
			var b1:Boolean = HeroDataManager.instance.isHeroFight();
			var b2:Boolean = HeroDataManager.instance.isBattleReady;
			if(b0 && !b1 && b2)
			{
				if(!battleGuide)
				{
					battleGuide = GuideSystem.instance.createAction(GuidesID.HERO_BATTLE_MODE);
				}
				
				if(battleGuide)
				{
					battleGuide.init();
					battleGuide.act();
                    _isHasGuideBattle = true;
//                    if(this.x<50){
//                        resize();
//                    }
                    resetPosition(this.x, this.y);
				}
			}
			else
			{
				if(battleGuide)
				{
					battleGuide.destroy();
                    _isHasGuideBattle = false;
				}
			}
		}
		
		private var recycleGuide:GuideArrow;
		
		private function checkShowRecycleShow():void
		{
			if(HeroDataManager.instance.needShowRecycleGuide 
				/*&& HeroDataManager.instance.numRecycleShown == 0*/
				&& !BagDataManager.instance.needShowRecycleGuide)
			{
				if(mcHeroHead.visible)
				{
					++HeroDataManager.instance.numRecycleShown;
					
					if(recycleGuide)
					{
						return;
					}
					
					recycleGuide = GuideArrowTalk.show(EquipRecycleDataManager.instance.getGuideTipForHero(),
						mcHeroHead.btnHero.x - 50 ,mcHeroHead.btnHero.y + 5,200,mcHeroHead.btnHero.parent,recycleCloseHandler,recycleLinkHandler);
				}
			}
			else if(!HeroDataManager.instance.needShowRecycleGuide
					|| BagDataManager.instance.needShowRecycleGuide)
			{
				if(recycleGuide)
				{
					recycleGuide.destroy();
					recycleGuide = null;
				}
			}
		}
		
		
		private function recycleCloseHandler(g:GuideArrow):void
		{
			if(recycleGuide)
			{
				recycleGuide.destroy();
				recycleGuide = null;
			}
		}
		
		private var _bagHandler:BagPanelClickHander;
		private function recycleLinkHandler(g:GuideArrow,link:String):void
		{
			if(!_bagHandler)
			{
				_bagHandler = new BagPanelClickHander();
			}
			
			_bagHandler.dealVip(false);
			recycleGuide.destroy();
			recycleGuide = null;
		}
		
		private function refreshMask():void
		{
			var lastHideTime:int = HeroDataManager.instance.lastHideTime;
			var lastDeadTime:int = HeroDataManager.instance.lastDeadTime;
			var serveTime:int = ServerTime.time;
			
			if(sectorMaskEffect && sectorMaskEffect.isPlaying)//若正在逆时针播放
			{
				return;
			}
			if(sectorMaskEffect)
			{
				sectorMaskEffect.destroy();
				sectorMaskEffect = null;
			}
			if(lastHideTime && (serveTime - lastHideTime)<30)
			{
                sectorMaskEffect = new SectorMaskEffect(mcHeroHead.iconContainer.icon, completeCallback);
				sectorMaskEffect.play((30 - (serveTime - lastHideTime))*1000,-90,270);
				_isDead = false;
				return;
			}
			if(lastDeadTime && (serveTime - lastDeadTime)<60)
			{
                sectorMaskEffect = new SectorMaskEffect(mcHeroHead.iconContainer.icon, completeCallback);
				sectorMaskEffect.play((60 - (serveTime - lastDeadTime))*1000,-90,270);
				_isDead = true;
			}
		}
		
		private function completeCallback():void
		{
			mcHeroHead.fightBtn.mouseEnabled = true;
			checkShowBattleGuide();
		}

        public function resetPosition(newX:Number, newY:Number):void
		{
            var showW:Number = 206, showH:Number = 71;// 看到最大宽和高
			var limitW:int = 0, limitH:int = 0;
            var borderLeft:int = 0, borderBottom:int = 0;

            _isHasGuideBattle ? borderLeft = 50 : borderLeft = 0;
            _isHasGuideBattle ? borderBottom = 42 : borderBottom = 0;

            if (NewMirMediator.getInstance())//当前舞台大小
			{
                limitW = NewMirMediator.getInstance().width - showW;//_width;
                limitH = NewMirMediator.getInstance().height - showH - borderBottom; //_height;
			}
            if (newX >= limitW)
            {
                newX = limitW;
            }
            if (newY >= limitH)
            {
                newY = limitH;
            }
            if (newX <= borderLeft)
            {
                newX = borderLeft;
            }
            if (newY <= 0)
            {
                newY = 0;
            }
            this.x = int(newX);
            this.y = int(newY);
		}

        private function isInArea(posX:Number, posY:Number):Boolean
        {
            var rect:Rectangle = getUnreachableArea();
            if (posX < rect.x)
            {
                posX += 180;
            }
            if (posX > rect.x && posX < rect.x + rect.width)
            {
                posY += 80;
            }
            if (posX > rect.x && posX < rect.x + rect.width && posY > rect.y)
            {
                return true;
            }
            return false;
        }

        private function getUnreachableArea():Rectangle
        {
            if (_bottomBar)
            {
                return new Rectangle(_bottomBar.x, _bottomBar.y, _bottomBar.width, _bottomBar.height);
            }
            return null;
        }
        
		private function getX(lastW:int, lastX:int, currentW:int):Number
		{
			return lastX * currentW / lastW;
		}
		
		private function getY(lastH:int, lastY:int, currentH:int):Number
		{
			return lastY * currentH / lastH;
		}
		
		public function resize():void
		{
			var lastX:int = HeroDataManager.instance.lastX;
			var lastY:int = HeroDataManager.instance.lastY;
			var lastW:int = HeroDataManager.instance.scaleW;
			var lastH:int = HeroDataManager.instance.scaleH;
            var newX:Number = 0, newY:Number = 0;
            if (lastX || lastY)//已保存位置
			{
				if (_mouseEvent)
				{
					if (_mouseEvent.lastX && _mouseEvent.lastY)
					{
                        newX = getX(lastW, _mouseEvent.lastX, NewMirMediator.getInstance().width);
                        newY = getY(lastH, _mouseEvent.lastY, NewMirMediator.getInstance().height);
					}
					else
					{
                        newX = getX(lastW, lastX, NewMirMediator.getInstance().width);
                        newY = getY(lastH, lastY, NewMirMediator.getInstance().height);
					}
				}
				else
				{
                    newX = getX(lastW, lastX, NewMirMediator.getInstance().width);
                    newY = getY(lastH, lastY, NewMirMediator.getInstance().height);
                    if (isInArea(newX, newY))
                    {
                        initPosition();
                    }
				}
                resetPosition(newX, newY);
			}
			else
			{
                initPosition();
			}
		}

        private function initPosition():void
        {
//			var team:TeamHeadLayer = MainUiMediator.getInstance().teamLayer;
            var tx:int = 0, ty:int = 0;
            _isHasGuideBattle ? tx = 50 : tx = 0;
			ty = 120+5;
//			if(TeamDataManager.instance.hasTeam){
//				ty+=team.height;
//			}
            this.x = tx;
            this.y = int(ty);
        }
	}
}