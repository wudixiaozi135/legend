package com.view.gameWindow.panel.panels.storage
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.cell.BagCell;
	import com.view.gameWindow.panel.panels.storage.access.PanelAccess;
	import com.view.gameWindow.panel.panels.stronger.StrongerDataManager;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.SimpleStateButton;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import mx.utils.StringUtil;

	public class PanelStorageMouseHandle
	{
		private var _panel:PanelStorage; 
		private var _skin:McStaorge;	
		private var _lastBtn:MovieClip;
		
		public var cellClickHandle:StorageCellClickHandle;
		public var cellDragHandle:StorageCellDragHandle;
		 
		public function PanelStorageMouseHandle(panel:PanelStorage)
		{
			_panel = panel;
			_skin = panel.skin as McStaorge;
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			_skin.addEventListener(MouseEvent.MOUSE_OVER,onOver);
			_skin.addEventListener(MouseEvent.MOUSE_OUT,onOut);
			cellClickHandle = new StorageCellClickHandle(panel);
			cellDragHandle = new StorageCellDragHandle(panel);
			
		}
 
		public function init(rsloader:RsrLoader):void
		{
			 
			for(var i:int = 0;i < 5;i++)
			{
				rsloader.addCallBack(_skin['page'+i],getFun(i));
			}
 
			rsloader.addCallBack(_skin.btnLock,function (mc:MovieClip):void
			{
				mc.selected = Boolean(StorageDataMannager.instance.isHavePassWord);
				SimpleStateButton.addState(mc);
			}
			);
 
			rsloader.addCallBack(_skin.btnArrange,function (mc:MovieClip):void
			{
				mc.txt.text = StringConst.STORAGE_003;
				mc.txt.mouseEnabled = false; 
				mc.txt.textColor = 0xd4a460;
			}
			); 
			
			SimpleStateButton.addState(_skin.txtCoin1,StringConst.STORAGE_060);
			SimpleStateButton.addState(_skin.txtGold1,StringConst.STORAGE_060);
			
		}
	
		private function getFun(index:int):Function
		{
			var fun:Function = function (mc:MovieClip):void
			{
				mc.txt.text = StringUtil.substitute(StringConst.STORAGE_002,StringConst['NUM_000'+(index+1)]);
				mc.txt.textColor = 0xd4a460;
				if(index == 0)
				{
					_lastBtn = mc;
					mc.txt.textColor = 0xffe1aa;
					mc.mouseEnabled = false;
					mc.selected = true;
				}
			}
			
			return fun;
		}
 
		private function onClick(e:MouseEvent):void
		{
			trace(e.target,_skin.btnArrange);
			var access:PanelAccess = PanelMediator.instance.openedPanel(PanelConst.TYPE_STORAGE_ACCESS) as PanelAccess;
			switch(e.target)
			{
				case _skin.btnClose:
					PanelMediator.instance.closePanel(PanelConst.TYPE_STORAGE);
					break;
				case _skin.page0:
					dealBtn(0,_skin.page0);
					break;
				case _skin.page1:
					dealBtn(1,_skin.page1);
					break;
				case _skin.page2:
					dealBtn(2,_skin.page2);
					break;
				case _skin.page3:
					dealBtn(3,_skin.page3);
					break;
				case _skin.page4:
					dealBtn(4,_skin.page4);
					break;
			    case _skin.txtCoin1:
				case _skin.txtCoin:
				 
					StorageDataMannager.instance.goldOrCoin = 2;
				 
					if(access)
						access.viewhandle.changeTilte();
					else
						PanelMediator.instance.switchPanel(PanelConst.TYPE_STORAGE_ACCESS);
					break;
				case _skin.txtGold1:
				case _skin.txtGold:
				 	
					StorageDataMannager.instance.goldOrCoin = 1;
					if(access)
						access.viewhandle.changeTilte();
					else
						PanelMediator.instance.switchPanel(PanelConst.TYPE_STORAGE_ACCESS);
					break;
				 
				case _skin.btnLock:
					
					PanelMediator.instance.openPanel(PanelConst.TYPE_STORAGE_CODE);
					break;
				case _skin.btnArrange:
					StorageDataMannager.instance.arrangeStorage();
					break;
			}
			
			 
		}
		public function showPage(param0:int):void
		{
			
			dealBtn(0,_skin.page0);
		}
		
		private function onOver(e:MouseEvent):void
		{
			var cell:BagCell = e.target as BagCell;
			if(cell)
			{
				_skin.setChildIndex(_skin.selectCellEfc,_skin.numChildren-1);
				_skin.selectCellEfc.x=cell.x+5;
				_skin.selectCellEfc.y=cell.y+5;
				_skin.selectCellEfc.visible=true;
			}
		}
		
		private function onOut(e:MouseEvent):void
		{
			var cell:BagCell = e.target as BagCell;
			if(cell)
			{
				_skin.selectCellEfc.visible=false;
			}
		}
		
		 
		public function dealBtn(index:int,nowBtn:MovieClip):void
		{
			if(!_lastBtn || nowBtn == _lastBtn)
				return;
 
			_lastBtn.selected = false;
			_lastBtn.mouseEnabled = true;
			(_lastBtn.txt as TextField).textColor = 0xd4a460;
			(_lastBtn.txt as TextField)			
			nowBtn.selected = true;
			nowBtn.mouseEnabled = false;
			(nowBtn.txt as TextField).textColor = 0xffe1aa;
			_lastBtn = nowBtn;
			var flag:Boolean = flagVip(index);
			if(flag)
			{
				StorageDataMannager.instance.storageId = index;
				StorageDataMannager.instance.queryStoreitems(index); 	 
			}	
			else
			{
				_panel.viewHandle.clearCells();
			}
			
		}
		
		
		public function flagVip(index:int):Boolean
		{
			var vip:int = VipDataManager.instance.lv;
			var needVip:int = StorageData.vipLevel[index];
			if(index == 0 || vip >= needVip)
			{
				_panel.viewHandle.showLock(false,0);
				return true;
			}
 			
			_panel.viewHandle.showLock(true,needVip);
			RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringUtil.substitute(StringConst.STORAGE_005,needVip.toString()));		
			return false;
		}
		
		public function showLockBtn(flag:Boolean):void
		{
			if(!flag)
			{
				if(_skin.btnLock.currentLabels.length)
					_skin.btnLock.gotoAndStop('up');//selectedUp
			}
			else
			{
				if(_skin.btnLock.currentLabels.length)
					_skin.btnLock.gotoAndStop('selectedUp');
			} 
			// true lock    false unlock
		}
		internal function destroy():void
		{ 
			for(var i:int = 0;i < 5;i++)
			{
				_skin['page'+i].removeEventListener(MouseEvent.CLICK,onClick);
			}
			if(_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK,onClick);
				_skin.removeEventListener(MouseEvent.ROLL_OUT,onOut);
				_skin.removeEventListener(MouseEvent.ROLL_OVER,onOver);
				
				_skin.btnArrange.removeEventListener(MouseEvent.CLICK,onClick);
				_skin.btnLock.removeEventListener(MouseEvent.CLICK,onClick);
				SimpleStateButton.removeState(_skin.txtCoin1);
				SimpleStateButton.removeState(_skin.txtGold1);
				SimpleStateButton.removeState(_skin.btnLock);
				_skin = null;
			}
			cellClickHandle.destory();
			cellDragHandle.destroy();
			cellDragHandle = null;
			cellClickHandle = null;
			_panel = null;
			
		}
		
		
	}
}