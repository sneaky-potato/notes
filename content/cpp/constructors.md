There are several ways of constructing objects in C++, I shall summarize some of them.

## Const and Refs
Const data types and references cannot be assigned once declared. If the class uses a `const` or a reference they must be initialized using the initializer list.
```cpp
class CustomMap {
private:
    const int M;
public:
    CustomMap(int modulo) : M(modulo) {}
};

int main() {
    CustomMap map(5);
    return 0;
}
```

## Brace initialization
This is different from constructor initializer list. Use `std::initializer_list<T>` to assign arrays.

```cpp
class Graph {
    vector<array<int, 2>> edges;

public:
    // Constructor that accepts { ... } initializer
    Graph(initializer_list<array<int, 2>> edgeList) : edges(edgeList) {
        cout << "Initializer-list constructor called" << endl;
    }

    void showEdges() const {
        for (int x : edges) cout << x << "";
        cout << endl;
    }
};

int main() {
    Graph g = {{1, 2}, {2, 3}, {3, 1}};  // uses initializer_list ctor
    return 0;
}

```

All the other ways are summarized in the below snippet
```cpp
class Order {
private:
    int qty;
    int prc;
    char side;      // buy or sell
    char symbol[6]; // ticker symbol name

public:
    // Paramterized constructor
    Order(int q, int p, char s, const char* sym) 
        : qty(q), prc(p), side(s) {
        strncpy(symbol, sym, 5);
        symbol[5] = '\0'; // ensure null-terminated
        cout << "Parameterized constructor called" << endl;
    }

    // Copy constructor
    Order(const Order& order) 
        : qty(order.qty), prc(order.prc), side(order.side) {
        strcpy(symbol, order.symbol);
        cout << "Copy constructor called" << endl;
    }

    // Move constructor
    Order(Order&& order) noexcept 
        : qty(order.qty), prc(order.prc), side(order.side) {
        strcpy(symbol, order.symbol);

        // Reset source
        order.qty = 0;
        order.prc = 0;
        order.side = '\0';
        order.symbol[0] = '\0';

        cout << "Move constructor called" << endl;
    }

    void displayTick() {
        cout << symbol << "\n";
    }
};

int main() {
    Order appleOrder(100, 50, 'B', "AAPL");
    Order appleOrderCopy = appleOrder; // copy

    Order appleOrderMove = std::move(appleOrder); // move
    appleOrderMove.displayTick();
    appleOrder.displayTick(); // after move

    return 0;
}
```


