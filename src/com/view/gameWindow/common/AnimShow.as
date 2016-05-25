package com.view.gameWindow.common
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	
	/**
	 * alpha only
	 * @author wqhk
	 * 2014-12-8
	 */
	public class AnimShow
	{
		private var _anim:TweenLite;
		private var _target:DisplayObject;
		
		public function AnimShow(target:DisplayObject)
		{
			target.visible = false;
			target.alpha = 0;
			_target = target;
		}
		
		public function show():void
		{
			clearAnim();
			_target.visible = true;
			_anim = TweenLite.to(_target,1,{alpha:1});
		}
		
		public function hide():void
		{
			clearAnim();
//			_anim = TweenLite.to(_target,1,{alpha:0});
			_target.visible = false;
			_target.alpha = 0;
		}
		
		private function clearAnim():void
		{
			if(_anim)
			{
				_anim.kill();
				_anim = null;
			}
		}
		
		public function destroy():void
		{
			clearAnim();
			_target = null;
		}
	}
}