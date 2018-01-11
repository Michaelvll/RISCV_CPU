// Written by Zhekai Zhang

#include <stdint.h>
#include <unistd.h>

extern int __heap_start;

static inline void out(unsigned char data) {
  *((volatile unsigned char *)0x104) = data;
}

static inline unsigned int in() { return *((volatile unsigned int *)0x100); }

void *sbrk(intptr_t increment) {
  static void *heap = (void *)&__heap_start;
  void *start = heap;
  heap += increment;
  return start;
}

ssize_t write(int fd, const void *buf, size_t nbyte) {
  if (fd == STDOUT_FILENO) {
    const unsigned char *ptr = (const unsigned char *)buf;
    size_t i;
    for (i = 0; i < nbyte; i++)
      out(ptr[i]);
    return nbyte;
  }
  return -1;
}

ssize_t read(int fd, void *buf, size_t nbyte) {
  if (fd == STDIN_FILENO) {
    unsigned char *ptr = (unsigned char *)buf;
    size_t i;
    for (i = 0; i < nbyte; i++) {
      unsigned int rd = in();
      if (rd == ~0)
        return i;
      ptr[i] = (unsigned char)rd;
    }
    return nbyte;
  }
  return -1;
}