#include <stdint.h>

int main() {
  volatile char *video_memory = (volatile char *)0xB8000;
  const char *message = "KDev Kernel initialized successfully.";
  int i = 0;

  while (message[i] != 0) {
    video_memory[i * 2] = message[i];
    video_memory[i * 2 + 1] = 0x0F;
    i++;
  }

  while (1) {
    asm volatile("hlt");
  }

  return 0;
}
