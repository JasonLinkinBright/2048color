import 'dart:math' show Random;
import 'util.dart';

class Game {
  final int row;
  final int column;
  int score;
  int maxLimit;

  Game(this.row, this.column,this.maxLimit);

  List<List<BoardCell>> _boardCells;

  void init() {
    _boardCells = List<List<BoardCell>>();
    for (int r = 0; r < row; ++r) {
      _boardCells.add(List<BoardCell>());
      for (int c = 0; c < column; ++c) {
        _boardCells[r].add(BoardCell(
          row: r,
          column: c,
          number: 0,
          isNew: false,
        ));
      }
    }
    score = 0;
    resetMergeStatus();
    randomEmptyCell(2);
  }

  BoardCell get(int r, int c) {
    return _boardCells[r][c];
  }

  void moveLeft() {
//    原版的算法事件复杂度太高
    if (!canMoveLeft()) {
      return;
    }
//    for (int r = 0; r < row; ++r) {
//      for (int c = 0; c < column; ++c) {
//        mergeLeft(r, c);
//      }
//    }
    for (int r = 0; r < row; r++) {
      newMerge(_boardCells[r]);
    }
    randomEmptyCell(1);
    resetMergeStatus();
  }

  void moveRight() {
    if (!canMoveRight()) {
      return;
    }
//    for (int r = 0; r < row; ++r) {
//      for (int c = column - 2; c >= 0; --c) {
//        mergeRight(r, c);
//      }
//    }
    for (int r = 0; r < row; r++) {
      newMerge(_boardCells[r].reversed.toList());
    }
    randomEmptyCell(1);
    resetMergeStatus();
  }

  void moveUp() {
    if (!canMoveUp()) {
      return;
    }
//    for (int r = 0; r < row; ++r) {
//      for (int c = 0; c < column; ++c) {
//        mergeUp(r, c);
//      }
//    }

    for (int c = 0; c < column; c++) {
      List<BoardCell> columnData = new List();
      for (int r = 0; r < row; r++) {
        columnData.add(_boardCells[r][c]);
      }
      newMerge(columnData);
    }
    randomEmptyCell(1);
    resetMergeStatus();
  }

  void moveDown() {
    if (!canMoveDown()) {
      return;
    }
//    for (int r = row - 2; r >= 0; --r) {
//      for (int c = 0; c < column; ++c) {
//        mergeDown(r, c);
//      }
//    }
    for (int c = 0; c < column; c++) {
      List<BoardCell> columnData = new List();
      for (int r = row - 1; r >= 0; r--) {
        columnData.add(_boardCells[r][c]);
      }
      newMerge(columnData);
    }
    randomEmptyCell(1);
    resetMergeStatus();
  }

