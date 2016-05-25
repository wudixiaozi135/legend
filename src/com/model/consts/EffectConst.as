package com.model.consts
{
	public class EffectConst
	{
		public static const RES_BTN_LEVEL_MATCH:String = "btn/levelMatch.swf";
		public static const RES_BTN_NPCTASKPANEL:String = "btn/npcTaskPanel.swf";
		public static const RES_COMPLETE_TASKL:String = "task/complete.swf";
		public static const RES_RECEIVE_TASK:String = "task/receive.swf";
		
		public static const RES_AUTOSIGN_FINDPATH:String = "autoSign/findPath.swf";
		public static const RES_AUTOSIGN_FIGHT:String = "autoSign/fight.swf";
		
		public static const RES_NPCTASK_GOLDEXCLAMATIONMARK:String = "npcTask/goldExclamationMark.swf";
		public static const RES_NPCTASK_GRAYEXCLAMATIONMARK:String = "npcTask/grayExclamationMark.swf";
		public static const RES_NPCTASK_GOLDQUESTIONMARK:String = "npcTask/goldQuestionMark.swf";
		public static const RES_NPCTASK_GRAYQUESTIONMARK:String = "npcTask/grayQuestionMark.swf";
		
		public static const RES_FIGHTNUM:String = "fightNum/fightNum.swf";
        public static const RES_FIGHTNUMEFFECT:String = "fightNum/fightNumEffect.swf";
		
		public static const RES_VIP:String = "vip/vip.swf";
		
		public static const RES_SKILL_SWITCH:String = "actionBar/skillSwitch.swf";
		
		public static const RES_MAINUI_BTN_EMAIL:String = "mainUiBtn/emai.swf";
		
		public static const RES_SPECIAL_RING:String = "ring/ring&x.swf";
		public static const RES_SPECIAL_RINGEFF:String = "hero/hero_meridians_02.swf";
		
		public static const RES_HEJI:String = "heji/heji.swf";
		
		public static const RES_STRENGTH_SUCCESS:String = "strength/success.swf";
		public static const RES_STRENGTH_FAILE:String = "strength/fail.swf";
		public static const RES_STRENGTH_STAR:String = "strength/star.swf";
		
		public static const RES_EXTEND_ARROW:String = "extend/arrow.swf";
		public static const RES_EXTEND_EXTEND:String = "extend/extend.swf";
		
		public static const RES_RESOLVE_BG:String = "resolve/bg.swf";
		public static const RES_RESOLVE_SUCCESS:String = "resolve/resolveSuccess.swf";
		public static const RES_RESOLVING:String = "resolve/resolving.swf";
		
		public static const RES_FORGE_BG:String = "forgeBg/bg.swf";
		
		public static const RES_RING_OO:String = "ring/ringOO.swf";
		public static const RES_MAINUI_BTN:String = "mainUiBtn/btn.swf";
		
		public static const RES_CONVERT_BOTTOM:String = "convert/bottom.swf";
		
		public static const RES_TREASURE:String = "treasure/long.swf";

        public static const RES_PRAY_COIN_NORMAL:String = "pray/normalCoin.swf";
        public static const RES_PRAY_TICKET_NORMAL:String = "pray/normalTicket.swf";

        public static const RES_PRAY_COIN:String = "pray/coinDrop.swf";
        public static const RES_PRAY_TICKET:String = "pray/ticketDrop.swf";

		public static const RES_HUOYAN:String = "closet/huoyan.swf";
		public static const RES_JINJIE:String = "closet/jinjie.swf";
		public static const RES_TITLE:String = "closet/title.swf";
		
		public static const RES_ITEMNUM1:String = "compound/itemNum1.swf";
		public static const RES_ITEMNUM3:String = "compound/itemNum3.swf";
		
		public static const RES_GREEN:String = "icon/green.swf";
        public static const RES_STONE_GREEN:String = "icon/stoneGreen.swf";

		public static const RES_EQUIPRECYCLE_SINGEL:String = "equipRecycle/singelRecycle.swf";
		public static const RES_EQUIPRECYCLE_ALL:String = "equipRecycle/allRecycle.swf";
		
		public static const RES_EXP_EFFECT:String = "exp/exp.swf";
		
		public static const RES_TASKSTAR_SUCCESS:String = "taskStar/success.swf";
		public static const RES_TASKSTAR_FAIL:String = "taskStar/fail.swf";
		
		public static const RES_EXPSTONE:String = "expStone/all.swf";

        public static const RES_BAG_UP:String = "bag/up.swf";
        public static const RES_BAG_DOWN:String = "bag/down.swf";

        public static const RES_ACT_ENTER_EFFECT:String = "actEnter/topIconEffect.swf";
        public static const RES_FIRE_DRAGON_STRENGTH:String = "bag/fireDragon.swf";
        public static const RES_BLUE_GREEN:String = "bag/blueGreen.swf";
        public static const RES_EXP_BALL:String = "bag/expBall.swf";//经验球
        public static const RES_EXP_EXPLOSION:String = "bag/expExplode.swf";//经验爆炸
		
		public static const RES_DGN_TOWER_EXCHANGE:String = "dgnTower/expfly.swf";

        //首充特效
        public static const RES_CHARGE_1:String = "charge/weapon_1.swf";
        public static const RES_CHARGE_2:String = "charge/weapon_2.swf";
        public static const RES_CHARGE_3:String = "charge/weapon_3.swf";
        public static const RES_CHARGE_BTN_EFFECT:String = "charge/chargeEffect.swf";
        public static const RES_WELFARE_EFFECT:String = "welfare/signEffect.swf";

		public static const RES_MAGIC:String = "artifact/magic.swf";
        public static const RES_ONLINE_EQUIP_EFFECT:String = "shield/onlineEffect.swf";
        public static const RES_ACHIEVEMENT_EFFECT:String = "achievement/btnEffect.swf";
        public static const RES_HERO_MODE_ATTACK:String = "hero/modeAttack.swf";
        public static const RES_HERO_MODE_DEFEND:String = "hero/modeDefend.swf";
        public static const RES_WING_EFFECT:String = "wing/";
        public static const RES_MALL_BTNEFFECT:String = "mall/btnExtract.swf";
        //在线装备特效
		public static function getClosetNameEffect(frame:int):String
		{
			switch(frame)
			{
				case 1:
					return "closet/huanwu.swf";
				case 2:
					return "closet/shizhuang.swf";
				case 3:
					return "closet/chibang.swf";
				case 4:
					return "closet/douli.swf";
				case 5:
					return "closet/zuji.swf";
			}
			return "";
		}
		
		public function EffectConst()
		{
		}
	}
}