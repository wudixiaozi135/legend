package com.view.gameWindow.panel.panels.activitys.loongWar.tabReward
{
	import com.model.configData.cfgdata.EquipCfgData;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.panel.panels.hero.tab1.EntityModeInUIlHandle;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.scene.entity.constants.ActionTypes;
	import com.view.gameWindow.scene.entity.model.EntityModelsManager;
	import com.view.gameWindow.scene.entity.model.base.EntityModel;
	import com.view.gameWindow.scene.entity.model.utils.EntityModelUtil;
	import com.view.gameWindow.util.UIEffectLoader;
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	public class TabLoongWarRewardModeHandle extends EntityModeInUIlHandle
	{
		private var _layer:MovieClip;
		private var _uiEffectLoader:UIEffectLoader;
		private var _type:int;
		
		public function TabLoongWarRewardModeHandle(layer:MovieClip,type:int)
		{
			_layer = layer;
			_layer.mouseEnabled = false;
			_layer.mouseChildren = false;
			_uiEffectLoader = new UIEffectLoader(_layer,0,-130);
			_type = type;
			super(layer);
		}
		
		override public function changeModel():void
		{
			var dtsReward:Dictionary = ActivityDataManager.instance.loongWarDataManager.dtsReward;
			var dt:DataLoongWarReward = dtsReward[_type] as DataLoongWarReward;
			if(_type == DataLoongWarReward.SCORE_RANK_0)
			{
				dealMode(dt);
			}
			else
			{
				dealSWFMode(dt);
			}
		}
		
		private function dealMode(dt:DataLoongWarReward):void
		{
			isInit = false;
			var oldEntityModel:EntityModel = _entityModel;
			_entityModel = EntityModelUtil.getEntityModel(0, dt.fashionId, 0, 0, 0, 0, 0, RoleDataManager.instance.sex, ActionTypes.NOACTION, EntityModel.N_DIRECTION_8);
			EntityModelsManager.getInstance().unUseModel(oldEntityModel);
		}
		
		private function dealSWFMode(dt:DataLoongWarReward):void
		{
			var equipCfgData:EquipCfgData = dt.equipCfgData;
			if(!equipCfgData)
			{
				return;
			}
			var chestUrl:String = equipCfgData.chest_url;
			_uiEffectLoader.url = "chest/"+chestUrl+".swf";
		}
		
		override public function destroy():void
		{
			_uiEffectLoader.destroy();
			_layer = null;
			super.destroy();
		}
	}
}