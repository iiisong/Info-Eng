// HEADER
// Isaac Song
// 8/31/2020
// Conway's Game of Life Game
// Instructions starts at line 49

import java.util.Arrays;

// Presets
  // small 5 by 5 empty grid
  boolean[][] empty = {{false, false, false, false, false},
                       {false, false, false, false, false},
                       {false, false, false, false, false},
                       {false, false, true, false, false},
                       {false, false, false, false, false}};
  
  // large 200 by 200 empty grid
  boolean[][] bigEmpty = new boolean[200][200];
  
  // solid unchanging 2 by 2 block
  boolean[][] block = {{false, false, false, false, false},
                       {false, true, true, false, false},
                       {false, true, true, false, false},
                       {false, false, false, false, false},
                       {false, false, false, false, false}};
                       
  // 3 by 1 block flipping continously between vertical and horizontal
  boolean[][] blinker = {{false, false, false, false, false},
                         {false, false, false, false, false},
                         {false, true, true, true, false},
                         {false, false, false, false, false},
                         {false, false, false, false, false}};
  
  // diogonal flying pattern
  boolean[][] glider = {{true,   false,  false,  false, false},
                        {false,  true,   true,   false, false},
                        {true,   true,   false,  false, false},
                        {false,  false,  false,   false, false},
                        {false,  false,  false,  false, false}};
  
  // the code specifically to instantiate the bigger patterns are at the very bottom
  // because the code is long, braindead, and boring
  boolean[][] gliderBig = new boolean[100][100]; // glider but on a larger 100 by 100 board
  boolean[][] spaceship = new boolean[100][100]; // horizontal-flying "light-weight" spaceship
  boolean[][] rPentamino = new boolean[100][100]; // r-Pentamino, takes 1103 generations to stabilize
  boolean[][] dieHard = new boolean[100][100]; // takes 130 generations to fully die
  boolean[][] gosperGun = new boolean[100][100]; // continuously produces gliders

//----------------------------------// INSTRUCTION AND SETTINGS //----------------------------------//
    /* 
    The 3 Rules of Conway's Game of Life:
      1. A live cell stays alive if it has 2 or 3 neighbors next to each other
      2. A dead cell gets revived if it has 3 neighbors next to it
      3. All other cells dies
    
    How to play: 
      1. change universal settings starting on line 98
      2. change the value of the varable "mode" on line 93 to the desired mode listed below
      3. follow the instructions listed under each mode below

      Mode 0: Preset Patterns - run preset interesting patterns that I previously initated by hand
        Instructions:
          4. make sure a pattern is chosen from the list of presets above by changing the name of the value of "patterns"  on line 94 to the desired pattern
          5. run the code
      
      Mode 1: Create Own Patterns to run on blank board, specify settings of board below
        Instructions:
          4. specify creation board settings below starting on line 103
          5. run the code
          6. toggle cells on the creation board to make them alive or dead by clicking on them
          7. press Enter/Return to run your pattern
          8. press Enter/Return again to return to your creation board
     
      Mode 2: Create your own patterns to solve puzzles
        Goal: the win condition; have a live cell occupy the goal to win
        Bomb: loses a life if live cell touches it
        Blocks: the cell can not have a live cell on it
        Lives: if all lives are loss, game loses
        
        Instructions:
          4. specify creation board settings below starting on line 103
          5. add/edit/remove game elements by adding/editing/remove coordinate and change other settings starting on line 112
          6. run the code
          7. take note of the game elements (goal, bombs, blocks, etc) and where the creation board is located (in light blue)
          8. press Enter/Return to go to your creation board
          9. toggle cells on the creation board to make them alive or dead by clicking on them
          10. press Enter/Return to run your pattern
          11. press Enter/Return again to return to your creation board to edit
          12. give up because its way too difficult
    */
    
    // Mode and Pattern Selection
    int mode = 2; // toggle 0 to run preset patterns, 1 to create own patterns, 2 to play game
    boolean[][] pattern = gosperGun; // choose which pattern to run from above
    
    // Settings
      // Universal Settings (Mode 0, 1, 2)
      int displayWidth = 1750; // window width of game
      int displayHeight = 1000; // window height of the game
      int sideLength = 30; // side length of individual cells in the game
      int delay = 20; // specify the delay between generations
      
      // Creation Settings (Mode 1 and 2)
      int createSideLength = 40; // side length of individual cells in the creation board
      int bWidth = 30; // width of the board
      int bHeight = 30; // height of the board
      int rCreation = 10; // size of creation board
      int cCreation = 10; // size of creation board
      int rOffset = 0; // creation board row offset on the board
      int cOffset = 0; // creation board col offset on the board
      
      // Game Settings (Mode 2)
      int[] goal = {20, 22}; // {y, x} of goal to win
      int[][] bombs = {{15, 20},{20, 17}}; // array of bombs in {{y, x}, {y, x}, ...} form
      int[][] blocks = {{13, 5}, {13, 6}, {13, 7}}; // array of blocks in {{y, x}, {y, x}, ...} form
      int lives = -1; // number of lives till death at 0, -1 for unlimited
      int startingLimit = -1; // number of live cells allowed when creating patterns, -1 for unlimited
      int damageDelay = 100; // length of delay when damaged
