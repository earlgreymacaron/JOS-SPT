
vmm/guest/obj/user/testtime:     file format elf64-x86-64


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
  80003c:	e8 6c 01 00 00       	callq  8001ad <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <sleep>:
#include <inc/lib.h>
#include <inc/x86.h>

void
sleep(int sec)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	unsigned now = sys_time_msec();
  80004e:	48 b8 dd 1b 80 00 00 	movabs $0x801bdd,%rax
  800055:	00 00 00 
  800058:	ff d0                	callq  *%rax
  80005a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	unsigned end = now + sec * 1000;
  80005d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800060:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
  800066:	89 c2                	mov    %eax,%edx
  800068:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	89 45 f8             	mov    %eax,-0x8(%rbp)

	if ((int)now < 0 && (int)now > -MAXERROR)
  800070:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800073:	85 c0                	test   %eax,%eax
  800075:	79 38                	jns    8000af <sleep+0x6c>
  800077:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80007a:	83 f8 eb             	cmp    $0xffffffeb,%eax
  80007d:	7c 30                	jl     8000af <sleep+0x6c>
		panic("sys_time_msec: %e", (int)now);
  80007f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800082:	89 c1                	mov    %eax,%ecx
  800084:	48 ba e0 41 80 00 00 	movabs $0x8041e0,%rdx
  80008b:	00 00 00 
  80008e:	be 0c 00 00 00       	mov    $0xc,%esi
  800093:	48 bf f2 41 80 00 00 	movabs $0x8041f2,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	49 b8 53 02 80 00 00 	movabs $0x800253,%r8
  8000a9:	00 00 00 
  8000ac:	41 ff d0             	callq  *%r8
	if (end < now)
  8000af:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000b2:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000b5:	73 2a                	jae    8000e1 <sleep+0x9e>
		panic("sleep: wrap");
  8000b7:	48 ba 02 42 80 00 00 	movabs $0x804202,%rdx
  8000be:	00 00 00 
  8000c1:	be 0e 00 00 00       	mov    $0xe,%esi
  8000c6:	48 bf f2 41 80 00 00 	movabs $0x8041f2,%rdi
  8000cd:	00 00 00 
  8000d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d5:	48 b9 53 02 80 00 00 	movabs $0x800253,%rcx
  8000dc:	00 00 00 
  8000df:	ff d1                	callq  *%rcx

	while (sys_time_msec() < end)
  8000e1:	eb 0c                	jmp    8000ef <sleep+0xac>
		sys_yield();
  8000e3:	48 b8 32 19 80 00 00 	movabs $0x801932,%rax
  8000ea:	00 00 00 
  8000ed:	ff d0                	callq  *%rax
	if ((int)now < 0 && (int)now > -MAXERROR)
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
		panic("sleep: wrap");

	while (sys_time_msec() < end)
  8000ef:	48 b8 dd 1b 80 00 00 	movabs $0x801bdd,%rax
  8000f6:	00 00 00 
  8000f9:	ff d0                	callq  *%rax
  8000fb:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8000fe:	72 e3                	jb     8000e3 <sleep+0xa0>
		sys_yield();
}
  800100:	c9                   	leaveq 
  800101:	c3                   	retq   

0000000000800102 <umain>:

void
umain(int argc, char **argv)
{
  800102:	55                   	push   %rbp
  800103:	48 89 e5             	mov    %rsp,%rbp
  800106:	48 83 ec 20          	sub    $0x20,%rsp
  80010a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80010d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
  800111:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800118:	eb 10                	jmp    80012a <umain+0x28>
		sys_yield();
  80011a:	48 b8 32 19 80 00 00 	movabs $0x801932,%rax
  800121:	00 00 00 
  800124:	ff d0                	callq  *%rax
umain(int argc, char **argv)
{
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
  800126:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80012a:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
  80012e:	7e ea                	jle    80011a <umain+0x18>
		sys_yield();

	cprintf("starting count down: ");
  800130:	48 bf 0e 42 80 00 00 	movabs $0x80420e,%rdi
  800137:	00 00 00 
  80013a:	b8 00 00 00 00       	mov    $0x0,%eax
  80013f:	48 ba 8c 04 80 00 00 	movabs $0x80048c,%rdx
  800146:	00 00 00 
  800149:	ff d2                	callq  *%rdx
	for (i = 5; i >= 0; i--) {
  80014b:	c7 45 fc 05 00 00 00 	movl   $0x5,-0x4(%rbp)
  800152:	eb 35                	jmp    800189 <umain+0x87>
		cprintf("%d ", i);
  800154:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800157:	89 c6                	mov    %eax,%esi
  800159:	48 bf 24 42 80 00 00 	movabs $0x804224,%rdi
  800160:	00 00 00 
  800163:	b8 00 00 00 00       	mov    $0x0,%eax
  800168:	48 ba 8c 04 80 00 00 	movabs $0x80048c,%rdx
  80016f:	00 00 00 
  800172:	ff d2                	callq  *%rdx
		sleep(1);
  800174:	bf 01 00 00 00       	mov    $0x1,%edi
  800179:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800180:	00 00 00 
  800183:	ff d0                	callq  *%rax
	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();

	cprintf("starting count down: ");
	for (i = 5; i >= 0; i--) {
  800185:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  800189:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80018d:	79 c5                	jns    800154 <umain+0x52>
		cprintf("%d ", i);
		sleep(1);
	}
	cprintf("\n");
  80018f:	48 bf 28 42 80 00 00 	movabs $0x804228,%rdi
  800196:	00 00 00 
  800199:	b8 00 00 00 00       	mov    $0x0,%eax
  80019e:	48 ba 8c 04 80 00 00 	movabs $0x80048c,%rdx
  8001a5:	00 00 00 
  8001a8:	ff d2                	callq  *%rdx
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8001aa:	cc                   	int3   
	breakpoint();
}
  8001ab:	c9                   	leaveq 
  8001ac:	c3                   	retq   

00000000008001ad <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ad:	55                   	push   %rbp
  8001ae:	48 89 e5             	mov    %rsp,%rbp
  8001b1:	48 83 ec 10          	sub    $0x10,%rsp
  8001b5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  8001bc:	48 b8 f4 18 80 00 00 	movabs $0x8018f4,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
  8001c8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001cd:	48 98                	cltq   
  8001cf:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8001d6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001dd:	00 00 00 
  8001e0:	48 01 c2             	add    %rax,%rdx
  8001e3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001ea:	00 00 00 
  8001ed:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001f4:	7e 14                	jle    80020a <libmain+0x5d>
		binaryname = argv[0];
  8001f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001fa:	48 8b 10             	mov    (%rax),%rdx
  8001fd:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800204:	00 00 00 
  800207:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80020a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80020e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800211:	48 89 d6             	mov    %rdx,%rsi
  800214:	89 c7                	mov    %eax,%edi
  800216:	48 b8 02 01 80 00 00 	movabs $0x800102,%rax
  80021d:	00 00 00 
  800220:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800222:	48 b8 30 02 80 00 00 	movabs $0x800230,%rax
  800229:	00 00 00 
  80022c:	ff d0                	callq  *%rax
}
  80022e:	c9                   	leaveq 
  80022f:	c3                   	retq   

0000000000800230 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800230:	55                   	push   %rbp
  800231:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800234:	48 b8 91 20 80 00 00 	movabs $0x802091,%rax
  80023b:	00 00 00 
  80023e:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800240:	bf 00 00 00 00       	mov    $0x0,%edi
  800245:	48 b8 b0 18 80 00 00 	movabs $0x8018b0,%rax
  80024c:	00 00 00 
  80024f:	ff d0                	callq  *%rax
}
  800251:	5d                   	pop    %rbp
  800252:	c3                   	retq   

0000000000800253 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800253:	55                   	push   %rbp
  800254:	48 89 e5             	mov    %rsp,%rbp
  800257:	53                   	push   %rbx
  800258:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80025f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800266:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80026c:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800273:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80027a:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800281:	84 c0                	test   %al,%al
  800283:	74 23                	je     8002a8 <_panic+0x55>
  800285:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80028c:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800290:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800294:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800298:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80029c:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002a0:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002a4:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002a8:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002af:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002b6:	00 00 00 
  8002b9:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002c0:	00 00 00 
  8002c3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002c7:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002ce:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002d5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002dc:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002e3:	00 00 00 
  8002e6:	48 8b 18             	mov    (%rax),%rbx
  8002e9:	48 b8 f4 18 80 00 00 	movabs $0x8018f4,%rax
  8002f0:	00 00 00 
  8002f3:	ff d0                	callq  *%rax
  8002f5:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8002fb:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800302:	41 89 c8             	mov    %ecx,%r8d
  800305:	48 89 d1             	mov    %rdx,%rcx
  800308:	48 89 da             	mov    %rbx,%rdx
  80030b:	89 c6                	mov    %eax,%esi
  80030d:	48 bf 38 42 80 00 00 	movabs $0x804238,%rdi
  800314:	00 00 00 
  800317:	b8 00 00 00 00       	mov    $0x0,%eax
  80031c:	49 b9 8c 04 80 00 00 	movabs $0x80048c,%r9
  800323:	00 00 00 
  800326:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800329:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800330:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800337:	48 89 d6             	mov    %rdx,%rsi
  80033a:	48 89 c7             	mov    %rax,%rdi
  80033d:	48 b8 e0 03 80 00 00 	movabs $0x8003e0,%rax
  800344:	00 00 00 
  800347:	ff d0                	callq  *%rax
	cprintf("\n");
  800349:	48 bf 5b 42 80 00 00 	movabs $0x80425b,%rdi
  800350:	00 00 00 
  800353:	b8 00 00 00 00       	mov    $0x0,%eax
  800358:	48 ba 8c 04 80 00 00 	movabs $0x80048c,%rdx
  80035f:	00 00 00 
  800362:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800364:	cc                   	int3   
  800365:	eb fd                	jmp    800364 <_panic+0x111>

0000000000800367 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800367:	55                   	push   %rbp
  800368:	48 89 e5             	mov    %rsp,%rbp
  80036b:	48 83 ec 10          	sub    $0x10,%rsp
  80036f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800372:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800376:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80037a:	8b 00                	mov    (%rax),%eax
  80037c:	8d 48 01             	lea    0x1(%rax),%ecx
  80037f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800383:	89 0a                	mov    %ecx,(%rdx)
  800385:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800388:	89 d1                	mov    %edx,%ecx
  80038a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80038e:	48 98                	cltq   
  800390:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800394:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800398:	8b 00                	mov    (%rax),%eax
  80039a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80039f:	75 2c                	jne    8003cd <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a5:	8b 00                	mov    (%rax),%eax
  8003a7:	48 98                	cltq   
  8003a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ad:	48 83 c2 08          	add    $0x8,%rdx
  8003b1:	48 89 c6             	mov    %rax,%rsi
  8003b4:	48 89 d7             	mov    %rdx,%rdi
  8003b7:	48 b8 28 18 80 00 00 	movabs $0x801828,%rax
  8003be:	00 00 00 
  8003c1:	ff d0                	callq  *%rax
        b->idx = 0;
  8003c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d1:	8b 40 04             	mov    0x4(%rax),%eax
  8003d4:	8d 50 01             	lea    0x1(%rax),%edx
  8003d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003db:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003de:	c9                   	leaveq 
  8003df:	c3                   	retq   

00000000008003e0 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003e0:	55                   	push   %rbp
  8003e1:	48 89 e5             	mov    %rsp,%rbp
  8003e4:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003eb:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003f2:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003f9:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800400:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800407:	48 8b 0a             	mov    (%rdx),%rcx
  80040a:	48 89 08             	mov    %rcx,(%rax)
  80040d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800411:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800415:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800419:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80041d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800424:	00 00 00 
    b.cnt = 0;
  800427:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80042e:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800431:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800438:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80043f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800446:	48 89 c6             	mov    %rax,%rsi
  800449:	48 bf 67 03 80 00 00 	movabs $0x800367,%rdi
  800450:	00 00 00 
  800453:	48 b8 3f 08 80 00 00 	movabs $0x80083f,%rax
  80045a:	00 00 00 
  80045d:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80045f:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800465:	48 98                	cltq   
  800467:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80046e:	48 83 c2 08          	add    $0x8,%rdx
  800472:	48 89 c6             	mov    %rax,%rsi
  800475:	48 89 d7             	mov    %rdx,%rdi
  800478:	48 b8 28 18 80 00 00 	movabs $0x801828,%rax
  80047f:	00 00 00 
  800482:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800484:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80048a:	c9                   	leaveq 
  80048b:	c3                   	retq   

000000000080048c <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80048c:	55                   	push   %rbp
  80048d:	48 89 e5             	mov    %rsp,%rbp
  800490:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800497:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80049e:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004a5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004ac:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004b3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004ba:	84 c0                	test   %al,%al
  8004bc:	74 20                	je     8004de <cprintf+0x52>
  8004be:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004c2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004c6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004ca:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004ce:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004d2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004d6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004da:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004de:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004e5:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004ec:	00 00 00 
  8004ef:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004f6:	00 00 00 
  8004f9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004fd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800504:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80050b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800512:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800519:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800520:	48 8b 0a             	mov    (%rdx),%rcx
  800523:	48 89 08             	mov    %rcx,(%rax)
  800526:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80052a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80052e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800532:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800536:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80053d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800544:	48 89 d6             	mov    %rdx,%rsi
  800547:	48 89 c7             	mov    %rax,%rdi
  80054a:	48 b8 e0 03 80 00 00 	movabs $0x8003e0,%rax
  800551:	00 00 00 
  800554:	ff d0                	callq  *%rax
  800556:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80055c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800562:	c9                   	leaveq 
  800563:	c3                   	retq   

0000000000800564 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800564:	55                   	push   %rbp
  800565:	48 89 e5             	mov    %rsp,%rbp
  800568:	53                   	push   %rbx
  800569:	48 83 ec 38          	sub    $0x38,%rsp
  80056d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800571:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800575:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800579:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80057c:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800580:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800584:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800587:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80058b:	77 3b                	ja     8005c8 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80058d:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800590:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800594:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800597:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80059b:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a0:	48 f7 f3             	div    %rbx
  8005a3:	48 89 c2             	mov    %rax,%rdx
  8005a6:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005a9:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005ac:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b4:	41 89 f9             	mov    %edi,%r9d
  8005b7:	48 89 c7             	mov    %rax,%rdi
  8005ba:	48 b8 64 05 80 00 00 	movabs $0x800564,%rax
  8005c1:	00 00 00 
  8005c4:	ff d0                	callq  *%rax
  8005c6:	eb 1e                	jmp    8005e6 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005c8:	eb 12                	jmp    8005dc <printnum+0x78>
			putch(padc, putdat);
  8005ca:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005ce:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d5:	48 89 ce             	mov    %rcx,%rsi
  8005d8:	89 d7                	mov    %edx,%edi
  8005da:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005dc:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005e0:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005e4:	7f e4                	jg     8005ca <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005e6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f2:	48 f7 f1             	div    %rcx
  8005f5:	48 89 d0             	mov    %rdx,%rax
  8005f8:	48 ba 50 44 80 00 00 	movabs $0x804450,%rdx
  8005ff:	00 00 00 
  800602:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800606:	0f be d0             	movsbl %al,%edx
  800609:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80060d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800611:	48 89 ce             	mov    %rcx,%rsi
  800614:	89 d7                	mov    %edx,%edi
  800616:	ff d0                	callq  *%rax
}
  800618:	48 83 c4 38          	add    $0x38,%rsp
  80061c:	5b                   	pop    %rbx
  80061d:	5d                   	pop    %rbp
  80061e:	c3                   	retq   

000000000080061f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80061f:	55                   	push   %rbp
  800620:	48 89 e5             	mov    %rsp,%rbp
  800623:	48 83 ec 1c          	sub    $0x1c,%rsp
  800627:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80062b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80062e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800632:	7e 52                	jle    800686 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800634:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800638:	8b 00                	mov    (%rax),%eax
  80063a:	83 f8 30             	cmp    $0x30,%eax
  80063d:	73 24                	jae    800663 <getuint+0x44>
  80063f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800643:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800647:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064b:	8b 00                	mov    (%rax),%eax
  80064d:	89 c0                	mov    %eax,%eax
  80064f:	48 01 d0             	add    %rdx,%rax
  800652:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800656:	8b 12                	mov    (%rdx),%edx
  800658:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80065b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065f:	89 0a                	mov    %ecx,(%rdx)
  800661:	eb 17                	jmp    80067a <getuint+0x5b>
  800663:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800667:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80066b:	48 89 d0             	mov    %rdx,%rax
  80066e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800672:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800676:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80067a:	48 8b 00             	mov    (%rax),%rax
  80067d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800681:	e9 a3 00 00 00       	jmpq   800729 <getuint+0x10a>
	else if (lflag)
  800686:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80068a:	74 4f                	je     8006db <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80068c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800690:	8b 00                	mov    (%rax),%eax
  800692:	83 f8 30             	cmp    $0x30,%eax
  800695:	73 24                	jae    8006bb <getuint+0x9c>
  800697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80069f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a3:	8b 00                	mov    (%rax),%eax
  8006a5:	89 c0                	mov    %eax,%eax
  8006a7:	48 01 d0             	add    %rdx,%rax
  8006aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ae:	8b 12                	mov    (%rdx),%edx
  8006b0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b7:	89 0a                	mov    %ecx,(%rdx)
  8006b9:	eb 17                	jmp    8006d2 <getuint+0xb3>
  8006bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006c3:	48 89 d0             	mov    %rdx,%rax
  8006c6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ce:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006d2:	48 8b 00             	mov    (%rax),%rax
  8006d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006d9:	eb 4e                	jmp    800729 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006df:	8b 00                	mov    (%rax),%eax
  8006e1:	83 f8 30             	cmp    $0x30,%eax
  8006e4:	73 24                	jae    80070a <getuint+0xeb>
  8006e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ea:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f2:	8b 00                	mov    (%rax),%eax
  8006f4:	89 c0                	mov    %eax,%eax
  8006f6:	48 01 d0             	add    %rdx,%rax
  8006f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fd:	8b 12                	mov    (%rdx),%edx
  8006ff:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800702:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800706:	89 0a                	mov    %ecx,(%rdx)
  800708:	eb 17                	jmp    800721 <getuint+0x102>
  80070a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800712:	48 89 d0             	mov    %rdx,%rax
  800715:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800719:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800721:	8b 00                	mov    (%rax),%eax
  800723:	89 c0                	mov    %eax,%eax
  800725:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800729:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80072d:	c9                   	leaveq 
  80072e:	c3                   	retq   

000000000080072f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80072f:	55                   	push   %rbp
  800730:	48 89 e5             	mov    %rsp,%rbp
  800733:	48 83 ec 1c          	sub    $0x1c,%rsp
  800737:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80073b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80073e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800742:	7e 52                	jle    800796 <getint+0x67>
		x=va_arg(*ap, long long);
  800744:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800748:	8b 00                	mov    (%rax),%eax
  80074a:	83 f8 30             	cmp    $0x30,%eax
  80074d:	73 24                	jae    800773 <getint+0x44>
  80074f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800753:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800757:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075b:	8b 00                	mov    (%rax),%eax
  80075d:	89 c0                	mov    %eax,%eax
  80075f:	48 01 d0             	add    %rdx,%rax
  800762:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800766:	8b 12                	mov    (%rdx),%edx
  800768:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80076b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076f:	89 0a                	mov    %ecx,(%rdx)
  800771:	eb 17                	jmp    80078a <getint+0x5b>
  800773:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800777:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80077b:	48 89 d0             	mov    %rdx,%rax
  80077e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800782:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800786:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80078a:	48 8b 00             	mov    (%rax),%rax
  80078d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800791:	e9 a3 00 00 00       	jmpq   800839 <getint+0x10a>
	else if (lflag)
  800796:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80079a:	74 4f                	je     8007eb <getint+0xbc>
		x=va_arg(*ap, long);
  80079c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a0:	8b 00                	mov    (%rax),%eax
  8007a2:	83 f8 30             	cmp    $0x30,%eax
  8007a5:	73 24                	jae    8007cb <getint+0x9c>
  8007a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ab:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b3:	8b 00                	mov    (%rax),%eax
  8007b5:	89 c0                	mov    %eax,%eax
  8007b7:	48 01 d0             	add    %rdx,%rax
  8007ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007be:	8b 12                	mov    (%rdx),%edx
  8007c0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c7:	89 0a                	mov    %ecx,(%rdx)
  8007c9:	eb 17                	jmp    8007e2 <getint+0xb3>
  8007cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007d3:	48 89 d0             	mov    %rdx,%rax
  8007d6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007de:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007e2:	48 8b 00             	mov    (%rax),%rax
  8007e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007e9:	eb 4e                	jmp    800839 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ef:	8b 00                	mov    (%rax),%eax
  8007f1:	83 f8 30             	cmp    $0x30,%eax
  8007f4:	73 24                	jae    80081a <getint+0xeb>
  8007f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fa:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800802:	8b 00                	mov    (%rax),%eax
  800804:	89 c0                	mov    %eax,%eax
  800806:	48 01 d0             	add    %rdx,%rax
  800809:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080d:	8b 12                	mov    (%rdx),%edx
  80080f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800812:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800816:	89 0a                	mov    %ecx,(%rdx)
  800818:	eb 17                	jmp    800831 <getint+0x102>
  80081a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800822:	48 89 d0             	mov    %rdx,%rax
  800825:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800829:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800831:	8b 00                	mov    (%rax),%eax
  800833:	48 98                	cltq   
  800835:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800839:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80083d:	c9                   	leaveq 
  80083e:	c3                   	retq   

