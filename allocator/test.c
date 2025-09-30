#include <stdio.h>
#include <string.h>

extern void *malloc(size_t);
extern void free(void*);

int main() {
    char *p = malloc(100);
    if (!p) { puts("malloc failed"); return 1; }
    strcpy(p, "hello from memory!");
    printf("%s\n", p);
    free(p);

    char *a = malloc(32);
    char *b = malloc(48);
    strcpy(a, "1");
    strcpy(b, "2");
    printf("%s %s\n", a, b);
    free(a);
    free(b);
    return 0;
}
