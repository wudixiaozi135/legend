package com.view.gameWindow.util.Progress
{
	import com.greensock.TweenLite;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.mainUi.subuis.progress.McActionProgress;
	import com.view.gameWindow.util.ServerTime;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class Progress extends Sprite
	{
		private var _startTime:Number;
		private var _totalTime:int;
		private var _mc:McActionProgress;

		private var rsr:RsrLoader;
		public var compleFunc:Function;//进度条满了之后要做的事情
		public var startFunc:Function;
		public var _isShow:Boolean;
		
		public function Progress()
		{
			initHandle();
		}
		
		override public function get width():Number
		{
			return _mc.width;
		}
		
		private function initHandle():void
		{
			rsr = new RsrLoader();	
			_mc = new McActionProgress();
			rsr.load(_mc,ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD,true);
		}
		
		public function show():void
		{
			if(!_totalTime)
			{
				return;
			}
			if(_mc.parent)
			{
				_mc.parent.removeChild(_mc);
			}
			removeEventListener(Event.ENTER_FRAME,onFrame);
			_startTime = ServerTime.timeMs;
			if(!_mc.parent)
			{
				addChild(_mc);
				_isShow = true;
				addEventListener(Event.ENTER_FRAME,onFrame);
			}
		}
		
		public function show2():void
		{
			if(!_totalTime)
			{
				return;
			}
			if(_mc.parent)
			{
				_mc.parent.removeChild(_mc);
			}
			removeEventListener(Event.ENTER_FRAME,onFrame);
			if(!_mc.parent)
			{
				addChild(_mc);
				_isShow = true;
				beginTween();
			}
		}
		
		private function beginTween():void
		{
			if(startFunc!=null)
			{
				startFunc();
			}
			if(_mc)
			{
				_mc.mcMask.scaleX=0;
				TweenLite.to(_mc.mcMask,_totalTime,{scaleX:1,onComplete:onFinishTween});
			}
		}		
		
		
		private function onFinishTween():void
		{
			if(compleFunc!=null)
			{
				compleFunc();
			}
			beginTween();
		}
		/**
		 *设置进度条信息 
		 * @param totalTime
		 * @param strTxt
		 * 
		 */		
		public function setProgressInfo(totalTime:int,strTxt:String):void
		{
			_totalTime = totalTime;
			_mc.txt.text = strTxt;
			
		}
		
		public function hide():void
		{
			TweenLite.killTweensOf(_mc.mcMask,true);
			_totalTime = 0;
			if(_mc.parent)
			{
				_mc.parent.removeChild(_mc);
			}
			_isShow = false;
			removeEventListener(Event.ENTER_FRAME,onFrame);
		}
		
		private function onFrame(event:Event):void
		{
			var nowTime:Number = ServerTime.timeMs;
			var scaleX:Number = (nowTime - _startTime)/_totalTime;
			_mc.mcMask.scaleX = scaleX < 0 ? 0 : (scaleX > 1 ? 1 : scaleX);
			if(scaleX >= 1)
			{
				if(compleFunc != null)
				{
					compleFunc();
				}
				removeEventListener(Event.ENTER_FRAME,onFrame);
			}
		}
		
		public  function destroy():void
		{
			startFunc=null;
			compleFunc=null;
			hide();
			if(rsr)
			{
				rsr.destroy();
				rsr = null;
			}
			_mc = null;
			_startTime = 0;
		}
	}
}