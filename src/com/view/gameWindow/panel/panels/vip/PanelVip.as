package com.view.gameWindow.panel.panels.vip
{
    import com.model.configData.cfgdata.PeerageCfgData;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.panel.panelbase.IPanelTab;
    import com.view.gameWindow.panel.panelbase.PanelBase;

    import flash.display.MovieClip;
    import flash.geom.Point;

    /**
	 * vip特权面板类
	 * @author Administrator
	 */	
	public class PanelVip extends PanelBase implements IPanelTab
	{
		internal var mouseHandle:PanelVipMouseHandle;
		internal var viewHandle:PanelVipViewHandle;
		
		public function PanelVip()
		{
			super();
			VipDataManager.instance.attach(this);
		}
		
		private var _tabIndexInit:int = -1;
		private var _tabBtnInited0:Boolean = false;
		private var _tabBtnInited1:Boolean = false;
		public function setTabIndex(index:int):void
		{
			_tabIndexInit = index;
			checkTabIndex();
		}
		
		public function getTabIndex():int
		{
			return mouseHandle.getTabIndex();
		}
		
		private function checkTabIndex():void
		{
			if(_tabIndexInit != -1 && _tabBtnInited0 && _tabBtnInited1)
			{
				mouseHandle.setTabIndex(_tabIndexInit);
			}
		}
		
		override protected function initSkin():void
		{
			var mc:McVip = new McVip();
			_skin = mc;
			addChild(_skin);
			setTitleBar(mc.mcDrag);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var mc:McVip = _skin as McVip;
			rsrLoader.addCallBack(mc.btnOpen,function (mc:MovieClip):void
			{
				mc.txt.text = StringConst.VIP_PANEL_0001;
				mc.txt.textColor = 0xffe1aa;
				mc.selected = true;
				mc.mouseEnabled = false;
				mouseHandle.lastClickBtn = mc;
				
				_tabBtnInited0 = true;
				checkTabIndex();
			});
			rsrLoader.addCallBack(mc.btnPrivilege,function (mc:MovieClip):void
			{
				mc.txt.text = StringConst.VIP_PANEL_0002;
				mc.txt.textColor = 0x675138;
				
				_tabBtnInited1 = true;
				checkTabIndex();
			});
			rsrLoader.addCallBack(mc.mcSign,function (mc:MovieClip):void
			{
				var manager:VipDataManager = VipDataManager.instance;
				var peerageCfgData:PeerageCfgData = manager.peerageCfgData;
				mc.gotoAndStop(peerageCfgData ? 2 : 1);
			});
		}
		
		override protected function initData():void
		{
			viewHandle = new PanelVipViewHandle(this);
			mouseHandle = new PanelVipMouseHandle(this);
		}
		
		override public function update(proc:int=0):void
		{
			viewHandle.refresh();
		}

        override public function setPostion():void
        {
            var mc:McMainUIBottom = (MainUiMediator.getInstance().bottomBar as BottomBar).skin as McMainUIBottom;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.vipBtn.x, mc.vipBtn.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
        }
		override public function destroy():void
		{
			VipDataManager.instance.detach(this);
			if(viewHandle)
			{
				viewHandle.destroy();
				viewHandle = null;
			}
			if(mouseHandle)
			{
				mouseHandle.destroy();
				mouseHandle = null;
			}
			super.destroy();
		}
	}
}