000000000080083f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80083f:	55                   	push   %rbp
  800840:	48 89 e5             	mov    %rsp,%rbp
  800843:	41 54                	push   %r12
  800845:	53                   	push   %rbx
  800846:	48 83 ec 60          	sub    $0x60,%rsp
  80084a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80084e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800852:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800856:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80085a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80085e:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800862:	48 8b 0a             	mov    (%rdx),%rcx
  800865:	48 89 08             	mov    %rcx,(%rax)
  800868:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80086c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800870:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800874:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800878:	eb 17                	jmp    800891 <vprintfmt+0x52>
			if (ch == '\0')
  80087a:	85 db                	test   %ebx,%ebx
  80087c:	0f 84 cc 04 00 00    	je     800d4e <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800882:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800886:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80088a:	48 89 d6             	mov    %rdx,%rsi
  80088d:	89 df                	mov    %ebx,%edi
  80088f:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800891:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800895:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800899:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80089d:	0f b6 00             	movzbl (%rax),%eax
  8008a0:	0f b6 d8             	movzbl %al,%ebx
  8008a3:	83 fb 25             	cmp    $0x25,%ebx
  8008a6:	75 d2                	jne    80087a <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008a8:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008ac:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008b3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008ba:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008c1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008c8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008cc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008d0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008d4:	0f b6 00             	movzbl (%rax),%eax
  8008d7:	0f b6 d8             	movzbl %al,%ebx
  8008da:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008dd:	83 f8 55             	cmp    $0x55,%eax
  8008e0:	0f 87 34 04 00 00    	ja     800d1a <vprintfmt+0x4db>
  8008e6:	89 c0                	mov    %eax,%eax
  8008e8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008ef:	00 
  8008f0:	48 b8 78 44 80 00 00 	movabs $0x804478,%rax
  8008f7:	00 00 00 
  8008fa:	48 01 d0             	add    %rdx,%rax
  8008fd:	48 8b 00             	mov    (%rax),%rax
  800900:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800902:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800906:	eb c0                	jmp    8008c8 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800908:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80090c:	eb ba                	jmp    8008c8 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800915:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800918:	89 d0                	mov    %edx,%eax
  80091a:	c1 e0 02             	shl    $0x2,%eax
  80091d:	01 d0                	add    %edx,%eax
  80091f:	01 c0                	add    %eax,%eax
  800921:	01 d8                	add    %ebx,%eax
  800923:	83 e8 30             	sub    $0x30,%eax
  800926:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800929:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80092d:	0f b6 00             	movzbl (%rax),%eax
  800930:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800933:	83 fb 2f             	cmp    $0x2f,%ebx
  800936:	7e 0c                	jle    800944 <vprintfmt+0x105>
  800938:	83 fb 39             	cmp    $0x39,%ebx
  80093b:	7f 07                	jg     800944 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80093d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800942:	eb d1                	jmp    800915 <vprintfmt+0xd6>
			goto process_precision;
  800944:	eb 58                	jmp    80099e <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800946:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800949:	83 f8 30             	cmp    $0x30,%eax
  80094c:	73 17                	jae    800965 <vprintfmt+0x126>
  80094e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800952:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800955:	89 c0                	mov    %eax,%eax
  800957:	48 01 d0             	add    %rdx,%rax
  80095a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80095d:	83 c2 08             	add    $0x8,%edx
  800960:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800963:	eb 0f                	jmp    800974 <vprintfmt+0x135>
  800965:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800969:	48 89 d0             	mov    %rdx,%rax
  80096c:	48 83 c2 08          	add    $0x8,%rdx
  800970:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800974:	8b 00                	mov    (%rax),%eax
  800976:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800979:	eb 23                	jmp    80099e <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80097b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80097f:	79 0c                	jns    80098d <vprintfmt+0x14e>
				width = 0;
  800981:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800988:	e9 3b ff ff ff       	jmpq   8008c8 <vprintfmt+0x89>
  80098d:	e9 36 ff ff ff       	jmpq   8008c8 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800992:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800999:	e9 2a ff ff ff       	jmpq   8008c8 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80099e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009a2:	79 12                	jns    8009b6 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009a4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009a7:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009aa:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009b1:	e9 12 ff ff ff       	jmpq   8008c8 <vprintfmt+0x89>
  8009b6:	e9 0d ff ff ff       	jmpq   8008c8 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009bb:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009bf:	e9 04 ff ff ff       	jmpq   8008c8 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009c4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c7:	83 f8 30             	cmp    $0x30,%eax
  8009ca:	73 17                	jae    8009e3 <vprintfmt+0x1a4>
  8009cc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009d0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d3:	89 c0                	mov    %eax,%eax
  8009d5:	48 01 d0             	add    %rdx,%rax
  8009d8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009db:	83 c2 08             	add    $0x8,%edx
  8009de:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009e1:	eb 0f                	jmp    8009f2 <vprintfmt+0x1b3>
  8009e3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009e7:	48 89 d0             	mov    %rdx,%rax
  8009ea:	48 83 c2 08          	add    $0x8,%rdx
  8009ee:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009f2:	8b 10                	mov    (%rax),%edx
  8009f4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009f8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009fc:	48 89 ce             	mov    %rcx,%rsi
  8009ff:	89 d7                	mov    %edx,%edi
  800a01:	ff d0                	callq  *%rax
			break;
  800a03:	e9 40 03 00 00       	jmpq   800d48 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a08:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0b:	83 f8 30             	cmp    $0x30,%eax
  800a0e:	73 17                	jae    800a27 <vprintfmt+0x1e8>
  800a10:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a14:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a17:	89 c0                	mov    %eax,%eax
  800a19:	48 01 d0             	add    %rdx,%rax
  800a1c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a1f:	83 c2 08             	add    $0x8,%edx
  800a22:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a25:	eb 0f                	jmp    800a36 <vprintfmt+0x1f7>
  800a27:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a2b:	48 89 d0             	mov    %rdx,%rax
  800a2e:	48 83 c2 08          	add    $0x8,%rdx
  800a32:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a36:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a38:	85 db                	test   %ebx,%ebx
  800a3a:	79 02                	jns    800a3e <vprintfmt+0x1ff>
				err = -err;
  800a3c:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a3e:	83 fb 15             	cmp    $0x15,%ebx
  800a41:	7f 16                	jg     800a59 <vprintfmt+0x21a>
  800a43:	48 b8 a0 43 80 00 00 	movabs $0x8043a0,%rax
  800a4a:	00 00 00 
  800a4d:	48 63 d3             	movslq %ebx,%rdx
  800a50:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a54:	4d 85 e4             	test   %r12,%r12
  800a57:	75 2e                	jne    800a87 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a59:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a61:	89 d9                	mov    %ebx,%ecx
  800a63:	48 ba 61 44 80 00 00 	movabs $0x804461,%rdx
  800a6a:	00 00 00 
  800a6d:	48 89 c7             	mov    %rax,%rdi
  800a70:	b8 00 00 00 00       	mov    $0x0,%eax
  800a75:	49 b8 57 0d 80 00 00 	movabs $0x800d57,%r8
  800a7c:	00 00 00 
  800a7f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a82:	e9 c1 02 00 00       	jmpq   800d48 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a87:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a8b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a8f:	4c 89 e1             	mov    %r12,%rcx
  800a92:	48 ba 6a 44 80 00 00 	movabs $0x80446a,%rdx
  800a99:	00 00 00 
  800a9c:	48 89 c7             	mov    %rax,%rdi
  800a9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa4:	49 b8 57 0d 80 00 00 	movabs $0x800d57,%r8
  800aab:	00 00 00 
  800aae:	41 ff d0             	callq  *%r8
			break;
  800ab1:	e9 92 02 00 00       	jmpq   800d48 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ab6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab9:	83 f8 30             	cmp    $0x30,%eax
  800abc:	73 17                	jae    800ad5 <vprintfmt+0x296>
  800abe:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ac2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac5:	89 c0                	mov    %eax,%eax
  800ac7:	48 01 d0             	add    %rdx,%rax
  800aca:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800acd:	83 c2 08             	add    $0x8,%edx
  800ad0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ad3:	eb 0f                	jmp    800ae4 <vprintfmt+0x2a5>
  800ad5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ad9:	48 89 d0             	mov    %rdx,%rax
  800adc:	48 83 c2 08          	add    $0x8,%rdx
  800ae0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ae4:	4c 8b 20             	mov    (%rax),%r12
  800ae7:	4d 85 e4             	test   %r12,%r12
  800aea:	75 0a                	jne    800af6 <vprintfmt+0x2b7>
				p = "(null)";
  800aec:	49 bc 6d 44 80 00 00 	movabs $0x80446d,%r12
  800af3:	00 00 00 
			if (width > 0 && padc != '-')
  800af6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800afa:	7e 3f                	jle    800b3b <vprintfmt+0x2fc>
  800afc:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b00:	74 39                	je     800b3b <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b02:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b05:	48 98                	cltq   
  800b07:	48 89 c6             	mov    %rax,%rsi
  800b0a:	4c 89 e7             	mov    %r12,%rdi
  800b0d:	48 b8 03 10 80 00 00 	movabs $0x801003,%rax
  800b14:	00 00 00 
  800b17:	ff d0                	callq  *%rax
  800b19:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b1c:	eb 17                	jmp    800b35 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b1e:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b22:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b2a:	48 89 ce             	mov    %rcx,%rsi
  800b2d:	89 d7                	mov    %edx,%edi
  800b2f:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b31:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b35:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b39:	7f e3                	jg     800b1e <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b3b:	eb 37                	jmp    800b74 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b3d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b41:	74 1e                	je     800b61 <vprintfmt+0x322>
  800b43:	83 fb 1f             	cmp    $0x1f,%ebx
  800b46:	7e 05                	jle    800b4d <vprintfmt+0x30e>
  800b48:	83 fb 7e             	cmp    $0x7e,%ebx
  800b4b:	7e 14                	jle    800b61 <vprintfmt+0x322>
					putch('?', putdat);
  800b4d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b51:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b55:	48 89 d6             	mov    %rdx,%rsi
  800b58:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b5d:	ff d0                	callq  *%rax
  800b5f:	eb 0f                	jmp    800b70 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b61:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b65:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b69:	48 89 d6             	mov    %rdx,%rsi
  800b6c:	89 df                	mov    %ebx,%edi
  800b6e:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b70:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b74:	4c 89 e0             	mov    %r12,%rax
  800b77:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b7b:	0f b6 00             	movzbl (%rax),%eax
  800b7e:	0f be d8             	movsbl %al,%ebx
  800b81:	85 db                	test   %ebx,%ebx
  800b83:	74 10                	je     800b95 <vprintfmt+0x356>
  800b85:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b89:	78 b2                	js     800b3d <vprintfmt+0x2fe>
  800b8b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b8f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b93:	79 a8                	jns    800b3d <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b95:	eb 16                	jmp    800bad <vprintfmt+0x36e>
				putch(' ', putdat);
  800b97:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b9b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9f:	48 89 d6             	mov    %rdx,%rsi
  800ba2:	bf 20 00 00 00       	mov    $0x20,%edi
  800ba7:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bad:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bb1:	7f e4                	jg     800b97 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bb3:	e9 90 01 00 00       	jmpq   800d48 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bb8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bbc:	be 03 00 00 00       	mov    $0x3,%esi
  800bc1:	48 89 c7             	mov    %rax,%rdi
  800bc4:	48 b8 2f 07 80 00 00 	movabs $0x80072f,%rax
  800bcb:	00 00 00 
  800bce:	ff d0                	callq  *%rax
  800bd0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bd8:	48 85 c0             	test   %rax,%rax
  800bdb:	79 1d                	jns    800bfa <vprintfmt+0x3bb>
				putch('-', putdat);
  800bdd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800be1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be5:	48 89 d6             	mov    %rdx,%rsi
  800be8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bed:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf3:	48 f7 d8             	neg    %rax
  800bf6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bfa:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c01:	e9 d5 00 00 00       	jmpq   800cdb <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c06:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c0a:	be 03 00 00 00       	mov    $0x3,%esi
  800c0f:	48 89 c7             	mov    %rax,%rdi
  800c12:	48 b8 1f 06 80 00 00 	movabs $0x80061f,%rax
  800c19:	00 00 00 
  800c1c:	ff d0                	callq  *%rax
  800c1e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c22:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c29:	e9 ad 00 00 00       	jmpq   800cdb <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800c2e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c32:	be 03 00 00 00       	mov    $0x3,%esi
  800c37:	48 89 c7             	mov    %rax,%rdi
  800c3a:	48 b8 1f 06 80 00 00 	movabs $0x80061f,%rax
  800c41:	00 00 00 
  800c44:	ff d0                	callq  *%rax
  800c46:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800c4a:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c51:	e9 85 00 00 00       	jmpq   800cdb <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800c56:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c5a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5e:	48 89 d6             	mov    %rdx,%rsi
  800c61:	bf 30 00 00 00       	mov    $0x30,%edi
  800c66:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c68:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c6c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c70:	48 89 d6             	mov    %rdx,%rsi
  800c73:	bf 78 00 00 00       	mov    $0x78,%edi
  800c78:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c7a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7d:	83 f8 30             	cmp    $0x30,%eax
  800c80:	73 17                	jae    800c99 <vprintfmt+0x45a>
  800c82:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c86:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c89:	89 c0                	mov    %eax,%eax
  800c8b:	48 01 d0             	add    %rdx,%rax
  800c8e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c91:	83 c2 08             	add    $0x8,%edx
  800c94:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c97:	eb 0f                	jmp    800ca8 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800c99:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c9d:	48 89 d0             	mov    %rdx,%rax
  800ca0:	48 83 c2 08          	add    $0x8,%rdx
  800ca4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ca8:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800caf:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cb6:	eb 23                	jmp    800cdb <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cb8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cbc:	be 03 00 00 00       	mov    $0x3,%esi
  800cc1:	48 89 c7             	mov    %rax,%rdi
  800cc4:	48 b8 1f 06 80 00 00 	movabs $0x80061f,%rax
  800ccb:	00 00 00 
  800cce:	ff d0                	callq  *%rax
  800cd0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cd4:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cdb:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ce0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ce3:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ce6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cea:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf2:	45 89 c1             	mov    %r8d,%r9d
  800cf5:	41 89 f8             	mov    %edi,%r8d
  800cf8:	48 89 c7             	mov    %rax,%rdi
  800cfb:	48 b8 64 05 80 00 00 	movabs $0x800564,%rax
  800d02:	00 00 00 
  800d05:	ff d0                	callq  *%rax
			break;
  800d07:	eb 3f                	jmp    800d48 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d09:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d0d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d11:	48 89 d6             	mov    %rdx,%rsi
  800d14:	89 df                	mov    %ebx,%edi
  800d16:	ff d0                	callq  *%rax
			break;
  800d18:	eb 2e                	jmp    800d48 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d1a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d1e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d22:	48 89 d6             	mov    %rdx,%rsi
  800d25:	bf 25 00 00 00       	mov    $0x25,%edi
  800d2a:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d2c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d31:	eb 05                	jmp    800d38 <vprintfmt+0x4f9>
  800d33:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d38:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d3c:	48 83 e8 01          	sub    $0x1,%rax
  800d40:	0f b6 00             	movzbl (%rax),%eax
  800d43:	3c 25                	cmp    $0x25,%al
  800d45:	75 ec                	jne    800d33 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800d47:	90                   	nop
		}
	}
  800d48:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d49:	e9 43 fb ff ff       	jmpq   800891 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d4e:	48 83 c4 60          	add    $0x60,%rsp
  800d52:	5b                   	pop    %rbx
  800d53:	41 5c                	pop    %r12
  800d55:	5d                   	pop    %rbp
  800d56:	c3                   	retq   

0000000000800d57 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d57:	55                   	push   %rbp
  800d58:	48 89 e5             	mov    %rsp,%rbp
  800d5b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d62:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d69:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d70:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d77:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d7e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d85:	84 c0                	test   %al,%al
  800d87:	74 20                	je     800da9 <printfmt+0x52>
  800d89:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d8d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d91:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d95:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d99:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d9d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800da1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800da5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800da9:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800db0:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800db7:	00 00 00 
  800dba:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800dc1:	00 00 00 
  800dc4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dc8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800dcf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dd6:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ddd:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800de4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800deb:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800df2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800df9:	48 89 c7             	mov    %rax,%rdi
  800dfc:	48 b8 3f 08 80 00 00 	movabs $0x80083f,%rax
  800e03:	00 00 00 
  800e06:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e08:	c9                   	leaveq 
  800e09:	c3                   	retq   

0000000000800e0a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e0a:	55                   	push   %rbp
  800e0b:	48 89 e5             	mov    %rsp,%rbp
  800e0e:	48 83 ec 10          	sub    $0x10,%rsp
  800e12:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e15:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e1d:	8b 40 10             	mov    0x10(%rax),%eax
  800e20:	8d 50 01             	lea    0x1(%rax),%edx
  800e23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e27:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2e:	48 8b 10             	mov    (%rax),%rdx
  800e31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e35:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e39:	48 39 c2             	cmp    %rax,%rdx
  800e3c:	73 17                	jae    800e55 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e42:	48 8b 00             	mov    (%rax),%rax
  800e45:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e49:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e4d:	48 89 0a             	mov    %rcx,(%rdx)
  800e50:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e53:	88 10                	mov    %dl,(%rax)
}
  800e55:	c9                   	leaveq 
  800e56:	c3                   	retq   

0000000000800e57 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e57:	55                   	push   %rbp
  800e58:	48 89 e5             	mov    %rsp,%rbp
  800e5b:	48 83 ec 50          	sub    $0x50,%rsp
  800e5f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e63:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e66:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e6a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e6e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e72:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e76:	48 8b 0a             	mov    (%rdx),%rcx
  800e79:	48 89 08             	mov    %rcx,(%rax)
  800e7c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e80:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e84:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e88:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e8c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e90:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e94:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e97:	48 98                	cltq   
  800e99:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e9d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ea1:	48 01 d0             	add    %rdx,%rax
  800ea4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ea8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800eaf:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800eb4:	74 06                	je     800ebc <vsnprintf+0x65>
  800eb6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800eba:	7f 07                	jg     800ec3 <vsnprintf+0x6c>
		return -E_INVAL;
  800ebc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ec1:	eb 2f                	jmp    800ef2 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ec3:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ec7:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ecb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ecf:	48 89 c6             	mov    %rax,%rsi
  800ed2:	48 bf 0a 0e 80 00 00 	movabs $0x800e0a,%rdi
  800ed9:	00 00 00 
  800edc:	48 b8 3f 08 80 00 00 	movabs $0x80083f,%rax
  800ee3:	00 00 00 
  800ee6:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ee8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800eec:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800eef:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ef2:	c9                   	leaveq 
  800ef3:	c3                   	retq   

0000000000800ef4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ef4:	55                   	push   %rbp
  800ef5:	48 89 e5             	mov    %rsp,%rbp
  800ef8:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800eff:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f06:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f0c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f13:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f1a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f21:	84 c0                	test   %al,%al
  800f23:	74 20                	je     800f45 <snprintf+0x51>
  800f25:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f29:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f2d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f31:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f35:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f39:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f3d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f41:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f45:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f4c:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f53:	00 00 00 
  800f56:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f5d:	00 00 00 
  800f60:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f64:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f6b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f72:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f79:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f80:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f87:	48 8b 0a             	mov    (%rdx),%rcx
  800f8a:	48 89 08             	mov    %rcx,(%rax)
  800f8d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f91:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f95:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f99:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f9d:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fa4:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fab:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fb1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fb8:	48 89 c7             	mov    %rax,%rdi
  800fbb:	48 b8 57 0e 80 00 00 	movabs $0x800e57,%rax
  800fc2:	00 00 00 
  800fc5:	ff d0                	callq  *%rax
  800fc7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fcd:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fd3:	c9                   	leaveq 
  800fd4:	c3                   	retq   

0000000000800fd5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fd5:	55                   	push   %rbp
  800fd6:	48 89 e5             	mov    %rsp,%rbp
  800fd9:	48 83 ec 18          	sub    $0x18,%rsp
  800fdd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fe1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fe8:	eb 09                	jmp    800ff3 <strlen+0x1e>
		n++;
  800fea:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fee:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ff3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff7:	0f b6 00             	movzbl (%rax),%eax
  800ffa:	84 c0                	test   %al,%al
  800ffc:	75 ec                	jne    800fea <strlen+0x15>
		n++;
	return n;
  800ffe:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801001:	c9                   	leaveq 
  801002:	c3                   	retq   

0000000000801003 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801003:	55                   	push   %rbp
  801004:	48 89 e5             	mov    %rsp,%rbp
  801007:	48 83 ec 20          	sub    $0x20,%rsp
  80100b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80100f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801013:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80101a:	eb 0e                	jmp    80102a <strnlen+0x27>
		n++;
  80101c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801020:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801025:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80102a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80102f:	74 0b                	je     80103c <strnlen+0x39>
  801031:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801035:	0f b6 00             	movzbl (%rax),%eax
  801038:	84 c0                	test   %al,%al
  80103a:	75 e0                	jne    80101c <strnlen+0x19>
		n++;
	return n;
  80103c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80103f:	c9                   	leaveq 
  801040:	c3                   	retq   

0000000000801041 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801041:	55                   	push   %rbp
  801042:	48 89 e5             	mov    %rsp,%rbp
  801045:	48 83 ec 20          	sub    $0x20,%rsp
  801049:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80104d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801051:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801055:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801059:	90                   	nop
  80105a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80105e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801062:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801066:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80106a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80106e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801072:	0f b6 12             	movzbl (%rdx),%edx
  801075:	88 10                	mov    %dl,(%rax)
  801077:	0f b6 00             	movzbl (%rax),%eax
  80107a:	84 c0                	test   %al,%al
  80107c:	75 dc                	jne    80105a <strcpy+0x19>
		/* do nothing */;
	return ret;
  80107e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801082:	c9                   	leaveq 
  801083:	c3                   	retq   

0000000000801084 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801084:	55                   	push   %rbp
  801085:	48 89 e5             	mov    %rsp,%rbp
  801088:	48 83 ec 20          	sub    $0x20,%rsp
  80108c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801090:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801094:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801098:	48 89 c7             	mov    %rax,%rdi
  80109b:	48 b8 d5 0f 80 00 00 	movabs $0x800fd5,%rax
  8010a2:	00 00 00 
  8010a5:	ff d0                	callq  *%rax
  8010a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ad:	48 63 d0             	movslq %eax,%rdx
  8010b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b4:	48 01 c2             	add    %rax,%rdx
  8010b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010bb:	48 89 c6             	mov    %rax,%rsi
  8010be:	48 89 d7             	mov    %rdx,%rdi
  8010c1:	48 b8 41 10 80 00 00 	movabs $0x801041,%rax
  8010c8:	00 00 00 
  8010cb:	ff d0                	callq  *%rax
	return dst;
  8010cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010d1:	c9                   	leaveq 
  8010d2:	c3                   	retq   

00000000008010d3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010d3:	55                   	push   %rbp
  8010d4:	48 89 e5             	mov    %rsp,%rbp
  8010d7:	48 83 ec 28          	sub    $0x28,%rsp
  8010db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010eb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010ef:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010f6:	00 
  8010f7:	eb 2a                	jmp    801123 <strncpy+0x50>
		*dst++ = *src;
  8010f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801101:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801105:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801109:	0f b6 12             	movzbl (%rdx),%edx
  80110c:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80110e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801112:	0f b6 00             	movzbl (%rax),%eax
  801115:	84 c0                	test   %al,%al
  801117:	74 05                	je     80111e <strncpy+0x4b>
			src++;
  801119:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80111e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801123:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801127:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80112b:	72 cc                	jb     8010f9 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80112d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801131:	c9                   	leaveq 
  801132:	c3                   	retq   

0000000000801133 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801133:	55                   	push   %rbp
  801134:	48 89 e5             	mov    %rsp,%rbp
  801137:	48 83 ec 28          	sub    $0x28,%rsp
  80113b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80113f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801143:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801147:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80114f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801154:	74 3d                	je     801193 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801156:	eb 1d                	jmp    801175 <strlcpy+0x42>
			*dst++ = *src++;
  801158:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801160:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801164:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801168:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80116c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801170:	0f b6 12             	movzbl (%rdx),%edx
  801173:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801175:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80117a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80117f:	74 0b                	je     80118c <strlcpy+0x59>
  801181:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801185:	0f b6 00             	movzbl (%rax),%eax
  801188:	84 c0                	test   %al,%al
  80118a:	75 cc                	jne    801158 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80118c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801190:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801193:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801197:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119b:	48 29 c2             	sub    %rax,%rdx
  80119e:	48 89 d0             	mov    %rdx,%rax
}
  8011a1:	c9                   	leaveq 
  8011a2:	c3                   	retq   

00000000008011a3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011a3:	55                   	push   %rbp
  8011a4:	48 89 e5             	mov    %rsp,%rbp
  8011a7:	48 83 ec 10          	sub    $0x10,%rsp
  8011ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011b3:	eb 0a                	jmp    8011bf <strcmp+0x1c>
		p++, q++;
  8011b5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011ba:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c3:	0f b6 00             	movzbl (%rax),%eax
  8011c6:	84 c0                	test   %al,%al
  8011c8:	74 12                	je     8011dc <strcmp+0x39>
  8011ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ce:	0f b6 10             	movzbl (%rax),%edx
  8011d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d5:	0f b6 00             	movzbl (%rax),%eax
  8011d8:	38 c2                	cmp    %al,%dl
  8011da:	74 d9                	je     8011b5 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e0:	0f b6 00             	movzbl (%rax),%eax
  8011e3:	0f b6 d0             	movzbl %al,%edx
  8011e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ea:	0f b6 00             	movzbl (%rax),%eax
  8011ed:	0f b6 c0             	movzbl %al,%eax
  8011f0:	29 c2                	sub    %eax,%edx
  8011f2:	89 d0                	mov    %edx,%eax
}
  8011f4:	c9                   	leaveq 
  8011f5:	c3                   	retq   

