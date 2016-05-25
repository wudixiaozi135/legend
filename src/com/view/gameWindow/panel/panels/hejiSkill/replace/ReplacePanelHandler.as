package com.view.gameWindow.panel.panels.hejiSkill.replace
{
	import com.view.gameWindow.panel.panels.hejiSkill.McPanelRunes;
	import com.view.gameWindow.util.scrollBar.ScrollBar;
	import com.view.gameWindow.util.scrollBar.ScrollBarType;

	public class ReplacePanelHandler
	{
		private var _replaceBag:ReplaceBag;

		private var _replace:ReplacePanel;
		private var _skin:McPanelRunes;
		private var _scrollBar:ScrollBar;
		public function ReplacePanelHandler(replace:ReplacePanel)
		{
			_replace = replace;
			_skin=replace.skin as McPanelRunes;	
			initBag();
		}
		
		private function initBag():void
		{
			_replaceBag=new ReplaceBag();
			_skin.addChild(_replaceBag);
			_replaceBag.x=313;
			_replaceBag.y=54;
		}
		
		public function initScrollBar():void
		{
			_replaceBag.setScrollRectWH(184,184);
			_scrollBar=new ScrollBar(_replaceBag,_skin.mcScrollBar,ScrollBarType.TYPE_ACHIEVEMENT,null,44);
			_scrollBar.resetHeight(184);
		}
		
		public function updateBag():void
		{
			_replaceBag.updateBag();
		}
		
		public function destroy():void
		{
			_scrollBar&&_scrollBar.destroy();
			_scrollBar=null;
			if(_replaceBag)
			{
				_replaceBag.destroy();
				_replaceBag.parent&&_replaceBag.parent.removeChild(_replaceBag);
			}
			_replaceBag=null;
		}
	}
}