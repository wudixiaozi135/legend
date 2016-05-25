package com.view.gameWindow.panel.panels.boss.individual
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.cfgdata.FamilyAddMemberCfgData;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.boss.BossModelHandle;
	import com.view.gameWindow.panel.panels.boss.MCIndividualBoss;
	import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
	import com.view.gameWindow.panel.panels.dungeon.DungeonData;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.UrlPic;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.MovieClip;

	public class TabIndividualViewHandle
	{
		private var _tab:TabIndividualBoss;
		private var _scrollRect:TabIndividualScrollRect;
		private var _data:IndividualItemData;
		private var _bool:Boolean = false; 
		private var _awarditems:Vector.<IconCellEx> = new Vector.<IconCellEx>;
		private var _bossMode:BossModelHandle;
		private var _bossPic:UrlPic;
		 
		public function TabIndividualViewHandle(tab:TabIndividualBoss)
		{
			_tab = tab;	
		}
		
		public function init(rsloader:RsrLoader):void
		{
			var skin:MCIndividualBoss = _tab.skin as MCIndividualBoss;
			_scrollRect = new TabIndividualScrollRect(this,skin,rsloader);
			rsloader.addCallBack(skin.mcScrollBar,function(mc:MovieClip):void
			{
				_scrollRect.initScrollBar(mc);
			}
			);
			var temp:MovieClip,iconcell:IconCellEx;
			for(var i:int = 0;i < 8;i++)
			{
				temp = skin.getChildByName('mcIcon'+i) as MovieClip;
				iconcell = new IconCellEx(temp.parent,temp.x,temp.y,temp.width,temp.height);
				_awarditems.push(iconcell);
			}
			_bossPic = new UrlPic(skin.bossPic);
		}
		
		public function refresh():void
		{
			var data:IndividualBossData = BossDataManager.instance.individualBossData;
			var items:Array = data.items;
			_scrollRect.refresh(items); 
			
			if(!_bool)
			{
				_scrollRect.showFirstItem();
				_bool = true;
			}
		}
		public function refreshChrDungeon():void
		{
//			var individualBossData:IndividualBossData = BossDataManager.instance.individualBossData;
//			var items:Array = individualBossData.items;
//			var dgnDataManager:DgnDataManager = DgnDataManager.instance;
//			var dungeonData:DungeonData;
//			var dungeon_id:int
//			var individualItemData:IndividualItemData 
//			for(var i:int = 0;i < items.length;i++)
//			{
//				individualItemData = items[i] as IndividualItemData;
//				dungeon_id = individualItemData.bossCfgData.dungeon_id;
//				dungeonData = dgnDataManager.getDgnDt(dungeon_id);
//				if(dungeonData)
//				{
//					individualItemData.daily_complete_count = dungeonData.daily_complete_count;
//					individualItemData.online_cleared = dungeonData.online_cleared;
//				}
//				items[i] = individualItemData;
//			}
//			BossDataManager.instance.individualBossData.items = items;
			
			DgnDataManager.instance.refreshChrDungeon();
		}
		
		public function showBoss(data:IndividualItemData):void
		{
			if(!data || _data == data)
				return;
			_data = data;
			var skin:MCIndividualBoss = _tab.skin as MCIndividualBoss;
			
			if(_bossMode)
				_bossMode.destroy();
			
			_bossMode = new BossModelHandle(skin.mcModel);	
			skin.mcModel.mouseEnabled=skin.mcModel.mouseChildren=false;
			_bossMode.data = data.monsterCfgData;
			_bossMode.changeModel();
			
			var awards:Vector.<ThingsData> =UtilItemParse.getThingsDatas(data.reward_items);	
			for(var i:int = 0;i < _awarditems.length;i++)
			{
				if(awards.length > i && awards[i])
				{
					IconCellEx.setItemByThingsData(_awarditems[i],awards[i]);
					ToolTipManager.getInstance().attach(_awarditems[i]);
					_awarditems[i].visible = true;
				}
				else
				{
					_awarditems[i].visible = false;
				}
			}
			_bossPic.load(ResourcePathConstants.IMAGE_BOSS_HEAD_LOAD+data.tip_url+".png"); 
			//skin.bossPic.resUrl = ResourcePathConstants.IMAGE_BOSS_HEAD_LOAD+data.url+".png";
			//_tab.loadNewSource(skin.bossPic);
		}
		
		internal function destroy():void
		{
			 
			_scrollRect.destroy();
			_scrollRect = null;
			_data = null;
			_tab = null;
		}
	}
}