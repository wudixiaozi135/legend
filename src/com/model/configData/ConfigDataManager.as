package com.model.configData
{
    import com.model.configData.cfgdata.*;
    import com.model.configData.constants.ConfigType;
    import com.view.gameWindow.util.ObjectUtils;
    
    import flash.utils.Dictionary;
    import flash.utils.getTimer;
    
    import mx.core.ByteArrayAsset;

    public final class ConfigDataManager
	{
		private static var _instance:ConfigDataManager;


		public static function get instance():ConfigDataManager
		{
			if(!_instance)
				_instance = new ConfigDataManager(); 
			return _instance;
		}
		
		private var _maxOpenDay:int;
		
		public function get maxOpenDay():int
		{
			return _maxOpenDay;
		}
		
		public function set maxOpenDay(value:int):void
		{
			_maxOpenDay = value;
		}
		
		public function ConfigDataManager()
		{
			_dictionary = new Dictionary();
		}
		private var _dictionary:Dictionary;

		private var _lastNameConfig:Array;

		public function get lastNameConfig():Array
		{
			return _lastNameConfig;
		}

		private var _maleNameConfig:Array;

		public function get maleNameConfig():Array
		{
			return _maleNameConfig;
		}

		private var _femaleNameConfig:Array;

		public function get femaleNameConfig():Array
		{
			return _femaleNameConfig;
		}

		public function get nameWordConfig():Dictionary
		{
			return _dictionary[ConfigType.KeyNameWord];
		}

		public function initData(cfgInfos:Vector.<ConfigDataItem>):void
		{
			var time1:int = getTimer();
			var l:int = cfgInfos.length;
			for (var i:int = 0; i < l; i++)
			{
				var time3:int = getTimer();
				rslvData(cfgInfos[i].dicKey, cfgInfos[i].idNames, cfgInfos[i].EmbedClass, cfgInfos[i].DataItemClass);
				var time4:int = getTimer();
				trace("ConfigDataManager.initData(cfgInfos) 表"+cfgInfos[i].EmbedClass+"，花费："+(time4 - time3));
			}
			var time2:int = getTimer();
			trace("ConfigDataManager.initData(cfgInfos) 总消耗时间："+(time2 - time1));
		}
		/**解析配置信息*/
		private function rslvData(dicKey:int, idNames:String, EmbedClass:Class, DataItemClass:Class):void
		{
			var dictionary:Dictionary, tempDic:Dictionary, vctIdName:Vector.<String>, idName:String;
			var byteArray:ByteArrayAsset, infos:String;
			var split:Vector.<String>;
			var substr:String;
			var split2:Vector.<String>, header:String, varNames:Vector.<String>, dataItem:Object;
			var i:int, il:int, j:int, jl:int, k:int, kl:int;
			
			//构建储存字典以及id名称数组
			dictionary = new Dictionary();
			vctIdName = Vector.<String>(idNames.split(","));
			//
			byteArray = ByteArrayAsset(new EmbedClass());
			infos = byteArray.readUTFBytes(byteArray.length);
			/*trace(infos);*/
			//取变量名
			split = Vector.<String>(infos.split("[data]\r\n"));
			substr = split[0].substr(8);
			split2 = Vector.<String>(substr.split("\r\n"));
			while (split2[split2.length - 1] == "")
			{
				split2.pop()
			}
			while (split2[0] == "")
			{
				split2.shift();
			}
			varNames = new Vector.<String>();
			for each(header in split2)
			{
				varNames.push(header.split("\t")[0]);
			}
			//数据赋值
			split = Vector.<String>(split[1].split("\r\n"));
			while (split.length - 1 != -1 && split[split.length - 1] == "")
			{
				split.pop();//删除无用的最后一个空字符串
			}
			il = split.length;
			for (i = 0; i < il; i++)//行
			{
				split2 = Vector.<String>(split[i].split("\t"));//列
				dataItem = new DataItemClass();
				jl = varNames.length;
				for (j = 0; j < jl; j++)
				{
					dataItem[varNames[j]] = split2[j];
				}
				tempDic = dictionary;
				kl = vctIdName.length;
				for (k = 0; k < kl; k++)
				{
					if (k == kl - 1)
					{
						tempDic[dataItem[vctIdName[k]]] = dataItem;
					}
					else
					{
						if (!tempDic[dataItem[vctIdName[k]]])
							tempDic[dataItem[vctIdName[k]]] = new Dictionary();
						tempDic = tempDic[dataItem[vctIdName[k]]];
					}
				}
			}
			_dictionary[dicKey] = dictionary;
			if(dicKey == ConfigType.KeyWorldLevel)
				geyMaxOpenDay();
		}
		/**
		 * 获取配置表中世界等级最大值
		 */
		private function geyMaxOpenDay():void
		{
			// TODO Auto Generated method stub
			var dic:Dictionary = _dictionary[ConfigType.KeyWorldLevel];
			var max:int;
			for each(var cfg:WorldLevelCfgData in dic)
			{
				if(cfg.open_day>max)
					max = cfg.open_day;
			}
			_maxOpenDay = max;
		}
		/**
		 * 在多层字典中搜索获取配置数据类（防报空）
		 * @param vars 键值数组，后入先出
		 * @param object 顶层字典
		 * @return
		 */
		private function searchGetCfgDt(vars:Vector.<int>, object:Object):Object
		{
			while (vars.length)
			{
				object = object[vars.pop()];
				if (!object)
				{
					return null;
				}
			}
			return object;
		}

        public function wingUpgrade():Dictionary
        {
            return _dictionary[ConfigType.KeyWingUpgrade];
        }

        public function wingUpgradeCfg(id:int):WingUpgradeCfgData
        {
            return _dictionary[ConfigType.KeyWingUpgrade][id];
        }

        public function loginReward():Dictionary
        {
            return _dictionary[ConfigType.KeyFifteenReward];
        }

        public function stoneExchangeShopCfgData(id:int):StoneExchangeShopCfgData
        {
            return _dictionary[ConfigType.KeyExchangeShop][id];
        }

        public function stoneExchangeShop():Dictionary
        {
            return _dictionary[ConfigType.KeyExchangeShop];
        }

        public function stoneExchangeShopItemCfgData(groupId:int, index:int):StoneExchangeShopItemCfgData
        {
            return _dictionary[ConfigType.KeyExchangeShopItem][groupId][index];
        }

        public function stoneExchangeShopItem(groupId:int):Dictionary
        {
            return _dictionary[ConfigType.KeyExchangeShopItem][groupId];
        }

        public function everydayRewardCfg(id:int):EveryDayRewardCfgData
        {
            return _dictionary[ConfigType.KeyEveryDayReward][id];
        }
        public function loginRewardCfg(day:int):LoginRewardCfgData
        {
            return _dictionary[ConfigType.KeyFifteenReward][day];
        }
        public function firstChargeReward(id:int):FirstChargeRewardCfgData
        {
            return _dictionary[ConfigType.KeyFirstChargeReward][id];
        }
        public function keepGameCfgData(id:int):KeepRewardCfgData
        {
            return _dictionary[ConfigType.KeyKeepGame][id];
        }
		public function npcShopCfgData(npc_id:int, id:int):NpcShopCfgData
		{
			var cfgDt:NpcShopCfgData;
			for each(cfgDt in _dictionary[ConfigType.keyNpcShop])
			{
				if(cfgDt.npc_id == npc_id && cfgDt.id == id)
				{
					return cfgDt;
				}
			}
			return null;
		}

		public function npcShopCfgData1(id:int):NpcShopCfgData
		{
			return _dictionary[ConfigType.keyNpcShop][id];
		}

		public function npcShopCfgDataByBase(base:int):NpcShopCfgData
		{
			var cfgDt:NpcShopCfgData;
			for each(cfgDt in _dictionary[ConfigType.keyNpcShop])
			{
				if(cfgDt.base == base)
				{
					return cfgDt;
				}
			}
			return null;
		}

		public function npcShopCfgDatas(npc_id:int):Dictionary
		{
			var dictionary:Dictionary = new Dictionary();
			var cfgDt:NpcShopCfgData;
			for each(cfgDt in _dictionary[ConfigType.keyNpcShop])
			{
				if(cfgDt.npc_id == npc_id)
				{
					dictionary[cfgDt.id] = cfgDt;
				}
			}
			return dictionary;
		}

		public function entityLayerCfgDatas(action:int, dir:int):Dictionary
		{
			return _dictionary[ConfigType.keyEntityLayer][action][dir];
		}

		public function entityLayerCfgData(action:int,dir:int,frame:int):EntityLayerCfgData
		{
			return _dictionary[ConfigType.keyEntityLayer][action][dir][frame];
		}

		public function levelGiftCfgDatas(index:int):LevelGiftCfgData
		{
			return _dictionary[ConfigType.keyLevelGift][index];
		}

		public function levelGiftCfgDic():Dictionary
		{
			return _dictionary[ConfigType.keyLevelGift];
		}

		public function treasureGiftCfgDic(type:int):Dictionary
		{
			return _dictionary[ConfigType.keyFindTreasureShopGift][type];
		}

		public function strongerCfgData(type:int, title:int):Dictionary
		{
			return _dictionary[ConfigType.keyStronger][type][title];
		}

		public function seaFeastGift():Dictionary
		{
			return _dictionary[ConfigType.keySeaSideGift];
		}

		/**
		 * 按职业,技能类型取所有对应的技能配置信息字典
		 * @param job 职业
		 * @param entity_type 技能类型，使用ConstSkill中的常量
		 * @param group_id 技能组ID
		 * @return 技能配置信息字典
		 */
		public function skillCfgDatas(job:int, entity_type:int, group_id:int = 0):Dictionary
		{
			var dictionary:Dictionary = new Dictionary();
			var cfgDt:SkillCfgData;
			if (group_id)
			{
				for each(cfgDt in _dictionary[ConfigType.keySkill])
				{
					if(cfgDt.job == job && cfgDt.entity_type == entity_type && cfgDt.group_id == group_id)
					{
						dictionary[cfgDt.level] = cfgDt
					}
				}
				return dictionary;
			}
			else
			{
				for each(cfgDt in _dictionary[ConfigType.keySkill])
				{
					if(cfgDt.job == job && cfgDt.entity_type == entity_type)
					{
						if(!dictionary[cfgDt.group_id])
						{
							dictionary[cfgDt.group_id] = new Dictionary();
						}
						dictionary[cfgDt.group_id][cfgDt.level] = cfgDt
					}
				}
				return dictionary;
			}
		}

		/**
		 * 根据不同参数获取技能配置信息<br>使用book可获取<br>使用group_id,level可获取<br>使用job,entity_type,group_id,level可获取
		 * @param job 职业
		 * @param entity_type 实体类型
		 * @param group_id 组id
		 * @param level 等级
		 * @param book 技能书id
		 * @return 技能配置信息
		 */
		public function skillCfgData(job:int = 0, entity_type:int = 0, group_id:int = 0, level:int = 0, book:int = 0):SkillCfgData
		{
			var cfgDt:SkillCfgData;
			if (!job && !entity_type && !group_id && !level && book)
			{
				for each(cfgDt in _dictionary[ConfigType.keySkill])
				{
					if(cfgDt.book == book)
					{
						return cfgDt;
					}
				}
			}
			else if (!job && !entity_type && group_id && level && !book)
			{
				for each(cfgDt in _dictionary[ConfigType.keySkill])
				{
					if(cfgDt.group_id == group_id && cfgDt.level == level)
					{
						return cfgDt;
					}
				}
			}
			else
			{
				for each(cfgDt in _dictionary[ConfigType.keySkill])
				{
					if(cfgDt.job == job && cfgDt.entity_type == entity_type && cfgDt.group_id == group_id && cfgDt.level == level)
					{
						return cfgDt;
					}
				}
			}
			return null;
		}
		
		public function skillCfgData1(skillId:int):SkillCfgData
		{
			return _dictionary[ConfigType.keySkill][skillId];
		}
		
		public function skillCfgDataByGroupID(groupId:int):SkillCfgData
		{
			var cfgDt:SkillCfgData;
			for each(cfgDt in _dictionary[ConfigType.keySkill])
			{
				if(cfgDt.group_id == groupId)
				{
					return cfgDt;
				}
			}
			return null;
		}

		public function skillCfgDataHeji(type:int, level:int, entity_type:int, job:int, job_mate:int):SkillCfgData
		{
			var cfgDt:SkillCfgData;
			for each(cfgDt in _dictionary[ConfigType.keySkill])
			{
				if(cfgDt.type == type && cfgDt.level == level && cfgDt.entity_type == entity_type && cfgDt.job == job && cfgDt.job_mate == job_mate)
				{
					return cfgDt;
				}
			}
			return null;
		}

		public function skillCfgDatasByRing(ringId:int, job:int):Dictionary
		{
			if (ringId)
			{
				var dictionary:Dictionary = new Dictionary();
				var cfgDt:SkillCfgData;
				for each(cfgDt in _dictionary[ConfigType.keySkill])
				{
					if(cfgDt.ring_id == ringId && cfgDt.job == job)
					{
						if(!dictionary[cfgDt.group_id])
						{
							dictionary[cfgDt.group_id] = new Dictionary();
						}
						dictionary[cfgDt.group_id][cfgDt.ring_level] = cfgDt;
					}
				}
				return dictionary;
			}
			else
			{
				return null;
			}
		}

		public function npcCfgData(id:int, mapid:int = 0):NpcCfgData
		{
			if (mapid == 0)
			{
				var dic:Dictionary;
				for each(dic in _dictionary[ConfigType.keyNpc])
				{
					if (dic[id])
						return dic[id];
				}
				return null;
			}
			else
			{
				return _dictionary[ConfigType.keyNpc][mapid][id];
			}
		}

		public function npcCfgDatas(mapid:int):Dictionary
		{
			return _dictionary[ConfigType.keyNpc][mapid];
		}

		public function allNpcCfgData():Dictionary
		{
			return _dictionary[ConfigType.keyNpc];
		}
		
		public function allTaskCfgData():Dictionary
		{
			return _dictionary[ConfigType.keyTask];
		}

		public function taskCfgData(id:int):TaskCfgData
		{
			return _dictionary[ConfigType.keyTask][id];
		}
		
		public function taskCfgDataByType(type:int):Array
		{
			var arr:Array=[];
			for each(var task:* in _dictionary[ConfigType.keyTask])
			{
				if(task.type==type)
				{
					arr.push(task);
				}
			}
			return arr;
		}

		public function taskCfgDatas(npcId:int):Dictionary
		{
			var dictionary:Dictionary = new Dictionary();
			var cfgDt:TaskCfgData;
			for each(cfgDt in _dictionary[ConfigType.keyTask])
			{
				if(cfgDt.start_npc == npcId)
				{
					dictionary[cfgDt.id] = cfgDt;
				}
			}
			return dictionary;
		}

		public function taskWantCfgDatas(id:int):Dictionary
		{
			return _dictionary[ConfigType.keyTaskWantCost][id];
		}

		public function taskCfgDataByStartNpcIdLv(npcId:int, lv:int):Vector.<TaskCfgData>
		{
			var cfgDt:TaskCfgData,vector:Vector.<TaskCfgData>;
			vector = new Vector.<TaskCfgData>();
			for each(cfgDt in _dictionary[ConfigType.keyTask])
			{
				if(cfgDt.start_npc == npcId && cfgDt.level <= lv && lv <= cfgDt.max_level)
				{
					vector.push(cfgDt);
				}
			}
			return vector;
		}

		public function taskCfgDataByEndNpcIdLv(npcId:int, lv:int):Vector.<TaskCfgData>
		{
			var dic:Dictionary, cfgDt:TaskCfgData, vector:Vector.<TaskCfgData>;
			vector = new Vector.<TaskCfgData>();
			for each(cfgDt in _dictionary[ConfigType.keyTask])
			{
				if (cfgDt.end_npc == npcId && cfgDt.level <= lv && lv <= cfgDt.max_level)
				{
					vector.push(cfgDt);
				}
			}
			return vector;
		}

		public function equipCfgData(id:int):EquipCfgData
		{
			return _dictionary[ConfigType.keyEquip][id];
		}

		public function heroEquipUpgradeCfgData(grade:int, order:int):HeroEquipUpgradeCfgData
		{
			return _dictionary[ConfigType.KeyHeroEquipUpgrade][grade][order];
		}
		
		public function heroGradeCfgData(grade:int):HeroGradeCfgData
		{
			return _dictionary[ConfigType.KeyHeroUpgrade][grade];
		}
		
		public function heroMeridiansCfgData(grade:int,level:int):HeroMeridiansCfgData
		{
			return _dictionary[ConfigType.KeyHeroMeridians][grade][level];
		}

		public function itemCfgData(id:int):ItemCfgData
		{
			return _dictionary[ConfigType.keyItem][id];
		}
		
		public function expYuAwardCfgData(id:int):ExpYuAwardCfgData
		{
			return _dictionary[ConfigType.keyExpYuAward][id];
		}

		public function mapCfgData(id:int):MapCfgData
		{
			return _dictionary[ConfigType.keyMap][id];
		}

		public function drpGrpCfgData(group_id:int, item_id:int):DropGroupCfgData
		{
			return _dictionary[ConfigType.keyMstDrpGrp][group_id][item_id];
		}
		
		public function drpGrpCfgDatas(group_id:int):Dictionary
		{
			return _dictionary[ConfigType.keyMstDrpGrp][group_id];
		}

		public function levelCfgData(level:int):LevelCfgData
		{
			return _dictionary[ConfigType.keyLv][level];
		}
		
		public function levelCfgArr():Dictionary
		{
			return _dictionary[ConfigType.keyLv];
		}

		public function mapPlantCfgDatas(plantGroupId:int):Dictionary
		{
			var dictionary:Dictionary = new Dictionary();
			var cfgDt:MapPlantCfgData;
			for each(cfgDt in _dictionary[ConfigType.keyMapPlant])
			{
				if(cfgDt.plant_group_id == plantGroupId)
				{
					dictionary[cfgDt.id] = cfgDt;
				}
			}
			return dictionary;
		}

		public function mapPlantCfgData(id:int, plantGroupId:int = 0):MapPlantCfgData
		{
			if (plantGroupId)
			{
				var cfgDt:MapPlantCfgData;
				for each(cfgDt in _dictionary[ConfigType.keyMapPlant])
				{
					if(cfgDt.plant_group_id == plantGroupId && cfgDt.id == id)
					{
						return cfgDt;
					}
				}
				return null;
			}
			else
			{
				return _dictionary[ConfigType.keyMapPlant][id];
			}
		}

		public function mapPlantCfgDatasByWave(map_id:int, wave:int):Array
		{
			var dict:Dictionary = _dictionary[ConfigType.keyMapPlant];

			var re:Array = [];
			for each(var data:MapPlantCfgData in dict)
			{
				if (data.map_id == map_id && data.wave == wave)
				{
					re.push(data);
				}
			}
			return re;
		}

		public function mapTrapCfgDatas(trapGroupId:int):Dictionary
		{
			var dictionary:Dictionary = new Dictionary();
			var cfgDt:MapTrapCfgData;
			for each(cfgDt in _dictionary[ConfigType.keyMapTrap])
			{
				if(cfgDt.trap_group_id == trapGroupId)
				{
					dictionary[cfgDt.id] = cfgDt;
				}
			}
			return dictionary;
		}

		public function mapTrapCfgData(id:int, trapGroupId:int = 0):MapTrapCfgData
		{
			if (trapGroupId)
			{
				var cfgDt:MapTrapCfgData;
				for each(cfgDt in _dictionary[ConfigType.keyMapTrap])
				{
					if(cfgDt.trap_group_id == trapGroupId && cfgDt.id == id)
					{
						return cfgDt;
					}
				}
				return null;
			}
			else
			{
				return _dictionary[ConfigType.keyMapTrap][id];
			}
		}

		public function mapTrapCfgDataByMap(mapId:int):Dictionary
		{
			var dictionary:Dictionary = new Dictionary();
			var cfgDt:MapTrapCfgData;
			for each(cfgDt in _dictionary[ConfigType.keyMapTrap])
			{
				if(cfgDt.map_id == mapId)
				{
					dictionary[cfgDt.id] = cfgDt;
				}
			}
			return dictionary;
		}

		public function mapTrapCfgDataByWave(mapId:int, wave:int):Array
		{
			var dict:Dictionary = mapTrapCfgDataByMap(mapId);

			var re:Array = [];
			for each(var item:MapTrapCfgData in dict)
			{
				if (item.wave == wave)
				{
					re.push(item);
				}
			}
			return re;
		}

		public function mapMstCfgDatas(mstGroupId:int):Dictionary
		{
			var dictionary:Dictionary = new Dictionary();
			var cfgDt:MapMonsterCfgData;
			for each(cfgDt in _dictionary[ConfigType.keyMapMst])
			{
				if(cfgDt.monster_group_id == mstGroupId)
				{
					dictionary[cfgDt.id] = cfgDt;
				}
			}
			return dictionary;
		}

		public function mapMstCfgData(id:int, mstGroupId:int = 0):MapMonsterCfgData
		{
			if (mstGroupId)
			{
				var cfgDt:MapMonsterCfgData;
				for each(cfgDt in _dictionary[ConfigType.keyMapMst])
				{
					if(cfgDt.monster_group_id == mstGroupId && cfgDt.id == id)
					{
						return cfgDt;
					}
				}
				return null;
			}
			else
			{
				return _dictionary[ConfigType.keyMapMst][id];
			}
		}

		public function mapMstCfgDataByMap(mapId:int):Dictionary
		{
			var dictionary:Dictionary;
			var cfgDt:MapMonsterCfgData;
			
			if(!_dictionary[ConfigType.keyMapMstByMap])
			{
				_dictionary[ConfigType.keyMapMstByMap] = new Dictionary();
			}
			
			dictionary = _dictionary[ConfigType.keyMapMstByMap][mapId];
			
			if(!dictionary)
			{
				dictionary = new Dictionary();
				for each(cfgDt in _dictionary[ConfigType.keyMapMst])
				{
					if(cfgDt.map_id == mapId)
					{
						dictionary[cfgDt.id] = cfgDt;
					}
				}
				_dictionary[ConfigType.keyMapMstByMap][mapId] = dictionary;
			}
			
			return dictionary;
		}

		public function bossCfgDataByGroupId(groupId:int):BossCfgData
		{
			return _dictionary[ConfigType.keyBoss][groupId]
		}
		
		public function mapBossCfgData(monster_group_id:int):*
		{
			return _dictionary[ConfigType.keyMapBoss][monster_group_id];
		}
		
		public function mapBossCfgDataById(monster_group_id:int,map_monster_id:int):MapBossCfgData
		{
			return _dictionary[ConfigType.keyMapBoss][monster_group_id][map_monster_id];
		}
		
		public function bossCfgData():Dictionary
		{
			return _dictionary[ConfigType.keyBoss];
		}

		public function bossCfgDatasByType(type:int):Dictionary
		{
			var dictionary:Dictionary = new Dictionary();
			var cfgDt:BossCfgData;
			for each(cfgDt in _dictionary[ConfigType.keyBoss])
			{
				if(cfgDt.type == type)
				{
					dictionary[cfgDt.monster_group_id] = cfgDt;
				}
			}
			return dictionary;
		}

		public function jobCfgDatasById(id:int):JobCfgData
		{
			return _dictionary[ConfigType.KeyJob][id];
		}

		public function mapMstCfgDataByWave(mapId:int, wave:int):Array
		{
			var dict:Dictionary = mapMstCfgDataByMap(mapId);

			var re:Array = [];
			for each(var item:MapMonsterCfgData in dict)
			{
				if (item.wave == wave)
				{
					re.push(item);
				}
			}
			return re;
		}

		public function mapRegionCfgData(id:int):MapRegionCfgData
		{
			return _dictionary[ConfigType.keyMapRegion][id];
		}

		public function mapRegionCfgDatasByMap(mapId:int):Dictionary
		{
			var dictionary:Dictionary = new Dictionary();
			var cfgDt:MapRegionCfgData;
			for each(cfgDt in _dictionary[ConfigType.keyMapRegion])
			{
				if(cfgDt.map_id == mapId)
				{
					dictionary[cfgDt.id] = cfgDt;
				}
			}
			return dictionary;
		}

		public function mapTeleporterCfgData(id:int, mapid:int = 0):MapTeleportCfgData
		{
			if (mapid == 0)
			{
				var dic:Dictionary;
				for each(dic in _dictionary[ConfigType.keyMapTlpt])
				{
					if (dic[id])
						return dic[id];
				}
				return null;
			}
			else
			{
				return _dictionary[ConfigType.keyMapTlpt][mapid][id];
			}
		}

		public function mapTeleporterCfgDatas(mapid:int):Dictionary
		{
			return _dictionary[ConfigType.keyMapTlpt][mapid];
		}

		public function allMapTeleporterCfgData():Dictionary
		{
			return _dictionary[ConfigType.keyMapTlpt];
		}
		
		public function equipDuijieSuitCfgData(id:int):EquipDuijieSuitCfgData
		{
			return _dictionary[ConfigType.KeyEquipDuiJieSuit][id];
		}

		public function monsterCfgData(id:int):MonsterCfgData
		{
			return _dictionary[ConfigType.keyMst][id];
		}

		public function monsterCfgDatas(group_id:int):Dictionary
		{
			var dictionary:Dictionary;
			var cfgDt:MonsterCfgData;
			
			if(!_dictionary[ConfigType.keyMstByGroupId])
			{
				_dictionary[ConfigType.keyMstByGroupId] = new Dictionary();
			}
			
			dictionary = _dictionary[ConfigType.keyMstByGroupId][group_id];
			
			if(!dictionary)
			{
				dictionary = new Dictionary();
				for each(cfgDt in _dictionary[ConfigType.keyMst])
				{
					if(cfgDt.group_id == group_id)
					{
						dictionary[cfgDt.id] = cfgDt;
					}
				}
				_dictionary[ConfigType.keyMstByGroupId][group_id] = dictionary;
			}
			
			return dictionary;
		}

		/**材料合成数据*/
		public function combineData(type:int):Dictionary
		{
			return _dictionary[ConfigType.keyCombine][type];
		}

		/**获取某一级分类中二级分类中所有材料*/
		public function getType2Data(type:int, type2:int):Vector.<CombineCfgData>
		{
			var dic:Dictionary=_dictionary[ConfigType.keyCombine][type];
			var vec:Vector.<CombineCfgData>=new Vector.<CombineCfgData>;
			for each(var comboineMsg:CombineCfgData in dic)
			{
				if (comboineMsg.distinguish == type2)
				{
					vec.push(comboineMsg);
				}
			}
			return vec;
		}

		/**根据ID获取数据*/
		public function getCombineDataByID(type:int, id:int):CombineCfgData
		{
			var dic:Dictionary = _dictionary[ConfigType.keyCombine][type];
			var vec:Vector.<CombineCfgData> = new Vector.<CombineCfgData>;
			for each(var comboineMsg:CombineCfgData in dic)
			{
				if (comboineMsg.id == id)
				{
					return comboineMsg;
				}
			}
			return null;
		}

		public function dungeonCfgData(npc:int):Dictionary
		{
			var dic:Dictionary;
			for each(dic in _dictionary[ConfigType.keyDungeon])
			{
				if (_dictionary[ConfigType.keyDungeon][npc])
				{
					return _dictionary[ConfigType.keyDungeon][npc];
				}
				else
				{
					return null;
				}
			}
			return _dictionary[ConfigType.keyDungeon][npc];
		}
		
		public function dgnCfgDts(funcType:int):Vector.<DungeonCfgData>
		{
			var dic:Dictionary;
			var cfgDt:DungeonCfgData;
			var vector:Vector.<DungeonCfgData> = new Vector.<DungeonCfgData>();
			for each(dic in _dictionary[ConfigType.keyDungeon])
			{
				for each(cfgDt in dic)
				{
					if(cfgDt.func_type == funcType)
					{
						vector.push(cfgDt);
					}
				}
			}
			return vector;
		}

		public function dungeonCfgDataId(dungeonId:int):DungeonCfgData
		{
			return _dictionary[ConfigType.keyDungeonId][dungeonId];
		}

		public function dungeonEventCfgData(dungeonId:int, triggerId:int, step:int = -1):DgnEventCfgData
		{
			if (step != -1)
			{
				return _dictionary[ConfigType.keyDungeonEvent1][dungeonId][step];
			}
			else
			{
				return _dictionary[ConfigType.keyDungeonEvent][dungeonId][triggerId];
			}
		}
		
		public function dungeonEventCfgDatas(dungeonId:int):Dictionary
		{
			return _dictionary[ConfigType.keyDungeonEvent][dungeonId];
		}

		public function dgnShopCfgData(dungeonId:int, itemId:int):DgnShopCfgData
		{
			var object:Object = _dictionary[ConfigType.keyDungeonShop];
			return searchGetCfgDt(Vector.<int>([itemId,dungeonId]),object) as DgnShopCfgData;
		}

		public function dungeonEventCfgDataDict(dungeonId:int):Dictionary
		{
			return _dictionary[ConfigType.keyDungeonEvent][dungeonId];
		}

		public function dungeonRewardEvaluateCfgData(dungeonId:int, star:int):DgnRewardEvaluateCfgData
		{
			return _dictionary[ConfigType.keyDungeonRewardEvaluate][dungeonId][star];
		}

		public function dungeonRewardEvaluateDict(dungeonId:int):Dictionary
		{
			return _dictionary[ConfigType.keyDungeonRewardEvaluate][dungeonId];
		}
		
		public function dungeonRewardMultipleCfgData(dungeonId:int):Dictionary
		{
			return _dictionary[ConfigType.keyDungeonRewardMultiple][dungeonId];
		}
		
		public function dgnRewardCardGroupCfgData(groupId:int,id:int):DgnRewardCardGroupCfgData
		{
			return _dictionary[ConfigType.keyDungeonRewardCardGroup][groupId][id];
		}
		
		public function dgnRewardCardGroupCfgDatas(groupId:int):Vector.<DgnRewardCardGroupCfgData>
		{
			var vector:Vector.<DgnRewardCardGroupCfgData> = new Vector.<DgnRewardCardGroupCfgData>();
			var cfgDt:DgnRewardCardGroupCfgData;
			for each(cfgDt in _dictionary[ConfigType.keyDungeonRewardCardGroup][groupId])
			{
				vector.push(cfgDt);
			}
			vector.sort(function (item1:DgnRewardCardGroupCfgData,item2:DgnRewardCardGroupCfgData):int
			{
				return item2.probability - item1.probability;
			});
			return vector;
		}
		
		public function dgnRewardCardGoldCfgData(num:int):DgnRewardCardGoldCfgData
		{
			return _dictionary[ConfigType.keyDungeonRewardCardGold][num];
		}
		
		public function npcTeleportCfgData(id:int):NpcTeleportCfgData
		{
			return _dictionary[ConfigType.npcTeleport][id];
		}
		
		public function npcTeleportCfgDatas(npc:int):Dictionary
		{
			var cfgDts:Dictionary = new Dictionary();
			var dic:Dictionary = _dictionary[ConfigType.npcTeleport] as Dictionary;
			var cfgDt:NpcTeleportCfgData;
			for each (cfgDt in dic) 
			{
				if(cfgDt && cfgDt.npc == npc)
				{
					cfgDts[cfgDt.id] = cfgDt;
				}
			}
			return cfgDts;
		}

		public function plantCfgData(plantId:int):PlantCfgData
		{
			return _dictionary[ConfigType.keyPlant][plantId];
		}

		public function closetCfgData(type:int, level:int):ClosetCfgData
		{
			return _dictionary[ConfigType.keyCloset][type][level];
		}
		
		public function equipStrengthen(level:int):EquipStrengthenCfgData
		{
			return _dictionary[ConfigType.keyEquipStrengthen][level];
		}

		public function equipStrengthenAttr(type:int, level:int):EquipStrengthenAttrCfgData
		{
			return _dictionary[ConfigType.keyEquipStrengthenAttr][type][level];
		}

		public function equipRecycleCfgData(type:int, quality:int, level:int):EquipRecycleCfgData
		{
			var dic:Dictionary = _dictionary[ConfigType.keyEquipRecycle][type];
			if (!dic)
			{
				return null
			}
			dic = dic[quality];
			if (!dic)
			{
				return null;
			}
			var cfgData:EquipRecycleCfgData, floorCfgData:EquipRecycleCfgData;//取小于目标等级的最大配置等级
			for each(cfgData in dic)
			{
				if (cfgData.level <= level)
				{
					if (!floorCfgData || cfgData.level > floorCfgData.level)
					{
						floorCfgData = cfgData;
					}
				}
			}
			return floorCfgData;
		}

		public function equipRecycleRwdCfgData(levelmax:int,index:int):EquipRecycleRwdCfgData
		{
			return _dictionary[ConfigType.keyEquipRecycleReward][levelmax][index];
		}
		
		/**
		 * 将实际点数转化为显示需要的值
		 * @param point
		 * @return
		 */
		/*public function equipRecycleViewRewardPoint(point:int):int
		{
		var dic:Dictionary, i:int, l:int, temp:EquipRecycleRwdCfgData;
		var x1:int, x2:int, yL:Number, y1:int, y2:int, k:Number, b:Number;
		dic = _dictionary[ConfigType.keyEquipRecycleReward];
		l = equipRecycleRwdCfgDataLength();
		temp = equipRecycleRwdCfgDataMax();
		yL = temp.reward_point / l;
		for (i = 0; i < l; i++)
		{
		x1 = dic[i - 1] ? (dic[i - 1] as EquipRecycleRwdCfgData).reward_point : 
		
		0;
		x2 = (dic[i] as EquipRecycleRwdCfgData).reward_point;
		if (x1 < point && point <= x2)
		{
		y1 = yL * i;
		y2 = yL * (i + 1);
		k = (y2 - y1) / (x2 - x1);
		b = (y1 * x2 - y2 * x1) / (x2 - x1);
		return k * point + b;
		}
		}
		return temp.reward_point;
		}*/
		
		public function equipRecycleRwdCfgDataLength(levelmax:int):int
		{
			var dic:Dictionary, dt:EquipRecycleRwdCfgData, l:int;
			dic = _dictionary[ConfigType.keyEquipRecycleReward][levelmax];
			for each(dt in dic)
			{
				l++;
			}
			return l;
		}
		
		public function equipRecycleRwdCfgDataMax(levelmax:int):EquipRecycleRwdCfgData
		{
			var dic:Dictionary, dt:EquipRecycleRwdCfgData, maxDt:EquipRecycleRwdCfgData;
			dic = _dictionary[ConfigType.keyEquipRecycleReward][levelmax];
			for each(dt in dic)
			{
				if (!maxDt || maxDt.reward_point < dt.reward_point)
				{
					maxDt = dt;
				}
			}
			return maxDt;
		}

		public function taskStarRewardCfgData(level:int, type:int):TaskStarRewardCfgData
		{
			return _dictionary[ConfigType.keyTaskStarReward][level][type];
		}

		public function taskStarRateCfgData(star:int):TaskStarRateCfgData
		{
			return _dictionary[ConfigType.keyTaskStarRate][star];
		}

		public function taskStarCostCfgData(rate:int):TaskStarCostCfgData
		{
			return _dictionary[ConfigType.keyTaskStarCost][rate];
		}

		public function taskWantedDailyReward(id:int):TaskWantedDailyRewardCfgData
		{
			return _dictionary[ConfigType.keyTaskWantedDailyReward][id];
		}
		
		public function mapVipCfgData(id:int):MapVipCfgData
		{
			return _dictionary[ConfigType.keyMapVip][id];
		}
		
		public function mapVipCfgDataArray():Array
		{
			return ObjectUtils.dicToArr(_dictionary[ConfigType.keyMapVip]);
		}

		public function bannedWordCfgData():Dictionary
		{
			return _dictionary[ConfigType.keyBannedWord];
		}

		public function equipDegreeCfgData(id:int):EquipDegreeCfgData
		{
			return _dictionary[ConfigType.keyEquipDegree][id];
		}

		public function equipResolveCfgData(id:int):EquipResolveCfgData
		{
			return _dictionary[ConfigType.keyEquipResolve][id];
		}

		public function qualityCfgData(quality:int):QualityCfgData
		{
			return _dictionary[ConfigType.keyQuality][quality];
		}

		public function trapCfgData(id:int):TrapCfgData
		{
			return _dictionary[ConfigType.keyTrap][id];
		}

		public function mailCfgData(id:int):MailCfgData
		{
			return _dictionary[ConfigType.keyMail][id];
		}

		public function itemTypeCfgData(id:int):ItemTypeCfgData
		{
			return _dictionary[ConfigType.keyItemType][id];
		}
		
		public function familyPositionCfgData(position:int):FamilyPositionCfgData
		{
			return _dictionary[ConfigType.keySchoolPosition][position];
		}
		
		public function familyAddMemberCfgData(number:int):FamilyAddMemberCfgData
		{
			return _dictionary[ConfigType.keySchoolAddMember][number];
		}

		public function equipExchangeCfgData(id:int):EquipExchangeCfgData
		{
			return _dictionary[ConfigType.keyEquipExchange][id];
		}

		public function equipExchangeNextCfgData(id:int):EquipExchangeCfgData
		{
			return _dictionary[ConfigType.keyEquipExchangeNext][id];
		}

		public function equipExchangeCfgDataByStep(id:int,step:int):Dictionary
		{
			var dic:Dictionary = _dictionary[ConfigType.keyEquipExchange];
			var re:Dictionary = new Dictionary();
			var type:int = equipCfgData(id).type;
			var t:int;
			for each(var cfg:EquipExchangeCfgData in dic)
			{
				t = equipCfgData(cfg.id).type;
				if(cfg.step == step&&t == type)
				{
					re[cfg.id] = cfg;
				}
			}
			return re;
		}
		
		public function uselessSellCfgDatas(level:int,worldLevel:int):Vector.<UselessSellCfgData>
		{
			var vector:Vector.<UselessSellCfgData> = new Vector.<UselessSellCfgData>();
			var data:UselessSellCfgData;
			var i:int;
			var j:int;
			for (i = 1; i <= level; i++)
			{
				for (j=0;j<=worldLevel;j++) 
				{
					var dictionary:Dictionary = _dictionary[ConfigType.keyUselessSell][i] as Dictionary;
					if (!dictionary)
					{
						continue;
					}
					dictionary = dictionary[j];
					if (!dictionary)
					{
						continue;
					}
					for each(data in dictionary)
					{
						vector.push(data);
					}
				}
			}
			return vector;
		}

		public function peerageCfgData(id:int):PeerageCfgData
		{
			return _dictionary[ConfigType.keyPeerage][id];
		}

		public function peerageDescCfgData(id:int):Dictionary
		{
			return _dictionary[ConfigType.keyPeerageDesc][id];
		}

		public function vipCfgData(lv:int):VipCfgData
		{
			return _dictionary[ConfigType.keyVip][lv];
		}
		public function getAllVipCfgData():Dictionary
		{
			return _dictionary[ConfigType.keyVip]
		}
		
		public function getSpecialFlagVipCfgData(item:String):VipCfgData
		{
			var dic:Dictionary = _dictionary[ConfigType.keyVip];
			var data:VipCfgData;
			for each(var temp:VipCfgData in dic)
			{
				if(temp[item] > 0)
				{
					data = temp;
					break;
				}
			}
			return data;
		}
		public function specialRingCfgDatas(job:int):Vector.<SpecialRingCfgData>
		{
			var dictionary:Dictionary = _dictionary[ConfigType.keySpecialRing] as Dictionary;
			var cfgDt:SpecialRingCfgData;
			var vector:Vector.<SpecialRingCfgData> = new Vector.<SpecialRingCfgData>();
			for each (cfgDt in dictionary)
			{
				if(cfgDt.job == 0 || cfgDt.job == job)
				{
					vector.push(cfgDt);
				}
			}
			vector.sort(function (item1:SpecialRingCfgData,item2:SpecialRingCfgData):Number
			{
				return item1.id - item2.id;
			});
			return vector;
		}

		public function specialRingCfgData(id:int):SpecialRingCfgData
		{
			return _dictionary[ConfigType.keySpecialRing][id];
		}

		public function specialRingLevelCfgData(id:int, level:int):SpecialRingLevelCfgData
		{
			var obj:Object = _dictionary[ConfigType.keySpecialLevelRing];
			return searchGetCfgDt(Vector.<int>([level,id]),obj) as SpecialRingLevelCfgData;
		}
		
		public function specialRingLevelCfgDatas(id:int):Vector.<SpecialRingLevelCfgData>
		{
			var dictionary:Dictionary = _dictionary[ConfigType.keySpecialLevelRing][id] as Dictionary;
			var cfgDt:SpecialRingLevelCfgData;
			var vector:Vector.<SpecialRingLevelCfgData> = new Vector.<SpecialRingLevelCfgData>();
			for each (cfgDt in dictionary)
			{
				vector.push(cfgDt);
			}
			vector.sort(function (item1:SpecialRingLevelCfgData,item2:SpecialRingLevelCfgData):Number
			{
				return item1.level - item2.level;
			});
			return vector;
		}

		public function buffCfgData(id:int):BuffCfgData
		{
			return _dictionary[ConfigType.keyBuff][id];
		}

		public function specialRingDungeonCfgData(cell:int):SpecialRingDungeonCfgData
		{
			return _dictionary[ConfigType.keySpecialDungeonRing][cell];
		}

		/**
		 * 若order不为0则使用order获取数据
		 * @param id
		 * @param order
		 * @return
		 */
		public function dailyCfgData(id:int, order:int = 0):DailyCfgData
		{
			if (order)
			{
				return _dictionary[ConfigType.keyDaily1][order];
			}
			else
			{
				return _dictionary[ConfigType.keyDaily][id];
			}
		}

		public function dailyCfgDatas():Dictionary
		{
			return _dictionary[ConfigType.keyDaily];
		}

		public function dailyVitRewardCfgDataByOrder(order:int):DailyVitRewardCfgData
		{
			return _dictionary[ConfigType.keyDailyVitReward][order];
		}

		public function dailyVitRewardCfgDataBykey(daily_vit:int):DailyVitRewardCfgData
		{
			return _dictionary[ConfigType.keyDailyVitReward1][daily_vit];
		}

		public function activityCfgData(id:int):ActivityCfgData
		{
			return _dictionary[ConfigType.keyActivity][id];
		}
		
		public function activityCfgData1(npcId:int):ActivityCfgData
		{
			return _dictionary[ConfigType.keyActivity1][npcId];
		}
		
		public function activityCfgData2(funcType:int):ActivityCfgData
		{
			var dictionary:Dictionary = _dictionary[ConfigType.keyActivity] as Dictionary;
			var cfgDt:ActivityCfgData;
			for each (cfgDt in dictionary) 
			{
				if(cfgDt.func_type == funcType)
				{
					return cfgDt;
				}
			}
			return null;
		}
		
		public function activityTimeCfgDatas(id:int):Dictionary
		{
			return _dictionary[ConfigType.keyActivityTime][id];
		}
		
		public function activityTimeCfgData(id:int,index:int):ActivityTimeCfgData
		{
			return _dictionary[ConfigType.keyActivityTime][id][index];
		}
		
		public function activitytMapRegionCfgDatas(id:int):Dictionary
		{
			return _dictionary[ConfigType.keyActivityMapRegion][id];
		}
		
		public function activitytMapRegionCfgData(id:int,index:int):ActivityMapRegionCfgData
		{
			return _dictionary[ConfigType.keyActivityMapRegion][id][index];
		}

		public function activityCfgDatas():Dictionary
		{
			return _dictionary[ConfigType.keyActivity];
		}
		
		public function activityEventCfgData(activity_id:int,trigger_id:int):ActivityEventCfgData
		{
			var object:Object = _dictionary[ConfigType.keyActivityEvent];
			return searchGetCfgDt(Vector.<int>([trigger_id,activity_id]),object) as ActivityEventCfgData;
		}
		
		public function activityEventCfgDatas(activity_id:int):Dictionary
		{
			return _dictionary[ConfigType.keyActivityEvent][activity_id];
		}

		public function mstDigCfgData(mstId:int, count:int):MstDigCfgData
		{
			if (_dictionary[ConfigType.keyMstDig] && _dictionary[ConfigType.keyMstDig][mstId])
			{
				return _dictionary[ConfigType.keyMstDig][mstId][count];
			}
			return null;
		}

		public function mstDigNum(mstId:int):int
		{
			var dictionary:Dictionary, cfgDt:MstDigCfgData, count:int;
			dictionary = _dictionary[ConfigType.keyMstDig][mstId] as Dictionary;
			for each(cfgDt in dictionary)
			{
				count++;
			}
			return count;
		}

		public function petCfgData(petId:int):PetCfgData
		{
			if (_dictionary[ConfigType.keyPet])
			{
				return _dictionary[ConfigType.keyPet][petId];
			}
			return null;
		}
		
		public function getPetCfgData(group_id:int,grade:int):PetCfgData
		{
			if (_dictionary[ConfigType.keyPet])
			{
				for each(var cfg:PetCfgData in _dictionary[ConfigType.keyPet])
				{
					if(cfg.group_id == group_id && cfg.grade == grade)
					{
						return cfg;
					}
				}
			}
			return null;
		}
		
		public function guideCfgDatas():Dictionary
		{
			return _dictionary[ConfigType.KeyGuide];
		}

		public function guideCfgData(id:int):GuideCfgData
		{
			return _dictionary[ConfigType.KeyGuide][id];
		}

		public function unlockCfgDatas():Dictionary
		{
			return _dictionary[ConfigType.KeyUnlock];
		}

		public function unlockCfgData(id:int):UnlockCfgData
		{
			return _dictionary[ConfigType.KeyUnlock][id];
		}

		public function reincarnCfgData(reincarn:int):ReinCarnCfgData
		{
			return _dictionary[ConfigType.keyReinCarn][reincarn];
		}

		public function forEach(keys:Array, handler:Function):void
		{
			var dict:Dictionary = _dictionary;

			for (var i:int = 0; i < keys.length; ++i)
			{
				dict = dict[keys[i]];
			}

			for each(var item:Object in dict)
			{
				handler(item);
			}
		}

		public function setLastNameConfig(data:Array):void
		{
			this._lastNameConfig = data;
		}
		
		public function setMaleNameConfig(data:Array):void
		{
			this._maleNameConfig=data;
		}

		public function setFemaleNameConfig(data:Array):void
		{
			this._femaleNameConfig = data;
		}

		public function attrCfgData(attr_type:int):AttrCfgData
		{
			return _dictionary[ConfigType.keyAttr][attr_type];
		}

		public function achievementCfgData():Dictionary
		{
			return _dictionary[ConfigType.keyAchievement];
		}

		public function achievementCfgDataById(id:int):AchievementCfgData
		{
			return _dictionary[ConfigType.keyAchievement][id];
		}

		public function equipPolishCfgData(level:int):EquipPolishCfgData
		{
			return _dictionary[ConfigType.keyEquipPolish][level];
		}

		public function equipPolishAttrCfgData(type:int, level:int):EquipPolishAttrCfgData
		{
			var dictionary:Dictionary = _dictionary[ConfigType.keyEquipPolishAttr] as Dictionary;
			return !dictionary[type] ? null : dictionary[type][level];
		}

		/**
		 *
		 * @param quality 装备品质
		 * @param level 装备等级
		 * @return
		 */
		public function equipRefinedCfgData(quality:int, level:int):EquipRefinedCfgData
		{
			var dictionary:Dictionary = _dictionary[ConfigType.keyEquipRefined][quality] as Dictionary;
			if (dictionary)
			{
				var cfgDt:EquipRefinedCfgData;
				for each (cfgDt in dictionary)
				{
					if (cfgDt.level_min <= level && level <= cfgDt.level_max)
					{
						return cfgDt;
					}
				}
			}
			return null;
		}

		public function equipRefinedCostCfgData(level:int):EquipRefinedCostCfgData
		{
			var dictionary:Dictionary = _dictionary[ConfigType.keyEquipRefinedCost] as Dictionary;
			if (dictionary)
			{
				var cfgDt:EquipRefinedCostCfgData;
				for each (cfgDt in dictionary)
				{
					if (cfgDt.level_min <= level && level <= cfgDt.level_max)
					{
						return cfgDt;
					}
				}
			}
			return null;
		}
		
		public function getRuneTransformCfgData(id:int):RuneTransformCfgData
		{
			return _dictionary[ConfigType.keyRuneTransform][id];
		}

		public function equipRefinedSuiteCfgData(level:int):EquipRefinedSuiteCfgData
		{
			return _dictionary[ConfigType.keyEquipRefinedCost][level];
		}

		public function jointHaloCfgData(id:int, level:int):JointHaloCfgData
		{
			return _dictionary[ConfigType.keyJointHalo][id][level];
		}
		
		public function jointHaloCfgData1(halo_skill:int):JointHaloCfgData
		{
			//要保证id,level是连续的且从1开始，不是就嗝屁了。
			var id:int;
			var level:int;
			var cfgDt:JointHaloCfgData;
			id = 1;
			var object:Object = _dictionary[ConfigType.keyJointHalo];
			while(object[id])
			{
				level = 1;
				while(object[id][level])
				{
					cfgDt = object[id][level];
					if(cfgDt.halo_skill == halo_skill)
					{
						return cfgDt;
					}
					level++;
				}
				id++;
			}
			return null;
		}

		public function gameShopCfgData():Dictionary
		{
			return  _dictionary[ConfigType.keyGameShop];
		}

		public function onlineRewardCfgData():Dictionary
		{
			return  _dictionary[ConfigType.keyOnlineReward];
		}

        public function onlineRewardShieldCfgData(index:int):OnlineRewardShieldCfgData
		{
            return _dictionary[ConfigType.keyOnlineRewardShield][index];
		}

        public function announcementCfgData(id:int):AnnouncementCfgData
		{
			return  _dictionary[ConfigType.keyAnnouncement][id];
		}
		
		public function familyCfgData(id:int):FamilyCfgData
		{
			return  _dictionary[ConfigType.keyFamily][id];
		}

		public function prayCfgData(type:int):Dictionary
		{
			return _dictionary[ConfigType.keyPray][type];
		}
		
		public function positionCfgData(level:int):PositionCfgData
		{
			return _dictionary[ConfigType.keyPosition][level];
		}
		
		public function positionChopCfgData(level:int):PositionChopCfgData
		{
			return _dictionary[ConfigType.keyPositionChop][level];
		}
		
		public function seaFeastCfgData():ActivitySeaFeastCfgData
		{
			return _dictionary[ConfigType.keyActivitySeaSide][1];
		}
		
		public function loongWarCfgData(id:int):ActivityLoongWarCfgData
		{
			return _dictionary[ConfigType.keyActivityLoongWar][id];
		}
		
		public function loongWarRewardCfgData(id:int):ActivityLoongWarRewardCfgData
		{
			return _dictionary[ConfigType.keyActivityLoongWarReward][id];
		}
		
		public function loongWarRewardCfgDatas(type:int):Vector.<ActivityLoongWarRewardCfgData>
		{
			var vector:Vector.<ActivityLoongWarRewardCfgData> = new Vector.<ActivityLoongWarRewardCfgData>();
			var dictionary:Dictionary = _dictionary[ConfigType.keyActivityLoongWarReward] as Dictionary;
			var cfgDt:ActivityLoongWarRewardCfgData;
			for each (cfgDt in dictionary)
			{
				if(cfgDt.type == type)
				{
					vector.push(cfgDt);
				}
			}
			vector.sort(function (dt1:ActivityLoongWarRewardCfgData,dt2:ActivityLoongWarRewardCfgData):int
			{
				return dt1.id - dt2.id;
			});
			return vector;
		}
		
		public function worshipCfgData():ActivityWorshipCfgData
		{
			return _dictionary[ConfigType.keyActivityMasterWorship][1];
		}
		
		public function findTreasure(id:int):TreasureCfgData
		{
			return _dictionary[ConfigType.keyFindTreasure][id];
		}
		
		public function findTreasureWoldLevel(level:int):TreasureCfgData
		{
			var dicts:Dictionary = _dictionary[ConfigType.keyFindTreasure];
			for each(var cfg:TreasureCfgData in dicts)
			{
				if(cfg.min_world_level<=level&&cfg.max_world_level>=level)
				{
					return cfg;
				}
			}
			return null;
		}

		public function findTreasureShop():Dictionary
		{
			return _dictionary[ConfigType.keyFindTreasureShop];
		}

		public function movieCfgDataDict(mid:int):Dictionary
		{
			return _dictionary[ConfigType.KeyMovie][mid];
		}
		
		public function artifactDic(type:int):Dictionary
		{
			return _dictionary[ConfigType.keyArtifact][type];
		}
		
		public function artifactCfgDatas(type:int,part:int):Dictionary
		{
			for(var i:* in _dictionary[ConfigType.keyArtifact][type])
			{
				if(i == part)
				{
					return _dictionary[ConfigType.keyArtifact][type][part];
				}
			}
			return null;
		}
		
		public function artifactCfgData(type:int,part:int,equipId:int):ArtifactCfgData
		{
			return _dictionary[ConfigType.keyArtifact][type][part][equipId];
		}
 
		
		public function getSignRewardByMonth(month:int,count:int):SignRewardData
		{
			return _dictionary[ConfigType.keySignReward][month][count];
		}
		
		public function getOffLineExp(level:int):OffLineExp
		{
			return _dictionary[ConfigType.keyOffLineExp][level];
		}
		
		public function getOffLineExpGet(max_off_line:int):OffLineExpGet
		{
			return _dictionary[ConfigType.keyOffLineExpGet][max_off_line];
		}
 
		public function sceneEffectCfgData(mapId:int):Vector.<SceneEffectCfgData>
		{
			var vector:Vector.<SceneEffectCfgData> = new Vector.<SceneEffectCfgData>();
			if(_dictionary[ConfigType.keySceneEffect])
			{
				for each(var sceneEffectCfgData:SceneEffectCfgData in _dictionary[ConfigType.keySceneEffect])
				{
					if(sceneEffectCfgData.mapId == mapId)
					{
						vector.push(sceneEffectCfgData);
					}
				}
			}
			return vector;
		}
		
		public function voiceEffectCfgData(id:int):VoiceEffectCfgData
		{
			return _dictionary[ConfigType.keyVoiceEffect][id];
		}
		
		public function taskTrailerCfgData(id:int):TaskTrailerCfgData
		{
			return _dictionary[ConfigType.keyTaskTrailer][id];
		}
		
		public function trailerCfgData(id:int):TrailerCfgData
		{
			return _dictionary[ConfigType.keyTrailer][id];
		}
		
		public function trailerRewardCfgData(level:int):TaskTrailerRewardCfgData
		{
			return _dictionary[ConfigType.KeyTrailerReward][level];
		}
		
		public function itemGiftRandomCfg(id:int):Dictionary
		{
			return _dictionary[ConfigType.KeyItemGiftRandom][id];
		}
		
		public function itemGiftCfg(id:int):Dictionary
		{
			return _dictionary[ConfigType.KeyItemGift][id];
		}
		
		public function equipStrengthenSuitCfg(level:int):EquipStrengthenSuiteCfgData
		{
			return _dictionary[ConfigType.KeyStrengthSuite][level];
		}
		
		public function equipBaptizeSuitCfg(level:int):EquipBaptizeSuiteCfgData
		{
			return _dictionary[ConfigType.KeyBaptizeSuite][level];
		}
		
		public function heroReincarnSuitCfg(level:int):HeroReincarnAttrCfgData
		{
			return _dictionary[ConfigType.KeyReincarinSuite][level];
		}
			
		public function monsterGroupDrop(monster_id:int):Dictionary
		{
			return _dictionary[ConfigType.KeyMonsterGroupDropClass][monster_id];
		}
			
			
		public function worldLevelMonster(monster_id:int):WorldLevelMonsterCfgData
		{
			return _dictionary[ConfigType.KeyWorldLevelMonster][monster_id];
		}
			
		public function worldLevel(openDay:int):WorldLevelCfgData
		{
			return _dictionary[ConfigType.KeyWorldLevel][openDay];
		}
		
		public function worldLevelExp(world_level:int):WorldLevelExpCfgData
		{
			return _dictionary[ConfigType.KeyWorldLevelExp][world_level];
		}

        public function schoolShopDatas():Dictionary
        {
            return _dictionary[ConfigType.KeySchoolShop];
        }
		public function equipSuitAttr(quality:int,type:int):EquipSuitAttrCfgData
		{
			var tmp:Object= _dictionary[ConfigType.keyEquipSuit][quality] as Object;
			for each(var equipCfg:EquipSuitAttrCfgData in tmp)
			{
				if(equipCfg.part.indexOf(type+"")>-1)
					return equipCfg
			}
			return null;
		}
		
		public function cheapReward(id:int):SpecialPreferenceRewordCfgData
		{
			return _dictionary[ConfigType.KeyCheapReward][id];
		}
		
		public function levelMatchReward(id:int):LevelCompetitiveRewordCfgData
		{
			return _dictionary[ConfigType.KeyLevelMatchReward][id];
		}
		
		public function allBossRewardNum():int
		{
			var dic:Dictionary = _dictionary[ConfigType.KeyAllBossReward];
			var num:int;
			for each(var cfg:AllBossRewardCfgData in dic)
			{
				num++;
			}
			return num;
		}
		
		public function allBossReward(id:int):AllBossRewardCfgData
		{
			return _dictionary[ConfigType.KeyAllBossReward][id];
		}
		
		public function broadcastCfgData():Dictionary
		{
			return _dictionary[ConfigType.KeyBroadcast];
		}
		
		public function achievementGroupCfgData():Dictionary
		{
			return _dictionary[ConfigType.keyAchievementGroup];
		}
		
		public function broadcastCfgDataById(id:int):BroadcastCfgData
		{
			return _dictionary[ConfigType.KeyBroadcast][id];
		}
		
		public function demonTowerCfgData(mapId:int):DemonTowerCfgData
		{
			var cfgDt:DemonTowerCfgData;
			for each(cfgDt in _dictionary[ConfigType.KeyDemonTower])
			{
				if(cfgDt.map_id == mapId)
				{
					return cfgDt;
				}
			}
			return null;
		}
		
		public function openServerDailyRewardData(day:int,index:int):OpenServerDailyRewardCfgData
		{
			return _dictionary[ConfigType.KeyOSDR][day][index];
		}
		
		public function OpenServerJourneyRewardData(day:int,index:int):OpenServerJourneyRewardCfgData
		{
			return _dictionary[ConfigType.KeyOSJR][day][index];
		}
		
		public function OpenServerJourneyRewardNumByDay(day:int):Vector.<OpenServerJourneyRewardCfgData>
		{
			var dic:Dictionary = _dictionary[ConfigType.KeyOSJR][day];
			var vector:Vector.<OpenServerJourneyRewardCfgData> = new Vector.<OpenServerJourneyRewardCfgData>();
			for each(var data:OpenServerJourneyRewardCfgData in dic)
			{
				vector.push(data);
			}
			return vector;
		}
		
		public function OpenServerPromoteRewardData(day:int,index:int):OpenServerPromoteRewardCfgData
		{
			return _dictionary[ConfigType.KeyOSPR][day][index];
		}
		
		public function OpenServerPromoteRewardNumByDay(day:int):Vector.<OpenServerPromoteRewardCfgData>
		{
			var dic:Dictionary = _dictionary[ConfigType.KeyOSPR][day];
			var vector:Vector.<OpenServerPromoteRewardCfgData> = new Vector.<OpenServerPromoteRewardCfgData>();
			for each(var data:OpenServerPromoteRewardCfgData in dic)
			{
				vector.push(data);
			}
			return vector;
		}
		
		
		public function OpenServerNewRewardData(day:int,index:int):OpenServerNewRewardCfgData
		{
			return _dictionary[ConfigType.KeyOSNR][day][index];
		}
		
		
		public function onlineWelfareNum():int
		{
			var dic:Dictionary = _dictionary[ConfigType.KeyOnlineWelfare];
			var count:int;
			for each(var cfg:OnlineWelfareCfgData in dic)
			{
				count++;
			}
			return count;
		}
		
		public function onlineWelfareData(id:int):OnlineWelfareCfgData
		{
			return _dictionary[ConfigType.KeyOnlineWelfare][id];
		}
		
		public function onlineWelfareVec():Vector.<OnlineWelfareCfgData>
		{
			var vec:Vector.<OnlineWelfareCfgData> = new Vector.<OnlineWelfareCfgData>();
			var dic:Dictionary = _dictionary[ConfigType.KeyOnlineWelfare];
			for each(var cfg:OnlineWelfareCfgData in dic)
			{
				vec.push(cfg);
			}
			return vec;
		}
		
		public function openServerRewardData(id:int):OpenServerRewardCfgData
		{
			return _dictionary[ConfigType.KeyOSR][id];
		}
		
	}
}