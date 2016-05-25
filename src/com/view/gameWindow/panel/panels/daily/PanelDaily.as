package com.view.gameWindow.panel.panels.daily
{
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMapProperty;
    import com.view.gameWindow.mainUi.subuis.minimap.MiniMap;
    import com.view.gameWindow.panel.panelbase.PanelBase;

    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
	 * 日常面板类
	 * @author Administrator
	 */	
	public class PanelDaily extends PanelBase
	{
		internal var callBackHandle:PanelDailyCallBackHandle;
		internal var viewHandle:PanelDailyViewHandle;
		internal var mouseHandle:PanelDailyMouseHandle;
		
		public function PanelDaily()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McDaily1 = new McDaily1();
			_skin = skin;
			addChild(_skin);
			setTitleBar(skin.mcDrag);
		}

		override public function setSelectTabShow(tabIndex:int = -1):void
		{
			var defaultIndex:int = 0;
			switch (tabIndex)
			{
				case 0:
					defaultIndex = DailyDataManager.instance.tabPep;
					break;
				case 1:
					defaultIndex = DailyDataManager.instance.tabActivity;
					break;
				case 2:
					defaultIndex = DailyDataManager.instance.tabTask;
					break;
				case 3:
					defaultIndex = DailyDataManager.instance.tabDgn;
					break;
				default:
					defaultIndex = DailyDataManager.instance.tabPep;
					break;
			}
			DailyDataManager.instance.selectTab = defaultIndex;
		}

		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			callBackHandle = new PanelDailyCallBackHandle(this,rsrLoader);
		}
		
		override protected function initData():void
		{
			viewHandle = new PanelDailyViewHandle(this);
			mouseHandle = new PanelDailyMouseHandle(this);
		}
		
		override public function getPanelRect():Rectangle
		{
			var skin:McDaily1 = _skin as McDaily1;
			if(skin==null)
			{
				return new Rectangle(0,0,0,0);
			}
			return new Rectangle(0,0,skin.mcBg.width,skin.mcBg.height);//由子类继承实现
		}


        override public function setPostion():void
        {
            var mc:McMapProperty = (MainUiMediator.getInstance().miniMap as MiniMap).skin as McMapProperty;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.btnAvtivityDaily.x, mc.btnAvtivityDaily.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
        }

        override public function destroy():void
		{
			DailyDataManager.instance.selectTab = DailyDataManager.instance.tabPep;
			if(mouseHandle)
			{
				mouseHandle.destroy();
				mouseHandle = null;
			}
			if(viewHandle)
			{
				viewHandle.destroy();
				viewHandle = null;
			}
			if(callBackHandle)
			{
				callBackHandle.destroy();
				callBackHandle = null;
			}
			super.destroy();
		}
	}
}