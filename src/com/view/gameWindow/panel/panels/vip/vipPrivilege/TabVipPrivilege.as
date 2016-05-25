package com.view.gameWindow.panel.panels.vip.vipPrivilege
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	
	/**
	 * vip特权选项卡类
	 * @author Administrator
	 */	
	public class TabVipPrivilege extends TabBase
	{
		private var _viewHandle:TabVipPrivilegeViewHandle;
		private var _mouseHandle:TabVipPrivilegeMouseHandle;
		
		public function TabVipPrivilege()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var mc:McVipPrivilege = new McVipPrivilege();
			_skin = mc;
			addChild(_skin);
			_viewHandle = new TabVipPrivilegeViewHandle(this);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var i:int,l:int = VipDataManager.TOTAL_PRIVILEGES,j:int,jl:int = VipDataManager.MAX_LV;
			for(i=0;i<l;i++)
			{
				for(j=1;j<=jl;j++)
				{
					rsrLoader.addCallBack(_viewHandle.items[i]["mcVip"+j].mc,function (mc:MovieClip):void
					{
						_viewHandle.refresh();
					});
				}
			}
			var mc:McVipPrivilege = _skin as McVipPrivilege;
			rsrLoader.addCallBack(mc.mcScrollBar,function (mc:MovieClip):void
			{
				_viewHandle.addScrollBar(mc);
			});
		}
		
		override protected function initData():void
		{
			_mouseHandle = new TabVipPrivilegeMouseHandle(this);
		}
		
		override public function destroy():void
		{
			if(_mouseHandle)
			{
				_mouseHandle.destroy();
				_mouseHandle = null;
			}
			if(_viewHandle)
			{
				_viewHandle.destroy();
				_viewHandle = null;
			}
			super.destroy();
		}
	}
}