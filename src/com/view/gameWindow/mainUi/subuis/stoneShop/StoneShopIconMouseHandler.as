package com.view.gameWindow.mainUi.subuis.stoneShop
{
    import com.view.gameWindow.panel.panels.exchangeShop.ExchangeShopDataManager;

    import flash.events.MouseEvent;

    /**
     * Created by Administrator on 2015/3/27.
     */
    public class StoneShopIconMouseHandler
    {
        private var _icon:ExchangeShopIcon;

        public function StoneShopIconMouseHandler(icon:ExchangeShopIcon)
        {
            _icon = icon;
            _icon.addEventListener(MouseEvent.CLICK, onClickHandler, false, 0, true);
        }

        private function onClickHandler(event:MouseEvent):void
        {
            ExchangeShopDataManager.instance.dealSwitchPanel();
        }

        public function destroy():void
        {
            if (_icon)
            {
                _icon.removeEventListener(MouseEvent.CLICK, onClickHandler);
                _icon = null;
            }
        }
    }
}
