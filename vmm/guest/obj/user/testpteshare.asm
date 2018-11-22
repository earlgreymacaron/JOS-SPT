
vmm/guest/obj/user/testpteshare:     file format elf64-x86-64


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
  80003c:	e8 67 02 00 00       	callq  8002a8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (argc != 0)
  800052:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800056:	74 0c                	je     800064 <umain+0x21>
		childofspawn();
  800058:	48 b8 75 02 80 00 00 	movabs $0x800275,%rax
  80005f:	00 00 00 
  800062:	ff d0                	callq  *%rax

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	ba 07 04 00 00       	mov    $0x407,%edx
  800069:	be 00 00 00 a0       	mov    $0xa0000000,%esi
  80006e:	bf 00 00 00 00       	mov    $0x0,%edi
  800073:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  80007a:	00 00 00 
  80007d:	ff d0                	callq  *%rax
  80007f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800082:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800086:	79 30                	jns    8000b8 <umain+0x75>
		panic("sys_page_alloc: %e", r);
  800088:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008b:	89 c1                	mov    %eax,%ecx
  80008d:	48 ba 3e 56 80 00 00 	movabs $0x80563e,%rdx
  800094:	00 00 00 
  800097:	be 14 00 00 00       	mov    $0x14,%esi
  80009c:	48 bf 51 56 80 00 00 	movabs $0x805651,%rdi
  8000a3:	00 00 00 
  8000a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ab:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  8000b2:	00 00 00 
  8000b5:	41 ff d0             	callq  *%r8

	// check fork
	if ((r = fork()) < 0)
  8000b8:	48 b8 eb 21 80 00 00 	movabs $0x8021eb,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xba>
		panic("fork: %e", r);
  8000cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba 65 56 80 00 00 	movabs $0x805665,%rdx
  8000d9:	00 00 00 
  8000dc:	be 18 00 00 00       	mov    $0x18,%esi
  8000e1:	48 bf 51 56 80 00 00 	movabs $0x805651,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800101:	75 2d                	jne    800130 <umain+0xed>
		strcpy(VA, msg);
  800103:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80010a:	00 00 00 
  80010d:	48 8b 00             	mov    (%rax),%rax
  800110:	48 89 c6             	mov    %rax,%rsi
  800113:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800118:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
		exit();
  800124:	48 b8 2b 03 80 00 00 	movabs $0x80032b,%rax
  80012b:	00 00 00 
  80012e:	ff d0                	callq  *%rax
	}
	wait(r);
  800130:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800133:	89 c7                	mov    %eax,%edi
  800135:	48 b8 ca 4d 80 00 00 	movabs $0x804dca,%rax
  80013c:	00 00 00 
  80013f:	ff d0                	callq  *%rax
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  800141:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800148:	00 00 00 
  80014b:	48 8b 00             	mov    (%rax),%rax
  80014e:	48 89 c6             	mov    %rax,%rsi
  800151:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800156:	48 b8 9e 12 80 00 00 	movabs $0x80129e,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	85 c0                	test   %eax,%eax
  800164:	75 0c                	jne    800172 <umain+0x12f>
  800166:	48 b8 6e 56 80 00 00 	movabs $0x80566e,%rax
  80016d:	00 00 00 
  800170:	eb 0a                	jmp    80017c <umain+0x139>
  800172:	48 b8 74 56 80 00 00 	movabs $0x805674,%rax
  800179:	00 00 00 
  80017c:	48 89 c6             	mov    %rax,%rsi
  80017f:	48 bf 7a 56 80 00 00 	movabs $0x80567a,%rdi
  800186:	00 00 00 
  800189:	b8 00 00 00 00       	mov    $0x0,%eax
  80018e:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  800195:	00 00 00 
  800198:	ff d2                	callq  *%rdx

	// check spawn
	if ((r = spawnl("/bin/testpteshare", "testpteshare", "arg", 0)) < 0)
  80019a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80019f:	48 ba 95 56 80 00 00 	movabs $0x805695,%rdx
  8001a6:	00 00 00 
  8001a9:	48 be 99 56 80 00 00 	movabs $0x805699,%rsi
  8001b0:	00 00 00 
  8001b3:	48 bf a6 56 80 00 00 	movabs $0x8056a6,%rdi
  8001ba:	00 00 00 
  8001bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c2:	49 b8 de 37 80 00 00 	movabs $0x8037de,%r8
  8001c9:	00 00 00 
  8001cc:	41 ff d0             	callq  *%r8
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d6:	79 30                	jns    800208 <umain+0x1c5>
		panic("spawn: %e", r);
  8001d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001db:	89 c1                	mov    %eax,%ecx
  8001dd:	48 ba b8 56 80 00 00 	movabs $0x8056b8,%rdx
  8001e4:	00 00 00 
  8001e7:	be 22 00 00 00       	mov    $0x22,%esi
  8001ec:	48 bf 51 56 80 00 00 	movabs $0x805651,%rdi
  8001f3:	00 00 00 
  8001f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fb:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  800202:	00 00 00 
  800205:	41 ff d0             	callq  *%r8
	wait(r);
  800208:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80020b:	89 c7                	mov    %eax,%edi
  80020d:	48 b8 ca 4d 80 00 00 	movabs $0x804dca,%rax
  800214:	00 00 00 
  800217:	ff d0                	callq  *%rax
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  800219:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800220:	00 00 00 
  800223:	48 8b 00             	mov    (%rax),%rax
  800226:	48 89 c6             	mov    %rax,%rsi
  800229:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80022e:	48 b8 9e 12 80 00 00 	movabs $0x80129e,%rax
  800235:	00 00 00 
  800238:	ff d0                	callq  *%rax
  80023a:	85 c0                	test   %eax,%eax
  80023c:	75 0c                	jne    80024a <umain+0x207>
  80023e:	48 b8 6e 56 80 00 00 	movabs $0x80566e,%rax
  800245:	00 00 00 
  800248:	eb 0a                	jmp    800254 <umain+0x211>
  80024a:	48 b8 74 56 80 00 00 	movabs $0x805674,%rax
  800251:	00 00 00 
  800254:	48 89 c6             	mov    %rax,%rsi
  800257:	48 bf c2 56 80 00 00 	movabs $0x8056c2,%rdi
  80025e:	00 00 00 
  800261:	b8 00 00 00 00       	mov    $0x0,%eax
  800266:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  80026d:	00 00 00 
  800270:	ff d2                	callq  *%rdx
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800272:	cc                   	int3   

	breakpoint();
}
  800273:	c9                   	leaveq 
  800274:	c3                   	retq   

0000000000800275 <childofspawn>:

void
childofspawn(void)
{
  800275:	55                   	push   %rbp
  800276:	48 89 e5             	mov    %rsp,%rbp
	strcpy(VA, msg2);
  800279:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800280:	00 00 00 
  800283:	48 8b 00             	mov    (%rax),%rax
  800286:	48 89 c6             	mov    %rax,%rsi
  800289:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80028e:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
	exit();
  80029a:	48 b8 2b 03 80 00 00 	movabs $0x80032b,%rax
  8002a1:	00 00 00 
  8002a4:	ff d0                	callq  *%rax
}
  8002a6:	5d                   	pop    %rbp
  8002a7:	c3                   	retq   

00000000008002a8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
  8002ac:	48 83 ec 10          	sub    $0x10,%rsp
  8002b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  8002b7:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  8002be:	00 00 00 
  8002c1:	ff d0                	callq  *%rax
  8002c3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002c8:	48 98                	cltq   
  8002ca:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8002d1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8002d8:	00 00 00 
  8002db:	48 01 c2             	add    %rax,%rdx
  8002de:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8002e5:	00 00 00 
  8002e8:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002ef:	7e 14                	jle    800305 <libmain+0x5d>
		binaryname = argv[0];
  8002f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002f5:	48 8b 10             	mov    (%rax),%rdx
  8002f8:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8002ff:	00 00 00 
  800302:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800305:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800309:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80030c:	48 89 d6             	mov    %rdx,%rsi
  80030f:	89 c7                	mov    %eax,%edi
  800311:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800318:	00 00 00 
  80031b:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80031d:	48 b8 2b 03 80 00 00 	movabs $0x80032b,%rax
  800324:	00 00 00 
  800327:	ff d0                	callq  *%rax
}
  800329:	c9                   	leaveq 
  80032a:	c3                   	retq   

000000000080032b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80032b:	55                   	push   %rbp
  80032c:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  80032f:	48 b8 a1 27 80 00 00 	movabs $0x8027a1,%rax
  800336:	00 00 00 
  800339:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  80033b:	bf 00 00 00 00       	mov    $0x0,%edi
  800340:	48 b8 ab 19 80 00 00 	movabs $0x8019ab,%rax
  800347:	00 00 00 
  80034a:	ff d0                	callq  *%rax
}
  80034c:	5d                   	pop    %rbp
  80034d:	c3                   	retq   

000000000080034e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80034e:	55                   	push   %rbp
  80034f:	48 89 e5             	mov    %rsp,%rbp
  800352:	53                   	push   %rbx
  800353:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80035a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800361:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800367:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80036e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800375:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80037c:	84 c0                	test   %al,%al
  80037e:	74 23                	je     8003a3 <_panic+0x55>
  800380:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800387:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80038b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80038f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800393:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800397:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80039b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80039f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003a3:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003aa:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003b1:	00 00 00 
  8003b4:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003bb:	00 00 00 
  8003be:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003c2:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8003c9:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8003d0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003d7:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8003de:	00 00 00 
  8003e1:	48 8b 18             	mov    (%rax),%rbx
  8003e4:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  8003eb:	00 00 00 
  8003ee:	ff d0                	callq  *%rax
  8003f0:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8003f6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8003fd:	41 89 c8             	mov    %ecx,%r8d
  800400:	48 89 d1             	mov    %rdx,%rcx
  800403:	48 89 da             	mov    %rbx,%rdx
  800406:	89 c6                	mov    %eax,%esi
  800408:	48 bf e8 56 80 00 00 	movabs $0x8056e8,%rdi
  80040f:	00 00 00 
  800412:	b8 00 00 00 00       	mov    $0x0,%eax
  800417:	49 b9 87 05 80 00 00 	movabs $0x800587,%r9
  80041e:	00 00 00 
  800421:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800424:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80042b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800432:	48 89 d6             	mov    %rdx,%rsi
  800435:	48 89 c7             	mov    %rax,%rdi
  800438:	48 b8 db 04 80 00 00 	movabs $0x8004db,%rax
  80043f:	00 00 00 
  800442:	ff d0                	callq  *%rax
	cprintf("\n");
  800444:	48 bf 0b 57 80 00 00 	movabs $0x80570b,%rdi
  80044b:	00 00 00 
  80044e:	b8 00 00 00 00       	mov    $0x0,%eax
  800453:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  80045a:	00 00 00 
  80045d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80045f:	cc                   	int3   
  800460:	eb fd                	jmp    80045f <_panic+0x111>

0000000000800462 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800462:	55                   	push   %rbp
  800463:	48 89 e5             	mov    %rsp,%rbp
  800466:	48 83 ec 10          	sub    $0x10,%rsp
  80046a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80046d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800471:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800475:	8b 00                	mov    (%rax),%eax
  800477:	8d 48 01             	lea    0x1(%rax),%ecx
  80047a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80047e:	89 0a                	mov    %ecx,(%rdx)
  800480:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800483:	89 d1                	mov    %edx,%ecx
  800485:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800489:	48 98                	cltq   
  80048b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80048f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800493:	8b 00                	mov    (%rax),%eax
  800495:	3d ff 00 00 00       	cmp    $0xff,%eax
  80049a:	75 2c                	jne    8004c8 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80049c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a0:	8b 00                	mov    (%rax),%eax
  8004a2:	48 98                	cltq   
  8004a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004a8:	48 83 c2 08          	add    $0x8,%rdx
  8004ac:	48 89 c6             	mov    %rax,%rsi
  8004af:	48 89 d7             	mov    %rdx,%rdi
  8004b2:	48 b8 23 19 80 00 00 	movabs $0x801923,%rax
  8004b9:	00 00 00 
  8004bc:	ff d0                	callq  *%rax
        b->idx = 0;
  8004be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004c2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8004c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004cc:	8b 40 04             	mov    0x4(%rax),%eax
  8004cf:	8d 50 01             	lea    0x1(%rax),%edx
  8004d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004d6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8004d9:	c9                   	leaveq 
  8004da:	c3                   	retq   

00000000008004db <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8004db:	55                   	push   %rbp
  8004dc:	48 89 e5             	mov    %rsp,%rbp
  8004df:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8004e6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8004ed:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8004f4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004fb:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800502:	48 8b 0a             	mov    (%rdx),%rcx
  800505:	48 89 08             	mov    %rcx,(%rax)
  800508:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80050c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800510:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800514:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800518:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80051f:	00 00 00 
    b.cnt = 0;
  800522:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800529:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80052c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800533:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80053a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800541:	48 89 c6             	mov    %rax,%rsi
  800544:	48 bf 62 04 80 00 00 	movabs $0x800462,%rdi
  80054b:	00 00 00 
  80054e:	48 b8 3a 09 80 00 00 	movabs $0x80093a,%rax
  800555:	00 00 00 
  800558:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80055a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800560:	48 98                	cltq   
  800562:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800569:	48 83 c2 08          	add    $0x8,%rdx
  80056d:	48 89 c6             	mov    %rax,%rsi
  800570:	48 89 d7             	mov    %rdx,%rdi
  800573:	48 b8 23 19 80 00 00 	movabs $0x801923,%rax
  80057a:	00 00 00 
  80057d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80057f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800585:	c9                   	leaveq 
  800586:	c3                   	retq   

0000000000800587 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800587:	55                   	push   %rbp
  800588:	48 89 e5             	mov    %rsp,%rbp
  80058b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800592:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800599:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005a0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005a7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005ae:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005b5:	84 c0                	test   %al,%al
  8005b7:	74 20                	je     8005d9 <cprintf+0x52>
  8005b9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005bd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005c1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8005c5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8005c9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8005cd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8005d1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8005d5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8005d9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8005e0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8005e7:	00 00 00 
  8005ea:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8005f1:	00 00 00 
  8005f4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005f8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005ff:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800606:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80060d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800614:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80061b:	48 8b 0a             	mov    (%rdx),%rcx
  80061e:	48 89 08             	mov    %rcx,(%rax)
  800621:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800625:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800629:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80062d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800631:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800638:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80063f:	48 89 d6             	mov    %rdx,%rsi
  800642:	48 89 c7             	mov    %rax,%rdi
  800645:	48 b8 db 04 80 00 00 	movabs $0x8004db,%rax
  80064c:	00 00 00 
  80064f:	ff d0                	callq  *%rax
  800651:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800657:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80065d:	c9                   	leaveq 
  80065e:	c3                   	retq   

000000000080065f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80065f:	55                   	push   %rbp
  800660:	48 89 e5             	mov    %rsp,%rbp
  800663:	53                   	push   %rbx
  800664:	48 83 ec 38          	sub    $0x38,%rsp
  800668:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80066c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800670:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800674:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800677:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80067b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80067f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800682:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800686:	77 3b                	ja     8006c3 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800688:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80068b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80068f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800692:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800696:	ba 00 00 00 00       	mov    $0x0,%edx
  80069b:	48 f7 f3             	div    %rbx
  80069e:	48 89 c2             	mov    %rax,%rdx
  8006a1:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8006a4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006a7:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8006ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006af:	41 89 f9             	mov    %edi,%r9d
  8006b2:	48 89 c7             	mov    %rax,%rdi
  8006b5:	48 b8 5f 06 80 00 00 	movabs $0x80065f,%rax
  8006bc:	00 00 00 
  8006bf:	ff d0                	callq  *%rax
  8006c1:	eb 1e                	jmp    8006e1 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006c3:	eb 12                	jmp    8006d7 <printnum+0x78>
			putch(padc, putdat);
  8006c5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006c9:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8006cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d0:	48 89 ce             	mov    %rcx,%rsi
  8006d3:	89 d7                	mov    %edx,%edi
  8006d5:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006d7:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8006db:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8006df:	7f e4                	jg     8006c5 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006e1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ed:	48 f7 f1             	div    %rcx
  8006f0:	48 89 d0             	mov    %rdx,%rax
  8006f3:	48 ba 10 59 80 00 00 	movabs $0x805910,%rdx
  8006fa:	00 00 00 
  8006fd:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800701:	0f be d0             	movsbl %al,%edx
  800704:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800708:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070c:	48 89 ce             	mov    %rcx,%rsi
  80070f:	89 d7                	mov    %edx,%edi
  800711:	ff d0                	callq  *%rax
}
  800713:	48 83 c4 38          	add    $0x38,%rsp
  800717:	5b                   	pop    %rbx
  800718:	5d                   	pop    %rbp
  800719:	c3                   	retq   

000000000080071a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80071a:	55                   	push   %rbp
  80071b:	48 89 e5             	mov    %rsp,%rbp
  80071e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800722:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800726:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800729:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80072d:	7e 52                	jle    800781 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80072f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800733:	8b 00                	mov    (%rax),%eax
  800735:	83 f8 30             	cmp    $0x30,%eax
  800738:	73 24                	jae    80075e <getuint+0x44>
  80073a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800742:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800746:	8b 00                	mov    (%rax),%eax
  800748:	89 c0                	mov    %eax,%eax
  80074a:	48 01 d0             	add    %rdx,%rax
  80074d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800751:	8b 12                	mov    (%rdx),%edx
  800753:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800756:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075a:	89 0a                	mov    %ecx,(%rdx)
  80075c:	eb 17                	jmp    800775 <getuint+0x5b>
  80075e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800762:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800766:	48 89 d0             	mov    %rdx,%rax
  800769:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80076d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800771:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800775:	48 8b 00             	mov    (%rax),%rax
  800778:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80077c:	e9 a3 00 00 00       	jmpq   800824 <getuint+0x10a>
	else if (lflag)
  800781:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800785:	74 4f                	je     8007d6 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800787:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078b:	8b 00                	mov    (%rax),%eax
  80078d:	83 f8 30             	cmp    $0x30,%eax
  800790:	73 24                	jae    8007b6 <getuint+0x9c>
  800792:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800796:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80079a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079e:	8b 00                	mov    (%rax),%eax
  8007a0:	89 c0                	mov    %eax,%eax
  8007a2:	48 01 d0             	add    %rdx,%rax
  8007a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a9:	8b 12                	mov    (%rdx),%edx
  8007ab:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b2:	89 0a                	mov    %ecx,(%rdx)
  8007b4:	eb 17                	jmp    8007cd <getuint+0xb3>
  8007b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ba:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007be:	48 89 d0             	mov    %rdx,%rax
  8007c1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007cd:	48 8b 00             	mov    (%rax),%rax
  8007d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007d4:	eb 4e                	jmp    800824 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8007d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007da:	8b 00                	mov    (%rax),%eax
  8007dc:	83 f8 30             	cmp    $0x30,%eax
  8007df:	73 24                	jae    800805 <getuint+0xeb>
  8007e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ed:	8b 00                	mov    (%rax),%eax
  8007ef:	89 c0                	mov    %eax,%eax
  8007f1:	48 01 d0             	add    %rdx,%rax
  8007f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f8:	8b 12                	mov    (%rdx),%edx
  8007fa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800801:	89 0a                	mov    %ecx,(%rdx)
  800803:	eb 17                	jmp    80081c <getuint+0x102>
  800805:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800809:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80080d:	48 89 d0             	mov    %rdx,%rax
  800810:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800814:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800818:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80081c:	8b 00                	mov    (%rax),%eax
  80081e:	89 c0                	mov    %eax,%eax
  800820:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800824:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800828:	c9                   	leaveq 
  800829:	c3                   	retq   

000000000080082a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80082a:	55                   	push   %rbp
  80082b:	48 89 e5             	mov    %rsp,%rbp
  80082e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800832:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800836:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800839:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80083d:	7e 52                	jle    800891 <getint+0x67>
		x=va_arg(*ap, long long);
  80083f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800843:	8b 00                	mov    (%rax),%eax
  800845:	83 f8 30             	cmp    $0x30,%eax
  800848:	73 24                	jae    80086e <getint+0x44>
  80084a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800852:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800856:	8b 00                	mov    (%rax),%eax
  800858:	89 c0                	mov    %eax,%eax
  80085a:	48 01 d0             	add    %rdx,%rax
  80085d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800861:	8b 12                	mov    (%rdx),%edx
  800863:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800866:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086a:	89 0a                	mov    %ecx,(%rdx)
  80086c:	eb 17                	jmp    800885 <getint+0x5b>
  80086e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800872:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800876:	48 89 d0             	mov    %rdx,%rax
  800879:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80087d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800881:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800885:	48 8b 00             	mov    (%rax),%rax
  800888:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80088c:	e9 a3 00 00 00       	jmpq   800934 <getint+0x10a>
	else if (lflag)
  800891:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800895:	74 4f                	je     8008e6 <getint+0xbc>
		x=va_arg(*ap, long);
  800897:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089b:	8b 00                	mov    (%rax),%eax
  80089d:	83 f8 30             	cmp    $0x30,%eax
  8008a0:	73 24                	jae    8008c6 <getint+0x9c>
  8008a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ae:	8b 00                	mov    (%rax),%eax
  8008b0:	89 c0                	mov    %eax,%eax
  8008b2:	48 01 d0             	add    %rdx,%rax
  8008b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b9:	8b 12                	mov    (%rdx),%edx
  8008bb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c2:	89 0a                	mov    %ecx,(%rdx)
  8008c4:	eb 17                	jmp    8008dd <getint+0xb3>
  8008c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ca:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008ce:	48 89 d0             	mov    %rdx,%rax
  8008d1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008dd:	48 8b 00             	mov    (%rax),%rax
  8008e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008e4:	eb 4e                	jmp    800934 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8008e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ea:	8b 00                	mov    (%rax),%eax
  8008ec:	83 f8 30             	cmp    $0x30,%eax
  8008ef:	73 24                	jae    800915 <getint+0xeb>
  8008f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fd:	8b 00                	mov    (%rax),%eax
  8008ff:	89 c0                	mov    %eax,%eax
  800901:	48 01 d0             	add    %rdx,%rax
  800904:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800908:	8b 12                	mov    (%rdx),%edx
  80090a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80090d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800911:	89 0a                	mov    %ecx,(%rdx)
  800913:	eb 17                	jmp    80092c <getint+0x102>
  800915:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800919:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80091d:	48 89 d0             	mov    %rdx,%rax
  800920:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800924:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800928:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80092c:	8b 00                	mov    (%rax),%eax
  80092e:	48 98                	cltq   
  800930:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800934:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800938:	c9                   	leaveq 
  800939:	c3                   	retq   

