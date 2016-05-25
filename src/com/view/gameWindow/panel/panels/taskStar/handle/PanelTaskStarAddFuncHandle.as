package com.view.gameWindow.panel.panels.taskStar.handle
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.GuideCfgData;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.DropDownListWithLoad;
    import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
    import com.view.gameWindow.panel.panels.guideSystem.action.ActionFactory2;
    import com.view.gameWindow.panel.panels.guideSystem.action.getAction;
    import com.view.gameWindow.panel.panels.taskStar.McTaskStar;
    import com.view.gameWindow.panel.panels.taskStar.PanelTaskStar;
    import com.view.gameWindow.panel.panels.taskStar.data.PanelTaskStarDataManager;
    import com.view.gameWindow.tips.toolTip.TipVO;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.text.TextField;

    /**
     * 星级任务面板添加回调函数处理类
     * @author Administrator
     */
    public class PanelTaskStarAddFuncHandle
    {
        private var combox:DropDownListWithLoad;
        private var comboxArr:Array;
        private var _mc:McTaskStar;
		private var _panel:PanelTaskStar;
		
        public function PanelTaskStarAddFuncHandle()
        {
        }

        public function deal(rsrLoader:RsrLoader, panel:PanelTaskStar):void
        {
			_panel = panel;
            _mc = panel.skin as McTaskStar;
            rsrLoader.addCallBack(_mc.mcName, function (mc:MovieClip):void
            {
                mc.gotoAndStop(PanelTaskStarDataManager.getFrameIndex(PanelTaskStarDataManager.instance.newTid));
            });

            rsrLoader.addCallBack(_mc.mcReceiveLayer.btnRefresh, function (mc:MovieClip):void
            {
                addUpgradeBtnTip(mc);
				InterObjCollector.instance.add(mc);
				InterObjCollector.autoCollector.add(mc);
				_panel.createRefreshBtnGuide();
				_panel.checkRefreshBtnGuide();
				
            });

			rsrLoader.addCallBack(_mc.mcReceiveLayer.btnReceive, function (mc:MovieClip):void
			{
				InterObjCollector.instance.add(mc);
				InterObjCollector.autoCollector.add(mc);
				_panel.createReceiveBtnGuide();
				_panel.checkReceiveBtnGuide();
			});
			
            rsrLoader.addCallBack(_mc.mcReceiveLayer.mcStar, function (mc:MovieClip):void
            {
                mc.gotoAndStop(PanelTaskStarDataManager.instance.newStar);
            });
            rsrLoader.addCallBack(_mc.mcReceiveLayer.mcStarNum, function (mc:MovieClip):void
            {
                mc.gotoAndStop(PanelTaskStarDataManager.instance.newStar + 1);
            });
			rsrLoader.addCallBack(_mc.mcReceiveLayer.btnZoom, function (mc:MovieClip):void
			{
				_mc.mcReceiveLayer.btnZoom.selected = true;
			});
			
			rsrLoader.addCallBack(_mc.mcReceiveLayer.protectSingleBtn, function (mc:MovieClip):void
			{
				_mc.mcReceiveLayer.protectSingleBtn.selected = PanelTaskStarDataManager.instance.setting != 0;
			});
			
			

            //奖励领取Tips
            setRewardInfo(_mc.mcRewardLayer.txtReward1, StringConst.TASK_STAR_PANEL_0059);
            setRewardInfo(_mc.mcRewardLayer.txtReward2, StringConst.TASK_STAR_PANEL_0058);
            setRewardInfo(_mc.mcRewardLayer.txtReward3, StringConst.TASK_STAR_PANEL_0057);
			
			InterObjCollector.instance.add(_mc.mcRewardLayer.txtReward1,"",new Point(2,2));
			InterObjCollector.instance.add(_mc.mcRewardLayer.txtReward2,"",new Point(2,2));
			InterObjCollector.instance.add(_mc.mcRewardLayer.txtReward3,"",new Point(2,2));
			
			InterObjCollector.autoCollector.add(_mc.mcRewardLayer.txtReward1,"",new Point(2,2));
			InterObjCollector.autoCollector.add(_mc.mcRewardLayer.txtReward2,"",new Point(2,2));
			InterObjCollector.autoCollector.add(_mc.mcRewardLayer.txtReward3,"",new Point(2,2));

            comboxArr = [StringConst.TASK_STAR_PANEL_0048, StringConst.TASK_STAR_PANEL_0049, StringConst.TASK_STAR_PANEL_0050, StringConst.TASK_STAR_PANEL_0051, StringConst.TASK_STAR_PANEL_0052];
            combox = new DropDownListWithLoad(comboxArr, _mc.mcReceiveLayer.txt_1, 80, rsrLoader, _mc.mcReceiveLayer, "downItem", "downListBtn", comboxArr[0]);
            combox.addEventListener(Event.CHANGE, onComboxChanage);
        }

        private function setRewardInfo(mc:TextField, str:String):void
        {
            var tipVO:TipVO = new TipVO;
            tipVO.tipType = ToolTipConst.TEXT_TIP;
            tipVO.tipData = HtmlUtils.createHtmlStr(0xffc000, str);
            ToolTipManager.getInstance().hashTipInfo(mc, tipVO);
            ToolTipManager.getInstance().attach(mc);
        }

        protected function onComboxChanage(event:Event):void
        {
            PanelTaskStarDataManager.instance.selectStar = combox.selectedIndex;
        }

        private function addGetBtnTip(movieClip:MovieClip):void
        {
            var tipVO:TipVO = new TipVO();
            tipVO.tipType = ToolTipConst.TEXT_TIP;
            tipVO.tipData = HtmlUtils.createHtmlStr(0xffe1aa, StringConst.TASK_STAR_PANEL_0025);
            ToolTipManager.getInstance().hashTipInfo(movieClip, tipVO);
            ToolTipManager.getInstance().attach(movieClip);
        }

        private function addUpgradeBtnTip(movieClip:MovieClip):void
        {
            var tipVO:TipVO = new TipVO();
            tipVO.tipType = ToolTipConst.TEXT_TIP;
            var createHtmlStr:String = HtmlUtils.createHtmlStr(0xffe1aa, StringConst.TASK_STAR_PANEL_0027);
            tipVO.tipData = createHtmlStr;
            ToolTipManager.getInstance().hashTipInfo(movieClip, tipVO);
            ToolTipManager.getInstance().attach(movieClip);
        }

        public function destroy():void
        {
            ToolTipManager.getInstance().detach(_mc.mcReceiveLayer.btnRefresh);
            ToolTipManager.getInstance().detach(_mc.mcRewardLayer.txtReward1);
            ToolTipManager.getInstance().detach(_mc.mcRewardLayer.txtReward2);
            ToolTipManager.getInstance().detach(_mc.mcRewardLayer.txtReward3);
            if (combox)
            {
                combox.removeEventListener(Event.CHANGE, onComboxChanage);
                combox.destroy();
                combox = null;
            }
			
			InterObjCollector.instance.remove(_mc.mcRewardLayer.txtReward1);
			InterObjCollector.instance.remove(_mc.mcRewardLayer.txtReward2);
			InterObjCollector.instance.remove(_mc.mcRewardLayer.txtReward3);
			InterObjCollector.instance.remove(_mc.mcReceiveLayer.btnRefresh);
			InterObjCollector.instance.remove(_mc.mcReceiveLayer.btnReceive);
			
			InterObjCollector.autoCollector.remove(_mc.mcRewardLayer.txtReward1);
			InterObjCollector.autoCollector.remove(_mc.mcRewardLayer.txtReward2);
			InterObjCollector.autoCollector.remove(_mc.mcRewardLayer.txtReward3);
			InterObjCollector.autoCollector.remove(_mc.mcReceiveLayer.btnRefresh);
			InterObjCollector.autoCollector.remove(_mc.mcReceiveLayer.btnReceive);
			
            _mc = null;
            comboxArr = null;
			_panel = null;
        }
    }
}