  bool canMoveLeft() {
    for (int r = 0; r < row; ++r) {
      for (int c = 1; c < column; ++c) {
        if (canMerge(_boardCells[r][c], _boardCells[r][c - 1])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveRight() {
    for (int r = 0; r < row; ++r) {
      for (int c = column - 2; c >= 0; --c) {
        if (canMerge(_boardCells[r][c], _boardCells[r][c + 1])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveUp() {
    for (int r = 1; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        if (canMerge(_boardCells[r][c], _boardCells[r - 1][c])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveDown() {
    for (int r = row - 2; r >= 0; --r) {
      for (int c = 0; c < column; ++c) {
        if (canMerge(_boardCells[r][c], _boardCells[r + 1][c])) {
          return true;
        }
      }
    }
    return false;
  }

  void mergeLeft(int r, int c) {
    while (c > 0) {
      merge(_boardCells[r][c], _boardCells[r][c - 1]);
      c--;
    }
  }

  void mergeRight(int r, int c) {
    while (c < column - 1) {
      merge(_boardCells[r][c], _boardCells[r][c + 1]);
      c++;
    }
  }

  void mergeUp(int r, int c) {
    while (r > 0) {
      merge(_boardCells[r][c], _boardCells[r - 1][c]);
      r--;
    }
  }

  void mergeDown(int r, int c) {
    while (r < row - 1) {
      merge(_boardCells[r][c], _boardCells[r + 1][c]);
      r++;
    }
  }

  bool canMerge(BoardCell a, BoardCell b) {
    return !b.isMerged &&
        ((b.isEmpty() && !a.isEmpty()) || (!a.isEmpty() && a == b));
  }

  void merge(BoardCell a, BoardCell b) {
    if (!canMerge(a, b)) {
      if (!a.isEmpty() && !b.isMerged) {
        b.isMerged = true;
      }
      return;
    }

    if (b.isEmpty()) {
      b.number = a.number;
      a.number = 0;
    } else if (a == b) {
      b.number = b.number * 2;
      a.number = 0;
      score += b.number;
      b.isMerged = true;
    } else {
      b.isMerged = true;
    }
  }

  bool isGameOver() {
    return !canMoveLeft() && !canMoveRight() && !canMoveUp() && !canMoveDown();
  }

  bool isReachLimit(){
    for(int r=0;r<row;r++){
      for(int c=0;c<column;c++){
        if(_boardCells[r][c].number >= maxLimit){
          return true;
        }
      }
    }
    return false;
  }

  void randomEmptyCell(int cnt) {
    List<BoardCell> emptyCells = List<BoardCell>();
    _boardCells.forEach((cells) {
      emptyCells.addAll(cells.where((cell) {
        return cell.isEmpty();
      }));
    });
    if (emptyCells.isEmpty) {
      return;
    }
    Random r = Random();
    for (int i = 0; i < cnt && emptyCells.isNotEmpty; i++) {
      int index = r.nextInt(emptyCells.length);
      emptyCells[index].number = randomCellNum();
      emptyCells[index].isNew = true;
      emptyCells.removeAt(index);
    }
  }

  int randomCellNum() {
    final Random r = Random();
    return r.nextInt(15) == 0 ? 4 : 2;
  }

  void resetMergeStatus() {
    _boardCells.forEach((cells) {
      cells.forEach((cell) {
        cell.isMerged = false;
      });
    });
  }

  void newMerge(List<BoardCell> originList) {
    int i, nextI, len, m;
    len = originList.length;
    for (i = 0; i < len; i++) {
      // 先找 nextI
      nextI = -1;
      for (m = i + 1; m < len; m++) {
        if (originList[m].number != 0) {
          nextI = m;
          break;
        }
      }

      if (nextI != -1) {
        // 存在下个不为0的位置
        if (originList[i].number == 0) {
          originList[i].number = originList[nextI].number;
          originList[nextI].number = 0;
          i -= 1;
        } else if (originList[i].number == originList[nextI].number) {
          originList[i].number = 2 * originList[i].number;
          // 分数加上去
          score += originList[i].number;
          originList[nextI].number = 0;
        }
      }
    }
  }

  void newMergeRight(List<BoardCell> originList) {
    int i, nextI, len, m;
    len = originList.length;
    for (i = 0; i < len; i++) {
      // 先找 nextI
      nextI = -1;
      for (m = i + 1; m < len; m++) {
        if (originList[m].number != 0) {
          nextI = m;
          break;
        }
      }

      if (nextI != -1) {
        // 存在下个不为0的位置
        if (originList[i].number == 0) {
          originList[i].number = originList[nextI].number;
          originList[nextI].number = 0;
          i -= 1;
        } else if (originList[i].number == originList[nextI].number) {
          originList[i].number = 2 * originList[i].number;
          originList[nextI].number = 0;
        }
      }
    }
  }
}

class BoardCell {
  int row, column;
  int number = 0;
  bool isMerged = false;
  bool isNew = false;

  BoardCell({this.row, this.column, this.number, this.isNew});

  bool isEmpty() {
    return number == 0;
  }

  @override
  int get hashCode {
    return number.hashCode;
  }

  @override
  bool operator ==(other) {
    return other is BoardCell && number == other.number;
  }
}
