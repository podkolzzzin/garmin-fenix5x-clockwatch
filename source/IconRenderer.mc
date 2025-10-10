import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

// Static class to render icons using vector graphics
// High-fidelity rendering of Font Awesome icons (steps/shoe prints and heart)
class IconRenderer {
    
    // Render the steps icon at the specified position with the given size and color
    // x, y - center position of the icon
    // size - width/height of the icon (it's square)
    // dc - drawing context
    // color - color to draw the icon
    static function drawSteps(dc as Graphics.Dc, x as Number, y as Number, size as Number, color as Number) as Void {
        // SVG viewBox is 0 0 640 640, we need to scale it to our size
        var scale = size / 640.0;
        
        // Offset to center the icon at x, y
        var offsetX = x - size / 2;
        var offsetY = y - size / 2;
        
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        
        // The SVG path consists of two shoe prints
        // First shoe print (upper right)
        drawFirstShoe(dc, offsetX, offsetY, scale);
        
        // Second shoe print (lower left)
        drawSecondShoe(dc, offsetX, offsetY, scale);
    }
    
    // Draw the first shoe print (upper portion)
    // Path: M328 256C306.9 243.9 285.7 231.8 256 226.7L256 86.4C289.7 77 343.4 64 384 64C480 64 608 112 608 192C608 272 488.4 288 432 288C384 288 356 272 328 256
    private static function drawFirstShoe(dc as Graphics.Dc, offsetX as Number, offsetY as Number, scale as Float) as Void {
        // Main body of first shoe - detailed polygon with more points for smooth curves
        var mainBody = [
            [s(328, scale, offsetX), s(256, scale, offsetY)],  // Start point
            [s(315, scale, offsetX), s(250, scale, offsetY)],  // Curve approximation
            [s(300, scale, offsetX), s(242, scale, offsetY)],
            [s(285, scale, offsetX), s(235, scale, offsetY)],
            [s(270, scale, offsetX), s(230, scale, offsetY)],
            [s(256, scale, offsetX), s(227, scale, offsetY)],  // Corner
            [s(256, scale, offsetX), s(200, scale, offsetY)],  // Left edge going up
            [s(256, scale, offsetX), s(150, scale, offsetY)],
            [s(256, scale, offsetX), s(100, scale, offsetY)],
            [s(256, scale, offsetX), s(86, scale, offsetY)],
            [s(265, scale, offsetX), s(84, scale, offsetY)],   // Curve at top
            [s(280, scale, offsetX), s(80, scale, offsetY)],
            [s(300, scale, offsetX), s(75, scale, offsetY)],
            [s(330, scale, offsetX), s(68, scale, offsetY)],
            [s(360, scale, offsetX), s(65, scale, offsetY)],
            [s(384, scale, offsetX), s(64, scale, offsetY)],
            [s(410, scale, offsetX), s(64, scale, offsetY)],
            [s(440, scale, offsetX), s(64, scale, offsetY)],
            [s(470, scale, offsetX), s(64, scale, offsetY)],
            [s(480, scale, offsetX), s(64, scale, offsetY)],
            [s(510, scale, offsetX), s(68, scale, offsetY)],   // Right side curve
            [s(540, scale, offsetX), s(75, scale, offsetY)],
            [s(565, scale, offsetX), s(88, scale, offsetY)],
            [s(585, scale, offsetX), s(105, scale, offsetY)],
            [s(600, scale, offsetX), s(130, scale, offsetY)],
            [s(608, scale, offsetX), s(160, scale, offsetY)],
            [s(608, scale, offsetX), s(192, scale, offsetY)],  // Peak
            [s(608, scale, offsetX), s(220, scale, offsetY)],  // Coming down
            [s(600, scale, offsetX), s(245, scale, offsetY)],
            [s(585, scale, offsetX), s(262, scale, offsetY)],
            [s(565, scale, offsetX), s(273, scale, offsetY)],
            [s(540, scale, offsetX), s(280, scale, offsetY)],
            [s(510, scale, offsetX), s(285, scale, offsetY)],
            [s(480, scale, offsetX), s(288, scale, offsetY)],
            [s(450, scale, offsetX), s(288, scale, offsetY)],
            [s(432, scale, offsetX), s(288, scale, offsetY)],
            [s(410, scale, offsetX), s(285, scale, offsetY)],  // Bottom right
            [s(390, scale, offsetX), s(280, scale, offsetY)],
            [s(370, scale, offsetX), s(272, scale, offsetY)],
            [s(350, scale, offsetX), s(264, scale, offsetY)],
            [s(328, scale, offsetX), s(256, scale, offsetY)]   // Back to start
        ];
        
        dc.fillPolygon(mainBody);
        
        // Small toe/heel piece (rounded rectangle approximated)
        // Path: M160 96L208 96L208 224L160 224C124.7 224 96 195.3 96 160C96 124.7 124.7 96 160 96
        var toe = [
            [s(160, scale, offsetX), s(96, scale, offsetY)],
            [s(208, scale, offsetX), s(96, scale, offsetY)],
            [s(208, scale, offsetX), s(110, scale, offsetY)],
            [s(208, scale, offsetX), s(140, scale, offsetY)],
            [s(208, scale, offsetX), s(170, scale, offsetY)],
            [s(208, scale, offsetX), s(200, scale, offsetY)],
            [s(208, scale, offsetX), s(224, scale, offsetY)],
            [s(195, scale, offsetX), s(224, scale, offsetY)],
            [s(180, scale, offsetX), s(224, scale, offsetY)],
            [s(160, scale, offsetX), s(224, scale, offsetY)],
            [s(145, scale, offsetX), s(222, scale, offsetY)],
            [s(130, scale, offsetX), s(218, scale, offsetY)],
            [s(118, scale, offsetX), s(210, scale, offsetY)],
            [s(108, scale, offsetX), s(198, scale, offsetY)],
            [s(100, scale, offsetX), s(183, scale, offsetY)],
            [s(96, scale, offsetX), s(165, scale, offsetY)],
            [s(96, scale, offsetX), s(160, scale, offsetY)],
            [s(96, scale, offsetX), s(145, scale, offsetY)],
            [s(100, scale, offsetX), s(130, scale, offsetY)],
            [s(108, scale, offsetX), s(118, scale, offsetY)],
            [s(118, scale, offsetX), s(108, scale, offsetY)],
            [s(130, scale, offsetX), s(100, scale, offsetY)],
            [s(145, scale, offsetX), s(96, scale, offsetY)],
            [s(160, scale, offsetX), s(96, scale, offsetY)]
        ];
        
        dc.fillPolygon(toe);
    }
    
