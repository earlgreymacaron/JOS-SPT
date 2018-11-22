
vmm/guest/obj/user/cat:     file format elf64-x86-64


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
  80003c:	e8 08 02 00 00       	callq  800249 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800052:	eb 68                	jmp    8000bc <cat+0x79>
		if ((r = write(1, buf, n)) != n)
  800054:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800058:	48 89 c2             	mov    %rax,%rdx
  80005b:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  800062:	00 00 00 
  800065:	bf 01 00 00 00       	mov    $0x1,%edi
  80006a:	48 b8 4e 24 80 00 00 	movabs $0x80244e,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800079:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80007c:	48 98                	cltq   
  80007e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800082:	74 38                	je     8000bc <cat+0x79>
			panic("write error copying %s: %e", s, r);
  800084:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800087:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80008b:	41 89 d0             	mov    %edx,%r8d
  80008e:	48 89 c1             	mov    %rax,%rcx
  800091:	48 ba 80 45 80 00 00 	movabs $0x804580,%rdx
  800098:	00 00 00 
  80009b:	be 0e 00 00 00       	mov    $0xe,%esi
  8000a0:	48 bf 9b 45 80 00 00 	movabs $0x80459b,%rdi
  8000a7:	00 00 00 
  8000aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000af:	49 b9 ef 02 80 00 00 	movabs $0x8002ef,%r9
  8000b6:	00 00 00 
  8000b9:	41 ff d1             	callq  *%r9
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  8000bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000bf:	ba 00 20 00 00       	mov    $0x2000,%edx
  8000c4:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  8000cb:	00 00 00 
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	48 b8 04 23 80 00 00 	movabs $0x802304,%rax
  8000d7:	00 00 00 
  8000da:	ff d0                	callq  *%rax
  8000dc:	48 98                	cltq   
  8000de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8000e2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000e7:	0f 8f 67 ff ff ff    	jg     800054 <cat+0x11>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  8000ed:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000f2:	79 39                	jns    80012d <cat+0xea>
		panic("error reading %s: %e", s, n);
  8000f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000fc:	49 89 d0             	mov    %rdx,%r8
  8000ff:	48 89 c1             	mov    %rax,%rcx
  800102:	48 ba a6 45 80 00 00 	movabs $0x8045a6,%rdx
  800109:	00 00 00 
  80010c:	be 10 00 00 00       	mov    $0x10,%esi
  800111:	48 bf 9b 45 80 00 00 	movabs $0x80459b,%rdi
  800118:	00 00 00 
  80011b:	b8 00 00 00 00       	mov    $0x0,%eax
  800120:	49 b9 ef 02 80 00 00 	movabs $0x8002ef,%r9
  800127:	00 00 00 
  80012a:	41 ff d1             	callq  *%r9
}
  80012d:	c9                   	leaveq 
  80012e:	c3                   	retq   

000000000080012f <umain>:

void
umain(int argc, char **argv)
{
  80012f:	55                   	push   %rbp
  800130:	48 89 e5             	mov    %rsp,%rbp
  800133:	53                   	push   %rbx
  800134:	48 83 ec 28          	sub    $0x28,%rsp
  800138:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80013b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int f, i;

	binaryname = "cat";
  80013f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800146:	00 00 00 
  800149:	48 bb bb 45 80 00 00 	movabs $0x8045bb,%rbx
  800150:	00 00 00 
  800153:	48 89 18             	mov    %rbx,(%rax)
	if (argc == 1)
  800156:	83 7d dc 01          	cmpl   $0x1,-0x24(%rbp)
  80015a:	75 20                	jne    80017c <umain+0x4d>
		cat(0, "<stdin>");
  80015c:	48 be bf 45 80 00 00 	movabs $0x8045bf,%rsi
  800163:	00 00 00 
  800166:	bf 00 00 00 00       	mov    $0x0,%edi
  80016b:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800172:	00 00 00 
  800175:	ff d0                	callq  *%rax
  800177:	e9 c6 00 00 00       	jmpq   800242 <umain+0x113>
	else
		for (i = 1; i < argc; i++) {
  80017c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
  800183:	e9 ae 00 00 00       	jmpq   800236 <umain+0x107>
			f = open(argv[i], O_RDONLY);
  800188:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80018b:	48 98                	cltq   
  80018d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800194:	00 
  800195:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800199:	48 01 d0             	add    %rdx,%rax
  80019c:	48 8b 00             	mov    (%rax),%rax
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
  8001a4:	48 89 c7             	mov    %rax,%rdi
  8001a7:	48 b8 da 27 80 00 00 	movabs $0x8027da,%rax
  8001ae:	00 00 00 
  8001b1:	ff d0                	callq  *%rax
  8001b3:	89 45 e8             	mov    %eax,-0x18(%rbp)
			if (f < 0)
  8001b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8001ba:	79 3a                	jns    8001f6 <umain+0xc7>
				printf("can't open %s: %e\n", argv[i], f);
  8001bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001bf:	48 98                	cltq   
  8001c1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8001c8:	00 
  8001c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8001cd:	48 01 d0             	add    %rdx,%rax
  8001d0:	48 8b 00             	mov    (%rax),%rax
  8001d3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8001d6:	48 89 c6             	mov    %rax,%rsi
  8001d9:	48 bf c7 45 80 00 00 	movabs $0x8045c7,%rdi
  8001e0:	00 00 00 
  8001e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e8:	48 b9 65 30 80 00 00 	movabs $0x803065,%rcx
  8001ef:	00 00 00 
  8001f2:	ff d1                	callq  *%rcx
  8001f4:	eb 3c                	jmp    800232 <umain+0x103>
			else {
				cat(f, argv[i]);
  8001f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001f9:	48 98                	cltq   
  8001fb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800202:	00 
  800203:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800207:	48 01 d0             	add    %rdx,%rax
  80020a:	48 8b 10             	mov    (%rax),%rdx
  80020d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800210:	48 89 d6             	mov    %rdx,%rsi
  800213:	89 c7                	mov    %eax,%edi
  800215:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80021c:	00 00 00 
  80021f:	ff d0                	callq  *%rax
				close(f);
  800221:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800224:	89 c7                	mov    %eax,%edi
  800226:	48 b8 e2 20 80 00 00 	movabs $0x8020e2,%rax
  80022d:	00 00 00 
  800230:	ff d0                	callq  *%rax

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800232:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  800236:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800239:	3b 45 dc             	cmp    -0x24(%rbp),%eax
  80023c:	0f 8c 46 ff ff ff    	jl     800188 <umain+0x59>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  800242:	48 83 c4 28          	add    $0x28,%rsp
  800246:	5b                   	pop    %rbx
  800247:	5d                   	pop    %rbp
  800248:	c3                   	retq   

0000000000800249 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800249:	55                   	push   %rbp
  80024a:	48 89 e5             	mov    %rsp,%rbp
  80024d:	48 83 ec 10          	sub    $0x10,%rsp
  800251:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800254:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800258:	48 b8 90 19 80 00 00 	movabs $0x801990,%rax
  80025f:	00 00 00 
  800262:	ff d0                	callq  *%rax
  800264:	25 ff 03 00 00       	and    $0x3ff,%eax
  800269:	48 98                	cltq   
  80026b:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800272:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800279:	00 00 00 
  80027c:	48 01 c2             	add    %rax,%rdx
  80027f:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  800286:	00 00 00 
  800289:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80028c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800290:	7e 14                	jle    8002a6 <libmain+0x5d>
		binaryname = argv[0];
  800292:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800296:	48 8b 10             	mov    (%rax),%rdx
  800299:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002a0:	00 00 00 
  8002a3:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ad:	48 89 d6             	mov    %rdx,%rsi
  8002b0:	89 c7                	mov    %eax,%edi
  8002b2:	48 b8 2f 01 80 00 00 	movabs $0x80012f,%rax
  8002b9:	00 00 00 
  8002bc:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8002be:	48 b8 cc 02 80 00 00 	movabs $0x8002cc,%rax
  8002c5:	00 00 00 
  8002c8:	ff d0                	callq  *%rax
}
  8002ca:	c9                   	leaveq 
  8002cb:	c3                   	retq   

00000000008002cc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002cc:	55                   	push   %rbp
  8002cd:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8002d0:	48 b8 2d 21 80 00 00 	movabs $0x80212d,%rax
  8002d7:	00 00 00 
  8002da:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8002dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8002e1:	48 b8 4c 19 80 00 00 	movabs $0x80194c,%rax
  8002e8:	00 00 00 
  8002eb:	ff d0                	callq  *%rax
}
  8002ed:	5d                   	pop    %rbp
  8002ee:	c3                   	retq   

00000000008002ef <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002ef:	55                   	push   %rbp
  8002f0:	48 89 e5             	mov    %rsp,%rbp
  8002f3:	53                   	push   %rbx
  8002f4:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8002fb:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800302:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800308:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80030f:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800316:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80031d:	84 c0                	test   %al,%al
  80031f:	74 23                	je     800344 <_panic+0x55>
  800321:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800328:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80032c:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800330:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800334:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800338:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80033c:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800340:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800344:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80034b:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800352:	00 00 00 
  800355:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80035c:	00 00 00 
  80035f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800363:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80036a:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800371:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800378:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80037f:	00 00 00 
  800382:	48 8b 18             	mov    (%rax),%rbx
  800385:	48 b8 90 19 80 00 00 	movabs $0x801990,%rax
  80038c:	00 00 00 
  80038f:	ff d0                	callq  *%rax
  800391:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800397:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80039e:	41 89 c8             	mov    %ecx,%r8d
  8003a1:	48 89 d1             	mov    %rdx,%rcx
  8003a4:	48 89 da             	mov    %rbx,%rdx
  8003a7:	89 c6                	mov    %eax,%esi
  8003a9:	48 bf e8 45 80 00 00 	movabs $0x8045e8,%rdi
  8003b0:	00 00 00 
  8003b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b8:	49 b9 28 05 80 00 00 	movabs $0x800528,%r9
  8003bf:	00 00 00 
  8003c2:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003c5:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003cc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003d3:	48 89 d6             	mov    %rdx,%rsi
  8003d6:	48 89 c7             	mov    %rax,%rdi
  8003d9:	48 b8 7c 04 80 00 00 	movabs $0x80047c,%rax
  8003e0:	00 00 00 
  8003e3:	ff d0                	callq  *%rax
	cprintf("\n");
  8003e5:	48 bf 0b 46 80 00 00 	movabs $0x80460b,%rdi
  8003ec:	00 00 00 
  8003ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f4:	48 ba 28 05 80 00 00 	movabs $0x800528,%rdx
  8003fb:	00 00 00 
  8003fe:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800400:	cc                   	int3   
  800401:	eb fd                	jmp    800400 <_panic+0x111>

0000000000800403 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800403:	55                   	push   %rbp
  800404:	48 89 e5             	mov    %rsp,%rbp
  800407:	48 83 ec 10          	sub    $0x10,%rsp
  80040b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80040e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800412:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800416:	8b 00                	mov    (%rax),%eax
  800418:	8d 48 01             	lea    0x1(%rax),%ecx
  80041b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80041f:	89 0a                	mov    %ecx,(%rdx)
  800421:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800424:	89 d1                	mov    %edx,%ecx
  800426:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80042a:	48 98                	cltq   
  80042c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800430:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800434:	8b 00                	mov    (%rax),%eax
  800436:	3d ff 00 00 00       	cmp    $0xff,%eax
  80043b:	75 2c                	jne    800469 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80043d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800441:	8b 00                	mov    (%rax),%eax
  800443:	48 98                	cltq   
  800445:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800449:	48 83 c2 08          	add    $0x8,%rdx
  80044d:	48 89 c6             	mov    %rax,%rsi
  800450:	48 89 d7             	mov    %rdx,%rdi
  800453:	48 b8 c4 18 80 00 00 	movabs $0x8018c4,%rax
  80045a:	00 00 00 
  80045d:	ff d0                	callq  *%rax
        b->idx = 0;
  80045f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800463:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800469:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80046d:	8b 40 04             	mov    0x4(%rax),%eax
  800470:	8d 50 01             	lea    0x1(%rax),%edx
  800473:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800477:	89 50 04             	mov    %edx,0x4(%rax)
}
  80047a:	c9                   	leaveq 
  80047b:	c3                   	retq   

000000000080047c <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80047c:	55                   	push   %rbp
  80047d:	48 89 e5             	mov    %rsp,%rbp
  800480:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800487:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80048e:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800495:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80049c:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004a3:	48 8b 0a             	mov    (%rdx),%rcx
  8004a6:	48 89 08             	mov    %rcx,(%rax)
  8004a9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004ad:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004b1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004b5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8004b9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004c0:	00 00 00 
    b.cnt = 0;
  8004c3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004ca:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004cd:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004d4:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004db:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004e2:	48 89 c6             	mov    %rax,%rsi
  8004e5:	48 bf 03 04 80 00 00 	movabs $0x800403,%rdi
  8004ec:	00 00 00 
  8004ef:	48 b8 db 08 80 00 00 	movabs $0x8008db,%rax
  8004f6:	00 00 00 
  8004f9:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8004fb:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800501:	48 98                	cltq   
  800503:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80050a:	48 83 c2 08          	add    $0x8,%rdx
  80050e:	48 89 c6             	mov    %rax,%rsi
  800511:	48 89 d7             	mov    %rdx,%rdi
  800514:	48 b8 c4 18 80 00 00 	movabs $0x8018c4,%rax
  80051b:	00 00 00 
  80051e:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800520:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800526:	c9                   	leaveq 
  800527:	c3                   	retq   

0000000000800528 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800528:	55                   	push   %rbp
  800529:	48 89 e5             	mov    %rsp,%rbp
  80052c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800533:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80053a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800541:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800548:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80054f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800556:	84 c0                	test   %al,%al
  800558:	74 20                	je     80057a <cprintf+0x52>
  80055a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80055e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800562:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800566:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80056a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80056e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800572:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800576:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80057a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800581:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800588:	00 00 00 
  80058b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800592:	00 00 00 
  800595:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800599:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005a0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005a7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8005ae:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005b5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005bc:	48 8b 0a             	mov    (%rdx),%rcx
  8005bf:	48 89 08             	mov    %rcx,(%rax)
  8005c2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005c6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005ca:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005ce:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005d2:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005d9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005e0:	48 89 d6             	mov    %rdx,%rsi
  8005e3:	48 89 c7             	mov    %rax,%rdi
  8005e6:	48 b8 7c 04 80 00 00 	movabs $0x80047c,%rax
  8005ed:	00 00 00 
  8005f0:	ff d0                	callq  *%rax
  8005f2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005f8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005fe:	c9                   	leaveq 
  8005ff:	c3                   	retq   

0000000000800600 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800600:	55                   	push   %rbp
  800601:	48 89 e5             	mov    %rsp,%rbp
  800604:	53                   	push   %rbx
  800605:	48 83 ec 38          	sub    $0x38,%rsp
  800609:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80060d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800611:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800615:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800618:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80061c:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800620:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800623:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800627:	77 3b                	ja     800664 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800629:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80062c:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800630:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800633:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800637:	ba 00 00 00 00       	mov    $0x0,%edx
  80063c:	48 f7 f3             	div    %rbx
  80063f:	48 89 c2             	mov    %rax,%rdx
  800642:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800645:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800648:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80064c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800650:	41 89 f9             	mov    %edi,%r9d
  800653:	48 89 c7             	mov    %rax,%rdi
  800656:	48 b8 00 06 80 00 00 	movabs $0x800600,%rax
  80065d:	00 00 00 
  800660:	ff d0                	callq  *%rax
  800662:	eb 1e                	jmp    800682 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800664:	eb 12                	jmp    800678 <printnum+0x78>
			putch(padc, putdat);
  800666:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80066a:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80066d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800671:	48 89 ce             	mov    %rcx,%rsi
  800674:	89 d7                	mov    %edx,%edi
  800676:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800678:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80067c:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800680:	7f e4                	jg     800666 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800682:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800685:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
  80068e:	48 f7 f1             	div    %rcx
  800691:	48 89 d0             	mov    %rdx,%rax
  800694:	48 ba 10 48 80 00 00 	movabs $0x804810,%rdx
  80069b:	00 00 00 
  80069e:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006a2:	0f be d0             	movsbl %al,%edx
  8006a5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ad:	48 89 ce             	mov    %rcx,%rsi
  8006b0:	89 d7                	mov    %edx,%edi
  8006b2:	ff d0                	callq  *%rax
}
  8006b4:	48 83 c4 38          	add    $0x38,%rsp
  8006b8:	5b                   	pop    %rbx
  8006b9:	5d                   	pop    %rbp
  8006ba:	c3                   	retq   

00000000008006bb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006bb:	55                   	push   %rbp
  8006bc:	48 89 e5             	mov    %rsp,%rbp
  8006bf:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006c7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006ca:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006ce:	7e 52                	jle    800722 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d4:	8b 00                	mov    (%rax),%eax
  8006d6:	83 f8 30             	cmp    $0x30,%eax
  8006d9:	73 24                	jae    8006ff <getuint+0x44>
  8006db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006df:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e7:	8b 00                	mov    (%rax),%eax
  8006e9:	89 c0                	mov    %eax,%eax
  8006eb:	48 01 d0             	add    %rdx,%rax
  8006ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f2:	8b 12                	mov    (%rdx),%edx
  8006f4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fb:	89 0a                	mov    %ecx,(%rdx)
  8006fd:	eb 17                	jmp    800716 <getuint+0x5b>
  8006ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800703:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800707:	48 89 d0             	mov    %rdx,%rax
  80070a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80070e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800712:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800716:	48 8b 00             	mov    (%rax),%rax
  800719:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80071d:	e9 a3 00 00 00       	jmpq   8007c5 <getuint+0x10a>
	else if (lflag)
  800722:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800726:	74 4f                	je     800777 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800728:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072c:	8b 00                	mov    (%rax),%eax
  80072e:	83 f8 30             	cmp    $0x30,%eax
  800731:	73 24                	jae    800757 <getuint+0x9c>
  800733:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800737:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80073b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073f:	8b 00                	mov    (%rax),%eax
  800741:	89 c0                	mov    %eax,%eax
  800743:	48 01 d0             	add    %rdx,%rax
  800746:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074a:	8b 12                	mov    (%rdx),%edx
  80074c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80074f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800753:	89 0a                	mov    %ecx,(%rdx)
  800755:	eb 17                	jmp    80076e <getuint+0xb3>
  800757:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80075f:	48 89 d0             	mov    %rdx,%rax
  800762:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800766:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80076e:	48 8b 00             	mov    (%rax),%rax
  800771:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800775:	eb 4e                	jmp    8007c5 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800777:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077b:	8b 00                	mov    (%rax),%eax
  80077d:	83 f8 30             	cmp    $0x30,%eax
  800780:	73 24                	jae    8007a6 <getuint+0xeb>
  800782:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800786:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80078a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078e:	8b 00                	mov    (%rax),%eax
  800790:	89 c0                	mov    %eax,%eax
  800792:	48 01 d0             	add    %rdx,%rax
  800795:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800799:	8b 12                	mov    (%rdx),%edx
  80079b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80079e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a2:	89 0a                	mov    %ecx,(%rdx)
  8007a4:	eb 17                	jmp    8007bd <getuint+0x102>
  8007a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007aa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007ae:	48 89 d0             	mov    %rdx,%rax
  8007b1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007bd:	8b 00                	mov    (%rax),%eax
  8007bf:	89 c0                	mov    %eax,%eax
  8007c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007c9:	c9                   	leaveq 
  8007ca:	c3                   	retq   

00000000008007cb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007cb:	55                   	push   %rbp
  8007cc:	48 89 e5             	mov    %rsp,%rbp
  8007cf:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007d7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007da:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007de:	7e 52                	jle    800832 <getint+0x67>
		x=va_arg(*ap, long long);
  8007e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e4:	8b 00                	mov    (%rax),%eax
  8007e6:	83 f8 30             	cmp    $0x30,%eax
  8007e9:	73 24                	jae    80080f <getint+0x44>
  8007eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ef:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f7:	8b 00                	mov    (%rax),%eax
  8007f9:	89 c0                	mov    %eax,%eax
  8007fb:	48 01 d0             	add    %rdx,%rax
  8007fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800802:	8b 12                	mov    (%rdx),%edx
  800804:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800807:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080b:	89 0a                	mov    %ecx,(%rdx)
  80080d:	eb 17                	jmp    800826 <getint+0x5b>
  80080f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800813:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800817:	48 89 d0             	mov    %rdx,%rax
  80081a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80081e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800822:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800826:	48 8b 00             	mov    (%rax),%rax
  800829:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80082d:	e9 a3 00 00 00       	jmpq   8008d5 <getint+0x10a>
	else if (lflag)
  800832:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800836:	74 4f                	je     800887 <getint+0xbc>
		x=va_arg(*ap, long);
  800838:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083c:	8b 00                	mov    (%rax),%eax
  80083e:	83 f8 30             	cmp    $0x30,%eax
  800841:	73 24                	jae    800867 <getint+0x9c>
  800843:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800847:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80084b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084f:	8b 00                	mov    (%rax),%eax
  800851:	89 c0                	mov    %eax,%eax
  800853:	48 01 d0             	add    %rdx,%rax
  800856:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085a:	8b 12                	mov    (%rdx),%edx
  80085c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80085f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800863:	89 0a                	mov    %ecx,(%rdx)
  800865:	eb 17                	jmp    80087e <getint+0xb3>
  800867:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80086f:	48 89 d0             	mov    %rdx,%rax
  800872:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800876:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80087a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80087e:	48 8b 00             	mov    (%rax),%rax
  800881:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800885:	eb 4e                	jmp    8008d5 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800887:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088b:	8b 00                	mov    (%rax),%eax
  80088d:	83 f8 30             	cmp    $0x30,%eax
  800890:	73 24                	jae    8008b6 <getint+0xeb>
  800892:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800896:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80089a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089e:	8b 00                	mov    (%rax),%eax
  8008a0:	89 c0                	mov    %eax,%eax
  8008a2:	48 01 d0             	add    %rdx,%rax
  8008a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a9:	8b 12                	mov    (%rdx),%edx
  8008ab:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b2:	89 0a                	mov    %ecx,(%rdx)
  8008b4:	eb 17                	jmp    8008cd <getint+0x102>
  8008b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ba:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008be:	48 89 d0             	mov    %rdx,%rax
  8008c1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008cd:	8b 00                	mov    (%rax),%eax
  8008cf:	48 98                	cltq   
  8008d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008d9:	c9                   	leaveq 
  8008da:	c3                   	retq   

