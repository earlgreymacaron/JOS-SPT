
vmm/guest/obj/user/vmm:     file format elf64-x86-64


Disassembly of section .text:

0000000000800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	movabs $USTACKTOP, %rax
  800020:	48 b8 00 e0 7f ef 00 	movabs $0xef7fe000,%rax
  800027:	00 00 00 
	cmpq %rax,%rsp
  80002a:	48 39 c4             	cmp    %rax,%rsp
	jne args_exist
  80002d:	75 04                	jne    800033 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushq $0
  80002f:	6a 00                	pushq  $0x0
	pushq $0
  800031:	6a 00                	pushq  $0x0

0000000000800033 <args_exist>:

args_exist:
	movq 8(%rsp), %rsi
  800033:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
	movq (%rsp), %rdi
  800038:	48 8b 3c 24          	mov    (%rsp),%rdi
	call libmain
  80003c:	e8 50 05 00 00       	callq  800591 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <do_alloc>:
#define GUEST_KERN "/vmm/kernel"
#define GUEST_BOOT "/vmm/boot"

#define JOS_ENTRY 0x7000

static void *do_alloc() {
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 83 ec 18          	sub    $0x18,%rsp
    static void *va = (void *)USTACKTOP - 2 * PGSIZE;
    while (sys_page_alloc(sys_getenvid(), va,  PTE_P|PTE_U|PTE_W) < 0) {
  80004c:	eb 21                	jmp    80006f <do_alloc+0x2c>
        va -= PGSIZE;
  80004e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800055:	00 00 00 
  800058:	48 8b 00             	mov    (%rax),%rax
  80005b:	48 8d 90 00 f0 ff ff 	lea    -0x1000(%rax),%rdx
  800062:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800069:	00 00 00 
  80006c:	48 89 10             	mov    %rdx,(%rax)

#define JOS_ENTRY 0x7000

static void *do_alloc() {
    static void *va = (void *)USTACKTOP - 2 * PGSIZE;
    while (sys_page_alloc(sys_getenvid(), va,  PTE_P|PTE_U|PTE_W) < 0) {
  80006f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800076:	00 00 00 
  800079:	48 8b 18             	mov    (%rax),%rbx
  80007c:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  800083:	00 00 00 
  800086:	ff d0                	callq  *%rax
  800088:	ba 07 00 00 00       	mov    $0x7,%edx
  80008d:	48 89 de             	mov    %rbx,%rsi
  800090:	89 c7                	mov    %eax,%edi
  800092:	48 b8 40 1c 80 00 00 	movabs $0x801c40,%rax
  800099:	00 00 00 
  80009c:	ff d0                	callq  *%rax
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	78 ac                	js     80004e <do_alloc+0xb>
        va -= PGSIZE;
    }
    void *ret = va;
  8000a2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000a9:	00 00 00 
  8000ac:	48 8b 00             	mov    (%rax),%rax
  8000af:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    va -= PGSIZE;
  8000b3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000ba:	00 00 00 
  8000bd:	48 8b 00             	mov    (%rax),%rax
  8000c0:	48 8d 90 00 f0 ff ff 	lea    -0x1000(%rax),%rdx
  8000c7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000ce:	00 00 00 
  8000d1:	48 89 10             	mov    %rdx,(%rax)
    return ret;
  8000d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8000d8:	48 83 c4 18          	add    $0x18,%rsp
  8000dc:	5b                   	pop    %rbx
  8000dd:	5d                   	pop    %rbp
  8000de:	c3                   	retq   

00000000008000df <map_in_guest>:
//
// Return 0 on success, <0 on failure.
//
static int
map_in_guest( envid_t guest, uintptr_t gpa, size_t memsz,
              int fd, size_t filesz, off_t fileoffset ) {
  8000df:	55                   	push   %rbp
  8000e0:	48 89 e5             	mov    %rsp,%rbp
  8000e3:	48 83 ec 50          	sub    $0x50,%rsp
  8000e7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8000ea:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8000ee:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8000f2:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8000f5:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8000f9:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
    /* Your code here */
    int res = 0;
  8000fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    size_t pos = 0;
  800104:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80010b:	00 
    envid_t me = sys_getenvid();
  80010c:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  800113:	00 00 00 
  800116:	ff d0                	callq  *%rax
  800118:	89 45 f0             	mov    %eax,-0x10(%rbp)
    seek(fd, fileoffset);
  80011b:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80011e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800121:	89 d6                	mov    %edx,%esi
  800123:	89 c7                	mov    %eax,%edi
  800125:	48 b8 56 27 80 00 00 	movabs $0x802756,%rax
  80012c:	00 00 00 
  80012f:	ff d0                	callq  *%rax
    for (pos = 0; pos < memsz; pos += PGSIZE) {
  800131:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800138:	00 
  800139:	e9 96 00 00 00       	jmpq   8001d4 <map_in_guest+0xf5>
        void *hva = do_alloc();
  80013e:	b8 00 00 00 00       	mov    $0x0,%eax
  800143:	48 ba 43 00 80 00 00 	movabs $0x800043,%rdx
  80014a:	00 00 00 
  80014d:	ff d2                	callq  *%rdx
  80014f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        if (pos < filesz)
  800153:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800157:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  80015b:	73 35                	jae    800192 <map_in_guest+0xb3>
            read (fd, hva, filesz - pos > PGSIZE ? PGSIZE : filesz - pos);
  80015d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800161:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800165:	48 29 c2             	sub    %rax,%rdx
  800168:	48 89 d0             	mov    %rdx,%rax
  80016b:	ba 00 10 00 00       	mov    $0x1000,%edx
  800170:	48 3d 00 10 00 00    	cmp    $0x1000,%rax
  800176:	48 0f 46 d0          	cmovbe %rax,%rdx
  80017a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80017e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800181:	48 89 ce             	mov    %rcx,%rsi
  800184:	89 c7                	mov    %eax,%edi
  800186:	48 b8 38 25 80 00 00 	movabs $0x802538,%rax
  80018d:	00 00 00 
  800190:	ff d0                	callq  *%rax
        if ((res = sys_ept_map(me, hva, guest, (void *) gpa + pos, __EPTE_READ | __EPTE_WRITE | __EPTE_EXEC)) < 0)
  800192:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800196:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80019a:	48 01 d0             	add    %rdx,%rax
  80019d:	48 89 c1             	mov    %rax,%rcx
  8001a0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8001a3:	48 8b 75 e8          	mov    -0x18(%rbp),%rsi
  8001a7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001aa:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8001b0:	89 c7                	mov    %eax,%edi
  8001b2:	48 b8 7b 1f 80 00 00 	movabs $0x801f7b,%rax
  8001b9:	00 00 00 
  8001bc:	ff d0                	callq  *%rax
  8001be:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8001c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8001c5:	79 05                	jns    8001cc <map_in_guest+0xed>
            return res;
  8001c7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8001ca:	eb 1b                	jmp    8001e7 <map_in_guest+0x108>
    /* Your code here */
    int res = 0;
    size_t pos = 0;
    envid_t me = sys_getenvid();
    seek(fd, fileoffset);
    for (pos = 0; pos < memsz; pos += PGSIZE) {
  8001cc:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  8001d3:	00 
  8001d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001d8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8001dc:	0f 82 5c ff ff ff    	jb     80013e <map_in_guest+0x5f>
        if (pos < filesz)
            read (fd, hva, filesz - pos > PGSIZE ? PGSIZE : filesz - pos);
        if ((res = sys_ept_map(me, hva, guest, (void *) gpa + pos, __EPTE_READ | __EPTE_WRITE | __EPTE_EXEC)) < 0)
            return res;
    }
    return 0;
  8001e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8001e7:	c9                   	leaveq 
  8001e8:	c3                   	retq   

00000000008001e9 <read_and_verify>:

static int read_and_verify(int fd, void *buf, int size) {
  8001e9:	55                   	push   %rbp
  8001ea:	48 89 e5             	mov    %rsp,%rbp
  8001ed:	48 83 ec 10          	sub    $0x10,%rsp
  8001f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8001f8:	89 55 f8             	mov    %edx,-0x8(%rbp)
    return (read(fd, buf, size) != size) ? -1 : 0;
  8001fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001fe:	48 63 d0             	movslq %eax,%rdx
  800201:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800205:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800208:	48 89 ce             	mov    %rcx,%rsi
  80020b:	89 c7                	mov    %eax,%edi
  80020d:	48 b8 38 25 80 00 00 	movabs $0x802538,%rax
  800214:	00 00 00 
  800217:	ff d0                	callq  *%rax
  800219:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  80021c:	74 07                	je     800225 <read_and_verify+0x3c>
  80021e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800223:	eb 05                	jmp    80022a <read_and_verify+0x41>
  800225:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80022a:	c9                   	leaveq 
  80022b:	c3                   	retq   

000000000080022c <copy_guest_kern_gpa>:
//
// Return 0 on success, <0 on error
//
// Hint: compare with ELF parsing in env.c, and use map_in_guest for each segment.
static int
copy_guest_kern_gpa( envid_t guest, char* fname ) {
  80022c:	55                   	push   %rbp
  80022d:	48 89 e5             	mov    %rsp,%rbp
  800230:	48 81 ec a0 00 00 00 	sub    $0xa0,%rsp
  800237:	89 bd 6c ff ff ff    	mov    %edi,-0x94(%rbp)
  80023d:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)

	/* Your code here */
    int res = 0, i;
  800244:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    struct Elf elf;
    struct Proghdr ph;

    int kern = open(fname, O_RDONLY);
  80024b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800252:	be 00 00 00 00       	mov    $0x0,%esi
  800257:	48 89 c7             	mov    %rax,%rdi
  80025a:	48 b8 0e 2a 80 00 00 	movabs $0x802a0e,%rax
  800261:	00 00 00 
  800264:	ff d0                	callq  *%rax
  800266:	89 45 f4             	mov    %eax,-0xc(%rbp)
    if (kern < 0) {
  800269:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80026d:	79 32                	jns    8002a1 <copy_guest_kern_gpa+0x75>
        cprintf("open %s for read: %e\n", fname, kern);
  80026f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800272:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800279:	48 89 c6             	mov    %rax,%rsi
  80027c:	48 bf 60 46 80 00 00 	movabs $0x804660,%rdi
  800283:	00 00 00 
  800286:	b8 00 00 00 00       	mov    $0x0,%eax
  80028b:	48 b9 5c 07 80 00 00 	movabs $0x80075c,%rcx
  800292:	00 00 00 
  800295:	ff d1                	callq  *%rcx
        return -E_NO_SYS;
  800297:	b8 f9 ff ff ff       	mov    $0xfffffff9,%eax
  80029c:	e9 5a 01 00 00       	jmpq   8003fb <copy_guest_kern_gpa+0x1cf>
    }

    if (read_and_verify(kern, &elf, sizeof(struct Elf)) < 0) {
  8002a1:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
  8002a5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8002a8:	ba 40 00 00 00       	mov    $0x40,%edx
  8002ad:	48 89 ce             	mov    %rcx,%rsi
  8002b0:	89 c7                	mov    %eax,%edi
  8002b2:	48 b8 e9 01 80 00 00 	movabs $0x8001e9,%rax
  8002b9:	00 00 00 
  8002bc:	ff d0                	callq  *%rax
  8002be:	85 c0                	test   %eax,%eax
  8002c0:	79 0c                	jns    8002ce <copy_guest_kern_gpa+0xa2>
        res = -E_NO_SYS;
  8002c2:	c7 45 fc f9 ff ff ff 	movl   $0xfffffff9,-0x4(%rbp)
        goto CLEAN_AND_EXIT;
  8002c9:	e9 19 01 00 00       	jmpq   8003e7 <copy_guest_kern_gpa+0x1bb>
    }

    if (elf.e_magic == ELF_MAGIC) {
  8002ce:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8002d1:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  8002d6:	0f 85 e8 00 00 00    	jne    8003c4 <copy_guest_kern_gpa+0x198>
        for (i = 0; i < elf.e_phnum; i++) {
  8002dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8002e3:	e9 ca 00 00 00       	jmpq   8003b2 <copy_guest_kern_gpa+0x186>
            seek(kern, elf.e_phoff + i * sizeof(struct Proghdr));
  8002e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8002ec:	89 c2                	mov    %eax,%edx
  8002ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002f1:	48 98                	cltq   
  8002f3:	c1 e0 03             	shl    $0x3,%eax
  8002f6:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  8002fd:	29 c1                	sub    %eax,%ecx
  8002ff:	89 c8                	mov    %ecx,%eax
  800301:	01 d0                	add    %edx,%eax
  800303:	89 c2                	mov    %eax,%edx
  800305:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800308:	89 d6                	mov    %edx,%esi
  80030a:	89 c7                	mov    %eax,%edi
  80030c:	48 b8 56 27 80 00 00 	movabs $0x802756,%rax
  800313:	00 00 00 
  800316:	ff d0                	callq  *%rax
            if (read_and_verify(kern, &ph, sizeof(struct Proghdr)) < 0) {
  800318:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  80031f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800322:	ba 38 00 00 00       	mov    $0x38,%edx
  800327:	48 89 ce             	mov    %rcx,%rsi
  80032a:	89 c7                	mov    %eax,%edi
  80032c:	48 b8 e9 01 80 00 00 	movabs $0x8001e9,%rax
  800333:	00 00 00 
  800336:	ff d0                	callq  *%rax
  800338:	85 c0                	test   %eax,%eax
  80033a:	79 0c                	jns    800348 <copy_guest_kern_gpa+0x11c>
                res = -E_NO_SYS;
  80033c:	c7 45 fc f9 ff ff ff 	movl   $0xfffffff9,-0x4(%rbp)
                goto CLEAN_AND_EXIT;
  800343:	e9 9f 00 00 00       	jmpq   8003e7 <copy_guest_kern_gpa+0x1bb>
            }

            if (ph.p_type == ELF_PROG_LOAD) {
  800348:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  80034e:	83 f8 01             	cmp    $0x1,%eax
  800351:	75 5b                	jne    8003ae <copy_guest_kern_gpa+0x182>
                if (map_in_guest(guest, ph.p_pa, ph.p_memsz, kern, ph.p_filesz, ph.p_offset) < 0) {
  800353:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  80035a:	41 89 c0             	mov    %eax,%r8d
  80035d:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  800361:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  800365:	48 8b 75 88          	mov    -0x78(%rbp),%rsi
  800369:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  80036c:	8b 85 6c ff ff ff    	mov    -0x94(%rbp),%eax
  800372:	45 89 c1             	mov    %r8d,%r9d
  800375:	49 89 f8             	mov    %rdi,%r8
  800378:	89 c7                	mov    %eax,%edi
  80037a:	48 b8 df 00 80 00 00 	movabs $0x8000df,%rax
  800381:	00 00 00 
  800384:	ff d0                	callq  *%rax
  800386:	85 c0                	test   %eax,%eax
  800388:	79 24                	jns    8003ae <copy_guest_kern_gpa+0x182>
                    cprintf("map_in_guest fail\n");
  80038a:	48 bf 76 46 80 00 00 	movabs $0x804676,%rdi
  800391:	00 00 00 
  800394:	b8 00 00 00 00       	mov    $0x0,%eax
  800399:	48 ba 5c 07 80 00 00 	movabs $0x80075c,%rdx
  8003a0:	00 00 00 
  8003a3:	ff d2                	callq  *%rdx
                    res = -E_NO_SYS;
  8003a5:	c7 45 fc f9 ff ff ff 	movl   $0xfffffff9,-0x4(%rbp)
                    goto CLEAN_AND_EXIT;
  8003ac:	eb 39                	jmp    8003e7 <copy_guest_kern_gpa+0x1bb>
        res = -E_NO_SYS;
        goto CLEAN_AND_EXIT;
    }

    if (elf.e_magic == ELF_MAGIC) {
        for (i = 0; i < elf.e_phnum; i++) {
  8003ae:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8003b2:	0f b7 45 e8          	movzwl -0x18(%rbp),%eax
  8003b6:	0f b7 c0             	movzwl %ax,%eax
  8003b9:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8003bc:	0f 8f 26 ff ff ff    	jg     8002e8 <copy_guest_kern_gpa+0xbc>
  8003c2:	eb 23                	jmp    8003e7 <copy_guest_kern_gpa+0x1bb>
                    goto CLEAN_AND_EXIT;
                }
            }
        }
    } else {
        cprintf("Invalid Binary\n");
  8003c4:	48 bf 89 46 80 00 00 	movabs $0x804689,%rdi
  8003cb:	00 00 00 
  8003ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d3:	48 ba 5c 07 80 00 00 	movabs $0x80075c,%rdx
  8003da:	00 00 00 
  8003dd:	ff d2                	callq  *%rdx
        res = -E_NO_SYS;
  8003df:	c7 45 fc f9 ff ff ff 	movl   $0xfffffff9,-0x4(%rbp)
        goto CLEAN_AND_EXIT;
  8003e6:	90                   	nop
    }
CLEAN_AND_EXIT:
    close(kern);
  8003e7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8003ea:	89 c7                	mov    %eax,%edi
  8003ec:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  8003f3:	00 00 00 
  8003f6:	ff d0                	callq  *%rax
    return res;
  8003f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8003fb:	c9                   	leaveq 
  8003fc:	c3                   	retq   

00000000008003fd <umain>:

void
umain(int argc, char **argv) {
  8003fd:	55                   	push   %rbp
  8003fe:	48 89 e5             	mov    %rsp,%rbp
  800401:	48 83 ec 50          	sub    $0x50,%rsp
  800405:	89 7d bc             	mov    %edi,-0x44(%rbp)
  800408:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int ret;
	envid_t guest;
	char filename_buffer[50];	//buffer to save the path 
	int vmdisk_number;
	int r;
	if ((ret = sys_env_mkguest( GUEST_MEM_SZ, JOS_ENTRY )) < 0) {
  80040c:	be 00 70 00 00       	mov    $0x7000,%esi
  800411:	bf 00 00 00 01       	mov    $0x1000000,%edi
  800416:	48 b8 d6 1f 80 00 00 	movabs $0x801fd6,%rax
  80041d:	00 00 00 
  800420:	ff d0                	callq  *%rax
  800422:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800425:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800429:	79 2c                	jns    800457 <umain+0x5a>
		cprintf("Error creating a guest OS env: %e\n", ret );
  80042b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80042e:	89 c6                	mov    %eax,%esi
  800430:	48 bf a0 46 80 00 00 	movabs $0x8046a0,%rdi
  800437:	00 00 00 
  80043a:	b8 00 00 00 00       	mov    $0x0,%eax
  80043f:	48 ba 5c 07 80 00 00 	movabs $0x80075c,%rdx
  800446:	00 00 00 
  800449:	ff d2                	callq  *%rdx
		exit();
  80044b:	48 b8 14 06 80 00 00 	movabs $0x800614,%rax
  800452:	00 00 00 
  800455:	ff d0                	callq  *%rax
	}
	guest = ret;
  800457:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80045a:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// Copy the guest kernel code into guest phys mem.
	if((ret = copy_guest_kern_gpa(guest, GUEST_KERN)) < 0) {
  80045d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800460:	48 be c3 46 80 00 00 	movabs $0x8046c3,%rsi
  800467:	00 00 00 
  80046a:	89 c7                	mov    %eax,%edi
  80046c:	48 b8 2c 02 80 00 00 	movabs $0x80022c,%rax
  800473:	00 00 00 
  800476:	ff d0                	callq  *%rax
  800478:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80047b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80047f:	79 2c                	jns    8004ad <umain+0xb0>
		cprintf("Error copying page into the guest - %d\n.", ret);
  800481:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800484:	89 c6                	mov    %eax,%esi
  800486:	48 bf d0 46 80 00 00 	movabs $0x8046d0,%rdi
  80048d:	00 00 00 
  800490:	b8 00 00 00 00       	mov    $0x0,%eax
  800495:	48 ba 5c 07 80 00 00 	movabs $0x80075c,%rdx
  80049c:	00 00 00 
  80049f:	ff d2                	callq  *%rdx
		exit();
  8004a1:	48 b8 14 06 80 00 00 	movabs $0x800614,%rax
  8004a8:	00 00 00 
  8004ab:	ff d0                	callq  *%rax
	}

	// Now copy the bootloader.
	int fd;
	if ((fd = open( GUEST_BOOT, O_RDONLY)) < 0 ) {
  8004ad:	be 00 00 00 00       	mov    $0x0,%esi
  8004b2:	48 bf f9 46 80 00 00 	movabs $0x8046f9,%rdi
  8004b9:	00 00 00 
  8004bc:	48 b8 0e 2a 80 00 00 	movabs $0x802a0e,%rax
  8004c3:	00 00 00 
  8004c6:	ff d0                	callq  *%rax
  8004c8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8004cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8004cf:	79 36                	jns    800507 <umain+0x10a>
		cprintf("open %s for read: %e\n", GUEST_BOOT, fd );
  8004d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004d4:	89 c2                	mov    %eax,%edx
  8004d6:	48 be f9 46 80 00 00 	movabs $0x8046f9,%rsi
  8004dd:	00 00 00 
  8004e0:	48 bf 60 46 80 00 00 	movabs $0x804660,%rdi
  8004e7:	00 00 00 
  8004ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ef:	48 b9 5c 07 80 00 00 	movabs $0x80075c,%rcx
  8004f6:	00 00 00 
  8004f9:	ff d1                	callq  *%rcx
		exit();
  8004fb:	48 b8 14 06 80 00 00 	movabs $0x800614,%rax
  800502:	00 00 00 
  800505:	ff d0                	callq  *%rax
	}

	// sizeof(bootloader) < 512.
	if ((ret = map_in_guest(guest, JOS_ENTRY, 512, fd, 512, 0)) < 0) {
  800507:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80050a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80050d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800513:	41 b8 00 02 00 00    	mov    $0x200,%r8d
  800519:	89 d1                	mov    %edx,%ecx
  80051b:	ba 00 02 00 00       	mov    $0x200,%edx
  800520:	be 00 70 00 00       	mov    $0x7000,%esi
  800525:	89 c7                	mov    %eax,%edi
  800527:	48 b8 df 00 80 00 00 	movabs $0x8000df,%rax
  80052e:	00 00 00 
  800531:	ff d0                	callq  *%rax
  800533:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800536:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80053a:	79 2c                	jns    800568 <umain+0x16b>
		cprintf("Error mapping bootloader into the guest - %d\n.", ret);
  80053c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80053f:	89 c6                	mov    %eax,%esi
  800541:	48 bf 08 47 80 00 00 	movabs $0x804708,%rdi
  800548:	00 00 00 
  80054b:	b8 00 00 00 00       	mov    $0x0,%eax
  800550:	48 ba 5c 07 80 00 00 	movabs $0x80075c,%rdx
  800557:	00 00 00 
  80055a:	ff d2                	callq  *%rdx
		exit();
  80055c:	48 b8 14 06 80 00 00 	movabs $0x800614,%rax
  800563:	00 00 00 
  800566:	ff d0                	callq  *%rax

	//cprintf("Create VHD finished\n");
#endif

	// Mark the guest as runnable.
	sys_env_set_status(guest, ENV_RUNNABLE);
  800568:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80056b:	be 02 00 00 00       	mov    $0x2,%esi
  800570:	89 c7                	mov    %eax,%edi
  800572:	48 b8 35 1d 80 00 00 	movabs $0x801d35,%rax
  800579:	00 00 00 
  80057c:	ff d0                	callq  *%rax
	wait(guest);
  80057e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800581:	89 c7                	mov    %eax,%edi
  800583:	48 b8 20 3e 80 00 00 	movabs $0x803e20,%rax
  80058a:	00 00 00 
  80058d:	ff d0                	callq  *%rax
}
  80058f:	c9                   	leaveq 
  800590:	c3                   	retq   

0000000000800591 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800591:	55                   	push   %rbp
  800592:	48 89 e5             	mov    %rsp,%rbp
  800595:	48 83 ec 10          	sub    $0x10,%rsp
  800599:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80059c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  8005a0:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  8005a7:	00 00 00 
  8005aa:	ff d0                	callq  *%rax
  8005ac:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005b1:	48 98                	cltq   
  8005b3:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8005ba:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8005c1:	00 00 00 
  8005c4:	48 01 c2             	add    %rax,%rdx
  8005c7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8005ce:	00 00 00 
  8005d1:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005d8:	7e 14                	jle    8005ee <libmain+0x5d>
		binaryname = argv[0];
  8005da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005de:	48 8b 10             	mov    (%rax),%rdx
  8005e1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8005e8:	00 00 00 
  8005eb:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8005ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005f5:	48 89 d6             	mov    %rdx,%rsi
  8005f8:	89 c7                	mov    %eax,%edi
  8005fa:	48 b8 fd 03 80 00 00 	movabs $0x8003fd,%rax
  800601:	00 00 00 
  800604:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800606:	48 b8 14 06 80 00 00 	movabs $0x800614,%rax
  80060d:	00 00 00 
  800610:	ff d0                	callq  *%rax
}
  800612:	c9                   	leaveq 
  800613:	c3                   	retq   

0000000000800614 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800614:	55                   	push   %rbp
  800615:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800618:	48 b8 61 23 80 00 00 	movabs $0x802361,%rax
  80061f:	00 00 00 
  800622:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800624:	bf 00 00 00 00       	mov    $0x0,%edi
  800629:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  800630:	00 00 00 
  800633:	ff d0                	callq  *%rax
}
  800635:	5d                   	pop    %rbp
  800636:	c3                   	retq   

0000000000800637 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800637:	55                   	push   %rbp
  800638:	48 89 e5             	mov    %rsp,%rbp
  80063b:	48 83 ec 10          	sub    $0x10,%rsp
  80063f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800642:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800646:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80064a:	8b 00                	mov    (%rax),%eax
  80064c:	8d 48 01             	lea    0x1(%rax),%ecx
  80064f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800653:	89 0a                	mov    %ecx,(%rdx)
  800655:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800658:	89 d1                	mov    %edx,%ecx
  80065a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80065e:	48 98                	cltq   
  800660:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800664:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800668:	8b 00                	mov    (%rax),%eax
  80066a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80066f:	75 2c                	jne    80069d <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800671:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800675:	8b 00                	mov    (%rax),%eax
  800677:	48 98                	cltq   
  800679:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80067d:	48 83 c2 08          	add    $0x8,%rdx
  800681:	48 89 c6             	mov    %rax,%rsi
  800684:	48 89 d7             	mov    %rdx,%rdi
  800687:	48 b8 f8 1a 80 00 00 	movabs $0x801af8,%rax
  80068e:	00 00 00 
  800691:	ff d0                	callq  *%rax
        b->idx = 0;
  800693:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800697:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80069d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006a1:	8b 40 04             	mov    0x4(%rax),%eax
  8006a4:	8d 50 01             	lea    0x1(%rax),%edx
  8006a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ab:	89 50 04             	mov    %edx,0x4(%rax)
}
  8006ae:	c9                   	leaveq 
  8006af:	c3                   	retq   

00000000008006b0 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8006b0:	55                   	push   %rbp
  8006b1:	48 89 e5             	mov    %rsp,%rbp
  8006b4:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006bb:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006c2:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006c9:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006d0:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006d7:	48 8b 0a             	mov    (%rdx),%rcx
  8006da:	48 89 08             	mov    %rcx,(%rax)
  8006dd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006e1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006e5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006e9:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006ed:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006f4:	00 00 00 
    b.cnt = 0;
  8006f7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006fe:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800701:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800708:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80070f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800716:	48 89 c6             	mov    %rax,%rsi
  800719:	48 bf 37 06 80 00 00 	movabs $0x800637,%rdi
  800720:	00 00 00 
  800723:	48 b8 0f 0b 80 00 00 	movabs $0x800b0f,%rax
  80072a:	00 00 00 
  80072d:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80072f:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800735:	48 98                	cltq   
  800737:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80073e:	48 83 c2 08          	add    $0x8,%rdx
  800742:	48 89 c6             	mov    %rax,%rsi
  800745:	48 89 d7             	mov    %rdx,%rdi
  800748:	48 b8 f8 1a 80 00 00 	movabs $0x801af8,%rax
  80074f:	00 00 00 
  800752:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800754:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80075a:	c9                   	leaveq 
  80075b:	c3                   	retq   

000000000080075c <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80075c:	55                   	push   %rbp
  80075d:	48 89 e5             	mov    %rsp,%rbp
  800760:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800767:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80076e:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800775:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80077c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800783:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80078a:	84 c0                	test   %al,%al
  80078c:	74 20                	je     8007ae <cprintf+0x52>
  80078e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800792:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800796:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80079a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80079e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8007a2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8007a6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8007aa:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8007ae:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8007b5:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007bc:	00 00 00 
  8007bf:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007c6:	00 00 00 
  8007c9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007cd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007d4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007db:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007e2:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007e9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007f0:	48 8b 0a             	mov    (%rdx),%rcx
  8007f3:	48 89 08             	mov    %rcx,(%rax)
  8007f6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007fa:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007fe:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800802:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800806:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80080d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800814:	48 89 d6             	mov    %rdx,%rsi
  800817:	48 89 c7             	mov    %rax,%rdi
  80081a:	48 b8 b0 06 80 00 00 	movabs $0x8006b0,%rax
  800821:	00 00 00 
  800824:	ff d0                	callq  *%rax
  800826:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80082c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800832:	c9                   	leaveq 
  800833:	c3                   	retq   

0000000000800834 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800834:	55                   	push   %rbp
  800835:	48 89 e5             	mov    %rsp,%rbp
  800838:	53                   	push   %rbx
  800839:	48 83 ec 38          	sub    $0x38,%rsp
  80083d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800841:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800845:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800849:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80084c:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800850:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800854:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800857:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80085b:	77 3b                	ja     800898 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80085d:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800860:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800864:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800867:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80086b:	ba 00 00 00 00       	mov    $0x0,%edx
  800870:	48 f7 f3             	div    %rbx
  800873:	48 89 c2             	mov    %rax,%rdx
  800876:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800879:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80087c:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800880:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800884:	41 89 f9             	mov    %edi,%r9d
  800887:	48 89 c7             	mov    %rax,%rdi
  80088a:	48 b8 34 08 80 00 00 	movabs $0x800834,%rax
  800891:	00 00 00 
  800894:	ff d0                	callq  *%rax
  800896:	eb 1e                	jmp    8008b6 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800898:	eb 12                	jmp    8008ac <printnum+0x78>
			putch(padc, putdat);
  80089a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80089e:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8008a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a5:	48 89 ce             	mov    %rcx,%rsi
  8008a8:	89 d7                	mov    %edx,%edi
  8008aa:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008ac:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8008b0:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8008b4:	7f e4                	jg     80089a <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008b6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8008b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c2:	48 f7 f1             	div    %rcx
  8008c5:	48 89 d0             	mov    %rdx,%rax
  8008c8:	48 ba 50 49 80 00 00 	movabs $0x804950,%rdx
  8008cf:	00 00 00 
  8008d2:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008d6:	0f be d0             	movsbl %al,%edx
  8008d9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e1:	48 89 ce             	mov    %rcx,%rsi
  8008e4:	89 d7                	mov    %edx,%edi
  8008e6:	ff d0                	callq  *%rax
}
  8008e8:	48 83 c4 38          	add    $0x38,%rsp
  8008ec:	5b                   	pop    %rbx
  8008ed:	5d                   	pop    %rbp
  8008ee:	c3                   	retq   

00000000008008ef <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ef:	55                   	push   %rbp
  8008f0:	48 89 e5             	mov    %rsp,%rbp
  8008f3:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008fb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008fe:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800902:	7e 52                	jle    800956 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800904:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800908:	8b 00                	mov    (%rax),%eax
  80090a:	83 f8 30             	cmp    $0x30,%eax
  80090d:	73 24                	jae    800933 <getuint+0x44>
  80090f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800913:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091b:	8b 00                	mov    (%rax),%eax
  80091d:	89 c0                	mov    %eax,%eax
  80091f:	48 01 d0             	add    %rdx,%rax
  800922:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800926:	8b 12                	mov    (%rdx),%edx
  800928:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80092b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092f:	89 0a                	mov    %ecx,(%rdx)
  800931:	eb 17                	jmp    80094a <getuint+0x5b>
  800933:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800937:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80093b:	48 89 d0             	mov    %rdx,%rax
  80093e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800942:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800946:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80094a:	48 8b 00             	mov    (%rax),%rax
  80094d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800951:	e9 a3 00 00 00       	jmpq   8009f9 <getuint+0x10a>
	else if (lflag)
  800956:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80095a:	74 4f                	je     8009ab <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80095c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800960:	8b 00                	mov    (%rax),%eax
  800962:	83 f8 30             	cmp    $0x30,%eax
  800965:	73 24                	jae    80098b <getuint+0x9c>
  800967:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80096f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800973:	8b 00                	mov    (%rax),%eax
  800975:	89 c0                	mov    %eax,%eax
  800977:	48 01 d0             	add    %rdx,%rax
  80097a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097e:	8b 12                	mov    (%rdx),%edx
  800980:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800983:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800987:	89 0a                	mov    %ecx,(%rdx)
  800989:	eb 17                	jmp    8009a2 <getuint+0xb3>
  80098b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800993:	48 89 d0             	mov    %rdx,%rax
  800996:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80099a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009a2:	48 8b 00             	mov    (%rax),%rax
  8009a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009a9:	eb 4e                	jmp    8009f9 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8009ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009af:	8b 00                	mov    (%rax),%eax
  8009b1:	83 f8 30             	cmp    $0x30,%eax
  8009b4:	73 24                	jae    8009da <getuint+0xeb>
  8009b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ba:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c2:	8b 00                	mov    (%rax),%eax
  8009c4:	89 c0                	mov    %eax,%eax
  8009c6:	48 01 d0             	add    %rdx,%rax
  8009c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cd:	8b 12                	mov    (%rdx),%edx
  8009cf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d6:	89 0a                	mov    %ecx,(%rdx)
  8009d8:	eb 17                	jmp    8009f1 <getuint+0x102>
  8009da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009de:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009e2:	48 89 d0             	mov    %rdx,%rax
  8009e5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ed:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009f1:	8b 00                	mov    (%rax),%eax
  8009f3:	89 c0                	mov    %eax,%eax
  8009f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009fd:	c9                   	leaveq 
  8009fe:	c3                   	retq   

00000000008009ff <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009ff:	55                   	push   %rbp
  800a00:	48 89 e5             	mov    %rsp,%rbp
  800a03:	48 83 ec 1c          	sub    $0x1c,%rsp
  800a07:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a0b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a0e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a12:	7e 52                	jle    800a66 <getint+0x67>
		x=va_arg(*ap, long long);
  800a14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a18:	8b 00                	mov    (%rax),%eax
  800a1a:	83 f8 30             	cmp    $0x30,%eax
  800a1d:	73 24                	jae    800a43 <getint+0x44>
  800a1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a23:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2b:	8b 00                	mov    (%rax),%eax
  800a2d:	89 c0                	mov    %eax,%eax
  800a2f:	48 01 d0             	add    %rdx,%rax
  800a32:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a36:	8b 12                	mov    (%rdx),%edx
  800a38:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a3b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a3f:	89 0a                	mov    %ecx,(%rdx)
  800a41:	eb 17                	jmp    800a5a <getint+0x5b>
  800a43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a47:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a4b:	48 89 d0             	mov    %rdx,%rax
  800a4e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a52:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a56:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a5a:	48 8b 00             	mov    (%rax),%rax
  800a5d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a61:	e9 a3 00 00 00       	jmpq   800b09 <getint+0x10a>
	else if (lflag)
  800a66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a6a:	74 4f                	je     800abb <getint+0xbc>
		x=va_arg(*ap, long);
  800a6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a70:	8b 00                	mov    (%rax),%eax
  800a72:	83 f8 30             	cmp    $0x30,%eax
  800a75:	73 24                	jae    800a9b <getint+0x9c>
  800a77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a83:	8b 00                	mov    (%rax),%eax
  800a85:	89 c0                	mov    %eax,%eax
  800a87:	48 01 d0             	add    %rdx,%rax
  800a8a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a8e:	8b 12                	mov    (%rdx),%edx
  800a90:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a93:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a97:	89 0a                	mov    %ecx,(%rdx)
  800a99:	eb 17                	jmp    800ab2 <getint+0xb3>
  800a9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800aa3:	48 89 d0             	mov    %rdx,%rax
  800aa6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800aaa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aae:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ab2:	48 8b 00             	mov    (%rax),%rax
  800ab5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ab9:	eb 4e                	jmp    800b09 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800abb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800abf:	8b 00                	mov    (%rax),%eax
  800ac1:	83 f8 30             	cmp    $0x30,%eax
  800ac4:	73 24                	jae    800aea <getint+0xeb>
  800ac6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aca:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ace:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad2:	8b 00                	mov    (%rax),%eax
  800ad4:	89 c0                	mov    %eax,%eax
  800ad6:	48 01 d0             	add    %rdx,%rax
  800ad9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800add:	8b 12                	mov    (%rdx),%edx
  800adf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ae2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae6:	89 0a                	mov    %ecx,(%rdx)
  800ae8:	eb 17                	jmp    800b01 <getint+0x102>
  800aea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aee:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800af2:	48 89 d0             	mov    %rdx,%rax
  800af5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800af9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800afd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b01:	8b 00                	mov    (%rax),%eax
  800b03:	48 98                	cltq   
  800b05:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b0d:	c9                   	leaveq 
  800b0e:	c3                   	retq   

0000000000800b0f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b0f:	55                   	push   %rbp
  800b10:	48 89 e5             	mov    %rsp,%rbp
  800b13:	41 54                	push   %r12
  800b15:	53                   	push   %rbx
  800b16:	48 83 ec 60          	sub    $0x60,%rsp
  800b1a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b1e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b22:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b26:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b2a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b2e:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b32:	48 8b 0a             	mov    (%rdx),%rcx
  800b35:	48 89 08             	mov    %rcx,(%rax)
  800b38:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b3c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b40:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b44:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b48:	eb 17                	jmp    800b61 <vprintfmt+0x52>
			if (ch == '\0')
  800b4a:	85 db                	test   %ebx,%ebx
  800b4c:	0f 84 cc 04 00 00    	je     80101e <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800b52:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b56:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b5a:	48 89 d6             	mov    %rdx,%rsi
  800b5d:	89 df                	mov    %ebx,%edi
  800b5f:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b61:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b65:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b69:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b6d:	0f b6 00             	movzbl (%rax),%eax
  800b70:	0f b6 d8             	movzbl %al,%ebx
  800b73:	83 fb 25             	cmp    $0x25,%ebx
  800b76:	75 d2                	jne    800b4a <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b78:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b7c:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b83:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b8a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b91:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b98:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b9c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ba0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ba4:	0f b6 00             	movzbl (%rax),%eax
  800ba7:	0f b6 d8             	movzbl %al,%ebx
  800baa:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800bad:	83 f8 55             	cmp    $0x55,%eax
  800bb0:	0f 87 34 04 00 00    	ja     800fea <vprintfmt+0x4db>
  800bb6:	89 c0                	mov    %eax,%eax
  800bb8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800bbf:	00 
  800bc0:	48 b8 78 49 80 00 00 	movabs $0x804978,%rax
  800bc7:	00 00 00 
  800bca:	48 01 d0             	add    %rdx,%rax
  800bcd:	48 8b 00             	mov    (%rax),%rax
  800bd0:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800bd2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bd6:	eb c0                	jmp    800b98 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bd8:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bdc:	eb ba                	jmp    800b98 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bde:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800be5:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800be8:	89 d0                	mov    %edx,%eax
  800bea:	c1 e0 02             	shl    $0x2,%eax
  800bed:	01 d0                	add    %edx,%eax
  800bef:	01 c0                	add    %eax,%eax
  800bf1:	01 d8                	add    %ebx,%eax
  800bf3:	83 e8 30             	sub    $0x30,%eax
  800bf6:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bf9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bfd:	0f b6 00             	movzbl (%rax),%eax
  800c00:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c03:	83 fb 2f             	cmp    $0x2f,%ebx
  800c06:	7e 0c                	jle    800c14 <vprintfmt+0x105>
  800c08:	83 fb 39             	cmp    $0x39,%ebx
  800c0b:	7f 07                	jg     800c14 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c0d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c12:	eb d1                	jmp    800be5 <vprintfmt+0xd6>
			goto process_precision;
  800c14:	eb 58                	jmp    800c6e <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800c16:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c19:	83 f8 30             	cmp    $0x30,%eax
  800c1c:	73 17                	jae    800c35 <vprintfmt+0x126>
  800c1e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c22:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c25:	89 c0                	mov    %eax,%eax
  800c27:	48 01 d0             	add    %rdx,%rax
  800c2a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c2d:	83 c2 08             	add    $0x8,%edx
  800c30:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c33:	eb 0f                	jmp    800c44 <vprintfmt+0x135>
  800c35:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c39:	48 89 d0             	mov    %rdx,%rax
  800c3c:	48 83 c2 08          	add    $0x8,%rdx
  800c40:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c44:	8b 00                	mov    (%rax),%eax
  800c46:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c49:	eb 23                	jmp    800c6e <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800c4b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c4f:	79 0c                	jns    800c5d <vprintfmt+0x14e>
				width = 0;
  800c51:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c58:	e9 3b ff ff ff       	jmpq   800b98 <vprintfmt+0x89>
  800c5d:	e9 36 ff ff ff       	jmpq   800b98 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c62:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c69:	e9 2a ff ff ff       	jmpq   800b98 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c6e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c72:	79 12                	jns    800c86 <vprintfmt+0x177>
				width = precision, precision = -1;
  800c74:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c77:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c7a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c81:	e9 12 ff ff ff       	jmpq   800b98 <vprintfmt+0x89>
  800c86:	e9 0d ff ff ff       	jmpq   800b98 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c8b:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c8f:	e9 04 ff ff ff       	jmpq   800b98 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c94:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c97:	83 f8 30             	cmp    $0x30,%eax
  800c9a:	73 17                	jae    800cb3 <vprintfmt+0x1a4>
  800c9c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ca0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca3:	89 c0                	mov    %eax,%eax
  800ca5:	48 01 d0             	add    %rdx,%rax
  800ca8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cab:	83 c2 08             	add    $0x8,%edx
  800cae:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cb1:	eb 0f                	jmp    800cc2 <vprintfmt+0x1b3>
  800cb3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cb7:	48 89 d0             	mov    %rdx,%rax
  800cba:	48 83 c2 08          	add    $0x8,%rdx
  800cbe:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cc2:	8b 10                	mov    (%rax),%edx
  800cc4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cc8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ccc:	48 89 ce             	mov    %rcx,%rsi
  800ccf:	89 d7                	mov    %edx,%edi
  800cd1:	ff d0                	callq  *%rax
			break;
  800cd3:	e9 40 03 00 00       	jmpq   801018 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800cd8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cdb:	83 f8 30             	cmp    $0x30,%eax
  800cde:	73 17                	jae    800cf7 <vprintfmt+0x1e8>
  800ce0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ce4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce7:	89 c0                	mov    %eax,%eax
  800ce9:	48 01 d0             	add    %rdx,%rax
  800cec:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cef:	83 c2 08             	add    $0x8,%edx
  800cf2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cf5:	eb 0f                	jmp    800d06 <vprintfmt+0x1f7>
  800cf7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cfb:	48 89 d0             	mov    %rdx,%rax
  800cfe:	48 83 c2 08          	add    $0x8,%rdx
  800d02:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d06:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d08:	85 db                	test   %ebx,%ebx
  800d0a:	79 02                	jns    800d0e <vprintfmt+0x1ff>
				err = -err;
  800d0c:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d0e:	83 fb 15             	cmp    $0x15,%ebx
  800d11:	7f 16                	jg     800d29 <vprintfmt+0x21a>
  800d13:	48 b8 a0 48 80 00 00 	movabs $0x8048a0,%rax
  800d1a:	00 00 00 
  800d1d:	48 63 d3             	movslq %ebx,%rdx
  800d20:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d24:	4d 85 e4             	test   %r12,%r12
  800d27:	75 2e                	jne    800d57 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800d29:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d2d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d31:	89 d9                	mov    %ebx,%ecx
  800d33:	48 ba 61 49 80 00 00 	movabs $0x804961,%rdx
  800d3a:	00 00 00 
  800d3d:	48 89 c7             	mov    %rax,%rdi
  800d40:	b8 00 00 00 00       	mov    $0x0,%eax
  800d45:	49 b8 27 10 80 00 00 	movabs $0x801027,%r8
  800d4c:	00 00 00 
  800d4f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d52:	e9 c1 02 00 00       	jmpq   801018 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d57:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d5b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d5f:	4c 89 e1             	mov    %r12,%rcx
  800d62:	48 ba 6a 49 80 00 00 	movabs $0x80496a,%rdx
  800d69:	00 00 00 
  800d6c:	48 89 c7             	mov    %rax,%rdi
  800d6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d74:	49 b8 27 10 80 00 00 	movabs $0x801027,%r8
  800d7b:	00 00 00 
  800d7e:	41 ff d0             	callq  *%r8
			break;
  800d81:	e9 92 02 00 00       	jmpq   801018 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d86:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d89:	83 f8 30             	cmp    $0x30,%eax
  800d8c:	73 17                	jae    800da5 <vprintfmt+0x296>
  800d8e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d92:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d95:	89 c0                	mov    %eax,%eax
  800d97:	48 01 d0             	add    %rdx,%rax
  800d9a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d9d:	83 c2 08             	add    $0x8,%edx
  800da0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800da3:	eb 0f                	jmp    800db4 <vprintfmt+0x2a5>
  800da5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800da9:	48 89 d0             	mov    %rdx,%rax
  800dac:	48 83 c2 08          	add    $0x8,%rdx
  800db0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800db4:	4c 8b 20             	mov    (%rax),%r12
  800db7:	4d 85 e4             	test   %r12,%r12
  800dba:	75 0a                	jne    800dc6 <vprintfmt+0x2b7>
				p = "(null)";
  800dbc:	49 bc 6d 49 80 00 00 	movabs $0x80496d,%r12
  800dc3:	00 00 00 
			if (width > 0 && padc != '-')
  800dc6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dca:	7e 3f                	jle    800e0b <vprintfmt+0x2fc>
  800dcc:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800dd0:	74 39                	je     800e0b <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dd2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800dd5:	48 98                	cltq   
  800dd7:	48 89 c6             	mov    %rax,%rsi
  800dda:	4c 89 e7             	mov    %r12,%rdi
  800ddd:	48 b8 d3 12 80 00 00 	movabs $0x8012d3,%rax
  800de4:	00 00 00 
  800de7:	ff d0                	callq  *%rax
  800de9:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800dec:	eb 17                	jmp    800e05 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800dee:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800df2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800df6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dfa:	48 89 ce             	mov    %rcx,%rsi
  800dfd:	89 d7                	mov    %edx,%edi
  800dff:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e01:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e05:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e09:	7f e3                	jg     800dee <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e0b:	eb 37                	jmp    800e44 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800e0d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e11:	74 1e                	je     800e31 <vprintfmt+0x322>
  800e13:	83 fb 1f             	cmp    $0x1f,%ebx
  800e16:	7e 05                	jle    800e1d <vprintfmt+0x30e>
  800e18:	83 fb 7e             	cmp    $0x7e,%ebx
  800e1b:	7e 14                	jle    800e31 <vprintfmt+0x322>
					putch('?', putdat);
  800e1d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e25:	48 89 d6             	mov    %rdx,%rsi
  800e28:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e2d:	ff d0                	callq  *%rax
  800e2f:	eb 0f                	jmp    800e40 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800e31:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e35:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e39:	48 89 d6             	mov    %rdx,%rsi
  800e3c:	89 df                	mov    %ebx,%edi
  800e3e:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e40:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e44:	4c 89 e0             	mov    %r12,%rax
  800e47:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e4b:	0f b6 00             	movzbl (%rax),%eax
  800e4e:	0f be d8             	movsbl %al,%ebx
  800e51:	85 db                	test   %ebx,%ebx
  800e53:	74 10                	je     800e65 <vprintfmt+0x356>
  800e55:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e59:	78 b2                	js     800e0d <vprintfmt+0x2fe>
  800e5b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e5f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e63:	79 a8                	jns    800e0d <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e65:	eb 16                	jmp    800e7d <vprintfmt+0x36e>
				putch(' ', putdat);
  800e67:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e6b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e6f:	48 89 d6             	mov    %rdx,%rsi
  800e72:	bf 20 00 00 00       	mov    $0x20,%edi
  800e77:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e79:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e7d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e81:	7f e4                	jg     800e67 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800e83:	e9 90 01 00 00       	jmpq   801018 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e88:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e8c:	be 03 00 00 00       	mov    $0x3,%esi
  800e91:	48 89 c7             	mov    %rax,%rdi
  800e94:	48 b8 ff 09 80 00 00 	movabs $0x8009ff,%rax
  800e9b:	00 00 00 
  800e9e:	ff d0                	callq  *%rax
  800ea0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ea4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea8:	48 85 c0             	test   %rax,%rax
  800eab:	79 1d                	jns    800eca <vprintfmt+0x3bb>
				putch('-', putdat);
  800ead:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eb1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eb5:	48 89 d6             	mov    %rdx,%rsi
  800eb8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ebd:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ebf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec3:	48 f7 d8             	neg    %rax
  800ec6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800eca:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ed1:	e9 d5 00 00 00       	jmpq   800fab <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ed6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800eda:	be 03 00 00 00       	mov    $0x3,%esi
  800edf:	48 89 c7             	mov    %rax,%rdi
  800ee2:	48 b8 ef 08 80 00 00 	movabs $0x8008ef,%rax
  800ee9:	00 00 00 
  800eec:	ff d0                	callq  *%rax
  800eee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ef2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ef9:	e9 ad 00 00 00       	jmpq   800fab <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800efe:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f02:	be 03 00 00 00       	mov    $0x3,%esi
  800f07:	48 89 c7             	mov    %rax,%rdi
  800f0a:	48 b8 ef 08 80 00 00 	movabs $0x8008ef,%rax
  800f11:	00 00 00 
  800f14:	ff d0                	callq  *%rax
  800f16:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800f1a:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f21:	e9 85 00 00 00       	jmpq   800fab <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800f26:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f2e:	48 89 d6             	mov    %rdx,%rsi
  800f31:	bf 30 00 00 00       	mov    $0x30,%edi
  800f36:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f38:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f40:	48 89 d6             	mov    %rdx,%rsi
  800f43:	bf 78 00 00 00       	mov    $0x78,%edi
  800f48:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f4a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f4d:	83 f8 30             	cmp    $0x30,%eax
  800f50:	73 17                	jae    800f69 <vprintfmt+0x45a>
  800f52:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f56:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f59:	89 c0                	mov    %eax,%eax
  800f5b:	48 01 d0             	add    %rdx,%rax
  800f5e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f61:	83 c2 08             	add    $0x8,%edx
  800f64:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f67:	eb 0f                	jmp    800f78 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800f69:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f6d:	48 89 d0             	mov    %rdx,%rax
  800f70:	48 83 c2 08          	add    $0x8,%rdx
  800f74:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f78:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f7b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f7f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f86:	eb 23                	jmp    800fab <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f88:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f8c:	be 03 00 00 00       	mov    $0x3,%esi
  800f91:	48 89 c7             	mov    %rax,%rdi
  800f94:	48 b8 ef 08 80 00 00 	movabs $0x8008ef,%rax
  800f9b:	00 00 00 
  800f9e:	ff d0                	callq  *%rax
  800fa0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800fa4:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fab:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800fb0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800fb3:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fb6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fba:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fbe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fc2:	45 89 c1             	mov    %r8d,%r9d
  800fc5:	41 89 f8             	mov    %edi,%r8d
  800fc8:	48 89 c7             	mov    %rax,%rdi
  800fcb:	48 b8 34 08 80 00 00 	movabs $0x800834,%rax
  800fd2:	00 00 00 
  800fd5:	ff d0                	callq  *%rax
			break;
  800fd7:	eb 3f                	jmp    801018 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fd9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fdd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fe1:	48 89 d6             	mov    %rdx,%rsi
  800fe4:	89 df                	mov    %ebx,%edi
  800fe6:	ff d0                	callq  *%rax
			break;
  800fe8:	eb 2e                	jmp    801018 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fea:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ff2:	48 89 d6             	mov    %rdx,%rsi
  800ff5:	bf 25 00 00 00       	mov    $0x25,%edi
  800ffa:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ffc:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801001:	eb 05                	jmp    801008 <vprintfmt+0x4f9>
  801003:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801008:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80100c:	48 83 e8 01          	sub    $0x1,%rax
  801010:	0f b6 00             	movzbl (%rax),%eax
  801013:	3c 25                	cmp    $0x25,%al
  801015:	75 ec                	jne    801003 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  801017:	90                   	nop
		}
	}
  801018:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801019:	e9 43 fb ff ff       	jmpq   800b61 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80101e:	48 83 c4 60          	add    $0x60,%rsp
  801022:	5b                   	pop    %rbx
  801023:	41 5c                	pop    %r12
  801025:	5d                   	pop    %rbp
  801026:	c3                   	retq   

0000000000801027 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801027:	55                   	push   %rbp
  801028:	48 89 e5             	mov    %rsp,%rbp
  80102b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801032:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801039:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801040:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801047:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80104e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801055:	84 c0                	test   %al,%al
  801057:	74 20                	je     801079 <printfmt+0x52>
  801059:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80105d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801061:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801065:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801069:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80106d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801071:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801075:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801079:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801080:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801087:	00 00 00 
  80108a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801091:	00 00 00 
  801094:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801098:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80109f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010a6:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8010ad:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010b4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010bb:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010c2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010c9:	48 89 c7             	mov    %rax,%rdi
  8010cc:	48 b8 0f 0b 80 00 00 	movabs $0x800b0f,%rax
  8010d3:	00 00 00 
  8010d6:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010d8:	c9                   	leaveq 
  8010d9:	c3                   	retq   

00000000008010da <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010da:	55                   	push   %rbp
  8010db:	48 89 e5             	mov    %rsp,%rbp
  8010de:	48 83 ec 10          	sub    $0x10,%rsp
  8010e2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ed:	8b 40 10             	mov    0x10(%rax),%eax
  8010f0:	8d 50 01             	lea    0x1(%rax),%edx
  8010f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f7:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010fe:	48 8b 10             	mov    (%rax),%rdx
  801101:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801105:	48 8b 40 08          	mov    0x8(%rax),%rax
  801109:	48 39 c2             	cmp    %rax,%rdx
  80110c:	73 17                	jae    801125 <sprintputch+0x4b>
		*b->buf++ = ch;
  80110e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801112:	48 8b 00             	mov    (%rax),%rax
  801115:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801119:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80111d:	48 89 0a             	mov    %rcx,(%rdx)
  801120:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801123:	88 10                	mov    %dl,(%rax)
}
  801125:	c9                   	leaveq 
  801126:	c3                   	retq   

0000000000801127 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801127:	55                   	push   %rbp
  801128:	48 89 e5             	mov    %rsp,%rbp
  80112b:	48 83 ec 50          	sub    $0x50,%rsp
  80112f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801133:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801136:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80113a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80113e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801142:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801146:	48 8b 0a             	mov    (%rdx),%rcx
  801149:	48 89 08             	mov    %rcx,(%rax)
  80114c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801150:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801154:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801158:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80115c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801160:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801164:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801167:	48 98                	cltq   
  801169:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80116d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801171:	48 01 d0             	add    %rdx,%rax
  801174:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801178:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80117f:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801184:	74 06                	je     80118c <vsnprintf+0x65>
  801186:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80118a:	7f 07                	jg     801193 <vsnprintf+0x6c>
		return -E_INVAL;
  80118c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801191:	eb 2f                	jmp    8011c2 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801193:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801197:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80119b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80119f:	48 89 c6             	mov    %rax,%rsi
  8011a2:	48 bf da 10 80 00 00 	movabs $0x8010da,%rdi
  8011a9:	00 00 00 
  8011ac:	48 b8 0f 0b 80 00 00 	movabs $0x800b0f,%rax
  8011b3:	00 00 00 
  8011b6:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011bc:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011bf:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011c2:	c9                   	leaveq 
  8011c3:	c3                   	retq   

00000000008011c4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011c4:	55                   	push   %rbp
  8011c5:	48 89 e5             	mov    %rsp,%rbp
  8011c8:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011cf:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011d6:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011dc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011e3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011ea:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011f1:	84 c0                	test   %al,%al
  8011f3:	74 20                	je     801215 <snprintf+0x51>
  8011f5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011f9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011fd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801201:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801205:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801209:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80120d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801211:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801215:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80121c:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801223:	00 00 00 
  801226:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80122d:	00 00 00 
  801230:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801234:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80123b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801242:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801249:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801250:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801257:	48 8b 0a             	mov    (%rdx),%rcx
  80125a:	48 89 08             	mov    %rcx,(%rax)
  80125d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801261:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801265:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801269:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80126d:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801274:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80127b:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801281:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801288:	48 89 c7             	mov    %rax,%rdi
  80128b:	48 b8 27 11 80 00 00 	movabs $0x801127,%rax
  801292:	00 00 00 
  801295:	ff d0                	callq  *%rax
  801297:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80129d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8012a3:	c9                   	leaveq 
  8012a4:	c3                   	retq   

00000000008012a5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8012a5:	55                   	push   %rbp
  8012a6:	48 89 e5             	mov    %rsp,%rbp
  8012a9:	48 83 ec 18          	sub    $0x18,%rsp
  8012ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8012b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012b8:	eb 09                	jmp    8012c3 <strlen+0x1e>
		n++;
  8012ba:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012be:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c7:	0f b6 00             	movzbl (%rax),%eax
  8012ca:	84 c0                	test   %al,%al
  8012cc:	75 ec                	jne    8012ba <strlen+0x15>
		n++;
	return n;
  8012ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012d1:	c9                   	leaveq 
  8012d2:	c3                   	retq   

00000000008012d3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012d3:	55                   	push   %rbp
  8012d4:	48 89 e5             	mov    %rsp,%rbp
  8012d7:	48 83 ec 20          	sub    $0x20,%rsp
  8012db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012ea:	eb 0e                	jmp    8012fa <strnlen+0x27>
		n++;
  8012ec:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012f5:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012fa:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012ff:	74 0b                	je     80130c <strnlen+0x39>
  801301:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801305:	0f b6 00             	movzbl (%rax),%eax
  801308:	84 c0                	test   %al,%al
  80130a:	75 e0                	jne    8012ec <strnlen+0x19>
		n++;
	return n;
  80130c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80130f:	c9                   	leaveq 
  801310:	c3                   	retq   

0000000000801311 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801311:	55                   	push   %rbp
  801312:	48 89 e5             	mov    %rsp,%rbp
  801315:	48 83 ec 20          	sub    $0x20,%rsp
  801319:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80131d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801321:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801325:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801329:	90                   	nop
  80132a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801332:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801336:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80133a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80133e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801342:	0f b6 12             	movzbl (%rdx),%edx
  801345:	88 10                	mov    %dl,(%rax)
  801347:	0f b6 00             	movzbl (%rax),%eax
  80134a:	84 c0                	test   %al,%al
  80134c:	75 dc                	jne    80132a <strcpy+0x19>
		/* do nothing */;
	return ret;
  80134e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801352:	c9                   	leaveq 
  801353:	c3                   	retq   

0000000000801354 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801354:	55                   	push   %rbp
  801355:	48 89 e5             	mov    %rsp,%rbp
  801358:	48 83 ec 20          	sub    $0x20,%rsp
  80135c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801360:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801364:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801368:	48 89 c7             	mov    %rax,%rdi
  80136b:	48 b8 a5 12 80 00 00 	movabs $0x8012a5,%rax
  801372:	00 00 00 
  801375:	ff d0                	callq  *%rax
  801377:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80137a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80137d:	48 63 d0             	movslq %eax,%rdx
  801380:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801384:	48 01 c2             	add    %rax,%rdx
  801387:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80138b:	48 89 c6             	mov    %rax,%rsi
  80138e:	48 89 d7             	mov    %rdx,%rdi
  801391:	48 b8 11 13 80 00 00 	movabs $0x801311,%rax
  801398:	00 00 00 
  80139b:	ff d0                	callq  *%rax
	return dst;
  80139d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013a1:	c9                   	leaveq 
  8013a2:	c3                   	retq   

00000000008013a3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8013a3:	55                   	push   %rbp
  8013a4:	48 89 e5             	mov    %rsp,%rbp
  8013a7:	48 83 ec 28          	sub    $0x28,%rsp
  8013ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8013b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8013bf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013c6:	00 
  8013c7:	eb 2a                	jmp    8013f3 <strncpy+0x50>
		*dst++ = *src;
  8013c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013cd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013d1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013d5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013d9:	0f b6 12             	movzbl (%rdx),%edx
  8013dc:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013e2:	0f b6 00             	movzbl (%rax),%eax
  8013e5:	84 c0                	test   %al,%al
  8013e7:	74 05                	je     8013ee <strncpy+0x4b>
			src++;
  8013e9:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013ee:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013fb:	72 cc                	jb     8013c9 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801401:	c9                   	leaveq 
  801402:	c3                   	retq   

0000000000801403 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801403:	55                   	push   %rbp
  801404:	48 89 e5             	mov    %rsp,%rbp
  801407:	48 83 ec 28          	sub    $0x28,%rsp
  80140b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80140f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801413:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801417:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80141b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80141f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801424:	74 3d                	je     801463 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801426:	eb 1d                	jmp    801445 <strlcpy+0x42>
			*dst++ = *src++;
  801428:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80142c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801430:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801434:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801438:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80143c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801440:	0f b6 12             	movzbl (%rdx),%edx
  801443:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801445:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80144a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80144f:	74 0b                	je     80145c <strlcpy+0x59>
  801451:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801455:	0f b6 00             	movzbl (%rax),%eax
  801458:	84 c0                	test   %al,%al
  80145a:	75 cc                	jne    801428 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80145c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801460:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801463:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801467:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146b:	48 29 c2             	sub    %rax,%rdx
  80146e:	48 89 d0             	mov    %rdx,%rax
}
  801471:	c9                   	leaveq 
  801472:	c3                   	retq   

