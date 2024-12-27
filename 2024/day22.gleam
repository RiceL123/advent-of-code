import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let init_secrets = get_initial_secrets("day22.txt")
  let secret_map =
    init_secrets
    |> list.map(fn(x) { secret_map(x, 2000) })

  let part1 =
    secret_map
    |> list.fold(0, fn(acc, x) { acc + x.0 })
  io.println("part1: " <> int.to_string(part1))

  let part2 =
    cartesian_product_4(-9, 9)
    |> list.map(fn(opt_change) {
      secret_map
      |> list.map(fn(x) {
        list.window_by_2(x.1)
        |> list.map(fn(x) { #(x.1 % 10, x.1 % 10 - x.0 % 10) })
        |> list.window(4)
        |> list.find(fn(changes) {
          list.map(changes, fn(x) { x.1 }) == opt_change
        })
        |> fn(res_found) {
          case res_found {
            Error(_) -> 0
            Ok(changes) -> result.unwrap(list.last(changes), #(0, 0)).0
          }
        }
      })
      |> list.fold(0, fn(acc, x) { acc + x })
    })
    |> list.max(int.compare)
    |> result.unwrap(0)

  io.println("part2: " <> int.to_string(part2))
}

fn get_initial_secrets(file_path: String) -> List(Int) {
  case simplifile.read(file_path) {
    Ok(contents) ->
      contents
      |> string.split("\n")
      |> list.map(fn(line) {
        int.parse(line)
        |> result.unwrap(0)
      })
    Error(_) -> []
  }
}

fn secret_map(secret: Int, n: Int) -> #(Int, List(Int)) {
  list.map_fold(list.range(1, n), secret, fn(acc, _) {
    let sec =
      acc
      |> int.bitwise_exclusive_or(acc * 64)
      |> int.modulo(16_777_216)
      |> result.unwrap(0)
      |> fn(step1) {
        step1
        |> int.divide(32)
        |> result.unwrap(0)
        |> int.bitwise_exclusive_or(step1)
        |> int.modulo(16_777_216)
        |> result.unwrap(0)
      }
      |> fn(step2) {
        step2
        |> int.bitwise_exclusive_or(step2 * 2048)
        |> int.modulo(16_777_216)
        |> result.unwrap(0)
      }
    #(sec, sec)
  })
}

fn cartesian_product_4(min: Int, max: Int) -> List(List(Int)) {
  let a = list.range(min, max)
  let b = list.range(min, max)
  let c = list.range(min, max)
  let d = list.range(min, max)

  a
  |> list.fold([], fn(acc, w) {
    b
    |> list.fold(acc, fn(acc, x) {
      c
      |> list.fold(acc, fn(acc, y) {
        d
        |> list.fold(acc, fn(acc, z) { acc |> list.append([[w, x, y, z]]) })
      })
    })
  })
}
