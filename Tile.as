package {
    import flash.display.Shape; 

    public class Tile extends Shape {
        public function Tile():void {
            this.graphics.lineStyle(2, 0x000000);
            this.graphics.beginFill(0x00b4f5, 1.0);
            this.graphics.drawRect(0, 0, 50, 50);
            this.graphics.endFill();
            this.setPosition(0, 0, 0);
        }
        public function setPosition(x:int, y:int, z:int):void {
            this.x = x;
            this.y = y;
            this.z = z;
        }
    }
}
