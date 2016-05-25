package com.view.gameWindow.panel.panels.split
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.consts.ConstStorage;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * 拆分面板鼠标相关处理类
	 * @author Administrator
	 */	
	public class PanelSplitMouseHandle
	{
		private var _panel:PanelSplit;
		private var _mc:McSplit;
		/**第一堆数量*/
		internal var count1:int;
		
		public function PanelSplitMouseHandle(panel:PanelSplit)
		{
			_panel = panel;
			_mc = _panel.skin as McSplit;
			init();
		}
		
		private function init():void
		{
			_mc.mcVernier.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			_mc.addEventListener(MouseEvent.CLICK,onClick);
			count1 = int(_panel.viewHandle.count/2)
		}
		
		protected function onDown(event:MouseEvent):void
		{
			_mc.stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
			_mc.stage.addEventListener(Event.ENTER_FRAME,onFrame);
			_mc.mcVernier.startDrag(false,new Rectangle(_mc.mcScaleplate.x-_mc.mcVernier.width/2,_mc.mcVernier.y,_mc.mcScaleplate.width,0));
		}
		
		protected function onFrame(event:Event):void
		{
			var piecesW:Number = _mc.mcScaleplate.width/_panel.viewHandle.count;
			var startX:Number = _mc.mcScaleplate.x-_mc.mcVernier.width/2;
			count1 = int((_mc.mcVernier.x - startX)/piecesW);
			_panel.viewHandle.refresh(count1,true);
		}
		
		protected function onUp(event:MouseEvent):void
		{
			_mc.stage.removeEventListener(Event.ENTER_FRAME,onFrame);
			_mc.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			_mc.mcVernier.stopDrag();
			var total:int = _panel.viewHandle.count;
			if(count1 < 1)
			{
				count1 = 1;
			}
			else if(count1 > total-1)
			{
				count1 = total-1;
			}
			_panel.viewHandle.refresh(count1);
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
					dealDo();
					break;
				case _mc.btnAdd:
					dealAdd();
					break;
				case _mc.btnMinus:
					dealMinus();
					break;
			}
		}
		
		private function dealClose():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_SPLIT);
		}
		
		private function dealDo():void
		{
			var storage:int = PanelSplitData.storage;
			var slot:int = PanelSplitData.slot;
			var firstEmptyCellId:int;
			if(storage == ConstStorage.ST_CHR_BAG)
			{
				firstEmptyCellId = BagDataManager.instance.getFirstEmptyCellId();
				if(firstEmptyCellId == -1)
				{
					return;
				}
			}
			else if(storage == ConstStorage.ST_HERO_BAG)
			{
				firstEmptyCellId = HeroDataManager.instance.getFirstEmptyCellId();
				if(firstEmptyCellId == -1)
				{
					return;
				}
			}
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(storage);
			byteArray.writeByte(slot);
			byteArray.writeInt(count1);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SPLIT_ITEM,byteArray);
			PanelMediator.instance.closePanel(PanelConst.TYPE_SPLIT);
		}
		
		private function dealAdd():void
		{
			var total:int = _panel.viewHandle.count;
			if(count1 < total-1)
			{
				count1++;
				_panel.viewHandle.refresh(count1);
			}
		}
		
		private function dealMinus():void
		{
			if(count1 > 1)
			{
				count1--;
				_panel.viewHandle.refresh(count1);
			}
		}
		
		public function destroy():void
		{
			if(_mc)
			{
				_mc.stage.removeEventListener(Event.ENTER_FRAME,onFrame);
				_mc.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
				_mc.mcVernier.stopDrag();
				_mc.removeEventListener(MouseEvent.CLICK,onClick);
				_mc = null;
			}
			_panel = null;
		}
	}
}