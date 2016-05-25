package com.view.gameWindow.panel.panels.roleProperty.role
{
    import com.model.consts.StringConst;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.closet.ClosetDataManager;
    import com.view.gameWindow.panel.panels.closet.IClosetPanel;
    import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
    import com.view.gameWindow.panel.panels.roleProperty.IRolePropertyPanel;
    import com.view.gameWindow.panel.panels.roleProperty.McRole;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.RolePropertyPanel;
    import com.view.gameWindow.panel.panels.roleProperty.cell.EquipCellHandle;
    import com.view.gameWindow.panel.panels.roleProperty.cell.FashionCellHandle;
    import com.view.gameWindow.panel.panels.stronger.PanelStronger;
    import com.view.gameWindow.panel.panels.stronger.data.StrongerTabType;
    import com.view.gameWindow.util.SimpleStateButton;
    import com.view.newMir.NewMirMediator;
    
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.events.TextEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;

    /**
	 * 角色面板鼠标事件处理类
	 * @author Administrator
	 */	
	public class RoleMouseHandle
	{
		private var _mc:McRole;
		public var fashionCellHandle:FashionCellHandle;
		public var equipCellHandle:EquipCellHandle;
		public var rolePropertyPanel:RolePropertyPanel;
        private var _parent:Object;

        public function RoleMouseHandle(skin:McRole, parent:Object = null)
		{
            _parent = parent;
            _mc = skin as McRole;
			init();
		}
		
		private function init():void
		{
			_mc.addEventListener(MouseEvent.MOUSE_OVER,overHandle);
			_mc.addEventListener(MouseEvent.MOUSE_OUT,outHandle);
			_mc.addEventListener(MouseEvent.CLICK,clickHandle);

            if (_parent)
            {
                SimpleStateButton.addLinkState(_mc.hideFashion, StringConst.ROLE_PROPERTY_PANEL_0020, "hideWing");
                _mc.hideFashion.addEventListener(TextEvent.LINK, onLinkEvt, false, 0, true);

                SimpleStateButton.addLinkState(_mc.upFight, StringConst.ROLE_PROPERTY_PANEL_0021, "upFight");
                _mc.upFight.addEventListener(TextEvent.LINK, onLinkEvt, false, 0, true);
            }
		}
		
		private function overHandle(evt:MouseEvent):void
		{
            var txt:TextField = evt.target as TextField;
			switch(txt)
			{
				case _mc.hideFashion:
					_mc.hideFashion.textColor = 0x00ffe5;
					break;
				case _mc.upFight:
					_mc.upFight.textColor = 0x00ffe5;
					break;
			}
		}

        private function onLinkEvt(event:TextEvent):void
        {
            if (event.text == "upFight")
            {
                var panel:PanelStronger = PanelMediator.instance.openedPanel(PanelConst.TYPE_BECOME_STRONGER) as PanelStronger;
                if (panel)
                {
                    panel.switchToTab(StrongerTabType.TAB_STRONGER);
                } else
                {
                    PanelMediator.instance.openPanel(PanelConst.TYPE_BECOME_STRONGER);
                    panel = PanelMediator.instance.openedPanel(PanelConst.TYPE_BECOME_STRONGER) as PanelStronger;
                    panel.switchToTab(StrongerTabType.TAB_STRONGER);
                }
            } else if (event.text == "hideWing")
            {
                if (_parent && _parent.menuCheck)
                {
                    _parent.menuCheck.visible = !_parent.menuCheck.visible;
                }
            }
        }
		
		private function outHandle(evt:MouseEvent):void
		{
			var txt:TextField = evt.target as TextField;
			switch(txt)
			{
				case _mc.hideFashion:
					_mc.hideFashion.textColor = 0x00ff00;
					break;
				case _mc.upFight:
					_mc.upFight.textColor = 0x00ff00;
					break;
			}
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			var mc:MovieClip = evt.target as MovieClip;
			switch(mc)
			{
				case _mc.changeBtn:
					switchRoleInfoBewteenCloset();
					break;
				case _mc.hideFashion:
//					fashionCellHandle.hideFasion();
					break;
				case _mc.upFight:
					break;
			}
		}
		
		
		/**角色信息和衣柜面板切换*/
		public function switchRoleInfoBewteenCloset():void
		{
			if(!ClosetDataManager.instance.isClosetUnlock)
			{
				_mc.changeBtn.selected = false;
				var tip:String = GuideSystem.instance.getUnlockTip(UnlockFuncId.ROLE_CLOSET);
				if(tip)
				{
					Alert.warning(tip);
				}
				return;
			}
			
			var mediator:PanelMediator = PanelMediator.instance;
			fashionCellHandle.visible = _mc.changeBtn.selected;
			equipCellHandle.visible = !_mc.changeBtn.selected;
			_mc.mcCellBg.visible = !_mc.changeBtn.selected;
			_mc.mcRight.visible = !_mc.changeBtn.selected;
			if(_mc.changeBtn.selected)
			{
//				ClosetDataManager.instance.request();
				
				ClosetDataManager.instance.setDefaultIndex(0);
				mediator.openPanel(PanelConst.TYPE_CLOSET);
				resetPostion();
			}
			else
			{
				mediator.closePanel(PanelConst.TYPE_CLOSET_PUT_IN);
				mediator.closePanel(PanelConst.TYPE_CLOSET_PROMPT);
				mediator.closePanel(PanelConst.TYPE_CLOSET);
				(PanelMediator.instance.openedPanel(PanelConst.TYPE_ROLE_PROPERTY) as RolePropertyPanel).setPostion();
			}
		}
		
		private function resetPostion():void
		{
			var closetPanel:IClosetPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_CLOSET) as IClosetPanel;
			var rolePanel:IRolePropertyPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_ROLE_PROPERTY) as IRolePropertyPanel;
			var roleRect:Rectangle = rolePanel.getPanelRect();
			var closetRect:Rectangle = closetPanel.getPanelRect();
			var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
			var x:int = int((newMirMediator.width - (roleRect.width - 150) - closetRect.width)*.5);
			var y:int = int((newMirMediator.height - roleRect.height)*.5);
			rolePanel.postion = new Point(x,y);
			closetPanel.postion = new Point(x+(roleRect.width/* - 150*/),y+(roleRect.height-closetRect.height)*.5);
		}
		
		public function destroy():void
		{
			if(_mc)
			{
                _mc.upFight.removeEventListener(TextEvent.LINK, onLinkEvt);
                _mc.hideFashion.removeEventListener(TextEvent.LINK, onLinkEvt);
                SimpleStateButton.removeState(_mc.upFight);
                SimpleStateButton.removeState(_mc.hideFashion);

				_mc.removeEventListener(MouseEvent.MOUSE_OVER,overHandle);
				_mc.removeEventListener(MouseEvent.MOUSE_OUT,outHandle);
				_mc.removeEventListener(MouseEvent.CLICK,clickHandle);
				_mc = null;
				fashionCellHandle = null;
				equipCellHandle = null;
			}
            if (_parent)
            {
                _parent = null;
            }
		}
	}
}