0000000000801473 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801473:	55                   	push   %rbp
  801474:	48 89 e5             	mov    %rsp,%rbp
  801477:	48 83 ec 10          	sub    $0x10,%rsp
  80147b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80147f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801483:	eb 0a                	jmp    80148f <strcmp+0x1c>
		p++, q++;
  801485:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80148a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80148f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801493:	0f b6 00             	movzbl (%rax),%eax
  801496:	84 c0                	test   %al,%al
  801498:	74 12                	je     8014ac <strcmp+0x39>
  80149a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149e:	0f b6 10             	movzbl (%rax),%edx
  8014a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a5:	0f b6 00             	movzbl (%rax),%eax
  8014a8:	38 c2                	cmp    %al,%dl
  8014aa:	74 d9                	je     801485 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b0:	0f b6 00             	movzbl (%rax),%eax
  8014b3:	0f b6 d0             	movzbl %al,%edx
  8014b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ba:	0f b6 00             	movzbl (%rax),%eax
  8014bd:	0f b6 c0             	movzbl %al,%eax
  8014c0:	29 c2                	sub    %eax,%edx
  8014c2:	89 d0                	mov    %edx,%eax
}
  8014c4:	c9                   	leaveq 
  8014c5:	c3                   	retq   

00000000008014c6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014c6:	55                   	push   %rbp
  8014c7:	48 89 e5             	mov    %rsp,%rbp
  8014ca:	48 83 ec 18          	sub    $0x18,%rsp
  8014ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014d6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014da:	eb 0f                	jmp    8014eb <strncmp+0x25>
		n--, p++, q++;
  8014dc:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014e1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014e6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014eb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014f0:	74 1d                	je     80150f <strncmp+0x49>
  8014f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f6:	0f b6 00             	movzbl (%rax),%eax
  8014f9:	84 c0                	test   %al,%al
  8014fb:	74 12                	je     80150f <strncmp+0x49>
  8014fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801501:	0f b6 10             	movzbl (%rax),%edx
  801504:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801508:	0f b6 00             	movzbl (%rax),%eax
  80150b:	38 c2                	cmp    %al,%dl
  80150d:	74 cd                	je     8014dc <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80150f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801514:	75 07                	jne    80151d <strncmp+0x57>
		return 0;
  801516:	b8 00 00 00 00       	mov    $0x0,%eax
  80151b:	eb 18                	jmp    801535 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80151d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801521:	0f b6 00             	movzbl (%rax),%eax
  801524:	0f b6 d0             	movzbl %al,%edx
  801527:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152b:	0f b6 00             	movzbl (%rax),%eax
  80152e:	0f b6 c0             	movzbl %al,%eax
  801531:	29 c2                	sub    %eax,%edx
  801533:	89 d0                	mov    %edx,%eax
}
  801535:	c9                   	leaveq 
  801536:	c3                   	retq   

