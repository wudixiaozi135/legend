package com.view.gameWindow.panel.panels.dragonTreasure
{
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subuis.actvEnter.ActvEnter;
    import com.view.gameWindow.mainUi.subuis.actvEnter.McActvEnter;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    
    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
	 * Created by Administrator on 2014/11/29.
	 */
	public class PanelTreasure extends PanelBase
	{
		private var _viewHandler:TreasureViewHandler;
		private var _mouseHandler:TreasureMouseHandler;

		public function PanelTreasure()
		{
			super();
		}

		override protected function initSkin():void
		{
			_skin = new McTreasurePanel();
//			_skin.mouseEnabled = false;
			addChild(_skin);
			setTitleBar(_skin.dragBox);
		}

		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McTreasurePanel = _skin as McTreasurePanel;
//			rsrLoader.addCallBack(skin.primaryBtn, function (mc:MovieClip):void
//			{
//				mc.mouseEnabled = false;
//			});
//			rsrLoader.addCallBack(skin.middleBtn, function (mc:MovieClip):void
//			{
//				mc.mouseEnabled = false;
//			});
//			rsrLoader.addCallBack(skin.advanceBtn, function (mc:MovieClip):void
//			{
//				mc.mouseEnabled = false;
//			});

			rsrLoader.addCallBack(skin.btnTxtTreasure1, function (mc:MovieClip):void
			{
				mc.mouseEnabled = false;
			});

			rsrLoader.addCallBack(skin.btnTxtTreasure10, function (mc:MovieClip):void
			{
				mc.mouseEnabled = false;
			});

			rsrLoader.addCallBack(skin.btnTxtTreasure50, function (mc:MovieClip):void
			{
				mc.mouseEnabled = false;
			});

			
			rsrLoader.addCallBack(skin.mcScrollBar1, function (mc:MovieClip):void
			{
				_viewHandler.initScrollBar1(mc);
			});
			
			rsrLoader.addCallBack(skin.mcScrollBar2, function (mc:MovieClip):void
			{
				_viewHandler.initScrollBar2(mc);
			});
//			for (var i:int = 0; i < 3; i++) {
//				rsrLoader.addCallBack(skin["tab" + i], getFunc(i));
//			}
		}

		private function getFunc(index:int):Function
		{
			var func:Function = function (mc:MovieClip):void
			{
				if (index == DragonTreasureManager.selectIndex) {
					mc.mouseEnabled = false;
					mc.selected = true;
					DragonTreasureManager.lastMc = mc;
				} else {
					mc.selected = false;
				}
			};
			return func;
		}

		override protected function initData():void
		{
			_viewHandler = new TreasureViewHandler(this);
			_mouseHandler = new TreasureMouseHandler(this);
		}


        override public function setPostion():void
        {
            var mc:McActvEnter = (MainUiMediator.getInstance().actvEnter as ActvEnter).skin as McActvEnter;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.mcBtns.mcLayer.btnDragon.x, mc.mcBtns.mcLayer.btnDragon.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
        }

        override public function getPanelRect():Rectangle
        {
            return new Rectangle(0, 0, 941, 626);
        }

        override public function destroy():void
		{
			if (_viewHandler) {
				_viewHandler.destroy();
				_viewHandler = null;
			}
			if (_mouseHandler) {
				_mouseHandler.destroy();
				_mouseHandler = null;
			}
			if (_skin && contains(_skin)) {
				removeChild(_skin);
				_skin = null;
			}
			super.destroy();
		}
	}
}