000000000080093a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80093a:	55                   	push   %rbp
  80093b:	48 89 e5             	mov    %rsp,%rbp
  80093e:	41 54                	push   %r12
  800940:	53                   	push   %rbx
  800941:	48 83 ec 60          	sub    $0x60,%rsp
  800945:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800949:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80094d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800951:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800955:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800959:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80095d:	48 8b 0a             	mov    (%rdx),%rcx
  800960:	48 89 08             	mov    %rcx,(%rax)
  800963:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800967:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80096b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80096f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800973:	eb 17                	jmp    80098c <vprintfmt+0x52>
			if (ch == '\0')
  800975:	85 db                	test   %ebx,%ebx
  800977:	0f 84 cc 04 00 00    	je     800e49 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80097d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800981:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800985:	48 89 d6             	mov    %rdx,%rsi
  800988:	89 df                	mov    %ebx,%edi
  80098a:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80098c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800990:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800994:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800998:	0f b6 00             	movzbl (%rax),%eax
  80099b:	0f b6 d8             	movzbl %al,%ebx
  80099e:	83 fb 25             	cmp    $0x25,%ebx
  8009a1:	75 d2                	jne    800975 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009a3:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009a7:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009ae:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009b5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009bc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009c3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009c7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009cb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009cf:	0f b6 00             	movzbl (%rax),%eax
  8009d2:	0f b6 d8             	movzbl %al,%ebx
  8009d5:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8009d8:	83 f8 55             	cmp    $0x55,%eax
  8009db:	0f 87 34 04 00 00    	ja     800e15 <vprintfmt+0x4db>
  8009e1:	89 c0                	mov    %eax,%eax
  8009e3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8009ea:	00 
  8009eb:	48 b8 38 59 80 00 00 	movabs $0x805938,%rax
  8009f2:	00 00 00 
  8009f5:	48 01 d0             	add    %rdx,%rax
  8009f8:	48 8b 00             	mov    (%rax),%rax
  8009fb:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8009fd:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a01:	eb c0                	jmp    8009c3 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a03:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a07:	eb ba                	jmp    8009c3 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a09:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a10:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a13:	89 d0                	mov    %edx,%eax
  800a15:	c1 e0 02             	shl    $0x2,%eax
  800a18:	01 d0                	add    %edx,%eax
  800a1a:	01 c0                	add    %eax,%eax
  800a1c:	01 d8                	add    %ebx,%eax
  800a1e:	83 e8 30             	sub    $0x30,%eax
  800a21:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a24:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a28:	0f b6 00             	movzbl (%rax),%eax
  800a2b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a2e:	83 fb 2f             	cmp    $0x2f,%ebx
  800a31:	7e 0c                	jle    800a3f <vprintfmt+0x105>
  800a33:	83 fb 39             	cmp    $0x39,%ebx
  800a36:	7f 07                	jg     800a3f <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a38:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a3d:	eb d1                	jmp    800a10 <vprintfmt+0xd6>
			goto process_precision;
  800a3f:	eb 58                	jmp    800a99 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800a41:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a44:	83 f8 30             	cmp    $0x30,%eax
  800a47:	73 17                	jae    800a60 <vprintfmt+0x126>
  800a49:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a4d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a50:	89 c0                	mov    %eax,%eax
  800a52:	48 01 d0             	add    %rdx,%rax
  800a55:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a58:	83 c2 08             	add    $0x8,%edx
  800a5b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a5e:	eb 0f                	jmp    800a6f <vprintfmt+0x135>
  800a60:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a64:	48 89 d0             	mov    %rdx,%rax
  800a67:	48 83 c2 08          	add    $0x8,%rdx
  800a6b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a6f:	8b 00                	mov    (%rax),%eax
  800a71:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a74:	eb 23                	jmp    800a99 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800a76:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a7a:	79 0c                	jns    800a88 <vprintfmt+0x14e>
				width = 0;
  800a7c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a83:	e9 3b ff ff ff       	jmpq   8009c3 <vprintfmt+0x89>
  800a88:	e9 36 ff ff ff       	jmpq   8009c3 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a8d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a94:	e9 2a ff ff ff       	jmpq   8009c3 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800a99:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a9d:	79 12                	jns    800ab1 <vprintfmt+0x177>
				width = precision, precision = -1;
  800a9f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800aa2:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800aa5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800aac:	e9 12 ff ff ff       	jmpq   8009c3 <vprintfmt+0x89>
  800ab1:	e9 0d ff ff ff       	jmpq   8009c3 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ab6:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800aba:	e9 04 ff ff ff       	jmpq   8009c3 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800abf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac2:	83 f8 30             	cmp    $0x30,%eax
  800ac5:	73 17                	jae    800ade <vprintfmt+0x1a4>
  800ac7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800acb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ace:	89 c0                	mov    %eax,%eax
  800ad0:	48 01 d0             	add    %rdx,%rax
  800ad3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ad6:	83 c2 08             	add    $0x8,%edx
  800ad9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800adc:	eb 0f                	jmp    800aed <vprintfmt+0x1b3>
  800ade:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ae2:	48 89 d0             	mov    %rdx,%rax
  800ae5:	48 83 c2 08          	add    $0x8,%rdx
  800ae9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aed:	8b 10                	mov    (%rax),%edx
  800aef:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800af3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af7:	48 89 ce             	mov    %rcx,%rsi
  800afa:	89 d7                	mov    %edx,%edi
  800afc:	ff d0                	callq  *%rax
			break;
  800afe:	e9 40 03 00 00       	jmpq   800e43 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b03:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b06:	83 f8 30             	cmp    $0x30,%eax
  800b09:	73 17                	jae    800b22 <vprintfmt+0x1e8>
  800b0b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b0f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b12:	89 c0                	mov    %eax,%eax
  800b14:	48 01 d0             	add    %rdx,%rax
  800b17:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b1a:	83 c2 08             	add    $0x8,%edx
  800b1d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b20:	eb 0f                	jmp    800b31 <vprintfmt+0x1f7>
  800b22:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b26:	48 89 d0             	mov    %rdx,%rax
  800b29:	48 83 c2 08          	add    $0x8,%rdx
  800b2d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b31:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b33:	85 db                	test   %ebx,%ebx
  800b35:	79 02                	jns    800b39 <vprintfmt+0x1ff>
				err = -err;
  800b37:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b39:	83 fb 15             	cmp    $0x15,%ebx
  800b3c:	7f 16                	jg     800b54 <vprintfmt+0x21a>
  800b3e:	48 b8 60 58 80 00 00 	movabs $0x805860,%rax
  800b45:	00 00 00 
  800b48:	48 63 d3             	movslq %ebx,%rdx
  800b4b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b4f:	4d 85 e4             	test   %r12,%r12
  800b52:	75 2e                	jne    800b82 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b54:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b5c:	89 d9                	mov    %ebx,%ecx
  800b5e:	48 ba 21 59 80 00 00 	movabs $0x805921,%rdx
  800b65:	00 00 00 
  800b68:	48 89 c7             	mov    %rax,%rdi
  800b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b70:	49 b8 52 0e 80 00 00 	movabs $0x800e52,%r8
  800b77:	00 00 00 
  800b7a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b7d:	e9 c1 02 00 00       	jmpq   800e43 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b82:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b86:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8a:	4c 89 e1             	mov    %r12,%rcx
  800b8d:	48 ba 2a 59 80 00 00 	movabs $0x80592a,%rdx
  800b94:	00 00 00 
  800b97:	48 89 c7             	mov    %rax,%rdi
  800b9a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9f:	49 b8 52 0e 80 00 00 	movabs $0x800e52,%r8
  800ba6:	00 00 00 
  800ba9:	41 ff d0             	callq  *%r8
			break;
  800bac:	e9 92 02 00 00       	jmpq   800e43 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800bb1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb4:	83 f8 30             	cmp    $0x30,%eax
  800bb7:	73 17                	jae    800bd0 <vprintfmt+0x296>
  800bb9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bbd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc0:	89 c0                	mov    %eax,%eax
  800bc2:	48 01 d0             	add    %rdx,%rax
  800bc5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bc8:	83 c2 08             	add    $0x8,%edx
  800bcb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bce:	eb 0f                	jmp    800bdf <vprintfmt+0x2a5>
  800bd0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bd4:	48 89 d0             	mov    %rdx,%rax
  800bd7:	48 83 c2 08          	add    $0x8,%rdx
  800bdb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bdf:	4c 8b 20             	mov    (%rax),%r12
  800be2:	4d 85 e4             	test   %r12,%r12
  800be5:	75 0a                	jne    800bf1 <vprintfmt+0x2b7>
				p = "(null)";
  800be7:	49 bc 2d 59 80 00 00 	movabs $0x80592d,%r12
  800bee:	00 00 00 
			if (width > 0 && padc != '-')
  800bf1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bf5:	7e 3f                	jle    800c36 <vprintfmt+0x2fc>
  800bf7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800bfb:	74 39                	je     800c36 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bfd:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c00:	48 98                	cltq   
  800c02:	48 89 c6             	mov    %rax,%rsi
  800c05:	4c 89 e7             	mov    %r12,%rdi
  800c08:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  800c0f:	00 00 00 
  800c12:	ff d0                	callq  *%rax
  800c14:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c17:	eb 17                	jmp    800c30 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800c19:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c1d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c25:	48 89 ce             	mov    %rcx,%rsi
  800c28:	89 d7                	mov    %edx,%edi
  800c2a:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c2c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c30:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c34:	7f e3                	jg     800c19 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c36:	eb 37                	jmp    800c6f <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800c38:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c3c:	74 1e                	je     800c5c <vprintfmt+0x322>
  800c3e:	83 fb 1f             	cmp    $0x1f,%ebx
  800c41:	7e 05                	jle    800c48 <vprintfmt+0x30e>
  800c43:	83 fb 7e             	cmp    $0x7e,%ebx
  800c46:	7e 14                	jle    800c5c <vprintfmt+0x322>
					putch('?', putdat);
  800c48:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c4c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c50:	48 89 d6             	mov    %rdx,%rsi
  800c53:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c58:	ff d0                	callq  *%rax
  800c5a:	eb 0f                	jmp    800c6b <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800c5c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c64:	48 89 d6             	mov    %rdx,%rsi
  800c67:	89 df                	mov    %ebx,%edi
  800c69:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c6b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c6f:	4c 89 e0             	mov    %r12,%rax
  800c72:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c76:	0f b6 00             	movzbl (%rax),%eax
  800c79:	0f be d8             	movsbl %al,%ebx
  800c7c:	85 db                	test   %ebx,%ebx
  800c7e:	74 10                	je     800c90 <vprintfmt+0x356>
  800c80:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c84:	78 b2                	js     800c38 <vprintfmt+0x2fe>
  800c86:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c8a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c8e:	79 a8                	jns    800c38 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c90:	eb 16                	jmp    800ca8 <vprintfmt+0x36e>
				putch(' ', putdat);
  800c92:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c96:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c9a:	48 89 d6             	mov    %rdx,%rsi
  800c9d:	bf 20 00 00 00       	mov    $0x20,%edi
  800ca2:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ca4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ca8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cac:	7f e4                	jg     800c92 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800cae:	e9 90 01 00 00       	jmpq   800e43 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800cb3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cb7:	be 03 00 00 00       	mov    $0x3,%esi
  800cbc:	48 89 c7             	mov    %rax,%rdi
  800cbf:	48 b8 2a 08 80 00 00 	movabs $0x80082a,%rax
  800cc6:	00 00 00 
  800cc9:	ff d0                	callq  *%rax
  800ccb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ccf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cd3:	48 85 c0             	test   %rax,%rax
  800cd6:	79 1d                	jns    800cf5 <vprintfmt+0x3bb>
				putch('-', putdat);
  800cd8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cdc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce0:	48 89 d6             	mov    %rdx,%rsi
  800ce3:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ce8:	ff d0                	callq  *%rax
				num = -(long long) num;
  800cea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cee:	48 f7 d8             	neg    %rax
  800cf1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800cf5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cfc:	e9 d5 00 00 00       	jmpq   800dd6 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d01:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d05:	be 03 00 00 00       	mov    $0x3,%esi
  800d0a:	48 89 c7             	mov    %rax,%rdi
  800d0d:	48 b8 1a 07 80 00 00 	movabs $0x80071a,%rax
  800d14:	00 00 00 
  800d17:	ff d0                	callq  *%rax
  800d19:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d1d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d24:	e9 ad 00 00 00       	jmpq   800dd6 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800d29:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d2d:	be 03 00 00 00       	mov    $0x3,%esi
  800d32:	48 89 c7             	mov    %rax,%rdi
  800d35:	48 b8 1a 07 80 00 00 	movabs $0x80071a,%rax
  800d3c:	00 00 00 
  800d3f:	ff d0                	callq  *%rax
  800d41:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800d45:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d4c:	e9 85 00 00 00       	jmpq   800dd6 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800d51:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d55:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d59:	48 89 d6             	mov    %rdx,%rsi
  800d5c:	bf 30 00 00 00       	mov    $0x30,%edi
  800d61:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d63:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d67:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d6b:	48 89 d6             	mov    %rdx,%rsi
  800d6e:	bf 78 00 00 00       	mov    $0x78,%edi
  800d73:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d75:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d78:	83 f8 30             	cmp    $0x30,%eax
  800d7b:	73 17                	jae    800d94 <vprintfmt+0x45a>
  800d7d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d81:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d84:	89 c0                	mov    %eax,%eax
  800d86:	48 01 d0             	add    %rdx,%rax
  800d89:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d8c:	83 c2 08             	add    $0x8,%edx
  800d8f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d92:	eb 0f                	jmp    800da3 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800d94:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d98:	48 89 d0             	mov    %rdx,%rax
  800d9b:	48 83 c2 08          	add    $0x8,%rdx
  800d9f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800da3:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800da6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800daa:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800db1:	eb 23                	jmp    800dd6 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800db3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800db7:	be 03 00 00 00       	mov    $0x3,%esi
  800dbc:	48 89 c7             	mov    %rax,%rdi
  800dbf:	48 b8 1a 07 80 00 00 	movabs $0x80071a,%rax
  800dc6:	00 00 00 
  800dc9:	ff d0                	callq  *%rax
  800dcb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800dcf:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800dd6:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ddb:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800dde:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800de1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800de5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800de9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ded:	45 89 c1             	mov    %r8d,%r9d
  800df0:	41 89 f8             	mov    %edi,%r8d
  800df3:	48 89 c7             	mov    %rax,%rdi
  800df6:	48 b8 5f 06 80 00 00 	movabs $0x80065f,%rax
  800dfd:	00 00 00 
  800e00:	ff d0                	callq  *%rax
			break;
  800e02:	eb 3f                	jmp    800e43 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0c:	48 89 d6             	mov    %rdx,%rsi
  800e0f:	89 df                	mov    %ebx,%edi
  800e11:	ff d0                	callq  *%rax
			break;
  800e13:	eb 2e                	jmp    800e43 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e15:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e1d:	48 89 d6             	mov    %rdx,%rsi
  800e20:	bf 25 00 00 00       	mov    $0x25,%edi
  800e25:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e27:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e2c:	eb 05                	jmp    800e33 <vprintfmt+0x4f9>
  800e2e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e33:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e37:	48 83 e8 01          	sub    $0x1,%rax
  800e3b:	0f b6 00             	movzbl (%rax),%eax
  800e3e:	3c 25                	cmp    $0x25,%al
  800e40:	75 ec                	jne    800e2e <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800e42:	90                   	nop
		}
	}
  800e43:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e44:	e9 43 fb ff ff       	jmpq   80098c <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e49:	48 83 c4 60          	add    $0x60,%rsp
  800e4d:	5b                   	pop    %rbx
  800e4e:	41 5c                	pop    %r12
  800e50:	5d                   	pop    %rbp
  800e51:	c3                   	retq   

0000000000800e52 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e52:	55                   	push   %rbp
  800e53:	48 89 e5             	mov    %rsp,%rbp
  800e56:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e5d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e64:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e6b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e72:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e79:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e80:	84 c0                	test   %al,%al
  800e82:	74 20                	je     800ea4 <printfmt+0x52>
  800e84:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e88:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e8c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e90:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e94:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e98:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e9c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ea0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ea4:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800eab:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800eb2:	00 00 00 
  800eb5:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ebc:	00 00 00 
  800ebf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ec3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800eca:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ed1:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ed8:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800edf:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ee6:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800eed:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800ef4:	48 89 c7             	mov    %rax,%rdi
  800ef7:	48 b8 3a 09 80 00 00 	movabs $0x80093a,%rax
  800efe:	00 00 00 
  800f01:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f03:	c9                   	leaveq 
  800f04:	c3                   	retq   

0000000000800f05 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f05:	55                   	push   %rbp
  800f06:	48 89 e5             	mov    %rsp,%rbp
  800f09:	48 83 ec 10          	sub    $0x10,%rsp
  800f0d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f10:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f18:	8b 40 10             	mov    0x10(%rax),%eax
  800f1b:	8d 50 01             	lea    0x1(%rax),%edx
  800f1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f22:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f29:	48 8b 10             	mov    (%rax),%rdx
  800f2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f30:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f34:	48 39 c2             	cmp    %rax,%rdx
  800f37:	73 17                	jae    800f50 <sprintputch+0x4b>
		*b->buf++ = ch;
  800f39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f3d:	48 8b 00             	mov    (%rax),%rax
  800f40:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f48:	48 89 0a             	mov    %rcx,(%rdx)
  800f4b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f4e:	88 10                	mov    %dl,(%rax)
}
  800f50:	c9                   	leaveq 
  800f51:	c3                   	retq   

0000000000800f52 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f52:	55                   	push   %rbp
  800f53:	48 89 e5             	mov    %rsp,%rbp
  800f56:	48 83 ec 50          	sub    $0x50,%rsp
  800f5a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f5e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f61:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f65:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f69:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f6d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f71:	48 8b 0a             	mov    (%rdx),%rcx
  800f74:	48 89 08             	mov    %rcx,(%rax)
  800f77:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f7b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f7f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f83:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f87:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f8b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f8f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f92:	48 98                	cltq   
  800f94:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f98:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f9c:	48 01 d0             	add    %rdx,%rax
  800f9f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800fa3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800faa:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800faf:	74 06                	je     800fb7 <vsnprintf+0x65>
  800fb1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800fb5:	7f 07                	jg     800fbe <vsnprintf+0x6c>
		return -E_INVAL;
  800fb7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fbc:	eb 2f                	jmp    800fed <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800fbe:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800fc2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800fc6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800fca:	48 89 c6             	mov    %rax,%rsi
  800fcd:	48 bf 05 0f 80 00 00 	movabs $0x800f05,%rdi
  800fd4:	00 00 00 
  800fd7:	48 b8 3a 09 80 00 00 	movabs $0x80093a,%rax
  800fde:	00 00 00 
  800fe1:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800fe3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fe7:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800fea:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800fed:	c9                   	leaveq 
  800fee:	c3                   	retq   

0000000000800fef <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fef:	55                   	push   %rbp
  800ff0:	48 89 e5             	mov    %rsp,%rbp
  800ff3:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ffa:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801001:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801007:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80100e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801015:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80101c:	84 c0                	test   %al,%al
  80101e:	74 20                	je     801040 <snprintf+0x51>
  801020:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801024:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801028:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80102c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801030:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801034:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801038:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80103c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801040:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801047:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80104e:	00 00 00 
  801051:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801058:	00 00 00 
  80105b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80105f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801066:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80106d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801074:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80107b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801082:	48 8b 0a             	mov    (%rdx),%rcx
  801085:	48 89 08             	mov    %rcx,(%rax)
  801088:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80108c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801090:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801094:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801098:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80109f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010a6:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010ac:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010b3:	48 89 c7             	mov    %rax,%rdi
  8010b6:	48 b8 52 0f 80 00 00 	movabs $0x800f52,%rax
  8010bd:	00 00 00 
  8010c0:	ff d0                	callq  *%rax
  8010c2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8010c8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8010ce:	c9                   	leaveq 
  8010cf:	c3                   	retq   

00000000008010d0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8010d0:	55                   	push   %rbp
  8010d1:	48 89 e5             	mov    %rsp,%rbp
  8010d4:	48 83 ec 18          	sub    $0x18,%rsp
  8010d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8010dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010e3:	eb 09                	jmp    8010ee <strlen+0x1e>
		n++;
  8010e5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010e9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f2:	0f b6 00             	movzbl (%rax),%eax
  8010f5:	84 c0                	test   %al,%al
  8010f7:	75 ec                	jne    8010e5 <strlen+0x15>
		n++;
	return n;
  8010f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010fc:	c9                   	leaveq 
  8010fd:	c3                   	retq   

00000000008010fe <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010fe:	55                   	push   %rbp
  8010ff:	48 89 e5             	mov    %rsp,%rbp
  801102:	48 83 ec 20          	sub    $0x20,%rsp
  801106:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80110a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80110e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801115:	eb 0e                	jmp    801125 <strnlen+0x27>
		n++;
  801117:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80111b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801120:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801125:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80112a:	74 0b                	je     801137 <strnlen+0x39>
  80112c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801130:	0f b6 00             	movzbl (%rax),%eax
  801133:	84 c0                	test   %al,%al
  801135:	75 e0                	jne    801117 <strnlen+0x19>
		n++;
	return n;
  801137:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80113a:	c9                   	leaveq 
  80113b:	c3                   	retq   

000000000080113c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80113c:	55                   	push   %rbp
  80113d:	48 89 e5             	mov    %rsp,%rbp
  801140:	48 83 ec 20          	sub    $0x20,%rsp
  801144:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801148:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80114c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801150:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801154:	90                   	nop
  801155:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801159:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80115d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801161:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801165:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801169:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80116d:	0f b6 12             	movzbl (%rdx),%edx
  801170:	88 10                	mov    %dl,(%rax)
  801172:	0f b6 00             	movzbl (%rax),%eax
  801175:	84 c0                	test   %al,%al
  801177:	75 dc                	jne    801155 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801179:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80117d:	c9                   	leaveq 
  80117e:	c3                   	retq   

000000000080117f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80117f:	55                   	push   %rbp
  801180:	48 89 e5             	mov    %rsp,%rbp
  801183:	48 83 ec 20          	sub    $0x20,%rsp
  801187:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80118b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80118f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801193:	48 89 c7             	mov    %rax,%rdi
  801196:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  80119d:	00 00 00 
  8011a0:	ff d0                	callq  *%rax
  8011a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011a8:	48 63 d0             	movslq %eax,%rdx
  8011ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011af:	48 01 c2             	add    %rax,%rdx
  8011b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011b6:	48 89 c6             	mov    %rax,%rsi
  8011b9:	48 89 d7             	mov    %rdx,%rdi
  8011bc:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  8011c3:	00 00 00 
  8011c6:	ff d0                	callq  *%rax
	return dst;
  8011c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8011cc:	c9                   	leaveq 
  8011cd:	c3                   	retq   

00000000008011ce <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011ce:	55                   	push   %rbp
  8011cf:	48 89 e5             	mov    %rsp,%rbp
  8011d2:	48 83 ec 28          	sub    $0x28,%rsp
  8011d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8011e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8011ea:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011f1:	00 
  8011f2:	eb 2a                	jmp    80121e <strncpy+0x50>
		*dst++ = *src;
  8011f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801200:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801204:	0f b6 12             	movzbl (%rdx),%edx
  801207:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801209:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80120d:	0f b6 00             	movzbl (%rax),%eax
  801210:	84 c0                	test   %al,%al
  801212:	74 05                	je     801219 <strncpy+0x4b>
			src++;
  801214:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801219:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80121e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801222:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801226:	72 cc                	jb     8011f4 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80122c:	c9                   	leaveq 
  80122d:	c3                   	retq   

000000000080122e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80122e:	55                   	push   %rbp
  80122f:	48 89 e5             	mov    %rsp,%rbp
  801232:	48 83 ec 28          	sub    $0x28,%rsp
  801236:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80123a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80123e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801242:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801246:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80124a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80124f:	74 3d                	je     80128e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801251:	eb 1d                	jmp    801270 <strlcpy+0x42>
			*dst++ = *src++;
  801253:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801257:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80125b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80125f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801263:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801267:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80126b:	0f b6 12             	movzbl (%rdx),%edx
  80126e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801270:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801275:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80127a:	74 0b                	je     801287 <strlcpy+0x59>
  80127c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801280:	0f b6 00             	movzbl (%rax),%eax
  801283:	84 c0                	test   %al,%al
  801285:	75 cc                	jne    801253 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801287:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80128e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801292:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801296:	48 29 c2             	sub    %rax,%rdx
  801299:	48 89 d0             	mov    %rdx,%rax
}
  80129c:	c9                   	leaveq 
  80129d:	c3                   	retq   

000000000080129e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80129e:	55                   	push   %rbp
  80129f:	48 89 e5             	mov    %rsp,%rbp
  8012a2:	48 83 ec 10          	sub    $0x10,%rsp
  8012a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012ae:	eb 0a                	jmp    8012ba <strcmp+0x1c>
		p++, q++;
  8012b0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012be:	0f b6 00             	movzbl (%rax),%eax
  8012c1:	84 c0                	test   %al,%al
  8012c3:	74 12                	je     8012d7 <strcmp+0x39>
  8012c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c9:	0f b6 10             	movzbl (%rax),%edx
  8012cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d0:	0f b6 00             	movzbl (%rax),%eax
  8012d3:	38 c2                	cmp    %al,%dl
  8012d5:	74 d9                	je     8012b0 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012db:	0f b6 00             	movzbl (%rax),%eax
  8012de:	0f b6 d0             	movzbl %al,%edx
  8012e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e5:	0f b6 00             	movzbl (%rax),%eax
  8012e8:	0f b6 c0             	movzbl %al,%eax
  8012eb:	29 c2                	sub    %eax,%edx
  8012ed:	89 d0                	mov    %edx,%eax
}
  8012ef:	c9                   	leaveq 
  8012f0:	c3                   	retq   

00000000008012f1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012f1:	55                   	push   %rbp
  8012f2:	48 89 e5             	mov    %rsp,%rbp
  8012f5:	48 83 ec 18          	sub    $0x18,%rsp
  8012f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012fd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801301:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801305:	eb 0f                	jmp    801316 <strncmp+0x25>
		n--, p++, q++;
  801307:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80130c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801311:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801316:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80131b:	74 1d                	je     80133a <strncmp+0x49>
  80131d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801321:	0f b6 00             	movzbl (%rax),%eax
  801324:	84 c0                	test   %al,%al
  801326:	74 12                	je     80133a <strncmp+0x49>
  801328:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132c:	0f b6 10             	movzbl (%rax),%edx
  80132f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801333:	0f b6 00             	movzbl (%rax),%eax
  801336:	38 c2                	cmp    %al,%dl
  801338:	74 cd                	je     801307 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80133a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80133f:	75 07                	jne    801348 <strncmp+0x57>
		return 0;
  801341:	b8 00 00 00 00       	mov    $0x0,%eax
  801346:	eb 18                	jmp    801360 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801348:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134c:	0f b6 00             	movzbl (%rax),%eax
  80134f:	0f b6 d0             	movzbl %al,%edx
  801352:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801356:	0f b6 00             	movzbl (%rax),%eax
  801359:	0f b6 c0             	movzbl %al,%eax
  80135c:	29 c2                	sub    %eax,%edx
  80135e:	89 d0                	mov    %edx,%eax
}
  801360:	c9                   	leaveq 
  801361:	c3                   	retq   

0000000000801362 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801362:	55                   	push   %rbp
  801363:	48 89 e5             	mov    %rsp,%rbp
  801366:	48 83 ec 0c          	sub    $0xc,%rsp
  80136a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80136e:	89 f0                	mov    %esi,%eax
  801370:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801373:	eb 17                	jmp    80138c <strchr+0x2a>
		if (*s == c)
  801375:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801379:	0f b6 00             	movzbl (%rax),%eax
  80137c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80137f:	75 06                	jne    801387 <strchr+0x25>
			return (char *) s;
  801381:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801385:	eb 15                	jmp    80139c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801387:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80138c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801390:	0f b6 00             	movzbl (%rax),%eax
  801393:	84 c0                	test   %al,%al
  801395:	75 de                	jne    801375 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801397:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80139c:	c9                   	leaveq 
  80139d:	c3                   	retq   

000000000080139e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80139e:	55                   	push   %rbp
  80139f:	48 89 e5             	mov    %rsp,%rbp
  8013a2:	48 83 ec 0c          	sub    $0xc,%rsp
  8013a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013aa:	89 f0                	mov    %esi,%eax
  8013ac:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013af:	eb 13                	jmp    8013c4 <strfind+0x26>
		if (*s == c)
  8013b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b5:	0f b6 00             	movzbl (%rax),%eax
  8013b8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013bb:	75 02                	jne    8013bf <strfind+0x21>
			break;
  8013bd:	eb 10                	jmp    8013cf <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013bf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c8:	0f b6 00             	movzbl (%rax),%eax
  8013cb:	84 c0                	test   %al,%al
  8013cd:	75 e2                	jne    8013b1 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8013cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013d3:	c9                   	leaveq 
  8013d4:	c3                   	retq   

00000000008013d5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013d5:	55                   	push   %rbp
  8013d6:	48 89 e5             	mov    %rsp,%rbp
  8013d9:	48 83 ec 18          	sub    $0x18,%rsp
  8013dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013e1:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8013e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8013e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013ed:	75 06                	jne    8013f5 <memset+0x20>
		return v;
  8013ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f3:	eb 69                	jmp    80145e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8013f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f9:	83 e0 03             	and    $0x3,%eax
  8013fc:	48 85 c0             	test   %rax,%rax
  8013ff:	75 48                	jne    801449 <memset+0x74>
  801401:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801405:	83 e0 03             	and    $0x3,%eax
  801408:	48 85 c0             	test   %rax,%rax
  80140b:	75 3c                	jne    801449 <memset+0x74>
		c &= 0xFF;
  80140d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801414:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801417:	c1 e0 18             	shl    $0x18,%eax
  80141a:	89 c2                	mov    %eax,%edx
  80141c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80141f:	c1 e0 10             	shl    $0x10,%eax
  801422:	09 c2                	or     %eax,%edx
  801424:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801427:	c1 e0 08             	shl    $0x8,%eax
  80142a:	09 d0                	or     %edx,%eax
  80142c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80142f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801433:	48 c1 e8 02          	shr    $0x2,%rax
  801437:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80143a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80143e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801441:	48 89 d7             	mov    %rdx,%rdi
  801444:	fc                   	cld    
  801445:	f3 ab                	rep stos %eax,%es:(%rdi)
  801447:	eb 11                	jmp    80145a <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801449:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80144d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801450:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801454:	48 89 d7             	mov    %rdx,%rdi
  801457:	fc                   	cld    
  801458:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80145a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80145e:	c9                   	leaveq 
  80145f:	c3                   	retq   

0000000000801460 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801460:	55                   	push   %rbp
  801461:	48 89 e5             	mov    %rsp,%rbp
  801464:	48 83 ec 28          	sub    $0x28,%rsp
  801468:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80146c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801470:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801474:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801478:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80147c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801480:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801484:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801488:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80148c:	0f 83 88 00 00 00    	jae    80151a <memmove+0xba>
  801492:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801496:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80149a:	48 01 d0             	add    %rdx,%rax
  80149d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014a1:	76 77                	jbe    80151a <memmove+0xba>
		s += n;
  8014a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a7:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014af:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b7:	83 e0 03             	and    $0x3,%eax
  8014ba:	48 85 c0             	test   %rax,%rax
  8014bd:	75 3b                	jne    8014fa <memmove+0x9a>
  8014bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c3:	83 e0 03             	and    $0x3,%eax
  8014c6:	48 85 c0             	test   %rax,%rax
  8014c9:	75 2f                	jne    8014fa <memmove+0x9a>
  8014cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014cf:	83 e0 03             	and    $0x3,%eax
  8014d2:	48 85 c0             	test   %rax,%rax
  8014d5:	75 23                	jne    8014fa <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8014d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014db:	48 83 e8 04          	sub    $0x4,%rax
  8014df:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014e3:	48 83 ea 04          	sub    $0x4,%rdx
  8014e7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014eb:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8014ef:	48 89 c7             	mov    %rax,%rdi
  8014f2:	48 89 d6             	mov    %rdx,%rsi
  8014f5:	fd                   	std    
  8014f6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014f8:	eb 1d                	jmp    801517 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014fe:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801502:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801506:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80150a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150e:	48 89 d7             	mov    %rdx,%rdi
  801511:	48 89 c1             	mov    %rax,%rcx
  801514:	fd                   	std    
  801515:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801517:	fc                   	cld    
  801518:	eb 57                	jmp    801571 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80151a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151e:	83 e0 03             	and    $0x3,%eax
  801521:	48 85 c0             	test   %rax,%rax
  801524:	75 36                	jne    80155c <memmove+0xfc>
  801526:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152a:	83 e0 03             	and    $0x3,%eax
  80152d:	48 85 c0             	test   %rax,%rax
  801530:	75 2a                	jne    80155c <memmove+0xfc>
  801532:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801536:	83 e0 03             	and    $0x3,%eax
  801539:	48 85 c0             	test   %rax,%rax
  80153c:	75 1e                	jne    80155c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80153e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801542:	48 c1 e8 02          	shr    $0x2,%rax
  801546:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801549:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801551:	48 89 c7             	mov    %rax,%rdi
  801554:	48 89 d6             	mov    %rdx,%rsi
  801557:	fc                   	cld    
  801558:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80155a:	eb 15                	jmp    801571 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80155c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801560:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801564:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801568:	48 89 c7             	mov    %rax,%rdi
  80156b:	48 89 d6             	mov    %rdx,%rsi
  80156e:	fc                   	cld    
  80156f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801571:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801575:	c9                   	leaveq 
  801576:	c3                   	retq   

0000000000801577 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801577:	55                   	push   %rbp
  801578:	48 89 e5             	mov    %rsp,%rbp
  80157b:	48 83 ec 18          	sub    $0x18,%rsp
  80157f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801583:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801587:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80158b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80158f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801593:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801597:	48 89 ce             	mov    %rcx,%rsi
  80159a:	48 89 c7             	mov    %rax,%rdi
  80159d:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  8015a4:	00 00 00 
  8015a7:	ff d0                	callq  *%rax
}
  8015a9:	c9                   	leaveq 
  8015aa:	c3                   	retq   

00000000008015ab <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015ab:	55                   	push   %rbp
  8015ac:	48 89 e5             	mov    %rsp,%rbp
  8015af:	48 83 ec 28          	sub    $0x28,%rsp
  8015b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8015c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015cb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8015cf:	eb 36                	jmp    801607 <memcmp+0x5c>
		if (*s1 != *s2)
  8015d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d5:	0f b6 10             	movzbl (%rax),%edx
  8015d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015dc:	0f b6 00             	movzbl (%rax),%eax
  8015df:	38 c2                	cmp    %al,%dl
  8015e1:	74 1a                	je     8015fd <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8015e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e7:	0f b6 00             	movzbl (%rax),%eax
  8015ea:	0f b6 d0             	movzbl %al,%edx
  8015ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f1:	0f b6 00             	movzbl (%rax),%eax
  8015f4:	0f b6 c0             	movzbl %al,%eax
  8015f7:	29 c2                	sub    %eax,%edx
  8015f9:	89 d0                	mov    %edx,%eax
  8015fb:	eb 20                	jmp    80161d <memcmp+0x72>
		s1++, s2++;
  8015fd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801602:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801607:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80160f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801613:	48 85 c0             	test   %rax,%rax
  801616:	75 b9                	jne    8015d1 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801618:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161d:	c9                   	leaveq 
  80161e:	c3                   	retq   

000000000080161f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80161f:	55                   	push   %rbp
  801620:	48 89 e5             	mov    %rsp,%rbp
  801623:	48 83 ec 28          	sub    $0x28,%rsp
  801627:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80162b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80162e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801632:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801636:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80163a:	48 01 d0             	add    %rdx,%rax
  80163d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801641:	eb 15                	jmp    801658 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801647:	0f b6 10             	movzbl (%rax),%edx
  80164a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80164d:	38 c2                	cmp    %al,%dl
  80164f:	75 02                	jne    801653 <memfind+0x34>
			break;
  801651:	eb 0f                	jmp    801662 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801653:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801658:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80165c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801660:	72 e1                	jb     801643 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801662:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801666:	c9                   	leaveq 
  801667:	c3                   	retq   

