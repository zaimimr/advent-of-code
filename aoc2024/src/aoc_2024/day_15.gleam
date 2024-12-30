import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

pub type Pos {
  Pos(x: Int, y: Int)
}

pub type Direction {
  Up
  Down
  Left
  Right
}

pub type Cell {
  Robot
  Floor
  Wall
  Box
  BoxLeft
  BoxRight
  Cell
}

pub fn draw(acc, width) {
  acc
  |> list.index_map(fn(_cell, idx) {
    case idx % width {
      0 -> io.println("")
      _ -> io.print("")
    }
    let x = idx % width
    let y = idx / width
    let pos = Pos(x, y)
    let cell = acc |> list.key_find(pos) |> result.unwrap(Floor)
    case cell {
      Robot -> io.print("@")
      Floor -> io.print(".")
      Wall -> io.print("#")
      Box -> io.print("0")
      BoxLeft -> io.print("[")
      BoxRight -> io.print("]")
      _ -> io.print_error("z")
    }
  })
  io.println("")
}

pub fn push(map, new_pos, new_cell, direction, cell: #(Pos, Cell)) {
  let temp_map = move(map, #(new_pos, new_cell), direction)
  let new_cell = case
    temp_map
    |> list.key_find(new_pos)
  {
    Ok(item) -> item
    Error(_) -> panic
  }
  case new_cell {
    Floor ->
      temp_map
      |> list.key_set(new_pos, cell.1)
      |> list.key_set(cell.0, new_cell)
    _ -> temp_map
  }
}

pub fn big_push(map, new_pos, new_cell, direction, cell: #(Pos, Cell)) {
  let Pos(x, y) = cell.0
  let new_pos = case direction {
    Up -> Pos(x, y - 1)
    Down -> Pos(x, y + 1)
    Left -> Pos(x - 1, y)
    Right -> Pos(x + 1, y)
  }

  let new_cell = case
    map
    |> list.key_find(new_pos)
  {
    Ok(item) -> item
    Error(_) -> panic
  }
  case direction {
    Up -> {
      case cell.1, new_cell {
        BoxLeft, BoxRight -> {
          map
        }
        BoxRight, BoxLeft -> {
          map
        }
        _, _ -> push(map, new_pos, new_cell, direction, cell)
      }
    }
    Down -> {
      case cell.1, new_cell {
        BoxLeft, BoxRight -> {
          map
        }
        BoxRight, BoxLeft -> {
          map
        }
        _, _ -> push(map, new_pos, new_cell, direction, cell)
      }
    }
    _ -> push(map, new_pos, new_cell, direction, cell)
  }
}

pub fn move(map: List(#(Pos, Cell)), cell: #(Pos, Cell), direction: Direction) {
  let Pos(x, y) = cell.0
  let new_pos = case direction {
    Up -> Pos(x, y - 1)
    Down -> Pos(x, y + 1)
    Left -> Pos(x - 1, y)
    Right -> Pos(x + 1, y)
  }

  let new_cell = case
    map
    |> list.key_find(new_pos)
  {
    Ok(item) -> item
    Error(_) -> panic
  }
  case new_cell {
    Box -> {
      push(map, new_pos, new_cell, direction, cell)
    }
    BoxLeft -> {
      big_push(map, new_pos, new_cell, direction, cell)
    }
    BoxRight -> {
      big_push(map, new_pos, new_cell, direction, cell)
    }
    Floor ->
      map
      |> list.key_set(new_pos, cell.1)
      |> list.key_set(cell.0, new_cell)
    _ -> map
  }
}

pub fn pt_1(input: String) {
  let input =
    input
    |> string.split_once("\n\n")
    |> result.unwrap(#("", ""))

  let map =
    input.0
    |> string.split("\n")
    |> list.map(string.to_graphemes)
    |> list.index_map(fn(row, y) {
      row
      |> list.index_map(fn(cell, x) {
        let pos = Pos(x, y)
        case cell {
          "." -> #(pos, Floor)
          "#" -> #(pos, Wall)
          "@" -> #(pos, Robot)
          "O" -> #(pos, Box)
          _ -> panic
        }
      })
    })

  let _width =
    map
    |> list.first()
    |> result.unwrap([])
    |> list.length()

  let map = map |> list.flatten
  input.1
  |> string.to_graphemes
  |> list.filter(fn(x) { x != "\n" })
  |> list.map(fn(c) {
    case c {
      "^" -> Up
      "v" -> Down
      "<" -> Left
      ">" -> Right
      _ -> panic
    }
  })
  |> list.fold(map, fn(acc, direction) {
    let robot =
      acc
      |> list.find(fn(cell) {
        case cell {
          #(_, Robot) -> True
          _ -> False
        }
      })
    let acc = case robot {
      Ok(cell) -> {
        move(acc, cell, direction)
      }
      Error(_) -> panic
    }
    // draw(acc, width)
    acc
  })
  |> list.filter(fn(cell) {
    case cell {
      #(_, Box) -> True
      _ -> False
    }
  })
  |> list.map(fn(cell) { { cell.0 }.y * 100 + { cell.0 }.x })
  |> list.reduce(int.add)
}

pub fn pt_2(input: String) {
  let input =
    input
    |> string.split_once("\n\n")
    |> result.unwrap(#("", ""))

  let map =
    input.0
    |> string.split("\n")
    |> list.map(string.to_graphemes)
    |> list.map(fn(row) {
      row
      |> list.map(fn(cell) {
        case cell {
          "." -> [".", "."]
          "#" -> ["#", "#"]
          "@" -> ["@", "."]
          "O" -> ["[", "]"]
          _ -> panic
        }
      })
      |> list.flatten
    })
    |> list.index_map(fn(row, y) {
      row
      |> list.index_map(fn(cell, x) {
        let pos = Pos(x, y)
        case cell {
          "." -> #(pos, Floor)
          "#" -> #(pos, Wall)
          "@" -> #(pos, Robot)
          "[" -> #(pos, BoxLeft)
          "]" -> #(pos, BoxRight)
          _ -> panic
        }
      })
    })
  let width =
    map
    |> list.first()
    |> result.unwrap([])
    |> list.length()

  let map = map |> list.flatten
  draw(map, width)

  input.1
  |> string.to_graphemes
  |> list.filter(fn(x) { x != "\n" })
  |> list.map(fn(c) {
    case c {
      "^" -> Up
      "v" -> Down
      "<" -> Left
      ">" -> Right
      _ -> panic
    }
  })
  |> list.fold(map, fn(acc, direction) {
    let robot =
      acc
      |> list.find(fn(cell) {
        case cell {
          #(_, Robot) -> True
          _ -> False
        }
      })
    direction |> io.debug
    let acc = case robot {
      Ok(cell) -> {
        move(acc, cell, direction)
      }
      Error(_) -> panic
    }
    draw(acc, width)
    acc
  })
  |> list.filter(fn(cell) {
    case cell {
      #(_, Box) -> True
      _ -> False
    }
  })
  |> list.map(fn(cell) { { cell.0 }.y * 100 + { cell.0 }.x })
  |> list.reduce(int.add)
}
