package com.view.gameWindow.panel.panels.guideSystem.view
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Sine;
	import com.model.business.fileService.UrlSwfLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlSwfLoaderReceiver;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	
	/**
	 * @author wqhk
	 * 2014-12-15
	 */
	public class GuideArrow2 extends GuideArrow implements IUrlSwfLoaderReceiver
	{
		private static const DIS:int = 15;
		private var loader:UrlSwfLoader;
		private var moveAnim:TweenMax;
		private var view:MovieClip;
		private var viewCtner:Sprite;
		private var roId:int = -1;
		private var needAnimUpdate:Boolean = false;
		private var needLabelUpdate:Boolean = false;
		protected var _label:String;
		private var showAnim:TweenLite;
		private var viewMask:Shape;
		private var _visible:Boolean = true;
		public function GuideArrow2()
		{
			super();
//			_visible = false;
//			super.visible = false;
		}
		
		override public function set label(value:String):void
		{
			_label = value;
			needLabelUpdate = true;
			updateView();
		}
		
		override protected function init():void
		{
			if(loader)
			{
				loader.destroy();
				loader = null;
			}
			loader = new UrlSwfLoader(this);
			loader.loadSwf(ResourcePathConstants.IMAGE_GUIDE_FOLDER_LOAD+"guideArrow"+ResourcePathConstants.POSTFIX_SWF);
		}
		
		override public function set rotation(value:Number):void
		{
			var r:int = value%360;
			
			if(r == 90)
			{
				roId = 1;//上
			}
			else if(r == 270)
			{
				roId = 2;//下
			}
			else if(r == 0)
			{
				roId = 3;//左
			}
			else if(r == 180)
			{
				roId = 4;//右
			}
			else
			{
				roId == -1;
			}
			
			needAnimUpdate = true;
			updateView();
		}
		
		protected function updateView():void
		{
			if(needAnimUpdate)
			{
				checkRotationAnim();
				needAnimUpdate = false;
			}
			
			if(needLabelUpdate)
			{
				if(roId != -1 && view)
				{
					view.label.htmlText = _label;
					needLabelUpdate = false;
				}
			}
		}
		
		override public function get rotation():Number
		{
			return 0;
		}
		
		override public function destroy():void
		{
			if(loader)
			{
				loader.destroy();
				loader = null;
			}
			
			if(moveAnim)
			{
				moveAnim.kill();
				moveAnim = null;
			}
			
			if(showAnim)
			{
				showAnim.kill();
				showAnim = null;
			}
			
			if(view)
			{
				if(view.parent)
				{
					view.parent.removeChild(view);
				}
				view = null;
			}
			
			if(viewMask)
			{
				viewMask = null;
			}
			
			super.destroy();
		}
		
		public function swfError(url:String, info:Object):void
		{
			
		}
		
		public function swfProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		public function swfReceive(url:String, swf:Sprite, info:Object):void
		{
			view = swf.getChildAt(0) as MovieClip;
			
			if(view)
			{
				if(!viewCtner)
				{
					viewCtner = new Sprite();
				}
				
				viewCtner.addChild(view);
				addChild(viewCtner);
				
			}
			
			needAnimUpdate = true;
			updateView();
		}
		
		private function addViewMask():void
		{
			var rect:Rectangle = view.getBounds(viewCtner);
			
			if(!viewMask)
			{
				viewMask = new Shape();
				viewMask.graphics.beginFill(0x0,0);
				viewMask.graphics.drawRect(0,0,rect.width,rect.height);
				viewMask.graphics.endFill();
			}
			
			viewMask.x = rect.left;
			viewMask.y = rect.top;
			
			viewCtner.addChild(viewMask);
			view.mask = viewMask;
			
			if(showAnim)
			{
				showAnim.kill();
				showAnim = null;
			}
			
			if(roId == 1)
			{
				viewMask.y = rect.y + rect.height; 
				showAnim = TweenLite.to(viewMask,0.8,{y:rect.y});
			}
			else if(roId == 2)
			{
				viewMask.y = rect.y - rect.height; 
				showAnim = TweenLite.to(viewMask,0.8,{y:rect.y});
			}
			else if(roId == 3)
			{
				viewMask.x = rect.x + rect.width; 
				showAnim = TweenLite.to(viewMask,0.8,{x:rect.x});
			}
			else if(roId == 4)
			{
				viewMask.x = rect.x - rect.width; 
				showAnim = TweenLite.to(viewMask,0.8,{x:rect.x});
			}
		}
		
//		override public function set x(value:Number):void
//		{
//			super.x = int(value*10)/10;
//		}
//		
//		override public function set y(value:Number):void
//		{
//			super.y = int(value*10)/10;
//		}
		
		override public function get visible():Boolean
		{
			return _visible;
		}
		
		override public function set visible(value:Boolean):void
		{
			_visible = value;
			
			if(super.visible == value)
			{
				return;
			}
			
//			if(value && showAnim)
//			{
//				showAnim.restart();
//			}
			
			if(!value)
			{
				if(showAnim)
				{
					showAnim.pause();
				}
				
				if(moveAnim)
				{
					moveAnim.pause();
				}
			}
			else
			{
				if(showAnim)
				{
					showAnim.restart();
				}
				
				if(moveAnim)
				{
					moveAnim.resume();
				}
			}
			
			super.visible = value;
		}
		
		private function checkRotationAnim():void
		{
			if(roId == -1)
			{
				if(moveAnim)
				{
					moveAnim.kill();
					moveAnim = null;
				}
				
				visible = false;
				return;
			}
			
			if(!view)
			{
				return;
			}
			
			viewCtner.x = 0;
			viewCtner.y = 0;
			
			if(roId == 1)
			{
				moveAnim = TweenMax.to(viewCtner,0.8,{y:-DIS,ease:Sine.easeInOut/*Sine.easeInOut*/,repeat:-1,yoyo:true});
			}
			else if(roId == 2)
			{
				moveAnim = TweenMax.to(viewCtner,0.8,{y:DIS,ease:Sine.easeInOut,repeat:-1,yoyo:true});
			}
			else if(roId == 3)
			{
				moveAnim = TweenMax.to(viewCtner,0.8,{x:-DIS,ease:Sine.easeInOut,repeat:-1,yoyo:true});
			}
			else if(roId == 4)
			{
				moveAnim = TweenMax.to(viewCtner,0.8,{x:DIS,ease:Sine.easeInOut,repeat:-1,yoyo:true});
			}
			
			view.gotoAndStop(roId);
			
			addViewMask();
			
			if(_visible != super.visible)
			{
				visible = _visible;
			}
		}
	}
}