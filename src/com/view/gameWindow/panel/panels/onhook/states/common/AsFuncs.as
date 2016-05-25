package com.view.gameWindow.panel.panels.onhook.states.common
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.skillDeal.SkillDealManager;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * server
	 * @author wqhk
	 * 2014-10-8
	 */
	public class AsFuncs
	{
		public static function sendBeginMining(tileX:int,tileY:int):void
		{
			AutoJobManager.getInstance().sendBeginMining(tileX,tileY);
		}
		/**
		 * 发送拾取信息
		 */
		public static function sendPickDropitem(entityId:int):void
		{
//			if(BagDataManager.instance.remainCellNum == 0)
//			{
//				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0028);	
//				return;
//			}
			//
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(entityId);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_PICK_DROPITEM,byteArray);
		}
		
		/**
		 * 发送技能
		 */
		public static function sendAttack(skillGroupId:int,direction:int,tileX:int,tileY:int,type:int,targetId:int,targetType:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(skillGroupId);
			byteArray.writeByte(direction);
			byteArray.writeShort(tileX);
			byteArray.writeShort(tileY);
			byteArray.writeByte(type);
			byteArray.writeInt(targetId);
			byteArray.writeByte(targetType);
			
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DO_UNIT_SKILL, byteArray);
		}
		
		/**
		 * 技能
		 */
		public static function sendTiggerSkill(skillId:int,direction:int,tileX:int,tileY:int,type:int,targetId:int,targetType:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(skillId);
			byteArray.writeByte(direction);
			byteArray.writeShort(tileX);
			byteArray.writeShort(tileY);
			byteArray.writeByte(type);
			byteArray.writeInt(targetId);
			byteArray.writeByte(targetType);
			
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DO_TRIGGER_SKILL, byteArray);
		}
		
		/**
		 * 发送移动
		 */
		public static function sendMove(sX:int,sY:int,tX:int,tY:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeShort(sX);
			byteArray.writeShort(sY);
			byteArray.writeShort(tX);
			byteArray.writeShort(tY);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_MOVE, byteArray);
		}
		
		/**
		 * 发送地图切换
		 */
		public static function sendSwitchMap(teleportId:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(teleportId);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SWITCH_MAP, byteArray);
		}
	}
}