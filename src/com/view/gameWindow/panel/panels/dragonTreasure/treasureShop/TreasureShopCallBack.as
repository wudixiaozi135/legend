package com.view.gameWindow.panel.panels.dragonTreasure.treasureShop
{
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    
    import flash.display.MovieClip;
    import flash.text.TextField;

    /**
	 * Created by Administrator on 2014/12/2.
	 */
	public class TreasureShopCallBack
	{
		private var _panel:PanelTreasureShop;
		private var _skin:McTreasureShop;
		private var _rsrLoader:RsrLoader;
		
		public function TreasureShopCallBack(panel:PanelTreasureShop, rsrLoader:RsrLoader)
		{
			_panel = panel;
			_skin = _panel.skin as McTreasureShop;
			_rsrLoader = rsrLoader;
			initialize();
		}

		private function initialize():void
		{
			for (var i:int = 0; i < 3; i++)
			{
				_rsrLoader.addCallBack(_skin["tab" + i], getFunc(i));
			}
			var btnLeftLoaded:Boolean = false, btnRightLoaded:Boolean = false;

			_rsrLoader.addCallBack(_skin.btnLeft, function (mc:MovieClip):void
			{
				btnLeftLoaded = true;
				if (btnLeftLoaded && btnRightLoaded)
				{
					_panel.viewHandler.refreshPage();
				}
			});
			_rsrLoader.addCallBack(_skin.btnRight, function (mc:MovieClip):void
			{
				btnRightLoaded = true;
				if (btnLeftLoaded && btnRightLoaded)
				{
					_panel.viewHandler.refreshPage();
				}
			});
		}

		private function getFunc(index:int):Function
		{
			var func:Function = function (mc:MovieClip):void
			{
				var tf:TextField = mc.txt as TextField;
                tf.mouseEnabled = false;
				tf.text = StringConst["PANEL_DRAGON_SHOP_TAB_" + index];
				tf.textColor = 0xd4a460;

				if (index == TreasureShopManager.selectIndex)
				{
					tf.textColor = 0xffe1aa;
					mc.selected = true;
					mc.mouseEnabled = false;
					TreasureShopManager.lastMc = mc;
				} else
				{
					mc.selected = false;
					mc.mouseEnabled = true;
				}
			};
			return func;
		}

		public function destory():void
		{

		}
	}
}
