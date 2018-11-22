
vmm/guest/obj/user/primes:     file format elf64-x86-64


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
  80003c:	e8 8d 01 00 00       	callq  8001ce <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80004b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80004f:	ba 00 00 00 00       	mov    $0x0,%edx
  800054:	be 00 00 00 00       	mov    $0x0,%esi
  800059:	48 89 c7             	mov    %rax,%rdi
  80005c:	48 b8 86 23 80 00 00 	movabs $0x802386,%rax
  800063:	00 00 00 
  800066:	ff d0                	callq  *%rax
  800068:	89 45 fc             	mov    %eax,-0x4(%rbp)
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80006b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800072:	00 00 00 
  800075:	48 8b 00             	mov    (%rax),%rax
  800078:	8b 80 dc 00 00 00    	mov    0xdc(%rax),%eax
  80007e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800081:	89 c6                	mov    %eax,%esi
  800083:	48 bf 40 49 80 00 00 	movabs $0x804940,%rdi
  80008a:	00 00 00 
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
  800092:	48 b9 ad 04 80 00 00 	movabs $0x8004ad,%rcx
  800099:	00 00 00 
  80009c:	ff d1                	callq  *%rcx

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  80009e:	48 b8 11 21 80 00 00 	movabs $0x802111,%rax
  8000a5:	00 00 00 
  8000a8:	ff d0                	callq  *%rax
  8000aa:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000ad:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000b1:	79 30                	jns    8000e3 <primeproc+0xa0>
		panic("fork: %e", id);
  8000b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000b6:	89 c1                	mov    %eax,%ecx
  8000b8:	48 ba 4c 49 80 00 00 	movabs $0x80494c,%rdx
  8000bf:	00 00 00 
  8000c2:	be 1b 00 00 00       	mov    $0x1b,%esi
  8000c7:	48 bf 55 49 80 00 00 	movabs $0x804955,%rdi
  8000ce:	00 00 00 
  8000d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d6:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  8000dd:	00 00 00 
  8000e0:	41 ff d0             	callq  *%r8
	if (id == 0)
  8000e3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e7:	75 05                	jne    8000ee <primeproc+0xab>
		goto top;
  8000e9:	e9 5d ff ff ff       	jmpq   80004b <primeproc+0x8>

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  8000ee:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000f7:	be 00 00 00 00       	mov    $0x0,%esi
  8000fc:	48 89 c7             	mov    %rax,%rdi
  8000ff:	48 b8 86 23 80 00 00 	movabs $0x802386,%rax
  800106:	00 00 00 
  800109:	ff d0                	callq  *%rax
  80010b:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (i % p)
  80010e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800111:	99                   	cltd   
  800112:	f7 7d fc             	idivl  -0x4(%rbp)
  800115:	89 d0                	mov    %edx,%eax
  800117:	85 c0                	test   %eax,%eax
  800119:	74 20                	je     80013b <primeproc+0xf8>
			ipc_send(id, i, 0, 0);
  80011b:	8b 75 f4             	mov    -0xc(%rbp),%esi
  80011e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800121:	b9 00 00 00 00       	mov    $0x0,%ecx
  800126:	ba 00 00 00 00       	mov    $0x0,%edx
  80012b:	89 c7                	mov    %eax,%edi
  80012d:	48 b8 47 24 80 00 00 	movabs $0x802447,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
	}
  800139:	eb b3                	jmp    8000ee <primeproc+0xab>
  80013b:	eb b1                	jmp    8000ee <primeproc+0xab>

000000000080013d <umain>:
}

void
umain(int argc, char **argv)
{
  80013d:	55                   	push   %rbp
  80013e:	48 89 e5             	mov    %rsp,%rbp
  800141:	48 83 ec 20          	sub    $0x20,%rsp
  800145:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800148:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  80014c:	48 b8 11 21 80 00 00 	movabs $0x802111,%rax
  800153:	00 00 00 
  800156:	ff d0                	callq  *%rax
  800158:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80015b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80015f:	79 30                	jns    800191 <umain+0x54>
		panic("fork: %e", id);
  800161:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800164:	89 c1                	mov    %eax,%ecx
  800166:	48 ba 4c 49 80 00 00 	movabs $0x80494c,%rdx
  80016d:	00 00 00 
  800170:	be 2e 00 00 00       	mov    $0x2e,%esi
  800175:	48 bf 55 49 80 00 00 	movabs $0x804955,%rdi
  80017c:	00 00 00 
  80017f:	b8 00 00 00 00       	mov    $0x0,%eax
  800184:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  80018b:	00 00 00 
  80018e:	41 ff d0             	callq  *%r8
	if (id == 0)
  800191:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800195:	75 0c                	jne    8001a3 <umain+0x66>
		primeproc();
  800197:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80019e:	00 00 00 
  8001a1:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i = 2; ; i++)
  8001a3:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001aa:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001ad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ba:	89 c7                	mov    %eax,%edi
  8001bc:	48 b8 47 24 80 00 00 	movabs $0x802447,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8001c8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001cc:	eb dc                	jmp    8001aa <umain+0x6d>

00000000008001ce <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ce:	55                   	push   %rbp
  8001cf:	48 89 e5             	mov    %rsp,%rbp
  8001d2:	48 83 ec 10          	sub    $0x10,%rsp
  8001d6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001d9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  8001dd:	48 b8 15 19 80 00 00 	movabs $0x801915,%rax
  8001e4:	00 00 00 
  8001e7:	ff d0                	callq  *%rax
  8001e9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ee:	48 98                	cltq   
  8001f0:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8001f7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001fe:	00 00 00 
  800201:	48 01 c2             	add    %rax,%rdx
  800204:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80020b:	00 00 00 
  80020e:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800211:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800215:	7e 14                	jle    80022b <libmain+0x5d>
		binaryname = argv[0];
  800217:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80021b:	48 8b 10             	mov    (%rax),%rdx
  80021e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800225:	00 00 00 
  800228:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80022b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80022f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800232:	48 89 d6             	mov    %rdx,%rsi
  800235:	89 c7                	mov    %eax,%edi
  800237:	48 b8 3d 01 80 00 00 	movabs $0x80013d,%rax
  80023e:	00 00 00 
  800241:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800243:	48 b8 51 02 80 00 00 	movabs $0x800251,%rax
  80024a:	00 00 00 
  80024d:	ff d0                	callq  *%rax
}
  80024f:	c9                   	leaveq 
  800250:	c3                   	retq   

0000000000800251 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800251:	55                   	push   %rbp
  800252:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800255:	48 b8 06 2a 80 00 00 	movabs $0x802a06,%rax
  80025c:	00 00 00 
  80025f:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800261:	bf 00 00 00 00       	mov    $0x0,%edi
  800266:	48 b8 d1 18 80 00 00 	movabs $0x8018d1,%rax
  80026d:	00 00 00 
  800270:	ff d0                	callq  *%rax
}
  800272:	5d                   	pop    %rbp
  800273:	c3                   	retq   

0000000000800274 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800274:	55                   	push   %rbp
  800275:	48 89 e5             	mov    %rsp,%rbp
  800278:	53                   	push   %rbx
  800279:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800280:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800287:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80028d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800294:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80029b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002a2:	84 c0                	test   %al,%al
  8002a4:	74 23                	je     8002c9 <_panic+0x55>
  8002a6:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002ad:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002b1:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002b5:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002b9:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002bd:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002c1:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002c5:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002c9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002d0:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002d7:	00 00 00 
  8002da:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002e1:	00 00 00 
  8002e4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002e8:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002ef:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002f6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002fd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800304:	00 00 00 
  800307:	48 8b 18             	mov    (%rax),%rbx
  80030a:	48 b8 15 19 80 00 00 	movabs $0x801915,%rax
  800311:	00 00 00 
  800314:	ff d0                	callq  *%rax
  800316:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80031c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800323:	41 89 c8             	mov    %ecx,%r8d
  800326:	48 89 d1             	mov    %rdx,%rcx
  800329:	48 89 da             	mov    %rbx,%rdx
  80032c:	89 c6                	mov    %eax,%esi
  80032e:	48 bf 70 49 80 00 00 	movabs $0x804970,%rdi
  800335:	00 00 00 
  800338:	b8 00 00 00 00       	mov    $0x0,%eax
  80033d:	49 b9 ad 04 80 00 00 	movabs $0x8004ad,%r9
  800344:	00 00 00 
  800347:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80034a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800351:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800358:	48 89 d6             	mov    %rdx,%rsi
  80035b:	48 89 c7             	mov    %rax,%rdi
  80035e:	48 b8 01 04 80 00 00 	movabs $0x800401,%rax
  800365:	00 00 00 
  800368:	ff d0                	callq  *%rax
	cprintf("\n");
  80036a:	48 bf 93 49 80 00 00 	movabs $0x804993,%rdi
  800371:	00 00 00 
  800374:	b8 00 00 00 00       	mov    $0x0,%eax
  800379:	48 ba ad 04 80 00 00 	movabs $0x8004ad,%rdx
  800380:	00 00 00 
  800383:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800385:	cc                   	int3   
  800386:	eb fd                	jmp    800385 <_panic+0x111>

0000000000800388 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800388:	55                   	push   %rbp
  800389:	48 89 e5             	mov    %rsp,%rbp
  80038c:	48 83 ec 10          	sub    $0x10,%rsp
  800390:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800393:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800397:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80039b:	8b 00                	mov    (%rax),%eax
  80039d:	8d 48 01             	lea    0x1(%rax),%ecx
  8003a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a4:	89 0a                	mov    %ecx,(%rdx)
  8003a6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003a9:	89 d1                	mov    %edx,%ecx
  8003ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003af:	48 98                	cltq   
  8003b1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b9:	8b 00                	mov    (%rax),%eax
  8003bb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003c0:	75 2c                	jne    8003ee <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c6:	8b 00                	mov    (%rax),%eax
  8003c8:	48 98                	cltq   
  8003ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ce:	48 83 c2 08          	add    $0x8,%rdx
  8003d2:	48 89 c6             	mov    %rax,%rsi
  8003d5:	48 89 d7             	mov    %rdx,%rdi
  8003d8:	48 b8 49 18 80 00 00 	movabs $0x801849,%rax
  8003df:	00 00 00 
  8003e2:	ff d0                	callq  *%rax
        b->idx = 0;
  8003e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f2:	8b 40 04             	mov    0x4(%rax),%eax
  8003f5:	8d 50 01             	lea    0x1(%rax),%edx
  8003f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003fc:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003ff:	c9                   	leaveq 
  800400:	c3                   	retq   

0000000000800401 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800401:	55                   	push   %rbp
  800402:	48 89 e5             	mov    %rsp,%rbp
  800405:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80040c:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800413:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80041a:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800421:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800428:	48 8b 0a             	mov    (%rdx),%rcx
  80042b:	48 89 08             	mov    %rcx,(%rax)
  80042e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800432:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800436:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80043a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80043e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800445:	00 00 00 
    b.cnt = 0;
  800448:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80044f:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800452:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800459:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800460:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800467:	48 89 c6             	mov    %rax,%rsi
  80046a:	48 bf 88 03 80 00 00 	movabs $0x800388,%rdi
  800471:	00 00 00 
  800474:	48 b8 60 08 80 00 00 	movabs $0x800860,%rax
  80047b:	00 00 00 
  80047e:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800480:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800486:	48 98                	cltq   
  800488:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80048f:	48 83 c2 08          	add    $0x8,%rdx
  800493:	48 89 c6             	mov    %rax,%rsi
  800496:	48 89 d7             	mov    %rdx,%rdi
  800499:	48 b8 49 18 80 00 00 	movabs $0x801849,%rax
  8004a0:	00 00 00 
  8004a3:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004a5:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004ab:	c9                   	leaveq 
  8004ac:	c3                   	retq   

00000000008004ad <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004ad:	55                   	push   %rbp
  8004ae:	48 89 e5             	mov    %rsp,%rbp
  8004b1:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004b8:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004bf:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004c6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004cd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004d4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004db:	84 c0                	test   %al,%al
  8004dd:	74 20                	je     8004ff <cprintf+0x52>
  8004df:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004e3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004e7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004eb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004ef:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004f3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004f7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004fb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004ff:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800506:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80050d:	00 00 00 
  800510:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800517:	00 00 00 
  80051a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80051e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800525:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80052c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800533:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80053a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800541:	48 8b 0a             	mov    (%rdx),%rcx
  800544:	48 89 08             	mov    %rcx,(%rax)
  800547:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80054b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80054f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800553:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800557:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80055e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800565:	48 89 d6             	mov    %rdx,%rsi
  800568:	48 89 c7             	mov    %rax,%rdi
  80056b:	48 b8 01 04 80 00 00 	movabs $0x800401,%rax
  800572:	00 00 00 
  800575:	ff d0                	callq  *%rax
  800577:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80057d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800583:	c9                   	leaveq 
  800584:	c3                   	retq   

0000000000800585 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800585:	55                   	push   %rbp
  800586:	48 89 e5             	mov    %rsp,%rbp
  800589:	53                   	push   %rbx
  80058a:	48 83 ec 38          	sub    $0x38,%rsp
  80058e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800592:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800596:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80059a:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80059d:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005a1:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a5:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005a8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005ac:	77 3b                	ja     8005e9 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ae:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005b1:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005b5:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c1:	48 f7 f3             	div    %rbx
  8005c4:	48 89 c2             	mov    %rax,%rdx
  8005c7:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005ca:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005cd:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d5:	41 89 f9             	mov    %edi,%r9d
  8005d8:	48 89 c7             	mov    %rax,%rdi
  8005db:	48 b8 85 05 80 00 00 	movabs $0x800585,%rax
  8005e2:	00 00 00 
  8005e5:	ff d0                	callq  *%rax
  8005e7:	eb 1e                	jmp    800607 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005e9:	eb 12                	jmp    8005fd <printnum+0x78>
			putch(padc, putdat);
  8005eb:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005ef:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f6:	48 89 ce             	mov    %rcx,%rsi
  8005f9:	89 d7                	mov    %edx,%edi
  8005fb:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005fd:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800601:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800605:	7f e4                	jg     8005eb <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800607:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80060a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80060e:	ba 00 00 00 00       	mov    $0x0,%edx
  800613:	48 f7 f1             	div    %rcx
  800616:	48 89 d0             	mov    %rdx,%rax
  800619:	48 ba 90 4b 80 00 00 	movabs $0x804b90,%rdx
  800620:	00 00 00 
  800623:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800627:	0f be d0             	movsbl %al,%edx
  80062a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80062e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800632:	48 89 ce             	mov    %rcx,%rsi
  800635:	89 d7                	mov    %edx,%edi
  800637:	ff d0                	callq  *%rax
}
  800639:	48 83 c4 38          	add    $0x38,%rsp
  80063d:	5b                   	pop    %rbx
  80063e:	5d                   	pop    %rbp
  80063f:	c3                   	retq   

0000000000800640 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800640:	55                   	push   %rbp
  800641:	48 89 e5             	mov    %rsp,%rbp
  800644:	48 83 ec 1c          	sub    $0x1c,%rsp
  800648:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80064c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80064f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800653:	7e 52                	jle    8006a7 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800655:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800659:	8b 00                	mov    (%rax),%eax
  80065b:	83 f8 30             	cmp    $0x30,%eax
  80065e:	73 24                	jae    800684 <getuint+0x44>
  800660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800664:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800668:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066c:	8b 00                	mov    (%rax),%eax
  80066e:	89 c0                	mov    %eax,%eax
  800670:	48 01 d0             	add    %rdx,%rax
  800673:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800677:	8b 12                	mov    (%rdx),%edx
  800679:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80067c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800680:	89 0a                	mov    %ecx,(%rdx)
  800682:	eb 17                	jmp    80069b <getuint+0x5b>
  800684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800688:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80068c:	48 89 d0             	mov    %rdx,%rax
  80068f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800693:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800697:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80069b:	48 8b 00             	mov    (%rax),%rax
  80069e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006a2:	e9 a3 00 00 00       	jmpq   80074a <getuint+0x10a>
	else if (lflag)
  8006a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006ab:	74 4f                	je     8006fc <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b1:	8b 00                	mov    (%rax),%eax
  8006b3:	83 f8 30             	cmp    $0x30,%eax
  8006b6:	73 24                	jae    8006dc <getuint+0x9c>
  8006b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c4:	8b 00                	mov    (%rax),%eax
  8006c6:	89 c0                	mov    %eax,%eax
  8006c8:	48 01 d0             	add    %rdx,%rax
  8006cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006cf:	8b 12                	mov    (%rdx),%edx
  8006d1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d8:	89 0a                	mov    %ecx,(%rdx)
  8006da:	eb 17                	jmp    8006f3 <getuint+0xb3>
  8006dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006e4:	48 89 d0             	mov    %rdx,%rax
  8006e7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ef:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006f3:	48 8b 00             	mov    (%rax),%rax
  8006f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006fa:	eb 4e                	jmp    80074a <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800700:	8b 00                	mov    (%rax),%eax
  800702:	83 f8 30             	cmp    $0x30,%eax
  800705:	73 24                	jae    80072b <getuint+0xeb>
  800707:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80070f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800713:	8b 00                	mov    (%rax),%eax
  800715:	89 c0                	mov    %eax,%eax
  800717:	48 01 d0             	add    %rdx,%rax
  80071a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071e:	8b 12                	mov    (%rdx),%edx
  800720:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800723:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800727:	89 0a                	mov    %ecx,(%rdx)
  800729:	eb 17                	jmp    800742 <getuint+0x102>
  80072b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800733:	48 89 d0             	mov    %rdx,%rax
  800736:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80073a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80073e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800742:	8b 00                	mov    (%rax),%eax
  800744:	89 c0                	mov    %eax,%eax
  800746:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80074a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80074e:	c9                   	leaveq 
  80074f:	c3                   	retq   

0000000000800750 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800750:	55                   	push   %rbp
  800751:	48 89 e5             	mov    %rsp,%rbp
  800754:	48 83 ec 1c          	sub    $0x1c,%rsp
  800758:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80075c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80075f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800763:	7e 52                	jle    8007b7 <getint+0x67>
		x=va_arg(*ap, long long);
  800765:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800769:	8b 00                	mov    (%rax),%eax
  80076b:	83 f8 30             	cmp    $0x30,%eax
  80076e:	73 24                	jae    800794 <getint+0x44>
  800770:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800774:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077c:	8b 00                	mov    (%rax),%eax
  80077e:	89 c0                	mov    %eax,%eax
  800780:	48 01 d0             	add    %rdx,%rax
  800783:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800787:	8b 12                	mov    (%rdx),%edx
  800789:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80078c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800790:	89 0a                	mov    %ecx,(%rdx)
  800792:	eb 17                	jmp    8007ab <getint+0x5b>
  800794:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800798:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80079c:	48 89 d0             	mov    %rdx,%rax
  80079f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007ab:	48 8b 00             	mov    (%rax),%rax
  8007ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007b2:	e9 a3 00 00 00       	jmpq   80085a <getint+0x10a>
	else if (lflag)
  8007b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007bb:	74 4f                	je     80080c <getint+0xbc>
		x=va_arg(*ap, long);
  8007bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c1:	8b 00                	mov    (%rax),%eax
  8007c3:	83 f8 30             	cmp    $0x30,%eax
  8007c6:	73 24                	jae    8007ec <getint+0x9c>
  8007c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d4:	8b 00                	mov    (%rax),%eax
  8007d6:	89 c0                	mov    %eax,%eax
  8007d8:	48 01 d0             	add    %rdx,%rax
  8007db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007df:	8b 12                	mov    (%rdx),%edx
  8007e1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e8:	89 0a                	mov    %ecx,(%rdx)
  8007ea:	eb 17                	jmp    800803 <getint+0xb3>
  8007ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007f4:	48 89 d0             	mov    %rdx,%rax
  8007f7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ff:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800803:	48 8b 00             	mov    (%rax),%rax
  800806:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80080a:	eb 4e                	jmp    80085a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80080c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800810:	8b 00                	mov    (%rax),%eax
  800812:	83 f8 30             	cmp    $0x30,%eax
  800815:	73 24                	jae    80083b <getint+0xeb>
  800817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80081f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800823:	8b 00                	mov    (%rax),%eax
  800825:	89 c0                	mov    %eax,%eax
  800827:	48 01 d0             	add    %rdx,%rax
  80082a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082e:	8b 12                	mov    (%rdx),%edx
  800830:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800833:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800837:	89 0a                	mov    %ecx,(%rdx)
  800839:	eb 17                	jmp    800852 <getint+0x102>
  80083b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800843:	48 89 d0             	mov    %rdx,%rax
  800846:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80084a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800852:	8b 00                	mov    (%rax),%eax
  800854:	48 98                	cltq   
  800856:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80085a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80085e:	c9                   	leaveq 
  80085f:	c3                   	retq   

