package com.view.gameWindow.tips.toolTip
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.EquipDuijieSuitCfgData;
	import com.model.configData.cfgdata.EquipPolishAttrCfgData;
	import com.model.configData.cfgdata.EquipRecycleCfgData;
	import com.model.configData.cfgdata.EquipStrengthenAttrCfgData;
	import com.model.configData.cfgdata.EquipSuitAttrCfgData;
	import com.model.consts.ConstBind;
	import com.model.consts.FontFamily;
	import com.model.consts.ItemType;
	import com.model.consts.JobConst;
	import com.model.consts.RolePropertyConst;
	import com.model.consts.SexConst;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.mem.AttrRandomData;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.UtilGetStrLv;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	import com.view.gameWindow.util.propertyParse.PropertyData;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mx.utils.StringUtil;
	
	/**
	 * 装备tip
	 * @author jhj
	 */
	public class EquipBaseTip extends BaseTip 
	{
		public static const NAME_X:int = 16;
		public static const NAME_Y:int = 16;
		public static const BIND_X:int = 220;
		public static const BIND_Y:int = 16;
		public static const EQUIPED_X:int = 9;
		public static const EQUIPED_Y:int = 36;
		
		private var equipCfgData:EquipCfgData;
		/**出售价格  */		
		private var sellPriceText:TextField;
		private var equipNameText:TextField;
		private var strengthenText:TextField;
		/**剩余时间  */		
		private var delayTimeText:TextField;
		private var equipedMC:MovieClip;
		/**穿戴条件字段 */		
		private var wearConditionArr:Array=[StringConst.LEVEL_NEED,StringConst.SEX_NEED,
			StringConst.JOB_NEED,StringConst.ENTITY_NEED,StringConst.LOAD,StringConst.DURABILITY];
		
		private var _durationTxt:TextField;
		
		public var fightFlag:TextField;
		public var fight:Number = 0;
		public var fightOther:Number = 0;
		
		private var _cellEffectLoader:UIEffectLoader;
		
		//基础属性
		private var _basePropertyList:Vector.<PropertyData>;
		private var _baseProtertyView:Vector.<TextField>;
		//
		private var _strengthenList:Vector.<PropertyData>;
		private var _strengthenView:Vector.<TextField>;
		//
		private var _polishList:Vector.<PropertyData>;
		private var _polishView:Vector.<TextField>;
		//
		private var _attrRdView:Vector.<TextField>;
		
		private var _url:String;

		private var _tipType:int;
		
		public function get basePropertyList():Vector.<PropertyData>
		{
			return _basePropertyList;
		}
		
		public function get strengthenList():Vector.<PropertyData>
		{
			return _strengthenList;
		}
		
		public function get polishList():Vector.<PropertyData>
		{
			return _polishList;
		}
		
		public function EquipBaseTip(tipType:int)
		{
			_tipType = tipType;
			_basePropertyList = new Vector.<PropertyData>();
			_baseProtertyView = new Vector.<TextField>();
			_strengthenList = new Vector.<PropertyData>();
			_strengthenView = new Vector.<TextField>();
			_polishList = new Vector.<PropertyData>();
			_polishView = new Vector.<TextField>();
			
			_attrRdView = new Vector.<TextField>();
			
			super();
			initView(_skin);
		}
		
		override public function initView(mc:MovieClip):void
		{
			_skin = new BaseEquipTipSkin();
			addChild(_skin);
			maxWidth = _skin.width;
			super.initView(_skin);
			drawUI();
		}
		
		private function drawUI():void
		{
			/*var equipFightText:TextField = new TextField();
			equipFightText.x = 84;
			equipFightText.y = -5;
			equipFightText.text = "装备战力:553 ↑ 336";
			var tf:TextFormat = new TextFormat("SimSun",12,0xff6600);
			equipFightText.defaultTextFormat = tf;
			equipFightText.setTextFormat(tf);
			equipFightText.filters = [_filter];
			equipFightText.autoSize = TextFieldAutoSize.LEFT;
			addChild(equipFightText);*/
		}
		
		override protected function addCallBack(mc:MovieClip, rsrLoader:RsrLoader):void
		{
			if(mc is Stars || mc is StarsAttrRd)
			{
				rsrLoader.addCallBack(mc.star,function():void
				{
					mc.star.gotoAndStop(mc.name);
				});
			}
		}
		
		override public function setData(obj:Object):void
		{
			_data = obj;
			
			_basePropertyList = new Vector.<PropertyData>();
			_baseProtertyView = new Vector.<TextField>();
			_strengthenList = new Vector.<PropertyData>();
			_strengthenView = new Vector.<TextField>();
			_polishList = new Vector.<PropertyData>();
			_polishView = new Vector.<TextField>();
			
			_attrRdView = new Vector.<TextField>();
			
			var memEquipData:MemEquipData = obj as MemEquipData;
			equipCfgData = obj as EquipCfgData;
			
			if(memEquipData)
			{
				equipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
			}
			
			if(!equipCfgData)
			{
				return;
			}
			
			setEquipName(equipCfgData,memEquipData ? memEquipData.bind : 0);
			if(memEquipData)
			{
				setEquipLevel(memEquipData.strengthen);
				setPolishLevel(memEquipData.polish);
			}
			setIconPos();
			setLimitProperty(equipCfgData,memEquipData);
			if(memEquipData)//星
			{
				setStars(memEquipData.strengthenStars());
			}
			
			setEquipProperty(equipCfgData,memEquipData);
			if(memEquipData)
			{
				fightOther = 0;
				setStrengthProperty(memEquipData,equipCfgData);
				setPolishProperty(memEquipData,equipCfgData);
				setRdProperty(memEquipData);
				setStrengthPropertyNext(memEquipData,equipCfgData);
			}
			setEquipSuitAttr(equipCfgData,memEquipData);
			if(equipCfgData.type==ConstEquipCell.TYPE_HUANJIE)
			{
				addDuijieSuitAttr(equipCfgData,memEquipData);
			}
			/*setFightPower();*///不显示战斗力
			setOtherProperty(equipCfgData,memEquipData);
			maxHeight += 10;
			
			setEquipRecycle(equipCfgData);
			maxHeight += 13;
			
			height = maxHeight;
			
			var url:String = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD+equipCfgData.icon+ResourcePathConstants.POSTFIX_PNG;
			if(url != _url)
			{
				_url = url;
				loadPic(_url);
			}
			width = maxWidth ? maxWidth : width;
		}
		
		private function setEquipRecycle(equipCfgData:EquipCfgData):void
		{
			var equipRecycleCfgData:EquipRecycleCfgData = ConfigDataManager.instance.equipRecycleCfgData(equipCfgData.type,equipCfgData.quality,equipCfgData.level);
			if(equipRecycleCfgData==null)return;
			if(equipRecycleCfgData.is_operation==1||equipRecycleCfgData.is_operation==3)
			{
				addText(HtmlUtils.createHtmlStr(0x009900,StringUtil.substitute(StringConst.RESOLVE_PANEL_0010,equipRecycleCfgData.exp)),15,maxHeight);
				maxHeight+=15;
			}
			if(equipRecycleCfgData.is_operation==2||equipRecycleCfgData.is_operation==3)
			{
				addText(HtmlUtils.createHtmlStr(0x009900,StringUtil.substitute(StringConst.RESOLVE_PANEL_0011,equipRecycleCfgData.family_contribute)),15,maxHeight);
				maxHeight+=15;
			}
		}		
		
		protected function setEquipName(equipCfgData:EquipCfgData,bind:int = 0):void
		{ 
			var color:int = ItemType.getColorByQuality(equipCfgData.color);
			var htmlStr:String = HtmlUtils.createHtmlStr(color,getPrefixName(equipCfgData.color)+equipCfgData.name,15,true);
			equipNameText = addText(htmlStr,NAME_X,NAME_Y);
			maxHeight = NAME_Y + equipNameText.height + 6;
			
			if(bind == ConstBind.HAS_BIND)
			{
				addText(HtmlUtils.createHtmlStr(0xff0000,StringConst.TYPE_BIND_2,12),BIND_X,BIND_Y);
			}
		}
		
		private function getPrefixName(quality:int):String
		{
			if(quality<=1)
			{
				return "";
			}
			else if(quality==2)
			{
				return StringConst.TIP_PREFIX_NAME_1;
			}
			else if(quality==5)
			{
				return StringConst.TIP_PREFIX_NAME_2;
			}
			else if(quality==6)
			{
				return StringConst.TIP_PREFIX_NAME_3;
			}
			else if(quality==7)
			{
				return StringConst.TIP_PREFIX_NAME_4;
			}
			else if(quality==8)
			{
				return StringConst.TIP_PREFIX_NAME_5;
			}
			else
			{
				return "";
			}
		}
		
		protected function setEquipLevel(level:int):void
		{
			if(level<=0)
			{
				return;
			}
			var htmlStr:String = HtmlUtils.createHtmlStr(ItemType.getColorByQuality(equipCfgData.color),"+"+level,15,true);
			var strengthenX:int = equipNameText.x+equipNameText.textWidth+6;
			var strengthenY:int = equipNameText.y-1;
			strengthenText = addText(htmlStr,strengthenX,strengthenY);
		}
		
		protected function setPolishLevel(level:int):void
		{
			if(level<=0)
			{
				return;
			}
			if(!strengthenText)
			{
				return;
			}
			var htmlStr:String = HtmlUtils.createHtmlStr(0x00cece,StringConst.POLISH+" +"+level,15,true);
			var polishX:int = strengthenText.x + strengthenText.textWidth + 6;
			var polishY:int = strengthenText.y;
			addText(htmlStr,polishX,polishY);
		}
		
		private function setIconPos():void
		{
			var skin:BaseEquipTipSkin = _skin as BaseEquipTipSkin;
			skin.mcIcon.y = 40;
			maxHeight = skin.mcIcon.y + skin.mcIcon.height + 6;
		}
		
		private function setLimitProperty(equipCfgData:EquipCfgData,memEquipData:MemEquipData):void
		{
			var color:int; 
			var htmlStr:String;
			var htmlStrArr:Array = [];
			htmlStr = HtmlUtils.createHtmlStr(0xaeaeae,StringConst.EQUIP_TYPE+StringConst.COLON,12)+HtmlUtils.createHtmlStr(0xaeaeae,ConstEquipCell.getEquipName(equipCfgData.type),12);
			htmlStrArr.push(htmlStr);
			
			var durationStr:String = "";
			
			for(var i:int = 0;i<wearConditionArr.length;i++)
			{
				var propertyName:String = wearConditionArr[i];
				
				switch(propertyName)
				{
					case StringConst.LEVEL_NEED:
						var boolean:Boolean;
						if(ToolTipConst.isHeroTips(_tipType))
						{
							boolean = HeroDataManager.instance.checkReincarnLevel(equipCfgData.reincarn,equipCfgData.level);
						}
						else
						{
							boolean = RoleDataManager.instance.checkReincarnLevel(equipCfgData.reincarn,equipCfgData.level);
						}
						color = boolean ? 0x70ad47 : 0xff0000;
						var levelDes:String = UtilGetStrLv.strReincarnLevel(equipCfgData.reincarn,equipCfgData.level);
						htmlStr = HtmlUtils.createHtmlStr(0xaeaeae,propertyName+StringConst.COLON,12)+HtmlUtils.createHtmlStr(color,levelDes,12);
						htmlStrArr.push(htmlStr);
						break;
					case StringConst.JOB_NEED:
						var job:int = !ToolTipConst.isHeroTips(_tipType) ? RoleDataManager.instance.job : HeroDataManager.instance.job;
						color = job == equipCfgData.job || equipCfgData.job == JobConst.TYPE_NO ? 0x70ad47 : 0xff0000 ;
						var jobName:String = JobConst.jobName(equipCfgData.job);
						htmlStr = HtmlUtils.createHtmlStr(0xaeaeae,propertyName+StringConst.COLON,12)+HtmlUtils.createHtmlStr(color,jobName,12);
						htmlStrArr.push(htmlStr);
						break;
					case StringConst.SEX_NEED:
						if(equipCfgData.sex == SexConst.TYPE_NO)
						{
							continue;
						}
						var sexName:String = SexConst.sexName(equipCfgData.sex);
						var sex:int = !ToolTipConst.isHeroTips(_tipType)? RoleDataManager.instance.sex : HeroDataManager.instance.sex;
						var sexColor:int = sex == equipCfgData.sex || equipCfgData.sex == SexConst.TYPE_NO? 0x70ad47 : 0xff0000 ;
						htmlStr = HtmlUtils.createHtmlStr(0xaeaeae,propertyName+StringConst.COLON,12)+HtmlUtils.createHtmlStr(sexColor,sexName,12);
						htmlStrArr.push(htmlStr);
						break;
					/*case StringConst.LOAD:
						if(equipCfgData.load == 0)
						{
							continue;
						}
						htmlStr = HtmlUtils.createHtmlStr(0xaeaeae,propertyName+StringConst.COLON,12)+HtmlUtils.createHtmlStr(0xaeaeae,equipCfgData.load.toString(),13);
						htmlStrArr.push(htmlStr);
						break;*/
					case StringConst.DURABILITY:
						var duranilityStr:String = (memEquipData?memEquipData.duralibility:equipCfgData.durability/100)+"/"+equipCfgData.durability/100;
						color = equipCfgData.durability>100? 0x0070c0 : 0xc00000 ;
						if(memEquipData!=null&&memEquipData.duralibility==0)
						{
							color=0xff0000;
						}
						if(equipCfgData.durability == 0)
						{
							color = 0xc00000;
							duranilityStr = StringConst.DURABILITY_NONE;
						}
						htmlStr = HtmlUtils.createHtmlStr(0xaeaeae,propertyName+StringConst.COLON,12)+HtmlUtils.createHtmlStr(color,duranilityStr,12);
						durationStr = htmlStr;
						break;
					case StringConst.ENTITY_NEED:
						if(equipCfgData.entity == EntityTypes.ET_NONE)
						{
							continue;
						}
						color = 0xaeaeae;
						var str:String = equipCfgData.entity == EntityTypes.ET_HERO?StringConst.ENTITY_TYPE_HERO:StringConst.ENTITY_TYPE_PLAYER;
						htmlStr = HtmlUtils.createHtmlStr(color,propertyName+StringConst.COLON,12)+HtmlUtils.createHtmlStr(color,str,12);
						htmlStrArr.push(htmlStr);
						break;
				}
			}
			
			var theY:int = 40;
			for(var j:int = 0;j<htmlStrArr.length;j++)
			{
				var text:TextField = addText(htmlStrArr[j],95,theY);
				
				if(i == htmlStrArr.length-1)
				{
					theY += text.textHeight;
				}
				else
				{
					theY += text.textHeight+6;
				}
				
				if(j == 0)
				{
					if(durationStr)
					{
						_durationTxt = addText(durationStr,text.x+100,text.y);
						maxWidth = Math.max(maxWidth,_durationTxt.x+_durationTxt.textWidth+10);
					}
				}
			}
			maxHeight = Math.max(maxHeight,theY);
		}
		
		protected function setStars(strengthenStars:Vector.<String>):void
		{
			var i:int,l:int = strengthenStars.length;
			for (i=0;i<l;i++) 
			{
				var stars:Stars = new Stars();
				super.initView(stars);
				stars.name = strengthenStars[i];
				stars.x = 42+(i-1)*25;
				stars.y = maxHeight;
				addChild(stars);
			}
			maxHeight += stars ? stars.height + 6 : 6;
		}
		/**
		 * 设置装备属性 
		 * @param equipCfgData
		 */
		protected function setEquipProperty(equipCfgData:EquipCfgData,memEquipData:MemEquipData):void
		{
			if(memEquipData && memEquipData.strengthen>0)
			{
				addChild(loadSplitLine(15,maxHeight));
				maxHeight += 6;
			}
			
			var attr:String=equipCfgData.attr;
			if(memEquipData&&memEquipData.goodLuck>0)
			{
				attr+="|"+RolePropertyConst.ROLE_PROPERTY_LUCKY_ID+":1:"+memEquipData.goodLuck;
			}
			
			var job:int = !ToolTipConst.isHeroTips(_tipType) ? RoleDataManager.instance.job : HeroDataManager.instance.job;
			var propertyArray:Vector.<String> = CfgDataParse.getAttHtmlStringArray(attr,2,_basePropertyList,true,0xaeaeae,job);
			var hasEquipProperty:Boolean = (propertyArray.length>0? true: false);
			var tf:TextField;
			
			if(hasEquipProperty)
			{
				var htmlStr:String = HtmlUtils.createHtmlStr(0xc55a11,StringConst.EQUIP_BASE_PROPERTY);
				tf = addText(htmlStr,18,maxHeight);
				maxHeight = tf.y+tf.textHeight+6;
			}
			
			for(var i:int=0;i<propertyArray.length;i++)
			{
				tf = addText(propertyArray[i],33,maxHeight);
				maxHeight = tf.y+tf.textHeight+5;
				
				_baseProtertyView.push(tf);
			}
		}
		/**
		 * 设置强化属性 
		 * @param equipCfgData
		 */		
		private function setStrengthProperty(memEquipData:MemEquipData,equipCfgData:EquipCfgData):void
		{
			if(memEquipData.strengthen <= 0)
			{
				return;
			}
			if(equipCfgData.type==ConstEquipCell.TYPE_XUNZHANG)return;
			var strengthenAttr:EquipStrengthenAttrCfgData = ConfigDataManager.instance.equipStrengthenAttr(equipCfgData.type,memEquipData.strengthen);
			if(!strengthenAttr)
			{
				return;
			}
			
			var job:int = !ToolTipConst.isHeroTips(_tipType) ? RoleDataManager.instance.job : HeroDataManager.instance.job;
			var propertyArray:Vector.<String> = CfgDataParse.getAttHtmlStringArray(strengthenAttr.attr,2,_strengthenList,false,0xfabe50,job);
			
			for(var i:int = 0;i < _strengthenList.length; ++i)
			{
				var propertyData:PropertyData = _strengthenList[i];
				var index:int = indexOfProperty(propertyData.propertyId,_basePropertyList);
				if(index != -1)
				{
					var pv:TextField = getBasePropertyView(index);
					
					var equipPolishAttrCfgData:EquipPolishAttrCfgData = ConfigDataManager.instance.equipPolishAttrCfgData(equipCfgData.type,memEquipData.polish);
					var strPolishAdd:String = equipPolishAttrCfgData ? "[+"+(equipPolishAttrCfgData.attr_rate * .1) + "%]" : "";
					var strHtml:String = HtmlUtils.createHtmlStr(0xfabe50,"("+StringConst.FORGE_PANEL_00011+propertyArray[i]+strPolishAdd+")");
					var tf:TextField = addText(strHtml,pv.x+pv.textWidth+10,pv.y);
					_strengthenView.push(tf);
					
					var value:Number = propertyData.fightPower * (1 + (equipPolishAttrCfgData ? equipPolishAttrCfgData.attr_rate*.001 : 0));
					fightOther += value;
				}
			}
		}
		/**
		 * 设置打磨属性 
		 * @param equipCfgData
		 */		
		private function setPolishProperty(memEquipData:MemEquipData,equipCfgData:EquipCfgData):void
		{
			if(memEquipData.polish <= 0)
			{
				return;
			}
			
			var equipPolishAttrCfgData:EquipPolishAttrCfgData = ConfigDataManager.instance.equipPolishAttrCfgData(equipCfgData.type,memEquipData.polish);
			if(!equipPolishAttrCfgData)
			{
				return;
			}
			
			var job:int = !ToolTipConst.isHeroTips(_tipType) ? RoleDataManager.instance.job : HeroDataManager.instance.job;
			var propertyArray:Vector.<String> = CfgDataParse.getAttHtmlStringArray(equipPolishAttrCfgData.attr,2,_polishList,false,0x00cece,job);
			
			for(var i:int = 0;i < _polishList.length; ++i)
			{
				var propertyData:PropertyData = _polishList[i];
				var index:int = indexOfProperty(propertyData.propertyId,_basePropertyList);
				if(index != -1)
				{
					var pv:TextField = _strengthenView && index < _strengthenList.length ? _strengthenView[index] : null;
					pv = !pv ? _baseProtertyView[index] : pv;
					
					var strHtml:String = HtmlUtils.createHtmlStr(0x00cece,StringConst.POLISH+propertyArray[i]+" ");
					var tf:TextField = addText(strHtml,pv.x+pv.textWidth+10,pv.y);
					_polishView.push(tf);
					maxWidth = Math.max(maxWidth,tf.x+tf.textWidth+10);
					
					fightOther += propertyData.fightPower;
				}
			}
		}
		/**
		 * 设置随机属性 
		 * @param memEquipData
		 */		
		private function setRdProperty(memEquipData:MemEquipData):void
		{
			var attrRdCount:int = memEquipData.attrRdCount;
			if(attrRdCount)
			{
				maxHeight += 6;
				loadSplitLine(15,maxHeight);
				maxHeight += 12;
				//
				var htmlStr:String = HtmlUtils.createHtmlStr(0xc55a11, StringConst.RANDOM_PROPERTY);
				var fuMoText:TextField = addText(htmlStr,18,maxHeight);
				maxHeight = fuMoText.y+fuMoText.textHeight+6;
				//
				var i:int;
				for (i=0;i<attrRdCount;i++) 
				{
					var attrRdDt:AttrRandomData = memEquipData.attrRdDt(i);
					var attrDt:PropertyData = attrRdDt ? attrRdDt.attrDt : null;
					if(attrRdDt && attrDt)
					{
						var str:String = CfgDataParse.propertyToStr(attrDt,2,0xaeaeae,0xaeaeae);
						fightOther += attrDt.fightPower;
						loadAttrRdStar(attrRdDt);
					}
					else
					{
						str = HtmlUtils.createHtmlStr(0xaeaeae,StringConst.REFINED_PANEL_0002);
					}
					var tf:TextField = addText(str,33,maxHeight);
					maxHeight = tf.y+tf.textHeight+5;
					
					_attrRdView.push(tf);
				}
			}
		}
		
		private function loadAttrRdStar(attrRdDt:AttrRandomData):void
		{
			var value:String = attrRdDt.star+"";
			addText(HtmlUtils.createHtmlStr(attrRdDt.starColor,value),140+((value.length-1)*-6),maxHeight);
			var frame:int = Math.ceil(attrRdDt.star/3);
			var stars:StarsAttrRd = new StarsAttrRd();
			super.initView(stars);
			stars.name = frame+"";
			stars.x = 150;
			stars.y = maxHeight+3;
			addChild(stars);
		}
		
		private function setStrengthPropertyNext(memEquipData:MemEquipData,equipCfgData:EquipCfgData):void
		{
			if(memEquipData.strengthen >= equipCfgData.strengthen)
			{
				return;
			}
			var strengthenNext:int = memEquipData.strengthen+1;
			var strengthenAttrNext:EquipStrengthenAttrCfgData = ConfigDataManager.instance.equipStrengthenAttr(equipCfgData.type,strengthenNext);
			if(!strengthenAttrNext)
			{
				return;
			}
			maxHeight += 6;
			loadSplitLine(15,maxHeight);
			maxHeight += 12;
			//
			var htmlStr:String = HtmlUtils.createHtmlStr(0xc55a11, StringConst.STRENTHEN_PROPERTY_NEXT + StringConst.COLON);
			var text:TextField = addText(htmlStr,18,maxHeight);
			htmlStr = HtmlUtils.createHtmlStr(0xc55a11,StringConst.FORGE_PANEL_00011 + "+" + strengthenNext);
			addText(htmlStr,140,maxHeight);
			maxHeight = text.y+text.textHeight+6;
			//
			var job:int = !ToolTipConst.isHeroTips(_tipType) ? RoleDataManager.instance.job : HeroDataManager.instance.job;
			var strengthenAttr:EquipStrengthenAttrCfgData = ConfigDataManager.instance.equipStrengthenAttr(equipCfgData.type,memEquipData.strengthen);
			var attrs:Vector.<PropertyData> = strengthenAttr ? 
				CfgDataParse.getDAttStringArray(strengthenAttr.attr,strengthenAttrNext.attr) :
				CfgDataParse.getPropertyDatas(strengthenAttrNext.attr);
			
			for(var i:int = 0;i < attrs.length; ++i)
			{
				var propertyData:PropertyData = attrs[i];
				var index:int = indexOfProperty(propertyData.propertyId,_basePropertyList);
				if(index != -1)
				{
					var strHtml:String = HtmlUtils.createHtmlStr(0xaeaeae,propertyData.name + StringConst.COLON);
					var tf:TextField = addText(strHtml,33,maxHeight);
					var propertyToStr:String = CfgDataParse.propertyToStr(propertyData,2,0xfabe50,0xfabe50,false);
					strHtml = HtmlUtils.createHtmlStr(0xfabe50,"+("+propertyToStr+")");
					addText(strHtml,140,maxHeight);
					maxHeight = tf.y+tf.textHeight+5;
				}
			}
		}
		
		private function setEquipSuitAttr(equipCfgData:EquipCfgData, memEquipData:MemEquipData):void
		{
			var equipSuitAttr:EquipSuitAttrCfgData = ConfigDataManager.instance.equipSuitAttr(equipCfgData.quality,equipCfgData.type);
			if(equipSuitAttr==null)return;
			
			maxHeight += 6;
			loadSplitLine(15,maxHeight);
			maxHeight += 12;
			
			var htmlStr:String = HtmlUtils.createHtmlStr(0xc55a11,StringConst.EQUIP_BASE_SUIT);
			var tf:TextField = addText(htmlStr,18,maxHeight);
			maxHeight +=19;
			
			var equipTypes:Array = equipSuitAttr.part.split(":");
			var equipStr:String="";
			var count:int;
			for(var i:int=0;i<equipTypes.length;i++)
			{
				var type:int=int(equipTypes[i]);
				var equipName:String = ConstEquipCell.getEquipName(type);
				var checked:Boolean;
				if(_tipType==ToolTipConst.EQUIP_BASE_TIP_HERO)
				{
					checked=HeroDataManager.instance.checkEquipQualityByType(type,equipCfgData.quality);
				}else
				{
					checked=RoleDataManager.instance.checkEquipQualityByType(type,equipCfgData.quality);
				}
				if(checked)
				{
					equipStr+=HtmlUtils.createHtmlStr(0xffcc00,equipName)+"    ";	
					count++;
				}else
				{
					equipStr+=HtmlUtils.createHtmlStr(0xbfbfbf,equipName)+"    ";
				}
			}
			addProperty(equipStr,33,maxHeight);
			maxHeight+=25;
			htmlStr = HtmlUtils.createHtmlStr(0xc55a11,StringConst.EQUIP_BASE_SUIT)+HtmlUtils.createHtmlStr(0xffcc00,"  （"+equipSuitAttr.name+"）  （"+count+"/"+equipTypes.length+"）");
			tf.htmlText=htmlStr;
			
			//******************************************************************************//
			addSuitProperty(equipSuitAttr.attr1,count,1,equipTypes.length);
			addSuitProperty(equipSuitAttr.attr2,count,2,equipTypes.length);
			addSuitProperty(equipSuitAttr.attr3,count,3,equipTypes.length);
			addSuitProperty(equipSuitAttr.attr4,count,4,equipTypes.length);
			
//			var thisEquipName:String = ConstEquipCell.getEquipName(equipCfgData.type);
//			var thisEquipStr:String = HtmlUtils.createHtmlStr(0xffcc00,StringUtil.substitute(StringConst.EQUIP_SUIT_0001,thisEquipName));
//			maxHeight+=6;
//			addProperty(thisEquipStr,18,maxHeight);
//			maxHeight+=21;
		}
		
		private function addSuitProperty(attrs:String,count:int,type:int,total:int):void
		{
			if(attrs=="")return;	
			var propertyStr:String;
			var newAttrs:Vector.<String> = CfgDataParse.getAttStringArray(attrs,true);
			var isSure:Boolean = count>=type;
			for (var i:int=0;i<newAttrs.length;i++)
			{
				newAttrs[i]=newAttrs[i].replace(" +",StringConst.EQUIP_BASE_PROPERTY_0001);
				if(isSure)
				{
					propertyStr = HtmlUtils.createHtmlStr(0xffcc00,type+"/"+total+"   "+newAttrs[i]);
				}else
				{
					propertyStr = HtmlUtils.createHtmlStr(0xbfbfbf,type+"/"+total+"   "+newAttrs[i]);
				}
				addProperty(propertyStr,33,maxHeight);
				maxHeight+=21;
			}
		}
		
		private function addDuijieSuitAttr(equipCfgData:EquipCfgData, memEquipData:MemEquipData):void
		{
			var equipDuijieSuitCfgData:EquipDuijieSuitCfgData = ConfigDataManager.instance.equipDuijieSuitCfgData(1);
			maxHeight += 6;
			loadSplitLine(15,maxHeight);
			maxHeight += 12;
			
			var htmlStr:String = HtmlUtils.createHtmlStr(0xc55a11,StringConst.EQUIP_BASE_SUIT);
			var tf:TextField = addText(htmlStr,18,maxHeight);
			maxHeight +=19;
			
			var equipTypes:Array = equipDuijieSuitCfgData.part.split(":");
			var equipStr:String="";
			var count:int;
			var type1:int=int(equipTypes[0]);
			var type2:int=int(equipTypes[1]);
			var equipName1:String = StringConst.ENTITY_TYPE_PLAYER+ConstEquipCell.getEquipName(type1);
			var equipName2:String = StringConst.ENTITY_TYPE_HERO+ConstEquipCell.getEquipName(type2);
			var checked:Boolean;
			checked=RoleDataManager.instance.getEquipPower(ConstEquipCell.CP_HUANJIE)>0;
			if(checked)
			{
				equipStr+=HtmlUtils.createHtmlStr(0xffcc00,equipName1)+"    ";	
				count++;
			}else
			{
				equipStr+=HtmlUtils.createHtmlStr(0xbfbfbf,equipName1)+"    ";
			}
			checked=HeroDataManager.instance.getEquipPower(ConstEquipCell.HP_HUANJIE)>0;
			if(checked)
			{
				equipStr+=HtmlUtils.createHtmlStr(0xffcc00,equipName2)+"    ";	
				count++;
			}else
			{
				equipStr+=HtmlUtils.createHtmlStr(0xbfbfbf,equipName2)+"    ";
			}
			
			addProperty(equipStr,33,maxHeight);
			maxHeight+=25;
			htmlStr = HtmlUtils.createHtmlStr(0xc55a11,StringConst.EQUIP_BASE_SUIT)+HtmlUtils.createHtmlStr(0xffcc00,"  （"+equipDuijieSuitCfgData.name+"）  （"+count+"/"+equipTypes.length+"）");
			tf.htmlText=htmlStr;
			
			//******************************************************************************//
			
			if(equipCfgData.entity==EntityTypes.ET_PLAYER)
			{
				addSuitProperty(equipDuijieSuitCfgData.chr_attr,count,2,equipTypes.length);
			}else
			{
				addSuitProperty(equipDuijieSuitCfgData.hero_attr,count,2,equipTypes.length);
			}
		}
		
		private function setFightPower():void
		{
			//战斗力
			fight = 0;
			for each(var data:PropertyData in _basePropertyList)
			{
				fight += data.fightPower;
			}
			
			fight += fightOther;
			
			var htmlStr:String = HtmlUtils.createHtmlStr(0xffc000,StringConst.TIP_FIGHT,12,true);
			
			var fightHeadTxt:TextField = addText(htmlStr,_durationTxt.x+10,_durationTxt.y + 30);
			
			htmlStr = HtmlUtils.createHtmlStr(0xfabe50,int(fight).toString(),24,true);
			
			var fightTxt:TextField = addText(htmlStr,_durationTxt.x,fightHeadTxt.y+fightHeadTxt.textHeight+3/*maxHeight - 20*/);
			fightTxt.x = fightHeadTxt.x + (fightHeadTxt.textWidth)/2 - (fightTxt.textWidth)/2;
			
			fightFlag = addText("",fightHeadTxt.x + fightHeadTxt.textWidth + 3,fightHeadTxt.y+8);
		}
		/**
		 * 设置其他属性 
		 * @param equipCfgData
		 * @param memEquipData
		 */		
		protected function setOtherProperty(equipCfgData:EquipCfgData,memEquipData:MemEquipData):void
		{
			//描述
			if(equipCfgData.desc != "" && equipCfgData.desc!="0")
			{
				maxHeight += 6;
				loadSplitLine(15,maxHeight);
				maxHeight += 12;
				
				setDesc(equipCfgData.desc);
			}
			
			//出售价格
			if(equipCfgData.desc == "" || equipCfgData.desc=="0")
			{
				maxHeight += 6;
				loadSplitLine(15,maxHeight);
				maxHeight += 12;
			}
			
			var htmlStr:String = HtmlUtils.createHtmlStr(0xaeaeae,StringConst.SELL_PRIECE+StringConst.COLON)+
				HtmlUtils.createHtmlStr(0xfabe50,equipCfgData.can_sell ? equipCfgData.sell_value.toString() : StringConst.NO_SELL);
			
			if(equipCfgData.desc != "" && equipCfgData.desc != "0")
			{
				maxHeight+=4;
			}
			var coinTxt:TextField = addText(htmlStr,18,maxHeight);
			maxHeight+=coinTxt.textHeight;
			
			//shift点击
			maxHeight+=4
			var chatTxt:TextField = addText(HtmlUtils.createHtmlStr(0xffc000,StringConst.TIP_ITEM_TO_CHAT),18,maxHeight);
			maxHeight+=chatTxt.textHeight;
		}
		
		private function setDesc(desc:String):void
		{
			if(desc == "")
				return;
			
			var htmlStrArr:Array = CfgDataParse.pareseDes(desc,0xffffff);
			if(htmlStrArr.length>0)
				maxHeight += 4;
			
			for (var i:int = 0;i<htmlStrArr.length;i++)
			{
				var desText:TextField = addText(htmlStrArr[i],18,maxHeight);
				maxHeight = desText.y+desText.height;
			}
			
			height = maxHeight;
		}
		
		override public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			super.urlBitmapDataReceive(url,bitmapData,info);
			
			if(equipCfgData)
			{
				_iconBmp.y = 46;
				var url:String = ItemType.getEffectUrlByQuality(equipCfgData.color);
				_cellEffectLoader = new UIEffectLoader(_skin,_iconBmp.x+_iconBmp.width/2,_iconBmp.y+_iconBmp.height/2,1,1,url);
			}
		}
		
		override public function dispose():void
		{
			_basePropertyList = null;
			_baseProtertyView = null;
			_strengthenList = null;
			_strengthenView = null;
			_polishList = null;
			_polishView = null;
			_attrRdView = null;
			super.dispose();
			_url = "";
			destroyEffect();
		}
		
		private function destroyEffect():void
		{
			if(_cellEffectLoader)
			{
				_cellEffectLoader.destroy();
			}
		}
		
		public function setEquipedFlag():void
		{
			var equipedFlag:MovieClip = new EquipedFlag();
			equipedFlag.y = EQUIPED_Y;
			equipedFlag.x = EQUIPED_X;
			addChild(equipedFlag);
			super.initView(equipedFlag);
		}
		/**
		 * 设置对比 数据
		 * @param data MemEquipData || EquipCfgData
		 */
		public function setCompareEquipTip(target:EquipBaseTip):void
		{
			for each(var targetProperty:PropertyData in target.basePropertyList)
			{
				var index:int = indexOfProperty(targetProperty.propertyId,basePropertyList);
				if(index != -1)
				{
					var strengthenSelfData:PropertyData = findProperty(targetProperty.propertyId,strengthenList);
					var strengthenTargetData:PropertyData = findProperty(targetProperty.propertyId,target.strengthenList);
					var value:int = comparePropertyValue(basePropertyList[index],strengthenSelfData,targetProperty,strengthenTargetData);
					
					var view:TextField = _polishView.length > index ? _polishView[index] : null;
					view ||= _strengthenView.length > index ? _strengthenView[index] : null;
					view ||= _baseProtertyView.length > index ? _baseProtertyView[index] : null;
					if(view)
					{
						var tf:TextField;
						if(value > 0)
						{
							tf = addText(HtmlUtils.createHtmlStr(0x70ad47,StringConst.TIP_UP,12,true,2,FontFamily.FONT_NAME_EX),view.x + view.textWidth + 6,view.y);
						}
						else if(value < 0)
						{
							tf = addText(HtmlUtils.createHtmlStr(0xc00000,StringConst.TIP_DOWN,12,true),view.x + view.textWidth + 6,view.y);
						}
						if(tf)
						{
							maxWidth = Math.max(maxWidth,tf.x+tf.textWidth+10);
							width = maxWidth ? maxWidth : width;
						}
					}
				}
			}
			
			if(fight - target.fight != 0)
			{
				if(fightFlag)
				{
					var boolean:Boolean = fight - target.fight > 0;
					var color:int = boolean ? 0x70ad47 : 0xc00000;
					var text:String = boolean ? StringConst.TIP_UP : StringConst.TIP_DOWN;
					fightFlag.htmlText = HtmlUtils.createHtmlStr(color,text,20,true,2,FontFamily.FONT_NAME_EX);
				}
			}
		}
		
		public function comparePropertyValue(baseSelfData:PropertyData,strengthenSelfData:PropertyData,baseTargetData:PropertyData,strengthenTargetData:PropertyData):int
		{
			if(!baseTargetData || !baseSelfData)
			{
				return 0;
			}
			var value1:int = baseSelfData.value1 + (strengthenSelfData ? strengthenSelfData.value1:0);
			var value2:int = baseSelfData.value + (strengthenSelfData?strengthenSelfData.value:0);
			var selfValue:int = baseSelfData.isMain ? value1 : value2;
			value1 = baseTargetData.value1 + (strengthenTargetData?strengthenTargetData.value1:0);
			value2 = baseTargetData.value + (strengthenTargetData?strengthenTargetData.value:0);
			var targetValue:int = baseTargetData.isMain ? value1 : value2;
			
			return selfValue - targetValue;
		}
		
		public function findProperty(propertyId:int,list:Vector.<PropertyData>):PropertyData
		{
			for each(var data:PropertyData in list)
			{
				if(data && propertyId == data.propertyId)
				{
					return data;
				}
			}
			return null;
		}
		
		public function indexOfProperty(propertyId:int,list:Vector.<PropertyData>):int
		{
			var index:int = -1;
			for each(var data:PropertyData in list)
			{
				++index;
				if(data && (propertyId == data.propertyId || (data.isMain && data.propertyId+1 == propertyId)))
				{
					return index;
				}
			}
			return -1;
		}
		
		public function getBasePropertyView(index:int):TextField
		{
			return _baseProtertyView[index];
		}
		
		private function loadSplitLine(x:int, y:int):DelimiterLine
		{
			var splitLine:DelimiterLine = new DelimiterLine();
			addChild(splitLine);
			splitLine.x = x;
			splitLine.y = y;
			super.initView(splitLine);
			return splitLine;
		}
		
		private function addText(htmlStr:String,x:int,y:int):TextField
		{
			var text:TextField = new TextField();
			addChild(text);
			text.width = 250;
			text.autoSize = TextFieldAutoSize.LEFT;
			text.htmlText = htmlStr;
			text.wordWrap = true;
			text.multiline =true;
			text.x = x;
			text.y = y;
			text.filters = [_filter];
			return text;
		}
	}
}