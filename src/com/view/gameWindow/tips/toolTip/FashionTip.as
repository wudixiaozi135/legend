package com.view.gameWindow.tips.toolTip
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;

	public class FashionTip extends EquipBaseTip
	{
		public function FashionTip(tipType:int)
		{
			super(tipType);
		}
		
		override public function setData(obj:Object):void
		{
			_data = obj;
			var equipCfgData:EquipCfgData = _data as EquipCfgData;
			if(!equipCfgData)
			{
				return;
			}
			super.setData(equipCfgData);
//			var url:String = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD+equipCfgData.icon+ResourcePathConstants.POSTFIX_PNG;
//			loadPic(url);
////			setStars(5);
//			setEquipName(equipCfgData);
//			setEquipType(ConstEquipCell.getEquipName(equipCfgData.type));
//			setEquipLevel(4);
//			setEquipProperty(equipCfgData);
//			//setStrengthProperty(newEquipCfgData);
//			//setFuMoProperty(newEquipCfgData);
//			setNextProperty(equipCfgData);
//			maxHeight += 13;
//			height = maxHeight;
		}
		
	}
}