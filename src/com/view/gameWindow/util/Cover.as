package com.view.gameWindow.util
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 遮罩类
	 * @author Administrator
	 */	
	public class Cover extends Sprite
	{
		public function Cover(color:uint, alpha:Number=1.0)
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded2Stage);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved4Stage);
			graphics.beginFill(color,alpha);
		}
		
		protected function onAdded2Stage(event:Event):void
		{
			x = -parent.x;
			y = -parent.y;
			stage.addEventListener(Event.RESIZE, resizeHandle);
			graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			graphics.endFill();
		}
		
		protected function resizeHandle(event:Event):void
		{
			x = -parent.x;
			y = -parent.y;
			width = stage.stageWidth;
			height = stage.stageHeight;
		}		
		
		protected function onRemoved4Stage(event:Event):void
		{
			stage.removeEventListener(Event.RESIZE, resizeHandle);
			removeEventListener(Event.ADDED_TO_STAGE,onAdded2Stage);
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved4Stage);
		}
	}
}