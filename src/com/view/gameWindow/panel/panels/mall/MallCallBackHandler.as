package com.view.gameWindow.panel.panels.mall
{
    import com.model.consts.EffectConst;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.util.LoaderCallBackAdapter;
    import com.view.gameWindow.util.UIEffectLoader;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.text.TextField;

    /**
	 * Created by Administrator on 2014/11/19.
	 */
	public class MallCallBackHandler
	{
        private var _panel:PanelMall;
        private var _btnExtractLoaded:Boolean = false;
        private var _effectContainer:Sprite;
        private var _effectLoader:UIEffectLoader;

		public function MallCallBackHandler(panel:PanelMall, rsrLoader:RsrLoader)
		{
			this._panel = panel;
			init(rsrLoader);
            addShieldMc();
            _panel.skin.addChild(_effectContainer = new Sprite());
            _effectContainer.mouseChildren = false;
            _effectContainer.mouseEnabled = false;
            _effectContainer.x = _panel.skin.btnGetGold.x + (_panel.skin.btnGetGold.width >> 1) + 1.5;
            _effectContainer.y = _panel.skin.btnGetGold.y + (_panel.skin.btnGetGold.height >> 1);
            _effectLoader = new UIEffectLoader(_effectContainer, 0, 0, 1, 1, EffectConst.RES_MALL_BTNEFFECT);
            _effectContainer.visible = false;
		}

        /**临时屏蔽元件*/
        private function addShieldMc():void
        {
            var skin:McMallPanel = _panel.skin as McMallPanel;
            skin.txtBroadCast.visible = false;
            skin.checkBtn.visible = false;
        }

		public function destroy():void
		{
            if (_effectLoader)
            {
                _effectLoader.destroy();
                _effectLoader = null;
            }
            if (_effectContainer && _effectContainer.parent)
            {
                _effectContainer.parent.removeChild(_effectContainer);
                _effectContainer = null;
            }
            _btnExtractLoaded = false;
            _panel = null;
		}

		private function init(rsrLoader:RsrLoader):void
		{
			var skin:McMallPanel = _panel.skin as McMallPanel;
			for (var i:int = 0; i < 9; i++)
			{
				skin["tabTxt" + i].mouseEnabled = false;
				rsrLoader.addCallBack(skin["tab" + i], getFunc(i));
			}
			rsrLoader.addCallBack(skin.btnGetGold, function (mc:MovieClip):void
			{//屏蔽提取元宝
//				skin.btnGetGold.visible = false;
//				skin.txtGetGold.visible = false;
                _btnExtractLoaded = true;
                updateEffect();
			});
			rsrLoader.addCallBack(skin.btnLeft, function (mc:MovieClip):void
			{
//				if (_panel.mouseHandler)
//				{
//					_panel.mouseHandler.firstClick();
//				}
			});

            var adapt:LoaderCallBackAdapter = new LoaderCallBackAdapter();
            adapt.addCallBack(rsrLoader, function ():void
            {
                if (_panel.viewHandler)
                {
                    _panel.viewHandler.updatePage();
                }
                adapt = null;
            }, skin.btnLeft, skin.btnRight);

			skin.searchTxt.textColor = 0xd4a460;
			skin.searchTxt.text = StringConst.MALL_LABEL_1;

			skin.txtBroadCast.textColor = 0xd4a460;
			skin.txtBroadCast.text = StringConst.MALL_LABEL_2;
			skin.txtBroadCast.mouseEnabled = false;

			skin.txtMedalCost.textColor = 0xa56237;
			skin.txtMedalCost.text = StringConst.MALL_LABEL_3;
			skin.txtMedalCost.mouseEnabled = false;

			skin.txtGetGold.textColor = 0xd4a460;
			skin.txtGetGold.text = StringConst.MALL_LABEL_7;
			skin.txtGetGold.mouseEnabled = false;

			skin.txtGold.textColor = 0xffff00;
			skin.txtGetGold.mouseEnabled = false;

			skin.txtBindGold.textColor = 0xffff00;
			skin.txtBindGold.mouseEnabled = false;

			skin.txtScore.textColor = 0xffff00;
			skin.txtScore.mouseEnabled = false;

			skin.txtPage.textColor = 0xffff00;
			skin.txtPage.mouseEnabled = false;
		}

		private function getFunc(index:int):Function
		{
			var skin:McMallPanel = _panel.skin as McMallPanel;

			var func:Function = function (mc:MovieClip):void
			{
				var textField:TextField = skin["tabTxt" + index] as TextField;
				textField.text = StringConst["MALL_TAB_" + (index + 1)];

                var selectIndex:int = MallDataManager.defaultIndex;
				if (selectIndex == index)
				{
					mc.selected = true;
					mc.mouseEnabled = false;
					if (!MallDataManager.lastTab) {
						MallDataManager.lastTab = mc;
					}
					_panel.mouseHandler.firstClick(index);
				}
			};
			return func;
		}

        public function updateEffect():void
        {
            if (_btnExtractLoaded)
            {
                var skin:McMallPanel = _panel.skin as McMallPanel;
                var unExtractNum:int = BagDataManager.instance.unExtractGold;
                var bool:Boolean = unExtractNum > 0;
                if (_effectContainer)
                {
                    _effectContainer.visible = bool;
                }
            }
        }
    }
}