00000000008008db <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008db:	55                   	push   %rbp
  8008dc:	48 89 e5             	mov    %rsp,%rbp
  8008df:	41 54                	push   %r12
  8008e1:	53                   	push   %rbx
  8008e2:	48 83 ec 60          	sub    $0x60,%rsp
  8008e6:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008ea:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008ee:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008f2:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008f6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008fa:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008fe:	48 8b 0a             	mov    (%rdx),%rcx
  800901:	48 89 08             	mov    %rcx,(%rax)
  800904:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800908:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80090c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800910:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800914:	eb 17                	jmp    80092d <vprintfmt+0x52>
			if (ch == '\0')
  800916:	85 db                	test   %ebx,%ebx
  800918:	0f 84 cc 04 00 00    	je     800dea <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80091e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800922:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800926:	48 89 d6             	mov    %rdx,%rsi
  800929:	89 df                	mov    %ebx,%edi
  80092b:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80092d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800931:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800935:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800939:	0f b6 00             	movzbl (%rax),%eax
  80093c:	0f b6 d8             	movzbl %al,%ebx
  80093f:	83 fb 25             	cmp    $0x25,%ebx
  800942:	75 d2                	jne    800916 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800944:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800948:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80094f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800956:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80095d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800964:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800968:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80096c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800970:	0f b6 00             	movzbl (%rax),%eax
  800973:	0f b6 d8             	movzbl %al,%ebx
  800976:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800979:	83 f8 55             	cmp    $0x55,%eax
  80097c:	0f 87 34 04 00 00    	ja     800db6 <vprintfmt+0x4db>
  800982:	89 c0                	mov    %eax,%eax
  800984:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80098b:	00 
  80098c:	48 b8 38 48 80 00 00 	movabs $0x804838,%rax
  800993:	00 00 00 
  800996:	48 01 d0             	add    %rdx,%rax
  800999:	48 8b 00             	mov    (%rax),%rax
  80099c:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80099e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009a2:	eb c0                	jmp    800964 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009a4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009a8:	eb ba                	jmp    800964 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009aa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009b1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009b4:	89 d0                	mov    %edx,%eax
  8009b6:	c1 e0 02             	shl    $0x2,%eax
  8009b9:	01 d0                	add    %edx,%eax
  8009bb:	01 c0                	add    %eax,%eax
  8009bd:	01 d8                	add    %ebx,%eax
  8009bf:	83 e8 30             	sub    $0x30,%eax
  8009c2:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009c5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009c9:	0f b6 00             	movzbl (%rax),%eax
  8009cc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009cf:	83 fb 2f             	cmp    $0x2f,%ebx
  8009d2:	7e 0c                	jle    8009e0 <vprintfmt+0x105>
  8009d4:	83 fb 39             	cmp    $0x39,%ebx
  8009d7:	7f 07                	jg     8009e0 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009de:	eb d1                	jmp    8009b1 <vprintfmt+0xd6>
			goto process_precision;
  8009e0:	eb 58                	jmp    800a3a <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8009e2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e5:	83 f8 30             	cmp    $0x30,%eax
  8009e8:	73 17                	jae    800a01 <vprintfmt+0x126>
  8009ea:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009ee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f1:	89 c0                	mov    %eax,%eax
  8009f3:	48 01 d0             	add    %rdx,%rax
  8009f6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009f9:	83 c2 08             	add    $0x8,%edx
  8009fc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009ff:	eb 0f                	jmp    800a10 <vprintfmt+0x135>
  800a01:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a05:	48 89 d0             	mov    %rdx,%rax
  800a08:	48 83 c2 08          	add    $0x8,%rdx
  800a0c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a10:	8b 00                	mov    (%rax),%eax
  800a12:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a15:	eb 23                	jmp    800a3a <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800a17:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a1b:	79 0c                	jns    800a29 <vprintfmt+0x14e>
				width = 0;
  800a1d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a24:	e9 3b ff ff ff       	jmpq   800964 <vprintfmt+0x89>
  800a29:	e9 36 ff ff ff       	jmpq   800964 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a2e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a35:	e9 2a ff ff ff       	jmpq   800964 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800a3a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a3e:	79 12                	jns    800a52 <vprintfmt+0x177>
				width = precision, precision = -1;
  800a40:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a43:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a46:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a4d:	e9 12 ff ff ff       	jmpq   800964 <vprintfmt+0x89>
  800a52:	e9 0d ff ff ff       	jmpq   800964 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a57:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a5b:	e9 04 ff ff ff       	jmpq   800964 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a60:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a63:	83 f8 30             	cmp    $0x30,%eax
  800a66:	73 17                	jae    800a7f <vprintfmt+0x1a4>
  800a68:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a6c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6f:	89 c0                	mov    %eax,%eax
  800a71:	48 01 d0             	add    %rdx,%rax
  800a74:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a77:	83 c2 08             	add    $0x8,%edx
  800a7a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a7d:	eb 0f                	jmp    800a8e <vprintfmt+0x1b3>
  800a7f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a83:	48 89 d0             	mov    %rdx,%rax
  800a86:	48 83 c2 08          	add    $0x8,%rdx
  800a8a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a8e:	8b 10                	mov    (%rax),%edx
  800a90:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a94:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a98:	48 89 ce             	mov    %rcx,%rsi
  800a9b:	89 d7                	mov    %edx,%edi
  800a9d:	ff d0                	callq  *%rax
			break;
  800a9f:	e9 40 03 00 00       	jmpq   800de4 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800aa4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa7:	83 f8 30             	cmp    $0x30,%eax
  800aaa:	73 17                	jae    800ac3 <vprintfmt+0x1e8>
  800aac:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ab0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab3:	89 c0                	mov    %eax,%eax
  800ab5:	48 01 d0             	add    %rdx,%rax
  800ab8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800abb:	83 c2 08             	add    $0x8,%edx
  800abe:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ac1:	eb 0f                	jmp    800ad2 <vprintfmt+0x1f7>
  800ac3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ac7:	48 89 d0             	mov    %rdx,%rax
  800aca:	48 83 c2 08          	add    $0x8,%rdx
  800ace:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ad2:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ad4:	85 db                	test   %ebx,%ebx
  800ad6:	79 02                	jns    800ada <vprintfmt+0x1ff>
				err = -err;
  800ad8:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ada:	83 fb 15             	cmp    $0x15,%ebx
  800add:	7f 16                	jg     800af5 <vprintfmt+0x21a>
  800adf:	48 b8 60 47 80 00 00 	movabs $0x804760,%rax
  800ae6:	00 00 00 
  800ae9:	48 63 d3             	movslq %ebx,%rdx
  800aec:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800af0:	4d 85 e4             	test   %r12,%r12
  800af3:	75 2e                	jne    800b23 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800af5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800af9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800afd:	89 d9                	mov    %ebx,%ecx
  800aff:	48 ba 21 48 80 00 00 	movabs $0x804821,%rdx
  800b06:	00 00 00 
  800b09:	48 89 c7             	mov    %rax,%rdi
  800b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b11:	49 b8 f3 0d 80 00 00 	movabs $0x800df3,%r8
  800b18:	00 00 00 
  800b1b:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b1e:	e9 c1 02 00 00       	jmpq   800de4 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b23:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b2b:	4c 89 e1             	mov    %r12,%rcx
  800b2e:	48 ba 2a 48 80 00 00 	movabs $0x80482a,%rdx
  800b35:	00 00 00 
  800b38:	48 89 c7             	mov    %rax,%rdi
  800b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b40:	49 b8 f3 0d 80 00 00 	movabs $0x800df3,%r8
  800b47:	00 00 00 
  800b4a:	41 ff d0             	callq  *%r8
			break;
  800b4d:	e9 92 02 00 00       	jmpq   800de4 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b52:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b55:	83 f8 30             	cmp    $0x30,%eax
  800b58:	73 17                	jae    800b71 <vprintfmt+0x296>
  800b5a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b5e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b61:	89 c0                	mov    %eax,%eax
  800b63:	48 01 d0             	add    %rdx,%rax
  800b66:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b69:	83 c2 08             	add    $0x8,%edx
  800b6c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b6f:	eb 0f                	jmp    800b80 <vprintfmt+0x2a5>
  800b71:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b75:	48 89 d0             	mov    %rdx,%rax
  800b78:	48 83 c2 08          	add    $0x8,%rdx
  800b7c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b80:	4c 8b 20             	mov    (%rax),%r12
  800b83:	4d 85 e4             	test   %r12,%r12
  800b86:	75 0a                	jne    800b92 <vprintfmt+0x2b7>
				p = "(null)";
  800b88:	49 bc 2d 48 80 00 00 	movabs $0x80482d,%r12
  800b8f:	00 00 00 
			if (width > 0 && padc != '-')
  800b92:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b96:	7e 3f                	jle    800bd7 <vprintfmt+0x2fc>
  800b98:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b9c:	74 39                	je     800bd7 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b9e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ba1:	48 98                	cltq   
  800ba3:	48 89 c6             	mov    %rax,%rsi
  800ba6:	4c 89 e7             	mov    %r12,%rdi
  800ba9:	48 b8 9f 10 80 00 00 	movabs $0x80109f,%rax
  800bb0:	00 00 00 
  800bb3:	ff d0                	callq  *%rax
  800bb5:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bb8:	eb 17                	jmp    800bd1 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800bba:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800bbe:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bc2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc6:	48 89 ce             	mov    %rcx,%rsi
  800bc9:	89 d7                	mov    %edx,%edi
  800bcb:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bcd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bd1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bd5:	7f e3                	jg     800bba <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bd7:	eb 37                	jmp    800c10 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800bd9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800bdd:	74 1e                	je     800bfd <vprintfmt+0x322>
  800bdf:	83 fb 1f             	cmp    $0x1f,%ebx
  800be2:	7e 05                	jle    800be9 <vprintfmt+0x30e>
  800be4:	83 fb 7e             	cmp    $0x7e,%ebx
  800be7:	7e 14                	jle    800bfd <vprintfmt+0x322>
					putch('?', putdat);
  800be9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf1:	48 89 d6             	mov    %rdx,%rsi
  800bf4:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bf9:	ff d0                	callq  *%rax
  800bfb:	eb 0f                	jmp    800c0c <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800bfd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c05:	48 89 d6             	mov    %rdx,%rsi
  800c08:	89 df                	mov    %ebx,%edi
  800c0a:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c0c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c10:	4c 89 e0             	mov    %r12,%rax
  800c13:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c17:	0f b6 00             	movzbl (%rax),%eax
  800c1a:	0f be d8             	movsbl %al,%ebx
  800c1d:	85 db                	test   %ebx,%ebx
  800c1f:	74 10                	je     800c31 <vprintfmt+0x356>
  800c21:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c25:	78 b2                	js     800bd9 <vprintfmt+0x2fe>
  800c27:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c2b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c2f:	79 a8                	jns    800bd9 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c31:	eb 16                	jmp    800c49 <vprintfmt+0x36e>
				putch(' ', putdat);
  800c33:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3b:	48 89 d6             	mov    %rdx,%rsi
  800c3e:	bf 20 00 00 00       	mov    $0x20,%edi
  800c43:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c45:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c49:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c4d:	7f e4                	jg     800c33 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800c4f:	e9 90 01 00 00       	jmpq   800de4 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c54:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c58:	be 03 00 00 00       	mov    $0x3,%esi
  800c5d:	48 89 c7             	mov    %rax,%rdi
  800c60:	48 b8 cb 07 80 00 00 	movabs $0x8007cb,%rax
  800c67:	00 00 00 
  800c6a:	ff d0                	callq  *%rax
  800c6c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c74:	48 85 c0             	test   %rax,%rax
  800c77:	79 1d                	jns    800c96 <vprintfmt+0x3bb>
				putch('-', putdat);
  800c79:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c81:	48 89 d6             	mov    %rdx,%rsi
  800c84:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c89:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c8f:	48 f7 d8             	neg    %rax
  800c92:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c96:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c9d:	e9 d5 00 00 00       	jmpq   800d77 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ca2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ca6:	be 03 00 00 00       	mov    $0x3,%esi
  800cab:	48 89 c7             	mov    %rax,%rdi
  800cae:	48 b8 bb 06 80 00 00 	movabs $0x8006bb,%rax
  800cb5:	00 00 00 
  800cb8:	ff d0                	callq  *%rax
  800cba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800cbe:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cc5:	e9 ad 00 00 00       	jmpq   800d77 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800cca:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cce:	be 03 00 00 00       	mov    $0x3,%esi
  800cd3:	48 89 c7             	mov    %rax,%rdi
  800cd6:	48 b8 bb 06 80 00 00 	movabs $0x8006bb,%rax
  800cdd:	00 00 00 
  800ce0:	ff d0                	callq  *%rax
  800ce2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800ce6:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ced:	e9 85 00 00 00       	jmpq   800d77 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800cf2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cf6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cfa:	48 89 d6             	mov    %rdx,%rsi
  800cfd:	bf 30 00 00 00       	mov    $0x30,%edi
  800d02:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0c:	48 89 d6             	mov    %rdx,%rsi
  800d0f:	bf 78 00 00 00       	mov    $0x78,%edi
  800d14:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d16:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d19:	83 f8 30             	cmp    $0x30,%eax
  800d1c:	73 17                	jae    800d35 <vprintfmt+0x45a>
  800d1e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d22:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d25:	89 c0                	mov    %eax,%eax
  800d27:	48 01 d0             	add    %rdx,%rax
  800d2a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d2d:	83 c2 08             	add    $0x8,%edx
  800d30:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d33:	eb 0f                	jmp    800d44 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800d35:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d39:	48 89 d0             	mov    %rdx,%rax
  800d3c:	48 83 c2 08          	add    $0x8,%rdx
  800d40:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d44:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d47:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d4b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d52:	eb 23                	jmp    800d77 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d54:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d58:	be 03 00 00 00       	mov    $0x3,%esi
  800d5d:	48 89 c7             	mov    %rax,%rdi
  800d60:	48 b8 bb 06 80 00 00 	movabs $0x8006bb,%rax
  800d67:	00 00 00 
  800d6a:	ff d0                	callq  *%rax
  800d6c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d70:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d77:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d7c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d7f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d82:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d86:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d8a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d8e:	45 89 c1             	mov    %r8d,%r9d
  800d91:	41 89 f8             	mov    %edi,%r8d
  800d94:	48 89 c7             	mov    %rax,%rdi
  800d97:	48 b8 00 06 80 00 00 	movabs $0x800600,%rax
  800d9e:	00 00 00 
  800da1:	ff d0                	callq  *%rax
			break;
  800da3:	eb 3f                	jmp    800de4 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800da5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800da9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dad:	48 89 d6             	mov    %rdx,%rsi
  800db0:	89 df                	mov    %ebx,%edi
  800db2:	ff d0                	callq  *%rax
			break;
  800db4:	eb 2e                	jmp    800de4 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800db6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dbe:	48 89 d6             	mov    %rdx,%rsi
  800dc1:	bf 25 00 00 00       	mov    $0x25,%edi
  800dc6:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dc8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dcd:	eb 05                	jmp    800dd4 <vprintfmt+0x4f9>
  800dcf:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dd4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dd8:	48 83 e8 01          	sub    $0x1,%rax
  800ddc:	0f b6 00             	movzbl (%rax),%eax
  800ddf:	3c 25                	cmp    $0x25,%al
  800de1:	75 ec                	jne    800dcf <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800de3:	90                   	nop
		}
	}
  800de4:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800de5:	e9 43 fb ff ff       	jmpq   80092d <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800dea:	48 83 c4 60          	add    $0x60,%rsp
  800dee:	5b                   	pop    %rbx
  800def:	41 5c                	pop    %r12
  800df1:	5d                   	pop    %rbp
  800df2:	c3                   	retq   

0000000000800df3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800df3:	55                   	push   %rbp
  800df4:	48 89 e5             	mov    %rsp,%rbp
  800df7:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800dfe:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e05:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e0c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e13:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e1a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e21:	84 c0                	test   %al,%al
  800e23:	74 20                	je     800e45 <printfmt+0x52>
  800e25:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e29:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e2d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e31:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e35:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e39:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e3d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e41:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e45:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e4c:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e53:	00 00 00 
  800e56:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e5d:	00 00 00 
  800e60:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e64:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e6b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e72:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e79:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e80:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e87:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e8e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e95:	48 89 c7             	mov    %rax,%rdi
  800e98:	48 b8 db 08 80 00 00 	movabs $0x8008db,%rax
  800e9f:	00 00 00 
  800ea2:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ea4:	c9                   	leaveq 
  800ea5:	c3                   	retq   

0000000000800ea6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ea6:	55                   	push   %rbp
  800ea7:	48 89 e5             	mov    %rsp,%rbp
  800eaa:	48 83 ec 10          	sub    $0x10,%rsp
  800eae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800eb1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800eb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eb9:	8b 40 10             	mov    0x10(%rax),%eax
  800ebc:	8d 50 01             	lea    0x1(%rax),%edx
  800ebf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ec3:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ec6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eca:	48 8b 10             	mov    (%rax),%rdx
  800ecd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ed1:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ed5:	48 39 c2             	cmp    %rax,%rdx
  800ed8:	73 17                	jae    800ef1 <sprintputch+0x4b>
		*b->buf++ = ch;
  800eda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ede:	48 8b 00             	mov    (%rax),%rax
  800ee1:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ee5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ee9:	48 89 0a             	mov    %rcx,(%rdx)
  800eec:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800eef:	88 10                	mov    %dl,(%rax)
}
  800ef1:	c9                   	leaveq 
  800ef2:	c3                   	retq   

0000000000800ef3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ef3:	55                   	push   %rbp
  800ef4:	48 89 e5             	mov    %rsp,%rbp
  800ef7:	48 83 ec 50          	sub    $0x50,%rsp
  800efb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800eff:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f02:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f06:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f0a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f0e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f12:	48 8b 0a             	mov    (%rdx),%rcx
  800f15:	48 89 08             	mov    %rcx,(%rax)
  800f18:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f1c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f20:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f24:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f28:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f2c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f30:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f33:	48 98                	cltq   
  800f35:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f39:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f3d:	48 01 d0             	add    %rdx,%rax
  800f40:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f44:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f4b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f50:	74 06                	je     800f58 <vsnprintf+0x65>
  800f52:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f56:	7f 07                	jg     800f5f <vsnprintf+0x6c>
		return -E_INVAL;
  800f58:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f5d:	eb 2f                	jmp    800f8e <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f5f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f63:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f67:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f6b:	48 89 c6             	mov    %rax,%rsi
  800f6e:	48 bf a6 0e 80 00 00 	movabs $0x800ea6,%rdi
  800f75:	00 00 00 
  800f78:	48 b8 db 08 80 00 00 	movabs $0x8008db,%rax
  800f7f:	00 00 00 
  800f82:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f84:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f88:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f8b:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f8e:	c9                   	leaveq 
  800f8f:	c3                   	retq   

0000000000800f90 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f90:	55                   	push   %rbp
  800f91:	48 89 e5             	mov    %rsp,%rbp
  800f94:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f9b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800fa2:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fa8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800faf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fb6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fbd:	84 c0                	test   %al,%al
  800fbf:	74 20                	je     800fe1 <snprintf+0x51>
  800fc1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fc5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fc9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fcd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fd1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fd5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fd9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fdd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fe1:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fe8:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fef:	00 00 00 
  800ff2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800ff9:	00 00 00 
  800ffc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801000:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801007:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80100e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801015:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80101c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801023:	48 8b 0a             	mov    (%rdx),%rcx
  801026:	48 89 08             	mov    %rcx,(%rax)
  801029:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80102d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801031:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801035:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801039:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801040:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801047:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80104d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801054:	48 89 c7             	mov    %rax,%rdi
  801057:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  80105e:	00 00 00 
  801061:	ff d0                	callq  *%rax
  801063:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801069:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80106f:	c9                   	leaveq 
  801070:	c3                   	retq   

0000000000801071 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801071:	55                   	push   %rbp
  801072:	48 89 e5             	mov    %rsp,%rbp
  801075:	48 83 ec 18          	sub    $0x18,%rsp
  801079:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80107d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801084:	eb 09                	jmp    80108f <strlen+0x1e>
		n++;
  801086:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80108a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80108f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801093:	0f b6 00             	movzbl (%rax),%eax
  801096:	84 c0                	test   %al,%al
  801098:	75 ec                	jne    801086 <strlen+0x15>
		n++;
	return n;
  80109a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80109d:	c9                   	leaveq 
  80109e:	c3                   	retq   

000000000080109f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80109f:	55                   	push   %rbp
  8010a0:	48 89 e5             	mov    %rsp,%rbp
  8010a3:	48 83 ec 20          	sub    $0x20,%rsp
  8010a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010b6:	eb 0e                	jmp    8010c6 <strnlen+0x27>
		n++;
  8010b8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010bc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010c1:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010c6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010cb:	74 0b                	je     8010d8 <strnlen+0x39>
  8010cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d1:	0f b6 00             	movzbl (%rax),%eax
  8010d4:	84 c0                	test   %al,%al
  8010d6:	75 e0                	jne    8010b8 <strnlen+0x19>
		n++;
	return n;
  8010d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010db:	c9                   	leaveq 
  8010dc:	c3                   	retq   

00000000008010dd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010dd:	55                   	push   %rbp
  8010de:	48 89 e5             	mov    %rsp,%rbp
  8010e1:	48 83 ec 20          	sub    $0x20,%rsp
  8010e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010f5:	90                   	nop
  8010f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010fe:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801102:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801106:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80110a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80110e:	0f b6 12             	movzbl (%rdx),%edx
  801111:	88 10                	mov    %dl,(%rax)
  801113:	0f b6 00             	movzbl (%rax),%eax
  801116:	84 c0                	test   %al,%al
  801118:	75 dc                	jne    8010f6 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80111a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80111e:	c9                   	leaveq 
  80111f:	c3                   	retq   

0000000000801120 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801120:	55                   	push   %rbp
  801121:	48 89 e5             	mov    %rsp,%rbp
  801124:	48 83 ec 20          	sub    $0x20,%rsp
  801128:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80112c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801130:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801134:	48 89 c7             	mov    %rax,%rdi
  801137:	48 b8 71 10 80 00 00 	movabs $0x801071,%rax
  80113e:	00 00 00 
  801141:	ff d0                	callq  *%rax
  801143:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801146:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801149:	48 63 d0             	movslq %eax,%rdx
  80114c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801150:	48 01 c2             	add    %rax,%rdx
  801153:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801157:	48 89 c6             	mov    %rax,%rsi
  80115a:	48 89 d7             	mov    %rdx,%rdi
  80115d:	48 b8 dd 10 80 00 00 	movabs $0x8010dd,%rax
  801164:	00 00 00 
  801167:	ff d0                	callq  *%rax
	return dst;
  801169:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80116d:	c9                   	leaveq 
  80116e:	c3                   	retq   

000000000080116f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80116f:	55                   	push   %rbp
  801170:	48 89 e5             	mov    %rsp,%rbp
  801173:	48 83 ec 28          	sub    $0x28,%rsp
  801177:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80117b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80117f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801183:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801187:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80118b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801192:	00 
  801193:	eb 2a                	jmp    8011bf <strncpy+0x50>
		*dst++ = *src;
  801195:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801199:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80119d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011a1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011a5:	0f b6 12             	movzbl (%rdx),%edx
  8011a8:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ae:	0f b6 00             	movzbl (%rax),%eax
  8011b1:	84 c0                	test   %al,%al
  8011b3:	74 05                	je     8011ba <strncpy+0x4b>
			src++;
  8011b5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011c7:	72 cc                	jb     801195 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011cd:	c9                   	leaveq 
  8011ce:	c3                   	retq   

00000000008011cf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011cf:	55                   	push   %rbp
  8011d0:	48 89 e5             	mov    %rsp,%rbp
  8011d3:	48 83 ec 28          	sub    $0x28,%rsp
  8011d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011df:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011eb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011f0:	74 3d                	je     80122f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011f2:	eb 1d                	jmp    801211 <strlcpy+0x42>
			*dst++ = *src++;
  8011f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801200:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801204:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801208:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80120c:	0f b6 12             	movzbl (%rdx),%edx
  80120f:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801211:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801216:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80121b:	74 0b                	je     801228 <strlcpy+0x59>
  80121d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801221:	0f b6 00             	movzbl (%rax),%eax
  801224:	84 c0                	test   %al,%al
  801226:	75 cc                	jne    8011f4 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801228:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80122f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801233:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801237:	48 29 c2             	sub    %rax,%rdx
  80123a:	48 89 d0             	mov    %rdx,%rax
}
  80123d:	c9                   	leaveq 
  80123e:	c3                   	retq   

000000000080123f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80123f:	55                   	push   %rbp
  801240:	48 89 e5             	mov    %rsp,%rbp
  801243:	48 83 ec 10          	sub    $0x10,%rsp
  801247:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80124b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80124f:	eb 0a                	jmp    80125b <strcmp+0x1c>
		p++, q++;
  801251:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801256:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80125b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125f:	0f b6 00             	movzbl (%rax),%eax
  801262:	84 c0                	test   %al,%al
  801264:	74 12                	je     801278 <strcmp+0x39>
  801266:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126a:	0f b6 10             	movzbl (%rax),%edx
  80126d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801271:	0f b6 00             	movzbl (%rax),%eax
  801274:	38 c2                	cmp    %al,%dl
  801276:	74 d9                	je     801251 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801278:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127c:	0f b6 00             	movzbl (%rax),%eax
  80127f:	0f b6 d0             	movzbl %al,%edx
  801282:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801286:	0f b6 00             	movzbl (%rax),%eax
  801289:	0f b6 c0             	movzbl %al,%eax
  80128c:	29 c2                	sub    %eax,%edx
  80128e:	89 d0                	mov    %edx,%eax
}
  801290:	c9                   	leaveq 
  801291:	c3                   	retq   

