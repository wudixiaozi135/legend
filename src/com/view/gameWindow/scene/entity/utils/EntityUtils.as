package com.view.gameWindow.scene.entity.utils
{
	import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
	import com.view.gameWindow.scene.entity.entityItem.interf.ILivingUnit;

	public class EntityUtils
	{
		public static function sortOnY(a:IEntity ,b:IEntity):Number
		{
			var livingUnitA:ILivingUnit;
			var livingUnitB:ILivingUnit;
			if(a is ILivingUnit && !(b is ILivingUnit))
			{
				livingUnitA = a as ILivingUnit;
				if(livingUnitA.hp <= 0)
				{
					return -1;
				}
				else
				{
					return a.pixelY - b.pixelY || /*a.pixelX - b.pixelX || */b.entityType - a.entityType || a.entityId - b.entityId;
				}
			}
			else if(b is ILivingUnit && !(a is ILivingUnit))
			{
				livingUnitB = b as ILivingUnit;
				if(livingUnitB.hp <= 0)
				{
					return 1;
				}
				else
				{
					return a.pixelY - b.pixelY || /*a.pixelX - b.pixelX || */b.entityType - a.entityType || a.entityId - b.entityId;
				}
			}
			else
			{
				return a.pixelY - b.pixelY || /*a.pixelX - b.pixelX || */b.entityType - a.entityType || a.entityId - b.entityId;
			}
		}
	}
}