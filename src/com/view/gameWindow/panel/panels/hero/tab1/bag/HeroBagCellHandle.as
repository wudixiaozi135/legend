package com.view.gameWindow.panel.panels.hero.tab1.bag
{
	import com.model.consts.ConstStorage;
	import com.view.gameWindow.mainUi.subuis.herohead.McHeroEquipPanel;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.cell.BagCell;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.hero.tab1.HeroEquipTab;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;

	/**
	 * 英雄背包单元格处理类
	 * @author Administrator
	 */	
	public class HeroBagCellHandle
	{
		private var _mc:McHeroEquipPanel;
		private var _bagCells:Vector.<BagCell>;

		internal var heroBagCellClickHandle:HeroBagCellClickHandle;
		internal var heroBagCellDragHandle:HeroBagCellDragHandle;
		internal var heroBagCellMouseEfHandler:HeroBagCellMouseEfHandler;
		
		public function HeroBagCellHandle(panel:HeroEquipTab)
		{
			_mc = panel.skin as McHeroEquipPanel;
			_mc.selectCellEfc.visible=false;
			init(panel);
		}
		
		private function init(panel:HeroEquipTab):void
		{
			var jl:int = 5,il:int = 6,i:int,j:int,vector:Vector.<BagCell>;
			_bagCells = new Vector.<BagCell>(HeroDataManager.totalCellNum,true);
			for(j=0;j<jl;j++)
			{
				for(i=0;i<il;i++)
				{
					var bagCell:BagCell = new BagCell();
					bagCell.storageType = ConstStorage.ST_HERO_BAG;
					bagCell.cellId = j*il+i;
					bagCell.initView();
					bagCell.refreshLockState(true);
					bagCell.x = 515+43*i;
					bagCell.y = 159+43*j;
					_mc.addChild(bagCell);
					_bagCells[j*il+i] = bagCell;
				}
			}
			heroBagCellClickHandle = new HeroBagCellClickHandle(panel);
			heroBagCellDragHandle = new HeroBagCellDragHandle(panel);
			heroBagCellMouseEfHandler=new HeroBagCellMouseEfHandler(panel);
		}
		
		public function refreshBagCellData():void
		{
			var bagCellDatas:Vector.<BagData>,dt:BagData,i:int,usedCell:int,numCelUnLock:int;
			bagCellDatas = HeroDataManager.instance.bagCellDatas;
			numCelUnLock = HeroDataManager.instance.numCelUnLock;
//			var isSay:Boolean=false;
			if(bagCellDatas)
			{
				for(i=0;i<HeroDataManager.totalCellNum;i++)
				{
					if(heroBagCellDragHandle.clickBagCell && _bagCells[i].cellId == heroBagCellDragHandle.clickBagCell.cellId)
					{
						continue;
					}
					dt = bagCellDatas[i];
					_bagCells[i].refreshLockState((i+1)>numCelUnLock);
					_bagCells[i]._isHeroBagCell = true;
					if(dt)
					{
						_bagCells[i].refreshData(dt);
						usedCell++;
//						if(BagDataManager.instance.isBagHeroFightPowerHigher(cellDatas))  //如果有更好的装备
//						{
//							isSay=true;
//						}
						ToolTipManager.getInstance().attach(_bagCells[i]);
					}
					else
					{
						ToolTipManager.getInstance().detach(_bagCells[i]);
						_bagCells[i].setNull();
					}
				}
			}
//			var myHero:IHero = EntityLayerManager.getInstance().myHero;
//			if(myHero!=null&&isSay)
//			{
//				myHero.say(StringConst.HERO_SAY_0004);
//			}
		}
		
		public function dealNotify(proc:int):void
		{
			heroBagCellClickHandle.dealNotify(proc);
		}
		
		public function destroy():void
		{
			if(heroBagCellClickHandle)
			{
				heroBagCellClickHandle.destory();
				heroBagCellClickHandle = null;
			} 
			if(heroBagCellDragHandle)
			{
				heroBagCellDragHandle.destroy();
				heroBagCellDragHandle = null;
			}
			if (heroBagCellMouseEfHandler)
			{
				heroBagCellMouseEfHandler.destory();
				heroBagCellMouseEfHandler = null;
			}
			var i:int,l:int;
			if(_bagCells)
			{
				l = _bagCells.length
			}
			for(i=0;i<l;i++)
			{
				_bagCells[i].destory();
				_bagCells[i] = null
			}
			_bagCells = null;
			_mc = null;
		}
	}
}