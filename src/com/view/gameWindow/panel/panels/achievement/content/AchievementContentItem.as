package com.view.gameWindow.panel.panels.achievement.content
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.cfgdata.AchievementCfgData;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.ResManager;
	import com.view.gameWindow.panel.panels.achievement.AchievementDataManager;
	import com.view.gameWindow.panel.panels.achievement.MCContentItem;
	import com.view.gameWindow.panel.panels.achievement.common.IScrollItem;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;

	public class AchievementContentItem extends MCContentItem implements IScrollItem
	{
		private var rsrLoader:RsrLoader;
		private const itemH:int=98;
		private var _select:Boolean;
		private var _linqu:Bitmap;
		private var _linqu2:Bitmap;
		public var configData:AchievementCfgData;
		public var iscompled:Boolean;
		
		public function AchievementContentItem() 
		{
			initSkin();
		}
		
		private function initSkin():void
		{
			rsrLoader=new RsrLoader();
			rsrLoader.load(this,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
			_linqu=new Bitmap();
			addChild(_linqu);
			_linqu.x=90;
			_linqu.y=35;
			_linqu2=new Bitmap();
			addChild(_linqu2);
			_linqu2.x=280;
			_linqu2.y=35;
			_linqu.visible=false;
			_linqu2.visible=false;
			var url:String=ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD+"achieve/get"+ResourcePathConstants.POSTFIX_PNG;
			ResManager.getInstance().loadBitmap(url,loadBitmapComple);
			txtsub.mouseEnabled=false;
			txtvsub.mouseEnabled=false;
			txtName.mouseEnabled=false;
			txtbg.mouseEnabled=false;
			txtvbg.mouseEnabled=false;
			txtgx.mouseEnabled=false;
			txtvgx.mouseEnabled=false;
			txt1.mouseEnabled=false;
			txtnum.mouseEnabled=false;
		}
		
		private function addCallBack():void
		{
			rsrLoader.addCallBack(this.btnsub,function (mc:MovieClip):void
			{
				updateView();
			});
			rsrLoader.addCallBack(this.btnvsub,function (mc:MovieClip):void
			{
				updateView();
			});
		}
		
		private function loadBitmapComple(bt:BitmapData,url:String):void
		{
			if(_linqu)
			{
				_linqu.bitmapData=bt;
			}
			if(_linqu2)
			{
				_linqu2.bitmapData=bt;
			}
		}
		
		public function initView(data:Object):void
		{
			var cfgData:AchievementCfgData=data as AchievementCfgData;
			txtName.htmlText=CfgDataParse.pareseDesToStr(cfgData.des);
			txtbg.text=StringConst.ACHI_PANEL_0010+cfgData.bind_gold;
			txtvbg.text=StringConst.ACHI_PANEL_0012+cfgData.vip_bind_gold;
			txtgx.text=StringConst.ACHI_PANEL_0011+cfgData.gongxun;
			txtvgx.text=StringConst.ACHI_PANEL_0013+cfgData.vip_gongxun;
			txt1.text=StringConst.ACHI_PANEL_0008;
			txtnum.text="";
			txtsub.text=StringConst.ACHI_PANEL_0014;
			txtvsub.text=StringConst.ACHI_PANEL_0015;
			configData=cfgData;
		}
		
		public function updateView():void
		{
			var contentData:ContentData=AchievementDataManager.getInstance().contentDatas[configData.achievement_id];
			if(contentData==null)return;
			iscompled=contentData.isCompled;
			
			if(contentData.state==0)
			{
				_linqu.visible=false;
				_linqu2.visible=false;
				txtsub.visible=iscompled;
				txtvsub.visible=iscompled;
				btnsub.visible=iscompled;
				btnvsub.visible=iscompled;
			}else if(contentData.state==1)
			{
				_linqu.visible=true;
				_linqu2.visible=false;
				txtsub.visible=false;
				txtvsub.visible=true;
				btnsub.visible=false;
				btnvsub.visible=true;
			}else if(contentData.state==2)
			{
				_linqu.visible=false;
				_linqu2.visible=true;
				txtsub.visible=true;
				txtvsub.visible=false;
				btnsub.visible=true;
				btnvsub.visible=false;
			}else
			{
				_linqu.visible=true;
				_linqu2.visible=true;
				txtsub.visible=false;
				txtvsub.visible=false;
				btnsub.visible=false;
				btnvsub.visible=false;
			}
			txtnum.text=contentData.gress+"%";
		}
		
		public function getItemHight():Number
		{
			return itemH;
		}
		
		public function set select(value:Boolean):void
		{
			_select=value;;
		}
		
		public function get select():Boolean
		{
			return _select;
		}
		
		public function setY(y:Number):void
		{
			this.y=y;
		}
		
		public function destroy():void
		{
			if(_linqu)
			{
				if(_linqu.parent)
				{
					_linqu.parent.removeChild(_linqu);
				}
				if(_linqu.bitmapData)
				{
					_linqu.bitmapData.dispose();
				}
				_linqu=null;
			}
			
			if(_linqu2)
			{
				if(_linqu2.parent)
				{
					_linqu2.parent.removeChild(_linqu2);
				}
				if(_linqu2.bitmapData)
				{
					_linqu2.bitmapData.dispose();
				}
				_linqu2=null;
			}
			rsrLoader&&rsrLoader.destroy();
			rsrLoader=null;
		}
	}
}