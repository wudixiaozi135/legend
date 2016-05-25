package com.view.gameWindow.panel.panels.onhook.states.fight
{
	import com.core.toArray;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapMonsterCfgData;
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.panel.panels.onhook.AutoDataManager;
	import com.view.gameWindow.panel.panels.onhook.states.common.AutoFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IMonster;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
	
	import flash.utils.getTimer;
	
	
	/**
	 * @author wqhk
	 * 2014-9-27
	 */
	public class SelectEnemyState implements IState
	{
		public var isConsideRange:Boolean = true;
		private var _target:IMonster;
		
		public function SelectEnemyState(isConsideRange:Boolean = true)
		{
			this.isConsideRange = isConsideRange;
			trace("进入怪物选择状态");
//			selectTarget();
		}
		
		public function get target():IMonster
		{
			return _target;
		}
		
		private var mapMstList:Array;
		
		private function selectTarget():void
		{
//			_target = AutoJobManager.getInstance().selectEntity as IMonster;
//			
//			if(!AxFuncs.monsterFilter(_target))
//			{
				if(AutoJobManager.getInstance().selectEntity && AxFuncs.isFixedTarget(AutoJobManager.getInstance().selectEntity))
				{
					_target = AutoJobManager.getInstance().selectEntity as IMonster;
					
					if(!AxFuncs.monsterFilter(_target))
					{
						_target = null;
					}
				}
				
				var self:IPlayer = EntityLayerManager.getInstance().firstPlayer;
				
				var time:int = getTimer();
				
				//增加boss的判断。现在只分析恶魔广场的数据。
				var isBossPriority:Boolean = AxFuncs.isBossPriority();/* && AxFuncs.isBossAttack() 按boss要求改成手动挂机也需要先寻找boss……*/;
				var bossList:Array = isBossPriority ? AxFuncs.getMapBossList() : null;
				var mapMonster:MapMonsterCfgData;
				if(!bossList)
				{
					if(!_target)
					{
						//优先选择任务中的怪
						_target = AxFuncs.findNearestLivingUnit(self,EntityLayerManager.getInstance().monsterDic,AxFuncs.taskMonsterFilter) as IMonster;
					}
					
					//如果没有任务怪选最近的怪
					if(!_target)
					{
						_target = AxFuncs.findNearestLivingUnit(self,EntityLayerManager.getInstance().monsterDic,AxFuncs.monsterFilter) as IMonster;
					}
					
					// 如果当前屏幕中没有怪，如果挂机范围是全地图，需要另外寻找怪
					if(!_target && (isConsideRange && AutoDataManager.instance.isFullMapRange) && !AutoFuncs.isAutoMove())
					{
						trace("当前屏没有目标");
						if(!mapMstList)
						{
							mapMstList = [];
							toArray(ConfigDataManager.instance.mapMstCfgDataByMap(AxFuncs.getCurMapId()),mapMstList);
						}
						
						if(mapMstList && mapMstList.length > 0)
						{
							mapMonster = AxFuncs.findNearestMapMonster(self.tileX,self.tileY,mapMstList);
							AxFuncs.moveToMapMonster(mapMonster);
							
							//之所以要删除是因为 有的怪可能没刷出来（如boss）如果不从列表中删除 下次还是找到这只怪
							var index:int = mapMstList.indexOf(mapMonster);
							mapMstList.splice(index,1);
						}
					}
				}
				else
				{
					if(!_target)
					{
						//选择BOSS
						_target = AxFuncs.findNearestLivingUnit(self,EntityLayerManager.getInstance().monsterDic,AxFuncs.bossMonsterFilter) as IMonster;
					}
					
					if(!_target && !AutoFuncs.isAutoMove())
					{
						mapMonster = AxFuncs.findNearestMapMonster(self.tileX,self.tileY,bossList);
						AxFuncs.moveToMapMonster(mapMonster);
					}
				}
				
				time = getTimer()-time;
				
				if(_target)
				{
					trace(time+"选择战斗目标："+(_target?_target.entityId:"无目标"));
				}
				
				AutoJobManager.getInstance().selectEntity = _target;
//			}
		}
		
		public function next(i:IIntention=null):IState
		{
			if(i)
			{
				return i.check(this);
			}
			else if(AxFuncs.monsterFilter(_target))
			{
				if(AutoFuncs.isAutoMove())
				{
					AutoFuncs.stopMove();
				}
				var attackState:IState = new AttackState(EntityLayerManager.getInstance().firstPlayer,_target,AxFuncs.monsterFilter,this);
				_target = null;
				return attackState;
			}
			else
			{
				selectTarget();
				return this;
			}
		}
	}
}