    // Draw the second shoe print (lower portion)
    // Path: M264 384C292 368 320 352 368 352C424.4 352 544 368 544 448C544 528 416 576 320 576C279.5 576 225.7 563 192 553.6L192 413.3
    private static function drawSecondShoe(dc as Graphics.Dc, offsetX as Number, offsetY as Number, scale as Float) as Void {
        // Main body of second shoe with detailed curves
        var mainBody = [
            [s(264, scale, offsetX), s(384, scale, offsetY)],  // Start
            [s(270, scale, offsetX), s(380, scale, offsetY)],
            [s(278, scale, offsetX), s(375, scale, offsetY)],
            [s(288, scale, offsetX), s(370, scale, offsetY)],
            [s(300, scale, offsetX), s(365, scale, offsetY)],
            [s(315, scale, offsetX), s(358, scale, offsetY)],
            [s(335, scale, offsetX), s(354, scale, offsetY)],
            [s(355, scale, offsetX), s(352, scale, offsetY)],
            [s(368, scale, offsetX), s(352, scale, offsetY)],
            [s(385, scale, offsetX), s(352, scale, offsetY)],
            [s(405, scale, offsetX), s(352, scale, offsetY)],
            [s(430, scale, offsetX), s(354, scale, offsetY)],
            [s(460, scale, offsetX), s(358, scale, offsetY)],
            [s(490, scale, offsetX), s(364, scale, offsetY)],
            [s(515, scale, offsetX), s(373, scale, offsetY)],
            [s(535, scale, offsetX), s(385, scale, offsetY)],
            [s(544, scale, offsetX), s(400, scale, offsetY)],
            [s(544, scale, offsetX), s(420, scale, offsetY)],
            [s(544, scale, offsetX), s(448, scale, offsetY)],  // Peak
            [s(544, scale, offsetX), s(475, scale, offsetY)],
            [s(540, scale, offsetX), s(500, scale, offsetY)],
            [s(532, scale, offsetX), s(520, scale, offsetY)],
            [s(520, scale, offsetX), s(535, scale, offsetY)],
            [s(500, scale, offsetX), s(548, scale, offsetY)],
            [s(475, scale, offsetX), s(558, scale, offsetY)],
            [s(445, scale, offsetX), s(566, scale, offsetY)],
            [s(410, scale, offsetX), s(572, scale, offsetY)],
            [s(370, scale, offsetX), s(576, scale, offsetY)],
            [s(340, scale, offsetX), s(576, scale, offsetY)],
            [s(320, scale, offsetX), s(576, scale, offsetY)],
            [s(295, scale, offsetX), s(574, scale, offsetY)],
            [s(270, scale, offsetX), s(570, scale, offsetY)],
            [s(245, scale, offsetX), s(565, scale, offsetY)],
            [s(220, scale, offsetX), s(558, scale, offsetY)],
            [s(200, scale, offsetX), s(554, scale, offsetY)],
            [s(192, scale, offsetX), s(554, scale, offsetY)],
            [s(192, scale, offsetX), s(530, scale, offsetY)],
            [s(192, scale, offsetX), s(500, scale, offsetY)],
            [s(192, scale, offsetX), s(470, scale, offsetY)],
            [s(192, scale, offsetX), s(440, scale, offsetY)],
            [s(192, scale, offsetX), s(413, scale, offsetY)],
            [s(200, scale, offsetX), s(408, scale, offsetY)],
            [s(215, scale, offsetX), s(398, scale, offsetY)],
            [s(235, scale, offsetX), s(390, scale, offsetY)],
            [s(264, scale, offsetX), s(384, scale, offsetY)]
        ];
        
        dc.fillPolygon(mainBody);
        
        // Small toe/heel piece (rounded)
        // Path: M96 544C60.7 544 32 515.3 32 480C32 444.7 60.7 416 96 416L144 416L144 544
        var toe = [
            [s(96, scale, offsetX), s(544, scale, offsetY)],
            [s(85, scale, offsetX), s(543, scale, offsetY)],
            [s(75, scale, offsetX), s(540, scale, offsetY)],
            [s(65, scale, offsetX), s(535, scale, offsetY)],
            [s(56, scale, offsetX), s(527, scale, offsetY)],
            [s(48, scale, offsetX), s(517, scale, offsetY)],
            [s(42, scale, offsetX), s(505, scale, offsetY)],
            [s(36, scale, offsetX), s(492, scale, offsetY)],
            [s(32, scale, offsetX), s(480, scale, offsetY)],
            [s(32, scale, offsetX), s(468, scale, offsetY)],
            [s(36, scale, offsetX), s(455, scale, offsetY)],
            [s(42, scale, offsetX), s(443, scale, offsetY)],
            [s(48, scale, offsetX), s(433, scale, offsetY)],
            [s(56, scale, offsetX), s(424, scale, offsetY)],
            [s(65, scale, offsetX), s(418, scale, offsetY)],
            [s(75, scale, offsetX), s(416, scale, offsetY)],
            [s(85, scale, offsetX), s(416, scale, offsetY)],
            [s(96, scale, offsetX), s(416, scale, offsetY)],
            [s(110, scale, offsetX), s(416, scale, offsetY)],
            [s(125, scale, offsetX), s(416, scale, offsetY)],
            [s(144, scale, offsetX), s(416, scale, offsetY)],
            [s(144, scale, offsetX), s(430, scale, offsetY)],
            [s(144, scale, offsetX), s(450, scale, offsetY)],
            [s(144, scale, offsetX), s(475, scale, offsetY)],
            [s(144, scale, offsetX), s(500, scale, offsetY)],
            [s(144, scale, offsetX), s(525, scale, offsetY)],
            [s(144, scale, offsetX), s(544, scale, offsetY)],
            [s(130, scale, offsetX), s(544, scale, offsetY)],
            [s(115, scale, offsetX), s(544, scale, offsetY)],
            [s(96, scale, offsetX), s(544, scale, offsetY)]
        ];
        
        dc.fillPolygon(toe);
    }
    