0000000000801292 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801292:	55                   	push   %rbp
  801293:	48 89 e5             	mov    %rsp,%rbp
  801296:	48 83 ec 18          	sub    $0x18,%rsp
  80129a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80129e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012a2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012a6:	eb 0f                	jmp    8012b7 <strncmp+0x25>
		n--, p++, q++;
  8012a8:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012ad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012b7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012bc:	74 1d                	je     8012db <strncmp+0x49>
  8012be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c2:	0f b6 00             	movzbl (%rax),%eax
  8012c5:	84 c0                	test   %al,%al
  8012c7:	74 12                	je     8012db <strncmp+0x49>
  8012c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cd:	0f b6 10             	movzbl (%rax),%edx
  8012d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d4:	0f b6 00             	movzbl (%rax),%eax
  8012d7:	38 c2                	cmp    %al,%dl
  8012d9:	74 cd                	je     8012a8 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012db:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012e0:	75 07                	jne    8012e9 <strncmp+0x57>
		return 0;
  8012e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e7:	eb 18                	jmp    801301 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ed:	0f b6 00             	movzbl (%rax),%eax
  8012f0:	0f b6 d0             	movzbl %al,%edx
  8012f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f7:	0f b6 00             	movzbl (%rax),%eax
  8012fa:	0f b6 c0             	movzbl %al,%eax
  8012fd:	29 c2                	sub    %eax,%edx
  8012ff:	89 d0                	mov    %edx,%eax
}
  801301:	c9                   	leaveq 
  801302:	c3                   	retq   

0000000000801303 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801303:	55                   	push   %rbp
  801304:	48 89 e5             	mov    %rsp,%rbp
  801307:	48 83 ec 0c          	sub    $0xc,%rsp
  80130b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80130f:	89 f0                	mov    %esi,%eax
  801311:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801314:	eb 17                	jmp    80132d <strchr+0x2a>
		if (*s == c)
  801316:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131a:	0f b6 00             	movzbl (%rax),%eax
  80131d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801320:	75 06                	jne    801328 <strchr+0x25>
			return (char *) s;
  801322:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801326:	eb 15                	jmp    80133d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801328:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80132d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801331:	0f b6 00             	movzbl (%rax),%eax
  801334:	84 c0                	test   %al,%al
  801336:	75 de                	jne    801316 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801338:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80133d:	c9                   	leaveq 
  80133e:	c3                   	retq   

000000000080133f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80133f:	55                   	push   %rbp
  801340:	48 89 e5             	mov    %rsp,%rbp
  801343:	48 83 ec 0c          	sub    $0xc,%rsp
  801347:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80134b:	89 f0                	mov    %esi,%eax
  80134d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801350:	eb 13                	jmp    801365 <strfind+0x26>
		if (*s == c)
  801352:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801356:	0f b6 00             	movzbl (%rax),%eax
  801359:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80135c:	75 02                	jne    801360 <strfind+0x21>
			break;
  80135e:	eb 10                	jmp    801370 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801360:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801365:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801369:	0f b6 00             	movzbl (%rax),%eax
  80136c:	84 c0                	test   %al,%al
  80136e:	75 e2                	jne    801352 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801370:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801374:	c9                   	leaveq 
  801375:	c3                   	retq   

0000000000801376 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801376:	55                   	push   %rbp
  801377:	48 89 e5             	mov    %rsp,%rbp
  80137a:	48 83 ec 18          	sub    $0x18,%rsp
  80137e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801382:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801385:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801389:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80138e:	75 06                	jne    801396 <memset+0x20>
		return v;
  801390:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801394:	eb 69                	jmp    8013ff <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801396:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139a:	83 e0 03             	and    $0x3,%eax
  80139d:	48 85 c0             	test   %rax,%rax
  8013a0:	75 48                	jne    8013ea <memset+0x74>
  8013a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a6:	83 e0 03             	and    $0x3,%eax
  8013a9:	48 85 c0             	test   %rax,%rax
  8013ac:	75 3c                	jne    8013ea <memset+0x74>
		c &= 0xFF;
  8013ae:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013b8:	c1 e0 18             	shl    $0x18,%eax
  8013bb:	89 c2                	mov    %eax,%edx
  8013bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c0:	c1 e0 10             	shl    $0x10,%eax
  8013c3:	09 c2                	or     %eax,%edx
  8013c5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c8:	c1 e0 08             	shl    $0x8,%eax
  8013cb:	09 d0                	or     %edx,%eax
  8013cd:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8013d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d4:	48 c1 e8 02          	shr    $0x2,%rax
  8013d8:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013db:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013df:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013e2:	48 89 d7             	mov    %rdx,%rdi
  8013e5:	fc                   	cld    
  8013e6:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013e8:	eb 11                	jmp    8013fb <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013ea:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013f1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013f5:	48 89 d7             	mov    %rdx,%rdi
  8013f8:	fc                   	cld    
  8013f9:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013ff:	c9                   	leaveq 
  801400:	c3                   	retq   

0000000000801401 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801401:	55                   	push   %rbp
  801402:	48 89 e5             	mov    %rsp,%rbp
  801405:	48 83 ec 28          	sub    $0x28,%rsp
  801409:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80140d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801411:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801415:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801419:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80141d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801421:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801425:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801429:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80142d:	0f 83 88 00 00 00    	jae    8014bb <memmove+0xba>
  801433:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801437:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80143b:	48 01 d0             	add    %rdx,%rax
  80143e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801442:	76 77                	jbe    8014bb <memmove+0xba>
		s += n;
  801444:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801448:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80144c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801450:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801454:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801458:	83 e0 03             	and    $0x3,%eax
  80145b:	48 85 c0             	test   %rax,%rax
  80145e:	75 3b                	jne    80149b <memmove+0x9a>
  801460:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801464:	83 e0 03             	and    $0x3,%eax
  801467:	48 85 c0             	test   %rax,%rax
  80146a:	75 2f                	jne    80149b <memmove+0x9a>
  80146c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801470:	83 e0 03             	and    $0x3,%eax
  801473:	48 85 c0             	test   %rax,%rax
  801476:	75 23                	jne    80149b <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801478:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147c:	48 83 e8 04          	sub    $0x4,%rax
  801480:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801484:	48 83 ea 04          	sub    $0x4,%rdx
  801488:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80148c:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801490:	48 89 c7             	mov    %rax,%rdi
  801493:	48 89 d6             	mov    %rdx,%rsi
  801496:	fd                   	std    
  801497:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801499:	eb 1d                	jmp    8014b8 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80149b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a7:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014af:	48 89 d7             	mov    %rdx,%rdi
  8014b2:	48 89 c1             	mov    %rax,%rcx
  8014b5:	fd                   	std    
  8014b6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014b8:	fc                   	cld    
  8014b9:	eb 57                	jmp    801512 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014bf:	83 e0 03             	and    $0x3,%eax
  8014c2:	48 85 c0             	test   %rax,%rax
  8014c5:	75 36                	jne    8014fd <memmove+0xfc>
  8014c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014cb:	83 e0 03             	and    $0x3,%eax
  8014ce:	48 85 c0             	test   %rax,%rax
  8014d1:	75 2a                	jne    8014fd <memmove+0xfc>
  8014d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d7:	83 e0 03             	and    $0x3,%eax
  8014da:	48 85 c0             	test   %rax,%rax
  8014dd:	75 1e                	jne    8014fd <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e3:	48 c1 e8 02          	shr    $0x2,%rax
  8014e7:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014f2:	48 89 c7             	mov    %rax,%rdi
  8014f5:	48 89 d6             	mov    %rdx,%rsi
  8014f8:	fc                   	cld    
  8014f9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014fb:	eb 15                	jmp    801512 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801501:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801505:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801509:	48 89 c7             	mov    %rax,%rdi
  80150c:	48 89 d6             	mov    %rdx,%rsi
  80150f:	fc                   	cld    
  801510:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801512:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801516:	c9                   	leaveq 
  801517:	c3                   	retq   

0000000000801518 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801518:	55                   	push   %rbp
  801519:	48 89 e5             	mov    %rsp,%rbp
  80151c:	48 83 ec 18          	sub    $0x18,%rsp
  801520:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801524:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801528:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80152c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801530:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801534:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801538:	48 89 ce             	mov    %rcx,%rsi
  80153b:	48 89 c7             	mov    %rax,%rdi
  80153e:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  801545:	00 00 00 
  801548:	ff d0                	callq  *%rax
}
  80154a:	c9                   	leaveq 
  80154b:	c3                   	retq   

000000000080154c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80154c:	55                   	push   %rbp
  80154d:	48 89 e5             	mov    %rsp,%rbp
  801550:	48 83 ec 28          	sub    $0x28,%rsp
  801554:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801558:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80155c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801560:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801564:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801568:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80156c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801570:	eb 36                	jmp    8015a8 <memcmp+0x5c>
		if (*s1 != *s2)
  801572:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801576:	0f b6 10             	movzbl (%rax),%edx
  801579:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157d:	0f b6 00             	movzbl (%rax),%eax
  801580:	38 c2                	cmp    %al,%dl
  801582:	74 1a                	je     80159e <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801584:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801588:	0f b6 00             	movzbl (%rax),%eax
  80158b:	0f b6 d0             	movzbl %al,%edx
  80158e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801592:	0f b6 00             	movzbl (%rax),%eax
  801595:	0f b6 c0             	movzbl %al,%eax
  801598:	29 c2                	sub    %eax,%edx
  80159a:	89 d0                	mov    %edx,%eax
  80159c:	eb 20                	jmp    8015be <memcmp+0x72>
		s1++, s2++;
  80159e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015a3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ac:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015b0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015b4:	48 85 c0             	test   %rax,%rax
  8015b7:	75 b9                	jne    801572 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015be:	c9                   	leaveq 
  8015bf:	c3                   	retq   

00000000008015c0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015c0:	55                   	push   %rbp
  8015c1:	48 89 e5             	mov    %rsp,%rbp
  8015c4:	48 83 ec 28          	sub    $0x28,%rsp
  8015c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015cc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015cf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015db:	48 01 d0             	add    %rdx,%rax
  8015de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015e2:	eb 15                	jmp    8015f9 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e8:	0f b6 10             	movzbl (%rax),%edx
  8015eb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015ee:	38 c2                	cmp    %al,%dl
  8015f0:	75 02                	jne    8015f4 <memfind+0x34>
			break;
  8015f2:	eb 0f                	jmp    801603 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015f4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015fd:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801601:	72 e1                	jb     8015e4 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801603:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801607:	c9                   	leaveq 
  801608:	c3                   	retq   

0000000000801609 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801609:	55                   	push   %rbp
  80160a:	48 89 e5             	mov    %rsp,%rbp
  80160d:	48 83 ec 34          	sub    $0x34,%rsp
  801611:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801615:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801619:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80161c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801623:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80162a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80162b:	eb 05                	jmp    801632 <strtol+0x29>
		s++;
  80162d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801632:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801636:	0f b6 00             	movzbl (%rax),%eax
  801639:	3c 20                	cmp    $0x20,%al
  80163b:	74 f0                	je     80162d <strtol+0x24>
  80163d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801641:	0f b6 00             	movzbl (%rax),%eax
  801644:	3c 09                	cmp    $0x9,%al
  801646:	74 e5                	je     80162d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801648:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164c:	0f b6 00             	movzbl (%rax),%eax
  80164f:	3c 2b                	cmp    $0x2b,%al
  801651:	75 07                	jne    80165a <strtol+0x51>
		s++;
  801653:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801658:	eb 17                	jmp    801671 <strtol+0x68>
	else if (*s == '-')
  80165a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165e:	0f b6 00             	movzbl (%rax),%eax
  801661:	3c 2d                	cmp    $0x2d,%al
  801663:	75 0c                	jne    801671 <strtol+0x68>
		s++, neg = 1;
  801665:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80166a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801671:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801675:	74 06                	je     80167d <strtol+0x74>
  801677:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80167b:	75 28                	jne    8016a5 <strtol+0x9c>
  80167d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801681:	0f b6 00             	movzbl (%rax),%eax
  801684:	3c 30                	cmp    $0x30,%al
  801686:	75 1d                	jne    8016a5 <strtol+0x9c>
  801688:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168c:	48 83 c0 01          	add    $0x1,%rax
  801690:	0f b6 00             	movzbl (%rax),%eax
  801693:	3c 78                	cmp    $0x78,%al
  801695:	75 0e                	jne    8016a5 <strtol+0x9c>
		s += 2, base = 16;
  801697:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80169c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016a3:	eb 2c                	jmp    8016d1 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016a5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016a9:	75 19                	jne    8016c4 <strtol+0xbb>
  8016ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016af:	0f b6 00             	movzbl (%rax),%eax
  8016b2:	3c 30                	cmp    $0x30,%al
  8016b4:	75 0e                	jne    8016c4 <strtol+0xbb>
		s++, base = 8;
  8016b6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016bb:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016c2:	eb 0d                	jmp    8016d1 <strtol+0xc8>
	else if (base == 0)
  8016c4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016c8:	75 07                	jne    8016d1 <strtol+0xc8>
		base = 10;
  8016ca:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d5:	0f b6 00             	movzbl (%rax),%eax
  8016d8:	3c 2f                	cmp    $0x2f,%al
  8016da:	7e 1d                	jle    8016f9 <strtol+0xf0>
  8016dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e0:	0f b6 00             	movzbl (%rax),%eax
  8016e3:	3c 39                	cmp    $0x39,%al
  8016e5:	7f 12                	jg     8016f9 <strtol+0xf0>
			dig = *s - '0';
  8016e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016eb:	0f b6 00             	movzbl (%rax),%eax
  8016ee:	0f be c0             	movsbl %al,%eax
  8016f1:	83 e8 30             	sub    $0x30,%eax
  8016f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016f7:	eb 4e                	jmp    801747 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fd:	0f b6 00             	movzbl (%rax),%eax
  801700:	3c 60                	cmp    $0x60,%al
  801702:	7e 1d                	jle    801721 <strtol+0x118>
  801704:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801708:	0f b6 00             	movzbl (%rax),%eax
  80170b:	3c 7a                	cmp    $0x7a,%al
  80170d:	7f 12                	jg     801721 <strtol+0x118>
			dig = *s - 'a' + 10;
  80170f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801713:	0f b6 00             	movzbl (%rax),%eax
  801716:	0f be c0             	movsbl %al,%eax
  801719:	83 e8 57             	sub    $0x57,%eax
  80171c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80171f:	eb 26                	jmp    801747 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801721:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801725:	0f b6 00             	movzbl (%rax),%eax
  801728:	3c 40                	cmp    $0x40,%al
  80172a:	7e 48                	jle    801774 <strtol+0x16b>
  80172c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801730:	0f b6 00             	movzbl (%rax),%eax
  801733:	3c 5a                	cmp    $0x5a,%al
  801735:	7f 3d                	jg     801774 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801737:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173b:	0f b6 00             	movzbl (%rax),%eax
  80173e:	0f be c0             	movsbl %al,%eax
  801741:	83 e8 37             	sub    $0x37,%eax
  801744:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801747:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80174a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80174d:	7c 02                	jl     801751 <strtol+0x148>
			break;
  80174f:	eb 23                	jmp    801774 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801751:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801756:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801759:	48 98                	cltq   
  80175b:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801760:	48 89 c2             	mov    %rax,%rdx
  801763:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801766:	48 98                	cltq   
  801768:	48 01 d0             	add    %rdx,%rax
  80176b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80176f:	e9 5d ff ff ff       	jmpq   8016d1 <strtol+0xc8>

	if (endptr)
  801774:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801779:	74 0b                	je     801786 <strtol+0x17d>
		*endptr = (char *) s;
  80177b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80177f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801783:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801786:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80178a:	74 09                	je     801795 <strtol+0x18c>
  80178c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801790:	48 f7 d8             	neg    %rax
  801793:	eb 04                	jmp    801799 <strtol+0x190>
  801795:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801799:	c9                   	leaveq 
  80179a:	c3                   	retq   

000000000080179b <strstr>:

char * strstr(const char *in, const char *str)
{
  80179b:	55                   	push   %rbp
  80179c:	48 89 e5             	mov    %rsp,%rbp
  80179f:	48 83 ec 30          	sub    $0x30,%rsp
  8017a3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017a7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8017ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017af:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017b3:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017b7:	0f b6 00             	movzbl (%rax),%eax
  8017ba:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8017bd:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017c1:	75 06                	jne    8017c9 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8017c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c7:	eb 6b                	jmp    801834 <strstr+0x99>

	len = strlen(str);
  8017c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017cd:	48 89 c7             	mov    %rax,%rdi
  8017d0:	48 b8 71 10 80 00 00 	movabs $0x801071,%rax
  8017d7:	00 00 00 
  8017da:	ff d0                	callq  *%rax
  8017dc:	48 98                	cltq   
  8017de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8017e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017ee:	0f b6 00             	movzbl (%rax),%eax
  8017f1:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8017f4:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017f8:	75 07                	jne    801801 <strstr+0x66>
				return (char *) 0;
  8017fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ff:	eb 33                	jmp    801834 <strstr+0x99>
		} while (sc != c);
  801801:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801805:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801808:	75 d8                	jne    8017e2 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80180a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80180e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801812:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801816:	48 89 ce             	mov    %rcx,%rsi
  801819:	48 89 c7             	mov    %rax,%rdi
  80181c:	48 b8 92 12 80 00 00 	movabs $0x801292,%rax
  801823:	00 00 00 
  801826:	ff d0                	callq  *%rax
  801828:	85 c0                	test   %eax,%eax
  80182a:	75 b6                	jne    8017e2 <strstr+0x47>

	return (char *) (in - 1);
  80182c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801830:	48 83 e8 01          	sub    $0x1,%rax
}
  801834:	c9                   	leaveq 
  801835:	c3                   	retq   

0000000000801836 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801836:	55                   	push   %rbp
  801837:	48 89 e5             	mov    %rsp,%rbp
  80183a:	53                   	push   %rbx
  80183b:	48 83 ec 48          	sub    $0x48,%rsp
  80183f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801842:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801845:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801849:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80184d:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801851:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801855:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801858:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80185c:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801860:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801864:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801868:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80186c:	4c 89 c3             	mov    %r8,%rbx
  80186f:	cd 30                	int    $0x30
  801871:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801875:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801879:	74 3e                	je     8018b9 <syscall+0x83>
  80187b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801880:	7e 37                	jle    8018b9 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801882:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801886:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801889:	49 89 d0             	mov    %rdx,%r8
  80188c:	89 c1                	mov    %eax,%ecx
  80188e:	48 ba e8 4a 80 00 00 	movabs $0x804ae8,%rdx
  801895:	00 00 00 
  801898:	be 24 00 00 00       	mov    $0x24,%esi
  80189d:	48 bf 05 4b 80 00 00 	movabs $0x804b05,%rdi
  8018a4:	00 00 00 
  8018a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ac:	49 b9 ef 02 80 00 00 	movabs $0x8002ef,%r9
  8018b3:	00 00 00 
  8018b6:	41 ff d1             	callq  *%r9

	return ret;
  8018b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018bd:	48 83 c4 48          	add    $0x48,%rsp
  8018c1:	5b                   	pop    %rbx
  8018c2:	5d                   	pop    %rbp
  8018c3:	c3                   	retq   

00000000008018c4 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018c4:	55                   	push   %rbp
  8018c5:	48 89 e5             	mov    %rsp,%rbp
  8018c8:	48 83 ec 20          	sub    $0x20,%rsp
  8018cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e3:	00 
  8018e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f0:	48 89 d1             	mov    %rdx,%rcx
  8018f3:	48 89 c2             	mov    %rax,%rdx
  8018f6:	be 00 00 00 00       	mov    $0x0,%esi
  8018fb:	bf 00 00 00 00       	mov    $0x0,%edi
  801900:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801907:	00 00 00 
  80190a:	ff d0                	callq  *%rax
}
  80190c:	c9                   	leaveq 
  80190d:	c3                   	retq   

000000000080190e <sys_cgetc>:

int
sys_cgetc(void)
{
  80190e:	55                   	push   %rbp
  80190f:	48 89 e5             	mov    %rsp,%rbp
  801912:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801916:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80191d:	00 
  80191e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801924:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80192a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80192f:	ba 00 00 00 00       	mov    $0x0,%edx
  801934:	be 00 00 00 00       	mov    $0x0,%esi
  801939:	bf 01 00 00 00       	mov    $0x1,%edi
  80193e:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801945:	00 00 00 
  801948:	ff d0                	callq  *%rax
}
  80194a:	c9                   	leaveq 
  80194b:	c3                   	retq   

000000000080194c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80194c:	55                   	push   %rbp
  80194d:	48 89 e5             	mov    %rsp,%rbp
  801950:	48 83 ec 10          	sub    $0x10,%rsp
  801954:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801957:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80195a:	48 98                	cltq   
  80195c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801963:	00 
  801964:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80196a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801970:	b9 00 00 00 00       	mov    $0x0,%ecx
  801975:	48 89 c2             	mov    %rax,%rdx
  801978:	be 01 00 00 00       	mov    $0x1,%esi
  80197d:	bf 03 00 00 00       	mov    $0x3,%edi
  801982:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801989:	00 00 00 
  80198c:	ff d0                	callq  *%rax
}
  80198e:	c9                   	leaveq 
  80198f:	c3                   	retq   

0000000000801990 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801990:	55                   	push   %rbp
  801991:	48 89 e5             	mov    %rsp,%rbp
  801994:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801998:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80199f:	00 
  8019a0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019a6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b6:	be 00 00 00 00       	mov    $0x0,%esi
  8019bb:	bf 02 00 00 00       	mov    $0x2,%edi
  8019c0:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  8019c7:	00 00 00 
  8019ca:	ff d0                	callq  *%rax
}
  8019cc:	c9                   	leaveq 
  8019cd:	c3                   	retq   

00000000008019ce <sys_yield>:


void
sys_yield(void)
{
  8019ce:	55                   	push   %rbp
  8019cf:	48 89 e5             	mov    %rsp,%rbp
  8019d2:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019d6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019dd:	00 
  8019de:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f4:	be 00 00 00 00       	mov    $0x0,%esi
  8019f9:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019fe:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801a05:	00 00 00 
  801a08:	ff d0                	callq  *%rax
}
  801a0a:	c9                   	leaveq 
  801a0b:	c3                   	retq   

0000000000801a0c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a0c:	55                   	push   %rbp
  801a0d:	48 89 e5             	mov    %rsp,%rbp
  801a10:	48 83 ec 20          	sub    $0x20,%rsp
  801a14:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a17:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a1b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a1e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a21:	48 63 c8             	movslq %eax,%rcx
  801a24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a2b:	48 98                	cltq   
  801a2d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a34:	00 
  801a35:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a3b:	49 89 c8             	mov    %rcx,%r8
  801a3e:	48 89 d1             	mov    %rdx,%rcx
  801a41:	48 89 c2             	mov    %rax,%rdx
  801a44:	be 01 00 00 00       	mov    $0x1,%esi
  801a49:	bf 04 00 00 00       	mov    $0x4,%edi
  801a4e:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801a55:	00 00 00 
  801a58:	ff d0                	callq  *%rax
}
  801a5a:	c9                   	leaveq 
  801a5b:	c3                   	retq   

0000000000801a5c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a5c:	55                   	push   %rbp
  801a5d:	48 89 e5             	mov    %rsp,%rbp
  801a60:	48 83 ec 30          	sub    $0x30,%rsp
  801a64:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a6b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a6e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a72:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a76:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a79:	48 63 c8             	movslq %eax,%rcx
  801a7c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a80:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a83:	48 63 f0             	movslq %eax,%rsi
  801a86:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a8d:	48 98                	cltq   
  801a8f:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a93:	49 89 f9             	mov    %rdi,%r9
  801a96:	49 89 f0             	mov    %rsi,%r8
  801a99:	48 89 d1             	mov    %rdx,%rcx
  801a9c:	48 89 c2             	mov    %rax,%rdx
  801a9f:	be 01 00 00 00       	mov    $0x1,%esi
  801aa4:	bf 05 00 00 00       	mov    $0x5,%edi
  801aa9:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801ab0:	00 00 00 
  801ab3:	ff d0                	callq  *%rax
}
  801ab5:	c9                   	leaveq 
  801ab6:	c3                   	retq   