00000000008011f6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011f6:	55                   	push   %rbp
  8011f7:	48 89 e5             	mov    %rsp,%rbp
  8011fa:	48 83 ec 18          	sub    $0x18,%rsp
  8011fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801202:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801206:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80120a:	eb 0f                	jmp    80121b <strncmp+0x25>
		n--, p++, q++;
  80120c:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801211:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801216:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80121b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801220:	74 1d                	je     80123f <strncmp+0x49>
  801222:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801226:	0f b6 00             	movzbl (%rax),%eax
  801229:	84 c0                	test   %al,%al
  80122b:	74 12                	je     80123f <strncmp+0x49>
  80122d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801231:	0f b6 10             	movzbl (%rax),%edx
  801234:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801238:	0f b6 00             	movzbl (%rax),%eax
  80123b:	38 c2                	cmp    %al,%dl
  80123d:	74 cd                	je     80120c <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80123f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801244:	75 07                	jne    80124d <strncmp+0x57>
		return 0;
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
  80124b:	eb 18                	jmp    801265 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80124d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801251:	0f b6 00             	movzbl (%rax),%eax
  801254:	0f b6 d0             	movzbl %al,%edx
  801257:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80125b:	0f b6 00             	movzbl (%rax),%eax
  80125e:	0f b6 c0             	movzbl %al,%eax
  801261:	29 c2                	sub    %eax,%edx
  801263:	89 d0                	mov    %edx,%eax
}
  801265:	c9                   	leaveq 
  801266:	c3                   	retq   

0000000000801267 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801267:	55                   	push   %rbp
  801268:	48 89 e5             	mov    %rsp,%rbp
  80126b:	48 83 ec 0c          	sub    $0xc,%rsp
  80126f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801273:	89 f0                	mov    %esi,%eax
  801275:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801278:	eb 17                	jmp    801291 <strchr+0x2a>
		if (*s == c)
  80127a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127e:	0f b6 00             	movzbl (%rax),%eax
  801281:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801284:	75 06                	jne    80128c <strchr+0x25>
			return (char *) s;
  801286:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128a:	eb 15                	jmp    8012a1 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80128c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801291:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801295:	0f b6 00             	movzbl (%rax),%eax
  801298:	84 c0                	test   %al,%al
  80129a:	75 de                	jne    80127a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80129c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012a1:	c9                   	leaveq 
  8012a2:	c3                   	retq   

00000000008012a3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012a3:	55                   	push   %rbp
  8012a4:	48 89 e5             	mov    %rsp,%rbp
  8012a7:	48 83 ec 0c          	sub    $0xc,%rsp
  8012ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012af:	89 f0                	mov    %esi,%eax
  8012b1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012b4:	eb 13                	jmp    8012c9 <strfind+0x26>
		if (*s == c)
  8012b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ba:	0f b6 00             	movzbl (%rax),%eax
  8012bd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012c0:	75 02                	jne    8012c4 <strfind+0x21>
			break;
  8012c2:	eb 10                	jmp    8012d4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012c4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cd:	0f b6 00             	movzbl (%rax),%eax
  8012d0:	84 c0                	test   %al,%al
  8012d2:	75 e2                	jne    8012b6 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012d8:	c9                   	leaveq 
  8012d9:	c3                   	retq   

00000000008012da <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012da:	55                   	push   %rbp
  8012db:	48 89 e5             	mov    %rsp,%rbp
  8012de:	48 83 ec 18          	sub    $0x18,%rsp
  8012e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e6:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012e9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012ed:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012f2:	75 06                	jne    8012fa <memset+0x20>
		return v;
  8012f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f8:	eb 69                	jmp    801363 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fe:	83 e0 03             	and    $0x3,%eax
  801301:	48 85 c0             	test   %rax,%rax
  801304:	75 48                	jne    80134e <memset+0x74>
  801306:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130a:	83 e0 03             	and    $0x3,%eax
  80130d:	48 85 c0             	test   %rax,%rax
  801310:	75 3c                	jne    80134e <memset+0x74>
		c &= 0xFF;
  801312:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801319:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80131c:	c1 e0 18             	shl    $0x18,%eax
  80131f:	89 c2                	mov    %eax,%edx
  801321:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801324:	c1 e0 10             	shl    $0x10,%eax
  801327:	09 c2                	or     %eax,%edx
  801329:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80132c:	c1 e0 08             	shl    $0x8,%eax
  80132f:	09 d0                	or     %edx,%eax
  801331:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801334:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801338:	48 c1 e8 02          	shr    $0x2,%rax
  80133c:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80133f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801343:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801346:	48 89 d7             	mov    %rdx,%rdi
  801349:	fc                   	cld    
  80134a:	f3 ab                	rep stos %eax,%es:(%rdi)
  80134c:	eb 11                	jmp    80135f <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80134e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801352:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801355:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801359:	48 89 d7             	mov    %rdx,%rdi
  80135c:	fc                   	cld    
  80135d:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80135f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801363:	c9                   	leaveq 
  801364:	c3                   	retq   

0000000000801365 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801365:	55                   	push   %rbp
  801366:	48 89 e5             	mov    %rsp,%rbp
  801369:	48 83 ec 28          	sub    $0x28,%rsp
  80136d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801371:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801375:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801379:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80137d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801381:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801385:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801389:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801391:	0f 83 88 00 00 00    	jae    80141f <memmove+0xba>
  801397:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80139f:	48 01 d0             	add    %rdx,%rax
  8013a2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013a6:	76 77                	jbe    80141f <memmove+0xba>
		s += n;
  8013a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ac:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b4:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bc:	83 e0 03             	and    $0x3,%eax
  8013bf:	48 85 c0             	test   %rax,%rax
  8013c2:	75 3b                	jne    8013ff <memmove+0x9a>
  8013c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c8:	83 e0 03             	and    $0x3,%eax
  8013cb:	48 85 c0             	test   %rax,%rax
  8013ce:	75 2f                	jne    8013ff <memmove+0x9a>
  8013d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d4:	83 e0 03             	and    $0x3,%eax
  8013d7:	48 85 c0             	test   %rax,%rax
  8013da:	75 23                	jne    8013ff <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e0:	48 83 e8 04          	sub    $0x4,%rax
  8013e4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013e8:	48 83 ea 04          	sub    $0x4,%rdx
  8013ec:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013f0:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013f4:	48 89 c7             	mov    %rax,%rdi
  8013f7:	48 89 d6             	mov    %rdx,%rsi
  8013fa:	fd                   	std    
  8013fb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013fd:	eb 1d                	jmp    80141c <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801403:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801407:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140b:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80140f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801413:	48 89 d7             	mov    %rdx,%rdi
  801416:	48 89 c1             	mov    %rax,%rcx
  801419:	fd                   	std    
  80141a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80141c:	fc                   	cld    
  80141d:	eb 57                	jmp    801476 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80141f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801423:	83 e0 03             	and    $0x3,%eax
  801426:	48 85 c0             	test   %rax,%rax
  801429:	75 36                	jne    801461 <memmove+0xfc>
  80142b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142f:	83 e0 03             	and    $0x3,%eax
  801432:	48 85 c0             	test   %rax,%rax
  801435:	75 2a                	jne    801461 <memmove+0xfc>
  801437:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143b:	83 e0 03             	and    $0x3,%eax
  80143e:	48 85 c0             	test   %rax,%rax
  801441:	75 1e                	jne    801461 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801443:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801447:	48 c1 e8 02          	shr    $0x2,%rax
  80144b:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80144e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801452:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801456:	48 89 c7             	mov    %rax,%rdi
  801459:	48 89 d6             	mov    %rdx,%rsi
  80145c:	fc                   	cld    
  80145d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80145f:	eb 15                	jmp    801476 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801461:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801465:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801469:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80146d:	48 89 c7             	mov    %rax,%rdi
  801470:	48 89 d6             	mov    %rdx,%rsi
  801473:	fc                   	cld    
  801474:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801476:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80147a:	c9                   	leaveq 
  80147b:	c3                   	retq   

000000000080147c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80147c:	55                   	push   %rbp
  80147d:	48 89 e5             	mov    %rsp,%rbp
  801480:	48 83 ec 18          	sub    $0x18,%rsp
  801484:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801488:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80148c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801490:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801494:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801498:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149c:	48 89 ce             	mov    %rcx,%rsi
  80149f:	48 89 c7             	mov    %rax,%rdi
  8014a2:	48 b8 65 13 80 00 00 	movabs $0x801365,%rax
  8014a9:	00 00 00 
  8014ac:	ff d0                	callq  *%rax
}
  8014ae:	c9                   	leaveq 
  8014af:	c3                   	retq   

00000000008014b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014b0:	55                   	push   %rbp
  8014b1:	48 89 e5             	mov    %rsp,%rbp
  8014b4:	48 83 ec 28          	sub    $0x28,%rsp
  8014b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014d0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014d4:	eb 36                	jmp    80150c <memcmp+0x5c>
		if (*s1 != *s2)
  8014d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014da:	0f b6 10             	movzbl (%rax),%edx
  8014dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e1:	0f b6 00             	movzbl (%rax),%eax
  8014e4:	38 c2                	cmp    %al,%dl
  8014e6:	74 1a                	je     801502 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ec:	0f b6 00             	movzbl (%rax),%eax
  8014ef:	0f b6 d0             	movzbl %al,%edx
  8014f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f6:	0f b6 00             	movzbl (%rax),%eax
  8014f9:	0f b6 c0             	movzbl %al,%eax
  8014fc:	29 c2                	sub    %eax,%edx
  8014fe:	89 d0                	mov    %edx,%eax
  801500:	eb 20                	jmp    801522 <memcmp+0x72>
		s1++, s2++;
  801502:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801507:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80150c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801510:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801514:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801518:	48 85 c0             	test   %rax,%rax
  80151b:	75 b9                	jne    8014d6 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80151d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801522:	c9                   	leaveq 
  801523:	c3                   	retq   

0000000000801524 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801524:	55                   	push   %rbp
  801525:	48 89 e5             	mov    %rsp,%rbp
  801528:	48 83 ec 28          	sub    $0x28,%rsp
  80152c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801530:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801533:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801537:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80153f:	48 01 d0             	add    %rdx,%rax
  801542:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801546:	eb 15                	jmp    80155d <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801548:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80154c:	0f b6 10             	movzbl (%rax),%edx
  80154f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801552:	38 c2                	cmp    %al,%dl
  801554:	75 02                	jne    801558 <memfind+0x34>
			break;
  801556:	eb 0f                	jmp    801567 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801558:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80155d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801561:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801565:	72 e1                	jb     801548 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801567:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80156b:	c9                   	leaveq 
  80156c:	c3                   	retq   

000000000080156d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80156d:	55                   	push   %rbp
  80156e:	48 89 e5             	mov    %rsp,%rbp
  801571:	48 83 ec 34          	sub    $0x34,%rsp
  801575:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801579:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80157d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801580:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801587:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80158e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80158f:	eb 05                	jmp    801596 <strtol+0x29>
		s++;
  801591:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801596:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159a:	0f b6 00             	movzbl (%rax),%eax
  80159d:	3c 20                	cmp    $0x20,%al
  80159f:	74 f0                	je     801591 <strtol+0x24>
  8015a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a5:	0f b6 00             	movzbl (%rax),%eax
  8015a8:	3c 09                	cmp    $0x9,%al
  8015aa:	74 e5                	je     801591 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b0:	0f b6 00             	movzbl (%rax),%eax
  8015b3:	3c 2b                	cmp    $0x2b,%al
  8015b5:	75 07                	jne    8015be <strtol+0x51>
		s++;
  8015b7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015bc:	eb 17                	jmp    8015d5 <strtol+0x68>
	else if (*s == '-')
  8015be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c2:	0f b6 00             	movzbl (%rax),%eax
  8015c5:	3c 2d                	cmp    $0x2d,%al
  8015c7:	75 0c                	jne    8015d5 <strtol+0x68>
		s++, neg = 1;
  8015c9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015d5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015d9:	74 06                	je     8015e1 <strtol+0x74>
  8015db:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015df:	75 28                	jne    801609 <strtol+0x9c>
  8015e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e5:	0f b6 00             	movzbl (%rax),%eax
  8015e8:	3c 30                	cmp    $0x30,%al
  8015ea:	75 1d                	jne    801609 <strtol+0x9c>
  8015ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f0:	48 83 c0 01          	add    $0x1,%rax
  8015f4:	0f b6 00             	movzbl (%rax),%eax
  8015f7:	3c 78                	cmp    $0x78,%al
  8015f9:	75 0e                	jne    801609 <strtol+0x9c>
		s += 2, base = 16;
  8015fb:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801600:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801607:	eb 2c                	jmp    801635 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801609:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80160d:	75 19                	jne    801628 <strtol+0xbb>
  80160f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801613:	0f b6 00             	movzbl (%rax),%eax
  801616:	3c 30                	cmp    $0x30,%al
  801618:	75 0e                	jne    801628 <strtol+0xbb>
		s++, base = 8;
  80161a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80161f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801626:	eb 0d                	jmp    801635 <strtol+0xc8>
	else if (base == 0)
  801628:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80162c:	75 07                	jne    801635 <strtol+0xc8>
		base = 10;
  80162e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801635:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801639:	0f b6 00             	movzbl (%rax),%eax
  80163c:	3c 2f                	cmp    $0x2f,%al
  80163e:	7e 1d                	jle    80165d <strtol+0xf0>
  801640:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801644:	0f b6 00             	movzbl (%rax),%eax
  801647:	3c 39                	cmp    $0x39,%al
  801649:	7f 12                	jg     80165d <strtol+0xf0>
			dig = *s - '0';
  80164b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164f:	0f b6 00             	movzbl (%rax),%eax
  801652:	0f be c0             	movsbl %al,%eax
  801655:	83 e8 30             	sub    $0x30,%eax
  801658:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80165b:	eb 4e                	jmp    8016ab <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80165d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801661:	0f b6 00             	movzbl (%rax),%eax
  801664:	3c 60                	cmp    $0x60,%al
  801666:	7e 1d                	jle    801685 <strtol+0x118>
  801668:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166c:	0f b6 00             	movzbl (%rax),%eax
  80166f:	3c 7a                	cmp    $0x7a,%al
  801671:	7f 12                	jg     801685 <strtol+0x118>
			dig = *s - 'a' + 10;
  801673:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801677:	0f b6 00             	movzbl (%rax),%eax
  80167a:	0f be c0             	movsbl %al,%eax
  80167d:	83 e8 57             	sub    $0x57,%eax
  801680:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801683:	eb 26                	jmp    8016ab <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801685:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801689:	0f b6 00             	movzbl (%rax),%eax
  80168c:	3c 40                	cmp    $0x40,%al
  80168e:	7e 48                	jle    8016d8 <strtol+0x16b>
  801690:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801694:	0f b6 00             	movzbl (%rax),%eax
  801697:	3c 5a                	cmp    $0x5a,%al
  801699:	7f 3d                	jg     8016d8 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80169b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169f:	0f b6 00             	movzbl (%rax),%eax
  8016a2:	0f be c0             	movsbl %al,%eax
  8016a5:	83 e8 37             	sub    $0x37,%eax
  8016a8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016ae:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016b1:	7c 02                	jl     8016b5 <strtol+0x148>
			break;
  8016b3:	eb 23                	jmp    8016d8 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016b5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016ba:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016bd:	48 98                	cltq   
  8016bf:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016c4:	48 89 c2             	mov    %rax,%rdx
  8016c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016ca:	48 98                	cltq   
  8016cc:	48 01 d0             	add    %rdx,%rax
  8016cf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016d3:	e9 5d ff ff ff       	jmpq   801635 <strtol+0xc8>

	if (endptr)
  8016d8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016dd:	74 0b                	je     8016ea <strtol+0x17d>
		*endptr = (char *) s;
  8016df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016e3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016e7:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016ee:	74 09                	je     8016f9 <strtol+0x18c>
  8016f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f4:	48 f7 d8             	neg    %rax
  8016f7:	eb 04                	jmp    8016fd <strtol+0x190>
  8016f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016fd:	c9                   	leaveq 
  8016fe:	c3                   	retq   

00000000008016ff <strstr>:

char * strstr(const char *in, const char *str)
{
  8016ff:	55                   	push   %rbp
  801700:	48 89 e5             	mov    %rsp,%rbp
  801703:	48 83 ec 30          	sub    $0x30,%rsp
  801707:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80170b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80170f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801713:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801717:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80171b:	0f b6 00             	movzbl (%rax),%eax
  80171e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801721:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801725:	75 06                	jne    80172d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801727:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172b:	eb 6b                	jmp    801798 <strstr+0x99>

	len = strlen(str);
  80172d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801731:	48 89 c7             	mov    %rax,%rdi
  801734:	48 b8 d5 0f 80 00 00 	movabs $0x800fd5,%rax
  80173b:	00 00 00 
  80173e:	ff d0                	callq  *%rax
  801740:	48 98                	cltq   
  801742:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801746:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80174e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801752:	0f b6 00             	movzbl (%rax),%eax
  801755:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801758:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80175c:	75 07                	jne    801765 <strstr+0x66>
				return (char *) 0;
  80175e:	b8 00 00 00 00       	mov    $0x0,%eax
  801763:	eb 33                	jmp    801798 <strstr+0x99>
		} while (sc != c);
  801765:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801769:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80176c:	75 d8                	jne    801746 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80176e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801772:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801776:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177a:	48 89 ce             	mov    %rcx,%rsi
  80177d:	48 89 c7             	mov    %rax,%rdi
  801780:	48 b8 f6 11 80 00 00 	movabs $0x8011f6,%rax
  801787:	00 00 00 
  80178a:	ff d0                	callq  *%rax
  80178c:	85 c0                	test   %eax,%eax
  80178e:	75 b6                	jne    801746 <strstr+0x47>

	return (char *) (in - 1);
  801790:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801794:	48 83 e8 01          	sub    $0x1,%rax
}
  801798:	c9                   	leaveq 
  801799:	c3                   	retq   

000000000080179a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80179a:	55                   	push   %rbp
  80179b:	48 89 e5             	mov    %rsp,%rbp
  80179e:	53                   	push   %rbx
  80179f:	48 83 ec 48          	sub    $0x48,%rsp
  8017a3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017a6:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017a9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017ad:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017b1:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017b5:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017b9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017bc:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017c0:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017c4:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017c8:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017cc:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017d0:	4c 89 c3             	mov    %r8,%rbx
  8017d3:	cd 30                	int    $0x30
  8017d5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017d9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017dd:	74 3e                	je     80181d <syscall+0x83>
  8017df:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017e4:	7e 37                	jle    80181d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ea:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017ed:	49 89 d0             	mov    %rdx,%r8
  8017f0:	89 c1                	mov    %eax,%ecx
  8017f2:	48 ba 28 47 80 00 00 	movabs $0x804728,%rdx
  8017f9:	00 00 00 
  8017fc:	be 24 00 00 00       	mov    $0x24,%esi
  801801:	48 bf 45 47 80 00 00 	movabs $0x804745,%rdi
  801808:	00 00 00 
  80180b:	b8 00 00 00 00       	mov    $0x0,%eax
  801810:	49 b9 53 02 80 00 00 	movabs $0x800253,%r9
  801817:	00 00 00 
  80181a:	41 ff d1             	callq  *%r9

	return ret;
  80181d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801821:	48 83 c4 48          	add    $0x48,%rsp
  801825:	5b                   	pop    %rbx
  801826:	5d                   	pop    %rbp
  801827:	c3                   	retq   

0000000000801828 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801828:	55                   	push   %rbp
  801829:	48 89 e5             	mov    %rsp,%rbp
  80182c:	48 83 ec 20          	sub    $0x20,%rsp
  801830:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801834:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801838:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80183c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801840:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801847:	00 
  801848:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80184e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801854:	48 89 d1             	mov    %rdx,%rcx
  801857:	48 89 c2             	mov    %rax,%rdx
  80185a:	be 00 00 00 00       	mov    $0x0,%esi
  80185f:	bf 00 00 00 00       	mov    $0x0,%edi
  801864:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  80186b:	00 00 00 
  80186e:	ff d0                	callq  *%rax
}
  801870:	c9                   	leaveq 
  801871:	c3                   	retq   

0000000000801872 <sys_cgetc>:

int
sys_cgetc(void)
{
  801872:	55                   	push   %rbp
  801873:	48 89 e5             	mov    %rsp,%rbp
  801876:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80187a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801881:	00 
  801882:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801888:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80188e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801893:	ba 00 00 00 00       	mov    $0x0,%edx
  801898:	be 00 00 00 00       	mov    $0x0,%esi
  80189d:	bf 01 00 00 00       	mov    $0x1,%edi
  8018a2:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  8018a9:	00 00 00 
  8018ac:	ff d0                	callq  *%rax
}
  8018ae:	c9                   	leaveq 
  8018af:	c3                   	retq   

00000000008018b0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018b0:	55                   	push   %rbp
  8018b1:	48 89 e5             	mov    %rsp,%rbp
  8018b4:	48 83 ec 10          	sub    $0x10,%rsp
  8018b8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018be:	48 98                	cltq   
  8018c0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018c7:	00 
  8018c8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ce:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018d9:	48 89 c2             	mov    %rax,%rdx
  8018dc:	be 01 00 00 00       	mov    $0x1,%esi
  8018e1:	bf 03 00 00 00       	mov    $0x3,%edi
  8018e6:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  8018ed:	00 00 00 
  8018f0:	ff d0                	callq  *%rax
}
  8018f2:	c9                   	leaveq 
  8018f3:	c3                   	retq   

00000000008018f4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018f4:	55                   	push   %rbp
  8018f5:	48 89 e5             	mov    %rsp,%rbp
  8018f8:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018fc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801903:	00 
  801904:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80190a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801910:	b9 00 00 00 00       	mov    $0x0,%ecx
  801915:	ba 00 00 00 00       	mov    $0x0,%edx
  80191a:	be 00 00 00 00       	mov    $0x0,%esi
  80191f:	bf 02 00 00 00       	mov    $0x2,%edi
  801924:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  80192b:	00 00 00 
  80192e:	ff d0                	callq  *%rax
}
  801930:	c9                   	leaveq 
  801931:	c3                   	retq   

0000000000801932 <sys_yield>:


void
sys_yield(void)
{
  801932:	55                   	push   %rbp
  801933:	48 89 e5             	mov    %rsp,%rbp
  801936:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80193a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801941:	00 
  801942:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801948:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80194e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801953:	ba 00 00 00 00       	mov    $0x0,%edx
  801958:	be 00 00 00 00       	mov    $0x0,%esi
  80195d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801962:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801969:	00 00 00 
  80196c:	ff d0                	callq  *%rax
}
  80196e:	c9                   	leaveq 
  80196f:	c3                   	retq   

