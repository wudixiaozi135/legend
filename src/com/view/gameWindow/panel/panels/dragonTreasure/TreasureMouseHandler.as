package com.view.gameWindow.panel.panels.dragonTreasure
{
    import com.model.consts.StringConst;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.dragonTreasure.constant.TreasureTabType;
    import com.view.gameWindow.panel.panels.dragonTreasure.treasureShop.TreasureShopManager;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UIUnlockHandler;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
    import com.view.gameWindow.util.JsUtils;
    import com.view.gameWindow.util.SimpleStateButton;
    
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.events.TextEvent;

    /**
	 * Created by Administrator on 2014/11/29.
	 */
	public class TreasureMouseHandler
	{
		private var _panel:PanelTreasure;
		private var _skin:McTreasurePanel;
		private var _unlock:UIUnlockHandler;

		public function TreasureMouseHandler(panel:PanelTreasure)
		{
			_panel = panel;
			_skin = _panel.skin as McTreasurePanel;

			_skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
//            SimpleStateButton.addLinkState(_skin.txtAllProps, StringConst.PANEL_DRAGON_TREASURE_001, "allProps");
//			_skin.txtAllProps.addEventListener(TextEvent.LINK, onLinkHandler, false, 0, true);
			firstClick();
			_unlock = new UIUnlockHandler(getUnlockBtn,0);
			_unlock.updateUIStates([UnlockFuncId.DRAGEON_TREASURE_M,UnlockFuncId.DRAGEON_TREASURE_H]);

            SimpleStateButton.addLinkState(_skin.txtShop, StringConst.PANEL_DRAGON_TREASURE_008, "scoreShop");
            _skin.txtShop.addEventListener(TextEvent.LINK, onLinkHandler, false, 0, true);
		}
		
		private function getUnlockBtn(id:int):*
		{
			if(id == UnlockFuncId.DRAGEON_TREASURE_M)
			{
				return [_skin.tab1,_skin.middleBtn];
			}
			else if(id == UnlockFuncId.DRAGEON_TREASURE_H)
			{
				return [_skin.tab2,_skin.advanceBtn];
			}
			
			return null;
		}
		

		/**查看所有物品信息*/
		private function onLinkHandler(event:TextEvent):void
		{
            if (event.text == "allProps")
            {
                PanelMediator.instance.openPanel(PanelConst.TYPE_DRAGON_TREASURE_REWARD);
            } else if (event.text == "scoreShop")
            {
                openTreasureShop();
            }
		}

		private function firstClick():void
		{
			dealClick(_skin.tab0, TreasureTabType.TAB_0);
		}

		private function onClick(event:MouseEvent):void
		{
			var cfgType:int = DragonTreasureManager.instance.getTypeBySelectIndex();
			switch (event.target)
			{
                case _skin.btnCharge:
                    dealCharge();
                    break;
				case _skin.closeBtn:
					closeHandler();
					break;
				case _skin.tab0:
					dealClick(_skin.tab0, TreasureTabType.TAB_0);
					break;
				case _skin.tab1:
					if(!_unlock.onClickUnlock(UnlockFuncId.DRAGEON_TREASURE_M))
					{
						_skin.tab1.selected = false;
						return;
					}
					dealClick(_skin.tab1, TreasureTabType.TAB_1);
					break;
				case _skin.tab2:
					if(!_unlock.onClickUnlock(UnlockFuncId.DRAGEON_TREASURE_H))
					{
						_skin.tab2.selected = false;
						return;
					}
					dealClick(_skin.tab2, TreasureTabType.TAB_2);
					break;
				case _skin.btnTreasure1:
					DragonTreasureManager.instance.sendFindTreasure(cfgType, DragonTreasureManager.COUNT_1);
					break;
				case _skin.btnTreasure10:
					DragonTreasureManager.instance.sendFindTreasure(cfgType, DragonTreasureManager.COUNT_5);
					break;
				case _skin.btnTreasure50:
					DragonTreasureManager.instance.sendFindTreasure(cfgType, DragonTreasureManager.COUNT_10);
					break;
				case _skin.btnVolume:
					openTreasureWareHouse();
					break;
				default :
					break;
			}
		}

        private function dealCharge():void
        {
            JsUtils.callRecharge();
        }

		private function openTreasureWareHouse():void
		{
			PanelMediator.instance.switchPanel(PanelConst.TYPE_DRAGON_TREASURE_WAREHOUSE);
		}


		private function openTreasureShop():void
		{
			TreasureShopManager.instance.dealTreasureShopPanel();
		}

		private function dealClick(tab:MovieClip, index:int):void
		{
			var lastMc:MovieClip = DragonTreasureManager.lastMc;
			if (!lastMc) return;
			if (lastMc)
			{
				lastMc.selected = false;
				lastMc.mouseEnabled = true;
			}
			tab.selected = true;
			tab.mouseEnabled = false;
			lastMc = tab;
			DragonTreasureManager.lastMc = lastMc;
			DragonTreasureManager.selectIndex = index;

//			DragonTreasureEvent.dispatchEvent(new DragonTreasureEvent(DragonTreasureEvent.SWITCH_TAB));
		}

		private function closeHandler():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_DRAGON_TREASURE);
		}

		public function destroy():void
		{
			if(_unlock)
			{
				_unlock.destroy();
				_unlock = null;
			}
			if (_skin)
			{
//                SimpleStateButton.removeState(_skin.txtAllProps);
//                SimpleStateButton.removeState(_skin.txtShop);
//				_skin.txtAllProps.removeEventListener(TextEvent.LINK, onLinkHandler);
//                _skin.txtShop.removeEventListener(TextEvent.LINK, onLinkHandler);
				_skin.removeEventListener(MouseEvent.CLICK, onClick);
				_skin = null;
			}
			if (_panel)
			{
				_panel = null;
			}
		}
	}
}
