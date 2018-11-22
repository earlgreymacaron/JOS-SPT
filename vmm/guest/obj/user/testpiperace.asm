
vmm/guest/obj/user/testpiperace:     file format elf64-x86-64


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
  80003c:	e8 44 03 00 00       	callq  800385 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 50          	sub    $0x50,%rsp
  80004b:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80004e:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  800052:	48 bf e0 4a 80 00 00 	movabs $0x804ae0,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 3c 41 80 00 00 	movabs $0x80413c,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba f9 4a 80 00 00 	movabs $0x804af9,%rdx
  800095:	00 00 00 
  800098:	be 0e 00 00 00       	mov    $0xe,%esi
  80009d:	48 bf 02 4b 80 00 00 	movabs $0x804b02,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	max = 200;
  8000b9:	c7 45 f4 c8 00 00 00 	movl   $0xc8,-0xc(%rbp)
	if ((r = fork()) < 0)
  8000c0:	48 b8 c8 22 80 00 00 	movabs $0x8022c8,%rax
  8000c7:	00 00 00 
  8000ca:	ff d0                	callq  *%rax
  8000cc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d3:	79 30                	jns    800105 <umain+0xc2>
		panic("fork: %e", r);
  8000d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d8:	89 c1                	mov    %eax,%ecx
  8000da:	48 ba 16 4b 80 00 00 	movabs $0x804b16,%rdx
  8000e1:	00 00 00 
  8000e4:	be 11 00 00 00       	mov    $0x11,%esi
  8000e9:	48 bf 02 4b 80 00 00 	movabs $0x804b02,%rdi
  8000f0:	00 00 00 
  8000f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f8:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  8000ff:	00 00 00 
  800102:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800105:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800109:	0f 85 89 00 00 00    	jne    800198 <umain+0x155>
		close(p[1]);
  80010f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800112:	89 c7                	mov    %eax,%edi
  800114:	48 b8 72 2b 80 00 00 	movabs $0x802b72,%rax
  80011b:	00 00 00 
  80011e:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  800120:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800127:	eb 4c                	jmp    800175 <umain+0x132>
			if(pipeisclosed(p[0])){
  800129:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80012c:	89 c7                	mov    %eax,%edi
  80012e:	48 b8 05 44 80 00 00 	movabs $0x804405,%rax
  800135:	00 00 00 
  800138:	ff d0                	callq  *%rax
  80013a:	85 c0                	test   %eax,%eax
  80013c:	74 27                	je     800165 <umain+0x122>
				cprintf("RACE: pipe appears closed\n");
  80013e:	48 bf 1f 4b 80 00 00 	movabs $0x804b1f,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  800154:	00 00 00 
  800157:	ff d2                	callq  *%rdx
				exit();
  800159:	48 b8 08 04 80 00 00 	movabs $0x800408,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
			}
			sys_yield();
  800165:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  80016c:	00 00 00 
  80016f:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  800171:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800175:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800178:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80017b:	7c ac                	jl     800129 <umain+0xe6>
				exit();
			}
			sys_yield();
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  80017d:	ba 00 00 00 00       	mov    $0x0,%edx
  800182:	be 00 00 00 00       	mov    $0x0,%esi
  800187:	bf 00 00 00 00       	mov    $0x0,%edi
  80018c:	48 b8 3d 25 80 00 00 	movabs $0x80253d,%rax
  800193:	00 00 00 
  800196:	ff d0                	callq  *%rax
	}
	pid = r;
  800198:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019b:	89 45 f0             	mov    %eax,-0x10(%rbp)
	cprintf("pid is %d\n", pid);
  80019e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001a1:	89 c6                	mov    %eax,%esi
  8001a3:	48 bf 3a 4b 80 00 00 	movabs $0x804b3a,%rdi
  8001aa:	00 00 00 
  8001ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b2:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  8001b9:	00 00 00 
  8001bc:	ff d2                	callq  *%rdx
	va = 0;
  8001be:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8001c5:	00 
	kid = &envs[ENVX(pid)];
  8001c6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001c9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ce:	48 98                	cltq   
  8001d0:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8001d7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001de:	00 00 00 
  8001e1:	48 01 d0             	add    %rdx,%rax
  8001e4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	cprintf("kid is %d\n", kid-envs);
  8001e8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001ec:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001f3:	00 00 00 
  8001f6:	48 29 c2             	sub    %rax,%rdx
  8001f9:	48 89 d0             	mov    %rdx,%rax
  8001fc:	48 c1 f8 03          	sar    $0x3,%rax
  800200:	48 89 c2             	mov    %rax,%rdx
  800203:	48 b8 a5 4f fa a4 4f 	movabs $0x4fa4fa4fa4fa4fa5,%rax
  80020a:	fa a4 4f 
  80020d:	48 0f af c2          	imul   %rdx,%rax
  800211:	48 89 c6             	mov    %rax,%rsi
  800214:	48 bf 45 4b 80 00 00 	movabs $0x804b45,%rdi
  80021b:	00 00 00 
  80021e:	b8 00 00 00 00       	mov    $0x0,%eax
  800223:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  80022a:	00 00 00 
  80022d:	ff d2                	callq  *%rdx
	dup(p[0], 10);
  80022f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800232:	be 0a 00 00 00       	mov    $0xa,%esi
  800237:	89 c7                	mov    %eax,%edi
  800239:	48 b8 eb 2b 80 00 00 	movabs $0x802beb,%rax
  800240:	00 00 00 
  800243:	ff d0                	callq  *%rax
	while (kid->env_status == ENV_RUNNABLE)
  800245:	eb 16                	jmp    80025d <umain+0x21a>
		dup(p[0], 10);
  800247:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80024a:	be 0a 00 00 00       	mov    $0xa,%esi
  80024f:	89 c7                	mov    %eax,%edi
  800251:	48 b8 eb 2b 80 00 00 	movabs $0x802beb,%rax
  800258:	00 00 00 
  80025b:	ff d0                	callq  *%rax
	cprintf("pid is %d\n", pid);
	va = 0;
	kid = &envs[ENVX(pid)];
	cprintf("kid is %d\n", kid-envs);
	dup(p[0], 10);
	while (kid->env_status == ENV_RUNNABLE)
  80025d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800261:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  800267:	83 f8 02             	cmp    $0x2,%eax
  80026a:	74 db                	je     800247 <umain+0x204>
		dup(p[0], 10);

	cprintf("child done with loop\n");
  80026c:	48 bf 50 4b 80 00 00 	movabs $0x804b50,%rdi
  800273:	00 00 00 
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  800282:	00 00 00 
  800285:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  800287:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80028a:	89 c7                	mov    %eax,%edi
  80028c:	48 b8 05 44 80 00 00 	movabs $0x804405,%rax
  800293:	00 00 00 
  800296:	ff d0                	callq  *%rax
  800298:	85 c0                	test   %eax,%eax
  80029a:	74 2a                	je     8002c6 <umain+0x283>
		panic("somehow the other end of p[0] got closed!");
  80029c:	48 ba 68 4b 80 00 00 	movabs $0x804b68,%rdx
  8002a3:	00 00 00 
  8002a6:	be 3b 00 00 00       	mov    $0x3b,%esi
  8002ab:	48 bf 02 4b 80 00 00 	movabs $0x804b02,%rdi
  8002b2:	00 00 00 
  8002b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ba:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  8002c1:	00 00 00 
  8002c4:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002c6:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002c9:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  8002cd:	48 89 d6             	mov    %rdx,%rsi
  8002d0:	89 c7                	mov    %eax,%edi
  8002d2:	48 b8 62 29 80 00 00 	movabs $0x802962,%rax
  8002d9:	00 00 00 
  8002dc:	ff d0                	callq  *%rax
  8002de:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002e1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002e5:	79 30                	jns    800317 <umain+0x2d4>
		panic("cannot look up p[0]: %e", r);
  8002e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002ea:	89 c1                	mov    %eax,%ecx
  8002ec:	48 ba 92 4b 80 00 00 	movabs $0x804b92,%rdx
  8002f3:	00 00 00 
  8002f6:	be 3d 00 00 00       	mov    $0x3d,%esi
  8002fb:	48 bf 02 4b 80 00 00 	movabs $0x804b02,%rdi
  800302:	00 00 00 
  800305:	b8 00 00 00 00       	mov    $0x0,%eax
  80030a:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  800311:	00 00 00 
  800314:	41 ff d0             	callq  *%r8
	va = fd2data(fd);
  800317:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80031b:	48 89 c7             	mov    %rax,%rdi
  80031e:	48 b8 9f 28 80 00 00 	movabs $0x80289f,%rax
  800325:	00 00 00 
  800328:	ff d0                	callq  *%rax
  80032a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (pageref(va) != 3+1)
  80032e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800332:	48 89 c7             	mov    %rax,%rdi
  800335:	48 b8 a7 38 80 00 00 	movabs $0x8038a7,%rax
  80033c:	00 00 00 
  80033f:	ff d0                	callq  *%rax
  800341:	83 f8 04             	cmp    $0x4,%eax
  800344:	74 1d                	je     800363 <umain+0x320>
		cprintf("\nchild detected race\n");
  800346:	48 bf aa 4b 80 00 00 	movabs $0x804baa,%rdi
  80034d:	00 00 00 
  800350:	b8 00 00 00 00       	mov    $0x0,%eax
  800355:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  80035c:	00 00 00 
  80035f:	ff d2                	callq  *%rdx
  800361:	eb 20                	jmp    800383 <umain+0x340>
	else
		cprintf("\nrace didn't happen\n", max);
  800363:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800366:	89 c6                	mov    %eax,%esi
  800368:	48 bf c0 4b 80 00 00 	movabs $0x804bc0,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  80037e:	00 00 00 
  800381:	ff d2                	callq  *%rdx
}
  800383:	c9                   	leaveq 
  800384:	c3                   	retq   

0000000000800385 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800385:	55                   	push   %rbp
  800386:	48 89 e5             	mov    %rsp,%rbp
  800389:	48 83 ec 10          	sub    $0x10,%rsp
  80038d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800390:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800394:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  80039b:	00 00 00 
  80039e:	ff d0                	callq  *%rax
  8003a0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003a5:	48 98                	cltq   
  8003a7:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8003ae:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8003b5:	00 00 00 
  8003b8:	48 01 c2             	add    %rax,%rdx
  8003bb:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8003c2:	00 00 00 
  8003c5:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003cc:	7e 14                	jle    8003e2 <libmain+0x5d>
		binaryname = argv[0];
  8003ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d2:	48 8b 10             	mov    (%rax),%rdx
  8003d5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8003dc:	00 00 00 
  8003df:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003e9:	48 89 d6             	mov    %rdx,%rsi
  8003ec:	89 c7                	mov    %eax,%edi
  8003ee:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003f5:	00 00 00 
  8003f8:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003fa:	48 b8 08 04 80 00 00 	movabs $0x800408,%rax
  800401:	00 00 00 
  800404:	ff d0                	callq  *%rax
}
  800406:	c9                   	leaveq 
  800407:	c3                   	retq   

0000000000800408 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800408:	55                   	push   %rbp
  800409:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  80040c:	48 b8 bd 2b 80 00 00 	movabs $0x802bbd,%rax
  800413:	00 00 00 
  800416:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800418:	bf 00 00 00 00       	mov    $0x0,%edi
  80041d:	48 b8 88 1a 80 00 00 	movabs $0x801a88,%rax
  800424:	00 00 00 
  800427:	ff d0                	callq  *%rax
}
  800429:	5d                   	pop    %rbp
  80042a:	c3                   	retq   

000000000080042b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80042b:	55                   	push   %rbp
  80042c:	48 89 e5             	mov    %rsp,%rbp
  80042f:	53                   	push   %rbx
  800430:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800437:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80043e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800444:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80044b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800452:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800459:	84 c0                	test   %al,%al
  80045b:	74 23                	je     800480 <_panic+0x55>
  80045d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800464:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800468:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80046c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800470:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800474:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800478:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80047c:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800480:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800487:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80048e:	00 00 00 
  800491:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800498:	00 00 00 
  80049b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80049f:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8004a6:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8004ad:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004b4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8004bb:	00 00 00 
  8004be:	48 8b 18             	mov    (%rax),%rbx
  8004c1:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  8004c8:	00 00 00 
  8004cb:	ff d0                	callq  *%rax
  8004cd:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004d3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004da:	41 89 c8             	mov    %ecx,%r8d
  8004dd:	48 89 d1             	mov    %rdx,%rcx
  8004e0:	48 89 da             	mov    %rbx,%rdx
  8004e3:	89 c6                	mov    %eax,%esi
  8004e5:	48 bf e0 4b 80 00 00 	movabs $0x804be0,%rdi
  8004ec:	00 00 00 
  8004ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f4:	49 b9 64 06 80 00 00 	movabs $0x800664,%r9
  8004fb:	00 00 00 
  8004fe:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800501:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800508:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80050f:	48 89 d6             	mov    %rdx,%rsi
  800512:	48 89 c7             	mov    %rax,%rdi
  800515:	48 b8 b8 05 80 00 00 	movabs $0x8005b8,%rax
  80051c:	00 00 00 
  80051f:	ff d0                	callq  *%rax
	cprintf("\n");
  800521:	48 bf 03 4c 80 00 00 	movabs $0x804c03,%rdi
  800528:	00 00 00 
  80052b:	b8 00 00 00 00       	mov    $0x0,%eax
  800530:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  800537:	00 00 00 
  80053a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80053c:	cc                   	int3   
  80053d:	eb fd                	jmp    80053c <_panic+0x111>

000000000080053f <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80053f:	55                   	push   %rbp
  800540:	48 89 e5             	mov    %rsp,%rbp
  800543:	48 83 ec 10          	sub    $0x10,%rsp
  800547:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80054a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80054e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800552:	8b 00                	mov    (%rax),%eax
  800554:	8d 48 01             	lea    0x1(%rax),%ecx
  800557:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80055b:	89 0a                	mov    %ecx,(%rdx)
  80055d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800560:	89 d1                	mov    %edx,%ecx
  800562:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800566:	48 98                	cltq   
  800568:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80056c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800570:	8b 00                	mov    (%rax),%eax
  800572:	3d ff 00 00 00       	cmp    $0xff,%eax
  800577:	75 2c                	jne    8005a5 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800579:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80057d:	8b 00                	mov    (%rax),%eax
  80057f:	48 98                	cltq   
  800581:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800585:	48 83 c2 08          	add    $0x8,%rdx
  800589:	48 89 c6             	mov    %rax,%rsi
  80058c:	48 89 d7             	mov    %rdx,%rdi
  80058f:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  800596:	00 00 00 
  800599:	ff d0                	callq  *%rax
        b->idx = 0;
  80059b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80059f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8005a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005a9:	8b 40 04             	mov    0x4(%rax),%eax
  8005ac:	8d 50 01             	lea    0x1(%rax),%edx
  8005af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005b3:	89 50 04             	mov    %edx,0x4(%rax)
}
  8005b6:	c9                   	leaveq 
  8005b7:	c3                   	retq   

00000000008005b8 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8005b8:	55                   	push   %rbp
  8005b9:	48 89 e5             	mov    %rsp,%rbp
  8005bc:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005c3:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005ca:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005d1:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005d8:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005df:	48 8b 0a             	mov    (%rdx),%rcx
  8005e2:	48 89 08             	mov    %rcx,(%rax)
  8005e5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005e9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005ed:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005f1:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005f5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005fc:	00 00 00 
    b.cnt = 0;
  8005ff:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800606:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800609:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800610:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800617:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80061e:	48 89 c6             	mov    %rax,%rsi
  800621:	48 bf 3f 05 80 00 00 	movabs $0x80053f,%rdi
  800628:	00 00 00 
  80062b:	48 b8 17 0a 80 00 00 	movabs $0x800a17,%rax
  800632:	00 00 00 
  800635:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800637:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80063d:	48 98                	cltq   
  80063f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800646:	48 83 c2 08          	add    $0x8,%rdx
  80064a:	48 89 c6             	mov    %rax,%rsi
  80064d:	48 89 d7             	mov    %rdx,%rdi
  800650:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  800657:	00 00 00 
  80065a:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80065c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800662:	c9                   	leaveq 
  800663:	c3                   	retq   

0000000000800664 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800664:	55                   	push   %rbp
  800665:	48 89 e5             	mov    %rsp,%rbp
  800668:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80066f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800676:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80067d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800684:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80068b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800692:	84 c0                	test   %al,%al
  800694:	74 20                	je     8006b6 <cprintf+0x52>
  800696:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80069a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80069e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8006a2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8006a6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8006aa:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8006ae:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8006b2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8006b6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8006bd:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006c4:	00 00 00 
  8006c7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006ce:	00 00 00 
  8006d1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006d5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006dc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006e3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006ea:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006f1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006f8:	48 8b 0a             	mov    (%rdx),%rcx
  8006fb:	48 89 08             	mov    %rcx,(%rax)
  8006fe:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800702:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800706:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80070a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80070e:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800715:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80071c:	48 89 d6             	mov    %rdx,%rsi
  80071f:	48 89 c7             	mov    %rax,%rdi
  800722:	48 b8 b8 05 80 00 00 	movabs $0x8005b8,%rax
  800729:	00 00 00 
  80072c:	ff d0                	callq  *%rax
  80072e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800734:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80073a:	c9                   	leaveq 
  80073b:	c3                   	retq   

000000000080073c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80073c:	55                   	push   %rbp
  80073d:	48 89 e5             	mov    %rsp,%rbp
  800740:	53                   	push   %rbx
  800741:	48 83 ec 38          	sub    $0x38,%rsp
  800745:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800749:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80074d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800751:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800754:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800758:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80075c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80075f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800763:	77 3b                	ja     8007a0 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800765:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800768:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80076c:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80076f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800773:	ba 00 00 00 00       	mov    $0x0,%edx
  800778:	48 f7 f3             	div    %rbx
  80077b:	48 89 c2             	mov    %rax,%rdx
  80077e:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800781:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800784:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800788:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078c:	41 89 f9             	mov    %edi,%r9d
  80078f:	48 89 c7             	mov    %rax,%rdi
  800792:	48 b8 3c 07 80 00 00 	movabs $0x80073c,%rax
  800799:	00 00 00 
  80079c:	ff d0                	callq  *%rax
  80079e:	eb 1e                	jmp    8007be <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007a0:	eb 12                	jmp    8007b4 <printnum+0x78>
			putch(padc, putdat);
  8007a2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007a6:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8007a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ad:	48 89 ce             	mov    %rcx,%rsi
  8007b0:	89 d7                	mov    %edx,%edi
  8007b2:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007b4:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8007b8:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8007bc:	7f e4                	jg     8007a2 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007be:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8007c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ca:	48 f7 f1             	div    %rcx
  8007cd:	48 89 d0             	mov    %rdx,%rax
  8007d0:	48 ba 10 4e 80 00 00 	movabs $0x804e10,%rdx
  8007d7:	00 00 00 
  8007da:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007de:	0f be d0             	movsbl %al,%edx
  8007e1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e9:	48 89 ce             	mov    %rcx,%rsi
  8007ec:	89 d7                	mov    %edx,%edi
  8007ee:	ff d0                	callq  *%rax
}
  8007f0:	48 83 c4 38          	add    $0x38,%rsp
  8007f4:	5b                   	pop    %rbx
  8007f5:	5d                   	pop    %rbp
  8007f6:	c3                   	retq   

00000000008007f7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007f7:	55                   	push   %rbp
  8007f8:	48 89 e5             	mov    %rsp,%rbp
  8007fb:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800803:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800806:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80080a:	7e 52                	jle    80085e <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80080c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800810:	8b 00                	mov    (%rax),%eax
  800812:	83 f8 30             	cmp    $0x30,%eax
  800815:	73 24                	jae    80083b <getuint+0x44>
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
  800839:	eb 17                	jmp    800852 <getuint+0x5b>
  80083b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800843:	48 89 d0             	mov    %rdx,%rax
  800846:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80084a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800852:	48 8b 00             	mov    (%rax),%rax
  800855:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800859:	e9 a3 00 00 00       	jmpq   800901 <getuint+0x10a>
	else if (lflag)
  80085e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800862:	74 4f                	je     8008b3 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800864:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800868:	8b 00                	mov    (%rax),%eax
  80086a:	83 f8 30             	cmp    $0x30,%eax
  80086d:	73 24                	jae    800893 <getuint+0x9c>
  80086f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800873:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800877:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087b:	8b 00                	mov    (%rax),%eax
  80087d:	89 c0                	mov    %eax,%eax
  80087f:	48 01 d0             	add    %rdx,%rax
  800882:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800886:	8b 12                	mov    (%rdx),%edx
  800888:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80088b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088f:	89 0a                	mov    %ecx,(%rdx)
  800891:	eb 17                	jmp    8008aa <getuint+0xb3>
  800893:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800897:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80089b:	48 89 d0             	mov    %rdx,%rax
  80089e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008aa:	48 8b 00             	mov    (%rax),%rax
  8008ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008b1:	eb 4e                	jmp    800901 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8008b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b7:	8b 00                	mov    (%rax),%eax
  8008b9:	83 f8 30             	cmp    $0x30,%eax
  8008bc:	73 24                	jae    8008e2 <getuint+0xeb>
  8008be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ca:	8b 00                	mov    (%rax),%eax
  8008cc:	89 c0                	mov    %eax,%eax
  8008ce:	48 01 d0             	add    %rdx,%rax
  8008d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d5:	8b 12                	mov    (%rdx),%edx
  8008d7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008de:	89 0a                	mov    %ecx,(%rdx)
  8008e0:	eb 17                	jmp    8008f9 <getuint+0x102>
  8008e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008ea:	48 89 d0             	mov    %rdx,%rax
  8008ed:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008f9:	8b 00                	mov    (%rax),%eax
  8008fb:	89 c0                	mov    %eax,%eax
  8008fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800901:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800905:	c9                   	leaveq 
  800906:	c3                   	retq   

0000000000800907 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800907:	55                   	push   %rbp
  800908:	48 89 e5             	mov    %rsp,%rbp
  80090b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80090f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800913:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800916:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80091a:	7e 52                	jle    80096e <getint+0x67>
		x=va_arg(*ap, long long);
  80091c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800920:	8b 00                	mov    (%rax),%eax
  800922:	83 f8 30             	cmp    $0x30,%eax
  800925:	73 24                	jae    80094b <getint+0x44>
  800927:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80092f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800933:	8b 00                	mov    (%rax),%eax
  800935:	89 c0                	mov    %eax,%eax
  800937:	48 01 d0             	add    %rdx,%rax
  80093a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093e:	8b 12                	mov    (%rdx),%edx
  800940:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800943:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800947:	89 0a                	mov    %ecx,(%rdx)
  800949:	eb 17                	jmp    800962 <getint+0x5b>
  80094b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800953:	48 89 d0             	mov    %rdx,%rax
  800956:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80095a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800962:	48 8b 00             	mov    (%rax),%rax
  800965:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800969:	e9 a3 00 00 00       	jmpq   800a11 <getint+0x10a>
	else if (lflag)
  80096e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800972:	74 4f                	je     8009c3 <getint+0xbc>
		x=va_arg(*ap, long);
  800974:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800978:	8b 00                	mov    (%rax),%eax
  80097a:	83 f8 30             	cmp    $0x30,%eax
  80097d:	73 24                	jae    8009a3 <getint+0x9c>
  80097f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800983:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800987:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098b:	8b 00                	mov    (%rax),%eax
  80098d:	89 c0                	mov    %eax,%eax
  80098f:	48 01 d0             	add    %rdx,%rax
  800992:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800996:	8b 12                	mov    (%rdx),%edx
  800998:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80099b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099f:	89 0a                	mov    %ecx,(%rdx)
  8009a1:	eb 17                	jmp    8009ba <getint+0xb3>
  8009a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009ab:	48 89 d0             	mov    %rdx,%rax
  8009ae:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ba:	48 8b 00             	mov    (%rax),%rax
  8009bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009c1:	eb 4e                	jmp    800a11 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c7:	8b 00                	mov    (%rax),%eax
  8009c9:	83 f8 30             	cmp    $0x30,%eax
  8009cc:	73 24                	jae    8009f2 <getint+0xeb>
  8009ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009da:	8b 00                	mov    (%rax),%eax
  8009dc:	89 c0                	mov    %eax,%eax
  8009de:	48 01 d0             	add    %rdx,%rax
  8009e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e5:	8b 12                	mov    (%rdx),%edx
  8009e7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ee:	89 0a                	mov    %ecx,(%rdx)
  8009f0:	eb 17                	jmp    800a09 <getint+0x102>
  8009f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009fa:	48 89 d0             	mov    %rdx,%rax
  8009fd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a01:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a05:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a09:	8b 00                	mov    (%rax),%eax
  800a0b:	48 98                	cltq   
  800a0d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a15:	c9                   	leaveq 
  800a16:	c3                   	retq   

