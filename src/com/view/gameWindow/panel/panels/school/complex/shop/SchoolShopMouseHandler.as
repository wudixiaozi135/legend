package com.view.gameWindow.panel.panels.school.complex.shop
{
    import flash.events.MouseEvent;

    /**
     * Created by Administrator on 2015/2/2.
     */
    public class SchoolShopMouseHandler
    {
        private var _tab:SchoolShopTab;
        private var _skin:McSchoolShop;

        public function SchoolShopMouseHandler(tab:SchoolShopTab)
        {
            _tab = tab;
            _skin = _tab.skin as McSchoolShop;
            _skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        }

        private function onClick(event:MouseEvent):void
        {
            switch (event.target)
            {
                case _skin.btnLeft:
                    turnLeft();
                    break;
                case _skin.btnRight:
                    turnRight();
                    break;
                default :
                    break;
            }
        }

        private function turnRight():void
        {
            var currentPage:int = SchoolShopManager.currentPage;
            var totalPage:int = SchoolShopManager.totalPage;
            if (currentPage < totalPage)
            {
                currentPage++;
            }
            SchoolShopManager.currentPage = currentPage;
        }

        private function turnLeft():void
        {
            var currentPage:int = SchoolShopManager.currentPage;
            if (currentPage > 1)
            {
                currentPage--;
            }
            SchoolShopManager.currentPage = currentPage;
        }

        public function destroy():void
        {
            if (_skin)
            {
                _skin.removeEventListener(MouseEvent.CLICK, onClick);
                _skin = null;
            }
            if (_tab)
            {
                _tab = null;
            }
        }
    }
}
