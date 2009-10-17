// 2009-10-12 koyachi
// ださい
package {
    import flash.display.*;

    public class BMPSelector {
        [Embed(source='imgsrc/tumblr_kqduwjUWyE1qz4m56o1_400.jpg')]
        private var bitmapLoader1:Class;
        private var bmp_dog:Bitmap = new bitmapLoader1();

        [Embed(source='imgsrc/xZCzkpWy2ovr2g3xSacnN25Eo1_500.jpg')]
        private var bitmapLoader2:Class;
        private var bmp_people:Bitmap = new bitmapLoader2();

        [Embed(source='imgsrc/9RtRLtEeloz7ugufGGIWDUn4o1_500.jpg')]
        private var bitmapLoader3:Class;
        private var bmp_heavymetal:Bitmap = new bitmapLoader3();

        [Embed(source='imgsrc/jVXA3yeekomu4ykowDtYtRTEo1_500.jpg')]
        private var bitmapLoader4:Class;
        private var bmp_flower:Bitmap = new bitmapLoader4();

        [Embed(source='imgsrc/na6iLGzUCpxp0jp1jT8Oo0pyo1_500.jpg')]
        private var bitmapLoader5:Class;
        private var bmp_kyuri:Bitmap = new bitmapLoader5();

        [Embed(source='imgsrc/tumblr_kof3htzgOx1qz4m56o1_500.jpg')]
        private var bitmapLoader6:Class;
        private var bmp_burger:Bitmap = new bitmapLoader6();


        [Embed(source='imgsrc/tumblr_konj44RIWl1qztjpvo1_500.jpg')]
        private var bitmapLoader7:Class;
        private var bmp_lego:Bitmap = new bitmapLoader7();

        [Embed(source='imgsrc/9RtRLtEelqizu9o1rqLsXZ5Ho1_500.jpg')]
        private var bitmapLoader8:Class;
        private var bmp_susi:Bitmap = new bitmapLoader8();

        [Embed(source='imgsrc/tumblr_kq6f49l3sw1qz4m56o1_500.jpg')]
        private var bitmapLoader9:Class;
        private var bmp_camera:Bitmap = new bitmapLoader9();

        [Embed(source='imgsrc/colormap.png')]
        private var bitmapLoader10:Class;
        private var bmp_colormap:Bitmap = new bitmapLoader10();

        private var bmp_map:Array = [
            bmp_dog,
            bmp_people,
            bmp_heavymetal,
            bmp_flower,
            bmp_kyuri,
            bmp_burger,
            bmp_lego,
            bmp_susi,
            bmp_camera,
            bmp_colormap];
        public var index:uint = 0;
        private var bitmap:Bitmap = bmp_map[index];

        public function changeBmp():Bitmap {
            return next();
        }

        public function next():Bitmap {
            if (index < bmp_map.length - 1) index++;
            else index = 0;
            return current();
        }
        public function current():Bitmap {
            return bmp_map[index];
        }
        
        public function BMPSelector():void {
            
        }
    }
}
