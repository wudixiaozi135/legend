package com.view.gameWindow.panel.panels.artifact
{
    import com.model.consts.StringConst;
    import com.model.consts.TabConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subuis.actvEnter.ActvEnter;
    import com.view.gameWindow.mainUi.subuis.actvEnter.McActvEnter;
    import com.view.gameWindow.panel.panelbase.IPanelTab;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.artifact.tabArtifact.TabArtifact;
    import com.view.gameWindow.panel.panels.artifact.tabNormal.TabNormal;
    import com.view.gameWindow.panel.panels.dungeon.TextFormatManager;

    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.text.TextField;

    public class ArtifactPanel extends PanelBase implements IArtifact,IPanelTab
	{
		
		private var _artifactMouseHandle:ArtifactMouseHandle;
		internal var _mcArtifact:McArtifactBg;
		private var _tabArtifact:TabArtifact;
		private var _tabNormal:TabNormal;
		private var _tabIndex:int = -1;
		
		public function ArtifactPanel()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			_skin = new McArtifactBg();
			addChild(_skin);
			_mcArtifact = _skin as McArtifactBg;
			setTitleBar(_mcArtifact.mcTitle);
			setTabIndex(TabConst.TYPE_TABARTIFACT);
		}
		
		override protected function initData():void
		{
			_artifactMouseHandle = new ArtifactMouseHandle(this);
			initText();
		}
		
		override public function setPostion():void 
		{
            var mc:McActvEnter = (MainUiMediator.getInstance().actvEnter as ActvEnter).skin as McActvEnter;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.mcBtns.mcLayer.btnArtifact.x, mc.mcBtns.mcLayer.btnArtifact.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
		}
		
		private function initText():void
		{
			_mcArtifact.txtTitle.text = StringConst.ARTIFACT_PANEL_0001;
			TextFormatManager.instance.setTextFormat(_mcArtifact.txtTitle,0xffe1aa,false,true);
			_mcArtifact.txtTitle.mouseEnabled = false;
			_mcArtifact.tabTxt_00.text = StringConst.ARTIFACT_PANEL_0002;
			_mcArtifact.tabTxt_01.text = StringConst.ARTIFACT_PANEL_0003;
			_mcArtifact.tabTxt_00.mouseEnabled = false;
			_mcArtifact.tabTxt_01.mouseEnabled = false;
		}	
		
		internal function setBtnState(btn:MovieClip,txt:TextField):void
		{
			_mcArtifact.tabBtn_00.mouseEnabled = true;
			_mcArtifact.tabBtn_01.mouseEnabled = true;
			_mcArtifact.tabBtn_00.selected = false;
			_mcArtifact.tabBtn_01.selected = false;
			btn.selected = true;
			btn.mouseEnabled = false;
			_mcArtifact.tabTxt_00.textColor = 0xd4a460;
			_mcArtifact.tabTxt_01.textColor = 0xd4a460;
			txt.textColor = 0xffe1aa;
		}
		
		public function getTabIndex():int
		{
			return _tabIndex;
		}
		
		public function setTabIndex(index:int):void
		{
			if(_tabIndex == index)return;
			_tabIndex = index;
			if(index == TabConst.TYPE_TABARTIFACT)
			{
				setTabNull();
				_tabArtifact = new TabArtifact();
				_tabArtifact.initView();
				_tabArtifact.x = 42;
				_tabArtifact.y = 82;
				addChild(_tabArtifact);
				setBtnState(_mcArtifact.tabBtn_00,_mcArtifact.tabTxt_00);
			}
			else if(index == TabConst.TYPE_TABNORMAL)
			{
				setTabNull();
				_tabNormal = new TabNormal();
				_tabNormal.initView();
				_tabNormal.x = 42;
				_tabNormal.y = 82;
				addChild(_tabNormal);
				setBtnState(_mcArtifact.tabBtn_01,_mcArtifact.tabTxt_01);
			}
		}

		override public function setSelectTabShow(tabIndex:int = -1):void
		{
			var index:int = 0;
			switch (tabIndex)
			{
				case 0:
					index = TabConst.TYPE_TABARTIFACT;
					break;
				case 1:
					index = TabConst.TYPE_TABNORMAL;
					break;
				default :
					index = TabConst.TYPE_TABARTIFACT;
					break;
			}
			setTabIndex(index);
		}

		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var load1:Boolean, load2:Boolean;
			var mc:MovieClip, tf:TextField;
			var loadComplete:Function = function ():void
			{
				if (load1 && load2)
				{
					var index:int = getTabIndex();
					switch (index)
					{
						case TabConst.TYPE_TABARTIFACT:
							mc = _mcArtifact.tabBtn_00;
							tf = _mcArtifact.tabTxt_00;
							break;
						case TabConst.TYPE_TABNORMAL:
							mc = _mcArtifact.tabBtn_01;
							tf = _mcArtifact.tabTxt_01;
							break;
						default :
							mc = _mcArtifact.tabBtn_00;
							tf = _mcArtifact.tabTxt_00;
							break;
					}
					setBtnState(mc, tf);
				}
			};
			rsrLoader.addCallBack(_mcArtifact.tabBtn_00,function():void
			{
				load1 = true;
				loadComplete();
			});
			rsrLoader.addCallBack(_mcArtifact.tabBtn_01,function():void
			{
				load2 = true;
				loadComplete();
			});
		}
		
		
		private function setTabNull():void
		{
			if(_tabArtifact)
			{
				removeChild(_tabArtifact);
				_tabArtifact.destroy();
				_tabArtifact = null;
			}
			if(_tabNormal)
			{
				removeChild(_tabNormal);
				_tabNormal.destroy();
				_tabNormal = null;
			}
		}
		
		override public function destroy():void
		{
			if(_tabArtifact)
			{
				_tabArtifact.destroy();
				_tabArtifact = null;
			}
			if(_tabNormal)
			{
				_tabNormal.destroy();
				_tabNormal = null;
			}
			if(_artifactMouseHandle)
			{
				_artifactMouseHandle.destroy();
				_artifactMouseHandle = null;
			}
			super.destroy();
		}
		
	}
}