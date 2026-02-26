#include <iostream>
#include <vector>
#include <cstdlib>

int main(const int argc, char* argv[]) {
    std::vector<int> a;
    for (int i = 1; i < argc; i++) {
        a.push_back(std::atoi(argv[i]));
    }

    const unsigned long n = std::size(a);
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (a[j] > a[j + 1]) {
                std::swap(a[j], a[j + 1]);
            }
        }
    }

    for (const int x : a) {
        std::cout << x << " ";
    }

    return 0;
}