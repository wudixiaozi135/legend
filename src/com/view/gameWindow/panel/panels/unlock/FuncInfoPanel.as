package com.view.gameWindow.panel.panels.unlock
{
	import com.greensock.TweenLite;
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.gameWindow.rsr.RsrLoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	
	/**
	 * @author wqhk
	 * 2014-12-28
	 */
	public class FuncInfoPanel extends Sprite implements IFuncInfoPanel,IUrlBitmapDataLoaderReceiver
	{
		private var _mc:McFuncInfoPanel;
		private var _loader:UrlBitmapDataLoader;
		private var func_id:int;
		private var icon:Bitmap;
		
		private var mk:Shape = new Shape();
		private var open:TweenLite;
		public function FuncInfoPanel()
		{
			super();
			
			_mc = new McFuncInfoPanel();
			addChild(_mc);
			
			var r:RsrLoader = new RsrLoader();
			r.load(_mc,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD,true);
			
			this.visible = false;
			mouseEnabled = false;
			mouseChildren = false;
			
			mk.graphics.beginFill(0,0);
			mk.graphics.drawRect(0,0,_mc.width,_mc.height);
			mk.graphics.endFill();
			mk.width = 0;
			addChild(mk);
			this.mask = mk;
		}
		
		public function checkFuncId(id:int):void
		{
			if(func_id)
			{
				if(func_id == id)
				{
					show(false);
				}
			}
		}
		
		public function show(value:Boolean):void
		{
			visible = value;
		}
		
		private var needOpen:Boolean = false;
		public function setFuncId(value:int):void
		{
			if(func_id != value)
			{
				func_id = value;
				needOpen = true;
			}
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
			
			_url = "";
		}
		
		private var _url:String;
		public function setIcon(value:String):void
		{
			if(_url == value)
			{
				return;
			}
			
			clear();
			
			_url = value;
			_loader = new UrlBitmapDataLoader(this);
			_loader.loadBitmap(ResourcePathConstants.IMAGE_UNLOCK_FOLDER_LOAD+value+ResourcePathConstants.POSTFIX_PNG);
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			icon = new Bitmap(bitmapData);
			icon.x = 5;
			icon.y = 0;
			_mc.icon.addChild(icon);
			
			openAnim();
		}
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		public function urlBitmapDataError(url:String, info:Object):void
		{
			openAnim();
		}
		
		private function openAnim():void
		{
			if(needOpen)
			{
				if(open)
				{
					open.restart();
				}
				else
				{
					mk.width = 0;
					open = TweenLite.to(mk,0.5,{width:_mc.width});
				}
				needOpen = false;
			}
		}
		
	}
}