0000000000800860 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800860:	55                   	push   %rbp
  800861:	48 89 e5             	mov    %rsp,%rbp
  800864:	41 54                	push   %r12
  800866:	53                   	push   %rbx
  800867:	48 83 ec 60          	sub    $0x60,%rsp
  80086b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80086f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800873:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800877:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80087b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80087f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800883:	48 8b 0a             	mov    (%rdx),%rcx
  800886:	48 89 08             	mov    %rcx,(%rax)
  800889:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80088d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800891:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800895:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800899:	eb 17                	jmp    8008b2 <vprintfmt+0x52>
			if (ch == '\0')
  80089b:	85 db                	test   %ebx,%ebx
  80089d:	0f 84 cc 04 00 00    	je     800d6f <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8008a3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008a7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ab:	48 89 d6             	mov    %rdx,%rsi
  8008ae:	89 df                	mov    %ebx,%edi
  8008b0:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008b6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008ba:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008be:	0f b6 00             	movzbl (%rax),%eax
  8008c1:	0f b6 d8             	movzbl %al,%ebx
  8008c4:	83 fb 25             	cmp    $0x25,%ebx
  8008c7:	75 d2                	jne    80089b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008c9:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008cd:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008d4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008db:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008e2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008e9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008ed:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008f1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008f5:	0f b6 00             	movzbl (%rax),%eax
  8008f8:	0f b6 d8             	movzbl %al,%ebx
  8008fb:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008fe:	83 f8 55             	cmp    $0x55,%eax
  800901:	0f 87 34 04 00 00    	ja     800d3b <vprintfmt+0x4db>
  800907:	89 c0                	mov    %eax,%eax
  800909:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800910:	00 
  800911:	48 b8 b8 4b 80 00 00 	movabs $0x804bb8,%rax
  800918:	00 00 00 
  80091b:	48 01 d0             	add    %rdx,%rax
  80091e:	48 8b 00             	mov    (%rax),%rax
  800921:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800923:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800927:	eb c0                	jmp    8008e9 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800929:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80092d:	eb ba                	jmp    8008e9 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80092f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800936:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800939:	89 d0                	mov    %edx,%eax
  80093b:	c1 e0 02             	shl    $0x2,%eax
  80093e:	01 d0                	add    %edx,%eax
  800940:	01 c0                	add    %eax,%eax
  800942:	01 d8                	add    %ebx,%eax
  800944:	83 e8 30             	sub    $0x30,%eax
  800947:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80094a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80094e:	0f b6 00             	movzbl (%rax),%eax
  800951:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800954:	83 fb 2f             	cmp    $0x2f,%ebx
  800957:	7e 0c                	jle    800965 <vprintfmt+0x105>
  800959:	83 fb 39             	cmp    $0x39,%ebx
  80095c:	7f 07                	jg     800965 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80095e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800963:	eb d1                	jmp    800936 <vprintfmt+0xd6>
			goto process_precision;
  800965:	eb 58                	jmp    8009bf <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800967:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80096a:	83 f8 30             	cmp    $0x30,%eax
  80096d:	73 17                	jae    800986 <vprintfmt+0x126>
  80096f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800973:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800976:	89 c0                	mov    %eax,%eax
  800978:	48 01 d0             	add    %rdx,%rax
  80097b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80097e:	83 c2 08             	add    $0x8,%edx
  800981:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800984:	eb 0f                	jmp    800995 <vprintfmt+0x135>
  800986:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80098a:	48 89 d0             	mov    %rdx,%rax
  80098d:	48 83 c2 08          	add    $0x8,%rdx
  800991:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800995:	8b 00                	mov    (%rax),%eax
  800997:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80099a:	eb 23                	jmp    8009bf <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80099c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009a0:	79 0c                	jns    8009ae <vprintfmt+0x14e>
				width = 0;
  8009a2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009a9:	e9 3b ff ff ff       	jmpq   8008e9 <vprintfmt+0x89>
  8009ae:	e9 36 ff ff ff       	jmpq   8008e9 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009b3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009ba:	e9 2a ff ff ff       	jmpq   8008e9 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009bf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009c3:	79 12                	jns    8009d7 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009c5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009c8:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009cb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009d2:	e9 12 ff ff ff       	jmpq   8008e9 <vprintfmt+0x89>
  8009d7:	e9 0d ff ff ff       	jmpq   8008e9 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009dc:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009e0:	e9 04 ff ff ff       	jmpq   8008e9 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009e5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e8:	83 f8 30             	cmp    $0x30,%eax
  8009eb:	73 17                	jae    800a04 <vprintfmt+0x1a4>
  8009ed:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009f1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f4:	89 c0                	mov    %eax,%eax
  8009f6:	48 01 d0             	add    %rdx,%rax
  8009f9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009fc:	83 c2 08             	add    $0x8,%edx
  8009ff:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a02:	eb 0f                	jmp    800a13 <vprintfmt+0x1b3>
  800a04:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a08:	48 89 d0             	mov    %rdx,%rax
  800a0b:	48 83 c2 08          	add    $0x8,%rdx
  800a0f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a13:	8b 10                	mov    (%rax),%edx
  800a15:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a1d:	48 89 ce             	mov    %rcx,%rsi
  800a20:	89 d7                	mov    %edx,%edi
  800a22:	ff d0                	callq  *%rax
			break;
  800a24:	e9 40 03 00 00       	jmpq   800d69 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a29:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a2c:	83 f8 30             	cmp    $0x30,%eax
  800a2f:	73 17                	jae    800a48 <vprintfmt+0x1e8>
  800a31:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a35:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a38:	89 c0                	mov    %eax,%eax
  800a3a:	48 01 d0             	add    %rdx,%rax
  800a3d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a40:	83 c2 08             	add    $0x8,%edx
  800a43:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a46:	eb 0f                	jmp    800a57 <vprintfmt+0x1f7>
  800a48:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a4c:	48 89 d0             	mov    %rdx,%rax
  800a4f:	48 83 c2 08          	add    $0x8,%rdx
  800a53:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a57:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a59:	85 db                	test   %ebx,%ebx
  800a5b:	79 02                	jns    800a5f <vprintfmt+0x1ff>
				err = -err;
  800a5d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a5f:	83 fb 15             	cmp    $0x15,%ebx
  800a62:	7f 16                	jg     800a7a <vprintfmt+0x21a>
  800a64:	48 b8 e0 4a 80 00 00 	movabs $0x804ae0,%rax
  800a6b:	00 00 00 
  800a6e:	48 63 d3             	movslq %ebx,%rdx
  800a71:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a75:	4d 85 e4             	test   %r12,%r12
  800a78:	75 2e                	jne    800aa8 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a7a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a7e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a82:	89 d9                	mov    %ebx,%ecx
  800a84:	48 ba a1 4b 80 00 00 	movabs $0x804ba1,%rdx
  800a8b:	00 00 00 
  800a8e:	48 89 c7             	mov    %rax,%rdi
  800a91:	b8 00 00 00 00       	mov    $0x0,%eax
  800a96:	49 b8 78 0d 80 00 00 	movabs $0x800d78,%r8
  800a9d:	00 00 00 
  800aa0:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aa3:	e9 c1 02 00 00       	jmpq   800d69 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aa8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab0:	4c 89 e1             	mov    %r12,%rcx
  800ab3:	48 ba aa 4b 80 00 00 	movabs $0x804baa,%rdx
  800aba:	00 00 00 
  800abd:	48 89 c7             	mov    %rax,%rdi
  800ac0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac5:	49 b8 78 0d 80 00 00 	movabs $0x800d78,%r8
  800acc:	00 00 00 
  800acf:	41 ff d0             	callq  *%r8
			break;
  800ad2:	e9 92 02 00 00       	jmpq   800d69 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ad7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ada:	83 f8 30             	cmp    $0x30,%eax
  800add:	73 17                	jae    800af6 <vprintfmt+0x296>
  800adf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ae3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae6:	89 c0                	mov    %eax,%eax
  800ae8:	48 01 d0             	add    %rdx,%rax
  800aeb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aee:	83 c2 08             	add    $0x8,%edx
  800af1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800af4:	eb 0f                	jmp    800b05 <vprintfmt+0x2a5>
  800af6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800afa:	48 89 d0             	mov    %rdx,%rax
  800afd:	48 83 c2 08          	add    $0x8,%rdx
  800b01:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b05:	4c 8b 20             	mov    (%rax),%r12
  800b08:	4d 85 e4             	test   %r12,%r12
  800b0b:	75 0a                	jne    800b17 <vprintfmt+0x2b7>
				p = "(null)";
  800b0d:	49 bc ad 4b 80 00 00 	movabs $0x804bad,%r12
  800b14:	00 00 00 
			if (width > 0 && padc != '-')
  800b17:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b1b:	7e 3f                	jle    800b5c <vprintfmt+0x2fc>
  800b1d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b21:	74 39                	je     800b5c <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b23:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b26:	48 98                	cltq   
  800b28:	48 89 c6             	mov    %rax,%rsi
  800b2b:	4c 89 e7             	mov    %r12,%rdi
  800b2e:	48 b8 24 10 80 00 00 	movabs $0x801024,%rax
  800b35:	00 00 00 
  800b38:	ff d0                	callq  *%rax
  800b3a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b3d:	eb 17                	jmp    800b56 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b3f:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b43:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b47:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b4b:	48 89 ce             	mov    %rcx,%rsi
  800b4e:	89 d7                	mov    %edx,%edi
  800b50:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b52:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b56:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b5a:	7f e3                	jg     800b3f <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5c:	eb 37                	jmp    800b95 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b5e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b62:	74 1e                	je     800b82 <vprintfmt+0x322>
  800b64:	83 fb 1f             	cmp    $0x1f,%ebx
  800b67:	7e 05                	jle    800b6e <vprintfmt+0x30e>
  800b69:	83 fb 7e             	cmp    $0x7e,%ebx
  800b6c:	7e 14                	jle    800b82 <vprintfmt+0x322>
					putch('?', putdat);
  800b6e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b72:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b76:	48 89 d6             	mov    %rdx,%rsi
  800b79:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b7e:	ff d0                	callq  *%rax
  800b80:	eb 0f                	jmp    800b91 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b82:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b86:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8a:	48 89 d6             	mov    %rdx,%rsi
  800b8d:	89 df                	mov    %ebx,%edi
  800b8f:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b91:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b95:	4c 89 e0             	mov    %r12,%rax
  800b98:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b9c:	0f b6 00             	movzbl (%rax),%eax
  800b9f:	0f be d8             	movsbl %al,%ebx
  800ba2:	85 db                	test   %ebx,%ebx
  800ba4:	74 10                	je     800bb6 <vprintfmt+0x356>
  800ba6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800baa:	78 b2                	js     800b5e <vprintfmt+0x2fe>
  800bac:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bb0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bb4:	79 a8                	jns    800b5e <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb6:	eb 16                	jmp    800bce <vprintfmt+0x36e>
				putch(' ', putdat);
  800bb8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bbc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc0:	48 89 d6             	mov    %rdx,%rsi
  800bc3:	bf 20 00 00 00       	mov    $0x20,%edi
  800bc8:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bca:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bce:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bd2:	7f e4                	jg     800bb8 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bd4:	e9 90 01 00 00       	jmpq   800d69 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bd9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bdd:	be 03 00 00 00       	mov    $0x3,%esi
  800be2:	48 89 c7             	mov    %rax,%rdi
  800be5:	48 b8 50 07 80 00 00 	movabs $0x800750,%rax
  800bec:	00 00 00 
  800bef:	ff d0                	callq  *%rax
  800bf1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf9:	48 85 c0             	test   %rax,%rax
  800bfc:	79 1d                	jns    800c1b <vprintfmt+0x3bb>
				putch('-', putdat);
  800bfe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c06:	48 89 d6             	mov    %rdx,%rsi
  800c09:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c0e:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c14:	48 f7 d8             	neg    %rax
  800c17:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c1b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c22:	e9 d5 00 00 00       	jmpq   800cfc <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c27:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c2b:	be 03 00 00 00       	mov    $0x3,%esi
  800c30:	48 89 c7             	mov    %rax,%rdi
  800c33:	48 b8 40 06 80 00 00 	movabs $0x800640,%rax
  800c3a:	00 00 00 
  800c3d:	ff d0                	callq  *%rax
  800c3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c43:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c4a:	e9 ad 00 00 00       	jmpq   800cfc <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800c4f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c53:	be 03 00 00 00       	mov    $0x3,%esi
  800c58:	48 89 c7             	mov    %rax,%rdi
  800c5b:	48 b8 40 06 80 00 00 	movabs $0x800640,%rax
  800c62:	00 00 00 
  800c65:	ff d0                	callq  *%rax
  800c67:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800c6b:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c72:	e9 85 00 00 00       	jmpq   800cfc <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800c77:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7f:	48 89 d6             	mov    %rdx,%rsi
  800c82:	bf 30 00 00 00       	mov    $0x30,%edi
  800c87:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c89:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c91:	48 89 d6             	mov    %rdx,%rsi
  800c94:	bf 78 00 00 00       	mov    $0x78,%edi
  800c99:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c9b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9e:	83 f8 30             	cmp    $0x30,%eax
  800ca1:	73 17                	jae    800cba <vprintfmt+0x45a>
  800ca3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ca7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800caa:	89 c0                	mov    %eax,%eax
  800cac:	48 01 d0             	add    %rdx,%rax
  800caf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb2:	83 c2 08             	add    $0x8,%edx
  800cb5:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb8:	eb 0f                	jmp    800cc9 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800cba:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cbe:	48 89 d0             	mov    %rdx,%rax
  800cc1:	48 83 c2 08          	add    $0x8,%rdx
  800cc5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cc9:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ccc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cd0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cd7:	eb 23                	jmp    800cfc <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cd9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cdd:	be 03 00 00 00       	mov    $0x3,%esi
  800ce2:	48 89 c7             	mov    %rax,%rdi
  800ce5:	48 b8 40 06 80 00 00 	movabs $0x800640,%rax
  800cec:	00 00 00 
  800cef:	ff d0                	callq  *%rax
  800cf1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cf5:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cfc:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d01:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d04:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d0b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d0f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d13:	45 89 c1             	mov    %r8d,%r9d
  800d16:	41 89 f8             	mov    %edi,%r8d
  800d19:	48 89 c7             	mov    %rax,%rdi
  800d1c:	48 b8 85 05 80 00 00 	movabs $0x800585,%rax
  800d23:	00 00 00 
  800d26:	ff d0                	callq  *%rax
			break;
  800d28:	eb 3f                	jmp    800d69 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d2a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d32:	48 89 d6             	mov    %rdx,%rsi
  800d35:	89 df                	mov    %ebx,%edi
  800d37:	ff d0                	callq  *%rax
			break;
  800d39:	eb 2e                	jmp    800d69 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d3b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d3f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d43:	48 89 d6             	mov    %rdx,%rsi
  800d46:	bf 25 00 00 00       	mov    $0x25,%edi
  800d4b:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d4d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d52:	eb 05                	jmp    800d59 <vprintfmt+0x4f9>
  800d54:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d59:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d5d:	48 83 e8 01          	sub    $0x1,%rax
  800d61:	0f b6 00             	movzbl (%rax),%eax
  800d64:	3c 25                	cmp    $0x25,%al
  800d66:	75 ec                	jne    800d54 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800d68:	90                   	nop
		}
	}
  800d69:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d6a:	e9 43 fb ff ff       	jmpq   8008b2 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d6f:	48 83 c4 60          	add    $0x60,%rsp
  800d73:	5b                   	pop    %rbx
  800d74:	41 5c                	pop    %r12
  800d76:	5d                   	pop    %rbp
  800d77:	c3                   	retq   

0000000000800d78 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d78:	55                   	push   %rbp
  800d79:	48 89 e5             	mov    %rsp,%rbp
  800d7c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d83:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d8a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d91:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d98:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d9f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800da6:	84 c0                	test   %al,%al
  800da8:	74 20                	je     800dca <printfmt+0x52>
  800daa:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dae:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800db2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800db6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dba:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dbe:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dc2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dc6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dca:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dd1:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dd8:	00 00 00 
  800ddb:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800de2:	00 00 00 
  800de5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800de9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800df0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800df7:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800dfe:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e05:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e0c:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e13:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e1a:	48 89 c7             	mov    %rax,%rdi
  800e1d:	48 b8 60 08 80 00 00 	movabs $0x800860,%rax
  800e24:	00 00 00 
  800e27:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e29:	c9                   	leaveq 
  800e2a:	c3                   	retq   

0000000000800e2b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e2b:	55                   	push   %rbp
  800e2c:	48 89 e5             	mov    %rsp,%rbp
  800e2f:	48 83 ec 10          	sub    $0x10,%rsp
  800e33:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e36:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e3e:	8b 40 10             	mov    0x10(%rax),%eax
  800e41:	8d 50 01             	lea    0x1(%rax),%edx
  800e44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e48:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e4f:	48 8b 10             	mov    (%rax),%rdx
  800e52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e56:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e5a:	48 39 c2             	cmp    %rax,%rdx
  800e5d:	73 17                	jae    800e76 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e63:	48 8b 00             	mov    (%rax),%rax
  800e66:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e6e:	48 89 0a             	mov    %rcx,(%rdx)
  800e71:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e74:	88 10                	mov    %dl,(%rax)
}
  800e76:	c9                   	leaveq 
  800e77:	c3                   	retq   

0000000000800e78 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e78:	55                   	push   %rbp
  800e79:	48 89 e5             	mov    %rsp,%rbp
  800e7c:	48 83 ec 50          	sub    $0x50,%rsp
  800e80:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e84:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e87:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e8b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e8f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e93:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e97:	48 8b 0a             	mov    (%rdx),%rcx
  800e9a:	48 89 08             	mov    %rcx,(%rax)
  800e9d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ea1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ea5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ea9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ead:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eb1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800eb5:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800eb8:	48 98                	cltq   
  800eba:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ebe:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ec2:	48 01 d0             	add    %rdx,%rax
  800ec5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ec9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ed0:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ed5:	74 06                	je     800edd <vsnprintf+0x65>
  800ed7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800edb:	7f 07                	jg     800ee4 <vsnprintf+0x6c>
		return -E_INVAL;
  800edd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ee2:	eb 2f                	jmp    800f13 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ee4:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ee8:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800eec:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ef0:	48 89 c6             	mov    %rax,%rsi
  800ef3:	48 bf 2b 0e 80 00 00 	movabs $0x800e2b,%rdi
  800efa:	00 00 00 
  800efd:	48 b8 60 08 80 00 00 	movabs $0x800860,%rax
  800f04:	00 00 00 
  800f07:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f09:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f0d:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f10:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f13:	c9                   	leaveq 
  800f14:	c3                   	retq   

0000000000800f15 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f15:	55                   	push   %rbp
  800f16:	48 89 e5             	mov    %rsp,%rbp
  800f19:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f20:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f27:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f2d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f34:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f3b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f42:	84 c0                	test   %al,%al
  800f44:	74 20                	je     800f66 <snprintf+0x51>
  800f46:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f4a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f4e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f52:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f56:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f5a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f5e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f62:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f66:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f6d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f74:	00 00 00 
  800f77:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f7e:	00 00 00 
  800f81:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f85:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f8c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f93:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f9a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fa1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fa8:	48 8b 0a             	mov    (%rdx),%rcx
  800fab:	48 89 08             	mov    %rcx,(%rax)
  800fae:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fb2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fb6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fba:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fbe:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fc5:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fcc:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fd2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fd9:	48 89 c7             	mov    %rax,%rdi
  800fdc:	48 b8 78 0e 80 00 00 	movabs $0x800e78,%rax
  800fe3:	00 00 00 
  800fe6:	ff d0                	callq  *%rax
  800fe8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fee:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800ff4:	c9                   	leaveq 
  800ff5:	c3                   	retq   

0000000000800ff6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ff6:	55                   	push   %rbp
  800ff7:	48 89 e5             	mov    %rsp,%rbp
  800ffa:	48 83 ec 18          	sub    $0x18,%rsp
  800ffe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801002:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801009:	eb 09                	jmp    801014 <strlen+0x1e>
		n++;
  80100b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80100f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801014:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801018:	0f b6 00             	movzbl (%rax),%eax
  80101b:	84 c0                	test   %al,%al
  80101d:	75 ec                	jne    80100b <strlen+0x15>
		n++;
	return n;
  80101f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801022:	c9                   	leaveq 
  801023:	c3                   	retq   

0000000000801024 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801024:	55                   	push   %rbp
  801025:	48 89 e5             	mov    %rsp,%rbp
  801028:	48 83 ec 20          	sub    $0x20,%rsp
  80102c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801030:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801034:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80103b:	eb 0e                	jmp    80104b <strnlen+0x27>
		n++;
  80103d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801041:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801046:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80104b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801050:	74 0b                	je     80105d <strnlen+0x39>
  801052:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801056:	0f b6 00             	movzbl (%rax),%eax
  801059:	84 c0                	test   %al,%al
  80105b:	75 e0                	jne    80103d <strnlen+0x19>
		n++;
	return n;
  80105d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801060:	c9                   	leaveq 
  801061:	c3                   	retq   

0000000000801062 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801062:	55                   	push   %rbp
  801063:	48 89 e5             	mov    %rsp,%rbp
  801066:	48 83 ec 20          	sub    $0x20,%rsp
  80106a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80106e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801072:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801076:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80107a:	90                   	nop
  80107b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80107f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801083:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801087:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80108b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80108f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801093:	0f b6 12             	movzbl (%rdx),%edx
  801096:	88 10                	mov    %dl,(%rax)
  801098:	0f b6 00             	movzbl (%rax),%eax
  80109b:	84 c0                	test   %al,%al
  80109d:	75 dc                	jne    80107b <strcpy+0x19>
		/* do nothing */;
	return ret;
  80109f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010a3:	c9                   	leaveq 
  8010a4:	c3                   	retq   

00000000008010a5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010a5:	55                   	push   %rbp
  8010a6:	48 89 e5             	mov    %rsp,%rbp
  8010a9:	48 83 ec 20          	sub    $0x20,%rsp
  8010ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b9:	48 89 c7             	mov    %rax,%rdi
  8010bc:	48 b8 f6 0f 80 00 00 	movabs $0x800ff6,%rax
  8010c3:	00 00 00 
  8010c6:	ff d0                	callq  *%rax
  8010c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ce:	48 63 d0             	movslq %eax,%rdx
  8010d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d5:	48 01 c2             	add    %rax,%rdx
  8010d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010dc:	48 89 c6             	mov    %rax,%rsi
  8010df:	48 89 d7             	mov    %rdx,%rdi
  8010e2:	48 b8 62 10 80 00 00 	movabs $0x801062,%rax
  8010e9:	00 00 00 
  8010ec:	ff d0                	callq  *%rax
	return dst;
  8010ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010f2:	c9                   	leaveq 
  8010f3:	c3                   	retq   

00000000008010f4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010f4:	55                   	push   %rbp
  8010f5:	48 89 e5             	mov    %rsp,%rbp
  8010f8:	48 83 ec 28          	sub    $0x28,%rsp
  8010fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801100:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801104:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801108:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801110:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801117:	00 
  801118:	eb 2a                	jmp    801144 <strncpy+0x50>
		*dst++ = *src;
  80111a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801122:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801126:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80112a:	0f b6 12             	movzbl (%rdx),%edx
  80112d:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80112f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801133:	0f b6 00             	movzbl (%rax),%eax
  801136:	84 c0                	test   %al,%al
  801138:	74 05                	je     80113f <strncpy+0x4b>
			src++;
  80113a:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80113f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801144:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801148:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80114c:	72 cc                	jb     80111a <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80114e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801152:	c9                   	leaveq 
  801153:	c3                   	retq   

0000000000801154 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801154:	55                   	push   %rbp
  801155:	48 89 e5             	mov    %rsp,%rbp
  801158:	48 83 ec 28          	sub    $0x28,%rsp
  80115c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801160:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801164:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801168:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801170:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801175:	74 3d                	je     8011b4 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801177:	eb 1d                	jmp    801196 <strlcpy+0x42>
			*dst++ = *src++;
  801179:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801181:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801185:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801189:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80118d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801191:	0f b6 12             	movzbl (%rdx),%edx
  801194:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801196:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80119b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011a0:	74 0b                	je     8011ad <strlcpy+0x59>
  8011a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011a6:	0f b6 00             	movzbl (%rax),%eax
  8011a9:	84 c0                	test   %al,%al
  8011ab:	75 cc                	jne    801179 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b1:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011bc:	48 29 c2             	sub    %rax,%rdx
  8011bf:	48 89 d0             	mov    %rdx,%rax
}
  8011c2:	c9                   	leaveq 
  8011c3:	c3                   	retq   

00000000008011c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011c4:	55                   	push   %rbp
  8011c5:	48 89 e5             	mov    %rsp,%rbp
  8011c8:	48 83 ec 10          	sub    $0x10,%rsp
  8011cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011d4:	eb 0a                	jmp    8011e0 <strcmp+0x1c>
		p++, q++;
  8011d6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011db:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e4:	0f b6 00             	movzbl (%rax),%eax
  8011e7:	84 c0                	test   %al,%al
  8011e9:	74 12                	je     8011fd <strcmp+0x39>
  8011eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ef:	0f b6 10             	movzbl (%rax),%edx
  8011f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f6:	0f b6 00             	movzbl (%rax),%eax
  8011f9:	38 c2                	cmp    %al,%dl
  8011fb:	74 d9                	je     8011d6 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801201:	0f b6 00             	movzbl (%rax),%eax
  801204:	0f b6 d0             	movzbl %al,%edx
  801207:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120b:	0f b6 00             	movzbl (%rax),%eax
  80120e:	0f b6 c0             	movzbl %al,%eax
  801211:	29 c2                	sub    %eax,%edx
  801213:	89 d0                	mov    %edx,%eax
}
  801215:	c9                   	leaveq 
  801216:	c3                   	retq   

0000000000801217 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801217:	55                   	push   %rbp
  801218:	48 89 e5             	mov    %rsp,%rbp
  80121b:	48 83 ec 18          	sub    $0x18,%rsp
  80121f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801223:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801227:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80122b:	eb 0f                	jmp    80123c <strncmp+0x25>
		n--, p++, q++;
  80122d:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801232:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801237:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80123c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801241:	74 1d                	je     801260 <strncmp+0x49>
  801243:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801247:	0f b6 00             	movzbl (%rax),%eax
  80124a:	84 c0                	test   %al,%al
  80124c:	74 12                	je     801260 <strncmp+0x49>
  80124e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801252:	0f b6 10             	movzbl (%rax),%edx
  801255:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801259:	0f b6 00             	movzbl (%rax),%eax
  80125c:	38 c2                	cmp    %al,%dl
  80125e:	74 cd                	je     80122d <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801260:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801265:	75 07                	jne    80126e <strncmp+0x57>
		return 0;
  801267:	b8 00 00 00 00       	mov    $0x0,%eax
  80126c:	eb 18                	jmp    801286 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80126e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801272:	0f b6 00             	movzbl (%rax),%eax
  801275:	0f b6 d0             	movzbl %al,%edx
  801278:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80127c:	0f b6 00             	movzbl (%rax),%eax
  80127f:	0f b6 c0             	movzbl %al,%eax
  801282:	29 c2                	sub    %eax,%edx
  801284:	89 d0                	mov    %edx,%eax
}
  801286:	c9                   	leaveq 
  801287:	c3                   	retq   

0000000000801288 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801288:	55                   	push   %rbp
  801289:	48 89 e5             	mov    %rsp,%rbp
  80128c:	48 83 ec 0c          	sub    $0xc,%rsp
  801290:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801294:	89 f0                	mov    %esi,%eax
  801296:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801299:	eb 17                	jmp    8012b2 <strchr+0x2a>
		if (*s == c)
  80129b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129f:	0f b6 00             	movzbl (%rax),%eax
  8012a2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012a5:	75 06                	jne    8012ad <strchr+0x25>
			return (char *) s;
  8012a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ab:	eb 15                	jmp    8012c2 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012ad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b6:	0f b6 00             	movzbl (%rax),%eax
  8012b9:	84 c0                	test   %al,%al
  8012bb:	75 de                	jne    80129b <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c2:	c9                   	leaveq 
  8012c3:	c3                   	retq   

00000000008012c4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012c4:	55                   	push   %rbp
  8012c5:	48 89 e5             	mov    %rsp,%rbp
  8012c8:	48 83 ec 0c          	sub    $0xc,%rsp
  8012cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d0:	89 f0                	mov    %esi,%eax
  8012d2:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012d5:	eb 13                	jmp    8012ea <strfind+0x26>
		if (*s == c)
  8012d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012db:	0f b6 00             	movzbl (%rax),%eax
  8012de:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012e1:	75 02                	jne    8012e5 <strfind+0x21>
			break;
  8012e3:	eb 10                	jmp    8012f5 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012e5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ee:	0f b6 00             	movzbl (%rax),%eax
  8012f1:	84 c0                	test   %al,%al
  8012f3:	75 e2                	jne    8012d7 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012f9:	c9                   	leaveq 
  8012fa:	c3                   	retq   

00000000008012fb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012fb:	55                   	push   %rbp
  8012fc:	48 89 e5             	mov    %rsp,%rbp
  8012ff:	48 83 ec 18          	sub    $0x18,%rsp
  801303:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801307:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80130a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80130e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801313:	75 06                	jne    80131b <memset+0x20>
		return v;
  801315:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801319:	eb 69                	jmp    801384 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80131b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131f:	83 e0 03             	and    $0x3,%eax
  801322:	48 85 c0             	test   %rax,%rax
  801325:	75 48                	jne    80136f <memset+0x74>
  801327:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132b:	83 e0 03             	and    $0x3,%eax
  80132e:	48 85 c0             	test   %rax,%rax
  801331:	75 3c                	jne    80136f <memset+0x74>
		c &= 0xFF;
  801333:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80133a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80133d:	c1 e0 18             	shl    $0x18,%eax
  801340:	89 c2                	mov    %eax,%edx
  801342:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801345:	c1 e0 10             	shl    $0x10,%eax
  801348:	09 c2                	or     %eax,%edx
  80134a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80134d:	c1 e0 08             	shl    $0x8,%eax
  801350:	09 d0                	or     %edx,%eax
  801352:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801355:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801359:	48 c1 e8 02          	shr    $0x2,%rax
  80135d:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801360:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801364:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801367:	48 89 d7             	mov    %rdx,%rdi
  80136a:	fc                   	cld    
  80136b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80136d:	eb 11                	jmp    801380 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80136f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801373:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801376:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80137a:	48 89 d7             	mov    %rdx,%rdi
  80137d:	fc                   	cld    
  80137e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801380:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801384:	c9                   	leaveq 
  801385:	c3                   	retq   

