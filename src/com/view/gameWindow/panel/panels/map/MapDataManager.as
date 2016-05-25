package com.view.gameWindow.panel.panels.map
{
	import com.core.toArray;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapCfgData;
	import com.model.configData.cfgdata.MapRegionCfgData;
	import com.model.consts.MapPKMode;
	import com.model.consts.MapRegionType;
	import com.pattern.Observer.Observe;
	import com.view.gameWindow.common.ModelEvents;
	
	import flash.utils.Dictionary;
	
	
	/**
	 * 界面用
	 * @author wqhk
	 * 2014-9-19
	 */
	public class MapDataManager extends Observe
	{
		private static var _instance:MapDataManager;
		
		public static function get instance():MapDataManager
		{
			if(!_instance)
			{
				_instance = new MapDataManager();
			}
			
			return _instance;
		}
		public function MapDataManager()
		{
			super();
		}
		
		private var _mapId:int;
		private var _tileX:int;
		private var _tileY:int;
		private var _mapCfg:MapCfgData;
		private var _regionList:Vector.<MapRegionCfgData>;
		private var _lastRegionType:int = -1;
		
		public function initMap(mapId:int):void
		{
			if(_mapId != mapId)
			{
				_tileX = -1;
				_tileY = -1;
				_mapId = mapId;
				_mapCfg = ConfigDataManager.instance.mapCfgData(_mapId);
				var dict:Dictionary = ConfigDataManager.instance.mapRegionCfgDatasByMap(mapId);
				_regionList = new Vector.<MapRegionCfgData>();
				toArray(dict,_regionList,filterPeaceRegion);
			}
		}
		
		private function filterPeaceRegion(item:MapRegionCfgData):Boolean
		{
			return item.type == MapRegionType.PEACE;
		}
		
		public function get regionType():int
		{
			return _lastRegionType;
		}
		
		public function updateRegionRype(tileX:int,tileY:int):void
		{
			if(_tileX == tileX && _tileY == tileY)
			{
				return;
			}
			
			_tileX = tileX;
			_tileY = tileY;
			
			var type:int = getRegionType(tileX,tileY);
			
			if(type == -1)
			{
				type = _mapCfg.pk_mode == MapPKMode.PEACE ? MapRegionType.PEACE : MapRegionType.FIGHT;
			}
			
			if(_lastRegionType != type)
			{
				_lastRegionType = type;
				
				if(type == MapRegionType.FIGHT)
				{
					notify(ModelEvents.UPDATE_REGION_TYPE_NOTICE);
				}
				else
				{
					if(!_mapCfg || _mapCfg.pk_mode != MapPKMode.PEACE )
					{
						notify(ModelEvents.UPDATE_REGION_TYPE_NOTICE);
					}
				}
				
				notify(ModelEvents.UPDATE_REGION_TYPE);
			}
			
			notify(ModelEvents.UPDATE_ACTIV_INFO_BY_POSTION);
		}
		/**
		 * 每次检测是否性能有问题?
		 */
		public function getRegionType(x:int,y:int):int
		{
			for(var i:int = 0;i < _regionList.length; ++i)
			{
				if(_regionList[i].type == MapRegionType.PEACE)
				{
					var region:MapRegionCfgData = _regionList[i];
					var isIn:Boolean = region.isIn(x,y);
					if(isIn)
					{
						return MapRegionType.PEACE;
					}
				}
			}
			return -1;
		}
	}
}