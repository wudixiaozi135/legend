package com.view.gameWindow.panel.panels.daily.pep
{
	import com.model.configData.cfgdata.DailyVitRewardCfgData;
	import com.model.consts.FontFamily;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.panels.daily.DailyData;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.scrollBar.IScrollee;
	import com.view.gameWindow.util.scrollBar.ScrollBar;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	internal class TabDailyPepViewHandle implements IScrollee
	{
		private var _tab:TabDailyPep;
		private var _skin:McDailyPep;
		private var _rewardItems:Vector.<TabDailyPepRewardItem>;
		private var _orderMax:int;
		
		private var _itemsTitle:Vector.<TabDailyPepItem>;
		private var _items:Vector.<TabDailyPepItem>;
		internal var itemsKeyMc:Dictionary;
		internal var itemsKeyTxt:Dictionary;
		private var _scrollBar:ScrollBar;
		private var _scrollRect:Rectangle;
		private var _contentHeight:int;
		
		public function TabDailyPepViewHandle(tab:TabDailyPep)
		{
			_tab = tab;
			_skin = _tab.skin as McDailyPep;
			init();
		}
		
		private function init():void
		{
			var manager:DailyDataManager = DailyDataManager.instance;
			//
			_skin.txtOpenVip0.htmlText = HtmlUtils.createHtmlStr(_skin.txtOpenVip0.textColor,StringConst.DAILY_PANEL_0006,12,false,2,FontFamily.FONT_NAME,true);
			_skin.txtOpenVip1.text = StringConst.DAILY_PANEL_0007;
			_skin.txtOpenVip2.text = StringConst.DAILY_PANEL_0008;
			_skin.txtOpenVip3.text = StringConst.DAILY_PANEL_0009;
			//
			_skin.txtRolePep.text = StringConst.DAILY_PANEL_0010 + manager.player_daily_vit + "/" + manager.daily_vit_max;
			_skin.txtRolePepGo.htmlText = HtmlUtils.createHtmlStr(_skin.txtOpenVip0.textColor,StringConst.DAILY_PANEL_0012,12,false,2,FontFamily.FONT_NAME,true);
			_skin.txtHeroPep.text = StringConst.DAILY_PANEL_0011 + manager.hero_daily_vit + "/" + manager.daily_vit_max;
			_skin.txtHeroPepGo.htmlText = HtmlUtils.createHtmlStr(_skin.txtOpenVip0.textColor,StringConst.DAILY_PANEL_0012,12,false,2,FontFamily.FONT_NAME,true);
			//
			initTips();
			//
			initItems();
			//
			initRewardItems();
			//
			_scrollRect = new Rectangle(0,0,_skin.mcLayer.width,_skin.mcLayer.height);
			_skin.mcLayer.scrollRect = _scrollRect;
		}
		
		private function initTips():void
		{
			var tipVO:TipVO = new TipVO();
			tipVO.tipType = ToolTipConst.TEXT_TIP;
			tipVO.tipData = HtmlUtils.createHtmlStr(0xd4a460,StringConst.DAILY_PANEL_0020,12,false,4);
			ToolTipManager.getInstance().hashTipInfo(_skin.txtOpenVip2,tipVO);
			ToolTipManager.getInstance().attach(_skin.txtOpenVip2);
			//
			tipVO = new TipVO();
			tipVO.tipType = ToolTipConst.TEXT_TIP;
			tipVO.tipData = function():String
			{
				var manager:DailyDataManager = DailyDataManager.instance;
				var str:String = StringConst.DAILY_PANEL_0021;
				str = str.replace("&wr",HtmlUtils.createHtmlStr(0xffe1aa,manager.vit_today_player+""));
				str = str.replace("&xr",HtmlUtils.createHtmlStr(0xffe1aa,manager.player_vit_daily_hour+""));
				str = str.replace("&yr",HtmlUtils.createHtmlStr(0xffe1aa,manager.player_vit_daily_reward+""));
				str = str.replace("&zr",HtmlUtils.createHtmlStr(0xffe1aa,manager.player_vit_daily_vip+""));
				//
				str = str.replace("&wh",HtmlUtils.createHtmlStr(0xffe1aa,manager.vit_today_hero+""));
				str = str.replace("&xh",HtmlUtils.createHtmlStr(0xffe1aa,manager.hero_vit_daily_hour+""));
				str = str.replace("&yh",HtmlUtils.createHtmlStr(0xffe1aa,manager.hero_vit_daily_reward+""));
				str = str.replace("&zh",HtmlUtils.createHtmlStr(0xffe1aa,manager.hero_vit_daily_vip+""));
				str = HtmlUtils.createHtmlStr(0xd4a460,str,12,false,4);
				return str;
			};
			ToolTipManager.getInstance().hashTipInfo(_skin.txtPepProgress,tipVO);
			ToolTipManager.getInstance().attach(_skin.txtPepProgress);
		}
		
		private function initItems():void
		{
			_itemsTitle = new Vector.<TabDailyPepItem>();
			_items = new Vector.<TabDailyPepItem>();
			itemsKeyMc = new Dictionary();
			itemsKeyTxt = new Dictionary();
			var item:TabDailyPepItem;
			//
			item = new TabDailyPepItem(null,2);
			_skin.mcLayer.addChild(item.skin);
			_itemsTitle.push(item);
			//
			item = new TabDailyPepItem(null,3);
			_skin.mcLayer.addChild(item.skin);
			_itemsTitle.push(item);
			//
			var datas:Dictionary = DailyDataManager.instance.datas,dt:DailyData,i:int = 1;
			for each(dt in datas)
			{
				item = new TabDailyPepItem(dt,1);
				_skin.mcLayer.addChild(item.skin);
				itemsKeyMc[item.bg0] = item;
				itemsKeyTxt[item.txt2] = item;
				_items.push(item);
			}
			_items.sort(TabDailyPepItem.compareByOrder);
		}
		
		internal function initRewardItems(isInner:Boolean = true):void
		{
			var manager:DailyDataManager = DailyDataManager.instance;
			//
			if(!_rewardItems)
			{
				_rewardItems = new Vector.<TabDailyPepRewardItem>();
			}
			var order:int = 1;
			while(manager.getDailyVitRewardCfgData(order))
			{
				var mcReward:McDailyPepRewardItem = _skin["mcReward"+(order-1)] as McDailyPepRewardItem;
				var rewardItem:TabDailyPepRewardItem;
				if(isInner)
				{
					rewardItem = new TabDailyPepRewardItem(mcReward,order);
					_rewardItems.push(rewardItem);
				}
				else
				{
					rewardItem = _rewardItems[order-1];
				}
				mcReward.mcMaskbtn.btn.rewardItem = rewardItem;
				order++;
			}
			_orderMax = order-1;
		}
		
		internal function initScrollBar(mc:MovieClip):void
		{
			_scrollBar = new ScrollBar(this,mc,0,_skin.mcLayer,15);
			_scrollBar.resetHeight(_scrollRect.height);
		}
		/**刷新完成项目条*/
		internal function refreshItems():void
		{
			var item:TabDailyPepItem;
			//
			item = _itemsTitle[0];
			item.skin.y = 0;
			_contentHeight = item.skin.height;
			//
			var i:int,l:int = _items.length;
			for(i=0;i<l;i++)
			{
				item = _items[i];
				if(!item.dailyData.isGet)
				{
					item.refresh();
					item.skin.y = _contentHeight+2;
					_contentHeight += item.skin.height;
				}
			}
			//
			item = _itemsTitle[1];
			item.skin.y = _contentHeight + 2;
			_contentHeight += item.skin.height;
			//
			for(i=0;i<l;i++)
			{
				item = _items[i];
				if(item.dailyData.isGet)
				{
					item.refresh();
					item.skin.y = _contentHeight+2;
					_contentHeight += item.skin.height;
				}
			}
			if(_scrollBar)
			{
				_scrollBar.resetScroll();
			}
		}
		
		public function scrollTo(pos:int):void
		{
			_scrollRect.y = pos;
			_skin.mcLayer.scrollRect = _scrollRect;
		}
		
		public function get contentHeight():int
		{
			return _contentHeight;
		}
		
		public function get scrollRectHeight():int
		{
			return _scrollRect.height;
		}
		
		public function get scrollRectY():int
		{
			return _scrollRect.y;
		}
		
		internal function refreshRewardItems():void
		{
			var i:int,l:int = _rewardItems.length;
			for(i=0;i<l;i++)
			{
				_rewardItems[i].refersh();
			}
		}
		
		internal function refreshPep():void
		{
			var manager:DailyDataManager = DailyDataManager.instance;
			//
			_skin.txtTotalPepGetted.text = manager.vit_today_total+"";
			//
			_skin.txtRolePep.text = StringConst.DAILY_PANEL_0010 + manager.player_daily_vit + "/" + manager.daily_vit_max;
			_skin.txtHeroPep.text = StringConst.DAILY_PANEL_0011 + manager.hero_daily_vit + "/" + manager.daily_vit_max;
			//
			var cfgDt:DailyVitRewardCfgData = manager.getDailyVitRewardCfgData(_orderMax);
			_skin.txtPepProgress.text = manager.vit_today_total+"/"+cfgDt.daily_vit;
			var scaleX:Number = manager.vit_today_total/cfgDt.daily_vit;
			scaleX = scaleX < 0 ? 0 : (scaleX > 1 ? 1 : scaleX);
			_skin.mcPepProgress.mcMask.scaleX = scaleX;
		}
		
		internal function destroy():void
		{
			ToolTipManager.getInstance().detach(_skin.txtOpenVip2);
			ToolTipManager.getInstance().detach(_skin.txtPepProgress);
			if(_scrollBar)
			{
				_scrollBar.destroy();
				_scrollBar = null;
			}
			var item:TabDailyPepItem;
			for each(item in _items)
			{
				item ? item.destroy() : null;
			}
			_items = null;
			for each(item in _itemsTitle)
			{
				item.destroy();
			}
			_itemsTitle = null;
			itemsKeyMc = null;
			itemsKeyTxt = null;
			var i:int,l:int = _rewardItems.length;
			for(i=0;i<l;i++)
			{
				var mcReward:McDailyPepRewardItem = _skin["mcReward"+i] as McDailyPepRewardItem;
				mcReward.mcMaskbtn.btn.rewardItem = null;
				_rewardItems[i].destroy();
			}
			_rewardItems = null;
			_skin = null;
			_tab = null;
		}
	}
}