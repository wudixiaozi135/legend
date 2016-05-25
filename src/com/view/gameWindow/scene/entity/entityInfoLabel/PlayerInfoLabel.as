package com.view.gameWindow.scene.entity.entityInfoLabel
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.view.gameWindow.scene.entity.entityInfoLabel.interf.ILivingUnitInfoLabel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.geom.Point;
	
	public class PlayerInfoLabel extends LivingUnitInfoLabel implements ILivingUnitInfoLabel,IUrlBitmapDataLoaderReceiver
	{
		private var _vip:int;
		
		public function PlayerInfoLabel()
		{
			super();
		}
		
		public override function refreshNameTextContent(nameTxt:TextField):void
		{
			if(!nameTxt)
			{
				return;
			}
			if (!_nameTxtBitmap)
			{
				_nameTxtBitmap = new Bitmap();
			}
			if (_nameTxtBitmap.bitmapData)
			{
				_nameTxtBitmap.bitmapData.dispose();
			}
			
			if(vip>0)
			{
				var vipUrl:String=ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD+"vip/";
				if(vip<4)
				{
					vipUrl+="V_1.png";
				}else if(vip<7)
				{
					vipUrl+="V_2.png";
				}else
				{
					vipUrl+="V_3.png";
				}
				var rec:Rectangle = nameTxt.getCharBoundaries(nameTxt.text.indexOf("[VIP]"));
				nameTxt.htmlText=nameTxt.htmlText.replace("[VIP]","&nbsp;&nbsp;");
				var urlBitmapDataLoader:UrlBitmapDataLoader = new UrlBitmapDataLoader(this);
				urlBitmapDataLoader.loadBitmap(vipUrl,rec);
			}
			_nameTxtBitmap.bitmapData = new BitmapData(nameTxt.width, nameTxt.height, true, 0x00000000);
			_nameTxtBitmap.bitmapData.draw(nameTxt);
		}
		
		public override function refreshNameTextPos(nameTxt:TextField, modelHeight:int):void
		{
			if (_nameTxtBitmap)
			{
				if (_nameTxtBitmap.y != -modelHeight)
				{
					_nameTxtBitmap.y = -modelHeight;
				}
				
				var xPos:Number = -_nameTxtBitmap.width / 2;
				if (_nameTxtBitmap.x != xPos)
				{
					_nameTxtBitmap.x = xPos;
				}
				if (!_nameTxtBitmap.parent)
				{
					addChild(_nameTxtBitmap);
				}
			}
		}

		public function get vip():int
		{
			return _vip;
		}

		public function set vip(value:int):void
		{
			_vip = value;
		}

		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			var rectangle:Rectangle = info as Rectangle;
			if(_nameTxtBitmap&&_nameTxtBitmap.bitmapData!=null&&rectangle!=null)
			{
				var topLeft:Point = rectangle.topLeft;
				topLeft.offset(0,-2);
				_nameTxtBitmap.bitmapData.copyPixels(bitmapData,bitmapData.rect,topLeft,null,null,true);
			}
			else
			{
				bitmapData.dispose();
				info=null;
			}
		}
	}
}