0000000000801537 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801537:	55                   	push   %rbp
  801538:	48 89 e5             	mov    %rsp,%rbp
  80153b:	48 83 ec 0c          	sub    $0xc,%rsp
  80153f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801543:	89 f0                	mov    %esi,%eax
  801545:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801548:	eb 17                	jmp    801561 <strchr+0x2a>
		if (*s == c)
  80154a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154e:	0f b6 00             	movzbl (%rax),%eax
  801551:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801554:	75 06                	jne    80155c <strchr+0x25>
			return (char *) s;
  801556:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155a:	eb 15                	jmp    801571 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80155c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801561:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801565:	0f b6 00             	movzbl (%rax),%eax
  801568:	84 c0                	test   %al,%al
  80156a:	75 de                	jne    80154a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80156c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801571:	c9                   	leaveq 
  801572:	c3                   	retq   

0000000000801573 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801573:	55                   	push   %rbp
  801574:	48 89 e5             	mov    %rsp,%rbp
  801577:	48 83 ec 0c          	sub    $0xc,%rsp
  80157b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80157f:	89 f0                	mov    %esi,%eax
  801581:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801584:	eb 13                	jmp    801599 <strfind+0x26>
		if (*s == c)
  801586:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158a:	0f b6 00             	movzbl (%rax),%eax
  80158d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801590:	75 02                	jne    801594 <strfind+0x21>
			break;
  801592:	eb 10                	jmp    8015a4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801594:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801599:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80159d:	0f b6 00             	movzbl (%rax),%eax
  8015a0:	84 c0                	test   %al,%al
  8015a2:	75 e2                	jne    801586 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8015a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015a8:	c9                   	leaveq 
  8015a9:	c3                   	retq   

00000000008015aa <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8015aa:	55                   	push   %rbp
  8015ab:	48 89 e5             	mov    %rsp,%rbp
  8015ae:	48 83 ec 18          	sub    $0x18,%rsp
  8015b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015b6:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8015b9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8015bd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015c2:	75 06                	jne    8015ca <memset+0x20>
		return v;
  8015c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c8:	eb 69                	jmp    801633 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ce:	83 e0 03             	and    $0x3,%eax
  8015d1:	48 85 c0             	test   %rax,%rax
  8015d4:	75 48                	jne    80161e <memset+0x74>
  8015d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015da:	83 e0 03             	and    $0x3,%eax
  8015dd:	48 85 c0             	test   %rax,%rax
  8015e0:	75 3c                	jne    80161e <memset+0x74>
		c &= 0xFF;
  8015e2:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015e9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015ec:	c1 e0 18             	shl    $0x18,%eax
  8015ef:	89 c2                	mov    %eax,%edx
  8015f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015f4:	c1 e0 10             	shl    $0x10,%eax
  8015f7:	09 c2                	or     %eax,%edx
  8015f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015fc:	c1 e0 08             	shl    $0x8,%eax
  8015ff:	09 d0                	or     %edx,%eax
  801601:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801604:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801608:	48 c1 e8 02          	shr    $0x2,%rax
  80160c:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80160f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801613:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801616:	48 89 d7             	mov    %rdx,%rdi
  801619:	fc                   	cld    
  80161a:	f3 ab                	rep stos %eax,%es:(%rdi)
  80161c:	eb 11                	jmp    80162f <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80161e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801622:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801625:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801629:	48 89 d7             	mov    %rdx,%rdi
  80162c:	fc                   	cld    
  80162d:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80162f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801633:	c9                   	leaveq 
  801634:	c3                   	retq   

0000000000801635 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801635:	55                   	push   %rbp
  801636:	48 89 e5             	mov    %rsp,%rbp
  801639:	48 83 ec 28          	sub    $0x28,%rsp
  80163d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801641:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801645:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801649:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80164d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801651:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801655:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801659:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801661:	0f 83 88 00 00 00    	jae    8016ef <memmove+0xba>
  801667:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80166f:	48 01 d0             	add    %rdx,%rax
  801672:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801676:	76 77                	jbe    8016ef <memmove+0xba>
		s += n;
  801678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167c:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801680:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801684:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801688:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80168c:	83 e0 03             	and    $0x3,%eax
  80168f:	48 85 c0             	test   %rax,%rax
  801692:	75 3b                	jne    8016cf <memmove+0x9a>
  801694:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801698:	83 e0 03             	and    $0x3,%eax
  80169b:	48 85 c0             	test   %rax,%rax
  80169e:	75 2f                	jne    8016cf <memmove+0x9a>
  8016a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a4:	83 e0 03             	and    $0x3,%eax
  8016a7:	48 85 c0             	test   %rax,%rax
  8016aa:	75 23                	jne    8016cf <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8016ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b0:	48 83 e8 04          	sub    $0x4,%rax
  8016b4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016b8:	48 83 ea 04          	sub    $0x4,%rdx
  8016bc:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016c0:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016c4:	48 89 c7             	mov    %rax,%rdi
  8016c7:	48 89 d6             	mov    %rdx,%rsi
  8016ca:	fd                   	std    
  8016cb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016cd:	eb 1d                	jmp    8016ec <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016db:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e3:	48 89 d7             	mov    %rdx,%rdi
  8016e6:	48 89 c1             	mov    %rax,%rcx
  8016e9:	fd                   	std    
  8016ea:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016ec:	fc                   	cld    
  8016ed:	eb 57                	jmp    801746 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f3:	83 e0 03             	and    $0x3,%eax
  8016f6:	48 85 c0             	test   %rax,%rax
  8016f9:	75 36                	jne    801731 <memmove+0xfc>
  8016fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ff:	83 e0 03             	and    $0x3,%eax
  801702:	48 85 c0             	test   %rax,%rax
  801705:	75 2a                	jne    801731 <memmove+0xfc>
  801707:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170b:	83 e0 03             	and    $0x3,%eax
  80170e:	48 85 c0             	test   %rax,%rax
  801711:	75 1e                	jne    801731 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801713:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801717:	48 c1 e8 02          	shr    $0x2,%rax
  80171b:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80171e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801722:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801726:	48 89 c7             	mov    %rax,%rdi
  801729:	48 89 d6             	mov    %rdx,%rsi
  80172c:	fc                   	cld    
  80172d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80172f:	eb 15                	jmp    801746 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801731:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801735:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801739:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80173d:	48 89 c7             	mov    %rax,%rdi
  801740:	48 89 d6             	mov    %rdx,%rsi
  801743:	fc                   	cld    
  801744:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80174a:	c9                   	leaveq 
  80174b:	c3                   	retq   

000000000080174c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80174c:	55                   	push   %rbp
  80174d:	48 89 e5             	mov    %rsp,%rbp
  801750:	48 83 ec 18          	sub    $0x18,%rsp
  801754:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801758:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80175c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801760:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801764:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801768:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80176c:	48 89 ce             	mov    %rcx,%rsi
  80176f:	48 89 c7             	mov    %rax,%rdi
  801772:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  801779:	00 00 00 
  80177c:	ff d0                	callq  *%rax
}
  80177e:	c9                   	leaveq 
  80177f:	c3                   	retq   

0000000000801780 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801780:	55                   	push   %rbp
  801781:	48 89 e5             	mov    %rsp,%rbp
  801784:	48 83 ec 28          	sub    $0x28,%rsp
  801788:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80178c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801790:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801794:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801798:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80179c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017a0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8017a4:	eb 36                	jmp    8017dc <memcmp+0x5c>
		if (*s1 != *s2)
  8017a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017aa:	0f b6 10             	movzbl (%rax),%edx
  8017ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b1:	0f b6 00             	movzbl (%rax),%eax
  8017b4:	38 c2                	cmp    %al,%dl
  8017b6:	74 1a                	je     8017d2 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8017b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017bc:	0f b6 00             	movzbl (%rax),%eax
  8017bf:	0f b6 d0             	movzbl %al,%edx
  8017c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017c6:	0f b6 00             	movzbl (%rax),%eax
  8017c9:	0f b6 c0             	movzbl %al,%eax
  8017cc:	29 c2                	sub    %eax,%edx
  8017ce:	89 d0                	mov    %edx,%eax
  8017d0:	eb 20                	jmp    8017f2 <memcmp+0x72>
		s1++, s2++;
  8017d2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017d7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017e8:	48 85 c0             	test   %rax,%rax
  8017eb:	75 b9                	jne    8017a6 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f2:	c9                   	leaveq 
  8017f3:	c3                   	retq   

00000000008017f4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017f4:	55                   	push   %rbp
  8017f5:	48 89 e5             	mov    %rsp,%rbp
  8017f8:	48 83 ec 28          	sub    $0x28,%rsp
  8017fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801800:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801803:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801807:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80180f:	48 01 d0             	add    %rdx,%rax
  801812:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801816:	eb 15                	jmp    80182d <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801818:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80181c:	0f b6 10             	movzbl (%rax),%edx
  80181f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801822:	38 c2                	cmp    %al,%dl
  801824:	75 02                	jne    801828 <memfind+0x34>
			break;
  801826:	eb 0f                	jmp    801837 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801828:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80182d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801831:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801835:	72 e1                	jb     801818 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801837:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80183b:	c9                   	leaveq 
  80183c:	c3                   	retq   

000000000080183d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80183d:	55                   	push   %rbp
  80183e:	48 89 e5             	mov    %rsp,%rbp
  801841:	48 83 ec 34          	sub    $0x34,%rsp
  801845:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801849:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80184d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801850:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801857:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80185e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80185f:	eb 05                	jmp    801866 <strtol+0x29>
		s++;
  801861:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801866:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186a:	0f b6 00             	movzbl (%rax),%eax
  80186d:	3c 20                	cmp    $0x20,%al
  80186f:	74 f0                	je     801861 <strtol+0x24>
  801871:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801875:	0f b6 00             	movzbl (%rax),%eax
  801878:	3c 09                	cmp    $0x9,%al
  80187a:	74 e5                	je     801861 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80187c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801880:	0f b6 00             	movzbl (%rax),%eax
  801883:	3c 2b                	cmp    $0x2b,%al
  801885:	75 07                	jne    80188e <strtol+0x51>
		s++;
  801887:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80188c:	eb 17                	jmp    8018a5 <strtol+0x68>
	else if (*s == '-')
  80188e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801892:	0f b6 00             	movzbl (%rax),%eax
  801895:	3c 2d                	cmp    $0x2d,%al
  801897:	75 0c                	jne    8018a5 <strtol+0x68>
		s++, neg = 1;
  801899:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80189e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018a5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018a9:	74 06                	je     8018b1 <strtol+0x74>
  8018ab:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8018af:	75 28                	jne    8018d9 <strtol+0x9c>
  8018b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b5:	0f b6 00             	movzbl (%rax),%eax
  8018b8:	3c 30                	cmp    $0x30,%al
  8018ba:	75 1d                	jne    8018d9 <strtol+0x9c>
  8018bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c0:	48 83 c0 01          	add    $0x1,%rax
  8018c4:	0f b6 00             	movzbl (%rax),%eax
  8018c7:	3c 78                	cmp    $0x78,%al
  8018c9:	75 0e                	jne    8018d9 <strtol+0x9c>
		s += 2, base = 16;
  8018cb:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018d0:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018d7:	eb 2c                	jmp    801905 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018dd:	75 19                	jne    8018f8 <strtol+0xbb>
  8018df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e3:	0f b6 00             	movzbl (%rax),%eax
  8018e6:	3c 30                	cmp    $0x30,%al
  8018e8:	75 0e                	jne    8018f8 <strtol+0xbb>
		s++, base = 8;
  8018ea:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018ef:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018f6:	eb 0d                	jmp    801905 <strtol+0xc8>
	else if (base == 0)
  8018f8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018fc:	75 07                	jne    801905 <strtol+0xc8>
		base = 10;
  8018fe:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801905:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801909:	0f b6 00             	movzbl (%rax),%eax
  80190c:	3c 2f                	cmp    $0x2f,%al
  80190e:	7e 1d                	jle    80192d <strtol+0xf0>
  801910:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801914:	0f b6 00             	movzbl (%rax),%eax
  801917:	3c 39                	cmp    $0x39,%al
  801919:	7f 12                	jg     80192d <strtol+0xf0>
			dig = *s - '0';
  80191b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191f:	0f b6 00             	movzbl (%rax),%eax
  801922:	0f be c0             	movsbl %al,%eax
  801925:	83 e8 30             	sub    $0x30,%eax
  801928:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80192b:	eb 4e                	jmp    80197b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80192d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801931:	0f b6 00             	movzbl (%rax),%eax
  801934:	3c 60                	cmp    $0x60,%al
  801936:	7e 1d                	jle    801955 <strtol+0x118>
  801938:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193c:	0f b6 00             	movzbl (%rax),%eax
  80193f:	3c 7a                	cmp    $0x7a,%al
  801941:	7f 12                	jg     801955 <strtol+0x118>
			dig = *s - 'a' + 10;
  801943:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801947:	0f b6 00             	movzbl (%rax),%eax
  80194a:	0f be c0             	movsbl %al,%eax
  80194d:	83 e8 57             	sub    $0x57,%eax
  801950:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801953:	eb 26                	jmp    80197b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801955:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801959:	0f b6 00             	movzbl (%rax),%eax
  80195c:	3c 40                	cmp    $0x40,%al
  80195e:	7e 48                	jle    8019a8 <strtol+0x16b>
  801960:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801964:	0f b6 00             	movzbl (%rax),%eax
  801967:	3c 5a                	cmp    $0x5a,%al
  801969:	7f 3d                	jg     8019a8 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80196b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196f:	0f b6 00             	movzbl (%rax),%eax
  801972:	0f be c0             	movsbl %al,%eax
  801975:	83 e8 37             	sub    $0x37,%eax
  801978:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80197b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80197e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801981:	7c 02                	jl     801985 <strtol+0x148>
			break;
  801983:	eb 23                	jmp    8019a8 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801985:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80198a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80198d:	48 98                	cltq   
  80198f:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801994:	48 89 c2             	mov    %rax,%rdx
  801997:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80199a:	48 98                	cltq   
  80199c:	48 01 d0             	add    %rdx,%rax
  80199f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8019a3:	e9 5d ff ff ff       	jmpq   801905 <strtol+0xc8>

	if (endptr)
  8019a8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8019ad:	74 0b                	je     8019ba <strtol+0x17d>
		*endptr = (char *) s;
  8019af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019b3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8019b7:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8019ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019be:	74 09                	je     8019c9 <strtol+0x18c>
  8019c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019c4:	48 f7 d8             	neg    %rax
  8019c7:	eb 04                	jmp    8019cd <strtol+0x190>
  8019c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019cd:	c9                   	leaveq 
  8019ce:	c3                   	retq   