0000000000801386 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801386:	55                   	push   %rbp
  801387:	48 89 e5             	mov    %rsp,%rbp
  80138a:	48 83 ec 28          	sub    $0x28,%rsp
  80138e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801392:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801396:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80139a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80139e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ae:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013b2:	0f 83 88 00 00 00    	jae    801440 <memmove+0xba>
  8013b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c0:	48 01 d0             	add    %rdx,%rax
  8013c3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013c7:	76 77                	jbe    801440 <memmove+0xba>
		s += n;
  8013c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013cd:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013dd:	83 e0 03             	and    $0x3,%eax
  8013e0:	48 85 c0             	test   %rax,%rax
  8013e3:	75 3b                	jne    801420 <memmove+0x9a>
  8013e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e9:	83 e0 03             	and    $0x3,%eax
  8013ec:	48 85 c0             	test   %rax,%rax
  8013ef:	75 2f                	jne    801420 <memmove+0x9a>
  8013f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f5:	83 e0 03             	and    $0x3,%eax
  8013f8:	48 85 c0             	test   %rax,%rax
  8013fb:	75 23                	jne    801420 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801401:	48 83 e8 04          	sub    $0x4,%rax
  801405:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801409:	48 83 ea 04          	sub    $0x4,%rdx
  80140d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801411:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801415:	48 89 c7             	mov    %rax,%rdi
  801418:	48 89 d6             	mov    %rdx,%rsi
  80141b:	fd                   	std    
  80141c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80141e:	eb 1d                	jmp    80143d <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801420:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801424:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801428:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801430:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801434:	48 89 d7             	mov    %rdx,%rdi
  801437:	48 89 c1             	mov    %rax,%rcx
  80143a:	fd                   	std    
  80143b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80143d:	fc                   	cld    
  80143e:	eb 57                	jmp    801497 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801440:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801444:	83 e0 03             	and    $0x3,%eax
  801447:	48 85 c0             	test   %rax,%rax
  80144a:	75 36                	jne    801482 <memmove+0xfc>
  80144c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801450:	83 e0 03             	and    $0x3,%eax
  801453:	48 85 c0             	test   %rax,%rax
  801456:	75 2a                	jne    801482 <memmove+0xfc>
  801458:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145c:	83 e0 03             	and    $0x3,%eax
  80145f:	48 85 c0             	test   %rax,%rax
  801462:	75 1e                	jne    801482 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801464:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801468:	48 c1 e8 02          	shr    $0x2,%rax
  80146c:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80146f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801473:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801477:	48 89 c7             	mov    %rax,%rdi
  80147a:	48 89 d6             	mov    %rdx,%rsi
  80147d:	fc                   	cld    
  80147e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801480:	eb 15                	jmp    801497 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801482:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801486:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80148a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80148e:	48 89 c7             	mov    %rax,%rdi
  801491:	48 89 d6             	mov    %rdx,%rsi
  801494:	fc                   	cld    
  801495:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801497:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80149b:	c9                   	leaveq 
  80149c:	c3                   	retq   

000000000080149d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80149d:	55                   	push   %rbp
  80149e:	48 89 e5             	mov    %rsp,%rbp
  8014a1:	48 83 ec 18          	sub    $0x18,%rsp
  8014a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014ad:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014b5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014bd:	48 89 ce             	mov    %rcx,%rsi
  8014c0:	48 89 c7             	mov    %rax,%rdi
  8014c3:	48 b8 86 13 80 00 00 	movabs $0x801386,%rax
  8014ca:	00 00 00 
  8014cd:	ff d0                	callq  *%rax
}
  8014cf:	c9                   	leaveq 
  8014d0:	c3                   	retq   

00000000008014d1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014d1:	55                   	push   %rbp
  8014d2:	48 89 e5             	mov    %rsp,%rbp
  8014d5:	48 83 ec 28          	sub    $0x28,%rsp
  8014d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014f1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014f5:	eb 36                	jmp    80152d <memcmp+0x5c>
		if (*s1 != *s2)
  8014f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fb:	0f b6 10             	movzbl (%rax),%edx
  8014fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801502:	0f b6 00             	movzbl (%rax),%eax
  801505:	38 c2                	cmp    %al,%dl
  801507:	74 1a                	je     801523 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801509:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80150d:	0f b6 00             	movzbl (%rax),%eax
  801510:	0f b6 d0             	movzbl %al,%edx
  801513:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801517:	0f b6 00             	movzbl (%rax),%eax
  80151a:	0f b6 c0             	movzbl %al,%eax
  80151d:	29 c2                	sub    %eax,%edx
  80151f:	89 d0                	mov    %edx,%eax
  801521:	eb 20                	jmp    801543 <memcmp+0x72>
		s1++, s2++;
  801523:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801528:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80152d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801531:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801535:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801539:	48 85 c0             	test   %rax,%rax
  80153c:	75 b9                	jne    8014f7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80153e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801543:	c9                   	leaveq 
  801544:	c3                   	retq   

0000000000801545 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801545:	55                   	push   %rbp
  801546:	48 89 e5             	mov    %rsp,%rbp
  801549:	48 83 ec 28          	sub    $0x28,%rsp
  80154d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801551:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801554:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801558:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801560:	48 01 d0             	add    %rdx,%rax
  801563:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801567:	eb 15                	jmp    80157e <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801569:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156d:	0f b6 10             	movzbl (%rax),%edx
  801570:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801573:	38 c2                	cmp    %al,%dl
  801575:	75 02                	jne    801579 <memfind+0x34>
			break;
  801577:	eb 0f                	jmp    801588 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801579:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80157e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801582:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801586:	72 e1                	jb     801569 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801588:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80158c:	c9                   	leaveq 
  80158d:	c3                   	retq   

000000000080158e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80158e:	55                   	push   %rbp
  80158f:	48 89 e5             	mov    %rsp,%rbp
  801592:	48 83 ec 34          	sub    $0x34,%rsp
  801596:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80159a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80159e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015a8:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015af:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015b0:	eb 05                	jmp    8015b7 <strtol+0x29>
		s++;
  8015b2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bb:	0f b6 00             	movzbl (%rax),%eax
  8015be:	3c 20                	cmp    $0x20,%al
  8015c0:	74 f0                	je     8015b2 <strtol+0x24>
  8015c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c6:	0f b6 00             	movzbl (%rax),%eax
  8015c9:	3c 09                	cmp    $0x9,%al
  8015cb:	74 e5                	je     8015b2 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d1:	0f b6 00             	movzbl (%rax),%eax
  8015d4:	3c 2b                	cmp    $0x2b,%al
  8015d6:	75 07                	jne    8015df <strtol+0x51>
		s++;
  8015d8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015dd:	eb 17                	jmp    8015f6 <strtol+0x68>
	else if (*s == '-')
  8015df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e3:	0f b6 00             	movzbl (%rax),%eax
  8015e6:	3c 2d                	cmp    $0x2d,%al
  8015e8:	75 0c                	jne    8015f6 <strtol+0x68>
		s++, neg = 1;
  8015ea:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015ef:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015f6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015fa:	74 06                	je     801602 <strtol+0x74>
  8015fc:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801600:	75 28                	jne    80162a <strtol+0x9c>
  801602:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801606:	0f b6 00             	movzbl (%rax),%eax
  801609:	3c 30                	cmp    $0x30,%al
  80160b:	75 1d                	jne    80162a <strtol+0x9c>
  80160d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801611:	48 83 c0 01          	add    $0x1,%rax
  801615:	0f b6 00             	movzbl (%rax),%eax
  801618:	3c 78                	cmp    $0x78,%al
  80161a:	75 0e                	jne    80162a <strtol+0x9c>
		s += 2, base = 16;
  80161c:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801621:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801628:	eb 2c                	jmp    801656 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80162a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80162e:	75 19                	jne    801649 <strtol+0xbb>
  801630:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801634:	0f b6 00             	movzbl (%rax),%eax
  801637:	3c 30                	cmp    $0x30,%al
  801639:	75 0e                	jne    801649 <strtol+0xbb>
		s++, base = 8;
  80163b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801640:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801647:	eb 0d                	jmp    801656 <strtol+0xc8>
	else if (base == 0)
  801649:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80164d:	75 07                	jne    801656 <strtol+0xc8>
		base = 10;
  80164f:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801656:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165a:	0f b6 00             	movzbl (%rax),%eax
  80165d:	3c 2f                	cmp    $0x2f,%al
  80165f:	7e 1d                	jle    80167e <strtol+0xf0>
  801661:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801665:	0f b6 00             	movzbl (%rax),%eax
  801668:	3c 39                	cmp    $0x39,%al
  80166a:	7f 12                	jg     80167e <strtol+0xf0>
			dig = *s - '0';
  80166c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801670:	0f b6 00             	movzbl (%rax),%eax
  801673:	0f be c0             	movsbl %al,%eax
  801676:	83 e8 30             	sub    $0x30,%eax
  801679:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80167c:	eb 4e                	jmp    8016cc <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80167e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801682:	0f b6 00             	movzbl (%rax),%eax
  801685:	3c 60                	cmp    $0x60,%al
  801687:	7e 1d                	jle    8016a6 <strtol+0x118>
  801689:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168d:	0f b6 00             	movzbl (%rax),%eax
  801690:	3c 7a                	cmp    $0x7a,%al
  801692:	7f 12                	jg     8016a6 <strtol+0x118>
			dig = *s - 'a' + 10;
  801694:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801698:	0f b6 00             	movzbl (%rax),%eax
  80169b:	0f be c0             	movsbl %al,%eax
  80169e:	83 e8 57             	sub    $0x57,%eax
  8016a1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016a4:	eb 26                	jmp    8016cc <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016aa:	0f b6 00             	movzbl (%rax),%eax
  8016ad:	3c 40                	cmp    $0x40,%al
  8016af:	7e 48                	jle    8016f9 <strtol+0x16b>
  8016b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b5:	0f b6 00             	movzbl (%rax),%eax
  8016b8:	3c 5a                	cmp    $0x5a,%al
  8016ba:	7f 3d                	jg     8016f9 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c0:	0f b6 00             	movzbl (%rax),%eax
  8016c3:	0f be c0             	movsbl %al,%eax
  8016c6:	83 e8 37             	sub    $0x37,%eax
  8016c9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016cf:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016d2:	7c 02                	jl     8016d6 <strtol+0x148>
			break;
  8016d4:	eb 23                	jmp    8016f9 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016d6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016db:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016de:	48 98                	cltq   
  8016e0:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016e5:	48 89 c2             	mov    %rax,%rdx
  8016e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016eb:	48 98                	cltq   
  8016ed:	48 01 d0             	add    %rdx,%rax
  8016f0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016f4:	e9 5d ff ff ff       	jmpq   801656 <strtol+0xc8>

	if (endptr)
  8016f9:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016fe:	74 0b                	je     80170b <strtol+0x17d>
		*endptr = (char *) s;
  801700:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801704:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801708:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80170b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80170f:	74 09                	je     80171a <strtol+0x18c>
  801711:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801715:	48 f7 d8             	neg    %rax
  801718:	eb 04                	jmp    80171e <strtol+0x190>
  80171a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80171e:	c9                   	leaveq 
  80171f:	c3                   	retq   

0000000000801720 <strstr>:

char * strstr(const char *in, const char *str)
{
  801720:	55                   	push   %rbp
  801721:	48 89 e5             	mov    %rsp,%rbp
  801724:	48 83 ec 30          	sub    $0x30,%rsp
  801728:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80172c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801730:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801734:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801738:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80173c:	0f b6 00             	movzbl (%rax),%eax
  80173f:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801742:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801746:	75 06                	jne    80174e <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801748:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174c:	eb 6b                	jmp    8017b9 <strstr+0x99>

	len = strlen(str);
  80174e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801752:	48 89 c7             	mov    %rax,%rdi
  801755:	48 b8 f6 0f 80 00 00 	movabs $0x800ff6,%rax
  80175c:	00 00 00 
  80175f:	ff d0                	callq  *%rax
  801761:	48 98                	cltq   
  801763:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801767:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80176f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801773:	0f b6 00             	movzbl (%rax),%eax
  801776:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801779:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80177d:	75 07                	jne    801786 <strstr+0x66>
				return (char *) 0;
  80177f:	b8 00 00 00 00       	mov    $0x0,%eax
  801784:	eb 33                	jmp    8017b9 <strstr+0x99>
		} while (sc != c);
  801786:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80178a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80178d:	75 d8                	jne    801767 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80178f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801793:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801797:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179b:	48 89 ce             	mov    %rcx,%rsi
  80179e:	48 89 c7             	mov    %rax,%rdi
  8017a1:	48 b8 17 12 80 00 00 	movabs $0x801217,%rax
  8017a8:	00 00 00 
  8017ab:	ff d0                	callq  *%rax
  8017ad:	85 c0                	test   %eax,%eax
  8017af:	75 b6                	jne    801767 <strstr+0x47>

	return (char *) (in - 1);
  8017b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b5:	48 83 e8 01          	sub    $0x1,%rax
}
  8017b9:	c9                   	leaveq 
  8017ba:	c3                   	retq   

00000000008017bb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017bb:	55                   	push   %rbp
  8017bc:	48 89 e5             	mov    %rsp,%rbp
  8017bf:	53                   	push   %rbx
  8017c0:	48 83 ec 48          	sub    $0x48,%rsp
  8017c4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017c7:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017ca:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017ce:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017d2:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017d6:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017da:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017dd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017e1:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017e5:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017e9:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017ed:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017f1:	4c 89 c3             	mov    %r8,%rbx
  8017f4:	cd 30                	int    $0x30
  8017f6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017fa:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017fe:	74 3e                	je     80183e <syscall+0x83>
  801800:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801805:	7e 37                	jle    80183e <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801807:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80180b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80180e:	49 89 d0             	mov    %rdx,%r8
  801811:	89 c1                	mov    %eax,%ecx
  801813:	48 ba 68 4e 80 00 00 	movabs $0x804e68,%rdx
  80181a:	00 00 00 
  80181d:	be 24 00 00 00       	mov    $0x24,%esi
  801822:	48 bf 85 4e 80 00 00 	movabs $0x804e85,%rdi
  801829:	00 00 00 
  80182c:	b8 00 00 00 00       	mov    $0x0,%eax
  801831:	49 b9 74 02 80 00 00 	movabs $0x800274,%r9
  801838:	00 00 00 
  80183b:	41 ff d1             	callq  *%r9

	return ret;
  80183e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801842:	48 83 c4 48          	add    $0x48,%rsp
  801846:	5b                   	pop    %rbx
  801847:	5d                   	pop    %rbp
  801848:	c3                   	retq   

0000000000801849 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801849:	55                   	push   %rbp
  80184a:	48 89 e5             	mov    %rsp,%rbp
  80184d:	48 83 ec 20          	sub    $0x20,%rsp
  801851:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801855:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801859:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80185d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801861:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801868:	00 
  801869:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80186f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801875:	48 89 d1             	mov    %rdx,%rcx
  801878:	48 89 c2             	mov    %rax,%rdx
  80187b:	be 00 00 00 00       	mov    $0x0,%esi
  801880:	bf 00 00 00 00       	mov    $0x0,%edi
  801885:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  80188c:	00 00 00 
  80188f:	ff d0                	callq  *%rax
}
  801891:	c9                   	leaveq 
  801892:	c3                   	retq   

0000000000801893 <sys_cgetc>:

int
sys_cgetc(void)
{
  801893:	55                   	push   %rbp
  801894:	48 89 e5             	mov    %rsp,%rbp
  801897:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80189b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018a2:	00 
  8018a3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b9:	be 00 00 00 00       	mov    $0x0,%esi
  8018be:	bf 01 00 00 00       	mov    $0x1,%edi
  8018c3:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  8018ca:	00 00 00 
  8018cd:	ff d0                	callq  *%rax
}
  8018cf:	c9                   	leaveq 
  8018d0:	c3                   	retq   

00000000008018d1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018d1:	55                   	push   %rbp
  8018d2:	48 89 e5             	mov    %rsp,%rbp
  8018d5:	48 83 ec 10          	sub    $0x10,%rsp
  8018d9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018df:	48 98                	cltq   
  8018e1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e8:	00 
  8018e9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018fa:	48 89 c2             	mov    %rax,%rdx
  8018fd:	be 01 00 00 00       	mov    $0x1,%esi
  801902:	bf 03 00 00 00       	mov    $0x3,%edi
  801907:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  80190e:	00 00 00 
  801911:	ff d0                	callq  *%rax
}
  801913:	c9                   	leaveq 
  801914:	c3                   	retq   

0000000000801915 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801915:	55                   	push   %rbp
  801916:	48 89 e5             	mov    %rsp,%rbp
  801919:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80191d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801924:	00 
  801925:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80192b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801931:	b9 00 00 00 00       	mov    $0x0,%ecx
  801936:	ba 00 00 00 00       	mov    $0x0,%edx
  80193b:	be 00 00 00 00       	mov    $0x0,%esi
  801940:	bf 02 00 00 00       	mov    $0x2,%edi
  801945:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  80194c:	00 00 00 
  80194f:	ff d0                	callq  *%rax
}
  801951:	c9                   	leaveq 
  801952:	c3                   	retq   

0000000000801953 <sys_yield>:


void
sys_yield(void)
{
  801953:	55                   	push   %rbp
  801954:	48 89 e5             	mov    %rsp,%rbp
  801957:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80195b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801962:	00 
  801963:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801969:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80196f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801974:	ba 00 00 00 00       	mov    $0x0,%edx
  801979:	be 00 00 00 00       	mov    $0x0,%esi
  80197e:	bf 0b 00 00 00       	mov    $0xb,%edi
  801983:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  80198a:	00 00 00 
  80198d:	ff d0                	callq  *%rax
}
  80198f:	c9                   	leaveq 
  801990:	c3                   	retq   

0000000000801991 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801991:	55                   	push   %rbp
  801992:	48 89 e5             	mov    %rsp,%rbp
  801995:	48 83 ec 20          	sub    $0x20,%rsp
  801999:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80199c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019a0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019a3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019a6:	48 63 c8             	movslq %eax,%rcx
  8019a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b0:	48 98                	cltq   
  8019b2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019b9:	00 
  8019ba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c0:	49 89 c8             	mov    %rcx,%r8
  8019c3:	48 89 d1             	mov    %rdx,%rcx
  8019c6:	48 89 c2             	mov    %rax,%rdx
  8019c9:	be 01 00 00 00       	mov    $0x1,%esi
  8019ce:	bf 04 00 00 00       	mov    $0x4,%edi
  8019d3:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  8019da:	00 00 00 
  8019dd:	ff d0                	callq  *%rax
}
  8019df:	c9                   	leaveq 
  8019e0:	c3                   	retq   

00000000008019e1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019e1:	55                   	push   %rbp
  8019e2:	48 89 e5             	mov    %rsp,%rbp
  8019e5:	48 83 ec 30          	sub    $0x30,%rsp
  8019e9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019ec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019f0:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019f3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019f7:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019fb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019fe:	48 63 c8             	movslq %eax,%rcx
  801a01:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a05:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a08:	48 63 f0             	movslq %eax,%rsi
  801a0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a12:	48 98                	cltq   
  801a14:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a18:	49 89 f9             	mov    %rdi,%r9
  801a1b:	49 89 f0             	mov    %rsi,%r8
  801a1e:	48 89 d1             	mov    %rdx,%rcx
  801a21:	48 89 c2             	mov    %rax,%rdx
  801a24:	be 01 00 00 00       	mov    $0x1,%esi
  801a29:	bf 05 00 00 00       	mov    $0x5,%edi
  801a2e:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801a35:	00 00 00 
  801a38:	ff d0                	callq  *%rax
}
  801a3a:	c9                   	leaveq 
  801a3b:	c3                   	retq   

0000000000801a3c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a3c:	55                   	push   %rbp
  801a3d:	48 89 e5             	mov    %rsp,%rbp
  801a40:	48 83 ec 20          	sub    $0x20,%rsp
  801a44:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a47:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a4b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a52:	48 98                	cltq   
  801a54:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a5b:	00 
  801a5c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a62:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a68:	48 89 d1             	mov    %rdx,%rcx
  801a6b:	48 89 c2             	mov    %rax,%rdx
  801a6e:	be 01 00 00 00       	mov    $0x1,%esi
  801a73:	bf 06 00 00 00       	mov    $0x6,%edi
  801a78:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801a7f:	00 00 00 
  801a82:	ff d0                	callq  *%rax
}
  801a84:	c9                   	leaveq 
  801a85:	c3                   	retq   

0000000000801a86 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a86:	55                   	push   %rbp
  801a87:	48 89 e5             	mov    %rsp,%rbp
  801a8a:	48 83 ec 10          	sub    $0x10,%rsp
  801a8e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a91:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a94:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a97:	48 63 d0             	movslq %eax,%rdx
  801a9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a9d:	48 98                	cltq   
  801a9f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aa6:	00 
  801aa7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ab3:	48 89 d1             	mov    %rdx,%rcx
  801ab6:	48 89 c2             	mov    %rax,%rdx
  801ab9:	be 01 00 00 00       	mov    $0x1,%esi
  801abe:	bf 08 00 00 00       	mov    $0x8,%edi
  801ac3:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801aca:	00 00 00 
  801acd:	ff d0                	callq  *%rax
}
  801acf:	c9                   	leaveq 
  801ad0:	c3                   	retq   

0000000000801ad1 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ad1:	55                   	push   %rbp
  801ad2:	48 89 e5             	mov    %rsp,%rbp
  801ad5:	48 83 ec 20          	sub    $0x20,%rsp
  801ad9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801adc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ae0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ae4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ae7:	48 98                	cltq   
  801ae9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af0:	00 
  801af1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801afd:	48 89 d1             	mov    %rdx,%rcx
  801b00:	48 89 c2             	mov    %rax,%rdx
  801b03:	be 01 00 00 00       	mov    $0x1,%esi
  801b08:	bf 09 00 00 00       	mov    $0x9,%edi
  801b0d:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801b14:	00 00 00 
  801b17:	ff d0                	callq  *%rax
}
  801b19:	c9                   	leaveq 
  801b1a:	c3                   	retq   

0000000000801b1b <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b1b:	55                   	push   %rbp
  801b1c:	48 89 e5             	mov    %rsp,%rbp
  801b1f:	48 83 ec 20          	sub    $0x20,%rsp
  801b23:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b26:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b31:	48 98                	cltq   
  801b33:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b3a:	00 
  801b3b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b41:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b47:	48 89 d1             	mov    %rdx,%rcx
  801b4a:	48 89 c2             	mov    %rax,%rdx
  801b4d:	be 01 00 00 00       	mov    $0x1,%esi
  801b52:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b57:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801b5e:	00 00 00 
  801b61:	ff d0                	callq  *%rax
}
  801b63:	c9                   	leaveq 
  801b64:	c3                   	retq   

0000000000801b65 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b65:	55                   	push   %rbp
  801b66:	48 89 e5             	mov    %rsp,%rbp
  801b69:	48 83 ec 20          	sub    $0x20,%rsp
  801b6d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b70:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b74:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b78:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b7b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b7e:	48 63 f0             	movslq %eax,%rsi
  801b81:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b88:	48 98                	cltq   
  801b8a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b8e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b95:	00 
  801b96:	49 89 f1             	mov    %rsi,%r9
  801b99:	49 89 c8             	mov    %rcx,%r8
  801b9c:	48 89 d1             	mov    %rdx,%rcx
  801b9f:	48 89 c2             	mov    %rax,%rdx
  801ba2:	be 00 00 00 00       	mov    $0x0,%esi
  801ba7:	bf 0c 00 00 00       	mov    $0xc,%edi
  801bac:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801bb3:	00 00 00 
  801bb6:	ff d0                	callq  *%rax
}
  801bb8:	c9                   	leaveq 
  801bb9:	c3                   	retq   

0000000000801bba <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801bba:	55                   	push   %rbp
  801bbb:	48 89 e5             	mov    %rsp,%rbp
  801bbe:	48 83 ec 10          	sub    $0x10,%rsp
  801bc2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801bc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd1:	00 
  801bd2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bde:	b9 00 00 00 00       	mov    $0x0,%ecx
  801be3:	48 89 c2             	mov    %rax,%rdx
  801be6:	be 01 00 00 00       	mov    $0x1,%esi
  801beb:	bf 0d 00 00 00       	mov    $0xd,%edi
  801bf0:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801bf7:	00 00 00 
  801bfa:	ff d0                	callq  *%rax
}
  801bfc:	c9                   	leaveq 
  801bfd:	c3                   	retq   

0000000000801bfe <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801bfe:	55                   	push   %rbp
  801bff:	48 89 e5             	mov    %rsp,%rbp
  801c02:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c06:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c0d:	00 
  801c0e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c14:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c1a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c24:	be 00 00 00 00       	mov    $0x0,%esi
  801c29:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c2e:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801c35:	00 00 00 
  801c38:	ff d0                	callq  *%rax
}
  801c3a:	c9                   	leaveq 
  801c3b:	c3                   	retq   