0000000000801970 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801970:	55                   	push   %rbp
  801971:	48 89 e5             	mov    %rsp,%rbp
  801974:	48 83 ec 20          	sub    $0x20,%rsp
  801978:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80197b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80197f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801982:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801985:	48 63 c8             	movslq %eax,%rcx
  801988:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80198c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80198f:	48 98                	cltq   
  801991:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801998:	00 
  801999:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80199f:	49 89 c8             	mov    %rcx,%r8
  8019a2:	48 89 d1             	mov    %rdx,%rcx
  8019a5:	48 89 c2             	mov    %rax,%rdx
  8019a8:	be 01 00 00 00       	mov    $0x1,%esi
  8019ad:	bf 04 00 00 00       	mov    $0x4,%edi
  8019b2:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  8019b9:	00 00 00 
  8019bc:	ff d0                	callq  *%rax
}
  8019be:	c9                   	leaveq 
  8019bf:	c3                   	retq   

00000000008019c0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019c0:	55                   	push   %rbp
  8019c1:	48 89 e5             	mov    %rsp,%rbp
  8019c4:	48 83 ec 30          	sub    $0x30,%rsp
  8019c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019cb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019cf:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019d2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019d6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019da:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019dd:	48 63 c8             	movslq %eax,%rcx
  8019e0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019e4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019e7:	48 63 f0             	movslq %eax,%rsi
  8019ea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f1:	48 98                	cltq   
  8019f3:	48 89 0c 24          	mov    %rcx,(%rsp)
  8019f7:	49 89 f9             	mov    %rdi,%r9
  8019fa:	49 89 f0             	mov    %rsi,%r8
  8019fd:	48 89 d1             	mov    %rdx,%rcx
  801a00:	48 89 c2             	mov    %rax,%rdx
  801a03:	be 01 00 00 00       	mov    $0x1,%esi
  801a08:	bf 05 00 00 00       	mov    $0x5,%edi
  801a0d:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801a14:	00 00 00 
  801a17:	ff d0                	callq  *%rax
}
  801a19:	c9                   	leaveq 
  801a1a:	c3                   	retq   

0000000000801a1b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a1b:	55                   	push   %rbp
  801a1c:	48 89 e5             	mov    %rsp,%rbp
  801a1f:	48 83 ec 20          	sub    $0x20,%rsp
  801a23:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a26:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a31:	48 98                	cltq   
  801a33:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3a:	00 
  801a3b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a41:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a47:	48 89 d1             	mov    %rdx,%rcx
  801a4a:	48 89 c2             	mov    %rax,%rdx
  801a4d:	be 01 00 00 00       	mov    $0x1,%esi
  801a52:	bf 06 00 00 00       	mov    $0x6,%edi
  801a57:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801a5e:	00 00 00 
  801a61:	ff d0                	callq  *%rax
}
  801a63:	c9                   	leaveq 
  801a64:	c3                   	retq   

0000000000801a65 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a65:	55                   	push   %rbp
  801a66:	48 89 e5             	mov    %rsp,%rbp
  801a69:	48 83 ec 10          	sub    $0x10,%rsp
  801a6d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a70:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a73:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a76:	48 63 d0             	movslq %eax,%rdx
  801a79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a7c:	48 98                	cltq   
  801a7e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a85:	00 
  801a86:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a8c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a92:	48 89 d1             	mov    %rdx,%rcx
  801a95:	48 89 c2             	mov    %rax,%rdx
  801a98:	be 01 00 00 00       	mov    $0x1,%esi
  801a9d:	bf 08 00 00 00       	mov    $0x8,%edi
  801aa2:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801aa9:	00 00 00 
  801aac:	ff d0                	callq  *%rax
}
  801aae:	c9                   	leaveq 
  801aaf:	c3                   	retq   

0000000000801ab0 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ab0:	55                   	push   %rbp
  801ab1:	48 89 e5             	mov    %rsp,%rbp
  801ab4:	48 83 ec 20          	sub    $0x20,%rsp
  801ab8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801abb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801abf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ac3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac6:	48 98                	cltq   
  801ac8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801acf:	00 
  801ad0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801adc:	48 89 d1             	mov    %rdx,%rcx
  801adf:	48 89 c2             	mov    %rax,%rdx
  801ae2:	be 01 00 00 00       	mov    $0x1,%esi
  801ae7:	bf 09 00 00 00       	mov    $0x9,%edi
  801aec:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801af3:	00 00 00 
  801af6:	ff d0                	callq  *%rax
}
  801af8:	c9                   	leaveq 
  801af9:	c3                   	retq   

0000000000801afa <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801afa:	55                   	push   %rbp
  801afb:	48 89 e5             	mov    %rsp,%rbp
  801afe:	48 83 ec 20          	sub    $0x20,%rsp
  801b02:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b05:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b09:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b10:	48 98                	cltq   
  801b12:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b19:	00 
  801b1a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b20:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b26:	48 89 d1             	mov    %rdx,%rcx
  801b29:	48 89 c2             	mov    %rax,%rdx
  801b2c:	be 01 00 00 00       	mov    $0x1,%esi
  801b31:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b36:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801b3d:	00 00 00 
  801b40:	ff d0                	callq  *%rax
}
  801b42:	c9                   	leaveq 
  801b43:	c3                   	retq   

0000000000801b44 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b44:	55                   	push   %rbp
  801b45:	48 89 e5             	mov    %rsp,%rbp
  801b48:	48 83 ec 20          	sub    $0x20,%rsp
  801b4c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b4f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b53:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b57:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b5a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b5d:	48 63 f0             	movslq %eax,%rsi
  801b60:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b67:	48 98                	cltq   
  801b69:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b6d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b74:	00 
  801b75:	49 89 f1             	mov    %rsi,%r9
  801b78:	49 89 c8             	mov    %rcx,%r8
  801b7b:	48 89 d1             	mov    %rdx,%rcx
  801b7e:	48 89 c2             	mov    %rax,%rdx
  801b81:	be 00 00 00 00       	mov    $0x0,%esi
  801b86:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b8b:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801b92:	00 00 00 
  801b95:	ff d0                	callq  *%rax
}
  801b97:	c9                   	leaveq 
  801b98:	c3                   	retq   

0000000000801b99 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b99:	55                   	push   %rbp
  801b9a:	48 89 e5             	mov    %rsp,%rbp
  801b9d:	48 83 ec 10          	sub    $0x10,%rsp
  801ba1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ba5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ba9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb0:	00 
  801bb1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bb7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bbd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bc2:	48 89 c2             	mov    %rax,%rdx
  801bc5:	be 01 00 00 00       	mov    $0x1,%esi
  801bca:	bf 0d 00 00 00       	mov    $0xd,%edi
  801bcf:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801bd6:	00 00 00 
  801bd9:	ff d0                	callq  *%rax
}
  801bdb:	c9                   	leaveq 
  801bdc:	c3                   	retq   

0000000000801bdd <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801bdd:	55                   	push   %rbp
  801bde:	48 89 e5             	mov    %rsp,%rbp
  801be1:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801be5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bec:	00 
  801bed:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bf9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bfe:	ba 00 00 00 00       	mov    $0x0,%edx
  801c03:	be 00 00 00 00       	mov    $0x0,%esi
  801c08:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c0d:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801c14:	00 00 00 
  801c17:	ff d0                	callq  *%rax
}
  801c19:	c9                   	leaveq 
  801c1a:	c3                   	retq   

0000000000801c1b <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801c1b:	55                   	push   %rbp
  801c1c:	48 89 e5             	mov    %rsp,%rbp
  801c1f:	48 83 ec 20          	sub    $0x20,%rsp
  801c23:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c27:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801c2a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801c2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c31:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c38:	00 
  801c39:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c3f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c45:	48 89 d1             	mov    %rdx,%rcx
  801c48:	48 89 c2             	mov    %rax,%rdx
  801c4b:	be 00 00 00 00       	mov    $0x0,%esi
  801c50:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c55:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801c5c:	00 00 00 
  801c5f:	ff d0                	callq  *%rax
}
  801c61:	c9                   	leaveq 
  801c62:	c3                   	retq   

0000000000801c63 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801c63:	55                   	push   %rbp
  801c64:	48 89 e5             	mov    %rsp,%rbp
  801c67:	48 83 ec 20          	sub    $0x20,%rsp
  801c6b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c6f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801c72:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801c75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c80:	00 
  801c81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c8d:	48 89 d1             	mov    %rdx,%rcx
  801c90:	48 89 c2             	mov    %rax,%rdx
  801c93:	be 00 00 00 00       	mov    $0x0,%esi
  801c98:	bf 10 00 00 00       	mov    $0x10,%edi
  801c9d:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801ca4:	00 00 00 
  801ca7:	ff d0                	callq  *%rax
}
  801ca9:	c9                   	leaveq 
  801caa:	c3                   	retq   

0000000000801cab <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801cab:	55                   	push   %rbp
  801cac:	48 89 e5             	mov    %rsp,%rbp
  801caf:	48 83 ec 30          	sub    $0x30,%rsp
  801cb3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cb6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cba:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801cbd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801cc1:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801cc5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801cc8:	48 63 c8             	movslq %eax,%rcx
  801ccb:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ccf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cd2:	48 63 f0             	movslq %eax,%rsi
  801cd5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cdc:	48 98                	cltq   
  801cde:	48 89 0c 24          	mov    %rcx,(%rsp)
  801ce2:	49 89 f9             	mov    %rdi,%r9
  801ce5:	49 89 f0             	mov    %rsi,%r8
  801ce8:	48 89 d1             	mov    %rdx,%rcx
  801ceb:	48 89 c2             	mov    %rax,%rdx
  801cee:	be 00 00 00 00       	mov    $0x0,%esi
  801cf3:	bf 11 00 00 00       	mov    $0x11,%edi
  801cf8:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801cff:	00 00 00 
  801d02:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801d04:	c9                   	leaveq 
  801d05:	c3                   	retq   

0000000000801d06 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801d06:	55                   	push   %rbp
  801d07:	48 89 e5             	mov    %rsp,%rbp
  801d0a:	48 83 ec 20          	sub    $0x20,%rsp
  801d0e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d12:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801d16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d1e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d25:	00 
  801d26:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d2c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d32:	48 89 d1             	mov    %rdx,%rcx
  801d35:	48 89 c2             	mov    %rax,%rdx
  801d38:	be 00 00 00 00       	mov    $0x0,%esi
  801d3d:	bf 12 00 00 00       	mov    $0x12,%edi
  801d42:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801d49:	00 00 00 
  801d4c:	ff d0                	callq  *%rax
}
  801d4e:	c9                   	leaveq 
  801d4f:	c3                   	retq   

0000000000801d50 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d50:	55                   	push   %rbp
  801d51:	48 89 e5             	mov    %rsp,%rbp
  801d54:	48 83 ec 08          	sub    $0x8,%rsp
  801d58:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d5c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d60:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d67:	ff ff ff 
  801d6a:	48 01 d0             	add    %rdx,%rax
  801d6d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d71:	c9                   	leaveq 
  801d72:	c3                   	retq   

0000000000801d73 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d73:	55                   	push   %rbp
  801d74:	48 89 e5             	mov    %rsp,%rbp
  801d77:	48 83 ec 08          	sub    $0x8,%rsp
  801d7b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d83:	48 89 c7             	mov    %rax,%rdi
  801d86:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  801d8d:	00 00 00 
  801d90:	ff d0                	callq  *%rax
  801d92:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d98:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d9c:	c9                   	leaveq 
  801d9d:	c3                   	retq   

0000000000801d9e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d9e:	55                   	push   %rbp
  801d9f:	48 89 e5             	mov    %rsp,%rbp
  801da2:	48 83 ec 18          	sub    $0x18,%rsp
  801da6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801daa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801db1:	eb 6b                	jmp    801e1e <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801db3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801db6:	48 98                	cltq   
  801db8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801dbe:	48 c1 e0 0c          	shl    $0xc,%rax
  801dc2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801dc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dca:	48 c1 e8 15          	shr    $0x15,%rax
  801dce:	48 89 c2             	mov    %rax,%rdx
  801dd1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801dd8:	01 00 00 
  801ddb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ddf:	83 e0 01             	and    $0x1,%eax
  801de2:	48 85 c0             	test   %rax,%rax
  801de5:	74 21                	je     801e08 <fd_alloc+0x6a>
  801de7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801deb:	48 c1 e8 0c          	shr    $0xc,%rax
  801def:	48 89 c2             	mov    %rax,%rdx
  801df2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801df9:	01 00 00 
  801dfc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e00:	83 e0 01             	and    $0x1,%eax
  801e03:	48 85 c0             	test   %rax,%rax
  801e06:	75 12                	jne    801e1a <fd_alloc+0x7c>
			*fd_store = fd;
  801e08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e0c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e10:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e13:	b8 00 00 00 00       	mov    $0x0,%eax
  801e18:	eb 1a                	jmp    801e34 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e1a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e1e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e22:	7e 8f                	jle    801db3 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e28:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e2f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e34:	c9                   	leaveq 
  801e35:	c3                   	retq   

0000000000801e36 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e36:	55                   	push   %rbp
  801e37:	48 89 e5             	mov    %rsp,%rbp
  801e3a:	48 83 ec 20          	sub    $0x20,%rsp
  801e3e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e41:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e45:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e49:	78 06                	js     801e51 <fd_lookup+0x1b>
  801e4b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e4f:	7e 07                	jle    801e58 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e51:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e56:	eb 6c                	jmp    801ec4 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e58:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e5b:	48 98                	cltq   
  801e5d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e63:	48 c1 e0 0c          	shl    $0xc,%rax
  801e67:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e6f:	48 c1 e8 15          	shr    $0x15,%rax
  801e73:	48 89 c2             	mov    %rax,%rdx
  801e76:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e7d:	01 00 00 
  801e80:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e84:	83 e0 01             	and    $0x1,%eax
  801e87:	48 85 c0             	test   %rax,%rax
  801e8a:	74 21                	je     801ead <fd_lookup+0x77>
  801e8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e90:	48 c1 e8 0c          	shr    $0xc,%rax
  801e94:	48 89 c2             	mov    %rax,%rdx
  801e97:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e9e:	01 00 00 
  801ea1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ea5:	83 e0 01             	and    $0x1,%eax
  801ea8:	48 85 c0             	test   %rax,%rax
  801eab:	75 07                	jne    801eb4 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ead:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eb2:	eb 10                	jmp    801ec4 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801eb4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801eb8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ebc:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801ebf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec4:	c9                   	leaveq 
  801ec5:	c3                   	retq   

0000000000801ec6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ec6:	55                   	push   %rbp
  801ec7:	48 89 e5             	mov    %rsp,%rbp
  801eca:	48 83 ec 30          	sub    $0x30,%rsp
  801ece:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ed2:	89 f0                	mov    %esi,%eax
  801ed4:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ed7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801edb:	48 89 c7             	mov    %rax,%rdi
  801ede:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  801ee5:	00 00 00 
  801ee8:	ff d0                	callq  *%rax
  801eea:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801eee:	48 89 d6             	mov    %rdx,%rsi
  801ef1:	89 c7                	mov    %eax,%edi
  801ef3:	48 b8 36 1e 80 00 00 	movabs $0x801e36,%rax
  801efa:	00 00 00 
  801efd:	ff d0                	callq  *%rax
  801eff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f06:	78 0a                	js     801f12 <fd_close+0x4c>
	    || fd != fd2)
  801f08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f0c:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f10:	74 12                	je     801f24 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f12:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f16:	74 05                	je     801f1d <fd_close+0x57>
  801f18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f1b:	eb 05                	jmp    801f22 <fd_close+0x5c>
  801f1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f22:	eb 69                	jmp    801f8d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f28:	8b 00                	mov    (%rax),%eax
  801f2a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f2e:	48 89 d6             	mov    %rdx,%rsi
  801f31:	89 c7                	mov    %eax,%edi
  801f33:	48 b8 8f 1f 80 00 00 	movabs $0x801f8f,%rax
  801f3a:	00 00 00 
  801f3d:	ff d0                	callq  *%rax
  801f3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f46:	78 2a                	js     801f72 <fd_close+0xac>
		if (dev->dev_close)
  801f48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f4c:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f50:	48 85 c0             	test   %rax,%rax
  801f53:	74 16                	je     801f6b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f59:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f5d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f61:	48 89 d7             	mov    %rdx,%rdi
  801f64:	ff d0                	callq  *%rax
  801f66:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f69:	eb 07                	jmp    801f72 <fd_close+0xac>
		else
			r = 0;
  801f6b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f76:	48 89 c6             	mov    %rax,%rsi
  801f79:	bf 00 00 00 00       	mov    $0x0,%edi
  801f7e:	48 b8 1b 1a 80 00 00 	movabs $0x801a1b,%rax
  801f85:	00 00 00 
  801f88:	ff d0                	callq  *%rax
	return r;
  801f8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f8d:	c9                   	leaveq 
  801f8e:	c3                   	retq   

0000000000801f8f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f8f:	55                   	push   %rbp
  801f90:	48 89 e5             	mov    %rsp,%rbp
  801f93:	48 83 ec 20          	sub    $0x20,%rsp
  801f97:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f9a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fa5:	eb 41                	jmp    801fe8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801fa7:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fae:	00 00 00 
  801fb1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fb4:	48 63 d2             	movslq %edx,%rdx
  801fb7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fbb:	8b 00                	mov    (%rax),%eax
  801fbd:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801fc0:	75 22                	jne    801fe4 <dev_lookup+0x55>
			*dev = devtab[i];
  801fc2:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fc9:	00 00 00 
  801fcc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fcf:	48 63 d2             	movslq %edx,%rdx
  801fd2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801fd6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fda:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fdd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe2:	eb 60                	jmp    802044 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801fe4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fe8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fef:	00 00 00 
  801ff2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ff5:	48 63 d2             	movslq %edx,%rdx
  801ff8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ffc:	48 85 c0             	test   %rax,%rax
  801fff:	75 a6                	jne    801fa7 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802001:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802008:	00 00 00 
  80200b:	48 8b 00             	mov    (%rax),%rax
  80200e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802014:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802017:	89 c6                	mov    %eax,%esi
  802019:	48 bf 58 47 80 00 00 	movabs $0x804758,%rdi
  802020:	00 00 00 
  802023:	b8 00 00 00 00       	mov    $0x0,%eax
  802028:	48 b9 8c 04 80 00 00 	movabs $0x80048c,%rcx
  80202f:	00 00 00 
  802032:	ff d1                	callq  *%rcx
	*dev = 0;
  802034:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802038:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80203f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802044:	c9                   	leaveq 
  802045:	c3                   	retq   

0000000000802046 <close>:

int
close(int fdnum)
{
  802046:	55                   	push   %rbp
  802047:	48 89 e5             	mov    %rsp,%rbp
  80204a:	48 83 ec 20          	sub    $0x20,%rsp
  80204e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802051:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802055:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802058:	48 89 d6             	mov    %rdx,%rsi
  80205b:	89 c7                	mov    %eax,%edi
  80205d:	48 b8 36 1e 80 00 00 	movabs $0x801e36,%rax
  802064:	00 00 00 
  802067:	ff d0                	callq  *%rax
  802069:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80206c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802070:	79 05                	jns    802077 <close+0x31>
		return r;
  802072:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802075:	eb 18                	jmp    80208f <close+0x49>
	else
		return fd_close(fd, 1);
  802077:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80207b:	be 01 00 00 00       	mov    $0x1,%esi
  802080:	48 89 c7             	mov    %rax,%rdi
  802083:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  80208a:	00 00 00 
  80208d:	ff d0                	callq  *%rax
}
  80208f:	c9                   	leaveq 
  802090:	c3                   	retq   

0000000000802091 <close_all>:

void
close_all(void)
{
  802091:	55                   	push   %rbp
  802092:	48 89 e5             	mov    %rsp,%rbp
  802095:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802099:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020a0:	eb 15                	jmp    8020b7 <close_all+0x26>
		close(i);
  8020a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020a5:	89 c7                	mov    %eax,%edi
  8020a7:	48 b8 46 20 80 00 00 	movabs $0x802046,%rax
  8020ae:	00 00 00 
  8020b1:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020b3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020b7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020bb:	7e e5                	jle    8020a2 <close_all+0x11>
		close(i);
}
  8020bd:	c9                   	leaveq 
  8020be:	c3                   	retq   

00000000008020bf <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8020bf:	55                   	push   %rbp
  8020c0:	48 89 e5             	mov    %rsp,%rbp
  8020c3:	48 83 ec 40          	sub    $0x40,%rsp
  8020c7:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8020ca:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8020cd:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8020d1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020d4:	48 89 d6             	mov    %rdx,%rsi
  8020d7:	89 c7                	mov    %eax,%edi
  8020d9:	48 b8 36 1e 80 00 00 	movabs $0x801e36,%rax
  8020e0:	00 00 00 
  8020e3:	ff d0                	callq  *%rax
  8020e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020ec:	79 08                	jns    8020f6 <dup+0x37>
		return r;
  8020ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020f1:	e9 70 01 00 00       	jmpq   802266 <dup+0x1a7>
	close(newfdnum);
  8020f6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020f9:	89 c7                	mov    %eax,%edi
  8020fb:	48 b8 46 20 80 00 00 	movabs $0x802046,%rax
  802102:	00 00 00 
  802105:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802107:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80210a:	48 98                	cltq   
  80210c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802112:	48 c1 e0 0c          	shl    $0xc,%rax
  802116:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80211a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80211e:	48 89 c7             	mov    %rax,%rdi
  802121:	48 b8 73 1d 80 00 00 	movabs $0x801d73,%rax
  802128:	00 00 00 
  80212b:	ff d0                	callq  *%rax
  80212d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802131:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802135:	48 89 c7             	mov    %rax,%rdi
  802138:	48 b8 73 1d 80 00 00 	movabs $0x801d73,%rax
  80213f:	00 00 00 
  802142:	ff d0                	callq  *%rax
  802144:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802148:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80214c:	48 c1 e8 15          	shr    $0x15,%rax
  802150:	48 89 c2             	mov    %rax,%rdx
  802153:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80215a:	01 00 00 
  80215d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802161:	83 e0 01             	and    $0x1,%eax
  802164:	48 85 c0             	test   %rax,%rax
  802167:	74 73                	je     8021dc <dup+0x11d>
  802169:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80216d:	48 c1 e8 0c          	shr    $0xc,%rax
  802171:	48 89 c2             	mov    %rax,%rdx
  802174:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80217b:	01 00 00 
  80217e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802182:	83 e0 01             	and    $0x1,%eax
  802185:	48 85 c0             	test   %rax,%rax
  802188:	74 52                	je     8021dc <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80218a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218e:	48 c1 e8 0c          	shr    $0xc,%rax
  802192:	48 89 c2             	mov    %rax,%rdx
  802195:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80219c:	01 00 00 
  80219f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021a3:	25 07 0e 00 00       	and    $0xe07,%eax
  8021a8:	89 c1                	mov    %eax,%ecx
  8021aa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b2:	41 89 c8             	mov    %ecx,%r8d
  8021b5:	48 89 d1             	mov    %rdx,%rcx
  8021b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8021bd:	48 89 c6             	mov    %rax,%rsi
  8021c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8021c5:	48 b8 c0 19 80 00 00 	movabs $0x8019c0,%rax
  8021cc:	00 00 00 
  8021cf:	ff d0                	callq  *%rax
  8021d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021d8:	79 02                	jns    8021dc <dup+0x11d>
			goto err;
  8021da:	eb 57                	jmp    802233 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021e0:	48 c1 e8 0c          	shr    $0xc,%rax
  8021e4:	48 89 c2             	mov    %rax,%rdx
  8021e7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021ee:	01 00 00 
  8021f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021f5:	25 07 0e 00 00       	and    $0xe07,%eax
  8021fa:	89 c1                	mov    %eax,%ecx
  8021fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802200:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802204:	41 89 c8             	mov    %ecx,%r8d
  802207:	48 89 d1             	mov    %rdx,%rcx
  80220a:	ba 00 00 00 00       	mov    $0x0,%edx
  80220f:	48 89 c6             	mov    %rax,%rsi
  802212:	bf 00 00 00 00       	mov    $0x0,%edi
  802217:	48 b8 c0 19 80 00 00 	movabs $0x8019c0,%rax
  80221e:	00 00 00 
  802221:	ff d0                	callq  *%rax
  802223:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802226:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80222a:	79 02                	jns    80222e <dup+0x16f>
		goto err;
  80222c:	eb 05                	jmp    802233 <dup+0x174>

	return newfdnum;
  80222e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802231:	eb 33                	jmp    802266 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802233:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802237:	48 89 c6             	mov    %rax,%rsi
  80223a:	bf 00 00 00 00       	mov    $0x0,%edi
  80223f:	48 b8 1b 1a 80 00 00 	movabs $0x801a1b,%rax
  802246:	00 00 00 
  802249:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80224b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80224f:	48 89 c6             	mov    %rax,%rsi
  802252:	bf 00 00 00 00       	mov    $0x0,%edi
  802257:	48 b8 1b 1a 80 00 00 	movabs $0x801a1b,%rax
  80225e:	00 00 00 
  802261:	ff d0                	callq  *%rax
	return r;
  802263:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802266:	c9                   	leaveq 
  802267:	c3                   	retq   

