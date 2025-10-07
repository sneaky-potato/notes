Please check the the customMax example given in [[templates]] to understand this.

C++20 allows to constraint the template argument so that only valid templates can be used. The following example only allows templates which are copyable and have less than operator defined.

```cpp
template<typename T>
concept SupportsLessThan = requires (T x) { x < x; };

template<typename T>
requires std::copyable<T> && SupportsLessThan<T>
T customMax(T a, T b) {
    return b < a ? a : b;
}
```

## Auto as function param

The following snippet will give compile time error as it does not know which function to use

```cpp
void add(auto& coll, const auto& val) {
    coll.push_back(val);
}

void add(auto& coll, const auto& val) {
    coll.insert(val);
}

std::vector<int> coll1;
std::set<int> coll2;

add(coll1, 42); // ERROR: ambiguous
add(coll2, 42); // ERROR: ambiguous
```

We can solve this by adding a concept to only allow a particular function definition to be used.

```cpp
template<typename Coll>
concept HasPushBack = requires (Coll c, Coll::value_type v) {
    c.push_back(v);
};

void add(HasPushBack auto& coll, const auto& val) {
    coll.push_back(val);
}

void add(auto& coll, const auto& val) {
    coll.insert(val);
}

std::vector<int> coll1;
std::set<int> coll2;

add(coll1, 42); // OK: uses push_back
add(coll2, 42); // OK: uses insert
```

This can be made even shorter by using the compile time if and requires inside the function definition itself
```cpp
void add(auto& coll, const auto& val) {
    if constexpr (requires { coll.push_back(v); }) {
        coll.push_back(val);
    } else {
        coll.insert(val);
    }
}
```