0000000000801668 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801668:	55                   	push   %rbp
  801669:	48 89 e5             	mov    %rsp,%rbp
  80166c:	48 83 ec 34          	sub    $0x34,%rsp
  801670:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801674:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801678:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80167b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801682:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801689:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80168a:	eb 05                	jmp    801691 <strtol+0x29>
		s++;
  80168c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801691:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801695:	0f b6 00             	movzbl (%rax),%eax
  801698:	3c 20                	cmp    $0x20,%al
  80169a:	74 f0                	je     80168c <strtol+0x24>
  80169c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a0:	0f b6 00             	movzbl (%rax),%eax
  8016a3:	3c 09                	cmp    $0x9,%al
  8016a5:	74 e5                	je     80168c <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ab:	0f b6 00             	movzbl (%rax),%eax
  8016ae:	3c 2b                	cmp    $0x2b,%al
  8016b0:	75 07                	jne    8016b9 <strtol+0x51>
		s++;
  8016b2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016b7:	eb 17                	jmp    8016d0 <strtol+0x68>
	else if (*s == '-')
  8016b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bd:	0f b6 00             	movzbl (%rax),%eax
  8016c0:	3c 2d                	cmp    $0x2d,%al
  8016c2:	75 0c                	jne    8016d0 <strtol+0x68>
		s++, neg = 1;
  8016c4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016c9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016d0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016d4:	74 06                	je     8016dc <strtol+0x74>
  8016d6:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8016da:	75 28                	jne    801704 <strtol+0x9c>
  8016dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e0:	0f b6 00             	movzbl (%rax),%eax
  8016e3:	3c 30                	cmp    $0x30,%al
  8016e5:	75 1d                	jne    801704 <strtol+0x9c>
  8016e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016eb:	48 83 c0 01          	add    $0x1,%rax
  8016ef:	0f b6 00             	movzbl (%rax),%eax
  8016f2:	3c 78                	cmp    $0x78,%al
  8016f4:	75 0e                	jne    801704 <strtol+0x9c>
		s += 2, base = 16;
  8016f6:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016fb:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801702:	eb 2c                	jmp    801730 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801704:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801708:	75 19                	jne    801723 <strtol+0xbb>
  80170a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170e:	0f b6 00             	movzbl (%rax),%eax
  801711:	3c 30                	cmp    $0x30,%al
  801713:	75 0e                	jne    801723 <strtol+0xbb>
		s++, base = 8;
  801715:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80171a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801721:	eb 0d                	jmp    801730 <strtol+0xc8>
	else if (base == 0)
  801723:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801727:	75 07                	jne    801730 <strtol+0xc8>
		base = 10;
  801729:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801730:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801734:	0f b6 00             	movzbl (%rax),%eax
  801737:	3c 2f                	cmp    $0x2f,%al
  801739:	7e 1d                	jle    801758 <strtol+0xf0>
  80173b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173f:	0f b6 00             	movzbl (%rax),%eax
  801742:	3c 39                	cmp    $0x39,%al
  801744:	7f 12                	jg     801758 <strtol+0xf0>
			dig = *s - '0';
  801746:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174a:	0f b6 00             	movzbl (%rax),%eax
  80174d:	0f be c0             	movsbl %al,%eax
  801750:	83 e8 30             	sub    $0x30,%eax
  801753:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801756:	eb 4e                	jmp    8017a6 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801758:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175c:	0f b6 00             	movzbl (%rax),%eax
  80175f:	3c 60                	cmp    $0x60,%al
  801761:	7e 1d                	jle    801780 <strtol+0x118>
  801763:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801767:	0f b6 00             	movzbl (%rax),%eax
  80176a:	3c 7a                	cmp    $0x7a,%al
  80176c:	7f 12                	jg     801780 <strtol+0x118>
			dig = *s - 'a' + 10;
  80176e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801772:	0f b6 00             	movzbl (%rax),%eax
  801775:	0f be c0             	movsbl %al,%eax
  801778:	83 e8 57             	sub    $0x57,%eax
  80177b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80177e:	eb 26                	jmp    8017a6 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801780:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801784:	0f b6 00             	movzbl (%rax),%eax
  801787:	3c 40                	cmp    $0x40,%al
  801789:	7e 48                	jle    8017d3 <strtol+0x16b>
  80178b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178f:	0f b6 00             	movzbl (%rax),%eax
  801792:	3c 5a                	cmp    $0x5a,%al
  801794:	7f 3d                	jg     8017d3 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801796:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179a:	0f b6 00             	movzbl (%rax),%eax
  80179d:	0f be c0             	movsbl %al,%eax
  8017a0:	83 e8 37             	sub    $0x37,%eax
  8017a3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017a9:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017ac:	7c 02                	jl     8017b0 <strtol+0x148>
			break;
  8017ae:	eb 23                	jmp    8017d3 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8017b0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017b5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017b8:	48 98                	cltq   
  8017ba:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8017bf:	48 89 c2             	mov    %rax,%rdx
  8017c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017c5:	48 98                	cltq   
  8017c7:	48 01 d0             	add    %rdx,%rax
  8017ca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8017ce:	e9 5d ff ff ff       	jmpq   801730 <strtol+0xc8>

	if (endptr)
  8017d3:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8017d8:	74 0b                	je     8017e5 <strtol+0x17d>
		*endptr = (char *) s;
  8017da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017de:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017e2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8017e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017e9:	74 09                	je     8017f4 <strtol+0x18c>
  8017eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ef:	48 f7 d8             	neg    %rax
  8017f2:	eb 04                	jmp    8017f8 <strtol+0x190>
  8017f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017f8:	c9                   	leaveq 
  8017f9:	c3                   	retq   

00000000008017fa <strstr>:

char * strstr(const char *in, const char *str)
{
  8017fa:	55                   	push   %rbp
  8017fb:	48 89 e5             	mov    %rsp,%rbp
  8017fe:	48 83 ec 30          	sub    $0x30,%rsp
  801802:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801806:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80180a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80180e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801812:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801816:	0f b6 00             	movzbl (%rax),%eax
  801819:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80181c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801820:	75 06                	jne    801828 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801822:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801826:	eb 6b                	jmp    801893 <strstr+0x99>

	len = strlen(str);
  801828:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80182c:	48 89 c7             	mov    %rax,%rdi
  80182f:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  801836:	00 00 00 
  801839:	ff d0                	callq  *%rax
  80183b:	48 98                	cltq   
  80183d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801841:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801845:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801849:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80184d:	0f b6 00             	movzbl (%rax),%eax
  801850:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801853:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801857:	75 07                	jne    801860 <strstr+0x66>
				return (char *) 0;
  801859:	b8 00 00 00 00       	mov    $0x0,%eax
  80185e:	eb 33                	jmp    801893 <strstr+0x99>
		} while (sc != c);
  801860:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801864:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801867:	75 d8                	jne    801841 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801869:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80186d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801871:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801875:	48 89 ce             	mov    %rcx,%rsi
  801878:	48 89 c7             	mov    %rax,%rdi
  80187b:	48 b8 f1 12 80 00 00 	movabs $0x8012f1,%rax
  801882:	00 00 00 
  801885:	ff d0                	callq  *%rax
  801887:	85 c0                	test   %eax,%eax
  801889:	75 b6                	jne    801841 <strstr+0x47>

	return (char *) (in - 1);
  80188b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188f:	48 83 e8 01          	sub    $0x1,%rax
}
  801893:	c9                   	leaveq 
  801894:	c3                   	retq   

0000000000801895 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801895:	55                   	push   %rbp
  801896:	48 89 e5             	mov    %rsp,%rbp
  801899:	53                   	push   %rbx
  80189a:	48 83 ec 48          	sub    $0x48,%rsp
  80189e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018a1:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018a4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018a8:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018ac:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018b0:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018b4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018b7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018bb:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018bf:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8018c3:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8018c7:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8018cb:	4c 89 c3             	mov    %r8,%rbx
  8018ce:	cd 30                	int    $0x30
  8018d0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8018d4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8018d8:	74 3e                	je     801918 <syscall+0x83>
  8018da:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018df:	7e 37                	jle    801918 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018e5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018e8:	49 89 d0             	mov    %rdx,%r8
  8018eb:	89 c1                	mov    %eax,%ecx
  8018ed:	48 ba e8 5b 80 00 00 	movabs $0x805be8,%rdx
  8018f4:	00 00 00 
  8018f7:	be 24 00 00 00       	mov    $0x24,%esi
  8018fc:	48 bf 05 5c 80 00 00 	movabs $0x805c05,%rdi
  801903:	00 00 00 
  801906:	b8 00 00 00 00       	mov    $0x0,%eax
  80190b:	49 b9 4e 03 80 00 00 	movabs $0x80034e,%r9
  801912:	00 00 00 
  801915:	41 ff d1             	callq  *%r9

	return ret;
  801918:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80191c:	48 83 c4 48          	add    $0x48,%rsp
  801920:	5b                   	pop    %rbx
  801921:	5d                   	pop    %rbp
  801922:	c3                   	retq   

0000000000801923 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801923:	55                   	push   %rbp
  801924:	48 89 e5             	mov    %rsp,%rbp
  801927:	48 83 ec 20          	sub    $0x20,%rsp
  80192b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80192f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801933:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801937:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80193b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801942:	00 
  801943:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801949:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80194f:	48 89 d1             	mov    %rdx,%rcx
  801952:	48 89 c2             	mov    %rax,%rdx
  801955:	be 00 00 00 00       	mov    $0x0,%esi
  80195a:	bf 00 00 00 00       	mov    $0x0,%edi
  80195f:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801966:	00 00 00 
  801969:	ff d0                	callq  *%rax
}
  80196b:	c9                   	leaveq 
  80196c:	c3                   	retq   

000000000080196d <sys_cgetc>:

int
sys_cgetc(void)
{
  80196d:	55                   	push   %rbp
  80196e:	48 89 e5             	mov    %rsp,%rbp
  801971:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801975:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197c:	00 
  80197d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801983:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801989:	b9 00 00 00 00       	mov    $0x0,%ecx
  80198e:	ba 00 00 00 00       	mov    $0x0,%edx
  801993:	be 00 00 00 00       	mov    $0x0,%esi
  801998:	bf 01 00 00 00       	mov    $0x1,%edi
  80199d:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  8019a4:	00 00 00 
  8019a7:	ff d0                	callq  *%rax
}
  8019a9:	c9                   	leaveq 
  8019aa:	c3                   	retq   

00000000008019ab <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019ab:	55                   	push   %rbp
  8019ac:	48 89 e5             	mov    %rsp,%rbp
  8019af:	48 83 ec 10          	sub    $0x10,%rsp
  8019b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8019b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b9:	48 98                	cltq   
  8019bb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c2:	00 
  8019c3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019d4:	48 89 c2             	mov    %rax,%rdx
  8019d7:	be 01 00 00 00       	mov    $0x1,%esi
  8019dc:	bf 03 00 00 00       	mov    $0x3,%edi
  8019e1:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  8019e8:	00 00 00 
  8019eb:	ff d0                	callq  *%rax
}
  8019ed:	c9                   	leaveq 
  8019ee:	c3                   	retq   

00000000008019ef <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019ef:	55                   	push   %rbp
  8019f0:	48 89 e5             	mov    %rsp,%rbp
  8019f3:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019f7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019fe:	00 
  8019ff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a05:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a10:	ba 00 00 00 00       	mov    $0x0,%edx
  801a15:	be 00 00 00 00       	mov    $0x0,%esi
  801a1a:	bf 02 00 00 00       	mov    $0x2,%edi
  801a1f:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801a26:	00 00 00 
  801a29:	ff d0                	callq  *%rax
}
  801a2b:	c9                   	leaveq 
  801a2c:	c3                   	retq   

0000000000801a2d <sys_yield>:


void
sys_yield(void)
{
  801a2d:	55                   	push   %rbp
  801a2e:	48 89 e5             	mov    %rsp,%rbp
  801a31:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a35:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3c:	00 
  801a3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a43:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a49:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a53:	be 00 00 00 00       	mov    $0x0,%esi
  801a58:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a5d:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801a64:	00 00 00 
  801a67:	ff d0                	callq  *%rax
}
  801a69:	c9                   	leaveq 
  801a6a:	c3                   	retq   

0000000000801a6b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a6b:	55                   	push   %rbp
  801a6c:	48 89 e5             	mov    %rsp,%rbp
  801a6f:	48 83 ec 20          	sub    $0x20,%rsp
  801a73:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a76:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a7a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a7d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a80:	48 63 c8             	movslq %eax,%rcx
  801a83:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a8a:	48 98                	cltq   
  801a8c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a93:	00 
  801a94:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a9a:	49 89 c8             	mov    %rcx,%r8
  801a9d:	48 89 d1             	mov    %rdx,%rcx
  801aa0:	48 89 c2             	mov    %rax,%rdx
  801aa3:	be 01 00 00 00       	mov    $0x1,%esi
  801aa8:	bf 04 00 00 00       	mov    $0x4,%edi
  801aad:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801ab4:	00 00 00 
  801ab7:	ff d0                	callq  *%rax
}
  801ab9:	c9                   	leaveq 
  801aba:	c3                   	retq   

0000000000801abb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801abb:	55                   	push   %rbp
  801abc:	48 89 e5             	mov    %rsp,%rbp
  801abf:	48 83 ec 30          	sub    $0x30,%rsp
  801ac3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ac6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801aca:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801acd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ad1:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ad5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ad8:	48 63 c8             	movslq %eax,%rcx
  801adb:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801adf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ae2:	48 63 f0             	movslq %eax,%rsi
  801ae5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ae9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aec:	48 98                	cltq   
  801aee:	48 89 0c 24          	mov    %rcx,(%rsp)
  801af2:	49 89 f9             	mov    %rdi,%r9
  801af5:	49 89 f0             	mov    %rsi,%r8
  801af8:	48 89 d1             	mov    %rdx,%rcx
  801afb:	48 89 c2             	mov    %rax,%rdx
  801afe:	be 01 00 00 00       	mov    $0x1,%esi
  801b03:	bf 05 00 00 00       	mov    $0x5,%edi
  801b08:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801b0f:	00 00 00 
  801b12:	ff d0                	callq  *%rax
}
  801b14:	c9                   	leaveq 
  801b15:	c3                   	retq   

0000000000801b16 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b16:	55                   	push   %rbp
  801b17:	48 89 e5             	mov    %rsp,%rbp
  801b1a:	48 83 ec 20          	sub    $0x20,%rsp
  801b1e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b25:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b2c:	48 98                	cltq   
  801b2e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b35:	00 
  801b36:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b3c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b42:	48 89 d1             	mov    %rdx,%rcx
  801b45:	48 89 c2             	mov    %rax,%rdx
  801b48:	be 01 00 00 00       	mov    $0x1,%esi
  801b4d:	bf 06 00 00 00       	mov    $0x6,%edi
  801b52:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801b59:	00 00 00 
  801b5c:	ff d0                	callq  *%rax
}
  801b5e:	c9                   	leaveq 
  801b5f:	c3                   	retq   

0000000000801b60 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b60:	55                   	push   %rbp
  801b61:	48 89 e5             	mov    %rsp,%rbp
  801b64:	48 83 ec 10          	sub    $0x10,%rsp
  801b68:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b6b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b6e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b71:	48 63 d0             	movslq %eax,%rdx
  801b74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b77:	48 98                	cltq   
  801b79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b80:	00 
  801b81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b8d:	48 89 d1             	mov    %rdx,%rcx
  801b90:	48 89 c2             	mov    %rax,%rdx
  801b93:	be 01 00 00 00       	mov    $0x1,%esi
  801b98:	bf 08 00 00 00       	mov    $0x8,%edi
  801b9d:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801ba4:	00 00 00 
  801ba7:	ff d0                	callq  *%rax
}
  801ba9:	c9                   	leaveq 
  801baa:	c3                   	retq   

0000000000801bab <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801bab:	55                   	push   %rbp
  801bac:	48 89 e5             	mov    %rsp,%rbp
  801baf:	48 83 ec 20          	sub    $0x20,%rsp
  801bb3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bb6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801bba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc1:	48 98                	cltq   
  801bc3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bca:	00 
  801bcb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bd7:	48 89 d1             	mov    %rdx,%rcx
  801bda:	48 89 c2             	mov    %rax,%rdx
  801bdd:	be 01 00 00 00       	mov    $0x1,%esi
  801be2:	bf 09 00 00 00       	mov    $0x9,%edi
  801be7:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801bee:	00 00 00 
  801bf1:	ff d0                	callq  *%rax
}
  801bf3:	c9                   	leaveq 
  801bf4:	c3                   	retq   

0000000000801bf5 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801bf5:	55                   	push   %rbp
  801bf6:	48 89 e5             	mov    %rsp,%rbp
  801bf9:	48 83 ec 20          	sub    $0x20,%rsp
  801bfd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c00:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c04:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c0b:	48 98                	cltq   
  801c0d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c14:	00 
  801c15:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c1b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c21:	48 89 d1             	mov    %rdx,%rcx
  801c24:	48 89 c2             	mov    %rax,%rdx
  801c27:	be 01 00 00 00       	mov    $0x1,%esi
  801c2c:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c31:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801c38:	00 00 00 
  801c3b:	ff d0                	callq  *%rax
}
  801c3d:	c9                   	leaveq 
  801c3e:	c3                   	retq   

0000000000801c3f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c3f:	55                   	push   %rbp
  801c40:	48 89 e5             	mov    %rsp,%rbp
  801c43:	48 83 ec 20          	sub    $0x20,%rsp
  801c47:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c4a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c4e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c52:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c55:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c58:	48 63 f0             	movslq %eax,%rsi
  801c5b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c62:	48 98                	cltq   
  801c64:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c68:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c6f:	00 
  801c70:	49 89 f1             	mov    %rsi,%r9
  801c73:	49 89 c8             	mov    %rcx,%r8
  801c76:	48 89 d1             	mov    %rdx,%rcx
  801c79:	48 89 c2             	mov    %rax,%rdx
  801c7c:	be 00 00 00 00       	mov    $0x0,%esi
  801c81:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c86:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801c8d:	00 00 00 
  801c90:	ff d0                	callq  *%rax
}
  801c92:	c9                   	leaveq 
  801c93:	c3                   	retq   

0000000000801c94 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c94:	55                   	push   %rbp
  801c95:	48 89 e5             	mov    %rsp,%rbp
  801c98:	48 83 ec 10          	sub    $0x10,%rsp
  801c9c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ca0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ca4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cab:	00 
  801cac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cb2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cbd:	48 89 c2             	mov    %rax,%rdx
  801cc0:	be 01 00 00 00       	mov    $0x1,%esi
  801cc5:	bf 0d 00 00 00       	mov    $0xd,%edi
  801cca:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801cd1:	00 00 00 
  801cd4:	ff d0                	callq  *%rax
}
  801cd6:	c9                   	leaveq 
  801cd7:	c3                   	retq   

0000000000801cd8 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801cd8:	55                   	push   %rbp
  801cd9:	48 89 e5             	mov    %rsp,%rbp
  801cdc:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801ce0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce7:	00 
  801ce8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cf9:	ba 00 00 00 00       	mov    $0x0,%edx
  801cfe:	be 00 00 00 00       	mov    $0x0,%esi
  801d03:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d08:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801d0f:	00 00 00 
  801d12:	ff d0                	callq  *%rax
}
  801d14:	c9                   	leaveq 
  801d15:	c3                   	retq   

0000000000801d16 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801d16:	55                   	push   %rbp
  801d17:	48 89 e5             	mov    %rsp,%rbp
  801d1a:	48 83 ec 20          	sub    $0x20,%rsp
  801d1e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d22:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801d25:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801d28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d2c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d33:	00 
  801d34:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d3a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d40:	48 89 d1             	mov    %rdx,%rcx
  801d43:	48 89 c2             	mov    %rax,%rdx
  801d46:	be 00 00 00 00       	mov    $0x0,%esi
  801d4b:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d50:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801d57:	00 00 00 
  801d5a:	ff d0                	callq  *%rax
}
  801d5c:	c9                   	leaveq 
  801d5d:	c3                   	retq   

0000000000801d5e <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801d5e:	55                   	push   %rbp
  801d5f:	48 89 e5             	mov    %rsp,%rbp
  801d62:	48 83 ec 20          	sub    $0x20,%rsp
  801d66:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d6a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801d6d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801d70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d74:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d7b:	00 
  801d7c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d82:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d88:	48 89 d1             	mov    %rdx,%rcx
  801d8b:	48 89 c2             	mov    %rax,%rdx
  801d8e:	be 00 00 00 00       	mov    $0x0,%esi
  801d93:	bf 10 00 00 00       	mov    $0x10,%edi
  801d98:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801d9f:	00 00 00 
  801da2:	ff d0                	callq  *%rax
}
  801da4:	c9                   	leaveq 
  801da5:	c3                   	retq   

0000000000801da6 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801da6:	55                   	push   %rbp
  801da7:	48 89 e5             	mov    %rsp,%rbp
  801daa:	48 83 ec 30          	sub    $0x30,%rsp
  801dae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801db1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801db5:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801db8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801dbc:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801dc0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801dc3:	48 63 c8             	movslq %eax,%rcx
  801dc6:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801dca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dcd:	48 63 f0             	movslq %eax,%rsi
  801dd0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd7:	48 98                	cltq   
  801dd9:	48 89 0c 24          	mov    %rcx,(%rsp)
  801ddd:	49 89 f9             	mov    %rdi,%r9
  801de0:	49 89 f0             	mov    %rsi,%r8
  801de3:	48 89 d1             	mov    %rdx,%rcx
  801de6:	48 89 c2             	mov    %rax,%rdx
  801de9:	be 00 00 00 00       	mov    $0x0,%esi
  801dee:	bf 11 00 00 00       	mov    $0x11,%edi
  801df3:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801dfa:	00 00 00 
  801dfd:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801dff:	c9                   	leaveq 
  801e00:	c3                   	retq   

0000000000801e01 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801e01:	55                   	push   %rbp
  801e02:	48 89 e5             	mov    %rsp,%rbp
  801e05:	48 83 ec 20          	sub    $0x20,%rsp
  801e09:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e0d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801e11:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e19:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e20:	00 
  801e21:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e27:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e2d:	48 89 d1             	mov    %rdx,%rcx
  801e30:	48 89 c2             	mov    %rax,%rdx
  801e33:	be 00 00 00 00       	mov    $0x0,%esi
  801e38:	bf 12 00 00 00       	mov    $0x12,%edi
  801e3d:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801e44:	00 00 00 
  801e47:	ff d0                	callq  *%rax
}
  801e49:	c9                   	leaveq 
  801e4a:	c3                   	retq   

0000000000801e4b <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801e4b:	55                   	push   %rbp
  801e4c:	48 89 e5             	mov    %rsp,%rbp
  801e4f:	48 83 ec 30          	sub    $0x30,%rsp
  801e53:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801e57:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e5b:	48 8b 00             	mov    (%rax),%rax
  801e5e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801e62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e66:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e6a:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  801e6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e70:	83 e0 02             	and    $0x2,%eax
  801e73:	85 c0                	test   %eax,%eax
  801e75:	75 40                	jne    801eb7 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  801e77:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e7b:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  801e82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e86:	49 89 d0             	mov    %rdx,%r8
  801e89:	48 89 c1             	mov    %rax,%rcx
  801e8c:	48 ba 18 5c 80 00 00 	movabs $0x805c18,%rdx
  801e93:	00 00 00 
  801e96:	be 1f 00 00 00       	mov    $0x1f,%esi
  801e9b:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  801ea2:	00 00 00 
  801ea5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eaa:	49 b9 4e 03 80 00 00 	movabs $0x80034e,%r9
  801eb1:	00 00 00 
  801eb4:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  801eb7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ebb:	48 c1 e8 0c          	shr    $0xc,%rax
  801ebf:	48 89 c2             	mov    %rax,%rdx
  801ec2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ec9:	01 00 00 
  801ecc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ed0:	25 07 08 00 00       	and    $0x807,%eax
  801ed5:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  801edb:	74 4e                	je     801f2b <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  801edd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ee1:	48 c1 e8 0c          	shr    $0xc,%rax
  801ee5:	48 89 c2             	mov    %rax,%rdx
  801ee8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801eef:	01 00 00 
  801ef2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801ef6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801efa:	49 89 d0             	mov    %rdx,%r8
  801efd:	48 89 c1             	mov    %rax,%rcx
  801f00:	48 ba 40 5c 80 00 00 	movabs $0x805c40,%rdx
  801f07:	00 00 00 
  801f0a:	be 22 00 00 00       	mov    $0x22,%esi
  801f0f:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  801f16:	00 00 00 
  801f19:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1e:	49 b9 4e 03 80 00 00 	movabs $0x80034e,%r9
  801f25:	00 00 00 
  801f28:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801f2b:	ba 07 00 00 00       	mov    $0x7,%edx
  801f30:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f35:	bf 00 00 00 00       	mov    $0x0,%edi
  801f3a:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  801f41:	00 00 00 
  801f44:	ff d0                	callq  *%rax
  801f46:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801f49:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801f4d:	79 30                	jns    801f7f <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  801f4f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f52:	89 c1                	mov    %eax,%ecx
  801f54:	48 ba 6b 5c 80 00 00 	movabs $0x805c6b,%rdx
  801f5b:	00 00 00 
  801f5e:	be 28 00 00 00       	mov    $0x28,%esi
  801f63:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  801f6a:	00 00 00 
  801f6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f72:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  801f79:	00 00 00 
  801f7c:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  801f7f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f83:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801f87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f8b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801f91:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f96:	48 89 c6             	mov    %rax,%rsi
  801f99:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801f9e:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  801fa5:	00 00 00 
  801fa8:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  801faa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801fb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fb6:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801fbc:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801fc2:	48 89 c1             	mov    %rax,%rcx
  801fc5:	ba 00 00 00 00       	mov    $0x0,%edx
  801fca:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fcf:	bf 00 00 00 00       	mov    $0x0,%edi
  801fd4:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  801fdb:	00 00 00 
  801fde:	ff d0                	callq  *%rax
  801fe0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801fe3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801fe7:	79 30                	jns    802019 <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  801fe9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fec:	89 c1                	mov    %eax,%ecx
  801fee:	48 ba 7e 5c 80 00 00 	movabs $0x805c7e,%rdx
  801ff5:	00 00 00 
  801ff8:	be 2d 00 00 00       	mov    $0x2d,%esi
  801ffd:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  802004:	00 00 00 
  802007:	b8 00 00 00 00       	mov    $0x0,%eax
  80200c:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  802013:	00 00 00 
  802016:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  802019:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80201e:	bf 00 00 00 00       	mov    $0x0,%edi
  802023:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  80202a:	00 00 00 
  80202d:	ff d0                	callq  *%rax
  80202f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802032:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802036:	79 30                	jns    802068 <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  802038:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80203b:	89 c1                	mov    %eax,%ecx
  80203d:	48 ba 8f 5c 80 00 00 	movabs $0x805c8f,%rdx
  802044:	00 00 00 
  802047:	be 31 00 00 00       	mov    $0x31,%esi
  80204c:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  802053:	00 00 00 
  802056:	b8 00 00 00 00       	mov    $0x0,%eax
  80205b:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  802062:	00 00 00 
  802065:	41 ff d0             	callq  *%r8

}
  802068:	c9                   	leaveq 
  802069:	c3                   	retq   

000000000080206a <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80206a:	55                   	push   %rbp
  80206b:	48 89 e5             	mov    %rsp,%rbp
  80206e:	48 83 ec 30          	sub    $0x30,%rsp
  802072:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802075:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  802078:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80207b:	c1 e0 0c             	shl    $0xc,%eax
  80207e:	89 c0                	mov    %eax,%eax
  802080:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  802084:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80208b:	01 00 00 
  80208e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802091:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802095:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  802099:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80209d:	25 02 08 00 00       	and    $0x802,%eax
  8020a2:	48 85 c0             	test   %rax,%rax
  8020a5:	74 0e                	je     8020b5 <duppage+0x4b>
  8020a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020ab:	25 00 04 00 00       	and    $0x400,%eax
  8020b0:	48 85 c0             	test   %rax,%rax
  8020b3:	74 70                	je     802125 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  8020b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020b9:	25 07 0e 00 00       	and    $0xe07,%eax
  8020be:	89 c6                	mov    %eax,%esi
  8020c0:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8020c4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020cb:	41 89 f0             	mov    %esi,%r8d
  8020ce:	48 89 c6             	mov    %rax,%rsi
  8020d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8020d6:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  8020dd:	00 00 00 
  8020e0:	ff d0                	callq  *%rax
  8020e2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8020e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8020e9:	79 30                	jns    80211b <duppage+0xb1>
			panic("sys_page_map: %e", r);
  8020eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020ee:	89 c1                	mov    %eax,%ecx
  8020f0:	48 ba 7e 5c 80 00 00 	movabs $0x805c7e,%rdx
  8020f7:	00 00 00 
  8020fa:	be 50 00 00 00       	mov    $0x50,%esi
  8020ff:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  802106:	00 00 00 
  802109:	b8 00 00 00 00       	mov    $0x0,%eax
  80210e:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  802115:	00 00 00 
  802118:	41 ff d0             	callq  *%r8
		return 0;
  80211b:	b8 00 00 00 00       	mov    $0x0,%eax
  802120:	e9 c4 00 00 00       	jmpq   8021e9 <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802125:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802129:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80212c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802130:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802136:	48 89 c6             	mov    %rax,%rsi
  802139:	bf 00 00 00 00       	mov    $0x0,%edi
  80213e:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  802145:	00 00 00 
  802148:	ff d0                	callq  *%rax
  80214a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80214d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802151:	79 30                	jns    802183 <duppage+0x119>
		panic("sys_page_map: %e", r);
  802153:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802156:	89 c1                	mov    %eax,%ecx
  802158:	48 ba 7e 5c 80 00 00 	movabs $0x805c7e,%rdx
  80215f:	00 00 00 
  802162:	be 64 00 00 00       	mov    $0x64,%esi
  802167:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  80216e:	00 00 00 
  802171:	b8 00 00 00 00       	mov    $0x0,%eax
  802176:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  80217d:	00 00 00 
  802180:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802183:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802187:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80218b:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802191:	48 89 d1             	mov    %rdx,%rcx
  802194:	ba 00 00 00 00       	mov    $0x0,%edx
  802199:	48 89 c6             	mov    %rax,%rsi
  80219c:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a1:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  8021a8:	00 00 00 
  8021ab:	ff d0                	callq  *%rax
  8021ad:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8021b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021b4:	79 30                	jns    8021e6 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  8021b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021b9:	89 c1                	mov    %eax,%ecx
  8021bb:	48 ba 7e 5c 80 00 00 	movabs $0x805c7e,%rdx
  8021c2:	00 00 00 
  8021c5:	be 66 00 00 00       	mov    $0x66,%esi
  8021ca:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  8021d1:	00 00 00 
  8021d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d9:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  8021e0:	00 00 00 
  8021e3:	41 ff d0             	callq  *%r8
	return r;
  8021e6:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8021e9:	c9                   	leaveq 
  8021ea:	c3                   	retq   

