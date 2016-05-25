package com.view.gameWindow.panel.panels.trans
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapCfgData;
	import com.model.configData.cfgdata.NpcTeleportCfgData;
	import com.model.consts.StringConst;
	
	import flash.text.TextField;

	/**
	 * 传送面板数据类
	 * @author Administrator
	 */	
	public class PanelTransData
	{
		public static var npcId:int;
		public static var npcTeleportId:int;
		public static var name:String;
		public static var normal_monster_drop:String;
		public static var elite_monster_drop:String;
		public static var boss_drop:String;
		public static var coin:String;
		public static var desc:String;
		
		public static var vip:int;
		public static var gold_bind:int;
		
		public static var normal_monster:Vector.<TextField>;
		public static var elite_monster:Vector.<TextField>;
		public static var normal_color:Vector.<uint>;
		public static var elite_color:Vector.<uint>;
		
		
		public static function getCoin(data:NpcTeleportCfgData):String
		{
			if(data.coin != 0)
			{
				return String(data.coin) + StringConst.TRANS_PANEL_0008;
			}
			if(data.unbind_coin != 0)
			{
				return String(data.unbind_coin) + StringConst.TRANS_PANEL_0008;
			}
			if(data.bind_gold != 0)
			{
				return String(data.bind_gold) + StringConst.TRANS_PANEL_0019;
			}
			if(data.unbind_gold != 0)
			{
				return String(data.unbind_gold) + StringConst.TRANS_PANEL_0010;
			}
			return "";
		}
		
		public static function getMapCfgData(npcId:int,id:int):MapCfgData
		{
			var region_to:int;
			var mapIds:int;
			var mapCfgData:MapCfgData;
			region_to = ConfigDataManager.instance.npcTeleportCfgData(id).region_to;
			mapIds = ConfigDataManager.instance.mapRegionCfgData(region_to).map_id;
			mapCfgData = ConfigDataManager.instance.mapCfgData(mapIds);
			return mapCfgData;
		}
		
		public function PanelTransData()
		{
		}
	}
}