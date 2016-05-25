package com.view.gameWindow.panel.panels.storage
{
	import com.model.consts.ConstStorage;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelBase;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.cell.BagCell;
	import com.view.gameWindow.panel.panels.prompt.Panel1BtnPromptData;
	import com.view.gameWindow.util.UtilGetCfgData;
	
	import flash.events.MouseEvent;

 
	public class StorageCellClickHandle
	{
		private var _panel:PanelStorage;
		private var _skin:McStaorge;
		private var _bagCell:BagCell;
		/**取消一次点击UP事件的触发*/
		internal var cancelOnce:Boolean;

		public function StorageCellClickHandle(panel:PanelStorage)
		{
			_panel = panel;
			_skin = _panel.skin as McStaorge;
			_skin.doubleClickEnabled = true;
			_skin.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick);
			 
		}
 
		protected function onDoubleClick(event:MouseEvent):void
		{
			_bagCell = event.target as BagCell;
			if(!_bagCell||_bagCell.isLock||_bagCell.isEmpty())
			{
				return;
			}
			var panel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_BAG);
			if(panel)
			{
				var storageId:int = StorageDataMannager.instance.storageId;
				storageId = ConstStorage.ST_STORAGE[storageId];
				StorageDataMannager.instance.moveStorageItem(storageId,_bagCell.cellId,ConstStorage.ST_CHR_BAG);
			}
			
		}
 
		/**处理丢弃*/
		internal function dealLitter(bagCell:BagCell,bagData:BagData,isDrag:Boolean = false):void
		{
			if(!bagCell)
			{
				return;
			}
			if(isDrag && _panel.isMouseOn())
			{
				return;
			}
			var panelHero:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_HERO);
			if(panelHero && panelHero.isMouseOn())
			{
				return;
			}
			var panelRole:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_ROLE_PROPERTY);
			if(panelRole && panelRole.isMouseOn())
			{
				return;
			}
			//var bagData:BagData = bagCell.bagData;
			var bind:int = bagData.bind;
			var type:int = bagData.type;
			var utilGetCfgData:UtilGetCfgData = new UtilGetCfgData();
			var cfgData:Object = type == SlotType.IT_EQUIP ? utilGetCfgData.GetEquipCfgData(bagData.id,bagData.bornSid) : utilGetCfgData.GetItemCfgData(bagData.id);
			if(!cfgData)
			{
				trace("BagCellClickHandle.dealLitter 配置信息不存在");
				return;
			}
			if(!cfgData.hasOwnProperty("can_sell"))
			{
				trace("BagCellClickHandle.dealLitter 配置信息中所取的变量不存在");
				return;
			}
			var can_sell:int = cfgData.can_sell;
			if(bind)//绑定且不能出售，销毁道具
			{
				dealDestory(bagCell);
			}
			 
			else//不绑定，丢弃道具
			{
				//dealTrueLitter(bagCell);
				StorageDataMannager.instance.dropStorageItem(bagCell.cellId);
			}
		}
		 
		private function dealDestory(bagCell:BagCell):void
		{
			Alert.show2(StringConst.BAG_PANEL_0020,function (bagCell:BagCell):void
			{
				StorageDataMannager.instance.destoryStorageItem(bagCell.cellId);
			},bagCell,StringConst.BAG_PANEL_0021);
		}
		
		 
		
		internal function destory():void
		{
			 
			_bagCell = null;
			if(_skin)
			{
				_skin.removeEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick);
			}
			_skin = null;
			_panel = null;
		}
	}
}