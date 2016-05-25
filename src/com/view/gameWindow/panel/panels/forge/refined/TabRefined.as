package com.view.gameWindow.panel.panels.forge.refined
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.util.tabsSwitch.ITabBase;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	
	/**
	 * 洗练标签页类
	 * @author Administrator
	 */	
	public class TabRefined extends TabBase implements ITabBase
	{
		internal var clickHandle:RefinedClickHandle;
		internal var viewHandle:RefinedViewHandle;
		internal var rightClickHandle:RefinedRightClickHandle;
		internal var cellHandle:RefinedCellHandle;
		
		public function TabRefined()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McRefined = new McRefined();
			_skin = skin;
			addChild(_skin);
			//
			/*skin.btnHeroEquip.visible = false;
			skin.btnBagItem.x = skin.btnHeroEquip.x;*/
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McRefined = _skin as McRefined;
			rsrLoader.addCallBack(skin.btnRoleEquip,function(mc:MovieClip):void
			{
				skin.btnRoleEquip.txt.textColor = 0xffe1aa;
				skin.btnRoleEquip.txt.text = StringConst.STRENGTH_PANEL_0001;
				skin.btnRoleEquip.selected = true;
			});	
			rsrLoader.addCallBack(skin.btnHeroEquip,function(mc:MovieClip):void
			{
				skin.btnHeroEquip.txt.textColor = 0x675138;
				skin.btnHeroEquip.txt.text = StringConst.STRENGTH_PANEL_0002;
			});
			rsrLoader.addCallBack(skin.btnBagItem,function(mc:MovieClip):void
			{
				skin.btnBagItem.txt.textColor = 0x675138;
				skin.btnBagItem.txt.text = StringConst.STRENGTH_PANEL_0003;
			});
			rsrLoader.addCallBack(skin.btnSure,function(mc:MovieClip):void
			{
				skin.btnSure.txt.text = StringConst.FORGE_PANEL_00016;
			});
		}
		
		override protected function initData():void
		{
			clickHandle = new RefinedClickHandle(this);
			viewHandle = new RefinedViewHandle(this);
			rightClickHandle = new RefinedRightClickHandle(this);
			cellHandle = new RefinedCellHandle(this);
		}
		
		override public function update(proc:int=0):void
		{
			if(rightClickHandle)
			{
				rightClickHandle.dealRefresh();
			}
		}
		
		override public function destroy():void
		{
			if(cellHandle)
			{
				cellHandle.destroy();
				cellHandle = null;
			}
			if(rightClickHandle)
			{
				rightClickHandle.destroy();
				rightClickHandle = null;
			}
			if(viewHandle)
			{
				viewHandle.destory();
				viewHandle = null;
			}
			if(clickHandle)
			{
				clickHandle.destroy();
				clickHandle = null;
			}
			super.destroy();
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			RoleDataManager.instance.attach(this);
			BagDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			RoleDataManager.instance.detach(this);
			BagDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}