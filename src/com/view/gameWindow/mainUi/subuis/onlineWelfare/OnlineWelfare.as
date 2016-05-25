package com.view.gameWindow.mainUi.subuis.onlineWelfare
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.OnlineWelfareCfgData;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.mainUi.MainUi;
	import com.view.gameWindow.mainUi.subuis.McOnlineWelfare;
	import com.view.gameWindow.panel.panels.everydayOnlineReward.EverydayOnlineRewardDatamanager;
	import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
	import com.view.gameWindow.util.ServerTime;
	import com.view.gameWindow.util.TimeUtils;
	import com.view.gameWindow.util.TimerManager;
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	public class OnlineWelfare extends MainUi implements IObserver
	{
		private var time:int;
		private var _vec:Vector.<OnlineWelfareCfgData>;
		private var timeArr:Array = [];
		public function OnlineWelfare()
		{
			super();
			WelfareDataMannager.instance.attach(this);
			EverydayOnlineRewardDatamanager.instance.attach(this);
		}
		
		override public function initView():void
		{
			_skin = new McOnlineWelfare();
			addChild(_skin);	
			super.initView();
			_skin.addEventListener(MouseEvent.CLICK,onclick);
			this.buttonMode = true;
			_vec = ConfigDataManager.instance.onlineWelfareVec();
			_vec.sort(sortId);
		}
		
		private function sortId(a:OnlineWelfareCfgData,b:OnlineWelfareCfgData):int
		{
			if(a.id < b.id)
			{
				return -1;
			}
			else
			{
				return 1;
			}
		}
		
		private var inited:Boolean = false;
		private function initCheck():void
		{
			// TODO Auto Generated method stub
			if(inited)return;
			var serverDate:Date = ServerTime.date;
			var totalSeconds:int = serverDate.hours * 3600 + serverDate.minutes * 60 + serverDate.seconds;
			for(var i:int = 0;i<_vec.length;i++)
			{
				timeArr[i] = totalSeconds+_vec[i].seconds - EverydayOnlineRewardDatamanager.instance.onlineTime;
			}
			time = getNextTime(totalSeconds);;
			TimerManager.getInstance().add(1000,checkTime);
			inited = true;
		}
		
		private function checkTime():void
		{
			// TODO Auto Generated method stub
			var serverDate:Date = ServerTime.date;
			var totalSeconds:int = serverDate.hours * 3600 + serverDate.minutes * 60 + serverDate.seconds;
			var num:int = time -totalSeconds;
			var skin:McOnlineWelfare = _skin as McOnlineWelfare;
			var cfg:OnlineWelfareCfgData = _vec[_vec.length-1];
			if(num<0)
			{
				if(!getNextTime(totalSeconds))
				{
					skin.countdown.visible = false;
					skin.txtTime.text = "";
					skin.txtTime.visible = false;
					TimerManager.getInstance().remove(checkTime);
				}
				else
					time = getNextTime(totalSeconds);
			}else
			{
				skin.countdown.visible = true;
				skin.txtTime.visible = true;
				skin.txtTime.text =  TimeUtils.formatClock1(num);
			}
		}
		
//		private function getCheckTime(totalSeconds:int):int
//		{
//			// TODO Auto Generated method stub
//			totalSeconds +getNextCfg().seconds -
//			return 0;
//		}
		
		private function getNextTime(sec:int):int
		{
			// TODO Auto Generated method stub
			var n:int = int.MAX_VALUE;
			var t:int;
			for(var i:int = 0;i<timeArr.length;i++)
			{
				if(timeArr[i] - sec>0)
				{
					if(n>(timeArr[i] - sec))
					{
						n = timeArr[i] - sec;
						t = timeArr[i];
					}
				}
			}
			return t;
		}
		
		private function checkShow():void
		{
			// TODO Auto Generated method stub
			var day:int = WelfareDataMannager.instance.openDay+1;
			if(day>1)
				visible = true;
			else
				visible = false;
		}
		
		protected function onclick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			EverydayOnlineRewardDatamanager.instance.dealSwitchPanel();
		}
		
		public function update(proc:int = 0):void
		{
			if(proc== GameServiceConstants.SM_QUERY_OFF_LINE)
			{
				checkShow();
			}
			
			if(proc == GameServiceConstants.SM_ONLINE_WELFARE_INFO)
			{
				initCheck();
			}
		}
	}
}