//----------------------------------//------------//----------------------------------//

gameSetup gameCreate; // instantiate creation 
Conways game; // instantiate game

void setup() {
  instantiateBigConway(); // sets the values for big patterns
  size(displayWidth, displayHeight); // sets window dimensions
  game = mode == 0 ? new Conways(pattern) : new Conways(new boolean[bHeight][bWidth]); // choose which pattern to run
  gameCreate = new gameSetup(rCreation, cCreation); // create creation board
  background(255); // white
  stroke(200); // light gray stroke
}

boolean create = true ? mode == 1 : false; // true

void draw() {
  // shouldn't run when running presets
  if (create == true && mode != 0) {
    gameCreate.display(createSideLength); // display creation board
  } else {
    game.display(sideLength); // adjust side length of individual cell
    delay(delay); // adjust delay between generations 
    game.nextGen(); // calculates the pattern for the next gen
  }
}

void mouseClicked() {
  // only trigger when in creation
  if (create == true) {
    gameCreate.clicked(); // toggles cell
  }
}

void keyPressed() {  
  // only react to enter/return
  if (key != RETURN && key != ENTER) {
    return;
  }
  
  // toggle between create and run
  if (create == false && mode != 0) {
    create = true; // switch draw() view
  } else {
    create = false; // switch draw() view
    
    // generate new conway
    game = new Conways(gameCreate.bigMatrix(rOffset, cOffset, bWidth, bHeight));
    // game = new Conways(gameCreate.rawMatrix());
  }
}

// calculates and displays Conways
public class Conways {
  private final int rows; // number of rows in the board
  private final int cols; // number of columns in the board
  private int sideLength; // length of individual cell side
  
  private int[][] neighbors; // number of alive cells next to each cell
  private boolean[][] cellLife; // whether the cell is alive or not
  private int lifeCount = lives; // the lives are tracked internally not globally
  
  private int gameStatus = 0; // 0 for normal, 1 for damaged, 2 for win
  
  public Conways(boolean[][] cellLife) {
    this.rows = cellLife.length;
    this.cols = cellLife[0].length;
    this.cellLife= cellLife;
  }
  
  public boolean[][] cellLife() {
    return cellLife;
  }
  
  public int rows() {
    return rows;
  }
  
  public int cols() {
    return cols;
  }
  
  public int sideLength() {
    return sideLength;
  }
  
  public int lifeCount() {
    return lifeCount;
  }
  
