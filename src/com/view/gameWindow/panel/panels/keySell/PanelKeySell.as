package com.view.gameWindow.panel.panels.keySell
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
	
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	
	/**
	 * 一键出售面板类
	 * @author Administrator
	 */	
	public class PanelKeySell extends PanelBase implements IPanelKeySell
	{
		internal var mouseHandle:PanelKeySellMouseHandle;
		internal var cellHandle:PanelKeySellCellHandle;
		
		public function PanelKeySell()
		{
			super();
			KeySellDataManager.instance.attach(this);
		}
		
		override protected function initSkin():void
		{
			var mc:McKeySell = new McKeySell();
			_skin = mc;
			addChild(_skin);
			setTitleBar(mc.mcDrag);
			initTxt();
		}
		
		private function initTxt():void
		{
			var mc:McKeySell = _skin as McKeySell;
			var defaultTextFormat:TextFormat = mc.txtTitle.defaultTextFormat;
			defaultTextFormat.bold = true;
			mc.txtTitle.defaultTextFormat = defaultTextFormat;
			mc.txtTitle.setTextFormat(defaultTextFormat);
			mc.txtTitle.text = StringConst.BAG_PANEL_0006;
			mc.txtTitle.mouseEnabled = false;
			mc.txtPrompt.text = StringConst.KEY_SELL_PANEL_0001;
			mc.txtPrompt.mouseEnabled = false;
			mc.txtBtn.text = StringConst.KEY_SELL_PANEL_0002;
			mc.txtBtn.mouseEnabled = false;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var mc:McKeySell = _skin as McKeySell;
			rsrLoader.addCallBack(mc.mcScrollBar,function (mc:MovieClip):void
			{
				cellHandle.addScrollBar(mc);
			});
			
			rsrLoader.addCallBack(mc.btnSure,function (mc:MovieClip):void
			{
				InterObjCollector.instance.add(mc);
			});
			
			rsrLoader.addCallBack(mc.btnClose,function (mc:MovieClip):void
			{
				InterObjCollector.instance.add(mc);
			});
		}
		
		override protected function initData():void
		{
			mouseHandle = new PanelKeySellMouseHandle(this);
			cellHandle = new PanelKeySellCellHandle(this);
		}
		
		override public function update(proc:int=0):void
		{
			cellHandle.refresh();
		}
		
		override public function destroy():void
		{
			KeySellDataManager.instance.detach(this);
			if(cellHandle)
			{
				cellHandle.destroy();
				cellHandle = null;
			}
			if(mouseHandle)
			{
				mouseHandle.destroy();
				mouseHandle = null;
			}
			
			InterObjCollector.instance.remove(_skin.btnSure);
			InterObjCollector.instance.remove(_skin.btnClose);
			super.destroy();
		}
		
	}
}