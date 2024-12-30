import gleam/int
import gleam/io
import gleam/iterator
import gleam/list
import gleam/order
import gleam/result
import gleam/string
import gleam/yielder
import gleamy/priority_queue as pq
import glearray

pub type Moves {
  Forward
  RotateLeft
  RotateRight
}

pub type Direction {
  North
  East
  South
  West
}

pub type Pos {
  Pos(x: Int, y: Int)
}

pub type CellType {
  Wall(x: Int, y: Int)
  Floor(x: Int, y: Int)
  Start(x: Int, y: Int)
  End(x: Int, y: Int)
  ErrorCell(x: Int, y: Int)
}

pub type Pointer {
  Pointer(
    me: CellType,
    parent: CellType,
    direction: Direction,
    f: Int,
    g: Int,
    h: Int,
  )
}

// pub fn find_cell_start(map) {
//   case
//     map
//     |> list.flatten
//     |> list.find(fn(cell) {
//       case cell {
//         Start(_, _) -> True
//         _ -> False
//       }
//     })
//   {
//     Ok(cell) -> cell
//     Error(_) -> panic("End not found")
//   }
// }

// pub fn find_cell_end(map) {
//   case
//     map
//     |> list.flatten
//     |> list.find(fn(cell) {
//       case cell {
//         #(_, End(_, _)) -> True
//         _ -> False
//       }
//     })
//   {
//     Ok(cell) -> cell
//     Error(_) -> panic("End not found")
//   }
// }

pub fn find_distance(cell1: CellType, cell2: CellType) {
  let dx = cell1.x - cell2.x
  let dy = cell1.y - cell2.y

  { dx |> int.absolute_value() } + { dy |> int.absolute_value() }
}

pub fn get_index(map, x, y) {
  case
    map
    |> glearray.get(y)
  {
    Ok(row) ->
      case row |> glearray.get(x) {
        Ok(cell) -> cell
        Error(_) -> panic
      }
    Error(_) -> panic
  }
}

pub fn get_start(map) {
  map
  |> glearray.iterate
  |> iterator.fold_until(ErrorCell(-1, -1), fn(acc, row) {
    let found_cell =
      row
      |> glearray.iterate
      |> iterator.fold(acc, fn(cell_acc, cell) {
        case cell {
          Start(_, _) -> cell
          _ -> cell_acc
        }
      })
    case found_cell {
      Start(_, _) -> list.Stop(found_cell)
      _ -> list.Continue(acc)
    }
  })
}

pub fn get_end(map) {
  map
  |> glearray.iterate
  |> iterator.fold_until(ErrorCell(-1, -1), fn(acc, row) {
    let found_cell =
      row
      |> glearray.iterate
      |> iterator.fold(acc, fn(cell_acc, cell) {
        case cell {
          End(_, _) -> cell
          _ -> cell_acc
        }
      })
    case found_cell {
      End(_, _) -> list.Stop(found_cell)
      _ -> list.Continue(acc)
    }
  })
}

pub fn pt_1(input: String) {
  let map =
    input
    |> string.split("\n")
    |> list.map(string.to_graphemes)
    |> list.index_map(fn(row, y) {
      row
      |> list.index_map(fn(cell, x) {
        case cell {
          "#" -> Wall(x, y)
          "." -> Floor(x, y)
          "S" -> Start(x, y)
          "E" -> End(x, y)
          _ -> panic("Invalid cell")
        }
      })
      |> glearray.from_list
    })
    |> glearray.from_list

  let start = map |> get_start()
  let end = map |> get_end()

  let start_pointer =
    Pointer(start, start, East, 0, 0, find_distance(start, end))

  let open =
    pq.from_list([start_pointer], fn(a, b) {
      case a.f < b.f {
        True -> order.Lt
        False -> order.Gt
      }
    })
  let closed = list.new()
  // a_star(map, open, closed)
}

pub fn get_neighbors(map, point) {
  let #(Pos(x, y), _) = point
  let neighbors =
    list.new()
    |> list.append([
      map |> get_index(x - 1, y),
      map |> get_index(x + 1, y),
      map |> get_index(x, y - 1),
      map |> get_index(x, y + 1),
    ])
  let valid_neighbors =
    neighbors
    |> list.filter(fn(cell) {
      case cell {
        Floor(_, _) -> False
        _ -> True
      }
    })
}

pub fn a_star(map, open, closed, width, height) {
  todo
}

pub fn pt_2(input: String) {
  todo as "part 2 not implemented"
}
