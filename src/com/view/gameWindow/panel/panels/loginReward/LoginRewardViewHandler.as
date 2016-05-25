package com.view.gameWindow.panel.panels.loginReward
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.EffectConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.flyEffect.FlyEffectMediator;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.loginReward.item.LoginRewardItem;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.UIEffectLoader;
    import com.view.gameWindow.util.cell.IconCellEx;
    import com.view.gameWindow.util.cell.ThingsData;

    import flash.display.Bitmap;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.filters.GlowFilter;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    /**
     * Created by Administrator on 2015/2/26.
     */
    public class LoginRewardViewHandler implements IObserver
    {
        private var _panel:PanelLoginReward;
        private var _skin:McLoginReward;
        private var _totalRewards:Array;

        private var _rewardItems:Dictionary;

        private var _rsrLoader:RsrLoader;

        private var _iconExs:Vector.<IconCellEx>;
        private var _dts:Vector.<ThingsData>;

        private var _shape:Shape;//选中框
        private var _flyDatas:Array = [];

        private var _btnEffect:UIEffectLoader;
        private var _btnEffectContainer:Sprite;

        public function LoginRewardViewHandler(panel:PanelLoginReward)
        {
            _panel = panel;
            _skin = _panel.skin as McLoginReward;
            _totalRewards = LoginRewardDataManager.instance.getTotalRewards();
            _rewardItems = new Dictionary();
            _rsrLoader = new RsrLoader();

            _skin.addChild(_btnEffectContainer = new Sprite());
            _btnEffectContainer.mouseEnabled = false;
            _btnEffectContainer.mouseChildren = false;
            _btnEffect = new UIEffectLoader(_btnEffectContainer, 0, 0, 1, 1, EffectConst.RES_CHARGE_BTN_EFFECT);
            _btnEffectContainer.x = _skin.btnGet.x - ((168 - _skin.btnGet.width) >> 1);
            _btnEffectContainer.y = _skin.btnGet.y - ((85.5 - _skin.btnGet.height) >> 1) - 2;
            _btnEffectContainer.visible = false;

            _shape = new Shape();//黄色选中框
            _shape.graphics.clear();
            _shape.graphics.lineStyle(2, 0xffcc00, 1);
            _shape.graphics.drawCircle(18.5, 18.5, 37);
            _shape.graphics.endFill();
            _shape.filters = [new GlowFilter(0xffff00, 1, 6, 6, 5, 1)];
            _shape.visible = false;
            _skin.container.addChild(_shape);

            initIcons();
            initDatas();
            LoginRewardDataManager.instance.attach(this);
            refresh();
        }

        private function initDatas():void
        {
            _iconExs = new Vector.<IconCellEx>();
            _dts = new Vector.<ThingsData>();
            for (var i:int = 0; i < 6; i++)
            {
                var cell:IconCellEx = new IconCellEx(_skin["icon" + (i + 1)], 0, 0, 60, 60);
                _iconExs.push(cell);

                var dt:ThingsData = new ThingsData();
                _dts.push(dt);
            }
        }

        private function initIcons():void
        {
            ///初始所有的icon
            for (var i:int = 0; i < 15; i++)
            {
                var item:LoginRewardItem = new LoginRewardItem(i + 1);
                _skin.container.addChild(item);
                _rewardItems[i + 1] = item;
                item.clickHandler = clickItemHandler;
            }
        }

        private function clickItemHandler(item:LoginRewardItem):void
        {
            LoginRewardDataManager.selectDay = item.day;

            for each(var icon:LoginRewardItem in _rewardItems)
            {
                icon.hightLight = false;
                icon.selected(false);
            }
            if (item.state == 0)
            {
                item.hightLight = true;
            }
            setBigIcon(item.day);

            if (item.hightLight == false)
            {
                var rect:Rectangle = item.getBgRect();
                _shape.x = item.x + rect.width * .5 - 19;
                _shape.y = item.y + rect.height * .5 - 2;
                _shape.visible = true;
            } else
            {
                _shape.visible = false;
            }
            setSmallIcons(item.day);

            if (item.state == 1)
            {
                _skin.btnGet.visible = false;
            } else if (item.state == 0)
            {
                _skin.btnGet.visible = true;
            } else if (item.state == -1)
            {
                _skin.btnGet.visible = false;
            }
            _btnEffectContainer.visible = _skin.btnGet.visible;
        }

        public function updatePageBtns():void
        {
            var page:int = LoginRewardDataManager.currentPage;
            var total:int = LoginRewardDataManager.totalPage;
            if (page <= 1)
            {
                _skin.btnLeft.btnEnabled = false;
                _skin.btnRight.btnEnabled = true;
            } else if (page < total)
            {
                _skin.btnLeft.btnEnabled = true;
                _skin.btnRight.btnEnabled = true;
            } else if (page == total)
            {
                _skin.btnLeft.btnEnabled = true;
                _skin.btnRight.btnEnabled = false;
            }
            if (_shape)
            {
                _shape.visible = false;
            }
            refreshTitleIcon();
        }

        /**刷新标题Icons*/
        private function refreshTitleIcon():void
        {
            var page:int = LoginRewardDataManager.currentPage;
            var pageNum:int = LoginRewardDataManager.pageNum;
            var startIndex:int = 0;
            if (page > 1)
            {
                startIndex = (page - 1) * pageNum + 1;
            } else
            {
                startIndex = page + (page - 1) * pageNum;
            }

            for each(var item:LoginRewardItem in _rewardItems)
            {
                item.visible = false;
            }

            var pos:int = 0;
            var len:int = startIndex + 4;
            var icon:LoginRewardItem;
            for (var i:int = startIndex; i <= len; i++)
            {
                icon = _rewardItems[i];
                icon.visible = true;
                icon.x = (75 + 54) * pos;
                pos++;
            }
        }

        private function setBigIcon(day:int):void
        {
            _skin.iconContainer.icon.resUrl = "loginReward/reward_" + day + ResourcePathConstants.POSTFIX_JPG;
            _rsrLoader.load(_skin.iconContainer, ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
        }

        private function setSmallIcons(day:int):void
        {
            destroyTips();
            //id:type:count:job:sex
            var arr:Array = _totalRewards[day - 1];
            var dt:ThingsData, icon:IconCellEx;
            for (var i:int = 0; i < 6; i++)
            {
                if (i < arr.length)
                {
                    icon = _iconExs[i];
                    dt = _dts[i];

                    dt.id = arr[i][0];
                    dt.type = arr[i][1];
                    dt.count = arr[i][2];
                    IconCellEx.setItemByThingsData(icon, dt);
                    ToolTipManager.getInstance().attach(icon);
                }
            }
        }

        public function update(proc:int = 0):void
        {
            if (proc == GameServiceConstants.SM_FIFTEEN_REWARD_GET)
            {
                refresh();
            } else if (proc == GameServiceConstants.CM_FIFTEEN_REWARD_GET)
            {
                handlerSuccess();
            }
        }

        private function handlerSuccess():void
        {
            if (_flyDatas)
            {
                FlyEffectMediator.instance.doFlyReceiveThings2(_flyDatas);
            }
            if (LoginRewardDataManager.instance.checkHasReward() == false)
            {
                PanelMediator.instance.closePanel(PanelConst.TYPE_LOGIN_REWARD_PANEL);
            }
        }

        /**飘物品数据*/
        public function storeBitmaps():void
        {
            destroyFlyDatas();
            _iconExs.forEach(function (element:IconCellEx, index:int, vec:Vector.<IconCellEx>):void
            {
                var bmp:Bitmap = element.getBitmap();
                if (bmp)
                {
                    bmp.width = bmp.height = 40;
                    bmp.name = element.id.toString();
                    bmp.visible = false;
                    element.addChild(bmp);
                    _flyDatas.push(bmp);
                }
            });
        }

        public function refresh():void
        {
            var loginDays:int = LoginRewardDataManager.instance.loginDays;
            if (_skin.txtDay)
            {
                _skin.txtDay.text = loginDays + "/" + LoginRewardDataManager.totalDays;
            }

            var totalRecord:Array = LoginRewardDataManager.instance.dayRecords;
            var loginItem:LoginRewardItem;
            for (var i:int = 0; i < 15; i++)
            {
                loginItem = _rewardItems[i + 1];
                loginItem.state = totalRecord[i];
                loginItem.refresh();
            }
            if (LoginRewardDataManager.instance.checkHasReward())
            {
                lockCanGetReward();
            }
        }

        /**锁定到第一个可以领取的奖励*/
        public function lockCanGetReward():void
        {
            var day:int = LoginRewardDataManager.flagDay;
            if (day == -1)
            {
                return;
            }

            if (day >= 1 && day <= 5)
            {
                LoginRewardDataManager.currentPage = 1;
            } else if (day >= 6 && day <= 10)
            {
                LoginRewardDataManager.currentPage = 2;
            } else if (day >= 11 && day <= 15)
            {
                LoginRewardDataManager.currentPage = 3;
            }
            updatePageBtns();
            setBigIcon(day);
            setSmallIcons(day);

            var record:Array = LoginRewardDataManager.instance.dayRecords;
            if (_rewardItems[day])
            {
                if (record[day - 1] != -1)
                {
                    _rewardItems[day].hightLight = true;
                    _skin.btnGet.visible = true;
                } else if (record[day - 1] == -1)
                {
                    _rewardItems[day].hightLight = false;
                    _skin.btnGet.visible = false;
                }
                clickItemHandler(_rewardItems[day]);
            }
            LoginRewardDataManager.selectDay = day;
        }

        private function destroyTips():void
        {
            _iconExs.forEach(function (element:IconCellEx, index:int, vec:Vector.<IconCellEx>):void
            {
                element.setNull();
                ToolTipManager.getInstance().detach(element);
            });
        }

        private function destroyFlyDatas():void
        {
            if (_flyDatas)
            {
                _flyDatas.forEach(function (element:Bitmap, index:int, arr:Array):void
                {
                    if (element.parent)
                    {
                        element.parent.removeChild(element);
                        if (element.bitmapData)
                        {
                            element.bitmapData.dispose();
                        }
                        element = null;
                    }
                });
                _flyDatas.length = 0;
            }
        }

        public function destroy():void
        {
            LoginRewardDataManager.instance.detach(this);
            destroyFlyDatas();
            if (_btnEffect)
            {
                _btnEffect.destroy();
                _btnEffect = null;
            }
            if (_btnEffectContainer && _btnEffectContainer.parent)
            {
                _skin.removeChild(_btnEffectContainer);
                _btnEffectContainer = null;
            }
            if (_flyDatas)
            {
                _flyDatas = null;
            }
            if (_rsrLoader)
            {
                _rsrLoader.destroy();
                _rsrLoader = null;
            }
            if (_totalRewards)
            {
                _totalRewards.length = 0;
                _totalRewards = null;
            }

            if (_iconExs)
            {
                destroyTips();
                _iconExs.forEach(function (element:IconCellEx, index:int, vec:Vector.<IconCellEx>):void
                {
                    element.destroy();
                    element = null;
                });
                _iconExs.length = 0;
                _iconExs = null;
            }
            if (_dts)
            {
                _dts.forEach(function (element:ThingsData, index:int, vec:Vector.<ThingsData>):void
                {
                    element = null;
                });
                _dts.length = 0;
                _dts = null;
            }

            if (_rewardItems)
            {
                for each(var item:LoginRewardItem in _rewardItems)
                {
                    if (_skin && _skin.container.contains(item))
                    {
                        _skin.container.removeChild(item);
                        item.destroy();
                        item = null;
                    }
                }
                _rewardItems = null;
            }
            if (_skin)
            {
                _skin = null;
            }
            if (_panel)
            {
                _panel = null;
            }
        }
    }
}
