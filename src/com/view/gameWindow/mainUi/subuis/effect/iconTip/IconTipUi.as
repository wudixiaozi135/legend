package com.view.gameWindow.mainUi.subuis.effect.iconTip
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ReinCarnCfgData;
	import com.model.consts.StringConst;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.mainUi.MainUi;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.tips.iconTip.IconTipMediator;
	import com.view.gameWindow.tips.iconTip.IconTipType;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelTab;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.IRolePropertyPanel;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.newLife.NewLifeDataManager;
	
	import flash.display.DisplayObjectContainer;
	
	public class IconTipUi extends MainUi implements IObserver
	{
		private const MAXLEVEL:int = 68;
		private var _level:int;
		private var _num:int;//每次转生之前icon出现次数
		private var _reincarn:int;
		public function IconTipUi()
		{
			super();
			RoleDataManager.instance.attach(this);
			BagDataManager.instance.attach(this);
			NewLifeDataManager.instance.attach(this);
		}
		
		public function update(proc:int=0):void
		{
			refreshReincarn();
		}
		
		private function refreshReincarn():void
		{
			var roleDataManager:RoleDataManager = RoleDataManager.instance;
			var reincarnCfg:ReinCarnCfgData = ConfigDataManager.instance.reincarnCfgData(roleDataManager.reincarn);
			if(!ConfigDataManager.instance.reincarnCfgData(roleDataManager.reincarn + 1))
			{
				return;
			}
			if(_reincarn != roleDataManager.reincarn)
			{
				_num = 0;
			}
			if(roleDataManager.lv == MAXLEVEL + roleDataManager.reincarn && _level != roleDataManager.lv && _num == 0)
			{
				_num = 1;
				showReincarnIconTip();
			}
			if((_num == 1 && roleDataManager.lv == MAXLEVEL + roleDataManager.reincarn && 
				reincarnCfg.coin <= BagDataManager.instance.coinBind + BagDataManager.instance.coinUnBind && (roleDataManager.exp/ConfigDataManager.instance.levelCfgData(MAXLEVEL + roleDataManager.reincarn).player_exp == 1 ||
					(NewLifeDataManager.instance.dungeon == reincarnCfg.dungeon && NewLifeDataManager.instance.time))))
			{
				_num = 2;
				showReincarnIconTip();
			}
			_reincarn = roleDataManager.reincarn;
			_level = roleDataManager.lv;
		}
		
		override public function initView():void
		{
			
		}
		
		private function showReincarnIconTip():void
		{
			var panel:IPanelTab;
			IconTipMediator.instance.showIconTip(IconTipType.IconTipREINCARN,StringConst.ICON_TIP_0001,function():void
			{
				PanelMediator.instance.openPanel(PanelConst.TYPE_ROLE_PROPERTY);
				panel = getUI(PanelConst.TYPE_ROLE_PROPERTY) as IPanelTab;
				panel.setTabIndex(2);
			});
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
	}
}