00000000008021eb <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8021eb:	55                   	push   %rbp
  8021ec:	48 89 e5             	mov    %rsp,%rbp
  8021ef:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  8021f3:	48 bf 4b 1e 80 00 00 	movabs $0x801e4b,%rdi
  8021fa:	00 00 00 
  8021fd:	48 b8 12 51 80 00 00 	movabs $0x805112,%rax
  802204:	00 00 00 
  802207:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802209:	b8 07 00 00 00       	mov    $0x7,%eax
  80220e:	cd 30                	int    $0x30
  802210:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802213:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  802216:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  802219:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80221d:	79 08                	jns    802227 <fork+0x3c>
		return envid;
  80221f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802222:	e9 09 02 00 00       	jmpq   802430 <fork+0x245>
	if (envid == 0) {
  802227:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80222b:	75 3e                	jne    80226b <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  80222d:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  802234:	00 00 00 
  802237:	ff d0                	callq  *%rax
  802239:	25 ff 03 00 00       	and    $0x3ff,%eax
  80223e:	48 98                	cltq   
  802240:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  802247:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80224e:	00 00 00 
  802251:	48 01 c2             	add    %rax,%rdx
  802254:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80225b:	00 00 00 
  80225e:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802261:	b8 00 00 00 00       	mov    $0x0,%eax
  802266:	e9 c5 01 00 00       	jmpq   802430 <fork+0x245>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  80226b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802272:	e9 a4 00 00 00       	jmpq   80231b <fork+0x130>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  802277:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80227a:	c1 f8 12             	sar    $0x12,%eax
  80227d:	89 c2                	mov    %eax,%edx
  80227f:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802286:	01 00 00 
  802289:	48 63 d2             	movslq %edx,%rdx
  80228c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802290:	83 e0 01             	and    $0x1,%eax
  802293:	48 85 c0             	test   %rax,%rax
  802296:	74 21                	je     8022b9 <fork+0xce>
  802298:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229b:	c1 f8 09             	sar    $0x9,%eax
  80229e:	89 c2                	mov    %eax,%edx
  8022a0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022a7:	01 00 00 
  8022aa:	48 63 d2             	movslq %edx,%rdx
  8022ad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022b1:	83 e0 01             	and    $0x1,%eax
  8022b4:	48 85 c0             	test   %rax,%rax
  8022b7:	75 09                	jne    8022c2 <fork+0xd7>
			pn += NPTENTRIES;
  8022b9:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  8022c0:	eb 59                	jmp    80231b <fork+0x130>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  8022c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022c5:	05 00 02 00 00       	add    $0x200,%eax
  8022ca:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8022cd:	eb 44                	jmp    802313 <fork+0x128>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  8022cf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022d6:	01 00 00 
  8022d9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022dc:	48 63 d2             	movslq %edx,%rdx
  8022df:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022e3:	83 e0 05             	and    $0x5,%eax
  8022e6:	48 83 f8 05          	cmp    $0x5,%rax
  8022ea:	74 02                	je     8022ee <fork+0x103>
				continue;
  8022ec:	eb 21                	jmp    80230f <fork+0x124>
			if (pn == PPN(UXSTACKTOP - 1))
  8022ee:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  8022f5:	75 02                	jne    8022f9 <fork+0x10e>
				continue;
  8022f7:	eb 16                	jmp    80230f <fork+0x124>
			duppage(envid, pn);
  8022f9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022ff:	89 d6                	mov    %edx,%esi
  802301:	89 c7                	mov    %eax,%edi
  802303:	48 b8 6a 20 80 00 00 	movabs $0x80206a,%rax
  80230a:	00 00 00 
  80230d:	ff d0                	callq  *%rax
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  80230f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802313:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802316:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  802319:	7c b4                	jl     8022cf <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  80231b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80231e:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  802323:	0f 86 4e ff ff ff    	jbe    802277 <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802329:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80232c:	ba 07 00 00 00       	mov    $0x7,%edx
  802331:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802336:	89 c7                	mov    %eax,%edi
  802338:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  80233f:	00 00 00 
  802342:	ff d0                	callq  *%rax
  802344:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802347:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80234b:	79 30                	jns    80237d <fork+0x192>
		panic("allocating exception stack: %e", r);
  80234d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802350:	89 c1                	mov    %eax,%ecx
  802352:	48 ba a8 5c 80 00 00 	movabs $0x805ca8,%rdx
  802359:	00 00 00 
  80235c:	be 9e 00 00 00       	mov    $0x9e,%esi
  802361:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  802368:	00 00 00 
  80236b:	b8 00 00 00 00       	mov    $0x0,%eax
  802370:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  802377:	00 00 00 
  80237a:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  80237d:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802384:	00 00 00 
  802387:	48 8b 00             	mov    (%rax),%rax
  80238a:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802391:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802394:	48 89 d6             	mov    %rdx,%rsi
  802397:	89 c7                	mov    %eax,%edi
  802399:	48 b8 f5 1b 80 00 00 	movabs $0x801bf5,%rax
  8023a0:	00 00 00 
  8023a3:	ff d0                	callq  *%rax
  8023a5:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8023a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8023ac:	79 30                	jns    8023de <fork+0x1f3>
		panic("sys_env_set_pgfault_upcall: %e", r);
  8023ae:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8023b1:	89 c1                	mov    %eax,%ecx
  8023b3:	48 ba c8 5c 80 00 00 	movabs $0x805cc8,%rdx
  8023ba:	00 00 00 
  8023bd:	be a2 00 00 00       	mov    $0xa2,%esi
  8023c2:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  8023c9:	00 00 00 
  8023cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d1:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  8023d8:	00 00 00 
  8023db:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8023de:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023e1:	be 02 00 00 00       	mov    $0x2,%esi
  8023e6:	89 c7                	mov    %eax,%edi
  8023e8:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  8023ef:	00 00 00 
  8023f2:	ff d0                	callq  *%rax
  8023f4:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8023f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8023fb:	79 30                	jns    80242d <fork+0x242>
		panic("sys_env_set_status: %e", r);
  8023fd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802400:	89 c1                	mov    %eax,%ecx
  802402:	48 ba e7 5c 80 00 00 	movabs $0x805ce7,%rdx
  802409:	00 00 00 
  80240c:	be a7 00 00 00       	mov    $0xa7,%esi
  802411:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  802418:	00 00 00 
  80241b:	b8 00 00 00 00       	mov    $0x0,%eax
  802420:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  802427:	00 00 00 
  80242a:	41 ff d0             	callq  *%r8

	return envid;
  80242d:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  802430:	c9                   	leaveq 
  802431:	c3                   	retq   

0000000000802432 <sfork>:

// Challenge!
int
sfork(void)
{
  802432:	55                   	push   %rbp
  802433:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802436:	48 ba fe 5c 80 00 00 	movabs $0x805cfe,%rdx
  80243d:	00 00 00 
  802440:	be b1 00 00 00       	mov    $0xb1,%esi
  802445:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  80244c:	00 00 00 
  80244f:	b8 00 00 00 00       	mov    $0x0,%eax
  802454:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  80245b:	00 00 00 
  80245e:	ff d1                	callq  *%rcx

0000000000802460 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802460:	55                   	push   %rbp
  802461:	48 89 e5             	mov    %rsp,%rbp
  802464:	48 83 ec 08          	sub    $0x8,%rsp
  802468:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80246c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802470:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802477:	ff ff ff 
  80247a:	48 01 d0             	add    %rdx,%rax
  80247d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802481:	c9                   	leaveq 
  802482:	c3                   	retq   

0000000000802483 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802483:	55                   	push   %rbp
  802484:	48 89 e5             	mov    %rsp,%rbp
  802487:	48 83 ec 08          	sub    $0x8,%rsp
  80248b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80248f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802493:	48 89 c7             	mov    %rax,%rdi
  802496:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  80249d:	00 00 00 
  8024a0:	ff d0                	callq  *%rax
  8024a2:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8024a8:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8024ac:	c9                   	leaveq 
  8024ad:	c3                   	retq   

00000000008024ae <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8024ae:	55                   	push   %rbp
  8024af:	48 89 e5             	mov    %rsp,%rbp
  8024b2:	48 83 ec 18          	sub    $0x18,%rsp
  8024b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8024ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024c1:	eb 6b                	jmp    80252e <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8024c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c6:	48 98                	cltq   
  8024c8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024ce:	48 c1 e0 0c          	shl    $0xc,%rax
  8024d2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8024d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024da:	48 c1 e8 15          	shr    $0x15,%rax
  8024de:	48 89 c2             	mov    %rax,%rdx
  8024e1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024e8:	01 00 00 
  8024eb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024ef:	83 e0 01             	and    $0x1,%eax
  8024f2:	48 85 c0             	test   %rax,%rax
  8024f5:	74 21                	je     802518 <fd_alloc+0x6a>
  8024f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024fb:	48 c1 e8 0c          	shr    $0xc,%rax
  8024ff:	48 89 c2             	mov    %rax,%rdx
  802502:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802509:	01 00 00 
  80250c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802510:	83 e0 01             	and    $0x1,%eax
  802513:	48 85 c0             	test   %rax,%rax
  802516:	75 12                	jne    80252a <fd_alloc+0x7c>
			*fd_store = fd;
  802518:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80251c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802520:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802523:	b8 00 00 00 00       	mov    $0x0,%eax
  802528:	eb 1a                	jmp    802544 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80252a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80252e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802532:	7e 8f                	jle    8024c3 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802534:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802538:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80253f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802544:	c9                   	leaveq 
  802545:	c3                   	retq   

0000000000802546 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802546:	55                   	push   %rbp
  802547:	48 89 e5             	mov    %rsp,%rbp
  80254a:	48 83 ec 20          	sub    $0x20,%rsp
  80254e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802551:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802555:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802559:	78 06                	js     802561 <fd_lookup+0x1b>
  80255b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80255f:	7e 07                	jle    802568 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802561:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802566:	eb 6c                	jmp    8025d4 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802568:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80256b:	48 98                	cltq   
  80256d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802573:	48 c1 e0 0c          	shl    $0xc,%rax
  802577:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80257b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80257f:	48 c1 e8 15          	shr    $0x15,%rax
  802583:	48 89 c2             	mov    %rax,%rdx
  802586:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80258d:	01 00 00 
  802590:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802594:	83 e0 01             	and    $0x1,%eax
  802597:	48 85 c0             	test   %rax,%rax
  80259a:	74 21                	je     8025bd <fd_lookup+0x77>
  80259c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025a0:	48 c1 e8 0c          	shr    $0xc,%rax
  8025a4:	48 89 c2             	mov    %rax,%rdx
  8025a7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025ae:	01 00 00 
  8025b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025b5:	83 e0 01             	and    $0x1,%eax
  8025b8:	48 85 c0             	test   %rax,%rax
  8025bb:	75 07                	jne    8025c4 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025c2:	eb 10                	jmp    8025d4 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8025c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025c8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025cc:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8025cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d4:	c9                   	leaveq 
  8025d5:	c3                   	retq   

00000000008025d6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8025d6:	55                   	push   %rbp
  8025d7:	48 89 e5             	mov    %rsp,%rbp
  8025da:	48 83 ec 30          	sub    $0x30,%rsp
  8025de:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8025e2:	89 f0                	mov    %esi,%eax
  8025e4:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8025e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025eb:	48 89 c7             	mov    %rax,%rdi
  8025ee:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  8025f5:	00 00 00 
  8025f8:	ff d0                	callq  *%rax
  8025fa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025fe:	48 89 d6             	mov    %rdx,%rsi
  802601:	89 c7                	mov    %eax,%edi
  802603:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  80260a:	00 00 00 
  80260d:	ff d0                	callq  *%rax
  80260f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802612:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802616:	78 0a                	js     802622 <fd_close+0x4c>
	    || fd != fd2)
  802618:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80261c:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802620:	74 12                	je     802634 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802622:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802626:	74 05                	je     80262d <fd_close+0x57>
  802628:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80262b:	eb 05                	jmp    802632 <fd_close+0x5c>
  80262d:	b8 00 00 00 00       	mov    $0x0,%eax
  802632:	eb 69                	jmp    80269d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802634:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802638:	8b 00                	mov    (%rax),%eax
  80263a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80263e:	48 89 d6             	mov    %rdx,%rsi
  802641:	89 c7                	mov    %eax,%edi
  802643:	48 b8 9f 26 80 00 00 	movabs $0x80269f,%rax
  80264a:	00 00 00 
  80264d:	ff d0                	callq  *%rax
  80264f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802652:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802656:	78 2a                	js     802682 <fd_close+0xac>
		if (dev->dev_close)
  802658:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80265c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802660:	48 85 c0             	test   %rax,%rax
  802663:	74 16                	je     80267b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802665:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802669:	48 8b 40 20          	mov    0x20(%rax),%rax
  80266d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802671:	48 89 d7             	mov    %rdx,%rdi
  802674:	ff d0                	callq  *%rax
  802676:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802679:	eb 07                	jmp    802682 <fd_close+0xac>
		else
			r = 0;
  80267b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802682:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802686:	48 89 c6             	mov    %rax,%rsi
  802689:	bf 00 00 00 00       	mov    $0x0,%edi
  80268e:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  802695:	00 00 00 
  802698:	ff d0                	callq  *%rax
	return r;
  80269a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80269d:	c9                   	leaveq 
  80269e:	c3                   	retq   

000000000080269f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80269f:	55                   	push   %rbp
  8026a0:	48 89 e5             	mov    %rsp,%rbp
  8026a3:	48 83 ec 20          	sub    $0x20,%rsp
  8026a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8026ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026b5:	eb 41                	jmp    8026f8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8026b7:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8026be:	00 00 00 
  8026c1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026c4:	48 63 d2             	movslq %edx,%rdx
  8026c7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026cb:	8b 00                	mov    (%rax),%eax
  8026cd:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8026d0:	75 22                	jne    8026f4 <dev_lookup+0x55>
			*dev = devtab[i];
  8026d2:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8026d9:	00 00 00 
  8026dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026df:	48 63 d2             	movslq %edx,%rdx
  8026e2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8026e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026ea:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f2:	eb 60                	jmp    802754 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8026f4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026f8:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8026ff:	00 00 00 
  802702:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802705:	48 63 d2             	movslq %edx,%rdx
  802708:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80270c:	48 85 c0             	test   %rax,%rax
  80270f:	75 a6                	jne    8026b7 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802711:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802718:	00 00 00 
  80271b:	48 8b 00             	mov    (%rax),%rax
  80271e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802724:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802727:	89 c6                	mov    %eax,%esi
  802729:	48 bf 18 5d 80 00 00 	movabs $0x805d18,%rdi
  802730:	00 00 00 
  802733:	b8 00 00 00 00       	mov    $0x0,%eax
  802738:	48 b9 87 05 80 00 00 	movabs $0x800587,%rcx
  80273f:	00 00 00 
  802742:	ff d1                	callq  *%rcx
	*dev = 0;
  802744:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802748:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80274f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802754:	c9                   	leaveq 
  802755:	c3                   	retq   

0000000000802756 <close>:

int
close(int fdnum)
{
  802756:	55                   	push   %rbp
  802757:	48 89 e5             	mov    %rsp,%rbp
  80275a:	48 83 ec 20          	sub    $0x20,%rsp
  80275e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802761:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802765:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802768:	48 89 d6             	mov    %rdx,%rsi
  80276b:	89 c7                	mov    %eax,%edi
  80276d:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  802774:	00 00 00 
  802777:	ff d0                	callq  *%rax
  802779:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80277c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802780:	79 05                	jns    802787 <close+0x31>
		return r;
  802782:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802785:	eb 18                	jmp    80279f <close+0x49>
	else
		return fd_close(fd, 1);
  802787:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80278b:	be 01 00 00 00       	mov    $0x1,%esi
  802790:	48 89 c7             	mov    %rax,%rdi
  802793:	48 b8 d6 25 80 00 00 	movabs $0x8025d6,%rax
  80279a:	00 00 00 
  80279d:	ff d0                	callq  *%rax
}
  80279f:	c9                   	leaveq 
  8027a0:	c3                   	retq   

00000000008027a1 <close_all>:

void
close_all(void)
{
  8027a1:	55                   	push   %rbp
  8027a2:	48 89 e5             	mov    %rsp,%rbp
  8027a5:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8027a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027b0:	eb 15                	jmp    8027c7 <close_all+0x26>
		close(i);
  8027b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b5:	89 c7                	mov    %eax,%edi
  8027b7:	48 b8 56 27 80 00 00 	movabs $0x802756,%rax
  8027be:	00 00 00 
  8027c1:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8027c3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027c7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027cb:	7e e5                	jle    8027b2 <close_all+0x11>
		close(i);
}
  8027cd:	c9                   	leaveq 
  8027ce:	c3                   	retq   

00000000008027cf <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8027cf:	55                   	push   %rbp
  8027d0:	48 89 e5             	mov    %rsp,%rbp
  8027d3:	48 83 ec 40          	sub    $0x40,%rsp
  8027d7:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8027da:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8027dd:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8027e1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8027e4:	48 89 d6             	mov    %rdx,%rsi
  8027e7:	89 c7                	mov    %eax,%edi
  8027e9:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  8027f0:	00 00 00 
  8027f3:	ff d0                	callq  *%rax
  8027f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027fc:	79 08                	jns    802806 <dup+0x37>
		return r;
  8027fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802801:	e9 70 01 00 00       	jmpq   802976 <dup+0x1a7>
	close(newfdnum);
  802806:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802809:	89 c7                	mov    %eax,%edi
  80280b:	48 b8 56 27 80 00 00 	movabs $0x802756,%rax
  802812:	00 00 00 
  802815:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802817:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80281a:	48 98                	cltq   
  80281c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802822:	48 c1 e0 0c          	shl    $0xc,%rax
  802826:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80282a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80282e:	48 89 c7             	mov    %rax,%rdi
  802831:	48 b8 83 24 80 00 00 	movabs $0x802483,%rax
  802838:	00 00 00 
  80283b:	ff d0                	callq  *%rax
  80283d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802841:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802845:	48 89 c7             	mov    %rax,%rdi
  802848:	48 b8 83 24 80 00 00 	movabs $0x802483,%rax
  80284f:	00 00 00 
  802852:	ff d0                	callq  *%rax
  802854:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802858:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80285c:	48 c1 e8 15          	shr    $0x15,%rax
  802860:	48 89 c2             	mov    %rax,%rdx
  802863:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80286a:	01 00 00 
  80286d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802871:	83 e0 01             	and    $0x1,%eax
  802874:	48 85 c0             	test   %rax,%rax
  802877:	74 73                	je     8028ec <dup+0x11d>
  802879:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80287d:	48 c1 e8 0c          	shr    $0xc,%rax
  802881:	48 89 c2             	mov    %rax,%rdx
  802884:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80288b:	01 00 00 
  80288e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802892:	83 e0 01             	and    $0x1,%eax
  802895:	48 85 c0             	test   %rax,%rax
  802898:	74 52                	je     8028ec <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80289a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80289e:	48 c1 e8 0c          	shr    $0xc,%rax
  8028a2:	48 89 c2             	mov    %rax,%rdx
  8028a5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028ac:	01 00 00 
  8028af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028b3:	25 07 0e 00 00       	and    $0xe07,%eax
  8028b8:	89 c1                	mov    %eax,%ecx
  8028ba:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c2:	41 89 c8             	mov    %ecx,%r8d
  8028c5:	48 89 d1             	mov    %rdx,%rcx
  8028c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8028cd:	48 89 c6             	mov    %rax,%rsi
  8028d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8028d5:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  8028dc:	00 00 00 
  8028df:	ff d0                	callq  *%rax
  8028e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e8:	79 02                	jns    8028ec <dup+0x11d>
			goto err;
  8028ea:	eb 57                	jmp    802943 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8028ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028f0:	48 c1 e8 0c          	shr    $0xc,%rax
  8028f4:	48 89 c2             	mov    %rax,%rdx
  8028f7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028fe:	01 00 00 
  802901:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802905:	25 07 0e 00 00       	and    $0xe07,%eax
  80290a:	89 c1                	mov    %eax,%ecx
  80290c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802910:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802914:	41 89 c8             	mov    %ecx,%r8d
  802917:	48 89 d1             	mov    %rdx,%rcx
  80291a:	ba 00 00 00 00       	mov    $0x0,%edx
  80291f:	48 89 c6             	mov    %rax,%rsi
  802922:	bf 00 00 00 00       	mov    $0x0,%edi
  802927:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  80292e:	00 00 00 
  802931:	ff d0                	callq  *%rax
  802933:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802936:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80293a:	79 02                	jns    80293e <dup+0x16f>
		goto err;
  80293c:	eb 05                	jmp    802943 <dup+0x174>

	return newfdnum;
  80293e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802941:	eb 33                	jmp    802976 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802943:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802947:	48 89 c6             	mov    %rax,%rsi
  80294a:	bf 00 00 00 00       	mov    $0x0,%edi
  80294f:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  802956:	00 00 00 
  802959:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80295b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80295f:	48 89 c6             	mov    %rax,%rsi
  802962:	bf 00 00 00 00       	mov    $0x0,%edi
  802967:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  80296e:	00 00 00 
  802971:	ff d0                	callq  *%rax
	return r;
  802973:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802976:	c9                   	leaveq 
  802977:	c3                   	retq   

0000000000802978 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802978:	55                   	push   %rbp
  802979:	48 89 e5             	mov    %rsp,%rbp
  80297c:	48 83 ec 40          	sub    $0x40,%rsp
  802980:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802983:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802987:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80298b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80298f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802992:	48 89 d6             	mov    %rdx,%rsi
  802995:	89 c7                	mov    %eax,%edi
  802997:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  80299e:	00 00 00 
  8029a1:	ff d0                	callq  *%rax
  8029a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029aa:	78 24                	js     8029d0 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b0:	8b 00                	mov    (%rax),%eax
  8029b2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029b6:	48 89 d6             	mov    %rdx,%rsi
  8029b9:	89 c7                	mov    %eax,%edi
  8029bb:	48 b8 9f 26 80 00 00 	movabs $0x80269f,%rax
  8029c2:	00 00 00 
  8029c5:	ff d0                	callq  *%rax
  8029c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ce:	79 05                	jns    8029d5 <read+0x5d>
		return r;
  8029d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d3:	eb 76                	jmp    802a4b <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8029d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d9:	8b 40 08             	mov    0x8(%rax),%eax
  8029dc:	83 e0 03             	and    $0x3,%eax
  8029df:	83 f8 01             	cmp    $0x1,%eax
  8029e2:	75 3a                	jne    802a1e <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8029e4:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8029eb:	00 00 00 
  8029ee:	48 8b 00             	mov    (%rax),%rax
  8029f1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029f7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029fa:	89 c6                	mov    %eax,%esi
  8029fc:	48 bf 37 5d 80 00 00 	movabs $0x805d37,%rdi
  802a03:	00 00 00 
  802a06:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0b:	48 b9 87 05 80 00 00 	movabs $0x800587,%rcx
  802a12:	00 00 00 
  802a15:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a17:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a1c:	eb 2d                	jmp    802a4b <read+0xd3>
	}
	if (!dev->dev_read)
  802a1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a22:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a26:	48 85 c0             	test   %rax,%rax
  802a29:	75 07                	jne    802a32 <read+0xba>
		return -E_NOT_SUPP;
  802a2b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a30:	eb 19                	jmp    802a4b <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802a32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a36:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a3a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a3e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a42:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a46:	48 89 cf             	mov    %rcx,%rdi
  802a49:	ff d0                	callq  *%rax
}
  802a4b:	c9                   	leaveq 
  802a4c:	c3                   	retq   

0000000000802a4d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802a4d:	55                   	push   %rbp
  802a4e:	48 89 e5             	mov    %rsp,%rbp
  802a51:	48 83 ec 30          	sub    $0x30,%rsp
  802a55:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a58:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a5c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a67:	eb 49                	jmp    802ab2 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802a69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a6c:	48 98                	cltq   
  802a6e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a72:	48 29 c2             	sub    %rax,%rdx
  802a75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a78:	48 63 c8             	movslq %eax,%rcx
  802a7b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a7f:	48 01 c1             	add    %rax,%rcx
  802a82:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a85:	48 89 ce             	mov    %rcx,%rsi
  802a88:	89 c7                	mov    %eax,%edi
  802a8a:	48 b8 78 29 80 00 00 	movabs $0x802978,%rax
  802a91:	00 00 00 
  802a94:	ff d0                	callq  *%rax
  802a96:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802a99:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a9d:	79 05                	jns    802aa4 <readn+0x57>
			return m;
  802a9f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802aa2:	eb 1c                	jmp    802ac0 <readn+0x73>
		if (m == 0)
  802aa4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802aa8:	75 02                	jne    802aac <readn+0x5f>
			break;
  802aaa:	eb 11                	jmp    802abd <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802aac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802aaf:	01 45 fc             	add    %eax,-0x4(%rbp)
  802ab2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab5:	48 98                	cltq   
  802ab7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802abb:	72 ac                	jb     802a69 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802abd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ac0:	c9                   	leaveq 
  802ac1:	c3                   	retq   

0000000000802ac2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802ac2:	55                   	push   %rbp
  802ac3:	48 89 e5             	mov    %rsp,%rbp
  802ac6:	48 83 ec 40          	sub    $0x40,%rsp
  802aca:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802acd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ad1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ad5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ad9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802adc:	48 89 d6             	mov    %rdx,%rsi
  802adf:	89 c7                	mov    %eax,%edi
  802ae1:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  802ae8:	00 00 00 
  802aeb:	ff d0                	callq  *%rax
  802aed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af4:	78 24                	js     802b1a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802af6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802afa:	8b 00                	mov    (%rax),%eax
  802afc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b00:	48 89 d6             	mov    %rdx,%rsi
  802b03:	89 c7                	mov    %eax,%edi
  802b05:	48 b8 9f 26 80 00 00 	movabs $0x80269f,%rax
  802b0c:	00 00 00 
  802b0f:	ff d0                	callq  *%rax
  802b11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b18:	79 05                	jns    802b1f <write+0x5d>
		return r;
  802b1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1d:	eb 75                	jmp    802b94 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b23:	8b 40 08             	mov    0x8(%rax),%eax
  802b26:	83 e0 03             	and    $0x3,%eax
  802b29:	85 c0                	test   %eax,%eax
  802b2b:	75 3a                	jne    802b67 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802b2d:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802b34:	00 00 00 
  802b37:	48 8b 00             	mov    (%rax),%rax
  802b3a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b40:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b43:	89 c6                	mov    %eax,%esi
  802b45:	48 bf 53 5d 80 00 00 	movabs $0x805d53,%rdi
  802b4c:	00 00 00 
  802b4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b54:	48 b9 87 05 80 00 00 	movabs $0x800587,%rcx
  802b5b:	00 00 00 
  802b5e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b65:	eb 2d                	jmp    802b94 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802b67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b6b:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b6f:	48 85 c0             	test   %rax,%rax
  802b72:	75 07                	jne    802b7b <write+0xb9>
		return -E_NOT_SUPP;
  802b74:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b79:	eb 19                	jmp    802b94 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802b7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b7f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b83:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b87:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b8b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b8f:	48 89 cf             	mov    %rcx,%rdi
  802b92:	ff d0                	callq  *%rax
}
  802b94:	c9                   	leaveq 
  802b95:	c3                   	retq   

0000000000802b96 <seek>:

