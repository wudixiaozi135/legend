package com.view.gameWindow.panel.panels.forge
{
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.panel.panelbase.IPanelTab;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UIUnlockHandler;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
    
    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
	 * 锻造面板类
	 * @author Administrator
	 */	
	public class PanelForge extends PanelBase implements IPanelForge,IPanelTab
	{
		private var _btns:Vector.<MovieClip>;
		
		private var _mouseHandle:PanelForgeMouseHandle;
		private var _unlockHandler:UIUnlockHandler;
		
		public function PanelForge()
		{
			super();
		}
		
		public function setTabIndex(index:int):void
		{
			if(_mouseHandle)
			{
				_mouseHandle.setTabIndex(index);
			}
		}

		override public function setSelectTabShow(tabIndex:int = -1):void
		{
			setTabIndex(tabIndex);
		}

		public function getTabIndex():int
		{
			return ForgeDataManager.instance.openedTab;
		}
		
		override protected function initSkin():void
		{
			var skin:McForge = new McForge();
			_skin = skin;
			skin.mcLayer.mouseEnabled = false;
			addChild(_skin);
			setTitleBar(skin.dragBox);
			//
			skin.btnResolve.resUrl = "";
			skin.btnResolve.visible = false;
			skin.btnRefined.x = skin.btnResolve.x;
		}
		
		private var tabLoadedState:Object = {};
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McForge = _skin as McForge;
			rsrLoader.addCallBack(skin.btnIntensify,function(mc:MovieClip):void
			{
				refreshTab(mc);
			});
			rsrLoader.addCallBack(skin.btnUpdegree,function(mc:MovieClip):void
			{
				refreshTab(mc);
			});
			rsrLoader.addCallBack(skin.btnCompound,function(mc:MovieClip):void
			{
				refreshTab(mc);
			});
			rsrLoader.addCallBack(skin.btnExtends,function(mc:MovieClip):void
			{
				refreshTab(mc);
			});
			rsrLoader.addCallBack(skin.btnResolve,function(mc:MovieClip):void
			{
				refreshTab(mc);
			});
			rsrLoader.addCallBack(skin.btnRefined,function(mc:MovieClip):void
			{
				refreshTab(mc);
			});
		}
		
		private function refreshTab(mc:MovieClip):void
		{
			mc.txt.textColor = 0x675138;
			mc.txt.text = getTabName(mc);
			var openedTab:int = ForgeDataManager.instance.openedTab;
			if(openedTab == getTabType(mc))
			{
				mc.txt.textColor = 0xffe1aa;
				mc.selected = true;
				mc.mouseEnabled = false;
				_mouseHandle.lastClickBtn = mc;
			}
		}
		
		private function getTabName(mc:MovieClip):String
		{
			var name:String;
			var skin:McForge = _skin as McForge;
			switch(mc)
			{
				default:
					break;
				case skin.btnIntensify:
					name = StringConst.FORGE_PANEL_00011;
					break;
				case skin.btnUpdegree:
					name = StringConst.FORGE_PANEL_00012;
					break;
				case skin.btnCompound:
					name = StringConst.FORGE_PANEL_00013;
					break;
				case skin.btnExtends:
					name = StringConst.FORGE_PANEL_00014;
					break;
				case skin.btnResolve:
					name = StringConst.FORGE_PANEL_00015;
					break;
				case skin.btnRefined:
					name = StringConst.FORGE_PANEL_00016;
					break;
			}
			return name;
		}
		
		private function getTabType(mc:MovieClip):int
		{
			var type:int;
			var skin:McForge = _skin as McForge;
			switch(mc)
			{
				default:
					break;
				case skin.btnIntensify:
					type = ForgeDataManager.typeStrengthen;
					break;
				case skin.btnUpdegree:
					type = ForgeDataManager.typeDegree;
					break;
				case skin.btnCompound:
					type = ForgeDataManager.typeCompound;
					break;
				case skin.btnExtends:
					type = ForgeDataManager.typeExtend;
					break;
				case skin.btnResolve:
					type = ForgeDataManager.typeResolve;
					break;
				case skin.btnRefined:
					type = ForgeDataManager.typeRefined;
					break;
			}
			return type;
		}
		
		override protected function initData():void
		{
			_mouseHandle = new PanelForgeMouseHandle(this);
			_unlockHandler = new UIUnlockHandler(getUnlockUI);
			_unlockHandler.updateUIStates(
				[UnlockFuncId.FORGE_COMPOUND,UnlockFuncId.FORGE_DEGREE,UnlockFuncId.FORGE_EXTEND,UnlockFuncId.FORGE_REFINED]);
		}
		
		private function getUnlockUI(id:int):*
		{
			var skin:McForge = _skin as McForge;
			switch(id)
			{
				case UnlockFuncId.FORGE_COMPOUND:
					return skin.btnCompound;
					break;
				case UnlockFuncId.FORGE_DEGREE:
					return skin.btnUpdegree;
					break;
				case UnlockFuncId.FORGE_EXTEND:
					return skin.btnExtends;
					break;
				case UnlockFuncId.FORGE_REFINED:
					return skin.btnRefined;
					break;
				default:
					return null;
			}
		}
		
		override public function update(proc:int=0):void
		{
			_mouseHandle.update(proc);
		}
		
		override public function destroy():void
		{
			if(_unlockHandler)
			{
				_unlockHandler.destroy();
				_unlockHandler = null;
			}
			if(_mouseHandle)
			{
				_mouseHandle.destroy();
				_mouseHandle = null;
			}
			super.destroy();
		}
		
		override public function getPanelRect():Rectangle
		{
			return new Rectangle(0,0,926,532);
		}
		
		override public function setPostion():void
		{
            var mc:McMainUIBottom = (MainUiMediator.getInstance().bottomBar as BottomBar).skin as McMainUIBottom;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.forgeBtn.x, mc.forgeBtn.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
		}
	}
}