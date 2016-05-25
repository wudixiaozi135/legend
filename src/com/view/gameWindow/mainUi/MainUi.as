package com.view.gameWindow.mainUi
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class MainUi extends Sprite
	{
		protected var _skin:MovieClip;
		
		public function MainUi()
		{
		}
		
		public function initView():void
		{
			var rsrLoader:RsrLoader = new RsrLoader();
			addCallBack(rsrLoader);
			rsrLoader.noQueue = false;//对于主界面元件需要置入队列
			rsrLoader.load(_skin,ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD,false);
		}
		/**添加初始资源加载完成的回调函数*/
		protected function addCallBack(rsrLoader:RsrLoader):void
		{
			//有需要子类重写
		}
		
		public function get skin():MovieClip
		{
			return _skin;
		}
		
		public function isMouseOn():Boolean
		{
			if(!_skin)
			{
				return false;
			}
			var mx:Number = mouseX*scaleX;//返回相对图像的起始点位置
			var my:Number = mouseY*scaleY;
			var result:Boolean = mx > 0 && mx <= width && my > 0 && my <= height;
			if (result)
			{
				try
				{
					var bitmapData:BitmapData = new BitmapData(width,height);
					bitmapData.draw(this);
					result = result && bitmapData.getPixel32(mouseX, mouseY) != 0;
				}
				catch (error:Error)
				{
					
				}
			}
			return result;
		}
	}
}