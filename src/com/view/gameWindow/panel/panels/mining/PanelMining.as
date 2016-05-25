package com.view.gameWindow.panel.panels.mining
{
	import com.view.gameWindow.panel.panelbase.PanelBase;
	
	/**
	 * 挖矿获得提示面板类
	 * @author Administrator
	 */	
	public class PanelMining extends PanelBase implements IPanelMining
	{
		internal var mouseHandler:PanelMiningMouseHandler;
		internal var viewHandler:PanelMiningViewHandler;
		
		public function PanelMining()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McMining = new McMining();
			_skin = skin;
			addChild(_skin);
			setTitleBar(skin.mcDrag);
			//
			skin.btnClose.resUrl = "";
			skin.btnClose.visible = false;
		}
		
		override protected function initData():void
		{
			mouseHandler = new PanelMiningMouseHandler(this);
			viewHandler = new PanelMiningViewHandler(this);
		}
		
		override public function update(proc:int=0):void
		{
			if(args)
			{
				viewHandler.refresh();
			}
		}
		
		override public function setPostion():void
		{
			super.setPostion();
			x += 250;
		}
		
		override public function destroy():void
		{
			if(viewHandler)
			{
				viewHandler.destroy();
				viewHandler = null;
			}
			if(mouseHandler)
			{
				mouseHandler.destroy();
				mouseHandler = null;
			}
			super.destroy();
		}
	}
}