  // update display
  public void display(int sideLength) {
    this.sideLength = sideLength;
    
    // if dead
    if (lifeCount <= 0 && lives != -1) {
      background(255, 0, 0); // red
      return;
    }
    
    // if win
    if (gameStatus == 2) {
      background(255, 255, 0); // yellow
      return;
    }
    
    // if damaged
    if (gameStatus == 1) {
      delay(damageDelay);
      gameStatus = 0; // go back to game status
    }
    
    background(255); // white
    for (int r = 0; r < rows; r++) {
      for(int c = 0; c < cols; c++) {
        // color cell black if alive
        if (cellLife[r][c]) {
          fill(0); // black
        
        // color cell white if dead
        } else {
          if (r >= rOffset && r <= rOffset + rCreation && c >= cOffset && c <= cOffset + cCreation) {
            fill(191, 255, 255); // light blue for starting cells
          } else {
          fill(255); // white
          }
        }
        
        // game part //
        if (mode != 1) {
          int[] currentCell = {r, c};// current cell
          
          // goal
          if (Arrays.equals(currentCell, goal)) {
            if (cellLife[r][c]) {
              gameStatus = 2; // win
            }
            
            fill(255,255,0); // yellow
          }
          
          // bombs
          for (int[] bomb : bombs) {
            if (Arrays.equals(currentCell, bomb)) {
              if (cellLife[r][c]) {
                lifeCount -= 1; // lose a life
                gameStatus = 1; // damaged state
                fill(208, 0, 255); // purple
              } else {
                fill(255,0,0); // red
              }
            }
          }
          
          // blocks
          for (int[] block : blocks) {
            if (Arrays.equals(currentCell, block)) {
              cellLife[r][c] = false; // cells on blocks will always be dead
              fill(0,255,0); // green
            }
          }
        }
          
        // create cell
        rect(c * sideLength, r * sideLength, sideLength, sideLength);
      }
    }
    
    return;
  }
  
  // see which cells living next generation
  private void nextGen() {
    // clear neighbors
    neighbors = new int[rows][cols];
    
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        // fill neighbors with the number of alives cells around each cell
        evalHelper(r, c);  
      }
    }
    
    // evaluate first row first
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        // cell survives if two or three neighbors are alive
        if (cellLife[r][c] && (neighbors[r][c] == 2 || neighbors[r][c] == 3)) {
          cellLife[r][c] = true; 
           
        // cell revives if three neighbors alive
        } else if (!cellLife[r][c] && neighbors[r][c] == 3) {
          cellLife[r][c] = true;
           
        // cell dies otherwise
        } else {
          cellLife[r][c] = false;
        }
      }
    }
    
    return;
  }
  
  // iterate neighbors counter if cell is alive
  private void evalHelper(int r, int c) {
    // only change neighbors if cell is alive
    if (!cellLife[r][c]) {
      return;
    }
    
    // every row but top row
    if (r != 0) {
      neighbors[r - 1][c] += 1; // up
      
      // not left col
      if (c != 0) { 
        neighbors[r - 1][c - 1] += 1; // up-left
      }
      
      // not right col
      if (c != cols - 1) { 
        neighbors[r - 1][c + 1] += 1; // up right
        
      }
    }
    
    // every row but bottom row
    if (r != rows - 1) { 
      neighbors[r + 1][c] += 1; // down
      
      // not left col
      if (c != 0) { 
        neighbors[r + 1][c - 1] += 1; // down left
      }
      
      // not right col
      if (c != cols - 1) {
        neighbors[r + 1][c + 1] += 1; // down right
      }
    }
    
    if (c != 0) {
      neighbors[r][c - 1] += 1; // left
    }
    
    if (c != cols - 1) {
      neighbors[r][c + 1] += 1; // right
    }
  }
}

// Pattern Creation
public class gameSetup {
  private int rows; // number of rows able to be created
  private int cols; // number of cols able to be created
  private int sideLength; // side length of cell in creation board
  private boolean[][] cellLife;
  
  private int[] goal; // [r, c] of goal
  private int[][] bomb; // array of bombs in [r, c] form
  private int[][] block; // array of blocks in [r, c] form
  private int aliveCount = 0; // number of cells alive at creation
  
  public gameSetup(int rows, int cols) {
    this.rows = rows;
    this.cols = cols;
    cellLife = new boolean[rows][cols];
  }
  
