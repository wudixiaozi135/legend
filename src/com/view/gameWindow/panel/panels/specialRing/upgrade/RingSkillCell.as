package com.view.gameWindow.panel.panels.specialRing.upgrade
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.util.cell.IconCell;
	
	import flash.display.MovieClip;
	
	/**
	 * 特戒技能框类
	 * @author Administrator
	 */	
	public class RingSkillCell extends IconCell
	{
		private var _cfgDt:SkillCfgData;

		public var bg:MovieClip;
		
		public function RingSkillCell(bg:MovieClip)
		{
			this.bg = bg;
			super(bg.parent, bg.x+3, bg.y+3, bg.width-6, bg.height-6);
		}
		override public function getTipData():Object
		{
			return _cfgDt;
		}
		
		override public function getTipType():int
		{
			return ToolTipConst.SKILL_TIP;
		}
		
		public function refreshData(cfgDt:SkillCfgData):void
		{
			if(!cfgDt)
			{
				setNull();
				bg.visible = false;
				return;
			}
			if(!_cfgDt || (cfgDt && _cfgDt && cfgDt.id != _cfgDt.id))
			{
				bg.visible = true;
				_cfgDt = cfgDt;
				var url:String = ResourcePathConstants.IMAGE_ICON_SKILL_FOLDER_LOAD+_cfgDt.icon+ResourcePathConstants.POSTFIX_PNG;
				loadPic(url);
			}
		}
		
		private function setNull():void
		{
			_cfgDt = null;
			destroyBmp();
		}
		
		override public function destroy():void
		{
			setNull();
			super.destroy();
		}
	}
}