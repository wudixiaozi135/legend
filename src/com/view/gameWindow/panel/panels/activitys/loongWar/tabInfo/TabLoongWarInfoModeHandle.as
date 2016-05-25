package com.view.gameWindow.panel.panels.activitys.loongWar.tabInfo
{
    import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
    import com.view.gameWindow.panel.panels.activitys.loongWar.LoongWarDataManager;
    import com.view.gameWindow.panel.panels.activitys.loongWar.tabReward.DataLoongWarReward;
    import com.view.gameWindow.panel.panels.hero.tab1.EntityModeInUIlHandle;
    import com.view.gameWindow.scene.entity.constants.ActionTypes;
    import com.view.gameWindow.scene.entity.model.EntityModelsManager;
    import com.view.gameWindow.scene.entity.model.base.EntityModel;
    import com.view.gameWindow.scene.entity.model.utils.EntityModelUtil;

    import flash.display.MovieClip;

    public class TabLoongWarInfoModeHandle extends EntityModeInUIlHandle
	{
		/**帮会职位：*/		
		private var _position:int;
		
		public function TabLoongWarInfoModeHandle(layer:MovieClip,position:int)
		{
			_position = position;
			super(layer);
		}
		
		override public function changeModel():void
		{
			isInit = false;
			var oldEntityModel:EntityModel = _entityModel;
			var manager:LoongWarDataManager = ActivityDataManager.instance.loongWarDataManager;
			if(_position == DataLoongWarInfo.POSITION_MAIN)//帮主
			{
				var dtReward:DataLoongWarReward = manager.dtsReward[DataLoongWarReward.SCORE_RANK_0] as DataLoongWarReward;
			}
			var dt:DataLoongWarInfo = manager.dtsPositionInfo[_position] as DataLoongWarInfo;
			if(dt)
			{
				var cloth:int = dt.clothesId;
                var fashion:int = (dtReward && dtReward.fashionId) ? dtReward.fashionId : dt.fashionIds[0];
				var weapon:int = dt.weaponId;
                var magicWeapon:int = dt.fashionIds[3];
                var hair:int = dt.fashionIds[1];//斗笠
				var shield:int = dt.shieldId;
                var wing:int = /*dt.wing*/0;
				var sex:int = dt.sex;
			}
			var actionId:int = ActionTypes.NOACTION;
			var dir:int = EntityModel.N_DIRECTION_8;
			_entityModel = EntityModelUtil.getEntityModel(cloth,fashion,weapon,magicWeapon,hair,shield,wing,sex,actionId,dir);
			EntityModelsManager.getInstance().unUseModel(oldEntityModel);
		}
	}
}