package GGM.panel
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import Person.Person;
	
	import morn.core.components.Label;

	/**
	 * 玩家信息框 
	 * @author LionelZhangz
	 * 
	 */	
	public class AvatarInfo extends Sprite
	{
		
		public function AvatarInfo()
		{
			txtName =new Label();
			txtName.color = 0xffffff;
			this.addChild(txtName);
			
			txtPower = new TextField();
			this.addChild(txtPower);
			
			avatarImg = new Bitmap();
			this.addChild(avatarImg);
		}
		
		
		/**
		 * 头像图片 
		 */		
		public var avatarImg:Bitmap;
		
		/**
		 * 战斗力文字显示 
		 */		
		public var txtPower:TextField;
		
		/**
		 * 用户名称 
		 */		
		public var txtName:Label;
		
		/**
		 * 设置数据 
		 * @param player
		 * 
		 */		
		public function setData(player:Person):void
		{
			this.txtPower.htmlText = "<font size='14',color='#ffffff'>Power:</font>" + 
				"<font size='14',color='#ffff00'>" + player.getPower() + "</font>" +
				　" \nlife " + player.getLife();
			this.txtName.text = player.getName();
			this.avatarImg.bitmapData = player.getBitmapData();
			avatarImg.width= 25;
			avatarImg.height = 50;
			
			txtName.x = avatarImg.x + avatarImg.width;
			txtName.y = 0;
			
			txtPower.x =txtName.x;
			txtPower.y = txtName.y + txtName.height + 5;
			
			
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		override public function get width():Number
		{
			return txtPower.y + txtPower.width;
		}
		
	}
}