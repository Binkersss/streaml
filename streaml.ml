let stream_array_size = 60_000_000
let offset = 0
let ntimes            = 10

let hline = "-------------------------------------------------------------\n"

let a = Array.make (stream_array_size + offset) 0.0
let b = Array.make (stream_array_size + offset) 0.0
let c = Array.make (stream_array_size + offset) 0.0

(*
let vgtime  = Array.make 4 0.0
let maxtime = Array.make 4 0.0
let mintime = Array.make 4 Float.max_float

let labels = [|
  "Copy:      ";
  "Scale:     ";
  "Add:       ";
  "Triad:     ";
|]

let bytes = [|
  2.0 *. 8.0 *. float_of_int stream_array_size;
  2.0 *. 8.0 *. float_of_int stream_array_size;
  3.0 *. 8.0 *. float_of_int stream_array_size;
  3.0 *. 8.0 *. float_of_int stream_array_size
|]
*)
let m = 20

let mysecond () = Unix.gettimeofday()
let checktick () =
    let timesfound = Array.make m 0.0 in

    for i = 0 to m -1 do
        let t1 = mysecond () in
        let t2 = ref t1 in
        while !t2 -. t1 < 1.0e-6 do
            t2 := mysecond ()
        done;
        timesfound.(i) <- !t2
    done;

    let delta = ref 0 in
    let minDelta = ref 1_000_000 in
    for i = 1 to m - 1 do
        delta := int_of_float (1.0e6 *. (timesfound.(i) -. timesfound.(i - 1)));
        minDelta := min !minDelta (max !delta 0)
    done;
    !minDelta

let main () =
  Printf.printf "%s" hline;
  Printf.printf "STREAML version 1.0\n";

  (*
  let bytes_per_word = 8 in (* OCaml floats are guaranteed to be 8 bytes *)
  let t = 0.0 in
  let times = Array.make_matrix  4 ntimes 0.0 in
  *)
  let bytes_per_word = 8 in

  Printf.printf "This system uses %d bytes per array element.\n" bytes_per_word;
  Printf.printf "%s" hline;
  Printf.printf "Array size = %d (elements)\n" stream_array_size;
  let memory_per_array_mb = float_of_int bytes_per_word *. (float_of_int stream_array_size /. (1024.0 *. 1024.0)) in
  let memory_per_array_gb = float_of_int bytes_per_word *. (float_of_int stream_array_size /. (1024.0 *. 1024.0 *. 1024.0)) in
  Printf.printf "Memory per array = %.1f MiB (= %.1f GiB).\n" memory_per_array_mb memory_per_array_gb;
  Printf.printf "Each kernel will be executed %d times.\n" ntimes;
  Printf.printf " The *best* time for each kernel (excluding the first iteration)\n"; 
  Printf.printf " will be used to compute the reported bandwidth.\n";

  (* Get initial value for system clock. *)
  for j = 0 to stream_array_size - 1 do
      a.(j) <- 1.0;
      b.(j) <- 2.0;
      c.(j) <- 0.0
  done;

  Printf.printf "%s" hline