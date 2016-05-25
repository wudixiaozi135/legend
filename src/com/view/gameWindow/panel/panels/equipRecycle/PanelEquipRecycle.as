package com.view.gameWindow.panel.panels.equipRecycle
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.McEquipRecycle;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;

	public class PanelEquipRecycle extends PanelBase
	{
		internal var viewhandle:EquipRecycleViewHandle;
		internal var mousehandle:EquipRecycleMouseHandle;

		public function PanelEquipRecycle()
		{
			super();
		}
		
		
		override protected function initSkin():void
		{
			 var skin:McEquipRecycle = new McEquipRecycle;
			 setTitleBar(skin.dropBox);
			 skin.tilteTxt.text = StringConst.EQUIPRECYCLE_PANEL_0018;
			 _skin = skin;
			 addChild(_skin);
		}
		
		override protected function initData():void
		{
			super.initData();
			
			EquipRecycleDataManager.instance.attach(this);
			BagDataManager.instance.attach(this);
			HeroDataManager.instance.attach(this);
			RoleDataManager.instance.attach(this);
			EquipRecycleDataManager.instance.queryEquipRecycleIinfo();
		}
 
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			viewhandle = new EquipRecycleViewHandle(this);
			viewhandle.init(rsrLoader);
			mousehandle = new EquipRecycleMouseHandle(this);
			mousehandle.init(rsrLoader);
		}
 
		override public function update(proc:int=0):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_HERO_INFO:
				case GameServiceConstants.SM_BAG_ITEMS:
				case GameServiceConstants.SM_CHR_INFO://脱衣服后
				{
					viewhandle.refresh();
					break;
				}
				case GameServiceConstants.SM_EQUIP_RECYCLE_INFO:
				{
					viewhandle.refresh();
					break;	
				}
				case GameServiceConstants.SM_EQUIP_RECYCLE_GET_INFO:
				{
					viewhandle.refreshAward();
					viewhandle.refreshEquip();
					break;	
				}
				case GameServiceConstants.CM_EQUIP_RECYCLE_GET_DAILY_REWARD:
				{
					viewhandle.flyAward();
					break;	
				}
			}			 
		}
		
		override public function setPostion():void
		{
			isMount(true);
		}
		
		
		override public function destroy():void
		{
			HeroDataManager.instance.detach(this);
			BagDataManager.instance.detach(this);
			EquipRecycleDataManager.instance.detach(this);
			RoleDataManager.instance.detach(this);
			EquipRecycleDataManager.instance.reset();
			mousehandle.destroy();
			viewhandle.destroy();
			super.destroy();
		}
		
	}
}