0000000000802268 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802268:	55                   	push   %rbp
  802269:	48 89 e5             	mov    %rsp,%rbp
  80226c:	48 83 ec 40          	sub    $0x40,%rsp
  802270:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802273:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802277:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80227b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80227f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802282:	48 89 d6             	mov    %rdx,%rsi
  802285:	89 c7                	mov    %eax,%edi
  802287:	48 b8 36 1e 80 00 00 	movabs $0x801e36,%rax
  80228e:	00 00 00 
  802291:	ff d0                	callq  *%rax
  802293:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802296:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80229a:	78 24                	js     8022c0 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80229c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a0:	8b 00                	mov    (%rax),%eax
  8022a2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022a6:	48 89 d6             	mov    %rdx,%rsi
  8022a9:	89 c7                	mov    %eax,%edi
  8022ab:	48 b8 8f 1f 80 00 00 	movabs $0x801f8f,%rax
  8022b2:	00 00 00 
  8022b5:	ff d0                	callq  *%rax
  8022b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022be:	79 05                	jns    8022c5 <read+0x5d>
		return r;
  8022c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022c3:	eb 76                	jmp    80233b <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8022c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c9:	8b 40 08             	mov    0x8(%rax),%eax
  8022cc:	83 e0 03             	and    $0x3,%eax
  8022cf:	83 f8 01             	cmp    $0x1,%eax
  8022d2:	75 3a                	jne    80230e <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8022d4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022db:	00 00 00 
  8022de:	48 8b 00             	mov    (%rax),%rax
  8022e1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022e7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022ea:	89 c6                	mov    %eax,%esi
  8022ec:	48 bf 77 47 80 00 00 	movabs $0x804777,%rdi
  8022f3:	00 00 00 
  8022f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fb:	48 b9 8c 04 80 00 00 	movabs $0x80048c,%rcx
  802302:	00 00 00 
  802305:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802307:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80230c:	eb 2d                	jmp    80233b <read+0xd3>
	}
	if (!dev->dev_read)
  80230e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802312:	48 8b 40 10          	mov    0x10(%rax),%rax
  802316:	48 85 c0             	test   %rax,%rax
  802319:	75 07                	jne    802322 <read+0xba>
		return -E_NOT_SUPP;
  80231b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802320:	eb 19                	jmp    80233b <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802322:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802326:	48 8b 40 10          	mov    0x10(%rax),%rax
  80232a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80232e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802332:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802336:	48 89 cf             	mov    %rcx,%rdi
  802339:	ff d0                	callq  *%rax
}
  80233b:	c9                   	leaveq 
  80233c:	c3                   	retq   

000000000080233d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80233d:	55                   	push   %rbp
  80233e:	48 89 e5             	mov    %rsp,%rbp
  802341:	48 83 ec 30          	sub    $0x30,%rsp
  802345:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802348:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80234c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802350:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802357:	eb 49                	jmp    8023a2 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802359:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235c:	48 98                	cltq   
  80235e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802362:	48 29 c2             	sub    %rax,%rdx
  802365:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802368:	48 63 c8             	movslq %eax,%rcx
  80236b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80236f:	48 01 c1             	add    %rax,%rcx
  802372:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802375:	48 89 ce             	mov    %rcx,%rsi
  802378:	89 c7                	mov    %eax,%edi
  80237a:	48 b8 68 22 80 00 00 	movabs $0x802268,%rax
  802381:	00 00 00 
  802384:	ff d0                	callq  *%rax
  802386:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802389:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80238d:	79 05                	jns    802394 <readn+0x57>
			return m;
  80238f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802392:	eb 1c                	jmp    8023b0 <readn+0x73>
		if (m == 0)
  802394:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802398:	75 02                	jne    80239c <readn+0x5f>
			break;
  80239a:	eb 11                	jmp    8023ad <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80239c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80239f:	01 45 fc             	add    %eax,-0x4(%rbp)
  8023a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a5:	48 98                	cltq   
  8023a7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8023ab:	72 ac                	jb     802359 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8023ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023b0:	c9                   	leaveq 
  8023b1:	c3                   	retq   

00000000008023b2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023b2:	55                   	push   %rbp
  8023b3:	48 89 e5             	mov    %rsp,%rbp
  8023b6:	48 83 ec 40          	sub    $0x40,%rsp
  8023ba:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023bd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023c1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023c5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023c9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023cc:	48 89 d6             	mov    %rdx,%rsi
  8023cf:	89 c7                	mov    %eax,%edi
  8023d1:	48 b8 36 1e 80 00 00 	movabs $0x801e36,%rax
  8023d8:	00 00 00 
  8023db:	ff d0                	callq  *%rax
  8023dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e4:	78 24                	js     80240a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ea:	8b 00                	mov    (%rax),%eax
  8023ec:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023f0:	48 89 d6             	mov    %rdx,%rsi
  8023f3:	89 c7                	mov    %eax,%edi
  8023f5:	48 b8 8f 1f 80 00 00 	movabs $0x801f8f,%rax
  8023fc:	00 00 00 
  8023ff:	ff d0                	callq  *%rax
  802401:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802404:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802408:	79 05                	jns    80240f <write+0x5d>
		return r;
  80240a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80240d:	eb 75                	jmp    802484 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80240f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802413:	8b 40 08             	mov    0x8(%rax),%eax
  802416:	83 e0 03             	and    $0x3,%eax
  802419:	85 c0                	test   %eax,%eax
  80241b:	75 3a                	jne    802457 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80241d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802424:	00 00 00 
  802427:	48 8b 00             	mov    (%rax),%rax
  80242a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802430:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802433:	89 c6                	mov    %eax,%esi
  802435:	48 bf 93 47 80 00 00 	movabs $0x804793,%rdi
  80243c:	00 00 00 
  80243f:	b8 00 00 00 00       	mov    $0x0,%eax
  802444:	48 b9 8c 04 80 00 00 	movabs $0x80048c,%rcx
  80244b:	00 00 00 
  80244e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802450:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802455:	eb 2d                	jmp    802484 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802457:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80245b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80245f:	48 85 c0             	test   %rax,%rax
  802462:	75 07                	jne    80246b <write+0xb9>
		return -E_NOT_SUPP;
  802464:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802469:	eb 19                	jmp    802484 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80246b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80246f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802473:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802477:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80247b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80247f:	48 89 cf             	mov    %rcx,%rdi
  802482:	ff d0                	callq  *%rax
}
  802484:	c9                   	leaveq 
  802485:	c3                   	retq   

0000000000802486 <seek>:

int
seek(int fdnum, off_t offset)
{
  802486:	55                   	push   %rbp
  802487:	48 89 e5             	mov    %rsp,%rbp
  80248a:	48 83 ec 18          	sub    $0x18,%rsp
  80248e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802491:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802494:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802498:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80249b:	48 89 d6             	mov    %rdx,%rsi
  80249e:	89 c7                	mov    %eax,%edi
  8024a0:	48 b8 36 1e 80 00 00 	movabs $0x801e36,%rax
  8024a7:	00 00 00 
  8024aa:	ff d0                	callq  *%rax
  8024ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b3:	79 05                	jns    8024ba <seek+0x34>
		return r;
  8024b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b8:	eb 0f                	jmp    8024c9 <seek+0x43>
	fd->fd_offset = offset;
  8024ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024be:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8024c1:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8024c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c9:	c9                   	leaveq 
  8024ca:	c3                   	retq   

00000000008024cb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8024cb:	55                   	push   %rbp
  8024cc:	48 89 e5             	mov    %rsp,%rbp
  8024cf:	48 83 ec 30          	sub    $0x30,%rsp
  8024d3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024d6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024d9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024e0:	48 89 d6             	mov    %rdx,%rsi
  8024e3:	89 c7                	mov    %eax,%edi
  8024e5:	48 b8 36 1e 80 00 00 	movabs $0x801e36,%rax
  8024ec:	00 00 00 
  8024ef:	ff d0                	callq  *%rax
  8024f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f8:	78 24                	js     80251e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024fe:	8b 00                	mov    (%rax),%eax
  802500:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802504:	48 89 d6             	mov    %rdx,%rsi
  802507:	89 c7                	mov    %eax,%edi
  802509:	48 b8 8f 1f 80 00 00 	movabs $0x801f8f,%rax
  802510:	00 00 00 
  802513:	ff d0                	callq  *%rax
  802515:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802518:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80251c:	79 05                	jns    802523 <ftruncate+0x58>
		return r;
  80251e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802521:	eb 72                	jmp    802595 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802523:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802527:	8b 40 08             	mov    0x8(%rax),%eax
  80252a:	83 e0 03             	and    $0x3,%eax
  80252d:	85 c0                	test   %eax,%eax
  80252f:	75 3a                	jne    80256b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802531:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802538:	00 00 00 
  80253b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80253e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802544:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802547:	89 c6                	mov    %eax,%esi
  802549:	48 bf b0 47 80 00 00 	movabs $0x8047b0,%rdi
  802550:	00 00 00 
  802553:	b8 00 00 00 00       	mov    $0x0,%eax
  802558:	48 b9 8c 04 80 00 00 	movabs $0x80048c,%rcx
  80255f:	00 00 00 
  802562:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802564:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802569:	eb 2a                	jmp    802595 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80256b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80256f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802573:	48 85 c0             	test   %rax,%rax
  802576:	75 07                	jne    80257f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802578:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80257d:	eb 16                	jmp    802595 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80257f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802583:	48 8b 40 30          	mov    0x30(%rax),%rax
  802587:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80258b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80258e:	89 ce                	mov    %ecx,%esi
  802590:	48 89 d7             	mov    %rdx,%rdi
  802593:	ff d0                	callq  *%rax
}
  802595:	c9                   	leaveq 
  802596:	c3                   	retq   

0000000000802597 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802597:	55                   	push   %rbp
  802598:	48 89 e5             	mov    %rsp,%rbp
  80259b:	48 83 ec 30          	sub    $0x30,%rsp
  80259f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025a2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025a6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025aa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025ad:	48 89 d6             	mov    %rdx,%rsi
  8025b0:	89 c7                	mov    %eax,%edi
  8025b2:	48 b8 36 1e 80 00 00 	movabs $0x801e36,%rax
  8025b9:	00 00 00 
  8025bc:	ff d0                	callq  *%rax
  8025be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025c5:	78 24                	js     8025eb <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025cb:	8b 00                	mov    (%rax),%eax
  8025cd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025d1:	48 89 d6             	mov    %rdx,%rsi
  8025d4:	89 c7                	mov    %eax,%edi
  8025d6:	48 b8 8f 1f 80 00 00 	movabs $0x801f8f,%rax
  8025dd:	00 00 00 
  8025e0:	ff d0                	callq  *%rax
  8025e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e9:	79 05                	jns    8025f0 <fstat+0x59>
		return r;
  8025eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ee:	eb 5e                	jmp    80264e <fstat+0xb7>
	if (!dev->dev_stat)
  8025f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025f8:	48 85 c0             	test   %rax,%rax
  8025fb:	75 07                	jne    802604 <fstat+0x6d>
		return -E_NOT_SUPP;
  8025fd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802602:	eb 4a                	jmp    80264e <fstat+0xb7>
	stat->st_name[0] = 0;
  802604:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802608:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80260b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80260f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802616:	00 00 00 
	stat->st_isdir = 0;
  802619:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80261d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802624:	00 00 00 
	stat->st_dev = dev;
  802627:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80262b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80262f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802636:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80263a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80263e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802642:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802646:	48 89 ce             	mov    %rcx,%rsi
  802649:	48 89 d7             	mov    %rdx,%rdi
  80264c:	ff d0                	callq  *%rax
}
  80264e:	c9                   	leaveq 
  80264f:	c3                   	retq   

0000000000802650 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802650:	55                   	push   %rbp
  802651:	48 89 e5             	mov    %rsp,%rbp
  802654:	48 83 ec 20          	sub    $0x20,%rsp
  802658:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80265c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802664:	be 00 00 00 00       	mov    $0x0,%esi
  802669:	48 89 c7             	mov    %rax,%rdi
  80266c:	48 b8 3e 27 80 00 00 	movabs $0x80273e,%rax
  802673:	00 00 00 
  802676:	ff d0                	callq  *%rax
  802678:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80267b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80267f:	79 05                	jns    802686 <stat+0x36>
		return fd;
  802681:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802684:	eb 2f                	jmp    8026b5 <stat+0x65>
	r = fstat(fd, stat);
  802686:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80268a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80268d:	48 89 d6             	mov    %rdx,%rsi
  802690:	89 c7                	mov    %eax,%edi
  802692:	48 b8 97 25 80 00 00 	movabs $0x802597,%rax
  802699:	00 00 00 
  80269c:	ff d0                	callq  *%rax
  80269e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8026a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a4:	89 c7                	mov    %eax,%edi
  8026a6:	48 b8 46 20 80 00 00 	movabs $0x802046,%rax
  8026ad:	00 00 00 
  8026b0:	ff d0                	callq  *%rax
	return r;
  8026b2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8026b5:	c9                   	leaveq 
  8026b6:	c3                   	retq   

00000000008026b7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8026b7:	55                   	push   %rbp
  8026b8:	48 89 e5             	mov    %rsp,%rbp
  8026bb:	48 83 ec 10          	sub    $0x10,%rsp
  8026bf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8026c6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026cd:	00 00 00 
  8026d0:	8b 00                	mov    (%rax),%eax
  8026d2:	85 c0                	test   %eax,%eax
  8026d4:	75 1d                	jne    8026f3 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8026d6:	bf 01 00 00 00       	mov    $0x1,%edi
  8026db:	48 b8 d0 40 80 00 00 	movabs $0x8040d0,%rax
  8026e2:	00 00 00 
  8026e5:	ff d0                	callq  *%rax
  8026e7:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8026ee:	00 00 00 
  8026f1:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026f3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026fa:	00 00 00 
  8026fd:	8b 00                	mov    (%rax),%eax
  8026ff:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802702:	b9 07 00 00 00       	mov    $0x7,%ecx
  802707:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80270e:	00 00 00 
  802711:	89 c7                	mov    %eax,%edi
  802713:	48 b8 c4 3e 80 00 00 	movabs $0x803ec4,%rax
  80271a:	00 00 00 
  80271d:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80271f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802723:	ba 00 00 00 00       	mov    $0x0,%edx
  802728:	48 89 c6             	mov    %rax,%rsi
  80272b:	bf 00 00 00 00       	mov    $0x0,%edi
  802730:	48 b8 03 3e 80 00 00 	movabs $0x803e03,%rax
  802737:	00 00 00 
  80273a:	ff d0                	callq  *%rax
}
  80273c:	c9                   	leaveq 
  80273d:	c3                   	retq   

000000000080273e <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80273e:	55                   	push   %rbp
  80273f:	48 89 e5             	mov    %rsp,%rbp
  802742:	48 83 ec 20          	sub    $0x20,%rsp
  802746:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80274a:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80274d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802751:	48 89 c7             	mov    %rax,%rdi
  802754:	48 b8 d5 0f 80 00 00 	movabs $0x800fd5,%rax
  80275b:	00 00 00 
  80275e:	ff d0                	callq  *%rax
  802760:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802765:	7e 0a                	jle    802771 <open+0x33>
		return -E_BAD_PATH;
  802767:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80276c:	e9 a5 00 00 00       	jmpq   802816 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802771:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802775:	48 89 c7             	mov    %rax,%rdi
  802778:	48 b8 9e 1d 80 00 00 	movabs $0x801d9e,%rax
  80277f:	00 00 00 
  802782:	ff d0                	callq  *%rax
  802784:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802787:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80278b:	79 08                	jns    802795 <open+0x57>
		return r;
  80278d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802790:	e9 81 00 00 00       	jmpq   802816 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802795:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802799:	48 89 c6             	mov    %rax,%rsi
  80279c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8027a3:	00 00 00 
  8027a6:	48 b8 41 10 80 00 00 	movabs $0x801041,%rax
  8027ad:	00 00 00 
  8027b0:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8027b2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027b9:	00 00 00 
  8027bc:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8027bf:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8027c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027c9:	48 89 c6             	mov    %rax,%rsi
  8027cc:	bf 01 00 00 00       	mov    $0x1,%edi
  8027d1:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  8027d8:	00 00 00 
  8027db:	ff d0                	callq  *%rax
  8027dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027e4:	79 1d                	jns    802803 <open+0xc5>
		fd_close(fd, 0);
  8027e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ea:	be 00 00 00 00       	mov    $0x0,%esi
  8027ef:	48 89 c7             	mov    %rax,%rdi
  8027f2:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  8027f9:	00 00 00 
  8027fc:	ff d0                	callq  *%rax
		return r;
  8027fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802801:	eb 13                	jmp    802816 <open+0xd8>
	}

	return fd2num(fd);
  802803:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802807:	48 89 c7             	mov    %rax,%rdi
  80280a:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  802811:	00 00 00 
  802814:	ff d0                	callq  *%rax

}
  802816:	c9                   	leaveq 
  802817:	c3                   	retq   

0000000000802818 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802818:	55                   	push   %rbp
  802819:	48 89 e5             	mov    %rsp,%rbp
  80281c:	48 83 ec 10          	sub    $0x10,%rsp
  802820:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802824:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802828:	8b 50 0c             	mov    0xc(%rax),%edx
  80282b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802832:	00 00 00 
  802835:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802837:	be 00 00 00 00       	mov    $0x0,%esi
  80283c:	bf 06 00 00 00       	mov    $0x6,%edi
  802841:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  802848:	00 00 00 
  80284b:	ff d0                	callq  *%rax
}
  80284d:	c9                   	leaveq 
  80284e:	c3                   	retq   

000000000080284f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80284f:	55                   	push   %rbp
  802850:	48 89 e5             	mov    %rsp,%rbp
  802853:	48 83 ec 30          	sub    $0x30,%rsp
  802857:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80285b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80285f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802863:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802867:	8b 50 0c             	mov    0xc(%rax),%edx
  80286a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802871:	00 00 00 
  802874:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802876:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80287d:	00 00 00 
  802880:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802884:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802888:	be 00 00 00 00       	mov    $0x0,%esi
  80288d:	bf 03 00 00 00       	mov    $0x3,%edi
  802892:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  802899:	00 00 00 
  80289c:	ff d0                	callq  *%rax
  80289e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028a5:	79 08                	jns    8028af <devfile_read+0x60>
		return r;
  8028a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028aa:	e9 a4 00 00 00       	jmpq   802953 <devfile_read+0x104>
	assert(r <= n);
  8028af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028b2:	48 98                	cltq   
  8028b4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8028b8:	76 35                	jbe    8028ef <devfile_read+0xa0>
  8028ba:	48 b9 d6 47 80 00 00 	movabs $0x8047d6,%rcx
  8028c1:	00 00 00 
  8028c4:	48 ba dd 47 80 00 00 	movabs $0x8047dd,%rdx
  8028cb:	00 00 00 
  8028ce:	be 86 00 00 00       	mov    $0x86,%esi
  8028d3:	48 bf f2 47 80 00 00 	movabs $0x8047f2,%rdi
  8028da:	00 00 00 
  8028dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e2:	49 b8 53 02 80 00 00 	movabs $0x800253,%r8
  8028e9:	00 00 00 
  8028ec:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8028ef:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8028f6:	7e 35                	jle    80292d <devfile_read+0xde>
  8028f8:	48 b9 fd 47 80 00 00 	movabs $0x8047fd,%rcx
  8028ff:	00 00 00 
  802902:	48 ba dd 47 80 00 00 	movabs $0x8047dd,%rdx
  802909:	00 00 00 
  80290c:	be 87 00 00 00       	mov    $0x87,%esi
  802911:	48 bf f2 47 80 00 00 	movabs $0x8047f2,%rdi
  802918:	00 00 00 
  80291b:	b8 00 00 00 00       	mov    $0x0,%eax
  802920:	49 b8 53 02 80 00 00 	movabs $0x800253,%r8
  802927:	00 00 00 
  80292a:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  80292d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802930:	48 63 d0             	movslq %eax,%rdx
  802933:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802937:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80293e:	00 00 00 
  802941:	48 89 c7             	mov    %rax,%rdi
  802944:	48 b8 65 13 80 00 00 	movabs $0x801365,%rax
  80294b:	00 00 00 
  80294e:	ff d0                	callq  *%rax
	return r;
  802950:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802953:	c9                   	leaveq 
  802954:	c3                   	retq   

0000000000802955 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802955:	55                   	push   %rbp
  802956:	48 89 e5             	mov    %rsp,%rbp
  802959:	48 83 ec 40          	sub    $0x40,%rsp
  80295d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802961:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802965:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802969:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80296d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802971:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802978:	00 
  802979:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80297d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802981:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802986:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80298a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80298e:	8b 50 0c             	mov    0xc(%rax),%edx
  802991:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802998:	00 00 00 
  80299b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80299d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029a4:	00 00 00 
  8029a7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8029ab:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8029af:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8029b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029b7:	48 89 c6             	mov    %rax,%rsi
  8029ba:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8029c1:	00 00 00 
  8029c4:	48 b8 65 13 80 00 00 	movabs $0x801365,%rax
  8029cb:	00 00 00 
  8029ce:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8029d0:	be 00 00 00 00       	mov    $0x0,%esi
  8029d5:	bf 04 00 00 00       	mov    $0x4,%edi
  8029da:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  8029e1:	00 00 00 
  8029e4:	ff d0                	callq  *%rax
  8029e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8029e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8029ed:	79 05                	jns    8029f4 <devfile_write+0x9f>
		return r;
  8029ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029f2:	eb 43                	jmp    802a37 <devfile_write+0xe2>
	assert(r <= n);
  8029f4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029f7:	48 98                	cltq   
  8029f9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8029fd:	76 35                	jbe    802a34 <devfile_write+0xdf>
  8029ff:	48 b9 d6 47 80 00 00 	movabs $0x8047d6,%rcx
  802a06:	00 00 00 
  802a09:	48 ba dd 47 80 00 00 	movabs $0x8047dd,%rdx
  802a10:	00 00 00 
  802a13:	be a2 00 00 00       	mov    $0xa2,%esi
  802a18:	48 bf f2 47 80 00 00 	movabs $0x8047f2,%rdi
  802a1f:	00 00 00 
  802a22:	b8 00 00 00 00       	mov    $0x0,%eax
  802a27:	49 b8 53 02 80 00 00 	movabs $0x800253,%r8
  802a2e:	00 00 00 
  802a31:	41 ff d0             	callq  *%r8
	return r;
  802a34:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802a37:	c9                   	leaveq 
  802a38:	c3                   	retq   