int
seek(int fdnum, off_t offset)
{
  802b96:	55                   	push   %rbp
  802b97:	48 89 e5             	mov    %rsp,%rbp
  802b9a:	48 83 ec 18          	sub    $0x18,%rsp
  802b9e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ba1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ba4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ba8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bab:	48 89 d6             	mov    %rdx,%rsi
  802bae:	89 c7                	mov    %eax,%edi
  802bb0:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  802bb7:	00 00 00 
  802bba:	ff d0                	callq  *%rax
  802bbc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bbf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc3:	79 05                	jns    802bca <seek+0x34>
		return r;
  802bc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc8:	eb 0f                	jmp    802bd9 <seek+0x43>
	fd->fd_offset = offset;
  802bca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bce:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802bd1:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802bd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bd9:	c9                   	leaveq 
  802bda:	c3                   	retq   

0000000000802bdb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802bdb:	55                   	push   %rbp
  802bdc:	48 89 e5             	mov    %rsp,%rbp
  802bdf:	48 83 ec 30          	sub    $0x30,%rsp
  802be3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802be6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802be9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bed:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bf0:	48 89 d6             	mov    %rdx,%rsi
  802bf3:	89 c7                	mov    %eax,%edi
  802bf5:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  802bfc:	00 00 00 
  802bff:	ff d0                	callq  *%rax
  802c01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c08:	78 24                	js     802c2e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c0e:	8b 00                	mov    (%rax),%eax
  802c10:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c14:	48 89 d6             	mov    %rdx,%rsi
  802c17:	89 c7                	mov    %eax,%edi
  802c19:	48 b8 9f 26 80 00 00 	movabs $0x80269f,%rax
  802c20:	00 00 00 
  802c23:	ff d0                	callq  *%rax
  802c25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c2c:	79 05                	jns    802c33 <ftruncate+0x58>
		return r;
  802c2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c31:	eb 72                	jmp    802ca5 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c37:	8b 40 08             	mov    0x8(%rax),%eax
  802c3a:	83 e0 03             	and    $0x3,%eax
  802c3d:	85 c0                	test   %eax,%eax
  802c3f:	75 3a                	jne    802c7b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802c41:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802c48:	00 00 00 
  802c4b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c4e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c54:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c57:	89 c6                	mov    %eax,%esi
  802c59:	48 bf 70 5d 80 00 00 	movabs $0x805d70,%rdi
  802c60:	00 00 00 
  802c63:	b8 00 00 00 00       	mov    $0x0,%eax
  802c68:	48 b9 87 05 80 00 00 	movabs $0x800587,%rcx
  802c6f:	00 00 00 
  802c72:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802c74:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c79:	eb 2a                	jmp    802ca5 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802c7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c7f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c83:	48 85 c0             	test   %rax,%rax
  802c86:	75 07                	jne    802c8f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802c88:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c8d:	eb 16                	jmp    802ca5 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802c8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c93:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c97:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c9b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802c9e:	89 ce                	mov    %ecx,%esi
  802ca0:	48 89 d7             	mov    %rdx,%rdi
  802ca3:	ff d0                	callq  *%rax
}
  802ca5:	c9                   	leaveq 
  802ca6:	c3                   	retq   

0000000000802ca7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802ca7:	55                   	push   %rbp
  802ca8:	48 89 e5             	mov    %rsp,%rbp
  802cab:	48 83 ec 30          	sub    $0x30,%rsp
  802caf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cb2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cb6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cba:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cbd:	48 89 d6             	mov    %rdx,%rsi
  802cc0:	89 c7                	mov    %eax,%edi
  802cc2:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  802cc9:	00 00 00 
  802ccc:	ff d0                	callq  *%rax
  802cce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cd5:	78 24                	js     802cfb <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802cd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cdb:	8b 00                	mov    (%rax),%eax
  802cdd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ce1:	48 89 d6             	mov    %rdx,%rsi
  802ce4:	89 c7                	mov    %eax,%edi
  802ce6:	48 b8 9f 26 80 00 00 	movabs $0x80269f,%rax
  802ced:	00 00 00 
  802cf0:	ff d0                	callq  *%rax
  802cf2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cf5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf9:	79 05                	jns    802d00 <fstat+0x59>
		return r;
  802cfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cfe:	eb 5e                	jmp    802d5e <fstat+0xb7>
	if (!dev->dev_stat)
  802d00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d04:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d08:	48 85 c0             	test   %rax,%rax
  802d0b:	75 07                	jne    802d14 <fstat+0x6d>
		return -E_NOT_SUPP;
  802d0d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d12:	eb 4a                	jmp    802d5e <fstat+0xb7>
	stat->st_name[0] = 0;
  802d14:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d18:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d1b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d1f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d26:	00 00 00 
	stat->st_isdir = 0;
  802d29:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d2d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d34:	00 00 00 
	stat->st_dev = dev;
  802d37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d3b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d3f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d4a:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d4e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d52:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d56:	48 89 ce             	mov    %rcx,%rsi
  802d59:	48 89 d7             	mov    %rdx,%rdi
  802d5c:	ff d0                	callq  *%rax
}
  802d5e:	c9                   	leaveq 
  802d5f:	c3                   	retq   

0000000000802d60 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802d60:	55                   	push   %rbp
  802d61:	48 89 e5             	mov    %rsp,%rbp
  802d64:	48 83 ec 20          	sub    $0x20,%rsp
  802d68:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d6c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802d70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d74:	be 00 00 00 00       	mov    $0x0,%esi
  802d79:	48 89 c7             	mov    %rax,%rdi
  802d7c:	48 b8 4e 2e 80 00 00 	movabs $0x802e4e,%rax
  802d83:	00 00 00 
  802d86:	ff d0                	callq  *%rax
  802d88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8f:	79 05                	jns    802d96 <stat+0x36>
		return fd;
  802d91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d94:	eb 2f                	jmp    802dc5 <stat+0x65>
	r = fstat(fd, stat);
  802d96:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d9d:	48 89 d6             	mov    %rdx,%rsi
  802da0:	89 c7                	mov    %eax,%edi
  802da2:	48 b8 a7 2c 80 00 00 	movabs $0x802ca7,%rax
  802da9:	00 00 00 
  802dac:	ff d0                	callq  *%rax
  802dae:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802db1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db4:	89 c7                	mov    %eax,%edi
  802db6:	48 b8 56 27 80 00 00 	movabs $0x802756,%rax
  802dbd:	00 00 00 
  802dc0:	ff d0                	callq  *%rax
	return r;
  802dc2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802dc5:	c9                   	leaveq 
  802dc6:	c3                   	retq   

0000000000802dc7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802dc7:	55                   	push   %rbp
  802dc8:	48 89 e5             	mov    %rsp,%rbp
  802dcb:	48 83 ec 10          	sub    $0x10,%rsp
  802dcf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802dd2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802dd6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ddd:	00 00 00 
  802de0:	8b 00                	mov    (%rax),%eax
  802de2:	85 c0                	test   %eax,%eax
  802de4:	75 1d                	jne    802e03 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802de6:	bf 01 00 00 00       	mov    $0x1,%edi
  802deb:	48 b8 07 55 80 00 00 	movabs $0x805507,%rax
  802df2:	00 00 00 
  802df5:	ff d0                	callq  *%rax
  802df7:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802dfe:	00 00 00 
  802e01:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e03:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e0a:	00 00 00 
  802e0d:	8b 00                	mov    (%rax),%eax
  802e0f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e12:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e17:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802e1e:	00 00 00 
  802e21:	89 c7                	mov    %eax,%edi
  802e23:	48 b8 fb 52 80 00 00 	movabs $0x8052fb,%rax
  802e2a:	00 00 00 
  802e2d:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e33:	ba 00 00 00 00       	mov    $0x0,%edx
  802e38:	48 89 c6             	mov    %rax,%rsi
  802e3b:	bf 00 00 00 00       	mov    $0x0,%edi
  802e40:	48 b8 3a 52 80 00 00 	movabs $0x80523a,%rax
  802e47:	00 00 00 
  802e4a:	ff d0                	callq  *%rax
}
  802e4c:	c9                   	leaveq 
  802e4d:	c3                   	retq   

0000000000802e4e <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802e4e:	55                   	push   %rbp
  802e4f:	48 89 e5             	mov    %rsp,%rbp
  802e52:	48 83 ec 20          	sub    $0x20,%rsp
  802e56:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e5a:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802e5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e61:	48 89 c7             	mov    %rax,%rdi
  802e64:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  802e6b:	00 00 00 
  802e6e:	ff d0                	callq  *%rax
  802e70:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e75:	7e 0a                	jle    802e81 <open+0x33>
		return -E_BAD_PATH;
  802e77:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e7c:	e9 a5 00 00 00       	jmpq   802f26 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802e81:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802e85:	48 89 c7             	mov    %rax,%rdi
  802e88:	48 b8 ae 24 80 00 00 	movabs $0x8024ae,%rax
  802e8f:	00 00 00 
  802e92:	ff d0                	callq  *%rax
  802e94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e9b:	79 08                	jns    802ea5 <open+0x57>
		return r;
  802e9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea0:	e9 81 00 00 00       	jmpq   802f26 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802ea5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea9:	48 89 c6             	mov    %rax,%rsi
  802eac:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  802eb3:	00 00 00 
  802eb6:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  802ebd:	00 00 00 
  802ec0:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802ec2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ec9:	00 00 00 
  802ecc:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802ecf:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802ed5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed9:	48 89 c6             	mov    %rax,%rsi
  802edc:	bf 01 00 00 00       	mov    $0x1,%edi
  802ee1:	48 b8 c7 2d 80 00 00 	movabs $0x802dc7,%rax
  802ee8:	00 00 00 
  802eeb:	ff d0                	callq  *%rax
  802eed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ef0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ef4:	79 1d                	jns    802f13 <open+0xc5>
		fd_close(fd, 0);
  802ef6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802efa:	be 00 00 00 00       	mov    $0x0,%esi
  802eff:	48 89 c7             	mov    %rax,%rdi
  802f02:	48 b8 d6 25 80 00 00 	movabs $0x8025d6,%rax
  802f09:	00 00 00 
  802f0c:	ff d0                	callq  *%rax
		return r;
  802f0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f11:	eb 13                	jmp    802f26 <open+0xd8>
	}

	return fd2num(fd);
  802f13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f17:	48 89 c7             	mov    %rax,%rdi
  802f1a:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  802f21:	00 00 00 
  802f24:	ff d0                	callq  *%rax

}
  802f26:	c9                   	leaveq 
  802f27:	c3                   	retq   

0000000000802f28 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f28:	55                   	push   %rbp
  802f29:	48 89 e5             	mov    %rsp,%rbp
  802f2c:	48 83 ec 10          	sub    $0x10,%rsp
  802f30:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f38:	8b 50 0c             	mov    0xc(%rax),%edx
  802f3b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f42:	00 00 00 
  802f45:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802f47:	be 00 00 00 00       	mov    $0x0,%esi
  802f4c:	bf 06 00 00 00       	mov    $0x6,%edi
  802f51:	48 b8 c7 2d 80 00 00 	movabs $0x802dc7,%rax
  802f58:	00 00 00 
  802f5b:	ff d0                	callq  *%rax
}
  802f5d:	c9                   	leaveq 
  802f5e:	c3                   	retq   

0000000000802f5f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802f5f:	55                   	push   %rbp
  802f60:	48 89 e5             	mov    %rsp,%rbp
  802f63:	48 83 ec 30          	sub    $0x30,%rsp
  802f67:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f6b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f6f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802f73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f77:	8b 50 0c             	mov    0xc(%rax),%edx
  802f7a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f81:	00 00 00 
  802f84:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802f86:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f8d:	00 00 00 
  802f90:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f94:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802f98:	be 00 00 00 00       	mov    $0x0,%esi
  802f9d:	bf 03 00 00 00       	mov    $0x3,%edi
  802fa2:	48 b8 c7 2d 80 00 00 	movabs $0x802dc7,%rax
  802fa9:	00 00 00 
  802fac:	ff d0                	callq  *%rax
  802fae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fb1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fb5:	79 08                	jns    802fbf <devfile_read+0x60>
		return r;
  802fb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fba:	e9 a4 00 00 00       	jmpq   803063 <devfile_read+0x104>
	assert(r <= n);
  802fbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc2:	48 98                	cltq   
  802fc4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802fc8:	76 35                	jbe    802fff <devfile_read+0xa0>
  802fca:	48 b9 96 5d 80 00 00 	movabs $0x805d96,%rcx
  802fd1:	00 00 00 
  802fd4:	48 ba 9d 5d 80 00 00 	movabs $0x805d9d,%rdx
  802fdb:	00 00 00 
  802fde:	be 86 00 00 00       	mov    $0x86,%esi
  802fe3:	48 bf b2 5d 80 00 00 	movabs $0x805db2,%rdi
  802fea:	00 00 00 
  802fed:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff2:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  802ff9:	00 00 00 
  802ffc:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802fff:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  803006:	7e 35                	jle    80303d <devfile_read+0xde>
  803008:	48 b9 bd 5d 80 00 00 	movabs $0x805dbd,%rcx
  80300f:	00 00 00 
  803012:	48 ba 9d 5d 80 00 00 	movabs $0x805d9d,%rdx
  803019:	00 00 00 
  80301c:	be 87 00 00 00       	mov    $0x87,%esi
  803021:	48 bf b2 5d 80 00 00 	movabs $0x805db2,%rdi
  803028:	00 00 00 
  80302b:	b8 00 00 00 00       	mov    $0x0,%eax
  803030:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  803037:	00 00 00 
  80303a:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  80303d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803040:	48 63 d0             	movslq %eax,%rdx
  803043:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803047:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80304e:	00 00 00 
  803051:	48 89 c7             	mov    %rax,%rdi
  803054:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  80305b:	00 00 00 
  80305e:	ff d0                	callq  *%rax
	return r;
  803060:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  803063:	c9                   	leaveq 
  803064:	c3                   	retq   

0000000000803065 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803065:	55                   	push   %rbp
  803066:	48 89 e5             	mov    %rsp,%rbp
  803069:	48 83 ec 40          	sub    $0x40,%rsp
  80306d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803071:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803075:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  803079:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80307d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803081:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  803088:	00 
  803089:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80308d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803091:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  803096:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80309a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80309e:	8b 50 0c             	mov    0xc(%rax),%edx
  8030a1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030a8:	00 00 00 
  8030ab:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8030ad:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030b4:	00 00 00 
  8030b7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8030bb:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8030bf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8030c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030c7:	48 89 c6             	mov    %rax,%rsi
  8030ca:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  8030d1:	00 00 00 
  8030d4:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  8030db:	00 00 00 
  8030de:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8030e0:	be 00 00 00 00       	mov    $0x0,%esi
  8030e5:	bf 04 00 00 00       	mov    $0x4,%edi
  8030ea:	48 b8 c7 2d 80 00 00 	movabs $0x802dc7,%rax
  8030f1:	00 00 00 
  8030f4:	ff d0                	callq  *%rax
  8030f6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030fd:	79 05                	jns    803104 <devfile_write+0x9f>
		return r;
  8030ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803102:	eb 43                	jmp    803147 <devfile_write+0xe2>
	assert(r <= n);
  803104:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803107:	48 98                	cltq   
  803109:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80310d:	76 35                	jbe    803144 <devfile_write+0xdf>
  80310f:	48 b9 96 5d 80 00 00 	movabs $0x805d96,%rcx
  803116:	00 00 00 
  803119:	48 ba 9d 5d 80 00 00 	movabs $0x805d9d,%rdx
  803120:	00 00 00 
  803123:	be a2 00 00 00       	mov    $0xa2,%esi
  803128:	48 bf b2 5d 80 00 00 	movabs $0x805db2,%rdi
  80312f:	00 00 00 
  803132:	b8 00 00 00 00       	mov    $0x0,%eax
  803137:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  80313e:	00 00 00 
  803141:	41 ff d0             	callq  *%r8
	return r;
  803144:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  803147:	c9                   	leaveq 
  803148:	c3                   	retq   

0000000000803149 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803149:	55                   	push   %rbp
  80314a:	48 89 e5             	mov    %rsp,%rbp
  80314d:	48 83 ec 20          	sub    $0x20,%rsp
  803151:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803155:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803159:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80315d:	8b 50 0c             	mov    0xc(%rax),%edx
  803160:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803167:	00 00 00 
  80316a:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80316c:	be 00 00 00 00       	mov    $0x0,%esi
  803171:	bf 05 00 00 00       	mov    $0x5,%edi
  803176:	48 b8 c7 2d 80 00 00 	movabs $0x802dc7,%rax
  80317d:	00 00 00 
  803180:	ff d0                	callq  *%rax
  803182:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803185:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803189:	79 05                	jns    803190 <devfile_stat+0x47>
		return r;
  80318b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318e:	eb 56                	jmp    8031e6 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803190:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803194:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80319b:	00 00 00 
  80319e:	48 89 c7             	mov    %rax,%rdi
  8031a1:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  8031a8:	00 00 00 
  8031ab:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8031ad:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031b4:	00 00 00 
  8031b7:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8031bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031c1:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8031c7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031ce:	00 00 00 
  8031d1:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8031d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031db:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8031e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031e6:	c9                   	leaveq 
  8031e7:	c3                   	retq   

00000000008031e8 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8031e8:	55                   	push   %rbp
  8031e9:	48 89 e5             	mov    %rsp,%rbp
  8031ec:	48 83 ec 10          	sub    $0x10,%rsp
  8031f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031f4:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8031f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031fb:	8b 50 0c             	mov    0xc(%rax),%edx
  8031fe:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803205:	00 00 00 
  803208:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80320a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803211:	00 00 00 
  803214:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803217:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80321a:	be 00 00 00 00       	mov    $0x0,%esi
  80321f:	bf 02 00 00 00       	mov    $0x2,%edi
  803224:	48 b8 c7 2d 80 00 00 	movabs $0x802dc7,%rax
  80322b:	00 00 00 
  80322e:	ff d0                	callq  *%rax
}
  803230:	c9                   	leaveq 
  803231:	c3                   	retq   

0000000000803232 <remove>:

// Delete a file
int
remove(const char *path)
{
  803232:	55                   	push   %rbp
  803233:	48 89 e5             	mov    %rsp,%rbp
  803236:	48 83 ec 10          	sub    $0x10,%rsp
  80323a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80323e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803242:	48 89 c7             	mov    %rax,%rdi
  803245:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  80324c:	00 00 00 
  80324f:	ff d0                	callq  *%rax
  803251:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803256:	7e 07                	jle    80325f <remove+0x2d>
		return -E_BAD_PATH;
  803258:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80325d:	eb 33                	jmp    803292 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80325f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803263:	48 89 c6             	mov    %rax,%rsi
  803266:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  80326d:	00 00 00 
  803270:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  803277:	00 00 00 
  80327a:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80327c:	be 00 00 00 00       	mov    $0x0,%esi
  803281:	bf 07 00 00 00       	mov    $0x7,%edi
  803286:	48 b8 c7 2d 80 00 00 	movabs $0x802dc7,%rax
  80328d:	00 00 00 
  803290:	ff d0                	callq  *%rax
}
  803292:	c9                   	leaveq 
  803293:	c3                   	retq   

0000000000803294 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803294:	55                   	push   %rbp
  803295:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803298:	be 00 00 00 00       	mov    $0x0,%esi
  80329d:	bf 08 00 00 00       	mov    $0x8,%edi
  8032a2:	48 b8 c7 2d 80 00 00 	movabs $0x802dc7,%rax
  8032a9:	00 00 00 
  8032ac:	ff d0                	callq  *%rax
}
  8032ae:	5d                   	pop    %rbp
  8032af:	c3                   	retq   

00000000008032b0 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8032b0:	55                   	push   %rbp
  8032b1:	48 89 e5             	mov    %rsp,%rbp
  8032b4:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8032bb:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8032c2:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8032c9:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8032d0:	be 00 00 00 00       	mov    $0x0,%esi
  8032d5:	48 89 c7             	mov    %rax,%rdi
  8032d8:	48 b8 4e 2e 80 00 00 	movabs $0x802e4e,%rax
  8032df:	00 00 00 
  8032e2:	ff d0                	callq  *%rax
  8032e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8032e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032eb:	79 28                	jns    803315 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8032ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f0:	89 c6                	mov    %eax,%esi
  8032f2:	48 bf c9 5d 80 00 00 	movabs $0x805dc9,%rdi
  8032f9:	00 00 00 
  8032fc:	b8 00 00 00 00       	mov    $0x0,%eax
  803301:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  803308:	00 00 00 
  80330b:	ff d2                	callq  *%rdx
		return fd_src;
  80330d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803310:	e9 74 01 00 00       	jmpq   803489 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803315:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80331c:	be 01 01 00 00       	mov    $0x101,%esi
  803321:	48 89 c7             	mov    %rax,%rdi
  803324:	48 b8 4e 2e 80 00 00 	movabs $0x802e4e,%rax
  80332b:	00 00 00 
  80332e:	ff d0                	callq  *%rax
  803330:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803333:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803337:	79 39                	jns    803372 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803339:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80333c:	89 c6                	mov    %eax,%esi
  80333e:	48 bf df 5d 80 00 00 	movabs $0x805ddf,%rdi
  803345:	00 00 00 
  803348:	b8 00 00 00 00       	mov    $0x0,%eax
  80334d:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  803354:	00 00 00 
  803357:	ff d2                	callq  *%rdx
		close(fd_src);
  803359:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80335c:	89 c7                	mov    %eax,%edi
  80335e:	48 b8 56 27 80 00 00 	movabs $0x802756,%rax
  803365:	00 00 00 
  803368:	ff d0                	callq  *%rax
		return fd_dest;
  80336a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80336d:	e9 17 01 00 00       	jmpq   803489 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803372:	eb 74                	jmp    8033e8 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803374:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803377:	48 63 d0             	movslq %eax,%rdx
  80337a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803381:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803384:	48 89 ce             	mov    %rcx,%rsi
  803387:	89 c7                	mov    %eax,%edi
  803389:	48 b8 c2 2a 80 00 00 	movabs $0x802ac2,%rax
  803390:	00 00 00 
  803393:	ff d0                	callq  *%rax
  803395:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803398:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80339c:	79 4a                	jns    8033e8 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80339e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033a1:	89 c6                	mov    %eax,%esi
  8033a3:	48 bf f9 5d 80 00 00 	movabs $0x805df9,%rdi
  8033aa:	00 00 00 
  8033ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b2:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  8033b9:	00 00 00 
  8033bc:	ff d2                	callq  *%rdx
			close(fd_src);
  8033be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033c1:	89 c7                	mov    %eax,%edi
  8033c3:	48 b8 56 27 80 00 00 	movabs $0x802756,%rax
  8033ca:	00 00 00 
  8033cd:	ff d0                	callq  *%rax
			close(fd_dest);
  8033cf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033d2:	89 c7                	mov    %eax,%edi
  8033d4:	48 b8 56 27 80 00 00 	movabs $0x802756,%rax
  8033db:	00 00 00 
  8033de:	ff d0                	callq  *%rax
			return write_size;
  8033e0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033e3:	e9 a1 00 00 00       	jmpq   803489 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8033e8:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8033ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f2:	ba 00 02 00 00       	mov    $0x200,%edx
  8033f7:	48 89 ce             	mov    %rcx,%rsi
  8033fa:	89 c7                	mov    %eax,%edi
  8033fc:	48 b8 78 29 80 00 00 	movabs $0x802978,%rax
  803403:	00 00 00 
  803406:	ff d0                	callq  *%rax
  803408:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80340b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80340f:	0f 8f 5f ff ff ff    	jg     803374 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803415:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803419:	79 47                	jns    803462 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80341b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80341e:	89 c6                	mov    %eax,%esi
  803420:	48 bf 0c 5e 80 00 00 	movabs $0x805e0c,%rdi
  803427:	00 00 00 
  80342a:	b8 00 00 00 00       	mov    $0x0,%eax
  80342f:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  803436:	00 00 00 
  803439:	ff d2                	callq  *%rdx
		close(fd_src);
  80343b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80343e:	89 c7                	mov    %eax,%edi
  803440:	48 b8 56 27 80 00 00 	movabs $0x802756,%rax
  803447:	00 00 00 
  80344a:	ff d0                	callq  *%rax
		close(fd_dest);
  80344c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80344f:	89 c7                	mov    %eax,%edi
  803451:	48 b8 56 27 80 00 00 	movabs $0x802756,%rax
  803458:	00 00 00 
  80345b:	ff d0                	callq  *%rax
		return read_size;
  80345d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803460:	eb 27                	jmp    803489 <copy+0x1d9>
	}
	close(fd_src);
  803462:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803465:	89 c7                	mov    %eax,%edi
  803467:	48 b8 56 27 80 00 00 	movabs $0x802756,%rax
  80346e:	00 00 00 
  803471:	ff d0                	callq  *%rax
	close(fd_dest);
  803473:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803476:	89 c7                	mov    %eax,%edi
  803478:	48 b8 56 27 80 00 00 	movabs $0x802756,%rax
  80347f:	00 00 00 
  803482:	ff d0                	callq  *%rax
	return 0;
  803484:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803489:	c9                   	leaveq 
  80348a:	c3                   	retq   

000000000080348b <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80348b:	55                   	push   %rbp
  80348c:	48 89 e5             	mov    %rsp,%rbp
  80348f:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  803496:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  80349d:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8034a4:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  8034ab:	be 00 00 00 00       	mov    $0x0,%esi
  8034b0:	48 89 c7             	mov    %rax,%rdi
  8034b3:	48 b8 4e 2e 80 00 00 	movabs $0x802e4e,%rax
  8034ba:	00 00 00 
  8034bd:	ff d0                	callq  *%rax
  8034bf:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8034c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8034c6:	79 08                	jns    8034d0 <spawn+0x45>
		return r;
  8034c8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034cb:	e9 0c 03 00 00       	jmpq   8037dc <spawn+0x351>
	fd = r;
  8034d0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034d3:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  8034d6:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  8034dd:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8034e1:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  8034e8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8034eb:	ba 00 02 00 00       	mov    $0x200,%edx
  8034f0:	48 89 ce             	mov    %rcx,%rsi
  8034f3:	89 c7                	mov    %eax,%edi
  8034f5:	48 b8 4d 2a 80 00 00 	movabs $0x802a4d,%rax
  8034fc:	00 00 00 
  8034ff:	ff d0                	callq  *%rax
  803501:	3d 00 02 00 00       	cmp    $0x200,%eax
  803506:	75 0d                	jne    803515 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  803508:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80350c:	8b 00                	mov    (%rax),%eax
  80350e:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  803513:	74 43                	je     803558 <spawn+0xcd>
		close(fd);
  803515:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803518:	89 c7                	mov    %eax,%edi
  80351a:	48 b8 56 27 80 00 00 	movabs $0x802756,%rax
  803521:	00 00 00 
  803524:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  803526:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80352a:	8b 00                	mov    (%rax),%eax
  80352c:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  803531:	89 c6                	mov    %eax,%esi
  803533:	48 bf 28 5e 80 00 00 	movabs $0x805e28,%rdi
  80353a:	00 00 00 
  80353d:	b8 00 00 00 00       	mov    $0x0,%eax
  803542:	48 b9 87 05 80 00 00 	movabs $0x800587,%rcx
  803549:	00 00 00 
  80354c:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  80354e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803553:	e9 84 02 00 00       	jmpq   8037dc <spawn+0x351>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803558:	b8 07 00 00 00       	mov    $0x7,%eax
  80355d:	cd 30                	int    $0x30
  80355f:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803562:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803565:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803568:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80356c:	79 08                	jns    803576 <spawn+0xeb>
		return r;
  80356e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803571:	e9 66 02 00 00       	jmpq   8037dc <spawn+0x351>
	child = r;
  803576:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803579:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80357c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80357f:	25 ff 03 00 00       	and    $0x3ff,%eax
  803584:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80358b:	00 00 00 
  80358e:	48 98                	cltq   
  803590:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803597:	48 01 d0             	add    %rdx,%rax
  80359a:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8035a1:	48 89 c6             	mov    %rax,%rsi
  8035a4:	b8 18 00 00 00       	mov    $0x18,%eax
  8035a9:	48 89 d7             	mov    %rdx,%rdi
  8035ac:	48 89 c1             	mov    %rax,%rcx
  8035af:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  8035b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035b6:	48 8b 40 18          	mov    0x18(%rax),%rax
  8035ba:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  8035c1:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  8035c8:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  8035cf:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  8035d6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8035d9:	48 89 ce             	mov    %rcx,%rsi
  8035dc:	89 c7                	mov    %eax,%edi
  8035de:	48 b8 46 3a 80 00 00 	movabs $0x803a46,%rax
  8035e5:	00 00 00 
  8035e8:	ff d0                	callq  *%rax
  8035ea:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8035ed:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8035f1:	79 08                	jns    8035fb <spawn+0x170>
		return r;
  8035f3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8035f6:	e9 e1 01 00 00       	jmpq   8037dc <spawn+0x351>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8035fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035ff:	48 8b 40 20          	mov    0x20(%rax),%rax
  803603:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  80360a:	48 01 d0             	add    %rdx,%rax
  80360d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803611:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803618:	e9 a3 00 00 00       	jmpq   8036c0 <spawn+0x235>
		if (ph->p_type != ELF_PROG_LOAD)
  80361d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803621:	8b 00                	mov    (%rax),%eax
  803623:	83 f8 01             	cmp    $0x1,%eax
  803626:	74 05                	je     80362d <spawn+0x1a2>
			continue;
  803628:	e9 8a 00 00 00       	jmpq   8036b7 <spawn+0x22c>
		perm = PTE_P | PTE_U;
  80362d:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803634:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803638:	8b 40 04             	mov    0x4(%rax),%eax
  80363b:	83 e0 02             	and    $0x2,%eax
  80363e:	85 c0                	test   %eax,%eax
  803640:	74 04                	je     803646 <spawn+0x1bb>
			perm |= PTE_W;
  803642:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803646:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80364a:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80364e:	41 89 c1             	mov    %eax,%r9d
  803651:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803655:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803659:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80365d:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803661:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803665:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803669:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80366c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80366f:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803672:	89 3c 24             	mov    %edi,(%rsp)
  803675:	89 c7                	mov    %eax,%edi
  803677:	48 b8 ef 3c 80 00 00 	movabs $0x803cef,%rax
  80367e:	00 00 00 
  803681:	ff d0                	callq  *%rax
  803683:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803686:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80368a:	79 2b                	jns    8036b7 <spawn+0x22c>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  80368c:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  80368d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803690:	89 c7                	mov    %eax,%edi
  803692:	48 b8 ab 19 80 00 00 	movabs $0x8019ab,%rax
  803699:	00 00 00 
  80369c:	ff d0                	callq  *%rax
	close(fd);
  80369e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8036a1:	89 c7                	mov    %eax,%edi
  8036a3:	48 b8 56 27 80 00 00 	movabs $0x802756,%rax
  8036aa:	00 00 00 
  8036ad:	ff d0                	callq  *%rax
	return r;
  8036af:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8036b2:	e9 25 01 00 00       	jmpq   8037dc <spawn+0x351>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8036b7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8036bb:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  8036c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036c4:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  8036c8:	0f b7 c0             	movzwl %ax,%eax
  8036cb:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8036ce:	0f 8f 49 ff ff ff    	jg     80361d <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8036d4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8036d7:	89 c7                	mov    %eax,%edi
  8036d9:	48 b8 56 27 80 00 00 	movabs $0x802756,%rax
  8036e0:	00 00 00 
  8036e3:	ff d0                	callq  *%rax
	fd = -1;
  8036e5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)


	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8036ec:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8036ef:	89 c7                	mov    %eax,%edi
  8036f1:	48 b8 db 3e 80 00 00 	movabs $0x803edb,%rax
  8036f8:	00 00 00 
  8036fb:	ff d0                	callq  *%rax
  8036fd:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803700:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803704:	79 30                	jns    803736 <spawn+0x2ab>
		panic("copy_shared_pages: %e", r);
  803706:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803709:	89 c1                	mov    %eax,%ecx
  80370b:	48 ba 42 5e 80 00 00 	movabs $0x805e42,%rdx
  803712:	00 00 00 
  803715:	be 86 00 00 00       	mov    $0x86,%esi
  80371a:	48 bf 58 5e 80 00 00 	movabs $0x805e58,%rdi
  803721:	00 00 00 
  803724:	b8 00 00 00 00       	mov    $0x0,%eax
  803729:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  803730:	00 00 00 
  803733:	41 ff d0             	callq  *%r8


	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803736:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  80373d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803740:	48 89 d6             	mov    %rdx,%rsi
  803743:	89 c7                	mov    %eax,%edi
  803745:	48 b8 ab 1b 80 00 00 	movabs $0x801bab,%rax
  80374c:	00 00 00 
  80374f:	ff d0                	callq  *%rax
  803751:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803754:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803758:	79 30                	jns    80378a <spawn+0x2ff>
		panic("sys_env_set_trapframe: %e", r);
  80375a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80375d:	89 c1                	mov    %eax,%ecx
  80375f:	48 ba 64 5e 80 00 00 	movabs $0x805e64,%rdx
  803766:	00 00 00 
  803769:	be 8a 00 00 00       	mov    $0x8a,%esi
  80376e:	48 bf 58 5e 80 00 00 	movabs $0x805e58,%rdi
  803775:	00 00 00 
  803778:	b8 00 00 00 00       	mov    $0x0,%eax
  80377d:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  803784:	00 00 00 
  803787:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80378a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80378d:	be 02 00 00 00       	mov    $0x2,%esi
  803792:	89 c7                	mov    %eax,%edi
  803794:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  80379b:	00 00 00 
  80379e:	ff d0                	callq  *%rax
  8037a0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8037a3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8037a7:	79 30                	jns    8037d9 <spawn+0x34e>
		panic("sys_env_set_status: %e", r);
  8037a9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8037ac:	89 c1                	mov    %eax,%ecx
  8037ae:	48 ba 7e 5e 80 00 00 	movabs $0x805e7e,%rdx
  8037b5:	00 00 00 
  8037b8:	be 8d 00 00 00       	mov    $0x8d,%esi
  8037bd:	48 bf 58 5e 80 00 00 	movabs $0x805e58,%rdi
  8037c4:	00 00 00 
  8037c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8037cc:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  8037d3:	00 00 00 
  8037d6:	41 ff d0             	callq  *%r8

	return child;
  8037d9:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  8037dc:	c9                   	leaveq 
  8037dd:	c3                   	retq   

