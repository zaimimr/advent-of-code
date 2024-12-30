import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/string

fn expand(stone: Int) -> List(Int) {
  case stone == 0 {
    True -> [1]
    False -> {
      let digits = int.to_string(stone) |> string.to_graphemes
      let len = list.length(digits)
      case len % 2 == 0 {
        True -> {
          let half = len / 2
          [
            list.take(digits, half)
              |> string.concat
              |> int.parse
              |> result.unwrap(0),
            list.drop(digits, half)
              |> string.concat
              |> int.parse
              |> result.unwrap(0),
          ]
        }
        False -> {
          [stone * 2024]
        }
      }
    }
  }
}

fn expand_map(stones: dict.Dict(Int, Int), depth: Int) {
  list.range(1, depth)
  |> list.fold(stones, fn(acc, _) {
    acc
    |> dict.fold(dict.new(), fn(acc2, stone, count) {
      expand(stone)
      |> list.fold(acc2, fn(acc3, new_stone) {
        acc3
        |> dict.upsert(new_stone, fn(x) {
          case x {
            option.Some(i) -> i + count
            option.None -> count
          }
        })
      })
    })
  })
}

pub fn pt_1(input: String) {
  input
  |> string.split(" ")
  |> list.filter_map(int.parse)
  |> list.map(fn(x) { #(x, 1) })
  |> dict.from_list
  |> expand_map(25)
  |> dict.values
  |> list.reduce(int.add)
}

pub fn pt_2(input: String) {
  input
  |> string.split(" ")
  |> list.filter_map(int.parse)
  |> list.map(fn(x) { #(x, 1) })
  |> dict.from_list
  |> expand_map(75)
  |> dict.values
  |> list.reduce(int.add)
}