0000000000800a17 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a17:	55                   	push   %rbp
  800a18:	48 89 e5             	mov    %rsp,%rbp
  800a1b:	41 54                	push   %r12
  800a1d:	53                   	push   %rbx
  800a1e:	48 83 ec 60          	sub    $0x60,%rsp
  800a22:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a26:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a2a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a2e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a32:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a36:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a3a:	48 8b 0a             	mov    (%rdx),%rcx
  800a3d:	48 89 08             	mov    %rcx,(%rax)
  800a40:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a44:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a48:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a4c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a50:	eb 17                	jmp    800a69 <vprintfmt+0x52>
			if (ch == '\0')
  800a52:	85 db                	test   %ebx,%ebx
  800a54:	0f 84 cc 04 00 00    	je     800f26 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800a5a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a5e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a62:	48 89 d6             	mov    %rdx,%rsi
  800a65:	89 df                	mov    %ebx,%edi
  800a67:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a69:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a6d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a71:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a75:	0f b6 00             	movzbl (%rax),%eax
  800a78:	0f b6 d8             	movzbl %al,%ebx
  800a7b:	83 fb 25             	cmp    $0x25,%ebx
  800a7e:	75 d2                	jne    800a52 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a80:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a84:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a8b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a92:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a99:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800aa0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800aa4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800aa8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800aac:	0f b6 00             	movzbl (%rax),%eax
  800aaf:	0f b6 d8             	movzbl %al,%ebx
  800ab2:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800ab5:	83 f8 55             	cmp    $0x55,%eax
  800ab8:	0f 87 34 04 00 00    	ja     800ef2 <vprintfmt+0x4db>
  800abe:	89 c0                	mov    %eax,%eax
  800ac0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ac7:	00 
  800ac8:	48 b8 38 4e 80 00 00 	movabs $0x804e38,%rax
  800acf:	00 00 00 
  800ad2:	48 01 d0             	add    %rdx,%rax
  800ad5:	48 8b 00             	mov    (%rax),%rax
  800ad8:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ada:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ade:	eb c0                	jmp    800aa0 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ae0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800ae4:	eb ba                	jmp    800aa0 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ae6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800aed:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800af0:	89 d0                	mov    %edx,%eax
  800af2:	c1 e0 02             	shl    $0x2,%eax
  800af5:	01 d0                	add    %edx,%eax
  800af7:	01 c0                	add    %eax,%eax
  800af9:	01 d8                	add    %ebx,%eax
  800afb:	83 e8 30             	sub    $0x30,%eax
  800afe:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b01:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b05:	0f b6 00             	movzbl (%rax),%eax
  800b08:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b0b:	83 fb 2f             	cmp    $0x2f,%ebx
  800b0e:	7e 0c                	jle    800b1c <vprintfmt+0x105>
  800b10:	83 fb 39             	cmp    $0x39,%ebx
  800b13:	7f 07                	jg     800b1c <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b15:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b1a:	eb d1                	jmp    800aed <vprintfmt+0xd6>
			goto process_precision;
  800b1c:	eb 58                	jmp    800b76 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800b1e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b21:	83 f8 30             	cmp    $0x30,%eax
  800b24:	73 17                	jae    800b3d <vprintfmt+0x126>
  800b26:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b2a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b2d:	89 c0                	mov    %eax,%eax
  800b2f:	48 01 d0             	add    %rdx,%rax
  800b32:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b35:	83 c2 08             	add    $0x8,%edx
  800b38:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b3b:	eb 0f                	jmp    800b4c <vprintfmt+0x135>
  800b3d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b41:	48 89 d0             	mov    %rdx,%rax
  800b44:	48 83 c2 08          	add    $0x8,%rdx
  800b48:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b4c:	8b 00                	mov    (%rax),%eax
  800b4e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b51:	eb 23                	jmp    800b76 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b53:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b57:	79 0c                	jns    800b65 <vprintfmt+0x14e>
				width = 0;
  800b59:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b60:	e9 3b ff ff ff       	jmpq   800aa0 <vprintfmt+0x89>
  800b65:	e9 36 ff ff ff       	jmpq   800aa0 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b6a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b71:	e9 2a ff ff ff       	jmpq   800aa0 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b76:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b7a:	79 12                	jns    800b8e <vprintfmt+0x177>
				width = precision, precision = -1;
  800b7c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b7f:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b82:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b89:	e9 12 ff ff ff       	jmpq   800aa0 <vprintfmt+0x89>
  800b8e:	e9 0d ff ff ff       	jmpq   800aa0 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b93:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b97:	e9 04 ff ff ff       	jmpq   800aa0 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b9c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b9f:	83 f8 30             	cmp    $0x30,%eax
  800ba2:	73 17                	jae    800bbb <vprintfmt+0x1a4>
  800ba4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ba8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bab:	89 c0                	mov    %eax,%eax
  800bad:	48 01 d0             	add    %rdx,%rax
  800bb0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bb3:	83 c2 08             	add    $0x8,%edx
  800bb6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bb9:	eb 0f                	jmp    800bca <vprintfmt+0x1b3>
  800bbb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bbf:	48 89 d0             	mov    %rdx,%rax
  800bc2:	48 83 c2 08          	add    $0x8,%rdx
  800bc6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bca:	8b 10                	mov    (%rax),%edx
  800bcc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bd0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd4:	48 89 ce             	mov    %rcx,%rsi
  800bd7:	89 d7                	mov    %edx,%edi
  800bd9:	ff d0                	callq  *%rax
			break;
  800bdb:	e9 40 03 00 00       	jmpq   800f20 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800be0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be3:	83 f8 30             	cmp    $0x30,%eax
  800be6:	73 17                	jae    800bff <vprintfmt+0x1e8>
  800be8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bef:	89 c0                	mov    %eax,%eax
  800bf1:	48 01 d0             	add    %rdx,%rax
  800bf4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf7:	83 c2 08             	add    $0x8,%edx
  800bfa:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bfd:	eb 0f                	jmp    800c0e <vprintfmt+0x1f7>
  800bff:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c03:	48 89 d0             	mov    %rdx,%rax
  800c06:	48 83 c2 08          	add    $0x8,%rdx
  800c0a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c0e:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c10:	85 db                	test   %ebx,%ebx
  800c12:	79 02                	jns    800c16 <vprintfmt+0x1ff>
				err = -err;
  800c14:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c16:	83 fb 15             	cmp    $0x15,%ebx
  800c19:	7f 16                	jg     800c31 <vprintfmt+0x21a>
  800c1b:	48 b8 60 4d 80 00 00 	movabs $0x804d60,%rax
  800c22:	00 00 00 
  800c25:	48 63 d3             	movslq %ebx,%rdx
  800c28:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c2c:	4d 85 e4             	test   %r12,%r12
  800c2f:	75 2e                	jne    800c5f <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800c31:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c35:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c39:	89 d9                	mov    %ebx,%ecx
  800c3b:	48 ba 21 4e 80 00 00 	movabs $0x804e21,%rdx
  800c42:	00 00 00 
  800c45:	48 89 c7             	mov    %rax,%rdi
  800c48:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4d:	49 b8 2f 0f 80 00 00 	movabs $0x800f2f,%r8
  800c54:	00 00 00 
  800c57:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c5a:	e9 c1 02 00 00       	jmpq   800f20 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c5f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c63:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c67:	4c 89 e1             	mov    %r12,%rcx
  800c6a:	48 ba 2a 4e 80 00 00 	movabs $0x804e2a,%rdx
  800c71:	00 00 00 
  800c74:	48 89 c7             	mov    %rax,%rdi
  800c77:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7c:	49 b8 2f 0f 80 00 00 	movabs $0x800f2f,%r8
  800c83:	00 00 00 
  800c86:	41 ff d0             	callq  *%r8
			break;
  800c89:	e9 92 02 00 00       	jmpq   800f20 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c8e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c91:	83 f8 30             	cmp    $0x30,%eax
  800c94:	73 17                	jae    800cad <vprintfmt+0x296>
  800c96:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c9a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9d:	89 c0                	mov    %eax,%eax
  800c9f:	48 01 d0             	add    %rdx,%rax
  800ca2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ca5:	83 c2 08             	add    $0x8,%edx
  800ca8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cab:	eb 0f                	jmp    800cbc <vprintfmt+0x2a5>
  800cad:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cb1:	48 89 d0             	mov    %rdx,%rax
  800cb4:	48 83 c2 08          	add    $0x8,%rdx
  800cb8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cbc:	4c 8b 20             	mov    (%rax),%r12
  800cbf:	4d 85 e4             	test   %r12,%r12
  800cc2:	75 0a                	jne    800cce <vprintfmt+0x2b7>
				p = "(null)";
  800cc4:	49 bc 2d 4e 80 00 00 	movabs $0x804e2d,%r12
  800ccb:	00 00 00 
			if (width > 0 && padc != '-')
  800cce:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cd2:	7e 3f                	jle    800d13 <vprintfmt+0x2fc>
  800cd4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cd8:	74 39                	je     800d13 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cda:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cdd:	48 98                	cltq   
  800cdf:	48 89 c6             	mov    %rax,%rsi
  800ce2:	4c 89 e7             	mov    %r12,%rdi
  800ce5:	48 b8 db 11 80 00 00 	movabs $0x8011db,%rax
  800cec:	00 00 00 
  800cef:	ff d0                	callq  *%rax
  800cf1:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cf4:	eb 17                	jmp    800d0d <vprintfmt+0x2f6>
					putch(padc, putdat);
  800cf6:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cfa:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cfe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d02:	48 89 ce             	mov    %rcx,%rsi
  800d05:	89 d7                	mov    %edx,%edi
  800d07:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d09:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d0d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d11:	7f e3                	jg     800cf6 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d13:	eb 37                	jmp    800d4c <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800d15:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d19:	74 1e                	je     800d39 <vprintfmt+0x322>
  800d1b:	83 fb 1f             	cmp    $0x1f,%ebx
  800d1e:	7e 05                	jle    800d25 <vprintfmt+0x30e>
  800d20:	83 fb 7e             	cmp    $0x7e,%ebx
  800d23:	7e 14                	jle    800d39 <vprintfmt+0x322>
					putch('?', putdat);
  800d25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2d:	48 89 d6             	mov    %rdx,%rsi
  800d30:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d35:	ff d0                	callq  *%rax
  800d37:	eb 0f                	jmp    800d48 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800d39:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d41:	48 89 d6             	mov    %rdx,%rsi
  800d44:	89 df                	mov    %ebx,%edi
  800d46:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d48:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d4c:	4c 89 e0             	mov    %r12,%rax
  800d4f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d53:	0f b6 00             	movzbl (%rax),%eax
  800d56:	0f be d8             	movsbl %al,%ebx
  800d59:	85 db                	test   %ebx,%ebx
  800d5b:	74 10                	je     800d6d <vprintfmt+0x356>
  800d5d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d61:	78 b2                	js     800d15 <vprintfmt+0x2fe>
  800d63:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d67:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d6b:	79 a8                	jns    800d15 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d6d:	eb 16                	jmp    800d85 <vprintfmt+0x36e>
				putch(' ', putdat);
  800d6f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d73:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d77:	48 89 d6             	mov    %rdx,%rsi
  800d7a:	bf 20 00 00 00       	mov    $0x20,%edi
  800d7f:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d81:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d85:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d89:	7f e4                	jg     800d6f <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d8b:	e9 90 01 00 00       	jmpq   800f20 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d90:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d94:	be 03 00 00 00       	mov    $0x3,%esi
  800d99:	48 89 c7             	mov    %rax,%rdi
  800d9c:	48 b8 07 09 80 00 00 	movabs $0x800907,%rax
  800da3:	00 00 00 
  800da6:	ff d0                	callq  *%rax
  800da8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800dac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800db0:	48 85 c0             	test   %rax,%rax
  800db3:	79 1d                	jns    800dd2 <vprintfmt+0x3bb>
				putch('-', putdat);
  800db5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800db9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dbd:	48 89 d6             	mov    %rdx,%rsi
  800dc0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800dc5:	ff d0                	callq  *%rax
				num = -(long long) num;
  800dc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dcb:	48 f7 d8             	neg    %rax
  800dce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800dd2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dd9:	e9 d5 00 00 00       	jmpq   800eb3 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800dde:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800de2:	be 03 00 00 00       	mov    $0x3,%esi
  800de7:	48 89 c7             	mov    %rax,%rdi
  800dea:	48 b8 f7 07 80 00 00 	movabs $0x8007f7,%rax
  800df1:	00 00 00 
  800df4:	ff d0                	callq  *%rax
  800df6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800dfa:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e01:	e9 ad 00 00 00       	jmpq   800eb3 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800e06:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e0a:	be 03 00 00 00       	mov    $0x3,%esi
  800e0f:	48 89 c7             	mov    %rax,%rdi
  800e12:	48 b8 f7 07 80 00 00 	movabs $0x8007f7,%rax
  800e19:	00 00 00 
  800e1c:	ff d0                	callq  *%rax
  800e1e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800e22:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e29:	e9 85 00 00 00       	jmpq   800eb3 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800e2e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e36:	48 89 d6             	mov    %rdx,%rsi
  800e39:	bf 30 00 00 00       	mov    $0x30,%edi
  800e3e:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e40:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e44:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e48:	48 89 d6             	mov    %rdx,%rsi
  800e4b:	bf 78 00 00 00       	mov    $0x78,%edi
  800e50:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e52:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e55:	83 f8 30             	cmp    $0x30,%eax
  800e58:	73 17                	jae    800e71 <vprintfmt+0x45a>
  800e5a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e5e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e61:	89 c0                	mov    %eax,%eax
  800e63:	48 01 d0             	add    %rdx,%rax
  800e66:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e69:	83 c2 08             	add    $0x8,%edx
  800e6c:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e6f:	eb 0f                	jmp    800e80 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800e71:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e75:	48 89 d0             	mov    %rdx,%rax
  800e78:	48 83 c2 08          	add    $0x8,%rdx
  800e7c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e80:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e83:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e87:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e8e:	eb 23                	jmp    800eb3 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e90:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e94:	be 03 00 00 00       	mov    $0x3,%esi
  800e99:	48 89 c7             	mov    %rax,%rdi
  800e9c:	48 b8 f7 07 80 00 00 	movabs $0x8007f7,%rax
  800ea3:	00 00 00 
  800ea6:	ff d0                	callq  *%rax
  800ea8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800eac:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800eb3:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800eb8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ebb:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ebe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ec2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ec6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eca:	45 89 c1             	mov    %r8d,%r9d
  800ecd:	41 89 f8             	mov    %edi,%r8d
  800ed0:	48 89 c7             	mov    %rax,%rdi
  800ed3:	48 b8 3c 07 80 00 00 	movabs $0x80073c,%rax
  800eda:	00 00 00 
  800edd:	ff d0                	callq  *%rax
			break;
  800edf:	eb 3f                	jmp    800f20 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ee1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee9:	48 89 d6             	mov    %rdx,%rsi
  800eec:	89 df                	mov    %ebx,%edi
  800eee:	ff d0                	callq  *%rax
			break;
  800ef0:	eb 2e                	jmp    800f20 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ef2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800efa:	48 89 d6             	mov    %rdx,%rsi
  800efd:	bf 25 00 00 00       	mov    $0x25,%edi
  800f02:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f04:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f09:	eb 05                	jmp    800f10 <vprintfmt+0x4f9>
  800f0b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f10:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f14:	48 83 e8 01          	sub    $0x1,%rax
  800f18:	0f b6 00             	movzbl (%rax),%eax
  800f1b:	3c 25                	cmp    $0x25,%al
  800f1d:	75 ec                	jne    800f0b <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800f1f:	90                   	nop
		}
	}
  800f20:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f21:	e9 43 fb ff ff       	jmpq   800a69 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f26:	48 83 c4 60          	add    $0x60,%rsp
  800f2a:	5b                   	pop    %rbx
  800f2b:	41 5c                	pop    %r12
  800f2d:	5d                   	pop    %rbp
  800f2e:	c3                   	retq   

0000000000800f2f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f2f:	55                   	push   %rbp
  800f30:	48 89 e5             	mov    %rsp,%rbp
  800f33:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f3a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f41:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f48:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f4f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f56:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f5d:	84 c0                	test   %al,%al
  800f5f:	74 20                	je     800f81 <printfmt+0x52>
  800f61:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f65:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f69:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f6d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f71:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f75:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f79:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f7d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f81:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f88:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f8f:	00 00 00 
  800f92:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f99:	00 00 00 
  800f9c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fa0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800fa7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fae:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800fb5:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fbc:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fc3:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fca:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fd1:	48 89 c7             	mov    %rax,%rdi
  800fd4:	48 b8 17 0a 80 00 00 	movabs $0x800a17,%rax
  800fdb:	00 00 00 
  800fde:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fe0:	c9                   	leaveq 
  800fe1:	c3                   	retq   

0000000000800fe2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fe2:	55                   	push   %rbp
  800fe3:	48 89 e5             	mov    %rsp,%rbp
  800fe6:	48 83 ec 10          	sub    $0x10,%rsp
  800fea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ff1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff5:	8b 40 10             	mov    0x10(%rax),%eax
  800ff8:	8d 50 01             	lea    0x1(%rax),%edx
  800ffb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fff:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801002:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801006:	48 8b 10             	mov    (%rax),%rdx
  801009:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80100d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801011:	48 39 c2             	cmp    %rax,%rdx
  801014:	73 17                	jae    80102d <sprintputch+0x4b>
		*b->buf++ = ch;
  801016:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80101a:	48 8b 00             	mov    (%rax),%rax
  80101d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801021:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801025:	48 89 0a             	mov    %rcx,(%rdx)
  801028:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80102b:	88 10                	mov    %dl,(%rax)
}
  80102d:	c9                   	leaveq 
  80102e:	c3                   	retq   

000000000080102f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80102f:	55                   	push   %rbp
  801030:	48 89 e5             	mov    %rsp,%rbp
  801033:	48 83 ec 50          	sub    $0x50,%rsp
  801037:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80103b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80103e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801042:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801046:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80104a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80104e:	48 8b 0a             	mov    (%rdx),%rcx
  801051:	48 89 08             	mov    %rcx,(%rax)
  801054:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801058:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80105c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801060:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801064:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801068:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80106c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80106f:	48 98                	cltq   
  801071:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801075:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801079:	48 01 d0             	add    %rdx,%rax
  80107c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801080:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801087:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80108c:	74 06                	je     801094 <vsnprintf+0x65>
  80108e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801092:	7f 07                	jg     80109b <vsnprintf+0x6c>
		return -E_INVAL;
  801094:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801099:	eb 2f                	jmp    8010ca <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80109b:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80109f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8010a3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010a7:	48 89 c6             	mov    %rax,%rsi
  8010aa:	48 bf e2 0f 80 00 00 	movabs $0x800fe2,%rdi
  8010b1:	00 00 00 
  8010b4:	48 b8 17 0a 80 00 00 	movabs $0x800a17,%rax
  8010bb:	00 00 00 
  8010be:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010c4:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010c7:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010ca:	c9                   	leaveq 
  8010cb:	c3                   	retq   

00000000008010cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010cc:	55                   	push   %rbp
  8010cd:	48 89 e5             	mov    %rsp,%rbp
  8010d0:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010d7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010de:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010e4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010eb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010f2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010f9:	84 c0                	test   %al,%al
  8010fb:	74 20                	je     80111d <snprintf+0x51>
  8010fd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801101:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801105:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801109:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80110d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801111:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801115:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801119:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80111d:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801124:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80112b:	00 00 00 
  80112e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801135:	00 00 00 
  801138:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80113c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801143:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80114a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801151:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801158:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80115f:	48 8b 0a             	mov    (%rdx),%rcx
  801162:	48 89 08             	mov    %rcx,(%rax)
  801165:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801169:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80116d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801171:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801175:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80117c:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801183:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801189:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801190:	48 89 c7             	mov    %rax,%rdi
  801193:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  80119a:	00 00 00 
  80119d:	ff d0                	callq  *%rax
  80119f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8011a5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011ab:	c9                   	leaveq 
  8011ac:	c3                   	retq   

00000000008011ad <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011ad:	55                   	push   %rbp
  8011ae:	48 89 e5             	mov    %rsp,%rbp
  8011b1:	48 83 ec 18          	sub    $0x18,%rsp
  8011b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011c0:	eb 09                	jmp    8011cb <strlen+0x1e>
		n++;
  8011c2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011c6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011cf:	0f b6 00             	movzbl (%rax),%eax
  8011d2:	84 c0                	test   %al,%al
  8011d4:	75 ec                	jne    8011c2 <strlen+0x15>
		n++;
	return n;
  8011d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011d9:	c9                   	leaveq 
  8011da:	c3                   	retq   

00000000008011db <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011db:	55                   	push   %rbp
  8011dc:	48 89 e5             	mov    %rsp,%rbp
  8011df:	48 83 ec 20          	sub    $0x20,%rsp
  8011e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011f2:	eb 0e                	jmp    801202 <strnlen+0x27>
		n++;
  8011f4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011f8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011fd:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801202:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801207:	74 0b                	je     801214 <strnlen+0x39>
  801209:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120d:	0f b6 00             	movzbl (%rax),%eax
  801210:	84 c0                	test   %al,%al
  801212:	75 e0                	jne    8011f4 <strnlen+0x19>
		n++;
	return n;
  801214:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801217:	c9                   	leaveq 
  801218:	c3                   	retq   

0000000000801219 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801219:	55                   	push   %rbp
  80121a:	48 89 e5             	mov    %rsp,%rbp
  80121d:	48 83 ec 20          	sub    $0x20,%rsp
  801221:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801225:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801229:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801231:	90                   	nop
  801232:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801236:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80123a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80123e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801242:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801246:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80124a:	0f b6 12             	movzbl (%rdx),%edx
  80124d:	88 10                	mov    %dl,(%rax)
  80124f:	0f b6 00             	movzbl (%rax),%eax
  801252:	84 c0                	test   %al,%al
  801254:	75 dc                	jne    801232 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801256:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80125a:	c9                   	leaveq 
  80125b:	c3                   	retq   

000000000080125c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80125c:	55                   	push   %rbp
  80125d:	48 89 e5             	mov    %rsp,%rbp
  801260:	48 83 ec 20          	sub    $0x20,%rsp
  801264:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801268:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80126c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801270:	48 89 c7             	mov    %rax,%rdi
  801273:	48 b8 ad 11 80 00 00 	movabs $0x8011ad,%rax
  80127a:	00 00 00 
  80127d:	ff d0                	callq  *%rax
  80127f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801282:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801285:	48 63 d0             	movslq %eax,%rdx
  801288:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128c:	48 01 c2             	add    %rax,%rdx
  80128f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801293:	48 89 c6             	mov    %rax,%rsi
  801296:	48 89 d7             	mov    %rdx,%rdi
  801299:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  8012a0:	00 00 00 
  8012a3:	ff d0                	callq  *%rax
	return dst;
  8012a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012a9:	c9                   	leaveq 
  8012aa:	c3                   	retq   

00000000008012ab <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012ab:	55                   	push   %rbp
  8012ac:	48 89 e5             	mov    %rsp,%rbp
  8012af:	48 83 ec 28          	sub    $0x28,%rsp
  8012b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012c7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012ce:	00 
  8012cf:	eb 2a                	jmp    8012fb <strncpy+0x50>
		*dst++ = *src;
  8012d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012d9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012dd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012e1:	0f b6 12             	movzbl (%rdx),%edx
  8012e4:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012ea:	0f b6 00             	movzbl (%rax),%eax
  8012ed:	84 c0                	test   %al,%al
  8012ef:	74 05                	je     8012f6 <strncpy+0x4b>
			src++;
  8012f1:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012f6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ff:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801303:	72 cc                	jb     8012d1 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801305:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801309:	c9                   	leaveq 
  80130a:	c3                   	retq   

000000000080130b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80130b:	55                   	push   %rbp
  80130c:	48 89 e5             	mov    %rsp,%rbp
  80130f:	48 83 ec 28          	sub    $0x28,%rsp
  801313:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801317:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80131b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80131f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801323:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801327:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80132c:	74 3d                	je     80136b <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80132e:	eb 1d                	jmp    80134d <strlcpy+0x42>
			*dst++ = *src++;
  801330:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801334:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801338:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80133c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801340:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801344:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801348:	0f b6 12             	movzbl (%rdx),%edx
  80134b:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80134d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801352:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801357:	74 0b                	je     801364 <strlcpy+0x59>
  801359:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80135d:	0f b6 00             	movzbl (%rax),%eax
  801360:	84 c0                	test   %al,%al
  801362:	75 cc                	jne    801330 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801364:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801368:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80136b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80136f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801373:	48 29 c2             	sub    %rax,%rdx
  801376:	48 89 d0             	mov    %rdx,%rax
}
  801379:	c9                   	leaveq 
  80137a:	c3                   	retq   

000000000080137b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80137b:	55                   	push   %rbp
  80137c:	48 89 e5             	mov    %rsp,%rbp
  80137f:	48 83 ec 10          	sub    $0x10,%rsp
  801383:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801387:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80138b:	eb 0a                	jmp    801397 <strcmp+0x1c>
		p++, q++;
  80138d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801392:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801397:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139b:	0f b6 00             	movzbl (%rax),%eax
  80139e:	84 c0                	test   %al,%al
  8013a0:	74 12                	je     8013b4 <strcmp+0x39>
  8013a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a6:	0f b6 10             	movzbl (%rax),%edx
  8013a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ad:	0f b6 00             	movzbl (%rax),%eax
  8013b0:	38 c2                	cmp    %al,%dl
  8013b2:	74 d9                	je     80138d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b8:	0f b6 00             	movzbl (%rax),%eax
  8013bb:	0f b6 d0             	movzbl %al,%edx
  8013be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c2:	0f b6 00             	movzbl (%rax),%eax
  8013c5:	0f b6 c0             	movzbl %al,%eax
  8013c8:	29 c2                	sub    %eax,%edx
  8013ca:	89 d0                	mov    %edx,%eax
}
  8013cc:	c9                   	leaveq 
  8013cd:	c3                   	retq   

00000000008013ce <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013ce:	55                   	push   %rbp
  8013cf:	48 89 e5             	mov    %rsp,%rbp
  8013d2:	48 83 ec 18          	sub    $0x18,%rsp
  8013d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013de:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013e2:	eb 0f                	jmp    8013f3 <strncmp+0x25>
		n--, p++, q++;
  8013e4:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013e9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013ee:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013f3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013f8:	74 1d                	je     801417 <strncmp+0x49>
  8013fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fe:	0f b6 00             	movzbl (%rax),%eax
  801401:	84 c0                	test   %al,%al
  801403:	74 12                	je     801417 <strncmp+0x49>
  801405:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801409:	0f b6 10             	movzbl (%rax),%edx
  80140c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801410:	0f b6 00             	movzbl (%rax),%eax
  801413:	38 c2                	cmp    %al,%dl
  801415:	74 cd                	je     8013e4 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801417:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80141c:	75 07                	jne    801425 <strncmp+0x57>
		return 0;
  80141e:	b8 00 00 00 00       	mov    $0x0,%eax
  801423:	eb 18                	jmp    80143d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801425:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801429:	0f b6 00             	movzbl (%rax),%eax
  80142c:	0f b6 d0             	movzbl %al,%edx
  80142f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801433:	0f b6 00             	movzbl (%rax),%eax
  801436:	0f b6 c0             	movzbl %al,%eax
  801439:	29 c2                	sub    %eax,%edx
  80143b:	89 d0                	mov    %edx,%eax
}
  80143d:	c9                   	leaveq 
  80143e:	c3                   	retq   

