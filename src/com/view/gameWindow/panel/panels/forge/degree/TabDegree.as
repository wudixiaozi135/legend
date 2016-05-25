package com.view.gameWindow.panel.panels.forge.degree
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.ConstStorage;
    import com.model.consts.EffectConst;
    import com.model.consts.StringConst;
    import com.model.gameWindow.mem.MemEquipDataManager;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.forge.DataTabSecondSelect;
    import com.view.gameWindow.panel.panels.forge.ForgeDataManager;
    import com.view.gameWindow.panel.panels.forge.McUpDegree;
    import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    import com.view.gameWindow.util.UIEffectLoader;
    import com.view.gameWindow.util.tabsSwitch.TabBase;

    /**
	 * 锻造进阶面板类
	 * @author Administrator
	 */	
	public class TabDegree extends TabBase
	{
		internal var degreeClickHandle:DegreeClickHandle;
		internal var degreeViewHandle:DegreeViewHandle;
		internal var degreeCellHandle:DegreeCellHandle;
		internal var degreeRightClickHandle:DegreeRightClickHandle;
		private var _effectLoader:UIEffectLoader;
        private var _degreeSuccessHandler:DegreeSuccessHandler;
		
		public function TabDegree()
		{
			super();
			mouseEnabled = false;
		}
		
		override public function destroy():void
		{
			ForgeDataManager.instance.resetTabSecondInfo();

			if(degreeRightClickHandle)
			{
				degreeRightClickHandle.destroy();
				degreeRightClickHandle = null;
			}
			if(degreeCellHandle)
			{
				degreeCellHandle.destroy();
				degreeCellHandle = null;
			}
			if(degreeViewHandle)
			{
				degreeViewHandle.destroy();
				degreeViewHandle = null;
			}
			if(degreeClickHandle)
			{
				degreeClickHandle.destroy();
				degreeClickHandle = null;
			}
			if(_effectLoader)
			{
				_effectLoader.destroy();
				_effectLoader = null;
			}
            if (_degreeSuccessHandler)
            {
                _degreeSuccessHandler.destroy();
                _degreeSuccessHandler = null;
            }
			InterObjCollector.instance.remove(skin.btnSure);
			InterObjCollector.autoCollector.remove(skin.btnSure);
			super.destroy();
		}
		
		override protected function initSkin():void
		{
			_skin = new McUpDegree();
			var skin:McUpDegree = _skin as McUpDegree;
			skin.mouseEnabled = false;
			skin.layer.mouseEnabled = false;
			addChild(skin);
			//隐藏英雄装备按钮
			/*skin.btnHeroEquip.visible = false;
			skin.btnBagItem.x = skin.btnHeroEquip.x;*/
			//
			//隐藏包裹装备按钮
			skin.btnBagItem.visible = false;
			//
			_effectLoader = new UIEffectLoader(skin.layer,-145,-155,1,1,EffectConst.RES_FORGE_BG);
            _degreeSuccessHandler = new DegreeSuccessHandler(this);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McUpDegree = _skin as McUpDegree;
			rsrLoader.addCallBack(skin.btnRoleEquip,function():void
			{
				skin.btnRoleEquip.txt.text = StringConst.STRENGTH_PANEL_0001;
				var typeSecond:int = ForgeDataManager.instance.dtTabSecondSelect.typeSecond;
				if(!typeSecond || typeSecond == ConstStorage.ST_CHR_EQUIP)
				{
					skin.btnRoleEquip.txt.textColor = 0xffe1aa;
					skin.btnRoleEquip.selected = true;
				}
				else
				{
					skin.btnRoleEquip.txt.textColor = 0x675138;
				}
			});	
			rsrLoader.addCallBack(skin.btnHeroEquip,function():void
			{
				skin.btnHeroEquip.txt.text = StringConst.STRENGTH_PANEL_0002;
				var typeSecond:int = ForgeDataManager.instance.dtTabSecondSelect.typeSecond;
				if(typeSecond == ConstStorage.ST_HERO_EQUIP)
				{
					skin.btnHeroEquip.txt.textColor = 0xffe1aa;
					skin.btnHeroEquip.selected = true;
				}
				else
				{
					skin.btnHeroEquip.txt.textColor = 0x675138;
				}
			});
			rsrLoader.addCallBack(skin.btnBagItem,function():void
			{
				skin.btnBagItem.txt.text = StringConst.STRENGTH_PANEL_0003;
				var typeSecond:int = ForgeDataManager.instance.dtTabSecondSelect.typeSecond;
				if(typeSecond == ConstStorage.ST_CHR_BAG)
				{
					skin.btnBagItem.txt.textColor = 0xffe1aa;
					skin.btnBagItem.selected = true;
				}
				else
				{
					skin.btnBagItem.txt.textColor = 0x675138;
				}
			});
			rsrLoader.addCallBack(skin.btnSure,function():void
			{
				skin.btnSure.txt.text = StringConst.FORGE_PANEL_00012;
				InterObjCollector.instance.add(skin.btnSure);
				InterObjCollector.autoCollector.add(skin.btnSure);
			});
		}
		
		override protected function initData():void
		{
			degreeClickHandle = new DegreeClickHandle(this);
			degreeViewHandle = new DegreeViewHandle(this);
			degreeRightClickHandle = new DegreeRightClickHandle(this);
			degreeCellHandle = new DegreeCellHandle(this);
		}
		
		override public function update(proc:int=0):void
		{
			var dt:DataTabSecondSelect = ForgeDataManager.instance.dtTabSecondSelect;
			if(proc == 0)
			{
				degreeRightClickHandle.dealRefresh();
			}
			else if(proc == GameServiceConstants.SM_BAG_ITEMS || proc == GameServiceConstants.SM_HERO_INFO || proc == GameServiceConstants.SM_MEM_UNIQUE_EQUIP_INFO)
			{
				degreeRightClickHandle.dealRefresh(0,true);
			}
			else if(proc == DataTabSecondSelect.NOTIFY_UPDATE_TAB_SECOND)
			{
				degreeRightClickHandle.dealRefresh(dt.typeSecond,true);
			}
			dt.isNotifyUpdateTabSecond = false;
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			ForgeDataManager.instance.attach(this);
			MemEquipDataManager.instance.attach(this);
			BagDataManager.instance.attach(this);
			HeroDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			HeroDataManager.instance.detach(this);
			BagDataManager.instance.detach(this);
			MemEquipDataManager.instance.detach(this);
			ForgeDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}