    // Render a simple, clean heart icon using a mathematical heart curve
    // x, y - center position of the icon
    // size - width/height of the icon (it's square)
    // dc - drawing context
    // color - color to draw the icon (typically red)
    static function drawHeart(dc as Graphics.Dc, x as Number, y as Number, size as Number, color as Number) as Void {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        
        // Create a classic heart shape using a polygon
        // Using a simple, recognizable heart shape that will render cleanly at small sizes
        var heartPolygon = [];
        var numPoints = 60; // Number of points for smooth curves
        var radius = size / 2.5; // Heart size
        
        // Generate heart shape using parametric equations
        // Classic heart curve: x = 16sin³(t), y = 13cos(t) - 5cos(2t) - 2cos(3t) - cos(4t)
        var i = 0;
        while (i < numPoints) {
            var t = (i * 2.0 * Math.PI) / numPoints;
            
            // Heart curve equations (scaled and adjusted)
            var sinT = Math.sin(t);
            var cosT = Math.cos(t);
            var sin3T = sinT * sinT * sinT;
            
            var heartX = 16 * sin3T;
            var heartY = -(13 * cosT - 5 * Math.cos(2 * t) - 2 * Math.cos(3 * t) - Math.cos(4 * t));
            
            // Scale and position
            var px = x + (heartX * radius / 16.0).toNumber();
            var py = y + (heartY * radius / 16.0).toNumber() - (radius * 0.1).toNumber(); // Slight upward adjustment
            
            heartPolygon.add([px, py]);
            i++;
        }
        
        dc.fillPolygon(heartPolygon);
    }
    
