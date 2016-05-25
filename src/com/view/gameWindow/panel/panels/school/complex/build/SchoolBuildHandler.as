package com.view.gameWindow.panel.panels.school.complex.build
{
	import com.view.gameWindow.panel.panels.school.McInformation;

	public class SchoolBuildHandler
	{

		private var _panel:SchoolBuildPanel;
		private var _skin:McInformation;
		public function SchoolBuildHandler(panel:SchoolBuildPanel)
		{
			this._panel = panel;
			_skin=panel.skin as McInformation;
		}
		
		public function updatePanel():void
		{
			
		}
		
		public function destroy():void
		{
			
		}
	}
}