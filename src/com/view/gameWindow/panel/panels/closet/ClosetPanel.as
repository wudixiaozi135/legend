package com.view.gameWindow.panel.panels.closet
{
    import com.model.consts.EffectConst;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.closet.handle.ClosetAddCallBackHandle;
    import com.view.gameWindow.panel.panels.closet.handle.ClosetMouseEventHandle;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UIUnlockHandler;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
    import com.view.gameWindow.util.UIEffectLoader;
    
    import flash.geom.Rectangle;

    /**
	 * 衣柜面板类
	 * @author Administrator
	 */	
	public class ClosetPanel extends PanelBase implements IClosetPanel
	{
		private var _mcClosetPanel:McClosetPanel;
		/**包内使用*/
		public var mouseEvent:ClosetMouseEventHandle;
		private var _uiEffectLoader:UIEffectLoader;
		private var _uiEffectLoader2:UIEffectLoader;
		private var _unlock:UIUnlockHandler;
		public function ClosetPanel()
		{
			super();
			mouseEnabled = false;
			ClosetDataManager.instance.attach(this);
		}
		
		override protected function initSkin():void
		{
			_skin = new McClosetPanel();
			_skin.mouseEnabled = false;
			_mcClosetPanel = _skin as McClosetPanel;
			_skin.mcEmptyBg.resUrl = "";
			addChild(_mcClosetPanel);
			setTitleBar(_mcClosetPanel.dragBox);
			
			_unlock = new UIUnlockHandler(getTabBtn,1,updateUnlock);
            _unlock.updateUIStates([UnlockFuncId.ROLE_CLOSET_0, UnlockFuncId.ROLE_CLOSET_1, UnlockFuncId.ROLE_CLOSET_3, UnlockFuncId.ROLE_CLOSET_4]);
		}
		
		private function getTabBtn(id:int):*
		{
			switch(id)
			{
				case UnlockFuncId.ROLE_CLOSET_0:
					return _skin.huanwuBtn;
					break;
				case UnlockFuncId.ROLE_CLOSET_1:
					return _skin.fashionBtn;
					break;
				case UnlockFuncId.ROLE_CLOSET_3:
					return _skin.bambooBtn;
					break;
				case UnlockFuncId.ROLE_CLOSET_4:
					return _skin.footprintBtn;
					break;
			}
			
			return null;
		}
		
		private function updateUnlock(id:int):void
		{
            if (id == UnlockFuncId.ROLE_CLOSET_0 || id == UnlockFuncId.ROLE_CLOSET_1 || id == UnlockFuncId.ROLE_CLOSET_3 || id == UnlockFuncId.ROLE_CLOSET_4)
			{
				rearrangeTabBtns();
			}
		}
		
		private function rearrangeTabBtns():void
		{
            var arr:Array = [_skin.fashionBtn, _skin.bambooBtn ,_skin.footprintBtn ,_skin.huanwuBtn];

			var startX:int = 62;
			for(var i:int = 0; i < arr.length; ++i)
			{
				if(arr[i].visible)
				{
					arr[i].x = startX;
					startX += arr[i].width;
				}
			}
			
			if(ClosetDataManager.instance.current == 0)
			{
				ClosetDataManager.instance.setDefaultIndex(0);
			}
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var closetAddCallBackHandle:ClosetAddCallBackHandle = new ClosetAddCallBackHandle(this);
			closetAddCallBackHandle.addCallBack(rsrLoader);
		}
		
		override protected function initData():void
		{
			initText();
			mouseEvent = new ClosetMouseEventHandle(_mcClosetPanel);
			_uiEffectLoader = new UIEffectLoader(_skin,_skin.mcGorgeousLevel.x-18,_skin.mcGorgeousLevel.y-48,1,1,EffectConst.RES_HUOYAN);
			_uiEffectLoader2 = new UIEffectLoader(_skin,335,45,1,1,EffectConst.RES_TITLE);
		}
		
		private function initText():void
		{
			_mcClosetPanel.txtClosetNum0.text = StringConst.CLOSET_PANEL_0008;
			_mcClosetPanel.txtFightPower0.text = StringConst.CLOSET_PANEL_0009;
		}
		
		override public function update(proc:int=0):void
		{
			if(proc == ClosetDataManager.TYPE_UPDATE_MODE)
			{
				mouseEvent.updateFashionAttribute();
			}
			else
			{
				mouseEvent.refresh();
			}
		}
		
		override public function getPanelRect():Rectangle
		{
			return new Rectangle(0,0,671,523);//由子类继承实现
		}
		
		override public function destroy():void
		{
			if(_unlock)
			{
				_unlock.destroy();
				_unlock = null;
			}
			ClosetDataManager.instance.current = 0;
			ClosetDataManager.instance.detach(this);
			if(mouseEvent)
			{
				mouseEvent.destroy();
				mouseEvent = null;
			}
			if(_uiEffectLoader)
			{
				_uiEffectLoader.destroy();
				_uiEffectLoader = null;
			}
			if(_uiEffectLoader2)
			{
				_uiEffectLoader2.destroy();
				_uiEffectLoader2 = null;
			}
			_mcClosetPanel = null;
			super.destroy();
		}
	}
}