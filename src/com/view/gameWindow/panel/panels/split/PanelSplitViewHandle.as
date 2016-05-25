package com.view.gameWindow.panel.panels.split
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.cell.BagCell;

	/**
	 * 拆分面板界面处理类
	 * @author Administrator
	 */	
	public class PanelSplitViewHandle
	{
		private var _panel:PanelSplit;
		private var _mc:McSplit;
		private var _item0:BagCell,_item1:BagCell,_item2:BagCell;
		internal var id:int,type:int,count:int;
		
		public function PanelSplitViewHandle(panel:PanelSplit)
		{
			_panel = panel;
			_mc = _panel.skin as McSplit;
			init();
		}
		
		private function init():void
		{
			id = PanelSplitData.id;
			type = PanelSplitData.type;
			count = PanelSplitData.cout;
			//
			_mc.txtTitle.text = StringConst.SPLIT_PANEL_0001;
			_mc.txtTitle.mouseEnabled = false;
			_mc.txtItem0.text = StringConst.SPLIT_PANEL_0002;
			_mc.txtItem1.text = StringConst.SPLIT_PANEL_0003;
			_mc.txtItem2.text = StringConst.SPLIT_PANEL_0004;
			_mc.txtInfo0.text = StringConst.SPLIT_PANEL_0005;
			_mc.txtInfo1.text = StringConst.SPLIT_PANEL_0006;
			_mc.txtBtn.text = StringConst.SPLIT_PANEL_0007;
			_mc.txtBtn.mouseEnabled = false;
			//
			_item0 = new BagCell();
			_item0.initView();
			_item0.refreshLockState(false);
			_item0.refreshData(getBagData(count));
			_item0.x = _mc.mcBg0.x;
			_item0.y = _mc.mcBg0.y;
			_mc.addChild(_item0);
			_item1 = new BagCell();
			_item1.initView();
			_item1.refreshLockState(false);
			_item1.x = _mc.mcBg1.x;
			_item1.y = _mc.mcBg1.y;
			_mc.addChild(_item1);
			_item2 = new BagCell();
			_item2.initView();
			_item2.refreshLockState(false);
			_item2.x = _mc.mcBg2.x;
			_item2.y = _mc.mcBg2.y;
			_mc.addChild(_item2);
			//
			refresh(int(count/2));
		}
		
		private function getBagData(count:int):BagData
		{
			var bagData:BagData = new BagData();
			bagData.id = id;
			bagData.type = type;
			bagData.count = count;
			return bagData;
		}
		
		internal function refresh(count1:int,isDrag:Boolean = false):void
		{
			_mc.txtNum.text = count1+"";
			_item1.refreshData(getBagData(count1));
			_item2.refreshData(getBagData(count-count1));
			if(!isDrag)
			{
				_mc.mcVernier.x = _mc.mcScaleplate.x+(_mc.mcScaleplate.width/count)*count1-_mc.mcVernier.width/2;
			}
		}
		
		public function destroy():void
		{
			if(_item0)
			{
				_item0.destory();
				_item0 = null;
			}
			if(_item1)
			{
				_item1.destory();
				_item1 = null;
			}
			if(_item2)
			{
				_item2.destory();
				_item2 = null;
			}
			_mc = null;
			_panel = null;
		}
	}
}