0000000000801ab7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801ab7:	55                   	push   %rbp
  801ab8:	48 89 e5             	mov    %rsp,%rbp
  801abb:	48 83 ec 20          	sub    $0x20,%rsp
  801abf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ac2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801ac6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801acd:	48 98                	cltq   
  801acf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad6:	00 
  801ad7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801add:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae3:	48 89 d1             	mov    %rdx,%rcx
  801ae6:	48 89 c2             	mov    %rax,%rdx
  801ae9:	be 01 00 00 00       	mov    $0x1,%esi
  801aee:	bf 06 00 00 00       	mov    $0x6,%edi
  801af3:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801afa:	00 00 00 
  801afd:	ff d0                	callq  *%rax
}
  801aff:	c9                   	leaveq 
  801b00:	c3                   	retq   

0000000000801b01 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b01:	55                   	push   %rbp
  801b02:	48 89 e5             	mov    %rsp,%rbp
  801b05:	48 83 ec 10          	sub    $0x10,%rsp
  801b09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b0c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b0f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b12:	48 63 d0             	movslq %eax,%rdx
  801b15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b18:	48 98                	cltq   
  801b1a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b21:	00 
  801b22:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b28:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b2e:	48 89 d1             	mov    %rdx,%rcx
  801b31:	48 89 c2             	mov    %rax,%rdx
  801b34:	be 01 00 00 00       	mov    $0x1,%esi
  801b39:	bf 08 00 00 00       	mov    $0x8,%edi
  801b3e:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801b45:	00 00 00 
  801b48:	ff d0                	callq  *%rax
}
  801b4a:	c9                   	leaveq 
  801b4b:	c3                   	retq   

0000000000801b4c <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b4c:	55                   	push   %rbp
  801b4d:	48 89 e5             	mov    %rsp,%rbp
  801b50:	48 83 ec 20          	sub    $0x20,%rsp
  801b54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b5b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b62:	48 98                	cltq   
  801b64:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b6b:	00 
  801b6c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b72:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b78:	48 89 d1             	mov    %rdx,%rcx
  801b7b:	48 89 c2             	mov    %rax,%rdx
  801b7e:	be 01 00 00 00       	mov    $0x1,%esi
  801b83:	bf 09 00 00 00       	mov    $0x9,%edi
  801b88:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801b8f:	00 00 00 
  801b92:	ff d0                	callq  *%rax
}
  801b94:	c9                   	leaveq 
  801b95:	c3                   	retq   

0000000000801b96 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b96:	55                   	push   %rbp
  801b97:	48 89 e5             	mov    %rsp,%rbp
  801b9a:	48 83 ec 20          	sub    $0x20,%rsp
  801b9e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ba1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ba5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ba9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bac:	48 98                	cltq   
  801bae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb5:	00 
  801bb6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bbc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc2:	48 89 d1             	mov    %rdx,%rcx
  801bc5:	48 89 c2             	mov    %rax,%rdx
  801bc8:	be 01 00 00 00       	mov    $0x1,%esi
  801bcd:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bd2:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801bd9:	00 00 00 
  801bdc:	ff d0                	callq  *%rax
}
  801bde:	c9                   	leaveq 
  801bdf:	c3                   	retq   

0000000000801be0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801be0:	55                   	push   %rbp
  801be1:	48 89 e5             	mov    %rsp,%rbp
  801be4:	48 83 ec 20          	sub    $0x20,%rsp
  801be8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801beb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bef:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bf3:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801bf6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bf9:	48 63 f0             	movslq %eax,%rsi
  801bfc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c03:	48 98                	cltq   
  801c05:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c09:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c10:	00 
  801c11:	49 89 f1             	mov    %rsi,%r9
  801c14:	49 89 c8             	mov    %rcx,%r8
  801c17:	48 89 d1             	mov    %rdx,%rcx
  801c1a:	48 89 c2             	mov    %rax,%rdx
  801c1d:	be 00 00 00 00       	mov    $0x0,%esi
  801c22:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c27:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801c2e:	00 00 00 
  801c31:	ff d0                	callq  *%rax
}
  801c33:	c9                   	leaveq 
  801c34:	c3                   	retq   

0000000000801c35 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c35:	55                   	push   %rbp
  801c36:	48 89 e5             	mov    %rsp,%rbp
  801c39:	48 83 ec 10          	sub    $0x10,%rsp
  801c3d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c45:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c4c:	00 
  801c4d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c53:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c59:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c5e:	48 89 c2             	mov    %rax,%rdx
  801c61:	be 01 00 00 00       	mov    $0x1,%esi
  801c66:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c6b:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801c72:	00 00 00 
  801c75:	ff d0                	callq  *%rax
}
  801c77:	c9                   	leaveq 
  801c78:	c3                   	retq   

0000000000801c79 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801c79:	55                   	push   %rbp
  801c7a:	48 89 e5             	mov    %rsp,%rbp
  801c7d:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c81:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c88:	00 
  801c89:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c8f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c95:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c9f:	be 00 00 00 00       	mov    $0x0,%esi
  801ca4:	bf 0e 00 00 00       	mov    $0xe,%edi
  801ca9:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801cb0:	00 00 00 
  801cb3:	ff d0                	callq  *%rax
}
  801cb5:	c9                   	leaveq 
  801cb6:	c3                   	retq   

0000000000801cb7 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801cb7:	55                   	push   %rbp
  801cb8:	48 89 e5             	mov    %rsp,%rbp
  801cbb:	48 83 ec 20          	sub    $0x20,%rsp
  801cbf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cc3:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801cc6:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801cc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ccd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd4:	00 
  801cd5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cdb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce1:	48 89 d1             	mov    %rdx,%rcx
  801ce4:	48 89 c2             	mov    %rax,%rdx
  801ce7:	be 00 00 00 00       	mov    $0x0,%esi
  801cec:	bf 0f 00 00 00       	mov    $0xf,%edi
  801cf1:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801cf8:	00 00 00 
  801cfb:	ff d0                	callq  *%rax
}
  801cfd:	c9                   	leaveq 
  801cfe:	c3                   	retq   

0000000000801cff <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801cff:	55                   	push   %rbp
  801d00:	48 89 e5             	mov    %rsp,%rbp
  801d03:	48 83 ec 20          	sub    $0x20,%rsp
  801d07:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d0b:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801d0e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801d11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d15:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d1c:	00 
  801d1d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d23:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d29:	48 89 d1             	mov    %rdx,%rcx
  801d2c:	48 89 c2             	mov    %rax,%rdx
  801d2f:	be 00 00 00 00       	mov    $0x0,%esi
  801d34:	bf 10 00 00 00       	mov    $0x10,%edi
  801d39:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801d40:	00 00 00 
  801d43:	ff d0                	callq  *%rax
}
  801d45:	c9                   	leaveq 
  801d46:	c3                   	retq   

0000000000801d47 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801d47:	55                   	push   %rbp
  801d48:	48 89 e5             	mov    %rsp,%rbp
  801d4b:	48 83 ec 30          	sub    $0x30,%rsp
  801d4f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d52:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d56:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d59:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d5d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801d61:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d64:	48 63 c8             	movslq %eax,%rcx
  801d67:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d6b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d6e:	48 63 f0             	movslq %eax,%rsi
  801d71:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d78:	48 98                	cltq   
  801d7a:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d7e:	49 89 f9             	mov    %rdi,%r9
  801d81:	49 89 f0             	mov    %rsi,%r8
  801d84:	48 89 d1             	mov    %rdx,%rcx
  801d87:	48 89 c2             	mov    %rax,%rdx
  801d8a:	be 00 00 00 00       	mov    $0x0,%esi
  801d8f:	bf 11 00 00 00       	mov    $0x11,%edi
  801d94:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801d9b:	00 00 00 
  801d9e:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801da0:	c9                   	leaveq 
  801da1:	c3                   	retq   

0000000000801da2 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801da2:	55                   	push   %rbp
  801da3:	48 89 e5             	mov    %rsp,%rbp
  801da6:	48 83 ec 20          	sub    $0x20,%rsp
  801daa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801db2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801db6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dc1:	00 
  801dc2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dc8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dce:	48 89 d1             	mov    %rdx,%rcx
  801dd1:	48 89 c2             	mov    %rax,%rdx
  801dd4:	be 00 00 00 00       	mov    $0x0,%esi
  801dd9:	bf 12 00 00 00       	mov    $0x12,%edi
  801dde:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801de5:	00 00 00 
  801de8:	ff d0                	callq  *%rax
}
  801dea:	c9                   	leaveq 
  801deb:	c3                   	retq   

0000000000801dec <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801dec:	55                   	push   %rbp
  801ded:	48 89 e5             	mov    %rsp,%rbp
  801df0:	48 83 ec 08          	sub    $0x8,%rsp
  801df4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801df8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dfc:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e03:	ff ff ff 
  801e06:	48 01 d0             	add    %rdx,%rax
  801e09:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e0d:	c9                   	leaveq 
  801e0e:	c3                   	retq   

0000000000801e0f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e0f:	55                   	push   %rbp
  801e10:	48 89 e5             	mov    %rsp,%rbp
  801e13:	48 83 ec 08          	sub    $0x8,%rsp
  801e17:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801e1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e1f:	48 89 c7             	mov    %rax,%rdi
  801e22:	48 b8 ec 1d 80 00 00 	movabs $0x801dec,%rax
  801e29:	00 00 00 
  801e2c:	ff d0                	callq  *%rax
  801e2e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e34:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e38:	c9                   	leaveq 
  801e39:	c3                   	retq   

0000000000801e3a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e3a:	55                   	push   %rbp
  801e3b:	48 89 e5             	mov    %rsp,%rbp
  801e3e:	48 83 ec 18          	sub    $0x18,%rsp
  801e42:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e4d:	eb 6b                	jmp    801eba <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e52:	48 98                	cltq   
  801e54:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e5a:	48 c1 e0 0c          	shl    $0xc,%rax
  801e5e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e66:	48 c1 e8 15          	shr    $0x15,%rax
  801e6a:	48 89 c2             	mov    %rax,%rdx
  801e6d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e74:	01 00 00 
  801e77:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e7b:	83 e0 01             	and    $0x1,%eax
  801e7e:	48 85 c0             	test   %rax,%rax
  801e81:	74 21                	je     801ea4 <fd_alloc+0x6a>
  801e83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e87:	48 c1 e8 0c          	shr    $0xc,%rax
  801e8b:	48 89 c2             	mov    %rax,%rdx
  801e8e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e95:	01 00 00 
  801e98:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e9c:	83 e0 01             	and    $0x1,%eax
  801e9f:	48 85 c0             	test   %rax,%rax
  801ea2:	75 12                	jne    801eb6 <fd_alloc+0x7c>
			*fd_store = fd;
  801ea4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ea8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eac:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb4:	eb 1a                	jmp    801ed0 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801eb6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801eba:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801ebe:	7e 8f                	jle    801e4f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801ec0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ec4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801ecb:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ed0:	c9                   	leaveq 
  801ed1:	c3                   	retq   

0000000000801ed2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ed2:	55                   	push   %rbp
  801ed3:	48 89 e5             	mov    %rsp,%rbp
  801ed6:	48 83 ec 20          	sub    $0x20,%rsp
  801eda:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801edd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ee1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ee5:	78 06                	js     801eed <fd_lookup+0x1b>
  801ee7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801eeb:	7e 07                	jle    801ef4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801eed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ef2:	eb 6c                	jmp    801f60 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ef4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ef7:	48 98                	cltq   
  801ef9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801eff:	48 c1 e0 0c          	shl    $0xc,%rax
  801f03:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f0b:	48 c1 e8 15          	shr    $0x15,%rax
  801f0f:	48 89 c2             	mov    %rax,%rdx
  801f12:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f19:	01 00 00 
  801f1c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f20:	83 e0 01             	and    $0x1,%eax
  801f23:	48 85 c0             	test   %rax,%rax
  801f26:	74 21                	je     801f49 <fd_lookup+0x77>
  801f28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f2c:	48 c1 e8 0c          	shr    $0xc,%rax
  801f30:	48 89 c2             	mov    %rax,%rdx
  801f33:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f3a:	01 00 00 
  801f3d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f41:	83 e0 01             	and    $0x1,%eax
  801f44:	48 85 c0             	test   %rax,%rax
  801f47:	75 07                	jne    801f50 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f4e:	eb 10                	jmp    801f60 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f50:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f54:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f58:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f60:	c9                   	leaveq 
  801f61:	c3                   	retq   

0000000000801f62 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f62:	55                   	push   %rbp
  801f63:	48 89 e5             	mov    %rsp,%rbp
  801f66:	48 83 ec 30          	sub    $0x30,%rsp
  801f6a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f6e:	89 f0                	mov    %esi,%eax
  801f70:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f77:	48 89 c7             	mov    %rax,%rdi
  801f7a:	48 b8 ec 1d 80 00 00 	movabs $0x801dec,%rax
  801f81:	00 00 00 
  801f84:	ff d0                	callq  *%rax
  801f86:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f8a:	48 89 d6             	mov    %rdx,%rsi
  801f8d:	89 c7                	mov    %eax,%edi
  801f8f:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  801f96:	00 00 00 
  801f99:	ff d0                	callq  *%rax
  801f9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fa2:	78 0a                	js     801fae <fd_close+0x4c>
	    || fd != fd2)
  801fa4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fa8:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801fac:	74 12                	je     801fc0 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801fae:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801fb2:	74 05                	je     801fb9 <fd_close+0x57>
  801fb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fb7:	eb 05                	jmp    801fbe <fd_close+0x5c>
  801fb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbe:	eb 69                	jmp    802029 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801fc0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fc4:	8b 00                	mov    (%rax),%eax
  801fc6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fca:	48 89 d6             	mov    %rdx,%rsi
  801fcd:	89 c7                	mov    %eax,%edi
  801fcf:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  801fd6:	00 00 00 
  801fd9:	ff d0                	callq  *%rax
  801fdb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fde:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fe2:	78 2a                	js     80200e <fd_close+0xac>
		if (dev->dev_close)
  801fe4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fe8:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fec:	48 85 c0             	test   %rax,%rax
  801fef:	74 16                	je     802007 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801ff1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ff5:	48 8b 40 20          	mov    0x20(%rax),%rax
  801ff9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801ffd:	48 89 d7             	mov    %rdx,%rdi
  802000:	ff d0                	callq  *%rax
  802002:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802005:	eb 07                	jmp    80200e <fd_close+0xac>
		else
			r = 0;
  802007:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80200e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802012:	48 89 c6             	mov    %rax,%rsi
  802015:	bf 00 00 00 00       	mov    $0x0,%edi
  80201a:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  802021:	00 00 00 
  802024:	ff d0                	callq  *%rax
	return r;
  802026:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802029:	c9                   	leaveq 
  80202a:	c3                   	retq   

000000000080202b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80202b:	55                   	push   %rbp
  80202c:	48 89 e5             	mov    %rsp,%rbp
  80202f:	48 83 ec 20          	sub    $0x20,%rsp
  802033:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802036:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80203a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802041:	eb 41                	jmp    802084 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802043:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80204a:	00 00 00 
  80204d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802050:	48 63 d2             	movslq %edx,%rdx
  802053:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802057:	8b 00                	mov    (%rax),%eax
  802059:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80205c:	75 22                	jne    802080 <dev_lookup+0x55>
			*dev = devtab[i];
  80205e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802065:	00 00 00 
  802068:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80206b:	48 63 d2             	movslq %edx,%rdx
  80206e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802072:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802076:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802079:	b8 00 00 00 00       	mov    $0x0,%eax
  80207e:	eb 60                	jmp    8020e0 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802080:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802084:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80208b:	00 00 00 
  80208e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802091:	48 63 d2             	movslq %edx,%rdx
  802094:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802098:	48 85 c0             	test   %rax,%rax
  80209b:	75 a6                	jne    802043 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80209d:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8020a4:	00 00 00 
  8020a7:	48 8b 00             	mov    (%rax),%rax
  8020aa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020b0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020b3:	89 c6                	mov    %eax,%esi
  8020b5:	48 bf 18 4b 80 00 00 	movabs $0x804b18,%rdi
  8020bc:	00 00 00 
  8020bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c4:	48 b9 28 05 80 00 00 	movabs $0x800528,%rcx
  8020cb:	00 00 00 
  8020ce:	ff d1                	callq  *%rcx
	*dev = 0;
  8020d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020d4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8020db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020e0:	c9                   	leaveq 
  8020e1:	c3                   	retq   

00000000008020e2 <close>:

int
close(int fdnum)
{
  8020e2:	55                   	push   %rbp
  8020e3:	48 89 e5             	mov    %rsp,%rbp
  8020e6:	48 83 ec 20          	sub    $0x20,%rsp
  8020ea:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020ed:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020f4:	48 89 d6             	mov    %rdx,%rsi
  8020f7:	89 c7                	mov    %eax,%edi
  8020f9:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  802100:	00 00 00 
  802103:	ff d0                	callq  *%rax
  802105:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802108:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80210c:	79 05                	jns    802113 <close+0x31>
		return r;
  80210e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802111:	eb 18                	jmp    80212b <close+0x49>
	else
		return fd_close(fd, 1);
  802113:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802117:	be 01 00 00 00       	mov    $0x1,%esi
  80211c:	48 89 c7             	mov    %rax,%rdi
  80211f:	48 b8 62 1f 80 00 00 	movabs $0x801f62,%rax
  802126:	00 00 00 
  802129:	ff d0                	callq  *%rax
}
  80212b:	c9                   	leaveq 
  80212c:	c3                   	retq   

000000000080212d <close_all>:

void
close_all(void)
{
  80212d:	55                   	push   %rbp
  80212e:	48 89 e5             	mov    %rsp,%rbp
  802131:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802135:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80213c:	eb 15                	jmp    802153 <close_all+0x26>
		close(i);
  80213e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802141:	89 c7                	mov    %eax,%edi
  802143:	48 b8 e2 20 80 00 00 	movabs $0x8020e2,%rax
  80214a:	00 00 00 
  80214d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80214f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802153:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802157:	7e e5                	jle    80213e <close_all+0x11>
		close(i);
}
  802159:	c9                   	leaveq 
  80215a:	c3                   	retq   

000000000080215b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80215b:	55                   	push   %rbp
  80215c:	48 89 e5             	mov    %rsp,%rbp
  80215f:	48 83 ec 40          	sub    $0x40,%rsp
  802163:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802166:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802169:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80216d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802170:	48 89 d6             	mov    %rdx,%rsi
  802173:	89 c7                	mov    %eax,%edi
  802175:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  80217c:	00 00 00 
  80217f:	ff d0                	callq  *%rax
  802181:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802184:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802188:	79 08                	jns    802192 <dup+0x37>
		return r;
  80218a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80218d:	e9 70 01 00 00       	jmpq   802302 <dup+0x1a7>
	close(newfdnum);
  802192:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802195:	89 c7                	mov    %eax,%edi
  802197:	48 b8 e2 20 80 00 00 	movabs $0x8020e2,%rax
  80219e:	00 00 00 
  8021a1:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8021a3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021a6:	48 98                	cltq   
  8021a8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021ae:	48 c1 e0 0c          	shl    $0xc,%rax
  8021b2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8021b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ba:	48 89 c7             	mov    %rax,%rdi
  8021bd:	48 b8 0f 1e 80 00 00 	movabs $0x801e0f,%rax
  8021c4:	00 00 00 
  8021c7:	ff d0                	callq  *%rax
  8021c9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8021cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021d1:	48 89 c7             	mov    %rax,%rdi
  8021d4:	48 b8 0f 1e 80 00 00 	movabs $0x801e0f,%rax
  8021db:	00 00 00 
  8021de:	ff d0                	callq  *%rax
  8021e0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8021e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e8:	48 c1 e8 15          	shr    $0x15,%rax
  8021ec:	48 89 c2             	mov    %rax,%rdx
  8021ef:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021f6:	01 00 00 
  8021f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021fd:	83 e0 01             	and    $0x1,%eax
  802200:	48 85 c0             	test   %rax,%rax
  802203:	74 73                	je     802278 <dup+0x11d>
  802205:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802209:	48 c1 e8 0c          	shr    $0xc,%rax
  80220d:	48 89 c2             	mov    %rax,%rdx
  802210:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802217:	01 00 00 
  80221a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80221e:	83 e0 01             	and    $0x1,%eax
  802221:	48 85 c0             	test   %rax,%rax
  802224:	74 52                	je     802278 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802226:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222a:	48 c1 e8 0c          	shr    $0xc,%rax
  80222e:	48 89 c2             	mov    %rax,%rdx
  802231:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802238:	01 00 00 
  80223b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80223f:	25 07 0e 00 00       	and    $0xe07,%eax
  802244:	89 c1                	mov    %eax,%ecx
  802246:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80224a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80224e:	41 89 c8             	mov    %ecx,%r8d
  802251:	48 89 d1             	mov    %rdx,%rcx
  802254:	ba 00 00 00 00       	mov    $0x0,%edx
  802259:	48 89 c6             	mov    %rax,%rsi
  80225c:	bf 00 00 00 00       	mov    $0x0,%edi
  802261:	48 b8 5c 1a 80 00 00 	movabs $0x801a5c,%rax
  802268:	00 00 00 
  80226b:	ff d0                	callq  *%rax
  80226d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802270:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802274:	79 02                	jns    802278 <dup+0x11d>
			goto err;
  802276:	eb 57                	jmp    8022cf <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802278:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80227c:	48 c1 e8 0c          	shr    $0xc,%rax
  802280:	48 89 c2             	mov    %rax,%rdx
  802283:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80228a:	01 00 00 
  80228d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802291:	25 07 0e 00 00       	and    $0xe07,%eax
  802296:	89 c1                	mov    %eax,%ecx
  802298:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80229c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022a0:	41 89 c8             	mov    %ecx,%r8d
  8022a3:	48 89 d1             	mov    %rdx,%rcx
  8022a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8022ab:	48 89 c6             	mov    %rax,%rsi
  8022ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b3:	48 b8 5c 1a 80 00 00 	movabs $0x801a5c,%rax
  8022ba:	00 00 00 
  8022bd:	ff d0                	callq  *%rax
  8022bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c6:	79 02                	jns    8022ca <dup+0x16f>
		goto err;
  8022c8:	eb 05                	jmp    8022cf <dup+0x174>

	return newfdnum;
  8022ca:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022cd:	eb 33                	jmp    802302 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8022cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022d3:	48 89 c6             	mov    %rax,%rsi
  8022d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8022db:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  8022e2:	00 00 00 
  8022e5:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8022e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022eb:	48 89 c6             	mov    %rax,%rsi
  8022ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8022f3:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  8022fa:	00 00 00 
  8022fd:	ff d0                	callq  *%rax
	return r;
  8022ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802302:	c9                   	leaveq 
  802303:	c3                   	retq   

0000000000802304 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802304:	55                   	push   %rbp
  802305:	48 89 e5             	mov    %rsp,%rbp
  802308:	48 83 ec 40          	sub    $0x40,%rsp
  80230c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80230f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802313:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802317:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80231b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80231e:	48 89 d6             	mov    %rdx,%rsi
  802321:	89 c7                	mov    %eax,%edi
  802323:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  80232a:	00 00 00 
  80232d:	ff d0                	callq  *%rax
  80232f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802332:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802336:	78 24                	js     80235c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802338:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80233c:	8b 00                	mov    (%rax),%eax
  80233e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802342:	48 89 d6             	mov    %rdx,%rsi
  802345:	89 c7                	mov    %eax,%edi
  802347:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  80234e:	00 00 00 
  802351:	ff d0                	callq  *%rax
  802353:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802356:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80235a:	79 05                	jns    802361 <read+0x5d>
		return r;
  80235c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235f:	eb 76                	jmp    8023d7 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802361:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802365:	8b 40 08             	mov    0x8(%rax),%eax
  802368:	83 e0 03             	and    $0x3,%eax
  80236b:	83 f8 01             	cmp    $0x1,%eax
  80236e:	75 3a                	jne    8023aa <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802370:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802377:	00 00 00 
  80237a:	48 8b 00             	mov    (%rax),%rax
  80237d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802383:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802386:	89 c6                	mov    %eax,%esi
  802388:	48 bf 37 4b 80 00 00 	movabs $0x804b37,%rdi
  80238f:	00 00 00 
  802392:	b8 00 00 00 00       	mov    $0x0,%eax
  802397:	48 b9 28 05 80 00 00 	movabs $0x800528,%rcx
  80239e:	00 00 00 
  8023a1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8023a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023a8:	eb 2d                	jmp    8023d7 <read+0xd3>
	}
	if (!dev->dev_read)
  8023aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ae:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023b2:	48 85 c0             	test   %rax,%rax
  8023b5:	75 07                	jne    8023be <read+0xba>
		return -E_NOT_SUPP;
  8023b7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023bc:	eb 19                	jmp    8023d7 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8023be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023c2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023c6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023ca:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023ce:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023d2:	48 89 cf             	mov    %rcx,%rdi
  8023d5:	ff d0                	callq  *%rax
}
  8023d7:	c9                   	leaveq 
  8023d8:	c3                   	retq   

