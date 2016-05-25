package com.view.gameWindow.panel.panels.equipRecycle
{
    import com.model.configData.ConfigDataManager;
    import com.model.consts.EffectConst;
    import com.model.consts.StringConst;
    import com.model.frame.FrameManager;
    import com.model.frame.IFrame;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.flyEffect.FlyEffectMediator;
    import com.view.gameWindow.mainUi.subuis.bottombar.ExpRecorder;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.McEquipRecycle;
    import com.view.gameWindow.panel.panels.bag.BagData;
    import com.view.gameWindow.panel.panels.bag.cell.BagCell;
    import com.view.gameWindow.panel.panels.exchangeShop.ExchangeShopDataManager;
    import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.RectRim;
    import com.view.gameWindow.util.SimpleStateButton;
    import com.view.gameWindow.util.UIEffectLoader;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.events.TextEvent;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;

    public class EquipRecycleMouseHandle implements IFrame
    {
        private var _panel:PanelEquipRecycle;
        private var _skin:McEquipRecycle;
        private var _equipRecycleFilterHandle:EquipRecycleFilterHandle;
		private var _bagCells:Vector.<BagCell>;

        public function EquipRecycleMouseHandle(panel:PanelEquipRecycle)
        {
            _panel = panel;
            _skin = _panel.skin as McEquipRecycle;
            FrameManager.instance.addObj(this);
			_bagCells = _panel.viewhandle._equipRecycleCellHandle.bagCells;
            SimpleStateButton.addLinkState(_skin.txtExchange, StringConst.EXCHANGE_SHOP_0021, "exchangeShop");
            _skin.txtExchange.addEventListener(TextEvent.LINK, onLinkEvt, false, 0, true);
        }

        private function onLinkEvt(event:TextEvent):void
        {
            if (event.text == "exchangeShop")
            {
                ExchangeShopDataManager.instance.dealSwitchPanel();
            }
        }

        public function init(rsrLoader:RsrLoader):void
        {
            _equipRecycleFilterHandle = new EquipRecycleFilterHandle(_panel);
            _equipRecycleFilterHandle.init(rsrLoader);
            rsrLoader.addCallBack(_skin.singalRecycleBtn, function (mc:MovieClip):void
            {
                mc.addEventListener(MouseEvent.CLICK, onClick);
                mc.txt.text = StringConst.EQUIPRECYCLE_PANEL_0016;
            });

            rsrLoader.addCallBack(_skin.allRecycleBtn, function (mc:MovieClip):void
            {
                mc.addEventListener(MouseEvent.CLICK, onClick);
                mc.txt.text = StringConst.EQUIPRECYCLE_PANEL_0017;
				InterObjCollector.instance.add(mc);
				InterObjCollector.autoCollector.add(mc);
				
				_panel.viewhandle.initRecycleGuide();
				
				
            });

            _skin.mcReward.addEventListener(MouseEvent.CLICK, onClick);
			rsrLoader.addCallBack( _skin.closeBtn,function(mc:MovieClip):void
			{
				mc.addEventListener(MouseEvent.CLICK, onClick);
			}
			);
        }

        private function onClick(e:MouseEvent):void
        {
            switch (e.target)
            {
                case _skin.singalRecycleBtn:
                {
                    var selectData:BagData = EquipRecycleDataManager.instance.selectData;
					var recycleDatas:Vector.<BagData> = new Vector.<BagData>();
					var rectRim:RectRim = EquipRecycleDataManager.instance._rectRim;
                    if (!selectData)
                    {
                        RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.EQUIPRECYCLE_PANEL_0009);
                        return;
                    }
					EquipRecycleDataManager.oneKeyRecycle = true;
					showBagEffect(rectRim.x + rectRim.width/2,rectRim.y + rectRim.height/2);
					showEquipEffect();
					recycleDatas.push(selectData);
                    ExpRecorder.storeData();
                    EquipRecycleDataManager.instance.requestEquipRecycle(recycleDatas, 1);
                    break;
                }
                case _skin.allRecycleBtn:
                {
                    EquipRecycleDataManager.instance.isAllRecycle = true;
                    _panel.viewhandle.clearCells();
                    var realEquipRecycleDatas:Vector.<BagData> = EquipRecycleDataManager.instance.realEquipRecycleDatas;
                    if (realEquipRecycleDatas.length == 0)
                    {
                        RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.EQUIPRECYCLE_PANEL_0010);
                    }
                    else
                    {
						var i:int = 0;
						var length:int;
						EquipRecycleDataManager.oneKeyRecycle = true;
						showEquipEffect();
                        ExpRecorder.storeData();
						EquipRecycleDataManager.instance.requestEquipRecycle(realEquipRecycleDatas, 2);
						length = realEquipRecycleDatas.length - 35*(EquipRecycleDataManager.instance._page - 1);
						for (;i<_bagCells.length;i++)
						{
							if(i<=length-1)
							{
								showBagEffect(_bagCells[i].x + _bagCells[0].width / 2, _bagCells[i].y + _bagCells[0].height / 2);
							}	 						
						}
                    }

                    var id:int = setTimeout(function ():void
                    {
                        EquipRecycleDataManager.instance.isAllRecycle = false;
                        clearTimeout(id);
                    }, 5000);
                    break;
                }
                case _skin.mcReward:
                {
                    var index:int = EquipRecycleDataManager.instance.currentIndex;
                    var reincarn:int = RoleDataManager.instance.reincarn;
                    var rewardPoint:int = ConfigDataManager.instance.equipRecycleRwdCfgData(reincarn, index).reward_point;
                    EquipRecycleDataManager.instance.equipRecycleGetDailyReward(rewardPoint);
                    break;
                }
                case _skin.closeBtn:
                {
                    PanelMediator.instance.closePanel(PanelConst.TYPE_EQUIP_RECYCLE);
                    break;
                }
            }
        }

        internal function destroy():void
        {
            FrameManager.instance.removeObj(this);
            if (_skin)
            {
                _skin.allRecycleBtn.removeEventListener(MouseEvent.CLICK, onClick);
                _skin.singalRecycleBtn.removeEventListener(MouseEvent.CLICK, onClick);
                _skin.mcReward.removeEventListener(MouseEvent.CLICK, onClick);
                _skin.closeBtn.removeEventListener(MouseEvent.CLICK, onClick);

                SimpleStateButton.removeState(_skin.txtExchange);
                _skin.txtExchange.removeEventListener(TextEvent.LINK, onLinkEvt);
				
				InterObjCollector.instance.remove(_skin.allRecycleBtn);
				InterObjCollector.autoCollector.remove(_skin.allRecycleBtn);
            }
            _equipRecycleFilterHandle.destroy();
            _equipRecycleFilterHandle = null;
            _panel = null;
            _skin = null;
        }

        public function updateTime(time:int):void
        {
            var play:Boolean = EquipRecycleDataManager.playEffect;
            if (play)
            {
                FlyEffectMediator.instance.doEquipRecycleEffect(false);
                EquipRecycleDataManager.instance.resetPlay();
//                EquipRecycleDataManager.instance.awardInfo = [0, 0, 0];
            }
//            var totalExpShow:Boolean = EquipRecycleDataManager.totalExpShow;
//            if (totalExpShow && EquipRecycleDataManager.oneKeyRecycle)
//            {
//                FlyEffectMediator.instance.doEquipRecycleEffect(false);
//                EquipRecycleDataManager.totalExpShow = false;
//
//                EquipRecycleDataManager.instance.resetPlay();
//                EquipRecycleDataManager.instance.awardInfo = [0, 0, 0];
//            }
        }
		
		private function showBagEffect(x:int,y:int):void
		{
			var sprite:Sprite = new Sprite;
			_skin.addChild(sprite);
			var _uiEffectLoader:UIEffectLoader = new UIEffectLoader(sprite,x,y,1,1,EffectConst.RES_EQUIPRECYCLE_ALL,null,true);
		}
		private function showEquipEffect():void
		{
			var sprite2:Sprite = new Sprite;
			_skin.addChild(sprite2);
			var _uiEffectLoader:UIEffectLoader = new UIEffectLoader(sprite2,_skin.mcIcon.x + _skin.mcIcon.width/2,_skin.mcIcon.y + _skin.mcIcon.height/2,1,1,EffectConst.RES_EQUIPRECYCLE_SINGEL,null,true);
		}
    }
}