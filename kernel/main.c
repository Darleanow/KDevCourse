#include "arch/x86/gdt/gdt.h"
#include <stdint.h>

int main() {
  init_gdt();

  volatile char *video_memory = (volatile char *)0xB8000;
  const char *message = "GDT Loaded! Kernel is stable.";
  int i = 0;

  while (message[i] != 0) {
    video_memory[i * 2] = message[i];
    video_memory[i * 2 + 1] = 0x02;
    i++;
  }

  while (1) {
    asm volatile("hlt");
  }

  return 0;
}
