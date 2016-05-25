package com.view.gameWindow.mainUi.subuis.progress
{
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.mainUi.MainUi;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.util.ServerTime;
	
	import flash.events.Event;

	public class ActionProgress extends MainUi implements IObserver
	{
		private var _startTime:Number;
		private var _totalTime:int;
		
		public function ActionProgress()
		{
			mouseChildren = false;
			mouseEnabled = false;
			EntityLayerManager.getInstance().attach(this);
		}
		
		override public function initView():void
		{
			_skin = new McActionProgress();
			super.initView();
		}
		
		public function update(proc:int = 0):void
		{
			if(proc == ActionProgressData.START)
			{
				//添加读条
				show();
//				trace("ActionProgress.update(proc) 添加");
			}
			else if(proc == ActionProgressData.OVER)
			{
				//移除读条
				hide();
//				trace("ActionProgress.update(proc) 移除");
			}
		}
		
		private function show():void
		{
			var totalTime:int = ActionProgressData.totalTime;
			var strTxt:String = ActionProgressData.strTxt;
			/*trace("ActionProgress.show totalTime"+totalTime);*/
			if(!totalTime)
			{
				return;
			}
			_totalTime = totalTime;
			_startTime = ServerTime.timeMs;
			(_skin as McActionProgress).txt.text = strTxt;
			if(!_skin.parent)
			{
				addChild(_skin);
				addEventListener(Event.ENTER_FRAME,onFrame);
			}
		}
		
		private function hide():void
		{
			_totalTime = 0;
			if(_skin.parent)
			{
				_skin.parent.removeChild(_skin);
			}
			removeEventListener(Event.ENTER_FRAME,onFrame);
		}
		
		public function onFrame(event:Event):void
		{
			var nowTime:Number = ServerTime.timeMs;
			var scaleX:Number = (nowTime - _startTime)/_totalTime;
			_skin.mcMask.scaleX = scaleX < 0 ? 0 : (scaleX > 1 ? 1 : scaleX);
			if(scaleX >= 1)
			{
				hide();
				/*trace("ActionProgress.update 内部移除");*/
			}
		}
		
		override public function get width():Number
		{
			return super.width || _skin.width;
		}
	}
}