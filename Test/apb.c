#include "io.h"

int main() {
  char a = inb();
  char b = inb();
  a = a - '0' + b;
  outb(a);
  return 0;
}