package com.view.gameWindow.panel.panels.activitys.seaFeast
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.SeaFeastGift;
    import com.model.consts.StringConst;
    import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.bag.BagData;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;

    import flash.events.MouseEvent;
    import flash.utils.Dictionary;

    /**
     * Created by Administrator on 2015/1/26.
     */
    public class SeaFeastNpcMouseHandler
    {
        private var _panel:PanelSeaFeastNpc;
        private var _skin:McSeaFeastNPC;

        public function SeaFeastNpcMouseHandler(panel:PanelSeaFeastNpc)
        {
            this._panel = panel;
            _skin = panel.skin as McSeaFeastNPC;
            _skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        }

        private function onClick(event:MouseEvent):void
        {
            switch (event.target)
            {
                case _skin.btnClose:
                    closeHandler();
                    break;
                case _skin.txtBtn:
                    submit();
                    break;
                default :
                    break;
            }
        }

        private function submit():void
        {
            var cfg:BagData, dic:Dictionary;
            dic = ConfigDataManager.instance.seaFeastGift();
            var exist:Boolean = false;
            for each(var data:SeaFeastGift in dic)
            {
                cfg = BagDataManager.instance.getItemById(data.item_id);
                if (cfg)
                {
                    exist = true;
                    break;
                }
            }
            if (exist)
            {
                var seaFeastDataManager:SeaFeastDataManager = ActivityDataManager.instance.seaFeastDataManager;
                seaFeastDataManager.cmCM_ACTIVITY_SEA_SIDE_SUBMIT();
            } else
            {
                RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.SEA_FEAST_0015);
            }
        }

        private function closeHandler():void
        {
            PanelMediator.instance.closePanel(PanelConst.TYPE_SEA_FEAST_NPC);
        }

        public function destroy():void
        {
            if (_skin)
            {
                _skin.removeEventListener(MouseEvent.CLICK, onClick);
            }
        }
    }
}
