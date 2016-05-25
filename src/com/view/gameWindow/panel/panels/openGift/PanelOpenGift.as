package com.view.gameWindow.panel.panels.openGift
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.CountCallback;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subuis.actvEnter.ActvEnter;
    import com.view.gameWindow.mainUi.subuis.actvEnter.McActvEnter;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.IPanelTab;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.openActivity.McOpenActivity;
    import com.view.gameWindow.panel.panels.openGift.cheapGift.CheapGift;
    import com.view.gameWindow.panel.panels.openGift.dailyReward.OpenServerDailyReward;
    import com.view.gameWindow.panel.panels.openGift.data.OpenServiceActivityDatamanager;
    import com.view.gameWindow.panel.panels.openGift.journeyReward.JourneyReward;
    import com.view.gameWindow.panel.panels.openGift.newReward.NewReward;
    import com.view.gameWindow.panel.panels.openGift.promote.PromoteReward;
    import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
    
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.text.TextField;

    public class PanelOpenGift extends PanelBase implements IPanelTab
	{
		private var _lastBtn:MovieClip;
		private var giftPanel:CheapGift;
		private var dailyReward:OpenServerDailyReward;
		private var journeyReward:JourneyReward;
		private var promoteReward:PromoteReward;
		private var newReward:NewReward;
		private var _initAfterTabBtnLoadedHandler:CountCallback;
        private var _defalutIndex:int = -1;
        private var _defaultSubIndex:int = -1;
		private static const GIFT:int = 1;
		private static const DAILY:int = 1;
		private static const JOURNEY:int = 2;
		private static const PROMOTE:int = 3;
		private static const NEW_REWARD:int = 4;
		public function PanelOpenGift()
		{
			OpenServiceActivityDatamanager.instance.attach(this);
			_initAfterTabBtnLoadedHandler = new CountCallback(initAfterTabBtnLoaded,8);
		}
		
		override public function update(proc:int = 0):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_SPECIALPREFERENCEREWORD_GET:
					if(giftPanel)
						giftPanel.viewHandler.dealSelectTab();
					break;
				case GameServiceConstants.CM_SPECIAL_PREFERENCE_REWARD_GET:
					if(giftPanel)
						giftPanel.viewHandler.showGetEffect();
					break;
				case GameServiceConstants.SM_OPEN_SERVER_DAILY_LIST:
					if(dailyReward)
						dailyReward.viewHandler.refreshData();
					refreshCount();
					break;
				case GameServiceConstants.SM_OPEN_SERVER_JOURNEY_LIST:
					if(journeyReward)
						journeyReward.viewHandler.refreshData();
					refreshCount();
					break;
				case GameServiceConstants.SM_OPEN_SERVER_PROMOTE_LIST:
					if(promoteReward)
						promoteReward.viewHandler.refreshData();
					refreshCount();
					break;
				case GameServiceConstants.SM_OPEN_SERVER_NEW_LIST:
					if(newReward)
						newReward.viewHandler.refreshData();
					refreshCount();
					break;
				case GameServiceConstants.CM_GET_OPEN_SERVER_DAILY:
					if(dailyReward)
						dailyReward.viewHandler.handlerSuccess();
					break;
				case GameServiceConstants.CM_GET_OPEN_SERVER_JOURNEY:
					if(journeyReward)
						journeyReward.viewHandler.handlerSuccess();
					break;
				case GameServiceConstants.CM_GET_OPEN_SERVER_PROMOTE:
					if(promoteReward)
						promoteReward.viewHandler.handlerSuccess();
					break;
				case GameServiceConstants.CM_BUY_OPEN_SERVER_NEW:
					if(newReward)
						newReward.viewHandler.handlerSuccess();
					break;
			}
		}
		
		private function refreshCount():void
		{
			// TODO Auto Generated method stub
			var numArr:Array = OpenServiceActivityDatamanager.instance.getCanGetReward();
			var skin:McOpenActivity = _skin as McOpenActivity;
			for(var i:int = 0;i<numArr.length;i++)
			{
				skin.tabList["txt"+(i+1)+"Count"].text = numArr[i] +"";
				skin.tabList["txt"+(i+1)+"Count"].visible = skin.tabList["txt"+(i+1)+"BG"].visible = Boolean(numArr[i]);
			}
		}
		
		override protected function initSkin():void
		{
			var skin:McOpenActivity = new McOpenActivity;
			setTitleBar(skin.mcTitleBar);
			skin.txtName.text = StringConst.PANEL_OPEN_GIFT_001;
			skin.txtName.mouseEnabled = false;
			_skin = skin;
			addChild(skin);
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			_skin.tabList.addEventListener(MouseEvent.CLICK,onTabClick);
			for(var i:int = 0;i<4;i++)
			{
				skin.tabList["txt"+(i+1)+"Count"].mouseEnabled = skin.tabList["txt"+(i+1)+"BG"].mouseEnabled = false;
			}
		}
		
		override protected function initData():void
		{
//			OpenServiceActivityDatamanager.instance.checkGetOver();
			refreshTabPosition();
		}
		
		private function refreshTabPosition():void
		{
			// TODO Auto Generated method stub
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var skin:McOpenActivity = _skin as McOpenActivity;
			switch(event.target)
			{
				case skin.tab0:
					dealBtn(1,skin.tab0);
					break;
				case skin.tab1:
					dealBtn(2,skin.tab1);
					break;
				case skin.tab2:
					dealBtn(3,skin.tab2);
					break;
				case skin.tab3:
					dealBtn(4,skin.tab3);
					break;
				case skin.tab4:
					dealBtn(5,skin.tab4);
					break;
				case skin.tab5:
					dealBtn(6,skin.tab5);
					break;
				case skin.tab6:
					dealBtn(7,skin.tab6);
					break;
				case skin.tab7:
					dealBtn(8,skin.tab7);
					break;
				case skin.closeBtn:
					PanelMediator.instance.closePanel(PanelConst.TYPE_OPEN_GIFT_PANEL);
					break;
			}
		}
		
		private function onTabClick(event:MouseEvent):void
		{
			// TODO Auto Generated method stub
			switch(event.target)
			{
				case skin.tabList.tab1:
					dealTab(1,skin.tabList.tab1);
					break;
				case skin.tabList.tab2:
					dealTab(2,skin.tabList.tab2)
					break;
				case skin.tabList.tab3:
					dealTab(3,skin.tabList.tab3)
					break;
				case skin.tabList.tab4:
					dealTab(4,skin.tabList.tab4)
					break;
			}
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			//StorageDataMannager.instance.queryStoreitems(0);
			var skin:McOpenActivity = _skin as McOpenActivity;
			for(var i:int=0;i<8;i++)
			{
				rsrLoader.addCallBack(_skin["tab"+i],function(mc:MovieClip):void
				{
					_initAfterTabBtnLoadedHandler.call();
				});
			}
			
			for(i = 0;i<4;i++)
			{
				rsrLoader.addCallBack(skin.tabList["tab"+(i+1)],getFun(i+1));
			}
			
			rsrLoader.addCallBack(skin.txtBossBG,function(mc:MovieClip):void
			{
				mc.mouseEnabled = false;
				skin.txtBossCount.mouseEnabled =false;
			});
			
			
			rsrLoader.addCallBack(skin.txtLvBG,function(mc:MovieClip):void
			{
				mc.mouseEnabled = false;
				skin.txtLvCount.mouseEnabled =false;
			});
		}
		
		private var tabOk:Boolean;
		private function getFun(index:int):Function
		{
			var skin:McOpenActivity = _skin as McOpenActivity;
			var func:Function = function(mc:MovieClip):void
			{
//				var selectTab:int = OpenServiceActivityDatamanager.instance.selectTab;
				var textField:TextField = skin.tabList["tab"+index+"Txt"] as TextField;
				textField.mouseEnabled =false;
				textField.text = StringConst["PANEL_OPEN_GIFT_TAB_00"+index];
				if(index == 1)
					tabOk = true;
			}
			return func;
		}
		
		private function initAfterTabBtnLoaded():void
		{
			var day:int = WelfareDataMannager.instance.openDay+1;
			for(var i:int = 0;i<7;i++)
			{
				if((i+1)<=day)
				{
					skin["tab"+(i+1)].visible = true;
					skin["pic"+(i+1)].visible = true;
				}
				else
				{
					skin["tab"+(i+1)].visible = false;
					skin["pic"+(i+1)].visible = false;
				}
			}
			skin.tabList.visible = false;
			dealBtn(1,skin.tab0);
		}
		
		public function dealBtn(_index:int,nowBtn:MovieClip):void
		{
			if(nowBtn == _lastBtn)
				return;
			
			if(_lastBtn)
			{
				_lastBtn.selected = false;
				_lastBtn.mouseEnabled = true;
			}
			nowBtn.selected = true;
			nowBtn.mouseEnabled = false;
			_lastBtn = nowBtn;
			
			if(_index!=1)
			{
				OpenServiceActivityDatamanager.instance.curDay = _index -1;
				OpenServiceActivityDatamanager.instance.askALL();
			}
			showPanel(_index);
			if(lastTab)
			{
				lastTab.selected = false;
				lastTab.mouseEnabled = true;
			}
			if(tabOk)
			{
				skin.tabList.tab1.selected = true;
				skin.tabList.tab1.mouseEnabled = false;
				lastTab = skin.tabList.tab1;
			}
		}
		
		private var lastTab:MovieClip;
		private function dealTab(index:int,mc:MovieClip):void
		{
			if(mc == lastTab)
				return;
			
			if(lastTab)
			{
				lastTab.selected = false;
				lastTab.mouseEnabled = true;
			}
			mc.selected = true;
			mc.mouseEnabled = false;
			lastTab = mc;
			showPanel(0,index);
		}
		
		private function showPanel(index:int,tab:int = 1):void
		{
			// TODO Auto Generated method stub
			hideAll();
			if(index == GIFT)
			{
				skin.tabList.visible = false;
				if(!giftPanel)
				{
					giftPanel = new CheapGift();
					addChild(giftPanel);
					giftPanel.x = 172;
					giftPanel.y = 50;
                    giftPanel.defaultIndex = _defaultSubIndex;
                    if (_defaultSubIndex != -1)
                    {
                        giftPanel.mouseHandler.setCur(_defaultSubIndex);
                        giftPanel.viewHandler.deal(giftPanel.skin.btnHead, _defaultSubIndex);
                        _defaultSubIndex = -1;
                    }
				}
			}
			else
			{
				skin.tabList.visible = true;
				if(tab == DAILY)
				{
					OpenServiceActivityDatamanager.instance.getDailyInfo();
					if(!dailyReward)
					{
						dailyReward = new OpenServerDailyReward();
						addChild(dailyReward);
						dailyReward.x = 173;
						dailyReward.y = 50;
					}
				}
				else if(tab == JOURNEY)
				{
					OpenServiceActivityDatamanager.instance.getJourneyInfo();
					if(!journeyReward)
					{
						journeyReward = new JourneyReward();
						addChild(journeyReward);
						journeyReward.x = 172;
						journeyReward.y = 50;
					}
				}
				else if(tab == PROMOTE)
				{
					OpenServiceActivityDatamanager.instance.getPromoteInfo();
					if(!promoteReward)
					{
						promoteReward = new PromoteReward();
						addChild(promoteReward);
						promoteReward.x = 172;
						promoteReward.y = 50;
					}
				}
				else if(tab == NEW_REWARD)
				{
					OpenServiceActivityDatamanager.instance.getNewInfo();
					if(!newReward)
					{
						newReward = new NewReward();
						addChild(newReward);
						newReward.x = 173;
						newReward.y = 50;
					}
				}
				addChild(skin.tabList);
			}
		}
		
		private function hideAll():void
		{
			// TODO Auto Generated method stub
			if(giftPanel)
			{
				giftPanel.parent.removeChild(giftPanel);
				giftPanel.destroy();
				giftPanel = null;
			}
			if(dailyReward)
			{
				dailyReward.parent.removeChild(dailyReward);
				dailyReward.destroy();
				dailyReward = null;
			}
			if(journeyReward)
			{
				journeyReward.parent.removeChild(journeyReward);
				journeyReward.destroy();
				journeyReward = null;
			}
			if(promoteReward)
			{
				promoteReward.parent.removeChild(promoteReward);
				promoteReward.destroy();
				promoteReward = null;
			}
			
			if(newReward)
			{
				newReward.parent.removeChild(newReward);
				newReward.destroy();
				newReward = null;
			}
		}
		
		
		override public function setPostion():void
		{
			var mc:McActvEnter = (MainUiMediator.getInstance().actvEnter as ActvEnter).skin as McActvEnter;
			if (mc)
			{
				var popPoint:Point = mc.localToGlobal(new Point(mc.mcBtns.mcLayer.btnOpenActivity.x + 15, mc.mcBtns.mcLayer.btnOpenActivity.y + 15));
				isMount(true, popPoint.x, popPoint.y);
			} else
			{
				isMount(true);
			}
		}
		
		override public function destroy():void
		{
			hideAll();
			skin.removeEventListener(MouseEvent.CLICK,onClick);
			skin.parent.removeChild(skin);
			OpenServiceActivityDatamanager.instance.detach(this);
			super.destroy();
		}

        /**调用子tab*/
        public function setSubTabIndex(index:int):void
        {
            _defaultSubIndex = index;
        }

        /**调用面板tab*/
        public function setTabIndex(index:int):void
        {
            _defalutIndex = index;
        }

        public function getTabIndex():int
        {
            return 0;
        }
    }
}