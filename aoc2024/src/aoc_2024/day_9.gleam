import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub type Fragment {
  Fragment(file_id: Int, file_size: Int, free_space: Int)
}

pub fn repeat_x(str: String, times: Int) -> List(String) {
  case times {
    0 -> []
    _ -> [str, ..repeat_x(str, times - 1)]
  }
}

pub fn parse_input(input: String) {
  let chunks =
    input
    |> string.append("0")
    |> string.to_graphemes
    |> list.filter_map(int.parse)
    |> list.sized_chunk(2)
    |> list.index_map(fn(x, i) {
      let a = x |> list.first |> result.unwrap(0)
      let b = case x |> list.length {
        2 -> x |> list.last |> result.unwrap(0)
        _ -> 0
      }
      Fragment(i, a, b)
    })

  let data =
    chunks
    |> list.fold([], fn(acc, fragment) {
      let acc =
        list.append(
          acc,
          repeat_x(fragment.file_id |> int.to_string, fragment.file_size),
        )
      list.append(acc, repeat_x(".", fragment.free_space))
    })
    |> list.index_map(fn(x, i) { #(i, x) })
  #(chunks, data)
}

pub fn solve(data: List(#(Int, String))) {
  let dot =
    data
    |> list.fold_until(#(-1, ""), fn(acc, x) {
      case x.1 {
        "." -> list.Stop(x)
        _ -> list.Continue(acc)
      }
    })
  let nr =
    data
    |> list.reverse
    |> list.fold_until(#(-1, ""), fn(acc, x) {
      case x.1 {
        "." -> list.Continue(acc)
        _ -> list.Stop(x)
      }
    })

  case dot.0 < nr.0 {
    True -> {
      data
      |> list.key_set(nr.0, dot.1)
      |> list.key_set(dot.0, nr.1)
      |> solve
    }
    False -> data
  }
}

pub fn pt_1(input: String) {
  let #(_chunks, data) = parse_input(input)
  data
  |> solve
  |> list.map(fn(x) { x.1 })
  |> list.filter(fn(x) { x != "." })
  |> list.filter_map(int.parse)
  |> list.index_map(fn(x, i) { i * x })
  |> list.reduce(int.add)
}

pub fn pt_2(input: String) {
  input
}
