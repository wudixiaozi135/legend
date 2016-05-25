package com.view.gameWindow.panel.panels.hero.tab1
{
    import com.model.configData.ConfigDataManager;
    import com.model.consts.EffectConst;
    import com.model.consts.FontFamily;
    import com.model.consts.JobConst;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.LinkButton;
    import com.view.gameWindow.mainUi.subuis.herohead.McHeroEquipPanel;
    import com.view.gameWindow.panel.panels.bag.menu.BagCellMenuDataManager;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    import com.view.gameWindow.panel.panels.hero.HeroPanelTimerHandler;
    import com.view.gameWindow.panel.panels.hero.tab1.HeroProperty.HeroPropertyPanel;
    import com.view.gameWindow.panel.panels.hero.tab1.bag.HeroBagCellHandle;
    import com.view.gameWindow.panel.panels.hero.tab1.bag.HeroBagCellRectRimHandle;
    import com.view.gameWindow.panel.panels.hero.tab1.equip.HeroEquipCellHandle;
    import com.view.gameWindow.panel.panels.propIcon.HeroPropIconGroup;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.NumPic;
    import com.view.gameWindow.util.UIEffectLoader;
    import com.view.gameWindow.util.tabsSwitch.TabBase;
    
    import flash.display.MovieClip;
    import flash.display.Sprite;
    
    import mx.utils.StringUtil;

    public class HeroEquipTab extends TabBase
	{
		private var _mouseEvent:HeroEquipTabEventHandle;
		private var _bagCellHandle:HeroBagCellHandle;
		private var _equipCellHandle:HeroEquipCellHandle;
//		private var _fashionCellHandle:HeroFashionCellHandle;
		private var _modelHandle:EntityModeInUIlHandle;
		private var _heroBagCellRectRimHandle:HeroBagCellRectRimHandle;
		private var _heroPropertyPanel:HeroPropertyPanel;
		private var _timerHandler:HeroPanelTimerHandler;
		
		private var _effectLoader:UIEffectLoader;
		private var _numMc:MovieClip;
		
		public var heroPropertyMcBtn:LinkButton;
//		public var skillMcBtn:LinkButton;
		private var _effectSprite:Sprite = new Sprite();
		private var heroPropIconGroup:HeroPropIconGroup;
		
		public function HeroEquipTab()
		{
			super();

			this.mouseEnabled=false;
		}
		
		override protected function initSkin():void
		{
			_skin = new McHeroEquipPanel();
			_skin.mouseEnabled=false;
			var heroPanel:McHeroEquipPanel = _skin as McHeroEquipPanel;
			addChild(heroPanel);
			
			_numMc = new MovieClip();
			heroPanel.addChild(_numMc);
			_numMc.x =113.5;
			_numMc.y = 23;
			
//			heroPanel.btnBottom.visible=false;
//			heroPanel.btnBottom.mouseEnabled=false;
			
			heroPropIconGroup = new HeroPropIconGroup();
			heroPanel.addChild(heroPropIconGroup);
			heroPropIconGroup.x=110;
			heroPropIconGroup.y=80;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var mcHeroPanel:McHeroEquipPanel = _skin as McHeroEquipPanel;
			rsrLoader.addCallBack(mcHeroPanel.btnSort,function(mc:MovieClip):void
			{
				_mouseEvent.initBtnSort();
			});
			rsrLoader.addCallBack(mcHeroPanel.selectCellEfc,function (mc:MovieClip):void
			{
//				mcHeroPanel.selectCellEfc.visible=false;
				mcHeroPanel.mouseEnabled=false;
			});
//			rsrLoader.addCallBack(mcHeroPanel.mcShoesBtn,function (mc:MovieClip):void
//			{
//				if(_equipCellHandle)
//				_equipCellHandle.refreshEquips();
//			});
		}
		
		override protected function initData():void
		{
			var mcHeroPanel:McHeroEquipPanel = _skin as McHeroEquipPanel;
			_bagCellHandle = new HeroBagCellHandle(this);
			_heroBagCellRectRimHandle = new HeroBagCellRectRimHandle(mcHeroPanel);
			_equipCellHandle = new HeroEquipCellHandle();
			_equipCellHandle.initData(mcHeroPanel);
//			_fashionCellHandle = new HeroFashionCellHandle();
//			_fashionCellHandle.initData(mcHeroPanel);
//			_fashionCellHandle.visible = false;
			_mouseEvent = new HeroEquipTabEventHandle(mcHeroPanel);
			_mouseEvent._heroEquipTab=this;
			_mouseEvent.heroEquipCellHandle = _equipCellHandle;
//			_mouseEvent.heroFashionCellHandle = _fashionCellHandle;
			_modelHandle = new EntityModeInUIlHandle(mcHeroPanel.mcModel);
			
			heroPropertyMcBtn=new LinkButton;
			heroPropertyMcBtn.label = HtmlUtils.createHtmlStr(0x53b436,StringConst.HERO_PANEL_61,14,false,2,FontFamily.FONT_NAME,true);
			mcHeroPanel.heroPropertyMc.addChild(heroPropertyMcBtn);
			
//			skillMcBtn=new LinkButton;
//			skillMcBtn.label = HtmlUtils.createHtmlStr(0x53b436,StringConst.HERO_PANEL_61,14,false,2,FontFamily.FONT_NAME,true);
//			mcHeroPanel.skillMc.addChild(skillMcBtn);
			
			_effectSprite.x = 127.5;
			_effectSprite.y = 43;
			_effectSprite.mouseEnabled = false;
			mcHeroPanel.addChild(_effectSprite);
//			_effectLoader = new UIEffectLoader(_effectSprite,0,0,1,1,EffectConst.RES_FIGHTNUM);
			
			_timerHandler=new HeroPanelTimerHandler(this);
			
			HeroDataManager.instance.requestData();
		}
		
		override public function update(proc:int=0):void
		{
			if(proc==0)return;
//			var numPic:NumPic = new NumPic();
			if(proc == HeroDataManager.TYPE_EXCHANGE)
			{
				_heroBagCellRectRimHandle.switchVisible();
			}
			else
			{
				_bagCellHandle.refreshBagCellData();
				_equipCellHandle.refreshEquips();
				_modelHandle.changeModel();
			}
			_bagCellHandle.dealNotify(proc);
			
			if(_heroPropertyPanel)
			{
				_heroPropertyPanel.changeValue();
			}
			initTxtValue();
			
//			numPic.init("fight_",HeroDataManager.instance.fightPower.toString(),_numMc);
			
			var heroPanel:McHeroEquipPanel = _skin as McHeroEquipPanel;
			var jobStr:String="";
			var jobT:int=HeroDataManager.instance.job;
			if(jobT==JobConst.TYPE_ZS)
			{
				jobStr="hero/zhanshi.png";
			}else if(jobT==JobConst.TYPE_FS)
			{
				jobStr="hero/fashi.png";
			}else
			{
				jobStr="hero/daoshi.png";
			}
			heroPanel.mcHeroJob.resUrl=jobStr;
			loadNewSource(heroPanel.mcHeroJob);
		}
		//移除属性面板 
		public function removeHeroPropertyPanel():void
		{
			this.removeChild(_heroPropertyPanel);
			_heroPropertyPanel.destroy();
			_heroPropertyPanel=null;
		}
		
		public function timer():void
		{
//			_equipCellHandle.timer();
		}
		//更新面板上的文本
		private function initTxtValue():void
		{
			var curExp:int;
			var nextHeroExp:int;
			var expPercent:String;

            var heroPanel:McHeroEquipPanel = _skin as McHeroEquipPanel;
            heroPanel.txtLiftLabel.text = StringConst.ROLE_PROPERTY_PANEL_0003;
            heroPanel.txtLiftLabel.mouseEnabled = false;
            heroPanel.txtMagicLabel.text = StringConst.ROLE_PROPERTY_PANEL_0004;
            heroPanel.txtMagicLabel.mouseEnabled = false;
            heroPanel.txtPhicalDefendLabel.text = StringConst.ROLE_PROPERTY_PANEL_0008;
            heroPanel.txtPhicalDefendLabel.mouseEnabled = false;
            heroPanel.txtMagicDefendLabel.text = StringConst.ROLE_PROPERTY_PANEL_0009;
            heroPanel.txtMagicDefendLabel.mouseEnabled = false;
            heroPanel.txtExpLabel.text = StringConst.ROLE_PROPERTY_PANEL_0087;
            heroPanel.txtExpLabel.mouseEnabled = false;

			var lev:int;
			heroPanel.hpTxt.text=HeroDataManager.instance.attrHp+"/"+HeroDataManager.instance.attrMaxHp;
			heroPanel.mpTxt.text=HeroDataManager.instance.attrMp+"/"+HeroDataManager.instance.attrMaxMp;
			var job:int=HeroDataManager.instance.job; 
			if(job==JobConst.TYPE_ZS)
			{
				heroPanel.dmgTxt.text=StringConst.ROLE_PROPERTY_PANEL_0005;
				heroPanel.phscDmgTxt.text=HeroDataManager.instance.minPhscDmg+"-"+HeroDataManager.instance.maxPhscDmg;	
			}else if(job==JobConst.TYPE_FS)
			{
				heroPanel.dmgTxt.text=StringConst.ROLE_PROPERTY_PANEL_0006;
				heroPanel.phscDmgTxt.text=HeroDataManager.instance.minMgcDmg+"-"+HeroDataManager.instance.maxMgcDmg;	
			}else
			{
				heroPanel.dmgTxt.text=StringConst.ROLE_PROPERTY_PANEL_0007;
				heroPanel.phscDmgTxt.text=HeroDataManager.instance.minTrailDmg+"-"+HeroDataManager.instance.maxTrailDmg;	
			}
			
			heroPanel.phscDfnsTxt.text=HeroDataManager.instance.minPhscDfns+"-"+HeroDataManager.instance.maxPhscDfns;
			heroPanel.mgcDfnsTxt.text=HeroDataManager.instance.minMgcDfns+"-"+HeroDataManager.instance.maxMgcDfns;
			
			heroPanel.nameTxt.text=/*HeroDataManager.instance.name*/RoleDataManager.instance.name + StringUtil.substitute(StringConst.HERO_PANEL_64,JobConst.jobName(job));
			lev=HeroDataManager.instance.lv;
			heroPanel.levTxt.text=String(lev) + StringConst.ROLE_PROPERTY_PANEL_0072;
			var jobName:String = JobConst.jobName(HeroDataManager.instance.job);
//			heroPanel.jobTxt.text=jobName;
//			UrlBitmapDataLoader
			
			curExp=HeroDataManager.instance.exp;
			nextHeroExp=ConfigDataManager.instance.levelCfgData(lev).hero_exp;
			expPercent=((curExp/nextHeroExp)*100).toFixed(2);
			
			heroPanel.expTxt.text=StringUtil.substitute(StringConst.HERO_PANEL_63,curExp,nextHeroExp,expPercent);
			
//			var model:int=HeroDataManager.instance.model;
//			var status:String;
//			if(model == ConstHeroMode.HM_ACTIVE)
//			{
//				status = StringConst.HERO_HEAD_0001;
//			}
//			else if(model == ConstHeroMode.HM_FOLLOW)
//			{
//				status = StringConst.HERO_HEAD_0002;
//			}
//			else
//			{
//				status = StringConst.HERO_HEAD_0003;
//			}
//			heroPanel.statusTxt.text=status;
			
			refreshHpMpBar();
		}
		
		/**刷新血条蓝条*/
		private function refreshHpMpBar():void
		{
			var mcHeroPanel:McHeroEquipPanel,mcHpMask:MovieClip,mcMpMask:MovieClip,attr:int,attrMax:int;
			
//			mcHeroPanel = _skin as McHeroEquipPanel;
//			mcHpMask = mcHeroPanel.mcHp.mcMask as MovieClip;
			attr = HeroDataManager.instance.attrHp;
			attrMax = HeroDataManager.instance.attrMaxHp;
//			mcHpMask.scaleX = attr/attrMax;
			
//			mcMpMask = mcHeroPanel.mcMp.mcMask as MovieClip;
			attr = HeroDataManager.instance.attrMp;
			attrMax = HeroDataManager.instance.attrMaxMp;
//			mcMpMask.scaleX = attr/attrMax;
		}
		
		override public function destroy():void
		{
			if(heroPropIconGroup)
			{
				heroPropIconGroup.destroy();
			}
			heroPropIconGroup=null;
			if(_timerHandler)
			{
				_timerHandler.destroy();
				_timerHandler=null;
			}
			
			var mcHeroPanel:McHeroEquipPanel = _skin as McHeroEquipPanel;
			mcHeroPanel.heroPropertyMc.removeChild(heroPropertyMcBtn);
			heroPropertyMcBtn.destroy();
			heroPropertyMcBtn=null;
			
//			mcHeroPanel.skillMc.removeChild(skillMcBtn);
//			skillMcBtn.destroy();
//			skillMcBtn=null;
			
			if(_heroPropertyPanel)
			{
				removeHeroPropertyPanel();
			}
			

			if(_mouseEvent)
			{
				_mouseEvent.destroy();
				_mouseEvent = null;
			}
			if(_bagCellHandle)
			{
				_bagCellHandle.destroy();
				_bagCellHandle = null;
			}
			if(_heroBagCellRectRimHandle)
			{
				_heroBagCellRectRimHandle.destroy();
				_heroBagCellRectRimHandle = null;
			}
			if(_equipCellHandle)
			{
				_equipCellHandle.destory();
				_equipCellHandle = null;
			}
			if(_modelHandle)
			{
				_modelHandle.destroy();
				_modelHandle = null;
			}
			
//			if(_fashionCellHandle)
//			{
//				_fashionCellHandle.destroy();
//				_fashionCellHandle = null;
//			}
			if(_effectLoader)
			{
				_effectLoader.destroy();
				_effectLoader = null;
			}
			mcHeroPanel.removeChild(_numMc);
			mcHeroPanel.removeChild(_effectSprite);
			
			super.destroy();
		}
		
		public function addHeroPropertyPanel():void
		{
			_heroPropertyPanel=new HeroPropertyPanel;
			this.addChild(_heroPropertyPanel);
			_heroPropertyPanel.initView();
			_heroPropertyPanel.x=133;
			_heroPropertyPanel.y=-10;
		}

		public function get bagCellHandle():HeroBagCellHandle
		{
			return _bagCellHandle;
		}
		
		override protected function attach():void
		{
			HeroDataManager.instance.attach(this);
			BagCellMenuDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			BagCellMenuDataManager.instance.detach(this);
			HeroDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}