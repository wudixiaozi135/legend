package com.view.gameWindow.panel.panels.specialRing
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.panel.panelbase.IPanelTab;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.daily.DailyDataManager;
    import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
    import com.view.gameWindow.panel.panels.onhook.AutoSystem;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.task.TaskDataManager;
    import com.view.gameWindow.util.tabsSwitch.TabBase;
    
    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.clearTimeout;
    import flash.utils.setInterval;
    import flash.utils.setTimeout;

    /**
	 * 特戒面板类
	 * @author Administrator
	 */	
	public class PanelSpecialRing extends PanelBase implements IPanelTab
	{
		private var _mouseHandle:PanelSpecialRingMouseHandle;
		
		public function PanelSpecialRing()
		{
			super();
			BagDataManager.instance.attach(this);
			RoleDataManager.instance.attach(this);
			DailyDataManager.instance.attach(this);
		}
		
		private var _tabIndex:int = -1;
		private var _tabBtnInited0:Boolean = false;
		private var _tabBtnInited1:Boolean = false;
		
		public function setTabIndex(index:int):void
		{
			_tabIndex = index;
			SpecialRingDataManager.instance.selectTab = _tabIndex;
			checkTabIndex();
		}
		
		public function getTabIndex():int
		{
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			if(_mouseHandle.tabIndex == 0 && manager.select != manager.ringIdBy(SpecialRingData.RING_INDEX_1))
			{
				return 3;
			}
			
			return _mouseHandle.tabIndex;
		}
		
		private function checkTabIndex():void
		{
			if(_tabIndex != -1 && _tabBtnInited0 && _tabBtnInited1)
			{
				_mouseHandle.tabIndex = index;
			}
		}
		
		override protected function initSkin():void
		{
			var skin:McSpecialRing = new McSpecialRing();
			_skin = skin;
			addChild(_skin);
			setTitleBar(skin.mcDrag);
			initTxt();
		}
		
		private function initTxt():void
		{
			var skin:McSpecialRing = _skin as McSpecialRing;
			var defaultTextFormat:TextFormat = skin.txtTitle.defaultTextFormat;
			defaultTextFormat.bold = true;
			skin.txtTitle.defaultTextFormat = defaultTextFormat;
			skin.txtTitle.setTextFormat(defaultTextFormat);
			skin.txtTitle.text = StringConst.SPECIAL_RING_PANEL_0001;
			refreshNum();
		}
		
		private function refreshNum():void
		{
			// TODO Auto Generated method stub
			var ringCount:int = SpecialRingDataManager.instance.upableNum();
			skin.txtRingCount.text = ringCount+"";
			skin.txtRingBG.visible = skin.txtRingCount.visible = Boolean(ringCount>0);
			var dgCount:int;
			if(GuideSystem.instance.isUnlock(UnlockFuncId.SPECIAL_RING_DGN))
			{
				dgCount = DailyDataManager.instance.player_daily_vit/20;
			}
			skin.txtDgCount.text = dgCount+"";
			skin.txtDgBG.visible = skin.txtDgCount.visible = Boolean(dgCount>0);
		}
		
		override public function setPostion():void
		{
            var mc:McMainUIBottom = (MainUiMediator.getInstance().bottomBar as BottomBar).skin as McMainUIBottom;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.btnSpecialRing.x, mc.btnSpecialRing.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McSpecialRing = _skin as McSpecialRing;
			rsrLoader.addCallBack(skin.btnUpgrade,function(mc:MovieClip):void
			{
				setTabBtnState(0,mc);
				_tabBtnInited0 = true;
				checkTabIndex();
			});
			rsrLoader.addCallBack(skin.btnDungeon,function(mc:MovieClip):void
			{
				setTabBtnState(1,mc);
				_tabBtnInited1 = true;
				checkTabIndex();
			});
			rsrLoader.addCallBack(skin.txtDgBG,function(mc:MovieClip):void
			{
				mc.mouseEnabled = false;
				skin.txtDgCount.mouseEnabled =false;
			});
			rsrLoader.addCallBack(skin.txtRingBG,function(mc:MovieClip):void
			{
				mc.mouseEnabled = false;
				skin.txtRingCount.mouseEnabled = false;
			});
		}
		
		private function setTabBtnState(tab:int,mc:MovieClip):void
		{
			var selectTab:int = SpecialRingDataManager.instance.selectTab;
			var textField:TextField = mc.txt as TextField;
			switch(tab)
			{
				default:
				case 0:
					textField.text = StringConst.SPECIAL_RING_PANEL_0002;
					break;
				case 1:
					textField.text = StringConst.SPECIAL_RING_PANEL_0003;
					break;
			}
			if(selectTab == tab)
			{
				mc.selected = true;
				mc.mouseEnabled = false;
				textField.textColor = 0xffe1aa;
				_mouseHandle.lastBtn = mc;
			}
			else
			{
				textField.textColor = 0xd4a460;
			}
		}
		
		//暂时
		private var timeId:int = 0;
		override protected function initData():void
		{
			_mouseHandle = new PanelSpecialRingMouseHandle(this);
			
			//暂时  蛋疼
			if(AutoSystem.instance.tempStop)
			{
				TaskDataManager.instance.setAutoTask(false,"PanelSpecialRing::initData");
				if(timeId)
				{
					clearTimeout(timeId);
				}
				timeId = setTimeout(startAuto,500);
			}
		}
		
		private function startAuto():void
		{
			TaskDataManager.instance.setAutoTask(true,"Special startAuto");
			AutoSystem.instance.tempStop = false;
			
			if(timeId)
			{
				clearTimeout(timeId);
				timeId = 0;
			}
		}
		
		override public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_BAG_ITEMS||proc == GameServiceConstants.SM_CHR_INFO||proc == GameServiceConstants.SM_DAILY_INFO)
			{
				refreshNum();
			}
		}
		
		public function get tab():TabBase
		{
			return _mouseHandle.tab;
		}
		
		override public function destroy():void
		{
			SpecialRingDataManager.instance.selectTab = 0;
			SpecialRingDataManager.instance.autoSelectFunc(true);
			RoleDataManager.instance.detach(this);
			DailyDataManager.instance.detach(this);
			BagDataManager.instance.detach(this);
			if(_mouseHandle)
			{
				_mouseHandle.destroy();
				_mouseHandle = null;
			}
			
			if(timeId)
			{
				clearTimeout(timeId);
				timeId;
			}
			
			super.destroy();
		}
	}
}