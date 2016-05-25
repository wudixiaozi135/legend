package com.view.gameWindow.mainUi.subuis.rolehead
{
    import com.event.GameDispatcher;
    import com.event.GameEvent;
    import com.event.GameEventConst;
    import com.model.consts.StringConst;
    import com.view.gameWindow.mainUi.MainUi;
    import com.view.gameWindow.panel.panels.bag.menu.ConstBagCellMenu;
    import com.view.gameWindow.panel.panels.menus.others.MenuRoundBg;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    /**
     * Created by Administrator on 2015/3/12.
     */
    public class PkMenuUi extends MainUi
    {
        private var _menuRoundBg:MenuRoundBg;

        public function PkMenuUi()
        {
            super();
            addChild(_skin = new MovieClip());
            GameDispatcher.addEventListener(GameEventConst.PK_MODE_EVENT, handlerPkEvt, false, 0, true);
        }

        private function handlerPkEvt(event:GameEvent):void
        {
            if (event.param is MouseEvent)
            {
                if (_menuRoundBg)
                {
                    _menuRoundBg.setListVisible(event.param as MouseEvent);
                }
            }
        }

        override public function initView():void
        {
            var list:Vector.<int> = new <int>[ConstBagCellMenu.TYPE_PEACE, ConstBagCellMenu.TYPE_TROOPS, ConstBagCellMenu.TYPE_GUILD, ConstBagCellMenu.TYPE_GOODANDEVIL, ConstBagCellMenu.TYPE_ALL];
            var tips:Vector.<String> = new <String>[StringConst.ROLE_HEAD_TIP_0001, StringConst.ROLE_HEAD_TIP_0002, StringConst.ROLE_HEAD_TIP_0003, StringConst.ROLE_HEAD_TIP_0004, StringConst.ROLE_HEAD_TIP_0005];
            _menuRoundBg = new MenuRoundBg(_skin, list, function (index:int):void
            {
                PkDataManager.instance.changePkMode(index);
            }, tips);
            _menuRoundBg.x = 0;
            _menuRoundBg.y = 0;
            super.initView();
        }
    }
}