00000000008019cf <strstr>:

char * strstr(const char *in, const char *str)
{
  8019cf:	55                   	push   %rbp
  8019d0:	48 89 e5             	mov    %rsp,%rbp
  8019d3:	48 83 ec 30          	sub    $0x30,%rsp
  8019d7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019db:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8019df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019e3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019e7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019eb:	0f b6 00             	movzbl (%rax),%eax
  8019ee:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8019f1:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019f5:	75 06                	jne    8019fd <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8019f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019fb:	eb 6b                	jmp    801a68 <strstr+0x99>

	len = strlen(str);
  8019fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a01:	48 89 c7             	mov    %rax,%rdi
  801a04:	48 b8 a5 12 80 00 00 	movabs $0x8012a5,%rax
  801a0b:	00 00 00 
  801a0e:	ff d0                	callq  *%rax
  801a10:	48 98                	cltq   
  801a12:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801a16:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a1e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a22:	0f b6 00             	movzbl (%rax),%eax
  801a25:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801a28:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a2c:	75 07                	jne    801a35 <strstr+0x66>
				return (char *) 0;
  801a2e:	b8 00 00 00 00       	mov    $0x0,%eax
  801a33:	eb 33                	jmp    801a68 <strstr+0x99>
		} while (sc != c);
  801a35:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a39:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a3c:	75 d8                	jne    801a16 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801a3e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a42:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4a:	48 89 ce             	mov    %rcx,%rsi
  801a4d:	48 89 c7             	mov    %rax,%rdi
  801a50:	48 b8 c6 14 80 00 00 	movabs $0x8014c6,%rax
  801a57:	00 00 00 
  801a5a:	ff d0                	callq  *%rax
  801a5c:	85 c0                	test   %eax,%eax
  801a5e:	75 b6                	jne    801a16 <strstr+0x47>

	return (char *) (in - 1);
  801a60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a64:	48 83 e8 01          	sub    $0x1,%rax
}
  801a68:	c9                   	leaveq 
  801a69:	c3                   	retq   

0000000000801a6a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801a6a:	55                   	push   %rbp
  801a6b:	48 89 e5             	mov    %rsp,%rbp
  801a6e:	53                   	push   %rbx
  801a6f:	48 83 ec 48          	sub    $0x48,%rsp
  801a73:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801a76:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801a79:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a7d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801a81:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801a85:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a89:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a8c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801a90:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801a94:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801a98:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801a9c:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801aa0:	4c 89 c3             	mov    %r8,%rbx
  801aa3:	cd 30                	int    $0x30
  801aa5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801aa9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801aad:	74 3e                	je     801aed <syscall+0x83>
  801aaf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ab4:	7e 37                	jle    801aed <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801ab6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801aba:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801abd:	49 89 d0             	mov    %rdx,%r8
  801ac0:	89 c1                	mov    %eax,%ecx
  801ac2:	48 ba 28 4c 80 00 00 	movabs $0x804c28,%rdx
  801ac9:	00 00 00 
  801acc:	be 24 00 00 00       	mov    $0x24,%esi
  801ad1:	48 bf 45 4c 80 00 00 	movabs $0x804c45,%rdi
  801ad8:	00 00 00 
  801adb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae0:	49 b9 68 41 80 00 00 	movabs $0x804168,%r9
  801ae7:	00 00 00 
  801aea:	41 ff d1             	callq  *%r9

	return ret;
  801aed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801af1:	48 83 c4 48          	add    $0x48,%rsp
  801af5:	5b                   	pop    %rbx
  801af6:	5d                   	pop    %rbp
  801af7:	c3                   	retq   

0000000000801af8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801af8:	55                   	push   %rbp
  801af9:	48 89 e5             	mov    %rsp,%rbp
  801afc:	48 83 ec 20          	sub    $0x20,%rsp
  801b00:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b04:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801b08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b0c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b10:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b17:	00 
  801b18:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b1e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b24:	48 89 d1             	mov    %rdx,%rcx
  801b27:	48 89 c2             	mov    %rax,%rdx
  801b2a:	be 00 00 00 00       	mov    $0x0,%esi
  801b2f:	bf 00 00 00 00       	mov    $0x0,%edi
  801b34:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  801b3b:	00 00 00 
  801b3e:	ff d0                	callq  *%rax
}
  801b40:	c9                   	leaveq 
  801b41:	c3                   	retq   

0000000000801b42 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b42:	55                   	push   %rbp
  801b43:	48 89 e5             	mov    %rsp,%rbp
  801b46:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801b4a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b51:	00 
  801b52:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b58:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b5e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b63:	ba 00 00 00 00       	mov    $0x0,%edx
  801b68:	be 00 00 00 00       	mov    $0x0,%esi
  801b6d:	bf 01 00 00 00       	mov    $0x1,%edi
  801b72:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  801b79:	00 00 00 
  801b7c:	ff d0                	callq  *%rax
}
  801b7e:	c9                   	leaveq 
  801b7f:	c3                   	retq   

0000000000801b80 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801b80:	55                   	push   %rbp
  801b81:	48 89 e5             	mov    %rsp,%rbp
  801b84:	48 83 ec 10          	sub    $0x10,%rsp
  801b88:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801b8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b8e:	48 98                	cltq   
  801b90:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b97:	00 
  801b98:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b9e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ba4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ba9:	48 89 c2             	mov    %rax,%rdx
  801bac:	be 01 00 00 00       	mov    $0x1,%esi
  801bb1:	bf 03 00 00 00       	mov    $0x3,%edi
  801bb6:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  801bbd:	00 00 00 
  801bc0:	ff d0                	callq  *%rax
}
  801bc2:	c9                   	leaveq 
  801bc3:	c3                   	retq   

0000000000801bc4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801bc4:	55                   	push   %rbp
  801bc5:	48 89 e5             	mov    %rsp,%rbp
  801bc8:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801bcc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd3:	00 
  801bd4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bda:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801be0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801be5:	ba 00 00 00 00       	mov    $0x0,%edx
  801bea:	be 00 00 00 00       	mov    $0x0,%esi
  801bef:	bf 02 00 00 00       	mov    $0x2,%edi
  801bf4:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  801bfb:	00 00 00 
  801bfe:	ff d0                	callq  *%rax
}
  801c00:	c9                   	leaveq 
  801c01:	c3                   	retq   

0000000000801c02 <sys_yield>:


void
sys_yield(void)
{
  801c02:	55                   	push   %rbp
  801c03:	48 89 e5             	mov    %rsp,%rbp
  801c06:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801c0a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c11:	00 
  801c12:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c18:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c23:	ba 00 00 00 00       	mov    $0x0,%edx
  801c28:	be 00 00 00 00       	mov    $0x0,%esi
  801c2d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801c32:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  801c39:	00 00 00 
  801c3c:	ff d0                	callq  *%rax
}
  801c3e:	c9                   	leaveq 
  801c3f:	c3                   	retq   

0000000000801c40 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801c40:	55                   	push   %rbp
  801c41:	48 89 e5             	mov    %rsp,%rbp
  801c44:	48 83 ec 20          	sub    $0x20,%rsp
  801c48:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c4b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c4f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801c52:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c55:	48 63 c8             	movslq %eax,%rcx
  801c58:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c5f:	48 98                	cltq   
  801c61:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c68:	00 
  801c69:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c6f:	49 89 c8             	mov    %rcx,%r8
  801c72:	48 89 d1             	mov    %rdx,%rcx
  801c75:	48 89 c2             	mov    %rax,%rdx
  801c78:	be 01 00 00 00       	mov    $0x1,%esi
  801c7d:	bf 04 00 00 00       	mov    $0x4,%edi
  801c82:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  801c89:	00 00 00 
  801c8c:	ff d0                	callq  *%rax
}
  801c8e:	c9                   	leaveq 
  801c8f:	c3                   	retq   

0000000000801c90 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801c90:	55                   	push   %rbp
  801c91:	48 89 e5             	mov    %rsp,%rbp
  801c94:	48 83 ec 30          	sub    $0x30,%rsp
  801c98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c9f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ca2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ca6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801caa:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801cad:	48 63 c8             	movslq %eax,%rcx
  801cb0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801cb4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cb7:	48 63 f0             	movslq %eax,%rsi
  801cba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cc1:	48 98                	cltq   
  801cc3:	48 89 0c 24          	mov    %rcx,(%rsp)
  801cc7:	49 89 f9             	mov    %rdi,%r9
  801cca:	49 89 f0             	mov    %rsi,%r8
  801ccd:	48 89 d1             	mov    %rdx,%rcx
  801cd0:	48 89 c2             	mov    %rax,%rdx
  801cd3:	be 01 00 00 00       	mov    $0x1,%esi
  801cd8:	bf 05 00 00 00       	mov    $0x5,%edi
  801cdd:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  801ce4:	00 00 00 
  801ce7:	ff d0                	callq  *%rax
}
  801ce9:	c9                   	leaveq 
  801cea:	c3                   	retq   

0000000000801ceb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801ceb:	55                   	push   %rbp
  801cec:	48 89 e5             	mov    %rsp,%rbp
  801cef:	48 83 ec 20          	sub    $0x20,%rsp
  801cf3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cf6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801cfa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d01:	48 98                	cltq   
  801d03:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d0a:	00 
  801d0b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d11:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d17:	48 89 d1             	mov    %rdx,%rcx
  801d1a:	48 89 c2             	mov    %rax,%rdx
  801d1d:	be 01 00 00 00       	mov    $0x1,%esi
  801d22:	bf 06 00 00 00       	mov    $0x6,%edi
  801d27:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  801d2e:	00 00 00 
  801d31:	ff d0                	callq  *%rax
}
  801d33:	c9                   	leaveq 
  801d34:	c3                   	retq   

0000000000801d35 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801d35:	55                   	push   %rbp
  801d36:	48 89 e5             	mov    %rsp,%rbp
  801d39:	48 83 ec 10          	sub    $0x10,%rsp
  801d3d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d40:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801d43:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d46:	48 63 d0             	movslq %eax,%rdx
  801d49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d4c:	48 98                	cltq   
  801d4e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d55:	00 
  801d56:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d5c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d62:	48 89 d1             	mov    %rdx,%rcx
  801d65:	48 89 c2             	mov    %rax,%rdx
  801d68:	be 01 00 00 00       	mov    $0x1,%esi
  801d6d:	bf 08 00 00 00       	mov    $0x8,%edi
  801d72:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  801d79:	00 00 00 
  801d7c:	ff d0                	callq  *%rax
}
  801d7e:	c9                   	leaveq 
  801d7f:	c3                   	retq   

0000000000801d80 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801d80:	55                   	push   %rbp
  801d81:	48 89 e5             	mov    %rsp,%rbp
  801d84:	48 83 ec 20          	sub    $0x20,%rsp
  801d88:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d8b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801d8f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d96:	48 98                	cltq   
  801d98:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d9f:	00 
  801da0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801da6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dac:	48 89 d1             	mov    %rdx,%rcx
  801daf:	48 89 c2             	mov    %rax,%rdx
  801db2:	be 01 00 00 00       	mov    $0x1,%esi
  801db7:	bf 09 00 00 00       	mov    $0x9,%edi
  801dbc:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  801dc3:	00 00 00 
  801dc6:	ff d0                	callq  *%rax
}
  801dc8:	c9                   	leaveq 
  801dc9:	c3                   	retq   

0000000000801dca <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801dca:	55                   	push   %rbp
  801dcb:	48 89 e5             	mov    %rsp,%rbp
  801dce:	48 83 ec 20          	sub    $0x20,%rsp
  801dd2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dd5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801dd9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ddd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801de0:	48 98                	cltq   
  801de2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801de9:	00 
  801dea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801df0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801df6:	48 89 d1             	mov    %rdx,%rcx
  801df9:	48 89 c2             	mov    %rax,%rdx
  801dfc:	be 01 00 00 00       	mov    $0x1,%esi
  801e01:	bf 0a 00 00 00       	mov    $0xa,%edi
  801e06:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  801e0d:	00 00 00 
  801e10:	ff d0                	callq  *%rax
}
  801e12:	c9                   	leaveq 
  801e13:	c3                   	retq   

0000000000801e14 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801e14:	55                   	push   %rbp
  801e15:	48 89 e5             	mov    %rsp,%rbp
  801e18:	48 83 ec 20          	sub    $0x20,%rsp
  801e1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e1f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e23:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801e27:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801e2a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e2d:	48 63 f0             	movslq %eax,%rsi
  801e30:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e37:	48 98                	cltq   
  801e39:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e3d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e44:	00 
  801e45:	49 89 f1             	mov    %rsi,%r9
  801e48:	49 89 c8             	mov    %rcx,%r8
  801e4b:	48 89 d1             	mov    %rdx,%rcx
  801e4e:	48 89 c2             	mov    %rax,%rdx
  801e51:	be 00 00 00 00       	mov    $0x0,%esi
  801e56:	bf 0c 00 00 00       	mov    $0xc,%edi
  801e5b:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  801e62:	00 00 00 
  801e65:	ff d0                	callq  *%rax
}
  801e67:	c9                   	leaveq 
  801e68:	c3                   	retq   

0000000000801e69 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801e69:	55                   	push   %rbp
  801e6a:	48 89 e5             	mov    %rsp,%rbp
  801e6d:	48 83 ec 10          	sub    $0x10,%rsp
  801e71:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801e75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e80:	00 
  801e81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e8d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e92:	48 89 c2             	mov    %rax,%rdx
  801e95:	be 01 00 00 00       	mov    $0x1,%esi
  801e9a:	bf 0d 00 00 00       	mov    $0xd,%edi
  801e9f:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  801ea6:	00 00 00 
  801ea9:	ff d0                	callq  *%rax
}
  801eab:	c9                   	leaveq 
  801eac:	c3                   	retq   

0000000000801ead <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801ead:	55                   	push   %rbp
  801eae:	48 89 e5             	mov    %rsp,%rbp
  801eb1:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801eb5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ebc:	00 
  801ebd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ec3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ec9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ece:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed3:	be 00 00 00 00       	mov    $0x0,%esi
  801ed8:	bf 0e 00 00 00       	mov    $0xe,%edi
  801edd:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  801ee4:	00 00 00 
  801ee7:	ff d0                	callq  *%rax
}
  801ee9:	c9                   	leaveq 
  801eea:	c3                   	retq   

0000000000801eeb <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801eeb:	55                   	push   %rbp
  801eec:	48 89 e5             	mov    %rsp,%rbp
  801eef:	48 83 ec 20          	sub    $0x20,%rsp
  801ef3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ef7:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801efa:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801efd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f01:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f08:	00 
  801f09:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f0f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f15:	48 89 d1             	mov    %rdx,%rcx
  801f18:	48 89 c2             	mov    %rax,%rdx
  801f1b:	be 00 00 00 00       	mov    $0x0,%esi
  801f20:	bf 0f 00 00 00       	mov    $0xf,%edi
  801f25:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  801f2c:	00 00 00 
  801f2f:	ff d0                	callq  *%rax
}
  801f31:	c9                   	leaveq 
  801f32:	c3                   	retq   

0000000000801f33 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801f33:	55                   	push   %rbp
  801f34:	48 89 e5             	mov    %rsp,%rbp
  801f37:	48 83 ec 20          	sub    $0x20,%rsp
  801f3b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f3f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801f42:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801f45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f49:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f50:	00 
  801f51:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f57:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f5d:	48 89 d1             	mov    %rdx,%rcx
  801f60:	48 89 c2             	mov    %rax,%rdx
  801f63:	be 00 00 00 00       	mov    $0x0,%esi
  801f68:	bf 10 00 00 00       	mov    $0x10,%edi
  801f6d:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  801f74:	00 00 00 
  801f77:	ff d0                	callq  *%rax
}
  801f79:	c9                   	leaveq 
  801f7a:	c3                   	retq   

0000000000801f7b <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801f7b:	55                   	push   %rbp
  801f7c:	48 89 e5             	mov    %rsp,%rbp
  801f7f:	48 83 ec 30          	sub    $0x30,%rsp
  801f83:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f86:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f8a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801f8d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801f91:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801f95:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801f98:	48 63 c8             	movslq %eax,%rcx
  801f9b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801f9f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fa2:	48 63 f0             	movslq %eax,%rsi
  801fa5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fa9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fac:	48 98                	cltq   
  801fae:	48 89 0c 24          	mov    %rcx,(%rsp)
  801fb2:	49 89 f9             	mov    %rdi,%r9
  801fb5:	49 89 f0             	mov    %rsi,%r8
  801fb8:	48 89 d1             	mov    %rdx,%rcx
  801fbb:	48 89 c2             	mov    %rax,%rdx
  801fbe:	be 00 00 00 00       	mov    $0x0,%esi
  801fc3:	bf 11 00 00 00       	mov    $0x11,%edi
  801fc8:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  801fcf:	00 00 00 
  801fd2:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801fd4:	c9                   	leaveq 
  801fd5:	c3                   	retq   

0000000000801fd6 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801fd6:	55                   	push   %rbp
  801fd7:	48 89 e5             	mov    %rsp,%rbp
  801fda:	48 83 ec 20          	sub    $0x20,%rsp
  801fde:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801fe2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801fe6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fee:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ff5:	00 
  801ff6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ffc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802002:	48 89 d1             	mov    %rdx,%rcx
  802005:	48 89 c2             	mov    %rax,%rdx
  802008:	be 00 00 00 00       	mov    $0x0,%esi
  80200d:	bf 12 00 00 00       	mov    $0x12,%edi
  802012:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  802019:	00 00 00 
  80201c:	ff d0                	callq  *%rax
}
  80201e:	c9                   	leaveq 
  80201f:	c3                   	retq   

0000000000802020 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802020:	55                   	push   %rbp
  802021:	48 89 e5             	mov    %rsp,%rbp
  802024:	48 83 ec 08          	sub    $0x8,%rsp
  802028:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80202c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802030:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802037:	ff ff ff 
  80203a:	48 01 d0             	add    %rdx,%rax
  80203d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802041:	c9                   	leaveq 
  802042:	c3                   	retq   

0000000000802043 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802043:	55                   	push   %rbp
  802044:	48 89 e5             	mov    %rsp,%rbp
  802047:	48 83 ec 08          	sub    $0x8,%rsp
  80204b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80204f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802053:	48 89 c7             	mov    %rax,%rdi
  802056:	48 b8 20 20 80 00 00 	movabs $0x802020,%rax
  80205d:	00 00 00 
  802060:	ff d0                	callq  *%rax
  802062:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802068:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80206c:	c9                   	leaveq 
  80206d:	c3                   	retq   

000000000080206e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80206e:	55                   	push   %rbp
  80206f:	48 89 e5             	mov    %rsp,%rbp
  802072:	48 83 ec 18          	sub    $0x18,%rsp
  802076:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80207a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802081:	eb 6b                	jmp    8020ee <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802083:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802086:	48 98                	cltq   
  802088:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80208e:	48 c1 e0 0c          	shl    $0xc,%rax
  802092:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802096:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80209a:	48 c1 e8 15          	shr    $0x15,%rax
  80209e:	48 89 c2             	mov    %rax,%rdx
  8020a1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020a8:	01 00 00 
  8020ab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020af:	83 e0 01             	and    $0x1,%eax
  8020b2:	48 85 c0             	test   %rax,%rax
  8020b5:	74 21                	je     8020d8 <fd_alloc+0x6a>
  8020b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020bb:	48 c1 e8 0c          	shr    $0xc,%rax
  8020bf:	48 89 c2             	mov    %rax,%rdx
  8020c2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020c9:	01 00 00 
  8020cc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020d0:	83 e0 01             	and    $0x1,%eax
  8020d3:	48 85 c0             	test   %rax,%rax
  8020d6:	75 12                	jne    8020ea <fd_alloc+0x7c>
			*fd_store = fd;
  8020d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020e0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8020e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e8:	eb 1a                	jmp    802104 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8020ea:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020ee:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020f2:	7e 8f                	jle    802083 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8020f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8020ff:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802104:	c9                   	leaveq 
  802105:	c3                   	retq   

0000000000802106 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802106:	55                   	push   %rbp
  802107:	48 89 e5             	mov    %rsp,%rbp
  80210a:	48 83 ec 20          	sub    $0x20,%rsp
  80210e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802111:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802115:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802119:	78 06                	js     802121 <fd_lookup+0x1b>
  80211b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80211f:	7e 07                	jle    802128 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802121:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802126:	eb 6c                	jmp    802194 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802128:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80212b:	48 98                	cltq   
  80212d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802133:	48 c1 e0 0c          	shl    $0xc,%rax
  802137:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80213b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80213f:	48 c1 e8 15          	shr    $0x15,%rax
  802143:	48 89 c2             	mov    %rax,%rdx
  802146:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80214d:	01 00 00 
  802150:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802154:	83 e0 01             	and    $0x1,%eax
  802157:	48 85 c0             	test   %rax,%rax
  80215a:	74 21                	je     80217d <fd_lookup+0x77>
  80215c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802160:	48 c1 e8 0c          	shr    $0xc,%rax
  802164:	48 89 c2             	mov    %rax,%rdx
  802167:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80216e:	01 00 00 
  802171:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802175:	83 e0 01             	and    $0x1,%eax
  802178:	48 85 c0             	test   %rax,%rax
  80217b:	75 07                	jne    802184 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80217d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802182:	eb 10                	jmp    802194 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802184:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802188:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80218c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80218f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802194:	c9                   	leaveq 
  802195:	c3                   	retq   

0000000000802196 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802196:	55                   	push   %rbp
  802197:	48 89 e5             	mov    %rsp,%rbp
  80219a:	48 83 ec 30          	sub    $0x30,%rsp
  80219e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8021a2:	89 f0                	mov    %esi,%eax
  8021a4:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8021a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ab:	48 89 c7             	mov    %rax,%rdi
  8021ae:	48 b8 20 20 80 00 00 	movabs $0x802020,%rax
  8021b5:	00 00 00 
  8021b8:	ff d0                	callq  *%rax
  8021ba:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021be:	48 89 d6             	mov    %rdx,%rsi
  8021c1:	89 c7                	mov    %eax,%edi
  8021c3:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  8021ca:	00 00 00 
  8021cd:	ff d0                	callq  *%rax
  8021cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021d6:	78 0a                	js     8021e2 <fd_close+0x4c>
	    || fd != fd2)
  8021d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021dc:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8021e0:	74 12                	je     8021f4 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8021e2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8021e6:	74 05                	je     8021ed <fd_close+0x57>
  8021e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021eb:	eb 05                	jmp    8021f2 <fd_close+0x5c>
  8021ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f2:	eb 69                	jmp    80225d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8021f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021f8:	8b 00                	mov    (%rax),%eax
  8021fa:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021fe:	48 89 d6             	mov    %rdx,%rsi
  802201:	89 c7                	mov    %eax,%edi
  802203:	48 b8 5f 22 80 00 00 	movabs $0x80225f,%rax
  80220a:	00 00 00 
  80220d:	ff d0                	callq  *%rax
  80220f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802212:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802216:	78 2a                	js     802242 <fd_close+0xac>
		if (dev->dev_close)
  802218:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80221c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802220:	48 85 c0             	test   %rax,%rax
  802223:	74 16                	je     80223b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802225:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802229:	48 8b 40 20          	mov    0x20(%rax),%rax
  80222d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802231:	48 89 d7             	mov    %rdx,%rdi
  802234:	ff d0                	callq  *%rax
  802236:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802239:	eb 07                	jmp    802242 <fd_close+0xac>
		else
			r = 0;
  80223b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802242:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802246:	48 89 c6             	mov    %rax,%rsi
  802249:	bf 00 00 00 00       	mov    $0x0,%edi
  80224e:	48 b8 eb 1c 80 00 00 	movabs $0x801ceb,%rax
  802255:	00 00 00 
  802258:	ff d0                	callq  *%rax
	return r;
  80225a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80225d:	c9                   	leaveq 
  80225e:	c3                   	retq   

