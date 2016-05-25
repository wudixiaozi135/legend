package com.view.gameWindow.panel.panels.dungeon
{
	import com.view.gameWindow.common.Draw;
	import com.view.gameWindow.common.PropertyOrganizer;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.newMir.NewMirMediator;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	
	/**
	 * @author wqhk
	 * 2014-9-6
	 */
	public class DgnStarPanel extends PanelBase
	{
		private var _ui:McDungeonStarPanel;
		private var _p:PropertyOrganizer;
		private var _dataMgr:DgnGoalsDataManager;
		private var _timeId:int;
		private var _pList:Array;
		private var _maskSpr:Sprite;
		
		public function DgnStarPanel()
		{
			super();
			canEscExit = false;
		}
		
		override public function destroy():void
		{
			if(_timeId)
			{
				clearInterval(_timeId);
				_timeId = 0;
			}
			
			if(_p)
			{
				_p.destroy();
				_p = null;
			}
			
			super.destroy();
		}
		override public function getPanelRect():Rectangle
		{
			return new Rectangle(0,0,NewMirMediator.getInstance().width,NewMirMediator.getInstance().height);
		}
		
		override public function resetPosInParent():void
		{
			x = 0;
			y = 0;
			
			setSkinPos();
		}
		
		private function setSkinPos():void
		{
			_skin.x =(NewMirMediator.getInstance().width - _skin.width)*1/2;
			_skin.y = NewMirMediator.getInstance().height - 200 - _skin.height;
		}
		
		override protected function initSkin():void
		{
			_ui = new McDungeonStarPanel;
			_skin = _ui;
			
			addChild(_skin);
			
			setSkinPos();
			
			_dataMgr = DgnGoalsDataManager.instance;
			
			_p = new PropertyOrganizer(this);
			
			_p.register("starFlag","skin.starFlag",null,updateStarFlag);
			_p.register("txt0","skin.txt0.text",_dataMgr.getStarTxt0);
			_p.register("txt1","skin.txt1.text",_dataMgr.getStarTxt1);
			_p.register("txt2","skin.txt2.text",_dataMgr.getStarTime);
			_pList = [];
			_pList.push("starFlag","txt0","txt1","txt2");
			
			visible = false;
			_timeId = setInterval(updateData,1000);
			
			_maskSpr = new Sprite();
			
			_maskSpr.x = _ui.timeFlag.x;
			_maskSpr.y = _ui.timeFlag.y;
			
			_ui.addChild(_maskSpr);
			_ui.timeFlag.mask = _maskSpr;
			
			drawMask(_maskSpr,_ui.timeFlag,1);
		}
		
		
		private function drawMask(mask:Sprite,target:DisplayObject,decimal:Number):void
		{
			mask.graphics.clear();
			mask.graphics.beginFill(0x0,0);
			Draw.drawSector(mask.graphics,target.width/2,target.height/2,target.width/2,360-decimal*360,decimal*360);
			mask.graphics.endFill();
		}
		
//		private	function drawSector(g:Graphics,x:Number, y:Number, radius:Number, startFrom:Number, angle:Number):void
//		{
//			g.moveTo(x,y);
//			var angle:Number=(Math.abs(angle)>360)?360:angle;
//			var n:Number=Math.ceil(Math.abs(angle)/45);
//			var angleA:Number=angle/n;
//			angleA=angleA*Math.PI/180;
//			startFrom=startFrom*Math.PI/180;
//			g.lineTo(x+radius*Math.cos(startFrom),y+radius*Math.sin(startFrom));
//			for (var i:int=1; i<=n; i++) 
//			{
//				startFrom+=angleA;
//				var angleMid:Number=startFrom-angleA/2;
//				var bx:Number=x+radius/Math.cos(angleA/2)*Math.cos(angleMid);
//				var by:Number=y+radius/Math.cos(angleA/2)*Math.sin(angleMid);
//				var cx:Number=x+radius*Math.cos(startFrom);
//				var cy:Number=y+radius*Math.sin(startFrom);
//				g.curveTo(bx,by,cx,cy);
//			}
//			
//			if(angle!=360)
//			{
//				g.lineTo(x,y);
//			}
//		}
			
		
		private function updateData():void
		{
			for each(var p:String in _pList)
			{
				_p.update(p);
			}
			
			drawMask(_maskSpr,_ui.timeFlag,_dataMgr.getStarTimeDec());
		}
		
		private function updateStarFlag(mv:MovieClip):void
		{
			if(!mv)
			{
				return;
			}
			
			var star:int = _dataMgr.getRealStar();
			
			if(star==0)
			{
				visible = false;
			}
			else
			{
				visible = true;
				mv.gotoAndStop(star);
			}
		}
	}
}