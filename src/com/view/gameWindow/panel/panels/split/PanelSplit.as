package com.view.gameWindow.panel.panels.split
{
	import com.view.gameWindow.panel.panelbase.PanelBase;
	
	/**
	 * 包裹单元格拆分面板类
	 * @author Administrator
	 */	
	public class PanelSplit extends PanelBase
	{
		internal var viewHandle:PanelSplitViewHandle;
		internal var mouseHandle:PanelSplitMouseHandle;
		internal var inputHandle:PanelSplitTextInputHandle;
		
		public function PanelSplit()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var mc:McSplit = new McSplit();
			_skin = mc;
			addChild(_skin);
			setTitleBar(mc.mcDrag);
		}
		
		override protected function initData():void
		{
			viewHandle = new PanelSplitViewHandle(this);
			inputHandle = new PanelSplitTextInputHandle(this);
			mouseHandle = new PanelSplitMouseHandle(this);
		}
		
		override public function update(proc:int=0):void
		{
		}
		
		override public function destroy():void
		{
			if(viewHandle)
			{
				viewHandle.destroy();
				viewHandle = null;
			}
			if(inputHandle)
			{
				inputHandle.destroy();
				inputHandle = null;
			}
			if(mouseHandle)
			{
				mouseHandle.destroy();
				mouseHandle = null;
			}
			super.destroy();
		}
	}
}