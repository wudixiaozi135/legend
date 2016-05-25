package com.view.gameWindow.panel.panels.convert
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipExchangeCfgData;
	import com.model.configData.cfgdata.MovieCfgData;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.HighlightEffectManager;
	import com.view.gameWindow.common.MouseOverEffectManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ConvertListItem extends McConvertListItem implements IUrlBitmapDataLoaderReceiver
	{
		private var icon:Bitmap;
		private var _data:EquipExchangeCfgData;
		private var _selected:Boolean;
		private static var NUM_STAR:int = 5;
		private var _callBack:Function;
		private var _index:int;
		private var _type:int;
		public function ConvertListItem(callback:Function,index:int,type:int)
		{
			super();
			_callBack = callback;
			_index = index;
			_type = type;
			txtName.selectable = false;
		}
		
		public function initView():void
		{
			var loader:RsrLoader = new RsrLoader();
			addCallBack(loader);
			loader.load(this,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
			addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			_callBack(_index,-1);
//			selected = true;
		}
		
		private function addCallBack(loader:RsrLoader):void
		{
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
//			filters = _selected ? [redFilter] : null;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set data(value:EquipExchangeCfgData):void
		{
			reset();
			txtName.text = value.name;
			var load:UrlBitmapDataLoader = new UrlBitmapDataLoader(this);
			var url:String = ConfigDataManager.instance.equipCfgData(value.id).icon;
			load.loadBitmap(ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD+url+ResourcePathConstants.POSTFIX_PNG);
			if(value.step>0)
			{
				_data = checkData(value);
			}
			else
			{
				_data = value;
			}
			refreshEquip();
		}
		
		public function get data():EquipExchangeCfgData
		{
			return _data;
		}
		
		private function checkData(value:EquipExchangeCfgData):EquipExchangeCfgData
		{
			// TODO Auto Generated method stub
			var id:int = RoleDataManager.instance.getFireHeartId(_type);
			var cfg:EquipExchangeCfgData = ConfigDataManager.instance.equipExchangeCfgData(id);
			if(cfg&&cfg.step==value.step)
			{
				value = cfg;
			}
			else
			{
				var b:Boolean = cfg&&cfg.step>value.step;
				value = ConvertDataManager.instance.getEquipExchangeStep(value.id,value.step,b)
			}
			return value;
		}
		
		private function reset():void
		{
			// TODO Auto Generated method stub
			txtName.text = "";
			for(var i:int = 1;i<6;i++)
			{
				this["star"+i].visible = false;
				this["stare"+i].visible = false;
			}
			isGet.visible = false;
			selected = false;
		}
		
		private function refreshEquip():void
		{
			// TODO Auto Generated method stub
			var id:int = RoleDataManager.instance.getFireHeartId(_type);
			var cfg:EquipExchangeCfgData = ConfigDataManager.instance.equipExchangeCfgData(id);
			if(cfg&&cfg.step>0){
				
				var str:String = _data.id.toString();
				var num:int;
				if(cfg.step>=_data.step)
					num = _data.current_star;
				for(var i:int = 1;i<6;i++)
				{
					if(i<num+1)
						this["star"+i].visible = true;
					else
						this["stare"+i].visible = true;
				}
			}
			if(cfg)
			{
				if(cfg.step>0)
					isGet.visible = Boolean(id>=_data.id&&_data.current_star == 5);
				else{
					if(_index<5)
						isGet.visible =  Boolean(id>=_data.id);
					else
					{
						id = HeroDataManager.instance.getRings();
						cfg = ConfigDataManager.instance.equipExchangeCfgData(id);
						isGet.visible = Boolean(id>=_data.id);
					}
				}
			}
			
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			if(!icon)
			{
				icon = new Bitmap(bitmapData,"auto",true);
			}
			
//			icon.bitmapData = bitmapData;
			addChild(icon);
			icon.scaleX=48/bitmapData.width;
			icon.scaleY=48/bitmapData.height;
			icon.x = 7;
			icon.y = 6;
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
		}
		
		public function destroy():void
		{
			removeEventListener(MouseEvent.CLICK,onClick);
			if(icon&&icon.parent)
				icon.parent.removeChild(icon);
			if(_callBack!=null)
				_callBack = null;
			_data = null;
		}
	}
}