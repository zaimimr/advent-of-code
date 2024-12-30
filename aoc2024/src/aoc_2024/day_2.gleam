import gleam/int
import gleam/list
import gleam/string

const asc = 1

const desc = -1

pub fn pt_1(input: String) {
  input
  |> string.split("\n")
  |> list.map(fn(item) {
    item
    |> string.split(" ")
    |> list.filter_map(int.parse)
  })
  |> list.map(fn(row) {
    row
    |> list.window_by_2()
    |> list.fold_until(0, fn(acc, row) {
      let #(item1, item2) = row
      case int.absolute_value(item1 - item2) <= 3 {
        True ->
          case item1 > item2 && acc == 0 {
            True -> list.Continue(desc)
            False ->
              case item1 < item2 && acc == 0 {
                True -> list.Continue(asc)
                False ->
                  case acc < 0 && item1 > item2 {
                    True -> list.Continue(acc)
                    False ->
                      case acc > 0 && item1 < item2 {
                        True -> list.Continue(acc)
                        False -> list.Stop(0)
                      }
                  }
              }
          }
        False -> list.Stop(0)
      }
    })
  })
  |> list.fold(0, fn(acc, row) { acc + int.absolute_value(row) })
}

pub fn pt_2(input: String) {
  input
  |> string.split("\n")
  |> list.map(fn(item) {
    item
    |> string.split(" ")
    |> list.filter_map(int.parse)
  })
  |> list.map(fn(li) {
    li
    |> list.combinations(list.length(li) - 1)
    |> list.map(fn(comb) {
      comb
      |> list.window_by_2()
      |> list.fold_until(0, fn(acc, row) {
        let #(item1, item2) = row
        case int.absolute_value(item1 - item2) <= 3 {
          True ->
            case item1 > item2 && acc == 0 {
              True -> list.Continue(desc)
              False ->
                case item1 < item2 && acc == 0 {
                  True -> list.Continue(asc)
                  False ->
                    case acc < 0 && item1 > item2 {
                      True -> list.Continue(acc)
                      False ->
                        case acc > 0 && item1 < item2 {
                          True -> list.Continue(acc)
                          False -> list.Stop(0)
                        }
                    }
                }
            }
          False -> list.Stop(0)
        }
      })
    })
  })
  |> list.map(fn(row) { list.any(row, fn(x) { x != 0 }) })
  |> list.filter(fn(x) { x })
  |> list.length()
}
