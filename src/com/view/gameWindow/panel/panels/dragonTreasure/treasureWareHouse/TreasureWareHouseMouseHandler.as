package com.view.gameWindow.panel.panels.dragonTreasure.treasureWareHouse
{
    import com.model.consts.StringConst;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.dragonTreasure.DragonTreasureManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.TimerManager;
    import com.view.gameWindow.util.cell.IconCellEx;

    import flash.events.MouseEvent;

    /**
	 * Created by Administrator on 2014/12/1.
	 */
	public class TreasureWareHouseMouseHandler
	{
		private var _panel:PanelTreasureWareHouse;
		private var _skin:McTreasureWareHouse;

		public function TreasureWareHouseMouseHandler(panel:PanelTreasureWareHouse)
		{
			_panel = panel;
			_skin = _panel.skin as McTreasureWareHouse;
			_skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}

		private function onClick(event:MouseEvent):void
		{
			switch (event.target)
			{
				default :
					break;
				case _skin.btnClose:
					closeHandler();
					break;
				case _skin.btnLeft:
					onLeft();
					break;
				case _skin.btnRight:
					onRight();
					break;
				case _skin.btnGetOut:
					getGoods();
					break;
				case _skin.btnMakeUp:
					makeUp();
					break;
			}
		}

		private function makeUp():void
		{
            if (DragonTreasureManager.instance.storageDatas.length <= 0) return;
			if (DragonTreasureManager.MAKE_UP_SWITCH == false)
			{
				DragonTreasureManager.instance.sendMakeUp();

				TimerManager.getInstance().add(1000, delayMakeUp);

				DragonTreasureManager.MAKE_UP_END_TIME = (new Date().time + 10000);//结束时间
				DragonTreasureManager.MAKE_UP_SWITCH = true;
			}

			if (_skin)
			{
				_skin.btnMakeUp.btnEnabled = false;
				_skin.txtMakeUp.text = int((DragonTreasureManager.MAKE_UP_END_TIME - new Date().time) / 1000).toString();
			}
		}

		public function delayMakeUp():void
		{
			var seconds:int = int((DragonTreasureManager.MAKE_UP_END_TIME - new Date().time) / 1000);
			if (seconds > 0)
			{//有剩余时间
				if (_skin)
				{
					_skin.txtMakeUp.text = seconds.toString();
				}
			} else
			{//已用完
				if (_skin)
				{
					_skin.txtMakeUp.text = StringConst.STORAGE_003;
					_skin.btnMakeUp.btnEnabled = true;
				}
				DragonTreasureManager.MAKE_UP_SWITCH = false;
				TimerManager.getInstance().remove(delayMakeUp);
			}
		}
		
		private function getGoods():void
		{
			var itemEx:IconCellEx = DragonTreasureManager.lastSlotMc;
			if (itemEx)
			{
				DragonTreasureManager.instance.sendTakeOutGoods(itemEx.slot);
			} else
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PANEL_DRAGON_ERROR_2);

            }
		}

		private function onLeft():void
		{
			_panel.viewHandler.turnLeft();
		}

		private function onRight():void
		{
			_panel.viewHandler.turnRight();
		}

		private function closeHandler():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_DRAGON_TREASURE_WAREHOUSE);
		}

		public function destroy():void
		{
			TimerManager.getInstance().remove(delayMakeUp);
			if (_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK, onClick);
				_skin = null;
			}
		}
	}
}
