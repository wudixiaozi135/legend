package com.view.gameWindow.panel.panels.everydayOnlineReward
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.mainUi.subuis.McOnlineWelfare;
	import com.view.gameWindow.mainUi.subuis.actvEnter.ActvEnter;
	import com.view.gameWindow.mainUi.subuis.actvEnter.McActvEnter;
	import com.view.gameWindow.mainUi.subuis.onlineWelfare.OnlineWelfare;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.onlineTime.McOnlineTimeReward;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class PanelEverydayOnlineReward extends PanelBase
	{
		private var _viewHandler:EverydayOnlineRewardViewHandler;
		private var _mouseHandler:EverydayOnlineRewardMouseHandler;
		public function PanelEverydayOnlineReward()
		{
			super();
			EverydayOnlineRewardDatamanager.instance.attach(this);
		}
		
		override protected function initSkin():void
		{
			var skin:McOnlineTimeReward = new McOnlineTimeReward();
			setTitleBar(skin.mcTitleBar);
			skin.txtName.text = StringConst.EVERYDAY_ONLINE_REWARD_001;
			_skin = skin;
			addChild(skin);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(_skin.mcScrollBar,function (mc:MovieClip):void//滚动条资源加载完成后构造滚动条控制类
			{
				_viewHandler.addScroll(mc);
			});
		}
		
		override protected function initData():void
		{
			_viewHandler = new EverydayOnlineRewardViewHandler(this);
			_mouseHandler = new EverydayOnlineRewardMouseHandler(this);
		}
		
		
		override public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_ONLINE_WELFARE_INFO)
			{
				_viewHandler.refresh();
			}
			if(proc == GameServiceConstants.CM_GET_ONLINE_WELFARE)
			{
				_viewHandler.showSuccess();
			}
		}
		
		override public function setPostion():void
		{
			var mc:McOnlineWelfare = (MainUiMediator.getInstance().onlineWelfare as OnlineWelfare).skin as McOnlineWelfare;
			if (mc)
			{
				var popPoint:Point = mc.localToGlobal(new Point(mc.x + 15, mc.y + 15));
				isMount(true, popPoint.x, popPoint.y);
			} else
			{
				isMount(true);
			}
		}
		
		override public function getPanelRect():Rectangle
		{
			return new Rectangle(0,0,428,485);
		}
		
		override public function destroy():void
		{
			_viewHandler.destroy();
			_viewHandler = null;
			_mouseHandler.destroy();
			_mouseHandler = null;
			EverydayOnlineRewardDatamanager.instance.detach(this);
			super.destroy();
		}
	}
}