
#ifndef JOS_INC_VMX_H
#define JOS_INC_VMX_H

#define GUEST_MEM_SZ 16 * 1024 * 1024
#define MAX_MSR_COUNT ( PGSIZE / 2 ) / ( 128 / 8 )

#ifndef __ASSEMBLER__
#include <inc/types.h>
#include <inc/memlayout.h>
typedef enum {
    MODE_EPT = 0,
    MODE_SPT
} MemoryMode;

struct VmxGuestInfo {
	int64_t phys_sz;
	uintptr_t *vmcs;

	// Exception bitmap.
	uint32_t exception_bmap;
	// I/O bitmap.
	uint64_t *io_bmap_a;
	uint64_t *io_bmap_b;
	// MSR load/store area.
	int msr_count;
	uintptr_t *msr_host_area;
	uintptr_t *msr_guest_area;
	int vcpunum;
    MemoryMode mmode;
    uint64_t gcr3; // hold the gpa
    pml4e_t *rmap; // reverse map: gpa -> gva

    // For spt write-protect,
    // temporary push ud2 to run only one instruction and then revert it back
    char nchar[2];
    char *fault_ninsn;
};

#endif

#if defined(VMM_GUEST) || defined(VMM_HOST)

// VMCALLs
#define VMX_VMCALL_MBMAP 0x1
#define VMX_VMCALL_IPCSEND 0x2
#define VMX_VMCALL_IPCRECV 0x3
#define VMX_VMCALL_LAPICEOI 0x4
#define VMX_VMCALL_BACKTOHOST 0x5
#define VMX_VMCALL_GETDISKIMGNUM 0x6
#define VMX_VMCALL_ALLOC_CPU 0x7
#define VMX_VMCALL_GUEST_YIELD 0x8
#define VMX_VMCALL_CPUNUM 0x9
#define VMX_VMCALL_SWITCH_MMODE 0xa

#define VMX_HOST_FS_ENV 0x1

#endif
#endif