    // Render the classic Bluetooth icon - simple angular shape in a circle
    // x, y - center position of the icon
    // size - width/height of the icon
    // dc - drawing context
    // color - color to draw the icon (typically blue)
    static function drawBluetooth(dc as Graphics.Dc, x as Number, y as Number, size as Number, color as Number) as Void {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        
        // Calculate pen width based on size (scales linearly, minimum 1)
        var circlePenWidth = (size * 4.0 / 100.0).toNumber();
        if (circlePenWidth < 1) {
            circlePenWidth = 1;
        }
        
        var symbolPenWidth = (size * 8.0 / 100.0).toNumber();
        if (symbolPenWidth < 1) {
            symbolPenWidth = 1;
        }
        
        // Draw circular border
        var radius = (size / 2.0).toNumber();
        dc.setPenWidth(circlePenWidth);
        //dc.drawCircle(x, y, radius);
        
        // Define the 6 key points of the Bluetooth symbol
        var points = [
            [0.25, 0.75],     // Point 0: Bottom-left
            [0.75, 0.25],        // Point 1: Top-left
            [0.5, 0],       // Point 2: Right-middle
            [0.5, 1],     // Point 3: Bottom-left (for drawing back)
            [0.75, 0.75],       // Point 4: Right-middle (for crossing line)
            [0.25, 0.25]         // Point 5: Top-left (to complete)
        ];
        
        // Draw the Bluetooth symbol by connecting the points
        dc.setPenWidth(symbolPenWidth);
        for (var i = 0; i < points.size() - 1; i++) {
            var p1 = points[i];
            var p2 = points[i + 1];
            dc.drawLine(
                x + ((p1[0] - 0.5) * size).toNumber(),
                y + ((p1[1] - 0.5) * size).toNumber(),
                x + ((p2[0] - 0.5) * size).toNumber(),
                y + ((p2[1] - 0.5) * size).toNumber()
            );
        }
    }
    
    // Helper function to scale and offset a coordinate
    private static function s(coord as Number, scaleFactor as Float, offset as Number) as Number {
        return ((coord * scaleFactor) + offset).toNumber();
    }
}
