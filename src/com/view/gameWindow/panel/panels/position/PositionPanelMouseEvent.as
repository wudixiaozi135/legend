package com.view.gameWindow.panel.panels.position
{
    import com.event.GameDispatcher;
    import com.event.GameEventConst;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.PositionCfgData;
    import com.model.configData.cfgdata.PositionChopCfgData;
    import com.model.consts.StringConst;
    import com.model.gameWindow.mem.MemEquipDataManager;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.IPanelTab;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    import com.view.gameWindow.panel.panels.mall.constant.MallTabType;
    import com.view.gameWindow.panel.panels.prompt.Panel2BtnPromptData;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.stronger.PanelStronger;
    import com.view.gameWindow.panel.panels.stronger.data.StrongerTabType;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.UtilItemParse;
    
    import flash.display.DisplayObjectContainer;
    import flash.events.MouseEvent;
    import flash.events.TextEvent;

    public class PositionPanelMouseEvent
	{ 
		private var _positionPanel:PositionPanel;
//		private var _nextPositionCfg:PositionCfgData;
//		private var _positionCfg:PositionCfgData;
		private var _position:int;
//        private var urlPic:UrlPic;
//		private var url:String;
		private const ROLE:int = 1;
		private const HERO:int = 2;
		
		public function PositionPanelMouseEvent(positionPanel:PositionPanel)
		{
			_positionPanel = positionPanel;
		}
		
		public function init():void
		{
//			urlPic = new UrlPic(_positionPanel.skin.icon.contain);
//			_position = PositionDataManager.instance.position;
			_positionPanel._mcPosition.addEventListener(MouseEvent.CLICK,clickHandle);
			_positionPanel._mcPosition.txt_01.addEventListener(TextEvent.LINK,linkHandle);
//			var positionCfg:PositionCfgData = ConfigDataManager.instance.positionCfgData(_position + _positionPanel._page );
//			positionCfg=positionCfg||ConfigDataManager.instance.positionCfgData(_position + _positionPanel._page +1);
			
//			dealContent(positionCfg);
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			switch(evt.target)
			{
				case _positionPanel._mcPosition.btnClose:
					dealClose();
					break;
				case _positionPanel._mcPosition.btnLeft:
					dealLeft();
					break;
				case _positionPanel._mcPosition.btnRight:
					dealRight();
					break;
				case _positionPanel._mcPosition.BtnJob:
					dealJob();
					break;
				case _positionPanel._mcPosition.btnGet:
					dealGet();
					break;
				case _positionPanel._mcPosition.btnGet2:
					dealGet2();
					break;
				case _positionPanel._mcPosition.btnDouble:
					dealDouble();
					break;
				case _positionPanel._mcPosition.btnFree:
					dealFree();
					break;
				case _positionPanel._mcPosition.btnMc.btnPositionChop:
					dealPositionChop();
					break;
				case _positionPanel._mcPosition.chop.btnLong:
					dealBtnLong();
					break;
				case _positionPanel._mcPosition.icon:
					break;
			}
		}
		
		private function dealBtnLong():void
		{
			var _nextPositionChopCfg:PositionChopCfgData=ConfigDataManager.instance.positionChopCfgData(PositionDataManager.instance.rolePositionLevel+1);
			if(_nextPositionChopCfg.exploit_cost > RoleDataManager.instance.merit)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.POSITION_PANEL_0042);
				return;
			}
			if(UtilItemParse.getThingsData(_nextPositionChopCfg.item_cost).count >BagDataManager.instance.getItemNumById(UtilItemParse.getThingsData(_nextPositionChopCfg.item_cost).itemCfgData.id))
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.POSITION_PANEL_0043.replace("X",UtilItemParse.getThingsData(_nextPositionChopCfg.item_cost).itemCfgData.name));
				return;
			}
			PositionDataManager.instance.updatePositionChop();
			PositionDataManager.instance._callBack = function():void
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.POSITION_PANEL_0044);
				_positionPanel.refreshChopTxt();
				_nextPositionChopCfg = ConfigDataManager.instance.positionChopCfgData(MemEquipDataManager.instance.equipedMemEquipDataByType(ConfigDataManager.instance.equipCfgData(RoleDataManager.instance.baseId?RoleDataManager.instance.baseId:HeroDataManager.instance.basicId).type).strengthen + 1);
				if(!_nextPositionChopCfg ||(_nextPositionChopCfg && _nextPositionChopCfg.position_level > RoleDataManager.instance.position))
				{
					_positionPanel._mcPosition.btnMc.btnPositionChop.btnEnabled = false;
					_positionPanel._mcPosition.txt_03.textColor = 0x6a6a6a;
					_positionPanel._mcPosition.chop.visible = false;
				}
			}	
		}
		
		private function dealPositionChop():void
		{
			_positionPanel._mcPosition.chop.visible = _positionPanel._mcPosition.chop.visible?false:true;
			_positionPanel.refreshChopTxt();
		}
		
		private function dealJob():void
		{
			var _nextPositionCfg:PositionCfgData = ConfigDataManager.instance.positionCfgData(PositionDataManager.instance.position+1);
			if(!_nextPositionCfg)
			{
				return;
			}
			
			if(RoleDataManager.instance.merit < _nextPositionCfg.exploit_cost)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.POSITION_PANEL_0029);
				return;
			}
			
			PositionDataManager.instance.enterPosition(_nextPositionCfg.level);
			PositionDataManager.instance._callBack = function():void
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.POSITION_PANEL_0030.replace("XX",_nextPositionCfg.name));
			}
		}

        /**角色领取*/
		private function dealGet():void
		{
			_position = PositionDataManager.instance.position;
			var positionCfg:PositionCfgData = positionCfg=_positionPanel.getCfg();
			if(RoleDataManager.instance.position<positionCfg.level)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.POSITION_PANEL_0032);
				_positionPanel._mcPosition.btnGet.selected = false;
				return;
			}
			if(RoleDataManager.instance.reincarn < positionCfg.change_count)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.POSITION_PANEL_0033);
				_positionPanel._mcPosition.btnGet.selected = false;
				return;
			}
			if(RoleDataManager.instance.reincarn == positionCfg.change_count)
			{
				if(RoleDataManager.instance.lv < positionCfg.chr_level)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.POSITION_PANEL_0033);
					_positionPanel._mcPosition.btnGet.selected = false;
					return;
				}
			}
			PositionDataManager.instance.getPositionChop(ROLE);
			PositionDataManager.instance._callBack = function():void
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.POSITION_PANEL_0035.replace("XX",ConfigDataManager.instance.equipCfgData(positionCfg.chopid).name));
                GameDispatcher.dispatchEvent(GameEventConst.POSITION_EFFECT, {type: 1, id: positionCfg.chopid});
            };
		}

        /**英雄领取*/
		private function dealGet2():void
		{
			_position = PositionDataManager.instance.position;
			var positionCfg:PositionCfgData =_positionPanel.getCfg();
//			positionCfg=positionCfg||ConfigDataManager.instance.positionCfgData(_position + _positionPanel._page+1);
			if(RoleDataManager.instance.position<positionCfg.level)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.POSITION_PANEL_0032);
				_positionPanel._mcPosition.btnGet2.selected = false;
				return;
			}
			if(HeroDataManager.instance.grade < positionCfg.hero_groude)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.POSITION_PANEL_0034);
				_positionPanel._mcPosition.btnGet2.selected = false;
				return;
			}
			if(HeroDataManager.instance.grade == positionCfg.hero_groude)
			{
				if(HeroDataManager.instance.lv < positionCfg.hero_level)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.POSITION_PANEL_0034);
					_positionPanel._mcPosition.btnGet2.selected = false;
					return;
				}
			}
			PositionDataManager.instance.getPositionChop(HERO);
			PositionDataManager.instance._callBack = function():void
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.POSITION_PANEL_0035.replace("XX",ConfigDataManager.instance.equipCfgData(positionCfg.hero_chopid).name));
//				setBtnGet2(true);
                GameDispatcher.dispatchEvent(GameEventConst.POSITION_EFFECT, {type: 2, id: positionCfg.chopid});
            };
