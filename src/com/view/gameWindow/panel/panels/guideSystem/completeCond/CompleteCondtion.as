package com.view.gameWindow.panel.panels.guideSystem.completeCond
{
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	
	/**
	 * @author wqhk
	 * 2014-12-10
	 */
	public class CompleteCondtion
	{
		public function CompleteCondtion()
		{
		}
		
		/**
		 * ICheckCondtion
		 */
		public function parse(data:String):Array
		{
			var list:Array = data ? data.split("|") : null;
			var re:Array = [];
			for each(var item:String in list)
			{
				var cond:ICheckCondition = parsePart(item);
				if(cond)
				{
					re.push(cond);
				}
			}
				
			return re;
		}
		
		public function parsePart(data:String):ICheckCondition
		{
			if(!data)
			{
				return null;
			}
			
			var arr:Array = data.split(":");
			
			
			switch(arr[0])
			{
				case CondDef.O_RUN:
					switch(arr[1])
					{
						case CondDef.P_NPC:
							return new RunToNpcCheck(parseInt(arr[2]));
							break;
						case CondDef.P_MST:
							return new RunToMonsterCheck(parseInt(arr[2]));
							break;
						case CondDef.P_MAP:
							if(arr.length == 5)
							{
								return new RunToMapCheck(parseInt(arr[2]),parseInt(arr[3]),parseInt(arr[4]));
							}
							break;
					}
					break;
				case CondDef.O_SPE_RING:
					return new SpecialRingLvCheck(parseInt(arr[1]),parseInt(arr[2]));
					break;
				case CondDef.O_AFIGHT:
					return new AutoFightCheck();
					break;
				case CondDef.O_JOINT_ATTACK:
					return new JointAttackCheck();
					break;
				case CondDef.O_POS:
					return new PositionCheck(int(arr[1]));
					break;
				case CondDef.O_POS_CHO:
					switch(int(arr[1]))
					{
						case EntityTypes.ET_PLAYER:
							return new PositionChopidCheck(EntityTypes.ET_PLAYER,int(arr[2]));
							break;
						case EntityTypes.ET_HERO:
							return new PositionChopidCheck(EntityTypes.ET_HERO,int(arr[2]));
							break;
					}
					break;
				case CondDef.O_INDIV_BOSS:
					arr.shift();
					return new IndividualBossKillCheck(arr);
					break;
				case CondDef.O_HERO_MODE:
					return new HeroFightModeCheck(parseInt(arr[1]));
					break;
				case CondDef.O_ALWAYS_CLOSE:
					return new PanelCloseCheck(arr[1]);
					break;
				case CondDef.O_EQUIP_RECYCLE:
					return new EquipRecycleNumCheck();
					break;
				case CondDef.O_VIP:
					return new VipCheck(parseInt(arr[1]));
					break;
			}
			
			return null;
		}
	}
}