package com.view.gameWindow.panel.panels.createHero
{
	import com.model.business.fileService.UrlSwfLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlSwfLoaderReceiver;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.consts.JobConst;
	import com.model.consts.SexConst;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.bag.IBagPanel;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.Cover;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class PanelCreateHero extends PanelBase implements IBagPanel,IUrlSwfLoaderReceiver
	{
		private var _mouseHandler:CreateHeroMouseHandler;
		
		private var mcVideo:Sprite;
		
		private var urlSwfLoader:UrlSwfLoader;
		public var skillId:int;
		
		public function PanelCreateHero()
		{
			super();
			canEscExit = false;
		}
		
		override protected function initSkin():void
		{
			var cover:Cover=new Cover(0x000000,0.6);
			addChild(cover);
			_skin = new McCreateHero();
			addChild(_skin);
			var mc:McCreateHero=_skin as McCreateHero;
			mc.txt_03.mouseEnabled=false;
			mc.txt.text = StringConst.HERO_CREATE_0007;
			var sex:int=RoleDataManager.instance.sex;
			if(sex==SexConst.TYPE_MALE)
			{
				mc.btnHero_00.resUrl="hero/nvzhan.png";
				mc.btnHero_01.resUrl="hero/nvfa.png";
				mc.btnHero_02.resUrl="hero/nvdao.png";
			}else
			{
				mc.btnHero_00.resUrl="hero/nanzhan.png";
				mc.btnHero_01.resUrl="hero/nanfa.png";
				mc.btnHero_02.resUrl="hero/nandao.png";
			}
			mc.txt_00.htmlText=HtmlUtils.createHtmlStr(0xd4a460,StringConst.HERO_CREATE_0001);
			mc.txt_01.htmlText=HtmlUtils.createHtmlStr(0xd4a460,StringConst.HERO_CREATE_0002);
			mc.txt_02.htmlText=HtmlUtils.createHtmlStr(0xd4a460,StringConst.HERO_CREATE_0003);
			var skillCfgData:SkillCfgData;
			mc.txt_11.htmlText=HtmlUtils.createHtmlStr(0x53b436,getSkillName(1),12,false,2,"SimSun",true,"this");
			skillCfgData = ConfigDataManager.instance.skillCfgData1(skillId);
			ToolTipManager.getInstance().attachByTipVO(mc.txt_11,ToolTipConst.SKILL_TIP,skillCfgData);
			mc.txt_12.htmlText=HtmlUtils.createHtmlStr(0x53b436,getSkillName(2),12,false,2,"SimSun",true,"this");
			skillCfgData = ConfigDataManager.instance.skillCfgData1(skillId);
			ToolTipManager.getInstance().attachByTipVO(mc.txt_12,ToolTipConst.SKILL_TIP,skillCfgData);
			mc.txt_13.htmlText=HtmlUtils.createHtmlStr(0x53b436,getSkillName(3),12,false,2,"SimSun",true,"this");
			skillCfgData = ConfigDataManager.instance.skillCfgData1(skillId);
			ToolTipManager.getInstance().attachByTipVO(mc.txt_13,ToolTipConst.SKILL_TIP,skillCfgData);
			
			mc.txt_title.text=StringConst.HERO_CREATE_0006;
			mc.txt_03.text=StringConst.HERO_CREATE_0005;
			mc.txt_04.text=StringConst.HERO_CREATE_0004;
			TaskDataManager.instance.setAutoTask(false);
			AutoSystem.instance.stopAutoEx();
			mcVideo = new Sprite();
			addChild(mcVideo);
			mcVideo.x=300;
			mcVideo.y=0;
			
		}
		
		private function getSkillName(type:int):String
		{
			var name:String="";
			var job:int=RoleDataManager.instance.job;
			if(job==JobConst.TYPE_ZS)
			{
				if(type==JobConst.TYPE_ZS)
				{
					name=StringConst.HEJI_NAME_0001;
					skillId=7001;
					
				}else if(type==JobConst.TYPE_FS)
				{
					name=StringConst.HEJI_NAME_0002;
					skillId=7007;
				}else
				{
					name=StringConst.HEJI_NAME_0003;
					skillId=7011;
				}
			}else if(job==JobConst.TYPE_FS)
			{
				if(type==JobConst.TYPE_FS)
				{
					name=StringConst.HEJI_NAME_0004;
					skillId=7003;
				}else if(type==JobConst.TYPE_DS)
				{
					name=StringConst.HEJI_NAME_0005;
					skillId=7015;
				}else
				{
					name=StringConst.HEJI_NAME_0002;
					skillId=7007;
				}
			}else
			{
				if(type==JobConst.TYPE_DS)
				{
					name=StringConst.HEJI_NAME_0006;
					skillId=7005;
				}else if(type==JobConst.TYPE_FS)
				{
					name=StringConst.HEJI_NAME_0005;
					skillId=7015;
				}else
				{
					name=StringConst.HEJI_NAME_0003;
					skillId=7011;
				}
			}
			return name;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(_skin.btnHero_00,function():void
			{
				_skin.btnHero_00.mouseEnabled=true;
				_skin.btnHero_00.buttonMode=true;
			});
			rsrLoader.addCallBack(_skin.btnHero_01,function():void
			{
				_skin.btnHero_01.mouseEnabled=true;
				_skin.btnHero_01.buttonMode=true;
			});
			rsrLoader.addCallBack(_skin.btnHero_02,function():void
			{
				_skin.btnHero_02.mouseEnabled=true;
				_skin.btnHero_02.buttonMode=true;
			});
		}
		
		override protected function initData():void
		{
			_mouseHandler=new CreateHeroMouseHandler(this);
		}
		
		override public function destroy():void
		{
			if(urlSwfLoader)
			{
				urlSwfLoader.destroy();
			}
			urlSwfLoader=null;
			if(mcVideo)
			{
				mcVideo.parent&&mcVideo.parent.removeChild(mcVideo);
				mcVideo=null;
			}
			if(_mouseHandler)
				_mouseHandler.destroy();
			_mouseHandler=null;
			super.destroy();
		}
		
		public function playerEffect(job:int, _select:int):void
		{
			removeVideo();
			var url:String="";
			var name:String="";
			if(job==JobConst.TYPE_ZS)
			{
				if(_select==JobConst.TYPE_ZS)
				{
					url="ZZ.swf";
				}else if(_select==JobConst.TYPE_FS)
				{
					url="ZF.swf";
				}else
				{
					url="ZD.swf";
				}
			}else if(job==JobConst.TYPE_FS)
			{
				if(_select==JobConst.TYPE_FS)
				{
					url="FF.swf";
				}else if(_select==JobConst.TYPE_DS)
				{
					url="FD.swf";
				}else
				{
					url="ZF.swf";
				}
			}else
			{
				if(_select==JobConst.TYPE_DS)
				{
					url="DD.swf";
				}else if(_select==JobConst.TYPE_FS)
				{
					url="FD.swf";
				}else
				{
					url="ZD.swf";
				}
			}
			if(urlSwfLoader)
			{
				urlSwfLoader.destroy();
			}
			trace(url);
			urlSwfLoader=null;
			urlSwfLoader = new UrlSwfLoader(this);
			urlSwfLoader.loadSwf(ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD+"hero/"+url);
		}
		
		private function removeVideo():void
		{
			while(mcVideo&&mcVideo.numChildren>0)
			{
				var dis:MovieClip = mcVideo.removeChildAt(0) as MovieClip;
				dis.stop();
				dis=null;
			}
		}
		
		public function swfError(url:String, info:Object):void
		{
			
		}
		
		public function swfProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		public function swfReceive(url:String, swf:Sprite, info:Object):void
		{
			if(mcVideo)
			{
				mcVideo.addChild(swf);
			}else
			{
				swf=null;
			}
		}
	}
}