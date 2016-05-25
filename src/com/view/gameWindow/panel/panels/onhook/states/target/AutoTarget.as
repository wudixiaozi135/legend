package com.view.gameWindow.panel.panels.onhook.states.target
{
	import com.core.getDictElement;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapMonsterCfgData;
	import com.model.configData.cfgdata.MapPlantCfgData;
	import com.model.configData.cfgdata.MapRegionCfgData;
	import com.model.configData.cfgdata.MapTeleportCfgData;
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.pattern.state.IState;
	import com.pattern.state.StateMachine;
	import com.pattern.state.StateTimeMachine;
	import com.view.gameWindow.panel.panels.onhook.states.common.AutoFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.WaitingState;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.scene.entity.entityItem.interf.INpcStatic;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	
	/**
	 * 负责 跑到npc或怪物，然后执行相应的操作  
	 * @author wqhk
	 * 2014-10-6
	 */
	public class AutoTarget extends StateMachine
	{
		/**
		 * 负责 跑到npc或怪物，然后执行相应的操作  
		 */
		public function AutoTarget()
		{
			super();
		}
		
		private var _targetId:int;

		public function get targetId():int
		{
			return _targetId;
		}

		private var _targetType:int;

		public function get targetType():int
		{
			return _targetType;
		}

		private var _plusId:int;

		public function get plusId():int
		{
			return _plusId;
		}
		
		private var _monsterTarget:MapMonsterCfgData;

		public function get monsterTarget():MapMonsterCfgData
		{
			return _monsterTarget;
		}
		
		public function setTarget(targetId:int,type:int,plusId:int):void
		{
			_targetId = targetId;
			_targetType = type;
			_plusId = plusId;
			
			AutoFuncs.stopAutoFight();
			var state:IState = new WaitingState();
			var nearPos:Point = null;
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			
			if(type == EntityTypes.ET_MINE)
			{
				var mapRegionCfgData:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(targetId);
				if(mapRegionCfgData)
				{
//					nearPos = mapRegionCfgData.randomPoint;
					nearPos = mapRegionCfgData.centerPoint;
					AutoFuncs.moveMap(mapRegionCfgData.map_id,nearPos.x,nearPos.y);
					AutoFuncs.toMine();
					state = new WaitingState();
				}
			}
			else if(type == EntityTypes.ET_NPC) //废
			{
				var npcCfg:NpcCfgData = ConfigDataManager.instance.npcCfgData(targetId);
				
				if(npcCfg)
				{
					nearPos = new Point(npcCfg.x,npcCfg.y);
					AutoFuncs.moveMap(npcCfg.mapid,nearPos.x,nearPos.y);
					
					state = new CheckDistanceState(firstPlayer,npcCfg.mapid,nearPos.x,nearPos.y,targetId,type);
				}
			}
			else if(type == EntityTypes.ET_MONSTER)
			{
				var monster:MapMonsterCfgData;
				
				var tpList:Array = null;
				
				if(plusId!=0)
				{
					monster = ConfigDataManager.instance.mapMstCfgData(plusId);
				}
				else
				{
					var ms:Dictionary = ConfigDataManager.instance.mapMstCfgDatas(targetId);
					
					var curMapMonsterList:Array = [];
					var otherMapMonsterList:Array = [];
					var curMapId:int = AxFuncs.getCurMapId();
					var otherMonster:MapMonsterCfgData = null;
					
					for each(var m:MapMonsterCfgData in ms)
					{
						if(m.map_id == curMapId)
						{
							curMapMonsterList.push(m);
						}
						else
						{
							if(!otherMonster || otherMonster.map_id == m.map_id)//只挑选同一张地图的怪
							{
								otherMapMonsterList.push(m);
							}
						}
					}
					
					if(curMapMonsterList.length == 0 && otherMapMonsterList.length > 0)
					{
						monster = otherMapMonsterList[0];//不同地图的 这里随便选了一个
						tpList = AxFuncs.getTpList(AxFuncs.getCurMapId(),monster.map_id);
						var tmpList:Array = tpList;
						tpList = null;
						if(tmpList && tmpList.length > 0)
						{
							var tpData:MapTeleportCfgData = tmpList[0];
							if(tpData)
							{
								var rg:MapRegionCfgData = tpData.mapRegionCfgData;
								if(rg)
								{
									//rg.x_min,rg.y_min 传送点 不会不可行走， 而且一般是同一个点
									monster = AxFuncs.findNearestMapMonster(rg.x_min,rg.y_min,otherMapMonsterList);
									tpList = tmpList;
								}
							}
						}
					}
					else if(curMapMonsterList.length > 0)
					{
						monster = AxFuncs.findNearestMapMonster(firstPlayer.tileX,firstPlayer.tileY,curMapMonsterList);
					}
				}
				
				_monsterTarget = monster;
				
				if(monster)
				{
					nearPos = new Point(monster.x,monster.y);//AxFuncs.getCanMoveLct(monster.x,monster.y);
					
					if(nearPos)
					{
						if(tpList)
						{
							AutoFuncs.movieMapEx(monster.map_id,nearPos.x,nearPos.y,tpList);//这样做只是为了省去 再找一遍传送点
						}
						else
						{
							AutoFuncs.moveMap(monster.map_id,nearPos.x,nearPos.y);
						}
					
						state = new CheckDistanceState(firstPlayer,monster.map_id,nearPos.x,nearPos.y,targetId,type,
										/*Math.max(monster.h_radius,monster.v_radius)*/1,plusId);
					}
					else
					{
						trace("目标点不可通过");
					}
				}
			}
			else if(type == EntityTypes.ET_PLANT)//废
			{
				var plant:MapPlantCfgData = getDictElement(ConfigDataManager.instance.mapPlantCfgDatas(targetId));
				
				if(plant)
				{
					AutoFuncs.moveMap(plant.map_id,plant.x,plant.y);
					state = new CheckDistanceState(	firstPlayer,
													plant.map_id,
													plant.x,
													plant.y,
													targetId,type,
													Math.max(plant.h_radius,plant.v_radius));
				}
			}
			
			init(state);
		}
	}
}