00000000008037de <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8037de:	55                   	push   %rbp
  8037df:	48 89 e5             	mov    %rsp,%rbp
  8037e2:	41 55                	push   %r13
  8037e4:	41 54                	push   %r12
  8037e6:	53                   	push   %rbx
  8037e7:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8037ee:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  8037f5:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  8037fc:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803803:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  80380a:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803811:	84 c0                	test   %al,%al
  803813:	74 26                	je     80383b <spawnl+0x5d>
  803815:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  80381c:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803823:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803827:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  80382b:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  80382f:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803833:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803837:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  80383b:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803842:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803849:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  80384c:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803853:	00 00 00 
  803856:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  80385d:	00 00 00 
  803860:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803864:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  80386b:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803872:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803879:	eb 07                	jmp    803882 <spawnl+0xa4>
		argc++;
  80387b:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803882:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803888:	83 f8 30             	cmp    $0x30,%eax
  80388b:	73 23                	jae    8038b0 <spawnl+0xd2>
  80388d:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803894:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80389a:	89 c0                	mov    %eax,%eax
  80389c:	48 01 d0             	add    %rdx,%rax
  80389f:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8038a5:	83 c2 08             	add    $0x8,%edx
  8038a8:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8038ae:	eb 15                	jmp    8038c5 <spawnl+0xe7>
  8038b0:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8038b7:	48 89 d0             	mov    %rdx,%rax
  8038ba:	48 83 c2 08          	add    $0x8,%rdx
  8038be:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8038c5:	48 8b 00             	mov    (%rax),%rax
  8038c8:	48 85 c0             	test   %rax,%rax
  8038cb:	75 ae                	jne    80387b <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8038cd:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8038d3:	83 c0 02             	add    $0x2,%eax
  8038d6:	48 89 e2             	mov    %rsp,%rdx
  8038d9:	48 89 d3             	mov    %rdx,%rbx
  8038dc:	48 63 d0             	movslq %eax,%rdx
  8038df:	48 83 ea 01          	sub    $0x1,%rdx
  8038e3:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8038ea:	48 63 d0             	movslq %eax,%rdx
  8038ed:	49 89 d4             	mov    %rdx,%r12
  8038f0:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8038f6:	48 63 d0             	movslq %eax,%rdx
  8038f9:	49 89 d2             	mov    %rdx,%r10
  8038fc:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803902:	48 98                	cltq   
  803904:	48 c1 e0 03          	shl    $0x3,%rax
  803908:	48 8d 50 07          	lea    0x7(%rax),%rdx
  80390c:	b8 10 00 00 00       	mov    $0x10,%eax
  803911:	48 83 e8 01          	sub    $0x1,%rax
  803915:	48 01 d0             	add    %rdx,%rax
  803918:	bf 10 00 00 00       	mov    $0x10,%edi
  80391d:	ba 00 00 00 00       	mov    $0x0,%edx
  803922:	48 f7 f7             	div    %rdi
  803925:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803929:	48 29 c4             	sub    %rax,%rsp
  80392c:	48 89 e0             	mov    %rsp,%rax
  80392f:	48 83 c0 07          	add    $0x7,%rax
  803933:	48 c1 e8 03          	shr    $0x3,%rax
  803937:	48 c1 e0 03          	shl    $0x3,%rax
  80393b:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803942:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803949:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803950:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803953:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803959:	8d 50 01             	lea    0x1(%rax),%edx
  80395c:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803963:	48 63 d2             	movslq %edx,%rdx
  803966:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  80396d:	00 

	va_start(vl, arg0);
  80396e:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803975:	00 00 00 
  803978:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  80397f:	00 00 00 
  803982:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803986:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  80398d:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803994:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  80399b:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  8039a2:	00 00 00 
  8039a5:	eb 63                	jmp    803a0a <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  8039a7:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  8039ad:	8d 70 01             	lea    0x1(%rax),%esi
  8039b0:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8039b6:	83 f8 30             	cmp    $0x30,%eax
  8039b9:	73 23                	jae    8039de <spawnl+0x200>
  8039bb:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  8039c2:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8039c8:	89 c0                	mov    %eax,%eax
  8039ca:	48 01 d0             	add    %rdx,%rax
  8039cd:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8039d3:	83 c2 08             	add    $0x8,%edx
  8039d6:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8039dc:	eb 15                	jmp    8039f3 <spawnl+0x215>
  8039de:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8039e5:	48 89 d0             	mov    %rdx,%rax
  8039e8:	48 83 c2 08          	add    $0x8,%rdx
  8039ec:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8039f3:	48 8b 08             	mov    (%rax),%rcx
  8039f6:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8039fd:	89 f2                	mov    %esi,%edx
  8039ff:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803a03:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803a0a:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803a10:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803a16:	77 8f                	ja     8039a7 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803a18:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803a1f:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803a26:	48 89 d6             	mov    %rdx,%rsi
  803a29:	48 89 c7             	mov    %rax,%rdi
  803a2c:	48 b8 8b 34 80 00 00 	movabs $0x80348b,%rax
  803a33:	00 00 00 
  803a36:	ff d0                	callq  *%rax
  803a38:	48 89 dc             	mov    %rbx,%rsp
}
  803a3b:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803a3f:	5b                   	pop    %rbx
  803a40:	41 5c                	pop    %r12
  803a42:	41 5d                	pop    %r13
  803a44:	5d                   	pop    %rbp
  803a45:	c3                   	retq   

0000000000803a46 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803a46:	55                   	push   %rbp
  803a47:	48 89 e5             	mov    %rsp,%rbp
  803a4a:	48 83 ec 50          	sub    $0x50,%rsp
  803a4e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803a51:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803a55:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803a59:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a60:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803a61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803a68:	eb 33                	jmp    803a9d <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803a6a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a6d:	48 98                	cltq   
  803a6f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803a76:	00 
  803a77:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803a7b:	48 01 d0             	add    %rdx,%rax
  803a7e:	48 8b 00             	mov    (%rax),%rax
  803a81:	48 89 c7             	mov    %rax,%rdi
  803a84:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  803a8b:	00 00 00 
  803a8e:	ff d0                	callq  *%rax
  803a90:	83 c0 01             	add    $0x1,%eax
  803a93:	48 98                	cltq   
  803a95:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803a99:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803a9d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803aa0:	48 98                	cltq   
  803aa2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803aa9:	00 
  803aaa:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803aae:	48 01 d0             	add    %rdx,%rax
  803ab1:	48 8b 00             	mov    (%rax),%rax
  803ab4:	48 85 c0             	test   %rax,%rax
  803ab7:	75 b1                	jne    803a6a <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803ab9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803abd:	48 f7 d8             	neg    %rax
  803ac0:	48 05 00 10 40 00    	add    $0x401000,%rax
  803ac6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803aca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ace:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803ad2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ad6:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803ada:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803add:	83 c2 01             	add    $0x1,%edx
  803ae0:	c1 e2 03             	shl    $0x3,%edx
  803ae3:	48 63 d2             	movslq %edx,%rdx
  803ae6:	48 f7 da             	neg    %rdx
  803ae9:	48 01 d0             	add    %rdx,%rax
  803aec:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803af0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803af4:	48 83 e8 10          	sub    $0x10,%rax
  803af8:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803afe:	77 0a                	ja     803b0a <init_stack+0xc4>
		return -E_NO_MEM;
  803b00:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803b05:	e9 e3 01 00 00       	jmpq   803ced <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803b0a:	ba 07 00 00 00       	mov    $0x7,%edx
  803b0f:	be 00 00 40 00       	mov    $0x400000,%esi
  803b14:	bf 00 00 00 00       	mov    $0x0,%edi
  803b19:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  803b20:	00 00 00 
  803b23:	ff d0                	callq  *%rax
  803b25:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b28:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b2c:	79 08                	jns    803b36 <init_stack+0xf0>
		return r;
  803b2e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b31:	e9 b7 01 00 00       	jmpq   803ced <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803b36:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803b3d:	e9 8a 00 00 00       	jmpq   803bcc <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803b42:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803b45:	48 98                	cltq   
  803b47:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803b4e:	00 
  803b4f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b53:	48 01 c2             	add    %rax,%rdx
  803b56:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803b5b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b5f:	48 01 c8             	add    %rcx,%rax
  803b62:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803b68:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  803b6b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803b6e:	48 98                	cltq   
  803b70:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803b77:	00 
  803b78:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803b7c:	48 01 d0             	add    %rdx,%rax
  803b7f:	48 8b 10             	mov    (%rax),%rdx
  803b82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b86:	48 89 d6             	mov    %rdx,%rsi
  803b89:	48 89 c7             	mov    %rax,%rdi
  803b8c:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  803b93:	00 00 00 
  803b96:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803b98:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803b9b:	48 98                	cltq   
  803b9d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803ba4:	00 
  803ba5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803ba9:	48 01 d0             	add    %rdx,%rax
  803bac:	48 8b 00             	mov    (%rax),%rax
  803baf:	48 89 c7             	mov    %rax,%rdi
  803bb2:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  803bb9:	00 00 00 
  803bbc:	ff d0                	callq  *%rax
  803bbe:	48 98                	cltq   
  803bc0:	48 83 c0 01          	add    $0x1,%rax
  803bc4:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803bc8:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803bcc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803bcf:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803bd2:	0f 8c 6a ff ff ff    	jl     803b42 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803bd8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803bdb:	48 98                	cltq   
  803bdd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803be4:	00 
  803be5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803be9:	48 01 d0             	add    %rdx,%rax
  803bec:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803bf3:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803bfa:	00 
  803bfb:	74 35                	je     803c32 <init_stack+0x1ec>
  803bfd:	48 b9 98 5e 80 00 00 	movabs $0x805e98,%rcx
  803c04:	00 00 00 
  803c07:	48 ba be 5e 80 00 00 	movabs $0x805ebe,%rdx
  803c0e:	00 00 00 
  803c11:	be f6 00 00 00       	mov    $0xf6,%esi
  803c16:	48 bf 58 5e 80 00 00 	movabs $0x805e58,%rdi
  803c1d:	00 00 00 
  803c20:	b8 00 00 00 00       	mov    $0x0,%eax
  803c25:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  803c2c:	00 00 00 
  803c2f:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803c32:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c36:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  803c3a:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803c3f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c43:	48 01 c8             	add    %rcx,%rax
  803c46:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803c4c:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803c4f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c53:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803c57:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803c5a:	48 98                	cltq   
  803c5c:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803c5f:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803c64:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c68:	48 01 d0             	add    %rdx,%rax
  803c6b:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803c71:	48 89 c2             	mov    %rax,%rdx
  803c74:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803c78:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803c7b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803c7e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803c84:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803c89:	89 c2                	mov    %eax,%edx
  803c8b:	be 00 00 40 00       	mov    $0x400000,%esi
  803c90:	bf 00 00 00 00       	mov    $0x0,%edi
  803c95:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  803c9c:	00 00 00 
  803c9f:	ff d0                	callq  *%rax
  803ca1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ca4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ca8:	79 02                	jns    803cac <init_stack+0x266>
		goto error;
  803caa:	eb 28                	jmp    803cd4 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803cac:	be 00 00 40 00       	mov    $0x400000,%esi
  803cb1:	bf 00 00 00 00       	mov    $0x0,%edi
  803cb6:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  803cbd:	00 00 00 
  803cc0:	ff d0                	callq  *%rax
  803cc2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cc5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cc9:	79 02                	jns    803ccd <init_stack+0x287>
		goto error;
  803ccb:	eb 07                	jmp    803cd4 <init_stack+0x28e>

	return 0;
  803ccd:	b8 00 00 00 00       	mov    $0x0,%eax
  803cd2:	eb 19                	jmp    803ced <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  803cd4:	be 00 00 40 00       	mov    $0x400000,%esi
  803cd9:	bf 00 00 00 00       	mov    $0x0,%edi
  803cde:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  803ce5:	00 00 00 
  803ce8:	ff d0                	callq  *%rax
	return r;
  803cea:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803ced:	c9                   	leaveq 
  803cee:	c3                   	retq   

0000000000803cef <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803cef:	55                   	push   %rbp
  803cf0:	48 89 e5             	mov    %rsp,%rbp
  803cf3:	48 83 ec 50          	sub    $0x50,%rsp
  803cf7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803cfa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803cfe:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803d02:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803d05:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803d09:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803d0d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d11:	25 ff 0f 00 00       	and    $0xfff,%eax
  803d16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d1d:	74 21                	je     803d40 <map_segment+0x51>
		va -= i;
  803d1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d22:	48 98                	cltq   
  803d24:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803d28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d2b:	48 98                	cltq   
  803d2d:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803d31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d34:	48 98                	cltq   
  803d36:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803d3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d3d:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803d40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d47:	e9 79 01 00 00       	jmpq   803ec5 <map_segment+0x1d6>
		if (i >= filesz) {
  803d4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d4f:	48 98                	cltq   
  803d51:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803d55:	72 3c                	jb     803d93 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803d57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5a:	48 63 d0             	movslq %eax,%rdx
  803d5d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d61:	48 01 d0             	add    %rdx,%rax
  803d64:	48 89 c1             	mov    %rax,%rcx
  803d67:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803d6a:	8b 55 10             	mov    0x10(%rbp),%edx
  803d6d:	48 89 ce             	mov    %rcx,%rsi
  803d70:	89 c7                	mov    %eax,%edi
  803d72:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  803d79:	00 00 00 
  803d7c:	ff d0                	callq  *%rax
  803d7e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803d81:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803d85:	0f 89 33 01 00 00    	jns    803ebe <map_segment+0x1cf>
				return r;
  803d8b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d8e:	e9 46 01 00 00       	jmpq   803ed9 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803d93:	ba 07 00 00 00       	mov    $0x7,%edx
  803d98:	be 00 00 40 00       	mov    $0x400000,%esi
  803d9d:	bf 00 00 00 00       	mov    $0x0,%edi
  803da2:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  803da9:	00 00 00 
  803dac:	ff d0                	callq  *%rax
  803dae:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803db1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803db5:	79 08                	jns    803dbf <map_segment+0xd0>
				return r;
  803db7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dba:	e9 1a 01 00 00       	jmpq   803ed9 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803dbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dc2:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803dc5:	01 c2                	add    %eax,%edx
  803dc7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803dca:	89 d6                	mov    %edx,%esi
  803dcc:	89 c7                	mov    %eax,%edi
  803dce:	48 b8 96 2b 80 00 00 	movabs $0x802b96,%rax
  803dd5:	00 00 00 
  803dd8:	ff d0                	callq  *%rax
  803dda:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803ddd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803de1:	79 08                	jns    803deb <map_segment+0xfc>
				return r;
  803de3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803de6:	e9 ee 00 00 00       	jmpq   803ed9 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803deb:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803df2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803df5:	48 98                	cltq   
  803df7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803dfb:	48 29 c2             	sub    %rax,%rdx
  803dfe:	48 89 d0             	mov    %rdx,%rax
  803e01:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803e05:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803e08:	48 63 d0             	movslq %eax,%rdx
  803e0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e0f:	48 39 c2             	cmp    %rax,%rdx
  803e12:	48 0f 47 d0          	cmova  %rax,%rdx
  803e16:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803e19:	be 00 00 40 00       	mov    $0x400000,%esi
  803e1e:	89 c7                	mov    %eax,%edi
  803e20:	48 b8 4d 2a 80 00 00 	movabs $0x802a4d,%rax
  803e27:	00 00 00 
  803e2a:	ff d0                	callq  *%rax
  803e2c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803e2f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803e33:	79 08                	jns    803e3d <map_segment+0x14e>
				return r;
  803e35:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e38:	e9 9c 00 00 00       	jmpq   803ed9 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803e3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e40:	48 63 d0             	movslq %eax,%rdx
  803e43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e47:	48 01 d0             	add    %rdx,%rax
  803e4a:	48 89 c2             	mov    %rax,%rdx
  803e4d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803e50:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803e54:	48 89 d1             	mov    %rdx,%rcx
  803e57:	89 c2                	mov    %eax,%edx
  803e59:	be 00 00 40 00       	mov    $0x400000,%esi
  803e5e:	bf 00 00 00 00       	mov    $0x0,%edi
  803e63:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  803e6a:	00 00 00 
  803e6d:	ff d0                	callq  *%rax
  803e6f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803e72:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803e76:	79 30                	jns    803ea8 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803e78:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e7b:	89 c1                	mov    %eax,%ecx
  803e7d:	48 ba d3 5e 80 00 00 	movabs $0x805ed3,%rdx
  803e84:	00 00 00 
  803e87:	be 29 01 00 00       	mov    $0x129,%esi
  803e8c:	48 bf 58 5e 80 00 00 	movabs $0x805e58,%rdi
  803e93:	00 00 00 
  803e96:	b8 00 00 00 00       	mov    $0x0,%eax
  803e9b:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  803ea2:	00 00 00 
  803ea5:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803ea8:	be 00 00 40 00       	mov    $0x400000,%esi
  803ead:	bf 00 00 00 00       	mov    $0x0,%edi
  803eb2:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  803eb9:	00 00 00 
  803ebc:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803ebe:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803ec5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ec8:	48 98                	cltq   
  803eca:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ece:	0f 82 78 fe ff ff    	jb     803d4c <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803ed4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ed9:	c9                   	leaveq 
  803eda:	c3                   	retq   

0000000000803edb <copy_shared_pages>:


// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803edb:	55                   	push   %rbp
  803edc:	48 89 e5             	mov    %rsp,%rbp
  803edf:	48 83 ec 30          	sub    $0x30,%rsp
  803ee3:	89 7d dc             	mov    %edi,-0x24(%rbp)

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  803ee6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803eed:	00 
  803eee:	e9 eb 00 00 00       	jmpq   803fde <copy_shared_pages+0x103>
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
  803ef3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ef7:	48 c1 f8 12          	sar    $0x12,%rax
  803efb:	48 89 c2             	mov    %rax,%rdx
  803efe:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803f05:	01 00 00 
  803f08:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f0c:	83 e0 01             	and    $0x1,%eax
  803f0f:	48 85 c0             	test   %rax,%rax
  803f12:	74 21                	je     803f35 <copy_shared_pages+0x5a>
  803f14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f18:	48 c1 f8 09          	sar    $0x9,%rax
  803f1c:	48 89 c2             	mov    %rax,%rdx
  803f1f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f26:	01 00 00 
  803f29:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f2d:	83 e0 01             	and    $0x1,%eax
  803f30:	48 85 c0             	test   %rax,%rax
  803f33:	75 0d                	jne    803f42 <copy_shared_pages+0x67>
			pn += NPTENTRIES;
  803f35:	48 81 45 f8 00 02 00 	addq   $0x200,-0x8(%rbp)
  803f3c:	00 
  803f3d:	e9 9c 00 00 00       	jmpq   803fde <copy_shared_pages+0x103>
		else {
			last_pn = pn + NPTENTRIES;
  803f42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f46:	48 05 00 02 00 00    	add    $0x200,%rax
  803f4c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
			for (; pn < last_pn; pn++)
  803f50:	eb 7e                	jmp    803fd0 <copy_shared_pages+0xf5>
				if ((uvpt[pn] & (PTE_P | PTE_SHARE)) == (PTE_P | PTE_SHARE)) {
  803f52:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f59:	01 00 00 
  803f5c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803f60:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f64:	25 01 04 00 00       	and    $0x401,%eax
  803f69:	48 3d 01 04 00 00    	cmp    $0x401,%rax
  803f6f:	75 5a                	jne    803fcb <copy_shared_pages+0xf0>
					va = (void*) (pn << PGSHIFT);
  803f71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f75:	48 c1 e0 0c          	shl    $0xc,%rax
  803f79:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
					if ((r = sys_page_map(0, va, child, va, uvpt[pn] & PTE_SYSCALL)) < 0)
  803f7d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f84:	01 00 00 
  803f87:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803f8b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f8f:	25 07 0e 00 00       	and    $0xe07,%eax
  803f94:	89 c6                	mov    %eax,%esi
  803f96:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803f9a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803f9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fa1:	41 89 f0             	mov    %esi,%r8d
  803fa4:	48 89 c6             	mov    %rax,%rsi
  803fa7:	bf 00 00 00 00       	mov    $0x0,%edi
  803fac:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  803fb3:	00 00 00 
  803fb6:	ff d0                	callq  *%rax
  803fb8:	48 98                	cltq   
  803fba:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  803fbe:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803fc3:	79 06                	jns    803fcb <copy_shared_pages+0xf0>
						return r;
  803fc5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fc9:	eb 28                	jmp    803ff3 <copy_shared_pages+0x118>
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
			pn += NPTENTRIES;
		else {
			last_pn = pn + NPTENTRIES;
			for (; pn < last_pn; pn++)
  803fcb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803fd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fd4:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803fd8:	0f 8c 74 ff ff ff    	jl     803f52 <copy_shared_pages+0x77>
{

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  803fde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fe2:	48 3d ff 07 00 08    	cmp    $0x80007ff,%rax
  803fe8:	0f 86 05 ff ff ff    	jbe    803ef3 <copy_shared_pages+0x18>
						return r;
				}
		}
	}

	return 0;
  803fee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ff3:	c9                   	leaveq 
  803ff4:	c3                   	retq   

0000000000803ff5 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803ff5:	55                   	push   %rbp
  803ff6:	48 89 e5             	mov    %rsp,%rbp
  803ff9:	48 83 ec 20          	sub    $0x20,%rsp
  803ffd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  804000:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804004:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804007:	48 89 d6             	mov    %rdx,%rsi
  80400a:	89 c7                	mov    %eax,%edi
  80400c:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  804013:	00 00 00 
  804016:	ff d0                	callq  *%rax
  804018:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80401b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80401f:	79 05                	jns    804026 <fd2sockid+0x31>
		return r;
  804021:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804024:	eb 24                	jmp    80404a <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  804026:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80402a:	8b 10                	mov    (%rax),%edx
  80402c:	48 b8 a0 80 80 00 00 	movabs $0x8080a0,%rax
  804033:	00 00 00 
  804036:	8b 00                	mov    (%rax),%eax
  804038:	39 c2                	cmp    %eax,%edx
  80403a:	74 07                	je     804043 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80403c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  804041:	eb 07                	jmp    80404a <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  804043:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804047:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80404a:	c9                   	leaveq 
  80404b:	c3                   	retq   

000000000080404c <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80404c:	55                   	push   %rbp
  80404d:	48 89 e5             	mov    %rsp,%rbp
  804050:	48 83 ec 20          	sub    $0x20,%rsp
  804054:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  804057:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80405b:	48 89 c7             	mov    %rax,%rdi
  80405e:	48 b8 ae 24 80 00 00 	movabs $0x8024ae,%rax
  804065:	00 00 00 
  804068:	ff d0                	callq  *%rax
  80406a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80406d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804071:	78 26                	js     804099 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  804073:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804077:	ba 07 04 00 00       	mov    $0x407,%edx
  80407c:	48 89 c6             	mov    %rax,%rsi
  80407f:	bf 00 00 00 00       	mov    $0x0,%edi
  804084:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  80408b:	00 00 00 
  80408e:	ff d0                	callq  *%rax
  804090:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804093:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804097:	79 16                	jns    8040af <alloc_sockfd+0x63>
		nsipc_close(sockid);
  804099:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80409c:	89 c7                	mov    %eax,%edi
  80409e:	48 b8 59 45 80 00 00 	movabs $0x804559,%rax
  8040a5:	00 00 00 
  8040a8:	ff d0                	callq  *%rax
		return r;
  8040aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040ad:	eb 3a                	jmp    8040e9 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8040af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040b3:	48 ba a0 80 80 00 00 	movabs $0x8080a0,%rdx
  8040ba:	00 00 00 
  8040bd:	8b 12                	mov    (%rdx),%edx
  8040bf:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8040c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040c5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8040cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040d0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8040d3:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8040d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040da:	48 89 c7             	mov    %rax,%rdi
  8040dd:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  8040e4:	00 00 00 
  8040e7:	ff d0                	callq  *%rax
}
  8040e9:	c9                   	leaveq 
  8040ea:	c3                   	retq   

00000000008040eb <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8040eb:	55                   	push   %rbp
  8040ec:	48 89 e5             	mov    %rsp,%rbp
  8040ef:	48 83 ec 30          	sub    $0x30,%rsp
  8040f3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8040f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8040fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8040fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804101:	89 c7                	mov    %eax,%edi
  804103:	48 b8 f5 3f 80 00 00 	movabs $0x803ff5,%rax
  80410a:	00 00 00 
  80410d:	ff d0                	callq  *%rax
  80410f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804112:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804116:	79 05                	jns    80411d <accept+0x32>
		return r;
  804118:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80411b:	eb 3b                	jmp    804158 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80411d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804121:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804125:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804128:	48 89 ce             	mov    %rcx,%rsi
  80412b:	89 c7                	mov    %eax,%edi
  80412d:	48 b8 36 44 80 00 00 	movabs $0x804436,%rax
  804134:	00 00 00 
  804137:	ff d0                	callq  *%rax
  804139:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80413c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804140:	79 05                	jns    804147 <accept+0x5c>
		return r;
  804142:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804145:	eb 11                	jmp    804158 <accept+0x6d>
	return alloc_sockfd(r);
  804147:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80414a:	89 c7                	mov    %eax,%edi
  80414c:	48 b8 4c 40 80 00 00 	movabs $0x80404c,%rax
  804153:	00 00 00 
  804156:	ff d0                	callq  *%rax
}
  804158:	c9                   	leaveq 
  804159:	c3                   	retq   

