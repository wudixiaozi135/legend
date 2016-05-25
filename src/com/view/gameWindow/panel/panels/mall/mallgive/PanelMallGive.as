package com.view.gameWindow.panel.panels.mall.mallgive
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.mall.McMallGive;

	/**
	 * Created by Administrator on 2014/11/21.
	 */
	public class PanelMallGive extends PanelBase
	{
		public function PanelMallGive()
		{
			super();

		}

		private var _callBackHandler:MallGiveCallBackHandler;

		public function get callBackHandler():MallGiveCallBackHandler
		{
			return _callBackHandler;
		}

		public function set callBackHandler(value:MallGiveCallBackHandler):void
		{
			_callBackHandler = value;
		}

		private var _viewHandler:MallGiveViewHandler;

		public function get viewHandler():MallGiveViewHandler
		{
			return _viewHandler;
		}

		public function set viewHandler(value:MallGiveViewHandler):void
		{
			_viewHandler = value;
		}

		private var _mouseHandler:MallGiveMouseHandler;

		public function get mouseHandler():MallGiveMouseHandler
		{
			return _mouseHandler;
		}

		public function set mouseHandler(value:MallGiveMouseHandler):void
		{
			_mouseHandler = value;
		}

		override protected function initSkin():void
		{
			_skin = new McMallGive();
			var mcMall:McMallGive = _skin as McMallGive;
			addChild(mcMall);
			setTitleBar(mcMall.dragBox);
		}

		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			_callBackHandler = new MallGiveCallBackHandler(this, rsrLoader);
		}

		override protected function initData():void
		{
			_viewHandler = new MallGiveViewHandler(this);
			_mouseHandler = new MallGiveMouseHandler(this);
		}

		override public function initView():void
		{
			super.initView();
		}

		override public function destroy():void
		{
			if (_callBackHandler)
			{
				_callBackHandler.destroy();
				_callBackHandler = null;
			}
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
			if (_skin)
			{
				_skin = null;
			}
			super.destroy();
		}
	}
}
