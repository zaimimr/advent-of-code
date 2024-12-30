import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/order
import gleam/result
import gleam/string
import glearray

pub fn pt_1(input: String) {
  let #(rules, orders) =
    input |> string.split_once("\n\n") |> result.unwrap(#("", ""))

  let rules_dict =
    rules
    |> string.split("\n")
    |> list.fold(dict.new(), fn(acc, rule) {
      let #(key, value) =
        rule
        |> string.split_once("|")
        |> result.unwrap(#("", ""))

      acc
      |> dict.upsert(key, fn(x) {
        case x {
          option.Some(i) -> i |> list.append([value])
          option.None -> [value]
        }
      })
    })

  orders
  |> string.split("\n")
  |> list.map(fn(order) {
    order
    |> string.split(",")
  })
  |> list.map(fn(order) {
    order
    |> list.map_fold(dict.new(), fn(prev, page) {
      let rules =
        rules_dict
        |> dict.get(page)

      case result.is_ok(rules) {
        True -> {
          let result =
            rules
            |> result.unwrap([])
            |> list.fold_until(False, fn(_acc, rule) {
              case prev |> dict.has_key(rule) {
                True -> list.Stop(True)
                False -> list.Continue(False)
              }
            })

          #(dict.insert(prev, page, result), page)
        }
        False -> #(dict.insert(prev, page, False), page)
      }
    })
  })
  |> list.filter(fn(x) {
    x.0
    |> dict.filter(fn(_, v) { v == True })
    |> dict.is_empty()
  })
  |> list.map(fn(x) {
    let len =
      x.1
      |> list.length()

    x.1
    |> glearray.from_list()
    |> glearray.get(len / 2)
  })
  |> list.fold(0, fn(acc, x) {
    let value = int.parse(x |> result.unwrap("0")) |> result.unwrap(0)
    acc + value
  })
}

pub fn pt_2(input: String) {
  let #(rules, orders) =
    input |> string.split_once("\n\n") |> result.unwrap(#("", ""))

  let rules_dict =
    rules
    |> string.split("\n")
    |> list.fold(dict.new(), fn(acc, rule) {
      let #(key, value) =
        rule
        |> string.split_once("|")
        |> result.unwrap(#("", ""))

      acc
      |> dict.upsert(key, fn(x) {
        case x {
          option.Some(i) -> i |> list.append([value])
          option.None -> [value]
        }
      })
    })

  let sort_rules =
    rules
    |> string.split("\n")
    |> list.fold(dict.new(), fn(acc, rule) {
      let #(key, value) =
        rule
        |> string.split_once("|")
        |> result.unwrap(#("", ""))

      acc
      |> dict.insert(#(key, value), order.Lt)
      |> dict.insert(#(value, key), order.Gt)
    })

  orders
  |> string.split("\n")
  |> list.map(fn(order) {
    order
    |> string.split(",")
    |> list.map_fold(dict.new(), fn(prev, page) {
      let rules =
        rules_dict
        |> dict.get(page)

      case result.is_ok(rules) {
        True -> {
          let result =
            rules
            |> result.unwrap([])
            |> list.map(fn(rule) { prev |> dict.has_key(rule) })

          #(dict.insert(prev, page, result), page)
        }
        False -> #(dict.insert(prev, page, [False]), page)
      }
    })
  })
  |> list.filter(fn(x) {
    x.0
    |> dict.filter(fn(_, v) {
      v |> list.filter(fn(x) { x == True }) |> list.length > 0
    })
    |> dict.is_empty()
    |> bool.negate()
  })
  |> list.map(fn(x) {
    x.1
    |> list.sort(fn(a, b) {
      sort_rules |> dict.get(#(a, b)) |> result.unwrap(order.Eq)
    })
  })
  |> list.map(fn(x) {
    let len =
      x
      |> list.length()

    x
    |> glearray.from_list()
    |> glearray.get(len / 2)
  })
  |> list.fold(0, fn(acc, x) {
    let value = int.parse(x |> result.unwrap("0")) |> result.unwrap(0)
    acc + value
  })
}
