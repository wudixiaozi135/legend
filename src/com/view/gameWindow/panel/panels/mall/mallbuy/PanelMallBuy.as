package com.view.gameWindow.panel.panels.mall.mallbuy
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.HighlightEffectManager;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.mall.MallDataManager;
	import com.view.gameWindow.panel.panels.mall.McMallBuyPanel;

	/**
	 * Created by Administrator on 2014/11/21.
	 */
	public class PanelMallBuy extends PanelBase
	{

		public function PanelMallBuy()
		{
			super();
			MallDataManager.instance.attach(this);
			_hl = new HighlightEffectManager();
		}
		
		private var _hl:HighlightEffectManager;
		private var _hightLight:Boolean = false;
		private var _isBuyBtnInited:Boolean = false;
		
		public function get hightLight():Boolean
		{
			return _hightLight;
		}
		
		public function set hightLight(value:Boolean):void
		{
			if(_hightLight != value)
			{
				_hightLight = value;
				checkHightLight();
			}
		}
		
		private function checkHightLight():void
		{
			if(_isBuyBtnInited)
			{
				if(_hightLight)
				{
					_hl.show(this,skin.btnOk);
				}
				else
				{
					_hl.hide(skin.btnOk);
				}
			}
		}

		private var _callBackHandler:MallBuyCallBackHandler;

		public function get callBackHandler():MallBuyCallBackHandler
		{
			return _callBackHandler;
		}

		private var _viewHandler:MallBuyViewHandler;

		public function get viewHandler():MallBuyViewHandler
		{
			return _viewHandler;
		}

		private var _mouseHandler:MallBuyMouseHandler;

		public function get mouseHandler():MallBuyMouseHandler
		{
			return _mouseHandler;
		}

		override public function update(proc:int = 0):void
		{
			switch (proc)
			{
				default :
					break;
				case GameServiceConstants.CM_BUY_SHOP_ITEM:
					break;
			}
		}

		override public function initView():void
		{
			super.initView();
		}

		override protected function initSkin():void
		{
			_skin = new McMallBuyPanel();
			var mcMall:McMallBuyPanel = _skin as McMallBuyPanel;
			addChild(mcMall);
			setTitleBar(mcMall.dragBox);
		}

		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			_callBackHandler = new MallBuyCallBackHandler(this, rsrLoader);
			rsrLoader.addCallBack(_skin.btnOk,function():void{
				_isBuyBtnInited = true;
				checkHightLight();
			});
		}

		override protected function initData():void
		{
			_viewHandler = new MallBuyViewHandler(this);
			_mouseHandler = new MallBuyMouseHandler(this);
		}

		override public function destroy():void
		{
			hightLight = false;
			MallDataManager.instance.detach(this);

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
