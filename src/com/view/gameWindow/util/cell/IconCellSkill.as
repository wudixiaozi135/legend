package com.view.gameWindow.util.cell
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;

	public class IconCellSkill extends IconCell
	{
		private var _cfgDt:SkillCfgData;
		public function get cfgDt():SkillCfgData
		{
			return _cfgDt;
		}
		
		public function IconCellSkill(bg:MovieClip)
		{
			super(bg.parent,bg.x,bg.y,bg.width,bg.height);
		}
		
		public function refresh(cfgDt:SkillCfgData):void
		{
			if(cfgDt)
			{
				if(_cfgDt != cfgDt)
				{
					_cfgDt = cfgDt;
					var url:String = ResourcePathConstants.IMAGE_ICON_SKILL_FOLDER_LOAD + _cfgDt.icon + ResourcePathConstants.POSTFIX_PNG;
					loadPic(url);
				}
			}
			else
			{
				destroyBmp();
			}
		}
		
		public function copyBitMap():Bitmap
		{
			if(!_bmp || !_bmp.bitmapData)
			{
				return null;
			}
			var clone:BitmapData = _bmp.bitmapData.clone();
			var bitmap:Bitmap = new Bitmap(clone);
			bitmap.width = _bmp.width;
			bitmap.height = _bmp.height;
			return bitmap;
		}
		
		override public function getTipData():Object
		{
			return cfgDt;
		}
		
		override public function getTipType():int
		{
			return ToolTipConst.SKILL_TIP;
		}
		
		public function onClick():void
		{
			AutoJobManager.getInstance().useJointSkill();
		}
		
		override public function destroy():void
		{
			_cfgDt = null;
			super.destroy();
		}
	}
}