00000000008023d9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8023d9:	55                   	push   %rbp
  8023da:	48 89 e5             	mov    %rsp,%rbp
  8023dd:	48 83 ec 30          	sub    $0x30,%rsp
  8023e1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023e4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023e8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023f3:	eb 49                	jmp    80243e <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f8:	48 98                	cltq   
  8023fa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023fe:	48 29 c2             	sub    %rax,%rdx
  802401:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802404:	48 63 c8             	movslq %eax,%rcx
  802407:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80240b:	48 01 c1             	add    %rax,%rcx
  80240e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802411:	48 89 ce             	mov    %rcx,%rsi
  802414:	89 c7                	mov    %eax,%edi
  802416:	48 b8 04 23 80 00 00 	movabs $0x802304,%rax
  80241d:	00 00 00 
  802420:	ff d0                	callq  *%rax
  802422:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802425:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802429:	79 05                	jns    802430 <readn+0x57>
			return m;
  80242b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80242e:	eb 1c                	jmp    80244c <readn+0x73>
		if (m == 0)
  802430:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802434:	75 02                	jne    802438 <readn+0x5f>
			break;
  802436:	eb 11                	jmp    802449 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802438:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80243b:	01 45 fc             	add    %eax,-0x4(%rbp)
  80243e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802441:	48 98                	cltq   
  802443:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802447:	72 ac                	jb     8023f5 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802449:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80244c:	c9                   	leaveq 
  80244d:	c3                   	retq   

000000000080244e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80244e:	55                   	push   %rbp
  80244f:	48 89 e5             	mov    %rsp,%rbp
  802452:	48 83 ec 40          	sub    $0x40,%rsp
  802456:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802459:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80245d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802461:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802465:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802468:	48 89 d6             	mov    %rdx,%rsi
  80246b:	89 c7                	mov    %eax,%edi
  80246d:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  802474:	00 00 00 
  802477:	ff d0                	callq  *%rax
  802479:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80247c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802480:	78 24                	js     8024a6 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802482:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802486:	8b 00                	mov    (%rax),%eax
  802488:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80248c:	48 89 d6             	mov    %rdx,%rsi
  80248f:	89 c7                	mov    %eax,%edi
  802491:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  802498:	00 00 00 
  80249b:	ff d0                	callq  *%rax
  80249d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a4:	79 05                	jns    8024ab <write+0x5d>
		return r;
  8024a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024a9:	eb 75                	jmp    802520 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024af:	8b 40 08             	mov    0x8(%rax),%eax
  8024b2:	83 e0 03             	and    $0x3,%eax
  8024b5:	85 c0                	test   %eax,%eax
  8024b7:	75 3a                	jne    8024f3 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8024b9:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8024c0:	00 00 00 
  8024c3:	48 8b 00             	mov    (%rax),%rax
  8024c6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024cc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024cf:	89 c6                	mov    %eax,%esi
  8024d1:	48 bf 53 4b 80 00 00 	movabs $0x804b53,%rdi
  8024d8:	00 00 00 
  8024db:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e0:	48 b9 28 05 80 00 00 	movabs $0x800528,%rcx
  8024e7:	00 00 00 
  8024ea:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024f1:	eb 2d                	jmp    802520 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8024f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024f7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024fb:	48 85 c0             	test   %rax,%rax
  8024fe:	75 07                	jne    802507 <write+0xb9>
		return -E_NOT_SUPP;
  802500:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802505:	eb 19                	jmp    802520 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802507:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80250b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80250f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802513:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802517:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80251b:	48 89 cf             	mov    %rcx,%rdi
  80251e:	ff d0                	callq  *%rax
}
  802520:	c9                   	leaveq 
  802521:	c3                   	retq   

0000000000802522 <seek>:

int
seek(int fdnum, off_t offset)
{
  802522:	55                   	push   %rbp
  802523:	48 89 e5             	mov    %rsp,%rbp
  802526:	48 83 ec 18          	sub    $0x18,%rsp
  80252a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80252d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802530:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802534:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802537:	48 89 d6             	mov    %rdx,%rsi
  80253a:	89 c7                	mov    %eax,%edi
  80253c:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  802543:	00 00 00 
  802546:	ff d0                	callq  *%rax
  802548:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80254b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80254f:	79 05                	jns    802556 <seek+0x34>
		return r;
  802551:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802554:	eb 0f                	jmp    802565 <seek+0x43>
	fd->fd_offset = offset;
  802556:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80255a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80255d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802560:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802565:	c9                   	leaveq 
  802566:	c3                   	retq   

0000000000802567 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802567:	55                   	push   %rbp
  802568:	48 89 e5             	mov    %rsp,%rbp
  80256b:	48 83 ec 30          	sub    $0x30,%rsp
  80256f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802572:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802575:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802579:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80257c:	48 89 d6             	mov    %rdx,%rsi
  80257f:	89 c7                	mov    %eax,%edi
  802581:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  802588:	00 00 00 
  80258b:	ff d0                	callq  *%rax
  80258d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802590:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802594:	78 24                	js     8025ba <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802596:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80259a:	8b 00                	mov    (%rax),%eax
  80259c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025a0:	48 89 d6             	mov    %rdx,%rsi
  8025a3:	89 c7                	mov    %eax,%edi
  8025a5:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8025ac:	00 00 00 
  8025af:	ff d0                	callq  *%rax
  8025b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b8:	79 05                	jns    8025bf <ftruncate+0x58>
		return r;
  8025ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025bd:	eb 72                	jmp    802631 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c3:	8b 40 08             	mov    0x8(%rax),%eax
  8025c6:	83 e0 03             	and    $0x3,%eax
  8025c9:	85 c0                	test   %eax,%eax
  8025cb:	75 3a                	jne    802607 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8025cd:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8025d4:	00 00 00 
  8025d7:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8025da:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025e0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025e3:	89 c6                	mov    %eax,%esi
  8025e5:	48 bf 70 4b 80 00 00 	movabs $0x804b70,%rdi
  8025ec:	00 00 00 
  8025ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f4:	48 b9 28 05 80 00 00 	movabs $0x800528,%rcx
  8025fb:	00 00 00 
  8025fe:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802600:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802605:	eb 2a                	jmp    802631 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802607:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80260b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80260f:	48 85 c0             	test   %rax,%rax
  802612:	75 07                	jne    80261b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802614:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802619:	eb 16                	jmp    802631 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80261b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80261f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802623:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802627:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80262a:	89 ce                	mov    %ecx,%esi
  80262c:	48 89 d7             	mov    %rdx,%rdi
  80262f:	ff d0                	callq  *%rax
}
  802631:	c9                   	leaveq 
  802632:	c3                   	retq   

0000000000802633 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802633:	55                   	push   %rbp
  802634:	48 89 e5             	mov    %rsp,%rbp
  802637:	48 83 ec 30          	sub    $0x30,%rsp
  80263b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80263e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802642:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802646:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802649:	48 89 d6             	mov    %rdx,%rsi
  80264c:	89 c7                	mov    %eax,%edi
  80264e:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  802655:	00 00 00 
  802658:	ff d0                	callq  *%rax
  80265a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80265d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802661:	78 24                	js     802687 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802663:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802667:	8b 00                	mov    (%rax),%eax
  802669:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80266d:	48 89 d6             	mov    %rdx,%rsi
  802670:	89 c7                	mov    %eax,%edi
  802672:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  802679:	00 00 00 
  80267c:	ff d0                	callq  *%rax
  80267e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802681:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802685:	79 05                	jns    80268c <fstat+0x59>
		return r;
  802687:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80268a:	eb 5e                	jmp    8026ea <fstat+0xb7>
	if (!dev->dev_stat)
  80268c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802690:	48 8b 40 28          	mov    0x28(%rax),%rax
  802694:	48 85 c0             	test   %rax,%rax
  802697:	75 07                	jne    8026a0 <fstat+0x6d>
		return -E_NOT_SUPP;
  802699:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80269e:	eb 4a                	jmp    8026ea <fstat+0xb7>
	stat->st_name[0] = 0;
  8026a0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026a4:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8026a7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026ab:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8026b2:	00 00 00 
	stat->st_isdir = 0;
  8026b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026b9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8026c0:	00 00 00 
	stat->st_dev = dev;
  8026c3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026cb:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8026d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026d6:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026de:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8026e2:	48 89 ce             	mov    %rcx,%rsi
  8026e5:	48 89 d7             	mov    %rdx,%rdi
  8026e8:	ff d0                	callq  *%rax
}
  8026ea:	c9                   	leaveq 
  8026eb:	c3                   	retq   

00000000008026ec <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8026ec:	55                   	push   %rbp
  8026ed:	48 89 e5             	mov    %rsp,%rbp
  8026f0:	48 83 ec 20          	sub    $0x20,%rsp
  8026f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802700:	be 00 00 00 00       	mov    $0x0,%esi
  802705:	48 89 c7             	mov    %rax,%rdi
  802708:	48 b8 da 27 80 00 00 	movabs $0x8027da,%rax
  80270f:	00 00 00 
  802712:	ff d0                	callq  *%rax
  802714:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802717:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80271b:	79 05                	jns    802722 <stat+0x36>
		return fd;
  80271d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802720:	eb 2f                	jmp    802751 <stat+0x65>
	r = fstat(fd, stat);
  802722:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802726:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802729:	48 89 d6             	mov    %rdx,%rsi
  80272c:	89 c7                	mov    %eax,%edi
  80272e:	48 b8 33 26 80 00 00 	movabs $0x802633,%rax
  802735:	00 00 00 
  802738:	ff d0                	callq  *%rax
  80273a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80273d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802740:	89 c7                	mov    %eax,%edi
  802742:	48 b8 e2 20 80 00 00 	movabs $0x8020e2,%rax
  802749:	00 00 00 
  80274c:	ff d0                	callq  *%rax
	return r;
  80274e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802751:	c9                   	leaveq 
  802752:	c3                   	retq   

0000000000802753 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802753:	55                   	push   %rbp
  802754:	48 89 e5             	mov    %rsp,%rbp
  802757:	48 83 ec 10          	sub    $0x10,%rsp
  80275b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80275e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802762:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802769:	00 00 00 
  80276c:	8b 00                	mov    (%rax),%eax
  80276e:	85 c0                	test   %eax,%eax
  802770:	75 1d                	jne    80278f <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802772:	bf 01 00 00 00       	mov    $0x1,%edi
  802777:	48 b8 70 44 80 00 00 	movabs $0x804470,%rax
  80277e:	00 00 00 
  802781:	ff d0                	callq  *%rax
  802783:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80278a:	00 00 00 
  80278d:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80278f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802796:	00 00 00 
  802799:	8b 00                	mov    (%rax),%eax
  80279b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80279e:	b9 07 00 00 00       	mov    $0x7,%ecx
  8027a3:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8027aa:	00 00 00 
  8027ad:	89 c7                	mov    %eax,%edi
  8027af:	48 b8 64 42 80 00 00 	movabs $0x804264,%rax
  8027b6:	00 00 00 
  8027b9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8027bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8027c4:	48 89 c6             	mov    %rax,%rsi
  8027c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8027cc:	48 b8 a3 41 80 00 00 	movabs $0x8041a3,%rax
  8027d3:	00 00 00 
  8027d6:	ff d0                	callq  *%rax
}
  8027d8:	c9                   	leaveq 
  8027d9:	c3                   	retq   

00000000008027da <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8027da:	55                   	push   %rbp
  8027db:	48 89 e5             	mov    %rsp,%rbp
  8027de:	48 83 ec 20          	sub    $0x20,%rsp
  8027e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027e6:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8027e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ed:	48 89 c7             	mov    %rax,%rdi
  8027f0:	48 b8 71 10 80 00 00 	movabs $0x801071,%rax
  8027f7:	00 00 00 
  8027fa:	ff d0                	callq  *%rax
  8027fc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802801:	7e 0a                	jle    80280d <open+0x33>
		return -E_BAD_PATH;
  802803:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802808:	e9 a5 00 00 00       	jmpq   8028b2 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80280d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802811:	48 89 c7             	mov    %rax,%rdi
  802814:	48 b8 3a 1e 80 00 00 	movabs $0x801e3a,%rax
  80281b:	00 00 00 
  80281e:	ff d0                	callq  *%rax
  802820:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802823:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802827:	79 08                	jns    802831 <open+0x57>
		return r;
  802829:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80282c:	e9 81 00 00 00       	jmpq   8028b2 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802831:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802835:	48 89 c6             	mov    %rax,%rsi
  802838:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  80283f:	00 00 00 
  802842:	48 b8 dd 10 80 00 00 	movabs $0x8010dd,%rax
  802849:	00 00 00 
  80284c:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80284e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802855:	00 00 00 
  802858:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80285b:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802861:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802865:	48 89 c6             	mov    %rax,%rsi
  802868:	bf 01 00 00 00       	mov    $0x1,%edi
  80286d:	48 b8 53 27 80 00 00 	movabs $0x802753,%rax
  802874:	00 00 00 
  802877:	ff d0                	callq  *%rax
  802879:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80287c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802880:	79 1d                	jns    80289f <open+0xc5>
		fd_close(fd, 0);
  802882:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802886:	be 00 00 00 00       	mov    $0x0,%esi
  80288b:	48 89 c7             	mov    %rax,%rdi
  80288e:	48 b8 62 1f 80 00 00 	movabs $0x801f62,%rax
  802895:	00 00 00 
  802898:	ff d0                	callq  *%rax
		return r;
  80289a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80289d:	eb 13                	jmp    8028b2 <open+0xd8>
	}

	return fd2num(fd);
  80289f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a3:	48 89 c7             	mov    %rax,%rdi
  8028a6:	48 b8 ec 1d 80 00 00 	movabs $0x801dec,%rax
  8028ad:	00 00 00 
  8028b0:	ff d0                	callq  *%rax

}
  8028b2:	c9                   	leaveq 
  8028b3:	c3                   	retq   

00000000008028b4 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8028b4:	55                   	push   %rbp
  8028b5:	48 89 e5             	mov    %rsp,%rbp
  8028b8:	48 83 ec 10          	sub    $0x10,%rsp
  8028bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8028c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028c4:	8b 50 0c             	mov    0xc(%rax),%edx
  8028c7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8028ce:	00 00 00 
  8028d1:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028d3:	be 00 00 00 00       	mov    $0x0,%esi
  8028d8:	bf 06 00 00 00       	mov    $0x6,%edi
  8028dd:	48 b8 53 27 80 00 00 	movabs $0x802753,%rax
  8028e4:	00 00 00 
  8028e7:	ff d0                	callq  *%rax
}
  8028e9:	c9                   	leaveq 
  8028ea:	c3                   	retq   

00000000008028eb <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8028eb:	55                   	push   %rbp
  8028ec:	48 89 e5             	mov    %rsp,%rbp
  8028ef:	48 83 ec 30          	sub    $0x30,%rsp
  8028f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028fb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8028ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802903:	8b 50 0c             	mov    0xc(%rax),%edx
  802906:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80290d:	00 00 00 
  802910:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802912:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802919:	00 00 00 
  80291c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802920:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802924:	be 00 00 00 00       	mov    $0x0,%esi
  802929:	bf 03 00 00 00       	mov    $0x3,%edi
  80292e:	48 b8 53 27 80 00 00 	movabs $0x802753,%rax
  802935:	00 00 00 
  802938:	ff d0                	callq  *%rax
  80293a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80293d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802941:	79 08                	jns    80294b <devfile_read+0x60>
		return r;
  802943:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802946:	e9 a4 00 00 00       	jmpq   8029ef <devfile_read+0x104>
	assert(r <= n);
  80294b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80294e:	48 98                	cltq   
  802950:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802954:	76 35                	jbe    80298b <devfile_read+0xa0>
  802956:	48 b9 96 4b 80 00 00 	movabs $0x804b96,%rcx
  80295d:	00 00 00 
  802960:	48 ba 9d 4b 80 00 00 	movabs $0x804b9d,%rdx
  802967:	00 00 00 
  80296a:	be 86 00 00 00       	mov    $0x86,%esi
  80296f:	48 bf b2 4b 80 00 00 	movabs $0x804bb2,%rdi
  802976:	00 00 00 
  802979:	b8 00 00 00 00       	mov    $0x0,%eax
  80297e:	49 b8 ef 02 80 00 00 	movabs $0x8002ef,%r8
  802985:	00 00 00 
  802988:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  80298b:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802992:	7e 35                	jle    8029c9 <devfile_read+0xde>
  802994:	48 b9 bd 4b 80 00 00 	movabs $0x804bbd,%rcx
  80299b:	00 00 00 
  80299e:	48 ba 9d 4b 80 00 00 	movabs $0x804b9d,%rdx
  8029a5:	00 00 00 
  8029a8:	be 87 00 00 00       	mov    $0x87,%esi
  8029ad:	48 bf b2 4b 80 00 00 	movabs $0x804bb2,%rdi
  8029b4:	00 00 00 
  8029b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bc:	49 b8 ef 02 80 00 00 	movabs $0x8002ef,%r8
  8029c3:	00 00 00 
  8029c6:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8029c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029cc:	48 63 d0             	movslq %eax,%rdx
  8029cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029d3:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8029da:	00 00 00 
  8029dd:	48 89 c7             	mov    %rax,%rdi
  8029e0:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  8029e7:	00 00 00 
  8029ea:	ff d0                	callq  *%rax
	return r;
  8029ec:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8029ef:	c9                   	leaveq 
  8029f0:	c3                   	retq   

00000000008029f1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8029f1:	55                   	push   %rbp
  8029f2:	48 89 e5             	mov    %rsp,%rbp
  8029f5:	48 83 ec 40          	sub    $0x40,%rsp
  8029f9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8029fd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a01:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802a05:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a09:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802a0d:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802a14:	00 
  802a15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a19:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802a1d:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802a22:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802a26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a2a:	8b 50 0c             	mov    0xc(%rax),%edx
  802a2d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802a34:	00 00 00 
  802a37:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802a39:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802a40:	00 00 00 
  802a43:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a47:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802a4b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a4f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a53:	48 89 c6             	mov    %rax,%rsi
  802a56:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  802a5d:	00 00 00 
  802a60:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  802a67:	00 00 00 
  802a6a:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802a6c:	be 00 00 00 00       	mov    $0x0,%esi
  802a71:	bf 04 00 00 00       	mov    $0x4,%edi
  802a76:	48 b8 53 27 80 00 00 	movabs $0x802753,%rax
  802a7d:	00 00 00 
  802a80:	ff d0                	callq  *%rax
  802a82:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a85:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a89:	79 05                	jns    802a90 <devfile_write+0x9f>
		return r;
  802a8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a8e:	eb 43                	jmp    802ad3 <devfile_write+0xe2>
	assert(r <= n);
  802a90:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a93:	48 98                	cltq   
  802a95:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802a99:	76 35                	jbe    802ad0 <devfile_write+0xdf>
  802a9b:	48 b9 96 4b 80 00 00 	movabs $0x804b96,%rcx
  802aa2:	00 00 00 
  802aa5:	48 ba 9d 4b 80 00 00 	movabs $0x804b9d,%rdx
  802aac:	00 00 00 
  802aaf:	be a2 00 00 00       	mov    $0xa2,%esi
  802ab4:	48 bf b2 4b 80 00 00 	movabs $0x804bb2,%rdi
  802abb:	00 00 00 
  802abe:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac3:	49 b8 ef 02 80 00 00 	movabs $0x8002ef,%r8
  802aca:	00 00 00 
  802acd:	41 ff d0             	callq  *%r8
	return r;
  802ad0:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802ad3:	c9                   	leaveq 
  802ad4:	c3                   	retq   

0000000000802ad5 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802ad5:	55                   	push   %rbp
  802ad6:	48 89 e5             	mov    %rsp,%rbp
  802ad9:	48 83 ec 20          	sub    $0x20,%rsp
  802add:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ae1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802ae5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae9:	8b 50 0c             	mov    0xc(%rax),%edx
  802aec:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802af3:	00 00 00 
  802af6:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802af8:	be 00 00 00 00       	mov    $0x0,%esi
  802afd:	bf 05 00 00 00       	mov    $0x5,%edi
  802b02:	48 b8 53 27 80 00 00 	movabs $0x802753,%rax
  802b09:	00 00 00 
  802b0c:	ff d0                	callq  *%rax
  802b0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b15:	79 05                	jns    802b1c <devfile_stat+0x47>
		return r;
  802b17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1a:	eb 56                	jmp    802b72 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b20:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802b27:	00 00 00 
  802b2a:	48 89 c7             	mov    %rax,%rdi
  802b2d:	48 b8 dd 10 80 00 00 	movabs $0x8010dd,%rax
  802b34:	00 00 00 
  802b37:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b39:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802b40:	00 00 00 
  802b43:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b4d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b53:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802b5a:	00 00 00 
  802b5d:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b67:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b72:	c9                   	leaveq 
  802b73:	c3                   	retq   

0000000000802b74 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b74:	55                   	push   %rbp
  802b75:	48 89 e5             	mov    %rsp,%rbp
  802b78:	48 83 ec 10          	sub    $0x10,%rsp
  802b7c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b80:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b87:	8b 50 0c             	mov    0xc(%rax),%edx
  802b8a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802b91:	00 00 00 
  802b94:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b96:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802b9d:	00 00 00 
  802ba0:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802ba3:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802ba6:	be 00 00 00 00       	mov    $0x0,%esi
  802bab:	bf 02 00 00 00       	mov    $0x2,%edi
  802bb0:	48 b8 53 27 80 00 00 	movabs $0x802753,%rax
  802bb7:	00 00 00 
  802bba:	ff d0                	callq  *%rax
}
  802bbc:	c9                   	leaveq 
  802bbd:	c3                   	retq   

0000000000802bbe <remove>:

// Delete a file
int
remove(const char *path)
{
  802bbe:	55                   	push   %rbp
  802bbf:	48 89 e5             	mov    %rsp,%rbp
  802bc2:	48 83 ec 10          	sub    $0x10,%rsp
  802bc6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802bca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bce:	48 89 c7             	mov    %rax,%rdi
  802bd1:	48 b8 71 10 80 00 00 	movabs $0x801071,%rax
  802bd8:	00 00 00 
  802bdb:	ff d0                	callq  *%rax
  802bdd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802be2:	7e 07                	jle    802beb <remove+0x2d>
		return -E_BAD_PATH;
  802be4:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802be9:	eb 33                	jmp    802c1e <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802beb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bef:	48 89 c6             	mov    %rax,%rsi
  802bf2:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  802bf9:	00 00 00 
  802bfc:	48 b8 dd 10 80 00 00 	movabs $0x8010dd,%rax
  802c03:	00 00 00 
  802c06:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802c08:	be 00 00 00 00       	mov    $0x0,%esi
  802c0d:	bf 07 00 00 00       	mov    $0x7,%edi
  802c12:	48 b8 53 27 80 00 00 	movabs $0x802753,%rax
  802c19:	00 00 00 
  802c1c:	ff d0                	callq  *%rax
}
  802c1e:	c9                   	leaveq 
  802c1f:	c3                   	retq   

