package com.view.gameWindow.tips.toolTip
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.frame.FrameManager;
	import com.model.frame.IFrame;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.util.Container;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * loadPic //icon
	 * addSplitLine //分割线
	 * addProperty //文本
	 * setDes //描述类文字
	 * 
	 * 文本tip
	 * @author jhj
	 */
	public class BaseTip extends Container implements IUrlBitmapDataLoaderReceiver,IFrame
	{
		private var _rsrLoader:RsrLoader;
		protected const _filter:GlowFilter = new GlowFilter(0,1,2,2,10);
		protected var _data:Object;
		protected var _skin:MovieClip;	
		protected var _iconBmp:Bitmap;	
		protected var _target:DisplayObject;
		private var _urlBitmapDataLoader:UrlBitmapDataLoader;
		protected var maxWidth:int = 0;
		protected var maxHeight:Number = 0;
		public static const GLOW_FILTER:GlowFilter = new GlowFilter(0xff9900,1,6,6,3);
		
		public function BaseTip()
		{
			super();
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		public function get target():DisplayObject
		{
			return _target;
		}

		public function set target(value:DisplayObject):void
		{
			_target = value;
		}

		public function urlBitmapDataError(url:String, info:Object):void
		{
			trace("类EquipToolTip方法urlBitmapDataError,加载图片出错："+url);
			destroyLoader();
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			destroyIcon();
			destroyLoader();
	
			_iconBmp = new Bitmap(bitmapData,"auto",true);
			_iconBmp.width = 60;
			_iconBmp.height = 60;
			_iconBmp.x = 22;
			_iconBmp.y = 22;
			
			if(_skin)
			 _skin.addChild(_iconBmp);
		}
		
		public function setData(obj:Object):void
		{
		}
		
		public function setCount(count:int):void
		{
		}
		
		public function getData():Object
		{
			return _data;
		}
		
		public function updateTime(time:int):void
		{
			
		}
		
		public function initView(mc:MovieClip):void
		{
			_rsrLoader = new RsrLoader();
			addCallBack(mc,_rsrLoader);
			_rsrLoader.load(mc,ResourcePathConstants.IMAGE_TOOLTIP_FOLDER_LOAD);
		}
		
		public function dispose():void
		{
			_data = null;
			_target = null;
			destroyLoader(); 
			destroyIcon();
			removeAllChild();
			FrameManager.instance.removeObj(this);
			if(_rsrLoader)
			{
				_rsrLoader.destroy();
				_rsrLoader = null;
			}
		}
		
		protected function loadPic(url:String):void
		{
			_urlBitmapDataLoader = new UrlBitmapDataLoader(this);
			_urlBitmapDataLoader.loadBitmap(url);
		}
		
		/**
		 * 资源加载成功回调
		 * @param rsrLoader
		 */		
		protected function addCallBack(mc:MovieClip, rsrLoader:RsrLoader):void
		{
		    
		}
		
		override public function get width():Number
		{
			if(_skin)
			{
				return _skin.skin.width;
			}
			else
			{
				return super.width;
			}
		}
		
		override public function get height():Number
		{
			if(_skin)
			{
				return _skin.skin.height;
			}
			else
			{
				return super.height;
			}
		}
		
		override public function set width(value:Number):void
		{
			var valueRound:Number = Math.round(value);
			if(_skin)
			{
				_skin.skin.width = Math.round(value);
			}
			else
			{
				super.width = Math.round(value);
			}
		}
		
		override public function set height(value:Number):void
		{
			var valueRound:Number = Math.round(value);
			if(_skin)
			{
				_skin.skin.height = valueRound;
			}
			else
			{
				super.height = valueRound;
			}
		}
		
		protected function destroyIcon():void
		{
			if(_iconBmp&&_iconBmp.bitmapData)
			{
				_iconBmp.bitmapData.dispose();
				_iconBmp.bitmapData = null;
				
				if(_skin.contains(_iconBmp))
				   _skin.removeChild(_iconBmp);
			}
		}
		
		protected function destroyLoader():void
		{
			if(_urlBitmapDataLoader)
				_urlBitmapDataLoader.destroy();
			
			_urlBitmapDataLoader = null;
		}
		
		protected function addProperty(htmlStr:String, x:int, y:int, /*,isSetLeading:Boolean = false*/defaultFormat:TextFormat = null):TextField
		{
			var text:TextField = new TextField();
			addChild(text);
			text.width = 250;
			text.autoSize = TextFieldAutoSize.LEFT;
			if(defaultFormat)
				text.defaultTextFormat = defaultFormat;
			text.htmlText = htmlStr;
			text.wordWrap = true;
			text.multiline =true;
			text.x = x;
			text.y = y;
			text.filters = [_filter];
			return text;
		}
		
		protected function addSplitLine(x:int, y:int):DelimiterLine
		{
			var splitLine:DelimiterLine = new DelimiterLine();
			addChild(splitLine);
			splitLine.x = x;
			splitLine.y = y;
			initView(splitLine);
			return splitLine;
		}
		
		protected function addDes(desc:String):void
		{
			if(desc == "")
				return;
			
			var htmlStrArr:Array = CfgDataParse.pareseDes(desc,0xffffff);
			
			if(htmlStrArr.length>0)
				maxHeight += 11;
			
			for (var i:int = 0;i<htmlStrArr.length;i++)
			{
				var desText:TextField = addProperty(htmlStrArr[i],18,maxHeight);
				if(desText.numLines == 1 && htmlStrArr.length == 1)
					maxHeight = desText.y+desText.textHeight-2;
				else if(i<htmlStrArr.length-1)
					maxHeight = desText.y+desText.textHeight+4;
				else
					maxHeight = desText.y+desText.textHeight;
			}
		}
	}
}