000000000080143f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80143f:	55                   	push   %rbp
  801440:	48 89 e5             	mov    %rsp,%rbp
  801443:	48 83 ec 0c          	sub    $0xc,%rsp
  801447:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80144b:	89 f0                	mov    %esi,%eax
  80144d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801450:	eb 17                	jmp    801469 <strchr+0x2a>
		if (*s == c)
  801452:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801456:	0f b6 00             	movzbl (%rax),%eax
  801459:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80145c:	75 06                	jne    801464 <strchr+0x25>
			return (char *) s;
  80145e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801462:	eb 15                	jmp    801479 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801464:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801469:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146d:	0f b6 00             	movzbl (%rax),%eax
  801470:	84 c0                	test   %al,%al
  801472:	75 de                	jne    801452 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801474:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801479:	c9                   	leaveq 
  80147a:	c3                   	retq   

000000000080147b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80147b:	55                   	push   %rbp
  80147c:	48 89 e5             	mov    %rsp,%rbp
  80147f:	48 83 ec 0c          	sub    $0xc,%rsp
  801483:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801487:	89 f0                	mov    %esi,%eax
  801489:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80148c:	eb 13                	jmp    8014a1 <strfind+0x26>
		if (*s == c)
  80148e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801492:	0f b6 00             	movzbl (%rax),%eax
  801495:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801498:	75 02                	jne    80149c <strfind+0x21>
			break;
  80149a:	eb 10                	jmp    8014ac <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80149c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a5:	0f b6 00             	movzbl (%rax),%eax
  8014a8:	84 c0                	test   %al,%al
  8014aa:	75 e2                	jne    80148e <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8014ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014b0:	c9                   	leaveq 
  8014b1:	c3                   	retq   

00000000008014b2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014b2:	55                   	push   %rbp
  8014b3:	48 89 e5             	mov    %rsp,%rbp
  8014b6:	48 83 ec 18          	sub    $0x18,%rsp
  8014ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014be:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014c1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014c5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014ca:	75 06                	jne    8014d2 <memset+0x20>
		return v;
  8014cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d0:	eb 69                	jmp    80153b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d6:	83 e0 03             	and    $0x3,%eax
  8014d9:	48 85 c0             	test   %rax,%rax
  8014dc:	75 48                	jne    801526 <memset+0x74>
  8014de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e2:	83 e0 03             	and    $0x3,%eax
  8014e5:	48 85 c0             	test   %rax,%rax
  8014e8:	75 3c                	jne    801526 <memset+0x74>
		c &= 0xFF;
  8014ea:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014f4:	c1 e0 18             	shl    $0x18,%eax
  8014f7:	89 c2                	mov    %eax,%edx
  8014f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014fc:	c1 e0 10             	shl    $0x10,%eax
  8014ff:	09 c2                	or     %eax,%edx
  801501:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801504:	c1 e0 08             	shl    $0x8,%eax
  801507:	09 d0                	or     %edx,%eax
  801509:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80150c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801510:	48 c1 e8 02          	shr    $0x2,%rax
  801514:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801517:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80151b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80151e:	48 89 d7             	mov    %rdx,%rdi
  801521:	fc                   	cld    
  801522:	f3 ab                	rep stos %eax,%es:(%rdi)
  801524:	eb 11                	jmp    801537 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801526:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80152a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80152d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801531:	48 89 d7             	mov    %rdx,%rdi
  801534:	fc                   	cld    
  801535:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801537:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80153b:	c9                   	leaveq 
  80153c:	c3                   	retq   

000000000080153d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80153d:	55                   	push   %rbp
  80153e:	48 89 e5             	mov    %rsp,%rbp
  801541:	48 83 ec 28          	sub    $0x28,%rsp
  801545:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801549:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80154d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801551:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801555:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801559:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80155d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801561:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801565:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801569:	0f 83 88 00 00 00    	jae    8015f7 <memmove+0xba>
  80156f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801573:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801577:	48 01 d0             	add    %rdx,%rax
  80157a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80157e:	76 77                	jbe    8015f7 <memmove+0xba>
		s += n;
  801580:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801584:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801588:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801590:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801594:	83 e0 03             	and    $0x3,%eax
  801597:	48 85 c0             	test   %rax,%rax
  80159a:	75 3b                	jne    8015d7 <memmove+0x9a>
  80159c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a0:	83 e0 03             	and    $0x3,%eax
  8015a3:	48 85 c0             	test   %rax,%rax
  8015a6:	75 2f                	jne    8015d7 <memmove+0x9a>
  8015a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ac:	83 e0 03             	and    $0x3,%eax
  8015af:	48 85 c0             	test   %rax,%rax
  8015b2:	75 23                	jne    8015d7 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b8:	48 83 e8 04          	sub    $0x4,%rax
  8015bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015c0:	48 83 ea 04          	sub    $0x4,%rdx
  8015c4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015c8:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015cc:	48 89 c7             	mov    %rax,%rdi
  8015cf:	48 89 d6             	mov    %rdx,%rsi
  8015d2:	fd                   	std    
  8015d3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015d5:	eb 1d                	jmp    8015f4 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015db:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e3:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015eb:	48 89 d7             	mov    %rdx,%rdi
  8015ee:	48 89 c1             	mov    %rax,%rcx
  8015f1:	fd                   	std    
  8015f2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015f4:	fc                   	cld    
  8015f5:	eb 57                	jmp    80164e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015fb:	83 e0 03             	and    $0x3,%eax
  8015fe:	48 85 c0             	test   %rax,%rax
  801601:	75 36                	jne    801639 <memmove+0xfc>
  801603:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801607:	83 e0 03             	and    $0x3,%eax
  80160a:	48 85 c0             	test   %rax,%rax
  80160d:	75 2a                	jne    801639 <memmove+0xfc>
  80160f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801613:	83 e0 03             	and    $0x3,%eax
  801616:	48 85 c0             	test   %rax,%rax
  801619:	75 1e                	jne    801639 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80161b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161f:	48 c1 e8 02          	shr    $0x2,%rax
  801623:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801626:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80162a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80162e:	48 89 c7             	mov    %rax,%rdi
  801631:	48 89 d6             	mov    %rdx,%rsi
  801634:	fc                   	cld    
  801635:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801637:	eb 15                	jmp    80164e <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801639:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80163d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801641:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801645:	48 89 c7             	mov    %rax,%rdi
  801648:	48 89 d6             	mov    %rdx,%rsi
  80164b:	fc                   	cld    
  80164c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80164e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801652:	c9                   	leaveq 
  801653:	c3                   	retq   

0000000000801654 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801654:	55                   	push   %rbp
  801655:	48 89 e5             	mov    %rsp,%rbp
  801658:	48 83 ec 18          	sub    $0x18,%rsp
  80165c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801660:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801664:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801668:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80166c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801670:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801674:	48 89 ce             	mov    %rcx,%rsi
  801677:	48 89 c7             	mov    %rax,%rdi
  80167a:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  801681:	00 00 00 
  801684:	ff d0                	callq  *%rax
}
  801686:	c9                   	leaveq 
  801687:	c3                   	retq   

0000000000801688 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801688:	55                   	push   %rbp
  801689:	48 89 e5             	mov    %rsp,%rbp
  80168c:	48 83 ec 28          	sub    $0x28,%rsp
  801690:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801694:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801698:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80169c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8016a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016a8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016ac:	eb 36                	jmp    8016e4 <memcmp+0x5c>
		if (*s1 != *s2)
  8016ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b2:	0f b6 10             	movzbl (%rax),%edx
  8016b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b9:	0f b6 00             	movzbl (%rax),%eax
  8016bc:	38 c2                	cmp    %al,%dl
  8016be:	74 1a                	je     8016da <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c4:	0f b6 00             	movzbl (%rax),%eax
  8016c7:	0f b6 d0             	movzbl %al,%edx
  8016ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ce:	0f b6 00             	movzbl (%rax),%eax
  8016d1:	0f b6 c0             	movzbl %al,%eax
  8016d4:	29 c2                	sub    %eax,%edx
  8016d6:	89 d0                	mov    %edx,%eax
  8016d8:	eb 20                	jmp    8016fa <memcmp+0x72>
		s1++, s2++;
  8016da:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016df:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016f0:	48 85 c0             	test   %rax,%rax
  8016f3:	75 b9                	jne    8016ae <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016fa:	c9                   	leaveq 
  8016fb:	c3                   	retq   

00000000008016fc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016fc:	55                   	push   %rbp
  8016fd:	48 89 e5             	mov    %rsp,%rbp
  801700:	48 83 ec 28          	sub    $0x28,%rsp
  801704:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801708:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80170b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80170f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801713:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801717:	48 01 d0             	add    %rdx,%rax
  80171a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80171e:	eb 15                	jmp    801735 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801720:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801724:	0f b6 10             	movzbl (%rax),%edx
  801727:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80172a:	38 c2                	cmp    %al,%dl
  80172c:	75 02                	jne    801730 <memfind+0x34>
			break;
  80172e:	eb 0f                	jmp    80173f <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801730:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801735:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801739:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80173d:	72 e1                	jb     801720 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80173f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801743:	c9                   	leaveq 
  801744:	c3                   	retq   

0000000000801745 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801745:	55                   	push   %rbp
  801746:	48 89 e5             	mov    %rsp,%rbp
  801749:	48 83 ec 34          	sub    $0x34,%rsp
  80174d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801751:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801755:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801758:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80175f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801766:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801767:	eb 05                	jmp    80176e <strtol+0x29>
		s++;
  801769:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80176e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801772:	0f b6 00             	movzbl (%rax),%eax
  801775:	3c 20                	cmp    $0x20,%al
  801777:	74 f0                	je     801769 <strtol+0x24>
  801779:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177d:	0f b6 00             	movzbl (%rax),%eax
  801780:	3c 09                	cmp    $0x9,%al
  801782:	74 e5                	je     801769 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801788:	0f b6 00             	movzbl (%rax),%eax
  80178b:	3c 2b                	cmp    $0x2b,%al
  80178d:	75 07                	jne    801796 <strtol+0x51>
		s++;
  80178f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801794:	eb 17                	jmp    8017ad <strtol+0x68>
	else if (*s == '-')
  801796:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179a:	0f b6 00             	movzbl (%rax),%eax
  80179d:	3c 2d                	cmp    $0x2d,%al
  80179f:	75 0c                	jne    8017ad <strtol+0x68>
		s++, neg = 1;
  8017a1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017a6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017ad:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017b1:	74 06                	je     8017b9 <strtol+0x74>
  8017b3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017b7:	75 28                	jne    8017e1 <strtol+0x9c>
  8017b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bd:	0f b6 00             	movzbl (%rax),%eax
  8017c0:	3c 30                	cmp    $0x30,%al
  8017c2:	75 1d                	jne    8017e1 <strtol+0x9c>
  8017c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c8:	48 83 c0 01          	add    $0x1,%rax
  8017cc:	0f b6 00             	movzbl (%rax),%eax
  8017cf:	3c 78                	cmp    $0x78,%al
  8017d1:	75 0e                	jne    8017e1 <strtol+0x9c>
		s += 2, base = 16;
  8017d3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017d8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017df:	eb 2c                	jmp    80180d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017e1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017e5:	75 19                	jne    801800 <strtol+0xbb>
  8017e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017eb:	0f b6 00             	movzbl (%rax),%eax
  8017ee:	3c 30                	cmp    $0x30,%al
  8017f0:	75 0e                	jne    801800 <strtol+0xbb>
		s++, base = 8;
  8017f2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017f7:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017fe:	eb 0d                	jmp    80180d <strtol+0xc8>
	else if (base == 0)
  801800:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801804:	75 07                	jne    80180d <strtol+0xc8>
		base = 10;
  801806:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80180d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801811:	0f b6 00             	movzbl (%rax),%eax
  801814:	3c 2f                	cmp    $0x2f,%al
  801816:	7e 1d                	jle    801835 <strtol+0xf0>
  801818:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181c:	0f b6 00             	movzbl (%rax),%eax
  80181f:	3c 39                	cmp    $0x39,%al
  801821:	7f 12                	jg     801835 <strtol+0xf0>
			dig = *s - '0';
  801823:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801827:	0f b6 00             	movzbl (%rax),%eax
  80182a:	0f be c0             	movsbl %al,%eax
  80182d:	83 e8 30             	sub    $0x30,%eax
  801830:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801833:	eb 4e                	jmp    801883 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801835:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801839:	0f b6 00             	movzbl (%rax),%eax
  80183c:	3c 60                	cmp    $0x60,%al
  80183e:	7e 1d                	jle    80185d <strtol+0x118>
  801840:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801844:	0f b6 00             	movzbl (%rax),%eax
  801847:	3c 7a                	cmp    $0x7a,%al
  801849:	7f 12                	jg     80185d <strtol+0x118>
			dig = *s - 'a' + 10;
  80184b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184f:	0f b6 00             	movzbl (%rax),%eax
  801852:	0f be c0             	movsbl %al,%eax
  801855:	83 e8 57             	sub    $0x57,%eax
  801858:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80185b:	eb 26                	jmp    801883 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80185d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801861:	0f b6 00             	movzbl (%rax),%eax
  801864:	3c 40                	cmp    $0x40,%al
  801866:	7e 48                	jle    8018b0 <strtol+0x16b>
  801868:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186c:	0f b6 00             	movzbl (%rax),%eax
  80186f:	3c 5a                	cmp    $0x5a,%al
  801871:	7f 3d                	jg     8018b0 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801873:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801877:	0f b6 00             	movzbl (%rax),%eax
  80187a:	0f be c0             	movsbl %al,%eax
  80187d:	83 e8 37             	sub    $0x37,%eax
  801880:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801883:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801886:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801889:	7c 02                	jl     80188d <strtol+0x148>
			break;
  80188b:	eb 23                	jmp    8018b0 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80188d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801892:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801895:	48 98                	cltq   
  801897:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80189c:	48 89 c2             	mov    %rax,%rdx
  80189f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018a2:	48 98                	cltq   
  8018a4:	48 01 d0             	add    %rdx,%rax
  8018a7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018ab:	e9 5d ff ff ff       	jmpq   80180d <strtol+0xc8>

	if (endptr)
  8018b0:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018b5:	74 0b                	je     8018c2 <strtol+0x17d>
		*endptr = (char *) s;
  8018b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018bb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018bf:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018c6:	74 09                	je     8018d1 <strtol+0x18c>
  8018c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018cc:	48 f7 d8             	neg    %rax
  8018cf:	eb 04                	jmp    8018d5 <strtol+0x190>
  8018d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018d5:	c9                   	leaveq 
  8018d6:	c3                   	retq   

00000000008018d7 <strstr>:

char * strstr(const char *in, const char *str)
{
  8018d7:	55                   	push   %rbp
  8018d8:	48 89 e5             	mov    %rsp,%rbp
  8018db:	48 83 ec 30          	sub    $0x30,%rsp
  8018df:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018e3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018eb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018ef:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018f3:	0f b6 00             	movzbl (%rax),%eax
  8018f6:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018f9:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018fd:	75 06                	jne    801905 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801903:	eb 6b                	jmp    801970 <strstr+0x99>

	len = strlen(str);
  801905:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801909:	48 89 c7             	mov    %rax,%rdi
  80190c:	48 b8 ad 11 80 00 00 	movabs $0x8011ad,%rax
  801913:	00 00 00 
  801916:	ff d0                	callq  *%rax
  801918:	48 98                	cltq   
  80191a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80191e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801922:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801926:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80192a:	0f b6 00             	movzbl (%rax),%eax
  80192d:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801930:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801934:	75 07                	jne    80193d <strstr+0x66>
				return (char *) 0;
  801936:	b8 00 00 00 00       	mov    $0x0,%eax
  80193b:	eb 33                	jmp    801970 <strstr+0x99>
		} while (sc != c);
  80193d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801941:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801944:	75 d8                	jne    80191e <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801946:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80194a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80194e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801952:	48 89 ce             	mov    %rcx,%rsi
  801955:	48 89 c7             	mov    %rax,%rdi
  801958:	48 b8 ce 13 80 00 00 	movabs $0x8013ce,%rax
  80195f:	00 00 00 
  801962:	ff d0                	callq  *%rax
  801964:	85 c0                	test   %eax,%eax
  801966:	75 b6                	jne    80191e <strstr+0x47>

	return (char *) (in - 1);
  801968:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196c:	48 83 e8 01          	sub    $0x1,%rax
}
  801970:	c9                   	leaveq 
  801971:	c3                   	retq   

0000000000801972 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801972:	55                   	push   %rbp
  801973:	48 89 e5             	mov    %rsp,%rbp
  801976:	53                   	push   %rbx
  801977:	48 83 ec 48          	sub    $0x48,%rsp
  80197b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80197e:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801981:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801985:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801989:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80198d:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801991:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801994:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801998:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80199c:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8019a0:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8019a4:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8019a8:	4c 89 c3             	mov    %r8,%rbx
  8019ab:	cd 30                	int    $0x30
  8019ad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8019b1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019b5:	74 3e                	je     8019f5 <syscall+0x83>
  8019b7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019bc:	7e 37                	jle    8019f5 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019c2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019c5:	49 89 d0             	mov    %rdx,%r8
  8019c8:	89 c1                	mov    %eax,%ecx
  8019ca:	48 ba e8 50 80 00 00 	movabs $0x8050e8,%rdx
  8019d1:	00 00 00 
  8019d4:	be 24 00 00 00       	mov    $0x24,%esi
  8019d9:	48 bf 05 51 80 00 00 	movabs $0x805105,%rdi
  8019e0:	00 00 00 
  8019e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e8:	49 b9 2b 04 80 00 00 	movabs $0x80042b,%r9
  8019ef:	00 00 00 
  8019f2:	41 ff d1             	callq  *%r9

	return ret;
  8019f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019f9:	48 83 c4 48          	add    $0x48,%rsp
  8019fd:	5b                   	pop    %rbx
  8019fe:	5d                   	pop    %rbp
  8019ff:	c3                   	retq   

0000000000801a00 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a00:	55                   	push   %rbp
  801a01:	48 89 e5             	mov    %rsp,%rbp
  801a04:	48 83 ec 20          	sub    $0x20,%rsp
  801a08:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a0c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a18:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a1f:	00 
  801a20:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a26:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a2c:	48 89 d1             	mov    %rdx,%rcx
  801a2f:	48 89 c2             	mov    %rax,%rdx
  801a32:	be 00 00 00 00       	mov    $0x0,%esi
  801a37:	bf 00 00 00 00       	mov    $0x0,%edi
  801a3c:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801a43:	00 00 00 
  801a46:	ff d0                	callq  *%rax
}
  801a48:	c9                   	leaveq 
  801a49:	c3                   	retq   

0000000000801a4a <sys_cgetc>:

int
sys_cgetc(void)
{
  801a4a:	55                   	push   %rbp
  801a4b:	48 89 e5             	mov    %rsp,%rbp
  801a4e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a52:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a59:	00 
  801a5a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a60:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a66:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a70:	be 00 00 00 00       	mov    $0x0,%esi
  801a75:	bf 01 00 00 00       	mov    $0x1,%edi
  801a7a:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801a81:	00 00 00 
  801a84:	ff d0                	callq  *%rax
}
  801a86:	c9                   	leaveq 
  801a87:	c3                   	retq   

0000000000801a88 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a88:	55                   	push   %rbp
  801a89:	48 89 e5             	mov    %rsp,%rbp
  801a8c:	48 83 ec 10          	sub    $0x10,%rsp
  801a90:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a96:	48 98                	cltq   
  801a98:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a9f:	00 
  801aa0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aac:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ab1:	48 89 c2             	mov    %rax,%rdx
  801ab4:	be 01 00 00 00       	mov    $0x1,%esi
  801ab9:	bf 03 00 00 00       	mov    $0x3,%edi
  801abe:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801ac5:	00 00 00 
  801ac8:	ff d0                	callq  *%rax
}
  801aca:	c9                   	leaveq 
  801acb:	c3                   	retq   

0000000000801acc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801acc:	55                   	push   %rbp
  801acd:	48 89 e5             	mov    %rsp,%rbp
  801ad0:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ad4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801adb:	00 
  801adc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aed:	ba 00 00 00 00       	mov    $0x0,%edx
  801af2:	be 00 00 00 00       	mov    $0x0,%esi
  801af7:	bf 02 00 00 00       	mov    $0x2,%edi
  801afc:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801b03:	00 00 00 
  801b06:	ff d0                	callq  *%rax
}
  801b08:	c9                   	leaveq 
  801b09:	c3                   	retq   

0000000000801b0a <sys_yield>:


void
sys_yield(void)
{
  801b0a:	55                   	push   %rbp
  801b0b:	48 89 e5             	mov    %rsp,%rbp
  801b0e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b12:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b19:	00 
  801b1a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b20:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b26:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b2b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b30:	be 00 00 00 00       	mov    $0x0,%esi
  801b35:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b3a:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801b41:	00 00 00 
  801b44:	ff d0                	callq  *%rax
}
  801b46:	c9                   	leaveq 
  801b47:	c3                   	retq   

0000000000801b48 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b48:	55                   	push   %rbp
  801b49:	48 89 e5             	mov    %rsp,%rbp
  801b4c:	48 83 ec 20          	sub    $0x20,%rsp
  801b50:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b53:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b57:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b5a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b5d:	48 63 c8             	movslq %eax,%rcx
  801b60:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b67:	48 98                	cltq   
  801b69:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b70:	00 
  801b71:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b77:	49 89 c8             	mov    %rcx,%r8
  801b7a:	48 89 d1             	mov    %rdx,%rcx
  801b7d:	48 89 c2             	mov    %rax,%rdx
  801b80:	be 01 00 00 00       	mov    $0x1,%esi
  801b85:	bf 04 00 00 00       	mov    $0x4,%edi
  801b8a:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801b91:	00 00 00 
  801b94:	ff d0                	callq  *%rax
}
  801b96:	c9                   	leaveq 
  801b97:	c3                   	retq   

0000000000801b98 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b98:	55                   	push   %rbp
  801b99:	48 89 e5             	mov    %rsp,%rbp
  801b9c:	48 83 ec 30          	sub    $0x30,%rsp
  801ba0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ba3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ba7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801baa:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bae:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801bb2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bb5:	48 63 c8             	movslq %eax,%rcx
  801bb8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bbc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bbf:	48 63 f0             	movslq %eax,%rsi
  801bc2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc9:	48 98                	cltq   
  801bcb:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bcf:	49 89 f9             	mov    %rdi,%r9
  801bd2:	49 89 f0             	mov    %rsi,%r8
  801bd5:	48 89 d1             	mov    %rdx,%rcx
  801bd8:	48 89 c2             	mov    %rax,%rdx
  801bdb:	be 01 00 00 00       	mov    $0x1,%esi
  801be0:	bf 05 00 00 00       	mov    $0x5,%edi
  801be5:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801bec:	00 00 00 
  801bef:	ff d0                	callq  *%rax
}
  801bf1:	c9                   	leaveq 
  801bf2:	c3                   	retq   

0000000000801bf3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bf3:	55                   	push   %rbp
  801bf4:	48 89 e5             	mov    %rsp,%rbp
  801bf7:	48 83 ec 20          	sub    $0x20,%rsp
  801bfb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bfe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c02:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c09:	48 98                	cltq   
  801c0b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c12:	00 
  801c13:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c19:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c1f:	48 89 d1             	mov    %rdx,%rcx
  801c22:	48 89 c2             	mov    %rax,%rdx
  801c25:	be 01 00 00 00       	mov    $0x1,%esi
  801c2a:	bf 06 00 00 00       	mov    $0x6,%edi
  801c2f:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801c36:	00 00 00 
  801c39:	ff d0                	callq  *%rax
}
  801c3b:	c9                   	leaveq 
  801c3c:	c3                   	retq   

0000000000801c3d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c3d:	55                   	push   %rbp
  801c3e:	48 89 e5             	mov    %rsp,%rbp
  801c41:	48 83 ec 10          	sub    $0x10,%rsp
  801c45:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c48:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c4b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c4e:	48 63 d0             	movslq %eax,%rdx
  801c51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c54:	48 98                	cltq   
  801c56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c5d:	00 
  801c5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c6a:	48 89 d1             	mov    %rdx,%rcx
  801c6d:	48 89 c2             	mov    %rax,%rdx
  801c70:	be 01 00 00 00       	mov    $0x1,%esi
  801c75:	bf 08 00 00 00       	mov    $0x8,%edi
  801c7a:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801c81:	00 00 00 
  801c84:	ff d0                	callq  *%rax
}
  801c86:	c9                   	leaveq 
  801c87:	c3                   	retq   

0000000000801c88 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c88:	55                   	push   %rbp
  801c89:	48 89 e5             	mov    %rsp,%rbp
  801c8c:	48 83 ec 20          	sub    $0x20,%rsp
  801c90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c93:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c97:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c9e:	48 98                	cltq   
  801ca0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca7:	00 
  801ca8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb4:	48 89 d1             	mov    %rdx,%rcx
  801cb7:	48 89 c2             	mov    %rax,%rdx
  801cba:	be 01 00 00 00       	mov    $0x1,%esi
  801cbf:	bf 09 00 00 00       	mov    $0x9,%edi
  801cc4:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801ccb:	00 00 00 
  801cce:	ff d0                	callq  *%rax
}
  801cd0:	c9                   	leaveq 
  801cd1:	c3                   	retq   