0000000000802c20 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c20:	55                   	push   %rbp
  802c21:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c24:	be 00 00 00 00       	mov    $0x0,%esi
  802c29:	bf 08 00 00 00       	mov    $0x8,%edi
  802c2e:	48 b8 53 27 80 00 00 	movabs $0x802753,%rax
  802c35:	00 00 00 
  802c38:	ff d0                	callq  *%rax
}
  802c3a:	5d                   	pop    %rbp
  802c3b:	c3                   	retq   

0000000000802c3c <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802c3c:	55                   	push   %rbp
  802c3d:	48 89 e5             	mov    %rsp,%rbp
  802c40:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802c47:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802c4e:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802c55:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802c5c:	be 00 00 00 00       	mov    $0x0,%esi
  802c61:	48 89 c7             	mov    %rax,%rdi
  802c64:	48 b8 da 27 80 00 00 	movabs $0x8027da,%rax
  802c6b:	00 00 00 
  802c6e:	ff d0                	callq  *%rax
  802c70:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802c73:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c77:	79 28                	jns    802ca1 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802c79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c7c:	89 c6                	mov    %eax,%esi
  802c7e:	48 bf c9 4b 80 00 00 	movabs $0x804bc9,%rdi
  802c85:	00 00 00 
  802c88:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8d:	48 ba 28 05 80 00 00 	movabs $0x800528,%rdx
  802c94:	00 00 00 
  802c97:	ff d2                	callq  *%rdx
		return fd_src;
  802c99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9c:	e9 74 01 00 00       	jmpq   802e15 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802ca1:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802ca8:	be 01 01 00 00       	mov    $0x101,%esi
  802cad:	48 89 c7             	mov    %rax,%rdi
  802cb0:	48 b8 da 27 80 00 00 	movabs $0x8027da,%rax
  802cb7:	00 00 00 
  802cba:	ff d0                	callq  *%rax
  802cbc:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802cbf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802cc3:	79 39                	jns    802cfe <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802cc5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cc8:	89 c6                	mov    %eax,%esi
  802cca:	48 bf df 4b 80 00 00 	movabs $0x804bdf,%rdi
  802cd1:	00 00 00 
  802cd4:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd9:	48 ba 28 05 80 00 00 	movabs $0x800528,%rdx
  802ce0:	00 00 00 
  802ce3:	ff d2                	callq  *%rdx
		close(fd_src);
  802ce5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce8:	89 c7                	mov    %eax,%edi
  802cea:	48 b8 e2 20 80 00 00 	movabs $0x8020e2,%rax
  802cf1:	00 00 00 
  802cf4:	ff d0                	callq  *%rax
		return fd_dest;
  802cf6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cf9:	e9 17 01 00 00       	jmpq   802e15 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802cfe:	eb 74                	jmp    802d74 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802d00:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d03:	48 63 d0             	movslq %eax,%rdx
  802d06:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d10:	48 89 ce             	mov    %rcx,%rsi
  802d13:	89 c7                	mov    %eax,%edi
  802d15:	48 b8 4e 24 80 00 00 	movabs $0x80244e,%rax
  802d1c:	00 00 00 
  802d1f:	ff d0                	callq  *%rax
  802d21:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802d24:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802d28:	79 4a                	jns    802d74 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802d2a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d2d:	89 c6                	mov    %eax,%esi
  802d2f:	48 bf f9 4b 80 00 00 	movabs $0x804bf9,%rdi
  802d36:	00 00 00 
  802d39:	b8 00 00 00 00       	mov    $0x0,%eax
  802d3e:	48 ba 28 05 80 00 00 	movabs $0x800528,%rdx
  802d45:	00 00 00 
  802d48:	ff d2                	callq  *%rdx
			close(fd_src);
  802d4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d4d:	89 c7                	mov    %eax,%edi
  802d4f:	48 b8 e2 20 80 00 00 	movabs $0x8020e2,%rax
  802d56:	00 00 00 
  802d59:	ff d0                	callq  *%rax
			close(fd_dest);
  802d5b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d5e:	89 c7                	mov    %eax,%edi
  802d60:	48 b8 e2 20 80 00 00 	movabs $0x8020e2,%rax
  802d67:	00 00 00 
  802d6a:	ff d0                	callq  *%rax
			return write_size;
  802d6c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d6f:	e9 a1 00 00 00       	jmpq   802e15 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d74:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d7e:	ba 00 02 00 00       	mov    $0x200,%edx
  802d83:	48 89 ce             	mov    %rcx,%rsi
  802d86:	89 c7                	mov    %eax,%edi
  802d88:	48 b8 04 23 80 00 00 	movabs $0x802304,%rax
  802d8f:	00 00 00 
  802d92:	ff d0                	callq  *%rax
  802d94:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d97:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d9b:	0f 8f 5f ff ff ff    	jg     802d00 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802da1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802da5:	79 47                	jns    802dee <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802da7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802daa:	89 c6                	mov    %eax,%esi
  802dac:	48 bf 0c 4c 80 00 00 	movabs $0x804c0c,%rdi
  802db3:	00 00 00 
  802db6:	b8 00 00 00 00       	mov    $0x0,%eax
  802dbb:	48 ba 28 05 80 00 00 	movabs $0x800528,%rdx
  802dc2:	00 00 00 
  802dc5:	ff d2                	callq  *%rdx
		close(fd_src);
  802dc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dca:	89 c7                	mov    %eax,%edi
  802dcc:	48 b8 e2 20 80 00 00 	movabs $0x8020e2,%rax
  802dd3:	00 00 00 
  802dd6:	ff d0                	callq  *%rax
		close(fd_dest);
  802dd8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ddb:	89 c7                	mov    %eax,%edi
  802ddd:	48 b8 e2 20 80 00 00 	movabs $0x8020e2,%rax
  802de4:	00 00 00 
  802de7:	ff d0                	callq  *%rax
		return read_size;
  802de9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802dec:	eb 27                	jmp    802e15 <copy+0x1d9>
	}
	close(fd_src);
  802dee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df1:	89 c7                	mov    %eax,%edi
  802df3:	48 b8 e2 20 80 00 00 	movabs $0x8020e2,%rax
  802dfa:	00 00 00 
  802dfd:	ff d0                	callq  *%rax
	close(fd_dest);
  802dff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e02:	89 c7                	mov    %eax,%edi
  802e04:	48 b8 e2 20 80 00 00 	movabs $0x8020e2,%rax
  802e0b:	00 00 00 
  802e0e:	ff d0                	callq  *%rax
	return 0;
  802e10:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802e15:	c9                   	leaveq 
  802e16:	c3                   	retq   

0000000000802e17 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802e17:	55                   	push   %rbp
  802e18:	48 89 e5             	mov    %rsp,%rbp
  802e1b:	48 83 ec 20          	sub    $0x20,%rsp
  802e1f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802e23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e27:	8b 40 0c             	mov    0xc(%rax),%eax
  802e2a:	85 c0                	test   %eax,%eax
  802e2c:	7e 67                	jle    802e95 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802e2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e32:	8b 40 04             	mov    0x4(%rax),%eax
  802e35:	48 63 d0             	movslq %eax,%rdx
  802e38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e3c:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802e40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e44:	8b 00                	mov    (%rax),%eax
  802e46:	48 89 ce             	mov    %rcx,%rsi
  802e49:	89 c7                	mov    %eax,%edi
  802e4b:	48 b8 4e 24 80 00 00 	movabs $0x80244e,%rax
  802e52:	00 00 00 
  802e55:	ff d0                	callq  *%rax
  802e57:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802e5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e5e:	7e 13                	jle    802e73 <writebuf+0x5c>
			b->result += result;
  802e60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e64:	8b 50 08             	mov    0x8(%rax),%edx
  802e67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e6a:	01 c2                	add    %eax,%edx
  802e6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e70:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802e73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e77:	8b 40 04             	mov    0x4(%rax),%eax
  802e7a:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802e7d:	74 16                	je     802e95 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802e7f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e88:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802e8c:	89 c2                	mov    %eax,%edx
  802e8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e92:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802e95:	c9                   	leaveq 
  802e96:	c3                   	retq   

0000000000802e97 <putch>:

static void
putch(int ch, void *thunk)
{
  802e97:	55                   	push   %rbp
  802e98:	48 89 e5             	mov    %rsp,%rbp
  802e9b:	48 83 ec 20          	sub    $0x20,%rsp
  802e9f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ea2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802ea6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eaa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802eae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eb2:	8b 40 04             	mov    0x4(%rax),%eax
  802eb5:	8d 48 01             	lea    0x1(%rax),%ecx
  802eb8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ebc:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802ebf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ec2:	89 d1                	mov    %edx,%ecx
  802ec4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ec8:	48 98                	cltq   
  802eca:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802ece:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ed2:	8b 40 04             	mov    0x4(%rax),%eax
  802ed5:	3d 00 01 00 00       	cmp    $0x100,%eax
  802eda:	75 1e                	jne    802efa <putch+0x63>
		writebuf(b);
  802edc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ee0:	48 89 c7             	mov    %rax,%rdi
  802ee3:	48 b8 17 2e 80 00 00 	movabs $0x802e17,%rax
  802eea:	00 00 00 
  802eed:	ff d0                	callq  *%rax
		b->idx = 0;
  802eef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ef3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802efa:	c9                   	leaveq 
  802efb:	c3                   	retq   

0000000000802efc <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802efc:	55                   	push   %rbp
  802efd:	48 89 e5             	mov    %rsp,%rbp
  802f00:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802f07:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802f0d:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802f14:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802f1b:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802f21:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802f27:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802f2e:	00 00 00 
	b.result = 0;
  802f31:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802f38:	00 00 00 
	b.error = 1;
  802f3b:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802f42:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802f45:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802f4c:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802f53:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802f5a:	48 89 c6             	mov    %rax,%rsi
  802f5d:	48 bf 97 2e 80 00 00 	movabs $0x802e97,%rdi
  802f64:	00 00 00 
  802f67:	48 b8 db 08 80 00 00 	movabs $0x8008db,%rax
  802f6e:	00 00 00 
  802f71:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802f73:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802f79:	85 c0                	test   %eax,%eax
  802f7b:	7e 16                	jle    802f93 <vfprintf+0x97>
		writebuf(&b);
  802f7d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802f84:	48 89 c7             	mov    %rax,%rdi
  802f87:	48 b8 17 2e 80 00 00 	movabs $0x802e17,%rax
  802f8e:	00 00 00 
  802f91:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802f93:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802f99:	85 c0                	test   %eax,%eax
  802f9b:	74 08                	je     802fa5 <vfprintf+0xa9>
  802f9d:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802fa3:	eb 06                	jmp    802fab <vfprintf+0xaf>
  802fa5:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802fab:	c9                   	leaveq 
  802fac:	c3                   	retq   

0000000000802fad <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802fad:	55                   	push   %rbp
  802fae:	48 89 e5             	mov    %rsp,%rbp
  802fb1:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802fb8:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802fbe:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802fc5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802fcc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802fd3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802fda:	84 c0                	test   %al,%al
  802fdc:	74 20                	je     802ffe <fprintf+0x51>
  802fde:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802fe2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802fe6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802fea:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802fee:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802ff2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802ff6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802ffa:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802ffe:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803005:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  80300c:	00 00 00 
  80300f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803016:	00 00 00 
  803019:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80301d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803024:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80302b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  803032:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803039:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  803040:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803046:	48 89 ce             	mov    %rcx,%rsi
  803049:	89 c7                	mov    %eax,%edi
  80304b:	48 b8 fc 2e 80 00 00 	movabs $0x802efc,%rax
  803052:	00 00 00 
  803055:	ff d0                	callq  *%rax
  803057:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80305d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803063:	c9                   	leaveq 
  803064:	c3                   	retq   

0000000000803065 <printf>:

int
printf(const char *fmt, ...)
{
  803065:	55                   	push   %rbp
  803066:	48 89 e5             	mov    %rsp,%rbp
  803069:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803070:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803077:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80307e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803085:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80308c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803093:	84 c0                	test   %al,%al
  803095:	74 20                	je     8030b7 <printf+0x52>
  803097:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80309b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80309f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8030a3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8030a7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8030ab:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8030af:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8030b3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8030b7:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8030be:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8030c5:	00 00 00 
  8030c8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8030cf:	00 00 00 
  8030d2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8030d6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8030dd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8030e4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)

	cnt = vfprintf(1, fmt, ap);
  8030eb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8030f2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8030f9:	48 89 c6             	mov    %rax,%rsi
  8030fc:	bf 01 00 00 00       	mov    $0x1,%edi
  803101:	48 b8 fc 2e 80 00 00 	movabs $0x802efc,%rax
  803108:	00 00 00 
  80310b:	ff d0                	callq  *%rax
  80310d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)

	va_end(ap);

	return cnt;
  803113:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803119:	c9                   	leaveq 
  80311a:	c3                   	retq   

000000000080311b <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80311b:	55                   	push   %rbp
  80311c:	48 89 e5             	mov    %rsp,%rbp
  80311f:	48 83 ec 20          	sub    $0x20,%rsp
  803123:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803126:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80312a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80312d:	48 89 d6             	mov    %rdx,%rsi
  803130:	89 c7                	mov    %eax,%edi
  803132:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  803139:	00 00 00 
  80313c:	ff d0                	callq  *%rax
  80313e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803141:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803145:	79 05                	jns    80314c <fd2sockid+0x31>
		return r;
  803147:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80314a:	eb 24                	jmp    803170 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80314c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803150:	8b 10                	mov    (%rax),%edx
  803152:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803159:	00 00 00 
  80315c:	8b 00                	mov    (%rax),%eax
  80315e:	39 c2                	cmp    %eax,%edx
  803160:	74 07                	je     803169 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803162:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803167:	eb 07                	jmp    803170 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803169:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80316d:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803170:	c9                   	leaveq 
  803171:	c3                   	retq   

0000000000803172 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803172:	55                   	push   %rbp
  803173:	48 89 e5             	mov    %rsp,%rbp
  803176:	48 83 ec 20          	sub    $0x20,%rsp
  80317a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80317d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803181:	48 89 c7             	mov    %rax,%rdi
  803184:	48 b8 3a 1e 80 00 00 	movabs $0x801e3a,%rax
  80318b:	00 00 00 
  80318e:	ff d0                	callq  *%rax
  803190:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803193:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803197:	78 26                	js     8031bf <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803199:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80319d:	ba 07 04 00 00       	mov    $0x407,%edx
  8031a2:	48 89 c6             	mov    %rax,%rsi
  8031a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8031aa:	48 b8 0c 1a 80 00 00 	movabs $0x801a0c,%rax
  8031b1:	00 00 00 
  8031b4:	ff d0                	callq  *%rax
  8031b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031bd:	79 16                	jns    8031d5 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8031bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031c2:	89 c7                	mov    %eax,%edi
  8031c4:	48 b8 7f 36 80 00 00 	movabs $0x80367f,%rax
  8031cb:	00 00 00 
  8031ce:	ff d0                	callq  *%rax
		return r;
  8031d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d3:	eb 3a                	jmp    80320f <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8031d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031d9:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8031e0:	00 00 00 
  8031e3:	8b 12                	mov    (%rdx),%edx
  8031e5:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8031e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031eb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8031f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031f6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031f9:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8031fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803200:	48 89 c7             	mov    %rax,%rdi
  803203:	48 b8 ec 1d 80 00 00 	movabs $0x801dec,%rax
  80320a:	00 00 00 
  80320d:	ff d0                	callq  *%rax
}
  80320f:	c9                   	leaveq 
  803210:	c3                   	retq   

0000000000803211 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803211:	55                   	push   %rbp
  803212:	48 89 e5             	mov    %rsp,%rbp
  803215:	48 83 ec 30          	sub    $0x30,%rsp
  803219:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80321c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803220:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803224:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803227:	89 c7                	mov    %eax,%edi
  803229:	48 b8 1b 31 80 00 00 	movabs $0x80311b,%rax
  803230:	00 00 00 
  803233:	ff d0                	callq  *%rax
  803235:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803238:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80323c:	79 05                	jns    803243 <accept+0x32>
		return r;
  80323e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803241:	eb 3b                	jmp    80327e <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803243:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803247:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80324b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80324e:	48 89 ce             	mov    %rcx,%rsi
  803251:	89 c7                	mov    %eax,%edi
  803253:	48 b8 5c 35 80 00 00 	movabs $0x80355c,%rax
  80325a:	00 00 00 
  80325d:	ff d0                	callq  *%rax
  80325f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803262:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803266:	79 05                	jns    80326d <accept+0x5c>
		return r;
  803268:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80326b:	eb 11                	jmp    80327e <accept+0x6d>
	return alloc_sockfd(r);
  80326d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803270:	89 c7                	mov    %eax,%edi
  803272:	48 b8 72 31 80 00 00 	movabs $0x803172,%rax
  803279:	00 00 00 
  80327c:	ff d0                	callq  *%rax
}
  80327e:	c9                   	leaveq 
  80327f:	c3                   	retq   

0000000000803280 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803280:	55                   	push   %rbp
  803281:	48 89 e5             	mov    %rsp,%rbp
  803284:	48 83 ec 20          	sub    $0x20,%rsp
  803288:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80328b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80328f:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803292:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803295:	89 c7                	mov    %eax,%edi
  803297:	48 b8 1b 31 80 00 00 	movabs $0x80311b,%rax
  80329e:	00 00 00 
  8032a1:	ff d0                	callq  *%rax
  8032a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032aa:	79 05                	jns    8032b1 <bind+0x31>
		return r;
  8032ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032af:	eb 1b                	jmp    8032cc <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8032b1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8032b4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8032b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032bb:	48 89 ce             	mov    %rcx,%rsi
  8032be:	89 c7                	mov    %eax,%edi
  8032c0:	48 b8 db 35 80 00 00 	movabs $0x8035db,%rax
  8032c7:	00 00 00 
  8032ca:	ff d0                	callq  *%rax
}
  8032cc:	c9                   	leaveq 
  8032cd:	c3                   	retq   

00000000008032ce <shutdown>:

int
shutdown(int s, int how)
{
  8032ce:	55                   	push   %rbp
  8032cf:	48 89 e5             	mov    %rsp,%rbp
  8032d2:	48 83 ec 20          	sub    $0x20,%rsp
  8032d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032d9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032df:	89 c7                	mov    %eax,%edi
  8032e1:	48 b8 1b 31 80 00 00 	movabs $0x80311b,%rax
  8032e8:	00 00 00 
  8032eb:	ff d0                	callq  *%rax
  8032ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f4:	79 05                	jns    8032fb <shutdown+0x2d>
		return r;
  8032f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f9:	eb 16                	jmp    803311 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8032fb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8032fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803301:	89 d6                	mov    %edx,%esi
  803303:	89 c7                	mov    %eax,%edi
  803305:	48 b8 3f 36 80 00 00 	movabs $0x80363f,%rax
  80330c:	00 00 00 
  80330f:	ff d0                	callq  *%rax
}
  803311:	c9                   	leaveq 
  803312:	c3                   	retq   

0000000000803313 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803313:	55                   	push   %rbp
  803314:	48 89 e5             	mov    %rsp,%rbp
  803317:	48 83 ec 10          	sub    $0x10,%rsp
  80331b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80331f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803323:	48 89 c7             	mov    %rax,%rdi
  803326:	48 b8 e2 44 80 00 00 	movabs $0x8044e2,%rax
  80332d:	00 00 00 
  803330:	ff d0                	callq  *%rax
  803332:	83 f8 01             	cmp    $0x1,%eax
  803335:	75 17                	jne    80334e <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803337:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80333b:	8b 40 0c             	mov    0xc(%rax),%eax
  80333e:	89 c7                	mov    %eax,%edi
  803340:	48 b8 7f 36 80 00 00 	movabs $0x80367f,%rax
  803347:	00 00 00 
  80334a:	ff d0                	callq  *%rax
  80334c:	eb 05                	jmp    803353 <devsock_close+0x40>
	else
		return 0;
  80334e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803353:	c9                   	leaveq 
  803354:	c3                   	retq   

0000000000803355 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803355:	55                   	push   %rbp
  803356:	48 89 e5             	mov    %rsp,%rbp
  803359:	48 83 ec 20          	sub    $0x20,%rsp
  80335d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803360:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803364:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803367:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80336a:	89 c7                	mov    %eax,%edi
  80336c:	48 b8 1b 31 80 00 00 	movabs $0x80311b,%rax
  803373:	00 00 00 
  803376:	ff d0                	callq  *%rax
  803378:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80337b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80337f:	79 05                	jns    803386 <connect+0x31>
		return r;
  803381:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803384:	eb 1b                	jmp    8033a1 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803386:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803389:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80338d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803390:	48 89 ce             	mov    %rcx,%rsi
  803393:	89 c7                	mov    %eax,%edi
  803395:	48 b8 ac 36 80 00 00 	movabs $0x8036ac,%rax
  80339c:	00 00 00 
  80339f:	ff d0                	callq  *%rax
}
  8033a1:	c9                   	leaveq 
  8033a2:	c3                   	retq   

00000000008033a3 <listen>:

int
listen(int s, int backlog)
{
  8033a3:	55                   	push   %rbp
  8033a4:	48 89 e5             	mov    %rsp,%rbp
  8033a7:	48 83 ec 20          	sub    $0x20,%rsp
  8033ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033ae:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033b4:	89 c7                	mov    %eax,%edi
  8033b6:	48 b8 1b 31 80 00 00 	movabs $0x80311b,%rax
  8033bd:	00 00 00 
  8033c0:	ff d0                	callq  *%rax
  8033c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033c9:	79 05                	jns    8033d0 <listen+0x2d>
		return r;
  8033cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ce:	eb 16                	jmp    8033e6 <listen+0x43>
	return nsipc_listen(r, backlog);
  8033d0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d6:	89 d6                	mov    %edx,%esi
  8033d8:	89 c7                	mov    %eax,%edi
  8033da:	48 b8 10 37 80 00 00 	movabs $0x803710,%rax
  8033e1:	00 00 00 
  8033e4:	ff d0                	callq  *%rax
}
  8033e6:	c9                   	leaveq 
  8033e7:	c3                   	retq   

00000000008033e8 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8033e8:	55                   	push   %rbp
  8033e9:	48 89 e5             	mov    %rsp,%rbp
  8033ec:	48 83 ec 20          	sub    $0x20,%rsp
  8033f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033f8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8033fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803400:	89 c2                	mov    %eax,%edx
  803402:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803406:	8b 40 0c             	mov    0xc(%rax),%eax
  803409:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80340d:	b9 00 00 00 00       	mov    $0x0,%ecx
  803412:	89 c7                	mov    %eax,%edi
  803414:	48 b8 50 37 80 00 00 	movabs $0x803750,%rax
  80341b:	00 00 00 
  80341e:	ff d0                	callq  *%rax
}
  803420:	c9                   	leaveq 
  803421:	c3                   	retq   

0000000000803422 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803422:	55                   	push   %rbp
  803423:	48 89 e5             	mov    %rsp,%rbp
  803426:	48 83 ec 20          	sub    $0x20,%rsp
  80342a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80342e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803432:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803436:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80343a:	89 c2                	mov    %eax,%edx
  80343c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803440:	8b 40 0c             	mov    0xc(%rax),%eax
  803443:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803447:	b9 00 00 00 00       	mov    $0x0,%ecx
  80344c:	89 c7                	mov    %eax,%edi
  80344e:	48 b8 1c 38 80 00 00 	movabs $0x80381c,%rax
  803455:	00 00 00 
  803458:	ff d0                	callq  *%rax
}
  80345a:	c9                   	leaveq 
  80345b:	c3                   	retq   

000000000080345c <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80345c:	55                   	push   %rbp
  80345d:	48 89 e5             	mov    %rsp,%rbp
  803460:	48 83 ec 10          	sub    $0x10,%rsp
  803464:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803468:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80346c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803470:	48 be 27 4c 80 00 00 	movabs $0x804c27,%rsi
  803477:	00 00 00 
  80347a:	48 89 c7             	mov    %rax,%rdi
  80347d:	48 b8 dd 10 80 00 00 	movabs $0x8010dd,%rax
  803484:	00 00 00 
  803487:	ff d0                	callq  *%rax
	return 0;
  803489:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80348e:	c9                   	leaveq 
  80348f:	c3                   	retq   

0000000000803490 <socket>:

