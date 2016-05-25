package com.view.gameWindow.panel.panels.skill.panelskillset
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.consts.JobConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.skill.SkillData;
	import com.view.gameWindow.panel.panels.skill.SkillDataManager;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;

	public class SkillIconItem implements IUrlBitmapDataLoaderReceiver
	{
		private const cellW:int = 36,cellH:int = 36;
		private var _layer:MovieClip;
		private var _urlBitmapDataLoader:UrlBitmapDataLoader;
		private var _bitmap:Bitmap;

		private var _data:SkillCfgData;
		public function SkillIconItem(layer:MovieClip)
		{
			_layer = layer;
			
			var tipVO:TipVO = new TipVO();
			tipVO.tipType = ToolTipConst.SKILL_TIP;
			tipVO.tipData = getTipData;
			ToolTipManager.getInstance().hashTipInfo(_layer,tipVO);
			ToolTipManager.getInstance().attach(_layer);
		}
		
		public function getTipData():Object
		{
			return _data;
		}
		
		public function loadPic(id:int):void
		{
			var job:int = RoleDataManager.instance.job;
			var entity_type:int = SkillDataManager.instance.entity_type;
			var skillData:SkillData = SkillDataManager.instance.skillData(id);
			if(!skillData)
			{
				return;
			}
			var skillCfgData:SkillCfgData = ConfigDataManager.instance.skillCfgData(job,entity_type,skillData.group_id,skillData.level);
			if(!skillCfgData)
			{
				skillCfgData = ConfigDataManager.instance.skillCfgData(JobConst.TYPE_NO,entity_type,skillData.group_id,skillData.level);
			}
			_data = skillCfgData;
			var url:String = ResourcePathConstants.IMAGE_ICON_SKILL_FOLDER_LOAD+skillCfgData.icon+ResourcePathConstants.POSTFIX_PNG;
			_urlBitmapDataLoader = new UrlBitmapDataLoader(this);
			_urlBitmapDataLoader.loadBitmap(url);
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			destroyLoader();
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			if(_bitmap && _bitmap.bitmapData)
				_bitmap.bitmapData.dispose();
			if(_bitmap && _bitmap.parent)
				_bitmap.parent.removeChild(_bitmap);
			_bitmap = new Bitmap(bitmapData,"auto",true);
			_bitmap.width = cellW;
			_bitmap.height = cellH;
			_layer.addChild(_bitmap);
			destroyLoader();
		}
		
		public function setNull():void
		{
			if(_bitmap && _bitmap.bitmapData)
			{
				_bitmap.bitmapData.dispose();
				if(_bitmap.parent)
					_bitmap.parent.removeChild(_bitmap);
			}
			_bitmap = null;
			_data = null;
		}
		
		public function destroyLoader():void
		{
			if(_urlBitmapDataLoader)
				_urlBitmapDataLoader.destroy();
			_urlBitmapDataLoader = null;
		}
		
		public function destory():void
		{
			ToolTipManager.getInstance().attach(_layer);
			setNull();
			destroyLoader();
			_layer = null;
		}
	}
}