package com.view.gameWindow.panel.panels.closet.handle
{
	import com.model.consts.ItemType;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.closet.ClosetDataManager;
	import com.view.gameWindow.panel.panels.closet.McClosetPanel;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.events.MouseEvent;

	/**
	 * 衣柜提升华丽度相关处理类
	 * @author Administrator
	 */	
	public class ClosetUpgradeBtnHandle
	{
		private var _mc:McClosetPanel;
		
		public function ClosetUpgradeBtnHandle(mc:McClosetPanel)
		{
			_mc = mc;
			init();
		}
		
		private function init():void
		{
			_mc.addEventListener(MouseEvent.CLICK,onClick);
			_mc.btnLevelUp.visible = false;
			var newX:Number = (_mc.btnLevelUp.x + _mc.btnPutIn.x)*.5;
			var dX:Number = _mc.btnPutIn.x - newX;
			_mc.btnPutIn.x = newX;
			_mc.txtFashionNum.x -= dX;
			_mc.mcNumBg.x -= dX;
		}
		
		protected function onClick(event:MouseEvent):void
		{
			if(!_mc)
			{
				return;
			}
			if (event.target == _mc.btnPutIn)
			{
				if (RoleDataManager.instance.stallStatue)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
					return;
				}
			}
			switch(event.target)
			{
				case _mc.btnLevelUp://道具升级
					useItemLvUp();
					break;
				case _mc.btnPutIn://放入时装
					showPutInPanel();
					break;
			}
		}
		
		private function useItemLvUp():void
		{
			var manager:ClosetDataManager = ClosetDataManager.instance;
			var isGorgeousFull:Boolean = manager.isGorgeousFull();
			if(isGorgeousFull)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.CLOSET_PANEL_0021);
				return;
			}
			var dt:BagData = new BagData();
			var num:int = BagDataManager.instance.getItemNumByType(ItemType.CLOSET_LV_UP,-1,dt);
			if(num)
			{
				/*BagDataManager.instance.sendUseData(dt.slot);*/
				manager.closetUpgrade(2,dt.slot);
			}
			else
			{
				show1BtnPanel();
			}
		}
		
		private function show1BtnPanel():void
		{
			Alert.show2(StringConst.CLOSET_PANEL_0011+StringConst.CLOSET_PANEL_0012+"\n" +StringConst.CLOSET_PANEL_0013,function ():void
			{
				if(BagDataManager.instance.goldUnBind >= 1000)
				{
					ClosetDataManager.instance.closetUpgrade(1);
				}
				else
				{
					trace("ClosetFuncBtnHandle.show1BtnPanel 元宝不足");
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.CLOSET_PANEL_0019);
				}
			},null,StringConst.CLOSET_PANEL_0014,"",null,"left");
		}
		
		public function refresh():void
		{
			var manager:ClosetDataManager = ClosetDataManager.instance;
			var fashionDatasByType:Vector.<BagData> = BagDataManager.instance.getFashionDatasByType(manager.current);
			_mc.txtFashionNum.text = fashionDatasByType.length+"";
			if(fashionDatasByType.length == 0)//无可放入的时装
			{
				_mc.mcNumBg.visible = false;
				_mc.txtFashionNum.visible = false;
			}
			else
			{
				_mc.mcNumBg.visible = true;
				_mc.txtFashionNum.visible = true;
				//
				if(manager.selectCellId != -1)
				{
					showPutInPanel();
				}
			}
		}
		
		private function showPutInPanel():void
		{
			if(_mc.txtFashionNum.text != "0")
			{
				PanelMediator.instance.openPanel(PanelConst.TYPE_CLOSET_PUT_IN);
			}
			else
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.CLOSET_PANEL_0022);
			}
		}
		
		public function destroy():void
		{
			_mc.removeEventListener(MouseEvent.CLICK,onClick);
			_mc = null;
		}
	}
}