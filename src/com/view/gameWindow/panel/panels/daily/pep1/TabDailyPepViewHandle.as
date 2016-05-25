package com.view.gameWindow.panel.panels.daily.pep1
{
	import com.model.configData.cfgdata.DailyVitRewardCfgData;
	import com.model.consts.FontFamily;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.panels.daily.DailyData;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.NumPic;
	import com.view.gameWindow.util.scrollBar.IScrollee;
	import com.view.gameWindow.util.scrollBar.ScrollBar;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	internal class TabDailyPepViewHandle implements IScrollee
	{
		private var _tab:TabDailyPep;
		private var _skin:McDailyPep;
		private var _rewardItems:Vector.<TabDailyPepRewardItem>;
		private var _orderMax:int;
		
		private var _items:Vector.<TabDailyPepItem>;
		internal var itemsKeyTxtNpc:Dictionary;
		internal var itemsKeyTxtGet:Dictionary;
		private var _scrollBar:ScrollBar;
		private var _scrollRect:Rectangle;
		private var _contentHeight:int;
		private var _numPic:NumPic;
		
		public function TabDailyPepViewHandle(tab:TabDailyPep)
		{
			_tab = tab;
			_skin = _tab.skin as McDailyPep;
			initialize();
		}
		
		private function initialize():void
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
			//
			_numPic = new NumPic();
			_numPic.interval = -15;
			_numPic.isCenter = true;
			//
			initTips();
			//
			_skin.mcItemMenu.txtContent.text = StringConst.DAILY_PANEL_0035;
			_skin.mcItemMenu.txtCount.text = StringConst.DAILY_PANEL_0036;
			_skin.mcItemMenu.txtReward.text = StringConst.DAILY_PANEL_0037;
			_skin.mcItemMenu.txtEnter.text = StringConst.DAILY_PANEL_0038;
			_skin.mcItemMenu.txtPep.text = StringConst.DAILY_PANEL_0039;
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
			ToolTipManager.getInstance().hashTipInfo(_skin.mcLayerTotalPepGetted,tipVO);
			ToolTipManager.getInstance().attach(_skin.mcLayerTotalPepGetted);
			//
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0,0);
			sprite.graphics.drawRect(0,0,_skin.mcProgress.width,_skin.mcProgress.height);
			sprite.graphics.endFill();
			sprite.x = _skin.mcProgress.x;
			sprite.y = _skin.mcProgress.y;
			_skin.addChild(sprite);
			var tipData:Function = function():String
			{
				var str:String = StringConst.DAILY_PANEL_0042.replace("&x",HtmlUtils.createHtmlStr(0xffe1aa,DailyDataManager.instance.player_vit_daily_reward+""));
				str = HtmlUtils.createHtmlStr(0xd4a460,str,12,false,4);
				return str;
			}
			ToolTipManager.getInstance().attachByTipVO(sprite,ToolTipConst.TEXT_TIP,tipData);
		}
		
		private function initItems():void
		{
			_items = new Vector.<TabDailyPepItem>();
			itemsKeyTxtNpc = new Dictionary();
			itemsKeyTxtGet = new Dictionary();
			var item:TabDailyPepItem;
			//
			var datas:Dictionary = DailyDataManager.instance.datas,dt:DailyData;
			for each(dt in datas)
			{
				if(dt.dailyCfgData.player_daily_vit)
				{
					item = new TabDailyPepItem(dt);
					_skin.mcLayer.addChild(item.skin);
					itemsKeyTxtNpc[item.skin.txtEnter] = item;
					itemsKeyTxtGet[item.skin.txtPepGet] = item;
					_items.push(item);
				}
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
				var rewardItem:TabDailyPepRewardItem;
				if(isInner)
				{
					rewardItem = new TabDailyPepRewardItem(order);
					_rewardItems.push(rewardItem);
				}
				else
				{
					rewardItem = _rewardItems[order-1];
				}
				order++;
			}
			_orderMax = order-1;
			setRewardItemsPostion();
		}
		
		private function setRewardItemsPostion():void
		{
			var manager:DailyDataManager = DailyDataManager.instance;
			var cfgDtMax:DailyVitRewardCfgData = manager.getDailyVitRewardCfgData(_orderMax);
			var i:int,l:int = _rewardItems.length;
			for (i=0;i<l;i++) 
			{
				var cfgDtNow:DailyVitRewardCfgData = manager.getDailyVitRewardCfgData(i+1);
				var skin:McDailyPepRewardItem = _rewardItems[i].skin;
				skin.x = _skin.mcProgress.x + _skin.mcProgress.width * (cfgDtNow.daily_vit/cfgDtMax.daily_vit);
				skin.y = _skin.mcProgress.y - 4;
				_skin.addChild(skin);
			}
		}
		
		internal function initScrollBar(mc:MovieClip):void
		{
			_scrollBar = new ScrollBar(this,mc,0,_skin.mcLayer,15);
			_scrollBar.resetHeight(_scrollRect.height);
		}
		/**刷新完成项目条*/
		internal function refreshItems():void
		{
			_items.sort(TabDailyPepItem.compareByOrder);
			var item:TabDailyPepItem;
			_contentHeight = 26;
			//
			var i:int,l:int = _items.length;
			for(i=0;i<l;i++)
			{
				item = _items[i];
				if(!item.dailyData.isGet)
				{
					item.refresh();
					item.skin.y = _contentHeight;
					_contentHeight += item.skin.height;
				}
			}
			//
			for(i=0;i<l;i++)
			{
				item = _items[i];
				if(item.dailyData.isGet)
				{
					item.refresh();
					item.skin.y = _contentHeight;
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
			if(manager.is_vit_today_total_change)
			{
				_numPic.init("dailyPep_",manager.vit_today_total+"",_skin.mcLayerTotalPepGetted);
			}
			//
			_skin.txtRolePep.text = StringConst.DAILY_PANEL_0010 + manager.player_daily_vit + "/" + manager.daily_vit_max;
			//
			var cfgDtMax:DailyVitRewardCfgData = manager.getDailyVitRewardCfgData(_orderMax);
			var scaleX:Number = manager.player_vit_daily_reward/*vit_today_total*//cfgDtMax.daily_vit;
			scaleX = scaleX < 0 ? 0 : (scaleX > 1 ? 1 : scaleX);
			_skin.mcProgress.mcMask.scaleX = scaleX;
		}
		
		internal function destroy():void
		{
			ToolTipManager.getInstance().detach(_skin.txtOpenVip2);
			ToolTipManager.getInstance().detach(_skin.txtPepProgress);
			_numPic.destory();
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
			itemsKeyTxtNpc = null;
			itemsKeyTxtGet = null;
			var i:int,l:int = _rewardItems.length;
			for(i=0;i<l;i++)
			{
				_rewardItems[i].destroy();
			}
			_rewardItems = null;
			_skin = null;
			_tab = null;
		}
	}
}