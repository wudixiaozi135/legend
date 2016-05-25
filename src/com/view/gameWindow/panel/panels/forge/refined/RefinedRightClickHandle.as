package com.view.gameWindow.panel.panels.forge.refined
{
	import com.model.consts.ConstStorage;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
	import com.view.gameWindow.util.cell.CellData;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 锻造进阶面板装备项相关点击处理类
	 * @author Administrator
	 */	
	public class RefinedRightClickHandle
	{
		private var _panel:TabRefined;
		private var _skin:McRefined;
		
		private const _numPage:int = 7;
		private var _type:int,_page:int,_totalPage:int;
		private var currentDatas:Vector.<CellData>;
		
		public function RefinedRightClickHandle(panel:TabRefined)
		{
			_panel = panel;
			_skin = _panel.skin as McRefined;
			init();
		}
		
		public function destroy():void
		{
			currentDatas = null;
			if(_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK,onClick);
				_skin = null;
			}
			_panel = null;
		}
		
		private function init():void
		{
			_page = 1;
			_totalPage = 0;
			_type = ConstStorage.ST_CHR_EQUIP;
			_skin.addEventListener(MouseEvent.CLICK,onClick,false,1);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _skin.btnRoleEquip:
					setSelected(_skin.btnRoleEquip);
					dealRefresh(ConstStorage.ST_CHR_EQUIP);
					break;
				case _skin.btnHeroEquip:
					setSelected(_skin.btnHeroEquip);
					dealRefresh(ConstStorage.ST_HERO_EQUIP);
					break;
				case _skin.btnBagItem:
					setSelected(_skin.btnBagItem);
					dealRefresh(ConstStorage.ST_CHR_BAG);
					break;
				case _skin.btnPrev:
					dealPrev();
					break;
				case _skin.btnNext:
					dealNext();
					break;
			}
		}
		/**装备来源选中切换*/
		private function setSelected(mc:MovieClip):void
		{
			_skin.btnRoleEquip.selected = false;
			_skin.btnHeroEquip.selected = false;
			_skin.btnBagItem.selected = false;
			_skin.btnRoleEquip.txt.textColor = 0x675138;
			_skin.btnHeroEquip.txt.textColor = 0x675138;
			_skin.btnBagItem.txt.textColor = 0x675138;
			mc.selected = true;
			mc.txt.textColor = 0xffe1aa;
		}
		
		internal function dealRefresh(type:int = 0):void
		{
			type != 0 ? _type = type : 0;
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
			_panel.cellHandle.refreshData(currentDatas);
			_panel.viewHandle.update();
		}
		
		private function dealRoleEquip():void
		{
			var datas:Vector.<EquipData> = RoleDataManager.instance.getRefinedEquipDatas();
			refreshPageTxt(Vector.<CellData>(datas));
			currentDatas = Vector.<CellData>(datas.slice((_page-1)*_numPage,_page*_numPage > datas.length ? datas.length : _page*_numPage));
		}
		
		private function dealHeroEquip():void
		{
			var datas:Vector.<EquipData> = HeroDataManager.instance.getRefinedEquipDatas();
			refreshPageTxt(Vector.<CellData>(datas));
			currentDatas = Vector.<CellData>(datas.slice((_page-1)*_numPage,_page*_numPage > datas.length ? datas.length : _page*_numPage));
		}
		
		private function dealRoleBag():void
		{
			var datas:Vector.<BagData> = BagDataManager.instance.getRefinedEquipDatas();
			refreshPageTxt(Vector.<CellData>(datas));
			currentDatas = Vector.<CellData>(datas.slice((_page-1)*_numPage,_page*_numPage > datas.length ? datas.length : _page*_numPage));
		}
		
		private function refreshPageTxt(datas:Vector.<CellData>):void
		{
			_totalPage = (datas.length + _numPage - 1) / _numPage;
			if(_totalPage == 0)
			{
				_skin.txtPage.text = "";
			}
			else
			{
				_page = _page > _totalPage ? 1 : _page;
				_skin.txtPage.text = _page + "/" + _totalPage;
			}
		}
		
		private function dealPrev():void
		{
			if(_page > 1)
			{
				_page--;
				dealRefresh();
			}
		}
		
		private function dealNext():void
		{
			if(_page < _totalPage)
			{
				_page++;
				dealRefresh();
			}
		}
	}
}