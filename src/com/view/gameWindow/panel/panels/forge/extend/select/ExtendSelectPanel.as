package com.view.gameWindow.panel.panels.forge.extend.select
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.forge.McExtendSelect;
	
	import flash.display.MovieClip;
	
	/**
	 * 强化转移选择装备面板类
	 * @author Administrator
	 */	
	public class ExtendSelectPanel extends PanelBase
	{
		private var _mc:McExtendSelect;
		private var _extendSelectHandle:ExtendSelectHandle;
		
		public function ExtendSelectPanel()
		{
			super();
			BagDataManager.instance.attach(this);
		}
		
		override protected function initSkin():void
		{
			_mc = new McExtendSelect();
			_skin = _mc;
			addChild(_skin);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(_mc.mcTitle,function (mc:MovieClip):void
			{
				setTitleBar(mc);
			});
		}
		
		override protected function initData():void
		{
			_extendSelectHandle = new ExtendSelectHandle(this);
		}
		
		override public function destroy():void
		{
			BagDataManager.instance.detach(this);
			if(_extendSelectHandle)
			{
				_extendSelectHandle.destroy();
				_extendSelectHandle = null;
			}
			_mc = null;
			super.destroy();
		}
		
		override public function update(proc:int=0):void
		{
			_extendSelectHandle.refresh();
		}
	}
}