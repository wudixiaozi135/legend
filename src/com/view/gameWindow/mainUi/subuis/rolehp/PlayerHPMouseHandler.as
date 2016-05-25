package com.view.gameWindow.mainUi.subuis.rolehp
{
    import com.model.consts.StringConst;
    import com.view.gameWindow.mainUi.subclass.McRoleHp;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.menus.MenuMediator;
    import com.view.gameWindow.panel.panels.menus.RoleHeadMenu;
    import com.view.gameWindow.panel.panels.menus.handlers.MenuFuncs;
    import com.view.gameWindow.panel.panels.menus.handlers.RoleHeadHandler;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.otherRole.IOtherRolePanel;
    import com.view.gameWindow.panel.panels.roleProperty.otherRole.OtherPlayerDataManager;
    import com.view.gameWindow.scene.entity.entityItem.Player;
    import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
    import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;

    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.events.Request;

    public class PlayerHPMouseHandler
    {
        private var _player:IPlayer;

        public function PlayerHPMouseHandler(skin:McRoleHp):void
        {
            _skin = skin;
            _skin.addEventListener(MouseEvent.CLICK, onMouseClick);
        }

        private var _skin:McRoleHp;
        private var roleMenu:RoleHeadMenu;

        private function onMouseClick(e:MouseEvent):void
        {
            if ((AutoJobManager.getInstance().selectEntity) is IPlayer)
            {
                _player = (AutoJobManager.getInstance().selectEntity) as IPlayer;
            }
            switch (e.target)
            {
                case _skin.btn1://查看
                    dealLook();
                    break;
                case _skin.btn2:
					MenuFuncs.addFriend(_player.sid,_player.cid);
                    break;
                case _skin.btn3://交易
                    handlerTrade(_player);
                    break;
                case _skin.btn4://操作
					if(!roleMenu)
					{
						e.stopImmediatePropagation();
						roleMenu = new RoleHeadMenu(new RoleHeadHandler(_player.sid,_player.cid,(_player as Player).entityName));						
						roleMenu.addEventListener(Event.SELECT,roleMenuSelectHandler);
						MenuMediator.instance.showMenu(roleMenu);
						
						roleMenu.x = e.stageX + 10;
						roleMenu.y = e.stageY;
					}
                    break;
                default:
                    break;
            }
        }

        private function handlerTrade(player:IPlayer):void
        {
            if (player)
            {
                if (RoleDataManager.instance.stallStatue)
                {
                    RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0037);
                    return;
                }
                if (player.stallStatue)
                {
                    RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0038);
                    return;
                }
                MenuFuncs.trade(player.sid, player.cid);
            }
        }
		
		public function hideMenu():void
		{
            if (roleMenu)
            {
                roleMenu.removeEventListener(Event.SELECT, roleMenuSelectHandler);
                MenuMediator.instance.hideMenu(roleMenu);
                roleMenu = null;
            }
		}
		
		private function roleMenuSelectHandler(e:Request):void
		{
			hideMenu();
		}

        private function dealLook():void
        {
            OtherPlayerDataManager.instance.sendData(_player.cid, _player.sid);
            PanelMediator.instance.openPanel(PanelConst.TYPE_OTHER_PLAYER);
			var IPanel:IOtherRolePanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_OTHER_PLAYER) as IOtherRolePanel;
			IPanel.cid = _player.cid;
			IPanel.sid = _player.sid;
        }
    }
}