int
socket(int domain, int type, int protocol)
{
  803490:	55                   	push   %rbp
  803491:	48 89 e5             	mov    %rsp,%rbp
  803494:	48 83 ec 20          	sub    $0x20,%rsp
  803498:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80349b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80349e:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8034a1:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8034a4:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8034a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034aa:	89 ce                	mov    %ecx,%esi
  8034ac:	89 c7                	mov    %eax,%edi
  8034ae:	48 b8 d4 38 80 00 00 	movabs $0x8038d4,%rax
  8034b5:	00 00 00 
  8034b8:	ff d0                	callq  *%rax
  8034ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034c1:	79 05                	jns    8034c8 <socket+0x38>
		return r;
  8034c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c6:	eb 11                	jmp    8034d9 <socket+0x49>
	return alloc_sockfd(r);
  8034c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034cb:	89 c7                	mov    %eax,%edi
  8034cd:	48 b8 72 31 80 00 00 	movabs $0x803172,%rax
  8034d4:	00 00 00 
  8034d7:	ff d0                	callq  *%rax
}
  8034d9:	c9                   	leaveq 
  8034da:	c3                   	retq   

00000000008034db <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8034db:	55                   	push   %rbp
  8034dc:	48 89 e5             	mov    %rsp,%rbp
  8034df:	48 83 ec 10          	sub    $0x10,%rsp
  8034e3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8034e6:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8034ed:	00 00 00 
  8034f0:	8b 00                	mov    (%rax),%eax
  8034f2:	85 c0                	test   %eax,%eax
  8034f4:	75 1d                	jne    803513 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8034f6:	bf 02 00 00 00       	mov    $0x2,%edi
  8034fb:	48 b8 70 44 80 00 00 	movabs $0x804470,%rax
  803502:	00 00 00 
  803505:	ff d0                	callq  *%rax
  803507:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  80350e:	00 00 00 
  803511:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803513:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80351a:	00 00 00 
  80351d:	8b 00                	mov    (%rax),%eax
  80351f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803522:	b9 07 00 00 00       	mov    $0x7,%ecx
  803527:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  80352e:	00 00 00 
  803531:	89 c7                	mov    %eax,%edi
  803533:	48 b8 64 42 80 00 00 	movabs $0x804264,%rax
  80353a:	00 00 00 
  80353d:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80353f:	ba 00 00 00 00       	mov    $0x0,%edx
  803544:	be 00 00 00 00       	mov    $0x0,%esi
  803549:	bf 00 00 00 00       	mov    $0x0,%edi
  80354e:	48 b8 a3 41 80 00 00 	movabs $0x8041a3,%rax
  803555:	00 00 00 
  803558:	ff d0                	callq  *%rax
}
  80355a:	c9                   	leaveq 
  80355b:	c3                   	retq   

000000000080355c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80355c:	55                   	push   %rbp
  80355d:	48 89 e5             	mov    %rsp,%rbp
  803560:	48 83 ec 30          	sub    $0x30,%rsp
  803564:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803567:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80356b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80356f:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803576:	00 00 00 
  803579:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80357c:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80357e:	bf 01 00 00 00       	mov    $0x1,%edi
  803583:	48 b8 db 34 80 00 00 	movabs $0x8034db,%rax
  80358a:	00 00 00 
  80358d:	ff d0                	callq  *%rax
  80358f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803592:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803596:	78 3e                	js     8035d6 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803598:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80359f:	00 00 00 
  8035a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8035a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035aa:	8b 40 10             	mov    0x10(%rax),%eax
  8035ad:	89 c2                	mov    %eax,%edx
  8035af:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8035b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035b7:	48 89 ce             	mov    %rcx,%rsi
  8035ba:	48 89 c7             	mov    %rax,%rdi
  8035bd:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  8035c4:	00 00 00 
  8035c7:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8035c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035cd:	8b 50 10             	mov    0x10(%rax),%edx
  8035d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035d4:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8035d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8035d9:	c9                   	leaveq 
  8035da:	c3                   	retq   

00000000008035db <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8035db:	55                   	push   %rbp
  8035dc:	48 89 e5             	mov    %rsp,%rbp
  8035df:	48 83 ec 10          	sub    $0x10,%rsp
  8035e3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035e6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035ea:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8035ed:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8035f4:	00 00 00 
  8035f7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035fa:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8035fc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803603:	48 89 c6             	mov    %rax,%rsi
  803606:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  80360d:	00 00 00 
  803610:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  803617:	00 00 00 
  80361a:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80361c:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803623:	00 00 00 
  803626:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803629:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80362c:	bf 02 00 00 00       	mov    $0x2,%edi
  803631:	48 b8 db 34 80 00 00 	movabs $0x8034db,%rax
  803638:	00 00 00 
  80363b:	ff d0                	callq  *%rax
}
  80363d:	c9                   	leaveq 
  80363e:	c3                   	retq   

000000000080363f <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80363f:	55                   	push   %rbp
  803640:	48 89 e5             	mov    %rsp,%rbp
  803643:	48 83 ec 10          	sub    $0x10,%rsp
  803647:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80364a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80364d:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803654:	00 00 00 
  803657:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80365a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80365c:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803663:	00 00 00 
  803666:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803669:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80366c:	bf 03 00 00 00       	mov    $0x3,%edi
  803671:	48 b8 db 34 80 00 00 	movabs $0x8034db,%rax
  803678:	00 00 00 
  80367b:	ff d0                	callq  *%rax
}
  80367d:	c9                   	leaveq 
  80367e:	c3                   	retq   

000000000080367f <nsipc_close>:

int
nsipc_close(int s)
{
  80367f:	55                   	push   %rbp
  803680:	48 89 e5             	mov    %rsp,%rbp
  803683:	48 83 ec 10          	sub    $0x10,%rsp
  803687:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80368a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803691:	00 00 00 
  803694:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803697:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803699:	bf 04 00 00 00       	mov    $0x4,%edi
  80369e:	48 b8 db 34 80 00 00 	movabs $0x8034db,%rax
  8036a5:	00 00 00 
  8036a8:	ff d0                	callq  *%rax
}
  8036aa:	c9                   	leaveq 
  8036ab:	c3                   	retq   

00000000008036ac <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8036ac:	55                   	push   %rbp
  8036ad:	48 89 e5             	mov    %rsp,%rbp
  8036b0:	48 83 ec 10          	sub    $0x10,%rsp
  8036b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036bb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8036be:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8036c5:	00 00 00 
  8036c8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036cb:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8036cd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d4:	48 89 c6             	mov    %rax,%rsi
  8036d7:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  8036de:	00 00 00 
  8036e1:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  8036e8:	00 00 00 
  8036eb:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8036ed:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8036f4:	00 00 00 
  8036f7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036fa:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8036fd:	bf 05 00 00 00       	mov    $0x5,%edi
  803702:	48 b8 db 34 80 00 00 	movabs $0x8034db,%rax
  803709:	00 00 00 
  80370c:	ff d0                	callq  *%rax
}
  80370e:	c9                   	leaveq 
  80370f:	c3                   	retq   

0000000000803710 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803710:	55                   	push   %rbp
  803711:	48 89 e5             	mov    %rsp,%rbp
  803714:	48 83 ec 10          	sub    $0x10,%rsp
  803718:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80371b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80371e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803725:	00 00 00 
  803728:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80372b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80372d:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803734:	00 00 00 
  803737:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80373a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80373d:	bf 06 00 00 00       	mov    $0x6,%edi
  803742:	48 b8 db 34 80 00 00 	movabs $0x8034db,%rax
  803749:	00 00 00 
  80374c:	ff d0                	callq  *%rax
}
  80374e:	c9                   	leaveq 
  80374f:	c3                   	retq   

0000000000803750 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803750:	55                   	push   %rbp
  803751:	48 89 e5             	mov    %rsp,%rbp
  803754:	48 83 ec 30          	sub    $0x30,%rsp
  803758:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80375b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80375f:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803762:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803765:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80376c:	00 00 00 
  80376f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803772:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803774:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80377b:	00 00 00 
  80377e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803781:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803784:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80378b:	00 00 00 
  80378e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803791:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803794:	bf 07 00 00 00       	mov    $0x7,%edi
  803799:	48 b8 db 34 80 00 00 	movabs $0x8034db,%rax
  8037a0:	00 00 00 
  8037a3:	ff d0                	callq  *%rax
  8037a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037ac:	78 69                	js     803817 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8037ae:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8037b5:	7f 08                	jg     8037bf <nsipc_recv+0x6f>
  8037b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ba:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8037bd:	7e 35                	jle    8037f4 <nsipc_recv+0xa4>
  8037bf:	48 b9 2e 4c 80 00 00 	movabs $0x804c2e,%rcx
  8037c6:	00 00 00 
  8037c9:	48 ba 43 4c 80 00 00 	movabs $0x804c43,%rdx
  8037d0:	00 00 00 
  8037d3:	be 62 00 00 00       	mov    $0x62,%esi
  8037d8:	48 bf 58 4c 80 00 00 	movabs $0x804c58,%rdi
  8037df:	00 00 00 
  8037e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8037e7:	49 b8 ef 02 80 00 00 	movabs $0x8002ef,%r8
  8037ee:	00 00 00 
  8037f1:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8037f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037f7:	48 63 d0             	movslq %eax,%rdx
  8037fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037fe:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  803805:	00 00 00 
  803808:	48 89 c7             	mov    %rax,%rdi
  80380b:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  803812:	00 00 00 
  803815:	ff d0                	callq  *%rax
	}

	return r;
  803817:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80381a:	c9                   	leaveq 
  80381b:	c3                   	retq   

000000000080381c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80381c:	55                   	push   %rbp
  80381d:	48 89 e5             	mov    %rsp,%rbp
  803820:	48 83 ec 20          	sub    $0x20,%rsp
  803824:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803827:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80382b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80382e:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803831:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803838:	00 00 00 
  80383b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80383e:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803840:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803847:	7e 35                	jle    80387e <nsipc_send+0x62>
  803849:	48 b9 64 4c 80 00 00 	movabs $0x804c64,%rcx
  803850:	00 00 00 
  803853:	48 ba 43 4c 80 00 00 	movabs $0x804c43,%rdx
  80385a:	00 00 00 
  80385d:	be 6d 00 00 00       	mov    $0x6d,%esi
  803862:	48 bf 58 4c 80 00 00 	movabs $0x804c58,%rdi
  803869:	00 00 00 
  80386c:	b8 00 00 00 00       	mov    $0x0,%eax
  803871:	49 b8 ef 02 80 00 00 	movabs $0x8002ef,%r8
  803878:	00 00 00 
  80387b:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80387e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803881:	48 63 d0             	movslq %eax,%rdx
  803884:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803888:	48 89 c6             	mov    %rax,%rsi
  80388b:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  803892:	00 00 00 
  803895:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  80389c:	00 00 00 
  80389f:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8038a1:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8038a8:	00 00 00 
  8038ab:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038ae:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8038b1:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8038b8:	00 00 00 
  8038bb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8038be:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8038c1:	bf 08 00 00 00       	mov    $0x8,%edi
  8038c6:	48 b8 db 34 80 00 00 	movabs $0x8034db,%rax
  8038cd:	00 00 00 
  8038d0:	ff d0                	callq  *%rax
}
  8038d2:	c9                   	leaveq 
  8038d3:	c3                   	retq   

00000000008038d4 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8038d4:	55                   	push   %rbp
  8038d5:	48 89 e5             	mov    %rsp,%rbp
  8038d8:	48 83 ec 10          	sub    $0x10,%rsp
  8038dc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038df:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8038e2:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8038e5:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8038ec:	00 00 00 
  8038ef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038f2:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8038f4:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8038fb:	00 00 00 
  8038fe:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803901:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803904:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80390b:	00 00 00 
  80390e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803911:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803914:	bf 09 00 00 00       	mov    $0x9,%edi
  803919:	48 b8 db 34 80 00 00 	movabs $0x8034db,%rax
  803920:	00 00 00 
  803923:	ff d0                	callq  *%rax
}
  803925:	c9                   	leaveq 
  803926:	c3                   	retq   

0000000000803927 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803927:	55                   	push   %rbp
  803928:	48 89 e5             	mov    %rsp,%rbp
  80392b:	53                   	push   %rbx
  80392c:	48 83 ec 38          	sub    $0x38,%rsp
  803930:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803934:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803938:	48 89 c7             	mov    %rax,%rdi
  80393b:	48 b8 3a 1e 80 00 00 	movabs $0x801e3a,%rax
  803942:	00 00 00 
  803945:	ff d0                	callq  *%rax
  803947:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80394a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80394e:	0f 88 bf 01 00 00    	js     803b13 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803954:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803958:	ba 07 04 00 00       	mov    $0x407,%edx
  80395d:	48 89 c6             	mov    %rax,%rsi
  803960:	bf 00 00 00 00       	mov    $0x0,%edi
  803965:	48 b8 0c 1a 80 00 00 	movabs $0x801a0c,%rax
  80396c:	00 00 00 
  80396f:	ff d0                	callq  *%rax
  803971:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803974:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803978:	0f 88 95 01 00 00    	js     803b13 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80397e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803982:	48 89 c7             	mov    %rax,%rdi
  803985:	48 b8 3a 1e 80 00 00 	movabs $0x801e3a,%rax
  80398c:	00 00 00 
  80398f:	ff d0                	callq  *%rax
  803991:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803994:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803998:	0f 88 5d 01 00 00    	js     803afb <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80399e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039a2:	ba 07 04 00 00       	mov    $0x407,%edx
  8039a7:	48 89 c6             	mov    %rax,%rsi
  8039aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8039af:	48 b8 0c 1a 80 00 00 	movabs $0x801a0c,%rax
  8039b6:	00 00 00 
  8039b9:	ff d0                	callq  *%rax
  8039bb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039be:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039c2:	0f 88 33 01 00 00    	js     803afb <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8039c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039cc:	48 89 c7             	mov    %rax,%rdi
  8039cf:	48 b8 0f 1e 80 00 00 	movabs $0x801e0f,%rax
  8039d6:	00 00 00 
  8039d9:	ff d0                	callq  *%rax
  8039db:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8039df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039e3:	ba 07 04 00 00       	mov    $0x407,%edx
  8039e8:	48 89 c6             	mov    %rax,%rsi
  8039eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8039f0:	48 b8 0c 1a 80 00 00 	movabs $0x801a0c,%rax
  8039f7:	00 00 00 
  8039fa:	ff d0                	callq  *%rax
  8039fc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a03:	79 05                	jns    803a0a <pipe+0xe3>
		goto err2;
  803a05:	e9 d9 00 00 00       	jmpq   803ae3 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a0a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a0e:	48 89 c7             	mov    %rax,%rdi
  803a11:	48 b8 0f 1e 80 00 00 	movabs $0x801e0f,%rax
  803a18:	00 00 00 
  803a1b:	ff d0                	callq  *%rax
  803a1d:	48 89 c2             	mov    %rax,%rdx
  803a20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a24:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803a2a:	48 89 d1             	mov    %rdx,%rcx
  803a2d:	ba 00 00 00 00       	mov    $0x0,%edx
  803a32:	48 89 c6             	mov    %rax,%rsi
  803a35:	bf 00 00 00 00       	mov    $0x0,%edi
  803a3a:	48 b8 5c 1a 80 00 00 	movabs $0x801a5c,%rax
  803a41:	00 00 00 
  803a44:	ff d0                	callq  *%rax
  803a46:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a49:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a4d:	79 1b                	jns    803a6a <pipe+0x143>
		goto err3;
  803a4f:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803a50:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a54:	48 89 c6             	mov    %rax,%rsi
  803a57:	bf 00 00 00 00       	mov    $0x0,%edi
  803a5c:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  803a63:	00 00 00 
  803a66:	ff d0                	callq  *%rax
  803a68:	eb 79                	jmp    803ae3 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803a6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a6e:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803a75:	00 00 00 
  803a78:	8b 12                	mov    (%rdx),%edx
  803a7a:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803a7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a80:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803a87:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a8b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803a92:	00 00 00 
  803a95:	8b 12                	mov    (%rdx),%edx
  803a97:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803a99:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a9d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803aa4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aa8:	48 89 c7             	mov    %rax,%rdi
  803aab:	48 b8 ec 1d 80 00 00 	movabs $0x801dec,%rax
  803ab2:	00 00 00 
  803ab5:	ff d0                	callq  *%rax
  803ab7:	89 c2                	mov    %eax,%edx
  803ab9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803abd:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803abf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ac3:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803ac7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803acb:	48 89 c7             	mov    %rax,%rdi
  803ace:	48 b8 ec 1d 80 00 00 	movabs $0x801dec,%rax
  803ad5:	00 00 00 
  803ad8:	ff d0                	callq  *%rax
  803ada:	89 03                	mov    %eax,(%rbx)
	return 0;
  803adc:	b8 00 00 00 00       	mov    $0x0,%eax
  803ae1:	eb 33                	jmp    803b16 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803ae3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ae7:	48 89 c6             	mov    %rax,%rsi
  803aea:	bf 00 00 00 00       	mov    $0x0,%edi
  803aef:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  803af6:	00 00 00 
  803af9:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803afb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aff:	48 89 c6             	mov    %rax,%rsi
  803b02:	bf 00 00 00 00       	mov    $0x0,%edi
  803b07:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  803b0e:	00 00 00 
  803b11:	ff d0                	callq  *%rax
err:
	return r;
  803b13:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803b16:	48 83 c4 38          	add    $0x38,%rsp
  803b1a:	5b                   	pop    %rbx
  803b1b:	5d                   	pop    %rbp
  803b1c:	c3                   	retq   

0000000000803b1d <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803b1d:	55                   	push   %rbp
  803b1e:	48 89 e5             	mov    %rsp,%rbp
  803b21:	53                   	push   %rbx
  803b22:	48 83 ec 28          	sub    $0x28,%rsp
  803b26:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b2a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803b2e:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803b35:	00 00 00 
  803b38:	48 8b 00             	mov    (%rax),%rax
  803b3b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803b41:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803b44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b48:	48 89 c7             	mov    %rax,%rdi
  803b4b:	48 b8 e2 44 80 00 00 	movabs $0x8044e2,%rax
  803b52:	00 00 00 
  803b55:	ff d0                	callq  *%rax
  803b57:	89 c3                	mov    %eax,%ebx
  803b59:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b5d:	48 89 c7             	mov    %rax,%rdi
  803b60:	48 b8 e2 44 80 00 00 	movabs $0x8044e2,%rax
  803b67:	00 00 00 
  803b6a:	ff d0                	callq  *%rax
  803b6c:	39 c3                	cmp    %eax,%ebx
  803b6e:	0f 94 c0             	sete   %al
  803b71:	0f b6 c0             	movzbl %al,%eax
  803b74:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803b77:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803b7e:	00 00 00 
  803b81:	48 8b 00             	mov    (%rax),%rax
  803b84:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803b8a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803b8d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b90:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803b93:	75 05                	jne    803b9a <_pipeisclosed+0x7d>
			return ret;
  803b95:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b98:	eb 4f                	jmp    803be9 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803b9a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b9d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ba0:	74 42                	je     803be4 <_pipeisclosed+0xc7>
  803ba2:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803ba6:	75 3c                	jne    803be4 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803ba8:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803baf:	00 00 00 
  803bb2:	48 8b 00             	mov    (%rax),%rax
  803bb5:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803bbb:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803bbe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bc1:	89 c6                	mov    %eax,%esi
  803bc3:	48 bf 75 4c 80 00 00 	movabs $0x804c75,%rdi
  803bca:	00 00 00 
  803bcd:	b8 00 00 00 00       	mov    $0x0,%eax
  803bd2:	49 b8 28 05 80 00 00 	movabs $0x800528,%r8
  803bd9:	00 00 00 
  803bdc:	41 ff d0             	callq  *%r8
	}
  803bdf:	e9 4a ff ff ff       	jmpq   803b2e <_pipeisclosed+0x11>
  803be4:	e9 45 ff ff ff       	jmpq   803b2e <_pipeisclosed+0x11>

}
  803be9:	48 83 c4 28          	add    $0x28,%rsp
  803bed:	5b                   	pop    %rbx
  803bee:	5d                   	pop    %rbp
  803bef:	c3                   	retq   

0000000000803bf0 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803bf0:	55                   	push   %rbp
  803bf1:	48 89 e5             	mov    %rsp,%rbp
  803bf4:	48 83 ec 30          	sub    $0x30,%rsp
  803bf8:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803bfb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803bff:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803c02:	48 89 d6             	mov    %rdx,%rsi
  803c05:	89 c7                	mov    %eax,%edi
  803c07:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  803c0e:	00 00 00 
  803c11:	ff d0                	callq  *%rax
  803c13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c1a:	79 05                	jns    803c21 <pipeisclosed+0x31>
		return r;
  803c1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c1f:	eb 31                	jmp    803c52 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803c21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c25:	48 89 c7             	mov    %rax,%rdi
  803c28:	48 b8 0f 1e 80 00 00 	movabs $0x801e0f,%rax
  803c2f:	00 00 00 
  803c32:	ff d0                	callq  *%rax
  803c34:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803c38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c3c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c40:	48 89 d6             	mov    %rdx,%rsi
  803c43:	48 89 c7             	mov    %rax,%rdi
  803c46:	48 b8 1d 3b 80 00 00 	movabs $0x803b1d,%rax
  803c4d:	00 00 00 
  803c50:	ff d0                	callq  *%rax
}
  803c52:	c9                   	leaveq 
  803c53:	c3                   	retq   

0000000000803c54 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c54:	55                   	push   %rbp
  803c55:	48 89 e5             	mov    %rsp,%rbp
  803c58:	48 83 ec 40          	sub    $0x40,%rsp
  803c5c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c60:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c64:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803c68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c6c:	48 89 c7             	mov    %rax,%rdi
  803c6f:	48 b8 0f 1e 80 00 00 	movabs $0x801e0f,%rax
  803c76:	00 00 00 
  803c79:	ff d0                	callq  *%rax
  803c7b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803c7f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c83:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803c87:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803c8e:	00 
  803c8f:	e9 92 00 00 00       	jmpq   803d26 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803c94:	eb 41                	jmp    803cd7 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803c96:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803c9b:	74 09                	je     803ca6 <devpipe_read+0x52>
				return i;
  803c9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ca1:	e9 92 00 00 00       	jmpq   803d38 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803ca6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803caa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cae:	48 89 d6             	mov    %rdx,%rsi
  803cb1:	48 89 c7             	mov    %rax,%rdi
  803cb4:	48 b8 1d 3b 80 00 00 	movabs $0x803b1d,%rax
  803cbb:	00 00 00 
  803cbe:	ff d0                	callq  *%rax
  803cc0:	85 c0                	test   %eax,%eax
  803cc2:	74 07                	je     803ccb <devpipe_read+0x77>
				return 0;
  803cc4:	b8 00 00 00 00       	mov    $0x0,%eax
  803cc9:	eb 6d                	jmp    803d38 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803ccb:	48 b8 ce 19 80 00 00 	movabs $0x8019ce,%rax
  803cd2:	00 00 00 
  803cd5:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803cd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cdb:	8b 10                	mov    (%rax),%edx
  803cdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce1:	8b 40 04             	mov    0x4(%rax),%eax
  803ce4:	39 c2                	cmp    %eax,%edx
  803ce6:	74 ae                	je     803c96 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803ce8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803cf0:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803cf4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf8:	8b 00                	mov    (%rax),%eax
  803cfa:	99                   	cltd   
  803cfb:	c1 ea 1b             	shr    $0x1b,%edx
  803cfe:	01 d0                	add    %edx,%eax
  803d00:	83 e0 1f             	and    $0x1f,%eax
  803d03:	29 d0                	sub    %edx,%eax
  803d05:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d09:	48 98                	cltq   
  803d0b:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803d10:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803d12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d16:	8b 00                	mov    (%rax),%eax
  803d18:	8d 50 01             	lea    0x1(%rax),%edx
  803d1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d1f:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803d21:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803d26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d2a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803d2e:	0f 82 60 ff ff ff    	jb     803c94 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803d34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803d38:	c9                   	leaveq 
  803d39:	c3                   	retq   

