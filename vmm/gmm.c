#include <vmm/gmm.h>
#include <inc/x86.h>
#include <inc/error.h>
#include <inc/memlayout.h>
#include <kern/pmap.h>
#include <inc/string.h>


// Find the final GMM entry for a given gpa,
// creating any missing intermediate extended page tables if create is non-zero.
//
// If gmme_out is non-NULL, store the found gmme_t * at this address.
//
// Return 0 on success.
//
// Error values:
//    -E_INVAL if gmmrt is NULL
//    -E_NO_ENT if create == 0 and the intermediate page table entries are missing.
//    -E_NO_MEM if allocation of intermediate page table entries fails
//
static int gmm_lookup_gpa(gmme_t* gmmrt, void *gpa, int create, gmme_t **gmme_out) {

    gmme_t* dir = gmmrt;
    int level = GMM_LEVELS - 1;
    int idx;

    // Check if gmmrt is valid
    if (!gmmrt)
        return -E_INVAL;

    // Walk GMM tables
    while (level > 0) {

        // Extract index for current level
        idx = ADDR_TO_IDX(gpa, level);

        // If there is no entry yet existing
        if (!dir[idx]) {
            if (!create)
                return -E_NO_ENT;
            else {
                struct PageInfo *new_page = page_alloc(ALLOC_ZERO);
                if (!new_page)
                    return -E_NO_MEM;
                dir[idx] = page2pa(new_page);
                new_page->pp_ref++;
            }
        }
        dir = (gmme_t *) KADDR(dir[idx]);
        level--;
    }

    // If gmme_out is non-NULL, fill it in
    if (gmme_out)
        *gmme_out = &dir[ADDR_TO_IDX(gpa, 0)];

    return 0;
}

// Save HVA for given GPA in *hva
void gmm_gpa2hva(gmme_t* gmmrt, void *gpa, void **hva) {
    gmme_t* gmme;

    // Find corresponding gmm entry
    int ret = gmm_lookup_gpa(gmmrt, gpa, 0, &gmme);

    if (ret < 0) {
        *hva = NULL;
    } else {
        if(!(*gmme)) {
           *hva = NULL;
        } else {
           *hva = KADDR(*gmme);
        }
    }
}

static void free_gmm_level(gmme_t* gmmrt, int level) {
    gmme_t* dir = gmmrt;
    int i;

    for(i=0; i<NPTENTRIES; ++i) {
        if(level != 0) {
            // If there is a mapping a ith entry
            if(dir[i]) {
                physaddr_t hpa = dir[i];
                free_gmm_level((gmme_t *) KADDR(hpa), level-1);
                // free the table.
                page_decref(pa2page(hpa));
            }
        } else {
            // Last level, free the guest physical page.
            if(dir[i]) {
                physaddr_t hpa = dir[i];
                page_decref(pa2page(hpa));
            }
        }
    }
    return;
}

// Free GMM table entries and the GMM tables.
// NOTE: Does not deallocate GMM PML4 page.
void gmm_free_guest_mem(gmme_t *gmmrt) {
    free_gmm_level(gmmrt, GMM_LEVELS - 1);
    tlbflush();
}

// Add Page pp to a guest's GMM at guest physical address gpa
// gmmrt is the GMM root.
//
// This function should increment the reference count of pp on a
//   successful insert.  If you overwrite a mapping, your code should
//   decrement the reference count of the old mapping.
//   (Handled in gmm_page_hva2gpa)
//
// Return 0 on success, <0 on failure.
//
int gmm_page_insert(gmme_t *gmmrt, struct PageInfo* pp, void* gpa) {

    pp->pp_ref++;
    return gmm_map_hva2gpa(gmmrt, page2kva(pp), gpa, 1);
}

// Map host virtual address hva to guest physical address gpa
// in GMM (Guest Memory Map). gmmrt is a pointer to GMM root.
//
// Return 0 on success.
//
// If the mapping already exists and overwrite is set to 0,
//  return -E_INVAL.
//
// Use gmm_lookup_gpa to create the intermediate gmm levels,
// and return the final gmme_t pointer.
int gmm_map_hva2gpa(gmme_t* gmmrt, void* hva, void* gpa, int overwrite) {

    gmme_t *gmme_out;
    int res;

    // Find corresponding GMM entry in gmme_out
    // Also create intermediate tables
    if ((res = gmm_lookup_gpa(gmmrt, gpa, 1, &gmme_out)) < 0) {
        return res;
    }

    // If the mapping already exists
    if (*gmme_out) {
        if (!overwrite)
            return -E_INVAL;
        else
            page_decref(pa2page(*gmme_out));
    }

    // Insert hpa in GMM entry
    *gmme_out = PADDR(hva);

    return 0;
}

int gmm_alloc_from_ept(gmme_t* gmmrt, epte_t* epte){
    const int NB_ENTRIES = 1 << 9;

    pml4e_t* pml4e;
    pdpe_t* pdpe;
    pde_t* pgdir;
    pte_t* pte;

    int i, j, k;
    uint64_t *gpa, *hva;

    if(gmmrt == NULL || epte == NULL) return -E_INVAL;

    pml4e = epte;

    for(i = 0; i < NB_ENTRIES; i++){
        pdpe = KADDR(pml4e[i]);
        if(pdpe){
            for(j = 0; j < NB_ENTRIES; j++){
                pgdir = KADDR(pdpe[j]);
                if(pgdir) {
                    for(k = 0; k < NB_ENTRIES; k++){
                        pte = KADDR(pgdir[k]);
                        // Check that an ept entry has been found
                        if(pte){
                            hva = KADDR(*pte);
                            gpa = (uint64_t *) ((uint64_t) i << 3 * 9 | j << 2 * 9 | k << 9);
                            gmm_map_hva2gpa(gmmrt, hva, gpa, 1);
                        }
                    }
                }
            }
        }
    }
    return 0;
}
