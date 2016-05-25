package com.view.gameWindow.panel.panels.skill
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UIUnlockHandler;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.skill.constants.SkillConstants;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class PanelSkillClickHandle
	{
		private var _panel:PanelSkill;
		private var _skin:McPanelSkill;
		private var _lastMc:MovieClip;
		private var _lastText:String;
		private var _page:int,_totalPage:int;
		private var _unlock:UIUnlockHandler;
		
		public function getTabIndex():int
		{
			return SkillDataManager.instance.entity_type - 1;
		}
		
		public function setTabIndex(index:int):void
		{
			if(index == 1)
			{
				setSelected(SkillConstants.TYPE_HERO,StringConst.SKILL_PANEL_0003);
			}
			else
			{
				setSelected(SkillConstants.TYPE_ROLE,StringConst.SKILL_PANEL_0002);
			}
		}
		
		public function PanelSkillClickHandle(panel:PanelSkill)
		{
			_panel = panel;
			_skin = _panel.skin as McPanelSkill;
			initializer();
		}
		
		private function initializer():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			//
			getTotalPage();
			
			_unlock = new UIUnlockHandler(getUnlockBtn);
			_unlock.updateUIState(UnlockFuncId.SKILL_HERO);
		}
		
		private function getUnlockBtn(id:int):*
		{
			if(id == UnlockFuncId.SKILL_HERO)
			{
				return _skin.btnSkills1;
			}
			
			return null;
		}
		
		private function getTotalPage():void
		{
			_page = 1;
			var pageNum:int = PanelSkillItem.pageNum;
			var length:int = _panel.itemHandle.lv1SkillCfgDatas.length;
			_totalPage = int((length+pageNum-1)/pageNum);
		}
		/**初始化默认选中按钮*/
		public function setDefault(index:int):void
		{
			var entity_type:int = SkillDataManager.instance.entity_type;
			var mc:MovieClip = _skin["btnSkills"+index] as MovieClip;
			var str:String = StringConst["SKILL_PANEL_000"+(index+2)] as String;
			var txt:TextField = mc.txt as TextField;
			if(entity_type == index+1)
			{
				mc.selected = true;
				mc.mouseEnabled = false;
				txt.text = str;
				txt.textColor = 0xffe1aa;
				_lastMc = mc;
				_lastText = str;
			}
			else
			{
				txt.text = str;
				txt.textColor = 0x675138;
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _skin.btnClose:
					PanelMediator.instance.closePanel(PanelConst.TYPE_SKILL);
					break;
				case _skin.btnPrev:
					if(_page > 1)
					{
						_page--;
						refreshPageText();
						_panel.itemHandle.refreshItems();
					}
					break;
				case _skin.btnNext:
					if(_page < _totalPage)
					{
						_page++;
						refreshPageText();
						_panel.itemHandle.refreshItems();
					}
					break;
				case _skin.btnSkills0:
					setSelected(SkillConstants.TYPE_ROLE,StringConst.SKILL_PANEL_0002);
					break;
				case _skin.btnSkills1:
					setSelected(SkillConstants.TYPE_HERO,StringConst.SKILL_PANEL_0003);
					break;
				case _skin.btnSkills2:
					setSelected(SkillConstants.TYPE_COMBINED,StringConst.SKILL_PANEL_0004);
					break;
				case _skin.btnSkills3:
					setSelected(SkillConstants.TYPE_WITHIN,StringConst.SKILL_PANEL_0005);
					break;
			}
		}
		
		public function refreshPageText():void
		{
			if(_totalPage == 0)
			{
				_skin.txtPage.text = "";
			}
			else
			{
				_skin.txtPage.text = _page+"/"+_totalPage;
			}
		}
		
		private function setSelected(index:int,nowText:String):void
		{
			var nowMc:MovieClip,textField:TextField;
			//
			nowMc = _skin["btnSkills"+(index-1)];
			_lastMc.selected = false;
			_lastMc.mouseEnabled = true;
			textField = _lastMc.txt as TextField;
			textField.text = _lastText;
			textField.textColor = 0x675138;
			//
			nowMc.selected = true;
			nowMc.mouseEnabled = false;
			textField = nowMc.txt as TextField;
			textField.text = nowText;
			textField.textColor = 0xffe1aa;
			//
			_lastMc = nowMc;
			_lastText = nowText;
			//
			SkillDataManager.instance.entity_type = index;
			getTotalPage();
			refreshPageText();
			_panel.itemHandle.refreshItems();
		}
		
		internal function destroy():void
		{
			if(_unlock)
			{
				_unlock.destroy();
				_unlock = null;
			}
			
			_lastMc = null;
			if(_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK,onClick);
			}
			_skin = null;
			_panel = null;
		}
		/**当前页*/
		public function get page():int
		{
			return _page;
		}
		/**总页数*/
		public function get totalPage():int
		{
			return _totalPage;
		}
	}
}