000000000080225f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80225f:	55                   	push   %rbp
  802260:	48 89 e5             	mov    %rsp,%rbp
  802263:	48 83 ec 20          	sub    $0x20,%rsp
  802267:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80226a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80226e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802275:	eb 41                	jmp    8022b8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802277:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80227e:	00 00 00 
  802281:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802284:	48 63 d2             	movslq %edx,%rdx
  802287:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80228b:	8b 00                	mov    (%rax),%eax
  80228d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802290:	75 22                	jne    8022b4 <dev_lookup+0x55>
			*dev = devtab[i];
  802292:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802299:	00 00 00 
  80229c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80229f:	48 63 d2             	movslq %edx,%rdx
  8022a2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8022a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022aa:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8022ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b2:	eb 60                	jmp    802314 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8022b4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8022b8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8022bf:	00 00 00 
  8022c2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022c5:	48 63 d2             	movslq %edx,%rdx
  8022c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022cc:	48 85 c0             	test   %rax,%rax
  8022cf:	75 a6                	jne    802277 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8022d1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022d8:	00 00 00 
  8022db:	48 8b 00             	mov    (%rax),%rax
  8022de:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022e4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8022e7:	89 c6                	mov    %eax,%esi
  8022e9:	48 bf 58 4c 80 00 00 	movabs $0x804c58,%rdi
  8022f0:	00 00 00 
  8022f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f8:	48 b9 5c 07 80 00 00 	movabs $0x80075c,%rcx
  8022ff:	00 00 00 
  802302:	ff d1                	callq  *%rcx
	*dev = 0;
  802304:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802308:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80230f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802314:	c9                   	leaveq 
  802315:	c3                   	retq   

0000000000802316 <close>:

int
close(int fdnum)
{
  802316:	55                   	push   %rbp
  802317:	48 89 e5             	mov    %rsp,%rbp
  80231a:	48 83 ec 20          	sub    $0x20,%rsp
  80231e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802321:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802325:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802328:	48 89 d6             	mov    %rdx,%rsi
  80232b:	89 c7                	mov    %eax,%edi
  80232d:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  802334:	00 00 00 
  802337:	ff d0                	callq  *%rax
  802339:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80233c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802340:	79 05                	jns    802347 <close+0x31>
		return r;
  802342:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802345:	eb 18                	jmp    80235f <close+0x49>
	else
		return fd_close(fd, 1);
  802347:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80234b:	be 01 00 00 00       	mov    $0x1,%esi
  802350:	48 89 c7             	mov    %rax,%rdi
  802353:	48 b8 96 21 80 00 00 	movabs $0x802196,%rax
  80235a:	00 00 00 
  80235d:	ff d0                	callq  *%rax
}
  80235f:	c9                   	leaveq 
  802360:	c3                   	retq   

0000000000802361 <close_all>:

void
close_all(void)
{
  802361:	55                   	push   %rbp
  802362:	48 89 e5             	mov    %rsp,%rbp
  802365:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802369:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802370:	eb 15                	jmp    802387 <close_all+0x26>
		close(i);
  802372:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802375:	89 c7                	mov    %eax,%edi
  802377:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  80237e:	00 00 00 
  802381:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802383:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802387:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80238b:	7e e5                	jle    802372 <close_all+0x11>
		close(i);
}
  80238d:	c9                   	leaveq 
  80238e:	c3                   	retq   

000000000080238f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80238f:	55                   	push   %rbp
  802390:	48 89 e5             	mov    %rsp,%rbp
  802393:	48 83 ec 40          	sub    $0x40,%rsp
  802397:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80239a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80239d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8023a1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8023a4:	48 89 d6             	mov    %rdx,%rsi
  8023a7:	89 c7                	mov    %eax,%edi
  8023a9:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  8023b0:	00 00 00 
  8023b3:	ff d0                	callq  *%rax
  8023b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023bc:	79 08                	jns    8023c6 <dup+0x37>
		return r;
  8023be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023c1:	e9 70 01 00 00       	jmpq   802536 <dup+0x1a7>
	close(newfdnum);
  8023c6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023c9:	89 c7                	mov    %eax,%edi
  8023cb:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  8023d2:	00 00 00 
  8023d5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8023d7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023da:	48 98                	cltq   
  8023dc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023e2:	48 c1 e0 0c          	shl    $0xc,%rax
  8023e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8023ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023ee:	48 89 c7             	mov    %rax,%rdi
  8023f1:	48 b8 43 20 80 00 00 	movabs $0x802043,%rax
  8023f8:	00 00 00 
  8023fb:	ff d0                	callq  *%rax
  8023fd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802401:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802405:	48 89 c7             	mov    %rax,%rdi
  802408:	48 b8 43 20 80 00 00 	movabs $0x802043,%rax
  80240f:	00 00 00 
  802412:	ff d0                	callq  *%rax
  802414:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802418:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80241c:	48 c1 e8 15          	shr    $0x15,%rax
  802420:	48 89 c2             	mov    %rax,%rdx
  802423:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80242a:	01 00 00 
  80242d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802431:	83 e0 01             	and    $0x1,%eax
  802434:	48 85 c0             	test   %rax,%rax
  802437:	74 73                	je     8024ac <dup+0x11d>
  802439:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80243d:	48 c1 e8 0c          	shr    $0xc,%rax
  802441:	48 89 c2             	mov    %rax,%rdx
  802444:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80244b:	01 00 00 
  80244e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802452:	83 e0 01             	and    $0x1,%eax
  802455:	48 85 c0             	test   %rax,%rax
  802458:	74 52                	je     8024ac <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80245a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80245e:	48 c1 e8 0c          	shr    $0xc,%rax
  802462:	48 89 c2             	mov    %rax,%rdx
  802465:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80246c:	01 00 00 
  80246f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802473:	25 07 0e 00 00       	and    $0xe07,%eax
  802478:	89 c1                	mov    %eax,%ecx
  80247a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80247e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802482:	41 89 c8             	mov    %ecx,%r8d
  802485:	48 89 d1             	mov    %rdx,%rcx
  802488:	ba 00 00 00 00       	mov    $0x0,%edx
  80248d:	48 89 c6             	mov    %rax,%rsi
  802490:	bf 00 00 00 00       	mov    $0x0,%edi
  802495:	48 b8 90 1c 80 00 00 	movabs $0x801c90,%rax
  80249c:	00 00 00 
  80249f:	ff d0                	callq  *%rax
  8024a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a8:	79 02                	jns    8024ac <dup+0x11d>
			goto err;
  8024aa:	eb 57                	jmp    802503 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8024ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024b0:	48 c1 e8 0c          	shr    $0xc,%rax
  8024b4:	48 89 c2             	mov    %rax,%rdx
  8024b7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024be:	01 00 00 
  8024c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024c5:	25 07 0e 00 00       	and    $0xe07,%eax
  8024ca:	89 c1                	mov    %eax,%ecx
  8024cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024d4:	41 89 c8             	mov    %ecx,%r8d
  8024d7:	48 89 d1             	mov    %rdx,%rcx
  8024da:	ba 00 00 00 00       	mov    $0x0,%edx
  8024df:	48 89 c6             	mov    %rax,%rsi
  8024e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8024e7:	48 b8 90 1c 80 00 00 	movabs $0x801c90,%rax
  8024ee:	00 00 00 
  8024f1:	ff d0                	callq  *%rax
  8024f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024fa:	79 02                	jns    8024fe <dup+0x16f>
		goto err;
  8024fc:	eb 05                	jmp    802503 <dup+0x174>

	return newfdnum;
  8024fe:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802501:	eb 33                	jmp    802536 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802503:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802507:	48 89 c6             	mov    %rax,%rsi
  80250a:	bf 00 00 00 00       	mov    $0x0,%edi
  80250f:	48 b8 eb 1c 80 00 00 	movabs $0x801ceb,%rax
  802516:	00 00 00 
  802519:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80251b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80251f:	48 89 c6             	mov    %rax,%rsi
  802522:	bf 00 00 00 00       	mov    $0x0,%edi
  802527:	48 b8 eb 1c 80 00 00 	movabs $0x801ceb,%rax
  80252e:	00 00 00 
  802531:	ff d0                	callq  *%rax
	return r;
  802533:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802536:	c9                   	leaveq 
  802537:	c3                   	retq   

0000000000802538 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802538:	55                   	push   %rbp
  802539:	48 89 e5             	mov    %rsp,%rbp
  80253c:	48 83 ec 40          	sub    $0x40,%rsp
  802540:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802543:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802547:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80254b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80254f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802552:	48 89 d6             	mov    %rdx,%rsi
  802555:	89 c7                	mov    %eax,%edi
  802557:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  80255e:	00 00 00 
  802561:	ff d0                	callq  *%rax
  802563:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802566:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80256a:	78 24                	js     802590 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80256c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802570:	8b 00                	mov    (%rax),%eax
  802572:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802576:	48 89 d6             	mov    %rdx,%rsi
  802579:	89 c7                	mov    %eax,%edi
  80257b:	48 b8 5f 22 80 00 00 	movabs $0x80225f,%rax
  802582:	00 00 00 
  802585:	ff d0                	callq  *%rax
  802587:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80258a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80258e:	79 05                	jns    802595 <read+0x5d>
		return r;
  802590:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802593:	eb 76                	jmp    80260b <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802595:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802599:	8b 40 08             	mov    0x8(%rax),%eax
  80259c:	83 e0 03             	and    $0x3,%eax
  80259f:	83 f8 01             	cmp    $0x1,%eax
  8025a2:	75 3a                	jne    8025de <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8025a4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8025ab:	00 00 00 
  8025ae:	48 8b 00             	mov    (%rax),%rax
  8025b1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025b7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025ba:	89 c6                	mov    %eax,%esi
  8025bc:	48 bf 77 4c 80 00 00 	movabs $0x804c77,%rdi
  8025c3:	00 00 00 
  8025c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cb:	48 b9 5c 07 80 00 00 	movabs $0x80075c,%rcx
  8025d2:	00 00 00 
  8025d5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8025d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025dc:	eb 2d                	jmp    80260b <read+0xd3>
	}
	if (!dev->dev_read)
  8025de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8025e6:	48 85 c0             	test   %rax,%rax
  8025e9:	75 07                	jne    8025f2 <read+0xba>
		return -E_NOT_SUPP;
  8025eb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025f0:	eb 19                	jmp    80260b <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8025f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8025fa:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025fe:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802602:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802606:	48 89 cf             	mov    %rcx,%rdi
  802609:	ff d0                	callq  *%rax
}
  80260b:	c9                   	leaveq 
  80260c:	c3                   	retq   

000000000080260d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80260d:	55                   	push   %rbp
  80260e:	48 89 e5             	mov    %rsp,%rbp
  802611:	48 83 ec 30          	sub    $0x30,%rsp
  802615:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802618:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80261c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802620:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802627:	eb 49                	jmp    802672 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802629:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80262c:	48 98                	cltq   
  80262e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802632:	48 29 c2             	sub    %rax,%rdx
  802635:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802638:	48 63 c8             	movslq %eax,%rcx
  80263b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80263f:	48 01 c1             	add    %rax,%rcx
  802642:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802645:	48 89 ce             	mov    %rcx,%rsi
  802648:	89 c7                	mov    %eax,%edi
  80264a:	48 b8 38 25 80 00 00 	movabs $0x802538,%rax
  802651:	00 00 00 
  802654:	ff d0                	callq  *%rax
  802656:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802659:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80265d:	79 05                	jns    802664 <readn+0x57>
			return m;
  80265f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802662:	eb 1c                	jmp    802680 <readn+0x73>
		if (m == 0)
  802664:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802668:	75 02                	jne    80266c <readn+0x5f>
			break;
  80266a:	eb 11                	jmp    80267d <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80266c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80266f:	01 45 fc             	add    %eax,-0x4(%rbp)
  802672:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802675:	48 98                	cltq   
  802677:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80267b:	72 ac                	jb     802629 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80267d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802680:	c9                   	leaveq 
  802681:	c3                   	retq   

0000000000802682 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802682:	55                   	push   %rbp
  802683:	48 89 e5             	mov    %rsp,%rbp
  802686:	48 83 ec 40          	sub    $0x40,%rsp
  80268a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80268d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802691:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802695:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802699:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80269c:	48 89 d6             	mov    %rdx,%rsi
  80269f:	89 c7                	mov    %eax,%edi
  8026a1:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  8026a8:	00 00 00 
  8026ab:	ff d0                	callq  *%rax
  8026ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b4:	78 24                	js     8026da <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ba:	8b 00                	mov    (%rax),%eax
  8026bc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026c0:	48 89 d6             	mov    %rdx,%rsi
  8026c3:	89 c7                	mov    %eax,%edi
  8026c5:	48 b8 5f 22 80 00 00 	movabs $0x80225f,%rax
  8026cc:	00 00 00 
  8026cf:	ff d0                	callq  *%rax
  8026d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d8:	79 05                	jns    8026df <write+0x5d>
		return r;
  8026da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026dd:	eb 75                	jmp    802754 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8026df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e3:	8b 40 08             	mov    0x8(%rax),%eax
  8026e6:	83 e0 03             	and    $0x3,%eax
  8026e9:	85 c0                	test   %eax,%eax
  8026eb:	75 3a                	jne    802727 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8026ed:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8026f4:	00 00 00 
  8026f7:	48 8b 00             	mov    (%rax),%rax
  8026fa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802700:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802703:	89 c6                	mov    %eax,%esi
  802705:	48 bf 93 4c 80 00 00 	movabs $0x804c93,%rdi
  80270c:	00 00 00 
  80270f:	b8 00 00 00 00       	mov    $0x0,%eax
  802714:	48 b9 5c 07 80 00 00 	movabs $0x80075c,%rcx
  80271b:	00 00 00 
  80271e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802720:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802725:	eb 2d                	jmp    802754 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802727:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80272b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80272f:	48 85 c0             	test   %rax,%rax
  802732:	75 07                	jne    80273b <write+0xb9>
		return -E_NOT_SUPP;
  802734:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802739:	eb 19                	jmp    802754 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80273b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80273f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802743:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802747:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80274b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80274f:	48 89 cf             	mov    %rcx,%rdi
  802752:	ff d0                	callq  *%rax
}
  802754:	c9                   	leaveq 
  802755:	c3                   	retq   

0000000000802756 <seek>:

int
seek(int fdnum, off_t offset)
{
  802756:	55                   	push   %rbp
  802757:	48 89 e5             	mov    %rsp,%rbp
  80275a:	48 83 ec 18          	sub    $0x18,%rsp
  80275e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802761:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802764:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802768:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80276b:	48 89 d6             	mov    %rdx,%rsi
  80276e:	89 c7                	mov    %eax,%edi
  802770:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  802777:	00 00 00 
  80277a:	ff d0                	callq  *%rax
  80277c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80277f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802783:	79 05                	jns    80278a <seek+0x34>
		return r;
  802785:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802788:	eb 0f                	jmp    802799 <seek+0x43>
	fd->fd_offset = offset;
  80278a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80278e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802791:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802794:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802799:	c9                   	leaveq 
  80279a:	c3                   	retq   

000000000080279b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80279b:	55                   	push   %rbp
  80279c:	48 89 e5             	mov    %rsp,%rbp
  80279f:	48 83 ec 30          	sub    $0x30,%rsp
  8027a3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027a6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8027a9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027ad:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8027b0:	48 89 d6             	mov    %rdx,%rsi
  8027b3:	89 c7                	mov    %eax,%edi
  8027b5:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  8027bc:	00 00 00 
  8027bf:	ff d0                	callq  *%rax
  8027c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027c8:	78 24                	js     8027ee <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ce:	8b 00                	mov    (%rax),%eax
  8027d0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027d4:	48 89 d6             	mov    %rdx,%rsi
  8027d7:	89 c7                	mov    %eax,%edi
  8027d9:	48 b8 5f 22 80 00 00 	movabs $0x80225f,%rax
  8027e0:	00 00 00 
  8027e3:	ff d0                	callq  *%rax
  8027e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ec:	79 05                	jns    8027f3 <ftruncate+0x58>
		return r;
  8027ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f1:	eb 72                	jmp    802865 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8027f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027f7:	8b 40 08             	mov    0x8(%rax),%eax
  8027fa:	83 e0 03             	and    $0x3,%eax
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	75 3a                	jne    80283b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802801:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802808:	00 00 00 
  80280b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80280e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802814:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802817:	89 c6                	mov    %eax,%esi
  802819:	48 bf b0 4c 80 00 00 	movabs $0x804cb0,%rdi
  802820:	00 00 00 
  802823:	b8 00 00 00 00       	mov    $0x0,%eax
  802828:	48 b9 5c 07 80 00 00 	movabs $0x80075c,%rcx
  80282f:	00 00 00 
  802832:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802834:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802839:	eb 2a                	jmp    802865 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80283b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80283f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802843:	48 85 c0             	test   %rax,%rax
  802846:	75 07                	jne    80284f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802848:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80284d:	eb 16                	jmp    802865 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80284f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802853:	48 8b 40 30          	mov    0x30(%rax),%rax
  802857:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80285b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80285e:	89 ce                	mov    %ecx,%esi
  802860:	48 89 d7             	mov    %rdx,%rdi
  802863:	ff d0                	callq  *%rax
}
  802865:	c9                   	leaveq 
  802866:	c3                   	retq   

0000000000802867 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802867:	55                   	push   %rbp
  802868:	48 89 e5             	mov    %rsp,%rbp
  80286b:	48 83 ec 30          	sub    $0x30,%rsp
  80286f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802872:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802876:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80287a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80287d:	48 89 d6             	mov    %rdx,%rsi
  802880:	89 c7                	mov    %eax,%edi
  802882:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  802889:	00 00 00 
  80288c:	ff d0                	callq  *%rax
  80288e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802891:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802895:	78 24                	js     8028bb <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802897:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80289b:	8b 00                	mov    (%rax),%eax
  80289d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028a1:	48 89 d6             	mov    %rdx,%rsi
  8028a4:	89 c7                	mov    %eax,%edi
  8028a6:	48 b8 5f 22 80 00 00 	movabs $0x80225f,%rax
  8028ad:	00 00 00 
  8028b0:	ff d0                	callq  *%rax
  8028b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b9:	79 05                	jns    8028c0 <fstat+0x59>
		return r;
  8028bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028be:	eb 5e                	jmp    80291e <fstat+0xb7>
	if (!dev->dev_stat)
  8028c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8028c8:	48 85 c0             	test   %rax,%rax
  8028cb:	75 07                	jne    8028d4 <fstat+0x6d>
		return -E_NOT_SUPP;
  8028cd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028d2:	eb 4a                	jmp    80291e <fstat+0xb7>
	stat->st_name[0] = 0;
  8028d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028d8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8028db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028df:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8028e6:	00 00 00 
	stat->st_isdir = 0;
  8028e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028ed:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8028f4:	00 00 00 
	stat->st_dev = dev;
  8028f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028ff:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802906:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80290a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80290e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802912:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802916:	48 89 ce             	mov    %rcx,%rsi
  802919:	48 89 d7             	mov    %rdx,%rdi
  80291c:	ff d0                	callq  *%rax
}
  80291e:	c9                   	leaveq 
  80291f:	c3                   	retq   

0000000000802920 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802920:	55                   	push   %rbp
  802921:	48 89 e5             	mov    %rsp,%rbp
  802924:	48 83 ec 20          	sub    $0x20,%rsp
  802928:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80292c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802930:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802934:	be 00 00 00 00       	mov    $0x0,%esi
  802939:	48 89 c7             	mov    %rax,%rdi
  80293c:	48 b8 0e 2a 80 00 00 	movabs $0x802a0e,%rax
  802943:	00 00 00 
  802946:	ff d0                	callq  *%rax
  802948:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80294b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80294f:	79 05                	jns    802956 <stat+0x36>
		return fd;
  802951:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802954:	eb 2f                	jmp    802985 <stat+0x65>
	r = fstat(fd, stat);
  802956:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80295a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295d:	48 89 d6             	mov    %rdx,%rsi
  802960:	89 c7                	mov    %eax,%edi
  802962:	48 b8 67 28 80 00 00 	movabs $0x802867,%rax
  802969:	00 00 00 
  80296c:	ff d0                	callq  *%rax
  80296e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802971:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802974:	89 c7                	mov    %eax,%edi
  802976:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  80297d:	00 00 00 
  802980:	ff d0                	callq  *%rax
	return r;
  802982:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802985:	c9                   	leaveq 
  802986:	c3                   	retq   

0000000000802987 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802987:	55                   	push   %rbp
  802988:	48 89 e5             	mov    %rsp,%rbp
  80298b:	48 83 ec 10          	sub    $0x10,%rsp
  80298f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802992:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802996:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80299d:	00 00 00 
  8029a0:	8b 00                	mov    (%rax),%eax
  8029a2:	85 c0                	test   %eax,%eax
  8029a4:	75 1d                	jne    8029c3 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8029a6:	bf 01 00 00 00       	mov    $0x1,%edi
  8029ab:	48 b8 49 45 80 00 00 	movabs $0x804549,%rax
  8029b2:	00 00 00 
  8029b5:	ff d0                	callq  *%rax
  8029b7:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8029be:	00 00 00 
  8029c1:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8029c3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029ca:	00 00 00 
  8029cd:	8b 00                	mov    (%rax),%eax
  8029cf:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8029d2:	b9 07 00 00 00       	mov    $0x7,%ecx
  8029d7:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8029de:	00 00 00 
  8029e1:	89 c7                	mov    %eax,%edi
  8029e3:	48 b8 3d 43 80 00 00 	movabs $0x80433d,%rax
  8029ea:	00 00 00 
  8029ed:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8029ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8029f8:	48 89 c6             	mov    %rax,%rsi
  8029fb:	bf 00 00 00 00       	mov    $0x0,%edi
  802a00:	48 b8 7c 42 80 00 00 	movabs $0x80427c,%rax
  802a07:	00 00 00 
  802a0a:	ff d0                	callq  *%rax
}
  802a0c:	c9                   	leaveq 
  802a0d:	c3                   	retq   

0000000000802a0e <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802a0e:	55                   	push   %rbp
  802a0f:	48 89 e5             	mov    %rsp,%rbp
  802a12:	48 83 ec 20          	sub    $0x20,%rsp
  802a16:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a1a:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802a1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a21:	48 89 c7             	mov    %rax,%rdi
  802a24:	48 b8 a5 12 80 00 00 	movabs $0x8012a5,%rax
  802a2b:	00 00 00 
  802a2e:	ff d0                	callq  *%rax
  802a30:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a35:	7e 0a                	jle    802a41 <open+0x33>
		return -E_BAD_PATH;
  802a37:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a3c:	e9 a5 00 00 00       	jmpq   802ae6 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802a41:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802a45:	48 89 c7             	mov    %rax,%rdi
  802a48:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  802a4f:	00 00 00 
  802a52:	ff d0                	callq  *%rax
  802a54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a5b:	79 08                	jns    802a65 <open+0x57>
		return r;
  802a5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a60:	e9 81 00 00 00       	jmpq   802ae6 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802a65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a69:	48 89 c6             	mov    %rax,%rsi
  802a6c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802a73:	00 00 00 
  802a76:	48 b8 11 13 80 00 00 	movabs $0x801311,%rax
  802a7d:	00 00 00 
  802a80:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802a82:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a89:	00 00 00 
  802a8c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802a8f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802a95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a99:	48 89 c6             	mov    %rax,%rsi
  802a9c:	bf 01 00 00 00       	mov    $0x1,%edi
  802aa1:	48 b8 87 29 80 00 00 	movabs $0x802987,%rax
  802aa8:	00 00 00 
  802aab:	ff d0                	callq  *%rax
  802aad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab4:	79 1d                	jns    802ad3 <open+0xc5>
		fd_close(fd, 0);
  802ab6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aba:	be 00 00 00 00       	mov    $0x0,%esi
  802abf:	48 89 c7             	mov    %rax,%rdi
  802ac2:	48 b8 96 21 80 00 00 	movabs $0x802196,%rax
  802ac9:	00 00 00 
  802acc:	ff d0                	callq  *%rax
		return r;
  802ace:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad1:	eb 13                	jmp    802ae6 <open+0xd8>
	}

	return fd2num(fd);
  802ad3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ad7:	48 89 c7             	mov    %rax,%rdi
  802ada:	48 b8 20 20 80 00 00 	movabs $0x802020,%rax
  802ae1:	00 00 00 
  802ae4:	ff d0                	callq  *%rax

}
  802ae6:	c9                   	leaveq 
  802ae7:	c3                   	retq   

0000000000802ae8 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802ae8:	55                   	push   %rbp
  802ae9:	48 89 e5             	mov    %rsp,%rbp
  802aec:	48 83 ec 10          	sub    $0x10,%rsp
  802af0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802af4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802af8:	8b 50 0c             	mov    0xc(%rax),%edx
  802afb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b02:	00 00 00 
  802b05:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802b07:	be 00 00 00 00       	mov    $0x0,%esi
  802b0c:	bf 06 00 00 00       	mov    $0x6,%edi
  802b11:	48 b8 87 29 80 00 00 	movabs $0x802987,%rax
  802b18:	00 00 00 
  802b1b:	ff d0                	callq  *%rax
}
  802b1d:	c9                   	leaveq 
  802b1e:	c3                   	retq   

