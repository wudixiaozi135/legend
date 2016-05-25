package com.view.gameWindow.scene.entity.entityItem
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.model.consts.SexConst;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.panel.panels.activitys.castellanWorship.DataWorshipInfo;
	import com.view.gameWindow.panel.panels.task.npcfunc.NpcFuncs;
	import com.view.gameWindow.scene.entity.constants.Direction;
	import com.view.gameWindow.scene.entity.entityItem.interf.INpcDynamic;
	import com.view.gameWindow.scene.entity.model.EntityModelsManager;
	import com.view.gameWindow.scene.entity.model.base.EntityModel;
	
	/**
	 * 动态NPC类<br>写一个类似function worshipHandle():String的方法在function get body():void方法中调用
	 * @author Administrator
	 */	
	public class NpcDynamic extends NpcStatic implements INpcDynamic
	{
		
		public function NpcDynamic(cfgData:NpcCfgData)
		{
			super(cfgData);
		}
		
		override public function changeMode():void
		{
			var oldEntityModel:EntityModel = _entityModel;
			var clothUrl:String = ResourcePathConstants.ENTITY_RES_NPC_LOAD + body + "/";
			if(!oldEntityModel || oldEntityModel.clothUrl != clothUrl)
			{
				_entityModel = EntityModelsManager.getInstance().getAndUseEntityModel(clothUrl, "", "", "", "", "", "", "", EntityModel.N_DIRECTION_1);
				_direction = Direction.DOWN;
				EntityModelsManager.getInstance().unUseModel(oldEntityModel);
				//
				changeName();
			}
		}
		/**获取动态npc模型链接*/		
		private function get body():String
		{
			if(_config.func_extra == NpcFuncs.NF_WORSHIP)
			{
				return bodyWorshipHandle();
			}
			return _config.body;
		}
		/**城主膜拜处理*/
		private function bodyWorshipHandle():String
		{
			var strBody:String = _config.body;
			var dtInfo:DataWorshipInfo = ActivityDataManager.instance.worshipDataManager.dtInfo;
			dtInfo.entityIds[entityId] ? null : dtInfo.entityIds[entityId] = entityId;
			if(dtInfo.sex == SexConst.TYPE_FEMALE)
			{
				switch(dtInfo.bodyState)
				{
					case 0:
						strBody = _config.body3;
						break;
					case 1:
						strBody = _config.body4;
						break;
					case 2:
						strBody = _config.body5;
						break;
					default:
						break;
				}
			}
			else
			{
				switch(dtInfo.bodyState)
				{
					case 0:
						strBody = _config.body;
						break;
					case 1:
						strBody = _config.body1;
						break;
					case 2:
						strBody = _config.body2;
						break;
					default:
						break;
				}
			}
			return strBody;
		}
		
		public function changeName():void
		{
			clearUpHeadContent();
			if(_config.func_extra == NpcFuncs.NF_WORSHIP)
			{
				entityName = nameWorshipHandle();
				return;
			}
			entityName = _config.name;
		}
		
		private function nameWorshipHandle():String
		{
			var dtInfo:DataWorshipInfo = ActivityDataManager.instance.worshipDataManager.dtInfo;
			return dtInfo.name ? dtInfo.name : _config.name;
		}
	}
}