package com.view.gameWindow.util
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IHero;
	
	import flash.utils.setTimeout;

	public class SayUtil
	{
		public function SayUtil()
		{
		}
		
		public static function heroSayEquip():void
		{
			var myHero:IHero = EntityLayerManager.getInstance().myHero;
			if(myHero)
			{
				var randomIndex:int= Math.random()*StringConst.HERO_SAY_0001.length;
				myHero.say(StringConst.HERO_SAY_0001[randomIndex]);
			}
		}
	}
}