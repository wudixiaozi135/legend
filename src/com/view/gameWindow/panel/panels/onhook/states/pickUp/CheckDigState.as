package com.view.gameWindow.panel.panels.onhook.states.pickUp
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.panel.panels.onhook.states.common.AsFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AutoFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.WaitingState;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.ActionTypes;
	import com.view.gameWindow.scene.entity.constants.Direction;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.scene.entity.entityItem.interf.IMonster;
	
	import flash.utils.getTimer;
	
	
	/**
	 * @author wqhk
	 * 2014-12-26
	 */
	public class CheckDigState implements IState
	{
		private static const CHECK_INVERVAL:int = 500;
		private var _mId:int;
		private var _curM:IMonster;
		private var _time:int;
		public function CheckDigState(monsterGroupId:int)
		{
			_mId = monsterGroupId;
			_time = 0;
		}
		
		public function next(i:IIntention=null):IState
		{
			if(_mId)
			{
				if(!_curM)
				{
					if(getTimer() - _time > CHECK_INVERVAL)
					{
						_time = getTimer();
						for each(var e:IEntity in EntityLayerManager.getInstance().inViewEntities)
						{
							var m:IMonster = e as IMonster;
							if(m && m.canDig)
							{
								if(m.mstCfgData && m.mstCfgData.group_id == _mId)
								{
									_curM = m;
									
									
									if(AutoFuncs.isAutoMove())
									{
										AutoFuncs.stopMove();
									}
									break;
								}
							}
						}
					}
				}
					
				if(_curM)
				{
					if(!_curM.canDig)
					{
						_curM = null;
						return this;							
					}
					
					if(EntityLayerManager.getInstance().inViewEntities.indexOf(_curM) == -1)
					{
						_curM = null;
						return this;
					}
					
					var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
					
					var dist:int = firstPlayer.tileDistance(_curM.tileX,_curM.tileY);
					
					if(AutoFuncs.isAutoFight())
					{
						AutoFuncs.stopAutoFight();
					}
					else if(AutoFuncs.isAutoAttack())
					{
						AutoFuncs.stopAttack();
					}
					
					if(dist <= 1)
					{
						if(AutoFuncs.isAutoMove())
						{
							AutoFuncs.stopMove();
						}
						
						firstPlayer.targetTileX = firstPlayer.tileX;
						firstPlayer.targetTileY = firstPlayer.tileY;
						if(dist == 0)
						{
							firstPlayer.direction = Direction.getDirectionByTile(firstPlayer.tileX, firstPlayer.tileY, _curM.tileX, _curM.tileY);
						}
						AsFuncs.sendMove(firstPlayer.tileX,firstPlayer.tileY,firstPlayer.targetTileX,firstPlayer.targetTileY);
						if(firstPlayer.currentAcionId != ActionTypes.MINING)
						{
							AxFuncs.selectEntity = _curM;
							EntityLayerManager.getInstance().requestBeginCorpseMonsterDig(_curM.entityId,_curM.mstDigCfgData);
						}
						return new DiggingState(_curM.entityId);
					}
					else
					{
						if(!AutoFuncs.isAutoMove())
						{
							AutoFuncs.move(firstPlayer, _curM.tileX, _curM.tileY, AutoJobManager.TO_MONSTER_DIG_TILE_DIST);
						}
					}
				}
					
				return this;
			}
			else
			{
				return new WaitingState();
			}
		}
	}
}