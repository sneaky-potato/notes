## Size

An empty class (with no data members) has a size of 1, because references to two such objects will not be different if size were 0.
However an empty class with a virtual method has a size of 8 rather than being 1.

Consider the following snippet:
```cpp
class Nothing {
};

class NothingWithMethod {
public:
    void print() {}
};

class NothingWithVirtualMethod {
public:
    virtual void print() {

    }
};

int main() {
    Nothing nothing;
    NothingWithMethod nothingWithMethod;
    NothingWithVirtualMethod nothingWithVirtualMethod;
    std::cout << sizeof(nothing) << "\n";                  // 1
    std::cout << sizeof(nothingWithMethod) << "\n";        // 1
    std::cout << sizeof(nothingWithVirtualMethod) << "\n"; // 8
}
```

Now that we have verified some data is there in the empty class with a virtual method, it is time to find out that these values are.

## Dynamic Dispatch

A class with virtual method contains a **vptr** (virtual pointer) pointing to a **vtable** (virtual table). This mechanism enables dynamic dispatch.

```cpp
class Base {
public:
    virtual void print() {
        std::cout << "Base print\n";
    }
};

class Derived : public Base {
public:
    void print() override {
        std::cout << "Derived print\n";
    }
};

int main() {
    Base base;
    Derived derived;

    size_t ptr_size = sizeof(void*);

    void* base_vptr = nullptr;
    void* derived_vptr = nullptr;

    std::memcpy(&base_vptr, &base, ptr_size);
    std::memcpy(&derived_vptr, &derived, ptr_size);

    std::cout << "Base object vptr:    " << base_vptr << "\n";
    std::cout << "Derived object vptr: " << derived_vptr << "\n";

    // Call virtual method via base pointer
    Base* ptr = &derived;
    std::cout << "Calling print via Base* ptr to Derived:\n";
    ptr->print();  // Should call Derived::print()

    return 0;
}
```

This is the foundation of dynamic dispatch.

First define another virtual method so that we have more than one entry in the virtual table:
```cpp
class Base {
public:
    virtual ~Base() = default;
    virtual void parse() {
        std::cout << "Base parse\n";
    }
};

class Json : public Base {
public:
    void parse() override {
        std::cout << "Json parse\n";
    }
};

class Csv : public Base {
public:
    void parse() override {
        std::cout << "Csv parse\n";
    }
}
```

We will require a factory function that creates the right parser based on file extension
```cpp
std::unique_ptr<Base> createParser(const std::string& filename) {
    auto pos = filename.rfind('.');
    if (pos == std::string::npos) {
        return std::make_unique<Base>();  // No extension, default parser
    }

    std::string ext = filename.substr(pos + 1);
    if (ext == "json") {
        return std::make_unique<Json>();
    } else if (ext == "csv") {
        return std::make_unique<Csv>();
    } else {
        return std::make_unique<Base>();
    }
}
```

We can see dynamic dispatch in action like so
```cpp
std::string files[] = { "data.json", "records.csv", "unknown.txt" };
for (const auto& filename : files) {
    std::cout << "Parsing file: " << filename << "\n";

    // Create the right parser dynamically based on file extension
    std::unique_ptr<Base> parser = createParser(filename);

    // Call the virtual method
    parser->parse();

    std::cout << "\n";
}
```

## Vptr and Vtable

We can go a step further and call the `Csv::parse()` or `Json::parse()` method, not via references but rather raw function pointers which we will get from the virtual table explicitly.

```cpp
// Define function pointer type: a function taking Base* and returning void
using ParseFuncPtr = void(*)(Base*);

void indirect_call(Base* obj) {

    void* vptr = nullptr;
    std::memcpy(&vptr, obj, sizeof(void*));
    std::cout << "vptr address: " << vptr << "\n";

    // Cast vptr to a pointer to array of function pointers (vtable)
    void** vtable = reinterpret_cast<void**>(vptr);

    // Let's assume 'parse' is the first entry in the vtable
    ParseFuncPtr fn = reinterpret_cast<ParseFuncPtr>(vtable[0]);

    std::cout << "Calling via vtable manually: ";
    fn(obj);  // manual indirection via vtable
}
```

Call this in the main function
```cpp
Json jsonObj;
Csv csvObj;

indirect_call(&jsonObj);
indirect_call(&csvObj);
```