//			_positionPanel.refreshEffect();
		}
		
		private function dealDouble():void
		{
			showRollTip(PositionType.DOUBLEGET);
		}
		
		private function dealFree():void
		{
			showRollTip(PositionType.FREEGET);
		}
		/**
		 *领取俸禄提示 
		 * 
		 */		
		private function showRollTip(type:int):void
		{
			_position = PositionDataManager.instance.position;
			var positionCfg:PositionCfgData = ConfigDataManager.instance.positionCfgData(_position);
			if(!positionCfg)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.POSITION_PANEL_0036);
				return;
			}
			if(PositionDataManager.instance.isget == PositionType.GET)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.POSITION_PANEL_0037);
				return;
			}
			if(type == PositionType.DOUBLEGET && positionCfg.double_cost_gold > BagDataManager.instance.goldUnBind)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.POSITION_PANEL_0038);
				return;
			}
			if(type == PositionType.DOUBLEGET)
			{
				Panel2BtnPromptData.strSureBtn = StringConst.POSITION_PANEL_0049;
				Panel2BtnPromptData.strCancelBtn = StringConst.TRANS_PANEL_0031;
				Panel2BtnPromptData.strContent = StringConst.POSITION_PANEL_0050.replace("X",positionCfg.double_cost_gold);
				Panel2BtnPromptData.funcBtn = function():void
				{
					PositionDataManager.instance.getPositionSalary(type);
					PanelMediator.instance.closePanel(PanelConst.TYPE_2BTN_PROMPT);
                };
				PanelMediator.instance.openPanel(PanelConst.TYPE_2BTN_PROMPT);
				return;
			}
			PositionDataManager.instance.getPositionSalary(type);
		}
		
		public function dealLeft():void
		{
			var cfg:PositionCfgData = _positionPanel.getCfg();
			var positionCfg:PositionCfgData = ConfigDataManager.instance.positionCfgData(cfg.level -1);
			if(!positionCfg)
			{
				_positionPanel._mcPosition.btnLeft.btnEnabled = false;
				return;
			}
			_positionPanel._page -= 1;
			dealContent();
			_positionPanel._mcPosition.btnRight.btnEnabled = true;
		}
		
		public function dealContent():void
		{
			_positionPanel.refreshContent();
		}
		
		private function dealRight():void
		{
			_position = PositionDataManager.instance.position;
//			var positionDataManager:PositionDataManager = PositionDataManager.instance;
			var cfg:PositionCfgData = _positionPanel.getCfg()
			var positionCfg:PositionCfgData = ConfigDataManager.instance.positionCfgData(cfg.level +1);
			if(positionCfg==null || positionCfg.level - _position > 1)
			{
				Alert.message(StringConst.POSITION_PANEL_0051);
				return;
			}
			_positionPanel._page += 1;
//			positionCfg = ConfigDataManager.instance.positionCfgData(_position + _positionPanel._page + 1);
//			if(positionCfg ==null || positionCfg.level - PositionDataManager.instance.position > 1)
//			{
//				_positionPanel._mcPosition.btnRight.btnEnabled = false;
//			}
//			positionCfg = ConfigDataManager.instance.positionCfgData(_position + _positionPanel._page);
			dealContent();
			_positionPanel._mcPosition.btnLeft.btnEnabled = true;
		}
		
		private function linkHandle(evt:TextEvent):void
		{
			
			var panel:PanelStronger = PanelMediator.instance.openedPanel(PanelConst.TYPE_BECOME_STRONGER) as PanelStronger;
			if (panel)
			{
				panel.switchToTab(StrongerTabType.TAB_POSITION);
			}
			else
			{
				PanelMediator.instance.openPanel(PanelConst.TYPE_BECOME_STRONGER);
				panel = PanelMediator.instance.openedPanel(PanelConst.TYPE_BECOME_STRONGER) as PanelStronger;
				panel.switchToTab(StrongerTabType.TAB_POSITION);
			}
//			switch(evt.text)
//			{
//				case _positionPanel.DEALACHIEVE:
//					dealAchieve();
//					break;
//				case _positionPanel.DEALJINGJICHANG:
//					dealJingjichang();
//					break;
//				case _positionPanel.DEALTUCHENGZHENGBA:
//					dealTuchengzhengba();
//					break;
//				case _positionPanel.DEALLIQUANSHANGCHENG:
//					dealLiquanshangcheng();
//					break;
//			}
			
		}
		
		private function dealAchieve():void
		{
			PanelMediator.instance.openPanel(PanelConst.TYPE_ACHI);	
		}
		
		private function dealJingjichang():void
		{
			RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0007);
		}
		
		private function dealTuchengzhengba():void
		{
			RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0007);
		}
		
		private function dealLiquanshangcheng():void
		{
			var panel:IPanelTab;
			PanelMediator.instance.openPanel(PanelConst.TYPE_MALL);
			panel = getUI(PanelConst.TYPE_MALL) as IPanelTab;
			panel.setTabIndex(MallTabType.TYPE_TICKET);
		}
		
		public function getUI(name:String):*
		{
			var panel:DisplayObjectContainer = null;
			if(!panel)
			{
				panel = PanelMediator.instance.openedPanel(name) as DisplayObjectContainer;
			}
			
			return panel;
		}
		
		public function openUI(name:String):void
		{
			PanelMediator.instance.openPanel(name);
		}
		
		private function dealClose():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_POSITION);
		}
		
		public function destory():void
		{
//			if(urlPic)
//			{
//				urlPic.destroy();
//				urlPic = null;
//			}
			if(_positionPanel)
			{
				_positionPanel._mcPosition.removeEventListener(MouseEvent.CLICK,clickHandle);
				_positionPanel._mcPosition.txt_01.removeEventListener(TextEvent.LINK,linkHandle);
				_positionPanel = null;
			}
//			_nextPositionCfg = null;
		}
	}
}