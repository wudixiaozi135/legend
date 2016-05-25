package com.view.gameWindow.panel.panels.unlock
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.util.Cover;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	
	/**
	 * @author wqhk
	 * 2014-10-30
	 */
	public class UnlockPanel extends PanelBase implements IUnlockPanel,IUrlBitmapDataLoaderReceiver
	{
		private var _mc:McUnlockPanel;
		private var _loader:UrlBitmapDataLoader;
		private var func_id:int;
		private var icon:Bitmap;
		
		public function UnlockPanel()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			_mc = new McUnlockPanel();
			_skin = _mc;
			
			addChild(_skin);
			addEventListener(MouseEvent.CLICK,clickHandler,false,0,true);
		}
		
		override public function destroy():void
		{
			clear();
			super.destroy();
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			switch(e.target)
			{
				case _mc.btn:
					PanelMediator.instance.closePanel(PanelConst.TYPE_UNLOCK);
					PanelMediator.instance.closePanel(PanelConst.TYPE_COVER);
					GuideSystem.instance.unlockAnimNotice.notify(func_id);
					GuideSystem.instance.updateUserUnlockOperation(func_id);
					break;
			}
		}
		
		public function setFuncId(value:int):void
		{
			func_id = value;
		}
		
		public function setTxt(value:String):void
		{
			_mc.txt.htmlText = value;
		}
		
		private function clear():void
		{
			if(_loader)
			{
				_loader.destroy();
				_loader = null;
			}
			
			if(icon && icon.parent)
			{
				icon.parent.removeChild(icon);
			}
		}
		
		public function setIcon(value:String):void
		{
			clear();
			
			_loader = new UrlBitmapDataLoader(this);
			_loader.loadBitmap(ResourcePathConstants.IMAGE_UNLOCK_FOLDER_LOAD+value+ResourcePathConstants.POSTFIX_PNG);
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			icon = new Bitmap(bitmapData);
			icon.x = 33;
			icon.y = -150;
			_skin.addChild(icon);
		}
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		public function urlBitmapDataError(url:String, info:Object):void
		{
			
		}
	}
}