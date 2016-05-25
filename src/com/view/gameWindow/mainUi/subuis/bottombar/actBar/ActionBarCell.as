package com.view.gameWindow.mainUi.subuis.bottombar.actBar
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.ItemTypeCfgData;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.consts.ConstStorage;
	import com.model.consts.EffectConst;
	import com.model.consts.ToolTipConst;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.bag.DrugCDData;
	import com.view.gameWindow.panel.panels.onhook.AutoDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.skill.SkillData;
	import com.view.gameWindow.panel.panels.skill.SkillDataManager;
	import com.view.gameWindow.panel.panels.skill.constants.SkillConstants;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.UtilColorMatrixFilters;
	import com.view.gameWindow.util.cooldown.CoolDownEffect;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	/**
	 * 动作条单元格类
	 * @author Administrator
	 */	
	public class ActionBarCell extends Sprite implements IUrlBitmapDataLoaderReceiver,IObserver
	{
		private const cellW:int = 48,cellH:int = 48;
		private var _bg:MovieClip;
		private var _bitmap:Bitmap;
		private var _key:int,_id:int,_type:int;
		private var _urlBitmapDataLoader:UrlBitmapDataLoader;
		private var _coolDownEffect:CoolDownEffect;
		private var _cellEffectLoader:UIEffectLoader;
		
		public function ActionBarCell(bg:MovieClip)
		{
			super();
			_bg = bg;
			_bg.mouseChildren = false;
			_bg.mouseEnabled = false;
			_bg.txtNum as TextField ? (_bg.txtNum as TextField).text = "" : null;
			x = _bg.x;
			y = _bg.y;
			_bg.x = 0;
			_bg.y = 0;
			addChild(_bg);
			_coolDownEffect = new CoolDownEffect();
			//
			RoleDataManager.instance.attach(this);
		}
		
		public function refreshData(id:int,type:int):void
		{
			if(_id != id || _type != type)
			{
				_id = id;
				_type = type;
				loadPic(_id,_type);
				resetTips(_id,_type);
			}
			loadEffect();
			if(_type == ActionBarCellType.TYPE_ITEM)
			{
				var num:int = BagDataManager.instance.getItemNumById(id);
				(_bg.txtNum as TextField).text = num+"";
			}
			else
			{
				(_bg.txtNum as TextField).text = "";
			}
		}
		
		private function resetTips(id:int,type:int):void
		{
			ToolTipManager.getInstance().detach(this);
			var tipVO:TipVO = new TipVO();
			if(type == ActionBarCellType.TYPE_ITEM)
			{
				//tips
				tipVO.tipType = ToolTipConst.ITEM_BASE_TIP;
				tipVO.tipData = getItemTipData;
//				tipVO.tipCount = 
				ToolTipManager.getInstance().hashTipInfo(this,tipVO);
				ToolTipManager.getInstance().attach(this);
			}
			else if(type == ActionBarCellType.TYPE_SKILL)
			{
				//tips
				tipVO.tipType = ToolTipConst.SKILL_TIP;
				tipVO.tipData = getSkillTipData;
				tipVO.tipDataValue = id;
				ToolTipManager.getInstance().hashTipInfo(this,tipVO);
				ToolTipManager.getInstance().attach(this);
			}
		}
		
		private function getSkillTipData(id:int):SkillCfgData
		{
			var skillData:SkillData = SkillDataManager.instance.skillData(id);
			if(!skillData)
			{
				trace("in ActionBarCell.loadPic 不存在的id:"+id);
				return null;
			}
			var skillCfgData:SkillCfgData = ConfigDataManager.instance.skillCfgData(0,0,id,skillData.level);
			if(!skillCfgData)
			{
				trace("in ActionBarCell.loadPic 不存在的id:"+id);
				return null;
			}
			
			return skillCfgData;
		}
		
		private function getItemTipData():ItemCfgData
		{
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(_id);
			return itemCfgData;
		}
		
		private function loadPic(id:int,type:int):void
		{
			ToolTipManager.getInstance().detach(this);
			
			var url:String;
			if(type == ActionBarCellType.TYPE_ITEM)
			{
				var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(id);
				if(!itemCfgData)
				{
					trace("in ActionBarCell.loadPic 不存在的id:"+id);
					return;
				}
				url = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD+itemCfgData.icon+ResourcePathConstants.POSTFIX_PNG;
			}
			else if(type == ActionBarCellType.TYPE_SKILL)
			{
				var skillData:SkillData = SkillDataManager.instance.skillData(id);
				if(!skillData)
				{
					trace("in ActionBarCell.loadPic 不存在的id:"+id);
					return;
				}
				var skillCfgData:SkillCfgData = ConfigDataManager.instance.skillCfgData(0,0,id,skillData.level);
				if(!skillCfgData)
				{
					trace("in ActionBarCell.loadPic 不存在的id:"+id);
					return;
				}
				url = ResourcePathConstants.IMAGE_ICON_SKILL_FOLDER_LOAD+skillCfgData.icon+ResourcePathConstants.POSTFIX_PNG;
			}
			_urlBitmapDataLoader = new UrlBitmapDataLoader(this);
			_urlBitmapDataLoader.loadBitmap(url);
		}
		
		public function loadEffect():void
		{
			destroyEffect();
			if(type == ActionBarCellType.TYPE_SKILL)
			{
				var cfgDt:SkillCfgData = getSkillTipData(_id);
				var isSkillOpen:Boolean = isSkillOpen(cfgDt);
				if(isSkillOpen)
				{
					var theX:int = x + width/2-2;
					var theY:int = y + height/2-4;
					_cellEffectLoader = new UIEffectLoader(parent as MovieClip,theX,theY,/*cellW/60*/1,/*cellH/60*/1,EffectConst.RES_SKILL_SWITCH);
				}
			}
		}
		
		private function isSkillOpen(cfgDt:SkillCfgData):Boolean
		{
			if(!cfgDt)
			{
				return false;
			}
			var manager:AutoDataManager = AutoDataManager.instance;
			if(cfgDt.group_id == SkillConstants.ZS_BYWD)
			{
				return Boolean(manager.quickSetState[0]);
			}
			else if(cfgDt.group_id == SkillConstants.ZS_CSJS)
			{
				return Boolean(manager.quickSetState[1]);
			}
			return false;
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
			{
				_bitmap.bitmapData.dispose();
			}
			if(_bitmap && _bitmap.parent)
			{
				_bitmap.parent.removeChild(_bitmap);
			}
			_bitmap = new Bitmap(bitmapData,"auto",true);
			_bitmap.x = _bitmap.y = 4;
			_bitmap.width = cellW;
			_bitmap.height = cellH;
			_bg.addChildAt(_bitmap,1);
			update(GameServiceConstants.SM_CHR_INFO);
			playCoolDownEffect();
			destroyLoader();
		}
		
		private function destroyLoader():void
		{
			if(_urlBitmapDataLoader)
				_urlBitmapDataLoader.destroy();
			_urlBitmapDataLoader = null;
		}
		/**
		 * 播放扇形冷却特效
		 */
		public function playCoolDownEffect(duration:int = 0):void
		{
			if(!_id)
			{
				return;
			}
			var initAngle:Number = -90; 
			var durationAngle:Number = 360;
			var skillCDAfter:int;
			var checkSkillCd:Boolean
			if(duration == 0)
			{
				if(_type == ActionBarCellType.TYPE_ITEM)
				{
					var cd:Array = DrugCDData.drugCDChr(ConstStorage.ST_CHR_BAG);
					var timer:int = getTimer();
					var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(id);
					var item:ItemTypeCfgData = ConfigDataManager.instance.itemTypeCfgData(itemCfgData.type); 
					if(!cd[item.id])return;
					skillCDAfter = timer - cd[item.id];
					checkSkillCd = (cd[item.id]+item.cd<=timer);
					duration = (!checkSkillCd && (item.cd > skillCDAfter)) ? (item.cd - skillCDAfter) : 0;
					initAngle = initAngle + durationAngle * (1 - duration / item.cd);
					durationAngle = durationAngle * duration / item.cd;
				}
				else if(_type == ActionBarCellType.TYPE_SKILL)
				{
					var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
					if (!firstPlayer)
					{
						return;
					}
					var skillData:SkillData = SkillDataManager.instance.skillData(_id);
					if (!skillData || skillData.level <= 0)
					{
						return;
					}
					var skillCfgData:SkillCfgData = ConfigDataManager.instance.skillCfgData(firstPlayer.job, firstPlayer.entityType, _id, skillData.level);
					if (!skillCfgData)
					{
						return;
					}
					checkSkillCd = SkillDataManager.instance.checkSkillCd(skillCfgData);
					skillCDAfter = SkillDataManager.instance.skillCDAfter(_id);
					duration = (!checkSkillCd && (skillCfgData.cd > skillCDAfter)) ? (skillCfgData.cd - skillCDAfter) : 0;
					initAngle = initAngle + durationAngle * (1 - duration / skillCfgData.cd);
					durationAngle = durationAngle * duration / skillCfgData.cd;
					/*trace("ActionBarCell.playCoolDownEffect(duration) name:"+skillCfgData.name);
					trace("ActionBarCell.playCoolDownEffect(duration) duration:"+duration);
					trace("ActionBarCell.playCoolDownEffect(duration) initAngle:"+initAngle);
					trace("ActionBarCell.playCoolDownEffect(duration) durationAngle:"+durationAngle);*/
				}
			}
			_coolDownEffect.stop();
			if(duration)
			{
				_coolDownEffect.play(_bitmap,duration,initAngle,durationAngle);
			}
		}
		
		public function getBitmap():Bitmap
		{
			if(_bitmap && _bitmap.parent)
			{
				_bitmap.parent.removeChild(_bitmap);
				_id = 0;
				_type = 0;
				(_bg.txtNum as TextField).text = "";
			}
			var temp:Bitmap = _bitmap;
			temp.x = temp.y = 0;
			_bitmap = null;
			destroyEffect();
			_coolDownEffect.stop();
			return temp;
		}
		
		public function setBitmap(value:Bitmap,id:int,type:int):void
		{
			if(_id != id || _type != type)
			{
				_id = id;
				_type = type;
				value.x = 0;
				value.y = 0;
				_bitmap = value;
				_bitmap.x = _bitmap.y = 4;
				_bg.addChildAt(_bitmap,1);
				update(GameServiceConstants.SM_CHR_INFO);
				if(_type == ActionBarCellType.TYPE_ITEM)
				{
					var num:int = BagDataManager.instance.getItemNumById(id);
					(_bg.txtNum as TextField).text = num+"";
				}
				else
				{
					(_bg.txtNum as TextField).text = "";
				}
				loadEffect();
				playCoolDownEffect();
			}
		}
		
		public function setNull():void
		{
			destroyEffect();
			if(_bitmap && _bitmap.bitmapData)
				_bitmap.bitmapData.dispose();
			if(_bitmap && _bitmap.parent)
				_bitmap.parent.removeChild(_bitmap);
			_bitmap = null;
			_id = 0;
			_type = 0;
			(_bg.txtNum as TextField).text = "";
			ToolTipManager.getInstance().detach(this);
		}
		
		public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_CHR_INFO)
			{
				if(_bitmap)
				{
					var isEnough:Boolean = true;
					if(_type == ActionBarCellType.TYPE_SKILL)
					{
						var skillCfgData:SkillCfgData = SkillDataManager.instance.skillCfgData(_id);
						isEnough = SkillDataManager.instance.checkSkillMpCost(skillCfgData);
					}
					else if(_type == ActionBarCellType.TYPE_ITEM)
					{
						/*var num:int = BagDataManager.instance.getItemNumById(_id);
						isEnough = num > 1;*/
					}
					if(isEnough)
					{
						_bitmap.filters = null;
					}
					else
					{
						_bitmap.filters = UtilColorMatrixFilters.GREY_FILTERS;
					}
				}
			}
		}
		
		private function destroyEffect():void
		{
			if(_cellEffectLoader)
			{
				_cellEffectLoader.destroy();
				_cellEffectLoader = null;
			}
		}
		
		public function destroy():void
		{
			RoleDataManager.instance.detach(this);
			destroyLoader();
			setNull();
			_coolDownEffect = null;
			_bg = null;
		}
		
		public function get key():int
		{
			return _key;
		}
		
		public function set key(value:int):void
		{
			_key = value;
			(_bg.txtKey as TextField).text = ActionBarCellType.getKeyString(_key);
		}
		
		public function get isEmpty():Boolean
		{
			return _bitmap == null;
		}
		
		public function get isInCd():Boolean
		{
			if(!_id)
			{
				return false;
			}
			var skillCfgData:SkillCfgData = SkillDataManager.instance.skillCfgData(_id);
			var boolean:Boolean = !SkillDataManager.instance.checkSkillCd(skillCfgData);
			return boolean;
		}
		/**技能组id或物品id*/
		public function get id():int
		{
			return _id;
		}
		
		public function get type():int
		{
			return _type;
		}
	}
}