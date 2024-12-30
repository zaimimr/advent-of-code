import gleam/list
import gleam/result
import gleam/string
import utils

type Command {
  Forward(Int)
  Up(Int)
  Down(Int)
}

type Position {
  Position(depth: Int, horizontal: Int, aim: Int)
}

fn parse(instruction: String) -> Command {
  let #(direction, distance) =
    string.split_once(instruction, " ")
    |> result.unwrap(#("", ""))
  let distance = utils.safe_int(distance)

  case direction {
    "forward" -> Forward(distance)
    "up" -> Up(distance)
    "down" -> Down(distance)
    _ -> panic
  }
}

fn move_submarine(position: Position, command: Command) -> Position {
  let Position(depth, horizontal, aim) = position
  case command {
    Forward(x) -> Position(depth, horizontal + x, aim)
    Up(x) -> Position(depth - x, horizontal, aim)
    Down(x) -> Position(depth + x, horizontal, aim)
  }
}

fn move_submarine_with_aim(position: Position, command: Command) -> Position {
  let Position(depth, horizontal, aim) = position
  case command {
    Forward(x) -> Position(depth + aim * x, horizontal + x, aim)
    Up(x) -> Position(depth, horizontal, aim - x)
    Down(x) -> Position(depth, horizontal, aim + x)
  }
}

fn calculate_position(
  input: String,
  initial: Position,
  mover: fn(Position, Command) -> Position,
) -> Position {
  input
  |> string.split("\n")
  |> list.map(parse)
  |> list.fold(initial, mover)
}

pub fn pt_1(input: String) {
  let initial = Position(0, 0, 0)
  let final = calculate_position(input, initial, move_submarine)
  final.depth * final.horizontal
}

pub fn pt_2(input: String) {
  let initial = Position(0, 0, 0)
  let final = calculate_position(input, initial, move_submarine_with_aim)
  final.depth * final.horizontal
}
