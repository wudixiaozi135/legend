package com.view.gameWindow.panel.panels.task.linkText
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.DungeonCfgData;
    import com.model.configData.cfgdata.ItemCfgData;
    import com.model.configData.cfgdata.MapCfgData;
    import com.model.configData.cfgdata.MapRegionCfgData;
    import com.model.configData.cfgdata.MapTeleportCfgData;
    import com.model.configData.cfgdata.MonsterCfgData;
    import com.model.configData.cfgdata.NpcCfgData;
    import com.model.configData.cfgdata.PlantCfgData;
    import com.model.configData.cfgdata.SpecialRingCfgData;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.task.linkText.item.LinkTextItem;

    import flash.utils.Dictionary;

    public class LinkText implements ILinkText
	{
		private var _htmlText:String;
		private var _items:Dictionary;
		public var lId:int=-1;
		private var _count:int;
		private static const COLOR:String = "#00ff00";
		
		public function showProfix():void
		{
			
		}
		
		public function init(text:String,noEvent : Boolean = false):void
		{
			_items = new Dictionary();
			_count=0;
			_htmlText = text;
			var id:int = 0;
			var matches:Array;
			var xml:XML;
			matches = _htmlText.match(/<l>(.*?)<\/l>/g);
			var match:String;
			
			var posesString:String;
			var posStrings:Array;
			var posString:String;
			var subPosStrings:Array;
			var rolePanelDataManager:RoleDataManager = RoleDataManager.instance;
			
			
			for each (match in matches)
			{
				id ++;
				_count++;
				var item:LinkTextItem = new LinkTextItem();
				xml = new XML(match);
				var mapConfig:MapCfgData;
				var naviPosition:String;
				var subNaviPositions:Array;
				var mapId:int;
				if (xml.d.toString())
				{
					item.type = LinkTextItem.TYPE_TO_MAP;
					item.mapId = parseInt(xml.d.@m);
					item.xPos = parseInt(xml.d.@x);
					item.yPos = parseInt(xml.d.@y);
					mapConfig = ConfigDataManager.instance.mapCfgData(item.mapId);
					if (mapConfig)
					{
						if(noEvent)
						{
							_htmlText = _htmlText.replace(match, "<font color='#01edce'>" + xml.d + "</font>");
						}
						else
						{
							_htmlText = _htmlText.replace(match, "<font color='"+COLOR+"'><u><a href='event:"+ (lId==-1?id:(lId+"|"+id)) + "'>" + xml.d + "</a></u></font>");
						}
					}
					else
					{
						trace("LinkText.init 配置信息不存在，类型："+item.type);
					}
				}
				else if (xml.n.toString())//npc
				{
					item.type = LinkTextItem.TYPE_TO_NPC;
					item.npcId = parseInt(xml.n);
					var npcConfig:NpcCfgData = ConfigDataManager.instance.npcCfgData(item.npcId);
					if (npcConfig)
					{
						var mapid:int = npcConfig.mapid;
						mapConfig = ConfigDataManager.instance.mapCfgData(mapid);
						if (mapConfig && rolePanelDataManager.lv >= mapConfig.level)
						{
							if(noEvent)
							{
								_htmlText = _htmlText.replace(match, "<font color='#597edb'>" + npcConfig.name + "</font>");
							}
							else
							{
								_htmlText = _htmlText.replace(match, "<font color='"+COLOR+"'><u><a href='event:" + (lId==-1?id:(lId+"|"+id))  + "'>" + npcConfig.name + "</a></u></font>");
							}
						}
						else if(mapConfig)
						{
							_htmlText =  "你的等级不符合指定地图设置";
						}
						else
						{
							trace("LinkText.init 配置信息不存在，类型："+item.type);
						}
					}
					else
					{
						trace("LinkText.init 配置信息不存在，类型："+item.type);
					}
				}
				else if (xml.g.toString())//怪
				{
					item.type = LinkTextItem.TYPE_TO_MONSTER;
					item.monsterId = parseInt(xml.g);
					var monsterCfgDatas:Dictionary,monsterConfig:MonsterCfgData;
					monsterCfgDatas = ConfigDataManager.instance.monsterCfgDatas(item.monsterId);
					for each(monsterConfig in monsterCfgDatas)
					{
						if (monsterConfig)
						{
							var txtName:String = String(xml.text());
							if(noEvent)
							{
								_htmlText = _htmlText.replace(match, "<font color='#b0d738'>" + (txtName ? txtName : monsterConfig.name) + "</font>");
							}
							else
							{
								_htmlText = _htmlText.replace(match, "<font color='"+COLOR+"'><u><a href='event:" + (lId==-1?id:(lId+"|"+id))  + "'>" + (txtName ? txtName : monsterConfig.name) + "</a></u></font>");
							}
						
							break;
						}
						else
						{
							trace("LinkText.init 配置信息不存在，类型："+item.type);
						}
					}
				}
				else if (xml.k.toString())//采矿
				{
					item.type = LinkTextItem.TYPE_TO_MAP_MINE;
					item.regionId = parseInt(xml.k);
					var mapRegionConfig:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(item.regionId);
					if (mapRegionConfig)
					{
						if(noEvent)
						{
							_htmlText = _htmlText.replace(match, "<font color='#b0d738'>" + mapRegionConfig.name + "</font>");
						}
						else
						{
							_htmlText = _htmlText.replace(match, "<font color='"+COLOR+"'><u><a href='event:" + (lId==-1?id:(lId+"|"+id))  + "'>" + mapRegionConfig.name + "</a></u></font>");
						}
					}
					else
					{
						trace("LinkText.init 配置信息不存在，类型："+item.type);
					}
				}
				else if (xml.z.toString())//采集物
				{
					item.type = LinkTextItem.TYPE_TO_PLANT;
					item.plantId = parseInt(xml.z);
					var plantConfig:PlantCfgData = ConfigDataManager.instance.plantCfgData(item.plantId);
					if (plantConfig)
					{
						if(noEvent)
						{
							_htmlText = _htmlText.replace(match, "<font color='#b0d738'>" + plantConfig.name + "</font>");
						}
						else
						{
							_htmlText = _htmlText.replace(match, "<font color='"+COLOR+"'><u><a href='event:" + (lId==-1?id:(lId+"|"+id))  + "'>" + plantConfig.name + "</a></u></font>");
						}
					}
					else
					{
						trace("LinkText.init 配置信息不存在，类型："+item.type);
					}
				}
				else if (xml.f.toString())
				{
					item.type = LinkTextItem.TYPE_TO_DUNGEON;
					item.dungeonId = parseInt(xml.f);
					var dungeonConfig : DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(item.dungeonId);
					if(dungeonConfig)
					{
						item.npcId = dungeonConfig.npc;
						if(noEvent)
						{
							_htmlText = _htmlText.replace(match, "<font color='#b0d738'>" + dungeonConfig.name + "</font>");
						}
						else
						{
							_htmlText = _htmlText.replace(match, "<font color='"+COLOR+"'><u><a href='event:" + (lId==-1?id:(lId+"|"+id))  + "'>" + dungeonConfig.name + "</a></u></font>");
						}
					}
					else
					{
						trace("LinkText.init 配置信息不存在，类型："+item.type);
					}
				}
				else if (xml.t.toString())
				{
					item.type = LinkTextItem.TYPE_TO_TELEPORT;
					item.teleportId = parseInt(xml.t);
					var mapTeleportCfgDt:MapTeleportCfgData = ConfigDataManager.instance.mapTeleporterCfgData(item.teleportId);
					if(mapTeleportCfgDt)
					{
						txtName = String(xml.text());
						if(noEvent)
						{
							_htmlText = _htmlText.replace(match, "<font color='#b0d738'>" + txtName + "</font>");
						}
						else
						{
							_htmlText = _htmlText.replace(match, "<font color='"+COLOR+"'><u><a href='event:" + (lId==-1?id:(lId+"|"+id))  + "'>" + txtName + "</a></u></font>");
						}
					}
					else
					{
						trace("LinkText.init 配置信息不存在，类型："+item.type);
					}
				}
				else if (xml.nt.toString())
				{
					item.type = LinkTextItem.TYPE_TO_MAPREGION;
					item.mapRegion = parseInt(xml.nt);
					var mapRegionCfgData:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(item.mapRegion);
					if(mapRegionCfgData)
					{
						if(noEvent)
						{
							_htmlText = _htmlText.replace(match, "<font color='#b0d738'>" + xml.children()[1] + "</font>");
						}
						else
						{
							_htmlText = _htmlText.replace(match, "<font color='"+COLOR+"'><u><a href='event:" + (lId==-1?id:(lId+"|"+id))  + "'>" + xml.children()[1] + "</a></u></font>");
						}
					}
					else
					{
						trace("LinkText.init 配置信息不存在，类型："+item.type);
					}
				}
				else if (xml.i.toString())
				{
					item.type = LinkTextItem.TYPE_TO_SHOW_ITEM_TIP;
					item.itemid = parseInt(xml.i);
					var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(item.itemid);
					if(itemCfgData)
					{
						if(noEvent)
						{
							_htmlText = _htmlText.replace(match, "<font color='#b0d738'>" + itemCfgData.name + "</font>");
						}
						else
						{
							_htmlText = _htmlText.replace(match, "<font color='"+COLOR+"'><u><a href='event:" + (lId==-1?id:(lId+"|"+id))  + "'>" + itemCfgData.name + "</a></u></font>");
						}
					}
					else
					{
						trace("LinkText.init 配置信息不存在，类型："+item.type);
					}
				}
				else if (xml.p.toString())
				{
					item.type = LinkTextItem.TYPE_TO_OPEN_PANEL;
					item.panelName = xml.p.@n;
					item.panelPage = parseInt(xml.p.@m);
					if(noEvent)
					{
						_htmlText = _htmlText.replace(match, "<font color='#b0d738'>" + xml.p + "</font>");
					}
					else
					{
						_htmlText = _htmlText.replace(match, "<font color='"+COLOR+"'><u><a href='event:" + (lId==-1?id:(lId+"|"+id))  + "'>" + xml.p + "</a></u></font>");
					}
				}
				else if(xml.r.toString())
				{
					item.type = LinkTextItem.TYPE_TO_OPEN_PANEL;
					item.itemid = parseInt(xml.r);
					item.panelName=PanelConst.TYPE_SPECIAL_RING;
					item.panelPage=parseInt(xml.r);
					var specialRingCfgData:SpecialRingCfgData = ConfigDataManager.instance.specialRingCfgData(item.itemid);
					if(specialRingCfgData)
					{
						if(noEvent)
						{
							_htmlText = _htmlText.replace(match, "<font color='#b0d738'>" + specialRingCfgData.name + "</font>");
						}
						else
						{
							_htmlText = _htmlText.replace(match, "<font color='"+COLOR+"'><u><a href='event:" + (lId==-1?id:(lId+"|"+id))  + "'>" + specialRingCfgData.name + "</a></u></font>");
						}
					}
					else
					{
						trace("LinkText.init 配置信息不存在，类型："+item.type);
					}
				}
				else if(xml.u.toString())//面板
				{
					var split:Array = xml.u.toString().split(":");
					item.type = LinkTextItem.TYPE_TO_OPEN_PANEL;
					item.panelId = split[0];
					item.panelPage = split[1];
                    if (split[2])
                    {
                        item.subTabIndex = split[2];
                    }
					if(noEvent)
					{
						_htmlText = _htmlText.replace(match, "<font color='#00ff00'>" + xml.children()[1] + "</font>");
					}
					else
					{
						_htmlText = _htmlText.replace(match, "<font color='#00ff00'>"+"<u><a href='event:" + (lId==-1?id:(lId+"|"+id))  + "'>" + xml.children()[1] + "</a></u></font>");
					}
				}
				_items[id] = item;
			}
			matches = _htmlText.match(/<t c=\"(.*?)\">(.*?)<\/t>/g);
			for each (match in matches)
			{
				xml = new XML(match);
				_htmlText = _htmlText.replace(match, "<font color='" + xml.@c + "'>" + xml.toString() + "</font>")
			}
			
			matches = _htmlText.match(/<t c='(.*?)'>(.*?)<\/t>/g);
			for each (match in matches)
			{
				xml = new XML(match);
				_htmlText = _htmlText.replace(match, "<font color='" + xml.@c + "'>" + xml.toString() + "</font>")
			}
		}
		
		public function get htmlText():String
		{
			return _htmlText;
		}
		
		public function set htmlText(value:String):void
		{
			_htmlText=value;
		}
		
		public function getItemById(id:int):LinkTextItem
		{
			if(!_items.hasOwnProperty(id.toString()))
				return null;
			
			return _items[id]; 
		}
		
		public function getItemCount():int
		{
			return _count;
		}
		
		public function clone():LinkText
		{
			var linkText:LinkText = new LinkText();
			linkText._htmlText = _htmlText;
			linkText._items = new Dictionary();
			var item:LinkTextItem,i:int;
			for each(item in _items)
			{
				i++;
				linkText._items[i] = item;
			}
			return linkText;
		}
	}
}