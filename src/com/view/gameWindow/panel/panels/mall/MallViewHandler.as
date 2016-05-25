package com.view.gameWindow.panel.panels.mall
{
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.mall.event.MallEvent;
    import com.view.gameWindow.util.ObjectUtils;

    /**
	 * Created by Administrator on 2014/11/19.
	 */
	public class MallViewHandler
	{
		public function MallViewHandler(panel:PanelMall)
		{
			this._panel = panel;
			MallEvent.addEventListener(MallEvent.CHANGE_PAGE, onChangePage);
			refresh();

            hideMc();
		}

        /**暂时屏蔽功能*/
        private function hideMc():void
        {
            var skin:McMallPanel = _panel.skin as McMallPanel;
            skin.txtScore.visible = false;
            skin.mcScore.visible = false;
            skin.scoreBg.visible = false;
        }

		private var _panel:PanelMall;

		public function refresh():void
		{
			if (_panel)
			{
				var skin:McMallPanel = _panel.skin as McMallPanel;
				var dataManager:BagDataManager = BagDataManager.instance;
				skin.txtGold.text = ObjectUtils.stringFormat(dataManager.goldUnBind);
				skin.txtBindGold.text = ObjectUtils.stringFormat(dataManager.goldBind);
				skin.txtScore.text = ObjectUtils.stringFormat(dataManager.costScore);
			}
		}

		public function destroy():void
		{
            _panel = null;
			MallEvent.removeEventListener(MallEvent.CHANGE_PAGE, onChangePage);
		}

		/**更新翻页状态*/
        public function updatePage():void
		{
			var currentPage:int = MallDataManager.currentPage;
			var totalPage:int = MallDataManager.totalPage;
			var skin:McMallPanel = _panel.skin as McMallPanel;
			if (totalPage == 1)
			{
				skin.btnLeft.btnEnabled = false;
				skin.btnRight.btnEnabled = false;
				return;
			}
			if (currentPage == 1)
			{
				skin.btnLeft.btnEnabled = false;
				skin.btnRight.btnEnabled = true;
			} else if (currentPage == totalPage)
			{
				skin.btnLeft.btnEnabled = true;
				skin.btnRight.btnEnabled = false;
			} else
			{
				skin.btnLeft.btnEnabled = true;
				skin.btnRight.btnEnabled = true;
			}
		}

		private function onChangePage(event:MallEvent):void
		{
			var params:Object = event._param;
			var skin:McMallPanel = _panel.skin as McMallPanel;
			skin.txtPage.text = params.currentPage + "/" + params.totalPage;
			updatePage();
		}
	}
}
