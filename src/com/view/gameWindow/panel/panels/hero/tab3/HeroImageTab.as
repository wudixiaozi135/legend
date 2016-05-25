package com.view.gameWindow.panel.panels.hero.tab3
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.hero.tab3.chest.HeroFashionChest;
	import com.view.gameWindow.util.FilterUtil;
	import com.view.gameWindow.util.LoaderCallBackAdapter;
	import com.view.gameWindow.util.PageListData;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	public class HeroImageTab extends TabBase
	{
		private var _handler:HeroImageHandler;
		private var _mouseHandler:HeroImageMouseHandler;
		private var _modelHandle:EntityModeInImagelHandle;
		
		public function HeroImageTab()
		{
			super();
			this.mouseEnabled=false;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			 var tab:mcHeroImageTab = _skin as mcHeroImageTab;
			 var loaderCallBackAdapter:LoaderCallBackAdapter = new LoaderCallBackAdapter();
			 var heroChestPage:PageListData = HeroDataManager.instance.heroChestPage;
			 loaderCallBackAdapter.addCallBack(rsrLoader,function ():void
			 {
				 if(heroChestPage.list!=null)
				 {
				 	tab.upBtn.btnEnabled=heroChestPage.hasPre();
				 	tab.downBtn.btnEnabled=heroChestPage.hasNext();
				 }
				 loaderCallBackAdapter=null;
			 },tab.upBtn,tab.downBtn);
			super.addCallBack(rsrLoader);
		}

		override protected function initSkin():void
		{
			var skin:mcHeroImageTab = new mcHeroImageTab();
			_skin = skin;
			_skin.mouseEnabled=false;
			addChild(_skin);
			_handler=new HeroImageHandler(this);
			_mouseHandler=new HeroImageMouseHandler(this);
		}
		
		override public function update(proc:int=0):void
		{
			if(proc==GameServiceConstants.SM_HERO_CHEST_QUERY)
			{
				_handler.updateChest();
				chageModel();
			}
			super.update(proc);
		}
		
		public function setSelect(heroFashionChest:HeroFashionChest):void
		{
			if(HeroDataManager.instance.currentSelectChest!=null)
			{
				HeroDataManager.instance.currentSelectChest.filters=null;
			}
			HeroDataManager.instance.currentSelectChest=heroFashionChest;
			HeroDataManager.instance.currentSelectChest.filters=[FilterUtil.getClolorFilter()];
		}
		
		public function chageModel():void
		{
			var id:int=0
			if(HeroDataManager.instance.currentSelectChest!=null)
			{
				id=HeroDataManager.instance.currentSelectChest.id;
			}
			if(HeroDataManager.instance.fashionUse==false)
			{
				id=0;
			}
			_modelHandle.changeModel(id);
		}
		
		public function chageAttr():void
		{
			_handler.updateAttr();
		}
		
		override public function destroy():void
		{
			HeroDataManager.instance.currentSelectChest=null;
			HeroDataManager.instance.fashionUse=true;
			if(_modelHandle)
			{
				_modelHandle.destroy();
				_modelHandle = null;
			}
			_handler&&_handler.destroy();
			_handler=null;
			_mouseHandler&&_mouseHandler.destroy(); 
			_mouseHandler=null;
			super.destroy();
		}
		
		override protected function initData():void
		{
			_modelHandle = new EntityModeInImagelHandle(_skin.mcModel);
			HeroDataManager.instance.heroChestQuery();
		}

		public function get handler():HeroImageHandler
		{
			return _handler;
		}

		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			HeroDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			HeroDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}