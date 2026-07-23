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

this is what the MOBJ binary looks like

```
[ "MOBJ" (4) ][version u16]
[instr_bytes_len u16][data_bytes_len u16]
[symtable_len u16][reloctable_len u16]
[meta_len u16]
[instr_bytes...][data_bytes...]
[symtable...][reloctable...][meta_bytes...]

symtable: repeated (name bytes, 0u8, u16 addr)
reloctable: repeated (u16 offset, u16 sym_index, u8 kind)
```

where `[meta_bytes...]` is

```
[mod_name_ofst u16][dependency_count u16]
[export_count u16][param_count u16]
[dependency_table][export_table]
[param_table][string_pool]

dependency_table:
    repeated (name_ofst u16)
    size = dependency_count * 16

export_table:
    repeated (
        name_ofst u16,
        return_type_ofst u16,
        first_param u16,
        param_count u16
    )
    size = export_count * 16 * 4

param_table:
    repeated (
        name_ofst u16,
        type_ofst u16
    )
    size = param_count * 16 * 2

string_pool:
    repeated (
        bytes,
        0u8
    )
```
