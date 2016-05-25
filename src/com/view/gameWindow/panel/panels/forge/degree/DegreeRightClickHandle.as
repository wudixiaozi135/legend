package com.view.gameWindow.panel.panels.forge.degree
{
    import com.model.consts.ConstStorage;
    import com.view.gameWindow.panel.panels.bag.BagData;
    import com.view.gameWindow.panel.panels.forge.ForgeDataManager;
    import com.view.gameWindow.panel.panels.forge.McUpDegree;
    import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
    import com.view.gameWindow.util.cell.CellData;
    
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import com.view.gameWindow.panel.panels.forge.DataTabSecondSelect;

    /**
	 * 锻造进阶面板装备项相关点击处理类
	 * @author Administrator
	 */	
	public class DegreeRightClickHandle
	{
		private var _panel:TabDegree;
		private var _mc:McUpDegree;
		private const _numPage:int = 7;
		private var _type:int,_page:int,_totalPage:int,_index:int;
		private var currentDatas:Vector.<CellData>;
		
		internal var isInited:Boolean;
		
		public function DegreeRightClickHandle(panel:TabDegree)
		{
			_panel = panel;
			_mc = _panel.skin as McUpDegree;
			init();
		}
		
		public function destroy():void
		{
			_index = 0;
			currentDatas = null;
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.CLICK,onClick);
				_mc = null;
			}
			_panel = null;
		}
		
		private function init():void
		{
			_page = 1;
			_totalPage = 0;
			var typeSecond:int = ForgeDataManager.instance.dtTabSecondSelect.typeSecond;
			_type = typeSecond ? typeSecond : ConstStorage.ST_CHR_EQUIP;
			_mc.addEventListener(MouseEvent.CLICK,onClick,false,1);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _mc.btnRoleEquip:
					dealRefresh(ConstStorage.ST_CHR_EQUIP);
					break;
				case _mc.btnHeroEquip:
					dealRefresh(ConstStorage.ST_HERO_EQUIP);
					break;
				case _mc.btnBagItem:
					dealRefresh(ConstStorage.ST_CHR_BAG);
					break;
				case _mc.btnPrev:
					dealPrev();
					break;
				case _mc.btnNext:
					dealNext();
					break;
			}
		}
		
		internal function dealRefresh(type:int = 0,isNotReset:Boolean = false):void
		{
			type != 0 ? _type = type : null;
			switch(_type)
			{
				default:
				case ConstStorage.ST_CHR_EQUIP:
					dealRoleEquip();
					break;
				case ConstStorage.ST_HERO_EQUIP:
					dealHeroEquip();
					break;
				case ConstStorage.ST_CHR_BAG:
					dealRoleBag();
					break;
			}
			_panel.degreeCellHandle.refreshData(currentDatas,(type != 0 || !isInited) && !isNotReset);
			_panel.degreeViewHandle.refresh();
		}
		
		private function dealRoleEquip():void
		{
			setSelected(_mc.btnRoleEquip);
			//
            var datas:Vector.<EquipData> = DegreeFilterUtil.getSatisfyDegreeRoleEquips();
			getPageIndex(Vector.<CellData>(datas));
			refreshPageTxt(Vector.<CellData>(datas));
			currentDatas = Vector.<CellData>(datas.slice((_page-1)*_numPage,_page*_numPage > datas.length ? datas.length : _page*_numPage));
		}
		
		private function dealHeroEquip():void
		{
			setSelected(_mc.btnHeroEquip);
			//
			var datas:Vector.<EquipData> = DegreeFilterUtil.getSatisfyDegreeHeroEquips();
			getPageIndex(Vector.<CellData>(datas));
			refreshPageTxt(Vector.<CellData>(datas));
			currentDatas = Vector.<CellData>(datas.slice((_page-1)*_numPage,_page*_numPage > datas.length ? datas.length : _page*_numPage));
		}
		
		private function dealRoleBag():void
		{
			setSelected(_mc.btnBagItem);
			//
            var datas:Vector.<BagData> = DegreeFilterUtil.getSatisfyDegreeBagEquips();
			getPageIndex(Vector.<CellData>(datas));
			refreshPageTxt(Vector.<CellData>(datas));
			currentDatas = Vector.<CellData>(datas.slice((_page-1)*_numPage,_page*_numPage > datas.length ? datas.length : _page*_numPage));
		}
		/**装备来源选中切换*/
		private function setSelected(mc:MovieClip):void
		{
			if(!mc.hasOwnProperty("txt"))
			{
				return;
			}
			_mc.btnRoleEquip.selected = false;
			_mc.btnHeroEquip.selected = false;
			_mc.btnBagItem.selected = false;
			_mc.btnRoleEquip.txt.textColor = 0x675138;
			_mc.btnHeroEquip.txt.textColor = 0x675138;
			_mc.btnBagItem.txt.textColor = 0x675138;
			mc.selected = true;
			mc.txt.textColor = 0xffe1aa;
		}
		
		private function refreshPageTxt(datas:Vector.<CellData>):void
		{
			_totalPage = (datas.length + _numPage - 1) / _numPage;
			if(_totalPage == 0)
			{
				_mc.txtPage.text = "";
			}
			else
			{
				_page = _page > _totalPage ? 1 : _page;
				_mc.txtPage.text = _page + "/" + _totalPage;
			}
		}
		
		private function getPageIndex(datas:Vector.<CellData>):void
		{
			var dt:DataTabSecondSelect = ForgeDataManager.instance.dtTabSecondSelect;
			if(dt.isNotifyUpdateTabSecond)
			{
				var selectId:int = dt.selectId;
				var selectSid:int = dt.selectSid;
				var dtCell:CellData;
				var i:int,l:int = datas.length;
				for (i=0;i<l;i++) 
				{
					dtCell = datas[i];
					if(dtCell.id == selectId && dtCell.bornSid == selectSid)
					{
						_page = int(i/_numPage) + 1;
						var index:int = i - (_page - 1) * _numPage;
						_panel.degreeCellHandle.setSelect(index,dtCell);
						return;
					}
				}
			}
		}
		
		private function dealPrev():void
		{
			if(_page > 1)
			{
				_page--;
				dealRefresh(_type);
			}
		}
		
		private function dealNext():void
		{
			if(_page < _totalPage)
			{
				_page++;
				dealRefresh(_type);
			}
		}
		
		internal function get isTypeRoleEquip():Boolean
		{
			return _type == ConstStorage.ST_CHR_EQUIP;
		}
		
		internal function get isTypeHeroEquip():Boolean
		{
			return _type == ConstStorage.ST_HERO_EQUIP;
		}
	}
}