0000000000802a39 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a39:	55                   	push   %rbp
  802a3a:	48 89 e5             	mov    %rsp,%rbp
  802a3d:	48 83 ec 20          	sub    $0x20,%rsp
  802a41:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a45:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a4d:	8b 50 0c             	mov    0xc(%rax),%edx
  802a50:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a57:	00 00 00 
  802a5a:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a5c:	be 00 00 00 00       	mov    $0x0,%esi
  802a61:	bf 05 00 00 00       	mov    $0x5,%edi
  802a66:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  802a6d:	00 00 00 
  802a70:	ff d0                	callq  *%rax
  802a72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a79:	79 05                	jns    802a80 <devfile_stat+0x47>
		return r;
  802a7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a7e:	eb 56                	jmp    802ad6 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a84:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a8b:	00 00 00 
  802a8e:	48 89 c7             	mov    %rax,%rdi
  802a91:	48 b8 41 10 80 00 00 	movabs $0x801041,%rax
  802a98:	00 00 00 
  802a9b:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a9d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802aa4:	00 00 00 
  802aa7:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802aad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ab1:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802ab7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802abe:	00 00 00 
  802ac1:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802ac7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802acb:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802ad1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ad6:	c9                   	leaveq 
  802ad7:	c3                   	retq   

0000000000802ad8 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802ad8:	55                   	push   %rbp
  802ad9:	48 89 e5             	mov    %rsp,%rbp
  802adc:	48 83 ec 10          	sub    $0x10,%rsp
  802ae0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ae4:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802ae7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802aeb:	8b 50 0c             	mov    0xc(%rax),%edx
  802aee:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802af5:	00 00 00 
  802af8:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802afa:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b01:	00 00 00 
  802b04:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b07:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b0a:	be 00 00 00 00       	mov    $0x0,%esi
  802b0f:	bf 02 00 00 00       	mov    $0x2,%edi
  802b14:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  802b1b:	00 00 00 
  802b1e:	ff d0                	callq  *%rax
}
  802b20:	c9                   	leaveq 
  802b21:	c3                   	retq   

0000000000802b22 <remove>:

// Delete a file
int
remove(const char *path)
{
  802b22:	55                   	push   %rbp
  802b23:	48 89 e5             	mov    %rsp,%rbp
  802b26:	48 83 ec 10          	sub    $0x10,%rsp
  802b2a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b32:	48 89 c7             	mov    %rax,%rdi
  802b35:	48 b8 d5 0f 80 00 00 	movabs $0x800fd5,%rax
  802b3c:	00 00 00 
  802b3f:	ff d0                	callq  *%rax
  802b41:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b46:	7e 07                	jle    802b4f <remove+0x2d>
		return -E_BAD_PATH;
  802b48:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b4d:	eb 33                	jmp    802b82 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802b4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b53:	48 89 c6             	mov    %rax,%rsi
  802b56:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802b5d:	00 00 00 
  802b60:	48 b8 41 10 80 00 00 	movabs $0x801041,%rax
  802b67:	00 00 00 
  802b6a:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802b6c:	be 00 00 00 00       	mov    $0x0,%esi
  802b71:	bf 07 00 00 00       	mov    $0x7,%edi
  802b76:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  802b7d:	00 00 00 
  802b80:	ff d0                	callq  *%rax
}
  802b82:	c9                   	leaveq 
  802b83:	c3                   	retq   

0000000000802b84 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b84:	55                   	push   %rbp
  802b85:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b88:	be 00 00 00 00       	mov    $0x0,%esi
  802b8d:	bf 08 00 00 00       	mov    $0x8,%edi
  802b92:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  802b99:	00 00 00 
  802b9c:	ff d0                	callq  *%rax
}
  802b9e:	5d                   	pop    %rbp
  802b9f:	c3                   	retq   

0000000000802ba0 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802ba0:	55                   	push   %rbp
  802ba1:	48 89 e5             	mov    %rsp,%rbp
  802ba4:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802bab:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802bb2:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802bb9:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802bc0:	be 00 00 00 00       	mov    $0x0,%esi
  802bc5:	48 89 c7             	mov    %rax,%rdi
  802bc8:	48 b8 3e 27 80 00 00 	movabs $0x80273e,%rax
  802bcf:	00 00 00 
  802bd2:	ff d0                	callq  *%rax
  802bd4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802bd7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bdb:	79 28                	jns    802c05 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802bdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be0:	89 c6                	mov    %eax,%esi
  802be2:	48 bf 09 48 80 00 00 	movabs $0x804809,%rdi
  802be9:	00 00 00 
  802bec:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf1:	48 ba 8c 04 80 00 00 	movabs $0x80048c,%rdx
  802bf8:	00 00 00 
  802bfb:	ff d2                	callq  *%rdx
		return fd_src;
  802bfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c00:	e9 74 01 00 00       	jmpq   802d79 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802c05:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802c0c:	be 01 01 00 00       	mov    $0x101,%esi
  802c11:	48 89 c7             	mov    %rax,%rdi
  802c14:	48 b8 3e 27 80 00 00 	movabs $0x80273e,%rax
  802c1b:	00 00 00 
  802c1e:	ff d0                	callq  *%rax
  802c20:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802c23:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c27:	79 39                	jns    802c62 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802c29:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c2c:	89 c6                	mov    %eax,%esi
  802c2e:	48 bf 1f 48 80 00 00 	movabs $0x80481f,%rdi
  802c35:	00 00 00 
  802c38:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3d:	48 ba 8c 04 80 00 00 	movabs $0x80048c,%rdx
  802c44:	00 00 00 
  802c47:	ff d2                	callq  *%rdx
		close(fd_src);
  802c49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4c:	89 c7                	mov    %eax,%edi
  802c4e:	48 b8 46 20 80 00 00 	movabs $0x802046,%rax
  802c55:	00 00 00 
  802c58:	ff d0                	callq  *%rax
		return fd_dest;
  802c5a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c5d:	e9 17 01 00 00       	jmpq   802d79 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c62:	eb 74                	jmp    802cd8 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802c64:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c67:	48 63 d0             	movslq %eax,%rdx
  802c6a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c71:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c74:	48 89 ce             	mov    %rcx,%rsi
  802c77:	89 c7                	mov    %eax,%edi
  802c79:	48 b8 b2 23 80 00 00 	movabs $0x8023b2,%rax
  802c80:	00 00 00 
  802c83:	ff d0                	callq  *%rax
  802c85:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c88:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c8c:	79 4a                	jns    802cd8 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802c8e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c91:	89 c6                	mov    %eax,%esi
  802c93:	48 bf 39 48 80 00 00 	movabs $0x804839,%rdi
  802c9a:	00 00 00 
  802c9d:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca2:	48 ba 8c 04 80 00 00 	movabs $0x80048c,%rdx
  802ca9:	00 00 00 
  802cac:	ff d2                	callq  *%rdx
			close(fd_src);
  802cae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb1:	89 c7                	mov    %eax,%edi
  802cb3:	48 b8 46 20 80 00 00 	movabs $0x802046,%rax
  802cba:	00 00 00 
  802cbd:	ff d0                	callq  *%rax
			close(fd_dest);
  802cbf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cc2:	89 c7                	mov    %eax,%edi
  802cc4:	48 b8 46 20 80 00 00 	movabs $0x802046,%rax
  802ccb:	00 00 00 
  802cce:	ff d0                	callq  *%rax
			return write_size;
  802cd0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802cd3:	e9 a1 00 00 00       	jmpq   802d79 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802cd8:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802cdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce2:	ba 00 02 00 00       	mov    $0x200,%edx
  802ce7:	48 89 ce             	mov    %rcx,%rsi
  802cea:	89 c7                	mov    %eax,%edi
  802cec:	48 b8 68 22 80 00 00 	movabs $0x802268,%rax
  802cf3:	00 00 00 
  802cf6:	ff d0                	callq  *%rax
  802cf8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802cfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802cff:	0f 8f 5f ff ff ff    	jg     802c64 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802d05:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d09:	79 47                	jns    802d52 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802d0b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d0e:	89 c6                	mov    %eax,%esi
  802d10:	48 bf 4c 48 80 00 00 	movabs $0x80484c,%rdi
  802d17:	00 00 00 
  802d1a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1f:	48 ba 8c 04 80 00 00 	movabs $0x80048c,%rdx
  802d26:	00 00 00 
  802d29:	ff d2                	callq  *%rdx
		close(fd_src);
  802d2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d2e:	89 c7                	mov    %eax,%edi
  802d30:	48 b8 46 20 80 00 00 	movabs $0x802046,%rax
  802d37:	00 00 00 
  802d3a:	ff d0                	callq  *%rax
		close(fd_dest);
  802d3c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d3f:	89 c7                	mov    %eax,%edi
  802d41:	48 b8 46 20 80 00 00 	movabs $0x802046,%rax
  802d48:	00 00 00 
  802d4b:	ff d0                	callq  *%rax
		return read_size;
  802d4d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d50:	eb 27                	jmp    802d79 <copy+0x1d9>
	}
	close(fd_src);
  802d52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d55:	89 c7                	mov    %eax,%edi
  802d57:	48 b8 46 20 80 00 00 	movabs $0x802046,%rax
  802d5e:	00 00 00 
  802d61:	ff d0                	callq  *%rax
	close(fd_dest);
  802d63:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d66:	89 c7                	mov    %eax,%edi
  802d68:	48 b8 46 20 80 00 00 	movabs $0x802046,%rax
  802d6f:	00 00 00 
  802d72:	ff d0                	callq  *%rax
	return 0;
  802d74:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802d79:	c9                   	leaveq 
  802d7a:	c3                   	retq   

0000000000802d7b <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802d7b:	55                   	push   %rbp
  802d7c:	48 89 e5             	mov    %rsp,%rbp
  802d7f:	48 83 ec 20          	sub    $0x20,%rsp
  802d83:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802d86:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d8a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d8d:	48 89 d6             	mov    %rdx,%rsi
  802d90:	89 c7                	mov    %eax,%edi
  802d92:	48 b8 36 1e 80 00 00 	movabs $0x801e36,%rax
  802d99:	00 00 00 
  802d9c:	ff d0                	callq  *%rax
  802d9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da5:	79 05                	jns    802dac <fd2sockid+0x31>
		return r;
  802da7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802daa:	eb 24                	jmp    802dd0 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802dac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db0:	8b 10                	mov    (%rax),%edx
  802db2:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802db9:	00 00 00 
  802dbc:	8b 00                	mov    (%rax),%eax
  802dbe:	39 c2                	cmp    %eax,%edx
  802dc0:	74 07                	je     802dc9 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802dc2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dc7:	eb 07                	jmp    802dd0 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802dc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dcd:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802dd0:	c9                   	leaveq 
  802dd1:	c3                   	retq   

0000000000802dd2 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802dd2:	55                   	push   %rbp
  802dd3:	48 89 e5             	mov    %rsp,%rbp
  802dd6:	48 83 ec 20          	sub    $0x20,%rsp
  802dda:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802ddd:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802de1:	48 89 c7             	mov    %rax,%rdi
  802de4:	48 b8 9e 1d 80 00 00 	movabs $0x801d9e,%rax
  802deb:	00 00 00 
  802dee:	ff d0                	callq  *%rax
  802df0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802df3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802df7:	78 26                	js     802e1f <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802df9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dfd:	ba 07 04 00 00       	mov    $0x407,%edx
  802e02:	48 89 c6             	mov    %rax,%rsi
  802e05:	bf 00 00 00 00       	mov    $0x0,%edi
  802e0a:	48 b8 70 19 80 00 00 	movabs $0x801970,%rax
  802e11:	00 00 00 
  802e14:	ff d0                	callq  *%rax
  802e16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e1d:	79 16                	jns    802e35 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802e1f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e22:	89 c7                	mov    %eax,%edi
  802e24:	48 b8 df 32 80 00 00 	movabs $0x8032df,%rax
  802e2b:	00 00 00 
  802e2e:	ff d0                	callq  *%rax
		return r;
  802e30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e33:	eb 3a                	jmp    802e6f <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802e35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e39:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802e40:	00 00 00 
  802e43:	8b 12                	mov    (%rdx),%edx
  802e45:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802e47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e4b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802e52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e56:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802e59:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802e5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e60:	48 89 c7             	mov    %rax,%rdi
  802e63:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  802e6a:	00 00 00 
  802e6d:	ff d0                	callq  *%rax
}
  802e6f:	c9                   	leaveq 
  802e70:	c3                   	retq   

0000000000802e71 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802e71:	55                   	push   %rbp
  802e72:	48 89 e5             	mov    %rsp,%rbp
  802e75:	48 83 ec 30          	sub    $0x30,%rsp
  802e79:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e7c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e80:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e84:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e87:	89 c7                	mov    %eax,%edi
  802e89:	48 b8 7b 2d 80 00 00 	movabs $0x802d7b,%rax
  802e90:	00 00 00 
  802e93:	ff d0                	callq  *%rax
  802e95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e9c:	79 05                	jns    802ea3 <accept+0x32>
		return r;
  802e9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea1:	eb 3b                	jmp    802ede <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802ea3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ea7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802eab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eae:	48 89 ce             	mov    %rcx,%rsi
  802eb1:	89 c7                	mov    %eax,%edi
  802eb3:	48 b8 bc 31 80 00 00 	movabs $0x8031bc,%rax
  802eba:	00 00 00 
  802ebd:	ff d0                	callq  *%rax
  802ebf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ec2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec6:	79 05                	jns    802ecd <accept+0x5c>
		return r;
  802ec8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ecb:	eb 11                	jmp    802ede <accept+0x6d>
	return alloc_sockfd(r);
  802ecd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed0:	89 c7                	mov    %eax,%edi
  802ed2:	48 b8 d2 2d 80 00 00 	movabs $0x802dd2,%rax
  802ed9:	00 00 00 
  802edc:	ff d0                	callq  *%rax
}
  802ede:	c9                   	leaveq 
  802edf:	c3                   	retq   

0000000000802ee0 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802ee0:	55                   	push   %rbp
  802ee1:	48 89 e5             	mov    %rsp,%rbp
  802ee4:	48 83 ec 20          	sub    $0x20,%rsp
  802ee8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802eeb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802eef:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ef2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ef5:	89 c7                	mov    %eax,%edi
  802ef7:	48 b8 7b 2d 80 00 00 	movabs $0x802d7b,%rax
  802efe:	00 00 00 
  802f01:	ff d0                	callq  *%rax
  802f03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f0a:	79 05                	jns    802f11 <bind+0x31>
		return r;
  802f0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f0f:	eb 1b                	jmp    802f2c <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802f11:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f14:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f1b:	48 89 ce             	mov    %rcx,%rsi
  802f1e:	89 c7                	mov    %eax,%edi
  802f20:	48 b8 3b 32 80 00 00 	movabs $0x80323b,%rax
  802f27:	00 00 00 
  802f2a:	ff d0                	callq  *%rax
}
  802f2c:	c9                   	leaveq 
  802f2d:	c3                   	retq   

0000000000802f2e <shutdown>:

int
shutdown(int s, int how)
{
  802f2e:	55                   	push   %rbp
  802f2f:	48 89 e5             	mov    %rsp,%rbp
  802f32:	48 83 ec 20          	sub    $0x20,%rsp
  802f36:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f39:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f3c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f3f:	89 c7                	mov    %eax,%edi
  802f41:	48 b8 7b 2d 80 00 00 	movabs $0x802d7b,%rax
  802f48:	00 00 00 
  802f4b:	ff d0                	callq  *%rax
  802f4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f54:	79 05                	jns    802f5b <shutdown+0x2d>
		return r;
  802f56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f59:	eb 16                	jmp    802f71 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802f5b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f61:	89 d6                	mov    %edx,%esi
  802f63:	89 c7                	mov    %eax,%edi
  802f65:	48 b8 9f 32 80 00 00 	movabs $0x80329f,%rax
  802f6c:	00 00 00 
  802f6f:	ff d0                	callq  *%rax
}
  802f71:	c9                   	leaveq 
  802f72:	c3                   	retq   

0000000000802f73 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802f73:	55                   	push   %rbp
  802f74:	48 89 e5             	mov    %rsp,%rbp
  802f77:	48 83 ec 10          	sub    $0x10,%rsp
  802f7b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802f7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f83:	48 89 c7             	mov    %rax,%rdi
  802f86:	48 b8 42 41 80 00 00 	movabs $0x804142,%rax
  802f8d:	00 00 00 
  802f90:	ff d0                	callq  *%rax
  802f92:	83 f8 01             	cmp    $0x1,%eax
  802f95:	75 17                	jne    802fae <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802f97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f9b:	8b 40 0c             	mov    0xc(%rax),%eax
  802f9e:	89 c7                	mov    %eax,%edi
  802fa0:	48 b8 df 32 80 00 00 	movabs $0x8032df,%rax
  802fa7:	00 00 00 
  802faa:	ff d0                	callq  *%rax
  802fac:	eb 05                	jmp    802fb3 <devsock_close+0x40>
	else
		return 0;
  802fae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fb3:	c9                   	leaveq 
  802fb4:	c3                   	retq   

0000000000802fb5 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802fb5:	55                   	push   %rbp
  802fb6:	48 89 e5             	mov    %rsp,%rbp
  802fb9:	48 83 ec 20          	sub    $0x20,%rsp
  802fbd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fc0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fc4:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fc7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fca:	89 c7                	mov    %eax,%edi
  802fcc:	48 b8 7b 2d 80 00 00 	movabs $0x802d7b,%rax
  802fd3:	00 00 00 
  802fd6:	ff d0                	callq  *%rax
  802fd8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fdb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fdf:	79 05                	jns    802fe6 <connect+0x31>
		return r;
  802fe1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe4:	eb 1b                	jmp    803001 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802fe6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fe9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802fed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff0:	48 89 ce             	mov    %rcx,%rsi
  802ff3:	89 c7                	mov    %eax,%edi
  802ff5:	48 b8 0c 33 80 00 00 	movabs $0x80330c,%rax
  802ffc:	00 00 00 
  802fff:	ff d0                	callq  *%rax
}
  803001:	c9                   	leaveq 
  803002:	c3                   	retq   

0000000000803003 <listen>:

int
listen(int s, int backlog)
{
  803003:	55                   	push   %rbp
  803004:	48 89 e5             	mov    %rsp,%rbp
  803007:	48 83 ec 20          	sub    $0x20,%rsp
  80300b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80300e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803011:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803014:	89 c7                	mov    %eax,%edi
  803016:	48 b8 7b 2d 80 00 00 	movabs $0x802d7b,%rax
  80301d:	00 00 00 
  803020:	ff d0                	callq  *%rax
  803022:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803025:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803029:	79 05                	jns    803030 <listen+0x2d>
		return r;
  80302b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80302e:	eb 16                	jmp    803046 <listen+0x43>
	return nsipc_listen(r, backlog);
  803030:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803033:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803036:	89 d6                	mov    %edx,%esi
  803038:	89 c7                	mov    %eax,%edi
  80303a:	48 b8 70 33 80 00 00 	movabs $0x803370,%rax
  803041:	00 00 00 
  803044:	ff d0                	callq  *%rax
}
  803046:	c9                   	leaveq 
  803047:	c3                   	retq   

0000000000803048 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803048:	55                   	push   %rbp
  803049:	48 89 e5             	mov    %rsp,%rbp
  80304c:	48 83 ec 20          	sub    $0x20,%rsp
  803050:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803054:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803058:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80305c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803060:	89 c2                	mov    %eax,%edx
  803062:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803066:	8b 40 0c             	mov    0xc(%rax),%eax
  803069:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80306d:	b9 00 00 00 00       	mov    $0x0,%ecx
  803072:	89 c7                	mov    %eax,%edi
  803074:	48 b8 b0 33 80 00 00 	movabs $0x8033b0,%rax
  80307b:	00 00 00 
  80307e:	ff d0                	callq  *%rax
}
  803080:	c9                   	leaveq 
  803081:	c3                   	retq   

0000000000803082 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803082:	55                   	push   %rbp
  803083:	48 89 e5             	mov    %rsp,%rbp
  803086:	48 83 ec 20          	sub    $0x20,%rsp
  80308a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80308e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803092:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803096:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80309a:	89 c2                	mov    %eax,%edx
  80309c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030a0:	8b 40 0c             	mov    0xc(%rax),%eax
  8030a3:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8030a7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8030ac:	89 c7                	mov    %eax,%edi
  8030ae:	48 b8 7c 34 80 00 00 	movabs $0x80347c,%rax
  8030b5:	00 00 00 
  8030b8:	ff d0                	callq  *%rax
}
  8030ba:	c9                   	leaveq 
  8030bb:	c3                   	retq   

00000000008030bc <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8030bc:	55                   	push   %rbp
  8030bd:	48 89 e5             	mov    %rsp,%rbp
  8030c0:	48 83 ec 10          	sub    $0x10,%rsp
  8030c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8030cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d0:	48 be 67 48 80 00 00 	movabs $0x804867,%rsi
  8030d7:	00 00 00 
  8030da:	48 89 c7             	mov    %rax,%rdi
  8030dd:	48 b8 41 10 80 00 00 	movabs $0x801041,%rax
  8030e4:	00 00 00 
  8030e7:	ff d0                	callq  *%rax
	return 0;
  8030e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030ee:	c9                   	leaveq 
  8030ef:	c3                   	retq   

00000000008030f0 <socket>:

int
socket(int domain, int type, int protocol)
{
  8030f0:	55                   	push   %rbp
  8030f1:	48 89 e5             	mov    %rsp,%rbp
  8030f4:	48 83 ec 20          	sub    $0x20,%rsp
  8030f8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030fb:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8030fe:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803101:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803104:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803107:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80310a:	89 ce                	mov    %ecx,%esi
  80310c:	89 c7                	mov    %eax,%edi
  80310e:	48 b8 34 35 80 00 00 	movabs $0x803534,%rax
  803115:	00 00 00 
  803118:	ff d0                	callq  *%rax
  80311a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80311d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803121:	79 05                	jns    803128 <socket+0x38>
		return r;
  803123:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803126:	eb 11                	jmp    803139 <socket+0x49>
	return alloc_sockfd(r);
  803128:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80312b:	89 c7                	mov    %eax,%edi
  80312d:	48 b8 d2 2d 80 00 00 	movabs $0x802dd2,%rax
  803134:	00 00 00 
  803137:	ff d0                	callq  *%rax
}
  803139:	c9                   	leaveq 
  80313a:	c3                   	retq   

