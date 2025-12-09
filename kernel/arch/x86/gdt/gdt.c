#include "gdt.h"

gdt_entry_t gdt_entries[3];
gdt_ptr_t gdt_ptr;

extern void gdt_flush(uint32_t);

static void gdt_set_gate(int32_t num, uint32_t base, uint32_t limit,
                         uint8_t access, uint8_t gran) {
  gdt_entries[num].base_low = (base & 0xFFFF);
  gdt_entries[num].base_middle = (base >> 16) & 0xFF;
  gdt_entries[num].base_high = (base >> 24) & 0xFF;

  gdt_entries[num].limit_low = (limit & 0xFFFF);
  gdt_entries[num].granularity = (limit >> 16) & 0x0F;

  gdt_entries[num].granularity |= (gran & 0xF0);
  gdt_entries[num].access = access;
}

void init_gdt() {
  gdt_ptr.limit = (sizeof(gdt_entry_t) * 3) - 1;
  gdt_ptr.base = (uint32_t)&gdt_entries;

  // 0: Null Segment
  gdt_set_gate(0, 0, 0, 0, 0);

  // 1: Kernel Code Segment
  // Base: 0, Limit: 4GB, Access: 0x9A, Gran: 0xCF
  // Access 0x9A = Present(1) Ring0(00) Code/Exec(1) Readable(1)
  gdt_set_gate(1, 0, 0xFFFFFFFF, 0x9A, 0xCF);

  // 2: Kernel Data Segment
  // Base: 0, Limit: 4GB, Access: 0x92, Gran: 0xCF
  // Access 0x92 = Present(1) Ring0(00) Data(1) Writable(1)
  gdt_set_gate(2, 0, 0xFFFFFFFF, 0x92, 0xCF);

  gdt_flush((uint32_t)&gdt_ptr);
}
