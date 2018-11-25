/*
 * GMM header
 * Guest Memory Map maps GPA -> HPA
 * GMM does not need to manage permissions
 */

#ifndef JOS_VMX_SPT_H
#define JOS_VMX_SPT_H

#include <inc/mmu.h>
#include <vmm/vmx.h>


typedef uint64_t gmme_t;

int gmm_map_hva2gpa(gmme_t *gmmrt, void* hva, void* gpa, int overwrite);
void gmm_free_guest_mem(gmme_t *gmmrt);
void gmm_gpa2hva(gmme_t *gmmrt, void *gpa, void **hva);
int gmm_page_insert(gmme_t *gmmrt, struct PageInfo* pp, void* gpa);

#define GMM_LEVELS 4

#define GMME_ADDR	(~(PGSIZE - 1))

#define ADDR_TO_IDX(pa, n) \
    ((((uint64_t) (pa)) >> (12 + 9 * (n))) & ((1 << 9) - 1))

#endif
