package com.view.gameWindow.panel.panels.dragonTreasure.treasureWareHouse.item
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.bag.McBagCell;
	import com.view.gameWindow.util.ObjectUtils;

	/**
	 * Created by Administrator on 2014/12/3.
	 * 寻宝仓库格子
	 */
	public class TreasureWareHouseCell extends McBagCell
	{
		public function TreasureWareHouseCell()
		{
			mouseEnabled = false;

			var rsrLoader:RsrLoader = new RsrLoader();
			rsrLoader.load(this, ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);

			txtNum.mouseEnabled = false;
			mcIcon.mouseEnabled = false;
			mcBindSign.mouseEnabled = false;
			doubleClickEnabled = true;
			bg.visible = false;

			mcIcon.visible = true;
			mcIcon.mouseEnabled = false;
			arrow.visible = false;
			txtNum.visible = true;
			mcLock.visible = false;
			bindSginVisible(false);
			mcRedSign.visible=false;
			mcYellowSign.visible=false;
		}

		private function bindSginVisible(value:Boolean):void
		{
			mcBindSign.visible = value;
		}

		public function destroy():void
		{
			if (numChildren)
			{
				ObjectUtils.clearAllChild(this);
			}
		}
	}
}
