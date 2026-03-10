/**
 * Test file for GynColors theme - C syntax.
 * Preprocessor, format specifiers, types, pointers.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define MAX_SIZE 1024
#define SQUARE(x) ((x) * (x))
#define LOG(fmt, ...) fprintf(stderr, fmt "\n", ##__VA_ARGS__)

#ifdef DEBUG
#define DEBUG_LOG(msg) printf("[DEBUG] %s\n", msg)
#else
#define DEBUG_LOG(msg)
#endif

#ifndef VERSION
#define VERSION "1.0.0"
#endif

/* Enum */
typedef enum {
    STATUS_OK = 0,
    STATUS_ERROR = -1,
    STATUS_TIMEOUT = -2
} Status;

/* Struct */
typedef struct {
    char name[64];
    int age;
    float score;
    bool active;
} Student;

/* Union */
typedef union {
    int i;
    float f;
    char c;
    unsigned char bytes[4];
} Value;

/* Function pointer typedef */
typedef int (*Comparator)(const void *, const void *);

/* Function prototypes */
static Student *create_student(const char *name, int age, float score);
static void print_student(const Student *s);
static int compare_by_age(const void *a, const void *b);

/* Static global */
static int instance_count = 0;

/* Pointer arithmetic and arrays */
void array_operations(void) {
    int arr[] = {10, 20, 30, 40, 50};
    int *ptr = arr;
    size_t len = sizeof(arr) / sizeof(arr[0]);

    for (size_t i = 0; i < len; i++) {
        printf("arr[%zu] = %d, *(ptr + %zu) = %d\n", i, arr[i], i, *(ptr + i));
    }

    /* Pointer to pointer */
    int **pptr = &ptr;
    printf("**pptr = %d\n", **pptr);
}

/* String operations with escape sequences and format specifiers */
void string_operations(void) {
    char buffer[MAX_SIZE];
    const char *greeting = "Hello, World!\n";
    const char *path = "C:\\Users\\test\\file.txt";
    const char *tab_separated = "col1\tcol2\tcol3";
    char hex_char = '\x41';  /* 'A' */
    char null_char = '\0';

    /* Various format specifiers */
    snprintf(buffer, sizeof(buffer),
        "String: %s, Char: %c, Int: %d, Unsigned: %u\n"
        "Hex: 0x%08x, Oct: %o, Float: %f\n"
        "Scientific: %e, Pointer: %p, Percent: %%\n"
        "Width: %10d, Left: %-10d, Zero: %010d\n"
        "Long: %ld, Size: %zu, Ptrdiff: %td\n",
        greeting, hex_char, -42, 42u,
        0xDEADBEEF, 0755, 3.14159,
        1.23e-4, (void *)buffer, 42,
        42, 42, 42,
        123456789L, sizeof(buffer), (ptrdiff_t)0);

    printf("%s", buffer);
    LOG("Processed %d items", 42);
}

/* Numeric literals */
void numeric_types(void) {
    int dec = 42;
    int neg = -17;
    unsigned int u = 42u;
    long l = 123456789L;
    unsigned long ul = 123456789UL;
    long long ll = 123456789LL;
    float f = 3.14f;
    double d = 3.14159265358979;
    long double ld = 3.14159265358979L;
    int hex = 0xDEADBEEF;
    int oct = 0755;
    int bin = 0b10101010;
}

/* Bitwise operations */
unsigned int bitwise_ops(unsigned int a, unsigned int b) {
    unsigned int result = 0;
    result = a & b;   /* AND */
    result = a | b;   /* OR */
    result = a ^ b;   /* XOR */
    result = ~a;       /* NOT */
    result = a << 4;   /* Left shift */
    result = a >> 4;   /* Right shift */
    result &= 0xFF;
    return result;
}

/* Struct operations */
static Student *create_student(const char *name, int age, float score) {
    Student *s = (Student *)malloc(sizeof(Student));
    if (s == NULL) {
        LOG("malloc failed for student '%s'", name);
        return NULL;
    }
    strncpy(s->name, name, sizeof(s->name) - 1);
    s->name[sizeof(s->name) - 1] = '\0';
    s->age = age;
    s->score = score;
    s->active = true;
    instance_count++;
    return s;
}

static void print_student(const Student *s) {
    if (s == NULL) {
        fprintf(stderr, "Error: NULL student pointer\n");
        return;
    }
    printf("Student { name: \"%s\", age: %d, score: %.1f, active: %s }\n",
           s->name, s->age, s->score, s->active ? "true" : "false");
}

static int compare_by_age(const void *a, const void *b) {
    const Student *sa = (const Student *)a;
    const Student *sb = (const Student *)b;
    return sa->age - sb->age;
}

/* Main */
int main(int argc, char *argv[]) {
    printf("Version: %s\n", VERSION);
    printf("MAX_SIZE: %d, SQUARE(5): %d\n", MAX_SIZE, SQUARE(5));

    DEBUG_LOG("Starting program");

    Student *students[3];
    students[0] = create_student("Alice", 22, 95.5f);
    students[1] = create_student("Bob", 19, 87.3f);
    students[2] = create_student("Charlie", 21, 91.0f);

    for (int i = 0; i < 3; i++) {
        print_student(students[i]);
    }

    /* Conditional compilation */
    #if defined(DEBUG) && DEBUG > 1
        printf("Verbose debug mode\n");
    #elif defined(DEBUG)
        printf("Debug mode\n");
    #else
        printf("Release mode\n");
    #endif

    /* Cleanup */
    for (int i = 0; i < 3; i++) {
        free(students[i]);
    }

    switch (argc) {
        case 1:
            printf("No arguments\n");
            break;
        case 2:
            printf("One argument: %s\n", argv[1]);
            break;
        default:
            printf("Multiple arguments: %d\n", argc - 1);
            break;
    }

    return STATUS_OK;
}