0000000000801c3c <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801c3c:	55                   	push   %rbp
  801c3d:	48 89 e5             	mov    %rsp,%rbp
  801c40:	48 83 ec 20          	sub    $0x20,%rsp
  801c44:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c48:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801c4b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801c4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c52:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c59:	00 
  801c5a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c60:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c66:	48 89 d1             	mov    %rdx,%rcx
  801c69:	48 89 c2             	mov    %rax,%rdx
  801c6c:	be 00 00 00 00       	mov    $0x0,%esi
  801c71:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c76:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801c7d:	00 00 00 
  801c80:	ff d0                	callq  *%rax
}
  801c82:	c9                   	leaveq 
  801c83:	c3                   	retq   

0000000000801c84 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801c84:	55                   	push   %rbp
  801c85:	48 89 e5             	mov    %rsp,%rbp
  801c88:	48 83 ec 20          	sub    $0x20,%rsp
  801c8c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c90:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801c93:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801c96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c9a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca1:	00 
  801ca2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cae:	48 89 d1             	mov    %rdx,%rcx
  801cb1:	48 89 c2             	mov    %rax,%rdx
  801cb4:	be 00 00 00 00       	mov    $0x0,%esi
  801cb9:	bf 10 00 00 00       	mov    $0x10,%edi
  801cbe:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801cc5:	00 00 00 
  801cc8:	ff d0                	callq  *%rax
}
  801cca:	c9                   	leaveq 
  801ccb:	c3                   	retq   

0000000000801ccc <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801ccc:	55                   	push   %rbp
  801ccd:	48 89 e5             	mov    %rsp,%rbp
  801cd0:	48 83 ec 30          	sub    $0x30,%rsp
  801cd4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cd7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cdb:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801cde:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ce2:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801ce6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ce9:	48 63 c8             	movslq %eax,%rcx
  801cec:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801cf0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cf3:	48 63 f0             	movslq %eax,%rsi
  801cf6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cfd:	48 98                	cltq   
  801cff:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d03:	49 89 f9             	mov    %rdi,%r9
  801d06:	49 89 f0             	mov    %rsi,%r8
  801d09:	48 89 d1             	mov    %rdx,%rcx
  801d0c:	48 89 c2             	mov    %rax,%rdx
  801d0f:	be 00 00 00 00       	mov    $0x0,%esi
  801d14:	bf 11 00 00 00       	mov    $0x11,%edi
  801d19:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801d20:	00 00 00 
  801d23:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801d25:	c9                   	leaveq 
  801d26:	c3                   	retq   

0000000000801d27 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801d27:	55                   	push   %rbp
  801d28:	48 89 e5             	mov    %rsp,%rbp
  801d2b:	48 83 ec 20          	sub    $0x20,%rsp
  801d2f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d33:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801d37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d3f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d46:	00 
  801d47:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d4d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d53:	48 89 d1             	mov    %rdx,%rcx
  801d56:	48 89 c2             	mov    %rax,%rdx
  801d59:	be 00 00 00 00       	mov    $0x0,%esi
  801d5e:	bf 12 00 00 00       	mov    $0x12,%edi
  801d63:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801d6a:	00 00 00 
  801d6d:	ff d0                	callq  *%rax
}
  801d6f:	c9                   	leaveq 
  801d70:	c3                   	retq   

0000000000801d71 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801d71:	55                   	push   %rbp
  801d72:	48 89 e5             	mov    %rsp,%rbp
  801d75:	48 83 ec 30          	sub    $0x30,%rsp
  801d79:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801d7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d81:	48 8b 00             	mov    (%rax),%rax
  801d84:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801d88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d8c:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d90:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  801d93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d96:	83 e0 02             	and    $0x2,%eax
  801d99:	85 c0                	test   %eax,%eax
  801d9b:	75 40                	jne    801ddd <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  801d9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801da1:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  801da8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dac:	49 89 d0             	mov    %rdx,%r8
  801daf:	48 89 c1             	mov    %rax,%rcx
  801db2:	48 ba 98 4e 80 00 00 	movabs $0x804e98,%rdx
  801db9:	00 00 00 
  801dbc:	be 1f 00 00 00       	mov    $0x1f,%esi
  801dc1:	48 bf b1 4e 80 00 00 	movabs $0x804eb1,%rdi
  801dc8:	00 00 00 
  801dcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd0:	49 b9 74 02 80 00 00 	movabs $0x800274,%r9
  801dd7:	00 00 00 
  801dda:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  801ddd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801de1:	48 c1 e8 0c          	shr    $0xc,%rax
  801de5:	48 89 c2             	mov    %rax,%rdx
  801de8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801def:	01 00 00 
  801df2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801df6:	25 07 08 00 00       	and    $0x807,%eax
  801dfb:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  801e01:	74 4e                	je     801e51 <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  801e03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e07:	48 c1 e8 0c          	shr    $0xc,%rax
  801e0b:	48 89 c2             	mov    %rax,%rdx
  801e0e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e15:	01 00 00 
  801e18:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801e1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e20:	49 89 d0             	mov    %rdx,%r8
  801e23:	48 89 c1             	mov    %rax,%rcx
  801e26:	48 ba c0 4e 80 00 00 	movabs $0x804ec0,%rdx
  801e2d:	00 00 00 
  801e30:	be 22 00 00 00       	mov    $0x22,%esi
  801e35:	48 bf b1 4e 80 00 00 	movabs $0x804eb1,%rdi
  801e3c:	00 00 00 
  801e3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e44:	49 b9 74 02 80 00 00 	movabs $0x800274,%r9
  801e4b:	00 00 00 
  801e4e:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801e51:	ba 07 00 00 00       	mov    $0x7,%edx
  801e56:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e5b:	bf 00 00 00 00       	mov    $0x0,%edi
  801e60:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  801e67:	00 00 00 
  801e6a:	ff d0                	callq  *%rax
  801e6c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801e6f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801e73:	79 30                	jns    801ea5 <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  801e75:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e78:	89 c1                	mov    %eax,%ecx
  801e7a:	48 ba eb 4e 80 00 00 	movabs $0x804eeb,%rdx
  801e81:	00 00 00 
  801e84:	be 28 00 00 00       	mov    $0x28,%esi
  801e89:	48 bf b1 4e 80 00 00 	movabs $0x804eb1,%rdi
  801e90:	00 00 00 
  801e93:	b8 00 00 00 00       	mov    $0x0,%eax
  801e98:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  801e9f:	00 00 00 
  801ea2:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  801ea5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ea9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801ead:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eb1:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801eb7:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ebc:	48 89 c6             	mov    %rax,%rsi
  801ebf:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801ec4:	48 b8 86 13 80 00 00 	movabs $0x801386,%rax
  801ecb:	00 00 00 
  801ece:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  801ed0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ed4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801ed8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801edc:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801ee2:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801ee8:	48 89 c1             	mov    %rax,%rcx
  801eeb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef0:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ef5:	bf 00 00 00 00       	mov    $0x0,%edi
  801efa:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  801f01:	00 00 00 
  801f04:	ff d0                	callq  *%rax
  801f06:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801f09:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801f0d:	79 30                	jns    801f3f <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  801f0f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f12:	89 c1                	mov    %eax,%ecx
  801f14:	48 ba fe 4e 80 00 00 	movabs $0x804efe,%rdx
  801f1b:	00 00 00 
  801f1e:	be 2d 00 00 00       	mov    $0x2d,%esi
  801f23:	48 bf b1 4e 80 00 00 	movabs $0x804eb1,%rdi
  801f2a:	00 00 00 
  801f2d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f32:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  801f39:	00 00 00 
  801f3c:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  801f3f:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f44:	bf 00 00 00 00       	mov    $0x0,%edi
  801f49:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  801f50:	00 00 00 
  801f53:	ff d0                	callq  *%rax
  801f55:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801f58:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801f5c:	79 30                	jns    801f8e <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  801f5e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f61:	89 c1                	mov    %eax,%ecx
  801f63:	48 ba 0f 4f 80 00 00 	movabs $0x804f0f,%rdx
  801f6a:	00 00 00 
  801f6d:	be 31 00 00 00       	mov    $0x31,%esi
  801f72:	48 bf b1 4e 80 00 00 	movabs $0x804eb1,%rdi
  801f79:	00 00 00 
  801f7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f81:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  801f88:	00 00 00 
  801f8b:	41 ff d0             	callq  *%r8

}
  801f8e:	c9                   	leaveq 
  801f8f:	c3                   	retq   

0000000000801f90 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801f90:	55                   	push   %rbp
  801f91:	48 89 e5             	mov    %rsp,%rbp
  801f94:	48 83 ec 30          	sub    $0x30,%rsp
  801f98:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801f9b:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  801f9e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801fa1:	c1 e0 0c             	shl    $0xc,%eax
  801fa4:	89 c0                	mov    %eax,%eax
  801fa6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  801faa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fb1:	01 00 00 
  801fb4:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801fb7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fbb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  801fbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fc3:	25 02 08 00 00       	and    $0x802,%eax
  801fc8:	48 85 c0             	test   %rax,%rax
  801fcb:	74 0e                	je     801fdb <duppage+0x4b>
  801fcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fd1:	25 00 04 00 00       	and    $0x400,%eax
  801fd6:	48 85 c0             	test   %rax,%rax
  801fd9:	74 70                	je     80204b <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  801fdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fdf:	25 07 0e 00 00       	and    $0xe07,%eax
  801fe4:	89 c6                	mov    %eax,%esi
  801fe6:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801fea:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801fed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ff1:	41 89 f0             	mov    %esi,%r8d
  801ff4:	48 89 c6             	mov    %rax,%rsi
  801ff7:	bf 00 00 00 00       	mov    $0x0,%edi
  801ffc:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  802003:	00 00 00 
  802006:	ff d0                	callq  *%rax
  802008:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80200b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80200f:	79 30                	jns    802041 <duppage+0xb1>
			panic("sys_page_map: %e", r);
  802011:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802014:	89 c1                	mov    %eax,%ecx
  802016:	48 ba fe 4e 80 00 00 	movabs $0x804efe,%rdx
  80201d:	00 00 00 
  802020:	be 50 00 00 00       	mov    $0x50,%esi
  802025:	48 bf b1 4e 80 00 00 	movabs $0x804eb1,%rdi
  80202c:	00 00 00 
  80202f:	b8 00 00 00 00       	mov    $0x0,%eax
  802034:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  80203b:	00 00 00 
  80203e:	41 ff d0             	callq  *%r8
		return 0;
  802041:	b8 00 00 00 00       	mov    $0x0,%eax
  802046:	e9 c4 00 00 00       	jmpq   80210f <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  80204b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80204f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802052:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802056:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  80205c:	48 89 c6             	mov    %rax,%rsi
  80205f:	bf 00 00 00 00       	mov    $0x0,%edi
  802064:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  80206b:	00 00 00 
  80206e:	ff d0                	callq  *%rax
  802070:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802073:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802077:	79 30                	jns    8020a9 <duppage+0x119>
		panic("sys_page_map: %e", r);
  802079:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80207c:	89 c1                	mov    %eax,%ecx
  80207e:	48 ba fe 4e 80 00 00 	movabs $0x804efe,%rdx
  802085:	00 00 00 
  802088:	be 64 00 00 00       	mov    $0x64,%esi
  80208d:	48 bf b1 4e 80 00 00 	movabs $0x804eb1,%rdi
  802094:	00 00 00 
  802097:	b8 00 00 00 00       	mov    $0x0,%eax
  80209c:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  8020a3:	00 00 00 
  8020a6:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  8020a9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8020ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020b1:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8020b7:	48 89 d1             	mov    %rdx,%rcx
  8020ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8020bf:	48 89 c6             	mov    %rax,%rsi
  8020c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8020c7:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  8020ce:	00 00 00 
  8020d1:	ff d0                	callq  *%rax
  8020d3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8020d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8020da:	79 30                	jns    80210c <duppage+0x17c>
		panic("sys_page_map: %e", r);
  8020dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020df:	89 c1                	mov    %eax,%ecx
  8020e1:	48 ba fe 4e 80 00 00 	movabs $0x804efe,%rdx
  8020e8:	00 00 00 
  8020eb:	be 66 00 00 00       	mov    $0x66,%esi
  8020f0:	48 bf b1 4e 80 00 00 	movabs $0x804eb1,%rdi
  8020f7:	00 00 00 
  8020fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ff:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  802106:	00 00 00 
  802109:	41 ff d0             	callq  *%r8
	return r;
  80210c:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  80210f:	c9                   	leaveq 
  802110:	c3                   	retq   

0000000000802111 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802111:	55                   	push   %rbp
  802112:	48 89 e5             	mov    %rsp,%rbp
  802115:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  802119:	48 bf 71 1d 80 00 00 	movabs $0x801d71,%rdi
  802120:	00 00 00 
  802123:	48 b8 78 47 80 00 00 	movabs $0x804778,%rax
  80212a:	00 00 00 
  80212d:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80212f:	b8 07 00 00 00       	mov    $0x7,%eax
  802134:	cd 30                	int    $0x30
  802136:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802139:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  80213c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  80213f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802143:	79 08                	jns    80214d <fork+0x3c>
		return envid;
  802145:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802148:	e9 09 02 00 00       	jmpq   802356 <fork+0x245>
	if (envid == 0) {
  80214d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802151:	75 3e                	jne    802191 <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  802153:	48 b8 15 19 80 00 00 	movabs $0x801915,%rax
  80215a:	00 00 00 
  80215d:	ff d0                	callq  *%rax
  80215f:	25 ff 03 00 00       	and    $0x3ff,%eax
  802164:	48 98                	cltq   
  802166:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80216d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802174:	00 00 00 
  802177:	48 01 c2             	add    %rax,%rdx
  80217a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802181:	00 00 00 
  802184:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802187:	b8 00 00 00 00       	mov    $0x0,%eax
  80218c:	e9 c5 01 00 00       	jmpq   802356 <fork+0x245>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  802191:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802198:	e9 a4 00 00 00       	jmpq   802241 <fork+0x130>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  80219d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a0:	c1 f8 12             	sar    $0x12,%eax
  8021a3:	89 c2                	mov    %eax,%edx
  8021a5:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8021ac:	01 00 00 
  8021af:	48 63 d2             	movslq %edx,%rdx
  8021b2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021b6:	83 e0 01             	and    $0x1,%eax
  8021b9:	48 85 c0             	test   %rax,%rax
  8021bc:	74 21                	je     8021df <fork+0xce>
  8021be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021c1:	c1 f8 09             	sar    $0x9,%eax
  8021c4:	89 c2                	mov    %eax,%edx
  8021c6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021cd:	01 00 00 
  8021d0:	48 63 d2             	movslq %edx,%rdx
  8021d3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021d7:	83 e0 01             	and    $0x1,%eax
  8021da:	48 85 c0             	test   %rax,%rax
  8021dd:	75 09                	jne    8021e8 <fork+0xd7>
			pn += NPTENTRIES;
  8021df:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  8021e6:	eb 59                	jmp    802241 <fork+0x130>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  8021e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021eb:	05 00 02 00 00       	add    $0x200,%eax
  8021f0:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8021f3:	eb 44                	jmp    802239 <fork+0x128>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  8021f5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021fc:	01 00 00 
  8021ff:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802202:	48 63 d2             	movslq %edx,%rdx
  802205:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802209:	83 e0 05             	and    $0x5,%eax
  80220c:	48 83 f8 05          	cmp    $0x5,%rax
  802210:	74 02                	je     802214 <fork+0x103>
				continue;
  802212:	eb 21                	jmp    802235 <fork+0x124>
			if (pn == PPN(UXSTACKTOP - 1))
  802214:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  80221b:	75 02                	jne    80221f <fork+0x10e>
				continue;
  80221d:	eb 16                	jmp    802235 <fork+0x124>
			duppage(envid, pn);
  80221f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802222:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802225:	89 d6                	mov    %edx,%esi
  802227:	89 c7                	mov    %eax,%edi
  802229:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  802230:	00 00 00 
  802233:	ff d0                	callq  *%rax
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802235:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802239:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80223c:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80223f:	7c b4                	jl     8021f5 <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  802241:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802244:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  802249:	0f 86 4e ff ff ff    	jbe    80219d <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80224f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802252:	ba 07 00 00 00       	mov    $0x7,%edx
  802257:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80225c:	89 c7                	mov    %eax,%edi
  80225e:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  802265:	00 00 00 
  802268:	ff d0                	callq  *%rax
  80226a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80226d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802271:	79 30                	jns    8022a3 <fork+0x192>
		panic("allocating exception stack: %e", r);
  802273:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802276:	89 c1                	mov    %eax,%ecx
  802278:	48 ba 28 4f 80 00 00 	movabs $0x804f28,%rdx
  80227f:	00 00 00 
  802282:	be 9e 00 00 00       	mov    $0x9e,%esi
  802287:	48 bf b1 4e 80 00 00 	movabs $0x804eb1,%rdi
  80228e:	00 00 00 
  802291:	b8 00 00 00 00       	mov    $0x0,%eax
  802296:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  80229d:	00 00 00 
  8022a0:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  8022a3:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8022aa:	00 00 00 
  8022ad:	48 8b 00             	mov    (%rax),%rax
  8022b0:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8022b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022ba:	48 89 d6             	mov    %rdx,%rsi
  8022bd:	89 c7                	mov    %eax,%edi
  8022bf:	48 b8 1b 1b 80 00 00 	movabs $0x801b1b,%rax
  8022c6:	00 00 00 
  8022c9:	ff d0                	callq  *%rax
  8022cb:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8022ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8022d2:	79 30                	jns    802304 <fork+0x1f3>
		panic("sys_env_set_pgfault_upcall: %e", r);
  8022d4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8022d7:	89 c1                	mov    %eax,%ecx
  8022d9:	48 ba 48 4f 80 00 00 	movabs $0x804f48,%rdx
  8022e0:	00 00 00 
  8022e3:	be a2 00 00 00       	mov    $0xa2,%esi
  8022e8:	48 bf b1 4e 80 00 00 	movabs $0x804eb1,%rdi
  8022ef:	00 00 00 
  8022f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f7:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  8022fe:	00 00 00 
  802301:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  802304:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802307:	be 02 00 00 00       	mov    $0x2,%esi
  80230c:	89 c7                	mov    %eax,%edi
  80230e:	48 b8 86 1a 80 00 00 	movabs $0x801a86,%rax
  802315:	00 00 00 
  802318:	ff d0                	callq  *%rax
  80231a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80231d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802321:	79 30                	jns    802353 <fork+0x242>
		panic("sys_env_set_status: %e", r);
  802323:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802326:	89 c1                	mov    %eax,%ecx
  802328:	48 ba 67 4f 80 00 00 	movabs $0x804f67,%rdx
  80232f:	00 00 00 
  802332:	be a7 00 00 00       	mov    $0xa7,%esi
  802337:	48 bf b1 4e 80 00 00 	movabs $0x804eb1,%rdi
  80233e:	00 00 00 
  802341:	b8 00 00 00 00       	mov    $0x0,%eax
  802346:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  80234d:	00 00 00 
  802350:	41 ff d0             	callq  *%r8

	return envid;
  802353:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  802356:	c9                   	leaveq 
  802357:	c3                   	retq   

0000000000802358 <sfork>:

// Challenge!
int
sfork(void)
{
  802358:	55                   	push   %rbp
  802359:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80235c:	48 ba 7e 4f 80 00 00 	movabs $0x804f7e,%rdx
  802363:	00 00 00 
  802366:	be b1 00 00 00       	mov    $0xb1,%esi
  80236b:	48 bf b1 4e 80 00 00 	movabs $0x804eb1,%rdi
  802372:	00 00 00 
  802375:	b8 00 00 00 00       	mov    $0x0,%eax
  80237a:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  802381:	00 00 00 
  802384:	ff d1                	callq  *%rcx

0000000000802386 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802386:	55                   	push   %rbp
  802387:	48 89 e5             	mov    %rsp,%rbp
  80238a:	48 83 ec 30          	sub    $0x30,%rsp
  80238e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802392:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802396:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  80239a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80239f:	75 0e                	jne    8023af <ipc_recv+0x29>
		pg = (void*) UTOP;
  8023a1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8023a8:	00 00 00 
  8023ab:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  8023af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023b3:	48 89 c7             	mov    %rax,%rdi
  8023b6:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  8023bd:	00 00 00 
  8023c0:	ff d0                	callq  *%rax
  8023c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c9:	79 27                	jns    8023f2 <ipc_recv+0x6c>
		if (from_env_store)
  8023cb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8023d0:	74 0a                	je     8023dc <ipc_recv+0x56>
			*from_env_store = 0;
  8023d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8023dc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8023e1:	74 0a                	je     8023ed <ipc_recv+0x67>
			*perm_store = 0;
  8023e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023e7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8023ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f0:	eb 53                	jmp    802445 <ipc_recv+0xbf>
	}
	if (from_env_store)
  8023f2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8023f7:	74 19                	je     802412 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8023f9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802400:	00 00 00 
  802403:	48 8b 00             	mov    (%rax),%rax
  802406:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80240c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802410:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  802412:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802417:	74 19                	je     802432 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  802419:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802420:	00 00 00 
  802423:	48 8b 00             	mov    (%rax),%rax
  802426:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80242c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802430:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  802432:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802439:	00 00 00 
  80243c:	48 8b 00             	mov    (%rax),%rax
  80243f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  802445:	c9                   	leaveq 
  802446:	c3                   	retq   

0000000000802447 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802447:	55                   	push   %rbp
  802448:	48 89 e5             	mov    %rsp,%rbp
  80244b:	48 83 ec 30          	sub    $0x30,%rsp
  80244f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802452:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802455:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802459:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  80245c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802461:	75 10                	jne    802473 <ipc_send+0x2c>
		pg = (void*) UTOP;
  802463:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80246a:	00 00 00 
  80246d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802471:	eb 0e                	jmp    802481 <ipc_send+0x3a>
  802473:	eb 0c                	jmp    802481 <ipc_send+0x3a>
		sys_yield();
  802475:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  80247c:	00 00 00 
  80247f:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802481:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802484:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802487:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80248b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80248e:	89 c7                	mov    %eax,%edi
  802490:	48 b8 65 1b 80 00 00 	movabs $0x801b65,%rax
  802497:	00 00 00 
  80249a:	ff d0                	callq  *%rax
  80249c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80249f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8024a3:	74 d0                	je     802475 <ipc_send+0x2e>
		sys_yield();
	}
	if (r < 0)
  8024a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a9:	79 30                	jns    8024db <ipc_send+0x94>
		panic("error in ipc_send: %e", r);
  8024ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ae:	89 c1                	mov    %eax,%ecx
  8024b0:	48 ba 94 4f 80 00 00 	movabs $0x804f94,%rdx
  8024b7:	00 00 00 
  8024ba:	be 47 00 00 00       	mov    $0x47,%esi
  8024bf:	48 bf aa 4f 80 00 00 	movabs $0x804faa,%rdi
  8024c6:	00 00 00 
  8024c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ce:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  8024d5:	00 00 00 
  8024d8:	41 ff d0             	callq  *%r8

}
  8024db:	c9                   	leaveq 
  8024dc:	c3                   	retq   

00000000008024dd <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8024dd:	55                   	push   %rbp
  8024de:	48 89 e5             	mov    %rsp,%rbp
  8024e1:	53                   	push   %rbx
  8024e2:	48 83 ec 28          	sub    $0x28,%rsp
  8024e6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  8024ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8024f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  8024f8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8024fd:	75 0e                	jne    80250d <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  8024ff:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802506:	00 00 00 
  802509:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  80250d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802511:	ba 07 00 00 00       	mov    $0x7,%edx
  802516:	48 89 c6             	mov    %rax,%rsi
  802519:	bf 00 00 00 00       	mov    $0x0,%edi
  80251e:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  802525:	00 00 00 
  802528:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  80252a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80252e:	48 c1 e8 0c          	shr    $0xc,%rax
  802532:	48 89 c2             	mov    %rax,%rdx
  802535:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80253c:	01 00 00 
  80253f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802543:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802549:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  80254d:	b8 03 00 00 00       	mov    $0x3,%eax
  802552:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802556:	48 89 d3             	mov    %rdx,%rbx
  802559:	0f 01 c1             	vmcall 
  80255c:	89 f2                	mov    %esi,%edx
  80255e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802561:	89 55 e8             	mov    %edx,-0x18(%rbp)
	/* cprintf("Returned IPC response from host: %d %d\n", r, -val);*/
	if (r < 0) {
  802564:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802568:	79 05                	jns    80256f <ipc_host_recv+0x92>
		return r;
  80256a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80256d:	eb 03                	jmp    802572 <ipc_host_recv+0x95>
	}
	return val;
  80256f:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  802572:	48 83 c4 28          	add    $0x28,%rsp
  802576:	5b                   	pop    %rbx
  802577:	5d                   	pop    %rbp
  802578:	c3                   	retq   

