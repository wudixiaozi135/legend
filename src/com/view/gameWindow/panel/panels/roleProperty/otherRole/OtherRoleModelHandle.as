package com.view.gameWindow.panel.panels.roleProperty.otherRole
{
	import com.view.gameWindow.panel.panels.hero.tab1.EntityModeInUIlHandle;
	import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
	import com.view.gameWindow.panel.panels.roleProperty.role.HideFactionData;
	import com.view.gameWindow.scene.entity.constants.ActionTypes;
	import com.view.gameWindow.scene.entity.model.EntityModelsManager;
	import com.view.gameWindow.scene.entity.model.base.EntityModel;
	import com.view.gameWindow.scene.entity.model.utils.EntityModelUtil;
	
	import flash.display.MovieClip;
	
	public class OtherRoleModelHandle extends EntityModeInUIlHandle
	{
		private var _cid:int;
		private var _sid:int;
		
		public function OtherRoleModelHandle(layer:MovieClip)
		{
			super(layer);
		}
		
		public function get sid():int
		{
			return _sid;
		}

		public function set sid(value:int):void
		{
			_sid = value;
		}

		public function get cid():int
		{
			return _cid;
		}

		public function set cid(value:int):void
		{
			_cid = value;
		}

		override public function changeModel():void
		{
			isInit = false;
			var sex:int = OtherPlayerDataManager.instance._infoDic[cid][sid]["sex"];
			var cloth:int = OtherPlayerDataManager.instance.memDic[cid][sid][0][ConstEquipCell.TYPE_YIFU].baseId;
			var fashion:int = OtherPlayerDataManager.instance.memDic[cid][sid][0][ConstEquipCell.TYPE_SHIZHUANG];
			var weapon:int = OtherPlayerDataManager.instance.memDic[cid][sid][0][ConstEquipCell.TYPE_WUQI].baseId;
			var hair:int = OtherPlayerDataManager.instance.memDic[cid][sid][0][ConstEquipCell.TYPE_DOULI];
			var wing:int = OtherPlayerDataManager.instance.memDic[cid][sid][0][ConstEquipCell.TYPE_CHIBANG];
			var shield:int = OtherPlayerDataManager.instance.memDic[cid][sid][0][ConstEquipCell.TYPE_DUNPAI].baseId;
			var oldEntityModel:EntityModel = _entityModel;
			var isHide:int = OtherPlayerDataManager.instance._infoDic[cid][sid]["idHide"];
			var hideFactionData:HideFactionData = new HideFactionData();
			hideFactionData.setData(isHide);
			_entityModel = EntityModelUtil.getEntityModel(cloth, hideFactionData.hideShizhuang == 1?0:fashion, weapon, 0, hideFactionData.hideDouli == 1?0:hair,
				shield, hideFactionData.hideChibang == 1?0:wing, sex, ActionTypes.NOACTION, EntityModel.N_DIRECTION_8);
			EntityModelsManager.getInstance().unUseModel(oldEntityModel);
		}	
	}
}