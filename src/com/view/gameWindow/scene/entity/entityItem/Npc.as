package com.view.gameWindow.scene.entity.entityItem
{
	import com.view.gameWindow.scene.entity.constants.EntityTypes;


	public class Npc extends Unit
	{
		public override function get entityType():int
		{
			return EntityTypes.ET_NPC;
		}
		
		public override function destory():void
		{
			super.destory();
		}
		
		protected override function refreshNameTxtPos():void
		{
			if(_nameTxt && _entityModel && _entityModel.available)
			{
				trace("ddddddddddddddddddddddddd");
				_infoLabel.refreshNameTextPos(_nameTxt, _entityModel.modelHeight);
			}
		}
	}
}