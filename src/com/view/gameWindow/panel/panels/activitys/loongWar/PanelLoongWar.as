package com.view.gameWindow.panel.panels.activitys.loongWar
{
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
    import com.view.gameWindow.mainUi.subuis.actvEnter.ActvEnter;
    import com.view.gameWindow.mainUi.subuis.actvEnter.McActvEnter;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.activitys.loongWar.tabApply.TabLoongWarApply;
    import com.view.gameWindow.panel.panels.activitys.loongWar.tabInfo.TabLoongWarInfo;
    import com.view.gameWindow.panel.panels.activitys.loongWar.tabReward.TabLoongWarReward;
    import com.view.gameWindow.util.tabsSwitch.TabsSwitch;
    
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFormat;

    /**
	 * 龙城争霸面板
	 * @author Administrator
	 */	
	public class PanelLoongWar extends PanelBase implements IPanelLoongWar
	{
		private var _tabsSwitch:TabsSwitch;
		private var _btnTabClick:MovieClip;
		
		public function PanelLoongWar()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McLoongWar = new McLoongWar();
			_skin = skin;
			_skin.mouseEnabled = false;
			addChild(_skin);
			setTitleBar(skin.mcDrag);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McLoongWar = _skin as McLoongWar;
			var i:int,l:int = 3;
			for (i=0;i<l;i++) 
			{
				rsrLoader.addCallBack(skin["btn"+i],callBack(i));
			}
		}
		
		private function callBack(index:int):Function
		{
			var func:Function = function (mc:MovieClip):void
			{
				var textField:TextField = mc.txt as TextField;
                var btnName:String = getBtnName(index);
				textField.text = btnName;
				textField.textColor = 0x675138;
				if(index == ActivityDataManager.instance.loongWarDataManager.currentTab)
				{
					dealBtnTab(mc,index);
				}
			};
			return func;
		}

        private function getBtnName(index:int):String
		{
			var name:String = "";
			switch(index)
			{
				case LoongWarDataManager.TAB_INFO:
					name = StringConst.LOONG_WAR_00001;
					break;
				case LoongWarDataManager.TAB_REWARD:
					name = StringConst.LOONG_WAR_00002;
					break;
				case LoongWarDataManager.TAB_APPLY:
					name = StringConst.LOONG_WAR_00003;
					break;
				default:
					break;
			}
			return name;
		}
		
		override protected function initData():void
		{
			var skin:McLoongWar = _skin as McLoongWar;
			//
			var defaultTextFormat:TextFormat = skin.txtTitle.defaultTextFormat;
			defaultTextFormat.bold = true;
			skin.txtTitle.defaultTextFormat = defaultTextFormat;
			skin.txtTitle.setTextFormat(defaultTextFormat);
			skin.txtTitle.text = StringConst.LOONG_WAR_0001;
			//
			_tabsSwitch = new TabsSwitch(skin.mcLayer,new <Class>[TabLoongWarInfo,TabLoongWarReward,TabLoongWarApply]);
			_skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var skin:McLoongWar = _skin as McLoongWar;
			switch(event.target)
			{
				case skin.btn0:
					dealBtnTab(skin.btn0,LoongWarDataManager.TAB_INFO);
					break;
				case skin.btn1:
					dealBtnTab(skin.btn1,LoongWarDataManager.TAB_REWARD);
					break;
				case skin.btn2:
					dealBtnTab(skin.btn2,LoongWarDataManager.TAB_APPLY);
					break;
				case skin.btnClose:
					dealBtnClose();
					break;
				default:
					break;
			}
		}
		
		private function dealBtnTab(btn:MovieClip,index:int):void
		{
			if(!btn || _btnTabClick == btn)
			{
				return;
			}
			var textField:TextField;
			if(_btnTabClick)
			{
				_btnTabClick.selected = false;
				_btnTabClick.mouseEnabled = true;
				textField = _btnTabClick.txt as TextField;
				textField.textColor = 0x675138;
			}
			btn.selected = true;
			btn.mouseEnabled = false;
			textField = btn.txt as TextField;
			textField.textColor = 0xffe1aa;
			_btnTabClick = btn;
			_tabsSwitch.onClick(index);
			//
			requestInfo(index);
		}
		
		private function requestInfo(index:int):void
		{
			var manager:LoongWarDataManager = ActivityDataManager.instance.loongWarDataManager;
			switch(index)
			{
				case LoongWarDataManager.TAB_INFO:
					manager.cmFamilyQueryLongchengPositionList();
					break;
				case LoongWarDataManager.TAB_REWARD:
					manager.cmLongchengAwardInfoList();
					break;
				case LoongWarDataManager.TAB_APPLY:
					manager.cmFamilyQueryLeagueInfo();
					break;
				default:
					break;
			}
		}
		
		private function dealBtnClose():void
		{
			ActivityDataManager.instance.loongWarDataManager.dealSwitchPanleLoongWar();
		}
		
		override public function getPanelRect():Rectangle
		{
			return new Rectangle(0,0,894,548);
		}

        override public function setPostion():void
        {
            var mc:McActvEnter = (MainUiMediator.getInstance().actvEnter as ActvEnter).skin as McActvEnter;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.mcBtns.mcLayer.btnLoongWar.x, mc.mcBtns.mcLayer.btnLoongWar.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
        }

        override public function destroy():void
		{
			_btnTabClick = null;
			_skin.removeEventListener(MouseEvent.CLICK,onClick);
			if(_tabsSwitch)
			{
				_tabsSwitch.destroy();
				_tabsSwitch = null;
			}
			super.destroy();
		}
	}
}