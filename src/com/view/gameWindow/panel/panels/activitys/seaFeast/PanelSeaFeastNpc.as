package com.view.gameWindow.panel.panels.activitys.seaFeast
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.NpcCfgData;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.npcfunc.PanelNpcFuncData;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.css.GameStyleSheet;

    public class PanelSeaFeastNpc extends PanelBase
    {
        private var mouseHandler:SeaFeastNpcMouseHandler;
        private var dataManager:SeaFeastDataManager;

        public function PanelSeaFeastNpc()
        {
            super();
            dataManager = ActivityDataManager.instance.seaFeastDataManager;
            dataManager.attach(this);
        }

        override protected function addCallBack(rsrLoader:RsrLoader):void
        {
            super.addCallBack(rsrLoader);
        }

        override protected function initSkin():void
        {
            var skin:McSeaFeastNPC = new McSeaFeastNPC();
            _skin = skin;
            addChild(_skin);
            setTitleBar(_skin.mcTitleBar);
            initText();
        }

        override protected function initData():void
        {
            mouseHandler = new SeaFeastNpcMouseHandler(this);
        }

        private function initText():void
        {
            var skin:McSeaFeastNPC = _skin as McSeaFeastNPC;
            skin.txtNpcName.mouseEnabled = false;
            skin.txtDialog.mouseEnabled = false;
            skin.txtDialog.width = 280;
            skin.txtDialog.multiline = true;
            skin.txtDialog.wordWrap = true;

            var npcId:int = PanelNpcFuncData.npcId;
            var npcCfgData:NpcCfgData = ConfigDataManager.instance.npcCfgData(npcId);
            if (npcCfgData)
            {
                skin.txtNpcName.htmlText = HtmlUtils.createHtmlStr(0xFFE1AA, npcCfgData.name, 14, true);
                skin.txtDialog.text = npcCfgData.default_dialog;
                skin.txtBtn.styleSheet = GameStyleSheet.linkStyle;//提交按钮
                skin.txtBtn.htmlText = HtmlUtils.createHtmlStr(0xffcc00, StringConst.SEA_FEAST_0014, 12, false, 2, "SimSun", true, "");
                skin.txtBtn.y = skin.txtDialog.y + (skin.txtDialog.numLines + 1) * 17 + skin.txtBtn.height;
            }
        }

        override public function update(proc:int = 0):void
        {
            if (proc == GameServiceConstants.CM_ACTIVITY_SEA_SIDE_SUBMIT)
            {
                PanelMediator.instance.closePanel(PanelConst.TYPE_SEA_FEAST_NPC);
            }
        }

        override public function destroy():void
        {
            dataManager.detach(this);
            if (mouseHandler)
            {
                mouseHandler.destroy();
                mouseHandler = null;
            }
            super.destroy();
        }
    }
}