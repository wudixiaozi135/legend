package com.view.gameWindow.scene.entity.entityItem
{

	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.PlantCfgData;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPlant;
	import com.view.gameWindow.scene.entity.model.EntityModelsManager;
	import com.view.gameWindow.scene.entity.model.base.EntityModel;
	import com.view.gameWindow.util.UtilMouse;
	
	public class Plant extends Unit implements IPlant
	{
		private var _plantId:int;
		private var _state:int;
		
		override public function setOver(value:Boolean):void
		{
			if(value)
			{
				if(!PanelMediator.instance.isMouseOnPanel && !MainUiMediator.getInstance().isMouseOn)
				{
					UtilMouse.setMouseStyle(UtilMouse.PLANT);
				}	
			}
			else
			{
				UtilMouse.cancelMouseStyle();
			}
			super.setOver(value);
		}
		
		override public function setSelected(value:Boolean):void
		{
			UtilMouse.cancelMouseStyle();
			super.setSelected(value);
		}
		
		
		private var _totalTime:int;
		
		public override function show():void
		{
			var plantCfgData:PlantCfgData = ConfigDataManager.instance.plantCfgData(_plantId);
			entityName = plantCfgData.name;
			_totalTime = plantCfgData.remain;
			super.show();
			_entityModel = EntityModelsManager.getInstance().getAndUseEntityModel(ResourcePathConstants.ENTITY_RES_PLANT_LOAD + plantCfgData.avatar+"/", "", "", "", "", "", "", "", EntityModel.N_DIRECTION_5);
			idle();
		}

		public override function get entityType():int
		{
			return EntityTypes.ET_PLANT;
		}
		
		public function get plantId():int
		{
			return _plantId;
		}
		
		public function set plantId(value:int):void
		{
			_plantId = value;
		}
		
		public function get state():int
		{
			return _state;
		}
		
		public function set state(value:int):void
		{
			_state = value;
		}
		
		override public function hide():void
		{
			super.hide();
		}
		
		override public function get totalTime():int
		{
			return _totalTime;
		}
		
		public override function get tileDistToReach():int
		{
			return AutoJobManager.TO_PLANT_TILE_DIST;
		}
		
		public override function destory():void
		{
			super.destory();
		}
	}
}