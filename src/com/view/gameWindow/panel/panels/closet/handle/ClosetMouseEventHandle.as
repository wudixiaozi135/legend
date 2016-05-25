package com.view.gameWindow.panel.panels.closet.handle
{
    import com.model.consts.EffectConst;
    import com.model.consts.StringConst;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.closet.ClosetData;
    import com.view.gameWindow.panel.panels.closet.ClosetDataManager;
    import com.view.gameWindow.panel.panels.closet.McClosetPanel;
    import com.view.gameWindow.panel.panels.roleProperty.IRolePropertyPanel;
    import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
    import com.view.gameWindow.util.UIEffectLoader;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class ClosetMouseEventHandle
	{
		private var _mc:McClosetPanel;
		private var _closetAttributeHandle:ClosetAttributeHandle;
		private var _closetFashionAttributeHandle:ClosetFashionAttributeHandle;
		private var _closetFuncBtnHandle:ClosetUpgradeBtnHandle;
		private var _closetFashionChooseHandle:ClosetFashionChooseHandle;
		private var _uiEffectLoader:UIEffectLoader;
		private var _uiEffectLoader2:UIEffectLoader;
		
		public function ClosetMouseEventHandle(mc:McClosetPanel)
		{
			_mc = mc;
			_mc.mouseEnabled = false;
			init();
		}
		
		private function init():void
		{
			_mc.addEventListener(MouseEvent.CLICK,clickHandle);
			_closetAttributeHandle = new ClosetAttributeHandle(_mc);
			_closetFashionAttributeHandle = new ClosetFashionAttributeHandle(_mc);
			_closetFuncBtnHandle = new ClosetUpgradeBtnHandle(_mc);
			_closetFashionChooseHandle = new ClosetFashionChooseHandle(_mc);
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			switch(evt.target)
			{
				case _mc.closeBtn:
					var mediator:PanelMediator = PanelMediator.instance;
					var rolePropertyPanel:IRolePropertyPanel = mediator.openedPanel(PanelConst.TYPE_ROLE_PROPERTY) as IRolePropertyPanel;
					if(rolePropertyPanel && rolePropertyPanel.rolePanel)
					{
						rolePropertyPanel.rolePanel.switchRoleInfoBewteenCloset();
					}
					else
					{
						mediator.closePanel(PanelConst.TYPE_CLOSET_PUT_IN);
						mediator.closePanel(PanelConst.TYPE_CLOSET_PROMPT);
						mediator.closePanel(PanelConst.TYPE_CLOSET);
					}
					break;
				case _mc.fashionBtn:
					clickRefresh(ConstEquipCell.TYPE_SHIZHUANG);
					break;
				case _mc.bambooBtn:
					clickRefresh(ConstEquipCell.TYPE_DOULI);
					break;
				case _mc.footprintBtn:
					clickRefresh(ConstEquipCell.TYPE_ZUJI);
					break;
				case _mc.huanwuBtn:
					clickRefresh(ConstEquipCell.TYPE_HUANWU);
					break;
			}
		}
		
		internal function setBtnState(selectBtn:MovieClip = null,isLoadSet:Boolean = false):void
		{
			if(!isLoadSet)
			{
				_mc.fashionBtn.selected = false;
				_mc.bambooBtn.selected = false;
				_mc.footprintBtn.selected = false;
				_mc.huanwuBtn.selected = false;
			}
			if(_mc.fashionBtn.txt && !_mc.fashionBtn.selected)
			{
				_mc.fashionBtn.txt.textColor = 0x675318;
				_mc.fashionBtn.txt.text = StringConst.CLOSET_PANEL_0002;
			}
			if(_mc.bambooBtn.txt && !_mc.bambooBtn.selected)
			{
				_mc.bambooBtn.txt.textColor = 0x675318;
				_mc.bambooBtn.txt.text = StringConst.CLOSET_PANEL_0004;
			}
			if(_mc.footprintBtn.txt && !_mc.footprintBtn.selected)
			{
				_mc.footprintBtn.txt.textColor = 0x675318;
				_mc.footprintBtn.txt.text = StringConst.CLOSET_PANEL_0005;
			}
			if(_mc.huanwuBtn.txt && !_mc.huanwuBtn.selected)
			{
				_mc.huanwuBtn.txt.textColor = 0x675318;
				_mc.huanwuBtn.txt.text = StringConst.CLOSET_PANEL_00051;
			}
			if(selectBtn && selectBtn.txt)
			{
				selectBtn.selected = true;
				selectBtn.txt.textColor = 0xffe1aa;
				/*trace("ClosetMouseEventHandle.setBtnState(selectBtn) selectBtn：" +selectBtn+",selectBtn.selected:"+selectBtn.selected);*/
			}
		}
		
		public function clickRefresh(current:int):void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_1BTN_PROMPT);
			PanelMediator.instance.closePanel(PanelConst.TYPE_CLOSET_PROMPT);
			PanelMediator.instance.closePanel(PanelConst.TYPE_CLOSET_PUT_IN);
			
			
			ClosetDataManager.instance.current = current;
			refresh();
			updateEffect();
		}
		
		
		private var lastClosetData:ClosetData;
		
		public function updateEffect():void
		{
			if(lastClosetData != ClosetDataManager.instance.currentClosetData())
			{
				if(_uiEffectLoader)
				{
					_uiEffectLoader.destroy();
					_uiEffectLoader = null;
				}
				
				lastClosetData = ClosetDataManager.instance.currentClosetData();
				
				if(lastClosetData)
				{
					_uiEffectLoader = new UIEffectLoader(_mc,544,109,1,1,EffectConst.getClosetNameEffect(lastClosetData.frame));
				}
			}
		}
		
		public function refresh():void
		{
			setBtnState(selectBtn);
			_closetAttributeHandle.refresh();
			_closetFashionChooseHandle.refresh();
			updateFashionAttribute();
			_closetFuncBtnHandle.refresh();
			refreshEffect();
		}
		
		private function refreshEffect():void
		{
			if(_uiEffectLoader2)
			{
				_uiEffectLoader2.destroy();
				_uiEffectLoader2 = null;
			}
			if(_mc.mcLevel.visible == true)
			{
				_uiEffectLoader2 = new UIEffectLoader(_mc,_mc.mcLevel.x + _mc.mcLevel.width/2 + 2,_mc.mcLevel.y + _mc.mcLevel.height/2-3,1,1,EffectConst.RES_JINJIE);
			}
		}
		
		public function updateFashionAttribute():void
		{
			_closetFashionAttributeHandle.refresh();
		}
		
		private function get selectBtn():MovieClip
		{
			var current:int = ClosetDataManager.instance.current;
			var mc:MovieClip = null;
			switch(current)
			{
				case ConstEquipCell.TYPE_SHIZHUANG:
					mc = _mc.fashionBtn;
					break;
				case ConstEquipCell.TYPE_DOULI:
					mc = _mc.bambooBtn;
					break;
				case ConstEquipCell.TYPE_ZUJI:
					mc = _mc.footprintBtn;
					break;
				case ConstEquipCell.TYPE_HUANWU:
					mc = _mc.huanwuBtn;
					break;
				default:
					mc = null;
					break;
			}
			return mc;
		}
		
		public function destroy():void
		{
			if(_closetFashionChooseHandle)
			{
				_closetFashionChooseHandle.destroy();
				_closetFashionChooseHandle = null;
			}
			if(_closetFuncBtnHandle)
			{
				_closetFuncBtnHandle.destroy();
				_closetFuncBtnHandle = null;
			}
			if(_closetFashionAttributeHandle)
			{
				_closetFashionAttributeHandle.destroy();
				_closetFashionAttributeHandle = null;
			}
			if(_closetAttributeHandle)
			{
				_closetAttributeHandle.destroy();
				_closetAttributeHandle = null;
			}
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.CLICK,clickHandle);
				_mc = null;
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
		}
	}
}