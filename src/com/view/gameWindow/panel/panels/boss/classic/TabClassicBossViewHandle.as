package com.view.gameWindow.panel.panels.boss.classic
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.boss.MCClassicBoss;
	import com.view.gameWindow.panel.panels.boss.classicPage1;
	import com.view.gameWindow.panel.panels.boss.classicPage2;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.PageListData;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;

	public class TabClassicBossViewHandle
	{
		private var _tab:TabClassicBoss;
		internal var skin:MCClassicBoss;
		private var _pager:PageListData;
		private var _rsrLoader:RsrLoader;
		private var _pageHandle:TabClassBossPage;
		public function TabClassicBossViewHandle(tab:TabClassicBoss)
		{
			_tab = tab;
			this.skin = _tab.skin as MCClassicBoss;
			var temp:Array = [classicPage1,classicPage2];
		}
		
		public function init(rsrLoader:RsrLoader):void
		{
			_rsrLoader = rsrLoader;
			_pager = new PageListData(5);
			skin.addEventListener(MouseEvent.CLICK,onCLick);
			rsrLoader.addCallBack(skin.leftBtn,function(mc:MovieClip):void
			{
				mc.btnEnabled = false;
				mc.addEventListener(MouseEvent.CLICK,onCLick);
			}
			);
			
			rsrLoader.addCallBack(skin.rightBtn,function(mc:MovieClip):void
			{
				mc.btnEnabled = true;
				mc.addEventListener(MouseEvent.CLICK,onCLick);
			}
			);
			
		}
		
		internal function refresh():void
		{
			var manager:BossDataManager = BossDataManager.instance;
			_pager.list = manager.classicData.items;
			var data:Array = _pager.getCurrentPageData();
			if(!_pageHandle)
			{
				var index:int = _pager.curPage;
				var str:String = 'com.view.gameWindow.panel.panels.boss.classicPage'+index;
				var obj:Class = getDefinitionByName(str) as Class;
				_pageHandle = new TabClassBossPage(this,_rsrLoader);
				_pageHandle.init(new obj() as MovieClip);	
			}
			
			refreshItem(data);
		}
		
		
		private function refreshItem(data:Array):void
		{
			_pageHandle.refresh(data);
			skin.rightBtn.btnEnabled = _pager.hasNext();
			skin.leftBtn.btnEnabled =  _pager.hasPre();  
			_pageHandle.handleArrowMc(data.length);
		}
		
		private function onCLick(event:MouseEvent):void
		{
			var data:Array;
			if(event.target == skin.leftBtn)
			{
				_pager.prev(); 
				data = _pager.getCurrentPageData();
				change();
				refreshItem(data); 
			}
			else if(event.target == skin.rightBtn)
			{
				_pager.next();
				data = _pager.getCurrentPageData();
				change();
				refreshItem(data);
			}
			
			function change():void
			{
				_pageHandle.destroy();
				var index:int = _pager.curPage;
				var str:String = 'com.view.gameWindow.panel.panels.boss.classicPage'+index;
				var obj:Class = getDefinitionByName(str) as Class;
				//_pageHandle = new TabClassBossPage(this,_rsrLoader);
				_pageHandle.init(new obj() as MovieClip);	
			}
		}
		
		public function gotoSceneBoss(data:ClassicItemData):void
		{
			
			var mapId:int = SceneMapManager.getInstance().mapId;
			if(data.maps_noFlys.indexOf(String(mapId)) ==-1)
			{
				BossDataManager.instance.deliverBoss(data,2);				
			}
			else
			{
				if(SceneMapManager.getInstance().mapId == data.mapId)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.BOSS_PANEL_0029);
					return;
				} 
				//AutoJobManager.getInstance().setAutoTargetData(data.monsterCfgData.group_id,EntityTypes.ET_MONSTER);
				AutoSystem.instance.setTarget(data.monsterCfgData.group_id,EntityTypes.ET_MONSTER,data.map_monster_id);	
				PanelMediator.instance.closePanel(PanelConst.TYPE_BOSS);
			}
		 
		}
 
		internal function destroy():void
		{ 
			if(_pageHandle)
			{
				_pageHandle.destroy();
				_pageHandle = null;
			}

			_pager.destroy();
			_pager = null;
			skin = null;
			_tab = null;
		}
	}
}