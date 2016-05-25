package com.view.gameWindow.panel.panels.task.linkText
{
	import com.view.gameWindow.panel.panelbase.IPanelTab;
	import com.view.gameWindow.panel.panels.guideSystem.UICenter;
	
	import flash.events.TextEvent;
	import flash.text.TextField;

	public class LinkTextClickHandle
	{
		private var _txtTarget:TextField;
		private var _linkText:ILinkText;
		private var _uiCenter:UICenter;
		
		public function get linkText():ILinkText
		{
			return _linkText;
		}
		
		public function LinkTextClickHandle(txtTarget:TextField)
		{
			txtTarget.addEventListener(TextEvent.LINK,onLink);
			_txtTarget = txtTarget;
			_linkText = new LinkText();
			_uiCenter = new UICenter();
		}
		
		protected function onLink(event:TextEvent):void
		{
			var num:int = _linkText.getItemCount();
			var name:String;
			var tabIndex:int;
			for(var i:int = 1;i<num+1;i++)
			{
				if(event.text == i.toString())
				{
					name = UICenter.getUINameFromMenu(_linkText.getItemById(i).panelId.toString());
					_uiCenter.openUI(name);
					tabIndex = _linkText.getItemById(i).panelPage;
					if(tabIndex>=0)
					{
						var tab:IPanelTab = UICenter.getUI(name) as IPanelTab;
						if(tab)
						{
							tab.setTabIndex(tabIndex);
						}
					}
				}
			}
		}
		
		public function destory():void
		{
			_txtTarget.removeEventListener(TextEvent.LINK,onLink);
			_linkText = null;
			_uiCenter = null;
		}
	}
}