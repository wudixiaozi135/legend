package com.view.gameWindow.panel.panels.hero.tab3
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.view.gameWindow.common.ResManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.hero.tab3.chest.HeroFashionChest;
	import com.view.gameWindow.util.FilterUtil;
	import com.view.gameWindow.util.PageListData;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class HeroImageHandler
	{

		private var _heroImageTab:HeroImageTab;

		private var skin:mcHeroImageTab;
		private const chestCount:int=4;

		private var chestSprite:Sprite;

		private var fashionName:Bitmap;
		public function HeroImageHandler(heroImageTab:HeroImageTab)
		{
			this._heroImageTab = heroImageTab;
			skin = heroImageTab.skin as mcHeroImageTab;
			initChest();
		}
		
		private function initChest():void
		{
			chestSprite=new Sprite();
			chestSprite.x=11;
			chestSprite.y=39;
			skin.addChild(chestSprite);
			
			for (var i:int=0;i<chestCount;i++)
			{
				var c:HeroFashionChest=new HeroFashionChest();
				c.y=101*i;
				chestSprite.addChild(c);
			}
			
			fashionName=new Bitmap();
			skin.addChild(fashionName);
			fashionName.x=572;
			fashionName.y=3;
		}
		
		public function updateChest():void
		{
			var heroChestPage:PageListData = HeroDataManager.instance.heroChestPage;
			var getCurrentPageData:Array = heroChestPage.getCurrentPageData();
			for (var i:int=0;i<chestCount;i++)
			{
				var heroFashionChest:HeroFashionChest = chestSprite.getChildAt(i) as HeroFashionChest;
				if(i>=getCurrentPageData.length)
				{
					heroFashionChest.setNull();
				}else
				{
					heroFashionChest.setFashion(getCurrentPageData[i]);
				}
				if(HeroDataManager.instance.fashionId!=0&&heroFashionChest.id==HeroDataManager.instance.fashionId)
				{
					_heroImageTab.setSelect(heroFashionChest);
				}
			}
			skin.upBtn.btnEnabled=heroChestPage.hasPre();
			skin.downBtn.btnEnabled=heroChestPage.hasNext();
			updateAttr();
		}
		
		public function updateAttr():void
		{
			var currentId:int =0;
			if(HeroDataManager.instance.currentSelectChest!=null)
			{
				currentId=HeroDataManager.instance.currentSelectChest.id;
			}
			if(HeroDataManager.instance.fashionUse==false)
			{
				currentId=0;
			}
			if(HeroDataManager.instance.fashionId!=0&&HeroDataManager.instance.currentSelectChest&&HeroDataManager.instance.currentSelectChest.id==HeroDataManager.instance.fashionId)
			{
				skin.btnNoSelect.visible=true;
				skin.btnSelect.visible=false;
			}
			else
			{
				skin.btnNoSelect.visible=false;
				skin.btnSelect.visible=true;
			}
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(currentId);
			if(equipCfgData==null)
			{
				skin.txtv1.htmlText="";
			}else
			{
				var vectorS:Vector.<String> = CfgDataParse.getAttHtmlStringArray(equipCfgData.attr);
				skin.txtv1.htmlText=CfgDataParse.VectorToString(vectorS);
				var url:String=ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD+equipCfgData.name_url+ResourcePathConstants.POSTFIX_PNG;
				ResManager.getInstance().loadBitmap(url,onLoadNameCallBack);
			}
			
			var heroFashionChes:Array = HeroDataManager.instance.heroFashionChes;
			var attrs:Vector.<String> = new Vector.<String>();
			for each(var cheId:int in heroFashionChes)
			{
				 var equipCfgData2:EquipCfgData = ConfigDataManager.instance.equipCfgData(cheId);
				 attrs.push(equipCfgData2.attr);
			}
			if(attrs.length>0)
			{
				var vecAttrs:Vector.<String> = CfgDataParse.getAttHtmlStringArray2(attrs);
				skin.txtv2.htmlText=CfgDataParse.VectorToString(vecAttrs); 
			}else
			{
				skin.txtv2.htmlText="";
			}
			attrs.splice(0,attrs.length);
			attrs=null;
		}
		
		private function onLoadNameCallBack(bitmap:BitmapData,url:String):void
		{
			if(fashionName==null)
			{
				bitmap.dispose();
			}else
			{
				fashionName.bitmapData=bitmap;
			}
		}
		
		public function destroy():void
		{
			if(fashionName)
			{
				fashionName.parent&&fashionName.parent.removeChild(fashionName);
				fashionName.bitmapData&&fashionName.bitmapData.dispose();
			}
			fashionName=null;
			if(chestSprite)
			{
				chestSprite.parent&&chestSprite.parent.removeChild(chestSprite);
				while(chestSprite.numChildren>0)
				{
					var chest:HeroFashionChest = chestSprite.removeChildAt(0) as HeroFashionChest;
					chest.destroy();
					chest=null;
				}
			}
			chestSprite=null;
		}
	}
}