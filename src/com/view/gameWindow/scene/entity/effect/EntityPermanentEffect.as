package com.view.gameWindow.scene.entity.effect
{
	import com.view.gameWindow.scene.effect.item.EffectBase;
	import com.view.gameWindow.scene.entity.effect.interf.IEntityPermanentEffect;
	
	public class EntityPermanentEffect extends EffectBase implements IEntityPermanentEffect
	{
		public function EntityPermanentEffect(path:String)
		{
			super(path);
		}
		
		protected override function repeat():Boolean
		{
			return true;
		}
		
		public override function expire():Boolean
		{
			return false;
		}
		
		public override function destory():void
		{
			super.destory();
		}
	}
}