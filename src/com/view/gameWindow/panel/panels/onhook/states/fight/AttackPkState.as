package com.view.gameWindow.panel.panels.onhook.states.fight
{
	import com.model.configData.cfgdata.SkillCfgData;
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarDataManager;
	import com.view.gameWindow.panel.panels.buff.BuffData;
	import com.view.gameWindow.panel.panels.buff.BuffDataManager;
	import com.view.gameWindow.panel.panels.onhook.states.common.AutoFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.skill.constants.SkillConstants;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.ILivingUnit;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
	
	import flash.geom.Point;
	
	
	/**
	 * @author wqhk
	 * 2014-12-30
	 */
	public class AttackPkState implements IState
	{
		public var target:ILivingUnit;
		public var attacker:IPlayer;
		public var checkTargetFunc:Function;
		public var preState:IState;
		
		public function AttackPkState(attacker:IPlayer,target:ILivingUnit,checkTargetFunc:Function,preState:IState)
		{	
			trace("进入PK攻击状态");
			this.target = target;
			this.attacker = attacker;
			this.checkTargetFunc = checkTargetFunc;
			this.preState = preState;
		}
		
		public function next(i:IIntention=null):IState
		{
			if(i)
			{
				return i.check(this);
			}
			
			if(target)
			{
				target = AxFuncs.getEntity(target.entityType,target.entityId) as ILivingUnit;
			}
			
			attacker = AxFuncs.firstPlayer;
			
			//			if(!AxFuncs.monsterFilter(target))
			//			{
			//				return new SelectEnemyState();
			//			}
			if(!checkTargetFunc(target))
			{
				if(AutoFuncs.isAutoMove())//当没目标时停止
				{
					AutoFuncs.stopMove();
				}
				return preState;
			}
			else
			{
				var skill:SkillCfgData = ActionBarDataManager.instance.clickSkillCfgDt;
				if(!skill)
				{
					var buff:BuffData = AxFuncs.selectTriggerSkillBuff();
					skill = buff ? AxFuncs.getSkillCfg(buff.specialTriggerSkill) : null;
					var isTriggerSkill:Boolean = true;
				}
				if(!skill)
				{
					skill = AxFuncs.selectSkill(attacker,target,
						AxFuncs.getSkillFight(attacker.job),
						AxFuncs.getSkillAuto(attacker.job),
						AxFuncs.getSkillDefault(attacker.job));
					isTriggerSkill = false;
				}
				
				if(skill)
				{
					var clickSkillGroupId:int = ActionBarDataManager.instance.clickSkillGroupId;
					if(clickSkillGroupId)
					{
						if(skill.center == SkillConstants.CENTER_MOUSE)//作用在自己身上
						{
							AutoJobManager.getInstance().useSkillDeal(null,skill.group_id,0,false);
						}
						else
						{
							AutoJobManager.getInstance().useSkillDeal(target,skill.group_id,0,false);
						}
						return this;
					}
					
					if(skill.beneficial == SkillConstants.BENEFICIAL_TRUE)//特别为神圣幽灵术处理，在该处不使用神圣幽灵术
					{
						return this;
					}
					
					var dist:int = attacker.tileDistance(target.tileX,target.tileY);
					
//					trace("距攻击目标的距离:"+dist);
					
					if((SkillConstants.RANGE_LINE != skill.range || AxFuncs.isInLine(attacker.tileX,attacker.tileY,target.tileX,target.tileY)) //简单判断但不移动修正，如果是直线技能需要在一条直线上
						&& skill.dist >= dist)
					{
						if(dist == 0)
						{
							if(!AutoFuncs.isAutoMove())
							{
								var pos:Point = AxFuncs.getNearCanMoveLct(attacker.tileX,attacker.tileY);
								move(attacker,pos.x,pos.y);
							}
						}
						else
						{
							AutoFuncs.stopMove();
							//为了快速出技能 去掉AxFuncs.isAtPixel的判断
							if(AxFuncs.isAtPixel(attacker) && !AxFuncs.isRigor())
							{
								AxFuncs.attack(attacker,target,skill,isTriggerSkill);
								if(isTriggerSkill)
								{
									BuffDataManager.instance.deleteBuffForce(attacker.entityType,attacker.entityId,buff.id);
								}
							}
						}
					}
					else
					{
//						if(AutoFuncs.isAutoMove())
//						{
//							if(!isFirst)
//							{
//								if(AxFuncs.isAtPixel(attacker) && isNeedFixed(attacker.tileX,attacker.tileY,lastX,lastY,target.tileX,target.tileY))
//								{
//									trace("停止移动");
//									AutoFuncs.stopMove();
//								}
//							}
//						}
//						else/*if(!AutoFuncs.isAutoMove() && !AutoDataManager.instance.isAnchorRange)*/
//						{
							if(isTargetPosChanged(target.tileX,target.tileY))
							{
								AutoFuncs.stopMove();
								if(AxFuncs.isAtPixel(attacker))
								{
									move(attacker,target.tileX,target.tileY);
								}
							}
								
//						}
						
//						AxFuncs.directMove(target.pixelX,target.pixelY);
					}
				}
				
				return this;
			}
		}
		
		private function isTargetPosChanged(x:int,y:int):Boolean
		{
			if(lastX != x || lastY != y)
			{
				return true;
			}
			
			return false;
		}
		
		private function isNeedFixed(x0:int,y0:int,x1:int,y1:int,x2:int,y2:int):Boolean
		{
			var ax:int = x1 - x0;
			var ay:int = y1 - y0;
			
			var bx:int = x2 - x1;
			var by:int = y2 - y1;
			
			
			var value:Number = (ax*bx + bx*by)/(Math.sqrt(ax*ax + ay*ay)*Math.sqrt(bx*bx + by*by));
			
			if(value < 0.707)//大于30度
			{
				return true;
			}
			else
			{
				var dis0:int = Math.max(Math.abs(ax),Math.abs(ay));
				var dis1:int = Math.max(Math.abs(bx),Math.abs(by));
				
				if(dis0<3 && dis1>1)
				{
					return true;
				}
				
				return false;
			}
		}
		
		private function get isFirst():Boolean
		{
			return lastX == -1 || lastY == -1;
		}
		
		private var lastX:int = -1;
		private var lastY:int = -1;
		private function move(entity:IPlayer,tileX:int,tileY:int):void
		{
			if(lastX == tileX && lastY == tileY)
			{
				return;
			}
			lastX = tileX;
			lastY = tileY;
			
			trace("移动");
			AutoFuncs.move(entity, tileX, tileY, AutoJobManager.TO_PLAYER_TILE_DIST, true);
		}
		
		private function directMove(x:int,y:int):void
		{
			if(AxFuncs.isAtPixel(attacker))
			{
				AxFuncs.directMove(x,y);
			}
		}
	}
}