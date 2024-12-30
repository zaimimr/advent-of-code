import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/string

pub fn depth(grid, item, acc) {
  let #(pos, number) = item
  case number {
    9 ->
      dict.upsert(acc, pos, fn(x) {
        case x {
          option.Some(i) -> i + 1
          option.None -> 1
        }
      })
    _ -> {
      let #(x, y) = pos
      [#(x + 1, y), #(x - 1, y), #(x, y + 1), #(x, y - 1)]
      |> list.map(fn(pos) { #(pos, grid |> dict.get(pos) |> result.unwrap(-1)) })
      |> list.filter(fn(value) { value.1 == number + 1 })
      |> list.fold(acc, fn(acc, value) { depth(grid, value, acc) })
    }
  }
}

pub fn format_input(input) {
  let grid =
    input
    |> string.split("\n")
    |> list.index_fold(dict.new(), fn(grid, line, y) {
      line
      |> string.to_graphemes()
      |> list.index_fold(dict.new(), fn(acc_grid, char, x) {
        let number = char |> int.parse() |> result.unwrap(-1)
        dict.insert(acc_grid, #(x, y), number)
      })
      |> dict.merge(grid)
    })

  let zeros = grid |> dict.filter(fn(_, value) { value == 0 })

  #(grid, zeros)
}

pub fn solve(grid, zeros, func) {
  zeros
  |> dict.to_list()
  |> list.map(fn(item) { depth(grid, item, dict.new()) })
  |> func
  |> list.reduce(int.add)
}

pub fn pt_1(input: String) {
  let #(grid, zeros) = format_input(input)

  solve(grid, zeros, fn(data) {
    data
    |> list.map(fn(x) { x |> dict.size() })
  })
}

pub fn pt_2(input: String) {
  let #(grid, zeros) = format_input(input)

  solve(grid, zeros, fn(data) {
    data
    |> list.map(fn(x) { x |> dict.values() })
    |> list.flatten()
  })
}
