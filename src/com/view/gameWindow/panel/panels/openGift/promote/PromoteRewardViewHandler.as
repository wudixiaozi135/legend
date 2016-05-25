package com.view.gameWindow.panel.panels.openGift.promote
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.OpenServerJourneyRewardCfgData;
	import com.model.configData.cfgdata.OpenServerPromoteRewardCfgData;
	import com.model.configData.cfgdata.OpenServerRewardCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.guideSystem.UICenter;
	import com.view.gameWindow.panel.panels.openActivity.McOpenJourney;
	import com.view.gameWindow.panel.panels.openGift.data.OpenServiceActivityDatamanager;
	import com.view.gameWindow.panel.panels.task.linkText.LinkText;
	import com.view.gameWindow.panel.panels.task.linkText.item.LinkTextItem;
	import com.view.gameWindow.util.ServerTime;
	import com.view.gameWindow.util.TimeUtils;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	import com.view.gameWindow.util.scrollBar.IScrollee;
	import com.view.gameWindow.util.scrollBar.ScrollBar;
	
	import flash.display.MovieClip;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;

	public class PromoteRewardViewHandler implements IScrollee
	{
		private var skin:McOpenJourney;
		private var panel:PromoteReward;
		private var _vec:Vector.<PromoteRewardItem>;
		private var cfgVec:Vector.<OpenServerPromoteRewardCfgData>;
		private var _scrollBar:ScrollBar;
		private var _scrollRect:Rectangle;
		internal var _linkText:LinkText;
		private var _uiCenter:UICenter;
		public function PromoteRewardViewHandler(p:PromoteReward)
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
			var time:int = ServerTime.openTime*1000+day*24*3600*1000;
			var cfg:OpenServerRewardCfgData = ConfigDataManager.instance.openServerRewardData(day);
			var str:String = StringConst.PANEL_OPEN_GIFT_016+TimeUtils.getDateStringCh(ServerTime.openTime*1000+(day-1)*24*3600*1000)+"---"+TimeUtils.getDateStringCh(ServerTime.openTime*1000+cfg.duration_day*24*3600*1000);
			str = str+StringConst.PANEL_OPEN_GIFT_017;
			skin.txtInfo.htmlText = str;
			_linkText.init(CfgDataParse.pareseDesToStr(cfg.open_server_promote_des));
			skin.txtDesc.htmlText = _linkText.htmlText;
			skin.txtDesc.addEventListener(TextEvent.LINK,linkHandle);
			skin.txtTarget.text = StringConst.PANEL_OPEN_GIFT_002;
			skin.txtShow.text = StringConst.PANEL_OPEN_GIFT_004;
			skin.txtOperate.text = StringConst.PANEL_OPEN_GIFT_005;
			skin.txtInfo.mouseEnabled = false;
			skin.txtTarget.mouseEnabled = false;
			skin.txtShow.mouseEnabled = false;
			skin.txtOperate.mouseEnabled = false;
			_scrollRect = new Rectangle(0,0,skin.list.width,skin.list.height);
			skin.list.scrollRect = _scrollRect;
			_vec = new Vector.<PromoteRewardItem>();
			cfgVec = ConfigDataManager.instance.OpenServerPromoteRewardNumByDay(OpenServiceActivityDatamanager.instance.curDay);
			cfgVec.sort(sortIndex);
			for(var i:int = 0;i<cfgVec.length;i++)
			{
				var item:PromoteRewardItem = new PromoteRewardItem();
				item.setData(cfgVec[i].index);
				skin.list.addChild(item);
				item.y = (item.height)*i;
				_vec[i] = item;
			}
			resetScrollBar();
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
		
		
		private function sortIndex(a:OpenServerPromoteRewardCfgData,b:OpenServerPromoteRewardCfgData):int
		{
			if(a.index < b.index)
			{
				return -1;
			}
			else
			{
				return 1;
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
		
		public function addScroll(mc:MovieClip):void
		{
			// TODO Auto Generated method stub
			if(!_scrollBar)
			{
				_scrollBar = new ScrollBar(this,mc,0,skin.list,15);
				_scrollBar.resetHeight(_scrollRect.height);
			}
		}
		
		public function resetScrollBar():void
		{
			if(_scrollBar)
			{
				_scrollBar.resetScroll();
			}
		}
		
		public function scrollTo(pos:int):void
		{
			_scrollRect.y = pos;
			skin.list.scrollRect = _scrollRect;
		}
		public function get contentHeight():int
		{
			return listContentHeight;
		}
		
		public function get scrollRectHeight():int
		{
			return _scrollRect.height;
		}
		public function get scrollRectY():int
		{
			return _scrollRect.y;
		}
		
		public function get listContentHeight():Number
		{
			if(_vec && _vec.length>0)
			{
				return _vec.length*_vec[0].height;
			}
			return 0;
		}
		
		public function destroy():void
		{
			// TODO Auto Generated method stub
			if(_scrollBar)
			{
				_scrollBar.destroy();
				_scrollBar = null;
			}
			if(_vec.length)
			{
				for(var i:int =0;i<_vec.length;i++)
				{
					_vec[i].destroy();
				}
			}
			_vec = null;
			_linkText = null;
			_uiCenter = null;
			skin.txtDesc.removeEventListener(TextEvent.LINK,linkHandle);
			skin = null;
			panel = null;
		}
	}
}