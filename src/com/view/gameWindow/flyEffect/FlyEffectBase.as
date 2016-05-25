package com.view.gameWindow.flyEffect
{
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class FlyEffectBase
	{
		protected var layer:Sprite;
		protected var target:DisplayObject;
		protected var duration:Number = 1;
		protected var fromLct:Point;
		protected var toLct:Point;
		
		public function FlyEffectBase(layer:Sprite)
		{
			this.layer = layer;
		}
		
		/**
		 * 进行飞行
		 */		
		public function fly():void
		{
			if(!target || !fromLct || !toLct)
			{
				return;
			}
			if(!target.parent)
			{
				layer.addChild(target);
			}
			TweenMax.fromTo(target,duration,{x:fromLct.x,y:fromLct.y},{x:toLct.x,y:toLct.y,onComplete:onComplete});
		}
		
		protected function onComplete():void
		{
			fromLct = null;
			toLct = null;
			if(target && target.parent)
			{
				target.parent.removeChild(target);
				if(target is Bitmap)
				{
					var bitmap:Bitmap = target as Bitmap;
					if(bitmap.bitmapData)
					{
						bitmap.bitmapData.dispose();
					}
				}
				target = null;
			}
		}
	}
}