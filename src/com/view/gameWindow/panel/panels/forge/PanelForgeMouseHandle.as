package com.view.gameWindow.panel.panels.forge
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.forge.compound.TabCompound;
	import com.view.gameWindow.panel.panels.forge.degree.TabDegree;
	import com.view.gameWindow.panel.panels.forge.extend.TabExtend;
	import com.view.gameWindow.panel.panels.forge.refined.TabRefined;
	import com.view.gameWindow.panel.panels.forge.resolve.TabResolve;
	import com.view.gameWindow.panel.panels.forge.strengthen.TabStrengthen;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	import com.view.gameWindow.util.tabsSwitch.TabsSwitch;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 锻造面板鼠标处理类
	 * @author Administrator
	 */	
	public class PanelForgeMouseHandle
	{
		private var _panel:PanelForge;
		private var _mc:McForge;
		private var _tabsSwitch:TabsSwitch;
		internal var lastClickBtn:MovieClip;
		
		public function PanelForgeMouseHandle(panel:PanelForge)
		{
			_panel = panel;
			_mc = _panel.skin as McForge;
			init();
		}
		
		private function init():void
		{
			var tabs:Vector.<Class> = Vector.<Class>([TabStrengthen,TabDegree,TabCompound,TabExtend,TabResolve,TabRefined]);
			var openedTab:int = ForgeDataManager.instance.openedTab;
			openedTab = openedTab == -1 ? 0 : openedTab;
			_tabsSwitch = new TabsSwitch(_mc.mcLayer,tabs,openedTab);
			lastClickBtn = _mc.btnIntensify;
			_mc.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		public function setTabIndex(index:int):void
		{
			switch(index)
			{
				case ForgeDataManager.typeStrengthen:
					dealTabSwitch(_mc.btnIntensify,ForgeDataManager.typeStrengthen);
					break;
				case ForgeDataManager.typeDegree:
					dealTabSwitch(_mc.btnUpdegree,ForgeDataManager.typeDegree);
					break;
				case ForgeDataManager.typeCompound:
					dealTabSwitch(_mc.btnCompound,ForgeDataManager.typeCompound);
					break;
				case ForgeDataManager.typeExtend:
					dealTabSwitch(_mc.btnExtends,ForgeDataManager.typeExtend);
					break;
				case ForgeDataManager.typeResolve:
					dealTabSwitch(_mc.btnResolve,ForgeDataManager.typeResolve);
					break;
				case ForgeDataManager.typeRefined:
					dealTabSwitch(_mc.btnRefined,ForgeDataManager.typeRefined);
					break;
				default:
					dealTabSwitch(_mc.btnIntensify,ForgeDataManager.typeStrengthen);
					break;
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _mc.btnClose:
					ForgeDataManager.instance.dealSwitchPanel();
					break;
				case _mc.btnIntensify:
					dealTabSwitch(_mc.btnIntensify,ForgeDataManager.typeStrengthen);
					break;
				case _mc.btnUpdegree:
					dealTabSwitch(_mc.btnUpdegree,ForgeDataManager.typeDegree);
					break;
				case _mc.btnCompound:
					dealTabSwitch(_mc.btnCompound,ForgeDataManager.typeCompound);
					break;
				case _mc.btnExtends:
					dealTabSwitch(_mc.btnExtends,ForgeDataManager.typeExtend);
					break;
				case _mc.btnResolve:
					dealTabSwitch(_mc.btnResolve,ForgeDataManager.typeResolve);
					break;
				case _mc.btnRefined:
					dealTabSwitch(_mc.btnRefined,ForgeDataManager.typeRefined);
					break;
				default:
					break;
			}
		}
		
		private function dealTabSwitch(clickBtn:MovieClip,index:int):void
		{
//			if(_tabsSwitch.index == index)
//			{
//				return;
//			}
			PanelMediator.instance.closePanel(PanelConst.TYPE_BUY_ITEM_CONFIRM);
			ForgeDataManager.instance.openedTab = index;
			_mc.mcLayer.mouseEnabled = false;
			if(lastClickBtn.hasOwnProperty("txt"))
			{
				lastClickBtn.txt.textColor = 0x675138;
				lastClickBtn.selected = false;
			}
			lastClickBtn.mouseEnabled = true;
			_tabsSwitch.onClick(index);
			lastClickBtn = clickBtn;
			if(lastClickBtn.hasOwnProperty("txt"))
			{
				lastClickBtn.txt.textColor = 0xffe1aa;
				lastClickBtn.selected = true;
			}
			lastClickBtn.mouseEnabled = false;
		}
		
		public function update(proc:int):void
		{
			if(_tabsSwitch)
			{
				var tab:TabBase = _tabsSwitch.tab;
				if(tab)
				{
					tab.update(proc);
				}
			}
		}
		
		public function destroy():void
		{
			if(_tabsSwitch)
			{
				_tabsSwitch.destroy();
				_tabsSwitch = null;
			}
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.CLICK,onClick);
				_mc = null;
			}
			_panel = null;
		}
	}
}