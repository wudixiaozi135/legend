package com.view.gameWindow.panel.panels.unlock
{
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.util.Cover;
	
	import flash.display.MovieClip;
	
	
	/**
	 * @author wqhk
	 * 2014-10-30
	 */
	public class CoverPanel extends PanelBase
	{
		public function CoverPanel()
		{
			super();
		}
		
		override protected function initSkin():void
		{
//			_skin = new Cover(0,0.8);
//			addChild(_skin);
			_skin = new MovieClip();
			addChild(new Cover(0,0.6));
		}
		
		override public function resetPosInParent():void
		{
			
		}
		
		override public function setPostion():void
		{
			
		}
	}
}