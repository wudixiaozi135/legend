package com.view.gameWindow.panel.panels.dragonTreasure.treasureShop
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.panel.panels.dragonTreasure.DragonTreasureManager;
	import com.view.gameWindow.panel.panels.dragonTreasure.event.DragonTreasureEvent;

	/**
	 * Created by Administrator on 2014/12/2.
	 */
	public class TreasureShopViewHandler implements IObserver
	{
		private var _panel:PanelTreasureShop;
		private var _skin:McTreasureShop;

		public function TreasureShopViewHandler(panel:PanelTreasureShop)
		{
			_panel = panel;
			_skin = _panel.skin as McTreasureShop;
			initialize();
			DragonTreasureManager.instance.attach(this);
			DragonTreasureEvent.addEventListener(DragonTreasureEvent.CHANGE_PAGE, onPageEvt, false, 0, true);
		}

		private function onPageEvt(event:DragonTreasureEvent):void
		{
			var param:Object = event._param;
			var _totalPage:int = param.totalPage;
			var _currentPage:int = param.currentPage;
			_skin.txtContent.text = _currentPage + "/" + _totalPage;
			refreshPage();
		}

		public function refreshPage():void
		{
			var _totalPage:int = TreasureShopManager.totalPage;
			var _currentPage:int = TreasureShopManager.currentPage;

			if (_totalPage == 1)
			{
				_skin.btnLeft.btnEnabled = false;
				_skin.btnRight.btnEnabled = false;
			} else
			{
				if (_currentPage < _totalPage)
				{
					if (_currentPage != 1)
					{
						_skin.btnLeft.btnEnabled = true;
						_skin.btnRight.btnEnabled = true;
					} else
					{
						_skin.btnLeft.btnEnabled = false;
						_skin.btnRight.btnEnabled = true;
					}
				} else if (_currentPage == _totalPage)
				{
					_skin.btnLeft.btnEnabled = true;
					_skin.btnRight.btnEnabled = false;
				}
			}
		}
		
		private function initialize():void
		{
			_skin.txtName.mouseEnabled = false;
			_skin.txtName.text = StringConst.PANEL_DRAGON_TREASURE_008;
			_skin.txtScore.mouseEnabled = false;
			_skin.txtScore.text = StringConst.PANEL_DRAGON_TREASURE_019;
			_skin.txtContent.mouseEnabled = false;

			updateMyScore();
		}

		public function update(proc:int = 0):void
		{
			switch (proc)
			{
				default :
					break;
				case GameServiceConstants.SM_FIND_TREASURE:
					updateMyScore();
					break;
			}
		}

		/**更新我的积分*/
		private function updateMyScore():void
		{
			if (_skin)
			{
				_skin.txtScoreValue.text = DragonTreasureManager.instance.score.toString();
			}
		}

		public function destroy():void
		{
			DragonTreasureManager.instance.detach(this);
			DragonTreasureEvent.removeEventListener(DragonTreasureEvent.CHANGE_PAGE, onPageEvt);
			if (_skin)
			{
				_skin = null;
			}
			if (_panel)
			{
				_panel = null;
			}
		}
	}
}
