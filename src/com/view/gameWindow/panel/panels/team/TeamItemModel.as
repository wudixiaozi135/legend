/**
 * Created by Administrator on 2014/11/6.
 */
package com.view.gameWindow.panel.panels.team
{
	import com.view.gameWindow.panel.panels.hero.tab1.EntityModeInUIlHandle;
	import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
	import com.view.gameWindow.panel.panels.roleProperty.otherRole.OtherPlayerDataManager;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.ActionTypes;
	import com.view.gameWindow.scene.entity.entityItem.Player;
	import com.view.gameWindow.scene.entity.model.EntityModelsManager;
	import com.view.gameWindow.scene.entity.model.base.EntityModel;
	import com.view.gameWindow.scene.entity.model.utils.EntityModelUtil;

	import flash.display.MovieClip;

	public class TeamItemModel extends EntityModeInUIlHandle
	{
		public function TeamItemModel(layer:MovieClip)
		{
			super(layer);
			layer.mouseChildren = false;
			layer.mouseEnabled = false;
		}

		private var _cid:int;
		private var _sid:int;

		override public function changeModel():void
		{
			isInit = false;
			
			var sex:int = 0;
			var cloth:int = 0;
			var fashion:int = 0;
			var weapon:int = 0;
			var currentActionId:int = ActionTypes.NOACTION;
			var hair:int = 0;
			var wing:int = 0;
			var shield:int = 0;

			var self:Player = EntityLayerManager.getInstance().firstPlayer as Player;
			if (cid == self.cid && sid == self.sid)
			{
				sex = self.sex;
				cloth = self.cloth;
				weapon = self.weapon;
				hair = self.hair;
				wing = self.wing;
				shield = self.shield;
			}
			else
			{
				sex = OtherPlayerDataManager.instance._infoDic[cid][sid]["sex"];
				cloth = OtherPlayerDataManager.instance.memDic[cid][sid][0][ConstEquipCell.TYPE_YIFU].baseId;
				fashion = OtherPlayerDataManager.instance.memDic[cid][sid][0][ConstEquipCell.TYPE_SHIZHUANG];
				weapon = OtherPlayerDataManager.instance.memDic[cid][sid][0][ConstEquipCell.TYPE_WUQI].baseId;
				hair =  OtherPlayerDataManager.instance.memDic[cid][sid][0][ConstEquipCell.TYPE_DOULI];
				wing = OtherPlayerDataManager.instance.memDic[cid][sid][0][ConstEquipCell.TYPE_CHIBANG];
				shield = OtherPlayerDataManager.instance.memDic[cid][sid][0][ConstEquipCell.TYPE_DUNPAI].baseId;
			}
			var oldEntityModel:EntityModel = _entityModel;
			_entityModel = EntityModelUtil.getEntityModel(cloth, fashion, weapon, 0, hair, shield, wing, sex, ActionTypes.NOACTION, EntityModel.N_DIRECTION_8);
			EntityModelsManager.getInstance().unUseModel(oldEntityModel);
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
	}
}
