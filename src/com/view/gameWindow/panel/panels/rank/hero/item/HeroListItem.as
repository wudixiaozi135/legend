package com.view.gameWindow.panel.panels.rank.hero.item
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.consts.JobConst;
	import com.model.consts.SexConst;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.ResManager;
	import com.view.gameWindow.panel.panels.rank.data.RankMemberData;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class HeroListItem extends McItem
	{
		private var _data:RankMemberData;
		private const NO_SCHOOL:int=0;
		private var icon:Bitmap;
		public function HeroListItem()
		{
			super();
		}
		
		public function update(data:RankMemberData):void
		{
			_data=data;
			
			if(data.rank<=3)
			{
				txt1.visible=false;
				initTop3Icon();
			}else
			{
				clearTop3Icon();
				txt1.visible=true;
				txt1.text=data.rank+"";
			}
			
			var color:int=initColor();
			txt2.htmlText=HtmlUtils.createHtmlStr(color,data.name+StringConst.NPC_TASK_PANEL_0004);
//			if(data.reincarn>0)
//			{
//				txt3.htmlText=HtmlUtils.createHtmlStr(color,StringUtil.substitute(StringConst.TEAM_PANEL_00025,data.reincarn,data.level));
//			}else
//			{
//			txt3.htmlText=HtmlUtils.createHtmlStr(color,data.level+StringConst.ROLE_PROPERTY_PANEL_0072);
//			}
			txt4.htmlText=HtmlUtils.createHtmlStr(color,JobConst.jobName(data.job));
			txt5.htmlText=HtmlUtils.createHtmlStr(color,SexConst.sexName(data.sex));
		}
		
		private function initColor():int
		{
			var color:int=0;
			if(data.rank==1)
			{
				color=0xa616b6;
			}
			else if(data.rank==2)
			{
				color=0x00a2ff;
			}
			else if(data.rank==3)
			{
				color=0x53b436;
			}else
			{
				color=0xd4a460;
			}
			return color;
		}
		
		private function clearTop3Icon():void
		{
			if(icon!=null)
			{
				icon.bitmapData&&icon.bitmapData.dispose();
				icon.parent&&icon.parent.removeChild(icon);
				icon=null;
			}
		}
		
		private function initTop3Icon():void
		{
			var url:String = ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD+"rank/icon"+_data.rank+ResourcePathConstants.POSTFIX_PNG
			if(icon==null)
			{
				icon=new Bitmap();
				addChild(icon);
				icon.x=5;
				icon.y=-3.5;
			}
			ResManager.getInstance().loadBitmap(url,loadIconComple);
		}		
		
		private function loadIconComple(bitmap:BitmapData,url:String):void
		{
			if(icon)
			{
				icon.bitmapData&&icon.bitmapData.dispose();
				icon.bitmapData=bitmap;
			}else
			{
				bitmap.dispose();
			}
		}
		
		public function get data():RankMemberData
		{
			return _data;
		}

		public function destroy():void
		{
			clearTop3Icon();
		}
	}
}