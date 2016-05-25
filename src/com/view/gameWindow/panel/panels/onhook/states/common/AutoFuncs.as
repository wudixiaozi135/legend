package com.view.gameWindow.panel.panels.onhook.states.common
{
	import com.model.configData.cfgdata.SkillCfgData;
	import com.view.gameWindow.panel.panels.onhook.AutoDataManager;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.onhook.states.EventNames;
	import com.view.gameWindow.panel.panels.onhook.states.StateEvent;
	import com.view.gameWindow.panel.panels.onhook.states.fight.StartAttackIntent;
	import com.view.gameWindow.panel.panels.onhook.states.move.ToPlaceIntent;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.skill.SkillDataManager;
	import com.view.gameWindow.panel.panels.skill.constants.SkillConstants;
	import com.view.gameWindow.scene.entity.constants.Direction;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.ILivingUnit;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
	import com.view.gameWindow.scene.skillDeal.SkillDealManager;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * auto
	 * @author wqhk
	 * 2014-9-29
	 */
	public class AutoFuncs
	{
		/**
		 * 开始战斗打怪
		 */
		public static function startAttack(isConsideRange:Boolean = true):void
		{
			StateEvent.dispatchMachine(EventNames.FIGHT,new StartAttackIntent(isConsideRange));
		}
		
		public static function startIndependentAttack(enityType:int,entityId:int):void
		{
			
		}
		
		/**
		 * 结束战斗打怪
		 */
		public static function stopAttack():void
		{
			StateEvent.dispatchMachine(EventNames.FIGHT,new StopIntent());
		}
		
		public static function toDig(monsterGroupId:int):void
		{
			AutoSystem.instance.toDig(monsterGroupId);
		}
		
		public static function toMine():void
		{
			AutoSystem.instance.toMine();
		}
		
		/**
		 * 开始战斗打怪加拾取物品
		 */
		public static function startAutoFight(place:int):void
		{
			AutoSystem.instance.startAutoFight(place);
		}
		
		public static function stopAutoFight(fightPlace:int=0, immediate:Boolean=true):void
		{
			AutoSystem.instance.stopAutoFight(fightPlace,immediate);
		}
		
		/**
		 * 同地图的移动 
		 * @param pkMode true时全跑动
		 */
		public static function move(entity:IPlayer, tileX:int, tileY:int, targetTileDist:int, pkMode:Boolean = false):void
		{
			var intent:ToPlaceIntent = new ToPlaceIntent();
			intent.destination = new Point(tileX,tileY);
			intent.targetTileDist = targetTileDist;
			intent.entity = entity;
			intent.pkMode = pkMode;
			StateEvent.dispatchMachine(EventNames.MOVE,intent);
		}
		
		/**
		 * 会寻找传送点传送的移动
		 */
		public static function moveMap(mapId:int,tileX:int,tileY:int):void
		{
			AutoSystem.instance.startAutoMap(mapId,tileX,tileY);
		}
		
		public static function movieMapEx(mapId:int,tileX:int,tileY:int,tpList:Array):void
		{
			AutoSystem.instance.startAutoMapEx(mapId,tileX,tileY,tpList);
		}
		
		
		/**
		 * 如果没有到targetPixel 还是会有位移的，就是说调用这个方法后，有可能还在移动中
		 */
		public static function stopMove():void
		{
			StateEvent.dispatchMachine(EventNames.MOVE,new StopIntent());
		}
		
		/**
		 * 停止 寻找传送点传送的移动
		 */
		public static function stopMap():void
		{
			//和上面的发事件(EventNames.MOVE,new StopIntent())来说更简洁些吧
			AutoSystem.instance.stopAutoMap();
		}
		
		public static function stopAuto():void
		{
			AutoSystem.instance.stopAuto();
		}
		
		/**
		 * 判断是否正在移动中
		 */
		public static function isAutoMove():Boolean
		{
			return AutoSystem.instance.isAutoMove();
		}
		
		/**
		 * 包括自动杀怪和自动拾取
		 */
		public static function isAutoFight():Boolean
		{
			return AutoSystem.instance.isAutoFight();
		}
		
		/**
		 * 是否自动打怪
		 */
		public static function isAutoAttack():Boolean
		{
			return AutoSystem.instance.isAutoAttack();
		}
		
		public static function isAutoMap():Boolean
		{
			return AutoSystem.instance.isAutoMap();
		}
		
		/**
		 *  定点 
		 */
		public static function isAnchorRange():Boolean
		{
			return AutoDataManager.instance.isAnchorRange;
		}
	}
}