0000000000801cd2 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801cd2:	55                   	push   %rbp
  801cd3:	48 89 e5             	mov    %rsp,%rbp
  801cd6:	48 83 ec 20          	sub    $0x20,%rsp
  801cda:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cdd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ce1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ce5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce8:	48 98                	cltq   
  801cea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cf1:	00 
  801cf2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cfe:	48 89 d1             	mov    %rdx,%rcx
  801d01:	48 89 c2             	mov    %rax,%rdx
  801d04:	be 01 00 00 00       	mov    $0x1,%esi
  801d09:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d0e:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801d15:	00 00 00 
  801d18:	ff d0                	callq  *%rax
}
  801d1a:	c9                   	leaveq 
  801d1b:	c3                   	retq   

0000000000801d1c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d1c:	55                   	push   %rbp
  801d1d:	48 89 e5             	mov    %rsp,%rbp
  801d20:	48 83 ec 20          	sub    $0x20,%rsp
  801d24:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d27:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d2b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d2f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d32:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d35:	48 63 f0             	movslq %eax,%rsi
  801d38:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d3f:	48 98                	cltq   
  801d41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d45:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d4c:	00 
  801d4d:	49 89 f1             	mov    %rsi,%r9
  801d50:	49 89 c8             	mov    %rcx,%r8
  801d53:	48 89 d1             	mov    %rdx,%rcx
  801d56:	48 89 c2             	mov    %rax,%rdx
  801d59:	be 00 00 00 00       	mov    $0x0,%esi
  801d5e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d63:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801d6a:	00 00 00 
  801d6d:	ff d0                	callq  *%rax
}
  801d6f:	c9                   	leaveq 
  801d70:	c3                   	retq   

0000000000801d71 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d71:	55                   	push   %rbp
  801d72:	48 89 e5             	mov    %rsp,%rbp
  801d75:	48 83 ec 10          	sub    $0x10,%rsp
  801d79:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d81:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d88:	00 
  801d89:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d8f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d95:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d9a:	48 89 c2             	mov    %rax,%rdx
  801d9d:	be 01 00 00 00       	mov    $0x1,%esi
  801da2:	bf 0d 00 00 00       	mov    $0xd,%edi
  801da7:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801dae:	00 00 00 
  801db1:	ff d0                	callq  *%rax
}
  801db3:	c9                   	leaveq 
  801db4:	c3                   	retq   

0000000000801db5 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801db5:	55                   	push   %rbp
  801db6:	48 89 e5             	mov    %rsp,%rbp
  801db9:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801dbd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dc4:	00 
  801dc5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dcb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dd1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dd6:	ba 00 00 00 00       	mov    $0x0,%edx
  801ddb:	be 00 00 00 00       	mov    $0x0,%esi
  801de0:	bf 0e 00 00 00       	mov    $0xe,%edi
  801de5:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801dec:	00 00 00 
  801def:	ff d0                	callq  *%rax
}
  801df1:	c9                   	leaveq 
  801df2:	c3                   	retq   

0000000000801df3 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801df3:	55                   	push   %rbp
  801df4:	48 89 e5             	mov    %rsp,%rbp
  801df7:	48 83 ec 20          	sub    $0x20,%rsp
  801dfb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dff:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801e02:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801e05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e09:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e10:	00 
  801e11:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e17:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e1d:	48 89 d1             	mov    %rdx,%rcx
  801e20:	48 89 c2             	mov    %rax,%rdx
  801e23:	be 00 00 00 00       	mov    $0x0,%esi
  801e28:	bf 0f 00 00 00       	mov    $0xf,%edi
  801e2d:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801e34:	00 00 00 
  801e37:	ff d0                	callq  *%rax
}
  801e39:	c9                   	leaveq 
  801e3a:	c3                   	retq   

0000000000801e3b <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801e3b:	55                   	push   %rbp
  801e3c:	48 89 e5             	mov    %rsp,%rbp
  801e3f:	48 83 ec 20          	sub    $0x20,%rsp
  801e43:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e47:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801e4a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801e4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e51:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e58:	00 
  801e59:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e5f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e65:	48 89 d1             	mov    %rdx,%rcx
  801e68:	48 89 c2             	mov    %rax,%rdx
  801e6b:	be 00 00 00 00       	mov    $0x0,%esi
  801e70:	bf 10 00 00 00       	mov    $0x10,%edi
  801e75:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801e7c:	00 00 00 
  801e7f:	ff d0                	callq  *%rax
}
  801e81:	c9                   	leaveq 
  801e82:	c3                   	retq   

0000000000801e83 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801e83:	55                   	push   %rbp
  801e84:	48 89 e5             	mov    %rsp,%rbp
  801e87:	48 83 ec 30          	sub    $0x30,%rsp
  801e8b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e8e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e92:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e95:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e99:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801e9d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ea0:	48 63 c8             	movslq %eax,%rcx
  801ea3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ea7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801eaa:	48 63 f0             	movslq %eax,%rsi
  801ead:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb4:	48 98                	cltq   
  801eb6:	48 89 0c 24          	mov    %rcx,(%rsp)
  801eba:	49 89 f9             	mov    %rdi,%r9
  801ebd:	49 89 f0             	mov    %rsi,%r8
  801ec0:	48 89 d1             	mov    %rdx,%rcx
  801ec3:	48 89 c2             	mov    %rax,%rdx
  801ec6:	be 00 00 00 00       	mov    $0x0,%esi
  801ecb:	bf 11 00 00 00       	mov    $0x11,%edi
  801ed0:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801ed7:	00 00 00 
  801eda:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801edc:	c9                   	leaveq 
  801edd:	c3                   	retq   

0000000000801ede <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801ede:	55                   	push   %rbp
  801edf:	48 89 e5             	mov    %rsp,%rbp
  801ee2:	48 83 ec 20          	sub    $0x20,%rsp
  801ee6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801eea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801eee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ef2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ef6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801efd:	00 
  801efe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f04:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f0a:	48 89 d1             	mov    %rdx,%rcx
  801f0d:	48 89 c2             	mov    %rax,%rdx
  801f10:	be 00 00 00 00       	mov    $0x0,%esi
  801f15:	bf 12 00 00 00       	mov    $0x12,%edi
  801f1a:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801f21:	00 00 00 
  801f24:	ff d0                	callq  *%rax
}
  801f26:	c9                   	leaveq 
  801f27:	c3                   	retq   

0000000000801f28 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801f28:	55                   	push   %rbp
  801f29:	48 89 e5             	mov    %rsp,%rbp
  801f2c:	48 83 ec 30          	sub    $0x30,%rsp
  801f30:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801f34:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f38:	48 8b 00             	mov    (%rax),%rax
  801f3b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801f3f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f43:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f47:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  801f4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f4d:	83 e0 02             	and    $0x2,%eax
  801f50:	85 c0                	test   %eax,%eax
  801f52:	75 40                	jne    801f94 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  801f54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f58:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  801f5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f63:	49 89 d0             	mov    %rdx,%r8
  801f66:	48 89 c1             	mov    %rax,%rcx
  801f69:	48 ba 18 51 80 00 00 	movabs $0x805118,%rdx
  801f70:	00 00 00 
  801f73:	be 1f 00 00 00       	mov    $0x1f,%esi
  801f78:	48 bf 31 51 80 00 00 	movabs $0x805131,%rdi
  801f7f:	00 00 00 
  801f82:	b8 00 00 00 00       	mov    $0x0,%eax
  801f87:	49 b9 2b 04 80 00 00 	movabs $0x80042b,%r9
  801f8e:	00 00 00 
  801f91:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  801f94:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f98:	48 c1 e8 0c          	shr    $0xc,%rax
  801f9c:	48 89 c2             	mov    %rax,%rdx
  801f9f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fa6:	01 00 00 
  801fa9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fad:	25 07 08 00 00       	and    $0x807,%eax
  801fb2:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  801fb8:	74 4e                	je     802008 <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  801fba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fbe:	48 c1 e8 0c          	shr    $0xc,%rax
  801fc2:	48 89 c2             	mov    %rax,%rdx
  801fc5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fcc:	01 00 00 
  801fcf:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801fd3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fd7:	49 89 d0             	mov    %rdx,%r8
  801fda:	48 89 c1             	mov    %rax,%rcx
  801fdd:	48 ba 40 51 80 00 00 	movabs $0x805140,%rdx
  801fe4:	00 00 00 
  801fe7:	be 22 00 00 00       	mov    $0x22,%esi
  801fec:	48 bf 31 51 80 00 00 	movabs $0x805131,%rdi
  801ff3:	00 00 00 
  801ff6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffb:	49 b9 2b 04 80 00 00 	movabs $0x80042b,%r9
  802002:	00 00 00 
  802005:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802008:	ba 07 00 00 00       	mov    $0x7,%edx
  80200d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802012:	bf 00 00 00 00       	mov    $0x0,%edi
  802017:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  80201e:	00 00 00 
  802021:	ff d0                	callq  *%rax
  802023:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802026:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80202a:	79 30                	jns    80205c <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  80202c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80202f:	89 c1                	mov    %eax,%ecx
  802031:	48 ba 6b 51 80 00 00 	movabs $0x80516b,%rdx
  802038:	00 00 00 
  80203b:	be 28 00 00 00       	mov    $0x28,%esi
  802040:	48 bf 31 51 80 00 00 	movabs $0x805131,%rdi
  802047:	00 00 00 
  80204a:	b8 00 00 00 00       	mov    $0x0,%eax
  80204f:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  802056:	00 00 00 
  802059:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  80205c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802060:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802064:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802068:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80206e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802073:	48 89 c6             	mov    %rax,%rsi
  802076:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80207b:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  802082:	00 00 00 
  802085:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802087:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80208b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80208f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802093:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802099:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80209f:	48 89 c1             	mov    %rax,%rcx
  8020a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8020a7:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8020b1:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  8020b8:	00 00 00 
  8020bb:	ff d0                	callq  *%rax
  8020bd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8020c0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020c4:	79 30                	jns    8020f6 <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  8020c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020c9:	89 c1                	mov    %eax,%ecx
  8020cb:	48 ba 7e 51 80 00 00 	movabs $0x80517e,%rdx
  8020d2:	00 00 00 
  8020d5:	be 2d 00 00 00       	mov    $0x2d,%esi
  8020da:	48 bf 31 51 80 00 00 	movabs $0x805131,%rdi
  8020e1:	00 00 00 
  8020e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e9:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  8020f0:	00 00 00 
  8020f3:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  8020f6:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020fb:	bf 00 00 00 00       	mov    $0x0,%edi
  802100:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  802107:	00 00 00 
  80210a:	ff d0                	callq  *%rax
  80210c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80210f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802113:	79 30                	jns    802145 <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  802115:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802118:	89 c1                	mov    %eax,%ecx
  80211a:	48 ba 8f 51 80 00 00 	movabs $0x80518f,%rdx
  802121:	00 00 00 
  802124:	be 31 00 00 00       	mov    $0x31,%esi
  802129:	48 bf 31 51 80 00 00 	movabs $0x805131,%rdi
  802130:	00 00 00 
  802133:	b8 00 00 00 00       	mov    $0x0,%eax
  802138:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  80213f:	00 00 00 
  802142:	41 ff d0             	callq  *%r8

}
  802145:	c9                   	leaveq 
  802146:	c3                   	retq   

0000000000802147 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802147:	55                   	push   %rbp
  802148:	48 89 e5             	mov    %rsp,%rbp
  80214b:	48 83 ec 30          	sub    $0x30,%rsp
  80214f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802152:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  802155:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802158:	c1 e0 0c             	shl    $0xc,%eax
  80215b:	89 c0                	mov    %eax,%eax
  80215d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  802161:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802168:	01 00 00 
  80216b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80216e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802172:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  802176:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80217a:	25 02 08 00 00       	and    $0x802,%eax
  80217f:	48 85 c0             	test   %rax,%rax
  802182:	74 0e                	je     802192 <duppage+0x4b>
  802184:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802188:	25 00 04 00 00       	and    $0x400,%eax
  80218d:	48 85 c0             	test   %rax,%rax
  802190:	74 70                	je     802202 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  802192:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802196:	25 07 0e 00 00       	and    $0xe07,%eax
  80219b:	89 c6                	mov    %eax,%esi
  80219d:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8021a1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021a8:	41 89 f0             	mov    %esi,%r8d
  8021ab:	48 89 c6             	mov    %rax,%rsi
  8021ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b3:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  8021ba:	00 00 00 
  8021bd:	ff d0                	callq  *%rax
  8021bf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8021c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021c6:	79 30                	jns    8021f8 <duppage+0xb1>
			panic("sys_page_map: %e", r);
  8021c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021cb:	89 c1                	mov    %eax,%ecx
  8021cd:	48 ba 7e 51 80 00 00 	movabs $0x80517e,%rdx
  8021d4:	00 00 00 
  8021d7:	be 50 00 00 00       	mov    $0x50,%esi
  8021dc:	48 bf 31 51 80 00 00 	movabs $0x805131,%rdi
  8021e3:	00 00 00 
  8021e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021eb:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  8021f2:	00 00 00 
  8021f5:	41 ff d0             	callq  *%r8
		return 0;
  8021f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fd:	e9 c4 00 00 00       	jmpq   8022c6 <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802202:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802206:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802209:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80220d:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802213:	48 89 c6             	mov    %rax,%rsi
  802216:	bf 00 00 00 00       	mov    $0x0,%edi
  80221b:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  802222:	00 00 00 
  802225:	ff d0                	callq  *%rax
  802227:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80222a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80222e:	79 30                	jns    802260 <duppage+0x119>
		panic("sys_page_map: %e", r);
  802230:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802233:	89 c1                	mov    %eax,%ecx
  802235:	48 ba 7e 51 80 00 00 	movabs $0x80517e,%rdx
  80223c:	00 00 00 
  80223f:	be 64 00 00 00       	mov    $0x64,%esi
  802244:	48 bf 31 51 80 00 00 	movabs $0x805131,%rdi
  80224b:	00 00 00 
  80224e:	b8 00 00 00 00       	mov    $0x0,%eax
  802253:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  80225a:	00 00 00 
  80225d:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802260:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802264:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802268:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  80226e:	48 89 d1             	mov    %rdx,%rcx
  802271:	ba 00 00 00 00       	mov    $0x0,%edx
  802276:	48 89 c6             	mov    %rax,%rsi
  802279:	bf 00 00 00 00       	mov    $0x0,%edi
  80227e:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  802285:	00 00 00 
  802288:	ff d0                	callq  *%rax
  80228a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80228d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802291:	79 30                	jns    8022c3 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  802293:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802296:	89 c1                	mov    %eax,%ecx
  802298:	48 ba 7e 51 80 00 00 	movabs $0x80517e,%rdx
  80229f:	00 00 00 
  8022a2:	be 66 00 00 00       	mov    $0x66,%esi
  8022a7:	48 bf 31 51 80 00 00 	movabs $0x805131,%rdi
  8022ae:	00 00 00 
  8022b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b6:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  8022bd:	00 00 00 
  8022c0:	41 ff d0             	callq  *%r8
	return r;
  8022c3:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8022c6:	c9                   	leaveq 
  8022c7:	c3                   	retq   

00000000008022c8 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8022c8:	55                   	push   %rbp
  8022c9:	48 89 e5             	mov    %rsp,%rbp
  8022cc:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  8022d0:	48 bf 28 1f 80 00 00 	movabs $0x801f28,%rdi
  8022d7:	00 00 00 
  8022da:	48 b8 b8 49 80 00 00 	movabs $0x8049b8,%rax
  8022e1:	00 00 00 
  8022e4:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8022e6:	b8 07 00 00 00       	mov    $0x7,%eax
  8022eb:	cd 30                	int    $0x30
  8022ed:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8022f0:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  8022f3:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  8022f6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022fa:	79 08                	jns    802304 <fork+0x3c>
		return envid;
  8022fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022ff:	e9 09 02 00 00       	jmpq   80250d <fork+0x245>
	if (envid == 0) {
  802304:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802308:	75 3e                	jne    802348 <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  80230a:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  802311:	00 00 00 
  802314:	ff d0                	callq  *%rax
  802316:	25 ff 03 00 00       	and    $0x3ff,%eax
  80231b:	48 98                	cltq   
  80231d:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  802324:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80232b:	00 00 00 
  80232e:	48 01 c2             	add    %rax,%rdx
  802331:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802338:	00 00 00 
  80233b:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80233e:	b8 00 00 00 00       	mov    $0x0,%eax
  802343:	e9 c5 01 00 00       	jmpq   80250d <fork+0x245>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  802348:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80234f:	e9 a4 00 00 00       	jmpq   8023f8 <fork+0x130>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  802354:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802357:	c1 f8 12             	sar    $0x12,%eax
  80235a:	89 c2                	mov    %eax,%edx
  80235c:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802363:	01 00 00 
  802366:	48 63 d2             	movslq %edx,%rdx
  802369:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80236d:	83 e0 01             	and    $0x1,%eax
  802370:	48 85 c0             	test   %rax,%rax
  802373:	74 21                	je     802396 <fork+0xce>
  802375:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802378:	c1 f8 09             	sar    $0x9,%eax
  80237b:	89 c2                	mov    %eax,%edx
  80237d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802384:	01 00 00 
  802387:	48 63 d2             	movslq %edx,%rdx
  80238a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80238e:	83 e0 01             	and    $0x1,%eax
  802391:	48 85 c0             	test   %rax,%rax
  802394:	75 09                	jne    80239f <fork+0xd7>
			pn += NPTENTRIES;
  802396:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  80239d:	eb 59                	jmp    8023f8 <fork+0x130>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  80239f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a2:	05 00 02 00 00       	add    $0x200,%eax
  8023a7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8023aa:	eb 44                	jmp    8023f0 <fork+0x128>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  8023ac:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023b3:	01 00 00 
  8023b6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023b9:	48 63 d2             	movslq %edx,%rdx
  8023bc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023c0:	83 e0 05             	and    $0x5,%eax
  8023c3:	48 83 f8 05          	cmp    $0x5,%rax
  8023c7:	74 02                	je     8023cb <fork+0x103>
				continue;
  8023c9:	eb 21                	jmp    8023ec <fork+0x124>
			if (pn == PPN(UXSTACKTOP - 1))
  8023cb:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  8023d2:	75 02                	jne    8023d6 <fork+0x10e>
				continue;
  8023d4:	eb 16                	jmp    8023ec <fork+0x124>
			duppage(envid, pn);
  8023d6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023dc:	89 d6                	mov    %edx,%esi
  8023de:	89 c7                	mov    %eax,%edi
  8023e0:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  8023e7:	00 00 00 
  8023ea:	ff d0                	callq  *%rax
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  8023ec:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f3:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8023f6:	7c b4                	jl     8023ac <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  8023f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023fb:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  802400:	0f 86 4e ff ff ff    	jbe    802354 <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802406:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802409:	ba 07 00 00 00       	mov    $0x7,%edx
  80240e:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802413:	89 c7                	mov    %eax,%edi
  802415:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  80241c:	00 00 00 
  80241f:	ff d0                	callq  *%rax
  802421:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802424:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802428:	79 30                	jns    80245a <fork+0x192>
		panic("allocating exception stack: %e", r);
  80242a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80242d:	89 c1                	mov    %eax,%ecx
  80242f:	48 ba a8 51 80 00 00 	movabs $0x8051a8,%rdx
  802436:	00 00 00 
  802439:	be 9e 00 00 00       	mov    $0x9e,%esi
  80243e:	48 bf 31 51 80 00 00 	movabs $0x805131,%rdi
  802445:	00 00 00 
  802448:	b8 00 00 00 00       	mov    $0x0,%eax
  80244d:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  802454:	00 00 00 
  802457:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  80245a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802461:	00 00 00 
  802464:	48 8b 00             	mov    (%rax),%rax
  802467:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80246e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802471:	48 89 d6             	mov    %rdx,%rsi
  802474:	89 c7                	mov    %eax,%edi
  802476:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  80247d:	00 00 00 
  802480:	ff d0                	callq  *%rax
  802482:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802485:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802489:	79 30                	jns    8024bb <fork+0x1f3>
		panic("sys_env_set_pgfault_upcall: %e", r);
  80248b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80248e:	89 c1                	mov    %eax,%ecx
  802490:	48 ba c8 51 80 00 00 	movabs $0x8051c8,%rdx
  802497:	00 00 00 
  80249a:	be a2 00 00 00       	mov    $0xa2,%esi
  80249f:	48 bf 31 51 80 00 00 	movabs $0x805131,%rdi
  8024a6:	00 00 00 
  8024a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ae:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  8024b5:	00 00 00 
  8024b8:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8024bb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024be:	be 02 00 00 00       	mov    $0x2,%esi
  8024c3:	89 c7                	mov    %eax,%edi
  8024c5:	48 b8 3d 1c 80 00 00 	movabs $0x801c3d,%rax
  8024cc:	00 00 00 
  8024cf:	ff d0                	callq  *%rax
  8024d1:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8024d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8024d8:	79 30                	jns    80250a <fork+0x242>
		panic("sys_env_set_status: %e", r);
  8024da:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8024dd:	89 c1                	mov    %eax,%ecx
  8024df:	48 ba e7 51 80 00 00 	movabs $0x8051e7,%rdx
  8024e6:	00 00 00 
  8024e9:	be a7 00 00 00       	mov    $0xa7,%esi
  8024ee:	48 bf 31 51 80 00 00 	movabs $0x805131,%rdi
  8024f5:	00 00 00 
  8024f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fd:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  802504:	00 00 00 
  802507:	41 ff d0             	callq  *%r8

	return envid;
  80250a:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  80250d:	c9                   	leaveq 
  80250e:	c3                   	retq   

000000000080250f <sfork>:

// Challenge!
int
sfork(void)
{
  80250f:	55                   	push   %rbp
  802510:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802513:	48 ba fe 51 80 00 00 	movabs $0x8051fe,%rdx
  80251a:	00 00 00 
  80251d:	be b1 00 00 00       	mov    $0xb1,%esi
  802522:	48 bf 31 51 80 00 00 	movabs $0x805131,%rdi
  802529:	00 00 00 
  80252c:	b8 00 00 00 00       	mov    $0x0,%eax
  802531:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  802538:	00 00 00 
  80253b:	ff d1                	callq  *%rcx

000000000080253d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80253d:	55                   	push   %rbp
  80253e:	48 89 e5             	mov    %rsp,%rbp
  802541:	48 83 ec 30          	sub    $0x30,%rsp
  802545:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802549:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80254d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  802551:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802556:	75 0e                	jne    802566 <ipc_recv+0x29>
		pg = (void*) UTOP;
  802558:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80255f:	00 00 00 
  802562:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  802566:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80256a:	48 89 c7             	mov    %rax,%rdi
  80256d:	48 b8 71 1d 80 00 00 	movabs $0x801d71,%rax
  802574:	00 00 00 
  802577:	ff d0                	callq  *%rax
  802579:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80257c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802580:	79 27                	jns    8025a9 <ipc_recv+0x6c>
		if (from_env_store)
  802582:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802587:	74 0a                	je     802593 <ipc_recv+0x56>
			*from_env_store = 0;
  802589:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80258d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  802593:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802598:	74 0a                	je     8025a4 <ipc_recv+0x67>
			*perm_store = 0;
  80259a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80259e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8025a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a7:	eb 53                	jmp    8025fc <ipc_recv+0xbf>
	}
	if (from_env_store)
  8025a9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8025ae:	74 19                	je     8025c9 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8025b0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8025b7:	00 00 00 
  8025ba:	48 8b 00             	mov    (%rax),%rax
  8025bd:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8025c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c7:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8025c9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8025ce:	74 19                	je     8025e9 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8025d0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8025d7:	00 00 00 
  8025da:	48 8b 00             	mov    (%rax),%rax
  8025dd:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8025e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025e7:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8025e9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8025f0:	00 00 00 
  8025f3:	48 8b 00             	mov    (%rax),%rax
  8025f6:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  8025fc:	c9                   	leaveq 
  8025fd:	c3                   	retq   

00000000008025fe <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8025fe:	55                   	push   %rbp
  8025ff:	48 89 e5             	mov    %rsp,%rbp
  802602:	48 83 ec 30          	sub    $0x30,%rsp
  802606:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802609:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80260c:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802610:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  802613:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802618:	75 10                	jne    80262a <ipc_send+0x2c>
		pg = (void*) UTOP;
  80261a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802621:	00 00 00 
  802624:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802628:	eb 0e                	jmp    802638 <ipc_send+0x3a>
  80262a:	eb 0c                	jmp    802638 <ipc_send+0x3a>
		sys_yield();
  80262c:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  802633:	00 00 00 
  802636:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802638:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80263b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80263e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802642:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802645:	89 c7                	mov    %eax,%edi
  802647:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  80264e:	00 00 00 
  802651:	ff d0                	callq  *%rax
  802653:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802656:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80265a:	74 d0                	je     80262c <ipc_send+0x2e>
		sys_yield();
	}
	if (r < 0)
  80265c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802660:	79 30                	jns    802692 <ipc_send+0x94>
		panic("error in ipc_send: %e", r);
  802662:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802665:	89 c1                	mov    %eax,%ecx
  802667:	48 ba 14 52 80 00 00 	movabs $0x805214,%rdx
  80266e:	00 00 00 
  802671:	be 47 00 00 00       	mov    $0x47,%esi
  802676:	48 bf 2a 52 80 00 00 	movabs $0x80522a,%rdi
  80267d:	00 00 00 
  802680:	b8 00 00 00 00       	mov    $0x0,%eax
  802685:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  80268c:	00 00 00 
  80268f:	41 ff d0             	callq  *%r8

}
  802692:	c9                   	leaveq 
  802693:	c3                   	retq   

