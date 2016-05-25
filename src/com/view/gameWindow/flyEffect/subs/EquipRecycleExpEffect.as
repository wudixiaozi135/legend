package com.view.gameWindow.flyEffect.subs
{
    import com.greensock.TweenLite;
    import com.greensock.TweenMax;
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.panels.McEquipExpEffect;
    import com.view.gameWindow.panel.panels.equipRecycle.EquipRecycleDataManager;
    import com.view.gameWindow.util.LoaderCallBackAdapter;
    import com.view.gameWindow.util.NumPic;
    
    import flash.display.Sprite;

    /**
     * Created by Administrator on 2015/1/16.
     */
    public class EquipRecycleExpEffect
    {
        private var _expLayer:McEquipExpEffect;
        private var _panel:Sprite;
        private var _showExp:Boolean;
        private var _expNum:NumPic;

        public function EquipRecycleExpEffect(panel:Sprite)
        {
            _panel = panel;

           /* _showExp = EquipRecycleDataManager.totalExpShow;
            if (_showExp)
            {
                var totalExp:int = EquipRecycleDataManager.instance.getTotalExp();
                _expLayer = new McEquipExpEffect();
                _expNum = new NumPic();
                _expNum.init("equipGreen_", totalExp + "", _expLayer.expContainer);
                var expRsrloader:RsrLoader = new RsrLoader();
                var adapt1:LoaderCallBackAdapter = new LoaderCallBackAdapter();
                adapt1.addCallBack(expRsrloader, function ():void
                {
                    //经验层加载完成
                    adapt1 = null;
                    _panel.addChild(_expLayer);
                    _expLayer.x = (_panel.stage.stageWidth - _expLayer.width) >> 1;
                    _expLayer.y = (_panel.stage.stageHeight >> 1) - _expLayer.height - 50;
                    initShow();
                }, _expLayer.iconExp, _expLayer.iconAdd);
                expRsrloader.load(_expLayer, ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
            }*/
        }

        private function initShow():void
        {
            if (_expLayer)
            {
                TweenMax.fromTo(_expLayer, 1, {}, {
                    y: _expLayer.y - 150,
                    onComplete: expLayerHandler
                });
            }
        }

        private function expLayerHandler():void
        {
            if (_expLayer)
            {
                TweenLite.killTweensOf(_expLayer);
                if (_panel)
                {
                    if (_expNum)
                    {
                        _expNum.destory();
                        _expNum = null;
                    }
                    EquipRecycleDataManager.totalExpShow = false;

                    if (_panel.contains(_expLayer))
                    {
                        _panel.removeChild(_expLayer);
                        _expLayer = null;
                    }
                }
            }
        }
    }
}