0000000000802579 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802579:	55                   	push   %rbp
  80257a:	48 89 e5             	mov    %rsp,%rbp
  80257d:	53                   	push   %rbx
  80257e:	48 83 ec 38          	sub    $0x38,%rsp
  802582:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802585:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802588:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80258c:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  80258f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  802596:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80259b:	75 0e                	jne    8025ab <ipc_host_send+0x32>
		pg = (void*) UTOP;
  80259d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8025a4:	00 00 00 
  8025a7:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8025ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025af:	48 c1 e8 0c          	shr    $0xc,%rax
  8025b3:	48 89 c2             	mov    %rax,%rdx
  8025b6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025bd:	01 00 00 
  8025c0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025c4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8025ca:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8025ce:	b8 02 00 00 00       	mov    $0x2,%eax
  8025d3:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8025d6:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8025d9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025dd:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8025e0:	89 fb                	mov    %edi,%ebx
  8025e2:	0f 01 c1             	vmcall 
  8025e5:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8025e8:	eb 26                	jmp    802610 <ipc_host_send+0x97>
		sys_yield();
  8025ea:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  8025f1:	00 00 00 
  8025f4:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8025f6:	b8 02 00 00 00       	mov    $0x2,%eax
  8025fb:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8025fe:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802601:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802605:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802608:	89 fb                	mov    %edi,%ebx
  80260a:	0f 01 c1             	vmcall 
  80260d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  802610:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  802614:	74 d4                	je     8025ea <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  802616:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80261a:	79 30                	jns    80264c <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  80261c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80261f:	89 c1                	mov    %eax,%ecx
  802621:	48 ba 94 4f 80 00 00 	movabs $0x804f94,%rdx
  802628:	00 00 00 
  80262b:	be 79 00 00 00       	mov    $0x79,%esi
  802630:	48 bf aa 4f 80 00 00 	movabs $0x804faa,%rdi
  802637:	00 00 00 
  80263a:	b8 00 00 00 00       	mov    $0x0,%eax
  80263f:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  802646:	00 00 00 
  802649:	41 ff d0             	callq  *%r8

}
  80264c:	48 83 c4 38          	add    $0x38,%rsp
  802650:	5b                   	pop    %rbx
  802651:	5d                   	pop    %rbp
  802652:	c3                   	retq   

0000000000802653 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802653:	55                   	push   %rbp
  802654:	48 89 e5             	mov    %rsp,%rbp
  802657:	48 83 ec 14          	sub    $0x14,%rsp
  80265b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80265e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802665:	eb 4e                	jmp    8026b5 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  802667:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80266e:	00 00 00 
  802671:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802674:	48 98                	cltq   
  802676:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80267d:	48 01 d0             	add    %rdx,%rax
  802680:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802686:	8b 00                	mov    (%rax),%eax
  802688:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80268b:	75 24                	jne    8026b1 <ipc_find_env+0x5e>
			return envs[i].env_id;
  80268d:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802694:	00 00 00 
  802697:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80269a:	48 98                	cltq   
  80269c:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8026a3:	48 01 d0             	add    %rdx,%rax
  8026a6:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8026ac:	8b 40 08             	mov    0x8(%rax),%eax
  8026af:	eb 12                	jmp    8026c3 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8026b1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026b5:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8026bc:	7e a9                	jle    802667 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8026be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026c3:	c9                   	leaveq 
  8026c4:	c3                   	retq   

00000000008026c5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8026c5:	55                   	push   %rbp
  8026c6:	48 89 e5             	mov    %rsp,%rbp
  8026c9:	48 83 ec 08          	sub    $0x8,%rsp
  8026cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8026d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8026d5:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8026dc:	ff ff ff 
  8026df:	48 01 d0             	add    %rdx,%rax
  8026e2:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8026e6:	c9                   	leaveq 
  8026e7:	c3                   	retq   

00000000008026e8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8026e8:	55                   	push   %rbp
  8026e9:	48 89 e5             	mov    %rsp,%rbp
  8026ec:	48 83 ec 08          	sub    $0x8,%rsp
  8026f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8026f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026f8:	48 89 c7             	mov    %rax,%rdi
  8026fb:	48 b8 c5 26 80 00 00 	movabs $0x8026c5,%rax
  802702:	00 00 00 
  802705:	ff d0                	callq  *%rax
  802707:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80270d:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802711:	c9                   	leaveq 
  802712:	c3                   	retq   

0000000000802713 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802713:	55                   	push   %rbp
  802714:	48 89 e5             	mov    %rsp,%rbp
  802717:	48 83 ec 18          	sub    $0x18,%rsp
  80271b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80271f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802726:	eb 6b                	jmp    802793 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802728:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80272b:	48 98                	cltq   
  80272d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802733:	48 c1 e0 0c          	shl    $0xc,%rax
  802737:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80273b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80273f:	48 c1 e8 15          	shr    $0x15,%rax
  802743:	48 89 c2             	mov    %rax,%rdx
  802746:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80274d:	01 00 00 
  802750:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802754:	83 e0 01             	and    $0x1,%eax
  802757:	48 85 c0             	test   %rax,%rax
  80275a:	74 21                	je     80277d <fd_alloc+0x6a>
  80275c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802760:	48 c1 e8 0c          	shr    $0xc,%rax
  802764:	48 89 c2             	mov    %rax,%rdx
  802767:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80276e:	01 00 00 
  802771:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802775:	83 e0 01             	and    $0x1,%eax
  802778:	48 85 c0             	test   %rax,%rax
  80277b:	75 12                	jne    80278f <fd_alloc+0x7c>
			*fd_store = fd;
  80277d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802781:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802785:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802788:	b8 00 00 00 00       	mov    $0x0,%eax
  80278d:	eb 1a                	jmp    8027a9 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80278f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802793:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802797:	7e 8f                	jle    802728 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802799:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80279d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8027a4:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8027a9:	c9                   	leaveq 
  8027aa:	c3                   	retq   

00000000008027ab <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8027ab:	55                   	push   %rbp
  8027ac:	48 89 e5             	mov    %rsp,%rbp
  8027af:	48 83 ec 20          	sub    $0x20,%rsp
  8027b3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027b6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8027ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8027be:	78 06                	js     8027c6 <fd_lookup+0x1b>
  8027c0:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8027c4:	7e 07                	jle    8027cd <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8027c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027cb:	eb 6c                	jmp    802839 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8027cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027d0:	48 98                	cltq   
  8027d2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027d8:	48 c1 e0 0c          	shl    $0xc,%rax
  8027dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8027e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027e4:	48 c1 e8 15          	shr    $0x15,%rax
  8027e8:	48 89 c2             	mov    %rax,%rdx
  8027eb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027f2:	01 00 00 
  8027f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027f9:	83 e0 01             	and    $0x1,%eax
  8027fc:	48 85 c0             	test   %rax,%rax
  8027ff:	74 21                	je     802822 <fd_lookup+0x77>
  802801:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802805:	48 c1 e8 0c          	shr    $0xc,%rax
  802809:	48 89 c2             	mov    %rax,%rdx
  80280c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802813:	01 00 00 
  802816:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80281a:	83 e0 01             	and    $0x1,%eax
  80281d:	48 85 c0             	test   %rax,%rax
  802820:	75 07                	jne    802829 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802822:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802827:	eb 10                	jmp    802839 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802829:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80282d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802831:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802834:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802839:	c9                   	leaveq 
  80283a:	c3                   	retq   

000000000080283b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80283b:	55                   	push   %rbp
  80283c:	48 89 e5             	mov    %rsp,%rbp
  80283f:	48 83 ec 30          	sub    $0x30,%rsp
  802843:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802847:	89 f0                	mov    %esi,%eax
  802849:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80284c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802850:	48 89 c7             	mov    %rax,%rdi
  802853:	48 b8 c5 26 80 00 00 	movabs $0x8026c5,%rax
  80285a:	00 00 00 
  80285d:	ff d0                	callq  *%rax
  80285f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802863:	48 89 d6             	mov    %rdx,%rsi
  802866:	89 c7                	mov    %eax,%edi
  802868:	48 b8 ab 27 80 00 00 	movabs $0x8027ab,%rax
  80286f:	00 00 00 
  802872:	ff d0                	callq  *%rax
  802874:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802877:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80287b:	78 0a                	js     802887 <fd_close+0x4c>
	    || fd != fd2)
  80287d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802881:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802885:	74 12                	je     802899 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802887:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80288b:	74 05                	je     802892 <fd_close+0x57>
  80288d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802890:	eb 05                	jmp    802897 <fd_close+0x5c>
  802892:	b8 00 00 00 00       	mov    $0x0,%eax
  802897:	eb 69                	jmp    802902 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802899:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80289d:	8b 00                	mov    (%rax),%eax
  80289f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028a3:	48 89 d6             	mov    %rdx,%rsi
  8028a6:	89 c7                	mov    %eax,%edi
  8028a8:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  8028af:	00 00 00 
  8028b2:	ff d0                	callq  *%rax
  8028b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028bb:	78 2a                	js     8028e7 <fd_close+0xac>
		if (dev->dev_close)
  8028bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c1:	48 8b 40 20          	mov    0x20(%rax),%rax
  8028c5:	48 85 c0             	test   %rax,%rax
  8028c8:	74 16                	je     8028e0 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8028ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ce:	48 8b 40 20          	mov    0x20(%rax),%rax
  8028d2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028d6:	48 89 d7             	mov    %rdx,%rdi
  8028d9:	ff d0                	callq  *%rax
  8028db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028de:	eb 07                	jmp    8028e7 <fd_close+0xac>
		else
			r = 0;
  8028e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8028e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028eb:	48 89 c6             	mov    %rax,%rsi
  8028ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8028f3:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  8028fa:	00 00 00 
  8028fd:	ff d0                	callq  *%rax
	return r;
  8028ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802902:	c9                   	leaveq 
  802903:	c3                   	retq   

0000000000802904 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802904:	55                   	push   %rbp
  802905:	48 89 e5             	mov    %rsp,%rbp
  802908:	48 83 ec 20          	sub    $0x20,%rsp
  80290c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80290f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802913:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80291a:	eb 41                	jmp    80295d <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80291c:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802923:	00 00 00 
  802926:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802929:	48 63 d2             	movslq %edx,%rdx
  80292c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802930:	8b 00                	mov    (%rax),%eax
  802932:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802935:	75 22                	jne    802959 <dev_lookup+0x55>
			*dev = devtab[i];
  802937:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80293e:	00 00 00 
  802941:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802944:	48 63 d2             	movslq %edx,%rdx
  802947:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80294b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80294f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802952:	b8 00 00 00 00       	mov    $0x0,%eax
  802957:	eb 60                	jmp    8029b9 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802959:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80295d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802964:	00 00 00 
  802967:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80296a:	48 63 d2             	movslq %edx,%rdx
  80296d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802971:	48 85 c0             	test   %rax,%rax
  802974:	75 a6                	jne    80291c <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802976:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80297d:	00 00 00 
  802980:	48 8b 00             	mov    (%rax),%rax
  802983:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802989:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80298c:	89 c6                	mov    %eax,%esi
  80298e:	48 bf b8 4f 80 00 00 	movabs $0x804fb8,%rdi
  802995:	00 00 00 
  802998:	b8 00 00 00 00       	mov    $0x0,%eax
  80299d:	48 b9 ad 04 80 00 00 	movabs $0x8004ad,%rcx
  8029a4:	00 00 00 
  8029a7:	ff d1                	callq  *%rcx
	*dev = 0;
  8029a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029ad:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8029b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8029b9:	c9                   	leaveq 
  8029ba:	c3                   	retq   

00000000008029bb <close>:

int
close(int fdnum)
{
  8029bb:	55                   	push   %rbp
  8029bc:	48 89 e5             	mov    %rsp,%rbp
  8029bf:	48 83 ec 20          	sub    $0x20,%rsp
  8029c3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029c6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029cd:	48 89 d6             	mov    %rdx,%rsi
  8029d0:	89 c7                	mov    %eax,%edi
  8029d2:	48 b8 ab 27 80 00 00 	movabs $0x8027ab,%rax
  8029d9:	00 00 00 
  8029dc:	ff d0                	callq  *%rax
  8029de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e5:	79 05                	jns    8029ec <close+0x31>
		return r;
  8029e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ea:	eb 18                	jmp    802a04 <close+0x49>
	else
		return fd_close(fd, 1);
  8029ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029f0:	be 01 00 00 00       	mov    $0x1,%esi
  8029f5:	48 89 c7             	mov    %rax,%rdi
  8029f8:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  8029ff:	00 00 00 
  802a02:	ff d0                	callq  *%rax
}
  802a04:	c9                   	leaveq 
  802a05:	c3                   	retq   

0000000000802a06 <close_all>:

void
close_all(void)
{
  802a06:	55                   	push   %rbp
  802a07:	48 89 e5             	mov    %rsp,%rbp
  802a0a:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802a0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a15:	eb 15                	jmp    802a2c <close_all+0x26>
		close(i);
  802a17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1a:	89 c7                	mov    %eax,%edi
  802a1c:	48 b8 bb 29 80 00 00 	movabs $0x8029bb,%rax
  802a23:	00 00 00 
  802a26:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802a28:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a2c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802a30:	7e e5                	jle    802a17 <close_all+0x11>
		close(i);
}
  802a32:	c9                   	leaveq 
  802a33:	c3                   	retq   

0000000000802a34 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802a34:	55                   	push   %rbp
  802a35:	48 89 e5             	mov    %rsp,%rbp
  802a38:	48 83 ec 40          	sub    $0x40,%rsp
  802a3c:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802a3f:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802a42:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802a46:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802a49:	48 89 d6             	mov    %rdx,%rsi
  802a4c:	89 c7                	mov    %eax,%edi
  802a4e:	48 b8 ab 27 80 00 00 	movabs $0x8027ab,%rax
  802a55:	00 00 00 
  802a58:	ff d0                	callq  *%rax
  802a5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a61:	79 08                	jns    802a6b <dup+0x37>
		return r;
  802a63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a66:	e9 70 01 00 00       	jmpq   802bdb <dup+0x1a7>
	close(newfdnum);
  802a6b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a6e:	89 c7                	mov    %eax,%edi
  802a70:	48 b8 bb 29 80 00 00 	movabs $0x8029bb,%rax
  802a77:	00 00 00 
  802a7a:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802a7c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a7f:	48 98                	cltq   
  802a81:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a87:	48 c1 e0 0c          	shl    $0xc,%rax
  802a8b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802a8f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a93:	48 89 c7             	mov    %rax,%rdi
  802a96:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  802a9d:	00 00 00 
  802aa0:	ff d0                	callq  *%rax
  802aa2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802aa6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aaa:	48 89 c7             	mov    %rax,%rdi
  802aad:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  802ab4:	00 00 00 
  802ab7:	ff d0                	callq  *%rax
  802ab9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802abd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac1:	48 c1 e8 15          	shr    $0x15,%rax
  802ac5:	48 89 c2             	mov    %rax,%rdx
  802ac8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802acf:	01 00 00 
  802ad2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ad6:	83 e0 01             	and    $0x1,%eax
  802ad9:	48 85 c0             	test   %rax,%rax
  802adc:	74 73                	je     802b51 <dup+0x11d>
  802ade:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae2:	48 c1 e8 0c          	shr    $0xc,%rax
  802ae6:	48 89 c2             	mov    %rax,%rdx
  802ae9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802af0:	01 00 00 
  802af3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802af7:	83 e0 01             	and    $0x1,%eax
  802afa:	48 85 c0             	test   %rax,%rax
  802afd:	74 52                	je     802b51 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802aff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b03:	48 c1 e8 0c          	shr    $0xc,%rax
  802b07:	48 89 c2             	mov    %rax,%rdx
  802b0a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b11:	01 00 00 
  802b14:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b18:	25 07 0e 00 00       	and    $0xe07,%eax
  802b1d:	89 c1                	mov    %eax,%ecx
  802b1f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b27:	41 89 c8             	mov    %ecx,%r8d
  802b2a:	48 89 d1             	mov    %rdx,%rcx
  802b2d:	ba 00 00 00 00       	mov    $0x0,%edx
  802b32:	48 89 c6             	mov    %rax,%rsi
  802b35:	bf 00 00 00 00       	mov    $0x0,%edi
  802b3a:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  802b41:	00 00 00 
  802b44:	ff d0                	callq  *%rax
  802b46:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b49:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b4d:	79 02                	jns    802b51 <dup+0x11d>
			goto err;
  802b4f:	eb 57                	jmp    802ba8 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802b51:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b55:	48 c1 e8 0c          	shr    $0xc,%rax
  802b59:	48 89 c2             	mov    %rax,%rdx
  802b5c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b63:	01 00 00 
  802b66:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b6a:	25 07 0e 00 00       	and    $0xe07,%eax
  802b6f:	89 c1                	mov    %eax,%ecx
  802b71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b75:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b79:	41 89 c8             	mov    %ecx,%r8d
  802b7c:	48 89 d1             	mov    %rdx,%rcx
  802b7f:	ba 00 00 00 00       	mov    $0x0,%edx
  802b84:	48 89 c6             	mov    %rax,%rsi
  802b87:	bf 00 00 00 00       	mov    $0x0,%edi
  802b8c:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  802b93:	00 00 00 
  802b96:	ff d0                	callq  *%rax
  802b98:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b9f:	79 02                	jns    802ba3 <dup+0x16f>
		goto err;
  802ba1:	eb 05                	jmp    802ba8 <dup+0x174>

	return newfdnum;
  802ba3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802ba6:	eb 33                	jmp    802bdb <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802ba8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bac:	48 89 c6             	mov    %rax,%rsi
  802baf:	bf 00 00 00 00       	mov    $0x0,%edi
  802bb4:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  802bbb:	00 00 00 
  802bbe:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802bc0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bc4:	48 89 c6             	mov    %rax,%rsi
  802bc7:	bf 00 00 00 00       	mov    $0x0,%edi
  802bcc:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  802bd3:	00 00 00 
  802bd6:	ff d0                	callq  *%rax
	return r;
  802bd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bdb:	c9                   	leaveq 
  802bdc:	c3                   	retq   

0000000000802bdd <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802bdd:	55                   	push   %rbp
  802bde:	48 89 e5             	mov    %rsp,%rbp
  802be1:	48 83 ec 40          	sub    $0x40,%rsp
  802be5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802be8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802bec:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bf0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bf4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bf7:	48 89 d6             	mov    %rdx,%rsi
  802bfa:	89 c7                	mov    %eax,%edi
  802bfc:	48 b8 ab 27 80 00 00 	movabs $0x8027ab,%rax
  802c03:	00 00 00 
  802c06:	ff d0                	callq  *%rax
  802c08:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c0f:	78 24                	js     802c35 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c15:	8b 00                	mov    (%rax),%eax
  802c17:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c1b:	48 89 d6             	mov    %rdx,%rsi
  802c1e:	89 c7                	mov    %eax,%edi
  802c20:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802c27:	00 00 00 
  802c2a:	ff d0                	callq  *%rax
  802c2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c33:	79 05                	jns    802c3a <read+0x5d>
		return r;
  802c35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c38:	eb 76                	jmp    802cb0 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802c3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c3e:	8b 40 08             	mov    0x8(%rax),%eax
  802c41:	83 e0 03             	and    $0x3,%eax
  802c44:	83 f8 01             	cmp    $0x1,%eax
  802c47:	75 3a                	jne    802c83 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802c49:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802c50:	00 00 00 
  802c53:	48 8b 00             	mov    (%rax),%rax
  802c56:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c5c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c5f:	89 c6                	mov    %eax,%esi
  802c61:	48 bf d7 4f 80 00 00 	movabs $0x804fd7,%rdi
  802c68:	00 00 00 
  802c6b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c70:	48 b9 ad 04 80 00 00 	movabs $0x8004ad,%rcx
  802c77:	00 00 00 
  802c7a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c81:	eb 2d                	jmp    802cb0 <read+0xd3>
	}
	if (!dev->dev_read)
  802c83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c87:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c8b:	48 85 c0             	test   %rax,%rax
  802c8e:	75 07                	jne    802c97 <read+0xba>
		return -E_NOT_SUPP;
  802c90:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c95:	eb 19                	jmp    802cb0 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802c97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c9b:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c9f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ca3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ca7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802cab:	48 89 cf             	mov    %rcx,%rdi
  802cae:	ff d0                	callq  *%rax
}
  802cb0:	c9                   	leaveq 
  802cb1:	c3                   	retq   

0000000000802cb2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802cb2:	55                   	push   %rbp
  802cb3:	48 89 e5             	mov    %rsp,%rbp
  802cb6:	48 83 ec 30          	sub    $0x30,%rsp
  802cba:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cbd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cc1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802cc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ccc:	eb 49                	jmp    802d17 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802cce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd1:	48 98                	cltq   
  802cd3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802cd7:	48 29 c2             	sub    %rax,%rdx
  802cda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cdd:	48 63 c8             	movslq %eax,%rcx
  802ce0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ce4:	48 01 c1             	add    %rax,%rcx
  802ce7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cea:	48 89 ce             	mov    %rcx,%rsi
  802ced:	89 c7                	mov    %eax,%edi
  802cef:	48 b8 dd 2b 80 00 00 	movabs $0x802bdd,%rax
  802cf6:	00 00 00 
  802cf9:	ff d0                	callq  *%rax
  802cfb:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802cfe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d02:	79 05                	jns    802d09 <readn+0x57>
			return m;
  802d04:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d07:	eb 1c                	jmp    802d25 <readn+0x73>
		if (m == 0)
  802d09:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d0d:	75 02                	jne    802d11 <readn+0x5f>
			break;
  802d0f:	eb 11                	jmp    802d22 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d11:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d14:	01 45 fc             	add    %eax,-0x4(%rbp)
  802d17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d1a:	48 98                	cltq   
  802d1c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d20:	72 ac                	jb     802cce <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802d22:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d25:	c9                   	leaveq 
  802d26:	c3                   	retq   

0000000000802d27 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802d27:	55                   	push   %rbp
  802d28:	48 89 e5             	mov    %rsp,%rbp
  802d2b:	48 83 ec 40          	sub    $0x40,%rsp
  802d2f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d32:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d36:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d3a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d3e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d41:	48 89 d6             	mov    %rdx,%rsi
  802d44:	89 c7                	mov    %eax,%edi
  802d46:	48 b8 ab 27 80 00 00 	movabs $0x8027ab,%rax
  802d4d:	00 00 00 
  802d50:	ff d0                	callq  *%rax
  802d52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d59:	78 24                	js     802d7f <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d5f:	8b 00                	mov    (%rax),%eax
  802d61:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d65:	48 89 d6             	mov    %rdx,%rsi
  802d68:	89 c7                	mov    %eax,%edi
  802d6a:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802d71:	00 00 00 
  802d74:	ff d0                	callq  *%rax
  802d76:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d79:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d7d:	79 05                	jns    802d84 <write+0x5d>
		return r;
  802d7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d82:	eb 75                	jmp    802df9 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d88:	8b 40 08             	mov    0x8(%rax),%eax
  802d8b:	83 e0 03             	and    $0x3,%eax
  802d8e:	85 c0                	test   %eax,%eax
  802d90:	75 3a                	jne    802dcc <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802d92:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802d99:	00 00 00 
  802d9c:	48 8b 00             	mov    (%rax),%rax
  802d9f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802da5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802da8:	89 c6                	mov    %eax,%esi
  802daa:	48 bf f3 4f 80 00 00 	movabs $0x804ff3,%rdi
  802db1:	00 00 00 
  802db4:	b8 00 00 00 00       	mov    $0x0,%eax
  802db9:	48 b9 ad 04 80 00 00 	movabs $0x8004ad,%rcx
  802dc0:	00 00 00 
  802dc3:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802dc5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802dca:	eb 2d                	jmp    802df9 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802dcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd0:	48 8b 40 18          	mov    0x18(%rax),%rax
  802dd4:	48 85 c0             	test   %rax,%rax
  802dd7:	75 07                	jne    802de0 <write+0xb9>
		return -E_NOT_SUPP;
  802dd9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dde:	eb 19                	jmp    802df9 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802de0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de4:	48 8b 40 18          	mov    0x18(%rax),%rax
  802de8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802dec:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802df0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802df4:	48 89 cf             	mov    %rcx,%rdi
  802df7:	ff d0                	callq  *%rax
}
  802df9:	c9                   	leaveq 
  802dfa:	c3                   	retq   

0000000000802dfb <seek>:

int
seek(int fdnum, off_t offset)
{
  802dfb:	55                   	push   %rbp
  802dfc:	48 89 e5             	mov    %rsp,%rbp
  802dff:	48 83 ec 18          	sub    $0x18,%rsp
  802e03:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e06:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e09:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e0d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e10:	48 89 d6             	mov    %rdx,%rsi
  802e13:	89 c7                	mov    %eax,%edi
  802e15:	48 b8 ab 27 80 00 00 	movabs $0x8027ab,%rax
  802e1c:	00 00 00 
  802e1f:	ff d0                	callq  *%rax
  802e21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e28:	79 05                	jns    802e2f <seek+0x34>
		return r;
  802e2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e2d:	eb 0f                	jmp    802e3e <seek+0x43>
	fd->fd_offset = offset;
  802e2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e33:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e36:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802e39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e3e:	c9                   	leaveq 
  802e3f:	c3                   	retq   

0000000000802e40 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802e40:	55                   	push   %rbp
  802e41:	48 89 e5             	mov    %rsp,%rbp
  802e44:	48 83 ec 30          	sub    $0x30,%rsp
  802e48:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e4b:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e4e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e52:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e55:	48 89 d6             	mov    %rdx,%rsi
  802e58:	89 c7                	mov    %eax,%edi
  802e5a:	48 b8 ab 27 80 00 00 	movabs $0x8027ab,%rax
  802e61:	00 00 00 
  802e64:	ff d0                	callq  *%rax
  802e66:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e6d:	78 24                	js     802e93 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e73:	8b 00                	mov    (%rax),%eax
  802e75:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e79:	48 89 d6             	mov    %rdx,%rsi
  802e7c:	89 c7                	mov    %eax,%edi
  802e7e:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802e85:	00 00 00 
  802e88:	ff d0                	callq  *%rax
  802e8a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e91:	79 05                	jns    802e98 <ftruncate+0x58>
		return r;
  802e93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e96:	eb 72                	jmp    802f0a <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e9c:	8b 40 08             	mov    0x8(%rax),%eax
  802e9f:	83 e0 03             	and    $0x3,%eax
  802ea2:	85 c0                	test   %eax,%eax
  802ea4:	75 3a                	jne    802ee0 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802ea6:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802ead:	00 00 00 
  802eb0:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802eb3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802eb9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ebc:	89 c6                	mov    %eax,%esi
  802ebe:	48 bf 10 50 80 00 00 	movabs $0x805010,%rdi
  802ec5:	00 00 00 
  802ec8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ecd:	48 b9 ad 04 80 00 00 	movabs $0x8004ad,%rcx
  802ed4:	00 00 00 
  802ed7:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802ed9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ede:	eb 2a                	jmp    802f0a <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802ee0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ee4:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ee8:	48 85 c0             	test   %rax,%rax
  802eeb:	75 07                	jne    802ef4 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802eed:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ef2:	eb 16                	jmp    802f0a <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802ef4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ef8:	48 8b 40 30          	mov    0x30(%rax),%rax
  802efc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f00:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802f03:	89 ce                	mov    %ecx,%esi
  802f05:	48 89 d7             	mov    %rdx,%rdi
  802f08:	ff d0                	callq  *%rax
}
  802f0a:	c9                   	leaveq 
  802f0b:	c3                   	retq   

