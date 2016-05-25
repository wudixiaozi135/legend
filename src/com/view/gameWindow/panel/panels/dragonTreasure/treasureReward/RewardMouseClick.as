package com.view.gameWindow.panel.panels.dragonTreasure.treasureReward
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;

	import flash.events.MouseEvent;

	/**
	 * Created by Administrator on 2014/12/1.
	 */
	public class RewardMouseClick
	{
		private var _panel:PanelTreasureReward;
		private var _skin:McTreasureReward;

		public function RewardMouseClick(panel:PanelTreasureReward)
		{
			_panel = panel;
			_skin = _panel.skin as McTreasureReward;
			_skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}

		private function onClick(event:MouseEvent):void
		{
			switch (event.target) {
				default :
					break;
				case _skin.btnClose:
					closeHandler();
					break;
				case _skin.btnLeft:
					onLeft()
					break;
				case _skin.btnRight:
					onRight();
					break;
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
			PanelMediator.instance.closePanel(PanelConst.TYPE_DRAGON_TREASURE_REWARD);
		}

		public function destroy():void
		{
			if (_skin) {
				_skin.removeEventListener(MouseEvent.CLICK, onClick);
				_skin = null;
			}
		}
	}
}
