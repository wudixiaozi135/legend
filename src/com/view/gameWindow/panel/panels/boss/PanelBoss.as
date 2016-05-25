package com.view.gameWindow.panel.panels.boss
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subuis.actvEnter.ActvEnter;
    import com.view.gameWindow.mainUi.subuis.actvEnter.McActvEnter;
    import com.view.gameWindow.panel.panelbase.IPanelTab;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.vip.VipDataManager;
    
    import flash.geom.Point;

    public class PanelBoss extends PanelBase implements IPanelTab
	{
		public function PanelBoss()
		{
			super();

			VipDataManager.instance.attach(this);

		}

		internal var callBackHandle:PanelBossCallBackHandle;
		internal var viewHandle:PanelBossViewHandle;

		public var mouseHandle:PanelBossMouseHandle;


		override public function setSelectTabShow(tabIndex:int = -1):void
		{
			BossDataManager.instance.GetBossHPInfo();
			if (mouseHandle)
			{
				mouseHandle.switchTabByIndex(tabIndex);
			}
		}
		
		public function getTabIndex():int
		{
			return BossDataManager.instance.selectTab;
		}
		
		public function setTabIndex(index:int):void
		{
			setSelectTabShow(index);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			viewHandle = new PanelBossViewHandle(this);
			mouseHandle = new PanelBossMouseHandle(this);			
			callBackHandle = new PanelBossCallBackHandle(this, rsrLoader);
			VipDataManager.instance.queryVipInfo();		
		}
 

		override protected function initSkin():void
		{
			var skin:MCPanelBoss = new MCPanelBoss();
			this._skin = skin;
			addChild(_skin);
			setTitleBar(skin.dragBox);
		}

		override public function update(proc:int = 0):void
		{
			switch (proc)
			{
				case GameServiceConstants.SM_VIP_INFO:
					viewHandle.refreshVip();
			}

		}

        override public function setPostion():void
        {
            var mc:McActvEnter = (MainUiMediator.getInstance().actvEnter as ActvEnter).skin as McActvEnter;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.mcBtns.mcLayer.btnBoss.x, mc.mcBtns.mcLayer.btnBoss.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
        }

        override public function destroy():void
		{
			if (mouseHandle)
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
			BossDataManager.instance.selectTab = 0;
			VipDataManager.instance.detach(this);

			super.destroy();
		}
	}
}