0000000000802f0c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802f0c:	55                   	push   %rbp
  802f0d:	48 89 e5             	mov    %rsp,%rbp
  802f10:	48 83 ec 30          	sub    $0x30,%rsp
  802f14:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f17:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f1b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f1f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f22:	48 89 d6             	mov    %rdx,%rsi
  802f25:	89 c7                	mov    %eax,%edi
  802f27:	48 b8 ab 27 80 00 00 	movabs $0x8027ab,%rax
  802f2e:	00 00 00 
  802f31:	ff d0                	callq  *%rax
  802f33:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f36:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f3a:	78 24                	js     802f60 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f40:	8b 00                	mov    (%rax),%eax
  802f42:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f46:	48 89 d6             	mov    %rdx,%rsi
  802f49:	89 c7                	mov    %eax,%edi
  802f4b:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802f52:	00 00 00 
  802f55:	ff d0                	callq  *%rax
  802f57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f5e:	79 05                	jns    802f65 <fstat+0x59>
		return r;
  802f60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f63:	eb 5e                	jmp    802fc3 <fstat+0xb7>
	if (!dev->dev_stat)
  802f65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f69:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f6d:	48 85 c0             	test   %rax,%rax
  802f70:	75 07                	jne    802f79 <fstat+0x6d>
		return -E_NOT_SUPP;
  802f72:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f77:	eb 4a                	jmp    802fc3 <fstat+0xb7>
	stat->st_name[0] = 0;
  802f79:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f7d:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802f80:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f84:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802f8b:	00 00 00 
	stat->st_isdir = 0;
  802f8e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f92:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802f99:	00 00 00 
	stat->st_dev = dev;
  802f9c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802fa0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fa4:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802fab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802faf:	48 8b 40 28          	mov    0x28(%rax),%rax
  802fb3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802fb7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802fbb:	48 89 ce             	mov    %rcx,%rsi
  802fbe:	48 89 d7             	mov    %rdx,%rdi
  802fc1:	ff d0                	callq  *%rax
}
  802fc3:	c9                   	leaveq 
  802fc4:	c3                   	retq   

0000000000802fc5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802fc5:	55                   	push   %rbp
  802fc6:	48 89 e5             	mov    %rsp,%rbp
  802fc9:	48 83 ec 20          	sub    $0x20,%rsp
  802fcd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fd1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802fd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd9:	be 00 00 00 00       	mov    $0x0,%esi
  802fde:	48 89 c7             	mov    %rax,%rdi
  802fe1:	48 b8 b3 30 80 00 00 	movabs $0x8030b3,%rax
  802fe8:	00 00 00 
  802feb:	ff d0                	callq  *%rax
  802fed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ff0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff4:	79 05                	jns    802ffb <stat+0x36>
		return fd;
  802ff6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff9:	eb 2f                	jmp    80302a <stat+0x65>
	r = fstat(fd, stat);
  802ffb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802fff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803002:	48 89 d6             	mov    %rdx,%rsi
  803005:	89 c7                	mov    %eax,%edi
  803007:	48 b8 0c 2f 80 00 00 	movabs $0x802f0c,%rax
  80300e:	00 00 00 
  803011:	ff d0                	callq  *%rax
  803013:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803016:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803019:	89 c7                	mov    %eax,%edi
  80301b:	48 b8 bb 29 80 00 00 	movabs $0x8029bb,%rax
  803022:	00 00 00 
  803025:	ff d0                	callq  *%rax
	return r;
  803027:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80302a:	c9                   	leaveq 
  80302b:	c3                   	retq   

000000000080302c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80302c:	55                   	push   %rbp
  80302d:	48 89 e5             	mov    %rsp,%rbp
  803030:	48 83 ec 10          	sub    $0x10,%rsp
  803034:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803037:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80303b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803042:	00 00 00 
  803045:	8b 00                	mov    (%rax),%eax
  803047:	85 c0                	test   %eax,%eax
  803049:	75 1d                	jne    803068 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80304b:	bf 01 00 00 00       	mov    $0x1,%edi
  803050:	48 b8 53 26 80 00 00 	movabs $0x802653,%rax
  803057:	00 00 00 
  80305a:	ff d0                	callq  *%rax
  80305c:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  803063:	00 00 00 
  803066:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803068:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80306f:	00 00 00 
  803072:	8b 00                	mov    (%rax),%eax
  803074:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803077:	b9 07 00 00 00       	mov    $0x7,%ecx
  80307c:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  803083:	00 00 00 
  803086:	89 c7                	mov    %eax,%edi
  803088:	48 b8 47 24 80 00 00 	movabs $0x802447,%rax
  80308f:	00 00 00 
  803092:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803094:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803098:	ba 00 00 00 00       	mov    $0x0,%edx
  80309d:	48 89 c6             	mov    %rax,%rsi
  8030a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8030a5:	48 b8 86 23 80 00 00 	movabs $0x802386,%rax
  8030ac:	00 00 00 
  8030af:	ff d0                	callq  *%rax
}
  8030b1:	c9                   	leaveq 
  8030b2:	c3                   	retq   

00000000008030b3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8030b3:	55                   	push   %rbp
  8030b4:	48 89 e5             	mov    %rsp,%rbp
  8030b7:	48 83 ec 20          	sub    $0x20,%rsp
  8030bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030bf:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8030c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030c6:	48 89 c7             	mov    %rax,%rdi
  8030c9:	48 b8 f6 0f 80 00 00 	movabs $0x800ff6,%rax
  8030d0:	00 00 00 
  8030d3:	ff d0                	callq  *%rax
  8030d5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8030da:	7e 0a                	jle    8030e6 <open+0x33>
		return -E_BAD_PATH;
  8030dc:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8030e1:	e9 a5 00 00 00       	jmpq   80318b <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8030e6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8030ea:	48 89 c7             	mov    %rax,%rdi
  8030ed:	48 b8 13 27 80 00 00 	movabs $0x802713,%rax
  8030f4:	00 00 00 
  8030f7:	ff d0                	callq  *%rax
  8030f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803100:	79 08                	jns    80310a <open+0x57>
		return r;
  803102:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803105:	e9 81 00 00 00       	jmpq   80318b <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  80310a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80310e:	48 89 c6             	mov    %rax,%rsi
  803111:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803118:	00 00 00 
  80311b:	48 b8 62 10 80 00 00 	movabs $0x801062,%rax
  803122:	00 00 00 
  803125:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  803127:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80312e:	00 00 00 
  803131:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803134:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80313a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80313e:	48 89 c6             	mov    %rax,%rsi
  803141:	bf 01 00 00 00       	mov    $0x1,%edi
  803146:	48 b8 2c 30 80 00 00 	movabs $0x80302c,%rax
  80314d:	00 00 00 
  803150:	ff d0                	callq  *%rax
  803152:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803155:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803159:	79 1d                	jns    803178 <open+0xc5>
		fd_close(fd, 0);
  80315b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80315f:	be 00 00 00 00       	mov    $0x0,%esi
  803164:	48 89 c7             	mov    %rax,%rdi
  803167:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  80316e:	00 00 00 
  803171:	ff d0                	callq  *%rax
		return r;
  803173:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803176:	eb 13                	jmp    80318b <open+0xd8>
	}

	return fd2num(fd);
  803178:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80317c:	48 89 c7             	mov    %rax,%rdi
  80317f:	48 b8 c5 26 80 00 00 	movabs $0x8026c5,%rax
  803186:	00 00 00 
  803189:	ff d0                	callq  *%rax

}
  80318b:	c9                   	leaveq 
  80318c:	c3                   	retq   

000000000080318d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80318d:	55                   	push   %rbp
  80318e:	48 89 e5             	mov    %rsp,%rbp
  803191:	48 83 ec 10          	sub    $0x10,%rsp
  803195:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803199:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80319d:	8b 50 0c             	mov    0xc(%rax),%edx
  8031a0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031a7:	00 00 00 
  8031aa:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8031ac:	be 00 00 00 00       	mov    $0x0,%esi
  8031b1:	bf 06 00 00 00       	mov    $0x6,%edi
  8031b6:	48 b8 2c 30 80 00 00 	movabs $0x80302c,%rax
  8031bd:	00 00 00 
  8031c0:	ff d0                	callq  *%rax
}
  8031c2:	c9                   	leaveq 
  8031c3:	c3                   	retq   

00000000008031c4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8031c4:	55                   	push   %rbp
  8031c5:	48 89 e5             	mov    %rsp,%rbp
  8031c8:	48 83 ec 30          	sub    $0x30,%rsp
  8031cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031d4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8031d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031dc:	8b 50 0c             	mov    0xc(%rax),%edx
  8031df:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031e6:	00 00 00 
  8031e9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8031eb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031f2:	00 00 00 
  8031f5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031f9:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8031fd:	be 00 00 00 00       	mov    $0x0,%esi
  803202:	bf 03 00 00 00       	mov    $0x3,%edi
  803207:	48 b8 2c 30 80 00 00 	movabs $0x80302c,%rax
  80320e:	00 00 00 
  803211:	ff d0                	callq  *%rax
  803213:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803216:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80321a:	79 08                	jns    803224 <devfile_read+0x60>
		return r;
  80321c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80321f:	e9 a4 00 00 00       	jmpq   8032c8 <devfile_read+0x104>
	assert(r <= n);
  803224:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803227:	48 98                	cltq   
  803229:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80322d:	76 35                	jbe    803264 <devfile_read+0xa0>
  80322f:	48 b9 36 50 80 00 00 	movabs $0x805036,%rcx
  803236:	00 00 00 
  803239:	48 ba 3d 50 80 00 00 	movabs $0x80503d,%rdx
  803240:	00 00 00 
  803243:	be 86 00 00 00       	mov    $0x86,%esi
  803248:	48 bf 52 50 80 00 00 	movabs $0x805052,%rdi
  80324f:	00 00 00 
  803252:	b8 00 00 00 00       	mov    $0x0,%eax
  803257:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  80325e:	00 00 00 
  803261:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803264:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  80326b:	7e 35                	jle    8032a2 <devfile_read+0xde>
  80326d:	48 b9 5d 50 80 00 00 	movabs $0x80505d,%rcx
  803274:	00 00 00 
  803277:	48 ba 3d 50 80 00 00 	movabs $0x80503d,%rdx
  80327e:	00 00 00 
  803281:	be 87 00 00 00       	mov    $0x87,%esi
  803286:	48 bf 52 50 80 00 00 	movabs $0x805052,%rdi
  80328d:	00 00 00 
  803290:	b8 00 00 00 00       	mov    $0x0,%eax
  803295:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  80329c:	00 00 00 
  80329f:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8032a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a5:	48 63 d0             	movslq %eax,%rdx
  8032a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032ac:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8032b3:	00 00 00 
  8032b6:	48 89 c7             	mov    %rax,%rdi
  8032b9:	48 b8 86 13 80 00 00 	movabs $0x801386,%rax
  8032c0:	00 00 00 
  8032c3:	ff d0                	callq  *%rax
	return r;
  8032c5:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8032c8:	c9                   	leaveq 
  8032c9:	c3                   	retq   

00000000008032ca <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8032ca:	55                   	push   %rbp
  8032cb:	48 89 e5             	mov    %rsp,%rbp
  8032ce:	48 83 ec 40          	sub    $0x40,%rsp
  8032d2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032d6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8032da:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8032de:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8032e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8032e6:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  8032ed:	00 
  8032ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f2:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8032f6:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  8032fb:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8032ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803303:	8b 50 0c             	mov    0xc(%rax),%edx
  803306:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80330d:	00 00 00 
  803310:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803312:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803319:	00 00 00 
  80331c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803320:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803324:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803328:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80332c:	48 89 c6             	mov    %rax,%rsi
  80332f:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803336:	00 00 00 
  803339:	48 b8 86 13 80 00 00 	movabs $0x801386,%rax
  803340:	00 00 00 
  803343:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803345:	be 00 00 00 00       	mov    $0x0,%esi
  80334a:	bf 04 00 00 00       	mov    $0x4,%edi
  80334f:	48 b8 2c 30 80 00 00 	movabs $0x80302c,%rax
  803356:	00 00 00 
  803359:	ff d0                	callq  *%rax
  80335b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80335e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803362:	79 05                	jns    803369 <devfile_write+0x9f>
		return r;
  803364:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803367:	eb 43                	jmp    8033ac <devfile_write+0xe2>
	assert(r <= n);
  803369:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80336c:	48 98                	cltq   
  80336e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803372:	76 35                	jbe    8033a9 <devfile_write+0xdf>
  803374:	48 b9 36 50 80 00 00 	movabs $0x805036,%rcx
  80337b:	00 00 00 
  80337e:	48 ba 3d 50 80 00 00 	movabs $0x80503d,%rdx
  803385:	00 00 00 
  803388:	be a2 00 00 00       	mov    $0xa2,%esi
  80338d:	48 bf 52 50 80 00 00 	movabs $0x805052,%rdi
  803394:	00 00 00 
  803397:	b8 00 00 00 00       	mov    $0x0,%eax
  80339c:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  8033a3:	00 00 00 
  8033a6:	41 ff d0             	callq  *%r8
	return r;
  8033a9:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8033ac:	c9                   	leaveq 
  8033ad:	c3                   	retq   

00000000008033ae <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8033ae:	55                   	push   %rbp
  8033af:	48 89 e5             	mov    %rsp,%rbp
  8033b2:	48 83 ec 20          	sub    $0x20,%rsp
  8033b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8033be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033c2:	8b 50 0c             	mov    0xc(%rax),%edx
  8033c5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033cc:	00 00 00 
  8033cf:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8033d1:	be 00 00 00 00       	mov    $0x0,%esi
  8033d6:	bf 05 00 00 00       	mov    $0x5,%edi
  8033db:	48 b8 2c 30 80 00 00 	movabs $0x80302c,%rax
  8033e2:	00 00 00 
  8033e5:	ff d0                	callq  *%rax
  8033e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ee:	79 05                	jns    8033f5 <devfile_stat+0x47>
		return r;
  8033f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f3:	eb 56                	jmp    80344b <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8033f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033f9:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803400:	00 00 00 
  803403:	48 89 c7             	mov    %rax,%rdi
  803406:	48 b8 62 10 80 00 00 	movabs $0x801062,%rax
  80340d:	00 00 00 
  803410:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803412:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803419:	00 00 00 
  80341c:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803422:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803426:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80342c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803433:	00 00 00 
  803436:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80343c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803440:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803446:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80344b:	c9                   	leaveq 
  80344c:	c3                   	retq   

000000000080344d <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80344d:	55                   	push   %rbp
  80344e:	48 89 e5             	mov    %rsp,%rbp
  803451:	48 83 ec 10          	sub    $0x10,%rsp
  803455:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803459:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80345c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803460:	8b 50 0c             	mov    0xc(%rax),%edx
  803463:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80346a:	00 00 00 
  80346d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80346f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803476:	00 00 00 
  803479:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80347c:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80347f:	be 00 00 00 00       	mov    $0x0,%esi
  803484:	bf 02 00 00 00       	mov    $0x2,%edi
  803489:	48 b8 2c 30 80 00 00 	movabs $0x80302c,%rax
  803490:	00 00 00 
  803493:	ff d0                	callq  *%rax
}
  803495:	c9                   	leaveq 
  803496:	c3                   	retq   

0000000000803497 <remove>:

// Delete a file
int
remove(const char *path)
{
  803497:	55                   	push   %rbp
  803498:	48 89 e5             	mov    %rsp,%rbp
  80349b:	48 83 ec 10          	sub    $0x10,%rsp
  80349f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8034a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034a7:	48 89 c7             	mov    %rax,%rdi
  8034aa:	48 b8 f6 0f 80 00 00 	movabs $0x800ff6,%rax
  8034b1:	00 00 00 
  8034b4:	ff d0                	callq  *%rax
  8034b6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8034bb:	7e 07                	jle    8034c4 <remove+0x2d>
		return -E_BAD_PATH;
  8034bd:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8034c2:	eb 33                	jmp    8034f7 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8034c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034c8:	48 89 c6             	mov    %rax,%rsi
  8034cb:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8034d2:	00 00 00 
  8034d5:	48 b8 62 10 80 00 00 	movabs $0x801062,%rax
  8034dc:	00 00 00 
  8034df:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8034e1:	be 00 00 00 00       	mov    $0x0,%esi
  8034e6:	bf 07 00 00 00       	mov    $0x7,%edi
  8034eb:	48 b8 2c 30 80 00 00 	movabs $0x80302c,%rax
  8034f2:	00 00 00 
  8034f5:	ff d0                	callq  *%rax
}
  8034f7:	c9                   	leaveq 
  8034f8:	c3                   	retq   

00000000008034f9 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8034f9:	55                   	push   %rbp
  8034fa:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8034fd:	be 00 00 00 00       	mov    $0x0,%esi
  803502:	bf 08 00 00 00       	mov    $0x8,%edi
  803507:	48 b8 2c 30 80 00 00 	movabs $0x80302c,%rax
  80350e:	00 00 00 
  803511:	ff d0                	callq  *%rax
}
  803513:	5d                   	pop    %rbp
  803514:	c3                   	retq   

0000000000803515 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803515:	55                   	push   %rbp
  803516:	48 89 e5             	mov    %rsp,%rbp
  803519:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803520:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803527:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80352e:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803535:	be 00 00 00 00       	mov    $0x0,%esi
  80353a:	48 89 c7             	mov    %rax,%rdi
  80353d:	48 b8 b3 30 80 00 00 	movabs $0x8030b3,%rax
  803544:	00 00 00 
  803547:	ff d0                	callq  *%rax
  803549:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80354c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803550:	79 28                	jns    80357a <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803552:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803555:	89 c6                	mov    %eax,%esi
  803557:	48 bf 69 50 80 00 00 	movabs $0x805069,%rdi
  80355e:	00 00 00 
  803561:	b8 00 00 00 00       	mov    $0x0,%eax
  803566:	48 ba ad 04 80 00 00 	movabs $0x8004ad,%rdx
  80356d:	00 00 00 
  803570:	ff d2                	callq  *%rdx
		return fd_src;
  803572:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803575:	e9 74 01 00 00       	jmpq   8036ee <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80357a:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803581:	be 01 01 00 00       	mov    $0x101,%esi
  803586:	48 89 c7             	mov    %rax,%rdi
  803589:	48 b8 b3 30 80 00 00 	movabs $0x8030b3,%rax
  803590:	00 00 00 
  803593:	ff d0                	callq  *%rax
  803595:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803598:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80359c:	79 39                	jns    8035d7 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80359e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035a1:	89 c6                	mov    %eax,%esi
  8035a3:	48 bf 7f 50 80 00 00 	movabs $0x80507f,%rdi
  8035aa:	00 00 00 
  8035ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b2:	48 ba ad 04 80 00 00 	movabs $0x8004ad,%rdx
  8035b9:	00 00 00 
  8035bc:	ff d2                	callq  *%rdx
		close(fd_src);
  8035be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c1:	89 c7                	mov    %eax,%edi
  8035c3:	48 b8 bb 29 80 00 00 	movabs $0x8029bb,%rax
  8035ca:	00 00 00 
  8035cd:	ff d0                	callq  *%rax
		return fd_dest;
  8035cf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035d2:	e9 17 01 00 00       	jmpq   8036ee <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8035d7:	eb 74                	jmp    80364d <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8035d9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035dc:	48 63 d0             	movslq %eax,%rdx
  8035df:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8035e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035e9:	48 89 ce             	mov    %rcx,%rsi
  8035ec:	89 c7                	mov    %eax,%edi
  8035ee:	48 b8 27 2d 80 00 00 	movabs $0x802d27,%rax
  8035f5:	00 00 00 
  8035f8:	ff d0                	callq  *%rax
  8035fa:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8035fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803601:	79 4a                	jns    80364d <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803603:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803606:	89 c6                	mov    %eax,%esi
  803608:	48 bf 99 50 80 00 00 	movabs $0x805099,%rdi
  80360f:	00 00 00 
  803612:	b8 00 00 00 00       	mov    $0x0,%eax
  803617:	48 ba ad 04 80 00 00 	movabs $0x8004ad,%rdx
  80361e:	00 00 00 
  803621:	ff d2                	callq  *%rdx
			close(fd_src);
  803623:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803626:	89 c7                	mov    %eax,%edi
  803628:	48 b8 bb 29 80 00 00 	movabs $0x8029bb,%rax
  80362f:	00 00 00 
  803632:	ff d0                	callq  *%rax
			close(fd_dest);
  803634:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803637:	89 c7                	mov    %eax,%edi
  803639:	48 b8 bb 29 80 00 00 	movabs $0x8029bb,%rax
  803640:	00 00 00 
  803643:	ff d0                	callq  *%rax
			return write_size;
  803645:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803648:	e9 a1 00 00 00       	jmpq   8036ee <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80364d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803654:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803657:	ba 00 02 00 00       	mov    $0x200,%edx
  80365c:	48 89 ce             	mov    %rcx,%rsi
  80365f:	89 c7                	mov    %eax,%edi
  803661:	48 b8 dd 2b 80 00 00 	movabs $0x802bdd,%rax
  803668:	00 00 00 
  80366b:	ff d0                	callq  *%rax
  80366d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803670:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803674:	0f 8f 5f ff ff ff    	jg     8035d9 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80367a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80367e:	79 47                	jns    8036c7 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803680:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803683:	89 c6                	mov    %eax,%esi
  803685:	48 bf ac 50 80 00 00 	movabs $0x8050ac,%rdi
  80368c:	00 00 00 
  80368f:	b8 00 00 00 00       	mov    $0x0,%eax
  803694:	48 ba ad 04 80 00 00 	movabs $0x8004ad,%rdx
  80369b:	00 00 00 
  80369e:	ff d2                	callq  *%rdx
		close(fd_src);
  8036a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a3:	89 c7                	mov    %eax,%edi
  8036a5:	48 b8 bb 29 80 00 00 	movabs $0x8029bb,%rax
  8036ac:	00 00 00 
  8036af:	ff d0                	callq  *%rax
		close(fd_dest);
  8036b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036b4:	89 c7                	mov    %eax,%edi
  8036b6:	48 b8 bb 29 80 00 00 	movabs $0x8029bb,%rax
  8036bd:	00 00 00 
  8036c0:	ff d0                	callq  *%rax
		return read_size;
  8036c2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8036c5:	eb 27                	jmp    8036ee <copy+0x1d9>
	}
	close(fd_src);
  8036c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ca:	89 c7                	mov    %eax,%edi
  8036cc:	48 b8 bb 29 80 00 00 	movabs $0x8029bb,%rax
  8036d3:	00 00 00 
  8036d6:	ff d0                	callq  *%rax
	close(fd_dest);
  8036d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036db:	89 c7                	mov    %eax,%edi
  8036dd:	48 b8 bb 29 80 00 00 	movabs $0x8029bb,%rax
  8036e4:	00 00 00 
  8036e7:	ff d0                	callq  *%rax
	return 0;
  8036e9:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8036ee:	c9                   	leaveq 
  8036ef:	c3                   	retq   

00000000008036f0 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8036f0:	55                   	push   %rbp
  8036f1:	48 89 e5             	mov    %rsp,%rbp
  8036f4:	48 83 ec 20          	sub    $0x20,%rsp
  8036f8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8036fb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8036ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803702:	48 89 d6             	mov    %rdx,%rsi
  803705:	89 c7                	mov    %eax,%edi
  803707:	48 b8 ab 27 80 00 00 	movabs $0x8027ab,%rax
  80370e:	00 00 00 
  803711:	ff d0                	callq  *%rax
  803713:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803716:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80371a:	79 05                	jns    803721 <fd2sockid+0x31>
		return r;
  80371c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80371f:	eb 24                	jmp    803745 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803721:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803725:	8b 10                	mov    (%rax),%edx
  803727:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  80372e:	00 00 00 
  803731:	8b 00                	mov    (%rax),%eax
  803733:	39 c2                	cmp    %eax,%edx
  803735:	74 07                	je     80373e <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803737:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80373c:	eb 07                	jmp    803745 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80373e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803742:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803745:	c9                   	leaveq 
  803746:	c3                   	retq   

