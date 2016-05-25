package com.model.dataManager
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.pattern.Observer.IObserverEx;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	
	import flash.geom.Point;
	
	internal class TeleportSuccess implements IObserverEx
	{
		internal var targetId:int,targetType:int,plusId:int;
		internal var targetPos:Point;
		internal var targetMapId:int;
		internal var targetTileDist:int;
		internal var isTeleport:Boolean;
		internal var isResetAutoTask:Boolean;
		
		public function TeleportSuccess()
		{
			EntityLayerManager.getInstance().attach(this);
		}
		
		private var waitingPlayerIntoMap:Boolean = false;
		public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_ENTER_MAP)//实际传送成功
			{
				if(TeleportDatamanager.instance.isTeleport)
				{
					waitingPlayerIntoMap = true;
				}
			}
		}
		
		public function updateData(proc:int,data:*):void
		{
			if(waitingPlayerIntoMap && proc == GameServiceConstants.SM_ENTITY_INTO_MAP)
			{
				if(data == EntityLayerManager.getInstance().firstPlayer)
				{
					isTeleport = true;
					dealTeleportSuccess();
				}
			}
			else if(proc == GameServiceConstants.SM_INSTANT_MOVE)
			{
				if(data == EntityLayerManager.getInstance().firstPlayer)
				{
					isTeleport = true;
					dealTeleportSuccess();
				}
			}
		}
		
		internal function dealTeleportSuccess():void
		{
			var isTeleport:Boolean = TeleportDatamanager.instance.isTeleport;
			if(!isTeleport || !this.isTeleport)
			{
				return;
			}
			
			if(isResetAutoTask)
			{
				TaskDataManager.instance.setAutoTask(true,"TeleportSuccess::dealTeleportSuccess");
			}
			
			if(targetId)
			{
				if(targetType == EntityTypes.ET_MONSTER)
				{
					AutoSystem.instance.setTarget(targetId,targetType,plusId);
				}
				else
				{
					AutoJobManager.getInstance().setAutoTargetData(targetId,targetType);
				}
			}
			else if(targetPos)
			{
				AutoJobManager.getInstance().setAutoFindPathPos(targetPos, targetMapId, targetTileDist);
			}
			else
			{
				//主要是倒计时的传送面板
				if(!isResetAutoTask)
				{
					TaskDataManager.instance.setAutoTask(true,"TeleportSuccess::dealTeleportSuccess");
				}
				
				TaskDataManager.instance.doAutoTask();
			}
			reset();
		}
		
		private function reset():void
		{
			isResetAutoTask = false;
			targetId = 0;
			targetType = 0;
			plusId = 0;
			
			targetPos = null;
			targetMapId = 0;
			targetTileDist = 0;
			
			isTeleport = false;
			waitingPlayerIntoMap = false;
			TeleportDatamanager.instance.isTeleport = false;
		}
	}
}