000000000080415a <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80415a:	55                   	push   %rbp
  80415b:	48 89 e5             	mov    %rsp,%rbp
  80415e:	48 83 ec 20          	sub    $0x20,%rsp
  804162:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804165:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804169:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80416c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80416f:	89 c7                	mov    %eax,%edi
  804171:	48 b8 f5 3f 80 00 00 	movabs $0x803ff5,%rax
  804178:	00 00 00 
  80417b:	ff d0                	callq  *%rax
  80417d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804180:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804184:	79 05                	jns    80418b <bind+0x31>
		return r;
  804186:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804189:	eb 1b                	jmp    8041a6 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80418b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80418e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804192:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804195:	48 89 ce             	mov    %rcx,%rsi
  804198:	89 c7                	mov    %eax,%edi
  80419a:	48 b8 b5 44 80 00 00 	movabs $0x8044b5,%rax
  8041a1:	00 00 00 
  8041a4:	ff d0                	callq  *%rax
}
  8041a6:	c9                   	leaveq 
  8041a7:	c3                   	retq   

00000000008041a8 <shutdown>:

int
shutdown(int s, int how)
{
  8041a8:	55                   	push   %rbp
  8041a9:	48 89 e5             	mov    %rsp,%rbp
  8041ac:	48 83 ec 20          	sub    $0x20,%rsp
  8041b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8041b3:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8041b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041b9:	89 c7                	mov    %eax,%edi
  8041bb:	48 b8 f5 3f 80 00 00 	movabs $0x803ff5,%rax
  8041c2:	00 00 00 
  8041c5:	ff d0                	callq  *%rax
  8041c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041ce:	79 05                	jns    8041d5 <shutdown+0x2d>
		return r;
  8041d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041d3:	eb 16                	jmp    8041eb <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8041d5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8041d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041db:	89 d6                	mov    %edx,%esi
  8041dd:	89 c7                	mov    %eax,%edi
  8041df:	48 b8 19 45 80 00 00 	movabs $0x804519,%rax
  8041e6:	00 00 00 
  8041e9:	ff d0                	callq  *%rax
}
  8041eb:	c9                   	leaveq 
  8041ec:	c3                   	retq   

00000000008041ed <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8041ed:	55                   	push   %rbp
  8041ee:	48 89 e5             	mov    %rsp,%rbp
  8041f1:	48 83 ec 10          	sub    $0x10,%rsp
  8041f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8041f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041fd:	48 89 c7             	mov    %rax,%rdi
  804200:	48 b8 79 55 80 00 00 	movabs $0x805579,%rax
  804207:	00 00 00 
  80420a:	ff d0                	callq  *%rax
  80420c:	83 f8 01             	cmp    $0x1,%eax
  80420f:	75 17                	jne    804228 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  804211:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804215:	8b 40 0c             	mov    0xc(%rax),%eax
  804218:	89 c7                	mov    %eax,%edi
  80421a:	48 b8 59 45 80 00 00 	movabs $0x804559,%rax
  804221:	00 00 00 
  804224:	ff d0                	callq  *%rax
  804226:	eb 05                	jmp    80422d <devsock_close+0x40>
	else
		return 0;
  804228:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80422d:	c9                   	leaveq 
  80422e:	c3                   	retq   

000000000080422f <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80422f:	55                   	push   %rbp
  804230:	48 89 e5             	mov    %rsp,%rbp
  804233:	48 83 ec 20          	sub    $0x20,%rsp
  804237:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80423a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80423e:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804241:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804244:	89 c7                	mov    %eax,%edi
  804246:	48 b8 f5 3f 80 00 00 	movabs $0x803ff5,%rax
  80424d:	00 00 00 
  804250:	ff d0                	callq  *%rax
  804252:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804255:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804259:	79 05                	jns    804260 <connect+0x31>
		return r;
  80425b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80425e:	eb 1b                	jmp    80427b <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  804260:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804263:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804267:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80426a:	48 89 ce             	mov    %rcx,%rsi
  80426d:	89 c7                	mov    %eax,%edi
  80426f:	48 b8 86 45 80 00 00 	movabs $0x804586,%rax
  804276:	00 00 00 
  804279:	ff d0                	callq  *%rax
}
  80427b:	c9                   	leaveq 
  80427c:	c3                   	retq   

000000000080427d <listen>:

int
listen(int s, int backlog)
{
  80427d:	55                   	push   %rbp
  80427e:	48 89 e5             	mov    %rsp,%rbp
  804281:	48 83 ec 20          	sub    $0x20,%rsp
  804285:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804288:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80428b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80428e:	89 c7                	mov    %eax,%edi
  804290:	48 b8 f5 3f 80 00 00 	movabs $0x803ff5,%rax
  804297:	00 00 00 
  80429a:	ff d0                	callq  *%rax
  80429c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80429f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042a3:	79 05                	jns    8042aa <listen+0x2d>
		return r;
  8042a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042a8:	eb 16                	jmp    8042c0 <listen+0x43>
	return nsipc_listen(r, backlog);
  8042aa:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8042ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042b0:	89 d6                	mov    %edx,%esi
  8042b2:	89 c7                	mov    %eax,%edi
  8042b4:	48 b8 ea 45 80 00 00 	movabs $0x8045ea,%rax
  8042bb:	00 00 00 
  8042be:	ff d0                	callq  *%rax
}
  8042c0:	c9                   	leaveq 
  8042c1:	c3                   	retq   

00000000008042c2 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8042c2:	55                   	push   %rbp
  8042c3:	48 89 e5             	mov    %rsp,%rbp
  8042c6:	48 83 ec 20          	sub    $0x20,%rsp
  8042ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8042ce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8042d2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8042d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042da:	89 c2                	mov    %eax,%edx
  8042dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042e0:	8b 40 0c             	mov    0xc(%rax),%eax
  8042e3:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8042e7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8042ec:	89 c7                	mov    %eax,%edi
  8042ee:	48 b8 2a 46 80 00 00 	movabs $0x80462a,%rax
  8042f5:	00 00 00 
  8042f8:	ff d0                	callq  *%rax
}
  8042fa:	c9                   	leaveq 
  8042fb:	c3                   	retq   

00000000008042fc <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8042fc:	55                   	push   %rbp
  8042fd:	48 89 e5             	mov    %rsp,%rbp
  804300:	48 83 ec 20          	sub    $0x20,%rsp
  804304:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804308:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80430c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  804310:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804314:	89 c2                	mov    %eax,%edx
  804316:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80431a:	8b 40 0c             	mov    0xc(%rax),%eax
  80431d:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  804321:	b9 00 00 00 00       	mov    $0x0,%ecx
  804326:	89 c7                	mov    %eax,%edi
  804328:	48 b8 f6 46 80 00 00 	movabs $0x8046f6,%rax
  80432f:	00 00 00 
  804332:	ff d0                	callq  *%rax
}
  804334:	c9                   	leaveq 
  804335:	c3                   	retq   

0000000000804336 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  804336:	55                   	push   %rbp
  804337:	48 89 e5             	mov    %rsp,%rbp
  80433a:	48 83 ec 10          	sub    $0x10,%rsp
  80433e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804342:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  804346:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80434a:	48 be f5 5e 80 00 00 	movabs $0x805ef5,%rsi
  804351:	00 00 00 
  804354:	48 89 c7             	mov    %rax,%rdi
  804357:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  80435e:	00 00 00 
  804361:	ff d0                	callq  *%rax
	return 0;
  804363:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804368:	c9                   	leaveq 
  804369:	c3                   	retq   

000000000080436a <socket>:

int
socket(int domain, int type, int protocol)
{
  80436a:	55                   	push   %rbp
  80436b:	48 89 e5             	mov    %rsp,%rbp
  80436e:	48 83 ec 20          	sub    $0x20,%rsp
  804372:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804375:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804378:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80437b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80437e:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804381:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804384:	89 ce                	mov    %ecx,%esi
  804386:	89 c7                	mov    %eax,%edi
  804388:	48 b8 ae 47 80 00 00 	movabs $0x8047ae,%rax
  80438f:	00 00 00 
  804392:	ff d0                	callq  *%rax
  804394:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804397:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80439b:	79 05                	jns    8043a2 <socket+0x38>
		return r;
  80439d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043a0:	eb 11                	jmp    8043b3 <socket+0x49>
	return alloc_sockfd(r);
  8043a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043a5:	89 c7                	mov    %eax,%edi
  8043a7:	48 b8 4c 40 80 00 00 	movabs $0x80404c,%rax
  8043ae:	00 00 00 
  8043b1:	ff d0                	callq  *%rax
}
  8043b3:	c9                   	leaveq 
  8043b4:	c3                   	retq   

00000000008043b5 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8043b5:	55                   	push   %rbp
  8043b6:	48 89 e5             	mov    %rsp,%rbp
  8043b9:	48 83 ec 10          	sub    $0x10,%rsp
  8043bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8043c0:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  8043c7:	00 00 00 
  8043ca:	8b 00                	mov    (%rax),%eax
  8043cc:	85 c0                	test   %eax,%eax
  8043ce:	75 1d                	jne    8043ed <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8043d0:	bf 02 00 00 00       	mov    $0x2,%edi
  8043d5:	48 b8 07 55 80 00 00 	movabs $0x805507,%rax
  8043dc:	00 00 00 
  8043df:	ff d0                	callq  *%rax
  8043e1:	48 ba 04 90 80 00 00 	movabs $0x809004,%rdx
  8043e8:	00 00 00 
  8043eb:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8043ed:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  8043f4:	00 00 00 
  8043f7:	8b 00                	mov    (%rax),%eax
  8043f9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8043fc:	b9 07 00 00 00       	mov    $0x7,%ecx
  804401:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  804408:	00 00 00 
  80440b:	89 c7                	mov    %eax,%edi
  80440d:	48 b8 fb 52 80 00 00 	movabs $0x8052fb,%rax
  804414:	00 00 00 
  804417:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  804419:	ba 00 00 00 00       	mov    $0x0,%edx
  80441e:	be 00 00 00 00       	mov    $0x0,%esi
  804423:	bf 00 00 00 00       	mov    $0x0,%edi
  804428:	48 b8 3a 52 80 00 00 	movabs $0x80523a,%rax
  80442f:	00 00 00 
  804432:	ff d0                	callq  *%rax
}
  804434:	c9                   	leaveq 
  804435:	c3                   	retq   

0000000000804436 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804436:	55                   	push   %rbp
  804437:	48 89 e5             	mov    %rsp,%rbp
  80443a:	48 83 ec 30          	sub    $0x30,%rsp
  80443e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804441:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804445:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  804449:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804450:	00 00 00 
  804453:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804456:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  804458:	bf 01 00 00 00       	mov    $0x1,%edi
  80445d:	48 b8 b5 43 80 00 00 	movabs $0x8043b5,%rax
  804464:	00 00 00 
  804467:	ff d0                	callq  *%rax
  804469:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80446c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804470:	78 3e                	js     8044b0 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  804472:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804479:	00 00 00 
  80447c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  804480:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804484:	8b 40 10             	mov    0x10(%rax),%eax
  804487:	89 c2                	mov    %eax,%edx
  804489:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80448d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804491:	48 89 ce             	mov    %rcx,%rsi
  804494:	48 89 c7             	mov    %rax,%rdi
  804497:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  80449e:	00 00 00 
  8044a1:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8044a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044a7:	8b 50 10             	mov    0x10(%rax),%edx
  8044aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044ae:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8044b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8044b3:	c9                   	leaveq 
  8044b4:	c3                   	retq   

00000000008044b5 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8044b5:	55                   	push   %rbp
  8044b6:	48 89 e5             	mov    %rsp,%rbp
  8044b9:	48 83 ec 10          	sub    $0x10,%rsp
  8044bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8044c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8044c4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8044c7:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8044ce:	00 00 00 
  8044d1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8044d4:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8044d6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8044d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044dd:	48 89 c6             	mov    %rax,%rsi
  8044e0:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  8044e7:	00 00 00 
  8044ea:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  8044f1:	00 00 00 
  8044f4:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8044f6:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8044fd:	00 00 00 
  804500:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804503:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  804506:	bf 02 00 00 00       	mov    $0x2,%edi
  80450b:	48 b8 b5 43 80 00 00 	movabs $0x8043b5,%rax
  804512:	00 00 00 
  804515:	ff d0                	callq  *%rax
}
  804517:	c9                   	leaveq 
  804518:	c3                   	retq   

0000000000804519 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  804519:	55                   	push   %rbp
  80451a:	48 89 e5             	mov    %rsp,%rbp
  80451d:	48 83 ec 10          	sub    $0x10,%rsp
  804521:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804524:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  804527:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80452e:	00 00 00 
  804531:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804534:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  804536:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80453d:	00 00 00 
  804540:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804543:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  804546:	bf 03 00 00 00       	mov    $0x3,%edi
  80454b:	48 b8 b5 43 80 00 00 	movabs $0x8043b5,%rax
  804552:	00 00 00 
  804555:	ff d0                	callq  *%rax
}
  804557:	c9                   	leaveq 
  804558:	c3                   	retq   

0000000000804559 <nsipc_close>:

int
nsipc_close(int s)
{
  804559:	55                   	push   %rbp
  80455a:	48 89 e5             	mov    %rsp,%rbp
  80455d:	48 83 ec 10          	sub    $0x10,%rsp
  804561:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  804564:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80456b:	00 00 00 
  80456e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804571:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  804573:	bf 04 00 00 00       	mov    $0x4,%edi
  804578:	48 b8 b5 43 80 00 00 	movabs $0x8043b5,%rax
  80457f:	00 00 00 
  804582:	ff d0                	callq  *%rax
}
  804584:	c9                   	leaveq 
  804585:	c3                   	retq   

0000000000804586 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804586:	55                   	push   %rbp
  804587:	48 89 e5             	mov    %rsp,%rbp
  80458a:	48 83 ec 10          	sub    $0x10,%rsp
  80458e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804591:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804595:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  804598:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80459f:	00 00 00 
  8045a2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8045a5:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8045a7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8045aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045ae:	48 89 c6             	mov    %rax,%rsi
  8045b1:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  8045b8:	00 00 00 
  8045bb:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  8045c2:	00 00 00 
  8045c5:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8045c7:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8045ce:	00 00 00 
  8045d1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8045d4:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8045d7:	bf 05 00 00 00       	mov    $0x5,%edi
  8045dc:	48 b8 b5 43 80 00 00 	movabs $0x8043b5,%rax
  8045e3:	00 00 00 
  8045e6:	ff d0                	callq  *%rax
}
  8045e8:	c9                   	leaveq 
  8045e9:	c3                   	retq   

00000000008045ea <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8045ea:	55                   	push   %rbp
  8045eb:	48 89 e5             	mov    %rsp,%rbp
  8045ee:	48 83 ec 10          	sub    $0x10,%rsp
  8045f2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8045f5:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8045f8:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8045ff:	00 00 00 
  804602:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804605:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  804607:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80460e:	00 00 00 
  804611:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804614:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  804617:	bf 06 00 00 00       	mov    $0x6,%edi
  80461c:	48 b8 b5 43 80 00 00 	movabs $0x8043b5,%rax
  804623:	00 00 00 
  804626:	ff d0                	callq  *%rax
}
  804628:	c9                   	leaveq 
  804629:	c3                   	retq   

000000000080462a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80462a:	55                   	push   %rbp
  80462b:	48 89 e5             	mov    %rsp,%rbp
  80462e:	48 83 ec 30          	sub    $0x30,%rsp
  804632:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804635:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804639:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80463c:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80463f:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804646:	00 00 00 
  804649:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80464c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80464e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804655:	00 00 00 
  804658:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80465b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80465e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804665:	00 00 00 
  804668:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80466b:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80466e:	bf 07 00 00 00       	mov    $0x7,%edi
  804673:	48 b8 b5 43 80 00 00 	movabs $0x8043b5,%rax
  80467a:	00 00 00 
  80467d:	ff d0                	callq  *%rax
  80467f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804682:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804686:	78 69                	js     8046f1 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  804688:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80468f:	7f 08                	jg     804699 <nsipc_recv+0x6f>
  804691:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804694:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  804697:	7e 35                	jle    8046ce <nsipc_recv+0xa4>
  804699:	48 b9 fc 5e 80 00 00 	movabs $0x805efc,%rcx
  8046a0:	00 00 00 
  8046a3:	48 ba 11 5f 80 00 00 	movabs $0x805f11,%rdx
  8046aa:	00 00 00 
  8046ad:	be 62 00 00 00       	mov    $0x62,%esi
  8046b2:	48 bf 26 5f 80 00 00 	movabs $0x805f26,%rdi
  8046b9:	00 00 00 
  8046bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8046c1:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  8046c8:	00 00 00 
  8046cb:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8046ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046d1:	48 63 d0             	movslq %eax,%rdx
  8046d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046d8:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  8046df:	00 00 00 
  8046e2:	48 89 c7             	mov    %rax,%rdi
  8046e5:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  8046ec:	00 00 00 
  8046ef:	ff d0                	callq  *%rax
	}

	return r;
  8046f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8046f4:	c9                   	leaveq 
  8046f5:	c3                   	retq   

00000000008046f6 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8046f6:	55                   	push   %rbp
  8046f7:	48 89 e5             	mov    %rsp,%rbp
  8046fa:	48 83 ec 20          	sub    $0x20,%rsp
  8046fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804701:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804705:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804708:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80470b:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804712:	00 00 00 
  804715:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804718:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80471a:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  804721:	7e 35                	jle    804758 <nsipc_send+0x62>
  804723:	48 b9 32 5f 80 00 00 	movabs $0x805f32,%rcx
  80472a:	00 00 00 
  80472d:	48 ba 11 5f 80 00 00 	movabs $0x805f11,%rdx
  804734:	00 00 00 
  804737:	be 6d 00 00 00       	mov    $0x6d,%esi
  80473c:	48 bf 26 5f 80 00 00 	movabs $0x805f26,%rdi
  804743:	00 00 00 
  804746:	b8 00 00 00 00       	mov    $0x0,%eax
  80474b:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  804752:	00 00 00 
  804755:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804758:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80475b:	48 63 d0             	movslq %eax,%rdx
  80475e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804762:	48 89 c6             	mov    %rax,%rsi
  804765:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  80476c:	00 00 00 
  80476f:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  804776:	00 00 00 
  804779:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80477b:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804782:	00 00 00 
  804785:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804788:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80478b:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804792:	00 00 00 
  804795:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804798:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80479b:	bf 08 00 00 00       	mov    $0x8,%edi
  8047a0:	48 b8 b5 43 80 00 00 	movabs $0x8043b5,%rax
  8047a7:	00 00 00 
  8047aa:	ff d0                	callq  *%rax
}
  8047ac:	c9                   	leaveq 
  8047ad:	c3                   	retq   

00000000008047ae <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8047ae:	55                   	push   %rbp
  8047af:	48 89 e5             	mov    %rsp,%rbp
  8047b2:	48 83 ec 10          	sub    $0x10,%rsp
  8047b6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8047b9:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8047bc:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8047bf:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8047c6:	00 00 00 
  8047c9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8047cc:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8047ce:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8047d5:	00 00 00 
  8047d8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8047db:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8047de:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8047e5:	00 00 00 
  8047e8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8047eb:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8047ee:	bf 09 00 00 00       	mov    $0x9,%edi
  8047f3:	48 b8 b5 43 80 00 00 	movabs $0x8043b5,%rax
  8047fa:	00 00 00 
  8047fd:	ff d0                	callq  *%rax
}
  8047ff:	c9                   	leaveq 
  804800:	c3                   	retq   

0000000000804801 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804801:	55                   	push   %rbp
  804802:	48 89 e5             	mov    %rsp,%rbp
  804805:	53                   	push   %rbx
  804806:	48 83 ec 38          	sub    $0x38,%rsp
  80480a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80480e:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804812:	48 89 c7             	mov    %rax,%rdi
  804815:	48 b8 ae 24 80 00 00 	movabs $0x8024ae,%rax
  80481c:	00 00 00 
  80481f:	ff d0                	callq  *%rax
  804821:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804824:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804828:	0f 88 bf 01 00 00    	js     8049ed <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80482e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804832:	ba 07 04 00 00       	mov    $0x407,%edx
  804837:	48 89 c6             	mov    %rax,%rsi
  80483a:	bf 00 00 00 00       	mov    $0x0,%edi
  80483f:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  804846:	00 00 00 
  804849:	ff d0                	callq  *%rax
  80484b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80484e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804852:	0f 88 95 01 00 00    	js     8049ed <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804858:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80485c:	48 89 c7             	mov    %rax,%rdi
  80485f:	48 b8 ae 24 80 00 00 	movabs $0x8024ae,%rax
  804866:	00 00 00 
  804869:	ff d0                	callq  *%rax
  80486b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80486e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804872:	0f 88 5d 01 00 00    	js     8049d5 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804878:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80487c:	ba 07 04 00 00       	mov    $0x407,%edx
  804881:	48 89 c6             	mov    %rax,%rsi
  804884:	bf 00 00 00 00       	mov    $0x0,%edi
  804889:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  804890:	00 00 00 
  804893:	ff d0                	callq  *%rax
  804895:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804898:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80489c:	0f 88 33 01 00 00    	js     8049d5 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8048a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048a6:	48 89 c7             	mov    %rax,%rdi
  8048a9:	48 b8 83 24 80 00 00 	movabs $0x802483,%rax
  8048b0:	00 00 00 
  8048b3:	ff d0                	callq  *%rax
  8048b5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8048b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048bd:	ba 07 04 00 00       	mov    $0x407,%edx
  8048c2:	48 89 c6             	mov    %rax,%rsi
  8048c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8048ca:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  8048d1:	00 00 00 
  8048d4:	ff d0                	callq  *%rax
  8048d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8048d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8048dd:	79 05                	jns    8048e4 <pipe+0xe3>
		goto err2;
  8048df:	e9 d9 00 00 00       	jmpq   8049bd <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8048e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8048e8:	48 89 c7             	mov    %rax,%rdi
  8048eb:	48 b8 83 24 80 00 00 	movabs $0x802483,%rax
  8048f2:	00 00 00 
  8048f5:	ff d0                	callq  *%rax
  8048f7:	48 89 c2             	mov    %rax,%rdx
  8048fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048fe:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804904:	48 89 d1             	mov    %rdx,%rcx
  804907:	ba 00 00 00 00       	mov    $0x0,%edx
  80490c:	48 89 c6             	mov    %rax,%rsi
  80490f:	bf 00 00 00 00       	mov    $0x0,%edi
  804914:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  80491b:	00 00 00 
  80491e:	ff d0                	callq  *%rax
  804920:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804923:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804927:	79 1b                	jns    804944 <pipe+0x143>
		goto err3;
  804929:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80492a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80492e:	48 89 c6             	mov    %rax,%rsi
  804931:	bf 00 00 00 00       	mov    $0x0,%edi
  804936:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  80493d:	00 00 00 
  804940:	ff d0                	callq  *%rax
  804942:	eb 79                	jmp    8049bd <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804944:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804948:	48 ba e0 80 80 00 00 	movabs $0x8080e0,%rdx
  80494f:	00 00 00 
  804952:	8b 12                	mov    (%rdx),%edx
  804954:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804956:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80495a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804961:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804965:	48 ba e0 80 80 00 00 	movabs $0x8080e0,%rdx
  80496c:	00 00 00 
  80496f:	8b 12                	mov    (%rdx),%edx
  804971:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804973:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804977:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80497e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804982:	48 89 c7             	mov    %rax,%rdi
  804985:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  80498c:	00 00 00 
  80498f:	ff d0                	callq  *%rax
  804991:	89 c2                	mov    %eax,%edx
  804993:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804997:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804999:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80499d:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8049a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8049a5:	48 89 c7             	mov    %rax,%rdi
  8049a8:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  8049af:	00 00 00 
  8049b2:	ff d0                	callq  *%rax
  8049b4:	89 03                	mov    %eax,(%rbx)
	return 0;
  8049b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8049bb:	eb 33                	jmp    8049f0 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8049bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8049c1:	48 89 c6             	mov    %rax,%rsi
  8049c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8049c9:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  8049d0:	00 00 00 
  8049d3:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8049d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049d9:	48 89 c6             	mov    %rax,%rsi
  8049dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8049e1:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  8049e8:	00 00 00 
  8049eb:	ff d0                	callq  *%rax
err:
	return r;
  8049ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8049f0:	48 83 c4 38          	add    $0x38,%rsp
  8049f4:	5b                   	pop    %rbx
  8049f5:	5d                   	pop    %rbp
  8049f6:	c3                   	retq   

00000000008049f7 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8049f7:	55                   	push   %rbp
  8049f8:	48 89 e5             	mov    %rsp,%rbp
  8049fb:	53                   	push   %rbx
  8049fc:	48 83 ec 28          	sub    $0x28,%rsp
  804a00:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804a04:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804a08:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804a0f:	00 00 00 
  804a12:	48 8b 00             	mov    (%rax),%rax
  804a15:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804a1b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804a1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a22:	48 89 c7             	mov    %rax,%rdi
  804a25:	48 b8 79 55 80 00 00 	movabs $0x805579,%rax
  804a2c:	00 00 00 
  804a2f:	ff d0                	callq  *%rax
  804a31:	89 c3                	mov    %eax,%ebx
  804a33:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804a37:	48 89 c7             	mov    %rax,%rdi
  804a3a:	48 b8 79 55 80 00 00 	movabs $0x805579,%rax
  804a41:	00 00 00 
  804a44:	ff d0                	callq  *%rax
  804a46:	39 c3                	cmp    %eax,%ebx
  804a48:	0f 94 c0             	sete   %al
  804a4b:	0f b6 c0             	movzbl %al,%eax
  804a4e:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804a51:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804a58:	00 00 00 
  804a5b:	48 8b 00             	mov    (%rax),%rax
  804a5e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804a64:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804a67:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a6a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804a6d:	75 05                	jne    804a74 <_pipeisclosed+0x7d>
			return ret;
  804a6f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804a72:	eb 4f                	jmp    804ac3 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  804a74:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a77:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804a7a:	74 42                	je     804abe <_pipeisclosed+0xc7>
  804a7c:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804a80:	75 3c                	jne    804abe <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804a82:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804a89:	00 00 00 
  804a8c:	48 8b 00             	mov    (%rax),%rax
  804a8f:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804a95:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804a98:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a9b:	89 c6                	mov    %eax,%esi
  804a9d:	48 bf 43 5f 80 00 00 	movabs $0x805f43,%rdi
  804aa4:	00 00 00 
  804aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  804aac:	49 b8 87 05 80 00 00 	movabs $0x800587,%r8
  804ab3:	00 00 00 
  804ab6:	41 ff d0             	callq  *%r8
	}
  804ab9:	e9 4a ff ff ff       	jmpq   804a08 <_pipeisclosed+0x11>
  804abe:	e9 45 ff ff ff       	jmpq   804a08 <_pipeisclosed+0x11>

}
  804ac3:	48 83 c4 28          	add    $0x28,%rsp
  804ac7:	5b                   	pop    %rbx
  804ac8:	5d                   	pop    %rbp
  804ac9:	c3                   	retq   

0000000000804aca <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804aca:	55                   	push   %rbp
  804acb:	48 89 e5             	mov    %rsp,%rbp
  804ace:	48 83 ec 30          	sub    $0x30,%rsp
  804ad2:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804ad5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804ad9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804adc:	48 89 d6             	mov    %rdx,%rsi
  804adf:	89 c7                	mov    %eax,%edi
  804ae1:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  804ae8:	00 00 00 
  804aeb:	ff d0                	callq  *%rax
  804aed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804af0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804af4:	79 05                	jns    804afb <pipeisclosed+0x31>
		return r;
  804af6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804af9:	eb 31                	jmp    804b2c <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804afb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804aff:	48 89 c7             	mov    %rax,%rdi
  804b02:	48 b8 83 24 80 00 00 	movabs $0x802483,%rax
  804b09:	00 00 00 
  804b0c:	ff d0                	callq  *%rax
  804b0e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804b12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b1a:	48 89 d6             	mov    %rdx,%rsi
  804b1d:	48 89 c7             	mov    %rax,%rdi
  804b20:	48 b8 f7 49 80 00 00 	movabs $0x8049f7,%rax
  804b27:	00 00 00 
  804b2a:	ff d0                	callq  *%rax
}
  804b2c:	c9                   	leaveq 
  804b2d:	c3                   	retq   

