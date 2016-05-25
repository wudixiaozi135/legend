package com.view.gameWindow.panel.panels.guideSystem.view
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.consts.FontFamily;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**
	 * @author wqhk
	 * 2014-11-24
	 */
	public class MapMarker extends Sprite implements IUrlBitmapDataLoaderReceiver
	{
		private var _loader:UrlBitmapDataLoader;
		private var _loader1:UrlBitmapDataLoader;
		private var _bmp:Bitmap;
		private var _bmp1:Bitmap;
		private var _arrow:GuideArrow;
		private var _label:TextField;
		
		public function MapMarker(label:String)
		{
			super();
			
			_arrow = new GuideArrow();
			_arrow.rotation = 90;
			_arrow.x = 0;
			_arrow.y = 0;
			addChild(_arrow);
			
			_label = new TextField();
			_label.defaultTextFormat = new TextFormat(FontFamily.FONT_NAME,14);
			_label.htmlText = HtmlUtils.createHtmlStr(0xffff00,label,14,true);
			_label.filters = [new GlowFilter(0xcc1100,1,3,3,10)];
			_label.width = _label.textWidth + 5;
			_label.height = _label.textHeight + 3;
			_label.y = -100;
			_label.x = -(_label.width/2);
			/*addChild(_label);*/
			
			addEventListener(Event.ADDED_TO_STAGE,addedHandler,false,0,true);
			addEventListener(Event.REMOVED_FROM_STAGE,removedHandler,false,0,true);
		}
		
		public function destroy():void
		{
			clear();
			if(_bmp)
			{
				if(_bmp.parent)
				{
					_bmp.parent.removeChild(_bmp);
				}
				if(_bmp.bitmapData)
				{
					_bmp.bitmapData = null;
				}
			}
			if(_bmp1)
			{
				if(_bmp1.parent)
				{
					_bmp1.parent.removeChild(_bmp1);
				}
				if(_bmp1.bitmapData)
				{
					_bmp1.bitmapData = null;
				}
			}
			removeEventListener(Event.ADDED_TO_STAGE,addedHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE,removedHandler);
			
			if(_arrow)
			{
				_arrow.destroy();
				_arrow = null;
			}
		}
		
		private function clear():void
		{
			if(_loader)
			{
				_loader.destroy();
				_loader = null;
			}
			if(_loader1)
			{
				_loader1.destroy();
				_loader1 = null;
			}
		}
		
		private function addedHandler(e:Event):void
		{
			clear();
			_loader = new UrlBitmapDataLoader(this);
			_loader.loadBitmap(ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD+"common/map_marker"+ResourcePathConstants.POSTFIX_PNG,0);
			_loader1 = new UrlBitmapDataLoader(this);
			_loader1.loadBitmap(ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD+"common/dgn_tower_text"+ResourcePathConstants.POSTFIX_PNG,1);
		}
		
		private function removedHandler(e:Event):void
		{
			clear();
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			if(info == 0)
			{
				if(!_bmp)
				{
					_bmp = new Bitmap();
					addChildAt(_bmp,0);
				}
				_bmp.bitmapData = bitmapData;
				_bmp.x = -int(_bmp.width/2);
				_bmp.y = -int(_bmp.height/2);
			}
			else if(info == 1)
			{
				if(!_bmp1)
				{
					_bmp1 = new Bitmap();
					addChildAt(_bmp1,0);
				}
				_bmp1.bitmapData = bitmapData;
				_bmp1.x = -int(_bmp1.width/2);
				_bmp1.y = _label.y + _label.height - _bmp1.height;
			}
		}
	}
}