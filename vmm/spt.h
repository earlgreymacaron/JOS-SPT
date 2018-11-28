/*
 * SPT header based on EPT header.
 * Likely to be modified to meet SPT requirements.
 */

#ifndef JOS_VMX_SPT_H
#define JOS_VMX_SPT_H

#include <inc/mmu.h>
#include <vmm/vmx.h>
#include <inc/spt.h>
#include <vmm/gmm.h>

typedef uint64_t spte_t;

int spt_map_hva2gva( spte_t* sptrt, void* hva, void* gva, int perm, int overwrite );
// int spt_alloc_static(spte_t *sptrt, struct VmxGuestInfo *ginfo);
void spt_free_guest_mem(spte_t* sptrt);
void spt_gva2hva(spte_t* sptrt, void *gva, void **hva);
int spt_page_insert(spte_t* sptrt, struct PageInfo* pp, void* gva, int perm);
int spt_alloc_from_ept(spte_t** spte, epte_t *eptrt, uint64_t guest_cr3);

#define SPT_LEVELS 4

#define VMX_SPT_FAULT_READ	0x01
#define VMX_SPT_FAULT_WRITE	0x02
#define VMX_SPT_FAULT_INS	0x04


#define SPTE_ADDR	(~(PGSIZE - 1))
#define SPTE_FLAGS	(PGSIZE - 1)

#define ADDR_TO_IDX(pa, n) \
    ((((uint64_t) (pa)) >> (12 + 9 * (n))) & ((1 << 9) - 1))

#endif
