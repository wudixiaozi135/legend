package com.view.gameWindow.panel.panels.closet.handle
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ClosetCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.closet.ClosetData;
	import com.view.gameWindow.panel.panels.closet.ClosetDataManager;
	import com.view.gameWindow.panel.panels.closet.McClosetPanel;
	import com.view.gameWindow.panel.panels.roleProperty.cell.FashionCell;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.RectRim;
	
	import flash.events.MouseEvent;

	/**
	 * 衣柜时装选择处理类
	 * @author Administrator
	 */	
	public class ClosetFashionChooseHandle
	{
		private const NUM_CELL:int = 7;
		private var _mc:McClosetPanel;
		private var _fashionCells:Vector.<FashionCell>;
		private var _currentSelect:int;
		
		private var _rectRim:RectRim;
		
		public function ClosetFashionChooseHandle(mc:McClosetPanel)
		{
			_mc = mc;
			init();
		}
		
		private function init():void
		{
			_mc.addEventListener(MouseEvent.CLICK,onClick);
			_mc.addEventListener(MouseEvent.ROLL_OVER,onOver,true);
			_mc.addEventListener(MouseEvent.ROLL_OUT,onOut,true);
			var i:int,l:int;
			l = NUM_CELL;
			_fashionCells = new Vector.<FashionCell>(l,true);
			for(i=0;i<l;i++)
			{
				var fashionCell:FashionCell = new FashionCell(_mc["mcFashionCell"+i]);
				_fashionCells[i] = fashionCell;
			}
		}
		
		protected function onOut(event:MouseEvent):void
		{
			var cell:FashionCell = event.target as FashionCell;
			if(cell)
			{
				destroyRim();
			}
		}
		
		protected function onOver(event:MouseEvent):void
		{
			var cell:FashionCell = event.target as FashionCell;
			if(cell && cell.fashionId)
			{
				var closetData:ClosetData = ClosetDataManager.instance.currentClosetData();
				if(!closetData)
				{
					return;
				}
				var fashionId:int = cell.fashionId;
				var selected:int = closetData.selected(fashionId);
				if(selected == _currentSelect)
				{
					return;
				}
				if(!_rectRim)
				{
					_rectRim = new RectRim(0xffcc00,cell.width,cell.height,1);
				}
				_rectRim.x = cell.x;
				_rectRim.y = cell.y;
				cell.parent.addChild(_rectRim);
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var manager:ClosetDataManager = ClosetDataManager.instance;
			var closetData:ClosetData = manager.currentClosetData();
			if(!closetData)
			{
				return;
			}
			var fashionIds:Vector.<int> = closetData.fashionIds;
			switch(event.target)
			{
				default:
					dealDefault(event);
					break;
				case _mc.btnPrev:
					if(_currentSelect > 0)
					{
						_currentSelect--;
						closetData.indexOf = _currentSelect;
						clickRefresh();
						manager.updateMode();
					}
					break;
				case _mc.btnNext:
					if(_currentSelect < fashionIds.length-1)
					{
						_currentSelect++;
						closetData.indexOf = _currentSelect;
						clickRefresh();
						manager.updateMode();
					}
					break;
				case _mc.btnChange:
					putOnFashion();
					showRollTip();
					break;
			}
		}
		
		private function dealDefault(event:MouseEvent):void
		{
			var cell:FashionCell = event.target as FashionCell;
			if(cell)
			{
				var fashionId:int = cell.fashionId;
				var manager:ClosetDataManager = ClosetDataManager.instance;
				var closetData:ClosetData = manager.currentClosetData();
				_currentSelect = closetData.selected(fashionId);
				clickRefresh();
				manager.updateMode();
			}
		}
		
		public function refresh():void
		{
			setSelect();
			clickRefresh();
		}
		/**设置选中的时装为穿戴着的时装*/
		private function setSelect():void
		{
			var closetData:ClosetData = ClosetDataManager.instance.currentClosetData();
			if(!closetData)
			{
				return;
			}
			_currentSelect = closetData.weared();
		}
		
		private function clickRefresh():void
		{
			var closetData:ClosetData = ClosetDataManager.instance.currentClosetData();
			if(!closetData)
			{
				return;
			}
			var fashionIds:Vector.<int> = closetData.fashionIds;
			_mc.btnChange.visible = Boolean(fashionIds.length);
			_mc.btnPrev.visible = _mc.btnNext.visible = _mc.btnChange.visible;
			if(fashionIds.length && fashionIds[_currentSelect] == closetData.fashionId)
			{
				_mc.btnChange.selected = true;//显示脱下
			}
			else
			{
				_mc.btnChange.selected = false;//显示穿上
			}
			var closetCfgData:ClosetCfgData = ConfigDataManager.instance.closetCfgData(closetData.type,closetData.level);
			var max:int = closetCfgData.max_count;
			_mc.txtClosetNum1.text = fashionIds.length+"/"+max;
			var i:int,l:int,index:int;
			l = NUM_CELL;
			for(i=0;i<l;i++)
			{
				var cell:FashionCell = _fashionCells[i];
				index = i-3+_currentSelect;
				if(index > -1 && index < fashionIds.length)
				{
					var fashionId:int = fashionIds[index];
					cell.refreshData(fashionId);
					ToolTipManager.getInstance().attach(cell);
				}
				else
				{
					cell.setNull();
					ToolTipManager.getInstance().detach(cell);
				}
			}
		}
		
		private function putOnFashion():void
		{
			if(_mc.btnChange.selected)//穿上
			{
				ClosetDataManager.instance.closetPutOn(_currentSelect);
			}
			else//脱下
			{
				ClosetDataManager.instance.closetPutOn(-1);
			}
		}
		/**显示穿上脱下时装滚动提示*/
		private function showRollTip():void
		{
			var closetData:ClosetData = ClosetDataManager.instance.currentClosetData();
			if(!closetData)
			{
				return;
			}
			var str:String;
			if(_mc.btnChange.selected)//穿上
			{
				str = StringConst.CLOSET_PANEL_0024 + closetData.selectFashionName(_currentSelect);
			}
			else//脱下
			{
				str = StringConst.CLOSET_PANEL_0025 + closetData.selectFashionName(_currentSelect);
			}
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,str);
		}
		
		public function destroy():void
		{
			_mc.removeEventListener(MouseEvent.CLICK,onClick);
			_mc.removeEventListener(MouseEvent.ROLL_OVER,onOver,true);
			_mc.removeEventListener(MouseEvent.ROLL_OUT,onOut,true);
			destroyRim();
			if(_fashionCells)
			{
				var fashionCell:FashionCell;
				for each(fashionCell in _fashionCells)
				{
					ToolTipManager.getInstance().detach(fashionCell);
					fashionCell.destroy();
				}
				_fashionCells = null;
			}
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
	}
}