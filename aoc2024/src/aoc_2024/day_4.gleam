import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import gleam/yielder

fn get_row_col(index, row_size) {
  let row = index / row_size
  let col = index % row_size
  #(row, col)
}

pub fn solver(
  input: String,
  directions: List(List(Result(#(#(Int, Int), String), Nil))),
  selector: String,
) {
  let letters =
    input
    |> string.to_graphemes()

  let row_size =
    letters
    |> list.fold_until(0, fn(acc, x) {
      case x == "\n" {
        True -> list.Stop(acc)
        False -> list.Continue(acc + 1)
      }
    })

  let grid =
    letters
    |> list.filter(fn(x) { x != "\n" })
    |> yielder.from_list()
    |> yielder.index()

  let dict =
    dict.from_list(
      grid
      |> yielder.to_list()
      |> list.map(fn(x) { #(x.1, x.0) }),
    )

  grid
  |> yielder.map(fn(cell) {
    case cell.0 == selector {
      True -> {
        let index = cell.1
        directions
        |> list.map(fn(direction) {
          let text =
            direction
            |> list.fold_until("", fn(acc, offset) {
              let #(row, col) = get_row_col(index, row_size)
              let new_offset = result.unwrap(offset, #(#(0, 0), ""))
              let new_row = row + new_offset.0.0
              let new_col = col + new_offset.0.1
              case
                new_row < 0
                || new_row >= row_size
                || new_col < 0
                || new_col >= row_size
              {
                True -> list.Stop("")
                False -> {
                  let new_index = new_row * row_size + new_col
                  let res =
                    dict
                    |> dict.get(new_index)
                    |> result.unwrap("")
                  case res == new_offset.1 {
                    True -> list.Continue(string.append(acc, res))
                    False -> list.Stop("")
                  }
                }
              }
            })
          case text != "" {
            True -> 1
            False -> 0
          }
        })
        |> list.reduce(int.add)
        |> result.unwrap(0)
      }
      False -> 0
    }
  })
}

pub fn pt_1(input: String) {
  let directions = [
    [Ok(#(#(1, 0), "M")), Ok(#(#(2, 0), "A")), Ok(#(#(3, 0), "S"))],
    //up
    [Ok(#(#(-1, 0), "M")), Ok(#(#(-2, 0), "A")), Ok(#(#(-3, 0), "S"))],
    //down
    [Ok(#(#(0, 1), "M")), Ok(#(#(0, 2), "A")), Ok(#(#(0, 3), "S"))],
    //right
    [Ok(#(#(0, -1), "M")), Ok(#(#(0, -2), "A")), Ok(#(#(0, -3), "S"))],
    //left
    [Ok(#(#(1, 1), "M")), Ok(#(#(2, 2), "A")), Ok(#(#(3, 3), "S"))],
    //up-right
    [Ok(#(#(-1, -1), "M")), Ok(#(#(-2, -2), "A")), Ok(#(#(-3, -3), "S"))],
    //down-left
    [Ok(#(#(1, -1), "M")), Ok(#(#(2, -2), "A")), Ok(#(#(3, -3), "S"))],
    //up-left
    [Ok(#(#(-1, 1), "M")), Ok(#(#(-2, 2), "A")), Ok(#(#(-3, 3), "S"))],
    //down-right
  ]

  solver(input, directions, "X")
  |> yielder.reduce(int.add)
}

pub fn pt_2(input: String) {
  let directions = [
    [Ok(#(#(1, 1), "M")), Ok(#(#(-1, -1), "S"))],
    [Ok(#(#(-1, 1), "M")), Ok(#(#(1, -1), "S"))],
    [Ok(#(#(1, -1), "M")), Ok(#(#(-1, 1), "S"))],
    [Ok(#(#(-1, -1), "M")), Ok(#(#(1, 1), "S"))],
  ]

  solver(input, directions, "A")
  |> yielder.filter(fn(x) { x == 2 })
  |> yielder.length()
}
