>A clever way to achieve polymorphism and inheritance in C using structs

The book talks about implementing strings in a virtual machine written in C. This was very easy in Java but C doesn't provide the privilege to use objects and classes.
The author achieves the conventional inheritance that is the "is" relation by following this scheme:

**`value.h`**
```c
typedef struct Obj Obj;
typedef struct ObjString ObjString;
```

**`object.h`**
```c
#include "value.h"

typedef enum {
    OBJ_STRING,
} ObjType;

struct Obj {
    ObjType type;
};

struct ObjString {
    Obj obj;
    int length;
    char* chars;
};
```

The author then mentions the advantage of having this clever setup
>Given an ObjString*, you can safely cast it to Obj* and then access the type field from it. Every ObjString “is” an Obj in the OOP sense of “is”. When we later add other object types, each struct will have an Obj as its first field. Any code that wants to work with all objects can treat them as base Obj* and ignore any other fields that may happen to follow.

This happens because Obj is the first field of ObjString, the first few bytes of ObjString line up exactly with the first few bytes of Obj.
You can take a pointer to a struct and safely convert it to a pointer to its first field and back.
This technique is a clever use of [type punning](https://en.wikipedia.org/wiki/Type_punning) and there are more example like this in both C and C++.