0000000000803747 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803747:	55                   	push   %rbp
  803748:	48 89 e5             	mov    %rsp,%rbp
  80374b:	48 83 ec 20          	sub    $0x20,%rsp
  80374f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803752:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803756:	48 89 c7             	mov    %rax,%rdi
  803759:	48 b8 13 27 80 00 00 	movabs $0x802713,%rax
  803760:	00 00 00 
  803763:	ff d0                	callq  *%rax
  803765:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803768:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80376c:	78 26                	js     803794 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80376e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803772:	ba 07 04 00 00       	mov    $0x407,%edx
  803777:	48 89 c6             	mov    %rax,%rsi
  80377a:	bf 00 00 00 00       	mov    $0x0,%edi
  80377f:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  803786:	00 00 00 
  803789:	ff d0                	callq  *%rax
  80378b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80378e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803792:	79 16                	jns    8037aa <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803794:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803797:	89 c7                	mov    %eax,%edi
  803799:	48 b8 54 3c 80 00 00 	movabs $0x803c54,%rax
  8037a0:	00 00 00 
  8037a3:	ff d0                	callq  *%rax
		return r;
  8037a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a8:	eb 3a                	jmp    8037e4 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8037aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ae:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8037b5:	00 00 00 
  8037b8:	8b 12                	mov    (%rdx),%edx
  8037ba:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8037bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8037c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037cb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8037ce:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8037d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d5:	48 89 c7             	mov    %rax,%rdi
  8037d8:	48 b8 c5 26 80 00 00 	movabs $0x8026c5,%rax
  8037df:	00 00 00 
  8037e2:	ff d0                	callq  *%rax
}
  8037e4:	c9                   	leaveq 
  8037e5:	c3                   	retq   

00000000008037e6 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8037e6:	55                   	push   %rbp
  8037e7:	48 89 e5             	mov    %rsp,%rbp
  8037ea:	48 83 ec 30          	sub    $0x30,%rsp
  8037ee:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037f5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037fc:	89 c7                	mov    %eax,%edi
  8037fe:	48 b8 f0 36 80 00 00 	movabs $0x8036f0,%rax
  803805:	00 00 00 
  803808:	ff d0                	callq  *%rax
  80380a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80380d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803811:	79 05                	jns    803818 <accept+0x32>
		return r;
  803813:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803816:	eb 3b                	jmp    803853 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803818:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80381c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803820:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803823:	48 89 ce             	mov    %rcx,%rsi
  803826:	89 c7                	mov    %eax,%edi
  803828:	48 b8 31 3b 80 00 00 	movabs $0x803b31,%rax
  80382f:	00 00 00 
  803832:	ff d0                	callq  *%rax
  803834:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803837:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80383b:	79 05                	jns    803842 <accept+0x5c>
		return r;
  80383d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803840:	eb 11                	jmp    803853 <accept+0x6d>
	return alloc_sockfd(r);
  803842:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803845:	89 c7                	mov    %eax,%edi
  803847:	48 b8 47 37 80 00 00 	movabs $0x803747,%rax
  80384e:	00 00 00 
  803851:	ff d0                	callq  *%rax
}
  803853:	c9                   	leaveq 
  803854:	c3                   	retq   

0000000000803855 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803855:	55                   	push   %rbp
  803856:	48 89 e5             	mov    %rsp,%rbp
  803859:	48 83 ec 20          	sub    $0x20,%rsp
  80385d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803860:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803864:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803867:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80386a:	89 c7                	mov    %eax,%edi
  80386c:	48 b8 f0 36 80 00 00 	movabs $0x8036f0,%rax
  803873:	00 00 00 
  803876:	ff d0                	callq  *%rax
  803878:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80387b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80387f:	79 05                	jns    803886 <bind+0x31>
		return r;
  803881:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803884:	eb 1b                	jmp    8038a1 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803886:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803889:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80388d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803890:	48 89 ce             	mov    %rcx,%rsi
  803893:	89 c7                	mov    %eax,%edi
  803895:	48 b8 b0 3b 80 00 00 	movabs $0x803bb0,%rax
  80389c:	00 00 00 
  80389f:	ff d0                	callq  *%rax
}
  8038a1:	c9                   	leaveq 
  8038a2:	c3                   	retq   

00000000008038a3 <shutdown>:

int
shutdown(int s, int how)
{
  8038a3:	55                   	push   %rbp
  8038a4:	48 89 e5             	mov    %rsp,%rbp
  8038a7:	48 83 ec 20          	sub    $0x20,%rsp
  8038ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038ae:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038b4:	89 c7                	mov    %eax,%edi
  8038b6:	48 b8 f0 36 80 00 00 	movabs $0x8036f0,%rax
  8038bd:	00 00 00 
  8038c0:	ff d0                	callq  *%rax
  8038c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038c9:	79 05                	jns    8038d0 <shutdown+0x2d>
		return r;
  8038cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ce:	eb 16                	jmp    8038e6 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8038d0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d6:	89 d6                	mov    %edx,%esi
  8038d8:	89 c7                	mov    %eax,%edi
  8038da:	48 b8 14 3c 80 00 00 	movabs $0x803c14,%rax
  8038e1:	00 00 00 
  8038e4:	ff d0                	callq  *%rax
}
  8038e6:	c9                   	leaveq 
  8038e7:	c3                   	retq   

00000000008038e8 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8038e8:	55                   	push   %rbp
  8038e9:	48 89 e5             	mov    %rsp,%rbp
  8038ec:	48 83 ec 10          	sub    $0x10,%rsp
  8038f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8038f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038f8:	48 89 c7             	mov    %rax,%rdi
  8038fb:	48 b8 a0 48 80 00 00 	movabs $0x8048a0,%rax
  803902:	00 00 00 
  803905:	ff d0                	callq  *%rax
  803907:	83 f8 01             	cmp    $0x1,%eax
  80390a:	75 17                	jne    803923 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80390c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803910:	8b 40 0c             	mov    0xc(%rax),%eax
  803913:	89 c7                	mov    %eax,%edi
  803915:	48 b8 54 3c 80 00 00 	movabs $0x803c54,%rax
  80391c:	00 00 00 
  80391f:	ff d0                	callq  *%rax
  803921:	eb 05                	jmp    803928 <devsock_close+0x40>
	else
		return 0;
  803923:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803928:	c9                   	leaveq 
  803929:	c3                   	retq   

000000000080392a <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80392a:	55                   	push   %rbp
  80392b:	48 89 e5             	mov    %rsp,%rbp
  80392e:	48 83 ec 20          	sub    $0x20,%rsp
  803932:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803935:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803939:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80393c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80393f:	89 c7                	mov    %eax,%edi
  803941:	48 b8 f0 36 80 00 00 	movabs $0x8036f0,%rax
  803948:	00 00 00 
  80394b:	ff d0                	callq  *%rax
  80394d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803950:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803954:	79 05                	jns    80395b <connect+0x31>
		return r;
  803956:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803959:	eb 1b                	jmp    803976 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80395b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80395e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803962:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803965:	48 89 ce             	mov    %rcx,%rsi
  803968:	89 c7                	mov    %eax,%edi
  80396a:	48 b8 81 3c 80 00 00 	movabs $0x803c81,%rax
  803971:	00 00 00 
  803974:	ff d0                	callq  *%rax
}
  803976:	c9                   	leaveq 
  803977:	c3                   	retq   

0000000000803978 <listen>:

int
listen(int s, int backlog)
{
  803978:	55                   	push   %rbp
  803979:	48 89 e5             	mov    %rsp,%rbp
  80397c:	48 83 ec 20          	sub    $0x20,%rsp
  803980:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803983:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803986:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803989:	89 c7                	mov    %eax,%edi
  80398b:	48 b8 f0 36 80 00 00 	movabs $0x8036f0,%rax
  803992:	00 00 00 
  803995:	ff d0                	callq  *%rax
  803997:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80399a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80399e:	79 05                	jns    8039a5 <listen+0x2d>
		return r;
  8039a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039a3:	eb 16                	jmp    8039bb <listen+0x43>
	return nsipc_listen(r, backlog);
  8039a5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8039a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ab:	89 d6                	mov    %edx,%esi
  8039ad:	89 c7                	mov    %eax,%edi
  8039af:	48 b8 e5 3c 80 00 00 	movabs $0x803ce5,%rax
  8039b6:	00 00 00 
  8039b9:	ff d0                	callq  *%rax
}
  8039bb:	c9                   	leaveq 
  8039bc:	c3                   	retq   

00000000008039bd <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8039bd:	55                   	push   %rbp
  8039be:	48 89 e5             	mov    %rsp,%rbp
  8039c1:	48 83 ec 20          	sub    $0x20,%rsp
  8039c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039c9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039cd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8039d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039d5:	89 c2                	mov    %eax,%edx
  8039d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039db:	8b 40 0c             	mov    0xc(%rax),%eax
  8039de:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8039e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8039e7:	89 c7                	mov    %eax,%edi
  8039e9:	48 b8 25 3d 80 00 00 	movabs $0x803d25,%rax
  8039f0:	00 00 00 
  8039f3:	ff d0                	callq  *%rax
}
  8039f5:	c9                   	leaveq 
  8039f6:	c3                   	retq   

00000000008039f7 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8039f7:	55                   	push   %rbp
  8039f8:	48 89 e5             	mov    %rsp,%rbp
  8039fb:	48 83 ec 20          	sub    $0x20,%rsp
  8039ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a03:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a07:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803a0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a0f:	89 c2                	mov    %eax,%edx
  803a11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a15:	8b 40 0c             	mov    0xc(%rax),%eax
  803a18:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803a1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  803a21:	89 c7                	mov    %eax,%edi
  803a23:	48 b8 f1 3d 80 00 00 	movabs $0x803df1,%rax
  803a2a:	00 00 00 
  803a2d:	ff d0                	callq  *%rax
}
  803a2f:	c9                   	leaveq 
  803a30:	c3                   	retq   

0000000000803a31 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803a31:	55                   	push   %rbp
  803a32:	48 89 e5             	mov    %rsp,%rbp
  803a35:	48 83 ec 10          	sub    $0x10,%rsp
  803a39:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a3d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803a41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a45:	48 be c7 50 80 00 00 	movabs $0x8050c7,%rsi
  803a4c:	00 00 00 
  803a4f:	48 89 c7             	mov    %rax,%rdi
  803a52:	48 b8 62 10 80 00 00 	movabs $0x801062,%rax
  803a59:	00 00 00 
  803a5c:	ff d0                	callq  *%rax
	return 0;
  803a5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a63:	c9                   	leaveq 
  803a64:	c3                   	retq   

0000000000803a65 <socket>:

int
socket(int domain, int type, int protocol)
{
  803a65:	55                   	push   %rbp
  803a66:	48 89 e5             	mov    %rsp,%rbp
  803a69:	48 83 ec 20          	sub    $0x20,%rsp
  803a6d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a70:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a73:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803a76:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803a79:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803a7c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a7f:	89 ce                	mov    %ecx,%esi
  803a81:	89 c7                	mov    %eax,%edi
  803a83:	48 b8 a9 3e 80 00 00 	movabs $0x803ea9,%rax
  803a8a:	00 00 00 
  803a8d:	ff d0                	callq  *%rax
  803a8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a96:	79 05                	jns    803a9d <socket+0x38>
		return r;
  803a98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a9b:	eb 11                	jmp    803aae <socket+0x49>
	return alloc_sockfd(r);
  803a9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa0:	89 c7                	mov    %eax,%edi
  803aa2:	48 b8 47 37 80 00 00 	movabs $0x803747,%rax
  803aa9:	00 00 00 
  803aac:	ff d0                	callq  *%rax
}
  803aae:	c9                   	leaveq 
  803aaf:	c3                   	retq   

0000000000803ab0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803ab0:	55                   	push   %rbp
  803ab1:	48 89 e5             	mov    %rsp,%rbp
  803ab4:	48 83 ec 10          	sub    $0x10,%rsp
  803ab8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803abb:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803ac2:	00 00 00 
  803ac5:	8b 00                	mov    (%rax),%eax
  803ac7:	85 c0                	test   %eax,%eax
  803ac9:	75 1d                	jne    803ae8 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803acb:	bf 02 00 00 00       	mov    $0x2,%edi
  803ad0:	48 b8 53 26 80 00 00 	movabs $0x802653,%rax
  803ad7:	00 00 00 
  803ada:	ff d0                	callq  *%rax
  803adc:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  803ae3:	00 00 00 
  803ae6:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803ae8:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803aef:	00 00 00 
  803af2:	8b 00                	mov    (%rax),%eax
  803af4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803af7:	b9 07 00 00 00       	mov    $0x7,%ecx
  803afc:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803b03:	00 00 00 
  803b06:	89 c7                	mov    %eax,%edi
  803b08:	48 b8 47 24 80 00 00 	movabs $0x802447,%rax
  803b0f:	00 00 00 
  803b12:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803b14:	ba 00 00 00 00       	mov    $0x0,%edx
  803b19:	be 00 00 00 00       	mov    $0x0,%esi
  803b1e:	bf 00 00 00 00       	mov    $0x0,%edi
  803b23:	48 b8 86 23 80 00 00 	movabs $0x802386,%rax
  803b2a:	00 00 00 
  803b2d:	ff d0                	callq  *%rax
}
  803b2f:	c9                   	leaveq 
  803b30:	c3                   	retq   

0000000000803b31 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803b31:	55                   	push   %rbp
  803b32:	48 89 e5             	mov    %rsp,%rbp
  803b35:	48 83 ec 30          	sub    $0x30,%rsp
  803b39:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b3c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b40:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803b44:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b4b:	00 00 00 
  803b4e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b51:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803b53:	bf 01 00 00 00       	mov    $0x1,%edi
  803b58:	48 b8 b0 3a 80 00 00 	movabs $0x803ab0,%rax
  803b5f:	00 00 00 
  803b62:	ff d0                	callq  *%rax
  803b64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b6b:	78 3e                	js     803bab <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803b6d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b74:	00 00 00 
  803b77:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803b7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b7f:	8b 40 10             	mov    0x10(%rax),%eax
  803b82:	89 c2                	mov    %eax,%edx
  803b84:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803b88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b8c:	48 89 ce             	mov    %rcx,%rsi
  803b8f:	48 89 c7             	mov    %rax,%rdi
  803b92:	48 b8 86 13 80 00 00 	movabs $0x801386,%rax
  803b99:	00 00 00 
  803b9c:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803b9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba2:	8b 50 10             	mov    0x10(%rax),%edx
  803ba5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ba9:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803bab:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803bae:	c9                   	leaveq 
  803baf:	c3                   	retq   

0000000000803bb0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803bb0:	55                   	push   %rbp
  803bb1:	48 89 e5             	mov    %rsp,%rbp
  803bb4:	48 83 ec 10          	sub    $0x10,%rsp
  803bb8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bbb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803bbf:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803bc2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bc9:	00 00 00 
  803bcc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bcf:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803bd1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bd8:	48 89 c6             	mov    %rax,%rsi
  803bdb:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803be2:	00 00 00 
  803be5:	48 b8 86 13 80 00 00 	movabs $0x801386,%rax
  803bec:	00 00 00 
  803bef:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803bf1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bf8:	00 00 00 
  803bfb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bfe:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803c01:	bf 02 00 00 00       	mov    $0x2,%edi
  803c06:	48 b8 b0 3a 80 00 00 	movabs $0x803ab0,%rax
  803c0d:	00 00 00 
  803c10:	ff d0                	callq  *%rax
}
  803c12:	c9                   	leaveq 
  803c13:	c3                   	retq   

0000000000803c14 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803c14:	55                   	push   %rbp
  803c15:	48 89 e5             	mov    %rsp,%rbp
  803c18:	48 83 ec 10          	sub    $0x10,%rsp
  803c1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c1f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803c22:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c29:	00 00 00 
  803c2c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c2f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803c31:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c38:	00 00 00 
  803c3b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c3e:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803c41:	bf 03 00 00 00       	mov    $0x3,%edi
  803c46:	48 b8 b0 3a 80 00 00 	movabs $0x803ab0,%rax
  803c4d:	00 00 00 
  803c50:	ff d0                	callq  *%rax
}
  803c52:	c9                   	leaveq 
  803c53:	c3                   	retq   

0000000000803c54 <nsipc_close>:

int
nsipc_close(int s)
{
  803c54:	55                   	push   %rbp
  803c55:	48 89 e5             	mov    %rsp,%rbp
  803c58:	48 83 ec 10          	sub    $0x10,%rsp
  803c5c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803c5f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c66:	00 00 00 
  803c69:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c6c:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803c6e:	bf 04 00 00 00       	mov    $0x4,%edi
  803c73:	48 b8 b0 3a 80 00 00 	movabs $0x803ab0,%rax
  803c7a:	00 00 00 
  803c7d:	ff d0                	callq  *%rax
}
  803c7f:	c9                   	leaveq 
  803c80:	c3                   	retq   

0000000000803c81 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803c81:	55                   	push   %rbp
  803c82:	48 89 e5             	mov    %rsp,%rbp
  803c85:	48 83 ec 10          	sub    $0x10,%rsp
  803c89:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c8c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c90:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803c93:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c9a:	00 00 00 
  803c9d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ca0:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803ca2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ca5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ca9:	48 89 c6             	mov    %rax,%rsi
  803cac:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803cb3:	00 00 00 
  803cb6:	48 b8 86 13 80 00 00 	movabs $0x801386,%rax
  803cbd:	00 00 00 
  803cc0:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803cc2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cc9:	00 00 00 
  803ccc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ccf:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803cd2:	bf 05 00 00 00       	mov    $0x5,%edi
  803cd7:	48 b8 b0 3a 80 00 00 	movabs $0x803ab0,%rax
  803cde:	00 00 00 
  803ce1:	ff d0                	callq  *%rax
}
  803ce3:	c9                   	leaveq 
  803ce4:	c3                   	retq   

0000000000803ce5 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803ce5:	55                   	push   %rbp
  803ce6:	48 89 e5             	mov    %rsp,%rbp
  803ce9:	48 83 ec 10          	sub    $0x10,%rsp
  803ced:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803cf0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803cf3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cfa:	00 00 00 
  803cfd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d00:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803d02:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d09:	00 00 00 
  803d0c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d0f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803d12:	bf 06 00 00 00       	mov    $0x6,%edi
  803d17:	48 b8 b0 3a 80 00 00 	movabs $0x803ab0,%rax
  803d1e:	00 00 00 
  803d21:	ff d0                	callq  *%rax
}
  803d23:	c9                   	leaveq 
  803d24:	c3                   	retq   

0000000000803d25 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803d25:	55                   	push   %rbp
  803d26:	48 89 e5             	mov    %rsp,%rbp
  803d29:	48 83 ec 30          	sub    $0x30,%rsp
  803d2d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d30:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d34:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803d37:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803d3a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d41:	00 00 00 
  803d44:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803d47:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803d49:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d50:	00 00 00 
  803d53:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d56:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803d59:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d60:	00 00 00 
  803d63:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803d66:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803d69:	bf 07 00 00 00       	mov    $0x7,%edi
  803d6e:	48 b8 b0 3a 80 00 00 	movabs $0x803ab0,%rax
  803d75:	00 00 00 
  803d78:	ff d0                	callq  *%rax
  803d7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d81:	78 69                	js     803dec <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803d83:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803d8a:	7f 08                	jg     803d94 <nsipc_recv+0x6f>
  803d8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d8f:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803d92:	7e 35                	jle    803dc9 <nsipc_recv+0xa4>
  803d94:	48 b9 ce 50 80 00 00 	movabs $0x8050ce,%rcx
  803d9b:	00 00 00 
  803d9e:	48 ba e3 50 80 00 00 	movabs $0x8050e3,%rdx
  803da5:	00 00 00 
  803da8:	be 62 00 00 00       	mov    $0x62,%esi
  803dad:	48 bf f8 50 80 00 00 	movabs $0x8050f8,%rdi
  803db4:	00 00 00 
  803db7:	b8 00 00 00 00       	mov    $0x0,%eax
  803dbc:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  803dc3:	00 00 00 
  803dc6:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803dc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dcc:	48 63 d0             	movslq %eax,%rdx
  803dcf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dd3:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803dda:	00 00 00 
  803ddd:	48 89 c7             	mov    %rax,%rdi
  803de0:	48 b8 86 13 80 00 00 	movabs $0x801386,%rax
  803de7:	00 00 00 
  803dea:	ff d0                	callq  *%rax
	}

	return r;
  803dec:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803def:	c9                   	leaveq 
  803df0:	c3                   	retq   

0000000000803df1 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803df1:	55                   	push   %rbp
  803df2:	48 89 e5             	mov    %rsp,%rbp
  803df5:	48 83 ec 20          	sub    $0x20,%rsp
  803df9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803dfc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e00:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803e03:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803e06:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e0d:	00 00 00 
  803e10:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e13:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803e15:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803e1c:	7e 35                	jle    803e53 <nsipc_send+0x62>
  803e1e:	48 b9 04 51 80 00 00 	movabs $0x805104,%rcx
  803e25:	00 00 00 
  803e28:	48 ba e3 50 80 00 00 	movabs $0x8050e3,%rdx
  803e2f:	00 00 00 
  803e32:	be 6d 00 00 00       	mov    $0x6d,%esi
  803e37:	48 bf f8 50 80 00 00 	movabs $0x8050f8,%rdi
  803e3e:	00 00 00 
  803e41:	b8 00 00 00 00       	mov    $0x0,%eax
  803e46:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  803e4d:	00 00 00 
  803e50:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803e53:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e56:	48 63 d0             	movslq %eax,%rdx
  803e59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e5d:	48 89 c6             	mov    %rax,%rsi
  803e60:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803e67:	00 00 00 
  803e6a:	48 b8 86 13 80 00 00 	movabs $0x801386,%rax
  803e71:	00 00 00 
  803e74:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803e76:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e7d:	00 00 00 
  803e80:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e83:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803e86:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e8d:	00 00 00 
  803e90:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e93:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803e96:	bf 08 00 00 00       	mov    $0x8,%edi
  803e9b:	48 b8 b0 3a 80 00 00 	movabs $0x803ab0,%rax
  803ea2:	00 00 00 
  803ea5:	ff d0                	callq  *%rax
}
  803ea7:	c9                   	leaveq 
  803ea8:	c3                   	retq   

0000000000803ea9 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803ea9:	55                   	push   %rbp
  803eaa:	48 89 e5             	mov    %rsp,%rbp
  803ead:	48 83 ec 10          	sub    $0x10,%rsp
  803eb1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803eb4:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803eb7:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803eba:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ec1:	00 00 00 
  803ec4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ec7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803ec9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ed0:	00 00 00 
  803ed3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ed6:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803ed9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ee0:	00 00 00 
  803ee3:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803ee6:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803ee9:	bf 09 00 00 00       	mov    $0x9,%edi
  803eee:	48 b8 b0 3a 80 00 00 	movabs $0x803ab0,%rax
  803ef5:	00 00 00 
  803ef8:	ff d0                	callq  *%rax
}
  803efa:	c9                   	leaveq 
  803efb:	c3                   	retq   

0000000000803efc <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803efc:	55                   	push   %rbp
  803efd:	48 89 e5             	mov    %rsp,%rbp
  803f00:	53                   	push   %rbx
  803f01:	48 83 ec 38          	sub    $0x38,%rsp
  803f05:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803f09:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803f0d:	48 89 c7             	mov    %rax,%rdi
  803f10:	48 b8 13 27 80 00 00 	movabs $0x802713,%rax
  803f17:	00 00 00 
  803f1a:	ff d0                	callq  *%rax
  803f1c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f1f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f23:	0f 88 bf 01 00 00    	js     8040e8 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f2d:	ba 07 04 00 00       	mov    $0x407,%edx
  803f32:	48 89 c6             	mov    %rax,%rsi
  803f35:	bf 00 00 00 00       	mov    $0x0,%edi
  803f3a:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  803f41:	00 00 00 
  803f44:	ff d0                	callq  *%rax
  803f46:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f49:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f4d:	0f 88 95 01 00 00    	js     8040e8 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803f53:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803f57:	48 89 c7             	mov    %rax,%rdi
  803f5a:	48 b8 13 27 80 00 00 	movabs $0x802713,%rax
  803f61:	00 00 00 
  803f64:	ff d0                	callq  *%rax
  803f66:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f69:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f6d:	0f 88 5d 01 00 00    	js     8040d0 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f73:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f77:	ba 07 04 00 00       	mov    $0x407,%edx
  803f7c:	48 89 c6             	mov    %rax,%rsi
  803f7f:	bf 00 00 00 00       	mov    $0x0,%edi
  803f84:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  803f8b:	00 00 00 
  803f8e:	ff d0                	callq  *%rax
  803f90:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f93:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f97:	0f 88 33 01 00 00    	js     8040d0 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803f9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fa1:	48 89 c7             	mov    %rax,%rdi
  803fa4:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  803fab:	00 00 00 
  803fae:	ff d0                	callq  *%rax
  803fb0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803fb4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fb8:	ba 07 04 00 00       	mov    $0x407,%edx
  803fbd:	48 89 c6             	mov    %rax,%rsi
  803fc0:	bf 00 00 00 00       	mov    $0x0,%edi
  803fc5:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  803fcc:	00 00 00 
  803fcf:	ff d0                	callq  *%rax
  803fd1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fd4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fd8:	79 05                	jns    803fdf <pipe+0xe3>
		goto err2;
  803fda:	e9 d9 00 00 00       	jmpq   8040b8 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803fdf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fe3:	48 89 c7             	mov    %rax,%rdi
  803fe6:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  803fed:	00 00 00 
  803ff0:	ff d0                	callq  *%rax
  803ff2:	48 89 c2             	mov    %rax,%rdx
  803ff5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ff9:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803fff:	48 89 d1             	mov    %rdx,%rcx
  804002:	ba 00 00 00 00       	mov    $0x0,%edx
  804007:	48 89 c6             	mov    %rax,%rsi
  80400a:	bf 00 00 00 00       	mov    $0x0,%edi
  80400f:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  804016:	00 00 00 
  804019:	ff d0                	callq  *%rax
  80401b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80401e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804022:	79 1b                	jns    80403f <pipe+0x143>
		goto err3;
  804024:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804025:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804029:	48 89 c6             	mov    %rax,%rsi
  80402c:	bf 00 00 00 00       	mov    $0x0,%edi
  804031:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  804038:	00 00 00 
  80403b:	ff d0                	callq  *%rax
  80403d:	eb 79                	jmp    8040b8 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80403f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804043:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80404a:	00 00 00 
  80404d:	8b 12                	mov    (%rdx),%edx
  80404f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804051:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804055:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80405c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804060:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804067:	00 00 00 
  80406a:	8b 12                	mov    (%rdx),%edx
  80406c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80406e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804072:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804079:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80407d:	48 89 c7             	mov    %rax,%rdi
  804080:	48 b8 c5 26 80 00 00 	movabs $0x8026c5,%rax
  804087:	00 00 00 
  80408a:	ff d0                	callq  *%rax
  80408c:	89 c2                	mov    %eax,%edx
  80408e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804092:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804094:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804098:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80409c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040a0:	48 89 c7             	mov    %rax,%rdi
  8040a3:	48 b8 c5 26 80 00 00 	movabs $0x8026c5,%rax
  8040aa:	00 00 00 
  8040ad:	ff d0                	callq  *%rax
  8040af:	89 03                	mov    %eax,(%rbx)
	return 0;
  8040b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8040b6:	eb 33                	jmp    8040eb <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8040b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040bc:	48 89 c6             	mov    %rax,%rsi
  8040bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8040c4:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  8040cb:	00 00 00 
  8040ce:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8040d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040d4:	48 89 c6             	mov    %rax,%rsi
  8040d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8040dc:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  8040e3:	00 00 00 
  8040e6:	ff d0                	callq  *%rax