0000000000802b1f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802b1f:	55                   	push   %rbp
  802b20:	48 89 e5             	mov    %rsp,%rbp
  802b23:	48 83 ec 30          	sub    $0x30,%rsp
  802b27:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b2b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b2f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802b33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b37:	8b 50 0c             	mov    0xc(%rax),%edx
  802b3a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b41:	00 00 00 
  802b44:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802b46:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b4d:	00 00 00 
  802b50:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b54:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802b58:	be 00 00 00 00       	mov    $0x0,%esi
  802b5d:	bf 03 00 00 00       	mov    $0x3,%edi
  802b62:	48 b8 87 29 80 00 00 	movabs $0x802987,%rax
  802b69:	00 00 00 
  802b6c:	ff d0                	callq  *%rax
  802b6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b75:	79 08                	jns    802b7f <devfile_read+0x60>
		return r;
  802b77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b7a:	e9 a4 00 00 00       	jmpq   802c23 <devfile_read+0x104>
	assert(r <= n);
  802b7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b82:	48 98                	cltq   
  802b84:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b88:	76 35                	jbe    802bbf <devfile_read+0xa0>
  802b8a:	48 b9 d6 4c 80 00 00 	movabs $0x804cd6,%rcx
  802b91:	00 00 00 
  802b94:	48 ba dd 4c 80 00 00 	movabs $0x804cdd,%rdx
  802b9b:	00 00 00 
  802b9e:	be 86 00 00 00       	mov    $0x86,%esi
  802ba3:	48 bf f2 4c 80 00 00 	movabs $0x804cf2,%rdi
  802baa:	00 00 00 
  802bad:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb2:	49 b8 68 41 80 00 00 	movabs $0x804168,%r8
  802bb9:	00 00 00 
  802bbc:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802bbf:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802bc6:	7e 35                	jle    802bfd <devfile_read+0xde>
  802bc8:	48 b9 fd 4c 80 00 00 	movabs $0x804cfd,%rcx
  802bcf:	00 00 00 
  802bd2:	48 ba dd 4c 80 00 00 	movabs $0x804cdd,%rdx
  802bd9:	00 00 00 
  802bdc:	be 87 00 00 00       	mov    $0x87,%esi
  802be1:	48 bf f2 4c 80 00 00 	movabs $0x804cf2,%rdi
  802be8:	00 00 00 
  802beb:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf0:	49 b8 68 41 80 00 00 	movabs $0x804168,%r8
  802bf7:	00 00 00 
  802bfa:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  802bfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c00:	48 63 d0             	movslq %eax,%rdx
  802c03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c07:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802c0e:	00 00 00 
  802c11:	48 89 c7             	mov    %rax,%rdi
  802c14:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  802c1b:	00 00 00 
  802c1e:	ff d0                	callq  *%rax
	return r;
  802c20:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802c23:	c9                   	leaveq 
  802c24:	c3                   	retq   

0000000000802c25 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802c25:	55                   	push   %rbp
  802c26:	48 89 e5             	mov    %rsp,%rbp
  802c29:	48 83 ec 40          	sub    $0x40,%rsp
  802c2d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c31:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c35:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802c39:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c3d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802c41:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802c48:	00 
  802c49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c4d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802c51:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802c56:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802c5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c5e:	8b 50 0c             	mov    0xc(%rax),%edx
  802c61:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c68:	00 00 00 
  802c6b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802c6d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c74:	00 00 00 
  802c77:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c7b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802c7f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c83:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c87:	48 89 c6             	mov    %rax,%rsi
  802c8a:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802c91:	00 00 00 
  802c94:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  802c9b:	00 00 00 
  802c9e:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802ca0:	be 00 00 00 00       	mov    $0x0,%esi
  802ca5:	bf 04 00 00 00       	mov    $0x4,%edi
  802caa:	48 b8 87 29 80 00 00 	movabs $0x802987,%rax
  802cb1:	00 00 00 
  802cb4:	ff d0                	callq  *%rax
  802cb6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802cb9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802cbd:	79 05                	jns    802cc4 <devfile_write+0x9f>
		return r;
  802cbf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cc2:	eb 43                	jmp    802d07 <devfile_write+0xe2>
	assert(r <= n);
  802cc4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cc7:	48 98                	cltq   
  802cc9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802ccd:	76 35                	jbe    802d04 <devfile_write+0xdf>
  802ccf:	48 b9 d6 4c 80 00 00 	movabs $0x804cd6,%rcx
  802cd6:	00 00 00 
  802cd9:	48 ba dd 4c 80 00 00 	movabs $0x804cdd,%rdx
  802ce0:	00 00 00 
  802ce3:	be a2 00 00 00       	mov    $0xa2,%esi
  802ce8:	48 bf f2 4c 80 00 00 	movabs $0x804cf2,%rdi
  802cef:	00 00 00 
  802cf2:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf7:	49 b8 68 41 80 00 00 	movabs $0x804168,%r8
  802cfe:	00 00 00 
  802d01:	41 ff d0             	callq  *%r8
	return r;
  802d04:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802d07:	c9                   	leaveq 
  802d08:	c3                   	retq   

0000000000802d09 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802d09:	55                   	push   %rbp
  802d0a:	48 89 e5             	mov    %rsp,%rbp
  802d0d:	48 83 ec 20          	sub    $0x20,%rsp
  802d11:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d15:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802d19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d1d:	8b 50 0c             	mov    0xc(%rax),%edx
  802d20:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d27:	00 00 00 
  802d2a:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802d2c:	be 00 00 00 00       	mov    $0x0,%esi
  802d31:	bf 05 00 00 00       	mov    $0x5,%edi
  802d36:	48 b8 87 29 80 00 00 	movabs $0x802987,%rax
  802d3d:	00 00 00 
  802d40:	ff d0                	callq  *%rax
  802d42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d49:	79 05                	jns    802d50 <devfile_stat+0x47>
		return r;
  802d4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d4e:	eb 56                	jmp    802da6 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802d50:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d54:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802d5b:	00 00 00 
  802d5e:	48 89 c7             	mov    %rax,%rdi
  802d61:	48 b8 11 13 80 00 00 	movabs $0x801311,%rax
  802d68:	00 00 00 
  802d6b:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802d6d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d74:	00 00 00 
  802d77:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802d7d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d81:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802d87:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d8e:	00 00 00 
  802d91:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802d97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d9b:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802da1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802da6:	c9                   	leaveq 
  802da7:	c3                   	retq   

0000000000802da8 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802da8:	55                   	push   %rbp
  802da9:	48 89 e5             	mov    %rsp,%rbp
  802dac:	48 83 ec 10          	sub    $0x10,%rsp
  802db0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802db4:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802db7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dbb:	8b 50 0c             	mov    0xc(%rax),%edx
  802dbe:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dc5:	00 00 00 
  802dc8:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802dca:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dd1:	00 00 00 
  802dd4:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802dd7:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802dda:	be 00 00 00 00       	mov    $0x0,%esi
  802ddf:	bf 02 00 00 00       	mov    $0x2,%edi
  802de4:	48 b8 87 29 80 00 00 	movabs $0x802987,%rax
  802deb:	00 00 00 
  802dee:	ff d0                	callq  *%rax
}
  802df0:	c9                   	leaveq 
  802df1:	c3                   	retq   

0000000000802df2 <remove>:

// Delete a file
int
remove(const char *path)
{
  802df2:	55                   	push   %rbp
  802df3:	48 89 e5             	mov    %rsp,%rbp
  802df6:	48 83 ec 10          	sub    $0x10,%rsp
  802dfa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802dfe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e02:	48 89 c7             	mov    %rax,%rdi
  802e05:	48 b8 a5 12 80 00 00 	movabs $0x8012a5,%rax
  802e0c:	00 00 00 
  802e0f:	ff d0                	callq  *%rax
  802e11:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e16:	7e 07                	jle    802e1f <remove+0x2d>
		return -E_BAD_PATH;
  802e18:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e1d:	eb 33                	jmp    802e52 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802e1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e23:	48 89 c6             	mov    %rax,%rsi
  802e26:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802e2d:	00 00 00 
  802e30:	48 b8 11 13 80 00 00 	movabs $0x801311,%rax
  802e37:	00 00 00 
  802e3a:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802e3c:	be 00 00 00 00       	mov    $0x0,%esi
  802e41:	bf 07 00 00 00       	mov    $0x7,%edi
  802e46:	48 b8 87 29 80 00 00 	movabs $0x802987,%rax
  802e4d:	00 00 00 
  802e50:	ff d0                	callq  *%rax
}
  802e52:	c9                   	leaveq 
  802e53:	c3                   	retq   

0000000000802e54 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802e54:	55                   	push   %rbp
  802e55:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802e58:	be 00 00 00 00       	mov    $0x0,%esi
  802e5d:	bf 08 00 00 00       	mov    $0x8,%edi
  802e62:	48 b8 87 29 80 00 00 	movabs $0x802987,%rax
  802e69:	00 00 00 
  802e6c:	ff d0                	callq  *%rax
}
  802e6e:	5d                   	pop    %rbp
  802e6f:	c3                   	retq   

0000000000802e70 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802e70:	55                   	push   %rbp
  802e71:	48 89 e5             	mov    %rsp,%rbp
  802e74:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802e7b:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802e82:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802e89:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802e90:	be 00 00 00 00       	mov    $0x0,%esi
  802e95:	48 89 c7             	mov    %rax,%rdi
  802e98:	48 b8 0e 2a 80 00 00 	movabs $0x802a0e,%rax
  802e9f:	00 00 00 
  802ea2:	ff d0                	callq  *%rax
  802ea4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802ea7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eab:	79 28                	jns    802ed5 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802ead:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb0:	89 c6                	mov    %eax,%esi
  802eb2:	48 bf 09 4d 80 00 00 	movabs $0x804d09,%rdi
  802eb9:	00 00 00 
  802ebc:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec1:	48 ba 5c 07 80 00 00 	movabs $0x80075c,%rdx
  802ec8:	00 00 00 
  802ecb:	ff d2                	callq  *%rdx
		return fd_src;
  802ecd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed0:	e9 74 01 00 00       	jmpq   803049 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802ed5:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802edc:	be 01 01 00 00       	mov    $0x101,%esi
  802ee1:	48 89 c7             	mov    %rax,%rdi
  802ee4:	48 b8 0e 2a 80 00 00 	movabs $0x802a0e,%rax
  802eeb:	00 00 00 
  802eee:	ff d0                	callq  *%rax
  802ef0:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802ef3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ef7:	79 39                	jns    802f32 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802ef9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802efc:	89 c6                	mov    %eax,%esi
  802efe:	48 bf 1f 4d 80 00 00 	movabs $0x804d1f,%rdi
  802f05:	00 00 00 
  802f08:	b8 00 00 00 00       	mov    $0x0,%eax
  802f0d:	48 ba 5c 07 80 00 00 	movabs $0x80075c,%rdx
  802f14:	00 00 00 
  802f17:	ff d2                	callq  *%rdx
		close(fd_src);
  802f19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f1c:	89 c7                	mov    %eax,%edi
  802f1e:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  802f25:	00 00 00 
  802f28:	ff d0                	callq  *%rax
		return fd_dest;
  802f2a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f2d:	e9 17 01 00 00       	jmpq   803049 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802f32:	eb 74                	jmp    802fa8 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802f34:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f37:	48 63 d0             	movslq %eax,%rdx
  802f3a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802f41:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f44:	48 89 ce             	mov    %rcx,%rsi
  802f47:	89 c7                	mov    %eax,%edi
  802f49:	48 b8 82 26 80 00 00 	movabs $0x802682,%rax
  802f50:	00 00 00 
  802f53:	ff d0                	callq  *%rax
  802f55:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802f58:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802f5c:	79 4a                	jns    802fa8 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802f5e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802f61:	89 c6                	mov    %eax,%esi
  802f63:	48 bf 39 4d 80 00 00 	movabs $0x804d39,%rdi
  802f6a:	00 00 00 
  802f6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f72:	48 ba 5c 07 80 00 00 	movabs $0x80075c,%rdx
  802f79:	00 00 00 
  802f7c:	ff d2                	callq  *%rdx
			close(fd_src);
  802f7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f81:	89 c7                	mov    %eax,%edi
  802f83:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  802f8a:	00 00 00 
  802f8d:	ff d0                	callq  *%rax
			close(fd_dest);
  802f8f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f92:	89 c7                	mov    %eax,%edi
  802f94:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  802f9b:	00 00 00 
  802f9e:	ff d0                	callq  *%rax
			return write_size;
  802fa0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802fa3:	e9 a1 00 00 00       	jmpq   803049 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802fa8:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802faf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb2:	ba 00 02 00 00       	mov    $0x200,%edx
  802fb7:	48 89 ce             	mov    %rcx,%rsi
  802fba:	89 c7                	mov    %eax,%edi
  802fbc:	48 b8 38 25 80 00 00 	movabs $0x802538,%rax
  802fc3:	00 00 00 
  802fc6:	ff d0                	callq  *%rax
  802fc8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802fcb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802fcf:	0f 8f 5f ff ff ff    	jg     802f34 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802fd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802fd9:	79 47                	jns    803022 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802fdb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fde:	89 c6                	mov    %eax,%esi
  802fe0:	48 bf 4c 4d 80 00 00 	movabs $0x804d4c,%rdi
  802fe7:	00 00 00 
  802fea:	b8 00 00 00 00       	mov    $0x0,%eax
  802fef:	48 ba 5c 07 80 00 00 	movabs $0x80075c,%rdx
  802ff6:	00 00 00 
  802ff9:	ff d2                	callq  *%rdx
		close(fd_src);
  802ffb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ffe:	89 c7                	mov    %eax,%edi
  803000:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  803007:	00 00 00 
  80300a:	ff d0                	callq  *%rax
		close(fd_dest);
  80300c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80300f:	89 c7                	mov    %eax,%edi
  803011:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  803018:	00 00 00 
  80301b:	ff d0                	callq  *%rax
		return read_size;
  80301d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803020:	eb 27                	jmp    803049 <copy+0x1d9>
	}
	close(fd_src);
  803022:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803025:	89 c7                	mov    %eax,%edi
  803027:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  80302e:	00 00 00 
  803031:	ff d0                	callq  *%rax
	close(fd_dest);
  803033:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803036:	89 c7                	mov    %eax,%edi
  803038:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  80303f:	00 00 00 
  803042:	ff d0                	callq  *%rax
	return 0;
  803044:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803049:	c9                   	leaveq 
  80304a:	c3                   	retq   

000000000080304b <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80304b:	55                   	push   %rbp
  80304c:	48 89 e5             	mov    %rsp,%rbp
  80304f:	48 83 ec 20          	sub    $0x20,%rsp
  803053:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803056:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80305a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80305d:	48 89 d6             	mov    %rdx,%rsi
  803060:	89 c7                	mov    %eax,%edi
  803062:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  803069:	00 00 00 
  80306c:	ff d0                	callq  *%rax
  80306e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803071:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803075:	79 05                	jns    80307c <fd2sockid+0x31>
		return r;
  803077:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80307a:	eb 24                	jmp    8030a0 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80307c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803080:	8b 10                	mov    (%rax),%edx
  803082:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803089:	00 00 00 
  80308c:	8b 00                	mov    (%rax),%eax
  80308e:	39 c2                	cmp    %eax,%edx
  803090:	74 07                	je     803099 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803092:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803097:	eb 07                	jmp    8030a0 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803099:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80309d:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8030a0:	c9                   	leaveq 
  8030a1:	c3                   	retq   

00000000008030a2 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8030a2:	55                   	push   %rbp
  8030a3:	48 89 e5             	mov    %rsp,%rbp
  8030a6:	48 83 ec 20          	sub    $0x20,%rsp
  8030aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8030ad:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8030b1:	48 89 c7             	mov    %rax,%rdi
  8030b4:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  8030bb:	00 00 00 
  8030be:	ff d0                	callq  *%rax
  8030c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030c7:	78 26                	js     8030ef <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8030c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030cd:	ba 07 04 00 00       	mov    $0x407,%edx
  8030d2:	48 89 c6             	mov    %rax,%rsi
  8030d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8030da:	48 b8 40 1c 80 00 00 	movabs $0x801c40,%rax
  8030e1:	00 00 00 
  8030e4:	ff d0                	callq  *%rax
  8030e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ed:	79 16                	jns    803105 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8030ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030f2:	89 c7                	mov    %eax,%edi
  8030f4:	48 b8 af 35 80 00 00 	movabs $0x8035af,%rax
  8030fb:	00 00 00 
  8030fe:	ff d0                	callq  *%rax
		return r;
  803100:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803103:	eb 3a                	jmp    80313f <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803105:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803109:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  803110:	00 00 00 
  803113:	8b 12                	mov    (%rdx),%edx
  803115:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803117:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80311b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803122:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803126:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803129:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80312c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803130:	48 89 c7             	mov    %rax,%rdi
  803133:	48 b8 20 20 80 00 00 	movabs $0x802020,%rax
  80313a:	00 00 00 
  80313d:	ff d0                	callq  *%rax
}
  80313f:	c9                   	leaveq 
  803140:	c3                   	retq   

0000000000803141 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803141:	55                   	push   %rbp
  803142:	48 89 e5             	mov    %rsp,%rbp
  803145:	48 83 ec 30          	sub    $0x30,%rsp
  803149:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80314c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803150:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803154:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803157:	89 c7                	mov    %eax,%edi
  803159:	48 b8 4b 30 80 00 00 	movabs $0x80304b,%rax
  803160:	00 00 00 
  803163:	ff d0                	callq  *%rax
  803165:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803168:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80316c:	79 05                	jns    803173 <accept+0x32>
		return r;
  80316e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803171:	eb 3b                	jmp    8031ae <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803173:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803177:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80317b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80317e:	48 89 ce             	mov    %rcx,%rsi
  803181:	89 c7                	mov    %eax,%edi
  803183:	48 b8 8c 34 80 00 00 	movabs $0x80348c,%rax
  80318a:	00 00 00 
  80318d:	ff d0                	callq  *%rax
  80318f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803192:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803196:	79 05                	jns    80319d <accept+0x5c>
		return r;
  803198:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80319b:	eb 11                	jmp    8031ae <accept+0x6d>
	return alloc_sockfd(r);
  80319d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a0:	89 c7                	mov    %eax,%edi
  8031a2:	48 b8 a2 30 80 00 00 	movabs $0x8030a2,%rax
  8031a9:	00 00 00 
  8031ac:	ff d0                	callq  *%rax
}
  8031ae:	c9                   	leaveq 
  8031af:	c3                   	retq   

00000000008031b0 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8031b0:	55                   	push   %rbp
  8031b1:	48 89 e5             	mov    %rsp,%rbp
  8031b4:	48 83 ec 20          	sub    $0x20,%rsp
  8031b8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031bf:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8031c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031c5:	89 c7                	mov    %eax,%edi
  8031c7:	48 b8 4b 30 80 00 00 	movabs $0x80304b,%rax
  8031ce:	00 00 00 
  8031d1:	ff d0                	callq  *%rax
  8031d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031da:	79 05                	jns    8031e1 <bind+0x31>
		return r;
  8031dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031df:	eb 1b                	jmp    8031fc <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8031e1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031e4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8031e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031eb:	48 89 ce             	mov    %rcx,%rsi
  8031ee:	89 c7                	mov    %eax,%edi
  8031f0:	48 b8 0b 35 80 00 00 	movabs $0x80350b,%rax
  8031f7:	00 00 00 
  8031fa:	ff d0                	callq  *%rax
}
  8031fc:	c9                   	leaveq 
  8031fd:	c3                   	retq   

00000000008031fe <shutdown>:

int
shutdown(int s, int how)
{
  8031fe:	55                   	push   %rbp
  8031ff:	48 89 e5             	mov    %rsp,%rbp
  803202:	48 83 ec 20          	sub    $0x20,%rsp
  803206:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803209:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80320c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80320f:	89 c7                	mov    %eax,%edi
  803211:	48 b8 4b 30 80 00 00 	movabs $0x80304b,%rax
  803218:	00 00 00 
  80321b:	ff d0                	callq  *%rax
  80321d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803220:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803224:	79 05                	jns    80322b <shutdown+0x2d>
		return r;
  803226:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803229:	eb 16                	jmp    803241 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80322b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80322e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803231:	89 d6                	mov    %edx,%esi
  803233:	89 c7                	mov    %eax,%edi
  803235:	48 b8 6f 35 80 00 00 	movabs $0x80356f,%rax
  80323c:	00 00 00 
  80323f:	ff d0                	callq  *%rax
}
  803241:	c9                   	leaveq 
  803242:	c3                   	retq   

0000000000803243 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803243:	55                   	push   %rbp
  803244:	48 89 e5             	mov    %rsp,%rbp
  803247:	48 83 ec 10          	sub    $0x10,%rsp
  80324b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80324f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803253:	48 89 c7             	mov    %rax,%rdi
  803256:	48 b8 bb 45 80 00 00 	movabs $0x8045bb,%rax
  80325d:	00 00 00 
  803260:	ff d0                	callq  *%rax
  803262:	83 f8 01             	cmp    $0x1,%eax
  803265:	75 17                	jne    80327e <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803267:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80326b:	8b 40 0c             	mov    0xc(%rax),%eax
  80326e:	89 c7                	mov    %eax,%edi
  803270:	48 b8 af 35 80 00 00 	movabs $0x8035af,%rax
  803277:	00 00 00 
  80327a:	ff d0                	callq  *%rax
  80327c:	eb 05                	jmp    803283 <devsock_close+0x40>
	else
		return 0;
  80327e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803283:	c9                   	leaveq 
  803284:	c3                   	retq   

0000000000803285 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803285:	55                   	push   %rbp
  803286:	48 89 e5             	mov    %rsp,%rbp
  803289:	48 83 ec 20          	sub    $0x20,%rsp
  80328d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803290:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803294:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803297:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80329a:	89 c7                	mov    %eax,%edi
  80329c:	48 b8 4b 30 80 00 00 	movabs $0x80304b,%rax
  8032a3:	00 00 00 
  8032a6:	ff d0                	callq  *%rax
  8032a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032af:	79 05                	jns    8032b6 <connect+0x31>
		return r;
  8032b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b4:	eb 1b                	jmp    8032d1 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8032b6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8032b9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8032bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032c0:	48 89 ce             	mov    %rcx,%rsi
  8032c3:	89 c7                	mov    %eax,%edi
  8032c5:	48 b8 dc 35 80 00 00 	movabs $0x8035dc,%rax
  8032cc:	00 00 00 
  8032cf:	ff d0                	callq  *%rax
}
  8032d1:	c9                   	leaveq 
  8032d2:	c3                   	retq   

00000000008032d3 <listen>:

int
listen(int s, int backlog)
{
  8032d3:	55                   	push   %rbp
  8032d4:	48 89 e5             	mov    %rsp,%rbp
  8032d7:	48 83 ec 20          	sub    $0x20,%rsp
  8032db:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032de:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032e4:	89 c7                	mov    %eax,%edi
  8032e6:	48 b8 4b 30 80 00 00 	movabs $0x80304b,%rax
  8032ed:	00 00 00 
  8032f0:	ff d0                	callq  *%rax
  8032f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f9:	79 05                	jns    803300 <listen+0x2d>
		return r;
  8032fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032fe:	eb 16                	jmp    803316 <listen+0x43>
	return nsipc_listen(r, backlog);
  803300:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803303:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803306:	89 d6                	mov    %edx,%esi
  803308:	89 c7                	mov    %eax,%edi
  80330a:	48 b8 40 36 80 00 00 	movabs $0x803640,%rax
  803311:	00 00 00 
  803314:	ff d0                	callq  *%rax
}
  803316:	c9                   	leaveq 
  803317:	c3                   	retq   

0000000000803318 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803318:	55                   	push   %rbp
  803319:	48 89 e5             	mov    %rsp,%rbp
  80331c:	48 83 ec 20          	sub    $0x20,%rsp
  803320:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803324:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803328:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80332c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803330:	89 c2                	mov    %eax,%edx
  803332:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803336:	8b 40 0c             	mov    0xc(%rax),%eax
  803339:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80333d:	b9 00 00 00 00       	mov    $0x0,%ecx
  803342:	89 c7                	mov    %eax,%edi
  803344:	48 b8 80 36 80 00 00 	movabs $0x803680,%rax
  80334b:	00 00 00 
  80334e:	ff d0                	callq  *%rax
}
  803350:	c9                   	leaveq 
  803351:	c3                   	retq   

0000000000803352 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803352:	55                   	push   %rbp
  803353:	48 89 e5             	mov    %rsp,%rbp
  803356:	48 83 ec 20          	sub    $0x20,%rsp
  80335a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80335e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803362:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803366:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80336a:	89 c2                	mov    %eax,%edx
  80336c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803370:	8b 40 0c             	mov    0xc(%rax),%eax
  803373:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803377:	b9 00 00 00 00       	mov    $0x0,%ecx
  80337c:	89 c7                	mov    %eax,%edi
  80337e:	48 b8 4c 37 80 00 00 	movabs $0x80374c,%rax
  803385:	00 00 00 
  803388:	ff d0                	callq  *%rax
}
  80338a:	c9                   	leaveq 
  80338b:	c3                   	retq   

000000000080338c <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80338c:	55                   	push   %rbp
  80338d:	48 89 e5             	mov    %rsp,%rbp
  803390:	48 83 ec 10          	sub    $0x10,%rsp
  803394:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803398:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80339c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033a0:	48 be 67 4d 80 00 00 	movabs $0x804d67,%rsi
  8033a7:	00 00 00 
  8033aa:	48 89 c7             	mov    %rax,%rdi
  8033ad:	48 b8 11 13 80 00 00 	movabs $0x801311,%rax
  8033b4:	00 00 00 
  8033b7:	ff d0                	callq  *%rax
	return 0;
  8033b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033be:	c9                   	leaveq 
  8033bf:	c3                   	retq   

00000000008033c0 <socket>:

