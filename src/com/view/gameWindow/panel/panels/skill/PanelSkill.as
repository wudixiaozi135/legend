package com.view.gameWindow.panel.panels.skill
{
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarDataManager;
    import com.view.gameWindow.panel.panelbase.IPanelTab;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.skill.constants.SkillConstants;

    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.text.TextFormat;

    /**
	 * 技能面板类
	 * @author Administrator
	 */	
	public class PanelSkill extends PanelBase implements IPanelSkill,IPanelTab
	{
		private var _page:int;
		internal var clickHandle:PanelSkillClickHandle;
		internal var itemHandle:PanelSkillItemHandle;
		
		public function PanelSkill()
		{
			super();
			SkillDataManager.instance.attach(this);
			ActionBarDataManager.instance.attach(this);
		}
		
		private var _tabIndex:int = -1;
		private var _tabBtnInited0:Boolean = false;
		private var _tabBtnInited1:Boolean = false;
		
		public function setTabIndex(index:int):void
		{
			_tabIndex = index;
			checkTabIndex();
		}
		
		public function getTabIndex():int
		{
			return clickHandle.getTabIndex();
		}
		
		override protected function initSkin():void
		{
			_skin = new McPanelSkill();
			addChild(_skin);
			setTitleBar((_skin as McPanelSkill).mcTitleBar);
			initTxt();
		}
		
		/**初始化文本*/
		private function initTxt():void
		{
			var mc:McPanelSkill,defaultTextFormat:TextFormat;
			mc = _skin as McPanelSkill;
			defaultTextFormat = mc.txtName.defaultTextFormat;
			defaultTextFormat.bold = true;
			mc.txtName.defaultTextFormat = defaultTextFormat;
			mc.txtName.setTextFormat(defaultTextFormat);
			mc.txtName.text = StringConst.SKILL_PANEL_0001;
			
			mc.txtPrev.mouseEnabled = false;
			mc.txtPrev.text = StringConst.SKILL_PANEL_0006;
			mc.txtNext.mouseEnabled = false;
			mc.txtNext.text = StringConst.SKILL_PANEL_0007;
		}
		
		override protected function initData():void
		{
			itemHandle = new PanelSkillItemHandle(this);
			clickHandle = new PanelSkillClickHandle(this);
		}
		
		private function checkTabIndex():void
		{
			if(_tabIndex != -1 && _tabBtnInited0 && _tabBtnInited1)
			{
				clickHandle.setTabIndex(_tabIndex);
			}
		}
		
		override public function setPostion():void
		{
            var mc:McMainUIBottom = (MainUiMediator.getInstance().bottomBar as BottomBar).skin as McMainUIBottom;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.skillBtn.x, mc.skillBtn.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var mcPanelSkill:McPanelSkill = _skin as McPanelSkill;
			rsrLoader.addCallBack(mcPanelSkill.btnSkills0,function(mc:MovieClip):void
			{
				clickHandle.setDefault(0);
				_tabBtnInited0 = true;
				checkTabIndex();
			});
			rsrLoader.addCallBack(mcPanelSkill.btnSkills1,function(mc:MovieClip):void
			{
				clickHandle.setDefault(1);
				_tabBtnInited1 = true;
				checkTabIndex();
			});
			rsrLoader.addCallBack(mcPanelSkill.btnSkills2,function(mc:MovieClip):void
			{
				clickHandle.setDefault(2);
				mc.visible = false;
			});
			rsrLoader.addCallBack(mcPanelSkill.btnSkills3,function(mc:MovieClip):void
			{
				clickHandle.setDefault(3);
				mc.visible = false;
			});
		}
		
		override public function update(proc:int = 0):void
		{
			clickHandle.refreshPageText();
			itemHandle.refreshItems();
		}
		
		override public function destroy():void
		{
			SkillDataManager.instance.entity_type = SkillConstants.TYPE_ROLE;
			SkillDataManager.instance.detach(this);
			ActionBarDataManager.instance.detach(this);
			if(itemHandle)
			{
				itemHandle.destory();
			}
			itemHandle = null;
			if(clickHandle)
			{
				clickHandle.destroy();
			}
			clickHandle = null;
			super.destroy();
		}
	}
}