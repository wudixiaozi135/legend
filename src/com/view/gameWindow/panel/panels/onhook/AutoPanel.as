package com.view.gameWindow.panel.panels.onhook
{
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.ButtonSelect;
    import com.view.gameWindow.common.CountCallback;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMapProperty;
    import com.view.gameWindow.mainUi.subuis.minimap.MiniMap;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.IPanelTab;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.util.tabsSwitch.TabsSwitch;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    /**
	 * @author wqhk
	 * 2014-10-11
	 */
	public class AutoPanel extends PanelBase implements IPanelTab
	{
		public static const NUM_TAB:int =3;
		private var _mc:McAutoPanel;
		private var _tabContents:TabsSwitch;
		private var _tabBtns:ButtonSelect;
		private var _initAfterTabBtnLoadedHandler:CountCallback;
		
		public function AutoPanel()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			_mc = new McAutoPanel();
			_skin = _mc;
			addChild(_skin);
			
			setTitleBar(_mc.dragBox);
			
			_tabBtns = new ButtonSelect();
			_tabBtns.selectHandler = tabSelectHandler;
			_tabBtns.resetHandler = tabResetHandler;
			_tabBtns.init([_mc.tab0,_mc.tab1,_mc.tab2]);
			
			_tabContents = new TabsSwitch(_mc.ctnerPos,Vector.<Class>([PanelAssistSet,PanelOnhook,PanelShortKey]));
			
			_initAfterTabBtnLoadedHandler = new CountCallback(initTabBtn,NUM_TAB);
			
			addEventListener(MouseEvent.CLICK,clickHandler,false,0,true);
			
			_tabBtns.selectedIndex = 0;
			_mc.txtTitle.text = StringConst.AUTO_SYSTEM;
			
		}
		
		override public function destroy():void
		{
			removeEventListener(MouseEvent.CLICK,clickHandler);
			
			_tabBtns.clear();
			_tabContents.destroy();
			
			_initAfterTabBtnLoadedHandler.destroy();
			_initAfterTabBtnLoadedHandler = null;
			super.destroy();
		}
		
		public function setTabIndex(index:int):void
		{
			if(_tabBtns)
			{
				_tabBtns.selectedIndex = index;
			}
		}
		public function getTabIndex():int
		{
			if(_tabBtns)
			{
				return _tabBtns.selectedIndex;
			}
			
			return -1;
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			switch(e.target)
			{
				case _mc.tab0:
					_tabBtns.selectedIndex = 0;
					break;
				case _mc.tab1:
					_tabBtns.selectedIndex = 1;
					break;
				case _mc.tab2:
					_tabBtns.selectedIndex = 2;
					break;
				case _mc.btnClose:
					PanelMediator.instance.closePanel(PanelConst.TYPE_ASSIST_SET);
					break;
			}
		}
		
		private function initTabBtn():void
		{
			_mc.tab0.txt.text = StringConst.AUTO_ASSIT;
			_mc.tab1.txt.text = StringConst.AUTO_ONHOOK;
			_mc.tab2.txt.text = StringConst.AUTO_HOTKEY;
			_tabBtns.init([_mc.tab0,_mc.tab1,_mc.tab2]);
		}
		
		public function tabSelectHandler(btn:MovieClip):void
		{
			if(btn.txt)
			{
				btn.txt.textColor = 0xffe1aa;
			}
			_tabContents.onClick(_tabBtns.selectedIndex);
		}
		
		public function tabResetHandler(btn:MovieClip):void
		{
			if(btn.txt)
			{
				btn.txt.textColor = 0x675138;
			}
		}

        override public function setPostion():void
        {
            var mc:McMapProperty = (MainUiMediator.getInstance().miniMap as MiniMap).skin as McMapProperty;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.btnSystemSet.x, mc.btnSystemSet.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
        }

        override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			super.addCallBack(rsrLoader);
			
			rsrLoader.addCallBack(_mc.tab0,function():void{_initAfterTabBtnLoadedHandler.call()});
			rsrLoader.addCallBack(_mc.tab1,function():void{_initAfterTabBtnLoadedHandler.call()});
			rsrLoader.addCallBack(_mc.tab2,function():void{_initAfterTabBtnLoadedHandler.call()});
		}
	}
}