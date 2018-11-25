#include <vmm/spt.h>
#include <inc/x86.h>
#include <inc/error.h>
#include <inc/memlayout.h>
#include <kern/pmap.h>
#include <inc/string.h>

// Return the physical address of an spt entry
static inline uintptr_t spte_addr(spte_t spte)
{
	return (spte & SPTE_ADDR);
}

// Return the host kernel virtual address of an spt entry
static inline uintptr_t spte_page_vaddr(spte_t spte)
{
	return (uintptr_t) KADDR(spte_addr(spte));
}

// Return the flags from an spt entry
static inline spte_t spte_flags(spte_t spte)
{
	return (spte & SPTE_FLAGS);
}

// Return true if an spt entry's mapping is present
static inline int spte_present(spte_t spte)
{
	return (spte & __SPTE_FULL) > 0;
}

// Find the final spt entry for a given guest virtual address,
// creating any missing intermediate extended page tables if create is non-zero.
//
// If spte_out is non-NULL, store the found spte_t* at this address.
//
// Return 0 on success.  
// 
// Error values:
//    -E_INVAL if sptrt is NULL
//    -E_NO_ENT if create == 0 and the intermediate page table entries are missing.
//    -E_NO_MEM if allocation of intermediate page table entries fails
//
// Hint: Set the permissions of intermediate spt entries to __SPTE_FULL.
//       The hardware ANDs the permissions at each level, so removing a permission
//       bit at the last level entry is sufficient (and the bookkeeping is much simpler).
static int spt_lookup_gva(spte_t* sptrt, void *gva, int create, spte_t **spte_out) {
    /* Your code here */
    spte_t* dir = sptrt;
    int level = SPT_LEVELS - 1;
    int idx;
    if (sptrt == NULL) return -E_INVAL;
    while (level > 0) {
        idx = ADDR_TO_IDX(gva, level);
        if (!spte_present(dir[idx])) {
            if (!create){
                cprintf("Cannot create a new spt entry for gva %x\n", gva);
                return -E_NO_ENT;
            } 
            else {
                struct PageInfo *p = page_alloc(0);
                if (p == NULL) return -E_NO_MEM;
                dir[idx] = page2pa(p) | __SPTE_FULL;
                p->pp_ref++;
            }
        }
        dir = (spte_t *) KADDR(spte_addr(dir[idx]));
        level--;
    }
    if (spte_out) *spte_out = &dir[ADDR_TO_IDX(gva, 0)];
    return 0;
}

void spt_gva2hva(spte_t* sptrt, void *gva, void **hva) {
    spte_t* pte;
    int ret = spt_lookup_gva(sptrt, gva, 0, &pte);
    if(ret < 0) {
        *hva = NULL;
    } else {
        if(!spte_present(*pte)) {
           *hva = NULL;
        } else {
           *hva = KADDR(spte_addr(*pte));
        }
    }
}

static void free_spt_level(spte_t* sptrt, int level) {
    spte_t* dir = sptrt;
    int i;

    for(i=0; i<NPTENTRIES; ++i) {
        if(level != 0) {
            if(spte_present(dir[i])) {
                physaddr_t pa = spte_addr(dir[i]);
                free_spt_level((spte_t*) KADDR(pa), level-1);
                // free the table.
                page_decref(pa2page(pa));
            }
        } else {
            // Last level, free the guest physical page.
            if(spte_present(dir[i])) {
                physaddr_t pa = spte_addr(dir[i]);                
                page_decref(pa2page(pa));
            }
        }
    }
    return;
}

// Free the SPT table entries and the SPT tables.
// NOTE: Does not deallocate SPT PML4 page.
void spt_free_guest_mem(spte_t* sptrt) {
    free_spt_level(sptrt, SPT_LEVELS - 1);
    tlbflush();
}

// Add Page pp to a guest's SPT at guest virtual address gva
//  with permission perm.  sptrt is the SPT root.
//
// This function should increment the reference count of pp on a
//   successful insert.  If you overwrite a mapping, your code should
//   decrement the reference count of the old mapping.
// 
// Return 0 on success, <0 on failure.
//
int spt_page_insert(spte_t* sptrt, struct PageInfo* pp, void* gva, int perm) {

    /* Your code here */
    pp->pp_ref++;
    return spt_map_hva2gva(sptrt, page2kva(pp), gva, perm, 1);
}

// Map host virtual address hva to guest virtual address gva,
// with permissions perm.  sptrt is a pointer to the extended
// page table root.
//
// Return 0 on success.
// 
// If the mapping already exists and overwrite is set to 0,
//  return -E_INVAL.
// 
// Hint: use spt_lookup_gva to create the intermediate 
//       spt levels, and return the final spte_t pointer.
//       You should set the type to SPTE_TYPE_WB and set __SPTE_IPAT flag.
int spt_map_hva2gva(spte_t* sptrt, void* hva, void* gva, int perm, 
        int overwrite) {

    /* Your code here */
    spte_t *spte_out;
    int res;
    if ((res = spt_lookup_gva(sptrt, gva, 1, &spte_out)) < 0) {
        return res;
    }
    if (*spte_out != 0) {
        if (overwrite) page_decref(pa2page(spte_addr(*spte_out)));
        else return -E_INVAL;
    }
    // Returns the hpa corresponding to the gva.
    *spte_out = __SPTE_IPAT | perm | PADDR(hva) | __SPTE_TYPE(SPTE_TYPE_WB);
    return 0;
}

// FIXME: find the equivalent for SPT
/* int spt_alloc_static(spte_t *sptrt, struct VmxGuestInfo *ginfo) {
    physaddr_t i;
    
    for(i=0x0; i < 0xA0000; i+=PGSIZE) {
        struct PageInfo *p = page_alloc(0);
        p->pp_ref += 1;
        int r = spt_map_hva2gva(sptrt, page2kva(p), (void *)i, __SPTE_FULL, 0);
    }

    for(i=0x100000; i < ginfo->phys_sz; i+=PGSIZE) {
        struct PageInfo *p = page_alloc(0);
        p->pp_ref += 1;
        int r = spt_map_hva2gva(sptrt, page2kva(p), (void *)i, __SPTE_FULL, 0);
    }
    return 0;
}*/