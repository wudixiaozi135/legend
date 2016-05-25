package com.view.gameWindow.panel.panels.forge.resolve
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.forge.ForgeDataManager;
	import com.view.gameWindow.panel.panels.forge.McResolve;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	
	/**
	 * 锻造分解面板类
	 * @author Administrator
	 */	
	public class TabResolve extends TabBase
	{
		private var _mcResolve:McResolve;
		
		internal var resolveClickHandle:ResolveClickHandle;
		internal var resolveViewHandle:ResolveViewHandle;
		internal var resolveCellHandle:ResolveCellHandle;
		
		public function TabResolve()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			_skin = new McResolve();
			_mcResolve = _skin as McResolve;
			addChild(_mcResolve);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(_mcResolve.btnSure,function():void
			{
				_mcResolve.btnSure.txt.text = StringConst.FORGE_PANEL_00015;
			});
			rsrLoader.addCallBack(_mcResolve.mcScrollBar,function(mc:MovieClip):void
			{
				resolveCellHandle.addScrollBar(mc);
			});
		}
		
		override protected function initData():void
		{
			resolveClickHandle = new ResolveClickHandle(this);
			resolveViewHandle = new ResolveViewHandle(this);
			resolveCellHandle = new ResolveCellHandle(this);
		}
		
		override public function update(proc:int=0):void
		{
			resolveCellHandle.refresh();
			resolveViewHandle.refresh();
			if(proc == GameServiceConstants.CM_EQUIP_DISASSEMBLE)
			{
				return;
			}
		}
		
		override public function destroy():void
		{
			if(resolveCellHandle)
			{
				resolveCellHandle.destroy();
				resolveCellHandle = null;
			}
			if(resolveViewHandle)
			{
				resolveViewHandle.destroy();
				resolveViewHandle = null;
			}
			if(resolveClickHandle)
			{
				resolveClickHandle.destory();
				resolveClickHandle = null;
			}
			_mcResolve = null;
			super.destroy();
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			ForgeDataManager.instance.attach(this);
			BagDataManager.instance.attach(this);
			HeroDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			HeroDataManager.instance.detach(this);
			BagDataManager.instance.detach(this);
			ForgeDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}