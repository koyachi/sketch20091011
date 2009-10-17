// 2009-10-12 koyachi
// にせwonder-wall.com

package {
    import flash.display.Shape;
    import flash.display.*;
    import flash.events.*;
    import mx.events.*;

    public class RubberGrid extends Shape {
        private var gridWidth:int = 6;
        private var gridHeight:int = 6;
        private var initialGridPos:Vector.<Number>;
        private var currentGridPos:Vector.<Number>;
        private var nextGridPos:Vector.<Number>;
        private var uvtGridPos:Vector.<Number>;
        private var index:Vector.<int>;
        private var gridVal:Vector.<Number>;
        
        private var offsetX:int = 50;
        private var offsetY:int = 50;
        private var polygonWidth:int = 50;
        private var polygonHeight:int = 50;
        private var zoom:int = 40;
        private var rMax:Number = 10;//12.4;

        private var bmpSelector:BMPSelector = new BMPSelector();
        private var bitmap:Bitmap = bmpSelector.current();
        public function changeBmp():void {
            bitmap = bmpSelector.next();
            this.drawGrid();
        }

        [Bindable]
        public var enableEdge:Boolean = false;
        
        public function RubberGrid() {
            initGrid();
            initShape();

            addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler);
        }

        private function initGrid():void {
            gridVal = new Vector.<Number>;
            initialGridPos = new Vector.<Number>(gridHeight * gridWidth * 2, true);
            currentGridPos = new Vector.<Number>(gridHeight * gridWidth * 2, true);
            nextGridPos = new Vector.<Number>(gridHeight * gridWidth * 2, true);
            uvtGridPos = new Vector.<Number>(gridHeight * gridWidth * 2, true);
            index = new Vector.<int>((gridHeight - 1) * (gridWidth - 1) * 6, true);
            var i:uint = 0;
            for (var y:int = 0; y < gridHeight; y++) {
                for (var x:int = 0; x < gridWidth; x++) {
                    gridVal.push(0);

                    var px:Number = x * polygonWidth + offsetX;
                    var py:Number = y * polygonHeight + offsetY;
                    i = (y * gridWidth + x) * 2;
                    initialGridPos[i+0] = px;
                    initialGridPos[i+1] = py;
                    currentGridPos[i+0] = px;
                    currentGridPos[i+1] = py;
                    nextGridPos[i+0] = px;
                    nextGridPos[i+1] = py;
                    uvtGridPos[i] = x/(gridWidth-1);
                    uvtGridPos[i+1] = y/(gridHeight-1);

                    if (x > 0 && y > 0) {
                        var p4:int = y * gridWidth + x;
                        var p3:int = p4 - 1;
                        var p2:int = p4  - gridWidth;
                        var p1:int = p2 - 1;

                        i = ((y-1) * (gridWidth-1) + (x-1)) * 6;
                        index[i+0] = p1;
                        index[i+1] = p2;
                        index[i+2] = p3;

                        index[i+3] = p2;
                        index[i+4] = p4;
                        index[i+5] = p3;
                    }

                }
            }
        }
        // drawTriangle test
        private function _initShape():void {
            this.graphics.lineStyle(2, 0x00000000);
            this.graphics.beginFill(0x00b4f5, 1.0);
            this.graphics.drawTriangles(
                Vector.<Number>([ 
                                    10,10,  100,10,  10,100, 
                                    110,10, 110,100, 20,100]));
            this.graphics.endFill();
        }
        private function initShape():void {
            this.drawGrid();
        }
        private function drawGrid():void {
            this.graphics.clear();
            if (this.enableEdge) {
                this.graphics.lineStyle(2, 0x00000000);
            }
            this.graphics.beginBitmapFill(bitmap.bitmapData);
            this.graphics.drawTriangles(currentGridPos, index, uvtGridPos);
            this.graphics.endFill();
        }

        private function updateGrid(cursorX:int, cursorY:int):void {
            var index_x:uint;
            var index_y:uint;
            var value:Number;
            var px:Number;
            var py:Number;
            var ix:Number;
            var iy:Number;
            var vx:Number;
            var vy:Number;
            var nx:Number;
            var ny:Number;

            var dx:Number;
            var dy:Number;

            var x:int=0;
            var y:int=0;
            var r:Number;
            for (y = 0; y < gridHeight; y++) {
                for (x = 0; x < gridWidth; x++) {
//                    var value:Number = gridVal[y * gridWidth + x];
                    index_x = y * gridWidth * 2 + (x * 2);
                    index_y = y * gridWidth * 2 + (x * 2) + 1;

                    px = currentGridPos[index_x];
                    py = currentGridPos[index_y];

                    ix = initialGridPos[index_x];
                    iy = initialGridPos[index_y];

                    vx = cursorX - px;
                    vy = cursorY - py;
                    r = Math.sqrt(Math.abs(vx) + Math.abs(vy));
//                    r = Math.sqrt(vx * vx + vy * vy);
                    if (r < rMax) {
//                        var value:Number = gridVal[y * gridWidth + x];
                        value = Math.cos(0.25 * Math.PI * (r/rMax)) * zoom;
                        nx = (vx < 0) ? 1 : -1;
                        ny = (vy < 0) ? 1 : -1;
                        nextGridPos[index_x] = ix + nx * value;
                        nextGridPos[index_y] = iy + ny * value;
                    }
                    else {
//                        dx = (ix - px) / 1.2;
//                        dy = (iy - py) / 1.2;
                        dx = (ix - px) * 0.25;
                        dy = (iy - py) * 0.25;
                        nextGridPos[index_x] = px + dx;
                        nextGridPos[index_y] = py + dy;
                    }
                }
            }
        }
        public function stabilize(speed:Number = 0.25):void {
//            var speed:Number = 0.25; // max=1.0
            var index_x:uint;
            var index_y:uint;
            var nx:Number;
            var ny:Number;
            var cx:Number;
            var cy:Number;
            var dx:Number;
            var dy:Number;
            
            var x:int=0;
            var y:int=0;
            for (y = 0; y < gridHeight; y++) {
                for (x = 0; x < gridWidth; x++) {
                    index_x = y * gridWidth * 2 + (x * 2);
                    index_y = y * gridWidth * 2 + (x * 2) + 1;
                    nx = nextGridPos[index_x];
                    ny = nextGridPos[index_y];

                    cx = currentGridPos[index_x];
                    cy = currentGridPos[index_y];

                    dx = (nx - cx) * speed;
                    dy = (ny - cy) * speed;
                    currentGridPos[index_x] = cx + dx;
                    currentGridPos[index_y] = cy + dy;
                }
            }
        }

        public function updateCursor(x:int, y:int):void {
            this.updateGrid(x, y);
            this.drawGrid();
        }

        private function propertyChangeHandler(e:PropertyChangeEvent):void {
            this.drawGrid();
        }
    }
}
