package com.view.gameWindow.panel.panels.unlock
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.view.gameWindow.panel.panels.menus.MenuMediator;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	
	/**
	 * @author wqhk
	 * 2014-10-30
	 */
	public class UnlockAnim extends Sprite
	{
		private var tween:TweenMax;
		private var view:Sprite;
		public function UnlockAnim()
		{
			super();
			
			view = new Sprite();
			view.graphics.beginFill(0xffffff,1);
			view.graphics.drawCircle(0,0,12);
			view.graphics.endFill();
			
			view.filters = [new GlowFilter(0xffffff,0.3,15,15,8)];
			
			addChild(view);
			
			tween = TweenMax.to(view,0.2,{yoyo:true,repeat:-1,width:width/2,height:height/2});
		}
		
		public function destroy():void
		{
			if(parent)
			{
				parent.removeChild(this);
			}
			
			tween.kill();
			tween = null;
		}
		
		public function move(x:int,y:int):void
		{
			TweenLite.to(this,1.5,{x:x,y:y,onComplete:onComplete});
		}
		
		private function onComplete():void
		{
			destroy();
		}
		
		public static function moveToDis(dis:DisplayObject):void
		{
			if(dis && dis.parent)
			{
				var pos:Point = dis.parent.localToGlobal(new Point(int(dis.x+dis.width/2),int(dis.y+dis.height/2)));
				moveTo(pos.x,pos.y);
			}
		}
		
		public static function moveTo(x:int,y:int):void
		{
			var target:UnlockAnim = new UnlockAnim();
			
			var ctner:Sprite = MenuMediator.instance.layer; //相对来说 关联少些 
			
			target.x = MenuMediator.instance.mouseX;
			target.y = MenuMediator.instance.mouseY;
			
			ctner.addChild(target);
			
			target.move(x,y);
		}
	}
}