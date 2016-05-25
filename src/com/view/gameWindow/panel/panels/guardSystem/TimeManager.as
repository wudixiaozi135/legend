package com.view.gameWindow.panel.panels.guardSystem
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.chatframe.ChatDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.prompt.Panel1BtnPromptData;
	
	import flash.utils.getTimer;
	import flash.utils.setInterval;

	public class TimeManager
	{
		private static var _instance:TimeManager;
		
		private var _adult:Boolean;
		private var _totalOnlineTime:int;
		private var _timer:int;
		private var _lastTime:int;
		
		public static function getInstance():TimeManager
		{
			if (!_instance)
			{
				_instance = new TimeManager(new PrivateClass());
			}
			return _instance;
		}
		
		public function TimeManager(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error();
			}
			_adult = true;
		}
		
		private function checkTime():void
		{
			var nowTime:int = getTimer();
			var diff:int = (nowTime - _lastTime) / 1000;
			_lastTime = nowTime;
			var oldTotalOnlineTime:int = _totalOnlineTime;
			_totalOnlineTime += diff;
			
			var times:Array = [3600, 7200, 10800, 12600, 14400, 16200];
			for each(var tp:int in times)
			{
				if(oldTotalOnlineTime < tp && _totalOnlineTime > tp)
				{
					var hint:String = "";
					switch(tp)
					{
						case 3600: hint = StringConst.ANTIWALLOW_0001; break;
						case 7200: hint = StringConst.ANTIWALLOW_0002; break;
						case 10800: hint = StringConst.ANTIWALLOW_0003; break;
						default: hint = StringConst.ANTIWALLOW_0004; break;
					}
					
					PanelMediator.instance.closePanel(PanelConst.TYPE_ANTIWALLOW_HINT);
					Panel1BtnPromptData.strName = StringConst.ANTIWALLOW_0006;
					Panel1BtnPromptData.strContent = hint;
					Panel1BtnPromptData.strBtn = StringConst.ANTIWALLOW_0007;
					PanelMediator.instance.switchPanel(PanelConst.TYPE_ANTIWALLOW_HINT);
//					ChatOutputManager.getInstance().addSystemNotice(hint);
					ChatDataManager.instance.sendSystemNotice(hint);
					break;
				}
			}
			
			if(oldTotalOnlineTime >= 17900)
			{
				var timeBig:int = oldTotalOnlineTime / 900;
				var timeBig2:int = _totalOnlineTime / 900;
				if(timeBig2 > timeBig)
				{
					PanelMediator.instance.closePanel(PanelConst.TYPE_ANTIWALLOW_HINT);
					Panel1BtnPromptData.strName = StringConst.ANTIWALLOW_0006;
					Panel1BtnPromptData.strContent = StringConst.ANTIWALLOW_0005;
					Panel1BtnPromptData.strBtn = StringConst.ANTIWALLOW_0007;
					PanelMediator.instance.switchPanel(PanelConst.TYPE_ANTIWALLOW_HINT);
//					ChatOutputManager.getInstance().addSystemNotice(InternationalConstants.getGameString(10881));
					ChatDataManager.instance.sendSystemNotice(StringConst.ANTIWALLOW_0005);
				}
			}
		}
		
		public function initOnlineTimeAndStart(onlineTime:int):void
		{
			_totalOnlineTime = onlineTime;
			_timer = setInterval(checkTime, 60 * 1000);
			_lastTime = getTimer();
			_adult = false;
		}
		
		public function isWallowed():Boolean
		{
			return !_adult && _totalOnlineTime >= 3600 * 3;
		}
	}
}

class PrivateClass{}