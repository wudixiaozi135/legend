package com.view.gameWindow.panel.panels.mall.mallItem
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.gameWindow.rsr.RsrLoader;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * Created by Administrator on 2014/11/19.
	 */
	public class MallItemBase extends Sprite
	{
		public function MallItemBase()
		{
		}

		protected var _skin:MovieClip;

		public function get skin():MovieClip
		{
			return _skin;
		}

		public function destroy():void
		{
			if (_skin)
			{
				_skin = null;
			}

		}

		protected function initView():void
		{
			var rsrLoader:RsrLoader = new RsrLoader();
			addCallBack(rsrLoader);
			rsrLoader.load(_skin, ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
		}

		protected function addCallBack(rsrLoader:RsrLoader):void
		{

		}
	}
}
