package com.view.gameWindow.common
{
	import com.view.gameWindow.panel.panels.roleProperty.RoleModelHandle;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.model.base.EntityModel;
	
	import flash.display.MovieClip;
	
	
	/**
	 * @author wqhk
	 * 2014-8-30
	 */
	public class ModelAnimBoard extends RoleModelHandle
	{
		public function ModelAnimBoard(layer:MovieClip)
		{
			super(layer);
		}
		
		public function setModel(model:EntityModel):void
		{
			isInit = false;
			_entityModel = EntityLayerManager.getInstance().firstPlayer.entityModel;
		}
	}
}