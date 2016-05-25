package com.view.gameWindow.mainUi.subuis.activityNow
{
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.consts.ConstActivityNow;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.mainUi.MainUi;
	import com.view.gameWindow.mainUi.subclass.McActivityNow;
	
	public class ActivityNow extends MainUi implements IObserver
	{
		internal var mouseHandle:ActivityNowMouseHandle;
		internal var viewHandle:ActivityNowViewHandle;
		private var has_init:Boolean = false;
		private var cfgDt:ActivityCfgData;
		public function ActivityNow()
		{
		}
		
		override public function initView():void
		{
			if(!_skin){
				_skin = new McActivityNow();
				addChild(_skin);
			}
			if(cfgDt)
			{
				_skin.activityIcon.resUrl = ConstActivityNow.getResUrlSmall(cfgDt.id);
			}else{
				_skin.activityIcon.resUrl = "";
			}
			super.initView();
		
			if(!has_init){
				initData();
				has_init = true;
			}
		}
		
		private function initData():void
		{
			// TODO Auto Generated method stub
			
				mouseHandle = new ActivityNowMouseHandle(this);
				viewHandle = new ActivityNowViewHandle(this);
				mouseHandle.initialize();
				viewHandle.initialize(reLoad);
			
		}
		
		private function reLoad(_cfgDt:ActivityCfgData):void
		{
			cfgDt = _cfgDt;
			initView();
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			
		}
		
		public function update(proc:int = 0):void
		{
			
		}
		
	}
}