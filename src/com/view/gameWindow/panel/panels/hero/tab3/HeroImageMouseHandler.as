package com.view.gameWindow.panel.panels.hero.tab3
{
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.hero.tab3.chest.HeroFashionChest;
	import com.view.gameWindow.util.PageListData;
	
	import flash.events.MouseEvent;
	

	public class HeroImageMouseHandler
	{
		private var _heroImageTab:HeroImageTab;
		private var skin:mcHeroImageTab;
		
		public function HeroImageMouseHandler(heroImageTab:HeroImageTab)
		{
			this._heroImageTab = heroImageTab;
			skin = heroImageTab.skin as mcHeroImageTab;
			skin.addEventListener(MouseEvent.CLICK,onClickFunc);
		}
		
		protected function onClickFunc(event:MouseEvent):void
		{
			switch(event.target)
			{
				case skin.upBtn:
					onUpFunc();
					break;
				case skin.downBtn:
					onDownFunc();
					break;
				case skin.btnSelect:
					dealOnSelect();
					break;
				case skin.btnNoSelect:
					dealOnNOtSelect();
					break;
			}
			
			if(event.target is HeroFashionChest)
			{
				var heroFashionChest:HeroFashionChest = event.target as HeroFashionChest;
				_heroImageTab.setSelect(heroFashionChest);
				HeroDataManager.instance.fashionUse=true;
				_heroImageTab.chageModel();
				_heroImageTab.chageAttr();
			}
		}
		
		private function dealOnNOtSelect():void
		{
			HeroDataManager.instance.fashionUse=false;
			HeroDataManager.instance.requestUseImage(0);
		}
		
		private function dealOnSelect():void
		{
			if(HeroDataManager.instance.currentSelectChest==null)
			{
				return;
			}
			var id:int =HeroDataManager.instance.currentSelectChest.id;
			HeroDataManager.instance.fashionUse=true;
			HeroDataManager.instance.requestUseImage(id);
		}
		
		private function onDownFunc():void
		{
			var heroChestPage:PageListData = HeroDataManager.instance.heroChestPage;
			heroChestPage.next();
			_heroImageTab.handler.updateChest();
		}
		
		private function onUpFunc():void
		{
			var heroChestPage:PageListData = HeroDataManager.instance.heroChestPage;
			heroChestPage.prev();
			_heroImageTab.handler.updateChest();
		}
		
		public function destroy():void
		{
			skin.removeEventListener(MouseEvent.CLICK,onClickFunc);
		}
	}
}