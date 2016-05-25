package com.view.gameWindow.panel.panels.boss.mapcream
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.VipCfgData;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.boss.BossModelHandle;
	import com.view.gameWindow.panel.panels.boss.MCMapCreamBoss;
	import com.view.gameWindow.panel.panels.boss.MCMapCreamBossItem;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.PageListData;
	import com.view.gameWindow.util.TimeUtils;
	import com.view.gameWindow.util.TimerManager;
	import com.view.gameWindow.util.UrlPic;
	import com.view.gameWindow.util.scrollBar.PageScrollBar;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.printing.PrintJob;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class TabMapCreamViewHandle
	{
		private var _tab:TabMapCreamBoss;
		private var _skin:MCMapCreamBoss;
		 
 		
		private var _pageScrollBar:PageScrollBar;
		
		private var loader:UrlPic;
		public var currnetData:MapCreamItemNode;
		private var bool:Boolean = false;
		
		private var bossMode:BossModelHandle;
		
		private var _items:Vector.<TabMapCreamItem>;
		private var _numItem:int = 4;
		private var _isloadScrollBar:Boolean;
		 
		public function TabMapCreamViewHandle(tab:TabMapCreamBoss)
		{
			_tab = tab;
			_skin = _tab.skin as MCMapCreamBoss;
			_skin.itemNodeShow.btnTxt.mouseEnabled = false;
			 
		}

		public function init(rsrLoader:RsrLoader):void
		{
			var _itemMc:MCMapCreamBossItem,_item:TabMapCreamItem;
			_items = new Vector.<TabMapCreamItem>();
			for(var i:int = 0;i<4;i++)
			{
				_itemMc = _skin.getChildByName("mapcreambossitem"+i) as MCMapCreamBossItem;
				_item = new TabMapCreamItem(_tab,_itemMc);
				_items.push(_item);
			}
			rsrLoader.addCallBack(_skin.mcScrollBar,function (mc:MovieClip):void
			{
				_isloadScrollBar = true;
				refreshScrollBar(mc);
			}
			);
		}
		
		public function refreshScrollBar(mc:MovieClip):void
		{
			
			var totalPage:int;
			var totalLen:int;
			var manager:BossDataManager = BossDataManager.instance;
			totalLen = manager.mapCreamData.items.length;
			if(totalLen>0)
			{
				totalPage = int((totalLen+_numItem-1)/_numItem);
			}
			else
			{
				totalPage = 1;
			}
			if(!_pageScrollBar)
				_pageScrollBar = new PageScrollBar(mc,429,refresh,totalPage); 
			else
				_pageScrollBar.refresh(totalPage);
			
		}
		
		
		public function refresh():void
		{
			var manager:BossDataManager = BossDataManager.instance;
			if(_isloadScrollBar)
			{
				refreshScrollBar(_skin.mcScrollBar);
				_isloadScrollBar = false;
			}
				
			var data:Array = manager.mapCreamData.items.getValues(); //MapCreamItemData
			var page:int,i:int,index:int,len:int,itemData:MapCreamItemData,n:int;
			data.sortOn('mapId',Array.NUMERIC);
			len = data.length;
			page = _pageScrollBar==null?1:_pageScrollBar.page;
			if(_pageScrollBar && page == _pageScrollBar.totalPage)
			{
				n = _pageScrollBar.totalPage*_numItem -len; 
			} 
			
			for each (var item:TabMapCreamItem in _items)
			{
				index = (page-1)*_numItem+i-n;
				if(index < len)
				{
					itemData = data[index];
					item.refresh(itemData);
					item.skin.visible = true;
				}
				else
				{
					item.skin.visible = false; 
				}
				i++;
			}
			if(!bool)
			{
				_items[0].items[0].onCLick();
				bool = true;
			}
		}
 
		public function changeShow(data:MapCreamItemNode):void
		{			
			if(currnetData == data)
				return;
 		
			currnetData = data;
			var skin:MCMapCreamBoss = _skin as MCMapCreamBoss;
			var decTxt:TextField = skin.itemNodeShow.decTxt;
			var timeTxt:TextField = skin.itemNodeShow.timeTxt;
			var bossNameTxt:TextField = skin.itemNodeShow.bossNameTxt;
			decTxt.htmlText = data.decText;
			bossNameTxt.text = data.name;
			var format:TextFormat = new TextFormat();
			format.leading = 7;
			decTxt.setTextFormat(format);
 
			if(bossMode)
				bossMode.destroy();
			
			bossMode = new BossModelHandle(_skin.itemNodeShow.mcModel);	
			bossMode.data = data.monsterCfgData;
			bossMode.changeModel();
			
			if(0>=data.revive_time)
			{
				timeTxt.textColor = 0x00ff00;
				if(0>=data.percent)
				{
					timeTxt.text = StringConst.BOSS_PANEL_0007;
				}
				else
				{
					timeTxt.text = StringConst.BOSS_PANEL_0028;
				}
				
				TimerManager.getInstance().remove(checkTime);
				
			}
			else
			{
				
				if(data.percent == 100)
				{
					timeTxt.textColor = 0x00ff00;
					timeTxt.text = StringConst.BOSS_PANEL_0028;
					return;
				}
				
				TimerManager.getInstance().add(1000,checkTime);
				timeTxt.textColor = 0xff0000;
				timeTxt.htmlText = TimeUtils.formatS2(TimeUtils.calcTime2(currnetData.revive_time));                     
			}		
		}
		
		private function checkTime():void
		{
			var skin:MCMapCreamBoss = _skin as MCMapCreamBoss;
			var timeTxt:TextField = skin.itemNodeShow.timeTxt;
			//currnetData.revive_time--;
			currnetData.dealReviveTime();
			timeTxt.htmlText = TimeUtils.formatS2(TimeUtils.calcTime2(currnetData.revive_time));
			if(0>currnetData.revive_time)
			{
				TimerManager.getInstance().remove(checkTime);
			}
		}
 
		
		internal function destroy():void
		{ 
			var item:TabMapCreamItem;
			/*for each(item in _tab.items)
			{
				if(item)
				{
					item.destroy();
				}
			}*/
			if(bossMode)
			{
				bossMode.destroy();
				bossMode = null;
			}
			TimerManager.getInstance().remove(checkTime);	
			currnetData = null;
			_skin = null;
			_tab = null;
			bool = false;
		}
	}
}