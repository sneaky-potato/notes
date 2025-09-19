# Structure Packing

Members are laid out in the memory in the exact order, they are declared (unless pragma packed is used)
- char data types can be put anywhere in the memory
- short data type must start at memory location divisible by 2
- int data type must start at memory location divisible by 4
- long long data type must start at memory location divisible by 8

Consider this peice of code

```cpp
struct emp {
    char c; // 1
    int x;  // 4
    char d; // 1
};

struct emp_with_padding {
    char c; // 1
    char pad[3];
    int x;  // 4
    char d; // 1
    char pad[3];
};

struct emp_reordered {
    int x;
    char c;
    char d;
};

#pragma pack(1)
struct emp_pragma_packed {
    int x;
    char c;
    char d;
};

struct emp_packed {
    int x;
    char c;
    char d;
}__attribute__((__packed__));


int main() {
    std::cout << sizeof(emp) << std::endl; // 12
    std::cout << sizeof(emp_with_padding) << std::endl; // 12
    std::cout << sizeof(emp_reordered) << std::endl; // 8
    std::cout << sizeof(emp_pragma_packed) << std::endl; // 6
    std::cout << sizeof(emp_packed) << std::endl; // 6
    return 0;
}
```

GCC does not do structure reordering on itself because the structure might be sent and recieved over network.

```cpp
#include <iostream>

struct Order {
    int qty;
    int prc;
    char side; // buy or sell
    char symbol[6]; // ticker symbol name
};
static_assert(sizeof(Order) == 16);

int main() {
    Order order{ 12, 100, 'B', "GOOGL" };
    auto orderStr = reinterpret_cast<char*>(&order);

    // send this orderStr as an array of bytes 
    // on the wire to other trading server
    
    // other side will unpack it like this
    auto recvd_order = reinterpret_cast<Order*>(orderStr);

    std::cout << "qty = " << recvd_order->qty << std::endl;
    std::cout << "prc = " << recvd_order->prc << std::endl;
    std::cout << "side = " << recvd_order->side << std::endl;
    std::cout << "symbol = " << recvd_order->symbol << std::endl;
}
```


## References
- [The Lost Art of Structure Packing](http://www.catb.org/esr/structure-packing/)
- [Why can't C compilers rearrange struct members to eliminate alignment padding](https://stackoverflow.com/questions/9486364/why-cant-c-compilers-rearrange-struct-members-to-eliminate-alignment-padding)
