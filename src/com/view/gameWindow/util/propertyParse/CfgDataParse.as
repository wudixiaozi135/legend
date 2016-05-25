package com.view.gameWindow.util.propertyParse
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.AttrCfgData;
	import com.model.consts.JobConst;
	import com.model.consts.RolePropertyConst;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.util.HtmlUtils;
	
	/**
	 * 配置文件数据解析类
	 * @author jhj
	 */
	public class CfgDataParse
	{
		private static const rangePropertyArr:Array = [RolePropertyConst.ROLE_PROPERTY_PHSICAL_ATTACK_LOWER_ID,RolePropertyConst.ROLE_PROPERTY_PHYSICAL_ATTACK_UPPER_ID,  
													   RolePropertyConst.ROLE_PROPERTY_MAGIC_ATTACK_UPPER_ID,RolePropertyConst.ROLE_PROPERTY_MAGIC_ATTACK_LOWER_ID,
													   RolePropertyConst.ROLE_PROPERTY_TAOISM_ATTACK_UPPER_ID,RolePropertyConst.ROLE_PROPERTY_TAOISM_ATTACK_LOWER_ID,
													   RolePropertyConst.ROLE_PROPERTY_PHYSICAL_DEFENSE_UPPER_ID,RolePropertyConst.ROLE_PROPERTY_PHYSICAl_DEFENSE_LOWER_ID,
													   RolePropertyConst.ROLE_PROPERTY_MAGIC_DEFENSE_UPPER_ID,RolePropertyConst.ROLE_PROPERTY_MAGIC_DEFENSE_LOWER_ID];
		private static const rangePropertyName:Array = [StringConst.ROLE_PROPERTY_PHSICAL_ATTACK,StringConst.ROLE_PROPERTY_PHSICAL_ATTACK,
														StringConst.ROLE_PROPERTY_MAGIC_ATTACK,StringConst.ROLE_PROPERTY_MAGIC_ATTACK,
														StringConst.ROLE_PROPERTY_TAOISM_ATTACK,StringConst.ROLE_PROPERTY_TAOISM_ATTACK,
														StringConst.ROLE_PROPERTY_PHYSICAL_DEFENSE,StringConst.ROLE_PROPERTY_PHYSICAL_DEFENSE,
														StringConst.ROLE_PROPERTY_MAGIC_DEFENSE,StringConst.ROLE_PROPERTY_MAGIC_DEFENSE];
			                                                                                                                  
		public function CfgDataParse()
		{
			
		}
		
		public static function propertyToStr(data:PropertyData,leading:int = 2,nameColor:int = 0,valueColor:int = 0,isShowName:Boolean = true,isShowFloor:Boolean=true,colon:String = StringConst.COLON):String
		{
			var name:String = "";
			
			if(nameColor == 0)
			{
				nameColor = data.color;
			}
			
			if(valueColor == 0)
			{
				valueColor = data.color;
			}
			
			if(isShowName)
			{
				name = HtmlUtils.createHtmlStr(nameColor,data.name + colon,12,false,leading);
			}
			
			var re:String = name;
			var value:String = "";
			if(data.type == RolePropertyConst.NUM_TYPE)
			{
				if(isShowFloor)
				{
					value = !data.isMain ? "+" + data.value : data.value + "-" + data.value1;
				}
				else
				{
					value = " +("+(!data.isMain ? data.value : data.value + "-" + data.value1)+")";
				}
				re += HtmlUtils.createHtmlStr(valueColor, value,12,false,leading);
				
			}
			else if(data.type == RolePropertyConst.PERCENT_TYPE)
			{  
				if(isShowFloor)
				{
					value = getPercentValue(data.value) + "%";
				}
				else
				{
					value =" ("+getPercentValue(data.value) + "%)";
				}
				re += HtmlUtils.createHtmlStr(valueColor,value,12,false,leading);
			}
			
			return re;
		}
		
		public static function getPercentValue(value:Number):String
		{
			var strValue:String = value.toString();
			var split:Array = strValue.split(".");
			var strInt:String = split[0] as String;//整数部分
			var strDecimal:String = split[1] as String;//小数部分
			if(strDecimal)
			{
				strDecimal = strDecimal.substr(0,1);
			}
			else
			{
				strDecimal = "0";
			}
			var str:String;
			str = "+"+strInt+"."+strDecimal;
			return str;
		}
		/**
		 * 解析装备Att属性字段
		 * 返回形如物理攻击20-50 和物理攻击+20%这种 字符串数组
		 * 请谨记，这个方法没有去除重复
		 * @param att
		 * @return html格式字符串數組
		 */		
		public static function getAttHtmlStringArray(att:String,leading:int = 2,output:Vector.<PropertyData>=null,isShowPropertyName:Boolean = true,color:int = 0xffc000,job:int = 0):Vector.<String>
		{
			var vector:Vector.<String> = new Vector.<String>();
			var propertyDatas:Vector.<PropertyData> = getPropertyDatas(att,false,null,job);
			var i:int,l:int = propertyDatas.length;
			var str:String,htmlStr:String;
			for(i=0;i<l;i++)
			{
				var propertyData:PropertyData = propertyDatas[i];
			
				htmlStr = propertyToStr(propertyData,leading,color,color,isShowPropertyName);
				vector.push(htmlStr);
				
				if(output)
				{
					output.push(propertyData);
				}
			}
			return vector;
		}
		
		public static function VectorToString(strs:Vector.<String>):String
		{
			var rs:String="";
			for (var i:int=0;i<strs.length;i++)
			{
				rs+=strs[i]+"\n";
			}
			return rs;
		}
		
		/**
		 * 解析attr属性字段,数组下标为1的位置不得放重复的属性
		 * 返回形如物理攻击20-50 和物理攻击+20%这种 字符串数组
		 * 请谨记，这个方法已经去除重复
		 * @param att
		 * @return html格式字符串數組
		 */		
		public static function getAttHtmlStringArray2(atts:Vector.<String>,leading:int = 2,isFiterMain:Boolean=false,output:Vector.<PropertyData>=null,isShowPropertyName:Boolean = true,color:int = 0xffc000):Vector.<String>
		{
			var vector:Vector.<String> = new Vector.<String>();
			var propertyDatas:Vector.<PropertyData> = getTAttrStringArray(atts,isFiterMain);
			var i:int,l:int = propertyDatas.length;
			var str:String,htmlStr:String;
			for(i=0;i<l;i++)
			{
				var propertyData:PropertyData = propertyDatas[i];
				
				htmlStr = propertyToStr(propertyData,leading,color,color,isShowPropertyName);
				vector.push(htmlStr);
				
				if(output)
				{
					output.push(propertyData);
				}
			}
			return vector;
		}
		
		/**
		 * 解析装备Att属性字段
		 * @param att
		 * @param subAttrS
		 * @return html格式字符串數組<br>返回形如物理攻击20-50 (+50)和物理攻击+20%+(2%)这种 字符串数组
		 */		
		public static function getAttSubJoinHtml(att:String,subAttrS:Vector.<String>):Vector.<String>
		{
			var vector:Vector.<String> = new Vector.<String>();
			
			var propertyDatas:Vector.<PropertyData> = getPropertyDatas(att);
			var subPropertyDatas:Vector.<PropertyData> = getTAttrStringArray(subAttrS);
			var i:int,l:int = propertyDatas.length;
			var str:String,htmlStr:String,strLine:String;
			var color:int=0xc72541;
			for(i=0;i<l;i++)
			{
				var propertyData:PropertyData = propertyDatas[i];
				strLine="";
				if(propertyData.propertyId>2&&propertyData.propertyId<9)
				{
					color=0xc72541;
				}else if(propertyData.propertyId<13)
				{
					if(color==0xc72541)
					{
						strLine="\n";
					}
					color=0xff6600;
				}else
				{
					if(color==0xff6600)strLine="\n";
					color=0xe616b6;
				}
				htmlStr = strLine+propertyToStr(propertyData,4,color,color);
				color=0x00ff00;
				if(subPropertyDatas!=null)
				{
					for (var d:int=0;d<subPropertyDatas.length;d++)
					{
						if(propertyData.name==subPropertyDatas[d].name)
						{
							htmlStr+=propertyToStr(subPropertyDatas[d],4,color,color,false,false);
						}
					}
				}
				vector.push(htmlStr);
			}
			return vector;
		}
		/**
		 * 解析装备Att属性字段
		 * 返回形如物理攻击20-50 和物理攻击+20%这种 字符串数组
		 * 请谨记，这个方法没有去除重复
		 * @param att
		 * @isFiterMain 是否过滤主属性
		 * @percentum 结果显示百分比 默认为100%
		 * @return 非html格式字符串數組
		 */		
		public static function getAttStringArray(att:String,isFiterMain:Boolean = false,percentum:int=100):Vector.<String>
		{
			var vector:Vector.<String> = new Vector.<String>();
			var propertyDatas:Vector.<PropertyData> = isFiterMain ? getPropertyDatas(att,isFiterMain,getFilterArr()) : getPropertyDatas(att);
			var i:int,l:int = propertyDatas.length;
			var str:String;
			for(i=0;i<l;i++)
			{
				var propertyData:PropertyData = propertyDatas[i];
				if(propertyData.type == RolePropertyConst.NUM_TYPE)
				{
					str = !propertyData.isMain ? "+" + int(propertyData.value*percentum/100) : int(propertyData.value*percentum/100) + "-" + int(propertyData.value1*percentum/100);
					vector.push(propertyData.name + " " + str);
				}
				else if(propertyData.type == RolePropertyConst.PERCENT_TYPE)
				{  
					str = getPercentValue(propertyData.value*percentum/100) + "%";
					vector.push(propertyData.name + " " + str);
				}
			}
			return vector;
		}
		
		public static function getAwardStringArray(att:String,job:int):Vector.<String>
		{
			var vector:Vector.<String> = new Vector.<String>();
			var propertyDatas:Vector.<PropertyData> = getPropertyDatas(att);
			var i:int,l:int = propertyDatas.length;
			var str:String;
			for(i=0;i<l;i++)
			{
				var propertyData:PropertyData = propertyDatas[i];
				if(propertyData.type == RolePropertyConst.NUM_TYPE)
				{
					str = !propertyData.isMain ? "+" + propertyData.value : propertyData.value + "-" + propertyData.value1;
					vector.push(propertyData.name + " " + str);
				}
				else if(propertyData.type == RolePropertyConst.PERCENT_TYPE)
				{  
					str = getPercentValue(propertyData.value) + "%";
					vector.push(propertyData.name + " " + str);
				}
			}
			return vector;
		}
		/**
		 * 解析装备属性计算att1与Att的差值
		 * @param att 当前属性
		 * @param att1 下一级属性
		 * @return 
		 */		
		public static function getDAttStringArray(att:String,att1:String):Vector.<PropertyData>
		{
			var propertyDatas:Vector.<PropertyData> = getPropertyDatas(att);
			var propertyDatas1:Vector.<PropertyData> = getPropertyDatas(att1);
			var i:int,l:int = propertyDatas.length;
			for(i=0;i<l;i++)
			{
				var propertyData:PropertyData = propertyDatas[i];
				var propertyData1:PropertyData = propertyDatas1[i];
				propertyData.value = propertyData1.value - propertyData.value;
				propertyData.value1 = propertyData1.value1 - propertyData.value1;
			}
			return propertyDatas;
		}
		/**
		 * 解析装备属性计算个属性总值
		 * @param attrs 属性列表
		 * @param isFiterMain 是否过滤掉非主属性
		 * @return 
		 */		
		public static function getTAttrStringArray(attrs:Vector.<String>,isFiterMain:Boolean=false):Vector.<PropertyData>
		{
			if(attrs==null||attrs.length<1)return null;
			var propertyDatas:Vector.<PropertyData> =isFiterMain?getPropertyDatas(attrs[0],isFiterMain,getFilterArr()):getPropertyDatas(attrs[0]);
			var temp:Vector.<PropertyData>,propertyData:PropertyData;
			var i:int,l:int = attrs.length,j:int,jl:int,k:int,kl:int,isBreak:Boolean;
			for(i=1;i<l;i++)
			{
				temp = isFiterMain?getPropertyDatas(attrs[i],isFiterMain,getFilterArr()):getPropertyDatas(attrs[i]);
				jl = temp.length;
				for(j=0;j<jl;j++)
				{
					kl = propertyDatas.length;
					isBreak = false;
					for(k=0;k<kl;k++)
					{
						if(temp[j].name == propertyDatas[k].name)
						{
							propertyDatas[k].value += temp[j].value;
							propertyDatas[k].value1 += temp[j].value1;
							isBreak = true;
							break;
						}
					}
					if(!isBreak)//若该属性在前一条属性中不存在则加入
					{
						propertyDatas.push(temp[j].clone());
					}
				}
			}
			return propertyDatas;
		}
		
		public static function getFilterArr():Array
		{
			var job:int=RoleDataManager.instance.job;
			switch(job)
			{
				case JobConst.TYPE_ZS:
					return [
						RolePropertyConst.ROLE_PROPERTY_MAGIC_ATTACK_UPPER_ID,
						RolePropertyConst.ROLE_PROPERTY_MAGIC_ATTACK_LOWER_ID,
						RolePropertyConst.ROLE_PROPERTY_TAOISM_ATTACK_UPPER_ID,
						RolePropertyConst.ROLE_PROPERTY_TAOISM_ATTACK_LOWER_ID
					];
					break;
				case JobConst.TYPE_FS:
					return [
						RolePropertyConst.ROLE_PROPERTY_PHYSICAL_ATTACK_UPPER_ID,
						RolePropertyConst.ROLE_PROPERTY_PHSICAL_ATTACK_LOWER_ID,
						RolePropertyConst.ROLE_PROPERTY_TAOISM_ATTACK_UPPER_ID,
						RolePropertyConst.ROLE_PROPERTY_TAOISM_ATTACK_LOWER_ID];
					break;
				case JobConst.TYPE_DS:
					return [
						RolePropertyConst.ROLE_PROPERTY_PHYSICAL_ATTACK_UPPER_ID,
						RolePropertyConst.ROLE_PROPERTY_PHSICAL_ATTACK_LOWER_ID,
						RolePropertyConst.ROLE_PROPERTY_MAGIC_ATTACK_UPPER_ID,
						RolePropertyConst.ROLE_PROPERTY_MAGIC_ATTACK_LOWER_ID];
					break;
				default:
					return [];
					break;
			}
		}
		
		public static function getFightPower(att:String):Number
		{
			var list:Vector.<PropertyData> = getPropertyDatas(att);
			
			var re:Number = 0;
			for each(var data:PropertyData in list)
			{
				re += data.fightPower;
			}
			
			return re;
		}
			
		/***
		 * 请谨记这个方法没有去除重复
		 * */
		public static function getPropertyDatas(att:String,isFilterMain:Boolean=false,filterIDs:Array=null,job:int = 0):Vector.<PropertyData>
		{
			var propertyArr:Array = att.split("|");
			var mainAttributeArr:Vector.<PropertyData> = new Vector.<PropertyData>();
			var associateAttributeArr:Vector.<PropertyData>= new Vector.<PropertyData>();;
			var i:int = 0;
			while(i < propertyArr.length)
			{

				var eachAttArr:Array = propertyArr[i].split(":");
				var propertyId:int = eachAttArr[0];
				var perCentFlag:int = eachAttArr[1];
				var property:Number = eachAttArr[2];
				property = perCentFlag == RolePropertyConst.PERCENT_TYPE ? property*.1 : property;
				
				if(isFilterMain==true) //如果需要过滤数据
				{
					var isContinue:Boolean=false;
					for each(var fId:int in filterIDs)
					{
						if(propertyId==fId)
						{
							isContinue=true;
							++i;
							break;
						}
					}
					if(isContinue)
					{
						continue;
					}
				}
				//
				var propertyName:String = RolePropertyConst.getPropertyName(propertyId);
				var value:Number = getFightCalculateValue(propertyId,perCentFlag,property);
				var propertyFightPower:Number = RolePropertyConst.getPropertyFightPower(propertyId,value,job);
				var color:int;
				var isMainAttribute:Boolean = false;
				var indexOf:int = rangePropertyArr.indexOf(propertyId);
				if(indexOf != -1)
				{
					var propertyStr:String = propertyArr[i+1] as String;
					if(propertyStr)
					{
						var nextAttArr:Array = propertyStr.split(":");
						var propertyIdNext:int = nextAttArr[0];
						if(propertyId+1 == propertyIdNext)
						{
							var perCentFlagNext:int = nextAttArr[1];
							var propertyNext:Number = nextAttArr[2];
							propertyName = rangePropertyName[indexOf];
							value = getFightCalculateValue(propertyIdNext,perCentFlagNext,propertyNext);
							propertyFightPower += RolePropertyConst.getPropertyFightPower(propertyIdNext,value,job);
							isMainAttribute = true;
							color = 0xffe1aa;
							i+=2;
						}
					}
				}
				if(!isMainAttribute)
				{
					color = 0xffcc00;
					i++;
				}
				//
				var tempArr:Vector.<PropertyData> = isMainAttribute ? mainAttributeArr : associateAttributeArr;
				var propertyData:PropertyData = new PropertyData();
				var cfgDt:AttrCfgData = ConfigDataManager.instance.attrCfgData(propertyId);
				var type:int = cfgDt.percentage || perCentFlag == RolePropertyConst.PERCENT_TYPE ? RolePropertyConst.PERCENT_TYPE : RolePropertyConst.NUM_TYPE;
				propertyData.propertyId = propertyId;
				propertyData.name = propertyName;
				propertyData.type = type;
				propertyData.color = color;
				propertyData.isMain = isMainAttribute;
				propertyData.value = property;
				propertyData.value1 = isMainAttribute ? int(propertyNext) : property;
				propertyData.fightPower = int(propertyFightPower+.001);
				tempArr.push(propertyData);
			}
			return mainAttributeArr.concat(associateAttributeArr);
		}
		/**获取用于计算战斗力的值*/
		private static function getFightCalculateValue(propertyId:int,perCentFlag:int,property:int):Number
		{
			var value:Number = 0;
			var manager:RoleDataManager = RoleDataManager.instance;
			if(perCentFlag == RolePropertyConst.PERCENT_TYPE)
			{
				var valueBase:int = manager.getAttrValueByType(propertyId);
				value = valueBase*property*.001;
			}
			else
			{
				value = property;
			}
			//
			var probit:Number = 1;
			if(propertyId == RolePropertyConst.ROLE_PROPERTY_CRIT_HURT_ID)
			{
				probit = manager.getAttrValueByType(RolePropertyConst.ROLE_PROPERTY_CRIT_ID) * .01;
			}
			else if(propertyId == RolePropertyConst.ROLE_PROPERTY_PARRY_VALUE_ID)
			{
				probit = manager.getAttrValueByType(RolePropertyConst.ROLE_PROPERTY_PARRY_ID) * .01;
			}
			value *= probit;
			return value;
		}
		/**
		 * 解析带颜色字符串
		 * @param des 使用|分隔的形如“|#ffffff|恢复道具”的字符串
		 * @param defaultColor
		 * @return 多行字符串数组
		 */		
		public static function pareseDes(des:String, defaultColor:int=0xffffff,leading:int = 3,size:int = 12):Array
		{
			var htmlStrArray:Array = [];
			var arr:Array = des.split("|n|");
			for each(var str:String in arr)
			{
				var colorStr:String = defaultColor.toString(16),valueStr:String,lineStr:String = "";
				var split:Array = str.split("|"),i:int,l:int;
				if(split[0] == "")
				{
					split.shift();
				}
				l = split.length/2;
				for(i=0;i<l;i++)
				{
					colorStr = (split[i*2] as String).replace("#","");
					valueStr = split[i*2+1];
					lineStr += HtmlUtils.createHtmlStr(parseInt(colorStr,16),valueStr,size,false,leading);
				}
				if(split.length==1)
				{
					htmlStrArray.push(HtmlUtils.createHtmlStr(parseInt(colorStr,16),split[0],size,false,leading));
				}
				else
				{
					htmlStrArray.push(lineStr);
				}
			}
			return htmlStrArray;
		}
		
		/**
		 *字符串转成xml格式 
		 * @param des
		 * @return 
		 * 
		 */	
		public static function pareseDesToXml(des:String):String
		{
			var htmlStrArray:Array = [];
			var colorStr:String,valueStr:String,lineStr:String = "";
			var split:Array = des.split("|"),i:int,l:int;
			if(split[0] == "")
			{
				split.shift();
			}
			l = split.length/2;
			for(i=0;i<l;i++)
			{
				colorStr = (split[i*2] as String).replace("#","");
				valueStr = split[i*2+1];
				lineStr += "<link " + "{" + String(i) + "}" + "color='0x" + colorStr + "'>" + valueStr + "</link>";
			}
 			return lineStr;
		}
		
		public static function pareseDesToStr(des:String, defaultColor:int=0xffffff,leading:int = 3,size:int = 12):String
		{
			var arr:Array = pareseDes(des,defaultColor,leading,size);
			var len:int = arr.length;
			var htmlText:String = "";
			for(var i:int=0;i<len;i++)
			{
				if(i<len-1)
				{
					htmlText += arr[i]+"\n";
				}
				else
				{
					htmlText += arr[i];
				}
			}
			return htmlText;
		}
		/**
		 * 根据传入的字符串解析出对应的数据信息列表
		 * @param str 形如x:x:x|y:y:y
		 * @return 解析成的数据信息列表
		 */		
		public static function propertyDatas(str:String):Vector.<ReincarnData>
		{
			var vector:Vector.<ReincarnData> = new Vector.<ReincarnData>();
			var thingsStrs:Array,i:int,l:int,dt:ReincarnData;
			thingsStrs = str.split("|");
			l = thingsStrs.length;
			for(i=0;i<l;i++)
			{
				dt = propertyData(thingsStrs[i]);
				vector.push(dt);
			}
			return vector;
		}
		/**
		 * 根据传入的字符串解析出对应的数据信息
		 * @param str 形如x:x:x
		 * @return 解析成的数据信息
		 */		
		public static function propertyData(str:String):ReincarnData
		{
			var split:Array = str.split(":");
			var attr:int = int(split[0]);
			var type:int = int(split[1]);
			var value:int = int(split[2]);
			var dt:ReincarnData = new ReincarnData();
			dt.attr = attr;
			dt.type = type;
			dt.value = value;
			return dt;
		}
	}
}