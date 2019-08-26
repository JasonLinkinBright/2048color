import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logic.dart';
import 'dart:math' as math;

void main() => runApp(MyApp());

final Map<int, Color> BoxColors = <int, Color>{
  2: Color(0xFFf5e289),
  4: Color(0xFF95e8ac),
  8: Color(0xFFfba27c),
  16: Color(0xFFbebdf7),
  32: Color(0xFFb285f7),
  64: Color(0xFF42A5F5),
  512: Color(0xFF7e64da),
  128: Color(0xFF5acfdb),
  256: Color(0xFFf785e0),
  1024: Color(0xFFf95570),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Opacity Demo';
    return MaterialApp(
        title: appTitle,
        home: new Scaffold(
          body: GameWidget(),
        ));
  }
}

///背景
class BoardGridWidget extends StatelessWidget {
  final _GameWidgetState _state;

  BoardGridWidget(this._state);

  @override
  Widget build(BuildContext context) {
    Size boardSize = _state.boardSize();
    double width =
        (boardSize.width - (_state.column + 1) * _state.cellPadding) /
            _state.column;
    List<CellBox> _backgroundBox = List<CellBox>();
    for (int r = 0; r < _state.row; ++r) {
      for (int c = 0; c < _state.column; ++c) {
        CellBox box = CellBox(
          left: c * width + _state.cellPadding * (c + 1),
          top: r * width + _state.cellPadding * (r + 1),
          size: width,
          color: Colors.grey[200],
        );
        _backgroundBox.add(box);
      }
    }
    return Positioned(
        left: 0.0,
        top: 0.0,
        child: Container(
          width: _state.boardSize().width,
          height: _state.boardSize().height,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Stack(
            children: _backgroundBox,
          ),
        ));
  }
}

class GameWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameWidgetState();
  }
}

class _GameWidgetState extends State<GameWidget> {
  Game _game;
  MediaQueryData _queryData;
  final int row = 4;
  final int column = 4;
  final double cellPadding = 5.0;
  final EdgeInsets _gameMargin = EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0);
  bool _isDragging = false;
  bool _isGameOver = false;
  bool _isReachLimit = false;

  @override
  void initState() {
    super.initState();
    _game = Game(row, column, 2048);
    newGame();
  }

  void newGame() {
    _game.init();
    _isGameOver = false;
    setState(() {});
  }

  void moveLeft() {
    setState(() {
      _game.moveLeft();
      checkGameOver();
    });
  }

  void moveRight() {
    setState(() {
      _game.moveRight();
      checkGameOver();
    });
  }

  void moveUp() {
    setState(() {
      _game.moveUp();
      checkGameOver();
    });
  }

  void moveDown() {
    setState(() {
      _game.moveDown();
      checkGameOver();
    });
  }

  void checkGameOver() {
    if (_game.isGameOver()) {
      _isGameOver = true;
    } else if (_game.isReachLimit()) {
      _isGameOver = true;
      _isReachLimit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<CellWidget> _cellWidgets = List<CellWidget>();
    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        _cellWidgets.add(CellWidget(cell: _game.get(r, c), state: this));
      }
    }
    _queryData = MediaQuery.of(context);
    List<Widget> children = List<Widget>();
    children.add(BoardGridWidget(this));
    children.addAll(_cellWidgets);
    return Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.fromLTRB(20.0, 64.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.yellow[600],
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Text(
                    "2048",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(25.0, 0.0, 15.0, 0.0),
                  width: 200,
                  height: 100,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              color: Colors.blue[100],
                              child: Container(
                                width: 80.0,
                                height: 50.0,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "得分",
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      Text(
                                        _game.score.toString(),
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            OutlineButton(
                              padding: EdgeInsets.all(0.0),
                              color: Colors.blue[400],
                              shape: StadiumBorder(),
                              textColor: Colors.blue,
                              child: Text('菜单'),
                              borderSide: BorderSide(
                                  color: Colors.blue,
                                  style: BorderStyle.solid,
                                  width: 1),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              color: Colors.blue[100],
                              child: Container(
                                width: 80.0,
                                height: 50.0,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "最高记录",
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      FutureBuilder<String>(
                                        future: getBestScore(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              snapshot.data.toString(),
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[800],
                                              ),
                                            );
                                          } else
                                            return Text('0');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            OutlineButton(
                              padding: EdgeInsets.all(0.0),
                              color: Colors.blue[400],
                              shape: StadiumBorder(),
                              textColor: Colors.blue,
                              child: Text('新游戏'),
                              borderSide: BorderSide(
                                  color: Colors.blue,
                                  style: BorderStyle.solid,
                                  width: 1),
                              onPressed: () {
                                newGame();
                              },
                            ),
                          ],
                        ),
                      ]),
                ),
              ],
            )),
        Container(
          height: 50.0,
          child: Opacity(
            opacity: _isGameOver ? 1.0 : 0.0,
            child: Center(
              child: Text(_isReachLimit ? "大吉大利，今晚吃鸡" : "oops,游戏结束",
                  style: TextStyle(
                    fontSize: 24.0,
                  )),
            ),
          ),
        ),
        Container(
            margin: _gameMargin,
            width: _queryData.size.width,
            height: _queryData.size.width,
            child: GestureDetector(
              onVerticalDragUpdate: (detail) {
                if (detail.delta.distance == 0 || _isDragging || _isGameOver) {
                  return;
                }
                _isDragging = true;
                if (detail.delta.direction > 0) {
                  moveDown();
                } else {
                  moveUp();
                }
              },
              onVerticalDragEnd: (detail) {
                _isDragging = false;
              },
              onVerticalDragCancel: () {
                _isDragging = false;
              },
              onHorizontalDragUpdate: (detail) {
                if (detail.delta.distance == 0 || _isDragging || _isGameOver) {
                  return;
                }
                _isDragging = true;
                if (detail.delta.direction > 0) {
                  moveLeft();
                } else {
                  moveRight();
                }
              },
              onHorizontalDragDown: (detail) {
                _isDragging = false;
              },
              onHorizontalDragCancel: () {
                _isDragging = false;
              },
              child: Stack(
                children: children,
              ),
            )),
      ],
    );
  }

  int highScore;
  SharedPreferences prefs;

  Size boardSize() {
    assert(_queryData != null);
    Size size = _queryData.size;
    num width = size.width - _gameMargin.left - _gameMargin.right;
    return Size(width, width);
  }

  Future<String> getBestScore() async {
    prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('score') ?? 0;
    if (_game.score > highScore) await prefs.setInt('score', _game.score);
    highScore = prefs.getInt('score') ?? 0;
    return highScore.toString();
  }