0000000000802694 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  802694:	55                   	push   %rbp
  802695:	48 89 e5             	mov    %rsp,%rbp
  802698:	53                   	push   %rbx
  802699:	48 83 ec 28          	sub    $0x28,%rsp
  80269d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  8026a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8026a8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  8026af:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8026b4:	75 0e                	jne    8026c4 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  8026b6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8026bd:	00 00 00 
  8026c0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  8026c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026c8:	ba 07 00 00 00       	mov    $0x7,%edx
  8026cd:	48 89 c6             	mov    %rax,%rsi
  8026d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d5:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  8026dc:	00 00 00 
  8026df:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8026e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026e5:	48 c1 e8 0c          	shr    $0xc,%rax
  8026e9:	48 89 c2             	mov    %rax,%rdx
  8026ec:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026f3:	01 00 00 
  8026f6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026fa:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802700:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  802704:	b8 03 00 00 00       	mov    $0x3,%eax
  802709:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80270d:	48 89 d3             	mov    %rdx,%rbx
  802710:	0f 01 c1             	vmcall 
  802713:	89 f2                	mov    %esi,%edx
  802715:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802718:	89 55 e8             	mov    %edx,-0x18(%rbp)
	/* cprintf("Returned IPC response from host: %d %d\n", r, -val);*/
	if (r < 0) {
  80271b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80271f:	79 05                	jns    802726 <ipc_host_recv+0x92>
		return r;
  802721:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802724:	eb 03                	jmp    802729 <ipc_host_recv+0x95>
	}
	return val;
  802726:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  802729:	48 83 c4 28          	add    $0x28,%rsp
  80272d:	5b                   	pop    %rbx
  80272e:	5d                   	pop    %rbp
  80272f:	c3                   	retq   

0000000000802730 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802730:	55                   	push   %rbp
  802731:	48 89 e5             	mov    %rsp,%rbp
  802734:	53                   	push   %rbx
  802735:	48 83 ec 38          	sub    $0x38,%rsp
  802739:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80273c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80273f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802743:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  802746:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  80274d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  802752:	75 0e                	jne    802762 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  802754:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80275b:	00 00 00 
  80275e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  802762:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802766:	48 c1 e8 0c          	shr    $0xc,%rax
  80276a:	48 89 c2             	mov    %rax,%rdx
  80276d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802774:	01 00 00 
  802777:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80277b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802781:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  802785:	b8 02 00 00 00       	mov    $0x2,%eax
  80278a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80278d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802790:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802794:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802797:	89 fb                	mov    %edi,%ebx
  802799:	0f 01 c1             	vmcall 
  80279c:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  80279f:	eb 26                	jmp    8027c7 <ipc_host_send+0x97>
		sys_yield();
  8027a1:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  8027a8:	00 00 00 
  8027ab:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8027ad:	b8 02 00 00 00       	mov    $0x2,%eax
  8027b2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8027b5:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8027b8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027bc:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8027bf:	89 fb                	mov    %edi,%ebx
  8027c1:	0f 01 c1             	vmcall 
  8027c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8027c7:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  8027cb:	74 d4                	je     8027a1 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  8027cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8027d1:	79 30                	jns    802803 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  8027d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027d6:	89 c1                	mov    %eax,%ecx
  8027d8:	48 ba 14 52 80 00 00 	movabs $0x805214,%rdx
  8027df:	00 00 00 
  8027e2:	be 79 00 00 00       	mov    $0x79,%esi
  8027e7:	48 bf 2a 52 80 00 00 	movabs $0x80522a,%rdi
  8027ee:	00 00 00 
  8027f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f6:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  8027fd:	00 00 00 
  802800:	41 ff d0             	callq  *%r8

}
  802803:	48 83 c4 38          	add    $0x38,%rsp
  802807:	5b                   	pop    %rbx
  802808:	5d                   	pop    %rbp
  802809:	c3                   	retq   

000000000080280a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80280a:	55                   	push   %rbp
  80280b:	48 89 e5             	mov    %rsp,%rbp
  80280e:	48 83 ec 14          	sub    $0x14,%rsp
  802812:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802815:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80281c:	eb 4e                	jmp    80286c <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  80281e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802825:	00 00 00 
  802828:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80282b:	48 98                	cltq   
  80282d:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802834:	48 01 d0             	add    %rdx,%rax
  802837:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80283d:	8b 00                	mov    (%rax),%eax
  80283f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802842:	75 24                	jne    802868 <ipc_find_env+0x5e>
			return envs[i].env_id;
  802844:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80284b:	00 00 00 
  80284e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802851:	48 98                	cltq   
  802853:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80285a:	48 01 d0             	add    %rdx,%rax
  80285d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802863:	8b 40 08             	mov    0x8(%rax),%eax
  802866:	eb 12                	jmp    80287a <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802868:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80286c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802873:	7e a9                	jle    80281e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802875:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80287a:	c9                   	leaveq 
  80287b:	c3                   	retq   

000000000080287c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80287c:	55                   	push   %rbp
  80287d:	48 89 e5             	mov    %rsp,%rbp
  802880:	48 83 ec 08          	sub    $0x8,%rsp
  802884:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802888:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80288c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802893:	ff ff ff 
  802896:	48 01 d0             	add    %rdx,%rax
  802899:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80289d:	c9                   	leaveq 
  80289e:	c3                   	retq   

000000000080289f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80289f:	55                   	push   %rbp
  8028a0:	48 89 e5             	mov    %rsp,%rbp
  8028a3:	48 83 ec 08          	sub    $0x8,%rsp
  8028a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8028ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028af:	48 89 c7             	mov    %rax,%rdi
  8028b2:	48 b8 7c 28 80 00 00 	movabs $0x80287c,%rax
  8028b9:	00 00 00 
  8028bc:	ff d0                	callq  *%rax
  8028be:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8028c4:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8028c8:	c9                   	leaveq 
  8028c9:	c3                   	retq   

00000000008028ca <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8028ca:	55                   	push   %rbp
  8028cb:	48 89 e5             	mov    %rsp,%rbp
  8028ce:	48 83 ec 18          	sub    $0x18,%rsp
  8028d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8028d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028dd:	eb 6b                	jmp    80294a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8028df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028e2:	48 98                	cltq   
  8028e4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028ea:	48 c1 e0 0c          	shl    $0xc,%rax
  8028ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8028f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028f6:	48 c1 e8 15          	shr    $0x15,%rax
  8028fa:	48 89 c2             	mov    %rax,%rdx
  8028fd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802904:	01 00 00 
  802907:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80290b:	83 e0 01             	and    $0x1,%eax
  80290e:	48 85 c0             	test   %rax,%rax
  802911:	74 21                	je     802934 <fd_alloc+0x6a>
  802913:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802917:	48 c1 e8 0c          	shr    $0xc,%rax
  80291b:	48 89 c2             	mov    %rax,%rdx
  80291e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802925:	01 00 00 
  802928:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80292c:	83 e0 01             	and    $0x1,%eax
  80292f:	48 85 c0             	test   %rax,%rax
  802932:	75 12                	jne    802946 <fd_alloc+0x7c>
			*fd_store = fd;
  802934:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802938:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80293c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80293f:	b8 00 00 00 00       	mov    $0x0,%eax
  802944:	eb 1a                	jmp    802960 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802946:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80294a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80294e:	7e 8f                	jle    8028df <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802950:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802954:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80295b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802960:	c9                   	leaveq 
  802961:	c3                   	retq   

0000000000802962 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802962:	55                   	push   %rbp
  802963:	48 89 e5             	mov    %rsp,%rbp
  802966:	48 83 ec 20          	sub    $0x20,%rsp
  80296a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80296d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802971:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802975:	78 06                	js     80297d <fd_lookup+0x1b>
  802977:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80297b:	7e 07                	jle    802984 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80297d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802982:	eb 6c                	jmp    8029f0 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802984:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802987:	48 98                	cltq   
  802989:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80298f:	48 c1 e0 0c          	shl    $0xc,%rax
  802993:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802997:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80299b:	48 c1 e8 15          	shr    $0x15,%rax
  80299f:	48 89 c2             	mov    %rax,%rdx
  8029a2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029a9:	01 00 00 
  8029ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029b0:	83 e0 01             	and    $0x1,%eax
  8029b3:	48 85 c0             	test   %rax,%rax
  8029b6:	74 21                	je     8029d9 <fd_lookup+0x77>
  8029b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029bc:	48 c1 e8 0c          	shr    $0xc,%rax
  8029c0:	48 89 c2             	mov    %rax,%rdx
  8029c3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029ca:	01 00 00 
  8029cd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029d1:	83 e0 01             	and    $0x1,%eax
  8029d4:	48 85 c0             	test   %rax,%rax
  8029d7:	75 07                	jne    8029e0 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8029d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029de:	eb 10                	jmp    8029f0 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8029e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029e4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8029e8:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8029eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029f0:	c9                   	leaveq 
  8029f1:	c3                   	retq   

00000000008029f2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8029f2:	55                   	push   %rbp
  8029f3:	48 89 e5             	mov    %rsp,%rbp
  8029f6:	48 83 ec 30          	sub    $0x30,%rsp
  8029fa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8029fe:	89 f0                	mov    %esi,%eax
  802a00:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802a03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a07:	48 89 c7             	mov    %rax,%rdi
  802a0a:	48 b8 7c 28 80 00 00 	movabs $0x80287c,%rax
  802a11:	00 00 00 
  802a14:	ff d0                	callq  *%rax
  802a16:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a1a:	48 89 d6             	mov    %rdx,%rsi
  802a1d:	89 c7                	mov    %eax,%edi
  802a1f:	48 b8 62 29 80 00 00 	movabs $0x802962,%rax
  802a26:	00 00 00 
  802a29:	ff d0                	callq  *%rax
  802a2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a32:	78 0a                	js     802a3e <fd_close+0x4c>
	    || fd != fd2)
  802a34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a38:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802a3c:	74 12                	je     802a50 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802a3e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802a42:	74 05                	je     802a49 <fd_close+0x57>
  802a44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a47:	eb 05                	jmp    802a4e <fd_close+0x5c>
  802a49:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4e:	eb 69                	jmp    802ab9 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802a50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a54:	8b 00                	mov    (%rax),%eax
  802a56:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a5a:	48 89 d6             	mov    %rdx,%rsi
  802a5d:	89 c7                	mov    %eax,%edi
  802a5f:	48 b8 bb 2a 80 00 00 	movabs $0x802abb,%rax
  802a66:	00 00 00 
  802a69:	ff d0                	callq  *%rax
  802a6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a72:	78 2a                	js     802a9e <fd_close+0xac>
		if (dev->dev_close)
  802a74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a78:	48 8b 40 20          	mov    0x20(%rax),%rax
  802a7c:	48 85 c0             	test   %rax,%rax
  802a7f:	74 16                	je     802a97 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802a81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a85:	48 8b 40 20          	mov    0x20(%rax),%rax
  802a89:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a8d:	48 89 d7             	mov    %rdx,%rdi
  802a90:	ff d0                	callq  *%rax
  802a92:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a95:	eb 07                	jmp    802a9e <fd_close+0xac>
		else
			r = 0;
  802a97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802a9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aa2:	48 89 c6             	mov    %rax,%rsi
  802aa5:	bf 00 00 00 00       	mov    $0x0,%edi
  802aaa:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  802ab1:	00 00 00 
  802ab4:	ff d0                	callq  *%rax
	return r;
  802ab6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ab9:	c9                   	leaveq 
  802aba:	c3                   	retq   

0000000000802abb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802abb:	55                   	push   %rbp
  802abc:	48 89 e5             	mov    %rsp,%rbp
  802abf:	48 83 ec 20          	sub    $0x20,%rsp
  802ac3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ac6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802aca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ad1:	eb 41                	jmp    802b14 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802ad3:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802ada:	00 00 00 
  802add:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ae0:	48 63 d2             	movslq %edx,%rdx
  802ae3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ae7:	8b 00                	mov    (%rax),%eax
  802ae9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802aec:	75 22                	jne    802b10 <dev_lookup+0x55>
			*dev = devtab[i];
  802aee:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802af5:	00 00 00 
  802af8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802afb:	48 63 d2             	movslq %edx,%rdx
  802afe:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802b02:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b06:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802b09:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0e:	eb 60                	jmp    802b70 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802b10:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b14:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802b1b:	00 00 00 
  802b1e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b21:	48 63 d2             	movslq %edx,%rdx
  802b24:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b28:	48 85 c0             	test   %rax,%rax
  802b2b:	75 a6                	jne    802ad3 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802b2d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802b34:	00 00 00 
  802b37:	48 8b 00             	mov    (%rax),%rax
  802b3a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b40:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802b43:	89 c6                	mov    %eax,%esi
  802b45:	48 bf 38 52 80 00 00 	movabs $0x805238,%rdi
  802b4c:	00 00 00 
  802b4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b54:	48 b9 64 06 80 00 00 	movabs $0x800664,%rcx
  802b5b:	00 00 00 
  802b5e:	ff d1                	callq  *%rcx
	*dev = 0;
  802b60:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b64:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802b6b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802b70:	c9                   	leaveq 
  802b71:	c3                   	retq   

0000000000802b72 <close>:

int
close(int fdnum)
{
  802b72:	55                   	push   %rbp
  802b73:	48 89 e5             	mov    %rsp,%rbp
  802b76:	48 83 ec 20          	sub    $0x20,%rsp
  802b7a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b7d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b81:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b84:	48 89 d6             	mov    %rdx,%rsi
  802b87:	89 c7                	mov    %eax,%edi
  802b89:	48 b8 62 29 80 00 00 	movabs $0x802962,%rax
  802b90:	00 00 00 
  802b93:	ff d0                	callq  *%rax
  802b95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b9c:	79 05                	jns    802ba3 <close+0x31>
		return r;
  802b9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba1:	eb 18                	jmp    802bbb <close+0x49>
	else
		return fd_close(fd, 1);
  802ba3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba7:	be 01 00 00 00       	mov    $0x1,%esi
  802bac:	48 89 c7             	mov    %rax,%rdi
  802baf:	48 b8 f2 29 80 00 00 	movabs $0x8029f2,%rax
  802bb6:	00 00 00 
  802bb9:	ff d0                	callq  *%rax
}
  802bbb:	c9                   	leaveq 
  802bbc:	c3                   	retq   

0000000000802bbd <close_all>:

void
close_all(void)
{
  802bbd:	55                   	push   %rbp
  802bbe:	48 89 e5             	mov    %rsp,%rbp
  802bc1:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802bc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bcc:	eb 15                	jmp    802be3 <close_all+0x26>
		close(i);
  802bce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd1:	89 c7                	mov    %eax,%edi
  802bd3:	48 b8 72 2b 80 00 00 	movabs $0x802b72,%rax
  802bda:	00 00 00 
  802bdd:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802bdf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802be3:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802be7:	7e e5                	jle    802bce <close_all+0x11>
		close(i);
}
  802be9:	c9                   	leaveq 
  802bea:	c3                   	retq   

0000000000802beb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802beb:	55                   	push   %rbp
  802bec:	48 89 e5             	mov    %rsp,%rbp
  802bef:	48 83 ec 40          	sub    $0x40,%rsp
  802bf3:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802bf6:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802bf9:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802bfd:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802c00:	48 89 d6             	mov    %rdx,%rsi
  802c03:	89 c7                	mov    %eax,%edi
  802c05:	48 b8 62 29 80 00 00 	movabs $0x802962,%rax
  802c0c:	00 00 00 
  802c0f:	ff d0                	callq  *%rax
  802c11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c18:	79 08                	jns    802c22 <dup+0x37>
		return r;
  802c1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c1d:	e9 70 01 00 00       	jmpq   802d92 <dup+0x1a7>
	close(newfdnum);
  802c22:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c25:	89 c7                	mov    %eax,%edi
  802c27:	48 b8 72 2b 80 00 00 	movabs $0x802b72,%rax
  802c2e:	00 00 00 
  802c31:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802c33:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c36:	48 98                	cltq   
  802c38:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802c3e:	48 c1 e0 0c          	shl    $0xc,%rax
  802c42:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802c46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c4a:	48 89 c7             	mov    %rax,%rdi
  802c4d:	48 b8 9f 28 80 00 00 	movabs $0x80289f,%rax
  802c54:	00 00 00 
  802c57:	ff d0                	callq  *%rax
  802c59:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802c5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c61:	48 89 c7             	mov    %rax,%rdi
  802c64:	48 b8 9f 28 80 00 00 	movabs $0x80289f,%rax
  802c6b:	00 00 00 
  802c6e:	ff d0                	callq  *%rax
  802c70:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802c74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c78:	48 c1 e8 15          	shr    $0x15,%rax
  802c7c:	48 89 c2             	mov    %rax,%rdx
  802c7f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802c86:	01 00 00 
  802c89:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c8d:	83 e0 01             	and    $0x1,%eax
  802c90:	48 85 c0             	test   %rax,%rax
  802c93:	74 73                	je     802d08 <dup+0x11d>
  802c95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c99:	48 c1 e8 0c          	shr    $0xc,%rax
  802c9d:	48 89 c2             	mov    %rax,%rdx
  802ca0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ca7:	01 00 00 
  802caa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cae:	83 e0 01             	and    $0x1,%eax
  802cb1:	48 85 c0             	test   %rax,%rax
  802cb4:	74 52                	je     802d08 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802cb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cba:	48 c1 e8 0c          	shr    $0xc,%rax
  802cbe:	48 89 c2             	mov    %rax,%rdx
  802cc1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cc8:	01 00 00 
  802ccb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ccf:	25 07 0e 00 00       	and    $0xe07,%eax
  802cd4:	89 c1                	mov    %eax,%ecx
  802cd6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cde:	41 89 c8             	mov    %ecx,%r8d
  802ce1:	48 89 d1             	mov    %rdx,%rcx
  802ce4:	ba 00 00 00 00       	mov    $0x0,%edx
  802ce9:	48 89 c6             	mov    %rax,%rsi
  802cec:	bf 00 00 00 00       	mov    $0x0,%edi
  802cf1:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  802cf8:	00 00 00 
  802cfb:	ff d0                	callq  *%rax
  802cfd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d04:	79 02                	jns    802d08 <dup+0x11d>
			goto err;
  802d06:	eb 57                	jmp    802d5f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802d08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d0c:	48 c1 e8 0c          	shr    $0xc,%rax
  802d10:	48 89 c2             	mov    %rax,%rdx
  802d13:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d1a:	01 00 00 
  802d1d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d21:	25 07 0e 00 00       	and    $0xe07,%eax
  802d26:	89 c1                	mov    %eax,%ecx
  802d28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d2c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d30:	41 89 c8             	mov    %ecx,%r8d
  802d33:	48 89 d1             	mov    %rdx,%rcx
  802d36:	ba 00 00 00 00       	mov    $0x0,%edx
  802d3b:	48 89 c6             	mov    %rax,%rsi
  802d3e:	bf 00 00 00 00       	mov    $0x0,%edi
  802d43:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  802d4a:	00 00 00 
  802d4d:	ff d0                	callq  *%rax
  802d4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d56:	79 02                	jns    802d5a <dup+0x16f>
		goto err;
  802d58:	eb 05                	jmp    802d5f <dup+0x174>

	return newfdnum;
  802d5a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d5d:	eb 33                	jmp    802d92 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802d5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d63:	48 89 c6             	mov    %rax,%rsi
  802d66:	bf 00 00 00 00       	mov    $0x0,%edi
  802d6b:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  802d72:	00 00 00 
  802d75:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802d77:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d7b:	48 89 c6             	mov    %rax,%rsi
  802d7e:	bf 00 00 00 00       	mov    $0x0,%edi
  802d83:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  802d8a:	00 00 00 
  802d8d:	ff d0                	callq  *%rax
	return r;
  802d8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d92:	c9                   	leaveq 
  802d93:	c3                   	retq   

0000000000802d94 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802d94:	55                   	push   %rbp
  802d95:	48 89 e5             	mov    %rsp,%rbp
  802d98:	48 83 ec 40          	sub    $0x40,%rsp
  802d9c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d9f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802da3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802da7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802dab:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802dae:	48 89 d6             	mov    %rdx,%rsi
  802db1:	89 c7                	mov    %eax,%edi
  802db3:	48 b8 62 29 80 00 00 	movabs $0x802962,%rax
  802dba:	00 00 00 
  802dbd:	ff d0                	callq  *%rax
  802dbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc6:	78 24                	js     802dec <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802dc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dcc:	8b 00                	mov    (%rax),%eax
  802dce:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dd2:	48 89 d6             	mov    %rdx,%rsi
  802dd5:	89 c7                	mov    %eax,%edi
  802dd7:	48 b8 bb 2a 80 00 00 	movabs $0x802abb,%rax
  802dde:	00 00 00 
  802de1:	ff d0                	callq  *%rax
  802de3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802de6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dea:	79 05                	jns    802df1 <read+0x5d>
		return r;
  802dec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802def:	eb 76                	jmp    802e67 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802df1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802df5:	8b 40 08             	mov    0x8(%rax),%eax
  802df8:	83 e0 03             	and    $0x3,%eax
  802dfb:	83 f8 01             	cmp    $0x1,%eax
  802dfe:	75 3a                	jne    802e3a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802e00:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802e07:	00 00 00 
  802e0a:	48 8b 00             	mov    (%rax),%rax
  802e0d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e13:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e16:	89 c6                	mov    %eax,%esi
  802e18:	48 bf 57 52 80 00 00 	movabs $0x805257,%rdi
  802e1f:	00 00 00 
  802e22:	b8 00 00 00 00       	mov    $0x0,%eax
  802e27:	48 b9 64 06 80 00 00 	movabs $0x800664,%rcx
  802e2e:	00 00 00 
  802e31:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802e33:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e38:	eb 2d                	jmp    802e67 <read+0xd3>
	}
	if (!dev->dev_read)
  802e3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e3e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802e42:	48 85 c0             	test   %rax,%rax
  802e45:	75 07                	jne    802e4e <read+0xba>
		return -E_NOT_SUPP;
  802e47:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e4c:	eb 19                	jmp    802e67 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802e4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e52:	48 8b 40 10          	mov    0x10(%rax),%rax
  802e56:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802e5a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e5e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802e62:	48 89 cf             	mov    %rcx,%rdi
  802e65:	ff d0                	callq  *%rax
}
  802e67:	c9                   	leaveq 
  802e68:	c3                   	retq   

0000000000802e69 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802e69:	55                   	push   %rbp
  802e6a:	48 89 e5             	mov    %rsp,%rbp
  802e6d:	48 83 ec 30          	sub    $0x30,%rsp
  802e71:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e74:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e78:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e83:	eb 49                	jmp    802ece <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802e85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e88:	48 98                	cltq   
  802e8a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e8e:	48 29 c2             	sub    %rax,%rdx
  802e91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e94:	48 63 c8             	movslq %eax,%rcx
  802e97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e9b:	48 01 c1             	add    %rax,%rcx
  802e9e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ea1:	48 89 ce             	mov    %rcx,%rsi
  802ea4:	89 c7                	mov    %eax,%edi
  802ea6:	48 b8 94 2d 80 00 00 	movabs $0x802d94,%rax
  802ead:	00 00 00 
  802eb0:	ff d0                	callq  *%rax
  802eb2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802eb5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802eb9:	79 05                	jns    802ec0 <readn+0x57>
			return m;
  802ebb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ebe:	eb 1c                	jmp    802edc <readn+0x73>
		if (m == 0)
  802ec0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ec4:	75 02                	jne    802ec8 <readn+0x5f>
			break;
  802ec6:	eb 11                	jmp    802ed9 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ec8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ecb:	01 45 fc             	add    %eax,-0x4(%rbp)
  802ece:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed1:	48 98                	cltq   
  802ed3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802ed7:	72 ac                	jb     802e85 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802ed9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802edc:	c9                   	leaveq 
  802edd:	c3                   	retq   

0000000000802ede <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802ede:	55                   	push   %rbp
  802edf:	48 89 e5             	mov    %rsp,%rbp
  802ee2:	48 83 ec 40          	sub    $0x40,%rsp
  802ee6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ee9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802eed:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ef1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ef5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ef8:	48 89 d6             	mov    %rdx,%rsi
  802efb:	89 c7                	mov    %eax,%edi
  802efd:	48 b8 62 29 80 00 00 	movabs $0x802962,%rax
  802f04:	00 00 00 
  802f07:	ff d0                	callq  *%rax
  802f09:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f10:	78 24                	js     802f36 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f16:	8b 00                	mov    (%rax),%eax
  802f18:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f1c:	48 89 d6             	mov    %rdx,%rsi
  802f1f:	89 c7                	mov    %eax,%edi
  802f21:	48 b8 bb 2a 80 00 00 	movabs $0x802abb,%rax
  802f28:	00 00 00 
  802f2b:	ff d0                	callq  *%rax
  802f2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f34:	79 05                	jns    802f3b <write+0x5d>
		return r;
  802f36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f39:	eb 75                	jmp    802fb0 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f3f:	8b 40 08             	mov    0x8(%rax),%eax
  802f42:	83 e0 03             	and    $0x3,%eax
  802f45:	85 c0                	test   %eax,%eax
  802f47:	75 3a                	jne    802f83 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802f49:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802f50:	00 00 00 
  802f53:	48 8b 00             	mov    (%rax),%rax
  802f56:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f5c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f5f:	89 c6                	mov    %eax,%esi
  802f61:	48 bf 73 52 80 00 00 	movabs $0x805273,%rdi
  802f68:	00 00 00 
  802f6b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f70:	48 b9 64 06 80 00 00 	movabs $0x800664,%rcx
  802f77:	00 00 00 
  802f7a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802f7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f81:	eb 2d                	jmp    802fb0 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802f83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f87:	48 8b 40 18          	mov    0x18(%rax),%rax
  802f8b:	48 85 c0             	test   %rax,%rax
  802f8e:	75 07                	jne    802f97 <write+0xb9>
		return -E_NOT_SUPP;
  802f90:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f95:	eb 19                	jmp    802fb0 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802f97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f9b:	48 8b 40 18          	mov    0x18(%rax),%rax
  802f9f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802fa3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802fa7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802fab:	48 89 cf             	mov    %rcx,%rdi
  802fae:	ff d0                	callq  *%rax
}
  802fb0:	c9                   	leaveq 
  802fb1:	c3                   	retq   

0000000000802fb2 <seek>:

