package com.view.gameWindow.panel.panels.school.complex.member.nickName
{
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	
	import flash.utils.Dictionary;
	
	import mx.utils.StringUtil;

	public class NickNameHandler
	{

		private var _panel:NickNamePanel;
		private var _skin:MCNickName;
		public function NickNameHandler(panel:NickNamePanel)
		{
			this._panel = panel;
			_skin=panel.skin as MCNickName;
		}
		
		public function updatePanel():void
		{
			var positionDic:Dictionary = SchoolDataManager.getInstance().positionDic;
			_skin.txtv1.text=positionDic[3];
			_skin.txtv2.text=positionDic[4];
			_skin.txtv3.text=positionDic[5];
			_skin.txtv4.text=positionDic[6];
			_skin.txtv1.maxChars=5;
			_skin.txtv2.maxChars=5;
			_skin.txtv3.maxChars=5;
			_skin.txtv4.maxChars=5;
		}
		
		public function destroy():void
		{
			
		}
	}
}