package com.view.gameWindow.panel.panels.mall.mallacquire
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.mall.McAcquirePanel;
	import com.view.gameWindow.panel.panels.mall.mallacquire.data.AcquireManager;

	import flash.display.MovieClip;

	/**
	 * Created by Administrator on 2014/11/22.
	 */
	public class PanelAcquire extends PanelBase
	{
		public function PanelAcquire()
		{
			super();
		}

		private var _viewHandler:AcquireViewHandler;

		public function get viewHandler():AcquireViewHandler
		{
			return _viewHandler;
		}

		public function set viewHandler(value:AcquireViewHandler):void
		{
			_viewHandler = value;
		}

		private var _mouseHandler:AcquireMouseHandler;

		public function get mouseHandler():AcquireMouseHandler
		{
			return _mouseHandler;
		}

		public function set mouseHandler(value:AcquireMouseHandler):void
		{
			_mouseHandler = value;
		}

		override protected function initSkin():void
		{
			_skin = new McAcquirePanel();
			addChild(_skin);
		}

		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McAcquirePanel = _skin as McAcquirePanel;
			rsrLoader.addCallBack(skin.scrollBar, function (mc:MovieClip):void
			{
				if (_viewHandler)
				{
					_viewHandler.initScrollBar(mc);
				}
			});
		}

		override protected function initData():void
		{
			_viewHandler = new AcquireViewHandler(this);
			_mouseHandler = new AcquireMouseHandler(this);
		}

		override public function destroy():void
		{
			AcquireManager.costType = 0;
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
	}
}