0000000000804b2e <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804b2e:	55                   	push   %rbp
  804b2f:	48 89 e5             	mov    %rsp,%rbp
  804b32:	48 83 ec 40          	sub    $0x40,%rsp
  804b36:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804b3a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804b3e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804b42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b46:	48 89 c7             	mov    %rax,%rdi
  804b49:	48 b8 83 24 80 00 00 	movabs $0x802483,%rax
  804b50:	00 00 00 
  804b53:	ff d0                	callq  *%rax
  804b55:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804b59:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804b5d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804b61:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804b68:	00 
  804b69:	e9 92 00 00 00       	jmpq   804c00 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804b6e:	eb 41                	jmp    804bb1 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804b70:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804b75:	74 09                	je     804b80 <devpipe_read+0x52>
				return i;
  804b77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b7b:	e9 92 00 00 00       	jmpq   804c12 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804b80:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b84:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b88:	48 89 d6             	mov    %rdx,%rsi
  804b8b:	48 89 c7             	mov    %rax,%rdi
  804b8e:	48 b8 f7 49 80 00 00 	movabs $0x8049f7,%rax
  804b95:	00 00 00 
  804b98:	ff d0                	callq  *%rax
  804b9a:	85 c0                	test   %eax,%eax
  804b9c:	74 07                	je     804ba5 <devpipe_read+0x77>
				return 0;
  804b9e:	b8 00 00 00 00       	mov    $0x0,%eax
  804ba3:	eb 6d                	jmp    804c12 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804ba5:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  804bac:	00 00 00 
  804baf:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804bb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804bb5:	8b 10                	mov    (%rax),%edx
  804bb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804bbb:	8b 40 04             	mov    0x4(%rax),%eax
  804bbe:	39 c2                	cmp    %eax,%edx
  804bc0:	74 ae                	je     804b70 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804bc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804bc6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804bca:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804bce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804bd2:	8b 00                	mov    (%rax),%eax
  804bd4:	99                   	cltd   
  804bd5:	c1 ea 1b             	shr    $0x1b,%edx
  804bd8:	01 d0                	add    %edx,%eax
  804bda:	83 e0 1f             	and    $0x1f,%eax
  804bdd:	29 d0                	sub    %edx,%eax
  804bdf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804be3:	48 98                	cltq   
  804be5:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804bea:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804bec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804bf0:	8b 00                	mov    (%rax),%eax
  804bf2:	8d 50 01             	lea    0x1(%rax),%edx
  804bf5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804bf9:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804bfb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804c00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c04:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804c08:	0f 82 60 ff ff ff    	jb     804b6e <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804c0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804c12:	c9                   	leaveq 
  804c13:	c3                   	retq   

0000000000804c14 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804c14:	55                   	push   %rbp
  804c15:	48 89 e5             	mov    %rsp,%rbp
  804c18:	48 83 ec 40          	sub    $0x40,%rsp
  804c1c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804c20:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804c24:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804c28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c2c:	48 89 c7             	mov    %rax,%rdi
  804c2f:	48 b8 83 24 80 00 00 	movabs $0x802483,%rax
  804c36:	00 00 00 
  804c39:	ff d0                	callq  *%rax
  804c3b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804c3f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804c43:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804c47:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804c4e:	00 
  804c4f:	e9 8e 00 00 00       	jmpq   804ce2 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804c54:	eb 31                	jmp    804c87 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804c56:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804c5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c5e:	48 89 d6             	mov    %rdx,%rsi
  804c61:	48 89 c7             	mov    %rax,%rdi
  804c64:	48 b8 f7 49 80 00 00 	movabs $0x8049f7,%rax
  804c6b:	00 00 00 
  804c6e:	ff d0                	callq  *%rax
  804c70:	85 c0                	test   %eax,%eax
  804c72:	74 07                	je     804c7b <devpipe_write+0x67>
				return 0;
  804c74:	b8 00 00 00 00       	mov    $0x0,%eax
  804c79:	eb 79                	jmp    804cf4 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804c7b:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  804c82:	00 00 00 
  804c85:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804c87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c8b:	8b 40 04             	mov    0x4(%rax),%eax
  804c8e:	48 63 d0             	movslq %eax,%rdx
  804c91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c95:	8b 00                	mov    (%rax),%eax
  804c97:	48 98                	cltq   
  804c99:	48 83 c0 20          	add    $0x20,%rax
  804c9d:	48 39 c2             	cmp    %rax,%rdx
  804ca0:	73 b4                	jae    804c56 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804ca2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ca6:	8b 40 04             	mov    0x4(%rax),%eax
  804ca9:	99                   	cltd   
  804caa:	c1 ea 1b             	shr    $0x1b,%edx
  804cad:	01 d0                	add    %edx,%eax
  804caf:	83 e0 1f             	and    $0x1f,%eax
  804cb2:	29 d0                	sub    %edx,%eax
  804cb4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804cb8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804cbc:	48 01 ca             	add    %rcx,%rdx
  804cbf:	0f b6 0a             	movzbl (%rdx),%ecx
  804cc2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804cc6:	48 98                	cltq   
  804cc8:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804ccc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cd0:	8b 40 04             	mov    0x4(%rax),%eax
  804cd3:	8d 50 01             	lea    0x1(%rax),%edx
  804cd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cda:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804cdd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804ce2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ce6:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804cea:	0f 82 64 ff ff ff    	jb     804c54 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804cf0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804cf4:	c9                   	leaveq 
  804cf5:	c3                   	retq   

0000000000804cf6 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804cf6:	55                   	push   %rbp
  804cf7:	48 89 e5             	mov    %rsp,%rbp
  804cfa:	48 83 ec 20          	sub    $0x20,%rsp
  804cfe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804d02:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804d06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d0a:	48 89 c7             	mov    %rax,%rdi
  804d0d:	48 b8 83 24 80 00 00 	movabs $0x802483,%rax
  804d14:	00 00 00 
  804d17:	ff d0                	callq  *%rax
  804d19:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804d1d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d21:	48 be 56 5f 80 00 00 	movabs $0x805f56,%rsi
  804d28:	00 00 00 
  804d2b:	48 89 c7             	mov    %rax,%rdi
  804d2e:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  804d35:	00 00 00 
  804d38:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804d3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d3e:	8b 50 04             	mov    0x4(%rax),%edx
  804d41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d45:	8b 00                	mov    (%rax),%eax
  804d47:	29 c2                	sub    %eax,%edx
  804d49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d4d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804d53:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d57:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804d5e:	00 00 00 
	stat->st_dev = &devpipe;
  804d61:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d65:	48 b9 e0 80 80 00 00 	movabs $0x8080e0,%rcx
  804d6c:	00 00 00 
  804d6f:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804d76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804d7b:	c9                   	leaveq 
  804d7c:	c3                   	retq   

0000000000804d7d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804d7d:	55                   	push   %rbp
  804d7e:	48 89 e5             	mov    %rsp,%rbp
  804d81:	48 83 ec 10          	sub    $0x10,%rsp
  804d85:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  804d89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d8d:	48 89 c6             	mov    %rax,%rsi
  804d90:	bf 00 00 00 00       	mov    $0x0,%edi
  804d95:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  804d9c:	00 00 00 
  804d9f:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804da1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804da5:	48 89 c7             	mov    %rax,%rdi
  804da8:	48 b8 83 24 80 00 00 	movabs $0x802483,%rax
  804daf:	00 00 00 
  804db2:	ff d0                	callq  *%rax
  804db4:	48 89 c6             	mov    %rax,%rsi
  804db7:	bf 00 00 00 00       	mov    $0x0,%edi
  804dbc:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  804dc3:	00 00 00 
  804dc6:	ff d0                	callq  *%rax
}
  804dc8:	c9                   	leaveq 
  804dc9:	c3                   	retq   

0000000000804dca <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804dca:	55                   	push   %rbp
  804dcb:	48 89 e5             	mov    %rsp,%rbp
  804dce:	48 83 ec 20          	sub    $0x20,%rsp
  804dd2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  804dd5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804dd9:	75 35                	jne    804e10 <wait+0x46>
  804ddb:	48 b9 5d 5f 80 00 00 	movabs $0x805f5d,%rcx
  804de2:	00 00 00 
  804de5:	48 ba 68 5f 80 00 00 	movabs $0x805f68,%rdx
  804dec:	00 00 00 
  804def:	be 0a 00 00 00       	mov    $0xa,%esi
  804df4:	48 bf 7d 5f 80 00 00 	movabs $0x805f7d,%rdi
  804dfb:	00 00 00 
  804dfe:	b8 00 00 00 00       	mov    $0x0,%eax
  804e03:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  804e0a:	00 00 00 
  804e0d:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804e10:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804e13:	25 ff 03 00 00       	and    $0x3ff,%eax
  804e18:	48 98                	cltq   
  804e1a:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804e21:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804e28:	00 00 00 
  804e2b:	48 01 d0             	add    %rdx,%rax
  804e2e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804e32:	eb 0c                	jmp    804e40 <wait+0x76>
		sys_yield();
  804e34:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  804e3b:	00 00 00 
  804e3e:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804e40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804e44:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804e4a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804e4d:	75 0e                	jne    804e5d <wait+0x93>
  804e4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804e53:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804e59:	85 c0                	test   %eax,%eax
  804e5b:	75 d7                	jne    804e34 <wait+0x6a>
		sys_yield();
}
  804e5d:	c9                   	leaveq 
  804e5e:	c3                   	retq   

0000000000804e5f <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804e5f:	55                   	push   %rbp
  804e60:	48 89 e5             	mov    %rsp,%rbp
  804e63:	48 83 ec 20          	sub    $0x20,%rsp
  804e67:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804e6a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804e6d:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804e70:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804e74:	be 01 00 00 00       	mov    $0x1,%esi
  804e79:	48 89 c7             	mov    %rax,%rdi
  804e7c:	48 b8 23 19 80 00 00 	movabs $0x801923,%rax
  804e83:	00 00 00 
  804e86:	ff d0                	callq  *%rax
}
  804e88:	c9                   	leaveq 
  804e89:	c3                   	retq   

0000000000804e8a <getchar>:

int
getchar(void)
{
  804e8a:	55                   	push   %rbp
  804e8b:	48 89 e5             	mov    %rsp,%rbp
  804e8e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804e92:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804e96:	ba 01 00 00 00       	mov    $0x1,%edx
  804e9b:	48 89 c6             	mov    %rax,%rsi
  804e9e:	bf 00 00 00 00       	mov    $0x0,%edi
  804ea3:	48 b8 78 29 80 00 00 	movabs $0x802978,%rax
  804eaa:	00 00 00 
  804ead:	ff d0                	callq  *%rax
  804eaf:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804eb2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804eb6:	79 05                	jns    804ebd <getchar+0x33>
		return r;
  804eb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ebb:	eb 14                	jmp    804ed1 <getchar+0x47>
	if (r < 1)
  804ebd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ec1:	7f 07                	jg     804eca <getchar+0x40>
		return -E_EOF;
  804ec3:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804ec8:	eb 07                	jmp    804ed1 <getchar+0x47>
	return c;
  804eca:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804ece:	0f b6 c0             	movzbl %al,%eax

}
  804ed1:	c9                   	leaveq 
  804ed2:	c3                   	retq   

0000000000804ed3 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804ed3:	55                   	push   %rbp
  804ed4:	48 89 e5             	mov    %rsp,%rbp
  804ed7:	48 83 ec 20          	sub    $0x20,%rsp
  804edb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804ede:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804ee2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804ee5:	48 89 d6             	mov    %rdx,%rsi
  804ee8:	89 c7                	mov    %eax,%edi
  804eea:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  804ef1:	00 00 00 
  804ef4:	ff d0                	callq  *%rax
  804ef6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804ef9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804efd:	79 05                	jns    804f04 <iscons+0x31>
		return r;
  804eff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f02:	eb 1a                	jmp    804f1e <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804f04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f08:	8b 10                	mov    (%rax),%edx
  804f0a:	48 b8 20 81 80 00 00 	movabs $0x808120,%rax
  804f11:	00 00 00 
  804f14:	8b 00                	mov    (%rax),%eax
  804f16:	39 c2                	cmp    %eax,%edx
  804f18:	0f 94 c0             	sete   %al
  804f1b:	0f b6 c0             	movzbl %al,%eax
}
  804f1e:	c9                   	leaveq 
  804f1f:	c3                   	retq   

0000000000804f20 <opencons>:

int
opencons(void)
{
  804f20:	55                   	push   %rbp
  804f21:	48 89 e5             	mov    %rsp,%rbp
  804f24:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804f28:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804f2c:	48 89 c7             	mov    %rax,%rdi
  804f2f:	48 b8 ae 24 80 00 00 	movabs $0x8024ae,%rax
  804f36:	00 00 00 
  804f39:	ff d0                	callq  *%rax
  804f3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804f3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804f42:	79 05                	jns    804f49 <opencons+0x29>
		return r;
  804f44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f47:	eb 5b                	jmp    804fa4 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804f49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f4d:	ba 07 04 00 00       	mov    $0x407,%edx
  804f52:	48 89 c6             	mov    %rax,%rsi
  804f55:	bf 00 00 00 00       	mov    $0x0,%edi
  804f5a:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  804f61:	00 00 00 
  804f64:	ff d0                	callq  *%rax
  804f66:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804f69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804f6d:	79 05                	jns    804f74 <opencons+0x54>
		return r;
  804f6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f72:	eb 30                	jmp    804fa4 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804f74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f78:	48 ba 20 81 80 00 00 	movabs $0x808120,%rdx
  804f7f:	00 00 00 
  804f82:	8b 12                	mov    (%rdx),%edx
  804f84:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804f86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f8a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804f91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f95:	48 89 c7             	mov    %rax,%rdi
  804f98:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  804f9f:	00 00 00 
  804fa2:	ff d0                	callq  *%rax
}
  804fa4:	c9                   	leaveq 
  804fa5:	c3                   	retq   

0000000000804fa6 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804fa6:	55                   	push   %rbp
  804fa7:	48 89 e5             	mov    %rsp,%rbp
  804faa:	48 83 ec 30          	sub    $0x30,%rsp
  804fae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804fb2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804fb6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804fba:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804fbf:	75 07                	jne    804fc8 <devcons_read+0x22>
		return 0;
  804fc1:	b8 00 00 00 00       	mov    $0x0,%eax
  804fc6:	eb 4b                	jmp    805013 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804fc8:	eb 0c                	jmp    804fd6 <devcons_read+0x30>
		sys_yield();
  804fca:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  804fd1:	00 00 00 
  804fd4:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804fd6:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  804fdd:	00 00 00 
  804fe0:	ff d0                	callq  *%rax
  804fe2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804fe5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804fe9:	74 df                	je     804fca <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804feb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804fef:	79 05                	jns    804ff6 <devcons_read+0x50>
		return c;
  804ff1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ff4:	eb 1d                	jmp    805013 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804ff6:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804ffa:	75 07                	jne    805003 <devcons_read+0x5d>
		return 0;
  804ffc:	b8 00 00 00 00       	mov    $0x0,%eax
  805001:	eb 10                	jmp    805013 <devcons_read+0x6d>
	*(char*)vbuf = c;
  805003:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805006:	89 c2                	mov    %eax,%edx
  805008:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80500c:	88 10                	mov    %dl,(%rax)
	return 1;
  80500e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  805013:	c9                   	leaveq 
  805014:	c3                   	retq   

0000000000805015 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  805015:	55                   	push   %rbp
  805016:	48 89 e5             	mov    %rsp,%rbp
  805019:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  805020:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  805027:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80502e:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  805035:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80503c:	eb 76                	jmp    8050b4 <devcons_write+0x9f>
		m = n - tot;
  80503e:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  805045:	89 c2                	mov    %eax,%edx
  805047:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80504a:	29 c2                	sub    %eax,%edx
  80504c:	89 d0                	mov    %edx,%eax
  80504e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  805051:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805054:	83 f8 7f             	cmp    $0x7f,%eax
  805057:	76 07                	jbe    805060 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  805059:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  805060:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805063:	48 63 d0             	movslq %eax,%rdx
  805066:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805069:	48 63 c8             	movslq %eax,%rcx
  80506c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  805073:	48 01 c1             	add    %rax,%rcx
  805076:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80507d:	48 89 ce             	mov    %rcx,%rsi
  805080:	48 89 c7             	mov    %rax,%rdi
  805083:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  80508a:	00 00 00 
  80508d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80508f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805092:	48 63 d0             	movslq %eax,%rdx
  805095:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80509c:	48 89 d6             	mov    %rdx,%rsi
  80509f:	48 89 c7             	mov    %rax,%rdi
  8050a2:	48 b8 23 19 80 00 00 	movabs $0x801923,%rax
  8050a9:	00 00 00 
  8050ac:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8050ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8050b1:	01 45 fc             	add    %eax,-0x4(%rbp)
  8050b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8050b7:	48 98                	cltq   
  8050b9:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8050c0:	0f 82 78 ff ff ff    	jb     80503e <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8050c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8050c9:	c9                   	leaveq 
  8050ca:	c3                   	retq   

00000000008050cb <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8050cb:	55                   	push   %rbp
  8050cc:	48 89 e5             	mov    %rsp,%rbp
  8050cf:	48 83 ec 08          	sub    $0x8,%rsp
  8050d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8050d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8050dc:	c9                   	leaveq 
  8050dd:	c3                   	retq   

00000000008050de <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8050de:	55                   	push   %rbp
  8050df:	48 89 e5             	mov    %rsp,%rbp
  8050e2:	48 83 ec 10          	sub    $0x10,%rsp
  8050e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8050ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8050ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8050f2:	48 be 8d 5f 80 00 00 	movabs $0x805f8d,%rsi
  8050f9:	00 00 00 
  8050fc:	48 89 c7             	mov    %rax,%rdi
  8050ff:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  805106:	00 00 00 
  805109:	ff d0                	callq  *%rax
	return 0;
  80510b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805110:	c9                   	leaveq 
  805111:	c3                   	retq   

0000000000805112 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  805112:	55                   	push   %rbp
  805113:	48 89 e5             	mov    %rsp,%rbp
  805116:	48 83 ec 20          	sub    $0x20,%rsp
  80511a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  80511e:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805125:	00 00 00 
  805128:	48 8b 00             	mov    (%rax),%rax
  80512b:	48 85 c0             	test   %rax,%rax
  80512e:	75 6f                	jne    80519f <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  805130:	ba 07 00 00 00       	mov    $0x7,%edx
  805135:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80513a:	bf 00 00 00 00       	mov    $0x0,%edi
  80513f:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  805146:	00 00 00 
  805149:	ff d0                	callq  *%rax
  80514b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80514e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805152:	79 30                	jns    805184 <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  805154:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805157:	89 c1                	mov    %eax,%ecx
  805159:	48 ba 98 5f 80 00 00 	movabs $0x805f98,%rdx
  805160:	00 00 00 
  805163:	be 22 00 00 00       	mov    $0x22,%esi
  805168:	48 bf b7 5f 80 00 00 	movabs $0x805fb7,%rdi
  80516f:	00 00 00 
  805172:	b8 00 00 00 00       	mov    $0x0,%eax
  805177:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  80517e:	00 00 00 
  805181:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  805184:	48 be b2 51 80 00 00 	movabs $0x8051b2,%rsi
  80518b:	00 00 00 
  80518e:	bf 00 00 00 00       	mov    $0x0,%edi
  805193:	48 b8 f5 1b 80 00 00 	movabs $0x801bf5,%rax
  80519a:	00 00 00 
  80519d:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80519f:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8051a6:	00 00 00 
  8051a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8051ad:	48 89 10             	mov    %rdx,(%rax)
}
  8051b0:	c9                   	leaveq 
  8051b1:	c3                   	retq   

00000000008051b2 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8051b2:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8051b5:	48 a1 00 d0 80 00 00 	movabs 0x80d000,%rax
  8051bc:	00 00 00 
call *%rax
  8051bf:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  8051c1:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  8051c8:	00 08 
    movq 152(%rsp), %rax
  8051ca:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  8051d1:	00 
    movq 136(%rsp), %rbx
  8051d2:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8051d9:	00 
movq %rbx, (%rax)
  8051da:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  8051dd:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  8051e1:	4c 8b 3c 24          	mov    (%rsp),%r15
  8051e5:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8051ea:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8051ef:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8051f4:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8051f9:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8051fe:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  805203:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  805208:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80520d:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  805212:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  805217:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80521c:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  805221:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  805226:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80522b:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  80522f:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  805233:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  805234:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  805239:	c3                   	retq   

000000000080523a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80523a:	55                   	push   %rbp
  80523b:	48 89 e5             	mov    %rsp,%rbp
  80523e:	48 83 ec 30          	sub    $0x30,%rsp
  805242:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805246:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80524a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  80524e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805253:	75 0e                	jne    805263 <ipc_recv+0x29>
		pg = (void*) UTOP;
  805255:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80525c:	00 00 00 
  80525f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  805263:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805267:	48 89 c7             	mov    %rax,%rdi
  80526a:	48 b8 94 1c 80 00 00 	movabs $0x801c94,%rax
  805271:	00 00 00 
  805274:	ff d0                	callq  *%rax
  805276:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805279:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80527d:	79 27                	jns    8052a6 <ipc_recv+0x6c>
		if (from_env_store)
  80527f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805284:	74 0a                	je     805290 <ipc_recv+0x56>
			*from_env_store = 0;
  805286:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80528a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  805290:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805295:	74 0a                	je     8052a1 <ipc_recv+0x67>
			*perm_store = 0;
  805297:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80529b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8052a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8052a4:	eb 53                	jmp    8052f9 <ipc_recv+0xbf>
	}
	if (from_env_store)
  8052a6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8052ab:	74 19                	je     8052c6 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8052ad:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8052b4:	00 00 00 
  8052b7:	48 8b 00             	mov    (%rax),%rax
  8052ba:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8052c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8052c4:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8052c6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8052cb:	74 19                	je     8052e6 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8052cd:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8052d4:	00 00 00 
  8052d7:	48 8b 00             	mov    (%rax),%rax
  8052da:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8052e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8052e4:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8052e6:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8052ed:	00 00 00 
  8052f0:	48 8b 00             	mov    (%rax),%rax
  8052f3:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  8052f9:	c9                   	leaveq 
  8052fa:	c3                   	retq   

00000000008052fb <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8052fb:	55                   	push   %rbp
  8052fc:	48 89 e5             	mov    %rsp,%rbp
  8052ff:	48 83 ec 30          	sub    $0x30,%rsp
  805303:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805306:	89 75 e8             	mov    %esi,-0x18(%rbp)
  805309:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80530d:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  805310:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805315:	75 10                	jne    805327 <ipc_send+0x2c>
		pg = (void*) UTOP;
  805317:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80531e:	00 00 00 
  805321:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  805325:	eb 0e                	jmp    805335 <ipc_send+0x3a>
  805327:	eb 0c                	jmp    805335 <ipc_send+0x3a>
		sys_yield();
  805329:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  805330:	00 00 00 
  805333:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  805335:	8b 75 e8             	mov    -0x18(%rbp),%esi
  805338:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80533b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80533f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805342:	89 c7                	mov    %eax,%edi
  805344:	48 b8 3f 1c 80 00 00 	movabs $0x801c3f,%rax
  80534b:	00 00 00 
  80534e:	ff d0                	callq  *%rax
  805350:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805353:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  805357:	74 d0                	je     805329 <ipc_send+0x2e>
		sys_yield();
	}
	if (r < 0)
  805359:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80535d:	79 30                	jns    80538f <ipc_send+0x94>
		panic("error in ipc_send: %e", r);
  80535f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805362:	89 c1                	mov    %eax,%ecx
  805364:	48 ba c5 5f 80 00 00 	movabs $0x805fc5,%rdx
  80536b:	00 00 00 
  80536e:	be 47 00 00 00       	mov    $0x47,%esi
  805373:	48 bf db 5f 80 00 00 	movabs $0x805fdb,%rdi
  80537a:	00 00 00 
  80537d:	b8 00 00 00 00       	mov    $0x0,%eax
  805382:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  805389:	00 00 00 
  80538c:	41 ff d0             	callq  *%r8

}
  80538f:	c9                   	leaveq 
  805390:	c3                   	retq   

0000000000805391 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  805391:	55                   	push   %rbp
  805392:	48 89 e5             	mov    %rsp,%rbp
  805395:	53                   	push   %rbx
  805396:	48 83 ec 28          	sub    $0x28,%rsp
  80539a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  80539e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8053a5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  8053ac:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8053b1:	75 0e                	jne    8053c1 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  8053b3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8053ba:	00 00 00 
  8053bd:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  8053c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8053c5:	ba 07 00 00 00       	mov    $0x7,%edx
  8053ca:	48 89 c6             	mov    %rax,%rsi
  8053cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8053d2:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  8053d9:	00 00 00 
  8053dc:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8053de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8053e2:	48 c1 e8 0c          	shr    $0xc,%rax
  8053e6:	48 89 c2             	mov    %rax,%rdx
  8053e9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8053f0:	01 00 00 
  8053f3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8053f7:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8053fd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  805401:	b8 03 00 00 00       	mov    $0x3,%eax
  805406:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80540a:	48 89 d3             	mov    %rdx,%rbx
  80540d:	0f 01 c1             	vmcall 
  805410:	89 f2                	mov    %esi,%edx
  805412:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805415:	89 55 e8             	mov    %edx,-0x18(%rbp)
	/* cprintf("Returned IPC response from host: %d %d\n", r, -val);*/
	if (r < 0) {
  805418:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80541c:	79 05                	jns    805423 <ipc_host_recv+0x92>
		return r;
  80541e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805421:	eb 03                	jmp    805426 <ipc_host_recv+0x95>
	}
	return val;
  805423:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  805426:	48 83 c4 28          	add    $0x28,%rsp
  80542a:	5b                   	pop    %rbx
  80542b:	5d                   	pop    %rbp
  80542c:	c3                   	retq   

000000000080542d <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80542d:	55                   	push   %rbp
  80542e:	48 89 e5             	mov    %rsp,%rbp
  805431:	53                   	push   %rbx
  805432:	48 83 ec 38          	sub    $0x38,%rsp
  805436:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805439:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80543c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  805440:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  805443:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  80544a:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80544f:	75 0e                	jne    80545f <ipc_host_send+0x32>
		pg = (void*) UTOP;
  805451:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805458:	00 00 00 
  80545b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  80545f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805463:	48 c1 e8 0c          	shr    $0xc,%rax
  805467:	48 89 c2             	mov    %rax,%rdx
  80546a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805471:	01 00 00 
  805474:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805478:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80547e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  805482:	b8 02 00 00 00       	mov    $0x2,%eax
  805487:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80548a:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80548d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805491:	8b 75 cc             	mov    -0x34(%rbp),%esi
  805494:	89 fb                	mov    %edi,%ebx
  805496:	0f 01 c1             	vmcall 
  805499:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  80549c:	eb 26                	jmp    8054c4 <ipc_host_send+0x97>
		sys_yield();
  80549e:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  8054a5:	00 00 00 
  8054a8:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8054aa:	b8 02 00 00 00       	mov    $0x2,%eax
  8054af:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8054b2:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8054b5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8054b9:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8054bc:	89 fb                	mov    %edi,%ebx
  8054be:	0f 01 c1             	vmcall 
  8054c1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8054c4:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  8054c8:	74 d4                	je     80549e <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  8054ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8054ce:	79 30                	jns    805500 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  8054d0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8054d3:	89 c1                	mov    %eax,%ecx
  8054d5:	48 ba c5 5f 80 00 00 	movabs $0x805fc5,%rdx
  8054dc:	00 00 00 
  8054df:	be 79 00 00 00       	mov    $0x79,%esi
  8054e4:	48 bf db 5f 80 00 00 	movabs $0x805fdb,%rdi
  8054eb:	00 00 00 
  8054ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8054f3:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  8054fa:	00 00 00 
  8054fd:	41 ff d0             	callq  *%r8

}
  805500:	48 83 c4 38          	add    $0x38,%rsp
  805504:	5b                   	pop    %rbx
  805505:	5d                   	pop    %rbp
  805506:	c3                   	retq   

0000000000805507 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  805507:	55                   	push   %rbp
  805508:	48 89 e5             	mov    %rsp,%rbp
  80550b:	48 83 ec 14          	sub    $0x14,%rsp
  80550f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  805512:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805519:	eb 4e                	jmp    805569 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  80551b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805522:	00 00 00 
  805525:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805528:	48 98                	cltq   
  80552a:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  805531:	48 01 d0             	add    %rdx,%rax
  805534:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80553a:	8b 00                	mov    (%rax),%eax
  80553c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80553f:	75 24                	jne    805565 <ipc_find_env+0x5e>
			return envs[i].env_id;
  805541:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805548:	00 00 00 
  80554b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80554e:	48 98                	cltq   
  805550:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  805557:	48 01 d0             	add    %rdx,%rax
  80555a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  805560:	8b 40 08             	mov    0x8(%rax),%eax
  805563:	eb 12                	jmp    805577 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  805565:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805569:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  805570:	7e a9                	jle    80551b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  805572:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805577:	c9                   	leaveq 
  805578:	c3                   	retq   

0000000000805579 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  805579:	55                   	push   %rbp
  80557a:	48 89 e5             	mov    %rsp,%rbp
  80557d:	48 83 ec 18          	sub    $0x18,%rsp
  805581:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  805585:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805589:	48 c1 e8 15          	shr    $0x15,%rax
  80558d:	48 89 c2             	mov    %rax,%rdx
  805590:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805597:	01 00 00 
  80559a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80559e:	83 e0 01             	and    $0x1,%eax
  8055a1:	48 85 c0             	test   %rax,%rax
  8055a4:	75 07                	jne    8055ad <pageref+0x34>
		return 0;
  8055a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8055ab:	eb 53                	jmp    805600 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8055ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8055b1:	48 c1 e8 0c          	shr    $0xc,%rax
  8055b5:	48 89 c2             	mov    %rax,%rdx
  8055b8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8055bf:	01 00 00 
  8055c2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8055c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8055ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055ce:	83 e0 01             	and    $0x1,%eax
  8055d1:	48 85 c0             	test   %rax,%rax
  8055d4:	75 07                	jne    8055dd <pageref+0x64>
		return 0;
  8055d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8055db:	eb 23                	jmp    805600 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8055dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055e1:	48 c1 e8 0c          	shr    $0xc,%rax
  8055e5:	48 89 c2             	mov    %rax,%rdx
  8055e8:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8055ef:	00 00 00 
  8055f2:	48 c1 e2 04          	shl    $0x4,%rdx
  8055f6:	48 01 d0             	add    %rdx,%rax
  8055f9:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8055fd:	0f b7 c0             	movzwl %ax,%eax
}
  805600:	c9                   	leaveq 
  805601:	c3                   	retq   
