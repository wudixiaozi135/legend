package com.view.gameWindow.panel.panels.boss.outside
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.BossCfgData;
	import com.model.configData.cfgdata.MapBossCfgData;
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.boss.BossData;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.boss.BossModelHandle;
	import com.view.gameWindow.panel.panels.boss.FlyItemText;
	import com.view.gameWindow.panel.panels.boss.MCFieldBoss;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.SimpleStateButton;
	import com.view.gameWindow.util.SortUtil;
	import com.view.gameWindow.util.UrlPic;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	public class TabOutsideViewHandle
	{
		private var _tab:TabOutsideBoss;
		private var _awarditems:Vector.<IconCellEx> = new Vector.<IconCellEx>;
		private var _bossNameUrlPic:UrlPic;
		private var _bossLvUrlPic:UrlPic;
		private var _data:BossCfgData;
		
		private var _scrollRect:TabOutSideScrollRect;
		private var _bossMode:BossModelHandle;
		private var _bool:Boolean = false;

		private var flySprite:Sprite;
		public var selectItem:OutsideBossItem;

		public function TabOutsideViewHandle(tab:TabOutsideBoss)
		{
			_tab = tab;	
		}
		
		public function init(rsloader:RsrLoader):void
		{
			var skin:MCFieldBoss = _tab.skin as MCFieldBoss;
			var temp:MovieClip;
			var iconcell:IconCellEx;
			for(var i:int = 0;i < 10;i++)
			{
				temp = skin.getChildByName('mcIcon'+i) as MovieClip;
				iconcell = new IconCellEx(temp.parent,temp.x,temp.y,temp.width,temp.height);
				_awarditems.push(iconcell);
			}
			_bossNameUrlPic = new UrlPic(skin.bossNamePic);
			_bossLvUrlPic=new UrlPic(skin.bossLvPic);
			_scrollRect=new TabOutSideScrollRect(this,skin,rsloader);
			
			rsloader.addCallBack(skin.mcScrollBar,function(mc:MovieClip):void
				{
					_scrollRect.initScrollBar(mc);	
				}
			);
			
			flySprite = new Sprite();
			skin.addChild(flySprite);
			flySprite.x=220;
			flySprite.y=400;
		}
		
		public function refresh():void
		{
			var bossVec:Vector.<BossCfgData>;
			bossVec=BossDataManager.instance.getOutsideBossCfg();
			bossVec=bossVec.sort(SortUtil.sortGroupId);
			_scrollRect.refresh(bossVec);
			 if(!_bool)
			 {
				 showDetail(bossVec[0]);
				 _bool = true;
			 }
		}
 
		public function showDetail(data:BossCfgData):void
		{
			if(_data == data)
				return;
			_data = data;
			
			var skin:MCFieldBoss = _tab.skin as MCFieldBoss;
			_bossNameUrlPic.load(ResourcePathConstants.IMAGE_BOSS_HEAD_LOAD+data.name_url+".png"); 
			_bossLvUrlPic.load(ResourcePathConstants.IMAGE_BOSS_HEAD_LOAD+data.level_url+".png"); 
		
			initAward(data);
			
			if(_bossMode)
				_bossMode.destroy();
			
			_bossMode = new BossModelHandle(skin.bossContent);	
//			var monsterCfgData:MonsterCfgData=ConfigDataManager.instance.monsterCfgData(data.monster_group_id+1);
			var monsterCfgData:MonsterCfgData;
			var monsterGroup:Dictionary = ConfigDataManager.instance.monsterCfgDatas(data.monster_group_id);  
			for each(var monsterCfg:MonsterCfgData in monsterGroup)
			{
				monsterCfgData = monsterCfg;
				break;
			} 
			_bossMode.data = monsterCfgData;
			_bossMode.changeModel();
			
			var time:int=monsterCfgData.corpse+monsterCfgData.revive;
			skin.freshTxt.text = int(time/60) +StringConst.MINIUTE_W;
			skin.mapTxt.htmlText =StringConst.BOSS_PANEL_0042;
			
			initRefreshMap(data);
		}
		
		private function initRefreshMap(data:BossCfgData):void
		{
			clearFlyItem();
			var mapBossCfgData:* = ConfigDataManager.instance.mapBossCfgData(data.monster_group_id);
			if(mapBossCfgData is MapBossCfgData)
			{
				initFlyItem(mapBossCfgData);
			}else
			{
				for each(var cfg:MapBossCfgData in mapBossCfgData)
				{
					initFlyItem(cfg);
				}
			}
		}
		
		private function initFlyItem(cfg:MapBossCfgData):void
		{
			var flyItemText:FlyItemText = new FlyItemText();
			var boss:BossData = BossDataManager.instance.getBossData(cfg.map_monster_id);
			flyItemText.setFlyData(cfg,boss);
			flyItemText.x=(cfg.index-1)*135;
			flySprite.addChild(flyItemText);
		}
		
		private function clearFlyItem():void
		{
			while(flySprite.numChildren>0)
			{
				var flyItemText:FlyItemText = flySprite.removeChildAt(0) as FlyItemText;
				flyItemText.destroy();
				flyItemText=null;
			}
		}
		
		
		private function initAward(bossCfgData:BossCfgData):void
		{
			if(bossCfgData.reward_items!="")
			{
				var awards:Vector.<ThingsData> =UtilItemParse.getThingsDatas(bossCfgData.reward_items);	
				for(var i:int = 0;i < _awarditems.length;i++)
				{
					if(awards.length > i)
					{
						IconCellEx.setItemByThingsData(_awarditems[i],awards[i]);
						ToolTipManager.getInstance().attach(_awarditems[i]);
					}
				}
			}
		}
		
		internal function destroy():void
		{ 
			var skin:MCFieldBoss = _tab.skin as MCFieldBoss;
			for(var i:int = 0;i<_awarditems.length;i++)
			{
				ToolTipManager.getInstance().detach(_awarditems[i]);
				_awarditems[i].destroy();
			}
			
			if(_bossMode)
			{
				_bossMode.destroy();
				_bossMode = null;
			}
				
			SimpleStateButton.removeState(skin.mapTxt);
//			SimpleStateButton.removeState(skin.flyBtn);
			_bool = false;
			_bossNameUrlPic.destroy();
			_bossLvUrlPic.destroy();
			_scrollRect.destroy();
			_awarditems.length = 0;
			_awarditems = null;
			_scrollRect = null;
			_bossNameUrlPic = null;
			_bossLvUrlPic=null;
			_tab = null;
			_data = null;
		}	
	}
}