package com.view.gameWindow.panel.panels.school.complex.information.donate
{
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.panel.panels.school.complex.information.MCdonate;

	public class DonateHandler
	{

		private var _panel:DonatePanel;
		private var _skin:MCdonate;
		public function DonateHandler(panel:DonatePanel)
		{
			this._panel = panel;
			_skin=panel.skin as MCdonate;
		}
		
		public function updatePanel():void
		{
			var donateData:DonateData = SchoolElseDataManager.getInstance().donateData;
			_skin.txtv1.text=donateData.contribute+"";
			_skin.txtv2.text=donateData.money+"";
			_skin.txtv3.text=donateData.surplus+"";
			_skin.txtv7.text=BagDataManager.instance.coinUnBind+"";
			_skin.txtv8.text=BagDataManager.instance.coinBind+"";
			var value:int=int(_skin.txtv4.text);
			if(value*1000>donateData.surplus)
			{
				value=donateData.surplus/1000;
			}
			_skin.txtv4.text=value+"";
			_skin.txtv5.text=value+"";
			_skin.txtv6.text=value+"";
		}
		
		public function destroy():void
		{
		}
	}
}