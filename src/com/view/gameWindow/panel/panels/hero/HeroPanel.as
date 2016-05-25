package com.view.gameWindow.panel.panels.hero
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.mainUi.subuis.herohead.McHeroPanel;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
    
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class HeroPanel extends PanelBase implements IHeroPanel
	{
		private var _mouseHandler:HeroPanelEventHandle;
		private var _timerHandler:HeroPanelTimerHandler;
		private var _tabContent:Sprite = new Sprite();
		
		public function HeroPanel()
		{
			super();
			HeroDataManager.instance.attach(this);
		}
		
		override protected function initSkin():void
		{
			_skin = new McHeroPanel();
			var heroPanel:McHeroPanel = _skin as McHeroPanel;
			addChild(heroPanel);
			setTitleBar(heroPanel.mcTitleBar);
			
			BagDataManager.instance.closeTalk();
			_mouseHandler=new HeroPanelEventHandle(heroPanel);
			_skin.txtJmCount.x-=1;
			_skin.txtEquipCount.x -=1;
			refreshNum();
		}

		private var _defaultSelectIndex:int;

		override public function setSelectTabShow(tabIndex:int = -1):void
		{
			HeroDataManager.instance.isExchange = false;
			_defaultSelectIndex = tabIndex;
		}

		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McHeroPanel=_skin as McHeroPanel;
			var load1:Boolean, load2:Boolean, load3:Boolean;
			var loadComplete:Function = function ():void
			{
				if (load1 && load2 && load3)
				{
					if (_mouseHandler != null)
					{
						var mc:MovieClip = _mouseHandler.getNowSelectMc(_defaultSelectIndex);
						_mouseHandler.initSelect(mc, _defaultSelectIndex);
					}
				}
			};

			rsrLoader.addCallBack(skin.btnEquip,function(mc:MovieClip):void
			{
				load1 = true;
				loadComplete();
			});
			rsrLoader.addCallBack(skin.btnUpgrade, function (mc:MovieClip):void
			{
				load2 = true;
				loadComplete();
			});
			rsrLoader.addCallBack(skin.btnImage, function (mc:MovieClip):void
			{
				load3 = true;
				loadComplete();
				skin.btnImage.visible = false;
			});
		}
		
		public function showIndex(index:int):void
		{
			_defaultSelectIndex = index;
			var mc:MovieClip = _mouseHandler.getNowSelectMc(index);
			_mouseHandler.initSelect(mc, _defaultSelectIndex);
		}
		
		override public function setPostion():void
		{
            var mc:McMainUIBottom = (MainUiMediator.getInstance().bottomBar as BottomBar).skin as McMainUIBottom;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.btnHero.x, mc.btnHero.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
		}
		
		override public function destroy():void
		{
			if(_mouseHandler!=null)
			{
				_mouseHandler.destroy();
			}
			_mouseHandler = null;
			HeroDataManager.instance.detach(this);
			super.destroy();
		}
		
		public function timer():void
		{
			
		}
		
		override public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_HERO_INFO || proc == GameServiceConstants.CM_HERO_GRADE_MERIDIANS ||proc ==GameServiceConstants.SM_QUERY_HERO_GRADE)
			{
				refreshNum();
			}
		}
		
		private function refreshNum():void
		{
			// TODO Auto Generated method stub
			var skin:McHeroPanel=_skin as McHeroPanel;
			var num:int = HeroDataManager.instance.getChannelsNum();
			skin.txtJmCount.text = num+"";
			skin.txtJmBG.visible = skin.txtJmCount.visible = Boolean(num>0);
			num = HeroDataManager.instance.getCanWearEquipNum();
			skin.txtEquipCount.text = num+"";
			skin.txtEquipBG.visible = skin.txtEquipCount.visible = Boolean(num>0);
			if(!GuideSystem.instance.isUnlock(UnlockFuncId.HERO_RE))
			{
				skin.txtJmBG.visible = skin.txtJmCount.visible = false;
			}
		}
		
		override public function getPanelRect():Rectangle
		{
			return new Rectangle(0,0,870,570);//由子类继承实现;
		}
	}
}