package com.view.gameWindow.panel.panels.welfare
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subuis.actvEnter.ActvEnter;
    import com.view.gameWindow.mainUi.subuis.actvEnter.McActvEnter;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    
    import flash.geom.Point;

    public class PanelWelfare extends PanelBase
    {

        internal var viewHandle:WelfareViewHandle;

        public function PanelWelfare()
        {
            super();
			WelfareDataMannager.instance.attach(this);
        }

        override protected function initSkin():void
        {
            var skin:MCPanelWelfare = new MCPanelWelfare;
            _skin = skin;
            setTitleBar(skin.mcTitle);
            skin.txtTitle.text = StringConst.WELFARE_PANEL_0000;
            addChild(_skin);
        }

        override public function setSelectTabShow(tabIndex:int = -1):void
        {
            var defaultIndex:int = 0;
            switch (tabIndex)
            {
                case 0:
                case 1:
                    defaultIndex = tabIndex;
                    break;
                default:
                    defaultIndex = 0;
                    break;
            }
            if (viewHandle)
            {
                viewHandle.switchTab(defaultIndex);
            }
        }

        override protected function addCallBack(rsrLoader:RsrLoader):void
        {
            viewHandle = new WelfareViewHandle(this);
            viewHandle.init(rsrLoader);
        }

        override public function setPostion():void
        {
			if(!MainUiMediator.getInstance().actvEnter)
			{
				return;
			}
            var mc:McActvEnter = (MainUiMediator.getInstance().actvEnter as ActvEnter).skin as McActvEnter;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.mcBtns.mcLayer.btnWelfare.x, mc.mcBtns.mcLayer.btnWelfare.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
        }

        override public function update(proc:int = 0):void
        {
			if(proc == GameServiceConstants.CM_GET_OFF_LINE_EXP)
			{
				if(viewHandle)
				{
					viewHandle.reafreshNum();
				}
			}
        }

        override public function destroy():void
        {
            WelfareDataMannager.instance.reset();
            viewHandle.destroy();
            viewHandle = null;
            super.destroy();
        }
    }
}