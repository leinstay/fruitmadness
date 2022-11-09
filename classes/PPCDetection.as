package 
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class PPCDetection
	{
		public static function getCollisionRect(target1:DisplayObject, target2:DisplayObject, commonParent:DisplayObjectContainer, pixelPrecise:Boolean = false, tolerance:Number = 0):Rectangle
		{
			var rect1:Rectangle = target1.getBounds(commonParent);
			var rect2:Rectangle = target2.getBounds(commonParent);
			var intersectionRect:Rectangle = rect1.intersection(rect2);
			if (intersectionRect.size.length > 0)
			{
				if (pixelPrecise)
				{
					intersectionRect.width = Math.ceil(intersectionRect.width);
					intersectionRect.height = Math.ceil(intersectionRect.height);
					var alpha1:BitmapData = getAlphaMap(target1,intersectionRect,BitmapDataChannel.RED,commonParent);
					var alpha2:BitmapData = getAlphaMap(target2,intersectionRect,BitmapDataChannel.GREEN,commonParent);
					alpha1.draw(alpha2, null, null, BlendMode.LIGHTEN);
					var searchColor:uint;
					if (tolerance <= 0)
					{
						searchColor = 0x010100;
					}
					else
					{
						if (tolerance> 1)
						{
							tolerance = 1;
						}
						var byte:int = Math.round(tolerance * 255);
						searchColor = (byte << 16) | (byte << 8) | 0;
					}
					var collisionRect:Rectangle = alpha1.getColorBoundsRect(searchColor,searchColor);
					collisionRect.x +=  intersectionRect.x;
					collisionRect.y +=  intersectionRect.y;
					return collisionRect;
				}
				else
				{
					return intersectionRect;
				}
			}
			else
			{
				return null;
			}
		}

		private static function getAlphaMap(target:DisplayObject, rect:Rectangle, channel:uint, commonParent:DisplayObjectContainer):BitmapData
		{
			var parentXformInvert:Matrix = commonParent.transform.concatenatedMatrix.clone();
			parentXformInvert.invert();
			var targetXform:Matrix = target.transform.concatenatedMatrix.clone();
			targetXform.concat(parentXformInvert);
			targetXform.translate(-rect.x, -rect.y);
			var bitmapData:BitmapData = new BitmapData(rect.width,rect.height,true,0);
			bitmapData.draw(target, targetXform);
			var alphaChannel:BitmapData = new BitmapData(rect.width,rect.height,false,0);
			alphaChannel.copyChannel(bitmapData, bitmapData.rect, new Point(0, 0), BitmapDataChannel.ALPHA, channel);
			return alphaChannel;
		}

		public static function getCollisionPoint(target1:DisplayObject, target2:DisplayObject, commonParent:DisplayObjectContainer, pixelPrecise:Boolean = false, tolerance:Number = 0):Point
		{
			var collisionRect:Rectangle = getCollisionRect(target1,target2,commonParent,pixelPrecise,tolerance);
			if (collisionRect != null && collisionRect.size.length> 0)
			{
				var x:Number = (collisionRect.left + collisionRect.right) / 2;
				var y:Number = (collisionRect.top + collisionRect.bottom) / 2;
				return new Point(x, y);
			}
			return null;
		}

		public static function isColliding(target1:DisplayObject, target2:DisplayObject, commonParent:DisplayObjectContainer, pixelPrecise:Boolean = false, tolerance:Number = 0):Boolean
		{
			var collisionRect:Rectangle = getCollisionRect(target1,target2,commonParent,pixelPrecise,tolerance);
			if (collisionRect != null && collisionRect.size.length> 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}
}