package com.view.gameWindow.panel.panels.closet.putIn
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelBase;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.bag.cell.BagCell;
	import com.view.gameWindow.panel.panels.closet.ClosetData;
	import com.view.gameWindow.panel.panels.closet.ClosetDataManager;
	import com.view.gameWindow.panel.panels.closet.McClosetPutInPanel;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.RectRim;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	public class ClosetPutInPanel extends PanelBase implements IClosetPutInPanel
	{
		private var _numNew:int;
		private var _rectRim:RectRim;
		private var _selectBagCell:BagCell;
		/**bagCell字典使用cellId作为key*/
		private var _newBagCells:Dictionary,_exsitBagCells:Dictionary;
		private var _firstNewCellId:int,_firstExsitCellId:int;
		
		public function ClosetPutInPanel()
		{
			super();
			ClosetDataManager.instance.attach(this);
		}
		
		override public function destroy():void
		{
			var manager:ClosetDataManager = ClosetDataManager.instance;
			manager.selectCellId = -1;
			manager.detach(this);
			destroyCells();
			destroyRim();
			_selectBagCell = null;
			var mc:McClosetPutInPanel = _skin as McClosetPutInPanel;
			mc.removeEventListener(MouseEvent.CLICK,onClick);
			super.destroy();
		}
		
		private function destroyCells():void
		{
			_numNew = 0;
			var bagCell:BagCell;
			for each(bagCell in _newBagCells)
			{
				ToolTipManager.getInstance().detach(bagCell);
				bagCell.parent ? bagCell.parent.removeChild(bagCell) : null;
				bagCell.destory();
			}
			_newBagCells = null;
			for each(bagCell in _exsitBagCells)
			{
				ToolTipManager.getInstance().detach(bagCell);
				bagCell.parent ? bagCell.parent.removeChild(bagCell) : null;
				bagCell.destory();
			}
			_exsitBagCells = null;
		}
		
		private function destroyRim():void
		{
			if(_rectRim)
			{
				if(_rectRim.parent)
				{
					_rectRim.parent.removeChild(_rectRim);
				}
				_rectRim = null;
			}
		}
		
		override protected function initSkin():void
		{
			_skin = new McClosetPutInPanel();
			addChild(_skin);
			setTitleBar((_skin as McClosetPutInPanel).mcBg);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var mc:McClosetPutInPanel = _skin as McClosetPutInPanel;
			rsrLoader.addCallBack(mc.btnSure,function (mc:MovieClip):void
			{
				var textField:TextField = mc.txt as TextField;
				textField.textColor = 0xd4a460;
				textField.text = StringConst.CLOSET_PANEL_0017;
			});
			rsrLoader.addCallBack(mc.btnCancel,function (mc:MovieClip):void
			{
				var textField:TextField = mc.txt as TextField;
				textField.textColor = 0xd4a460;
				textField.text = StringConst.CLOSET_PANEL_0018;
			});
			rsrLoader.addCallBack(mc.btnAll,function (mc:MovieClip):void
			{
				var textField:TextField = mc.txt as TextField;
				textField.textColor = 0xd4a460;
				textField.text = StringConst.CLOSET_PANEL_0033;
			});
		}
		
		override protected function initData():void
		{
			var mc:McClosetPutInPanel = _skin as McClosetPutInPanel;
			mc.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var mc:McClosetPutInPanel = _skin as McClosetPutInPanel;
			var bagCell:BagCell = event.target as BagCell;
			if(bagCell)
			{
				clickDeal(bagCell);
				return;
			}
			switch(event.target)
			{
				case mc.btnSure:
					dealBtnSure();
					break;
				case mc.btnClose:
					dealBtnCancel();
					break;
				case mc.btnAll:
					dealAllPutIn();
					break;
			}
		}
		
		private function dealAllPutIn():void
		{
			// TODO Auto Generated method stub
			var manager:ClosetDataManager = ClosetDataManager.instance;
			var isGorgeousFull:Boolean = manager.isGorgeousFull();
			var isClosetFull:Boolean = manager.isClosetFull();
			if(isGorgeousFull && isClosetFull)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.CLOSET_PANEL_0023);
				return;
			}
			else if(isGorgeousFull && !isClosetFull)
			{
				if(!isSelectNew())
				{
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.CLOSET_PANEL_0023);
					return;
				}
				else
				{
					Alert.show2(StringConst.CLOSET_PANEL_0030,closetUpgradeAfterAll);
				}
			}
			else if(!isGorgeousFull && isClosetFull)
			{
				Alert.show2(StringConst.CLOSET_PANEL_0031,closetUpgradeAfterAll);
			}
			else
			{
				if(!isSelectNew())
				{
					Alert.show2(StringConst.CLOSET_PANEL_0032,closetUpgradeAfterAll);
				}
				else
				{
					closetUpgradeAfterAll();
				}
			}
		}
		
		private function dealBtnSure():void
		{
			if(!_selectBagCell)
			{
				return;
			}
			var manager:ClosetDataManager = ClosetDataManager.instance;
			var isGorgeousFull:Boolean = manager.isGorgeousFull();
			var isClosetFull:Boolean = manager.isClosetFull();
			if(isGorgeousFull && isClosetFull)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.CLOSET_PANEL_0023);
				return;
			}
			else if(isGorgeousFull && !isClosetFull)
			{
				if(!isSelectNew())
				{
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.CLOSET_PANEL_0023);
					return;
				}
				else
				{
					Alert.show2(StringConst.CLOSET_PANEL_0030,closetUpgrade,_selectBagCell.cellId);
				}
			}
			else if(!isGorgeousFull && isClosetFull)
			{
				Alert.show2(StringConst.CLOSET_PANEL_0031,closetUpgrade,_selectBagCell.cellId);
			}
			else
			{
				if(!isSelectNew())
				{
					Alert.show2(StringConst.CLOSET_PANEL_0032,closetUpgrade,_selectBagCell.cellId);
				}
				else
				{
					closetUpgrade(_selectBagCell.cellId);
				}
			}
		}
		
		private function closetUpgrade(slot:int):void
		{
			var manager:ClosetDataManager = ClosetDataManager.instance;
			manager.closetUpgrade(2,slot);
			manager.selectCellId = -1;
			_selectBagCell = null;
			_firstNewCellId = 0;
			_firstExsitCellId = 0;
		}
		
		private function closetUpgradeAfterAll():void
		{
			var manager:ClosetDataManager = ClosetDataManager.instance;
			var dic:Dictionary;
			if(!isSelectNew())
				dic = _exsitBagCells;
			else
				dic = _newBagCells;
			for each(var cell:BagCell in dic)
			{
				manager.closetUpgrade(2,cell.cellId);
			}
			manager.selectCellId = -1;
			_selectBagCell = null;
			_firstNewCellId = 0;
			_firstExsitCellId = 0;
		}
		
		private function dealBtnCancel():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_CLOSET_PUT_IN);
		}
		
		private function clickDeal(bagCell:BagCell):void
		{
			if(!_rectRim)
			{
				_rectRim = new RectRim(0xffcc00,46,46);
			}
			if(bagCell)
			{
				_rectRim.x = bagCell.x;
				_rectRim.y = bagCell.y;
				bagCell.parent.addChild(_rectRim);
				_selectBagCell = bagCell;
			}
			else
			{
				destroyRim();
			}
		}
		
		private function updateCells():void
		{
			destroyCells();
			_newBagCells = new Dictionary();
			_exsitBagCells = new Dictionary();
			var mc:McClosetPutInPanel = _skin as McClosetPutInPanel;
			var type:int = ClosetDataManager.instance.current;
			var closetData:ClosetData = ClosetDataManager.instance.closetDatas[type]
			var fashionDatasByType:Vector.<BagData> = BagDataManager.instance.getFashionDatasByType(type);
			var i:int,l:int,height:int,bagCell:BagCell;
			if(!closetData.fashionIds.length)
			{
				mc.mcLayer.parent ? mc.mcLayer.parent.removeChild(mc.mcLayer) : null;
				l = fashionDatasByType.length;
				for(i=0;i<l;i++)
				{
					bagCell = new BagCell();
					ToolTipManager.getInstance().attach(bagCell);
					bagCell.cellId = fashionDatasByType[i].slot;
					bagCell.initView();
					bagCell.refreshLockState(false);
					bagCell.x = 16+55*(i%4);
					bagCell.y = 69+48*int(i/4);
					if(bagCell.y > height)
					{
						height = bagCell.y;
					}
					mc.addChild(bagCell);
					bagCell.refreshData(fashionDatasByType[i]);
					_newBagCells[bagCell.cellId] = bagCell;
					if(!_firstNewCellId)
					{
						_firstNewCellId = bagCell.cellId;
					}
				}
				mc.btnSure.y = height+bagCell.height+23;
				mc.btnAll.y = height+bagCell.height+23;
				mc.mcBg.height = mc.btnSure.y+mc.btnSure.height+12;
				_numNew = l;
			}
			else//衣橱中有时装
			{
				var j:int,jl:int,isNew:Boolean;
				jl = closetData.fashionIds.length;
				l = fashionDatasByType.length;
				if(l == 0)
				{
					return;
				}
				for(i=0;i<l;i++)
				{
					isNew = true;
					for(j=0;j<jl;j++)
					{
						var baseId:int = closetData.fashionIds[j];
						var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(fashionDatasByType[i].bornSid,fashionDatasByType[i].id);
						if(memEquipData.baseId == baseId)
						{
							isNew = false;
						}
					}
					bagCell = new BagCell();
					ToolTipManager.getInstance().attach(bagCell);
					bagCell.cellId = fashionDatasByType[i].slot;
					bagCell.initView();
					bagCell.refreshLockState(false);
					if(isNew)
					{
						bagCell.x = 16+55*(_numNew%4);
						bagCell.y = 69+48*int(_numNew/4);
						if(bagCell.y > height)
						{
							height = bagCell.y;
						}
						mc.addChild(bagCell);
						bagCell.refreshData(fashionDatasByType[i]);
						_numNew++;
						_newBagCells[bagCell.cellId] = bagCell;
						if(!_firstNewCellId)
						{
							_firstNewCellId = bagCell.cellId;
						}
					}
					else
					{
						bagCell.x = 6+55*((i-_numNew)%4);
						bagCell.y = 48+48*int((i-_numNew)/4);
						mc.mcLayer.addChild(bagCell);
						bagCell.refreshData(fashionDatasByType[i]);
						_exsitBagCells[bagCell.cellId] = bagCell;
						if(!_firstExsitCellId)
						{
							_firstExsitCellId = bagCell.cellId;
						}
					}
				}
				if(_numNew == l)
				{
					mc.mcLayer.parent ? mc.mcLayer.parent.removeChild(mc.mcLayer) : null;
					mc.btnSure.y = height+bagCell.height+23;
					mc.btnAll.y = height+bagCell.height+23;
				}
				else
				{
					!mc.mcLayer.parent ? mc.addChild(mc.mcLayer) : null;
					mc.mcLayer.y = height+bagCell.height+23;
					mc.btnSure.y = mc.mcLayer.y+mc.mcLayer.height+23;
					mc.btnAll.y = mc.mcLayer.y+mc.mcLayer.height+23;
				}
				mc.mcBg.height = mc.btnSure.y+mc.btnSure.height+12;
			}
		}
		
		private function updateTxts():void
		{
			var isGorgeousFull:Boolean = ClosetDataManager.instance.isGorgeousFull();
			var str:String = isGorgeousFull ? StringConst.CLOSET_PANEL_0028 : StringConst.CLOSET_PANEL_0015;
			var mc:McClosetPutInPanel = _skin as McClosetPutInPanel;
			var search:int = str.search("&x");
			mc.txt.text = StringConst.CLOSET_PANEL_0015.replace("&x",_numNew);
			var textFormat:TextFormat = mc.txt.getTextFormat(search,search+1);
			textFormat.color = 0x00ff00;
			mc.txt.setTextFormat(textFormat,search,search+1);
			(mc.mcLayer.txt as TextField).text = isGorgeousFull ? StringConst.CLOSET_PANEL_0029 : StringConst.CLOSET_PANEL_0016;
		}
		
		private function setSelect():void
		{
			var selectCellId:int,bagCell:BagCell;
			selectCellId = ClosetDataManager.instance.selectCellId;
			if(selectCellId != -1)
			{
				bagCell = _newBagCells[selectCellId] || _exsitBagCells[selectCellId];
			}
			else
			{
				bagCell = _newBagCells[_firstNewCellId] || _exsitBagCells[_firstExsitCellId];
			}
			if(bagCell)
			{
				clickDeal(bagCell);
			}
		}
		
		override public function update(proc:int=0):void
		{
			updateCells();
			updateTxts();
			setSelect();
			if(!isExistCanPut())
			{
				dealBtnCancel();
			}
		}
		
		override public function setPostion():void
		{
			var rect:Rectangle = getPanelRect();
			var panel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_CLOSET);
			if(panel)
			{
				var rect2:Rectangle = panel.getPanelRect();
				var postion:Point = panel.postion;
				var newX:int = int(postion.x + (rect2.width - rect.width)*.5);
				x != newX ? x = newX : null;
				var newY:int = int(postion.y + (rect2.height - rect.height)*.5);
				y != newY ? y = newY : null;
			}
			else
			{
				super.setPostion();
			}
		}
		/**是否存在可放入时装*/
		private function isExistCanPut():Boolean
		{
			var cell:BagCell;
			for each (cell in _exsitBagCells)
			{
				if(cell)
				{
					return true;
				}
			}
			for each (cell in _newBagCells)
			{
				if(cell)
				{
					return true;
				}
			}
			return false;
		}
		/**是否是选中新的时装*/
		private function isSelectNew():Boolean
		{
			var cell:BagCell;
			for each (cell in _newBagCells)
			{
				if(cell == _selectBagCell)
				{
					return true;
				}
			}
			return false;
		}
	}
}