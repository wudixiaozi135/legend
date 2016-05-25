package com.view.gameWindow.tips.toolTip
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.NpcShopCfgData;
	
	/**
	 * @author jhj
	 */
	public class ShopEquipTip extends EquipBaseTip
	{
		public function ShopEquipTip(tipType:int)
		{
			super(tipType);
		}
		
		override public function setData(obj:Object):void
		{
			_data = obj;
			var _cfgDt:NpcShopCfgData = _data as NpcShopCfgData;
			if(!_cfgDt)
			{
				return;
			}
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(_cfgDt.base);
			super.setData(equipCfgData);
//			if(!equipCfgData)
//			{
//				return;
//			}
//			var url:String = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD+equipCfgData.icon+ResourcePathConstants.POSTFIX_PNG;
//			loadPic(url);
////			setStars(5);
//			setEquipName(equipCfgData);
//			setEquipType(ConstEquipCell.getEquipName(equipCfgData.type));
//			setEquipLevel(4);
//			setEquipProperty(equipCfgData);
//			//setStrengthProperty(equipCfgData);
//			//setFuMoProperty(equipCfgData);
//			setNextProperty(equipCfgData);
//			maxHeight += 13;
//			height = maxHeight;
		}
	}
}