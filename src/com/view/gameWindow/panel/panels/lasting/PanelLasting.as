package com.view.gameWindow.panel.panels.lasting
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	public class PanelLasting extends PanelBase
	{
		private var _viewHandler:LastingViewHandler;
		private var _mouseHandler:LastingMouseHandler;
		public function PanelLasting()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			_skin = new McLasting();
			addChild(_skin);
		}
		
		override protected function initData():void
		{
			_viewHandler = new LastingViewHandler(this);
			_mouseHandler = new LastingMouseHandler(this);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McLasting = _skin as McLasting;
			
			rsrLoader.addCallBack(skin.btnClose,function(mc:MovieClip):void{
				skin.btnClose.buttonMode = true;
			});
			rsrLoader.addCallBack(skin.btnShoe,function(mc:MovieClip):void{
				skin.btnShoe.buttonMode = true;
			});
		}
		
		public function get viewHandler():LastingViewHandler
		{
			return _viewHandler;
		}
		
		public function get mouseHandler():LastingMouseHandler
		{
			return _mouseHandler;
		}
		
		override public function destroy():void
		{
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