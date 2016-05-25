package com.view.gameWindow.util.cell
{
	import com.model.consts.ConstStorage;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
	
	import flash.utils.Dictionary;
	
	/**
	 * 单元格数据管理类
	 * @author Administrator
	 */	
	public class CellDataManager extends DataManagerBase
	{
		public static const CHR_BAG_NUM:int = 63;
		public static const CHR_STORE_NUM:int = 50;
		public static const HERO_BAG_NUM:int = 30;
		
		private static var _instance:CellDataManager;
		public static function get instance():CellDataManager
		{
			return _instance ||= new CellDataManager(new PrivateClass());
		}
		
		public function clearInstance():void
		{
			_instance = null;
		}
		
		private var _cellDatas:Dictionary;
		private var _chrEquip:Vector.<CellData>;
		private var _chrBag:Vector.<CellData>;
		private var _chrStore:Vector.<CellData>;
		private var _heroEquip:Vector.<CellData>;
		private var _heroBag:Vector.<CellData>;
		
		public function CellDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			_cellDatas = new Dictionary();
			_chrEquip = new Vector.<CellData>(ConstEquipCell.CP_TOTAL,true);
			_chrBag = new Vector.<CellData>(CHR_BAG_NUM,true);
			_chrStore = new Vector.<CellData>(CHR_STORE_NUM,true);
			_heroEquip = new Vector.<CellData>(ConstEquipCell.HP_TOTAL,true);
			_heroBag = new Vector.<CellData>(HERO_BAG_NUM,true);
			//
			_cellDatas[ConstStorage.ST_CHR_EQUIP] = _chrEquip;
			_cellDatas[ConstStorage.ST_CHR_BAG] = _chrBag;
			_cellDatas[ConstStorage.ST_CHR_STORE] = _chrStore;
			_cellDatas[ConstStorage.ST_HERO_EQUIP] = _heroEquip;
			_cellDatas[ConstStorage.ST_HERO_BAG] = _heroBag;
		}
		
		public function getCellDatas(storage:int):Vector.<CellData>
		{
			return _cellDatas[storage];
		}
		
		public function getCellData(storage:int,slot:int):CellData
		{
			return _cellDatas[storage][slot];
		}
	}
}
class PrivateClass{}