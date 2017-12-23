#ifndef CPU_JUDGE_TEST_IO_H
#define CPU_JUDGE_TEST_IO_H

static inline unsigned char inb() { return *((volatile unsigned char *)0x100); }

static inline void outb(unsigned char data) {
  *((volatile unsigned char *)0x104) = data;
}

static inline unsigned long inl() {
  unsigned char data[4];
  data[0] = inb();
  data[1] = inb();
  data[2] = inb();
  data[3] = inb();
  return data[0] | (data[1] << 8) | (data[2] << 16) | (data[3] << 24);
}

static inline void outl(unsigned int data) {
  outb(data & 0xff);
  outb((data >> 8) & 0xff);
  outb((data >> 16) & 0xff);
  outb((data >> 24) & 0xff);
}

static inline void print(const char *str) {
  for (; *str; str++)
    outb(*str);
}

static inline void println(const char *str) {
  print(str);
  outb('\n');
}

#endif