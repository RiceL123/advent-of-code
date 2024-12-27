import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/result
import gleam/set
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
    list.fold(secret_map, dict.new(), fn(sequence_dict, x) {
      list.window_by_2(x.1)
      |> list.map(fn(x) { #(x.1 % 10, x.1 % 10 - x.0 % 10) })
      |> list.window(4)
      |> list.fold(#(set.new(), sequence_dict), fn(collects, changes) {
        let seen_sequences = collects.0
        let sequence_dict = collects.1
        let sequence = list.map(changes, fn(x) { x.1 })
        case set.contains(seen_sequences, sequence) {
          True -> collects
          False -> {
            let price = result.unwrap(list.last(changes), #(0, 0)).0
            let updated_dict =
              dict.upsert(sequence_dict, sequence, fn(res) {
                case res {
                  option.Some(val) -> val + price
                  option.None -> price
                }
              })
            #(set.insert(seen_sequences, sequence), updated_dict)
          }
        }
      })
      |> fn(x) { x.1 }
    })
    |> dict.to_list()
    |> list.map(fn(x) { x.1 })
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
