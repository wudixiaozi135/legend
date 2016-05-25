package com.view.gameWindow.panel.panels.map
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.map.mappic.MapPicHandle;
	import com.view.gameWindow.panel.panels.map.mappic.MapSign;
	import com.view.gameWindow.panel.panels.map.mappic.MapSignTypes;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class MapMouseEventHandle
	{
		private var _mc:McMapPanel;
		public var mapPicHandle:MapPicHandle;
		
		public function MapMouseEventHandle()
		{
		}
		
		public function addEvent(mc:McMapPanel):void
		{
			_mc = mc;
			_mc.addEventListener(MouseEvent.CLICK,clickHandle);
			_mc.searchText.addEventListener(Event.CHANGE,searchTextInputHandler);
		}
		
		private function searchTextInputHandler(e:Event):void
		{
			if(_mc.searchText.text)
			{
				mapPicHandle.mapSidebar.showSearch(_mc.searchText.text,_mc,_mc.searchText.x,_mc.searchText.y+_mc.searchText.height);
			}
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			if (evt.target != _mc.closeBtn)
			{
				if (RoleDataManager.instance.stallStatue)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
					return;
				}
			}
			if(evt.target is MapSign){
				var mapSign:MapSign=evt.target as MapSign;
				var signType:int=mapSign.type;
				switch (signType){
					default :break;
					case MapSignTypes.TELEPORTER:
						if(mapSign.mapTeleportData)
						{
							AutoSystem.instance.stopAutoEx();
							AutoJobManager.getInstance().setAutoTargetData(mapSign.mapTeleportData.id,EntityTypes.ET_TELEPORTER);
							mapPicHandle.removePathSigns();
						}
						break;
					case MapSignTypes.RED:
						if(mapSign.monsterData)
						{
							AutoSystem.instance.stopAutoEx();
							/*AutoJobManager.getInstance().setAutoTargetData(mapSign.monsterData.group_id,EntityTypes.ET_MONSTER);*/
							AutoSystem.instance.setTarget(mapSign.monsterData.group_id,EntityTypes.ET_MONSTER);
							mapPicHandle.removePathSigns();
						}
						break;
					case MapSignTypes.GREEN:
						if(mapSign.npcData)
						{
							AutoSystem.instance.stopAutoEx();
							AutoJobManager.getInstance().setAutoTargetData(mapSign.npcData.id,EntityTypes.ET_NPC);
							mapPicHandle.removePathSigns();
						}
						break;
				}
				return;
			}
			
			switch(evt.target)
			{
				case _mc.closeBtn:
					PanelMediator.instance.closePanel(PanelConst.TYPE_MAP);
					break;
				case _mc.currentMap:
					_mc.currentMap.selected = true;
					_mc.currentTxt.text = StringConst.MAP_PANEL_0001;
					_mc.currentTxt.textColor = 0xffe1aa;
					_mc.worldMap.selected = false;
					_mc.worldTxt.text = StringConst.MAP_PANEL_0002;
					_mc.worldTxt.textColor = 0x675138;
					break;
				case _mc.worldMap:
					//					_mc.worldMap.selected = true;
					//					_mc.worldTxt.text = StringConst.MAP_PANEL_0002;
					//					_mc.worldTxt.textColor = 0xffe1aa;
					//					_mc.currentMap.selected = false;
					//					_mc.currentTxt.text = StringConst.MAP_PANEL_0001;
					//					_mc.currentTxt.textColor = 0x675138;
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.MAP_PANEL_0006);
					break;
				case _mc.mcPic:
					mapPicHandle.clickMove();
					break;
				case _mc.goBtn:
					mapPicHandle.goTo(_mc);
					break;
				case _mc.searchText:
					if(!_isSearchTextClick)
					{
						_mc.searchText.text = "";
						_isSearchTextClick = true;
					}
					else
					{
						if(_mc.searchText.text)
						{
							mapPicHandle.mapSidebar.showSearch(_mc.searchText.text,_mc,_mc.searchText.x,_mc.searchText.y+_mc.searchText.height);
						}
					}
					break;
			}
		}
		
		private var _isSearchTextClick:Boolean = false;
		
		public function mouseEventDestroy():void
		{
			mapPicHandle = null;
			_mc.removeEventListener(MouseEvent.CLICK,clickHandle);
			_mc = null;
		}
	}
}