package com.view.gameWindow.panel.panels.achievement.title
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.configData.cfgdata.AchievementGroupCfgData;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.panels.achievement.AchievementDataManager;
    import com.view.gameWindow.panel.panels.achievement.MCTitleItem;
    import com.view.gameWindow.panel.panels.achievement.common.IScrollItem;
    import com.view.gameWindow.util.HtmlUtils;

    import flash.display.MovieClip;

    public class AchievementTitleItem extends MCTitleItem implements IScrollItem
	{
		private var rsrLoader:RsrLoader;
		private const hightConst:int=44;
		private var _data:TitleData;
		private var _cfg:AchievementGroupCfgData;
		public function AchievementTitleItem()
		{
			super();
			txtTitle.mouseEnabled=false;
			initSkin();
		}
		
		private function initSkin():void
		{
			rsrLoader=new RsrLoader();
			rsrLoader.addCallBack(this.titleBg,addBgCallback);
			rsrLoader.load(this,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
			rsrLoader.addCallBack(this.bg1,function (mc:MovieClip):void
			{
				if(_data!=null)
				{
                    bg1.visible = _data.awardC > 0;
				}
                bg1.mouseEnabled = false;
			});
		}
		
		public function destroy():void
		{
			rsrLoader.destroy();
			rsrLoader=null;
		}
		
		private function addBgCallback(e:MovieClip):void
		{
			var type:int= AchievementDataManager.getInstance().selectTitleType;
			if(_data&&_data.type==type)
			{
				select=true;
			}
		}
		
		public function set select(value:Boolean):void
		{
			titleBg.toggle=value;
			titleBg.selected=value;
		}
		
		public function get select():Boolean
		{
			return titleBg.selected;
		}
		
		public function initView(cfg:Object):void
		{
			_cfg=cfg as AchievementGroupCfgData ;
			this.txtTitle.text=cfg.name;
		}
		
		public function updateView():void
		{
			_data=AchievementDataManager.getInstance().getTitleData(_cfg.type);
			this.txtTitle.htmlText=HtmlUtils.createHtmlStr(0xFFE1AA,"<b>"+_cfg.name+"</b><font color='#ffffff'> ("+_data.gress+"/"+_data.count+") </font>",14);
			this.txtc.htmlText=HtmlUtils.createHtmlStr(0xffffff,_data.awardC+"",14,true);
			this.txtc.visible=_data.awardC>0;
			this.bg1.visible=_data.awardC>0;
		}
		
		public function setY(y:Number):void
		{
			this.y=y;
		}
		
		public function getItemHight():Number
		{
			return hightConst;
		}
		
		public function get cfg():AchievementGroupCfgData
		{
			return _cfg;
		}
	}
}