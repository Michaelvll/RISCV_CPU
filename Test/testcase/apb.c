#include "io.h"

int main() {
  unsigned long a = inl();
  unsigned long b = inl();
  a += b;
  outl(a);
  return 0;
}