package com.view.gameWindow.mainUi.subuis.onlineReward
{
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
	import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class OnlineRewardMouseEvent
	{
		private var _ui:OnlineReward;
		
		public function OnlineRewardMouseEvent(ui:OnlineReward)
		{
			_ui = ui;
		}
		
		public function init():void
		{
			_ui._icon.addEventListener(MouseEvent.CLICK,clickHandle);
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			if(_ui._rewardTime <= 0)
			{
				if(_ui.onlineRewardCfg)
				{
					OnlineRewardDataManager.instance.sendData(_ui.onlineRewardCfg.id);	
					OnlineRewardDataManager.instance._callBack = function():void
					{
						_ui.resetOnlineRewardCfg();
						_ui.update();
						var startPoint:Point, endPoint:Point;
						var mc:McMainUIBottom = (MainUiMediator.getInstance().bottomBar as BottomBar).skin as McMainUIBottom;
						if (mc)
						{
							endPoint = mc.localToGlobal(new Point(mc.btnBag.x + (mc.btnBag.width) * .5 - 5, mc.btnBag.y + ((mc.btnBag.height) >> 1)));
						}
						if (_ui && _ui._icon)
						{
							startPoint = _ui.localToGlobal(new Point(_ui._icon.x + ((_ui._icon.width) >> 1), _ui._icon.y + 20));
							FlyEffectMediator.instance.doFlyTicket(startPoint, endPoint);
						}
					}
				}	
			}
		}
		
		public function destory():void
		{
			if(_ui._icon)
			{
				_ui._icon.removeEventListener(MouseEvent.CLICK,clickHandle);
				_ui = null;
			}
		}
	}
}