000000000080313b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80313b:	55                   	push   %rbp
  80313c:	48 89 e5             	mov    %rsp,%rbp
  80313f:	48 83 ec 10          	sub    $0x10,%rsp
  803143:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803146:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80314d:	00 00 00 
  803150:	8b 00                	mov    (%rax),%eax
  803152:	85 c0                	test   %eax,%eax
  803154:	75 1d                	jne    803173 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803156:	bf 02 00 00 00       	mov    $0x2,%edi
  80315b:	48 b8 d0 40 80 00 00 	movabs $0x8040d0,%rax
  803162:	00 00 00 
  803165:	ff d0                	callq  *%rax
  803167:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  80316e:	00 00 00 
  803171:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803173:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80317a:	00 00 00 
  80317d:	8b 00                	mov    (%rax),%eax
  80317f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803182:	b9 07 00 00 00       	mov    $0x7,%ecx
  803187:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80318e:	00 00 00 
  803191:	89 c7                	mov    %eax,%edi
  803193:	48 b8 c4 3e 80 00 00 	movabs $0x803ec4,%rax
  80319a:	00 00 00 
  80319d:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80319f:	ba 00 00 00 00       	mov    $0x0,%edx
  8031a4:	be 00 00 00 00       	mov    $0x0,%esi
  8031a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8031ae:	48 b8 03 3e 80 00 00 	movabs $0x803e03,%rax
  8031b5:	00 00 00 
  8031b8:	ff d0                	callq  *%rax
}
  8031ba:	c9                   	leaveq 
  8031bb:	c3                   	retq   

00000000008031bc <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8031bc:	55                   	push   %rbp
  8031bd:	48 89 e5             	mov    %rsp,%rbp
  8031c0:	48 83 ec 30          	sub    $0x30,%rsp
  8031c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8031cf:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031d6:	00 00 00 
  8031d9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031dc:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8031de:	bf 01 00 00 00       	mov    $0x1,%edi
  8031e3:	48 b8 3b 31 80 00 00 	movabs $0x80313b,%rax
  8031ea:	00 00 00 
  8031ed:	ff d0                	callq  *%rax
  8031ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031f6:	78 3e                	js     803236 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8031f8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031ff:	00 00 00 
  803202:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803206:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80320a:	8b 40 10             	mov    0x10(%rax),%eax
  80320d:	89 c2                	mov    %eax,%edx
  80320f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803213:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803217:	48 89 ce             	mov    %rcx,%rsi
  80321a:	48 89 c7             	mov    %rax,%rdi
  80321d:	48 b8 65 13 80 00 00 	movabs $0x801365,%rax
  803224:	00 00 00 
  803227:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803229:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80322d:	8b 50 10             	mov    0x10(%rax),%edx
  803230:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803234:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803236:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803239:	c9                   	leaveq 
  80323a:	c3                   	retq   

000000000080323b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80323b:	55                   	push   %rbp
  80323c:	48 89 e5             	mov    %rsp,%rbp
  80323f:	48 83 ec 10          	sub    $0x10,%rsp
  803243:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803246:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80324a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80324d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803254:	00 00 00 
  803257:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80325a:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80325c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80325f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803263:	48 89 c6             	mov    %rax,%rsi
  803266:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80326d:	00 00 00 
  803270:	48 b8 65 13 80 00 00 	movabs $0x801365,%rax
  803277:	00 00 00 
  80327a:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80327c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803283:	00 00 00 
  803286:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803289:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80328c:	bf 02 00 00 00       	mov    $0x2,%edi
  803291:	48 b8 3b 31 80 00 00 	movabs $0x80313b,%rax
  803298:	00 00 00 
  80329b:	ff d0                	callq  *%rax
}
  80329d:	c9                   	leaveq 
  80329e:	c3                   	retq   

000000000080329f <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80329f:	55                   	push   %rbp
  8032a0:	48 89 e5             	mov    %rsp,%rbp
  8032a3:	48 83 ec 10          	sub    $0x10,%rsp
  8032a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032aa:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8032ad:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032b4:	00 00 00 
  8032b7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032ba:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8032bc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032c3:	00 00 00 
  8032c6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032c9:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8032cc:	bf 03 00 00 00       	mov    $0x3,%edi
  8032d1:	48 b8 3b 31 80 00 00 	movabs $0x80313b,%rax
  8032d8:	00 00 00 
  8032db:	ff d0                	callq  *%rax
}
  8032dd:	c9                   	leaveq 
  8032de:	c3                   	retq   

00000000008032df <nsipc_close>:

int
nsipc_close(int s)
{
  8032df:	55                   	push   %rbp
  8032e0:	48 89 e5             	mov    %rsp,%rbp
  8032e3:	48 83 ec 10          	sub    $0x10,%rsp
  8032e7:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8032ea:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032f1:	00 00 00 
  8032f4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032f7:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8032f9:	bf 04 00 00 00       	mov    $0x4,%edi
  8032fe:	48 b8 3b 31 80 00 00 	movabs $0x80313b,%rax
  803305:	00 00 00 
  803308:	ff d0                	callq  *%rax
}
  80330a:	c9                   	leaveq 
  80330b:	c3                   	retq   

000000000080330c <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80330c:	55                   	push   %rbp
  80330d:	48 89 e5             	mov    %rsp,%rbp
  803310:	48 83 ec 10          	sub    $0x10,%rsp
  803314:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803317:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80331b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80331e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803325:	00 00 00 
  803328:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80332b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80332d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803330:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803334:	48 89 c6             	mov    %rax,%rsi
  803337:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80333e:	00 00 00 
  803341:	48 b8 65 13 80 00 00 	movabs $0x801365,%rax
  803348:	00 00 00 
  80334b:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80334d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803354:	00 00 00 
  803357:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80335a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80335d:	bf 05 00 00 00       	mov    $0x5,%edi
  803362:	48 b8 3b 31 80 00 00 	movabs $0x80313b,%rax
  803369:	00 00 00 
  80336c:	ff d0                	callq  *%rax
}
  80336e:	c9                   	leaveq 
  80336f:	c3                   	retq   

0000000000803370 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803370:	55                   	push   %rbp
  803371:	48 89 e5             	mov    %rsp,%rbp
  803374:	48 83 ec 10          	sub    $0x10,%rsp
  803378:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80337b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80337e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803385:	00 00 00 
  803388:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80338b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80338d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803394:	00 00 00 
  803397:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80339a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80339d:	bf 06 00 00 00       	mov    $0x6,%edi
  8033a2:	48 b8 3b 31 80 00 00 	movabs $0x80313b,%rax
  8033a9:	00 00 00 
  8033ac:	ff d0                	callq  *%rax
}
  8033ae:	c9                   	leaveq 
  8033af:	c3                   	retq   

00000000008033b0 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8033b0:	55                   	push   %rbp
  8033b1:	48 89 e5             	mov    %rsp,%rbp
  8033b4:	48 83 ec 30          	sub    $0x30,%rsp
  8033b8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033bf:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8033c2:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8033c5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033cc:	00 00 00 
  8033cf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8033d2:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8033d4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033db:	00 00 00 
  8033de:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033e1:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8033e4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033eb:	00 00 00 
  8033ee:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8033f1:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8033f4:	bf 07 00 00 00       	mov    $0x7,%edi
  8033f9:	48 b8 3b 31 80 00 00 	movabs $0x80313b,%rax
  803400:	00 00 00 
  803403:	ff d0                	callq  *%rax
  803405:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803408:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80340c:	78 69                	js     803477 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80340e:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803415:	7f 08                	jg     80341f <nsipc_recv+0x6f>
  803417:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80341a:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80341d:	7e 35                	jle    803454 <nsipc_recv+0xa4>
  80341f:	48 b9 6e 48 80 00 00 	movabs $0x80486e,%rcx
  803426:	00 00 00 
  803429:	48 ba 83 48 80 00 00 	movabs $0x804883,%rdx
  803430:	00 00 00 
  803433:	be 62 00 00 00       	mov    $0x62,%esi
  803438:	48 bf 98 48 80 00 00 	movabs $0x804898,%rdi
  80343f:	00 00 00 
  803442:	b8 00 00 00 00       	mov    $0x0,%eax
  803447:	49 b8 53 02 80 00 00 	movabs $0x800253,%r8
  80344e:	00 00 00 
  803451:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803454:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803457:	48 63 d0             	movslq %eax,%rdx
  80345a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80345e:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803465:	00 00 00 
  803468:	48 89 c7             	mov    %rax,%rdi
  80346b:	48 b8 65 13 80 00 00 	movabs $0x801365,%rax
  803472:	00 00 00 
  803475:	ff d0                	callq  *%rax
	}

	return r;
  803477:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80347a:	c9                   	leaveq 
  80347b:	c3                   	retq   

000000000080347c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80347c:	55                   	push   %rbp
  80347d:	48 89 e5             	mov    %rsp,%rbp
  803480:	48 83 ec 20          	sub    $0x20,%rsp
  803484:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803487:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80348b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80348e:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803491:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803498:	00 00 00 
  80349b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80349e:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8034a0:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8034a7:	7e 35                	jle    8034de <nsipc_send+0x62>
  8034a9:	48 b9 a4 48 80 00 00 	movabs $0x8048a4,%rcx
  8034b0:	00 00 00 
  8034b3:	48 ba 83 48 80 00 00 	movabs $0x804883,%rdx
  8034ba:	00 00 00 
  8034bd:	be 6d 00 00 00       	mov    $0x6d,%esi
  8034c2:	48 bf 98 48 80 00 00 	movabs $0x804898,%rdi
  8034c9:	00 00 00 
  8034cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d1:	49 b8 53 02 80 00 00 	movabs $0x800253,%r8
  8034d8:	00 00 00 
  8034db:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8034de:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034e1:	48 63 d0             	movslq %eax,%rdx
  8034e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034e8:	48 89 c6             	mov    %rax,%rsi
  8034eb:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8034f2:	00 00 00 
  8034f5:	48 b8 65 13 80 00 00 	movabs $0x801365,%rax
  8034fc:	00 00 00 
  8034ff:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803501:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803508:	00 00 00 
  80350b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80350e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803511:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803518:	00 00 00 
  80351b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80351e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803521:	bf 08 00 00 00       	mov    $0x8,%edi
  803526:	48 b8 3b 31 80 00 00 	movabs $0x80313b,%rax
  80352d:	00 00 00 
  803530:	ff d0                	callq  *%rax
}
  803532:	c9                   	leaveq 
  803533:	c3                   	retq   

0000000000803534 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803534:	55                   	push   %rbp
  803535:	48 89 e5             	mov    %rsp,%rbp
  803538:	48 83 ec 10          	sub    $0x10,%rsp
  80353c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80353f:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803542:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803545:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80354c:	00 00 00 
  80354f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803552:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803554:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80355b:	00 00 00 
  80355e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803561:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803564:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80356b:	00 00 00 
  80356e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803571:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803574:	bf 09 00 00 00       	mov    $0x9,%edi
  803579:	48 b8 3b 31 80 00 00 	movabs $0x80313b,%rax
  803580:	00 00 00 
  803583:	ff d0                	callq  *%rax
}
  803585:	c9                   	leaveq 
  803586:	c3                   	retq   

0000000000803587 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803587:	55                   	push   %rbp
  803588:	48 89 e5             	mov    %rsp,%rbp
  80358b:	53                   	push   %rbx
  80358c:	48 83 ec 38          	sub    $0x38,%rsp
  803590:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803594:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803598:	48 89 c7             	mov    %rax,%rdi
  80359b:	48 b8 9e 1d 80 00 00 	movabs $0x801d9e,%rax
  8035a2:	00 00 00 
  8035a5:	ff d0                	callq  *%rax
  8035a7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035ae:	0f 88 bf 01 00 00    	js     803773 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035b8:	ba 07 04 00 00       	mov    $0x407,%edx
  8035bd:	48 89 c6             	mov    %rax,%rsi
  8035c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8035c5:	48 b8 70 19 80 00 00 	movabs $0x801970,%rax
  8035cc:	00 00 00 
  8035cf:	ff d0                	callq  *%rax
  8035d1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035d8:	0f 88 95 01 00 00    	js     803773 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8035de:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8035e2:	48 89 c7             	mov    %rax,%rdi
  8035e5:	48 b8 9e 1d 80 00 00 	movabs $0x801d9e,%rax
  8035ec:	00 00 00 
  8035ef:	ff d0                	callq  *%rax
  8035f1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035f8:	0f 88 5d 01 00 00    	js     80375b <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803602:	ba 07 04 00 00       	mov    $0x407,%edx
  803607:	48 89 c6             	mov    %rax,%rsi
  80360a:	bf 00 00 00 00       	mov    $0x0,%edi
  80360f:	48 b8 70 19 80 00 00 	movabs $0x801970,%rax
  803616:	00 00 00 
  803619:	ff d0                	callq  *%rax
  80361b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80361e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803622:	0f 88 33 01 00 00    	js     80375b <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803628:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80362c:	48 89 c7             	mov    %rax,%rdi
  80362f:	48 b8 73 1d 80 00 00 	movabs $0x801d73,%rax
  803636:	00 00 00 
  803639:	ff d0                	callq  *%rax
  80363b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80363f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803643:	ba 07 04 00 00       	mov    $0x407,%edx
  803648:	48 89 c6             	mov    %rax,%rsi
  80364b:	bf 00 00 00 00       	mov    $0x0,%edi
  803650:	48 b8 70 19 80 00 00 	movabs $0x801970,%rax
  803657:	00 00 00 
  80365a:	ff d0                	callq  *%rax
  80365c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80365f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803663:	79 05                	jns    80366a <pipe+0xe3>
		goto err2;
  803665:	e9 d9 00 00 00       	jmpq   803743 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80366a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80366e:	48 89 c7             	mov    %rax,%rdi
  803671:	48 b8 73 1d 80 00 00 	movabs $0x801d73,%rax
  803678:	00 00 00 
  80367b:	ff d0                	callq  *%rax
  80367d:	48 89 c2             	mov    %rax,%rdx
  803680:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803684:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80368a:	48 89 d1             	mov    %rdx,%rcx
  80368d:	ba 00 00 00 00       	mov    $0x0,%edx
  803692:	48 89 c6             	mov    %rax,%rsi
  803695:	bf 00 00 00 00       	mov    $0x0,%edi
  80369a:	48 b8 c0 19 80 00 00 	movabs $0x8019c0,%rax
  8036a1:	00 00 00 
  8036a4:	ff d0                	callq  *%rax
  8036a6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036ad:	79 1b                	jns    8036ca <pipe+0x143>
		goto err3;
  8036af:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8036b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036b4:	48 89 c6             	mov    %rax,%rsi
  8036b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8036bc:	48 b8 1b 1a 80 00 00 	movabs $0x801a1b,%rax
  8036c3:	00 00 00 
  8036c6:	ff d0                	callq  *%rax
  8036c8:	eb 79                	jmp    803743 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8036ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036ce:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8036d5:	00 00 00 
  8036d8:	8b 12                	mov    (%rdx),%edx
  8036da:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8036dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036e0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8036e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036eb:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8036f2:	00 00 00 
  8036f5:	8b 12                	mov    (%rdx),%edx
  8036f7:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8036f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036fd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803704:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803708:	48 89 c7             	mov    %rax,%rdi
  80370b:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  803712:	00 00 00 
  803715:	ff d0                	callq  *%rax
  803717:	89 c2                	mov    %eax,%edx
  803719:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80371d:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80371f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803723:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803727:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80372b:	48 89 c7             	mov    %rax,%rdi
  80372e:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  803735:	00 00 00 
  803738:	ff d0                	callq  *%rax
  80373a:	89 03                	mov    %eax,(%rbx)
	return 0;
  80373c:	b8 00 00 00 00       	mov    $0x0,%eax
  803741:	eb 33                	jmp    803776 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803743:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803747:	48 89 c6             	mov    %rax,%rsi
  80374a:	bf 00 00 00 00       	mov    $0x0,%edi
  80374f:	48 b8 1b 1a 80 00 00 	movabs $0x801a1b,%rax
  803756:	00 00 00 
  803759:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80375b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80375f:	48 89 c6             	mov    %rax,%rsi
  803762:	bf 00 00 00 00       	mov    $0x0,%edi
  803767:	48 b8 1b 1a 80 00 00 	movabs $0x801a1b,%rax
  80376e:	00 00 00 
  803771:	ff d0                	callq  *%rax
err:
	return r;
  803773:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803776:	48 83 c4 38          	add    $0x38,%rsp
  80377a:	5b                   	pop    %rbx
  80377b:	5d                   	pop    %rbp
  80377c:	c3                   	retq   

000000000080377d <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80377d:	55                   	push   %rbp
  80377e:	48 89 e5             	mov    %rsp,%rbp
  803781:	53                   	push   %rbx
  803782:	48 83 ec 28          	sub    $0x28,%rsp
  803786:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80378a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80378e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803795:	00 00 00 
  803798:	48 8b 00             	mov    (%rax),%rax
  80379b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8037a1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8037a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037a8:	48 89 c7             	mov    %rax,%rdi
  8037ab:	48 b8 42 41 80 00 00 	movabs $0x804142,%rax
  8037b2:	00 00 00 
  8037b5:	ff d0                	callq  *%rax
  8037b7:	89 c3                	mov    %eax,%ebx
  8037b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037bd:	48 89 c7             	mov    %rax,%rdi
  8037c0:	48 b8 42 41 80 00 00 	movabs $0x804142,%rax
  8037c7:	00 00 00 
  8037ca:	ff d0                	callq  *%rax
  8037cc:	39 c3                	cmp    %eax,%ebx
  8037ce:	0f 94 c0             	sete   %al
  8037d1:	0f b6 c0             	movzbl %al,%eax
  8037d4:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8037d7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8037de:	00 00 00 
  8037e1:	48 8b 00             	mov    (%rax),%rax
  8037e4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8037ea:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8037ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037f0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8037f3:	75 05                	jne    8037fa <_pipeisclosed+0x7d>
			return ret;
  8037f5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8037f8:	eb 4f                	jmp    803849 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8037fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037fd:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803800:	74 42                	je     803844 <_pipeisclosed+0xc7>
  803802:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803806:	75 3c                	jne    803844 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803808:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80380f:	00 00 00 
  803812:	48 8b 00             	mov    (%rax),%rax
  803815:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80381b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80381e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803821:	89 c6                	mov    %eax,%esi
  803823:	48 bf b5 48 80 00 00 	movabs $0x8048b5,%rdi
  80382a:	00 00 00 
  80382d:	b8 00 00 00 00       	mov    $0x0,%eax
  803832:	49 b8 8c 04 80 00 00 	movabs $0x80048c,%r8
  803839:	00 00 00 
  80383c:	41 ff d0             	callq  *%r8
	}
  80383f:	e9 4a ff ff ff       	jmpq   80378e <_pipeisclosed+0x11>
  803844:	e9 45 ff ff ff       	jmpq   80378e <_pipeisclosed+0x11>

}
  803849:	48 83 c4 28          	add    $0x28,%rsp
  80384d:	5b                   	pop    %rbx
  80384e:	5d                   	pop    %rbp
  80384f:	c3                   	retq   

0000000000803850 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803850:	55                   	push   %rbp
  803851:	48 89 e5             	mov    %rsp,%rbp
  803854:	48 83 ec 30          	sub    $0x30,%rsp
  803858:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80385b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80385f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803862:	48 89 d6             	mov    %rdx,%rsi
  803865:	89 c7                	mov    %eax,%edi
  803867:	48 b8 36 1e 80 00 00 	movabs $0x801e36,%rax
  80386e:	00 00 00 
  803871:	ff d0                	callq  *%rax
  803873:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803876:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80387a:	79 05                	jns    803881 <pipeisclosed+0x31>
		return r;
  80387c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80387f:	eb 31                	jmp    8038b2 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803881:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803885:	48 89 c7             	mov    %rax,%rdi
  803888:	48 b8 73 1d 80 00 00 	movabs $0x801d73,%rax
  80388f:	00 00 00 
  803892:	ff d0                	callq  *%rax
  803894:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80389c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038a0:	48 89 d6             	mov    %rdx,%rsi
  8038a3:	48 89 c7             	mov    %rax,%rdi
  8038a6:	48 b8 7d 37 80 00 00 	movabs $0x80377d,%rax
  8038ad:	00 00 00 
  8038b0:	ff d0                	callq  *%rax
}
  8038b2:	c9                   	leaveq 
  8038b3:	c3                   	retq   

00000000008038b4 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8038b4:	55                   	push   %rbp
  8038b5:	48 89 e5             	mov    %rsp,%rbp
  8038b8:	48 83 ec 40          	sub    $0x40,%rsp
  8038bc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038c0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038c4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8038c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038cc:	48 89 c7             	mov    %rax,%rdi
  8038cf:	48 b8 73 1d 80 00 00 	movabs $0x801d73,%rax
  8038d6:	00 00 00 
  8038d9:	ff d0                	callq  *%rax
  8038db:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8038df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038e3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8038e7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8038ee:	00 
  8038ef:	e9 92 00 00 00       	jmpq   803986 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8038f4:	eb 41                	jmp    803937 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8038f6:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8038fb:	74 09                	je     803906 <devpipe_read+0x52>
				return i;
  8038fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803901:	e9 92 00 00 00       	jmpq   803998 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803906:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80390a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80390e:	48 89 d6             	mov    %rdx,%rsi
  803911:	48 89 c7             	mov    %rax,%rdi
  803914:	48 b8 7d 37 80 00 00 	movabs $0x80377d,%rax
  80391b:	00 00 00 
  80391e:	ff d0                	callq  *%rax
  803920:	85 c0                	test   %eax,%eax
  803922:	74 07                	je     80392b <devpipe_read+0x77>
				return 0;
  803924:	b8 00 00 00 00       	mov    $0x0,%eax
  803929:	eb 6d                	jmp    803998 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80392b:	48 b8 32 19 80 00 00 	movabs $0x801932,%rax
  803932:	00 00 00 
  803935:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803937:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80393b:	8b 10                	mov    (%rax),%edx
  80393d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803941:	8b 40 04             	mov    0x4(%rax),%eax
  803944:	39 c2                	cmp    %eax,%edx
  803946:	74 ae                	je     8038f6 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803948:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80394c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803950:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803954:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803958:	8b 00                	mov    (%rax),%eax
  80395a:	99                   	cltd   
  80395b:	c1 ea 1b             	shr    $0x1b,%edx
  80395e:	01 d0                	add    %edx,%eax
  803960:	83 e0 1f             	and    $0x1f,%eax
  803963:	29 d0                	sub    %edx,%eax
  803965:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803969:	48 98                	cltq   
  80396b:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803970:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803972:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803976:	8b 00                	mov    (%rax),%eax
  803978:	8d 50 01             	lea    0x1(%rax),%edx
  80397b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80397f:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803981:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803986:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80398a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80398e:	0f 82 60 ff ff ff    	jb     8038f4 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803994:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803998:	c9                   	leaveq 
  803999:	c3                   	retq   