//  void setBestScore() async {
//    prefs = await SharedPreferences.getInstance();
//    highScore = prefs.getInt('score') ?? 0;
//    if (_game.score > highScore) await prefs.setInt('score', score);
//    highScore = prefs.getInt('score') ?? 0;
//  }

}

class AnimatedCellWidget extends AnimatedWidget {
  final BoardCell cell;
  final _GameWidgetState state;

  AnimatedCellWidget(
      {Key key,
      this.cell,
      this.state,
      Animation<double> animation,
      Animatable<double> transformAnimation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    double animationValue = animation.value;
    Size boardSize = state.boardSize();
    double width = (boardSize.width - (state.column + 1) * state.cellPadding) /
        state.column;
    if (cell.number == 0) {
      return Container();
    } else {
      return CellBox(
        left: (cell.column * width + state.cellPadding * (cell.column + 1)) +
            width / 2 * (1 - animationValue),
        top: cell.row * width +
            state.cellPadding * (cell.row + 1) +
            width / 2 * (1 - animationValue),
        size: width * animationValue,
        color: BoxColors.containsKey(cell.number)
            ? BoxColors[cell.number]
            : BoxColors[BoxColors.keys.last],
        text: Text(
          cell.number.toString(),
          style: TextStyle(
            fontSize:
                // 1024 四位数太多了，可能超出
                cell.number > 512 ? 30 * animationValue : 40.0 * animationValue,
            fontWeight: FontWeight.bold,
            color: cell.number < 32 ? Colors.grey[800] : Colors.white,
          ),
        ),
        rotate: animationValue,
      );
    }
  }
}

class CellWidget extends StatefulWidget {
  final BoardCell cell;
  final _GameWidgetState state;

  CellWidget({this.cell, this.state});

  _CellWidgetState createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  Tween<double> scaleTween = Tween(begin: 0.0, end: 1.0);
  Tween<double> transformTween = Tween(begin: 0.0, end: 40.0); // 添加边角半径变动范围
  Animation<double> scaleAnimation;
  Animation<double> transformAnimation;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(
        milliseconds: 400,
      ),
      vsync: this,
    );
    animation = new Tween(begin: 0.0, end: 1.0).animate(controller);
    scaleAnimation = scaleTween
        .animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    transformAnimation = transformTween.animate(
        CurvedAnimation(parent: controller, curve: Curves.linear)); // 定义边角半径动画
  }

  dispose() {
    controller.dispose();
    super.dispose();
    widget.cell.isNew = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cell.isNew && !widget.cell.isEmpty()) {
      controller.reset();
      controller.forward();
      widget.cell.isNew = false;
    } else {
      controller.animateTo(1.0);
    }
    return AnimatedCellWidget(
      cell: widget.cell,
      state: widget.state,
      animation: scaleAnimation,
    );
  }
}

class CellBox extends StatelessWidget {
  final double left;
  final double top;
  final double size;
  final Color color;
  final Text text;
  final double rotate;
  RotationTransition rotationTransition;

  CellBox({this.left, this.top, this.size, this.color, this.text, this.rotate});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: left,
        top: top,
        child: Transform(
          transform:
              Matrix4.rotationZ((rotate != null) ? 2 * math.pi * rotate : 0),
          alignment: Alignment.center,
          child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Center(
                child: text,
              )),
        ));
  }
}