  // return cellLife in large board
  public boolean[][] bigMatrix(int rOffset, int cOffset, int bigRows, int bigCols) {
    boolean[][] bigBoard = new boolean[bigRows][bigCols];
    
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        bigBoard[r + rOffset][c + cOffset] = cellLife[r][c];
      }
    }
    
    return bigBoard;
  }
  
  // return raw value of cellLife
  public boolean[][] rawMatrix() {
    return cellLife;
  }
  
  // update display
  public void display(int sideLength) {
    background(255); // white
    this.sideLength = sideLength;
    
    for (int r = 0; r < rows; r++) {
      for(int c = 0; c < cols; c++) {
        // color cell black if alive
        if (cellLife[r][c]) {
          fill(0); // black
        
        // color cell white if dead
        } else {
          fill(255); // white
        }
        
        // create cell
        rect(c * sideLength, r * sideLength, sideLength, sideLength);
      }
    }
  }
  
  // selection of cell
  public void clicked() {
    if (mouseX < 0 || mouseX > sideLength * rows || mouseY < 0 || mouseY > sideLength * cols) {
      return;
    }
      
    int cellX = mouseY / sideLength;
    int cellY = mouseX / sideLength;
    
    // selected cell is dead
    if (!cellLife[cellX][cellY]) {
      if (aliveCount < startingLimit || startingLimit == -1) {
        cellLife[cellX][cellY] = true; // toggle cell to life
        aliveCount += startingLimit != -1 ? 1  : 0;
      }
      
    // selected cell is alive
    } else {
      cellLife[cellX][cellY] = false; // toggle cell to death
      aliveCount -= startingLimit != -1 ? 1  : 0;
    }
  }
}

// used to instantiate big patterns
void instantiateBigConway() {
  // for glider
  gliderBig[0][0] = true;
  gliderBig[1][1] = true;
  gliderBig[1][2] = true;
  gliderBig[2][0] = true;
  gliderBig[2][1] = true;
  
  // for spaceship
  spaceship[0][0] = true;
  spaceship[0][3] = true;
  spaceship[1][4] = true;
  spaceship[2][0] = true;
  spaceship[2][4] = true;
  spaceship[3][1] = true;
  spaceship[3][2] = true;
  spaceship[3][3] = true;
  spaceship[3][4] = true;
  
  // for rPentamino
  rPentamino[40][80] = true;
  rPentamino[40][81] = true;
  rPentamino[41][79] = true;
  rPentamino[41][80] = true;
  rPentamino[42][80] = true;
  
  // for dieHard
  dieHard[40][40] = true;
  dieHard[40][41] = true;
  dieHard[41][41] = true;
  dieHard[41][45] = true;
  dieHard[41][46] = true;
  dieHard[41][47] = true;
  dieHard[39][46] = true;
  
  // for gosperGun
  gosperGun[20][20] = true;
  gosperGun[20][21] = true;
  gosperGun[21][20] = true;
  gosperGun[21][21] = true;
  gosperGun[20][30] = true;
  gosperGun[21][30] = true;
  gosperGun[22][30] = true;
  gosperGun[23][31] = true;
  gosperGun[19][31] = true;
  gosperGun[18][32] = true;
  gosperGun[18][33] = true;
  gosperGun[24][32] = true;
  gosperGun[24][33] = true;
  gosperGun[21][34] = true;
  gosperGun[19][35] = true;
  gosperGun[23][35] = true;
  gosperGun[20][36] = true;
  gosperGun[21][36] = true;
  gosperGun[22][36] = true;
  gosperGun[21][37] = true;
  gosperGun[20][40] = true;
  gosperGun[19][40] = true;
  gosperGun[18][40] = true;
  gosperGun[20][41] = true;
  gosperGun[19][41] = true;
  gosperGun[18][41] = true;
  gosperGun[17][42] = true;
  gosperGun[21][42] = true;
  gosperGun[16][44] = true;
  gosperGun[17][44] = true;
  gosperGun[21][44] = true;
  gosperGun[22][44] = true;
  gosperGun[18][54] = true;
  gosperGun[19][54] = true;
  gosperGun[18][55] = true;
  gosperGun[19][55] = true;
}