0000000000803d3a <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d3a:	55                   	push   %rbp
  803d3b:	48 89 e5             	mov    %rsp,%rbp
  803d3e:	48 83 ec 40          	sub    $0x40,%rsp
  803d42:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d46:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d4a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803d4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d52:	48 89 c7             	mov    %rax,%rdi
  803d55:	48 b8 0f 1e 80 00 00 	movabs $0x801e0f,%rax
  803d5c:	00 00 00 
  803d5f:	ff d0                	callq  *%rax
  803d61:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d65:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d69:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d6d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d74:	00 
  803d75:	e9 8e 00 00 00       	jmpq   803e08 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803d7a:	eb 31                	jmp    803dad <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803d7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d84:	48 89 d6             	mov    %rdx,%rsi
  803d87:	48 89 c7             	mov    %rax,%rdi
  803d8a:	48 b8 1d 3b 80 00 00 	movabs $0x803b1d,%rax
  803d91:	00 00 00 
  803d94:	ff d0                	callq  *%rax
  803d96:	85 c0                	test   %eax,%eax
  803d98:	74 07                	je     803da1 <devpipe_write+0x67>
				return 0;
  803d9a:	b8 00 00 00 00       	mov    $0x0,%eax
  803d9f:	eb 79                	jmp    803e1a <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803da1:	48 b8 ce 19 80 00 00 	movabs $0x8019ce,%rax
  803da8:	00 00 00 
  803dab:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803dad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803db1:	8b 40 04             	mov    0x4(%rax),%eax
  803db4:	48 63 d0             	movslq %eax,%rdx
  803db7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dbb:	8b 00                	mov    (%rax),%eax
  803dbd:	48 98                	cltq   
  803dbf:	48 83 c0 20          	add    $0x20,%rax
  803dc3:	48 39 c2             	cmp    %rax,%rdx
  803dc6:	73 b4                	jae    803d7c <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803dc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dcc:	8b 40 04             	mov    0x4(%rax),%eax
  803dcf:	99                   	cltd   
  803dd0:	c1 ea 1b             	shr    $0x1b,%edx
  803dd3:	01 d0                	add    %edx,%eax
  803dd5:	83 e0 1f             	and    $0x1f,%eax
  803dd8:	29 d0                	sub    %edx,%eax
  803dda:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803dde:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803de2:	48 01 ca             	add    %rcx,%rdx
  803de5:	0f b6 0a             	movzbl (%rdx),%ecx
  803de8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803dec:	48 98                	cltq   
  803dee:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803df2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803df6:	8b 40 04             	mov    0x4(%rax),%eax
  803df9:	8d 50 01             	lea    0x1(%rax),%edx
  803dfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e00:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e03:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e0c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e10:	0f 82 64 ff ff ff    	jb     803d7a <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803e16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803e1a:	c9                   	leaveq 
  803e1b:	c3                   	retq   

0000000000803e1c <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803e1c:	55                   	push   %rbp
  803e1d:	48 89 e5             	mov    %rsp,%rbp
  803e20:	48 83 ec 20          	sub    $0x20,%rsp
  803e24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e28:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803e2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e30:	48 89 c7             	mov    %rax,%rdi
  803e33:	48 b8 0f 1e 80 00 00 	movabs $0x801e0f,%rax
  803e3a:	00 00 00 
  803e3d:	ff d0                	callq  *%rax
  803e3f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803e43:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e47:	48 be 88 4c 80 00 00 	movabs $0x804c88,%rsi
  803e4e:	00 00 00 
  803e51:	48 89 c7             	mov    %rax,%rdi
  803e54:	48 b8 dd 10 80 00 00 	movabs $0x8010dd,%rax
  803e5b:	00 00 00 
  803e5e:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803e60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e64:	8b 50 04             	mov    0x4(%rax),%edx
  803e67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e6b:	8b 00                	mov    (%rax),%eax
  803e6d:	29 c2                	sub    %eax,%edx
  803e6f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e73:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803e79:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e7d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803e84:	00 00 00 
	stat->st_dev = &devpipe;
  803e87:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e8b:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803e92:	00 00 00 
  803e95:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803e9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ea1:	c9                   	leaveq 
  803ea2:	c3                   	retq   

0000000000803ea3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803ea3:	55                   	push   %rbp
  803ea4:	48 89 e5             	mov    %rsp,%rbp
  803ea7:	48 83 ec 10          	sub    $0x10,%rsp
  803eab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  803eaf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803eb3:	48 89 c6             	mov    %rax,%rsi
  803eb6:	bf 00 00 00 00       	mov    $0x0,%edi
  803ebb:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  803ec2:	00 00 00 
  803ec5:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  803ec7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ecb:	48 89 c7             	mov    %rax,%rdi
  803ece:	48 b8 0f 1e 80 00 00 	movabs $0x801e0f,%rax
  803ed5:	00 00 00 
  803ed8:	ff d0                	callq  *%rax
  803eda:	48 89 c6             	mov    %rax,%rsi
  803edd:	bf 00 00 00 00       	mov    $0x0,%edi
  803ee2:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  803ee9:	00 00 00 
  803eec:	ff d0                	callq  *%rax
}
  803eee:	c9                   	leaveq 
  803eef:	c3                   	retq   

0000000000803ef0 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803ef0:	55                   	push   %rbp
  803ef1:	48 89 e5             	mov    %rsp,%rbp
  803ef4:	48 83 ec 20          	sub    $0x20,%rsp
  803ef8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803efb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803efe:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803f01:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803f05:	be 01 00 00 00       	mov    $0x1,%esi
  803f0a:	48 89 c7             	mov    %rax,%rdi
  803f0d:	48 b8 c4 18 80 00 00 	movabs $0x8018c4,%rax
  803f14:	00 00 00 
  803f17:	ff d0                	callq  *%rax
}
  803f19:	c9                   	leaveq 
  803f1a:	c3                   	retq   

0000000000803f1b <getchar>:

int
getchar(void)
{
  803f1b:	55                   	push   %rbp
  803f1c:	48 89 e5             	mov    %rsp,%rbp
  803f1f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803f23:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803f27:	ba 01 00 00 00       	mov    $0x1,%edx
  803f2c:	48 89 c6             	mov    %rax,%rsi
  803f2f:	bf 00 00 00 00       	mov    $0x0,%edi
  803f34:	48 b8 04 23 80 00 00 	movabs $0x802304,%rax
  803f3b:	00 00 00 
  803f3e:	ff d0                	callq  *%rax
  803f40:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803f43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f47:	79 05                	jns    803f4e <getchar+0x33>
		return r;
  803f49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f4c:	eb 14                	jmp    803f62 <getchar+0x47>
	if (r < 1)
  803f4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f52:	7f 07                	jg     803f5b <getchar+0x40>
		return -E_EOF;
  803f54:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803f59:	eb 07                	jmp    803f62 <getchar+0x47>
	return c;
  803f5b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803f5f:	0f b6 c0             	movzbl %al,%eax

}
  803f62:	c9                   	leaveq 
  803f63:	c3                   	retq   

0000000000803f64 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803f64:	55                   	push   %rbp
  803f65:	48 89 e5             	mov    %rsp,%rbp
  803f68:	48 83 ec 20          	sub    $0x20,%rsp
  803f6c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f6f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803f73:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f76:	48 89 d6             	mov    %rdx,%rsi
  803f79:	89 c7                	mov    %eax,%edi
  803f7b:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  803f82:	00 00 00 
  803f85:	ff d0                	callq  *%rax
  803f87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f8e:	79 05                	jns    803f95 <iscons+0x31>
		return r;
  803f90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f93:	eb 1a                	jmp    803faf <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803f95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f99:	8b 10                	mov    (%rax),%edx
  803f9b:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803fa2:	00 00 00 
  803fa5:	8b 00                	mov    (%rax),%eax
  803fa7:	39 c2                	cmp    %eax,%edx
  803fa9:	0f 94 c0             	sete   %al
  803fac:	0f b6 c0             	movzbl %al,%eax
}
  803faf:	c9                   	leaveq 
  803fb0:	c3                   	retq   

0000000000803fb1 <opencons>:

int
opencons(void)
{
  803fb1:	55                   	push   %rbp
  803fb2:	48 89 e5             	mov    %rsp,%rbp
  803fb5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803fb9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803fbd:	48 89 c7             	mov    %rax,%rdi
  803fc0:	48 b8 3a 1e 80 00 00 	movabs $0x801e3a,%rax
  803fc7:	00 00 00 
  803fca:	ff d0                	callq  *%rax
  803fcc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fcf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fd3:	79 05                	jns    803fda <opencons+0x29>
		return r;
  803fd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fd8:	eb 5b                	jmp    804035 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803fda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fde:	ba 07 04 00 00       	mov    $0x407,%edx
  803fe3:	48 89 c6             	mov    %rax,%rsi
  803fe6:	bf 00 00 00 00       	mov    $0x0,%edi
  803feb:	48 b8 0c 1a 80 00 00 	movabs $0x801a0c,%rax
  803ff2:	00 00 00 
  803ff5:	ff d0                	callq  *%rax
  803ff7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ffa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ffe:	79 05                	jns    804005 <opencons+0x54>
		return r;
  804000:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804003:	eb 30                	jmp    804035 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804005:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804009:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  804010:	00 00 00 
  804013:	8b 12                	mov    (%rdx),%edx
  804015:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804017:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80401b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804022:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804026:	48 89 c7             	mov    %rax,%rdi
  804029:	48 b8 ec 1d 80 00 00 	movabs $0x801dec,%rax
  804030:	00 00 00 
  804033:	ff d0                	callq  *%rax
}
  804035:	c9                   	leaveq 
  804036:	c3                   	retq   

0000000000804037 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804037:	55                   	push   %rbp
  804038:	48 89 e5             	mov    %rsp,%rbp
  80403b:	48 83 ec 30          	sub    $0x30,%rsp
  80403f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804043:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804047:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80404b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804050:	75 07                	jne    804059 <devcons_read+0x22>
		return 0;
  804052:	b8 00 00 00 00       	mov    $0x0,%eax
  804057:	eb 4b                	jmp    8040a4 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804059:	eb 0c                	jmp    804067 <devcons_read+0x30>
		sys_yield();
  80405b:	48 b8 ce 19 80 00 00 	movabs $0x8019ce,%rax
  804062:	00 00 00 
  804065:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804067:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  80406e:	00 00 00 
  804071:	ff d0                	callq  *%rax
  804073:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804076:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80407a:	74 df                	je     80405b <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80407c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804080:	79 05                	jns    804087 <devcons_read+0x50>
		return c;
  804082:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804085:	eb 1d                	jmp    8040a4 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804087:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80408b:	75 07                	jne    804094 <devcons_read+0x5d>
		return 0;
  80408d:	b8 00 00 00 00       	mov    $0x0,%eax
  804092:	eb 10                	jmp    8040a4 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804094:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804097:	89 c2                	mov    %eax,%edx
  804099:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80409d:	88 10                	mov    %dl,(%rax)
	return 1;
  80409f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8040a4:	c9                   	leaveq 
  8040a5:	c3                   	retq   

00000000008040a6 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8040a6:	55                   	push   %rbp
  8040a7:	48 89 e5             	mov    %rsp,%rbp
  8040aa:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8040b1:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8040b8:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8040bf:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8040c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8040cd:	eb 76                	jmp    804145 <devcons_write+0x9f>
		m = n - tot;
  8040cf:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8040d6:	89 c2                	mov    %eax,%edx
  8040d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040db:	29 c2                	sub    %eax,%edx
  8040dd:	89 d0                	mov    %edx,%eax
  8040df:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8040e2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040e5:	83 f8 7f             	cmp    $0x7f,%eax
  8040e8:	76 07                	jbe    8040f1 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8040ea:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8040f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040f4:	48 63 d0             	movslq %eax,%rdx
  8040f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040fa:	48 63 c8             	movslq %eax,%rcx
  8040fd:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804104:	48 01 c1             	add    %rax,%rcx
  804107:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80410e:	48 89 ce             	mov    %rcx,%rsi
  804111:	48 89 c7             	mov    %rax,%rdi
  804114:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  80411b:	00 00 00 
  80411e:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804120:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804123:	48 63 d0             	movslq %eax,%rdx
  804126:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80412d:	48 89 d6             	mov    %rdx,%rsi
  804130:	48 89 c7             	mov    %rax,%rdi
  804133:	48 b8 c4 18 80 00 00 	movabs $0x8018c4,%rax
  80413a:	00 00 00 
  80413d:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80413f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804142:	01 45 fc             	add    %eax,-0x4(%rbp)
  804145:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804148:	48 98                	cltq   
  80414a:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804151:	0f 82 78 ff ff ff    	jb     8040cf <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804157:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80415a:	c9                   	leaveq 
  80415b:	c3                   	retq   

000000000080415c <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80415c:	55                   	push   %rbp
  80415d:	48 89 e5             	mov    %rsp,%rbp
  804160:	48 83 ec 08          	sub    $0x8,%rsp
  804164:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804168:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80416d:	c9                   	leaveq 
  80416e:	c3                   	retq   

000000000080416f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80416f:	55                   	push   %rbp
  804170:	48 89 e5             	mov    %rsp,%rbp
  804173:	48 83 ec 10          	sub    $0x10,%rsp
  804177:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80417b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80417f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804183:	48 be 94 4c 80 00 00 	movabs $0x804c94,%rsi
  80418a:	00 00 00 
  80418d:	48 89 c7             	mov    %rax,%rdi
  804190:	48 b8 dd 10 80 00 00 	movabs $0x8010dd,%rax
  804197:	00 00 00 
  80419a:	ff d0                	callq  *%rax
	return 0;
  80419c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041a1:	c9                   	leaveq 
  8041a2:	c3                   	retq   

00000000008041a3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8041a3:	55                   	push   %rbp
  8041a4:	48 89 e5             	mov    %rsp,%rbp
  8041a7:	48 83 ec 30          	sub    $0x30,%rsp
  8041ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8041b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  8041b7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8041bc:	75 0e                	jne    8041cc <ipc_recv+0x29>
		pg = (void*) UTOP;
  8041be:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8041c5:	00 00 00 
  8041c8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  8041cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041d0:	48 89 c7             	mov    %rax,%rdi
  8041d3:	48 b8 35 1c 80 00 00 	movabs $0x801c35,%rax
  8041da:	00 00 00 
  8041dd:	ff d0                	callq  *%rax
  8041df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041e6:	79 27                	jns    80420f <ipc_recv+0x6c>
		if (from_env_store)
  8041e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8041ed:	74 0a                	je     8041f9 <ipc_recv+0x56>
			*from_env_store = 0;
  8041ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041f3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8041f9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8041fe:	74 0a                	je     80420a <ipc_recv+0x67>
			*perm_store = 0;
  804200:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804204:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  80420a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80420d:	eb 53                	jmp    804262 <ipc_recv+0xbf>
	}
	if (from_env_store)
  80420f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804214:	74 19                	je     80422f <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  804216:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80421d:	00 00 00 
  804220:	48 8b 00             	mov    (%rax),%rax
  804223:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804229:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80422d:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  80422f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804234:	74 19                	je     80424f <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  804236:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80423d:	00 00 00 
  804240:	48 8b 00             	mov    (%rax),%rax
  804243:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804249:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80424d:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  80424f:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  804256:	00 00 00 
  804259:	48 8b 00             	mov    (%rax),%rax
  80425c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804262:	c9                   	leaveq 
  804263:	c3                   	retq   

0000000000804264 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804264:	55                   	push   %rbp
  804265:	48 89 e5             	mov    %rsp,%rbp
  804268:	48 83 ec 30          	sub    $0x30,%rsp
  80426c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80426f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804272:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804276:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804279:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80427e:	75 10                	jne    804290 <ipc_send+0x2c>
		pg = (void*) UTOP;
  804280:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804287:	00 00 00 
  80428a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80428e:	eb 0e                	jmp    80429e <ipc_send+0x3a>
  804290:	eb 0c                	jmp    80429e <ipc_send+0x3a>
		sys_yield();
  804292:	48 b8 ce 19 80 00 00 	movabs $0x8019ce,%rax
  804299:	00 00 00 
  80429c:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80429e:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8042a1:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8042a4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8042a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042ab:	89 c7                	mov    %eax,%edi
  8042ad:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  8042b4:	00 00 00 
  8042b7:	ff d0                	callq  *%rax
  8042b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042bc:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8042c0:	74 d0                	je     804292 <ipc_send+0x2e>
		sys_yield();
	}
	if (r < 0)
  8042c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042c6:	79 30                	jns    8042f8 <ipc_send+0x94>
		panic("error in ipc_send: %e", r);
  8042c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042cb:	89 c1                	mov    %eax,%ecx
  8042cd:	48 ba 9b 4c 80 00 00 	movabs $0x804c9b,%rdx
  8042d4:	00 00 00 
  8042d7:	be 47 00 00 00       	mov    $0x47,%esi
  8042dc:	48 bf b1 4c 80 00 00 	movabs $0x804cb1,%rdi
  8042e3:	00 00 00 
  8042e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8042eb:	49 b8 ef 02 80 00 00 	movabs $0x8002ef,%r8
  8042f2:	00 00 00 
  8042f5:	41 ff d0             	callq  *%r8

}
  8042f8:	c9                   	leaveq 
  8042f9:	c3                   	retq   

00000000008042fa <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8042fa:	55                   	push   %rbp
  8042fb:	48 89 e5             	mov    %rsp,%rbp
  8042fe:	53                   	push   %rbx
  8042ff:	48 83 ec 28          	sub    $0x28,%rsp
  804303:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  804307:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  80430e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  804315:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80431a:	75 0e                	jne    80432a <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  80431c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804323:	00 00 00 
  804326:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  80432a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80432e:	ba 07 00 00 00       	mov    $0x7,%edx
  804333:	48 89 c6             	mov    %rax,%rsi
  804336:	bf 00 00 00 00       	mov    $0x0,%edi
  80433b:	48 b8 0c 1a 80 00 00 	movabs $0x801a0c,%rax
  804342:	00 00 00 
  804345:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804347:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80434b:	48 c1 e8 0c          	shr    $0xc,%rax
  80434f:	48 89 c2             	mov    %rax,%rdx
  804352:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804359:	01 00 00 
  80435c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804360:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804366:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  80436a:	b8 03 00 00 00       	mov    $0x3,%eax
  80436f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804373:	48 89 d3             	mov    %rdx,%rbx
  804376:	0f 01 c1             	vmcall 
  804379:	89 f2                	mov    %esi,%edx
  80437b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80437e:	89 55 e8             	mov    %edx,-0x18(%rbp)
	/* cprintf("Returned IPC response from host: %d %d\n", r, -val);*/
	if (r < 0) {
  804381:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804385:	79 05                	jns    80438c <ipc_host_recv+0x92>
		return r;
  804387:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80438a:	eb 03                	jmp    80438f <ipc_host_recv+0x95>
	}
	return val;
  80438c:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  80438f:	48 83 c4 28          	add    $0x28,%rsp
  804393:	5b                   	pop    %rbx
  804394:	5d                   	pop    %rbp
  804395:	c3                   	retq   

0000000000804396 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804396:	55                   	push   %rbp
  804397:	48 89 e5             	mov    %rsp,%rbp
  80439a:	53                   	push   %rbx
  80439b:	48 83 ec 38          	sub    $0x38,%rsp
  80439f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8043a2:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8043a5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8043a9:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  8043ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  8043b3:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8043b8:	75 0e                	jne    8043c8 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  8043ba:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8043c1:	00 00 00 
  8043c4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8043c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043cc:	48 c1 e8 0c          	shr    $0xc,%rax
  8043d0:	48 89 c2             	mov    %rax,%rdx
  8043d3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8043da:	01 00 00 
  8043dd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8043e1:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8043e7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8043eb:	b8 02 00 00 00       	mov    $0x2,%eax
  8043f0:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8043f3:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8043f6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8043fa:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8043fd:	89 fb                	mov    %edi,%ebx
  8043ff:	0f 01 c1             	vmcall 
  804402:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804405:	eb 26                	jmp    80442d <ipc_host_send+0x97>
		sys_yield();
  804407:	48 b8 ce 19 80 00 00 	movabs $0x8019ce,%rax
  80440e:	00 00 00 
  804411:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  804413:	b8 02 00 00 00       	mov    $0x2,%eax
  804418:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80441b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80441e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804422:	8b 75 cc             	mov    -0x34(%rbp),%esi
  804425:	89 fb                	mov    %edi,%ebx
  804427:	0f 01 c1             	vmcall 
  80442a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  80442d:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  804431:	74 d4                	je     804407 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  804433:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804437:	79 30                	jns    804469 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  804439:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80443c:	89 c1                	mov    %eax,%ecx
  80443e:	48 ba 9b 4c 80 00 00 	movabs $0x804c9b,%rdx
  804445:	00 00 00 
  804448:	be 79 00 00 00       	mov    $0x79,%esi
  80444d:	48 bf b1 4c 80 00 00 	movabs $0x804cb1,%rdi
  804454:	00 00 00 
  804457:	b8 00 00 00 00       	mov    $0x0,%eax
  80445c:	49 b8 ef 02 80 00 00 	movabs $0x8002ef,%r8
  804463:	00 00 00 
  804466:	41 ff d0             	callq  *%r8

}
  804469:	48 83 c4 38          	add    $0x38,%rsp
  80446d:	5b                   	pop    %rbx
  80446e:	5d                   	pop    %rbp
  80446f:	c3                   	retq   

0000000000804470 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804470:	55                   	push   %rbp
  804471:	48 89 e5             	mov    %rsp,%rbp
  804474:	48 83 ec 14          	sub    $0x14,%rsp
  804478:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80447b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804482:	eb 4e                	jmp    8044d2 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804484:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80448b:	00 00 00 
  80448e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804491:	48 98                	cltq   
  804493:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80449a:	48 01 d0             	add    %rdx,%rax
  80449d:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8044a3:	8b 00                	mov    (%rax),%eax
  8044a5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8044a8:	75 24                	jne    8044ce <ipc_find_env+0x5e>
			return envs[i].env_id;
  8044aa:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8044b1:	00 00 00 
  8044b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044b7:	48 98                	cltq   
  8044b9:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8044c0:	48 01 d0             	add    %rdx,%rax
  8044c3:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8044c9:	8b 40 08             	mov    0x8(%rax),%eax
  8044cc:	eb 12                	jmp    8044e0 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8044ce:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8044d2:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8044d9:	7e a9                	jle    804484 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8044db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044e0:	c9                   	leaveq 
  8044e1:	c3                   	retq   

00000000008044e2 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  8044e2:	55                   	push   %rbp
  8044e3:	48 89 e5             	mov    %rsp,%rbp
  8044e6:	48 83 ec 18          	sub    $0x18,%rsp
  8044ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8044ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044f2:	48 c1 e8 15          	shr    $0x15,%rax
  8044f6:	48 89 c2             	mov    %rax,%rdx
  8044f9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804500:	01 00 00 
  804503:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804507:	83 e0 01             	and    $0x1,%eax
  80450a:	48 85 c0             	test   %rax,%rax
  80450d:	75 07                	jne    804516 <pageref+0x34>
		return 0;
  80450f:	b8 00 00 00 00       	mov    $0x0,%eax
  804514:	eb 53                	jmp    804569 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804516:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80451a:	48 c1 e8 0c          	shr    $0xc,%rax
  80451e:	48 89 c2             	mov    %rax,%rdx
  804521:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804528:	01 00 00 
  80452b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80452f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804533:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804537:	83 e0 01             	and    $0x1,%eax
  80453a:	48 85 c0             	test   %rax,%rax
  80453d:	75 07                	jne    804546 <pageref+0x64>
		return 0;
  80453f:	b8 00 00 00 00       	mov    $0x0,%eax
  804544:	eb 23                	jmp    804569 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804546:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80454a:	48 c1 e8 0c          	shr    $0xc,%rax
  80454e:	48 89 c2             	mov    %rax,%rdx
  804551:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804558:	00 00 00 
  80455b:	48 c1 e2 04          	shl    $0x4,%rdx
  80455f:	48 01 d0             	add    %rdx,%rax
  804562:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804566:	0f b7 c0             	movzwl %ax,%eax
}
  804569:	c9                   	leaveq 
  80456a:	c3                   	retq   
