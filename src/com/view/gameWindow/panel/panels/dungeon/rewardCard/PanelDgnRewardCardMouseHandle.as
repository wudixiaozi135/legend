package com.view.gameWindow.panel.panels.dungeon.rewardCard
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.dungeon.DgnGoalsDataManager;
	
	import flash.events.MouseEvent;

	public class PanelDgnRewardCardMouseHandle
	{
		private var _panel:PanelDgnRewardCard;
		private var _skin:McDgnRewardCard;
		
		public function PanelDgnRewardCardMouseHandle(panel:PanelDgnRewardCard)
		{
			_panel = panel;
			_skin = _panel.skin as McDgnRewardCard;
			initialize();
		}
		
		private function initialize():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _skin.btnClose:
					dealBtnClose();
					break;
				case _skin.btnStart:
					dealBtnStart();
					break;
				default:
					dealDefault(event);
					break;
			}
		}
		
		private function dealBtnClose():void
		{
			var manager:DgnGoalsDataManager = DgnGoalsDataManager.instance;
			var dt:DataDgnRewardCard = manager.dtDgnRewardCard;
			if(dt.isUnTurn)
			{
				Alert.show2(StringConst.DUNGEON_REWARD_CARD_TIP_0005,function():void
				{
					PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_REWARD_CARD);
				});
				return;
			}
			else if(dt.isCountRemain)
			{
				Alert.show2(StringConst.DUNGEON_REWARD_CARD_TIP_0006,function():void
				{
					manager.cmDungeonCardDraw(0);
					PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_REWARD_CARD);
				});
				return;
			}
			PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_REWARD_CARD);
		}
		
		private function dealBtnStart():void
		{
			_panel.viewHandle.shuffle();
		}
		
		private function dealDefault(event:MouseEvent):void
		{
			if(_panel.viewHandle.isShuffle)
			{
				return;
			}
			if(event.target.hasOwnProperty("postion"))
			{
				var postion:int = event.target.postion as int;
				DgnGoalsDataManager.instance.cmDungeonCardDraw(postion);
			}
		}
		
		public function destroy():void
		{
			if(_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK,onClick);
				_skin = null;
			}
			_panel = null;
		}
	}
}