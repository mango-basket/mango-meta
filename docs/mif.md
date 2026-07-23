# The MIF or Mango Interface Format file

## v1

```
module name

depends dep1
depends dep2

fn fname1(param1: type1, param2: type2) -> rettype
fn fname2(param1: type1) -> void
```

this is an example of what a MIF file is going to look like for future reference. since i dont have globals or constants im comfortable sticking to this for now. open to change in the future. dependencies are also mentioned here, which translate into the metadata section of the MOBJ files, which in the builder can then use to compile supporting libraries and link them properly without overlap or overwriting.
