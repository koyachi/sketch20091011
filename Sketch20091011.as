package {
    import flash.display.Sprite;
    import flash.display.InteractiveObject;
    import flash.events.*;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.*;

    [SWF(backgroundColor="#808080", frameRate="24")]
    public class Sketch20091011 extends Sprite {
        private var rubberGrid:RubberGrid;
        private var tf:TextField;
        private var mouse_x:int;
        private var mouse_y:int;

        private var lastMouseX:int;
        private var lastMouseY:int;
        
        private var enableAsyncUpdate:Boolean = true;

        public function Sketch20091011():void {
            rubberGrid = new RubberGrid();
            this.addChild(rubberGrid);
            
            this.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
            this.addEventListener(KeyboardEvent.KEY_UP, onKeyup);
            if (enableAsyncUpdate) {
                setInterval(updateGrid, 20);
            }
            setInterval(rubberGrid.stabilize, 40);
//            setInterval(stabilize, 40);

            // デバッグ情報 & rubberGridがShapeインスタンスでclick検知しないのかねて領域大きめに
            tf = new TextField();
            tf.x = 0;
            tf.y = 0;
            tf.width = 600;
            tf.height = 600;
            tf.text = ["[Sketch20091011]", "any key except e: change bmp", "e: draw edge"].join("\n");
            var format:TextFormat = new TextFormat();
            format.font = 'Courier New';
            format.color = 0x0000ff00;
            format.size = 8;
            tf.defaultTextFormat = format;
            this.addChild(tf);

        }

        private function updateGrid():void {
            rubberGrid.updateCursor(mouse_x, mouse_y);
//            var r:Number = Math.sqrt((mouseX - lastMouseX) * (mouseX - lastMouseX) + (mouseY - lastMouseY) * (mouseY - lastMouseY));
//            if (r > 1.0) {
//                rubberGrid.updateCursor(mouseX, mouseY);
//            }
            lastMouseX = mouseX;
            lastMouseY = mouseY;
        }
        private var isRunningStablizer:Boolean = false;
        private function stabilize():void {
            var r:Number = Math.sqrt((mouseX - lastMouseX) * (mouseX - lastMouseX) + (mouseY - lastMouseY) * (mouseY - lastMouseY));
            if (r > 2.0 && !isRunningStablizer) {
//                rubberGrid.stabilize();
                var counter:uint = 10;
                tid = setTimeout(st_core, 40);
            }
        }
        private var counter:uint = 10;
        private var tid:uint = undefined;
        private function st_core():void {
            if (counter) {
                rubberGrid.stabilize();
                counter--;
                isRunningStablizer = true;
                tid = setTimeout(st_core, 40);
            }
            else {
                clearTimeout(tid);
                isRunningStablizer = false;
            }
        }
        
        public function onMove(e:MouseEvent):void {
            // onmoveでやると重いからタイマーで回すか
            // onmoveで毎回計算だとちょっと重いので適当にはぶきたい
            // キューにつんで最新のだけ計算とか
            if (enableAsyncUpdate) {
                mouse_x = e.stageX;
                mouse_y = e.stageY;
            }
            else {
                rubberGrid.updateCursor(e.stageX, e.stageY);
            }
//            stabilize();
        }

        public function onKeyup(e:KeyboardEvent):void {
            if (e.charCode == 0x65) { // e
                rubberGrid.enableEdge = !rubberGrid.enableEdge;
            }
            else {
              rubberGrid.changeBmp();
            }
//                ttrace(String(e.charCode));
        }

        private function ttrace(msg:String):* {
            this.tf.text = msg;
        }
    }
}
