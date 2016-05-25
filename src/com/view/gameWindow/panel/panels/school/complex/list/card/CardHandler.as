package com.view.gameWindow.panel.panels.school.complex.list.card
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	import com.view.gameWindow.panel.panels.school.simpleness.list.item.SchoolData;
	import com.view.gameWindow.util.ServerTime;
	import com.view.gameWindow.util.TimerManager;

	public class CardHandler
	{

		private var _panel:CardPanel;
		private var _skin:MCCard;
		public function CardHandler(panel:CardPanel)
		{
			this._panel = panel;
			_skin=panel.skin as MCCard;
			TimerManager.getInstance().add(1000,updateState);
		}
		
		private function updateState():void
		{
			var lookSchoolData:SchoolData = SchoolDataManager.getInstance().lookSchoolData;
			var item:* = SchoolDataManager.getInstance().attackSchoolDic[lookSchoolData.id+"|"+lookSchoolData.sid];
			if(item!=null)
			{
				var diff:Number = (item as int)-ServerTime.time;
				var m:int = diff/60;
				var s:int=diff%60;
				_skin.txtv4.text=StringConst.SCHOOL_PANEL_00333+"("+m+StringConst.MINIUTE+s+StringConst.SECOND+")";
			}else
			{
				_skin.txtv4.text="";
				TimerManager.getInstance().remove(updateState);
			}
		}
		
		public function updatePanel():void
		{
			var lookSchoolData:SchoolData = SchoolDataManager.getInstance().lookSchoolData;
			_skin.txtv1.text=lookSchoolData.name;
			_skin.txtv2.text=lookSchoolData.count+"/"+lookSchoolData.maxCount;
			_skin.txtv3.text=lookSchoolData.leaderName;
			_skin.txtv4.text="";
			_skin.txtv5.text=lookSchoolData.noticeExter;
		}
		
		
		
		public function destroy():void
		{
			TimerManager.getInstance().remove(updateState);
		}
	}
}