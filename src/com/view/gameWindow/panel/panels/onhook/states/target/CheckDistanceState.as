package com.view.gameWindow.panel.panels.onhook.states.target
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.panel.panels.onhook.states.common.AuFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AutoFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.FightPlace;
	import com.view.gameWindow.panel.panels.onhook.states.common.WaitingState;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.Entity;
	import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
	import com.view.gameWindow.scene.entity.entityItem.interf.IMonster;
	import com.view.gameWindow.scene.entity.entityItem.interf.INpcStatic;
	import com.view.gameWindow.scene.map.SceneMapManager;
	
	
	/**
	 * @author wqhk
	 * 2014-10-6
	 */
	public class CheckDistanceState implements IState
	{
		private var _moving:IEntity;
		private var _span:int;
		private var _targetMapId:int;
		private var _targetTileX:int;
		private var _targetTileY:int;
		private var _targetId:int;
		private var _targetType:int;
		private var _targetIdPlus:int;
		
		public function CheckDistanceState(moving:IEntity,targetMapId:int,targetTileX:int,targetTileY:int,targetId:int,targetType:int,span:int = 1,targetIdPlus:int = 0)
		{
			_moving = moving;
			
			_span = span;
			
			_targetMapId = targetMapId;
			_targetTileX = targetTileX;
			_targetTileY = targetTileY;
			_targetId = targetId;
			_targetType = targetType;
			_targetIdPlus = targetIdPlus;
		}
		
		public function next(i:IIntention=null):IState
		{
			if(_targetMapId == SceneMapManager.getInstance().mapId)
			{
				//优化寻路打怪时 停下来攻击的时机
				//修改成 有目标怪时停止寻路，不跑到目标点直接进入自动攻击模式
				if(_targetType == EntityTypes.ET_MONSTER)
				{
					var list:Vector.<Entity> = EntityLayerManager.getInstance().inViewEntities;
					for each(var e:IEntity in list)
					{
						var m:IMonster = e as IMonster;
						if(!m)
						{
							continue;
						}
						
						var mst:MonsterCfgData = ConfigDataManager.instance.monsterCfgData(m.monsterId);
						var groupId:int = mst.group_id;
						
						if(groupId == _targetId && (!_targetIdPlus || _targetIdPlus==m.entityId) && AxFuncs.firstPlayer.tileDistance(m.tileX,m.tileY) < 6)
						{
							if(AutoFuncs.isAutoMap())
							{
								AutoFuncs.stopMap();
							}
							
							if(m.hp>0)
							{
								AutoFuncs.startAutoFight(FightPlace.FIGHT_PLACE_TASK);
								
								//dig
								if(mst.corpse_dig != 0)
								{
									AutoFuncs.toDig(groupId);
								}
								
								return new WaitingState();
							}
							else if(m.canDig)//dig
							{
								AutoFuncs.toDig(groupId);
								return new WaitingState();
							}
						}
					}
				}
				
				if(_moving.tileDistance(_targetTileX,_targetTileY) <= _span)
				{
					if(AutoFuncs.isAutoMap())
					{
						AutoFuncs.stopMap();
					}
					
					if(_targetType == EntityTypes.ET_NPC)
					{
						var sNpc:INpcStatic = EntityLayerManager.getInstance().getEntity(_targetType,_targetId) as INpcStatic;
						
						if(sNpc)
						{
							AuFuncs.openNpcPanle(sNpc);
						}
					}
					else if(_targetType == EntityTypes.ET_MONSTER)
					{
						AutoFuncs.startAutoFight(FightPlace.FIGHT_PLACE_TASK);//等于没用了
					}
					else if(_targetType == EntityTypes.ET_PLANT)
					{
						
					}
					
					return new WaitingState();
				}
				else
				{
					if(!AutoFuncs.isAutoMap())
					{
						AxFuncs.setTarget(_targetId,_targetType,_targetIdPlus);
					}
				}
			}
			
			return this;
		}
	}
}