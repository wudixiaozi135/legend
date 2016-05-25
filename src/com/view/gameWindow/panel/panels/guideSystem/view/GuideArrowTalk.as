package com.view.gameWindow.panel.panels.guideSystem.view
{
	import com.model.business.fileService.UrlSwfLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlSwfLoaderReceiver;
	import com.model.consts.FontFamily;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * @author wqhk
	 * 2015-2-10
	 */
	public class GuideArrowTalk extends GuideArrow implements IUrlSwfLoaderReceiver
	{
		private var loader:UrlSwfLoader;
		private var view:MovieClip;
		private var _label:String;
		private var _txtWidth:int;
		
		public var closeCallback:Function;
		public var linkCallback:Function;
		
		/**
		 * @param width 因为需要换行 所以需要指定文本宽度
		 * @param closeHandler func(arrow:GuideArrowTalk):void;
		 * @param linkHandler  func(arrow:GuideArrowTalk,eventName:String):void 
		 */
		public static function show(htmlText:String,x:int,y:int,width:int,ctner:DisplayObjectContainer,closeHandler:Function=null,linkHandler:Function=null):GuideArrowTalk
		{
			var view:GuideArrowTalk = new GuideArrowTalk(true,width,0);
			view.label = htmlText;
			view.x = int(x);
			view.y = int(y);
			view.closeCallback = closeHandler;
			view.linkCallback = linkHandler;
			ctner.addChild(view);
			
			return view;
		}
		
//		public static const TIME:int = 45000;
		private var timeId:int = 0;
		private var _isEvent:Boolean;
		public function GuideArrowTalk(isEvent:Boolean = true,txtWidth:int = 100,desappearTime:int = 45000)
		{
			super();
			_txtWidth = txtWidth;
			_isEvent = isEvent;
			if(desappearTime > 0)
			{
				timeId = setTimeout(destroy,desappearTime);
			}
		}
		
		override protected function init():void
		{
			loader = new UrlSwfLoader(this);
			loader.loadSwf(ResourcePathConstants.IMAGE_GUIDE_FOLDER_LOAD+"guideTalkTip"+ResourcePathConstants.POSTFIX_SWF);
		}
		
		override public function set label(value:String):void
		{
			if(_label != value)
			{
				_label = value;
				updateView();
			}
		}
		
		public function swfReceive(url:String, swf:Sprite, info:Object):void
		{
			view = swf.getChildAt(0) as MovieClip;
			
			if(view)
			{
				addChildAt(view,0);
			}
			
			updateView();
		}
		
		protected function updateView():void
		{
			if(!view || !_label)
			{
				super.visible = false;
				return;
			}
			
			super.visible = true;
			txt.width = _txtWidth;
			txt.multiline = true;
			txt.wordWrap = true;
			txt.htmlText = _label;
			
			if(_isEvent)
			{
				view.closeBtn.addEventListener(MouseEvent.CLICK,closeHandler,false,0,true);
				view.txt.addEventListener(TextEvent.LINK,linkHandler,false,0,true);
			}
			else
			{
				view.closeBtn.visible = false;
			}
			setPosition();
		}
		
		private function closeHandler(e:Event):void
		{
			if(closeCallback != null)
			{
				closeCallback(this);
			}
			
			dispatchEvent(new Event("close"));
			
			destroy();
		}
		
		private function linkHandler(e:TextEvent):void
		{
			if(linkCallback != null)
			{
				linkCallback(this,e.text);
			}
			
			dispatchEvent(e);
		}
		
		override public function destroy():void
		{
			this.parent&&this.parent.removeChild(this);
			if(view)
			{
				view.closeBtn.removeEventListener(MouseEvent.CLICK,closeHandler);
				view.txt.removeEventListener(TextEvent.LINK,linkHandler);
				
				if(view.parent)
				{
					view.parent.removeChild(view);
				}
				
				view = null;
			}
			
			if(timeId)
			{
				clearTimeout(timeId);
				timeId = 0;
			}
			
			closeCallback = null;
			linkCallback = null;
			
			super.destroy();
		}
		
		public function get txt():TextField
		{
			if(!view)
			{
				return null;
			}
			
			return view.txt;
		}
		
		private function setPosition():void
		{
			txt.height = txt.textHeight + 5;
			view.bg.width = txt.width + 20;
			view.bg.height = txt.height + 35;
			view.closeBtn.x = view.width - 15;
			view.x = -18;
			view.y = -view.height;
			
			
		}
		
		public function swfError(url:String, info:Object):void
		{
		}
		
		public function swfProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
	}
}