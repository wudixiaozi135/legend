package com.view.gameWindow.panel.panels.dungeon.rewardCard
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.dungeon.DgnGoalsDataManager;
	
	/**
	 * 副本翻牌奖励面板
	 * @author Administrator
	 */	
	public class PanelDgnRewardCard extends PanelBase
	{
		internal var viewHandle:PanelDgnRewardCardViewHandle;
		internal var mouseHandle:PanelDgnRewardCardMouseHandle;
		
		public function PanelDgnRewardCard()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McDgnRewardCard = new McDgnRewardCard();
			_skin = skin;
			addChild(_skin);
		}
		
		override protected function initData():void
		{
			DgnGoalsDataManager.instance.attach(this);
			//
			viewHandle = new PanelDgnRewardCardViewHandle(this);
			mouseHandle = new PanelDgnRewardCardMouseHandle(this);
		}
		
		override public function update(proc:int=0):void
		{
			if(proc != GameServiceConstants.CM_DUNGEON_CARD_DRAW && 
			   proc != GameServiceConstants.SM_FINISH_DUNGEON)
			{
				return;
			}
			viewHandle.update(proc);
		}
		
		override public function destroy():void
		{
			if(viewHandle)
			{
				viewHandle.destroy();
				viewHandle = null;
			}
			if(mouseHandle)
			{
				mouseHandle.destroy();
				mouseHandle = null;
			}
			DgnGoalsDataManager.instance.detach(this);
			super.destroy();
		}
	}
}