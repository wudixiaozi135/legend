package com.view.gameWindow.panel.panels.activitys.nightFight
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * 夜战比奇关系变更类
	 * @author Administrator
	 */	
	public class PanelNightFightChange extends PanelBase
	{
		private var _timeLast:int;
		
		public function PanelNightFightChange()
		{
			super();
			canEscExit = false;
		}
		
		override protected function initSkin():void
		{
			var skin:McNightFightChange = new McNightFightChange();
			skin.mouseEnabled = false;
			skin.mouseChildren = false;
			_skin = skin;
			addChild(skin);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McNightFightChange = _skin as McNightFightChange;
			rsrLoader.addCallBack(skin.mcNum,function(mc:MovieClip):void
			{
				addEventListener(Event.ENTER_FRAME,onFrame);
				_timeLast = getTimer();
			});
		}
		
		protected function onFrame(event:Event):void
		{
			var skin:McNightFightChange = _skin as McNightFightChange;
			var timeNow:int = getTimer();
			if(timeNow - _timeLast >= 1000)
			{
				_timeLast = timeNow;
				if(skin.mcNum.currentFrame == skin.mcNum.totalFrames)
				{
					PanelMediator.instance.closePanel(PanelConst.TYPE_NIGHT_CHANGE);
					return;
				}
				skin.mcNum.nextFrame();
			}
		}
		
		override public function destroy():void
		{
			removeEventListener(Event.ENTER_FRAME,onFrame);
			super.destroy();
		}
	}
}