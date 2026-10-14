# StreaML

An OCaml port of the [STREAM](https://www.cs.virginia.edu/stream/) benchmark.
Original C version: Copyright 1991-2013 John D. McCalpin. See LICENSE for full
terms.

**This is an unofficial variant, not official STREAM benchmark results.** Per
the original STREAM license, results from this implementation should be
described as "based on a variant of the STREAM benchmark" rather than "STREAM
benchmark results."

## STRATA ONLY

```
# go to the STRATA-5.5.0 repo
opam switch create STRATA-5.5.0 --empty
opam switch set my-switch

eval "$(opam env)"

# configure ocaml with libnuma to install into the switch
LIBS="-lnuma" LDFLAGS="-lnuma" ./configure --prefix="$(opam var prefix)"

# build ocaml
make -j

# install into the switch
opam install opam-custom-install
opam custom-install ocaml-variants -- make install
```

It's up to the gods on whether this will really work. If you have trouble
getting the custom OCaml runtime/compiler into your environment, let me know.

Run the benchmark like this:

```
for m in 0 1 2 3 4 5 6 7; do
    STREAM_FAR=$m dune exec ./streaml.exe | grep '^CSV'
done > far.csv
```

## Usage

### Building

```````
dune build
```````

### Running

```````
dune exec ./streaml.exe
```````

or, if you build a release/optimized profile:

```````
dune exec ./streaml.exe --profile release
```````

## Configuration

Array size and iteration count are set as constants at the top of `streaml.ml`:

````````
let stream_array_size = 60_000_000  (* elements per array *)
let ntimes            = 10          (* kernel repetitions *)
````````

Edit these and rebuild (`dune build`) to change the benchmark's memory footprint
or iteration count. As with the original STREAM, each array should be sized to
at least ~4x your machine's last-level cache to get a valid bandwidth
measurement rather than cache effects.

## Sample output

```
-------------------------------------------------------------
STREAML version 1.0
This system uses 8 bytes per array element.
-------------------------------------------------------------
Array size = 60000000 (elements)
Memory per array = 457.8 MiB (= 0.4 GiB).
...
Function    Best Rate MB/s  Avg time     Min time     Max time
Copy:           21608.4     0.045493     0.044427     0.050700
Scale:          19693.1     0.049828     0.048748     0.052387
Add:            25918.9     0.057274     0.055558     0.063964
Triad:          24075.8     0.061093     0.059811     0.063648
Solution Validates: avg error less than 1.300000e-13 on all three arrays
-------------------------------------------------------------
```
