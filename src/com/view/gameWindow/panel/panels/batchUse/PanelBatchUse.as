package com.view.gameWindow.panel.panels.batchUse
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * 批量使用面板类
	 * @author Administrator
	 */	
	public class PanelBatchUse extends PanelBase implements IPanelBatchUse
	{
		internal var viewHandle:PanelBatchUseViewHandle;
		internal var mouseHandle:PanelBatchUseMouseHandle;
		internal var inputHandle:PanelBatchUseTextInputHandle;

		public function PanelBatchUse()
		{
			super();
			BagDataManager.instance.attach(this);
			HeroDataManager.instance.attach(this);
		}
		
		override protected function initSkin():void
		{
			var mc:McBatchUse = new McBatchUse();
			_skin = mc;
			addChild(_skin);
			setTitleBar(mc.mcDrag);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var mc:McBatchUse = _skin as McBatchUse;
			rsrLoader.addCallBack(mc.btnDo,function(mc:MovieClip):void
			{
				(mc.txt as TextField).text = StringConst.BATCH_USE_PANEL_0002;
				InterObjCollector.instance.add(mc.btnDo);
			});
		}
		
		override protected function initData():void
		{
			viewHandle = new PanelBatchUseViewHandle(this);
			inputHandle = new PanelBatchUseTextInputHandle(this);
			mouseHandle = new PanelBatchUseMouseHandle(this);
		}
		
		override public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_BAG_ITEMS || proc == GameServiceConstants.SM_HERO_INFO)
			{
				viewHandle.refresh();
			}
		}
		
		override public function destroy():void
		{
			HeroDataManager.instance.detach(this);
			BagDataManager.instance.detach(this);
			if(mouseHandle)
			{
				mouseHandle.destroy();
				mouseHandle = null;
			}
			if(inputHandle)
			{
				inputHandle.destroy();
				inputHandle = null;
			}
			if(viewHandle)
			{
				viewHandle.destroy();
				viewHandle = null;
			}
			
			InterObjCollector.instance.remove(_skin.btnDo);
			super.destroy();
		}
	}
}