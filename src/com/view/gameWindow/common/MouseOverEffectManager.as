package com.view.gameWindow.common
{
	import com.view.gameWindow.util.UrlPic;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.utils.Dictionary;
	
	/**
	 * @author wqhk
	 * 2014-8-27
	 */
	public class MouseOverEffectManager
	{
		protected var store:Dictionary;
		protected var overEffect:Shape;
		protected var selectedEffect:*;
		
		protected var overFilter:GlowFilter;
		protected var selectedFilter:GlowFilter;
		
		protected var type:int;
		protected var urlPic:UrlPic;
		
		/**
		 * 一个manager的大小固定
		 */
		public function MouseOverEffectManager(type:int,width:int,height:int)
		{
			store = new Dictionary(true);
			
			overFilter = new GlowFilter(0xffffff,0.5,8,8,2,1,true,true);
			selectedFilter =  new GlowFilter(0x996100,1,8,8,2,1,true,true);
			
			overEffect = new Shape();
			selectedEffect = new Shape();
			
			this.type = type;
			
			if(type == 1)
			{
				overEffect.graphics.beginFill(0x0,1);
				overEffect.graphics.drawRect(0,0,width,height);
				overEffect.graphics.endFill();
				overEffect.filters = [overFilter];
				
				selectedEffect.graphics.beginFill(0x0,1);
				selectedEffect.graphics.drawRect(0,0,width,height);
				selectedEffect.graphics.endFill();
				selectedEffect.filters = [selectedFilter];
			}
			else if(type == 0)
			{
				overEffect.graphics.lineStyle(2,0xff6600);
				overEffect.graphics.beginFill(0xff6600,0);
				overEffect.graphics.drawRect(0,0,width,height);
				overEffect.graphics.endFill();
				
				selectedEffect.graphics.lineStyle(2,0xffff00);
				selectedEffect.graphics.beginFill(0xff8800,0);
				selectedEffect.graphics.drawRect(0,0,width,height);
				selectedEffect.graphics.endFill();
			}
		}
		
		
		public function add(item:DisplayObject):void
		{
			remove(item);
			
			item.addEventListener(MouseEvent.ROLL_OVER,rollOverHandler,false,0,true);
			item.addEventListener(MouseEvent.ROLL_OUT,rollOutHandler,false,0,true);
			
			var record:Record = new Record();
			record.item = item;
			store[item] = record;
		}
		
		
		private function rollOverHandler(e:Event):void
		{
			var item:DisplayObject = e.currentTarget as DisplayObject;
			var record:Record = getRecord(item);
			
			record.isOver = true;
			
			if(!record.isSelected)
			{
				addEffect(item,overEffect);
			}
		}
		
		protected function addEffect(item:DisplayObject,effect:*):void
		{
			effect.x = item.x;
			effect.y = item.y;
			
			if(item.parent)
			{
				item.parent.addChild(effect);
			}
		}
		
		protected function removeEffect(effect:*):void
		{
			if(effect.parent)
			{
				effect.parent.removeChild(effect);
			}
		}
		
		
		private function rollOutHandler(e:Event):void
		{
			var item:DisplayObject = e.currentTarget as DisplayObject;
			var record:Record = getRecord(item);
			
			if(!record)
			{
				removeEffect(overEffect);
				return;
			}
			
			record.isOver = false;
			if(!record.isSelected)
			{
				removeEffect(overEffect);
			}
		}
		
		public function setSelected(item:DisplayObject,value:Boolean):void
		{
			var record:Record = getRecord(item);
			
			if(record)
			{
				if(value)
				{
					removeEffect(overEffect);
					addEffect(item,selectedEffect);
					
					record.isSelected = true;
				}
				else
				{
					record.isSelected = false;
					
					removeEffect(selectedEffect);
					
					if(record.isOver)
					{
						addEffect(item,overEffect);
					}
				}
			}
		}
		
		private function getRecord(item:DisplayObject):Record
		{
			return store[item];
		}
		
		public function remove(item:DisplayObject):void
		{
			var record:Record = getRecord(item);
			if(record)
			{
				if(record.isSelected)
				{
					removeEffect(selectedEffect);
				}
				
				if(record.isOver)
				{
					removeEffect(overEffect);
				}
				
				item.removeEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
				item.removeEventListener(MouseEvent.ROLL_OVER,rollOutHandler);
				
				delete store[item];
			}
		}
	}
}
import flash.display.DisplayObject;

class Record
{
	public var item:DisplayObject;
	public var type:int;
	public var isSelected:Boolean = false;
	public var isOver:Boolean = false;
}