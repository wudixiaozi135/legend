package com.view.gameWindow.panel.panels.buff
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.ServerTime;
	import com.view.gameWindow.util.TimeUtils;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @author wqhk
	 * 2014-9-15
	 */
	public class BuffView extends Sprite implements IUrlBitmapDataLoaderReceiver
	{
		private var _icon:IconCellEx;
		private var _data:BuffData;
		private var _timeDes:TextField;
		private var _size:Number;
		private var _isWaitingDestroy:Boolean = false;
		private var _border:Shape;
		private var bmp:Bitmap;
		public function BuffView(size:Number = 40)
		{
			_size = size;
			super();
			drawBg();
		}
		
		public function drawBg():void
		{
			var loader:UrlBitmapDataLoader = new UrlBitmapDataLoader(this);
			var url:String = ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD+"rolehead/buff.png";
			loader.loadBitmap(url);
		}
		
		public function drawBorder(color:uint = 0x0070c0):void
		{
//			if(!_border)
//			{
//				_border = new Shape();
//				addChild(_border);
//			}
//			
//			_border.graphics.clear();
//			_border.graphics.lineStyle(2,color,1,false,"normal",null,JointStyle.MITER);
//			_border.graphics.beginFill(0,0);
//			_border.graphics.drawRect(0,0,_size,_size);
//			_border.graphics.endFill();
		}
		
		public function get isWaitingDestroy():Boolean
		{
			return _isWaitingDestroy;
		}
		
		public function get data():BuffData
		{
			return _data;
		}
		
		public function set data(value:BuffData):void
		{
			_data = value;
			
			ToolTipManager.getInstance().detach(this);
			if(_data)
			{
				visible = Boolean(_data.cfg.show);
				if(!_icon)
				{
					_icon = new IconCellEx(this,0,0,_size,_size);
//					addChildAt(_icon,0);
					
					drawBorder();
				}
				
				if(visible)
				{
					_icon.url = ResourcePathConstants.IMAGE_ICON_BUFF_FOLDER_LOAD+_data.cfg.icon+ResourcePathConstants.POSTFIX_PNG;
				}
				
				
//				if(!_timeDes)
//				{
//					_timeDes = new TextField();
//					_timeDes.selectable = false;
//					_timeDes.width = _size;
//					_timeDes.y = _size - 15;
//					_timeDes.defaultTextFormat = new TextFormat(FontFamily.FONT_NAME,12,0xffc000,null,null,null,null,null,TextAlign.CENTER);
//					_timeDes.filters = [new GlowFilter(0x0,1,2,2,10)];
//					_timeDes.text = " ";
//					_timeDes.height = _timeDes.textHeight+3;
//					addChild(_timeDes);
//				}
				
				var tipVO:TipVO = new TipVO();
				tipVO.tipData = getTooltipData;
				tipVO.tipType = ToolTipConst.TEXT_TIP;
				ToolTipManager.getInstance().hashTipInfo(this,tipVO);
				ToolTipManager.getInstance().attach(this);
			}
			
		}
		
		public function destroy():void
		{
			if(_icon)
			{
				_icon.destroy();
				_icon = null;
			}
			ToolTipManager.getInstance().detach(this);
		}
		
		public function getTooltipData():String
		{
			if(!_data)
			{
				return "";
			}
			
//			var re:String = HtmlUtils.createHtmlStr(0x00ff00,_data.cfg.name,14,true);
//			re += HtmlUtils.createHtmlStr(0xffffff,_data.cfg.desc);
			var re:String = CfgDataParse.pareseDesToStr(_data.cfg.desc);
			if(timeDes)
			{
				re += "\n"+HtmlUtils.createHtmlStr(0x00ff00,timeDes);
			}
			return re;
		}
		
		private var timeDes:String;
		
		public function updateTime():void
		{
			if(_data)
			{
				if(_data.endtime > 0)
				{
					var time:int = _data.endtime - ServerTime.time;
					var timeObj:Object = TimeUtils.calcTime(time);
//					_timeDes.text = TimeUtils.formatS(timeObj);
					if (timeObj.day > TimeUtils.TEN_YEAR_DAYS)
					{
						timeDes = StringConst.TIP_FOREVER;
					} else
					{
						timeDes = TimeUtils.formatS(timeObj);
					}
					ToolTipManager.getInstance().updateTipData(this);
					
					if(time>0)
					{
						_isWaitingDestroy = false;
					}
					else
					{
						_isWaitingDestroy = true;
					}
				}
				else
				{
//					_timeDes.text = StringConst.TIP_FOREVER;
					timeDes = "";
				}
				
			}
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			bmp= new Bitmap(bitmapData,"auto",true);
			addChildAt(bmp,0);
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			
		}
		
	}
}