int
seek(int fdnum, off_t offset)
{
  802fb2:	55                   	push   %rbp
  802fb3:	48 89 e5             	mov    %rsp,%rbp
  802fb6:	48 83 ec 18          	sub    $0x18,%rsp
  802fba:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fbd:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fc0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fc4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fc7:	48 89 d6             	mov    %rdx,%rsi
  802fca:	89 c7                	mov    %eax,%edi
  802fcc:	48 b8 62 29 80 00 00 	movabs $0x802962,%rax
  802fd3:	00 00 00 
  802fd6:	ff d0                	callq  *%rax
  802fd8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fdb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fdf:	79 05                	jns    802fe6 <seek+0x34>
		return r;
  802fe1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe4:	eb 0f                	jmp    802ff5 <seek+0x43>
	fd->fd_offset = offset;
  802fe6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fea:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fed:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802ff0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ff5:	c9                   	leaveq 
  802ff6:	c3                   	retq   

0000000000802ff7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802ff7:	55                   	push   %rbp
  802ff8:	48 89 e5             	mov    %rsp,%rbp
  802ffb:	48 83 ec 30          	sub    $0x30,%rsp
  802fff:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803002:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803005:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803009:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80300c:	48 89 d6             	mov    %rdx,%rsi
  80300f:	89 c7                	mov    %eax,%edi
  803011:	48 b8 62 29 80 00 00 	movabs $0x802962,%rax
  803018:	00 00 00 
  80301b:	ff d0                	callq  *%rax
  80301d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803020:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803024:	78 24                	js     80304a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803026:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80302a:	8b 00                	mov    (%rax),%eax
  80302c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803030:	48 89 d6             	mov    %rdx,%rsi
  803033:	89 c7                	mov    %eax,%edi
  803035:	48 b8 bb 2a 80 00 00 	movabs $0x802abb,%rax
  80303c:	00 00 00 
  80303f:	ff d0                	callq  *%rax
  803041:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803044:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803048:	79 05                	jns    80304f <ftruncate+0x58>
		return r;
  80304a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80304d:	eb 72                	jmp    8030c1 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80304f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803053:	8b 40 08             	mov    0x8(%rax),%eax
  803056:	83 e0 03             	and    $0x3,%eax
  803059:	85 c0                	test   %eax,%eax
  80305b:	75 3a                	jne    803097 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80305d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803064:	00 00 00 
  803067:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80306a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803070:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803073:	89 c6                	mov    %eax,%esi
  803075:	48 bf 90 52 80 00 00 	movabs $0x805290,%rdi
  80307c:	00 00 00 
  80307f:	b8 00 00 00 00       	mov    $0x0,%eax
  803084:	48 b9 64 06 80 00 00 	movabs $0x800664,%rcx
  80308b:	00 00 00 
  80308e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803090:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803095:	eb 2a                	jmp    8030c1 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803097:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80309b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80309f:	48 85 c0             	test   %rax,%rax
  8030a2:	75 07                	jne    8030ab <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8030a4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030a9:	eb 16                	jmp    8030c1 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8030ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030af:	48 8b 40 30          	mov    0x30(%rax),%rax
  8030b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030b7:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8030ba:	89 ce                	mov    %ecx,%esi
  8030bc:	48 89 d7             	mov    %rdx,%rdi
  8030bf:	ff d0                	callq  *%rax
}
  8030c1:	c9                   	leaveq 
  8030c2:	c3                   	retq   

00000000008030c3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8030c3:	55                   	push   %rbp
  8030c4:	48 89 e5             	mov    %rsp,%rbp
  8030c7:	48 83 ec 30          	sub    $0x30,%rsp
  8030cb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8030ce:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030d2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8030d6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8030d9:	48 89 d6             	mov    %rdx,%rsi
  8030dc:	89 c7                	mov    %eax,%edi
  8030de:	48 b8 62 29 80 00 00 	movabs $0x802962,%rax
  8030e5:	00 00 00 
  8030e8:	ff d0                	callq  *%rax
  8030ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030f1:	78 24                	js     803117 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8030f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030f7:	8b 00                	mov    (%rax),%eax
  8030f9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030fd:	48 89 d6             	mov    %rdx,%rsi
  803100:	89 c7                	mov    %eax,%edi
  803102:	48 b8 bb 2a 80 00 00 	movabs $0x802abb,%rax
  803109:	00 00 00 
  80310c:	ff d0                	callq  *%rax
  80310e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803111:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803115:	79 05                	jns    80311c <fstat+0x59>
		return r;
  803117:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80311a:	eb 5e                	jmp    80317a <fstat+0xb7>
	if (!dev->dev_stat)
  80311c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803120:	48 8b 40 28          	mov    0x28(%rax),%rax
  803124:	48 85 c0             	test   %rax,%rax
  803127:	75 07                	jne    803130 <fstat+0x6d>
		return -E_NOT_SUPP;
  803129:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80312e:	eb 4a                	jmp    80317a <fstat+0xb7>
	stat->st_name[0] = 0;
  803130:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803134:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803137:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80313b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803142:	00 00 00 
	stat->st_isdir = 0;
  803145:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803149:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803150:	00 00 00 
	stat->st_dev = dev;
  803153:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803157:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80315b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803162:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803166:	48 8b 40 28          	mov    0x28(%rax),%rax
  80316a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80316e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803172:	48 89 ce             	mov    %rcx,%rsi
  803175:	48 89 d7             	mov    %rdx,%rdi
  803178:	ff d0                	callq  *%rax
}
  80317a:	c9                   	leaveq 
  80317b:	c3                   	retq   

000000000080317c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80317c:	55                   	push   %rbp
  80317d:	48 89 e5             	mov    %rsp,%rbp
  803180:	48 83 ec 20          	sub    $0x20,%rsp
  803184:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803188:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80318c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803190:	be 00 00 00 00       	mov    $0x0,%esi
  803195:	48 89 c7             	mov    %rax,%rdi
  803198:	48 b8 6a 32 80 00 00 	movabs $0x80326a,%rax
  80319f:	00 00 00 
  8031a2:	ff d0                	callq  *%rax
  8031a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031ab:	79 05                	jns    8031b2 <stat+0x36>
		return fd;
  8031ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b0:	eb 2f                	jmp    8031e1 <stat+0x65>
	r = fstat(fd, stat);
  8031b2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8031b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b9:	48 89 d6             	mov    %rdx,%rsi
  8031bc:	89 c7                	mov    %eax,%edi
  8031be:	48 b8 c3 30 80 00 00 	movabs $0x8030c3,%rax
  8031c5:	00 00 00 
  8031c8:	ff d0                	callq  *%rax
  8031ca:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8031cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d0:	89 c7                	mov    %eax,%edi
  8031d2:	48 b8 72 2b 80 00 00 	movabs $0x802b72,%rax
  8031d9:	00 00 00 
  8031dc:	ff d0                	callq  *%rax
	return r;
  8031de:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8031e1:	c9                   	leaveq 
  8031e2:	c3                   	retq   

00000000008031e3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8031e3:	55                   	push   %rbp
  8031e4:	48 89 e5             	mov    %rsp,%rbp
  8031e7:	48 83 ec 10          	sub    $0x10,%rsp
  8031eb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8031ee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8031f2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031f9:	00 00 00 
  8031fc:	8b 00                	mov    (%rax),%eax
  8031fe:	85 c0                	test   %eax,%eax
  803200:	75 1d                	jne    80321f <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803202:	bf 01 00 00 00       	mov    $0x1,%edi
  803207:	48 b8 0a 28 80 00 00 	movabs $0x80280a,%rax
  80320e:	00 00 00 
  803211:	ff d0                	callq  *%rax
  803213:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80321a:	00 00 00 
  80321d:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80321f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803226:	00 00 00 
  803229:	8b 00                	mov    (%rax),%eax
  80322b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80322e:	b9 07 00 00 00       	mov    $0x7,%ecx
  803233:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  80323a:	00 00 00 
  80323d:	89 c7                	mov    %eax,%edi
  80323f:	48 b8 fe 25 80 00 00 	movabs $0x8025fe,%rax
  803246:	00 00 00 
  803249:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80324b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80324f:	ba 00 00 00 00       	mov    $0x0,%edx
  803254:	48 89 c6             	mov    %rax,%rsi
  803257:	bf 00 00 00 00       	mov    $0x0,%edi
  80325c:	48 b8 3d 25 80 00 00 	movabs $0x80253d,%rax
  803263:	00 00 00 
  803266:	ff d0                	callq  *%rax
}
  803268:	c9                   	leaveq 
  803269:	c3                   	retq   

000000000080326a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80326a:	55                   	push   %rbp
  80326b:	48 89 e5             	mov    %rsp,%rbp
  80326e:	48 83 ec 20          	sub    $0x20,%rsp
  803272:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803276:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  803279:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80327d:	48 89 c7             	mov    %rax,%rdi
  803280:	48 b8 ad 11 80 00 00 	movabs $0x8011ad,%rax
  803287:	00 00 00 
  80328a:	ff d0                	callq  *%rax
  80328c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803291:	7e 0a                	jle    80329d <open+0x33>
		return -E_BAD_PATH;
  803293:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803298:	e9 a5 00 00 00       	jmpq   803342 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80329d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8032a1:	48 89 c7             	mov    %rax,%rdi
  8032a4:	48 b8 ca 28 80 00 00 	movabs $0x8028ca,%rax
  8032ab:	00 00 00 
  8032ae:	ff d0                	callq  *%rax
  8032b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032b7:	79 08                	jns    8032c1 <open+0x57>
		return r;
  8032b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032bc:	e9 81 00 00 00       	jmpq   803342 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8032c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032c5:	48 89 c6             	mov    %rax,%rsi
  8032c8:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8032cf:	00 00 00 
  8032d2:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  8032d9:	00 00 00 
  8032dc:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8032de:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032e5:	00 00 00 
  8032e8:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8032eb:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8032f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f5:	48 89 c6             	mov    %rax,%rsi
  8032f8:	bf 01 00 00 00       	mov    $0x1,%edi
  8032fd:	48 b8 e3 31 80 00 00 	movabs $0x8031e3,%rax
  803304:	00 00 00 
  803307:	ff d0                	callq  *%rax
  803309:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80330c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803310:	79 1d                	jns    80332f <open+0xc5>
		fd_close(fd, 0);
  803312:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803316:	be 00 00 00 00       	mov    $0x0,%esi
  80331b:	48 89 c7             	mov    %rax,%rdi
  80331e:	48 b8 f2 29 80 00 00 	movabs $0x8029f2,%rax
  803325:	00 00 00 
  803328:	ff d0                	callq  *%rax
		return r;
  80332a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80332d:	eb 13                	jmp    803342 <open+0xd8>
	}

	return fd2num(fd);
  80332f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803333:	48 89 c7             	mov    %rax,%rdi
  803336:	48 b8 7c 28 80 00 00 	movabs $0x80287c,%rax
  80333d:	00 00 00 
  803340:	ff d0                	callq  *%rax

}
  803342:	c9                   	leaveq 
  803343:	c3                   	retq   

0000000000803344 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803344:	55                   	push   %rbp
  803345:	48 89 e5             	mov    %rsp,%rbp
  803348:	48 83 ec 10          	sub    $0x10,%rsp
  80334c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803350:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803354:	8b 50 0c             	mov    0xc(%rax),%edx
  803357:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80335e:	00 00 00 
  803361:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803363:	be 00 00 00 00       	mov    $0x0,%esi
  803368:	bf 06 00 00 00       	mov    $0x6,%edi
  80336d:	48 b8 e3 31 80 00 00 	movabs $0x8031e3,%rax
  803374:	00 00 00 
  803377:	ff d0                	callq  *%rax
}
  803379:	c9                   	leaveq 
  80337a:	c3                   	retq   

000000000080337b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80337b:	55                   	push   %rbp
  80337c:	48 89 e5             	mov    %rsp,%rbp
  80337f:	48 83 ec 30          	sub    $0x30,%rsp
  803383:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803387:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80338b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80338f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803393:	8b 50 0c             	mov    0xc(%rax),%edx
  803396:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80339d:	00 00 00 
  8033a0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8033a2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033a9:	00 00 00 
  8033ac:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8033b0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8033b4:	be 00 00 00 00       	mov    $0x0,%esi
  8033b9:	bf 03 00 00 00       	mov    $0x3,%edi
  8033be:	48 b8 e3 31 80 00 00 	movabs $0x8031e3,%rax
  8033c5:	00 00 00 
  8033c8:	ff d0                	callq  *%rax
  8033ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033d1:	79 08                	jns    8033db <devfile_read+0x60>
		return r;
  8033d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d6:	e9 a4 00 00 00       	jmpq   80347f <devfile_read+0x104>
	assert(r <= n);
  8033db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033de:	48 98                	cltq   
  8033e0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8033e4:	76 35                	jbe    80341b <devfile_read+0xa0>
  8033e6:	48 b9 b6 52 80 00 00 	movabs $0x8052b6,%rcx
  8033ed:	00 00 00 
  8033f0:	48 ba bd 52 80 00 00 	movabs $0x8052bd,%rdx
  8033f7:	00 00 00 
  8033fa:	be 86 00 00 00       	mov    $0x86,%esi
  8033ff:	48 bf d2 52 80 00 00 	movabs $0x8052d2,%rdi
  803406:	00 00 00 
  803409:	b8 00 00 00 00       	mov    $0x0,%eax
  80340e:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  803415:	00 00 00 
  803418:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  80341b:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  803422:	7e 35                	jle    803459 <devfile_read+0xde>
  803424:	48 b9 dd 52 80 00 00 	movabs $0x8052dd,%rcx
  80342b:	00 00 00 
  80342e:	48 ba bd 52 80 00 00 	movabs $0x8052bd,%rdx
  803435:	00 00 00 
  803438:	be 87 00 00 00       	mov    $0x87,%esi
  80343d:	48 bf d2 52 80 00 00 	movabs $0x8052d2,%rdi
  803444:	00 00 00 
  803447:	b8 00 00 00 00       	mov    $0x0,%eax
  80344c:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  803453:	00 00 00 
  803456:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  803459:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80345c:	48 63 d0             	movslq %eax,%rdx
  80345f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803463:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80346a:	00 00 00 
  80346d:	48 89 c7             	mov    %rax,%rdi
  803470:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  803477:	00 00 00 
  80347a:	ff d0                	callq  *%rax
	return r;
  80347c:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  80347f:	c9                   	leaveq 
  803480:	c3                   	retq   

0000000000803481 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803481:	55                   	push   %rbp
  803482:	48 89 e5             	mov    %rsp,%rbp
  803485:	48 83 ec 40          	sub    $0x40,%rsp
  803489:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80348d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803491:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  803495:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803499:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80349d:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  8034a4:	00 
  8034a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034a9:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8034ad:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  8034b2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8034b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034ba:	8b 50 0c             	mov    0xc(%rax),%edx
  8034bd:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8034c4:	00 00 00 
  8034c7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8034c9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8034d0:	00 00 00 
  8034d3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8034d7:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8034db:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8034df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034e3:	48 89 c6             	mov    %rax,%rsi
  8034e6:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  8034ed:	00 00 00 
  8034f0:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  8034f7:	00 00 00 
  8034fa:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8034fc:	be 00 00 00 00       	mov    $0x0,%esi
  803501:	bf 04 00 00 00       	mov    $0x4,%edi
  803506:	48 b8 e3 31 80 00 00 	movabs $0x8031e3,%rax
  80350d:	00 00 00 
  803510:	ff d0                	callq  *%rax
  803512:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803515:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803519:	79 05                	jns    803520 <devfile_write+0x9f>
		return r;
  80351b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80351e:	eb 43                	jmp    803563 <devfile_write+0xe2>
	assert(r <= n);
  803520:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803523:	48 98                	cltq   
  803525:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803529:	76 35                	jbe    803560 <devfile_write+0xdf>
  80352b:	48 b9 b6 52 80 00 00 	movabs $0x8052b6,%rcx
  803532:	00 00 00 
  803535:	48 ba bd 52 80 00 00 	movabs $0x8052bd,%rdx
  80353c:	00 00 00 
  80353f:	be a2 00 00 00       	mov    $0xa2,%esi
  803544:	48 bf d2 52 80 00 00 	movabs $0x8052d2,%rdi
  80354b:	00 00 00 
  80354e:	b8 00 00 00 00       	mov    $0x0,%eax
  803553:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  80355a:	00 00 00 
  80355d:	41 ff d0             	callq  *%r8
	return r;
  803560:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  803563:	c9                   	leaveq 
  803564:	c3                   	retq   

0000000000803565 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803565:	55                   	push   %rbp
  803566:	48 89 e5             	mov    %rsp,%rbp
  803569:	48 83 ec 20          	sub    $0x20,%rsp
  80356d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803571:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803575:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803579:	8b 50 0c             	mov    0xc(%rax),%edx
  80357c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803583:	00 00 00 
  803586:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803588:	be 00 00 00 00       	mov    $0x0,%esi
  80358d:	bf 05 00 00 00       	mov    $0x5,%edi
  803592:	48 b8 e3 31 80 00 00 	movabs $0x8031e3,%rax
  803599:	00 00 00 
  80359c:	ff d0                	callq  *%rax
  80359e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035a5:	79 05                	jns    8035ac <devfile_stat+0x47>
		return r;
  8035a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035aa:	eb 56                	jmp    803602 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8035ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035b0:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8035b7:	00 00 00 
  8035ba:	48 89 c7             	mov    %rax,%rdi
  8035bd:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  8035c4:	00 00 00 
  8035c7:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8035c9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035d0:	00 00 00 
  8035d3:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8035d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035dd:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8035e3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035ea:	00 00 00 
  8035ed:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8035f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035f7:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8035fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803602:	c9                   	leaveq 
  803603:	c3                   	retq   

0000000000803604 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803604:	55                   	push   %rbp
  803605:	48 89 e5             	mov    %rsp,%rbp
  803608:	48 83 ec 10          	sub    $0x10,%rsp
  80360c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803610:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803613:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803617:	8b 50 0c             	mov    0xc(%rax),%edx
  80361a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803621:	00 00 00 
  803624:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803626:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80362d:	00 00 00 
  803630:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803633:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803636:	be 00 00 00 00       	mov    $0x0,%esi
  80363b:	bf 02 00 00 00       	mov    $0x2,%edi
  803640:	48 b8 e3 31 80 00 00 	movabs $0x8031e3,%rax
  803647:	00 00 00 
  80364a:	ff d0                	callq  *%rax
}
  80364c:	c9                   	leaveq 
  80364d:	c3                   	retq   

000000000080364e <remove>:

// Delete a file
int
remove(const char *path)
{
  80364e:	55                   	push   %rbp
  80364f:	48 89 e5             	mov    %rsp,%rbp
  803652:	48 83 ec 10          	sub    $0x10,%rsp
  803656:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80365a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80365e:	48 89 c7             	mov    %rax,%rdi
  803661:	48 b8 ad 11 80 00 00 	movabs $0x8011ad,%rax
  803668:	00 00 00 
  80366b:	ff d0                	callq  *%rax
  80366d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803672:	7e 07                	jle    80367b <remove+0x2d>
		return -E_BAD_PATH;
  803674:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803679:	eb 33                	jmp    8036ae <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80367b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80367f:	48 89 c6             	mov    %rax,%rsi
  803682:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803689:	00 00 00 
  80368c:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  803693:	00 00 00 
  803696:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803698:	be 00 00 00 00       	mov    $0x0,%esi
  80369d:	bf 07 00 00 00       	mov    $0x7,%edi
  8036a2:	48 b8 e3 31 80 00 00 	movabs $0x8031e3,%rax
  8036a9:	00 00 00 
  8036ac:	ff d0                	callq  *%rax
}
  8036ae:	c9                   	leaveq 
  8036af:	c3                   	retq   

00000000008036b0 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8036b0:	55                   	push   %rbp
  8036b1:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8036b4:	be 00 00 00 00       	mov    $0x0,%esi
  8036b9:	bf 08 00 00 00       	mov    $0x8,%edi
  8036be:	48 b8 e3 31 80 00 00 	movabs $0x8031e3,%rax
  8036c5:	00 00 00 
  8036c8:	ff d0                	callq  *%rax
}
  8036ca:	5d                   	pop    %rbp
  8036cb:	c3                   	retq   

00000000008036cc <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8036cc:	55                   	push   %rbp
  8036cd:	48 89 e5             	mov    %rsp,%rbp
  8036d0:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8036d7:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8036de:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8036e5:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8036ec:	be 00 00 00 00       	mov    $0x0,%esi
  8036f1:	48 89 c7             	mov    %rax,%rdi
  8036f4:	48 b8 6a 32 80 00 00 	movabs $0x80326a,%rax
  8036fb:	00 00 00 
  8036fe:	ff d0                	callq  *%rax
  803700:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803703:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803707:	79 28                	jns    803731 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803709:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80370c:	89 c6                	mov    %eax,%esi
  80370e:	48 bf e9 52 80 00 00 	movabs $0x8052e9,%rdi
  803715:	00 00 00 
  803718:	b8 00 00 00 00       	mov    $0x0,%eax
  80371d:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  803724:	00 00 00 
  803727:	ff d2                	callq  *%rdx
		return fd_src;
  803729:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80372c:	e9 74 01 00 00       	jmpq   8038a5 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803731:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803738:	be 01 01 00 00       	mov    $0x101,%esi
  80373d:	48 89 c7             	mov    %rax,%rdi
  803740:	48 b8 6a 32 80 00 00 	movabs $0x80326a,%rax
  803747:	00 00 00 
  80374a:	ff d0                	callq  *%rax
  80374c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80374f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803753:	79 39                	jns    80378e <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803755:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803758:	89 c6                	mov    %eax,%esi
  80375a:	48 bf ff 52 80 00 00 	movabs $0x8052ff,%rdi
  803761:	00 00 00 
  803764:	b8 00 00 00 00       	mov    $0x0,%eax
  803769:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  803770:	00 00 00 
  803773:	ff d2                	callq  *%rdx
		close(fd_src);
  803775:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803778:	89 c7                	mov    %eax,%edi
  80377a:	48 b8 72 2b 80 00 00 	movabs $0x802b72,%rax
  803781:	00 00 00 
  803784:	ff d0                	callq  *%rax
		return fd_dest;
  803786:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803789:	e9 17 01 00 00       	jmpq   8038a5 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80378e:	eb 74                	jmp    803804 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803790:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803793:	48 63 d0             	movslq %eax,%rdx
  803796:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80379d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037a0:	48 89 ce             	mov    %rcx,%rsi
  8037a3:	89 c7                	mov    %eax,%edi
  8037a5:	48 b8 de 2e 80 00 00 	movabs $0x802ede,%rax
  8037ac:	00 00 00 
  8037af:	ff d0                	callq  *%rax
  8037b1:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8037b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8037b8:	79 4a                	jns    803804 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8037ba:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8037bd:	89 c6                	mov    %eax,%esi
  8037bf:	48 bf 19 53 80 00 00 	movabs $0x805319,%rdi
  8037c6:	00 00 00 
  8037c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ce:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  8037d5:	00 00 00 
  8037d8:	ff d2                	callq  *%rdx
			close(fd_src);
  8037da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037dd:	89 c7                	mov    %eax,%edi
  8037df:	48 b8 72 2b 80 00 00 	movabs $0x802b72,%rax
  8037e6:	00 00 00 
  8037e9:	ff d0                	callq  *%rax
			close(fd_dest);
  8037eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037ee:	89 c7                	mov    %eax,%edi
  8037f0:	48 b8 72 2b 80 00 00 	movabs $0x802b72,%rax
  8037f7:	00 00 00 
  8037fa:	ff d0                	callq  *%rax
			return write_size;
  8037fc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8037ff:	e9 a1 00 00 00       	jmpq   8038a5 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803804:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80380b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80380e:	ba 00 02 00 00       	mov    $0x200,%edx
  803813:	48 89 ce             	mov    %rcx,%rsi
  803816:	89 c7                	mov    %eax,%edi
  803818:	48 b8 94 2d 80 00 00 	movabs $0x802d94,%rax
  80381f:	00 00 00 
  803822:	ff d0                	callq  *%rax
  803824:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803827:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80382b:	0f 8f 5f ff ff ff    	jg     803790 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803831:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803835:	79 47                	jns    80387e <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803837:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80383a:	89 c6                	mov    %eax,%esi
  80383c:	48 bf 2c 53 80 00 00 	movabs $0x80532c,%rdi
  803843:	00 00 00 
  803846:	b8 00 00 00 00       	mov    $0x0,%eax
  80384b:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  803852:	00 00 00 
  803855:	ff d2                	callq  *%rdx
		close(fd_src);
  803857:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80385a:	89 c7                	mov    %eax,%edi
  80385c:	48 b8 72 2b 80 00 00 	movabs $0x802b72,%rax
  803863:	00 00 00 
  803866:	ff d0                	callq  *%rax
		close(fd_dest);
  803868:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80386b:	89 c7                	mov    %eax,%edi
  80386d:	48 b8 72 2b 80 00 00 	movabs $0x802b72,%rax
  803874:	00 00 00 
  803877:	ff d0                	callq  *%rax
		return read_size;
  803879:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80387c:	eb 27                	jmp    8038a5 <copy+0x1d9>
	}
	close(fd_src);
  80387e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803881:	89 c7                	mov    %eax,%edi
  803883:	48 b8 72 2b 80 00 00 	movabs $0x802b72,%rax
  80388a:	00 00 00 
  80388d:	ff d0                	callq  *%rax
	close(fd_dest);
  80388f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803892:	89 c7                	mov    %eax,%edi
  803894:	48 b8 72 2b 80 00 00 	movabs $0x802b72,%rax
  80389b:	00 00 00 
  80389e:	ff d0                	callq  *%rax
	return 0;
  8038a0:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8038a5:	c9                   	leaveq 
  8038a6:	c3                   	retq   