000000000080399a <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80399a:	55                   	push   %rbp
  80399b:	48 89 e5             	mov    %rsp,%rbp
  80399e:	48 83 ec 40          	sub    $0x40,%rsp
  8039a2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039a6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039aa:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8039ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039b2:	48 89 c7             	mov    %rax,%rdi
  8039b5:	48 b8 73 1d 80 00 00 	movabs $0x801d73,%rax
  8039bc:	00 00 00 
  8039bf:	ff d0                	callq  *%rax
  8039c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039c9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8039cd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039d4:	00 
  8039d5:	e9 8e 00 00 00       	jmpq   803a68 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8039da:	eb 31                	jmp    803a0d <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8039dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039e4:	48 89 d6             	mov    %rdx,%rsi
  8039e7:	48 89 c7             	mov    %rax,%rdi
  8039ea:	48 b8 7d 37 80 00 00 	movabs $0x80377d,%rax
  8039f1:	00 00 00 
  8039f4:	ff d0                	callq  *%rax
  8039f6:	85 c0                	test   %eax,%eax
  8039f8:	74 07                	je     803a01 <devpipe_write+0x67>
				return 0;
  8039fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ff:	eb 79                	jmp    803a7a <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803a01:	48 b8 32 19 80 00 00 	movabs $0x801932,%rax
  803a08:	00 00 00 
  803a0b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a11:	8b 40 04             	mov    0x4(%rax),%eax
  803a14:	48 63 d0             	movslq %eax,%rdx
  803a17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a1b:	8b 00                	mov    (%rax),%eax
  803a1d:	48 98                	cltq   
  803a1f:	48 83 c0 20          	add    $0x20,%rax
  803a23:	48 39 c2             	cmp    %rax,%rdx
  803a26:	73 b4                	jae    8039dc <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803a28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a2c:	8b 40 04             	mov    0x4(%rax),%eax
  803a2f:	99                   	cltd   
  803a30:	c1 ea 1b             	shr    $0x1b,%edx
  803a33:	01 d0                	add    %edx,%eax
  803a35:	83 e0 1f             	and    $0x1f,%eax
  803a38:	29 d0                	sub    %edx,%eax
  803a3a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a3e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803a42:	48 01 ca             	add    %rcx,%rdx
  803a45:	0f b6 0a             	movzbl (%rdx),%ecx
  803a48:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a4c:	48 98                	cltq   
  803a4e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803a52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a56:	8b 40 04             	mov    0x4(%rax),%eax
  803a59:	8d 50 01             	lea    0x1(%rax),%edx
  803a5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a60:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a63:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a6c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a70:	0f 82 64 ff ff ff    	jb     8039da <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803a76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803a7a:	c9                   	leaveq 
  803a7b:	c3                   	retq   

0000000000803a7c <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803a7c:	55                   	push   %rbp
  803a7d:	48 89 e5             	mov    %rsp,%rbp
  803a80:	48 83 ec 20          	sub    $0x20,%rsp
  803a84:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a88:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803a8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a90:	48 89 c7             	mov    %rax,%rdi
  803a93:	48 b8 73 1d 80 00 00 	movabs $0x801d73,%rax
  803a9a:	00 00 00 
  803a9d:	ff d0                	callq  *%rax
  803a9f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803aa3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aa7:	48 be c8 48 80 00 00 	movabs $0x8048c8,%rsi
  803aae:	00 00 00 
  803ab1:	48 89 c7             	mov    %rax,%rdi
  803ab4:	48 b8 41 10 80 00 00 	movabs $0x801041,%rax
  803abb:	00 00 00 
  803abe:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803ac0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ac4:	8b 50 04             	mov    0x4(%rax),%edx
  803ac7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803acb:	8b 00                	mov    (%rax),%eax
  803acd:	29 c2                	sub    %eax,%edx
  803acf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ad3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803ad9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803add:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803ae4:	00 00 00 
	stat->st_dev = &devpipe;
  803ae7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aeb:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803af2:	00 00 00 
  803af5:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803afc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b01:	c9                   	leaveq 
  803b02:	c3                   	retq   

0000000000803b03 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b03:	55                   	push   %rbp
  803b04:	48 89 e5             	mov    %rsp,%rbp
  803b07:	48 83 ec 10          	sub    $0x10,%rsp
  803b0b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  803b0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b13:	48 89 c6             	mov    %rax,%rsi
  803b16:	bf 00 00 00 00       	mov    $0x0,%edi
  803b1b:	48 b8 1b 1a 80 00 00 	movabs $0x801a1b,%rax
  803b22:	00 00 00 
  803b25:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  803b27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b2b:	48 89 c7             	mov    %rax,%rdi
  803b2e:	48 b8 73 1d 80 00 00 	movabs $0x801d73,%rax
  803b35:	00 00 00 
  803b38:	ff d0                	callq  *%rax
  803b3a:	48 89 c6             	mov    %rax,%rsi
  803b3d:	bf 00 00 00 00       	mov    $0x0,%edi
  803b42:	48 b8 1b 1a 80 00 00 	movabs $0x801a1b,%rax
  803b49:	00 00 00 
  803b4c:	ff d0                	callq  *%rax
}
  803b4e:	c9                   	leaveq 
  803b4f:	c3                   	retq   

0000000000803b50 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803b50:	55                   	push   %rbp
  803b51:	48 89 e5             	mov    %rsp,%rbp
  803b54:	48 83 ec 20          	sub    $0x20,%rsp
  803b58:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803b5b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b5e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803b61:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803b65:	be 01 00 00 00       	mov    $0x1,%esi
  803b6a:	48 89 c7             	mov    %rax,%rdi
  803b6d:	48 b8 28 18 80 00 00 	movabs $0x801828,%rax
  803b74:	00 00 00 
  803b77:	ff d0                	callq  *%rax
}
  803b79:	c9                   	leaveq 
  803b7a:	c3                   	retq   

0000000000803b7b <getchar>:

int
getchar(void)
{
  803b7b:	55                   	push   %rbp
  803b7c:	48 89 e5             	mov    %rsp,%rbp
  803b7f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803b83:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803b87:	ba 01 00 00 00       	mov    $0x1,%edx
  803b8c:	48 89 c6             	mov    %rax,%rsi
  803b8f:	bf 00 00 00 00       	mov    $0x0,%edi
  803b94:	48 b8 68 22 80 00 00 	movabs $0x802268,%rax
  803b9b:	00 00 00 
  803b9e:	ff d0                	callq  *%rax
  803ba0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803ba3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ba7:	79 05                	jns    803bae <getchar+0x33>
		return r;
  803ba9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bac:	eb 14                	jmp    803bc2 <getchar+0x47>
	if (r < 1)
  803bae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bb2:	7f 07                	jg     803bbb <getchar+0x40>
		return -E_EOF;
  803bb4:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803bb9:	eb 07                	jmp    803bc2 <getchar+0x47>
	return c;
  803bbb:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803bbf:	0f b6 c0             	movzbl %al,%eax

}
  803bc2:	c9                   	leaveq 
  803bc3:	c3                   	retq   

0000000000803bc4 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803bc4:	55                   	push   %rbp
  803bc5:	48 89 e5             	mov    %rsp,%rbp
  803bc8:	48 83 ec 20          	sub    $0x20,%rsp
  803bcc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803bcf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803bd3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bd6:	48 89 d6             	mov    %rdx,%rsi
  803bd9:	89 c7                	mov    %eax,%edi
  803bdb:	48 b8 36 1e 80 00 00 	movabs $0x801e36,%rax
  803be2:	00 00 00 
  803be5:	ff d0                	callq  *%rax
  803be7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bee:	79 05                	jns    803bf5 <iscons+0x31>
		return r;
  803bf0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf3:	eb 1a                	jmp    803c0f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803bf5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bf9:	8b 10                	mov    (%rax),%edx
  803bfb:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803c02:	00 00 00 
  803c05:	8b 00                	mov    (%rax),%eax
  803c07:	39 c2                	cmp    %eax,%edx
  803c09:	0f 94 c0             	sete   %al
  803c0c:	0f b6 c0             	movzbl %al,%eax
}
  803c0f:	c9                   	leaveq 
  803c10:	c3                   	retq   

0000000000803c11 <opencons>:

int
opencons(void)
{
  803c11:	55                   	push   %rbp
  803c12:	48 89 e5             	mov    %rsp,%rbp
  803c15:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803c19:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803c1d:	48 89 c7             	mov    %rax,%rdi
  803c20:	48 b8 9e 1d 80 00 00 	movabs $0x801d9e,%rax
  803c27:	00 00 00 
  803c2a:	ff d0                	callq  *%rax
  803c2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c33:	79 05                	jns    803c3a <opencons+0x29>
		return r;
  803c35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c38:	eb 5b                	jmp    803c95 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803c3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c3e:	ba 07 04 00 00       	mov    $0x407,%edx
  803c43:	48 89 c6             	mov    %rax,%rsi
  803c46:	bf 00 00 00 00       	mov    $0x0,%edi
  803c4b:	48 b8 70 19 80 00 00 	movabs $0x801970,%rax
  803c52:	00 00 00 
  803c55:	ff d0                	callq  *%rax
  803c57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c5e:	79 05                	jns    803c65 <opencons+0x54>
		return r;
  803c60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c63:	eb 30                	jmp    803c95 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803c65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c69:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803c70:	00 00 00 
  803c73:	8b 12                	mov    (%rdx),%edx
  803c75:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803c77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c7b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803c82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c86:	48 89 c7             	mov    %rax,%rdi
  803c89:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  803c90:	00 00 00 
  803c93:	ff d0                	callq  *%rax
}
  803c95:	c9                   	leaveq 
  803c96:	c3                   	retq   

0000000000803c97 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c97:	55                   	push   %rbp
  803c98:	48 89 e5             	mov    %rsp,%rbp
  803c9b:	48 83 ec 30          	sub    $0x30,%rsp
  803c9f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ca3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ca7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803cab:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cb0:	75 07                	jne    803cb9 <devcons_read+0x22>
		return 0;
  803cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  803cb7:	eb 4b                	jmp    803d04 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803cb9:	eb 0c                	jmp    803cc7 <devcons_read+0x30>
		sys_yield();
  803cbb:	48 b8 32 19 80 00 00 	movabs $0x801932,%rax
  803cc2:	00 00 00 
  803cc5:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803cc7:	48 b8 72 18 80 00 00 	movabs $0x801872,%rax
  803cce:	00 00 00 
  803cd1:	ff d0                	callq  *%rax
  803cd3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cd6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cda:	74 df                	je     803cbb <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803cdc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ce0:	79 05                	jns    803ce7 <devcons_read+0x50>
		return c;
  803ce2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ce5:	eb 1d                	jmp    803d04 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803ce7:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803ceb:	75 07                	jne    803cf4 <devcons_read+0x5d>
		return 0;
  803ced:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf2:	eb 10                	jmp    803d04 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803cf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cf7:	89 c2                	mov    %eax,%edx
  803cf9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cfd:	88 10                	mov    %dl,(%rax)
	return 1;
  803cff:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d04:	c9                   	leaveq 
  803d05:	c3                   	retq   

0000000000803d06 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d06:	55                   	push   %rbp
  803d07:	48 89 e5             	mov    %rsp,%rbp
  803d0a:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803d11:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803d18:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803d1f:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d2d:	eb 76                	jmp    803da5 <devcons_write+0x9f>
		m = n - tot;
  803d2f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803d36:	89 c2                	mov    %eax,%edx
  803d38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d3b:	29 c2                	sub    %eax,%edx
  803d3d:	89 d0                	mov    %edx,%eax
  803d3f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803d42:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d45:	83 f8 7f             	cmp    $0x7f,%eax
  803d48:	76 07                	jbe    803d51 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803d4a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803d51:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d54:	48 63 d0             	movslq %eax,%rdx
  803d57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5a:	48 63 c8             	movslq %eax,%rcx
  803d5d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803d64:	48 01 c1             	add    %rax,%rcx
  803d67:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d6e:	48 89 ce             	mov    %rcx,%rsi
  803d71:	48 89 c7             	mov    %rax,%rdi
  803d74:	48 b8 65 13 80 00 00 	movabs $0x801365,%rax
  803d7b:	00 00 00 
  803d7e:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803d80:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d83:	48 63 d0             	movslq %eax,%rdx
  803d86:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d8d:	48 89 d6             	mov    %rdx,%rsi
  803d90:	48 89 c7             	mov    %rax,%rdi
  803d93:	48 b8 28 18 80 00 00 	movabs $0x801828,%rax
  803d9a:	00 00 00 
  803d9d:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d9f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803da2:	01 45 fc             	add    %eax,-0x4(%rbp)
  803da5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803da8:	48 98                	cltq   
  803daa:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803db1:	0f 82 78 ff ff ff    	jb     803d2f <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803db7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803dba:	c9                   	leaveq 
  803dbb:	c3                   	retq   

0000000000803dbc <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803dbc:	55                   	push   %rbp
  803dbd:	48 89 e5             	mov    %rsp,%rbp
  803dc0:	48 83 ec 08          	sub    $0x8,%rsp
  803dc4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803dc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dcd:	c9                   	leaveq 
  803dce:	c3                   	retq   

0000000000803dcf <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803dcf:	55                   	push   %rbp
  803dd0:	48 89 e5             	mov    %rsp,%rbp
  803dd3:	48 83 ec 10          	sub    $0x10,%rsp
  803dd7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ddb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803ddf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803de3:	48 be d4 48 80 00 00 	movabs $0x8048d4,%rsi
  803dea:	00 00 00 
  803ded:	48 89 c7             	mov    %rax,%rdi
  803df0:	48 b8 41 10 80 00 00 	movabs $0x801041,%rax
  803df7:	00 00 00 
  803dfa:	ff d0                	callq  *%rax
	return 0;
  803dfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e01:	c9                   	leaveq 
  803e02:	c3                   	retq   

0000000000803e03 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e03:	55                   	push   %rbp
  803e04:	48 89 e5             	mov    %rsp,%rbp
  803e07:	48 83 ec 30          	sub    $0x30,%rsp
  803e0b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e0f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e13:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  803e17:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e1c:	75 0e                	jne    803e2c <ipc_recv+0x29>
		pg = (void*) UTOP;
  803e1e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e25:	00 00 00 
  803e28:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  803e2c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e30:	48 89 c7             	mov    %rax,%rdi
  803e33:	48 b8 99 1b 80 00 00 	movabs $0x801b99,%rax
  803e3a:	00 00 00 
  803e3d:	ff d0                	callq  *%rax
  803e3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e46:	79 27                	jns    803e6f <ipc_recv+0x6c>
		if (from_env_store)
  803e48:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e4d:	74 0a                	je     803e59 <ipc_recv+0x56>
			*from_env_store = 0;
  803e4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e53:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  803e59:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e5e:	74 0a                	je     803e6a <ipc_recv+0x67>
			*perm_store = 0;
  803e60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e64:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803e6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e6d:	eb 53                	jmp    803ec2 <ipc_recv+0xbf>
	}
	if (from_env_store)
  803e6f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e74:	74 19                	je     803e8f <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  803e76:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e7d:	00 00 00 
  803e80:	48 8b 00             	mov    (%rax),%rax
  803e83:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803e89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e8d:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  803e8f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e94:	74 19                	je     803eaf <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  803e96:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e9d:	00 00 00 
  803ea0:	48 8b 00             	mov    (%rax),%rax
  803ea3:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803ea9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ead:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803eaf:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803eb6:	00 00 00 
  803eb9:	48 8b 00             	mov    (%rax),%rax
  803ebc:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  803ec2:	c9                   	leaveq 
  803ec3:	c3                   	retq   

0000000000803ec4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803ec4:	55                   	push   %rbp
  803ec5:	48 89 e5             	mov    %rsp,%rbp
  803ec8:	48 83 ec 30          	sub    $0x30,%rsp
  803ecc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ecf:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803ed2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803ed6:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  803ed9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ede:	75 10                	jne    803ef0 <ipc_send+0x2c>
		pg = (void*) UTOP;
  803ee0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803ee7:	00 00 00 
  803eea:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  803eee:	eb 0e                	jmp    803efe <ipc_send+0x3a>
  803ef0:	eb 0c                	jmp    803efe <ipc_send+0x3a>
		sys_yield();
  803ef2:	48 b8 32 19 80 00 00 	movabs $0x801932,%rax
  803ef9:	00 00 00 
  803efc:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  803efe:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803f01:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803f04:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f08:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f0b:	89 c7                	mov    %eax,%edi
  803f0d:	48 b8 44 1b 80 00 00 	movabs $0x801b44,%rax
  803f14:	00 00 00 
  803f17:	ff d0                	callq  *%rax
  803f19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f1c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803f20:	74 d0                	je     803ef2 <ipc_send+0x2e>
		sys_yield();
	}
	if (r < 0)
  803f22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f26:	79 30                	jns    803f58 <ipc_send+0x94>
		panic("error in ipc_send: %e", r);
  803f28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f2b:	89 c1                	mov    %eax,%ecx
  803f2d:	48 ba db 48 80 00 00 	movabs $0x8048db,%rdx
  803f34:	00 00 00 
  803f37:	be 47 00 00 00       	mov    $0x47,%esi
  803f3c:	48 bf f1 48 80 00 00 	movabs $0x8048f1,%rdi
  803f43:	00 00 00 
  803f46:	b8 00 00 00 00       	mov    $0x0,%eax
  803f4b:	49 b8 53 02 80 00 00 	movabs $0x800253,%r8
  803f52:	00 00 00 
  803f55:	41 ff d0             	callq  *%r8

}
  803f58:	c9                   	leaveq 
  803f59:	c3                   	retq   

0000000000803f5a <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803f5a:	55                   	push   %rbp
  803f5b:	48 89 e5             	mov    %rsp,%rbp
  803f5e:	53                   	push   %rbx
  803f5f:	48 83 ec 28          	sub    $0x28,%rsp
  803f63:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  803f67:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  803f6e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  803f75:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f7a:	75 0e                	jne    803f8a <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  803f7c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f83:	00 00 00 
  803f86:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  803f8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f8e:	ba 07 00 00 00       	mov    $0x7,%edx
  803f93:	48 89 c6             	mov    %rax,%rsi
  803f96:	bf 00 00 00 00       	mov    $0x0,%edi
  803f9b:	48 b8 70 19 80 00 00 	movabs $0x801970,%rax
  803fa2:	00 00 00 
  803fa5:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  803fa7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fab:	48 c1 e8 0c          	shr    $0xc,%rax
  803faf:	48 89 c2             	mov    %rax,%rdx
  803fb2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803fb9:	01 00 00 
  803fbc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803fc0:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803fc6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  803fca:	b8 03 00 00 00       	mov    $0x3,%eax
  803fcf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803fd3:	48 89 d3             	mov    %rdx,%rbx
  803fd6:	0f 01 c1             	vmcall 
  803fd9:	89 f2                	mov    %esi,%edx
  803fdb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fde:	89 55 e8             	mov    %edx,-0x18(%rbp)
	/* cprintf("Returned IPC response from host: %d %d\n", r, -val);*/
	if (r < 0) {
  803fe1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fe5:	79 05                	jns    803fec <ipc_host_recv+0x92>
		return r;
  803fe7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fea:	eb 03                	jmp    803fef <ipc_host_recv+0x95>
	}
	return val;
  803fec:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  803fef:	48 83 c4 28          	add    $0x28,%rsp
  803ff3:	5b                   	pop    %rbx
  803ff4:	5d                   	pop    %rbp
  803ff5:	c3                   	retq   

0000000000803ff6 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803ff6:	55                   	push   %rbp
  803ff7:	48 89 e5             	mov    %rsp,%rbp
  803ffa:	53                   	push   %rbx
  803ffb:	48 83 ec 38          	sub    $0x38,%rsp
  803fff:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804002:	89 75 d8             	mov    %esi,-0x28(%rbp)
  804005:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804009:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  80400c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  804013:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  804018:	75 0e                	jne    804028 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  80401a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804021:	00 00 00 
  804024:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804028:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80402c:	48 c1 e8 0c          	shr    $0xc,%rax
  804030:	48 89 c2             	mov    %rax,%rdx
  804033:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80403a:	01 00 00 
  80403d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804041:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804047:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  80404b:	b8 02 00 00 00       	mov    $0x2,%eax
  804050:	8b 7d dc             	mov    -0x24(%rbp),%edi
  804053:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804056:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80405a:	8b 75 cc             	mov    -0x34(%rbp),%esi
  80405d:	89 fb                	mov    %edi,%ebx
  80405f:	0f 01 c1             	vmcall 
  804062:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804065:	eb 26                	jmp    80408d <ipc_host_send+0x97>
		sys_yield();
  804067:	48 b8 32 19 80 00 00 	movabs $0x801932,%rax
  80406e:	00 00 00 
  804071:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  804073:	b8 02 00 00 00       	mov    $0x2,%eax
  804078:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80407b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80407e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804082:	8b 75 cc             	mov    -0x34(%rbp),%esi
  804085:	89 fb                	mov    %edi,%ebx
  804087:	0f 01 c1             	vmcall 
  80408a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  80408d:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  804091:	74 d4                	je     804067 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  804093:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804097:	79 30                	jns    8040c9 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  804099:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80409c:	89 c1                	mov    %eax,%ecx
  80409e:	48 ba db 48 80 00 00 	movabs $0x8048db,%rdx
  8040a5:	00 00 00 
  8040a8:	be 79 00 00 00       	mov    $0x79,%esi
  8040ad:	48 bf f1 48 80 00 00 	movabs $0x8048f1,%rdi
  8040b4:	00 00 00 
  8040b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8040bc:	49 b8 53 02 80 00 00 	movabs $0x800253,%r8
  8040c3:	00 00 00 
  8040c6:	41 ff d0             	callq  *%r8

}
  8040c9:	48 83 c4 38          	add    $0x38,%rsp
  8040cd:	5b                   	pop    %rbx
  8040ce:	5d                   	pop    %rbp
  8040cf:	c3                   	retq   

00000000008040d0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8040d0:	55                   	push   %rbp
  8040d1:	48 89 e5             	mov    %rsp,%rbp
  8040d4:	48 83 ec 14          	sub    $0x14,%rsp
  8040d8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8040db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8040e2:	eb 4e                	jmp    804132 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8040e4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8040eb:	00 00 00 
  8040ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040f1:	48 98                	cltq   
  8040f3:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8040fa:	48 01 d0             	add    %rdx,%rax
  8040fd:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804103:	8b 00                	mov    (%rax),%eax
  804105:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804108:	75 24                	jne    80412e <ipc_find_env+0x5e>
			return envs[i].env_id;
  80410a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804111:	00 00 00 
  804114:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804117:	48 98                	cltq   
  804119:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804120:	48 01 d0             	add    %rdx,%rax
  804123:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804129:	8b 40 08             	mov    0x8(%rax),%eax
  80412c:	eb 12                	jmp    804140 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80412e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804132:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804139:	7e a9                	jle    8040e4 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80413b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804140:	c9                   	leaveq 
  804141:	c3                   	retq   

0000000000804142 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804142:	55                   	push   %rbp
  804143:	48 89 e5             	mov    %rsp,%rbp
  804146:	48 83 ec 18          	sub    $0x18,%rsp
  80414a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80414e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804152:	48 c1 e8 15          	shr    $0x15,%rax
  804156:	48 89 c2             	mov    %rax,%rdx
  804159:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804160:	01 00 00 
  804163:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804167:	83 e0 01             	and    $0x1,%eax
  80416a:	48 85 c0             	test   %rax,%rax
  80416d:	75 07                	jne    804176 <pageref+0x34>
		return 0;
  80416f:	b8 00 00 00 00       	mov    $0x0,%eax
  804174:	eb 53                	jmp    8041c9 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804176:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80417a:	48 c1 e8 0c          	shr    $0xc,%rax
  80417e:	48 89 c2             	mov    %rax,%rdx
  804181:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804188:	01 00 00 
  80418b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80418f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804193:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804197:	83 e0 01             	and    $0x1,%eax
  80419a:	48 85 c0             	test   %rax,%rax
  80419d:	75 07                	jne    8041a6 <pageref+0x64>
		return 0;
  80419f:	b8 00 00 00 00       	mov    $0x0,%eax
  8041a4:	eb 23                	jmp    8041c9 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8041a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041aa:	48 c1 e8 0c          	shr    $0xc,%rax
  8041ae:	48 89 c2             	mov    %rax,%rdx
  8041b1:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8041b8:	00 00 00 
  8041bb:	48 c1 e2 04          	shl    $0x4,%rdx
  8041bf:	48 01 d0             	add    %rdx,%rax
  8041c2:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8041c6:	0f b7 c0             	movzwl %ax,%eax
}
  8041c9:	c9                   	leaveq 
  8041ca:	c3                   	retq   
