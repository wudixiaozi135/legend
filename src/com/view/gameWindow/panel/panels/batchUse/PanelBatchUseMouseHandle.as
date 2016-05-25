package com.view.gameWindow.panel.panels.batchUse
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.ItemTypeCfgData;
	import com.model.consts.ConstStorage;
	import com.model.consts.ItemType;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class PanelBatchUseMouseHandle
	{
		private var _panel:PanelBatchUse;
		private var _mc:McBatchUse;
		internal var useNum:int = 1;
		
		public function PanelBatchUseMouseHandle(panel:PanelBatchUse)
		{
			_panel = panel;
			_mc = _panel.skin as McBatchUse;
			init();
		}
		
		private function init():void
		{
			_mc.addEventListener(MouseEvent.CLICK,onClick);
			_mc.mcVernier.mouseEnabled = true;
			_mc.mcVernier.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			useNum = int(_mc.txtValue.text);
		}
		
		protected function onDown(event:MouseEvent):void
		{
			_mc.stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
			_mc.stage.addEventListener(Event.ENTER_FRAME,onFrame);
			var w:Number = _mc.mcProgress.width - _mc.mcVernier.width;
			_mc.mcVernier.startDrag(false,new Rectangle(_mc.mcProgress.x,_mc.mcVernier.y,w,0));
		}
		
		protected function onUp(event:MouseEvent):void
		{
			_mc.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			_mc.stage.removeEventListener(Event.ENTER_FRAME,onFrame);
			_mc.mcVernier.stopDrag();
			if(useNum < 1)
			{
				useNum = 1;
			}
			_panel.viewHandle.refresh(useNum);
		}
		
		protected function onFrame(event:Event):void
		{
			var startX:Number = _mc.mcProgress.x;
			var w:Number = _mc.mcProgress.width - _mc.mcVernier.width;
			var total:int = _panel.viewHandle.total;
			useNum = int((_mc.mcVernier.x - startX)/(w/total));
			_panel.viewHandle.refresh(useNum,true);
			var scaleX:Number = (_mc.mcVernier.x - startX)/w;
			_mc.mcProgress.mcMask.scaleX = scaleX;
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				default:
					break;
				case _mc.btnClose:
					dealClose();
					break;
				case _mc.btnDo:
					dealUse();
					break;
				case _mc.btnLeft:
					dealLeft();
					break;
				case _mc.btnRight:
					dealRight();
					break;
			}
		}
		
		private function dealClose():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_BATCH);
		}
		
		private function dealUse():void
		{
			var str:String;
			var id:int = _panel.viewHandle.id;
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(id);
			var itemTypeCfgData:ItemTypeCfgData = ConfigDataManager.instance.itemTypeCfgData(itemCfgData.type);
			if(!itemCfgData)
			{
				return;
			}
			var job:int,sex:int,lv:int;
			var storage:int = _panel.viewHandle.storage;
			if(storage == ConstStorage.ST_CHR_BAG)
			{
				job = RoleDataManager.instance.job;
				sex = RoleDataManager.instance.sex;
				lv = RoleDataManager.instance.lv;
				
				var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
				if (firstPlayer.isPalsy && storage == ConstStorage.ST_CHR_BAG)
				{
					return;
				}
			}
			else if(storage == ConstStorage.ST_HERO_BAG)
			{
				job = HeroDataManager.instance.job;
				sex = HeroDataManager.instance.sex;
				lv = HeroDataManager.instance.lv;
			}
			if(itemCfgData.job && itemCfgData.job != job)
			{
				trace("in PanelBatchUseMouseHandle.dealUse 职业不对");
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0013);
				return;
			}
			if(itemCfgData.entity && itemCfgData.entity != EntityTypes.ET_PLAYER && storage == ConstStorage.ST_CHR_BAG)
			{
				trace("in PanelBatchUseMouseHandle.dealUse 使用者不对");
				var replace:String = StringConst.BAG_PANEL_0016.replace("&x",StringConst.BAG_PANEL_0017).replace("&y",itemCfgData.name);
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,replace);
				return;
			}
			if(itemCfgData.level > lv)
			{
				trace("in PanelBatchUseMouseHandle.dealUse 等级不够");
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0015);
				return;
			}
			str = ItemType.itemTypeName(itemCfgData.type);
			if(str != "")
			{
				if(itemCfgData.type == ItemType.IT_ENERGY || itemCfgData.type == ItemType.IT_ENERGY2)
				{
					str = str.replace("xx",String(useNum*int(itemCfgData.effect))).replace("xx",String(useNum*int(itemCfgData.effect))); 
				}
				else
				{
					str = str + String(useNum*int(itemCfgData.effect));
				}
				RollTipMediator.instance.showRollTip(RollTipType.REWARD,str);
			}
			
			var slot:int = _panel.viewHandle.slot;
			BagDataManager.instance.sendUseData(slot,storage,useNum);
			PanelMediator.instance.closePanel(PanelConst.TYPE_BATCH);
		}
		
		private function dealLeft():void
		{
			useNum = 1;
			_panel.viewHandle.refresh(useNum);
		}
		
		private function dealRight():void
		{
			var total:int = _panel.viewHandle.total;
			useNum = total;
			_panel.viewHandle.refresh(useNum);
		}
		
		public function destroy():void
		{
			if(_mc)
			{
				_mc.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
				_mc.mcVernier.removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
				_mc.removeEventListener(MouseEvent.CLICK,onClick);
				_mc = null;
			}
			_panel = null;
		}
	}
}