00000000008038a7 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  8038a7:	55                   	push   %rbp
  8038a8:	48 89 e5             	mov    %rsp,%rbp
  8038ab:	48 83 ec 18          	sub    $0x18,%rsp
  8038af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8038b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038b7:	48 c1 e8 15          	shr    $0x15,%rax
  8038bb:	48 89 c2             	mov    %rax,%rdx
  8038be:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8038c5:	01 00 00 
  8038c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038cc:	83 e0 01             	and    $0x1,%eax
  8038cf:	48 85 c0             	test   %rax,%rax
  8038d2:	75 07                	jne    8038db <pageref+0x34>
		return 0;
  8038d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8038d9:	eb 53                	jmp    80392e <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8038db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038df:	48 c1 e8 0c          	shr    $0xc,%rax
  8038e3:	48 89 c2             	mov    %rax,%rdx
  8038e6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8038ed:	01 00 00 
  8038f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8038f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038fc:	83 e0 01             	and    $0x1,%eax
  8038ff:	48 85 c0             	test   %rax,%rax
  803902:	75 07                	jne    80390b <pageref+0x64>
		return 0;
  803904:	b8 00 00 00 00       	mov    $0x0,%eax
  803909:	eb 23                	jmp    80392e <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80390b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80390f:	48 c1 e8 0c          	shr    $0xc,%rax
  803913:	48 89 c2             	mov    %rax,%rdx
  803916:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80391d:	00 00 00 
  803920:	48 c1 e2 04          	shl    $0x4,%rdx
  803924:	48 01 d0             	add    %rdx,%rax
  803927:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80392b:	0f b7 c0             	movzwl %ax,%eax
}
  80392e:	c9                   	leaveq 
  80392f:	c3                   	retq   

0000000000803930 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803930:	55                   	push   %rbp
  803931:	48 89 e5             	mov    %rsp,%rbp
  803934:	48 83 ec 20          	sub    $0x20,%rsp
  803938:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80393b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80393f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803942:	48 89 d6             	mov    %rdx,%rsi
  803945:	89 c7                	mov    %eax,%edi
  803947:	48 b8 62 29 80 00 00 	movabs $0x802962,%rax
  80394e:	00 00 00 
  803951:	ff d0                	callq  *%rax
  803953:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803956:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80395a:	79 05                	jns    803961 <fd2sockid+0x31>
		return r;
  80395c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80395f:	eb 24                	jmp    803985 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803961:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803965:	8b 10                	mov    (%rax),%edx
  803967:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  80396e:	00 00 00 
  803971:	8b 00                	mov    (%rax),%eax
  803973:	39 c2                	cmp    %eax,%edx
  803975:	74 07                	je     80397e <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803977:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80397c:	eb 07                	jmp    803985 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80397e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803982:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803985:	c9                   	leaveq 
  803986:	c3                   	retq   

0000000000803987 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803987:	55                   	push   %rbp
  803988:	48 89 e5             	mov    %rsp,%rbp
  80398b:	48 83 ec 20          	sub    $0x20,%rsp
  80398f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803992:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803996:	48 89 c7             	mov    %rax,%rdi
  803999:	48 b8 ca 28 80 00 00 	movabs $0x8028ca,%rax
  8039a0:	00 00 00 
  8039a3:	ff d0                	callq  *%rax
  8039a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039ac:	78 26                	js     8039d4 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8039ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b2:	ba 07 04 00 00       	mov    $0x407,%edx
  8039b7:	48 89 c6             	mov    %rax,%rsi
  8039ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8039bf:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  8039c6:	00 00 00 
  8039c9:	ff d0                	callq  *%rax
  8039cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039d2:	79 16                	jns    8039ea <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8039d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039d7:	89 c7                	mov    %eax,%edi
  8039d9:	48 b8 94 3e 80 00 00 	movabs $0x803e94,%rax
  8039e0:	00 00 00 
  8039e3:	ff d0                	callq  *%rax
		return r;
  8039e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039e8:	eb 3a                	jmp    803a24 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8039ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ee:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8039f5:	00 00 00 
  8039f8:	8b 12                	mov    (%rdx),%edx
  8039fa:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8039fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a00:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803a07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a0b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a0e:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803a11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a15:	48 89 c7             	mov    %rax,%rdi
  803a18:	48 b8 7c 28 80 00 00 	movabs $0x80287c,%rax
  803a1f:	00 00 00 
  803a22:	ff d0                	callq  *%rax
}
  803a24:	c9                   	leaveq 
  803a25:	c3                   	retq   

0000000000803a26 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803a26:	55                   	push   %rbp
  803a27:	48 89 e5             	mov    %rsp,%rbp
  803a2a:	48 83 ec 30          	sub    $0x30,%rsp
  803a2e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a31:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a35:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a39:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a3c:	89 c7                	mov    %eax,%edi
  803a3e:	48 b8 30 39 80 00 00 	movabs $0x803930,%rax
  803a45:	00 00 00 
  803a48:	ff d0                	callq  *%rax
  803a4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a51:	79 05                	jns    803a58 <accept+0x32>
		return r;
  803a53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a56:	eb 3b                	jmp    803a93 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803a58:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803a5c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803a60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a63:	48 89 ce             	mov    %rcx,%rsi
  803a66:	89 c7                	mov    %eax,%edi
  803a68:	48 b8 71 3d 80 00 00 	movabs $0x803d71,%rax
  803a6f:	00 00 00 
  803a72:	ff d0                	callq  *%rax
  803a74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a7b:	79 05                	jns    803a82 <accept+0x5c>
		return r;
  803a7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a80:	eb 11                	jmp    803a93 <accept+0x6d>
	return alloc_sockfd(r);
  803a82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a85:	89 c7                	mov    %eax,%edi
  803a87:	48 b8 87 39 80 00 00 	movabs $0x803987,%rax
  803a8e:	00 00 00 
  803a91:	ff d0                	callq  *%rax
}
  803a93:	c9                   	leaveq 
  803a94:	c3                   	retq   

0000000000803a95 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803a95:	55                   	push   %rbp
  803a96:	48 89 e5             	mov    %rsp,%rbp
  803a99:	48 83 ec 20          	sub    $0x20,%rsp
  803a9d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803aa0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803aa4:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803aa7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aaa:	89 c7                	mov    %eax,%edi
  803aac:	48 b8 30 39 80 00 00 	movabs $0x803930,%rax
  803ab3:	00 00 00 
  803ab6:	ff d0                	callq  *%rax
  803ab8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803abb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803abf:	79 05                	jns    803ac6 <bind+0x31>
		return r;
  803ac1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ac4:	eb 1b                	jmp    803ae1 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803ac6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803ac9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803acd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad0:	48 89 ce             	mov    %rcx,%rsi
  803ad3:	89 c7                	mov    %eax,%edi
  803ad5:	48 b8 f0 3d 80 00 00 	movabs $0x803df0,%rax
  803adc:	00 00 00 
  803adf:	ff d0                	callq  *%rax
}
  803ae1:	c9                   	leaveq 
  803ae2:	c3                   	retq   

0000000000803ae3 <shutdown>:

int
shutdown(int s, int how)
{
  803ae3:	55                   	push   %rbp
  803ae4:	48 89 e5             	mov    %rsp,%rbp
  803ae7:	48 83 ec 20          	sub    $0x20,%rsp
  803aeb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803aee:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803af1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803af4:	89 c7                	mov    %eax,%edi
  803af6:	48 b8 30 39 80 00 00 	movabs $0x803930,%rax
  803afd:	00 00 00 
  803b00:	ff d0                	callq  *%rax
  803b02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b09:	79 05                	jns    803b10 <shutdown+0x2d>
		return r;
  803b0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b0e:	eb 16                	jmp    803b26 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803b10:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b16:	89 d6                	mov    %edx,%esi
  803b18:	89 c7                	mov    %eax,%edi
  803b1a:	48 b8 54 3e 80 00 00 	movabs $0x803e54,%rax
  803b21:	00 00 00 
  803b24:	ff d0                	callq  *%rax
}
  803b26:	c9                   	leaveq 
  803b27:	c3                   	retq   

0000000000803b28 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803b28:	55                   	push   %rbp
  803b29:	48 89 e5             	mov    %rsp,%rbp
  803b2c:	48 83 ec 10          	sub    $0x10,%rsp
  803b30:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803b34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b38:	48 89 c7             	mov    %rax,%rdi
  803b3b:	48 b8 a7 38 80 00 00 	movabs $0x8038a7,%rax
  803b42:	00 00 00 
  803b45:	ff d0                	callq  *%rax
  803b47:	83 f8 01             	cmp    $0x1,%eax
  803b4a:	75 17                	jne    803b63 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803b4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b50:	8b 40 0c             	mov    0xc(%rax),%eax
  803b53:	89 c7                	mov    %eax,%edi
  803b55:	48 b8 94 3e 80 00 00 	movabs $0x803e94,%rax
  803b5c:	00 00 00 
  803b5f:	ff d0                	callq  *%rax
  803b61:	eb 05                	jmp    803b68 <devsock_close+0x40>
	else
		return 0;
  803b63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b68:	c9                   	leaveq 
  803b69:	c3                   	retq   

0000000000803b6a <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803b6a:	55                   	push   %rbp
  803b6b:	48 89 e5             	mov    %rsp,%rbp
  803b6e:	48 83 ec 20          	sub    $0x20,%rsp
  803b72:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b75:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b79:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b7c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b7f:	89 c7                	mov    %eax,%edi
  803b81:	48 b8 30 39 80 00 00 	movabs $0x803930,%rax
  803b88:	00 00 00 
  803b8b:	ff d0                	callq  *%rax
  803b8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b94:	79 05                	jns    803b9b <connect+0x31>
		return r;
  803b96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b99:	eb 1b                	jmp    803bb6 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803b9b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b9e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803ba2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ba5:	48 89 ce             	mov    %rcx,%rsi
  803ba8:	89 c7                	mov    %eax,%edi
  803baa:	48 b8 c1 3e 80 00 00 	movabs $0x803ec1,%rax
  803bb1:	00 00 00 
  803bb4:	ff d0                	callq  *%rax
}
  803bb6:	c9                   	leaveq 
  803bb7:	c3                   	retq   

0000000000803bb8 <listen>:

int
listen(int s, int backlog)
{
  803bb8:	55                   	push   %rbp
  803bb9:	48 89 e5             	mov    %rsp,%rbp
  803bbc:	48 83 ec 20          	sub    $0x20,%rsp
  803bc0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bc3:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803bc6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bc9:	89 c7                	mov    %eax,%edi
  803bcb:	48 b8 30 39 80 00 00 	movabs $0x803930,%rax
  803bd2:	00 00 00 
  803bd5:	ff d0                	callq  *%rax
  803bd7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bda:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bde:	79 05                	jns    803be5 <listen+0x2d>
		return r;
  803be0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803be3:	eb 16                	jmp    803bfb <listen+0x43>
	return nsipc_listen(r, backlog);
  803be5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803be8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803beb:	89 d6                	mov    %edx,%esi
  803bed:	89 c7                	mov    %eax,%edi
  803bef:	48 b8 25 3f 80 00 00 	movabs $0x803f25,%rax
  803bf6:	00 00 00 
  803bf9:	ff d0                	callq  *%rax
}
  803bfb:	c9                   	leaveq 
  803bfc:	c3                   	retq   

0000000000803bfd <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803bfd:	55                   	push   %rbp
  803bfe:	48 89 e5             	mov    %rsp,%rbp
  803c01:	48 83 ec 20          	sub    $0x20,%rsp
  803c05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c0d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803c11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c15:	89 c2                	mov    %eax,%edx
  803c17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c1b:	8b 40 0c             	mov    0xc(%rax),%eax
  803c1e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803c22:	b9 00 00 00 00       	mov    $0x0,%ecx
  803c27:	89 c7                	mov    %eax,%edi
  803c29:	48 b8 65 3f 80 00 00 	movabs $0x803f65,%rax
  803c30:	00 00 00 
  803c33:	ff d0                	callq  *%rax
}
  803c35:	c9                   	leaveq 
  803c36:	c3                   	retq   

0000000000803c37 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803c37:	55                   	push   %rbp
  803c38:	48 89 e5             	mov    %rsp,%rbp
  803c3b:	48 83 ec 20          	sub    $0x20,%rsp
  803c3f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c47:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803c4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c4f:	89 c2                	mov    %eax,%edx
  803c51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c55:	8b 40 0c             	mov    0xc(%rax),%eax
  803c58:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803c5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  803c61:	89 c7                	mov    %eax,%edi
  803c63:	48 b8 31 40 80 00 00 	movabs $0x804031,%rax
  803c6a:	00 00 00 
  803c6d:	ff d0                	callq  *%rax
}
  803c6f:	c9                   	leaveq 
  803c70:	c3                   	retq   

0000000000803c71 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803c71:	55                   	push   %rbp
  803c72:	48 89 e5             	mov    %rsp,%rbp
  803c75:	48 83 ec 10          	sub    $0x10,%rsp
  803c79:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c7d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803c81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c85:	48 be 47 53 80 00 00 	movabs $0x805347,%rsi
  803c8c:	00 00 00 
  803c8f:	48 89 c7             	mov    %rax,%rdi
  803c92:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  803c99:	00 00 00 
  803c9c:	ff d0                	callq  *%rax
	return 0;
  803c9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ca3:	c9                   	leaveq 
  803ca4:	c3                   	retq   

0000000000803ca5 <socket>:

int
socket(int domain, int type, int protocol)
{
  803ca5:	55                   	push   %rbp
  803ca6:	48 89 e5             	mov    %rsp,%rbp
  803ca9:	48 83 ec 20          	sub    $0x20,%rsp
  803cad:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803cb0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803cb3:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803cb6:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803cb9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803cbc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cbf:	89 ce                	mov    %ecx,%esi
  803cc1:	89 c7                	mov    %eax,%edi
  803cc3:	48 b8 e9 40 80 00 00 	movabs $0x8040e9,%rax
  803cca:	00 00 00 
  803ccd:	ff d0                	callq  *%rax
  803ccf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cd2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cd6:	79 05                	jns    803cdd <socket+0x38>
		return r;
  803cd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cdb:	eb 11                	jmp    803cee <socket+0x49>
	return alloc_sockfd(r);
  803cdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ce0:	89 c7                	mov    %eax,%edi
  803ce2:	48 b8 87 39 80 00 00 	movabs $0x803987,%rax
  803ce9:	00 00 00 
  803cec:	ff d0                	callq  *%rax
}
  803cee:	c9                   	leaveq 
  803cef:	c3                   	retq   

0000000000803cf0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803cf0:	55                   	push   %rbp
  803cf1:	48 89 e5             	mov    %rsp,%rbp
  803cf4:	48 83 ec 10          	sub    $0x10,%rsp
  803cf8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803cfb:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803d02:	00 00 00 
  803d05:	8b 00                	mov    (%rax),%eax
  803d07:	85 c0                	test   %eax,%eax
  803d09:	75 1d                	jne    803d28 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803d0b:	bf 02 00 00 00       	mov    $0x2,%edi
  803d10:	48 b8 0a 28 80 00 00 	movabs $0x80280a,%rax
  803d17:	00 00 00 
  803d1a:	ff d0                	callq  *%rax
  803d1c:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  803d23:	00 00 00 
  803d26:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803d28:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803d2f:	00 00 00 
  803d32:	8b 00                	mov    (%rax),%eax
  803d34:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803d37:	b9 07 00 00 00       	mov    $0x7,%ecx
  803d3c:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803d43:	00 00 00 
  803d46:	89 c7                	mov    %eax,%edi
  803d48:	48 b8 fe 25 80 00 00 	movabs $0x8025fe,%rax
  803d4f:	00 00 00 
  803d52:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803d54:	ba 00 00 00 00       	mov    $0x0,%edx
  803d59:	be 00 00 00 00       	mov    $0x0,%esi
  803d5e:	bf 00 00 00 00       	mov    $0x0,%edi
  803d63:	48 b8 3d 25 80 00 00 	movabs $0x80253d,%rax
  803d6a:	00 00 00 
  803d6d:	ff d0                	callq  *%rax
}
  803d6f:	c9                   	leaveq 
  803d70:	c3                   	retq   

0000000000803d71 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803d71:	55                   	push   %rbp
  803d72:	48 89 e5             	mov    %rsp,%rbp
  803d75:	48 83 ec 30          	sub    $0x30,%rsp
  803d79:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d7c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d80:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803d84:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d8b:	00 00 00 
  803d8e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803d91:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803d93:	bf 01 00 00 00       	mov    $0x1,%edi
  803d98:	48 b8 f0 3c 80 00 00 	movabs $0x803cf0,%rax
  803d9f:	00 00 00 
  803da2:	ff d0                	callq  *%rax
  803da4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803da7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dab:	78 3e                	js     803deb <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803dad:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803db4:	00 00 00 
  803db7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803dbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dbf:	8b 40 10             	mov    0x10(%rax),%eax
  803dc2:	89 c2                	mov    %eax,%edx
  803dc4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803dc8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dcc:	48 89 ce             	mov    %rcx,%rsi
  803dcf:	48 89 c7             	mov    %rax,%rdi
  803dd2:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  803dd9:	00 00 00 
  803ddc:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803dde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803de2:	8b 50 10             	mov    0x10(%rax),%edx
  803de5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803de9:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803deb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803dee:	c9                   	leaveq 
  803def:	c3                   	retq   

0000000000803df0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803df0:	55                   	push   %rbp
  803df1:	48 89 e5             	mov    %rsp,%rbp
  803df4:	48 83 ec 10          	sub    $0x10,%rsp
  803df8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803dfb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803dff:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803e02:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e09:	00 00 00 
  803e0c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e0f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803e11:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e18:	48 89 c6             	mov    %rax,%rsi
  803e1b:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803e22:	00 00 00 
  803e25:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  803e2c:	00 00 00 
  803e2f:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803e31:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e38:	00 00 00 
  803e3b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e3e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803e41:	bf 02 00 00 00       	mov    $0x2,%edi
  803e46:	48 b8 f0 3c 80 00 00 	movabs $0x803cf0,%rax
  803e4d:	00 00 00 
  803e50:	ff d0                	callq  *%rax
}
  803e52:	c9                   	leaveq 
  803e53:	c3                   	retq   

0000000000803e54 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803e54:	55                   	push   %rbp
  803e55:	48 89 e5             	mov    %rsp,%rbp
  803e58:	48 83 ec 10          	sub    $0x10,%rsp
  803e5c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e5f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803e62:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e69:	00 00 00 
  803e6c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e6f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803e71:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e78:	00 00 00 
  803e7b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e7e:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803e81:	bf 03 00 00 00       	mov    $0x3,%edi
  803e86:	48 b8 f0 3c 80 00 00 	movabs $0x803cf0,%rax
  803e8d:	00 00 00 
  803e90:	ff d0                	callq  *%rax
}
  803e92:	c9                   	leaveq 
  803e93:	c3                   	retq   

0000000000803e94 <nsipc_close>:

int
nsipc_close(int s)
{
  803e94:	55                   	push   %rbp
  803e95:	48 89 e5             	mov    %rsp,%rbp
  803e98:	48 83 ec 10          	sub    $0x10,%rsp
  803e9c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803e9f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ea6:	00 00 00 
  803ea9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803eac:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803eae:	bf 04 00 00 00       	mov    $0x4,%edi
  803eb3:	48 b8 f0 3c 80 00 00 	movabs $0x803cf0,%rax
  803eba:	00 00 00 
  803ebd:	ff d0                	callq  *%rax
}
  803ebf:	c9                   	leaveq 
  803ec0:	c3                   	retq   

0000000000803ec1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803ec1:	55                   	push   %rbp
  803ec2:	48 89 e5             	mov    %rsp,%rbp
  803ec5:	48 83 ec 10          	sub    $0x10,%rsp
  803ec9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ecc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ed0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803ed3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803eda:	00 00 00 
  803edd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ee0:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803ee2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ee5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ee9:	48 89 c6             	mov    %rax,%rsi
  803eec:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803ef3:	00 00 00 
  803ef6:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  803efd:	00 00 00 
  803f00:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803f02:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f09:	00 00 00 
  803f0c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f0f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803f12:	bf 05 00 00 00       	mov    $0x5,%edi
  803f17:	48 b8 f0 3c 80 00 00 	movabs $0x803cf0,%rax
  803f1e:	00 00 00 
  803f21:	ff d0                	callq  *%rax
}
  803f23:	c9                   	leaveq 
  803f24:	c3                   	retq   

0000000000803f25 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803f25:	55                   	push   %rbp
  803f26:	48 89 e5             	mov    %rsp,%rbp
  803f29:	48 83 ec 10          	sub    $0x10,%rsp
  803f2d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f30:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803f33:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f3a:	00 00 00 
  803f3d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f40:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803f42:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f49:	00 00 00 
  803f4c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f4f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803f52:	bf 06 00 00 00       	mov    $0x6,%edi
  803f57:	48 b8 f0 3c 80 00 00 	movabs $0x803cf0,%rax
  803f5e:	00 00 00 
  803f61:	ff d0                	callq  *%rax
}
  803f63:	c9                   	leaveq 
  803f64:	c3                   	retq   

0000000000803f65 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803f65:	55                   	push   %rbp
  803f66:	48 89 e5             	mov    %rsp,%rbp
  803f69:	48 83 ec 30          	sub    $0x30,%rsp
  803f6d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f70:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f74:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803f77:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803f7a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f81:	00 00 00 
  803f84:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f87:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803f89:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f90:	00 00 00 
  803f93:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803f96:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803f99:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fa0:	00 00 00 
  803fa3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803fa6:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803fa9:	bf 07 00 00 00       	mov    $0x7,%edi
  803fae:	48 b8 f0 3c 80 00 00 	movabs $0x803cf0,%rax
  803fb5:	00 00 00 
  803fb8:	ff d0                	callq  *%rax
  803fba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fc1:	78 69                	js     80402c <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803fc3:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803fca:	7f 08                	jg     803fd4 <nsipc_recv+0x6f>
  803fcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fcf:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803fd2:	7e 35                	jle    804009 <nsipc_recv+0xa4>
  803fd4:	48 b9 4e 53 80 00 00 	movabs $0x80534e,%rcx
  803fdb:	00 00 00 
  803fde:	48 ba 63 53 80 00 00 	movabs $0x805363,%rdx
  803fe5:	00 00 00 
  803fe8:	be 62 00 00 00       	mov    $0x62,%esi
  803fed:	48 bf 78 53 80 00 00 	movabs $0x805378,%rdi
  803ff4:	00 00 00 
  803ff7:	b8 00 00 00 00       	mov    $0x0,%eax
  803ffc:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  804003:	00 00 00 
  804006:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804009:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80400c:	48 63 d0             	movslq %eax,%rdx
  80400f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804013:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  80401a:	00 00 00 
  80401d:	48 89 c7             	mov    %rax,%rdi
  804020:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  804027:	00 00 00 
  80402a:	ff d0                	callq  *%rax
	}

	return r;
  80402c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80402f:	c9                   	leaveq 
  804030:	c3                   	retq   

0000000000804031 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804031:	55                   	push   %rbp
  804032:	48 89 e5             	mov    %rsp,%rbp
  804035:	48 83 ec 20          	sub    $0x20,%rsp
  804039:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80403c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804040:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804043:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  804046:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80404d:	00 00 00 
  804050:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804053:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  804055:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80405c:	7e 35                	jle    804093 <nsipc_send+0x62>
  80405e:	48 b9 84 53 80 00 00 	movabs $0x805384,%rcx
  804065:	00 00 00 
  804068:	48 ba 63 53 80 00 00 	movabs $0x805363,%rdx
  80406f:	00 00 00 
  804072:	be 6d 00 00 00       	mov    $0x6d,%esi
  804077:	48 bf 78 53 80 00 00 	movabs $0x805378,%rdi
  80407e:	00 00 00 
  804081:	b8 00 00 00 00       	mov    $0x0,%eax
  804086:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  80408d:	00 00 00 
  804090:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804093:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804096:	48 63 d0             	movslq %eax,%rdx
  804099:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80409d:	48 89 c6             	mov    %rax,%rsi
  8040a0:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  8040a7:	00 00 00 
  8040aa:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  8040b1:	00 00 00 
  8040b4:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8040b6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040bd:	00 00 00 
  8040c0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8040c3:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8040c6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040cd:	00 00 00 
  8040d0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8040d3:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8040d6:	bf 08 00 00 00       	mov    $0x8,%edi
  8040db:	48 b8 f0 3c 80 00 00 	movabs $0x803cf0,%rax
  8040e2:	00 00 00 
  8040e5:	ff d0                	callq  *%rax
}
  8040e7:	c9                   	leaveq 
  8040e8:	c3                   	retq   

00000000008040e9 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8040e9:	55                   	push   %rbp
  8040ea:	48 89 e5             	mov    %rsp,%rbp
  8040ed:	48 83 ec 10          	sub    $0x10,%rsp
  8040f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8040f4:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8040f7:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8040fa:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804101:	00 00 00 
  804104:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804107:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804109:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804110:	00 00 00 
  804113:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804116:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804119:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804120:	00 00 00 
  804123:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804126:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804129:	bf 09 00 00 00       	mov    $0x9,%edi
  80412e:	48 b8 f0 3c 80 00 00 	movabs $0x803cf0,%rax
  804135:	00 00 00 
  804138:	ff d0                	callq  *%rax
}
  80413a:	c9                   	leaveq 
  80413b:	c3                   	retq   

