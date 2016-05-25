package com.view.gameWindow.panel.panels.onhook.states.map
{
	import com.core.toArray;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapCfgData;
	import com.model.configData.cfgdata.MapRegionCfgData;
	import com.model.configData.cfgdata.MapTeleportCfgData;
	import com.model.consts.MapConst;
	import com.pattern.state.IState;
	import com.pattern.state.StateTimeMachine;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.WaitingState;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	
	/**
	 * 负责寻找传送点 传送并移动
	 * @author wqhk
	 * 2014-10-6
	 */
	public class AutoMap extends StateTimeMachine
	{
		public function AutoMap()
		{
			super();
			interval = 1000;
		}
		
		public function setDestination(curMapId:int,targetMapId:int,tileX:int,tileY:int,tpList:Array = null):void
		{
			trace("寻找传送点");
			var time:int = getTimer();
			
			var teleList:Array = tpList ? tpList : AxFuncs.getTpList(curMapId,targetMapId);//AutoMap.getTeleportList(curMapId,targetMapId);
			
			setDestinationEx(curMapId,targetMapId,tileX,tileY,teleList);
//			trace("花费时间:"+(getTimer() - time));
//			
//			
//			var state:IState;
//			if(teleList == null)
//			{
//				trace("无路径");
//				state = new WaitingState();
//			}
//			else
//			{
//				teleList.unshift([targetMapId,tileX,tileY]);
//				state = new CheckTeleportState(teleList,EntityLayerManager.getInstance().firstPlayer);
//			}
//			
//			
//			init(state);
			
			
			
		}
		
		/**
		 * @param tpList 传送点并不会验证正确性
		 */
		public function setDestinationEx(curMapId:int,targetMapId:int,tileX:int,tileY:int,tpList:Array):void
		{
			trace("寻找传送点");
			var time:int = getTimer();
			
			var teleList:Array = tpList;//AutoMap.getTeleportList(curMapId,targetMapId);
			var state:IState;
			if(teleList == null)
			{
				trace("无路径");
				state = new WaitingState();
			}
			else
			{
				teleList.unshift([targetMapId,tileX,tileY]);
				state = new CheckTeleportState(teleList,EntityLayerManager.getInstance().firstPlayer);
			}
			
			
			init(state);
			
			
			trace("花费时间:"+(getTimer() - time));
		}
		
		
		public static function getTeleportList(curMapId:int,targetMapId:int):Array
		{
			if(curMapId == targetMapId)
			{
				return [];
			}
			var configMgr:ConfigDataManager = ConfigDataManager.instance;
			var nodes:Array = [];
			var tmps:Array = [];
			toArray(configMgr.mapTeleporterCfgDatas(curMapId),nodes);
			nodes = AutoMap.toNodes(null,nodes);
			
			var isRuning:Boolean = true;
			var target:Node = null;
			var alreadyPassed:Array = [];//很重要，不然会陷入死循环. 过滤掉已经寻过的图
			
			while(!target)
			{
				if(nodes.length == 0)
				{
					return null;
				}
				for each(var node:Node in nodes)
				{
					alreadyPassed.push(node.data);
					var r:MapRegionCfgData = configMgr.mapRegionCfgData(node.data.region_to);
					
					if(!r)//过滤掉策划的错误数据
					{
						continue;
					}
					
					if(r.map_id == targetMapId)
					{
						target = node;
						break;
					}
					else
					{
						var nextTeleList:Array = [];
						
						var map:MapCfgData = configMgr.mapCfgData(r.map_id);
						
						toArray(configMgr.mapTeleporterCfgDatas(r.map_id),nextTeleList);
						
						var nextTeleNoPassedList:Array = [];
						for each(var next:MapTeleportCfgData in nextTeleList)
						{
							//过滤掉已经寻过的图
							if(alreadyPassed.indexOf(next) == -1)
							{
								nextTeleNoPassedList.push(next);
							}
						}
						
						nextTeleNoPassedList = AutoMap.toNodes(node,nextTeleNoPassedList);
						tmps = tmps.concat(nextTeleNoPassedList);
					}
				}
				
				nodes = tmps.concat();
				tmps = [];
			}
			
			var teleList:Array = [target.data];
			while(target.parent)
			{
				target = target.parent;
				teleList.push(target.data);
			}
			
			return teleList;
		}
		
		
		public static function toNodes(parent:Node,datas:Array):Array
		{
			var re:Array = [];
			for each(var data:* in datas)
			{
				var node:Node = new Node();
				node.data = data;
				node.parent = parent;
				re.push(node);
			}
			
			return re;
		}
	}
}

import com.model.configData.cfgdata.MapTeleportCfgData;

class Node
{
	public var parent:Node;
	public var data:MapTeleportCfgData;
}