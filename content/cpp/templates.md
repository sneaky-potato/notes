## Templates in functions

Consider this simple template function definition

```cpp
template<typename T>
T customMax(T a, T b) {
    return b < a ? a : b;
}
```

Type deduction happens at compile time like so

```cpp
int main() {
    std::cout << "templates\n";
    std::cout << customMax(1, 2) << '\n';

    // customMax<std::string>(std::string, std::string)
    std::cout << customMax(std::string("hello"), std::string("world")) << '\n';

    // customMax<const char*>(const char*, const char*)
    std::cout << customMax("hello", "world") << '\n'; // compares addresses and not strings

    // customMax<std::string>(std::string, std::string)
    std::cout << customMax<std::string>("hello", "world") << '\n';
    return 0;
}
```

A simple definition like the one above comes with some non-negotiable assumptions and constraints


These are:
- `T` must support `<` operator and must return bool when used
- copy and move constructors must be defined for `T`

```cpp
std::complex<double> c1, c2;
std::cout << customMax(c1, c2); // ERROR: no < supported to complex<double>

std::atomic<int> a1{8}, a2{15};
std::cout << customMax(a1, a2); // ERROR: copying is disabled for atomic
```

>[!NOTE]
> Since C++ 20 we can enforce formal constraints for generic code, see [[concepts]]

## Variadic templates

Type safe variadic templates for classes and functions
```cpp
template<typename T, typename... Types>
void print(T firstarg, Types... args) {
    std::cout << firstArg << " ";
    print(args...);
}

// base case function definition
void print() {}

std::string str = "world";
print("hello", 7.5, str);
```


## Find dimension at compile time

Say we have to write metafunction to find the dimension of array of any type at compile time.
Something like this
```cpp
static_assert(Rank<int>::value == 0);
static_assert(Rank<float[3]>::value == 1);
static_assert(Rank<char[][3]>::value == 2);
static_assert(Rank<Emp[2][3][4][5]>::value == 4);
```

Solution is given below
```cpp
template <typename T>
struct Rank {
    static constexpr size_t value = 0;
};

// int arr[] = {1, 2, 3, 4}
template <typename T>
struct Rank<T[]> {
    static constexpr size_t value = 1u + Rank<T>::value;
};

//int arr[4] = {1, 2, 3, 4}
template <typename T, size_t N>
struct Rank<T[N]> {
    static constexpr size_t value = 1u + Rank<T>::value;
}
```

## Constrain templates
We can allow only certain type of templates to be used using `<type_traits>` header.

```cpp
#include <iostream>
#include <type_traits>

template <typename T>
struct is_numeric {
    static constexpr bool value = std::is_integral<T>::value || std::is_floating_point<T>::value;
};

template <typename T, size_t N>
class Vector {
    static_assert(is_numeric<T>::value, "Vector only supports numeric types!");
    
    T data[N];
    size_t size_ = 0;

public:
    void add(T value) {
        if (size_ < N) {
            data[size_++] = value;
        } else {
            std::cout << "Vector full!\n";
        }
    }

    T get(size_t index) const {
        return data[index];
    }

    size_t size() const { return size_; }

    template <typename Func>
    void for_each(Func f) const {
        for (size_t i = 0; i < size_; ++i)
            f(data[i]);
    }
};

int main() {
    Vector<int, 5> arr;
    arr.add(10);
    arr.add(20);
    arr.add(30);

    std::cout << "Array elements: ";
    arr.for_each([](int x){ std::cout << x << " "; });
    std::cout << "\n";

    // Uncommenting this line will fail at compile-time
    // Vector<std::string, 3> badArray; 
    return 0;
}
```