int
socket(int domain, int type, int protocol)
{
  8033c0:	55                   	push   %rbp
  8033c1:	48 89 e5             	mov    %rsp,%rbp
  8033c4:	48 83 ec 20          	sub    $0x20,%rsp
  8033c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033cb:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8033ce:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8033d1:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8033d4:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8033d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033da:	89 ce                	mov    %ecx,%esi
  8033dc:	89 c7                	mov    %eax,%edi
  8033de:	48 b8 04 38 80 00 00 	movabs $0x803804,%rax
  8033e5:	00 00 00 
  8033e8:	ff d0                	callq  *%rax
  8033ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033f1:	79 05                	jns    8033f8 <socket+0x38>
		return r;
  8033f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f6:	eb 11                	jmp    803409 <socket+0x49>
	return alloc_sockfd(r);
  8033f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fb:	89 c7                	mov    %eax,%edi
  8033fd:	48 b8 a2 30 80 00 00 	movabs $0x8030a2,%rax
  803404:	00 00 00 
  803407:	ff d0                	callq  *%rax
}
  803409:	c9                   	leaveq 
  80340a:	c3                   	retq   

000000000080340b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80340b:	55                   	push   %rbp
  80340c:	48 89 e5             	mov    %rsp,%rbp
  80340f:	48 83 ec 10          	sub    $0x10,%rsp
  803413:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803416:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80341d:	00 00 00 
  803420:	8b 00                	mov    (%rax),%eax
  803422:	85 c0                	test   %eax,%eax
  803424:	75 1d                	jne    803443 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803426:	bf 02 00 00 00       	mov    $0x2,%edi
  80342b:	48 b8 49 45 80 00 00 	movabs $0x804549,%rax
  803432:	00 00 00 
  803435:	ff d0                	callq  *%rax
  803437:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  80343e:	00 00 00 
  803441:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803443:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80344a:	00 00 00 
  80344d:	8b 00                	mov    (%rax),%eax
  80344f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803452:	b9 07 00 00 00       	mov    $0x7,%ecx
  803457:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80345e:	00 00 00 
  803461:	89 c7                	mov    %eax,%edi
  803463:	48 b8 3d 43 80 00 00 	movabs $0x80433d,%rax
  80346a:	00 00 00 
  80346d:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80346f:	ba 00 00 00 00       	mov    $0x0,%edx
  803474:	be 00 00 00 00       	mov    $0x0,%esi
  803479:	bf 00 00 00 00       	mov    $0x0,%edi
  80347e:	48 b8 7c 42 80 00 00 	movabs $0x80427c,%rax
  803485:	00 00 00 
  803488:	ff d0                	callq  *%rax
}
  80348a:	c9                   	leaveq 
  80348b:	c3                   	retq   

000000000080348c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80348c:	55                   	push   %rbp
  80348d:	48 89 e5             	mov    %rsp,%rbp
  803490:	48 83 ec 30          	sub    $0x30,%rsp
  803494:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803497:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80349b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80349f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034a6:	00 00 00 
  8034a9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034ac:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8034ae:	bf 01 00 00 00       	mov    $0x1,%edi
  8034b3:	48 b8 0b 34 80 00 00 	movabs $0x80340b,%rax
  8034ba:	00 00 00 
  8034bd:	ff d0                	callq  *%rax
  8034bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034c6:	78 3e                	js     803506 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8034c8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034cf:	00 00 00 
  8034d2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8034d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034da:	8b 40 10             	mov    0x10(%rax),%eax
  8034dd:	89 c2                	mov    %eax,%edx
  8034df:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8034e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034e7:	48 89 ce             	mov    %rcx,%rsi
  8034ea:	48 89 c7             	mov    %rax,%rdi
  8034ed:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  8034f4:	00 00 00 
  8034f7:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8034f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034fd:	8b 50 10             	mov    0x10(%rax),%edx
  803500:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803504:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803506:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803509:	c9                   	leaveq 
  80350a:	c3                   	retq   

000000000080350b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80350b:	55                   	push   %rbp
  80350c:	48 89 e5             	mov    %rsp,%rbp
  80350f:	48 83 ec 10          	sub    $0x10,%rsp
  803513:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803516:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80351a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80351d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803524:	00 00 00 
  803527:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80352a:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80352c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80352f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803533:	48 89 c6             	mov    %rax,%rsi
  803536:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80353d:	00 00 00 
  803540:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  803547:	00 00 00 
  80354a:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80354c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803553:	00 00 00 
  803556:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803559:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80355c:	bf 02 00 00 00       	mov    $0x2,%edi
  803561:	48 b8 0b 34 80 00 00 	movabs $0x80340b,%rax
  803568:	00 00 00 
  80356b:	ff d0                	callq  *%rax
}
  80356d:	c9                   	leaveq 
  80356e:	c3                   	retq   

000000000080356f <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80356f:	55                   	push   %rbp
  803570:	48 89 e5             	mov    %rsp,%rbp
  803573:	48 83 ec 10          	sub    $0x10,%rsp
  803577:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80357a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80357d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803584:	00 00 00 
  803587:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80358a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80358c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803593:	00 00 00 
  803596:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803599:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80359c:	bf 03 00 00 00       	mov    $0x3,%edi
  8035a1:	48 b8 0b 34 80 00 00 	movabs $0x80340b,%rax
  8035a8:	00 00 00 
  8035ab:	ff d0                	callq  *%rax
}
  8035ad:	c9                   	leaveq 
  8035ae:	c3                   	retq   

00000000008035af <nsipc_close>:

int
nsipc_close(int s)
{
  8035af:	55                   	push   %rbp
  8035b0:	48 89 e5             	mov    %rsp,%rbp
  8035b3:	48 83 ec 10          	sub    $0x10,%rsp
  8035b7:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8035ba:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035c1:	00 00 00 
  8035c4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035c7:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8035c9:	bf 04 00 00 00       	mov    $0x4,%edi
  8035ce:	48 b8 0b 34 80 00 00 	movabs $0x80340b,%rax
  8035d5:	00 00 00 
  8035d8:	ff d0                	callq  *%rax
}
  8035da:	c9                   	leaveq 
  8035db:	c3                   	retq   

00000000008035dc <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8035dc:	55                   	push   %rbp
  8035dd:	48 89 e5             	mov    %rsp,%rbp
  8035e0:	48 83 ec 10          	sub    $0x10,%rsp
  8035e4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035eb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8035ee:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035f5:	00 00 00 
  8035f8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035fb:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8035fd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803600:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803604:	48 89 c6             	mov    %rax,%rsi
  803607:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80360e:	00 00 00 
  803611:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  803618:	00 00 00 
  80361b:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80361d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803624:	00 00 00 
  803627:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80362a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80362d:	bf 05 00 00 00       	mov    $0x5,%edi
  803632:	48 b8 0b 34 80 00 00 	movabs $0x80340b,%rax
  803639:	00 00 00 
  80363c:	ff d0                	callq  *%rax
}
  80363e:	c9                   	leaveq 
  80363f:	c3                   	retq   

0000000000803640 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803640:	55                   	push   %rbp
  803641:	48 89 e5             	mov    %rsp,%rbp
  803644:	48 83 ec 10          	sub    $0x10,%rsp
  803648:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80364b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80364e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803655:	00 00 00 
  803658:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80365b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80365d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803664:	00 00 00 
  803667:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80366a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80366d:	bf 06 00 00 00       	mov    $0x6,%edi
  803672:	48 b8 0b 34 80 00 00 	movabs $0x80340b,%rax
  803679:	00 00 00 
  80367c:	ff d0                	callq  *%rax
}
  80367e:	c9                   	leaveq 
  80367f:	c3                   	retq   

0000000000803680 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803680:	55                   	push   %rbp
  803681:	48 89 e5             	mov    %rsp,%rbp
  803684:	48 83 ec 30          	sub    $0x30,%rsp
  803688:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80368b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80368f:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803692:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803695:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80369c:	00 00 00 
  80369f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8036a2:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8036a4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036ab:	00 00 00 
  8036ae:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036b1:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8036b4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036bb:	00 00 00 
  8036be:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8036c1:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8036c4:	bf 07 00 00 00       	mov    $0x7,%edi
  8036c9:	48 b8 0b 34 80 00 00 	movabs $0x80340b,%rax
  8036d0:	00 00 00 
  8036d3:	ff d0                	callq  *%rax
  8036d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036dc:	78 69                	js     803747 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8036de:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8036e5:	7f 08                	jg     8036ef <nsipc_recv+0x6f>
  8036e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ea:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8036ed:	7e 35                	jle    803724 <nsipc_recv+0xa4>
  8036ef:	48 b9 6e 4d 80 00 00 	movabs $0x804d6e,%rcx
  8036f6:	00 00 00 
  8036f9:	48 ba 83 4d 80 00 00 	movabs $0x804d83,%rdx
  803700:	00 00 00 
  803703:	be 62 00 00 00       	mov    $0x62,%esi
  803708:	48 bf 98 4d 80 00 00 	movabs $0x804d98,%rdi
  80370f:	00 00 00 
  803712:	b8 00 00 00 00       	mov    $0x0,%eax
  803717:	49 b8 68 41 80 00 00 	movabs $0x804168,%r8
  80371e:	00 00 00 
  803721:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803724:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803727:	48 63 d0             	movslq %eax,%rdx
  80372a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80372e:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803735:	00 00 00 
  803738:	48 89 c7             	mov    %rax,%rdi
  80373b:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  803742:	00 00 00 
  803745:	ff d0                	callq  *%rax
	}

	return r;
  803747:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80374a:	c9                   	leaveq 
  80374b:	c3                   	retq   

000000000080374c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80374c:	55                   	push   %rbp
  80374d:	48 89 e5             	mov    %rsp,%rbp
  803750:	48 83 ec 20          	sub    $0x20,%rsp
  803754:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803757:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80375b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80375e:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803761:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803768:	00 00 00 
  80376b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80376e:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803770:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803777:	7e 35                	jle    8037ae <nsipc_send+0x62>
  803779:	48 b9 a4 4d 80 00 00 	movabs $0x804da4,%rcx
  803780:	00 00 00 
  803783:	48 ba 83 4d 80 00 00 	movabs $0x804d83,%rdx
  80378a:	00 00 00 
  80378d:	be 6d 00 00 00       	mov    $0x6d,%esi
  803792:	48 bf 98 4d 80 00 00 	movabs $0x804d98,%rdi
  803799:	00 00 00 
  80379c:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a1:	49 b8 68 41 80 00 00 	movabs $0x804168,%r8
  8037a8:	00 00 00 
  8037ab:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8037ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037b1:	48 63 d0             	movslq %eax,%rdx
  8037b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037b8:	48 89 c6             	mov    %rax,%rsi
  8037bb:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8037c2:	00 00 00 
  8037c5:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  8037cc:	00 00 00 
  8037cf:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8037d1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037d8:	00 00 00 
  8037db:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037de:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8037e1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037e8:	00 00 00 
  8037eb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8037ee:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8037f1:	bf 08 00 00 00       	mov    $0x8,%edi
  8037f6:	48 b8 0b 34 80 00 00 	movabs $0x80340b,%rax
  8037fd:	00 00 00 
  803800:	ff d0                	callq  *%rax
}
  803802:	c9                   	leaveq 
  803803:	c3                   	retq   

0000000000803804 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803804:	55                   	push   %rbp
  803805:	48 89 e5             	mov    %rsp,%rbp
  803808:	48 83 ec 10          	sub    $0x10,%rsp
  80380c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80380f:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803812:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803815:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80381c:	00 00 00 
  80381f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803822:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803824:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80382b:	00 00 00 
  80382e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803831:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803834:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80383b:	00 00 00 
  80383e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803841:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803844:	bf 09 00 00 00       	mov    $0x9,%edi
  803849:	48 b8 0b 34 80 00 00 	movabs $0x80340b,%rax
  803850:	00 00 00 
  803853:	ff d0                	callq  *%rax
}
  803855:	c9                   	leaveq 
  803856:	c3                   	retq   

0000000000803857 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803857:	55                   	push   %rbp
  803858:	48 89 e5             	mov    %rsp,%rbp
  80385b:	53                   	push   %rbx
  80385c:	48 83 ec 38          	sub    $0x38,%rsp
  803860:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803864:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803868:	48 89 c7             	mov    %rax,%rdi
  80386b:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  803872:	00 00 00 
  803875:	ff d0                	callq  *%rax
  803877:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80387a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80387e:	0f 88 bf 01 00 00    	js     803a43 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803884:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803888:	ba 07 04 00 00       	mov    $0x407,%edx
  80388d:	48 89 c6             	mov    %rax,%rsi
  803890:	bf 00 00 00 00       	mov    $0x0,%edi
  803895:	48 b8 40 1c 80 00 00 	movabs $0x801c40,%rax
  80389c:	00 00 00 
  80389f:	ff d0                	callq  *%rax
  8038a1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038a8:	0f 88 95 01 00 00    	js     803a43 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8038ae:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8038b2:	48 89 c7             	mov    %rax,%rdi
  8038b5:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  8038bc:	00 00 00 
  8038bf:	ff d0                	callq  *%rax
  8038c1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038c8:	0f 88 5d 01 00 00    	js     803a2b <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038d2:	ba 07 04 00 00       	mov    $0x407,%edx
  8038d7:	48 89 c6             	mov    %rax,%rsi
  8038da:	bf 00 00 00 00       	mov    $0x0,%edi
  8038df:	48 b8 40 1c 80 00 00 	movabs $0x801c40,%rax
  8038e6:	00 00 00 
  8038e9:	ff d0                	callq  *%rax
  8038eb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038f2:	0f 88 33 01 00 00    	js     803a2b <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8038f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038fc:	48 89 c7             	mov    %rax,%rdi
  8038ff:	48 b8 43 20 80 00 00 	movabs $0x802043,%rax
  803906:	00 00 00 
  803909:	ff d0                	callq  *%rax
  80390b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80390f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803913:	ba 07 04 00 00       	mov    $0x407,%edx
  803918:	48 89 c6             	mov    %rax,%rsi
  80391b:	bf 00 00 00 00       	mov    $0x0,%edi
  803920:	48 b8 40 1c 80 00 00 	movabs $0x801c40,%rax
  803927:	00 00 00 
  80392a:	ff d0                	callq  *%rax
  80392c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80392f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803933:	79 05                	jns    80393a <pipe+0xe3>
		goto err2;
  803935:	e9 d9 00 00 00       	jmpq   803a13 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80393a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80393e:	48 89 c7             	mov    %rax,%rdi
  803941:	48 b8 43 20 80 00 00 	movabs $0x802043,%rax
  803948:	00 00 00 
  80394b:	ff d0                	callq  *%rax
  80394d:	48 89 c2             	mov    %rax,%rdx
  803950:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803954:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80395a:	48 89 d1             	mov    %rdx,%rcx
  80395d:	ba 00 00 00 00       	mov    $0x0,%edx
  803962:	48 89 c6             	mov    %rax,%rsi
  803965:	bf 00 00 00 00       	mov    $0x0,%edi
  80396a:	48 b8 90 1c 80 00 00 	movabs $0x801c90,%rax
  803971:	00 00 00 
  803974:	ff d0                	callq  *%rax
  803976:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803979:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80397d:	79 1b                	jns    80399a <pipe+0x143>
		goto err3;
  80397f:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803980:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803984:	48 89 c6             	mov    %rax,%rsi
  803987:	bf 00 00 00 00       	mov    $0x0,%edi
  80398c:	48 b8 eb 1c 80 00 00 	movabs $0x801ceb,%rax
  803993:	00 00 00 
  803996:	ff d0                	callq  *%rax
  803998:	eb 79                	jmp    803a13 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80399a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80399e:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8039a5:	00 00 00 
  8039a8:	8b 12                	mov    (%rdx),%edx
  8039aa:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8039ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039b0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8039b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039bb:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8039c2:	00 00 00 
  8039c5:	8b 12                	mov    (%rdx),%edx
  8039c7:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8039c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039cd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8039d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039d8:	48 89 c7             	mov    %rax,%rdi
  8039db:	48 b8 20 20 80 00 00 	movabs $0x802020,%rax
  8039e2:	00 00 00 
  8039e5:	ff d0                	callq  *%rax
  8039e7:	89 c2                	mov    %eax,%edx
  8039e9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039ed:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8039ef:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039f3:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8039f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039fb:	48 89 c7             	mov    %rax,%rdi
  8039fe:	48 b8 20 20 80 00 00 	movabs $0x802020,%rax
  803a05:	00 00 00 
  803a08:	ff d0                	callq  *%rax
  803a0a:	89 03                	mov    %eax,(%rbx)
	return 0;
  803a0c:	b8 00 00 00 00       	mov    $0x0,%eax
  803a11:	eb 33                	jmp    803a46 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803a13:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a17:	48 89 c6             	mov    %rax,%rsi
  803a1a:	bf 00 00 00 00       	mov    $0x0,%edi
  803a1f:	48 b8 eb 1c 80 00 00 	movabs $0x801ceb,%rax
  803a26:	00 00 00 
  803a29:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803a2b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a2f:	48 89 c6             	mov    %rax,%rsi
  803a32:	bf 00 00 00 00       	mov    $0x0,%edi
  803a37:	48 b8 eb 1c 80 00 00 	movabs $0x801ceb,%rax
  803a3e:	00 00 00 
  803a41:	ff d0                	callq  *%rax
err:
	return r;
  803a43:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803a46:	48 83 c4 38          	add    $0x38,%rsp
  803a4a:	5b                   	pop    %rbx
  803a4b:	5d                   	pop    %rbp
  803a4c:	c3                   	retq   

0000000000803a4d <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803a4d:	55                   	push   %rbp
  803a4e:	48 89 e5             	mov    %rsp,%rbp
  803a51:	53                   	push   %rbx
  803a52:	48 83 ec 28          	sub    $0x28,%rsp
  803a56:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a5a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803a5e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a65:	00 00 00 
  803a68:	48 8b 00             	mov    (%rax),%rax
  803a6b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803a71:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803a74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a78:	48 89 c7             	mov    %rax,%rdi
  803a7b:	48 b8 bb 45 80 00 00 	movabs $0x8045bb,%rax
  803a82:	00 00 00 
  803a85:	ff d0                	callq  *%rax
  803a87:	89 c3                	mov    %eax,%ebx
  803a89:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a8d:	48 89 c7             	mov    %rax,%rdi
  803a90:	48 b8 bb 45 80 00 00 	movabs $0x8045bb,%rax
  803a97:	00 00 00 
  803a9a:	ff d0                	callq  *%rax
  803a9c:	39 c3                	cmp    %eax,%ebx
  803a9e:	0f 94 c0             	sete   %al
  803aa1:	0f b6 c0             	movzbl %al,%eax
  803aa4:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803aa7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803aae:	00 00 00 
  803ab1:	48 8b 00             	mov    (%rax),%rax
  803ab4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803aba:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803abd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ac0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ac3:	75 05                	jne    803aca <_pipeisclosed+0x7d>
			return ret;
  803ac5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803ac8:	eb 4f                	jmp    803b19 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803aca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803acd:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ad0:	74 42                	je     803b14 <_pipeisclosed+0xc7>
  803ad2:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803ad6:	75 3c                	jne    803b14 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803ad8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803adf:	00 00 00 
  803ae2:	48 8b 00             	mov    (%rax),%rax
  803ae5:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803aeb:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803aee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803af1:	89 c6                	mov    %eax,%esi
  803af3:	48 bf b5 4d 80 00 00 	movabs $0x804db5,%rdi
  803afa:	00 00 00 
  803afd:	b8 00 00 00 00       	mov    $0x0,%eax
  803b02:	49 b8 5c 07 80 00 00 	movabs $0x80075c,%r8
  803b09:	00 00 00 
  803b0c:	41 ff d0             	callq  *%r8
	}
  803b0f:	e9 4a ff ff ff       	jmpq   803a5e <_pipeisclosed+0x11>
  803b14:	e9 45 ff ff ff       	jmpq   803a5e <_pipeisclosed+0x11>

}
  803b19:	48 83 c4 28          	add    $0x28,%rsp
  803b1d:	5b                   	pop    %rbx
  803b1e:	5d                   	pop    %rbp
  803b1f:	c3                   	retq   

0000000000803b20 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803b20:	55                   	push   %rbp
  803b21:	48 89 e5             	mov    %rsp,%rbp
  803b24:	48 83 ec 30          	sub    $0x30,%rsp
  803b28:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b2b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803b2f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b32:	48 89 d6             	mov    %rdx,%rsi
  803b35:	89 c7                	mov    %eax,%edi
  803b37:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  803b3e:	00 00 00 
  803b41:	ff d0                	callq  *%rax
  803b43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b4a:	79 05                	jns    803b51 <pipeisclosed+0x31>
		return r;
  803b4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b4f:	eb 31                	jmp    803b82 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803b51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b55:	48 89 c7             	mov    %rax,%rdi
  803b58:	48 b8 43 20 80 00 00 	movabs $0x802043,%rax
  803b5f:	00 00 00 
  803b62:	ff d0                	callq  *%rax
  803b64:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803b68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b6c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b70:	48 89 d6             	mov    %rdx,%rsi
  803b73:	48 89 c7             	mov    %rax,%rdi
  803b76:	48 b8 4d 3a 80 00 00 	movabs $0x803a4d,%rax
  803b7d:	00 00 00 
  803b80:	ff d0                	callq  *%rax
}
  803b82:	c9                   	leaveq 
  803b83:	c3                   	retq   

0000000000803b84 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b84:	55                   	push   %rbp
  803b85:	48 89 e5             	mov    %rsp,%rbp
  803b88:	48 83 ec 40          	sub    $0x40,%rsp
  803b8c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b90:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b94:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803b98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b9c:	48 89 c7             	mov    %rax,%rdi
  803b9f:	48 b8 43 20 80 00 00 	movabs $0x802043,%rax
  803ba6:	00 00 00 
  803ba9:	ff d0                	callq  *%rax
  803bab:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803baf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bb3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803bb7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803bbe:	00 
  803bbf:	e9 92 00 00 00       	jmpq   803c56 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803bc4:	eb 41                	jmp    803c07 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803bc6:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803bcb:	74 09                	je     803bd6 <devpipe_read+0x52>
				return i;
  803bcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bd1:	e9 92 00 00 00       	jmpq   803c68 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803bd6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bda:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bde:	48 89 d6             	mov    %rdx,%rsi
  803be1:	48 89 c7             	mov    %rax,%rdi
  803be4:	48 b8 4d 3a 80 00 00 	movabs $0x803a4d,%rax
  803beb:	00 00 00 
  803bee:	ff d0                	callq  *%rax
  803bf0:	85 c0                	test   %eax,%eax
  803bf2:	74 07                	je     803bfb <devpipe_read+0x77>
				return 0;
  803bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf9:	eb 6d                	jmp    803c68 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803bfb:	48 b8 02 1c 80 00 00 	movabs $0x801c02,%rax
  803c02:	00 00 00 
  803c05:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803c07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c0b:	8b 10                	mov    (%rax),%edx
  803c0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c11:	8b 40 04             	mov    0x4(%rax),%eax
  803c14:	39 c2                	cmp    %eax,%edx
  803c16:	74 ae                	je     803bc6 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803c18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c1c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c20:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803c24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c28:	8b 00                	mov    (%rax),%eax
  803c2a:	99                   	cltd   
  803c2b:	c1 ea 1b             	shr    $0x1b,%edx
  803c2e:	01 d0                	add    %edx,%eax
  803c30:	83 e0 1f             	and    $0x1f,%eax
  803c33:	29 d0                	sub    %edx,%eax
  803c35:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c39:	48 98                	cltq   
  803c3b:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803c40:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803c42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c46:	8b 00                	mov    (%rax),%eax
  803c48:	8d 50 01             	lea    0x1(%rax),%edx
  803c4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c4f:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803c51:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c5a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c5e:	0f 82 60 ff ff ff    	jb     803bc4 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803c64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803c68:	c9                   	leaveq 
  803c69:	c3                   	retq   

0000000000803c6a <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c6a:	55                   	push   %rbp
  803c6b:	48 89 e5             	mov    %rsp,%rbp
  803c6e:	48 83 ec 40          	sub    $0x40,%rsp
  803c72:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c76:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c7a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803c7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c82:	48 89 c7             	mov    %rax,%rdi
  803c85:	48 b8 43 20 80 00 00 	movabs $0x802043,%rax
  803c8c:	00 00 00 
  803c8f:	ff d0                	callq  *%rax
  803c91:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803c95:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c99:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803c9d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ca4:	00 
  803ca5:	e9 8e 00 00 00       	jmpq   803d38 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803caa:	eb 31                	jmp    803cdd <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803cac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cb4:	48 89 d6             	mov    %rdx,%rsi
  803cb7:	48 89 c7             	mov    %rax,%rdi
  803cba:	48 b8 4d 3a 80 00 00 	movabs $0x803a4d,%rax
  803cc1:	00 00 00 
  803cc4:	ff d0                	callq  *%rax
  803cc6:	85 c0                	test   %eax,%eax
  803cc8:	74 07                	je     803cd1 <devpipe_write+0x67>
				return 0;
  803cca:	b8 00 00 00 00       	mov    $0x0,%eax
  803ccf:	eb 79                	jmp    803d4a <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803cd1:	48 b8 02 1c 80 00 00 	movabs $0x801c02,%rax
  803cd8:	00 00 00 
  803cdb:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803cdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce1:	8b 40 04             	mov    0x4(%rax),%eax
  803ce4:	48 63 d0             	movslq %eax,%rdx
  803ce7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ceb:	8b 00                	mov    (%rax),%eax
  803ced:	48 98                	cltq   
  803cef:	48 83 c0 20          	add    $0x20,%rax
  803cf3:	48 39 c2             	cmp    %rax,%rdx
  803cf6:	73 b4                	jae    803cac <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803cf8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cfc:	8b 40 04             	mov    0x4(%rax),%eax
  803cff:	99                   	cltd   
  803d00:	c1 ea 1b             	shr    $0x1b,%edx
  803d03:	01 d0                	add    %edx,%eax
  803d05:	83 e0 1f             	and    $0x1f,%eax
  803d08:	29 d0                	sub    %edx,%eax
  803d0a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803d0e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803d12:	48 01 ca             	add    %rcx,%rdx
  803d15:	0f b6 0a             	movzbl (%rdx),%ecx
  803d18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d1c:	48 98                	cltq   
  803d1e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803d22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d26:	8b 40 04             	mov    0x4(%rax),%eax
  803d29:	8d 50 01             	lea    0x1(%rax),%edx
  803d2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d30:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803d33:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803d38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d3c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803d40:	0f 82 64 ff ff ff    	jb     803caa <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803d46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803d4a:	c9                   	leaveq 
  803d4b:	c3                   	retq   

