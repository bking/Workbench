// Units are in inches

// Dimensions of the boards I'm working with (2x4, in name only)
boardWidth = 3.5;
boardThickness = 1.5;

// 24 2x4 boards make the top. The boards are really 1.5"x3.5" tho.
benchtopWidth = 60;
benchtopDepth = 36;
benchtopHeight = 36;

// Distance from the floor to the bottom crossbars
bottomClearance = 6;

// Insets of the legs from the edges of the benchtop
iLeft = 6;
iRight = 6;
iFront = 0;
iBack = 0;


// Legs are 2 boards glued together
legDepth = 2 * boardThickness;
legWidth = boardWidth;

// frameHeight is the height of the frame. The benchtop sits on top of
// the frame.
frameHeight = benchtopHeight - boardWidth;

// Scaling for the boards placed in the benchtop. Setting this to
// something smaller than 1 will show the individual boards used to
// make the top.
scaleFactor=0.9;

// A 2x4 board (actually 1.5"x3.5")
module board(length = 96) {
    echo("Board: ", length=length);
    cube([length, boardThickness, boardWidth]);
}

// The top of the bench. Boards are stacked vertically to
// create a top the thickness of the board width (3.5" for a 2x4)
benchtopBoardCount = benchtopDepth / boardThickness;
echo(benchtopBoardCount=benchtopBoardCount);
module benchtop() {
    for (i = [0:boardThickness:benchtopDepth - boardThickness]) {
        translate([0, i, 0]) {
            scale([1, scaleFactor, scaleFactor]) {
                board(benchtopWidth);
            }
        }    
    }
}

// One leg = 2 boards together
module leg(legHeight = frameHeight) {
    rotate([0, 270, 0]) board(legHeight);
    translate([0, boardThickness, 0]) rotate([0, 270, 0]) board(legHeight);
}

module crossbars() {
    crossbarWidth = benchtopWidth - iLeft - iRight;
    crossbarDepth = benchtopDepth - iBack - iFront;

    translate([iLeft, iFront, 0]) board(crossbarWidth);
    translate([iLeft, benchtopDepth - iBack - boardThickness, 0]) board(crossbarWidth);
    translate([iLeft, iFront, 0]) rotate([0, 0, 90]) board(crossbarDepth);
    translate([benchtopWidth - iRight + boardThickness, iFront, 0]) rotate([0, 0, 90]) board(crossbarDepth);
}

// Creates the frame with legs inset to the argument values
module frame() {
    // 4 legs
    translate([iLeft + legWidth, iFront, 0]) leg();
    translate([benchtopWidth - iRight, benchtopDepth - legDepth - iBack, 0]) leg();
    translate([benchtopWidth - iRight, iFront, 0]) leg();
    translate([iLeft + legWidth, benchtopDepth - iBack - legDepth, 0]) leg();

    // Crossbars
    translate([0, 0, bottomClearance]) crossbars(iLeft, iRight, iFront, iBack);
    translate([0, 0, frameHeight - boardWidth]) crossbars(iLeft, iRight, iFront, iBack);
}

// Draw it all
color("BurlyWood") translate([0, 0, benchtopHeight - boardWidth]) benchtop();
color("BurlyWood") frame();