000000000080413c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80413c:	55                   	push   %rbp
  80413d:	48 89 e5             	mov    %rsp,%rbp
  804140:	53                   	push   %rbx
  804141:	48 83 ec 38          	sub    $0x38,%rsp
  804145:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804149:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80414d:	48 89 c7             	mov    %rax,%rdi
  804150:	48 b8 ca 28 80 00 00 	movabs $0x8028ca,%rax
  804157:	00 00 00 
  80415a:	ff d0                	callq  *%rax
  80415c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80415f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804163:	0f 88 bf 01 00 00    	js     804328 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804169:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80416d:	ba 07 04 00 00       	mov    $0x407,%edx
  804172:	48 89 c6             	mov    %rax,%rsi
  804175:	bf 00 00 00 00       	mov    $0x0,%edi
  80417a:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  804181:	00 00 00 
  804184:	ff d0                	callq  *%rax
  804186:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804189:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80418d:	0f 88 95 01 00 00    	js     804328 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804193:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804197:	48 89 c7             	mov    %rax,%rdi
  80419a:	48 b8 ca 28 80 00 00 	movabs $0x8028ca,%rax
  8041a1:	00 00 00 
  8041a4:	ff d0                	callq  *%rax
  8041a6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041ad:	0f 88 5d 01 00 00    	js     804310 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8041b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041b7:	ba 07 04 00 00       	mov    $0x407,%edx
  8041bc:	48 89 c6             	mov    %rax,%rsi
  8041bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8041c4:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  8041cb:	00 00 00 
  8041ce:	ff d0                	callq  *%rax
  8041d0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041d7:	0f 88 33 01 00 00    	js     804310 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8041dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041e1:	48 89 c7             	mov    %rax,%rdi
  8041e4:	48 b8 9f 28 80 00 00 	movabs $0x80289f,%rax
  8041eb:	00 00 00 
  8041ee:	ff d0                	callq  *%rax
  8041f0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8041f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041f8:	ba 07 04 00 00       	mov    $0x407,%edx
  8041fd:	48 89 c6             	mov    %rax,%rsi
  804200:	bf 00 00 00 00       	mov    $0x0,%edi
  804205:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  80420c:	00 00 00 
  80420f:	ff d0                	callq  *%rax
  804211:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804214:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804218:	79 05                	jns    80421f <pipe+0xe3>
		goto err2;
  80421a:	e9 d9 00 00 00       	jmpq   8042f8 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80421f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804223:	48 89 c7             	mov    %rax,%rdi
  804226:	48 b8 9f 28 80 00 00 	movabs $0x80289f,%rax
  80422d:	00 00 00 
  804230:	ff d0                	callq  *%rax
  804232:	48 89 c2             	mov    %rax,%rdx
  804235:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804239:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80423f:	48 89 d1             	mov    %rdx,%rcx
  804242:	ba 00 00 00 00       	mov    $0x0,%edx
  804247:	48 89 c6             	mov    %rax,%rsi
  80424a:	bf 00 00 00 00       	mov    $0x0,%edi
  80424f:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  804256:	00 00 00 
  804259:	ff d0                	callq  *%rax
  80425b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80425e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804262:	79 1b                	jns    80427f <pipe+0x143>
		goto err3;
  804264:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804265:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804269:	48 89 c6             	mov    %rax,%rsi
  80426c:	bf 00 00 00 00       	mov    $0x0,%edi
  804271:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  804278:	00 00 00 
  80427b:	ff d0                	callq  *%rax
  80427d:	eb 79                	jmp    8042f8 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80427f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804283:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80428a:	00 00 00 
  80428d:	8b 12                	mov    (%rdx),%edx
  80428f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804291:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804295:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80429c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042a0:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8042a7:	00 00 00 
  8042aa:	8b 12                	mov    (%rdx),%edx
  8042ac:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8042ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042b2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8042b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042bd:	48 89 c7             	mov    %rax,%rdi
  8042c0:	48 b8 7c 28 80 00 00 	movabs $0x80287c,%rax
  8042c7:	00 00 00 
  8042ca:	ff d0                	callq  *%rax
  8042cc:	89 c2                	mov    %eax,%edx
  8042ce:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8042d2:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8042d4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8042d8:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8042dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042e0:	48 89 c7             	mov    %rax,%rdi
  8042e3:	48 b8 7c 28 80 00 00 	movabs $0x80287c,%rax
  8042ea:	00 00 00 
  8042ed:	ff d0                	callq  *%rax
  8042ef:	89 03                	mov    %eax,(%rbx)
	return 0;
  8042f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8042f6:	eb 33                	jmp    80432b <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8042f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042fc:	48 89 c6             	mov    %rax,%rsi
  8042ff:	bf 00 00 00 00       	mov    $0x0,%edi
  804304:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  80430b:	00 00 00 
  80430e:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804310:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804314:	48 89 c6             	mov    %rax,%rsi
  804317:	bf 00 00 00 00       	mov    $0x0,%edi
  80431c:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  804323:	00 00 00 
  804326:	ff d0                	callq  *%rax
err:
	return r;
  804328:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80432b:	48 83 c4 38          	add    $0x38,%rsp
  80432f:	5b                   	pop    %rbx
  804330:	5d                   	pop    %rbp
  804331:	c3                   	retq   

0000000000804332 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804332:	55                   	push   %rbp
  804333:	48 89 e5             	mov    %rsp,%rbp
  804336:	53                   	push   %rbx
  804337:	48 83 ec 28          	sub    $0x28,%rsp
  80433b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80433f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804343:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80434a:	00 00 00 
  80434d:	48 8b 00             	mov    (%rax),%rax
  804350:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804356:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804359:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80435d:	48 89 c7             	mov    %rax,%rdi
  804360:	48 b8 a7 38 80 00 00 	movabs $0x8038a7,%rax
  804367:	00 00 00 
  80436a:	ff d0                	callq  *%rax
  80436c:	89 c3                	mov    %eax,%ebx
  80436e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804372:	48 89 c7             	mov    %rax,%rdi
  804375:	48 b8 a7 38 80 00 00 	movabs $0x8038a7,%rax
  80437c:	00 00 00 
  80437f:	ff d0                	callq  *%rax
  804381:	39 c3                	cmp    %eax,%ebx
  804383:	0f 94 c0             	sete   %al
  804386:	0f b6 c0             	movzbl %al,%eax
  804389:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80438c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804393:	00 00 00 
  804396:	48 8b 00             	mov    (%rax),%rax
  804399:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80439f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8043a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043a5:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8043a8:	75 05                	jne    8043af <_pipeisclosed+0x7d>
			return ret;
  8043aa:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8043ad:	eb 4f                	jmp    8043fe <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8043af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043b2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8043b5:	74 42                	je     8043f9 <_pipeisclosed+0xc7>
  8043b7:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8043bb:	75 3c                	jne    8043f9 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8043bd:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8043c4:	00 00 00 
  8043c7:	48 8b 00             	mov    (%rax),%rax
  8043ca:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8043d0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8043d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043d6:	89 c6                	mov    %eax,%esi
  8043d8:	48 bf 95 53 80 00 00 	movabs $0x805395,%rdi
  8043df:	00 00 00 
  8043e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8043e7:	49 b8 64 06 80 00 00 	movabs $0x800664,%r8
  8043ee:	00 00 00 
  8043f1:	41 ff d0             	callq  *%r8
	}
  8043f4:	e9 4a ff ff ff       	jmpq   804343 <_pipeisclosed+0x11>
  8043f9:	e9 45 ff ff ff       	jmpq   804343 <_pipeisclosed+0x11>

}
  8043fe:	48 83 c4 28          	add    $0x28,%rsp
  804402:	5b                   	pop    %rbx
  804403:	5d                   	pop    %rbp
  804404:	c3                   	retq   

0000000000804405 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804405:	55                   	push   %rbp
  804406:	48 89 e5             	mov    %rsp,%rbp
  804409:	48 83 ec 30          	sub    $0x30,%rsp
  80440d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804410:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804414:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804417:	48 89 d6             	mov    %rdx,%rsi
  80441a:	89 c7                	mov    %eax,%edi
  80441c:	48 b8 62 29 80 00 00 	movabs $0x802962,%rax
  804423:	00 00 00 
  804426:	ff d0                	callq  *%rax
  804428:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80442b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80442f:	79 05                	jns    804436 <pipeisclosed+0x31>
		return r;
  804431:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804434:	eb 31                	jmp    804467 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804436:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80443a:	48 89 c7             	mov    %rax,%rdi
  80443d:	48 b8 9f 28 80 00 00 	movabs $0x80289f,%rax
  804444:	00 00 00 
  804447:	ff d0                	callq  *%rax
  804449:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80444d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804451:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804455:	48 89 d6             	mov    %rdx,%rsi
  804458:	48 89 c7             	mov    %rax,%rdi
  80445b:	48 b8 32 43 80 00 00 	movabs $0x804332,%rax
  804462:	00 00 00 
  804465:	ff d0                	callq  *%rax
}
  804467:	c9                   	leaveq 
  804468:	c3                   	retq   

0000000000804469 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804469:	55                   	push   %rbp
  80446a:	48 89 e5             	mov    %rsp,%rbp
  80446d:	48 83 ec 40          	sub    $0x40,%rsp
  804471:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804475:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804479:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80447d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804481:	48 89 c7             	mov    %rax,%rdi
  804484:	48 b8 9f 28 80 00 00 	movabs $0x80289f,%rax
  80448b:	00 00 00 
  80448e:	ff d0                	callq  *%rax
  804490:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804494:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804498:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80449c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8044a3:	00 
  8044a4:	e9 92 00 00 00       	jmpq   80453b <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8044a9:	eb 41                	jmp    8044ec <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8044ab:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8044b0:	74 09                	je     8044bb <devpipe_read+0x52>
				return i;
  8044b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044b6:	e9 92 00 00 00       	jmpq   80454d <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8044bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8044bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044c3:	48 89 d6             	mov    %rdx,%rsi
  8044c6:	48 89 c7             	mov    %rax,%rdi
  8044c9:	48 b8 32 43 80 00 00 	movabs $0x804332,%rax
  8044d0:	00 00 00 
  8044d3:	ff d0                	callq  *%rax
  8044d5:	85 c0                	test   %eax,%eax
  8044d7:	74 07                	je     8044e0 <devpipe_read+0x77>
				return 0;
  8044d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8044de:	eb 6d                	jmp    80454d <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8044e0:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  8044e7:	00 00 00 
  8044ea:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8044ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044f0:	8b 10                	mov    (%rax),%edx
  8044f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044f6:	8b 40 04             	mov    0x4(%rax),%eax
  8044f9:	39 c2                	cmp    %eax,%edx
  8044fb:	74 ae                	je     8044ab <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8044fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804501:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804505:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804509:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80450d:	8b 00                	mov    (%rax),%eax
  80450f:	99                   	cltd   
  804510:	c1 ea 1b             	shr    $0x1b,%edx
  804513:	01 d0                	add    %edx,%eax
  804515:	83 e0 1f             	and    $0x1f,%eax
  804518:	29 d0                	sub    %edx,%eax
  80451a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80451e:	48 98                	cltq   
  804520:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804525:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804527:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80452b:	8b 00                	mov    (%rax),%eax
  80452d:	8d 50 01             	lea    0x1(%rax),%edx
  804530:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804534:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804536:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80453b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80453f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804543:	0f 82 60 ff ff ff    	jb     8044a9 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804549:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80454d:	c9                   	leaveq 
  80454e:	c3                   	retq   

000000000080454f <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80454f:	55                   	push   %rbp
  804550:	48 89 e5             	mov    %rsp,%rbp
  804553:	48 83 ec 40          	sub    $0x40,%rsp
  804557:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80455b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80455f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804563:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804567:	48 89 c7             	mov    %rax,%rdi
  80456a:	48 b8 9f 28 80 00 00 	movabs $0x80289f,%rax
  804571:	00 00 00 
  804574:	ff d0                	callq  *%rax
  804576:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80457a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80457e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804582:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804589:	00 
  80458a:	e9 8e 00 00 00       	jmpq   80461d <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80458f:	eb 31                	jmp    8045c2 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804591:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804595:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804599:	48 89 d6             	mov    %rdx,%rsi
  80459c:	48 89 c7             	mov    %rax,%rdi
  80459f:	48 b8 32 43 80 00 00 	movabs $0x804332,%rax
  8045a6:	00 00 00 
  8045a9:	ff d0                	callq  *%rax
  8045ab:	85 c0                	test   %eax,%eax
  8045ad:	74 07                	je     8045b6 <devpipe_write+0x67>
				return 0;
  8045af:	b8 00 00 00 00       	mov    $0x0,%eax
  8045b4:	eb 79                	jmp    80462f <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8045b6:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  8045bd:	00 00 00 
  8045c0:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8045c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045c6:	8b 40 04             	mov    0x4(%rax),%eax
  8045c9:	48 63 d0             	movslq %eax,%rdx
  8045cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045d0:	8b 00                	mov    (%rax),%eax
  8045d2:	48 98                	cltq   
  8045d4:	48 83 c0 20          	add    $0x20,%rax
  8045d8:	48 39 c2             	cmp    %rax,%rdx
  8045db:	73 b4                	jae    804591 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8045dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045e1:	8b 40 04             	mov    0x4(%rax),%eax
  8045e4:	99                   	cltd   
  8045e5:	c1 ea 1b             	shr    $0x1b,%edx
  8045e8:	01 d0                	add    %edx,%eax
  8045ea:	83 e0 1f             	and    $0x1f,%eax
  8045ed:	29 d0                	sub    %edx,%eax
  8045ef:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8045f3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8045f7:	48 01 ca             	add    %rcx,%rdx
  8045fa:	0f b6 0a             	movzbl (%rdx),%ecx
  8045fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804601:	48 98                	cltq   
  804603:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804607:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80460b:	8b 40 04             	mov    0x4(%rax),%eax
  80460e:	8d 50 01             	lea    0x1(%rax),%edx
  804611:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804615:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804618:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80461d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804621:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804625:	0f 82 64 ff ff ff    	jb     80458f <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80462b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80462f:	c9                   	leaveq 
  804630:	c3                   	retq   

0000000000804631 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804631:	55                   	push   %rbp
  804632:	48 89 e5             	mov    %rsp,%rbp
  804635:	48 83 ec 20          	sub    $0x20,%rsp
  804639:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80463d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804641:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804645:	48 89 c7             	mov    %rax,%rdi
  804648:	48 b8 9f 28 80 00 00 	movabs $0x80289f,%rax
  80464f:	00 00 00 
  804652:	ff d0                	callq  *%rax
  804654:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804658:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80465c:	48 be a8 53 80 00 00 	movabs $0x8053a8,%rsi
  804663:	00 00 00 
  804666:	48 89 c7             	mov    %rax,%rdi
  804669:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  804670:	00 00 00 
  804673:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804675:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804679:	8b 50 04             	mov    0x4(%rax),%edx
  80467c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804680:	8b 00                	mov    (%rax),%eax
  804682:	29 c2                	sub    %eax,%edx
  804684:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804688:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80468e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804692:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804699:	00 00 00 
	stat->st_dev = &devpipe;
  80469c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046a0:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  8046a7:	00 00 00 
  8046aa:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8046b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046b6:	c9                   	leaveq 
  8046b7:	c3                   	retq   

00000000008046b8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8046b8:	55                   	push   %rbp
  8046b9:	48 89 e5             	mov    %rsp,%rbp
  8046bc:	48 83 ec 10          	sub    $0x10,%rsp
  8046c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  8046c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046c8:	48 89 c6             	mov    %rax,%rsi
  8046cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8046d0:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  8046d7:	00 00 00 
  8046da:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  8046dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046e0:	48 89 c7             	mov    %rax,%rdi
  8046e3:	48 b8 9f 28 80 00 00 	movabs $0x80289f,%rax
  8046ea:	00 00 00 
  8046ed:	ff d0                	callq  *%rax
  8046ef:	48 89 c6             	mov    %rax,%rsi
  8046f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8046f7:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  8046fe:	00 00 00 
  804701:	ff d0                	callq  *%rax
}
  804703:	c9                   	leaveq 
  804704:	c3                   	retq   

0000000000804705 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804705:	55                   	push   %rbp
  804706:	48 89 e5             	mov    %rsp,%rbp
  804709:	48 83 ec 20          	sub    $0x20,%rsp
  80470d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804710:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804713:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804716:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80471a:	be 01 00 00 00       	mov    $0x1,%esi
  80471f:	48 89 c7             	mov    %rax,%rdi
  804722:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  804729:	00 00 00 
  80472c:	ff d0                	callq  *%rax
}
  80472e:	c9                   	leaveq 
  80472f:	c3                   	retq   

0000000000804730 <getchar>:

int
getchar(void)
{
  804730:	55                   	push   %rbp
  804731:	48 89 e5             	mov    %rsp,%rbp
  804734:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804738:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80473c:	ba 01 00 00 00       	mov    $0x1,%edx
  804741:	48 89 c6             	mov    %rax,%rsi
  804744:	bf 00 00 00 00       	mov    $0x0,%edi
  804749:	48 b8 94 2d 80 00 00 	movabs $0x802d94,%rax
  804750:	00 00 00 
  804753:	ff d0                	callq  *%rax
  804755:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804758:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80475c:	79 05                	jns    804763 <getchar+0x33>
		return r;
  80475e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804761:	eb 14                	jmp    804777 <getchar+0x47>
	if (r < 1)
  804763:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804767:	7f 07                	jg     804770 <getchar+0x40>
		return -E_EOF;
  804769:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80476e:	eb 07                	jmp    804777 <getchar+0x47>
	return c;
  804770:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804774:	0f b6 c0             	movzbl %al,%eax

}
  804777:	c9                   	leaveq 
  804778:	c3                   	retq   

0000000000804779 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804779:	55                   	push   %rbp
  80477a:	48 89 e5             	mov    %rsp,%rbp
  80477d:	48 83 ec 20          	sub    $0x20,%rsp
  804781:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804784:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804788:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80478b:	48 89 d6             	mov    %rdx,%rsi
  80478e:	89 c7                	mov    %eax,%edi
  804790:	48 b8 62 29 80 00 00 	movabs $0x802962,%rax
  804797:	00 00 00 
  80479a:	ff d0                	callq  *%rax
  80479c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80479f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047a3:	79 05                	jns    8047aa <iscons+0x31>
		return r;
  8047a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047a8:	eb 1a                	jmp    8047c4 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8047aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047ae:	8b 10                	mov    (%rax),%edx
  8047b0:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  8047b7:	00 00 00 
  8047ba:	8b 00                	mov    (%rax),%eax
  8047bc:	39 c2                	cmp    %eax,%edx
  8047be:	0f 94 c0             	sete   %al
  8047c1:	0f b6 c0             	movzbl %al,%eax
}
  8047c4:	c9                   	leaveq 
  8047c5:	c3                   	retq   

00000000008047c6 <opencons>:

int
opencons(void)
{
  8047c6:	55                   	push   %rbp
  8047c7:	48 89 e5             	mov    %rsp,%rbp
  8047ca:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8047ce:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8047d2:	48 89 c7             	mov    %rax,%rdi
  8047d5:	48 b8 ca 28 80 00 00 	movabs $0x8028ca,%rax
  8047dc:	00 00 00 
  8047df:	ff d0                	callq  *%rax
  8047e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047e8:	79 05                	jns    8047ef <opencons+0x29>
		return r;
  8047ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047ed:	eb 5b                	jmp    80484a <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8047ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047f3:	ba 07 04 00 00       	mov    $0x407,%edx
  8047f8:	48 89 c6             	mov    %rax,%rsi
  8047fb:	bf 00 00 00 00       	mov    $0x0,%edi
  804800:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  804807:	00 00 00 
  80480a:	ff d0                	callq  *%rax
  80480c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80480f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804813:	79 05                	jns    80481a <opencons+0x54>
		return r;
  804815:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804818:	eb 30                	jmp    80484a <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80481a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80481e:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804825:	00 00 00 
  804828:	8b 12                	mov    (%rdx),%edx
  80482a:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80482c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804830:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804837:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80483b:	48 89 c7             	mov    %rax,%rdi
  80483e:	48 b8 7c 28 80 00 00 	movabs $0x80287c,%rax
  804845:	00 00 00 
  804848:	ff d0                	callq  *%rax
}
  80484a:	c9                   	leaveq 
  80484b:	c3                   	retq   

000000000080484c <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80484c:	55                   	push   %rbp
  80484d:	48 89 e5             	mov    %rsp,%rbp
  804850:	48 83 ec 30          	sub    $0x30,%rsp
  804854:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804858:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80485c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804860:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804865:	75 07                	jne    80486e <devcons_read+0x22>
		return 0;
  804867:	b8 00 00 00 00       	mov    $0x0,%eax
  80486c:	eb 4b                	jmp    8048b9 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80486e:	eb 0c                	jmp    80487c <devcons_read+0x30>
		sys_yield();
  804870:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  804877:	00 00 00 
  80487a:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80487c:	48 b8 4a 1a 80 00 00 	movabs $0x801a4a,%rax
  804883:	00 00 00 
  804886:	ff d0                	callq  *%rax
  804888:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80488b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80488f:	74 df                	je     804870 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804891:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804895:	79 05                	jns    80489c <devcons_read+0x50>
		return c;
  804897:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80489a:	eb 1d                	jmp    8048b9 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80489c:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8048a0:	75 07                	jne    8048a9 <devcons_read+0x5d>
		return 0;
  8048a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8048a7:	eb 10                	jmp    8048b9 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8048a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048ac:	89 c2                	mov    %eax,%edx
  8048ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048b2:	88 10                	mov    %dl,(%rax)
	return 1;
  8048b4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8048b9:	c9                   	leaveq 
  8048ba:	c3                   	retq   

00000000008048bb <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8048bb:	55                   	push   %rbp
  8048bc:	48 89 e5             	mov    %rsp,%rbp
  8048bf:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8048c6:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8048cd:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8048d4:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8048db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8048e2:	eb 76                	jmp    80495a <devcons_write+0x9f>
		m = n - tot;
  8048e4:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8048eb:	89 c2                	mov    %eax,%edx
  8048ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048f0:	29 c2                	sub    %eax,%edx
  8048f2:	89 d0                	mov    %edx,%eax
  8048f4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8048f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8048fa:	83 f8 7f             	cmp    $0x7f,%eax
  8048fd:	76 07                	jbe    804906 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8048ff:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804906:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804909:	48 63 d0             	movslq %eax,%rdx
  80490c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80490f:	48 63 c8             	movslq %eax,%rcx
  804912:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804919:	48 01 c1             	add    %rax,%rcx
  80491c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804923:	48 89 ce             	mov    %rcx,%rsi
  804926:	48 89 c7             	mov    %rax,%rdi
  804929:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  804930:	00 00 00 
  804933:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804935:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804938:	48 63 d0             	movslq %eax,%rdx
  80493b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804942:	48 89 d6             	mov    %rdx,%rsi
  804945:	48 89 c7             	mov    %rax,%rdi
  804948:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  80494f:	00 00 00 
  804952:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804954:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804957:	01 45 fc             	add    %eax,-0x4(%rbp)
  80495a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80495d:	48 98                	cltq   
  80495f:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804966:	0f 82 78 ff ff ff    	jb     8048e4 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80496c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80496f:	c9                   	leaveq 
  804970:	c3                   	retq   

0000000000804971 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804971:	55                   	push   %rbp
  804972:	48 89 e5             	mov    %rsp,%rbp
  804975:	48 83 ec 08          	sub    $0x8,%rsp
  804979:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80497d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804982:	c9                   	leaveq 
  804983:	c3                   	retq   

0000000000804984 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804984:	55                   	push   %rbp
  804985:	48 89 e5             	mov    %rsp,%rbp
  804988:	48 83 ec 10          	sub    $0x10,%rsp
  80498c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804990:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804994:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804998:	48 be b4 53 80 00 00 	movabs $0x8053b4,%rsi
  80499f:	00 00 00 
  8049a2:	48 89 c7             	mov    %rax,%rdi
  8049a5:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  8049ac:	00 00 00 
  8049af:	ff d0                	callq  *%rax
	return 0;
  8049b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8049b6:	c9                   	leaveq 
  8049b7:	c3                   	retq   

00000000008049b8 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8049b8:	55                   	push   %rbp
  8049b9:	48 89 e5             	mov    %rsp,%rbp
  8049bc:	48 83 ec 20          	sub    $0x20,%rsp
  8049c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8049c4:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8049cb:	00 00 00 
  8049ce:	48 8b 00             	mov    (%rax),%rax
  8049d1:	48 85 c0             	test   %rax,%rax
  8049d4:	75 6f                	jne    804a45 <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  8049d6:	ba 07 00 00 00       	mov    $0x7,%edx
  8049db:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8049e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8049e5:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  8049ec:	00 00 00 
  8049ef:	ff d0                	callq  *%rax
  8049f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049f8:	79 30                	jns    804a2a <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  8049fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049fd:	89 c1                	mov    %eax,%ecx
  8049ff:	48 ba c0 53 80 00 00 	movabs $0x8053c0,%rdx
  804a06:	00 00 00 
  804a09:	be 22 00 00 00       	mov    $0x22,%esi
  804a0e:	48 bf df 53 80 00 00 	movabs $0x8053df,%rdi
  804a15:	00 00 00 
  804a18:	b8 00 00 00 00       	mov    $0x0,%eax
  804a1d:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  804a24:	00 00 00 
  804a27:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  804a2a:	48 be 58 4a 80 00 00 	movabs $0x804a58,%rsi
  804a31:	00 00 00 
  804a34:	bf 00 00 00 00       	mov    $0x0,%edi
  804a39:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  804a40:	00 00 00 
  804a43:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804a45:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804a4c:	00 00 00 
  804a4f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804a53:	48 89 10             	mov    %rdx,(%rax)
}
  804a56:	c9                   	leaveq 
  804a57:	c3                   	retq   

0000000000804a58 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804a58:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804a5b:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  804a62:	00 00 00 
call *%rax
  804a65:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  804a67:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  804a6e:	00 08 
    movq 152(%rsp), %rax
  804a70:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  804a77:	00 
    movq 136(%rsp), %rbx
  804a78:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804a7f:	00 
movq %rbx, (%rax)
  804a80:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  804a83:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  804a87:	4c 8b 3c 24          	mov    (%rsp),%r15
  804a8b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804a90:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804a95:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804a9a:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804a9f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804aa4:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804aa9:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804aae:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804ab3:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804ab8:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804abd:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804ac2:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804ac7:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804acc:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804ad1:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  804ad5:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  804ad9:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  804ada:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  804adf:	c3                   	retq   
