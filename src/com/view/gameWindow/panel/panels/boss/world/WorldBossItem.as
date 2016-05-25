package com.view.gameWindow.panel.panels.boss.world
{
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.view.gameWindow.panel.panels.boss.McWorldBossItem;
	import com.view.gameWindow.util.UrlPic;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class WorldBossItem
	{
		private var _tab:TabWorldBoss;
		private var _skin:McWorldBossItem;
		private var _urlpic:UrlPic;
		
		public var data:WorldBossItemData;
		
		private var _isClick:Boolean = false;
		public function WorldBossItem(tab:TabWorldBoss,skin:MovieClip)
		{
			_tab = tab;
			_skin = skin as McWorldBossItem;
			_skin.mcstate.visible = false;

			_skin.mouseChildren =false;
			_skin.useHandCursor = true;
			_skin.doubleClickEnabled = true;
			_skin.addEventListener(MouseEvent.CLICK,onCLick);
			_skin.addEventListener(MouseEvent.ROLL_OVER,onOver);
			_skin.addEventListener(MouseEvent.ROLL_OUT,onOut);
			_skin.addEventListener(Event.ADDED_TO_STAGE,onAdd);
			_skin.addEventListener(Event.REMOVED_FROM_STAGE,onRemove);
		}
		public function onCLick(e:MouseEvent = null):void
		{
			setVisible(true);
			_isClick = true;
			_tab.viewHandle.setItemShow(data);
		}
		public function firstShow():void
		{
			_isClick = true;
			_tab.viewHandle.setItemShow(data);
		}
		private function onOver(e:MouseEvent):void
		{
			setVisible(true);
		}
		private function onOut(e:MouseEvent):void
		{
			if(!_isClick)
			{
				setVisible(false);
			}
		}
		
		private function onAdd(e:Event):void
		{
			_skin.stage.addEventListener(MouseEvent.CLICK,onStageClick);
		}
		
		private function onRemove(e:Event):void
		{
			_skin.stage.removeEventListener(MouseEvent.CLICK,onStageClick);
			_skin.removeEventListener(Event.ADDED_TO_STAGE,onAdd);
			_skin.removeEventListener(Event.REMOVED_FROM_STAGE,onRemove);
		}
		
		private function onStageClick(e:MouseEvent):void
		{
			if((e.target is McWorldBossItem) && e.target!=_skin)
			{
				setVisible(false);
				_isClick = false;
			}
			
		}
		public function setVisible(bool:Boolean):void
		{
			if(_skin)
				_skin.mcstate.visible = bool; 
		}
		 
		public function refresh(data:WorldBossItemData):void
		{
			this.data = data;
			_skin.picBox.resUrl = "worldBoss/"+data.url+".png";
			_tab.loadNewSource(_skin.picBox);
		}
		
		internal function destroy():void
		{
			
			if(_skin.parent)
			{
				_skin.parent.removeChild(_skin);	
			}			
			_skin.removeEventListener(MouseEvent.CLICK,onCLick);
			_skin.removeEventListener(MouseEvent.ROLL_OVER,onOver);
			_skin.removeEventListener(MouseEvent.ROLL_OUT,onOut);			
			_skin = null;
			data = null;
			_isClick = false;
		}
	}
}