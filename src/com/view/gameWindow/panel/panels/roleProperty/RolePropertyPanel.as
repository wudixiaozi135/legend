package com.view.gameWindow.panel.panels.roleProperty
{
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.panel.panelbase.IPanelTab;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.roleProperty.newLife.NewLifePanel;
    import com.view.gameWindow.panel.panels.roleProperty.property.PropertyPanel;
    import com.view.gameWindow.panel.panels.roleProperty.role.IRolePanel;
    import com.view.gameWindow.panel.panels.roleProperty.role.RolePanel;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    
    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.text.TextFormat;

    public class RolePropertyPanel extends PanelBase implements IRolePropertyPanel,IPanelTab
	{
		private var _mcRoleProperty:McRoleProperty;
		private var _rolePanel:RolePanel;
		private var _propertyPanel:PropertyPanel;
		private var _newLifePanel:NewLifePanel;
		private var _rolePropertyMouseHandle:RolePropertyMouseHandle;
		
		private const ROLE:int = 0;
		private const PROPERTY:int = 2;
		private const NEWLIFE:int = 1;
		public function RolePropertyPanel()
		{
			mouseEnabled = false;
			super();
		}
		
		public function get rolePanel():IRolePanel
		{
			return _rolePanel;
		}

		override protected function initSkin():void
		{
			_skin = new McRoleProperty();
			addChild(_skin);
			_mcRoleProperty = _skin as McRoleProperty;
			setTitleBar(_mcRoleProperty.dragCell);
			_skin.mouseEnabled = false;
		}
		
		override public function setPostion():void
		{
            var mc:McMainUIBottom = (MainUiMediator.getInstance().bottomBar as BottomBar).skin as McMainUIBottom;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.roleBtn.x, mc.roleBtn.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
		}
		
		override protected function initData():void
		{
			initText();
			_rolePropertyMouseHandle = new RolePropertyMouseHandle(_mcRoleProperty,this);
			setTabIndex(0);
			updateBtnPosition();
		}
		
		public function updateBtnPosition():void
		{
			// TODO Auto Generated method stub
			_mcRoleProperty.btnProperty.visible = false;
		}
		
		private var btnStates:Array = [0,0,0];
		
		public function changeSonPanel(name:int):void
		{
			if(name==ROLE)
			{
				setSonPanelNull();
				if(!_rolePanel)
				{
					_rolePanel = new RolePanel;
					_rolePanel.initView();
					_rolePanel.x=40;
					_rolePanel.y=55;
					this.addChild(_rolePanel);
				}
//				setMcRight(true);
				setBtnState(ROLE);
			}
			else if(name==PROPERTY)
			{
				setSonPanelNull();
				if(!_propertyPanel)
				{
					_propertyPanel = new PropertyPanel;
					_propertyPanel.initView();
					_propertyPanel.x=40;
					_propertyPanel.y=60;
					this.addChild(_propertyPanel);
					_propertyPanel.changeValue();
				}
//				setMcRight(false);
				setBtnState(PROPERTY);
			}
			else if(name == NEWLIFE)
			{
				setSonPanelNull();
				if(!_newLifePanel)
				{
					_newLifePanel = new NewLifePanel;
					_newLifePanel.initView();
					_newLifePanel.x=40;
					_newLifePanel.y=60;
					this.addChild(_newLifePanel);
				}
//				setMcRight(false);
				setBtnState(NEWLIFE);
			}
			else
			{
				
			}
		}
		
		private function setSonPanelNull():void
		{
			if(_rolePanel)
			{
				this.removeChild(_rolePanel);
				_rolePanel.destroy();
				_rolePanel=null;
			}
			if(_propertyPanel)
			{
				this.removeChild(_propertyPanel);
				_propertyPanel.destroy();
				_propertyPanel=null;
			}
			if(_newLifePanel)
			{
				this.removeChild(_newLifePanel);
				_newLifePanel.destroy();
				_newLifePanel=null;
			}
		}
		
		private function updateBtnState():void
		{
			for(var i:int = 0; i < btnStates.length; ++i)
			{
				var btn:MovieClip = getTabBtn(i);
				
				if(btn && btn.hasOwnProperty("selected"))//代表已加载
				{
					if(btnStates[i])
					{
						btn.selected = true;
						btn.mouseEnabled = false;
						(btn.txt as TextField).textColor = 0xffe1aa;
					}
					else
					{
						btn.selected = false;
						btn.mouseEnabled = true;
						(btn.txt as TextField).textColor = 0xd4a460;
					}
					
					(btn.txt as TextField).text = getTabName(i);
				}
			}
		}
		
		private function getTabName(index:int):String
		{
			var names:Array = [StringConst.ROLE_PROPERTY_PANEL_0022,StringConst.ROLE_PROPERTY_PANEL_0060,StringConst.ROLE_PROPERTY_PANEL_0023];
			if(index>=0)
			{
				return names[index];
			}
			
			return "";
		}
		
		private function getTabBtn(index:int):MovieClip
		{
			var btns:Array = [_mcRoleProperty.btnRole,_mcRoleProperty.btnNewLife,_mcRoleProperty.btnProperty];
			if(index>=0)
			{
				return btns[index];
			}
			
			return null;
		}
		
		
		private function setBtnState(selectedIndex:int):void
		{
			btnStates = [0,0,0];
			
			if(selectedIndex>=0)
			{
				btnStates[selectedIndex] = 1;
			}
			
			updateBtnState();
		}
		/**控制右边栏显示*/
		private function setMcRight(isShow:Boolean):void
		{
			_mcRoleProperty.mcRight.visible=isShow;
			_mcRoleProperty.mcRight.mouseChildren=isShow;
			_mcRoleProperty.mcRight.enabled=isShow;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(_mcRoleProperty.btnRole,function (mc:MovieClip):void
			{
				setTabBtnState(0,mc);
				updateBtnState();
			});
			rsrLoader.addCallBack(_mcRoleProperty.btnProperty,function (mc:MovieClip):void
			{
				setTabBtnState(2,mc);
				updateBtnState();
			});
			rsrLoader.addCallBack(_mcRoleProperty.btnNewLife,function (mc:MovieClip):void
			{
				setTabBtnState(1,mc);
				updateBtnState();
			});
			
		}
		
		private function setTabBtnState(tab:int,mc:MovieClip):void
		{
			var textField:TextField = mc.txt as TextField;
			textField.wordWrap=true;
			var format:TextFormat=new TextFormat;
			format.leading=8;
			textField.defaultTextFormat=format;
		}
		
		
		private function initText():void
		{
			var _textFormat:TextFormat;	
			_textFormat = _mcRoleProperty.rolePropertyText.defaultTextFormat;
			_textFormat.bold = true;
			_mcRoleProperty.rolePropertyText.defaultTextFormat = _textFormat;
			_mcRoleProperty.rolePropertyText.setTextFormat(_textFormat);
			_mcRoleProperty.rolePropertyText.text = StringConst.ROLE_PROPERTY_PANEL_0019;
		}
		
		override public function update(proc:int = 0):void
		{
			
		}
		
		override public function destroy():void
		{
			if(_rolePropertyMouseHandle)
			{
				_rolePropertyMouseHandle.destroy();
				_rolePropertyMouseHandle = null;
			}
			setSonPanelNull();
			_mcRoleProperty = null;
			var i:int,l:int = _skin.numChildren;
			for (i=0;i<l;i++) 
			{
				var textField:TextField = _skin.getChildAt(i) as TextField;
				if(textField)
				{
					ToolTipManager.getInstance().detach(textField);
				}
			}
			super.destroy();
		}
		
		
		public function getTabIndex():int
		{
			return _rolePropertyMouseHandle.getTabIndex();
		}
		
		public function setTabIndex(index:int):void
		{
			_rolePropertyMouseHandle.setTabIndex(index);
		}
		
	}
}