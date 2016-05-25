package com.view.gameWindow.panel.panels.openGift.dailyReward
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.OpenServerRewardCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.guideSystem.UICenter;
	import com.view.gameWindow.panel.panels.openActivity.McOpenDailyReward;
	import com.view.gameWindow.panel.panels.openGift.data.OpenServiceActivityDatamanager;
	import com.view.gameWindow.panel.panels.task.linkText.LinkText;
	import com.view.gameWindow.panel.panels.task.linkText.item.LinkTextItem;
	import com.view.gameWindow.util.ServerTime;
	import com.view.gameWindow.util.TimeUtils;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.events.TextEvent;

	public class OpenServerDailyRewardViewHandler
	{
		private var skin:McOpenDailyReward;
		private var panel:OpenServerDailyReward;
		private var _vec:Vector.<OpenServerDailyRewardItem>;
		public static const ITEM_NUM:int = 3;
		internal var _linkText:LinkText;
		private var _uiCenter:UICenter;
		public function OpenServerDailyRewardViewHandler(p:OpenServerDailyReward)
		{
			panel = p;
			skin = panel.skin;
			initData();
		}
		
		private function initData():void
		{
			// TODO Auto Generated method stub
			_linkText = new LinkText();
			_uiCenter = new UICenter();
			var day:int = OpenServiceActivityDatamanager.instance.curDay;
			var cfg:OpenServerRewardCfgData = ConfigDataManager.instance.openServerRewardData(day);
			var str:String = StringConst.PANEL_OPEN_GIFT_016+TimeUtils.getDateStringCh(ServerTime.openTime*1000+(day-1)*24*3600*1000)+"---"+TimeUtils.getDateStringCh(ServerTime.openTime*1000+cfg.duration_day*24*3600*1000);
			str = str+StringConst.PANEL_OPEN_GIFT_017;
			skin.txtInfo.htmlText = str;
			_linkText.init(CfgDataParse.pareseDesToStr(cfg.open_server_daily_des));
			skin.txtDesc.htmlText =_linkText.htmlText;
			skin.txtDesc.addEventListener(TextEvent.LINK,linkHandle);
			skin.txtNum.text = "14";
//			skin.txtCall.htmlText = StringConst.PANEL_OPEN_GIFT_020;
			skin.txtInfo.mouseEnabled = false;
			skin.txtNum.mouseEnabled = false;
			_vec = new Vector.<OpenServerDailyRewardItem>();
			for(var i:int = 0;i<ITEM_NUM;i++)
			{
				var item:OpenServerDailyRewardItem = new OpenServerDailyRewardItem();
				item.setData(i+1);
				skin.addChild(item);
				item.y = 122+(item.height+8)*i;
				if(i == 2)
					item.y = 344;
				_vec[i] = item;
			}
		}
		
		protected function linkHandle(event:TextEvent):void
		{
			var num:int = _linkText.getItemCount();
			var name:String;
			var tabIndex:int;
			var tabSubIndex:int;
			var linkItem:LinkTextItem;
			for(var i:int = 1;i<num+1;i++)
			{
				if(event.text == i.toString())
				{
					name = UICenter.getUINameFromMenu(_linkText.getItemById(i).panelId.toString());
					_uiCenter.openUI(name);
					linkItem = _linkText.getItemById(i);
					tabIndex = linkItem.panelPage;
					tabSubIndex = linkItem.subTabIndex;
					if(tabIndex>=0)
					{
						var tab:* = UICenter.getUI(name);
						if(tab)
						{
							if (tab.hasOwnProperty("setTabIndex"))
							{
								tab.setTabIndex(tabIndex);
							}
							if (tab.hasOwnProperty("setSubTabIndex"))
							{
								tab.setSubTabIndex(tabSubIndex);
							}
						}
					}
				}
			}
		}
		
		public function refreshData():void
		{
			for(var i:int = 0;i<_vec.length;i++)
			{
				_vec[i].refreshData();
			}
		}
		
		public function handlerSuccess():void
		{
			for(var i:int = 0;i<_vec.length;i++)
			{
				_vec[i].handlerSuccess();
			}
		}
		
		public function destroy():void
		{
			for(var i:int = 0;i<_vec.length;i++)
			{
				_vec[i].destroy();
			}
			_linkText = null;
			_uiCenter = null;
			skin.txtDesc.removeEventListener(TextEvent.LINK,linkHandle);
			skin = null;
			panel = null;
		}
	}
}