0000000000803d4c <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803d4c:	55                   	push   %rbp
  803d4d:	48 89 e5             	mov    %rsp,%rbp
  803d50:	48 83 ec 20          	sub    $0x20,%rsp
  803d54:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d58:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803d5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d60:	48 89 c7             	mov    %rax,%rdi
  803d63:	48 b8 43 20 80 00 00 	movabs $0x802043,%rax
  803d6a:	00 00 00 
  803d6d:	ff d0                	callq  *%rax
  803d6f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803d73:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d77:	48 be c8 4d 80 00 00 	movabs $0x804dc8,%rsi
  803d7e:	00 00 00 
  803d81:	48 89 c7             	mov    %rax,%rdi
  803d84:	48 b8 11 13 80 00 00 	movabs $0x801311,%rax
  803d8b:	00 00 00 
  803d8e:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803d90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d94:	8b 50 04             	mov    0x4(%rax),%edx
  803d97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d9b:	8b 00                	mov    (%rax),%eax
  803d9d:	29 c2                	sub    %eax,%edx
  803d9f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803da3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803da9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dad:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803db4:	00 00 00 
	stat->st_dev = &devpipe;
  803db7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dbb:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803dc2:	00 00 00 
  803dc5:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803dcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dd1:	c9                   	leaveq 
  803dd2:	c3                   	retq   

0000000000803dd3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803dd3:	55                   	push   %rbp
  803dd4:	48 89 e5             	mov    %rsp,%rbp
  803dd7:	48 83 ec 10          	sub    $0x10,%rsp
  803ddb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  803ddf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803de3:	48 89 c6             	mov    %rax,%rsi
  803de6:	bf 00 00 00 00       	mov    $0x0,%edi
  803deb:	48 b8 eb 1c 80 00 00 	movabs $0x801ceb,%rax
  803df2:	00 00 00 
  803df5:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  803df7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dfb:	48 89 c7             	mov    %rax,%rdi
  803dfe:	48 b8 43 20 80 00 00 	movabs $0x802043,%rax
  803e05:	00 00 00 
  803e08:	ff d0                	callq  *%rax
  803e0a:	48 89 c6             	mov    %rax,%rsi
  803e0d:	bf 00 00 00 00       	mov    $0x0,%edi
  803e12:	48 b8 eb 1c 80 00 00 	movabs $0x801ceb,%rax
  803e19:	00 00 00 
  803e1c:	ff d0                	callq  *%rax
}
  803e1e:	c9                   	leaveq 
  803e1f:	c3                   	retq   

0000000000803e20 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803e20:	55                   	push   %rbp
  803e21:	48 89 e5             	mov    %rsp,%rbp
  803e24:	48 83 ec 20          	sub    $0x20,%rsp
  803e28:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  803e2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e2f:	75 35                	jne    803e66 <wait+0x46>
  803e31:	48 b9 cf 4d 80 00 00 	movabs $0x804dcf,%rcx
  803e38:	00 00 00 
  803e3b:	48 ba da 4d 80 00 00 	movabs $0x804dda,%rdx
  803e42:	00 00 00 
  803e45:	be 0a 00 00 00       	mov    $0xa,%esi
  803e4a:	48 bf ef 4d 80 00 00 	movabs $0x804def,%rdi
  803e51:	00 00 00 
  803e54:	b8 00 00 00 00       	mov    $0x0,%eax
  803e59:	49 b8 68 41 80 00 00 	movabs $0x804168,%r8
  803e60:	00 00 00 
  803e63:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  803e66:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e69:	25 ff 03 00 00       	and    $0x3ff,%eax
  803e6e:	48 98                	cltq   
  803e70:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803e77:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e7e:	00 00 00 
  803e81:	48 01 d0             	add    %rdx,%rax
  803e84:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803e88:	eb 0c                	jmp    803e96 <wait+0x76>
		sys_yield();
  803e8a:	48 b8 02 1c 80 00 00 	movabs $0x801c02,%rax
  803e91:	00 00 00 
  803e94:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803e96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e9a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803ea0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803ea3:	75 0e                	jne    803eb3 <wait+0x93>
  803ea5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ea9:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803eaf:	85 c0                	test   %eax,%eax
  803eb1:	75 d7                	jne    803e8a <wait+0x6a>
		sys_yield();
}
  803eb3:	c9                   	leaveq 
  803eb4:	c3                   	retq   

0000000000803eb5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803eb5:	55                   	push   %rbp
  803eb6:	48 89 e5             	mov    %rsp,%rbp
  803eb9:	48 83 ec 20          	sub    $0x20,%rsp
  803ebd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803ec0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ec3:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803ec6:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803eca:	be 01 00 00 00       	mov    $0x1,%esi
  803ecf:	48 89 c7             	mov    %rax,%rdi
  803ed2:	48 b8 f8 1a 80 00 00 	movabs $0x801af8,%rax
  803ed9:	00 00 00 
  803edc:	ff d0                	callq  *%rax
}
  803ede:	c9                   	leaveq 
  803edf:	c3                   	retq   

0000000000803ee0 <getchar>:

int
getchar(void)
{
  803ee0:	55                   	push   %rbp
  803ee1:	48 89 e5             	mov    %rsp,%rbp
  803ee4:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803ee8:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803eec:	ba 01 00 00 00       	mov    $0x1,%edx
  803ef1:	48 89 c6             	mov    %rax,%rsi
  803ef4:	bf 00 00 00 00       	mov    $0x0,%edi
  803ef9:	48 b8 38 25 80 00 00 	movabs $0x802538,%rax
  803f00:	00 00 00 
  803f03:	ff d0                	callq  *%rax
  803f05:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803f08:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f0c:	79 05                	jns    803f13 <getchar+0x33>
		return r;
  803f0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f11:	eb 14                	jmp    803f27 <getchar+0x47>
	if (r < 1)
  803f13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f17:	7f 07                	jg     803f20 <getchar+0x40>
		return -E_EOF;
  803f19:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803f1e:	eb 07                	jmp    803f27 <getchar+0x47>
	return c;
  803f20:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803f24:	0f b6 c0             	movzbl %al,%eax

}
  803f27:	c9                   	leaveq 
  803f28:	c3                   	retq   

0000000000803f29 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803f29:	55                   	push   %rbp
  803f2a:	48 89 e5             	mov    %rsp,%rbp
  803f2d:	48 83 ec 20          	sub    $0x20,%rsp
  803f31:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f34:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803f38:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f3b:	48 89 d6             	mov    %rdx,%rsi
  803f3e:	89 c7                	mov    %eax,%edi
  803f40:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  803f47:	00 00 00 
  803f4a:	ff d0                	callq  *%rax
  803f4c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f53:	79 05                	jns    803f5a <iscons+0x31>
		return r;
  803f55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f58:	eb 1a                	jmp    803f74 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803f5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f5e:	8b 10                	mov    (%rax),%edx
  803f60:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803f67:	00 00 00 
  803f6a:	8b 00                	mov    (%rax),%eax
  803f6c:	39 c2                	cmp    %eax,%edx
  803f6e:	0f 94 c0             	sete   %al
  803f71:	0f b6 c0             	movzbl %al,%eax
}
  803f74:	c9                   	leaveq 
  803f75:	c3                   	retq   

0000000000803f76 <opencons>:

int
opencons(void)
{
  803f76:	55                   	push   %rbp
  803f77:	48 89 e5             	mov    %rsp,%rbp
  803f7a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803f7e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803f82:	48 89 c7             	mov    %rax,%rdi
  803f85:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  803f8c:	00 00 00 
  803f8f:	ff d0                	callq  *%rax
  803f91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f98:	79 05                	jns    803f9f <opencons+0x29>
		return r;
  803f9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f9d:	eb 5b                	jmp    803ffa <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803f9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fa3:	ba 07 04 00 00       	mov    $0x407,%edx
  803fa8:	48 89 c6             	mov    %rax,%rsi
  803fab:	bf 00 00 00 00       	mov    $0x0,%edi
  803fb0:	48 b8 40 1c 80 00 00 	movabs $0x801c40,%rax
  803fb7:	00 00 00 
  803fba:	ff d0                	callq  *%rax
  803fbc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fbf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fc3:	79 05                	jns    803fca <opencons+0x54>
		return r;
  803fc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc8:	eb 30                	jmp    803ffa <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803fca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fce:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803fd5:	00 00 00 
  803fd8:	8b 12                	mov    (%rdx),%edx
  803fda:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803fdc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803fe7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803feb:	48 89 c7             	mov    %rax,%rdi
  803fee:	48 b8 20 20 80 00 00 	movabs $0x802020,%rax
  803ff5:	00 00 00 
  803ff8:	ff d0                	callq  *%rax
}
  803ffa:	c9                   	leaveq 
  803ffb:	c3                   	retq   

0000000000803ffc <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803ffc:	55                   	push   %rbp
  803ffd:	48 89 e5             	mov    %rsp,%rbp
  804000:	48 83 ec 30          	sub    $0x30,%rsp
  804004:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804008:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80400c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804010:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804015:	75 07                	jne    80401e <devcons_read+0x22>
		return 0;
  804017:	b8 00 00 00 00       	mov    $0x0,%eax
  80401c:	eb 4b                	jmp    804069 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80401e:	eb 0c                	jmp    80402c <devcons_read+0x30>
		sys_yield();
  804020:	48 b8 02 1c 80 00 00 	movabs $0x801c02,%rax
  804027:	00 00 00 
  80402a:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80402c:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  804033:	00 00 00 
  804036:	ff d0                	callq  *%rax
  804038:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80403b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80403f:	74 df                	je     804020 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804041:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804045:	79 05                	jns    80404c <devcons_read+0x50>
		return c;
  804047:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80404a:	eb 1d                	jmp    804069 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80404c:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804050:	75 07                	jne    804059 <devcons_read+0x5d>
		return 0;
  804052:	b8 00 00 00 00       	mov    $0x0,%eax
  804057:	eb 10                	jmp    804069 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804059:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80405c:	89 c2                	mov    %eax,%edx
  80405e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804062:	88 10                	mov    %dl,(%rax)
	return 1;
  804064:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804069:	c9                   	leaveq 
  80406a:	c3                   	retq   

000000000080406b <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80406b:	55                   	push   %rbp
  80406c:	48 89 e5             	mov    %rsp,%rbp
  80406f:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804076:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80407d:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804084:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80408b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804092:	eb 76                	jmp    80410a <devcons_write+0x9f>
		m = n - tot;
  804094:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80409b:	89 c2                	mov    %eax,%edx
  80409d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040a0:	29 c2                	sub    %eax,%edx
  8040a2:	89 d0                	mov    %edx,%eax
  8040a4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8040a7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040aa:	83 f8 7f             	cmp    $0x7f,%eax
  8040ad:	76 07                	jbe    8040b6 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8040af:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8040b6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040b9:	48 63 d0             	movslq %eax,%rdx
  8040bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040bf:	48 63 c8             	movslq %eax,%rcx
  8040c2:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8040c9:	48 01 c1             	add    %rax,%rcx
  8040cc:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8040d3:	48 89 ce             	mov    %rcx,%rsi
  8040d6:	48 89 c7             	mov    %rax,%rdi
  8040d9:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  8040e0:	00 00 00 
  8040e3:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8040e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040e8:	48 63 d0             	movslq %eax,%rdx
  8040eb:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8040f2:	48 89 d6             	mov    %rdx,%rsi
  8040f5:	48 89 c7             	mov    %rax,%rdi
  8040f8:	48 b8 f8 1a 80 00 00 	movabs $0x801af8,%rax
  8040ff:	00 00 00 
  804102:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804104:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804107:	01 45 fc             	add    %eax,-0x4(%rbp)
  80410a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80410d:	48 98                	cltq   
  80410f:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804116:	0f 82 78 ff ff ff    	jb     804094 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80411c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80411f:	c9                   	leaveq 
  804120:	c3                   	retq   

0000000000804121 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804121:	55                   	push   %rbp
  804122:	48 89 e5             	mov    %rsp,%rbp
  804125:	48 83 ec 08          	sub    $0x8,%rsp
  804129:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80412d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804132:	c9                   	leaveq 
  804133:	c3                   	retq   

0000000000804134 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804134:	55                   	push   %rbp
  804135:	48 89 e5             	mov    %rsp,%rbp
  804138:	48 83 ec 10          	sub    $0x10,%rsp
  80413c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804140:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804144:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804148:	48 be ff 4d 80 00 00 	movabs $0x804dff,%rsi
  80414f:	00 00 00 
  804152:	48 89 c7             	mov    %rax,%rdi
  804155:	48 b8 11 13 80 00 00 	movabs $0x801311,%rax
  80415c:	00 00 00 
  80415f:	ff d0                	callq  *%rax
	return 0;
  804161:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804166:	c9                   	leaveq 
  804167:	c3                   	retq   

0000000000804168 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  804168:	55                   	push   %rbp
  804169:	48 89 e5             	mov    %rsp,%rbp
  80416c:	53                   	push   %rbx
  80416d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  804174:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80417b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  804181:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  804188:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80418f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  804196:	84 c0                	test   %al,%al
  804198:	74 23                	je     8041bd <_panic+0x55>
  80419a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8041a1:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8041a5:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8041a9:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8041ad:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8041b1:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8041b5:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8041b9:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8041bd:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8041c4:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8041cb:	00 00 00 
  8041ce:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8041d5:	00 00 00 
  8041d8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8041dc:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8041e3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8041ea:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8041f1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8041f8:	00 00 00 
  8041fb:	48 8b 18             	mov    (%rax),%rbx
  8041fe:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  804205:	00 00 00 
  804208:	ff d0                	callq  *%rax
  80420a:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  804210:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  804217:	41 89 c8             	mov    %ecx,%r8d
  80421a:	48 89 d1             	mov    %rdx,%rcx
  80421d:	48 89 da             	mov    %rbx,%rdx
  804220:	89 c6                	mov    %eax,%esi
  804222:	48 bf 08 4e 80 00 00 	movabs $0x804e08,%rdi
  804229:	00 00 00 
  80422c:	b8 00 00 00 00       	mov    $0x0,%eax
  804231:	49 b9 5c 07 80 00 00 	movabs $0x80075c,%r9
  804238:	00 00 00 
  80423b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80423e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  804245:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80424c:	48 89 d6             	mov    %rdx,%rsi
  80424f:	48 89 c7             	mov    %rax,%rdi
  804252:	48 b8 b0 06 80 00 00 	movabs $0x8006b0,%rax
  804259:	00 00 00 
  80425c:	ff d0                	callq  *%rax
	cprintf("\n");
  80425e:	48 bf 2b 4e 80 00 00 	movabs $0x804e2b,%rdi
  804265:	00 00 00 
  804268:	b8 00 00 00 00       	mov    $0x0,%eax
  80426d:	48 ba 5c 07 80 00 00 	movabs $0x80075c,%rdx
  804274:	00 00 00 
  804277:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  804279:	cc                   	int3   
  80427a:	eb fd                	jmp    804279 <_panic+0x111>

000000000080427c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80427c:	55                   	push   %rbp
  80427d:	48 89 e5             	mov    %rsp,%rbp
  804280:	48 83 ec 30          	sub    $0x30,%rsp
  804284:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804288:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80428c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  804290:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804295:	75 0e                	jne    8042a5 <ipc_recv+0x29>
		pg = (void*) UTOP;
  804297:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80429e:	00 00 00 
  8042a1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  8042a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042a9:	48 89 c7             	mov    %rax,%rdi
  8042ac:	48 b8 69 1e 80 00 00 	movabs $0x801e69,%rax
  8042b3:	00 00 00 
  8042b6:	ff d0                	callq  *%rax
  8042b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042bf:	79 27                	jns    8042e8 <ipc_recv+0x6c>
		if (from_env_store)
  8042c1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8042c6:	74 0a                	je     8042d2 <ipc_recv+0x56>
			*from_env_store = 0;
  8042c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042cc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8042d2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8042d7:	74 0a                	je     8042e3 <ipc_recv+0x67>
			*perm_store = 0;
  8042d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042dd:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8042e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042e6:	eb 53                	jmp    80433b <ipc_recv+0xbf>
	}
	if (from_env_store)
  8042e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8042ed:	74 19                	je     804308 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8042ef:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8042f6:	00 00 00 
  8042f9:	48 8b 00             	mov    (%rax),%rax
  8042fc:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804302:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804306:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  804308:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80430d:	74 19                	je     804328 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  80430f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804316:	00 00 00 
  804319:	48 8b 00             	mov    (%rax),%rax
  80431c:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804322:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804326:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804328:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80432f:	00 00 00 
  804332:	48 8b 00             	mov    (%rax),%rax
  804335:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  80433b:	c9                   	leaveq 
  80433c:	c3                   	retq   

000000000080433d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80433d:	55                   	push   %rbp
  80433e:	48 89 e5             	mov    %rsp,%rbp
  804341:	48 83 ec 30          	sub    $0x30,%rsp
  804345:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804348:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80434b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80434f:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804352:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804357:	75 10                	jne    804369 <ipc_send+0x2c>
		pg = (void*) UTOP;
  804359:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804360:	00 00 00 
  804363:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804367:	eb 0e                	jmp    804377 <ipc_send+0x3a>
  804369:	eb 0c                	jmp    804377 <ipc_send+0x3a>
		sys_yield();
  80436b:	48 b8 02 1c 80 00 00 	movabs $0x801c02,%rax
  804372:	00 00 00 
  804375:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804377:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80437a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80437d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804381:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804384:	89 c7                	mov    %eax,%edi
  804386:	48 b8 14 1e 80 00 00 	movabs $0x801e14,%rax
  80438d:	00 00 00 
  804390:	ff d0                	callq  *%rax
  804392:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804395:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804399:	74 d0                	je     80436b <ipc_send+0x2e>
		sys_yield();
	}
	if (r < 0)
  80439b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80439f:	79 30                	jns    8043d1 <ipc_send+0x94>
		panic("error in ipc_send: %e", r);
  8043a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043a4:	89 c1                	mov    %eax,%ecx
  8043a6:	48 ba 2d 4e 80 00 00 	movabs $0x804e2d,%rdx
  8043ad:	00 00 00 
  8043b0:	be 47 00 00 00       	mov    $0x47,%esi
  8043b5:	48 bf 43 4e 80 00 00 	movabs $0x804e43,%rdi
  8043bc:	00 00 00 
  8043bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8043c4:	49 b8 68 41 80 00 00 	movabs $0x804168,%r8
  8043cb:	00 00 00 
  8043ce:	41 ff d0             	callq  *%r8

}
  8043d1:	c9                   	leaveq 
  8043d2:	c3                   	retq   

00000000008043d3 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8043d3:	55                   	push   %rbp
  8043d4:	48 89 e5             	mov    %rsp,%rbp
  8043d7:	53                   	push   %rbx
  8043d8:	48 83 ec 28          	sub    $0x28,%rsp
  8043dc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  8043e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8043e7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  8043ee:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8043f3:	75 0e                	jne    804403 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  8043f5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8043fc:	00 00 00 
  8043ff:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  804403:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804407:	ba 07 00 00 00       	mov    $0x7,%edx
  80440c:	48 89 c6             	mov    %rax,%rsi
  80440f:	bf 00 00 00 00       	mov    $0x0,%edi
  804414:	48 b8 40 1c 80 00 00 	movabs $0x801c40,%rax
  80441b:	00 00 00 
  80441e:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804420:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804424:	48 c1 e8 0c          	shr    $0xc,%rax
  804428:	48 89 c2             	mov    %rax,%rdx
  80442b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804432:	01 00 00 
  804435:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804439:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80443f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  804443:	b8 03 00 00 00       	mov    $0x3,%eax
  804448:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80444c:	48 89 d3             	mov    %rdx,%rbx
  80444f:	0f 01 c1             	vmcall 
  804452:	89 f2                	mov    %esi,%edx
  804454:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804457:	89 55 e8             	mov    %edx,-0x18(%rbp)
	/* cprintf("Returned IPC response from host: %d %d\n", r, -val);*/
	if (r < 0) {
  80445a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80445e:	79 05                	jns    804465 <ipc_host_recv+0x92>
		return r;
  804460:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804463:	eb 03                	jmp    804468 <ipc_host_recv+0x95>
	}
	return val;
  804465:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  804468:	48 83 c4 28          	add    $0x28,%rsp
  80446c:	5b                   	pop    %rbx
  80446d:	5d                   	pop    %rbp
  80446e:	c3                   	retq   

000000000080446f <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80446f:	55                   	push   %rbp
  804470:	48 89 e5             	mov    %rsp,%rbp
  804473:	53                   	push   %rbx
  804474:	48 83 ec 38          	sub    $0x38,%rsp
  804478:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80447b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80447e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804482:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  804485:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  80448c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  804491:	75 0e                	jne    8044a1 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  804493:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80449a:	00 00 00 
  80449d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8044a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044a5:	48 c1 e8 0c          	shr    $0xc,%rax
  8044a9:	48 89 c2             	mov    %rax,%rdx
  8044ac:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8044b3:	01 00 00 
  8044b6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044ba:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8044c0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8044c4:	b8 02 00 00 00       	mov    $0x2,%eax
  8044c9:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8044cc:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8044cf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8044d3:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8044d6:	89 fb                	mov    %edi,%ebx
  8044d8:	0f 01 c1             	vmcall 
  8044db:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8044de:	eb 26                	jmp    804506 <ipc_host_send+0x97>
		sys_yield();
  8044e0:	48 b8 02 1c 80 00 00 	movabs $0x801c02,%rax
  8044e7:	00 00 00 
  8044ea:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8044ec:	b8 02 00 00 00       	mov    $0x2,%eax
  8044f1:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8044f4:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8044f7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8044fb:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8044fe:	89 fb                	mov    %edi,%ebx
  804500:	0f 01 c1             	vmcall 
  804503:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804506:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  80450a:	74 d4                	je     8044e0 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  80450c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804510:	79 30                	jns    804542 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  804512:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804515:	89 c1                	mov    %eax,%ecx
  804517:	48 ba 2d 4e 80 00 00 	movabs $0x804e2d,%rdx
  80451e:	00 00 00 
  804521:	be 79 00 00 00       	mov    $0x79,%esi
  804526:	48 bf 43 4e 80 00 00 	movabs $0x804e43,%rdi
  80452d:	00 00 00 
  804530:	b8 00 00 00 00       	mov    $0x0,%eax
  804535:	49 b8 68 41 80 00 00 	movabs $0x804168,%r8
  80453c:	00 00 00 
  80453f:	41 ff d0             	callq  *%r8

}
  804542:	48 83 c4 38          	add    $0x38,%rsp
  804546:	5b                   	pop    %rbx
  804547:	5d                   	pop    %rbp
  804548:	c3                   	retq   

0000000000804549 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804549:	55                   	push   %rbp
  80454a:	48 89 e5             	mov    %rsp,%rbp
  80454d:	48 83 ec 14          	sub    $0x14,%rsp
  804551:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804554:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80455b:	eb 4e                	jmp    8045ab <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  80455d:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804564:	00 00 00 
  804567:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80456a:	48 98                	cltq   
  80456c:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804573:	48 01 d0             	add    %rdx,%rax
  804576:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80457c:	8b 00                	mov    (%rax),%eax
  80457e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804581:	75 24                	jne    8045a7 <ipc_find_env+0x5e>
			return envs[i].env_id;
  804583:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80458a:	00 00 00 
  80458d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804590:	48 98                	cltq   
  804592:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804599:	48 01 d0             	add    %rdx,%rax
  80459c:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8045a2:	8b 40 08             	mov    0x8(%rax),%eax
  8045a5:	eb 12                	jmp    8045b9 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8045a7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8045ab:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8045b2:	7e a9                	jle    80455d <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8045b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8045b9:	c9                   	leaveq 
  8045ba:	c3                   	retq   

00000000008045bb <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  8045bb:	55                   	push   %rbp
  8045bc:	48 89 e5             	mov    %rsp,%rbp
  8045bf:	48 83 ec 18          	sub    $0x18,%rsp
  8045c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8045c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045cb:	48 c1 e8 15          	shr    $0x15,%rax
  8045cf:	48 89 c2             	mov    %rax,%rdx
  8045d2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8045d9:	01 00 00 
  8045dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8045e0:	83 e0 01             	and    $0x1,%eax
  8045e3:	48 85 c0             	test   %rax,%rax
  8045e6:	75 07                	jne    8045ef <pageref+0x34>
		return 0;
  8045e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8045ed:	eb 53                	jmp    804642 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8045ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045f3:	48 c1 e8 0c          	shr    $0xc,%rax
  8045f7:	48 89 c2             	mov    %rax,%rdx
  8045fa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804601:	01 00 00 
  804604:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804608:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80460c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804610:	83 e0 01             	and    $0x1,%eax
  804613:	48 85 c0             	test   %rax,%rax
  804616:	75 07                	jne    80461f <pageref+0x64>
		return 0;
  804618:	b8 00 00 00 00       	mov    $0x0,%eax
  80461d:	eb 23                	jmp    804642 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80461f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804623:	48 c1 e8 0c          	shr    $0xc,%rax
  804627:	48 89 c2             	mov    %rax,%rdx
  80462a:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804631:	00 00 00 
  804634:	48 c1 e2 04          	shl    $0x4,%rdx
  804638:	48 01 d0             	add    %rdx,%rax
  80463b:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80463f:	0f b7 c0             	movzwl %ax,%eax
}
  804642:	c9                   	leaveq 
  804643:	c3                   	retq   
