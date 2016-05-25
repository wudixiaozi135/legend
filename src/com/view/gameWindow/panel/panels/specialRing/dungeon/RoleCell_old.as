package com.view.gameWindow.panel.panels.specialRing.dungeon
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.util.cell.IconCell;
	
	import flash.display.MovieClip;
	
	/**
	 * 角色头像单元框类
	 * @author Administrator
	 */	
	public class RoleCell extends IconCell
	{
		private var isInit:Boolean;
		
		public function RoleCell(bg:MovieClip)
		{
			super(bg, 0, 0, bg.width, bg.height);
		}
		
		public function refreshData():void
		{
			if(!isInit)
			{
				isInit = true;
				var job:int = RoleDataManager.instance.job;
				var sex:int = RoleDataManager.instance.sex;
				var url:String = ResourcePathConstants.IMAGE_CREATEROLE_FOLDER_LOAD + job + "_" + sex + ResourcePathConstants.POSTFIX_PNG;
				loadPic(url);
			}
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
	}
}