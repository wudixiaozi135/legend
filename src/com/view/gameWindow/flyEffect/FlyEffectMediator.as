package com.view.gameWindow.flyEffect
{
	import com.model.configData.cfgdata.SkillCfgData;
	import com.view.gameWindow.flyEffect.subs.EquipRecycleExpEffect;
	import com.view.gameWindow.flyEffect.subs.ExpStoneEffect;
	import com.view.gameWindow.flyEffect.subs.FlyEffectDgnExchange;
	import com.view.gameWindow.flyEffect.subs.FlyEffectHeroSkillNew;
	import com.view.gameWindow.flyEffect.subs.FlyEffectReceiveThing;
	import com.view.gameWindow.flyEffect.subs.FlyEffectSkillNew;
	import com.view.gameWindow.flyEffect.subs.FlyEffectSpeciaToTask;
	import com.view.gameWindow.flyEffect.subs.FlyEffectSpecialRing;
	import com.view.gameWindow.flyEffect.subs.FlyEffectToExp;
	import com.view.gameWindow.flyEffect.subs.FlyFireDragonEnergyEffect;
	import com.view.gameWindow.flyEffect.subs.FlyKeepGameReceiveThing;
	import com.view.gameWindow.flyEffect.subs.FlySpecialEffect;
	import com.view.gameWindow.flyEffect.subs.HeroSkillEffectHandler;
	import com.view.gameWindow.mainUi.subuis.onlineReward.FlyOnlineShieldEffect;
	import com.view.gameWindow.panel.panels.chests.ChestsEffectHandler;
	import com.view.gameWindow.panel.panels.equipRecycle.EquipRecycleEffectHandler;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * 飞行特效介质类
	 * @author Administrator
	 */
	public class FlyEffectMediator
	{
		private static var _instance:FlyEffectMediator;
		public static function get instance():FlyEffectMediator
		{
			if (!_instance)
				_instance = new FlyEffectMediator(new PrivateClass());
			return _instance;
		}
		
		public var isDoFiy:Boolean = false;   //是否有动画在飞行
		private var _layer:Sprite;

		private var equipRecycleEffectHandler:EquipRecycleEffectHandler;
		public function get layer():Sprite
		{
			return _layer;
		}
		
		public function FlyEffectMediator(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error("该类使用单例模式");
			}
		}
		
		public function initData(layer:Sprite):void
		{
			_layer = layer;
		}
		/**执行获得特戒飞行特效*/
		public function doFlySpecialRing():void
		{
			var flyEffectSpecialRing:FlyEffectSpecialRing = new FlyEffectSpecialRing(_layer);
			flyEffectSpecialRing.fly();
		}
		/**执行获得新技能飞行特效*/
		public function doFlySkillNew(panelIndex:int):void
		{
			var flyEffectSkillNew:FlyEffectSkillNew = new FlyEffectSkillNew(_layer, panelIndex);
			flyEffectSkillNew.fly();
		}
		
		public function doFlyHeroSkillNew(cfg:SkillCfgData):void
		{
			if (EntityLayerManager.getInstance().myHero)
			{
				HeroSkillEffectHandler.instance.addEffect(new FlyEffectHeroSkillNew(_layer, cfg));
			}
		}
		/**执行获得物品飞行特效*/
		public function doFlyReceiveThing(...args):void
		{
			var flyEffectReceiveThing:FlyEffectReceiveThing = new FlyEffectReceiveThing(_layer, args);
			flyEffectReceiveThing.fly();
		}
		
		/**执行获得多个物品飞行特效*/
		public function doFlyReceiveThings(...args):void
		{
			if (args.length == 3)
			{
				var num:int = args[2];
				var str:String = '';
				var panelIndex:int;
				var flyEffectReceiveThing:FlyEffectReceiveThing;
				var duration:Number = 1;
				for (var index:int = 0; index < num; index++)
				{
					str = args[0];
					panelIndex = args[1];
					duration = duration + /*Math.random()**/0.2;
					flyEffectReceiveThing = new FlyEffectReceiveThing(_layer, [str, panelIndex, index, duration]);
					flyEffectReceiveThing.fly();
				}
			}
		}
		/**执行获得多个物品飞行特效*/
		public function doFlyReceiveThings2(data:Array):void
		{
			var len:int = data.length;
			var flyEffectReceiveThing:FlyEffectReceiveThing;
			var duration:Number = 1;
			for (var index:int = 0; index < len; index++)
			{
				duration = duration + /*Math.random()**/0.2;
				flyEffectReceiveThing = new FlyEffectReceiveThing(_layer, [data[index], duration]);
				flyEffectReceiveThing.fly();
			}
		}
		
		public function doFlyItemsIntoBag(data:Array):void
		{
			var len:int = data.length;
			var flyEffectReceiveThing:FlyEffectReceiveThing;
			var duration:Number = .3;
			for (var index:int = 0; index < len; index++)
			{
				duration = duration + .23;
				if (duration > 3)
				{
					duration = 2;
				}
				if (data[index] && data[index].bitmapData)
				{
					flyEffectReceiveThing = new FlyEffectReceiveThing(_layer, [data[index], duration]);
					flyEffectReceiveThing.fly();
				}
			}
		}
		/**执行获得多个物品飞行特效*/
		public function doFlyReceiveThings3(data:Array):void
		{
			var len:int = data.length;
			var flyEffectReceiveThing:FlyEffectReceiveThing;
			var duration:Number = 1;
			for (var index:int = 0; index < len; index++)
			{
				duration = duration + /*Math.random()**/0.2;
				flyEffectReceiveThing = new FlyEffectReceiveThing(_layer, [data[index], duration, true]);
				flyEffectReceiveThing.fly();
			}
		}
		/**执行小飞鞋图标飞行特效*/
		public function doFlySpeciaToTask(fPoint:Point):void
		{
			var flySpeciaToTask:FlyEffectSpeciaToTask = new FlyEffectSpeciaToTask(_layer);
			flySpeciaToTask.setFpointAndFly(fPoint);
		}
		
		public function doFlyTicket(point:Point, endPoint:Point):void
		{
			var fly:FlyKeepGameReceiveThing = new FlyKeepGameReceiveThing(_layer);
			fly.setStartPoint(point, endPoint);
		}
		
		public function doFlyExp(point:Point, endPoint:Point, complete:Function = null):void
		{
			var fly:FlyEffectToExp = new FlyEffectToExp(_layer,complete);
			fly.setStartPoint(point, endPoint);
		}
		
		public function doEquipRecycleEffect(isExp:Boolean = false):void
		{
			if (isExp)
			{
				new EquipRecycleExpEffect(_layer);
			} else
			{
				if(equipRecycleEffectHandler&&equipRecycleEffectHandler.doing)
				{
					equipRecycleEffectHandler.destroy();
					equipRecycleEffectHandler=null;
				}
				equipRecycleEffectHandler = new EquipRecycleEffectHandler(_layer);
			}
		}
		
		public function doFireDragonEnergyEffect():void
		{
			new FlyFireDragonEnergyEffect(_layer);
		}
		
		public function doChestRewardEffect():void
		{
			new ChestsEffectHandler(_layer);
		}
		
		public function doSpecialEffect(type:int):void
		{
			new FlySpecialEffect(_layer, type);
		}
		
		public function doFlyOnlineShield(type:int, bmp:Bitmap, startPoint:Point, endPoint:Point):void
		{
			var fly:FlyOnlineShieldEffect = new FlyOnlineShieldEffect(_layer);
			fly.setData(type, bmp, startPoint, endPoint);
		}
		
		public function deExpStoneEffect(start:Point):void
		{
			var fly:ExpStoneEffect = new ExpStoneEffect(_layer);
			fly.setStartPoint(start);
		}
		
		public function doFlyDgnExchange(index:int):void
		{
			var size:int = 10;
			while(size--)
			{
				var obj:Object = new Object();
				obj.timerId = setTimeout(function (obj:Object):void
				{
					clearTimeout(obj.timerId);
					var flyEffectDgnExchange:FlyEffectDgnExchange = new FlyEffectDgnExchange(_layer,index);
				},size*50,obj);
			}
		}
	}
}

class PrivateClass
{
}