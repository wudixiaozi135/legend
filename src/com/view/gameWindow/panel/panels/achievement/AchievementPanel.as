package com.view.gameWindow.panel.panels.achievement
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.EffectConst;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMapProperty;
    import com.view.gameWindow.mainUi.subuis.minimap.MiniMap;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.achievement.content.AchievementContentHandler;
    import com.view.gameWindow.panel.panels.achievement.title.AchievemnetTitleHandler;
    import com.view.gameWindow.panel.panels.achievement.title.TitleData;
    import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.UIEffectLoader;
    
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.text.TextFormat;

    public class AchievementPanel extends PanelBase
	{
		internal var _mcAcPanel:MCAchievementPanel;
		internal var titleHandler:AchievemnetTitleHandler;
        public var contentHandler:AchievementContentHandler;
		internal var mouseHandler:AchiMouseHandler;

		public var isFilter:Boolean;
        private var _btnEffect:UIEffectLoader;
        private var _btnEffectContainer:Sprite;
		public function AchievementPanel()
		{
			super();
			AchievementDataManager.getInstance().attach(this);
		}
		
		override protected function initSkin():void 
		{
			_mcAcPanel=new MCAchievementPanel();
			_skin=_mcAcPanel;
			addChild(_skin);
			setTitleBar(_mcAcPanel.mcTitleBar);
            _skin.addChild(_btnEffectContainer = new Sprite());
            _btnEffectContainer.mouseEnabled = false;
            _btnEffectContainer.mouseChildren = false;
            _btnEffect = new UIEffectLoader(_btnEffectContainer, 0, 0, 1, 1, EffectConst.RES_ACHIEVEMENT_EFFECT);
            _btnEffectContainer.x = _mcAcPanel.btnOneKey.x - int((100 - _mcAcPanel.btnOneKey.width) >> 1) - 1;
            _btnEffectContainer.y = _mcAcPanel.btnOneKey.y - int((50 - _mcAcPanel.btnOneKey.height) >> 1) - 1;
            _btnEffectContainer.visible = false;
		}
		
		override protected function initData():void
		{
			initTxt();
			titleHandler=new AchievemnetTitleHandler(this);
			contentHandler=new AchievementContentHandler(this);
			mouseHandler=new AchiMouseHandler(this);
		}
		
		/**初始化文本*/
		private function initTxt():void
		{
			var defaultTextFormat:TextFormat;
			defaultTextFormat = _mcAcPanel.txtName.defaultTextFormat;
			defaultTextFormat.bold = true;
			_mcAcPanel.txtName.defaultTextFormat = defaultTextFormat;
			_mcAcPanel.txtName.setTextFormat(defaultTextFormat);
			_mcAcPanel.txtName.text = StringConst.ACHI_PANEL_0001;
			_mcAcPanel.txt1.text=StringConst.ACHI_PANEL_0002;
			_mcAcPanel.txt2.text=StringConst.ACHI_PANEL_0003;
			_mcAcPanel.txt3.text=StringConst.ACHI_PANEL_0004;
			_mcAcPanel.txt_vip_link.htmlText=HtmlUtils.createHtmlStr(0x00A2FF,StringConst.ACHI_PANEL_0005,112,false,2,"SimSun",true);
			ToolTipManager.getInstance().attachByTipVO(_mcAcPanel.txt_vip_link,ToolTipConst.TEXT_TIP,HtmlUtils.createHtmlStr(0xffffff,StringConst.ACHI_PANEL_0009));
			_mcAcPanel.txt5.text=StringConst.ACHI_PANEL_0006;
			_mcAcPanel.txtBtn.text=StringConst.ACHI_PANEL_0007;
			_mcAcPanel.txtBtn.mouseEnabled=false;
			_mcAcPanel.txtgress.mouseEnabled=false;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(_mcAcPanel.mcScrollBar,function (mc:MovieClip):void
			{
				titleHandler.initScroll();
			});
			rsrLoader.addCallBack(_mcAcPanel.mcScrollBarC,function (mc:MovieClip):void
			{
				contentHandler.initScroll();
				contentHandler.initView();
				AchievementDataManager.getInstance().getAchievementData();
			});
			
			rsrLoader.addCallBack(_mcAcPanel.btnOneKey,function (mc:MovieClip):void
			{
				InterObjCollector.instance.add(mc);
			});
			super.addCallBack(rsrLoader);
		}
		
		public function updatePanel():void
		{
			_mcAcPanel.txt1_value.text=AchievementDataManager.getInstance().liquan+"";
			_mcAcPanel.txt2_value.text=AchievementDataManager.getInstance().exploit+"";
			var selectTitleType:int = AchievementDataManager.getInstance().selectTitleType;
			var titleData:TitleData = AchievementDataManager.getInstance().getTitleData(selectTitleType);
			var gressN:int=titleData.gress/titleData.count*100;
			_mcAcPanel.txtgress.text=titleData.gress+"/"+titleData.count+"("+gressN+"%)";
			_mcAcPanel.gresssMask.scaleX=titleData.gress/titleData.count;
		}

		override public function update(proc:int=0):void
		{
			if(proc==GameServiceConstants.SM_ACHIEVEMENT_LIST)
			{
				updatePanel();
				titleHandler.refreshTitle();
				if(isFilter)
				{
					contentHandler.initView();
				}
				contentHandler.refreshView();
	            checkEffect();
			}
			super.update(proc);
		}

        override public function setPostion():void
        {
            var mc:McMapProperty = (MainUiMediator.getInstance().miniMap as MiniMap).skin as McMapProperty;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.btnAchieve.x, mc.btnAchieve.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
        }

        override public function destroy():void
		{
			AchievementDataManager.getInstance().detach(this);
			ToolTipManager.getInstance().detach(_mcAcPanel.txt_vip_link);
			InterObjCollector.instance.remove(_mcAcPanel.btnOneKey);
            if (_btnEffect)
            {
                _btnEffect.destroy();
                _btnEffect = null;
            }
            if (_btnEffectContainer && _btnEffectContainer.parent)
            {
                _btnEffectContainer.parent.removeChild(_btnEffectContainer);
                _btnEffectContainer = null;
            }
			mouseHandler&&mouseHandler.destroy();
			mouseHandler=null;
			contentHandler&&contentHandler.destroy();
			contentHandler=null;
			titleHandler&&titleHandler.destroy();
			titleHandler=null;
			_skin.parent&&_skin.parent.removeChild(_skin);
			_skin=null;
			AchievementDataManager.getInstance().selectTitleType=1;
			super.destroy();
		}

        public function checkEffect():void
        {
            var noRequstCount:int = AchievementDataManager.getInstance().noRequstCount;
            if (noRequstCount > 0)
            {
                _btnEffectContainer.visible = true;
            } else
            {
                _btnEffectContainer.visible = false;
            }
        }
		public function get mcAcPanel():MCAchievementPanel
		{
			return _mcAcPanel;
		}

		public function set mcAcPanel(value:MCAchievementPanel):void
		{
			_mcAcPanel = value;
		}
	}
}