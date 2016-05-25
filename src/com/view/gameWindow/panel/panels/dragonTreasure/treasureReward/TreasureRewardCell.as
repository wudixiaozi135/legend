package com.view.gameWindow.panel.panels.dragonTreasure.treasureReward
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.bag.McBagCell;

	/**
	 * Created by Administrator on 2014/12/1.
	 */
	public class TreasureRewardCell extends McBagCell
	{
		public function TreasureRewardCell()
		{
			mouseEnabled = false;
			var rsrLoader:RsrLoader = new RsrLoader();
			rsrLoader.load(this, ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);

			txtNum.mouseEnabled = false;
			mcIcon.mouseEnabled = false;
			mcBindSign.mouseEnabled = false;
			doubleClickEnabled = true;

			mcIcon.visible = true;
			mcIcon.mouseEnabled=false;
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

		}
	}
}
