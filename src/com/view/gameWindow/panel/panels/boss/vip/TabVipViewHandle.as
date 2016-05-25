package com.view.gameWindow.panel.panels.boss.vip
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.WorldLevelMonsterCfgData;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.boss.BossModelHandle;
	import com.view.gameWindow.panel.panels.boss.MCVIPBoss;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.SimpleStateButton;
	import com.view.gameWindow.util.UrlPic;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;

	public class TabVipViewHandle
	{
		private var _tab:TabVipBoss;
		private var _awarditems:Vector.<IconCellEx> = new Vector.<IconCellEx>;
		private var _bossurlPic:UrlPic;
		private var _data:VipBossItemData;
		
		private var _scrollRect:TabVipScrollRect;
		private var _bossMode:BossModelHandle;
		
		private var _bool:Boolean = false;
		public function TabVipViewHandle(tab:TabVipBoss)
		{
			_tab = tab;	
		}
		
		public function init(rsloader:RsrLoader):void
		{
			var skin:MCVIPBoss = _tab.skin as MCVIPBoss;
			var temp:MovieClip;
			var iconcell:IconCellEx;
			for(var i:int = 0;i < 9;i++)
			{
				temp = skin.getChildByName('mcIcon'+i) as MovieClip;
				iconcell = new IconCellEx(temp.parent,temp.x,temp.y,temp.width,temp.height);
				_awarditems.push(iconcell);
			}
			_bossurlPic = new UrlPic(skin.bossNamePic);
			//skin.flyBtn.buttonMode = true;
			skin.flyBtn.addEventListener(MouseEvent.CLICK,onClickFlyBtn);
/*			skin.flyBtn.addEventListener(MouseEvent.ROLL_OVER,onOverBmc);
			skin.flyBtn.addEventListener(MouseEvent.ROLL_OUT,onOutBmc);*/
			//skin.mapTxt.addEventListener(MouseEvent.CLICK,onClickMapTxt);
			_scrollRect = new TabVipScrollRect(this,skin,rsloader);
			//SimpleStateButton.addState(skin.mapTxt);
			SimpleStateButton.addState(skin.flyBtn);
			rsloader.addCallBack(skin.mcScrollBar,function(mc:MovieClip):void
			{
				_scrollRect.initScrollBar(mc);	
			}
			);
		}
		private function onOverBmc(e:MouseEvent):void
		{
			var skin:MCVIPBoss = _tab.skin as MCVIPBoss; 
			skin.flyBtn.filters = [new GlowFilter(0xffffff)];
		}
		
		private function onOutBmc(e:MouseEvent):void
		{
			var skin:MCVIPBoss = _tab.skin as MCVIPBoss;
			skin.flyBtn.filters = [];
		}
		private function onClickMapTxt(e:MouseEvent):void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			if(0>=_data.hp)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.BOSS_PANEL_0031);	
				return;
			}
			AutoSystem.instance.setTarget(_data.group_id,EntityTypes.ET_MONSTER,_data.map_monster_id);	
			PanelMediator.instance.closePanel(PanelConst.TYPE_BOSS);
		}
		
		private function onClickFlyBtn(e:MouseEvent):void
		{
			var mapId:int = SceneMapManager.getInstance().mapId;
			if(_data.maps_noFlys.indexOf(String(mapId)) ==-1)
			{
				BossDataManager.instance.deliverBoss(_data,4);
				
			}
			else
			{
				if(SceneMapManager.getInstance().mapId == _data.mapId)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.BOSS_PANEL_0029);
					return;
				} 
				AutoSystem.instance.setTarget(_data.group_id,EntityTypes.ET_MONSTER,_data.map_monster_id);	
				PanelMediator.instance.closePanel(PanelConst.TYPE_BOSS);
			}	
		}
		public function refresh():void
		{
			var data:VipBossData = BossDataManager.instance.vipBossData;
			var items:Array = data.items;
			 _scrollRect.refresh(items);
			 
			 if(!_bool)
			 {
				 showItem(data.firstData);
				 _bool = true;
			 }
				
		}
 
		public function showItem(data:VipBossItemData):void
		{
			if(_data == data)
				return;
			_data = data;
			var skin:MCVIPBoss = _tab.skin as MCVIPBoss;
			_bossurlPic.load(ResourcePathConstants.IMAGE_BOSS_HEAD_LOAD+data.url+".png"); 
			var awards:Vector.<ThingsData> =UtilItemParse.getThingsDatas(data.reward_items);	
			for(var i:int = 0;i < _awarditems.length;i++)
			{
				if(awards.length > i)
				{
					IconCellEx.setItemByThingsData(_awarditems[i],awards[i]);
					ToolTipManager.getInstance().attach(_awarditems[i]);
				}
			}
			
			if(_bossMode)
				_bossMode.destroy();
			
			_bossMode = new BossModelHandle(skin.bossContent);	
			_bossMode.data = data.monsterCfgData;
			_bossMode.changeModel();
			//_bossMode.width 
			
			skin.levelVipTxt.text = data.level.toString() + StringConst.ROLE_PROPERTY_PANEL_0072;// + data.bossVip;			 
			skin.appearTxt.text = data.percent == 100? StringConst.BOSS_PANEL_0028:(data.percent > 1 ? data.percent.toString()+"%" : StringConst.BOSS_PANEL_0007);
			var time:int;
			var worldMstData:WorldLevelMonsterCfgData = ConfigDataManager.instance.worldLevelMonster(data.monsterCfgData.group_id);
			var openday:int = WelfareDataMannager.instance.openServiceDay+1;
			if(openday>worldMstData.min_open_day && openday<worldMstData.max_open_day)
				time = data.revive + worldMstData.revive_time;
			else
				time = data.revive;
			skin.freshTxt.text = int(time/60) +StringConst.MINIUTE_W;
			skin.mapTxt.htmlText =  data.mapName;
			//skin.mapTxt.htmlText = "<u><a href='#'>"+ data.mapName +"</a></u>";		
			//skin.lvTxt.text = '('+RoleDataManager.instance.lv.toString()+'级'+','+'VIP'+VipDataManager.instance.lv.toString()+')';
		}
		
		internal function destroy():void
		{ 
			var skin:MCVIPBoss = _tab.skin as MCVIPBoss;
			skin.flyBtn.removeEventListener(MouseEvent.CLICK,onClickFlyBtn);
			skin.mapTxt.removeEventListener(MouseEvent.CLICK,onClickMapTxt);
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
			SimpleStateButton.removeState(skin.flyBtn);
			_bool = false;
			_bossurlPic.destroy();
			_scrollRect.destroy();
			_awarditems.length = 0;
			_awarditems = null;
			_scrollRect = null;
			_bossurlPic = null;
			_tab = null;
			_data = null;
		}	
	}
}