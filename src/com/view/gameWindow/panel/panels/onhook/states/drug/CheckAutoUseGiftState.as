package com.view.gameWindow.panel.panels.onhook.states.drug
{
	import com.model.consts.ConstStorage;
	import com.model.consts.SlotType;
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.hero.tab1.bag.HeroBagCellClickHandle;
	import com.view.gameWindow.panel.panels.onhook.AutoDataManager;
	
	
	/**
	 * @author wqhk
	 * 2015-2-3
	 */
	public class CheckAutoUseGiftState implements IState
	{
//		private var autoUseList:Array;
		
//		private var heroBagHandler:HeroBagCellClickHandle;
		
		public function CheckAutoUseGiftState()
		{
//			autoUseList = AutoDataManager.instance.getAutoUseGift();
//			heroBagHandler = new HeroBagCellClickHandle(null);
		}
		
		
		private var bagList:Array;
		private var heroList:Array;
		
		public function next(i:IIntention=null):IState
		{
			var bag:Vector.<BagData> = BagDataManager.instance.bagCellDatas;
			var hero:Vector.<BagData> = HeroDataManager.instance.bagCellDatas;
			if(BagDataManager.instance.isChangeForAutoDrug || !bagList)
			{
				bagList =  BagDataManager.checkAutoUseGift(bag);
			}
			
			if(HeroDataManager.instance.isChangeForAutoDrug || !heroList)
			{
				heroList = BagDataManager.checkAutoUseGift(hero);
			}
			
			if(bagList.length == 0)
			{
				BagDataManager.instance.isChangeForAutoDrug = false;
			}
			else
			{
				useItem(bagList);
			}
			
			if(heroList.length == 0)
			{
				HeroDataManager.instance.isChangeForAutoDrug = false;
			}
			else
			{
				useItem(heroList);
			}
			
			return this;
		}
		
		private function useItem(list:*):void
		{
			for each(var data:BagData in list)
			{
				if(!BagDataManager.instance.checkUseCD(data.slot,data.storageType))
				{
					if(data.storageType == ConstStorage.ST_CHR_BAG)
					{
						BagDataManager.instance.requestUseItem(data.id,1);
					}
					else if(data.storageType == ConstStorage.ST_HERO_BAG)
					{
						HeroDataManager.instance.requestUseItem(data);
					}
				}
			}
		}
		
//		public function next(i:IIntention=null):IState
//		{
//			var bag:Vector.<BagData> = BagDataManager.instance.bagCellDatas;
//			useItem(bag);
//			var hero:Vector.<BagData> = HeroDataManager.instance.bagCellDatas;
//			useItem(hero);
//			
//			return this;
//		}
		
//		private function useItem(bag:Vector.<BagData>):void
//		{
//			for each(var data:BagData in bag)
//			{
//				if(data && data.type == SlotType.IT_ITEM)
//				{
//					if(autoUseList.indexOf(data.id) != -1)
//					{
//						if(data.storageType == ConstStorage.ST_CHR_BAG)
//						{
//							if(BagDataManager.instance.requestUseItem(data.id,1))
//							{
//								return;//如果成功使用 就返回 
//							}
//						}
//						else if(data.storageType == ConstStorage.ST_HERO_BAG)
//						{
//							if(heroBagHandler.dealUseWear(data,false))
//							{
//								return;
//							}
//						}
//					}
//				}
//			}
//		}
	}
}