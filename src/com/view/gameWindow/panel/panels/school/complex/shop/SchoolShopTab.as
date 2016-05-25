package com.view.gameWindow.panel.panels.school.complex.shop
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.cfgdata.SchoolShopCfgData;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
    import com.view.gameWindow.util.LoaderCallBackAdapter;
    import com.view.gameWindow.util.ObjectUtils;
    import com.view.gameWindow.util.tabsSwitch.TabBase;

    import flash.display.Sprite;
    import flash.utils.Dictionary;

    /**
     * Created by Administrator on 2015/1/31.
     */
    public class SchoolShopTab extends TabBase
    {
        private var _schoolShopItems:Dictionary;
        private var _container:Sprite;
        private var _dataItems:Vector.<SchoolShopCfgData>;
        private var _mouseHandler:SchoolShopMouseHandler;
        public function SchoolShopTab()
        {
            super();
            _schoolShopItems = new Dictionary(true);
            x = -7;
            SchoolShopEvent.addEventListener(SchoolShopEvent.CHANGE_PAGE, onPageEvt, false, 0, true);
        }

        override protected function initSkin():void
        {
            _skin = new McSchoolShop();
            addChild(_skin);
            _container = new Sprite();
            _skin.container.addChild(_container);
            _container.x = 1.5;
            _container.y = 2;
            _skin.txtScore.textColor = 0xd4a460;
            _skin.txtScore.text = StringConst.SCHOOL_PANEL_5013;
            _skin.txtScore.mouseEnabled = false;

            _skin.txtScoreValue.mouseEnabled = false;
            _skin.txtScoreValue.textColor = 0xffe1aa;
        }

        override protected function addCallBack(rsrLoader:RsrLoader):void
        {
            var skin:McSchoolShop = _skin as McSchoolShop;
            var adapt:LoaderCallBackAdapter = new LoaderCallBackAdapter();
            adapt.addCallBack(rsrLoader, function ():void
            {
                refreshPage();
                adapt = null;
            }, skin.btnLeft, skin.btnRight);
        }

        override protected function initData():void
        {
            _mouseHandler = new SchoolShopMouseHandler(this);
            _dataItems = _dataItems || SchoolShopManager.instance.getVecCfgByShelf(SchoolShopType.SCHOOL_SHOP_TYPE_0);
            SchoolShopManager.totalPage = ObjectUtils.getTotalPage(_dataItems.length);
            refresh();
        }

        private function onPageEvt(event:SchoolShopEvent):void
        {
            var param:Object = event._param;
            var _totalPage:int = param.totalPage;
            var _currentPage:int = param.currentPage;
            _skin.txtContent.text = _currentPage + "/" + _totalPage;
            refreshPage();
            refresh();
        }

        public function refreshPage():void
        {
            var _totalPage:int = SchoolShopManager.totalPage;
            var _currentPage:int = SchoolShopManager.currentPage;

            if (_totalPage == 1)
            {
                _skin.btnLeft.btnEnabled = false;
                _skin.btnRight.btnEnabled = false;
            } else
            {
                if (_currentPage < _totalPage)
                {
                    if (_currentPage != 1)
                    {
                        _skin.btnLeft.btnEnabled = true;
                        _skin.btnRight.btnEnabled = true;
                    } else
                    {
                        _skin.btnLeft.btnEnabled = false;
                        _skin.btnRight.btnEnabled = true;
                    }
                } else if (_currentPage == _totalPage)
                {
                    _skin.btnLeft.btnEnabled = true;
                    _skin.btnRight.btnEnabled = false;
                }
            }
        }

        override public function refresh():void
        {
            if (_dataItems == null) return;
            ObjectUtils.forEach(_schoolShopItems, function (obj:SchoolShopItem):void
            {
                obj.visible = false;
            });

            var currentPage:int = SchoolShopManager.currentPage;
            for (var i:int = (currentPage - 1) * 9, len:int = _dataItems.length; i < len; i++)
            {
                if (i < currentPage * 9)
                {
                    var item:SchoolShopItem;
                    if (_schoolShopItems[i])
                    {
                        item = _schoolShopItems[i];
                    } else
                    {
                        item = new SchoolShopItem();
                    }
                    item.data = _dataItems[i];

                    _schoolShopItems[i] = item;
                    if (!_container.contains(item))
                    {
                        _container.addChild(item);
                    }
                    item.x = (i % 3) * (item.width + 9);
                    item.y = int((i % 9) / 3) * item.height;
                    item.visible = true;
                }
            }
            updateMyContribution();
        }

        /**更新我的帮贡*/
        private function updateMyContribution():void
        {
            if (_skin)
            {
                if (SchoolElseDataManager.getInstance().schoolInfoData)
                {
                    _skin.txtScoreValue.text = SchoolElseDataManager.getInstance().schoolInfoData.contribute.toString();
                } else
                {
                    _skin.txtScoreValue.text = "0";
                }
            }
        }

        override public function update(proc:int = 0):void
        {
            switch (proc)
            {
                case GameServiceConstants.SM_FAMILY_INFO_QUERY:
                    updateMyContribution();
                    break;
                case GameServiceConstants.SM_GET_FAMILY_LIMIT_NUM:
                    refresh();
                    break;
                default :
                    break;
            }
        }

        override public function destroy():void
        {
            SchoolShopManager.currentPage = 1;
            SchoolShopManager.totalPage = 1;
            SchoolShopEvent.removeEventListener(SchoolShopEvent.CHANGE_PAGE, onPageEvt);
            if (_mouseHandler)
            {
                _mouseHandler.destroy();
                _mouseHandler = null;
            }
            if (_schoolShopItems)
            {
                ObjectUtils.forEach(_schoolShopItems, function (obj:SchoolShopItem):void
                {
                    if (_container.contains(obj))
                    {
                        _container.removeChild(obj);
                        obj.destroy();
                        obj = null;
                    }
                });
                _schoolShopItems.length = 0;
                _schoolShopItems = null;
            }
            if (_dataItems)
            {
                _dataItems.forEach(function (element:SchoolShopCfgData, index:int, vec:Vector.<SchoolShopCfgData>):void
                {
                    element = null;
                });
                _dataItems.length = 0;
                _dataItems = null;
            }
            super.destroy();
        }
		
		override protected function attach():void
		{
			SchoolElseDataManager.getInstance().attach(this);
			SchoolShopManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			SchoolElseDataManager.getInstance().detach(this);
			SchoolShopManager.instance.detach(this);
			super.detach();
		}
		
	}
}
