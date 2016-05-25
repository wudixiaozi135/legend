package com.view.gameWindow.panel.panels.dragonTreasure.treasureWareHouse
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.dragonTreasure.DragonTreasureManager;
	import com.view.gameWindow.util.TimerManager;
	
	import flash.display.MovieClip;

	/**
	 * Created by Administrator on 2014/12/1.
	 */
	public class PanelTreasureWareHouse extends PanelBase
	{
		private var _viewHandler:TreasureWareHouseViewHandler;
		private var _mouseHandler:TreasureWareHouseMouseHandler;

		public function PanelTreasureWareHouse()
		{
			super();
		}

		override protected function initSkin():void
		{
			_skin = new McTreasureWareHouse();
			addChild(_skin);
			setTitleBar(_skin.dragBox);
		}

		override protected function initData():void
		{
			_viewHandler = new TreasureWareHouseViewHandler(this);
			_mouseHandler = new TreasureWareHouseMouseHandler(this);
		}

		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McTreasureWareHouse = _skin as McTreasureWareHouse;
			rsrLoader.addCallBack(skin.mcSelect, function (mc:MovieClip):void
			{
				mc.mouseEnabled = false;
				mc.visible = false;
			});

			var btnLeftLoaded:Boolean = false, btnRightLoaded:Boolean = false;
			rsrLoader.addCallBack(skin.btnLeft, function (mc:MovieClip):void
			{
				btnLeftLoaded = true;
				if (btnLeftLoaded && btnRightLoaded)
				{
					if (_viewHandler)
					_viewHandler.turnLeft();
				}
			});

			rsrLoader.addCallBack(skin.btnRight, function (mc:MovieClip):void
			{
				btnRightLoaded = true;
				if (btnLeftLoaded && btnRightLoaded)
				{
					if (_viewHandler)
					_viewHandler.turnLeft();
				}
			});

			rsrLoader.addCallBack(skin.btnMakeUp, function (mc:MovieClip):void
			{
				var seconds:int = int((DragonTreasureManager.MAKE_UP_END_TIME - new Date().time) / 1000);
				if (seconds > 0)
				{
					if (DragonTreasureManager.MAKE_UP_SWITCH)
					{
						mc.btnEnabled = false;
						skin.txtMakeUp.text = seconds > 0 ? seconds.toString() : "1";
						TimerManager.getInstance().add(1000, _mouseHandler.delayMakeUp);
					}
				} else
				{
					DragonTreasureManager.MAKE_UP_SWITCH = false;
				}
			});
		}
		
		

		override public function destroy():void
		{
			DragonTreasureManager.lastSlotMc = null;
			if (_viewHandler)
			{
				_viewHandler.destroy();
				_viewHandler = null;
			}
			if (_mouseHandler)
			{
				_mouseHandler.destroy();
				_mouseHandler = null;
			}
			super.destroy();
		}

		public function get viewHandler():TreasureWareHouseViewHandler
		{
			return _viewHandler;
		}

		public function get mouseHandler():TreasureWareHouseMouseHandler
		{
			return _mouseHandler;
		}
		
		override public function setPostion():void
		{
			// TODO Auto Generated method stub
			isMount(true);
		}
		
	}
}
