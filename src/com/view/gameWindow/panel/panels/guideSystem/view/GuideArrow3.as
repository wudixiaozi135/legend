package com.view.gameWindow.panel.panels.guideSystem.view
{
	import com.greensock.TweenLite;
	import com.model.business.fileService.UrlSwfLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlSwfLoaderReceiver;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/**
	 * @author wqhk
	 * 2014-12-16
	 */
	public class GuideArrow3 extends GuideArrow implements IUrlSwfLoaderReceiver
	{
		private static const ANIM_TIME:Number = 1;
		private static const BORDER:int = 9;
		private static const POINT_RIGHT:int = 20;
		private var loader:UrlSwfLoader;
		private var textMask:Shape;
		private var textCtner:Sprite;
		private var text:TextField;
		private var view:MovieClip;
		private var _label:String;
		private var widthAnim:TweenLite;
		
		public function GuideArrow3()
		{
			super();
		 	mouseEnabled = false;
			mouseChildren = false;
		}
		
		override public function set visible(value:Boolean):void
		{
			if(visible != value)
			{
				if(value && widthAnim)
				{
					widthAnim.restart();
				}
				
				super.visible = value;
			}
		}
		
		override public function set rotation(value:Number):void
		{
			
		}
		
		override protected function init():void
		{
			loader = new UrlSwfLoader(this);
			loader.loadSwf(ResourcePathConstants.IMAGE_GUIDE_FOLDER_LOAD+"guideTip"+ResourcePathConstants.POSTFIX_SWF);
			
			
			textCtner = new Sprite();
			text = new TextField();
			textCtner.addChild(text);
			
			textMask = new Shape();
			textMask.graphics.beginFill(0,0);
			textMask.graphics.drawRect(0,0,1,1);
			textMask.graphics.endFill();
			textCtner.addChild(textMask);
			textCtner.mask = textMask;
			addChild(textCtner);
		}
		
		override public function set label(value:String):void
		{
			if(_label != value)
			{
				_label = value;
				updateView();
			}
		}
		
		public function swfError(url:String, info:Object):void
		{
			
		}
		
		public function swfProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		private function setPosition():void
		{
			text.width = text.textWidth + 10;
			textMask.height = text.height = text.textHeight + 5;
			
			textCtner.y = view.y + 34;
			view.height = textCtner.y + text.height + BORDER;
			changeViewWidth(view,text.width+BORDER*2);
		}
		
		private function changeViewWidth(view:*,newWidth:Number):void
		{
			if(widthAnim)
			{
				widthAnim.kill();
				widthAnim = null;
			}
			
			viewWidthChange();
			
			if(view.width != newWidth)
			{
				widthAnim = TweenLite.to(view,ANIM_TIME,{width:newWidth,onUpdate:viewWidthChange});
			}
		}
		
		private function viewWidthChange():void
		{
			view.x = -view.width + POINT_RIGHT;
			
			textCtner.x = view.x + BORDER;
			
			textMask.width = view.width - 2*BORDER;
		}
		
		public function swfReceive(url:String, swf:Sprite, info:Object):void
		{
			view = swf.getChildAt(0) as MovieClip;
			
			if(view)
			{
				addChildAt(view,0);
				updateView();
			}
		}
		
		override public function destroy():void
		{
			if(loader)
			{
				loader.destroy();
				loader = null;
			}
			
			if(widthAnim)
			{
				widthAnim.kill();
				widthAnim = null;
			}
			
			if(view)
			{
				if(view.parent)
				{
					view.parent.removeChild(view);
				}
				view = null;
			}
			
			if(textCtner)
			{
				if(textCtner.parent)
				{
					textCtner.parent.removeChild(textCtner);
				}
				textCtner = null;
			}
			
			if(textMask)
			{
				textMask = null
			}
			
			text = null;
			
			super.destroy();
		}
		
		protected function updateView():void
		{
			if(!view || !_label)
			{
				super.visible = false;
				return;
			}
			
			super.visible = true;
			
			text.htmlText = _label;
			
			setPosition();
		}
		
	}
}