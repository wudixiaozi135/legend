package com.view.gameWindow.panel.panels.closet
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;

	/**
	 * 衣柜数据类
	 * @author Administrator
	 */	
	public class ClosetData
	{
		public function get frame():int
		{
			var frame:int;
			switch(type)
			{
				case ConstEquipCell.TYPE_SHIZHUANG:
					frame = 2;
					break;
				case ConstEquipCell.TYPE_DOULI:
					frame = 4;
					break;
				case ConstEquipCell.TYPE_ZUJI:
					frame = 5;
					break;
				case ConstEquipCell.TYPE_HUANWU:
					frame = 1;
					break;
				default:
					frame = 1;
					break;
			}
			return frame;
		}
		
		public function get textPutInBtn():String
		{
			var text:String;
			switch(type)
			{
				case ConstEquipCell.TYPE_SHIZHUANG:
					text = StringConst.CLOSET_PANEL_PUTIN_0001;
					break;
				case ConstEquipCell.TYPE_DOULI:
					text = StringConst.CLOSET_PANEL_PUTIN_0002;
					break;
				case ConstEquipCell.TYPE_ZUJI:
					text = StringConst.CLOSET_PANEL_PUTIN_0003;
					break;
				case ConstEquipCell.TYPE_HUANWU:
					text = StringConst.CLOSET_PANEL_PUTIN_0004;
					break;
				default:
					text = StringConst.CLOSET_PANEL_PUTIN_0001;
					break;
			}
			return text;
		}

		public var type:int;
		public var level:int;
		public var gorgeousLevel:int;
		public var fashionId:int;
		public var fashionIds:Vector.<int>;

		private var _indexOf:int;
		
		public function ClosetData()
		{
			fashionIds = new Vector.<int>();
		}
		
		public function sortOn(fashionId1:int,fashionId2:int):Number
		{
			var cfgDt:EquipCfgData = ConfigDataManager.instance.equipCfgData(fashionId1);
			var power1:Number = CfgDataParse.getFightPower(cfgDt.attr);
			cfgDt = ConfigDataManager.instance.equipCfgData(fashionId2);
			var power2:Number = CfgDataParse.getFightPower(cfgDt.attr);
			return power1 - power2;
		}
		
		public function selectFashionName(select:int):String
		{
			var id:int = fashionIds[select];
			var cfgDt:EquipCfgData = ConfigDataManager.instance.equipCfgData(id);
			return cfgDt ? cfgDt.name : "";
		}
		/**穿着的时装，若无则为0*/
		public function weared():int
		{
			_indexOf = fashionIds.indexOf(fashionId);
			return _indexOf == -1 ? 0 : _indexOf;
		}
		/**选中的*/
		public function selected(fashionId:int):int
		{
			_indexOf = fashionIds.indexOf(fashionId);
			return _indexOf == -1 ? 0 : _indexOf;
		}
		
		public function set indexOf(value:int):void
		{
			_indexOf = value;
		}
		
		public function equipCfgData():EquipCfgData
		{
			var selected:int = _indexOf == -1 ? 0 : _indexOf;
			var id:int = selected < fashionIds.length ? fashionIds[selected] : 0;
			var equipCfgData:EquipCfgData = id ? ConfigDataManager.instance.equipCfgData(id) : null;
			return equipCfgData;
		}
		
		public function equipCfgId():int
		{
			var selected:int = _indexOf == -1 ? 0 : _indexOf;
			return selected < fashionIds.length ? fashionIds[selected] : 0;
		}
	}
}