err:
	return r;
  8040e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8040eb:	48 83 c4 38          	add    $0x38,%rsp
  8040ef:	5b                   	pop    %rbx
  8040f0:	5d                   	pop    %rbp
  8040f1:	c3                   	retq   

00000000008040f2 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8040f2:	55                   	push   %rbp
  8040f3:	48 89 e5             	mov    %rsp,%rbp
  8040f6:	53                   	push   %rbx
  8040f7:	48 83 ec 28          	sub    $0x28,%rsp
  8040fb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8040ff:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804103:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80410a:	00 00 00 
  80410d:	48 8b 00             	mov    (%rax),%rax
  804110:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804116:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804119:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80411d:	48 89 c7             	mov    %rax,%rdi
  804120:	48 b8 a0 48 80 00 00 	movabs $0x8048a0,%rax
  804127:	00 00 00 
  80412a:	ff d0                	callq  *%rax
  80412c:	89 c3                	mov    %eax,%ebx
  80412e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804132:	48 89 c7             	mov    %rax,%rdi
  804135:	48 b8 a0 48 80 00 00 	movabs $0x8048a0,%rax
  80413c:	00 00 00 
  80413f:	ff d0                	callq  *%rax
  804141:	39 c3                	cmp    %eax,%ebx
  804143:	0f 94 c0             	sete   %al
  804146:	0f b6 c0             	movzbl %al,%eax
  804149:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80414c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804153:	00 00 00 
  804156:	48 8b 00             	mov    (%rax),%rax
  804159:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80415f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804162:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804165:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804168:	75 05                	jne    80416f <_pipeisclosed+0x7d>
			return ret;
  80416a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80416d:	eb 4f                	jmp    8041be <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80416f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804172:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804175:	74 42                	je     8041b9 <_pipeisclosed+0xc7>
  804177:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80417b:	75 3c                	jne    8041b9 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80417d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804184:	00 00 00 
  804187:	48 8b 00             	mov    (%rax),%rax
  80418a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804190:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804193:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804196:	89 c6                	mov    %eax,%esi
  804198:	48 bf 15 51 80 00 00 	movabs $0x805115,%rdi
  80419f:	00 00 00 
  8041a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8041a7:	49 b8 ad 04 80 00 00 	movabs $0x8004ad,%r8
  8041ae:	00 00 00 
  8041b1:	41 ff d0             	callq  *%r8
	}
  8041b4:	e9 4a ff ff ff       	jmpq   804103 <_pipeisclosed+0x11>
  8041b9:	e9 45 ff ff ff       	jmpq   804103 <_pipeisclosed+0x11>

}
  8041be:	48 83 c4 28          	add    $0x28,%rsp
  8041c2:	5b                   	pop    %rbx
  8041c3:	5d                   	pop    %rbp
  8041c4:	c3                   	retq   

00000000008041c5 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8041c5:	55                   	push   %rbp
  8041c6:	48 89 e5             	mov    %rsp,%rbp
  8041c9:	48 83 ec 30          	sub    $0x30,%rsp
  8041cd:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8041d0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8041d4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8041d7:	48 89 d6             	mov    %rdx,%rsi
  8041da:	89 c7                	mov    %eax,%edi
  8041dc:	48 b8 ab 27 80 00 00 	movabs $0x8027ab,%rax
  8041e3:	00 00 00 
  8041e6:	ff d0                	callq  *%rax
  8041e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041ef:	79 05                	jns    8041f6 <pipeisclosed+0x31>
		return r;
  8041f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041f4:	eb 31                	jmp    804227 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8041f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041fa:	48 89 c7             	mov    %rax,%rdi
  8041fd:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  804204:	00 00 00 
  804207:	ff d0                	callq  *%rax
  804209:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80420d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804211:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804215:	48 89 d6             	mov    %rdx,%rsi
  804218:	48 89 c7             	mov    %rax,%rdi
  80421b:	48 b8 f2 40 80 00 00 	movabs $0x8040f2,%rax
  804222:	00 00 00 
  804225:	ff d0                	callq  *%rax
}
  804227:	c9                   	leaveq 
  804228:	c3                   	retq   

0000000000804229 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804229:	55                   	push   %rbp
  80422a:	48 89 e5             	mov    %rsp,%rbp
  80422d:	48 83 ec 40          	sub    $0x40,%rsp
  804231:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804235:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804239:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80423d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804241:	48 89 c7             	mov    %rax,%rdi
  804244:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  80424b:	00 00 00 
  80424e:	ff d0                	callq  *%rax
  804250:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804254:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804258:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80425c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804263:	00 
  804264:	e9 92 00 00 00       	jmpq   8042fb <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804269:	eb 41                	jmp    8042ac <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80426b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804270:	74 09                	je     80427b <devpipe_read+0x52>
				return i;
  804272:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804276:	e9 92 00 00 00       	jmpq   80430d <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80427b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80427f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804283:	48 89 d6             	mov    %rdx,%rsi
  804286:	48 89 c7             	mov    %rax,%rdi
  804289:	48 b8 f2 40 80 00 00 	movabs $0x8040f2,%rax
  804290:	00 00 00 
  804293:	ff d0                	callq  *%rax
  804295:	85 c0                	test   %eax,%eax
  804297:	74 07                	je     8042a0 <devpipe_read+0x77>
				return 0;
  804299:	b8 00 00 00 00       	mov    $0x0,%eax
  80429e:	eb 6d                	jmp    80430d <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8042a0:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  8042a7:	00 00 00 
  8042aa:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8042ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042b0:	8b 10                	mov    (%rax),%edx
  8042b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042b6:	8b 40 04             	mov    0x4(%rax),%eax
  8042b9:	39 c2                	cmp    %eax,%edx
  8042bb:	74 ae                	je     80426b <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8042bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8042c5:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8042c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042cd:	8b 00                	mov    (%rax),%eax
  8042cf:	99                   	cltd   
  8042d0:	c1 ea 1b             	shr    $0x1b,%edx
  8042d3:	01 d0                	add    %edx,%eax
  8042d5:	83 e0 1f             	and    $0x1f,%eax
  8042d8:	29 d0                	sub    %edx,%eax
  8042da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042de:	48 98                	cltq   
  8042e0:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8042e5:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8042e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042eb:	8b 00                	mov    (%rax),%eax
  8042ed:	8d 50 01             	lea    0x1(%rax),%edx
  8042f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042f4:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8042f6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8042fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042ff:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804303:	0f 82 60 ff ff ff    	jb     804269 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804309:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80430d:	c9                   	leaveq 
  80430e:	c3                   	retq   

000000000080430f <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80430f:	55                   	push   %rbp
  804310:	48 89 e5             	mov    %rsp,%rbp
  804313:	48 83 ec 40          	sub    $0x40,%rsp
  804317:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80431b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80431f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804323:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804327:	48 89 c7             	mov    %rax,%rdi
  80432a:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  804331:	00 00 00 
  804334:	ff d0                	callq  *%rax
  804336:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80433a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80433e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804342:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804349:	00 
  80434a:	e9 8e 00 00 00       	jmpq   8043dd <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80434f:	eb 31                	jmp    804382 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804351:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804355:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804359:	48 89 d6             	mov    %rdx,%rsi
  80435c:	48 89 c7             	mov    %rax,%rdi
  80435f:	48 b8 f2 40 80 00 00 	movabs $0x8040f2,%rax
  804366:	00 00 00 
  804369:	ff d0                	callq  *%rax
  80436b:	85 c0                	test   %eax,%eax
  80436d:	74 07                	je     804376 <devpipe_write+0x67>
				return 0;
  80436f:	b8 00 00 00 00       	mov    $0x0,%eax
  804374:	eb 79                	jmp    8043ef <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804376:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  80437d:	00 00 00 
  804380:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804382:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804386:	8b 40 04             	mov    0x4(%rax),%eax
  804389:	48 63 d0             	movslq %eax,%rdx
  80438c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804390:	8b 00                	mov    (%rax),%eax
  804392:	48 98                	cltq   
  804394:	48 83 c0 20          	add    $0x20,%rax
  804398:	48 39 c2             	cmp    %rax,%rdx
  80439b:	73 b4                	jae    804351 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80439d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043a1:	8b 40 04             	mov    0x4(%rax),%eax
  8043a4:	99                   	cltd   
  8043a5:	c1 ea 1b             	shr    $0x1b,%edx
  8043a8:	01 d0                	add    %edx,%eax
  8043aa:	83 e0 1f             	and    $0x1f,%eax
  8043ad:	29 d0                	sub    %edx,%eax
  8043af:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8043b3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8043b7:	48 01 ca             	add    %rcx,%rdx
  8043ba:	0f b6 0a             	movzbl (%rdx),%ecx
  8043bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8043c1:	48 98                	cltq   
  8043c3:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8043c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043cb:	8b 40 04             	mov    0x4(%rax),%eax
  8043ce:	8d 50 01             	lea    0x1(%rax),%edx
  8043d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043d5:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8043d8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8043dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043e1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8043e5:	0f 82 64 ff ff ff    	jb     80434f <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8043eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8043ef:	c9                   	leaveq 
  8043f0:	c3                   	retq   

00000000008043f1 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8043f1:	55                   	push   %rbp
  8043f2:	48 89 e5             	mov    %rsp,%rbp
  8043f5:	48 83 ec 20          	sub    $0x20,%rsp
  8043f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804401:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804405:	48 89 c7             	mov    %rax,%rdi
  804408:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  80440f:	00 00 00 
  804412:	ff d0                	callq  *%rax
  804414:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804418:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80441c:	48 be 28 51 80 00 00 	movabs $0x805128,%rsi
  804423:	00 00 00 
  804426:	48 89 c7             	mov    %rax,%rdi
  804429:	48 b8 62 10 80 00 00 	movabs $0x801062,%rax
  804430:	00 00 00 
  804433:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804435:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804439:	8b 50 04             	mov    0x4(%rax),%edx
  80443c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804440:	8b 00                	mov    (%rax),%eax
  804442:	29 c2                	sub    %eax,%edx
  804444:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804448:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80444e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804452:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804459:	00 00 00 
	stat->st_dev = &devpipe;
  80445c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804460:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804467:	00 00 00 
  80446a:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804471:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804476:	c9                   	leaveq 
  804477:	c3                   	retq   

0000000000804478 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804478:	55                   	push   %rbp
  804479:	48 89 e5             	mov    %rsp,%rbp
  80447c:	48 83 ec 10          	sub    $0x10,%rsp
  804480:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  804484:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804488:	48 89 c6             	mov    %rax,%rsi
  80448b:	bf 00 00 00 00       	mov    $0x0,%edi
  804490:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  804497:	00 00 00 
  80449a:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  80449c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044a0:	48 89 c7             	mov    %rax,%rdi
  8044a3:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  8044aa:	00 00 00 
  8044ad:	ff d0                	callq  *%rax
  8044af:	48 89 c6             	mov    %rax,%rsi
  8044b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8044b7:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  8044be:	00 00 00 
  8044c1:	ff d0                	callq  *%rax
}
  8044c3:	c9                   	leaveq 
  8044c4:	c3                   	retq   

00000000008044c5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8044c5:	55                   	push   %rbp
  8044c6:	48 89 e5             	mov    %rsp,%rbp
  8044c9:	48 83 ec 20          	sub    $0x20,%rsp
  8044cd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8044d0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044d3:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8044d6:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8044da:	be 01 00 00 00       	mov    $0x1,%esi
  8044df:	48 89 c7             	mov    %rax,%rdi
  8044e2:	48 b8 49 18 80 00 00 	movabs $0x801849,%rax
  8044e9:	00 00 00 
  8044ec:	ff d0                	callq  *%rax
}
  8044ee:	c9                   	leaveq 
  8044ef:	c3                   	retq   

00000000008044f0 <getchar>:

int
getchar(void)
{
  8044f0:	55                   	push   %rbp
  8044f1:	48 89 e5             	mov    %rsp,%rbp
  8044f4:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8044f8:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8044fc:	ba 01 00 00 00       	mov    $0x1,%edx
  804501:	48 89 c6             	mov    %rax,%rsi
  804504:	bf 00 00 00 00       	mov    $0x0,%edi
  804509:	48 b8 dd 2b 80 00 00 	movabs $0x802bdd,%rax
  804510:	00 00 00 
  804513:	ff d0                	callq  *%rax
  804515:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804518:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80451c:	79 05                	jns    804523 <getchar+0x33>
		return r;
  80451e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804521:	eb 14                	jmp    804537 <getchar+0x47>
	if (r < 1)
  804523:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804527:	7f 07                	jg     804530 <getchar+0x40>
		return -E_EOF;
  804529:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80452e:	eb 07                	jmp    804537 <getchar+0x47>
	return c;
  804530:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804534:	0f b6 c0             	movzbl %al,%eax

}
  804537:	c9                   	leaveq 
  804538:	c3                   	retq   

0000000000804539 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804539:	55                   	push   %rbp
  80453a:	48 89 e5             	mov    %rsp,%rbp
  80453d:	48 83 ec 20          	sub    $0x20,%rsp
  804541:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804544:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804548:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80454b:	48 89 d6             	mov    %rdx,%rsi
  80454e:	89 c7                	mov    %eax,%edi
  804550:	48 b8 ab 27 80 00 00 	movabs $0x8027ab,%rax
  804557:	00 00 00 
  80455a:	ff d0                	callq  *%rax
  80455c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80455f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804563:	79 05                	jns    80456a <iscons+0x31>
		return r;
  804565:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804568:	eb 1a                	jmp    804584 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80456a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80456e:	8b 10                	mov    (%rax),%edx
  804570:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804577:	00 00 00 
  80457a:	8b 00                	mov    (%rax),%eax
  80457c:	39 c2                	cmp    %eax,%edx
  80457e:	0f 94 c0             	sete   %al
  804581:	0f b6 c0             	movzbl %al,%eax
}
  804584:	c9                   	leaveq 
  804585:	c3                   	retq   

0000000000804586 <opencons>:

int
opencons(void)
{
  804586:	55                   	push   %rbp
  804587:	48 89 e5             	mov    %rsp,%rbp
  80458a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80458e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804592:	48 89 c7             	mov    %rax,%rdi
  804595:	48 b8 13 27 80 00 00 	movabs $0x802713,%rax
  80459c:	00 00 00 
  80459f:	ff d0                	callq  *%rax
  8045a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045a8:	79 05                	jns    8045af <opencons+0x29>
		return r;
  8045aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045ad:	eb 5b                	jmp    80460a <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8045af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045b3:	ba 07 04 00 00       	mov    $0x407,%edx
  8045b8:	48 89 c6             	mov    %rax,%rsi
  8045bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8045c0:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  8045c7:	00 00 00 
  8045ca:	ff d0                	callq  *%rax
  8045cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045d3:	79 05                	jns    8045da <opencons+0x54>
		return r;
  8045d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045d8:	eb 30                	jmp    80460a <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8045da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045de:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8045e5:	00 00 00 
  8045e8:	8b 12                	mov    (%rdx),%edx
  8045ea:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8045ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045f0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8045f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045fb:	48 89 c7             	mov    %rax,%rdi
  8045fe:	48 b8 c5 26 80 00 00 	movabs $0x8026c5,%rax
  804605:	00 00 00 
  804608:	ff d0                	callq  *%rax
}
  80460a:	c9                   	leaveq 
  80460b:	c3                   	retq   

000000000080460c <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80460c:	55                   	push   %rbp
  80460d:	48 89 e5             	mov    %rsp,%rbp
  804610:	48 83 ec 30          	sub    $0x30,%rsp
  804614:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804618:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80461c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804620:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804625:	75 07                	jne    80462e <devcons_read+0x22>
		return 0;
  804627:	b8 00 00 00 00       	mov    $0x0,%eax
  80462c:	eb 4b                	jmp    804679 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80462e:	eb 0c                	jmp    80463c <devcons_read+0x30>
		sys_yield();
  804630:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  804637:	00 00 00 
  80463a:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80463c:	48 b8 93 18 80 00 00 	movabs $0x801893,%rax
  804643:	00 00 00 
  804646:	ff d0                	callq  *%rax
  804648:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80464b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80464f:	74 df                	je     804630 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804651:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804655:	79 05                	jns    80465c <devcons_read+0x50>
		return c;
  804657:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80465a:	eb 1d                	jmp    804679 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80465c:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804660:	75 07                	jne    804669 <devcons_read+0x5d>
		return 0;
  804662:	b8 00 00 00 00       	mov    $0x0,%eax
  804667:	eb 10                	jmp    804679 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804669:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80466c:	89 c2                	mov    %eax,%edx
  80466e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804672:	88 10                	mov    %dl,(%rax)
	return 1;
  804674:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804679:	c9                   	leaveq 
  80467a:	c3                   	retq   

000000000080467b <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80467b:	55                   	push   %rbp
  80467c:	48 89 e5             	mov    %rsp,%rbp
  80467f:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804686:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80468d:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804694:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80469b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8046a2:	eb 76                	jmp    80471a <devcons_write+0x9f>
		m = n - tot;
  8046a4:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8046ab:	89 c2                	mov    %eax,%edx
  8046ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046b0:	29 c2                	sub    %eax,%edx
  8046b2:	89 d0                	mov    %edx,%eax
  8046b4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8046b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8046ba:	83 f8 7f             	cmp    $0x7f,%eax
  8046bd:	76 07                	jbe    8046c6 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8046bf:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8046c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8046c9:	48 63 d0             	movslq %eax,%rdx
  8046cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046cf:	48 63 c8             	movslq %eax,%rcx
  8046d2:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8046d9:	48 01 c1             	add    %rax,%rcx
  8046dc:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8046e3:	48 89 ce             	mov    %rcx,%rsi
  8046e6:	48 89 c7             	mov    %rax,%rdi
  8046e9:	48 b8 86 13 80 00 00 	movabs $0x801386,%rax
  8046f0:	00 00 00 
  8046f3:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8046f5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8046f8:	48 63 d0             	movslq %eax,%rdx
  8046fb:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804702:	48 89 d6             	mov    %rdx,%rsi
  804705:	48 89 c7             	mov    %rax,%rdi
  804708:	48 b8 49 18 80 00 00 	movabs $0x801849,%rax
  80470f:	00 00 00 
  804712:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804714:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804717:	01 45 fc             	add    %eax,-0x4(%rbp)
  80471a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80471d:	48 98                	cltq   
  80471f:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804726:	0f 82 78 ff ff ff    	jb     8046a4 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80472c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80472f:	c9                   	leaveq 
  804730:	c3                   	retq   

0000000000804731 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804731:	55                   	push   %rbp
  804732:	48 89 e5             	mov    %rsp,%rbp
  804735:	48 83 ec 08          	sub    $0x8,%rsp
  804739:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80473d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804742:	c9                   	leaveq 
  804743:	c3                   	retq   

0000000000804744 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804744:	55                   	push   %rbp
  804745:	48 89 e5             	mov    %rsp,%rbp
  804748:	48 83 ec 10          	sub    $0x10,%rsp
  80474c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804750:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804754:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804758:	48 be 34 51 80 00 00 	movabs $0x805134,%rsi
  80475f:	00 00 00 
  804762:	48 89 c7             	mov    %rax,%rdi
  804765:	48 b8 62 10 80 00 00 	movabs $0x801062,%rax
  80476c:	00 00 00 
  80476f:	ff d0                	callq  *%rax
	return 0;
  804771:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804776:	c9                   	leaveq 
  804777:	c3                   	retq   

0000000000804778 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804778:	55                   	push   %rbp
  804779:	48 89 e5             	mov    %rsp,%rbp
  80477c:	48 83 ec 20          	sub    $0x20,%rsp
  804780:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804784:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80478b:	00 00 00 
  80478e:	48 8b 00             	mov    (%rax),%rax
  804791:	48 85 c0             	test   %rax,%rax
  804794:	75 6f                	jne    804805 <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  804796:	ba 07 00 00 00       	mov    $0x7,%edx
  80479b:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8047a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8047a5:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  8047ac:	00 00 00 
  8047af:	ff d0                	callq  *%rax
  8047b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047b8:	79 30                	jns    8047ea <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  8047ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047bd:	89 c1                	mov    %eax,%ecx
  8047bf:	48 ba 40 51 80 00 00 	movabs $0x805140,%rdx
  8047c6:	00 00 00 
  8047c9:	be 22 00 00 00       	mov    $0x22,%esi
  8047ce:	48 bf 5f 51 80 00 00 	movabs $0x80515f,%rdi
  8047d5:	00 00 00 
  8047d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8047dd:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  8047e4:	00 00 00 
  8047e7:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  8047ea:	48 be 18 48 80 00 00 	movabs $0x804818,%rsi
  8047f1:	00 00 00 
  8047f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8047f9:	48 b8 1b 1b 80 00 00 	movabs $0x801b1b,%rax
  804800:	00 00 00 
  804803:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804805:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80480c:	00 00 00 
  80480f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804813:	48 89 10             	mov    %rdx,(%rax)
}
  804816:	c9                   	leaveq 
  804817:	c3                   	retq   

0000000000804818 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804818:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80481b:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  804822:	00 00 00 
call *%rax
  804825:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  804827:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  80482e:	00 08 
    movq 152(%rsp), %rax
  804830:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  804837:	00 
    movq 136(%rsp), %rbx
  804838:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80483f:	00 
movq %rbx, (%rax)
  804840:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  804843:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  804847:	4c 8b 3c 24          	mov    (%rsp),%r15
  80484b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804850:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804855:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80485a:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80485f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804864:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804869:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80486e:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804873:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804878:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80487d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804882:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804887:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80488c:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804891:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  804895:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  804899:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  80489a:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  80489f:	c3                   	retq   

00000000008048a0 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  8048a0:	55                   	push   %rbp
  8048a1:	48 89 e5             	mov    %rsp,%rbp
  8048a4:	48 83 ec 18          	sub    $0x18,%rsp
  8048a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8048ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048b0:	48 c1 e8 15          	shr    $0x15,%rax
  8048b4:	48 89 c2             	mov    %rax,%rdx
  8048b7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8048be:	01 00 00 
  8048c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8048c5:	83 e0 01             	and    $0x1,%eax
  8048c8:	48 85 c0             	test   %rax,%rax
  8048cb:	75 07                	jne    8048d4 <pageref+0x34>
		return 0;
  8048cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8048d2:	eb 53                	jmp    804927 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8048d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048d8:	48 c1 e8 0c          	shr    $0xc,%rax
  8048dc:	48 89 c2             	mov    %rax,%rdx
  8048df:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8048e6:	01 00 00 
  8048e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8048ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8048f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048f5:	83 e0 01             	and    $0x1,%eax
  8048f8:	48 85 c0             	test   %rax,%rax
  8048fb:	75 07                	jne    804904 <pageref+0x64>
		return 0;
  8048fd:	b8 00 00 00 00       	mov    $0x0,%eax
  804902:	eb 23                	jmp    804927 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804904:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804908:	48 c1 e8 0c          	shr    $0xc,%rax
  80490c:	48 89 c2             	mov    %rax,%rdx
  80490f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804916:	00 00 00 
  804919:	48 c1 e2 04          	shl    $0x4,%rdx
  80491d:	48 01 d0             	add    %rdx,%rax
  804920:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804924:	0f b7 c0             	movzwl %ax,%eax
}
  804927:	c9                   	leaveq 
  804928:	c3                   	retq   
