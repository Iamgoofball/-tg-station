/obj/item/puzzlescript_paper
	name = "puzzle paper"
	desc = "A piece of paper with a grid puzzle printed on it. The squares seem to shift when you look at them."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	var/game_title = "Sokoban"
	var/puzzle_script_code = null

/obj/item/puzzlescript_paper/attack_self(mob/user)
	if(!puzzle_script_code)
		puzzle_script_code = default_sokoban_game()
	var/datum/browser/popup = new(user, "puzzlescript_[REF(src)]", "[game_title]", 800, 600)
	popup.set_content(generate_puzzlescript_html(puzzle_script_code, game_title))
	popup.open()

/obj/item/puzzlescript_paper/proc/generate_puzzlescript_html(script_code, title)
	var/html = {"<!DOCTYPE html>
<html>
<head>
<meta charset='utf-8'>
<title>[title]</title>
<style>
body { margin: 0; padding: 0; background: #000; overflow: hidden; }
#gameCanvas { display: block; margin: 0 auto; }
#loading { color: #fff; font-family: monospace; text-align: center; padding: 20px; font-size: 16px; }
</style>
</head>
<body>
<div id='loading'>Loading [title]...</div>
<script>
var PUZZLESCRIPT_CODE = [json_encode(script_code)];

// Minimal PuzzleScript-compatible Sokoban engine
(function() {
  var canvas, ctx, gameState;
  var TILE = 48;
  var COLORS = {
    background: '#000000',
    wall: '#8B4513',
    player: '#FFD700',
    box: '#8B6914',
    target: '#00FF00',
    boxOnTarget: '#FF8C00',
    floor: '#1a1a1a'
  };

  var levels = [
    [
      '  #####',
      '###   #',
      '#.P   #',
      '### B.#',
      '#.##B #',
      '# # . #',
      '#B  ###',
      '#####'
    ],
    [
      '#######',
      '#     #',
      '# B.B #',
      '# .P. #',
      '# B.B #',
      '#     #',
      '#######'
    ],
    [
      '  ####',
      '  #  #',
      '  #B #',
      '###B #',
      '#.P B#',
      '##### #',
      '  #.  #',
      '  #####'
    ]
  ];

  var currentLevel = 0;
  var grid, playerPos, boxes, targets, moves;

  function parseLevel(levelData) {
    grid = [];
    boxes = [];
    targets = [];
    playerPos = {x: 0, y: 0};
    moves = 0;
    for (var y = 0; y < levelData.length; y++) {
      grid[y] = [];
      for (var x = 0; x < levelData[y].length; x++) {
        var ch = levelData[y][x];
        if (ch === '#') { grid[y][x] = 'wall'; }
        else if (ch === '.') { grid[y][x] = 'target'; targets.push({x:x,y:y}); }
        else if (ch === 'B') { grid[y][x] = 'floor'; boxes.push({x:x,y:y}); }
        else if (ch === 'P') { grid[y][x] = 'floor'; playerPos = {x:x,y:y}; }
        else if (ch === '+') { grid[y][x] = 'target'; targets.push({x:x,y:y}); playerPos = {x:x,y:y}; }
        else if (ch === '*') { grid[y][x] = 'target'; targets.push({x:x,y:y}); boxes.push({x:x,y:y}); }
        else { grid[y][x] = 'floor'; }
      }
    }
  }

  function isWall(x, y) {
    if (!grid[y] || grid[y][x] === undefined) return true;
    return grid[y][x] === 'wall';
  }

  function isBox(x, y) {
    for (var i = 0; i < boxes.length; i++) {
      if (boxes[i].x === x && boxes[i].y === y) return i;
    }
    return -1;
  }

  function isTarget(x, y) {
    for (var i = 0; i < targets.length; i++) {
      if (targets[i].x === x && targets[i].y === y) return true;
    }
    return false;
  }

  function checkWin() {
    for (var i = 0; i < targets.length; i++) {
      if (isBox(targets[i].x, targets[i].y) === -1) return false;
    }
    return boxes.length > 0 && targets.length > 0;
  }

  function move(dx, dy) {
    var nx = playerPos.x + dx;
    var ny = playerPos.y + dy;
    if (isWall(nx, ny)) return;
    var bi = isBox(nx, ny);
    if (bi !== -1) {
      var bx = nx + dx;
      var by = ny + dy;
      if (isWall(bx, by) || isBox(bx, by) !== -1) return;
      boxes[bi].x = bx;
      boxes[bi].y = by;
    }
    playerPos.x = nx;
    playerPos.y = ny;
    moves++;
    draw();
    if (checkWin()) {
      setTimeout(function() {
        currentLevel = (currentLevel + 1) % levels.length;
        parseLevel(levels[currentLevel]);
        draw();
        showMessage('Level ' + (currentLevel + 1));
      }, 500);
    }
  }

  function showMessage(msg) {
    ctx.fillStyle = 'rgba(0,0,0,0.7)';
    ctx.fillRect(0, canvas.height/2 - 30, canvas.width, 60);
    ctx.fillStyle = '#FFD700';
    ctx.font = 'bold 24px monospace';
    ctx.textAlign = 'center';
    ctx.fillText(msg, canvas.width/2, canvas.height/2 + 8);
  }

  function draw() {
    if (!ctx) return;
    ctx.fillStyle = COLORS.background;
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    var maxW = 0;
    for (var y = 0; y < grid.length; y++) {
      if (grid[y].length > maxW) maxW = grid[y].length;
    }
    var offX = Math.floor((canvas.width - maxW * TILE) / 2);
    var offY = Math.floor((canvas.height - grid.length * TILE) / 2);
    if (offX < 0) offX = 0;
    if (offY < 0) offY = 0;

    for (var y = 0; y < grid.length; y++) {
      for (var x = 0; x < grid[y].length; x++) {
        var px = offX + x * TILE;
        var py = offY + y * TILE;
        var cell = grid[y][x];
        if (cell === 'wall') {
          ctx.fillStyle = COLORS.wall;
          ctx.fillRect(px, py, TILE, TILE);
          ctx.fillStyle = '#6B3410';
          ctx.fillRect(px+2, py+2, TILE-4, TILE-4);
        } else if (cell === 'target') {
          ctx.fillStyle = COLORS.floor;
          ctx.fillRect(px, py, TILE, TILE);
          ctx.strokeStyle = COLORS.target;
          ctx.lineWidth = 3;
          ctx.strokeRect(px+6, py+6, TILE-12, TILE-12);
        } else {
          ctx.fillStyle = COLORS.floor;
          ctx.fillRect(px, py, TILE, TILE);
        }
      }
    }

    for (var i = 0; i < boxes.length; i++) {
      var bx = offX + boxes[i].x * TILE;
      var by = offY + boxes[i].y * TILE;
      var onTarget = isTarget(boxes[i].x, boxes[i].y);
      ctx.fillStyle = onTarget ? COLORS.boxOnTarget : COLORS.box;
      ctx.fillRect(bx+3, by+3, TILE-6, TILE-6);
      ctx.strokeStyle = onTarget ? '#FF6600' : '#5a4510';
      ctx.lineWidth = 2;
      ctx.strokeRect(bx+3, by+3, TILE-6, TILE-6);
      if (onTarget) {
        ctx.strokeStyle = '#FFD700';
        ctx.lineWidth = 2;
        ctx.strokeRect(bx+8, by+8, TILE-16, TILE-16);
      }
    }

    var px2 = offX + playerPos.x * TILE;
    var py2 = offY + playerPos.y * TILE;
    ctx.fillStyle = COLORS.player;
    ctx.beginPath();
    ctx.arc(px2 + TILE/2, py2 + TILE/2, TILE/2 - 4, 0, Math.PI*2);
    ctx.fill();
    ctx.fillStyle = '#000';
    ctx.beginPath();
    ctx.arc(px2 + TILE/2 - 5, py2 + TILE/2 - 4, 3, 0, Math.PI*2);
    ctx.fill();
    ctx.beginPath();
    ctx.arc(px2 + TILE/2 + 5, py2 + TILE/2 - 4, 3, 0, Math.PI*2);
    ctx.fill();

    ctx.fillStyle = '#888';
    ctx.font = '14px monospace';
    ctx.textAlign = 'left';
    ctx.fillText('Level: ' + (currentLevel+1) + '/' + levels.length + '  Moves: ' + moves, 8, 20);
    ctx.fillText('Arrow keys or WASD to move  |  R to restart', 8, canvas.height - 8);
  }

  function init() {
    document.getElementById('loading').style.display = 'none';
    canvas = document.createElement('canvas');
    canvas.id = 'gameCanvas';
    canvas.width = 600;
    canvas.height = 500;
    canvas.style.background = '#000';
    document.body.appendChild(canvas);
    ctx = canvas.getContext('2d');
    parseLevel(levels[currentLevel]);
    draw();
    showMessage('Level 1');

    document.addEventListener('keydown', function(e) {
      switch(e.key) {
        case 'ArrowUp': case 'w': case 'W': e.preventDefault(); move(0,-1); break;
        case 'ArrowDown': case 's': case 'S': e.preventDefault(); move(0,1); break;
        case 'ArrowLeft': case 'a': case 'A': e.preventDefault(); move(-1,0); break;
        case 'ArrowRight': case 'd': case 'D': e.preventDefault(); move(1,0); break;
        case 'r': case 'R': parseLevel(levels[currentLevel]); draw(); break;
      }
    });
  }

  window.onload = init;
})();
</script>
</body>
</html>"}
	return html

/obj/item/puzzlescript_paper/proc/default_sokoban_game()
	return "sokoban"

// Craftable variant
/obj/item/puzzlescript_paper/sokoban
	name = "sokoban puzzle paper"
	desc = "A piece of paper with a hand-drawn Sokoban puzzle on it. Push all the boxes onto the marked targets!"
	game_title = "Sokoban"
