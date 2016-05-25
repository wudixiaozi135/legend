package com.view.gameWindow.panel.panels.forge.extend
{
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.forge.McExtend;
	import com.view.gameWindow.panel.panels.forge.extend.select.ExtendSelectData;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	
	/**
	 * 强化转移面板类
	 * @author Administrator
	 */	
	public class TabExtend extends TabBase
	{
		internal var extendClickHandle:ExtendClickHandle;
		internal var extendCellHandle:ExtendCellHandle;
		internal var extendViewHandle:ExtendViewHandle;
		
		public function TabExtend()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			_skin = new McExtend();
			addChild(skin);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McExtend = _skin as McExtend;
			rsrLoader.addCallBack(skin.btnMoveSP,function (mc:MovieClip):void
			{
				mc.selected = true;
			});
		}
		
		override protected function initData():void
		{
			extendViewHandle = new ExtendViewHandle(this);
			extendClickHandle = new ExtendClickHandle(this);
			extendCellHandle = new ExtendCellHandle(this);
		}
		
		public function get cell0():ExtendCell
		{
			return extendCellHandle.cell0;
		}
		
		public function get cell1():ExtendCell
		{
			return extendCellHandle.cell1;
		}
		
		override public function update(proc:int=0):void
		{
			extendViewHandle.refresh();
			extendCellHandle.refreshData();
		}
		
		override public function destroy():void
		{
			ExtendSelectData.filter = 2;
			ExtendSelectData.cellData1 = null;
			ExtendSelectData.cellData2 = null;
			if(extendCellHandle)
			{
				extendCellHandle.destroy();
				extendCellHandle = null;
			}
			if(extendClickHandle)
			{
				extendClickHandle.destroy();
				extendClickHandle = null;
			}
			super.destroy();
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			MemEquipDataManager.instance.attach(this);
			BagDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			MemEquipDataManager.instance.detach(this);
			BagDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}