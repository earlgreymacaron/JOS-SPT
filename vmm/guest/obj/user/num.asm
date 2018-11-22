
vmm/guest/obj/user/num:     file format elf64-x86-64


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
  80003c:	e8 97 02 00 00       	callq  8002d8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800052:	e9 da 00 00 00       	jmpq   800131 <num+0xee>
		if (bol) {
  800057:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80005e:	00 00 00 
  800061:	8b 00                	mov    (%rax),%eax
  800063:	85 c0                	test   %eax,%eax
  800065:	74 54                	je     8000bb <num+0x78>
			printf("%5d ", ++line);
  800067:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80006e:	00 00 00 
  800071:	8b 00                	mov    (%rax),%eax
  800073:	8d 50 01             	lea    0x1(%rax),%edx
  800076:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80007d:	00 00 00 
  800080:	89 10                	mov    %edx,(%rax)
  800082:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800089:	00 00 00 
  80008c:	8b 00                	mov    (%rax),%eax
  80008e:	89 c6                	mov    %eax,%esi
  800090:	48 bf 00 46 80 00 00 	movabs $0x804600,%rdi
  800097:	00 00 00 
  80009a:	b8 00 00 00 00       	mov    $0x0,%eax
  80009f:	48 ba f4 30 80 00 00 	movabs $0x8030f4,%rdx
  8000a6:	00 00 00 
  8000a9:	ff d2                	callq  *%rdx
			bol = 0;
  8000ab:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000b2:	00 00 00 
  8000b5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		if ((r = write(1, &c, 1)) != 1)
  8000bb:	48 8d 45 f3          	lea    -0xd(%rbp),%rax
  8000bf:	ba 01 00 00 00       	mov    $0x1,%edx
  8000c4:	48 89 c6             	mov    %rax,%rsi
  8000c7:	bf 01 00 00 00       	mov    $0x1,%edi
  8000cc:	48 b8 dd 24 80 00 00 	movabs $0x8024dd,%rax
  8000d3:	00 00 00 
  8000d6:	ff d0                	callq  *%rax
  8000d8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000db:	83 7d f4 01          	cmpl   $0x1,-0xc(%rbp)
  8000df:	74 38                	je     800119 <num+0xd6>
			panic("write error copying %s: %e", s, r);
  8000e1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8000e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000e8:	41 89 d0             	mov    %edx,%r8d
  8000eb:	48 89 c1             	mov    %rax,%rcx
  8000ee:	48 ba 05 46 80 00 00 	movabs $0x804605,%rdx
  8000f5:	00 00 00 
  8000f8:	be 14 00 00 00       	mov    $0x14,%esi
  8000fd:	48 bf 20 46 80 00 00 	movabs $0x804620,%rdi
  800104:	00 00 00 
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	49 b9 7e 03 80 00 00 	movabs $0x80037e,%r9
  800113:	00 00 00 
  800116:	41 ff d1             	callq  *%r9
		if (c == '\n')
  800119:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  80011d:	3c 0a                	cmp    $0xa,%al
  80011f:	75 10                	jne    800131 <num+0xee>
			bol = 1;
  800121:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800128:	00 00 00 
  80012b:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800131:	48 8d 4d f3          	lea    -0xd(%rbp),%rcx
  800135:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800138:	ba 01 00 00 00       	mov    $0x1,%edx
  80013d:	48 89 ce             	mov    %rcx,%rsi
  800140:	89 c7                	mov    %eax,%edi
  800142:	48 b8 93 23 80 00 00 	movabs $0x802393,%rax
  800149:	00 00 00 
  80014c:	ff d0                	callq  *%rax
  80014e:	48 98                	cltq   
  800150:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800154:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800159:	0f 8f f8 fe ff ff    	jg     800057 <num+0x14>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  80015f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800164:	79 39                	jns    80019f <num+0x15c>
		panic("error reading %s: %e", s, n);
  800166:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80016a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80016e:	49 89 d0             	mov    %rdx,%r8
  800171:	48 89 c1             	mov    %rax,%rcx
  800174:	48 ba 2b 46 80 00 00 	movabs $0x80462b,%rdx
  80017b:	00 00 00 
  80017e:	be 19 00 00 00       	mov    $0x19,%esi
  800183:	48 bf 20 46 80 00 00 	movabs $0x804620,%rdi
  80018a:	00 00 00 
  80018d:	b8 00 00 00 00       	mov    $0x0,%eax
  800192:	49 b9 7e 03 80 00 00 	movabs $0x80037e,%r9
  800199:	00 00 00 
  80019c:	41 ff d1             	callq  *%r9
}
  80019f:	c9                   	leaveq 
  8001a0:	c3                   	retq   

00000000008001a1 <umain>:

void
umain(int argc, char **argv)
{
  8001a1:	55                   	push   %rbp
  8001a2:	48 89 e5             	mov    %rsp,%rbp
  8001a5:	53                   	push   %rbx
  8001a6:	48 83 ec 28          	sub    $0x28,%rsp
  8001aa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8001ad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int f, i;

	binaryname = "num";
  8001b1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8001b8:	00 00 00 
  8001bb:	48 bb 40 46 80 00 00 	movabs $0x804640,%rbx
  8001c2:	00 00 00 
  8001c5:	48 89 18             	mov    %rbx,(%rax)
	if (argc == 1)
  8001c8:	83 7d dc 01          	cmpl   $0x1,-0x24(%rbp)
  8001cc:	75 20                	jne    8001ee <umain+0x4d>
		num(0, "<stdin>");
  8001ce:	48 be 44 46 80 00 00 	movabs $0x804644,%rsi
  8001d5:	00 00 00 
  8001d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001dd:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001e4:	00 00 00 
  8001e7:	ff d0                	callq  *%rax
  8001e9:	e9 d7 00 00 00       	jmpq   8002c5 <umain+0x124>
	else
		for (i = 1; i < argc; i++) {
  8001ee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
  8001f5:	e9 bf 00 00 00       	jmpq   8002b9 <umain+0x118>
			f = open(argv[i], O_RDONLY);
  8001fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001fd:	48 98                	cltq   
  8001ff:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800206:	00 
  800207:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80020b:	48 01 d0             	add    %rdx,%rax
  80020e:	48 8b 00             	mov    (%rax),%rax
  800211:	be 00 00 00 00       	mov    $0x0,%esi
  800216:	48 89 c7             	mov    %rax,%rdi
  800219:	48 b8 69 28 80 00 00 	movabs $0x802869,%rax
  800220:	00 00 00 
  800223:	ff d0                	callq  *%rax
  800225:	89 45 e8             	mov    %eax,-0x18(%rbp)
			if (f < 0)
  800228:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80022c:	79 4b                	jns    800279 <umain+0xd8>
				panic("can't open %s: %e", argv[i], f);
  80022e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800231:	48 98                	cltq   
  800233:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80023a:	00 
  80023b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80023f:	48 01 d0             	add    %rdx,%rax
  800242:	48 8b 00             	mov    (%rax),%rax
  800245:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800248:	41 89 d0             	mov    %edx,%r8d
  80024b:	48 89 c1             	mov    %rax,%rcx
  80024e:	48 ba 4c 46 80 00 00 	movabs $0x80464c,%rdx
  800255:	00 00 00 
  800258:	be 28 00 00 00       	mov    $0x28,%esi
  80025d:	48 bf 20 46 80 00 00 	movabs $0x804620,%rdi
  800264:	00 00 00 
  800267:	b8 00 00 00 00       	mov    $0x0,%eax
  80026c:	49 b9 7e 03 80 00 00 	movabs $0x80037e,%r9
  800273:	00 00 00 
  800276:	41 ff d1             	callq  *%r9
			else {
				num(f, argv[i]);
  800279:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027c:	48 98                	cltq   
  80027e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800285:	00 
  800286:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80028a:	48 01 d0             	add    %rdx,%rax
  80028d:	48 8b 10             	mov    (%rax),%rdx
  800290:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800293:	48 89 d6             	mov    %rdx,%rsi
  800296:	89 c7                	mov    %eax,%edi
  800298:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80029f:	00 00 00 
  8002a2:	ff d0                	callq  *%rax
				close(f);
  8002a4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002a7:	89 c7                	mov    %eax,%edi
  8002a9:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  8002b0:	00 00 00 
  8002b3:	ff d0                	callq  *%rax

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8002b5:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8002b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002bc:	3b 45 dc             	cmp    -0x24(%rbp),%eax
  8002bf:	0f 8c 35 ff ff ff    	jl     8001fa <umain+0x59>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8002c5:	48 b8 5b 03 80 00 00 	movabs $0x80035b,%rax
  8002cc:	00 00 00 
  8002cf:	ff d0                	callq  *%rax
}
  8002d1:	48 83 c4 28          	add    $0x28,%rsp
  8002d5:	5b                   	pop    %rbx
  8002d6:	5d                   	pop    %rbp
  8002d7:	c3                   	retq   

00000000008002d8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d8:	55                   	push   %rbp
  8002d9:	48 89 e5             	mov    %rsp,%rbp
  8002dc:	48 83 ec 10          	sub    $0x10,%rsp
  8002e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  8002e7:	48 b8 1f 1a 80 00 00 	movabs $0x801a1f,%rax
  8002ee:	00 00 00 
  8002f1:	ff d0                	callq  *%rax
  8002f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002f8:	48 98                	cltq   
  8002fa:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800301:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800308:	00 00 00 
  80030b:	48 01 c2             	add    %rax,%rdx
  80030e:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800315:	00 00 00 
  800318:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80031b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80031f:	7e 14                	jle    800335 <libmain+0x5d>
		binaryname = argv[0];
  800321:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800325:	48 8b 10             	mov    (%rax),%rdx
  800328:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80032f:	00 00 00 
  800332:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800335:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800339:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80033c:	48 89 d6             	mov    %rdx,%rsi
  80033f:	89 c7                	mov    %eax,%edi
  800341:	48 b8 a1 01 80 00 00 	movabs $0x8001a1,%rax
  800348:	00 00 00 
  80034b:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80034d:	48 b8 5b 03 80 00 00 	movabs $0x80035b,%rax
  800354:	00 00 00 
  800357:	ff d0                	callq  *%rax
}
  800359:	c9                   	leaveq 
  80035a:	c3                   	retq   

000000000080035b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80035b:	55                   	push   %rbp
  80035c:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  80035f:	48 b8 bc 21 80 00 00 	movabs $0x8021bc,%rax
  800366:	00 00 00 
  800369:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  80036b:	bf 00 00 00 00       	mov    $0x0,%edi
  800370:	48 b8 db 19 80 00 00 	movabs $0x8019db,%rax
  800377:	00 00 00 
  80037a:	ff d0                	callq  *%rax
}
  80037c:	5d                   	pop    %rbp
  80037d:	c3                   	retq   

000000000080037e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80037e:	55                   	push   %rbp
  80037f:	48 89 e5             	mov    %rsp,%rbp
  800382:	53                   	push   %rbx
  800383:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80038a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800391:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800397:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80039e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8003a5:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8003ac:	84 c0                	test   %al,%al
  8003ae:	74 23                	je     8003d3 <_panic+0x55>
  8003b0:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8003b7:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8003bb:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8003bf:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8003c3:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8003c7:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8003cb:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8003cf:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003d3:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003da:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003e1:	00 00 00 
  8003e4:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003eb:	00 00 00 
  8003ee:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003f2:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8003f9:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800400:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800407:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80040e:	00 00 00 
  800411:	48 8b 18             	mov    (%rax),%rbx
  800414:	48 b8 1f 1a 80 00 00 	movabs $0x801a1f,%rax
  80041b:	00 00 00 
  80041e:	ff d0                	callq  *%rax
  800420:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800426:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80042d:	41 89 c8             	mov    %ecx,%r8d
  800430:	48 89 d1             	mov    %rdx,%rcx
  800433:	48 89 da             	mov    %rbx,%rdx
  800436:	89 c6                	mov    %eax,%esi
  800438:	48 bf 68 46 80 00 00 	movabs $0x804668,%rdi
  80043f:	00 00 00 
  800442:	b8 00 00 00 00       	mov    $0x0,%eax
  800447:	49 b9 b7 05 80 00 00 	movabs $0x8005b7,%r9
  80044e:	00 00 00 
  800451:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800454:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80045b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800462:	48 89 d6             	mov    %rdx,%rsi
  800465:	48 89 c7             	mov    %rax,%rdi
  800468:	48 b8 0b 05 80 00 00 	movabs $0x80050b,%rax
  80046f:	00 00 00 
  800472:	ff d0                	callq  *%rax
	cprintf("\n");
  800474:	48 bf 8b 46 80 00 00 	movabs $0x80468b,%rdi
  80047b:	00 00 00 
  80047e:	b8 00 00 00 00       	mov    $0x0,%eax
  800483:	48 ba b7 05 80 00 00 	movabs $0x8005b7,%rdx
  80048a:	00 00 00 
  80048d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80048f:	cc                   	int3   
  800490:	eb fd                	jmp    80048f <_panic+0x111>

0000000000800492 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800492:	55                   	push   %rbp
  800493:	48 89 e5             	mov    %rsp,%rbp
  800496:	48 83 ec 10          	sub    $0x10,%rsp
  80049a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80049d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8004a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a5:	8b 00                	mov    (%rax),%eax
  8004a7:	8d 48 01             	lea    0x1(%rax),%ecx
  8004aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004ae:	89 0a                	mov    %ecx,(%rdx)
  8004b0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004b3:	89 d1                	mov    %edx,%ecx
  8004b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004b9:	48 98                	cltq   
  8004bb:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8004bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004c3:	8b 00                	mov    (%rax),%eax
  8004c5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004ca:	75 2c                	jne    8004f8 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8004cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004d0:	8b 00                	mov    (%rax),%eax
  8004d2:	48 98                	cltq   
  8004d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004d8:	48 83 c2 08          	add    $0x8,%rdx
  8004dc:	48 89 c6             	mov    %rax,%rsi
  8004df:	48 89 d7             	mov    %rdx,%rdi
  8004e2:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  8004e9:	00 00 00 
  8004ec:	ff d0                	callq  *%rax
        b->idx = 0;
  8004ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004f2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8004f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004fc:	8b 40 04             	mov    0x4(%rax),%eax
  8004ff:	8d 50 01             	lea    0x1(%rax),%edx
  800502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800506:	89 50 04             	mov    %edx,0x4(%rax)
}
  800509:	c9                   	leaveq 
  80050a:	c3                   	retq   

000000000080050b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80050b:	55                   	push   %rbp
  80050c:	48 89 e5             	mov    %rsp,%rbp
  80050f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800516:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80051d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800524:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80052b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800532:	48 8b 0a             	mov    (%rdx),%rcx
  800535:	48 89 08             	mov    %rcx,(%rax)
  800538:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80053c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800540:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800544:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800548:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80054f:	00 00 00 
    b.cnt = 0;
  800552:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800559:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80055c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800563:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80056a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800571:	48 89 c6             	mov    %rax,%rsi
  800574:	48 bf 92 04 80 00 00 	movabs $0x800492,%rdi
  80057b:	00 00 00 
  80057e:	48 b8 6a 09 80 00 00 	movabs $0x80096a,%rax
  800585:	00 00 00 
  800588:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80058a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800590:	48 98                	cltq   
  800592:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800599:	48 83 c2 08          	add    $0x8,%rdx
  80059d:	48 89 c6             	mov    %rax,%rsi
  8005a0:	48 89 d7             	mov    %rdx,%rdi
  8005a3:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  8005aa:	00 00 00 
  8005ad:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8005af:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8005b5:	c9                   	leaveq 
  8005b6:	c3                   	retq   

00000000008005b7 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8005b7:	55                   	push   %rbp
  8005b8:	48 89 e5             	mov    %rsp,%rbp
  8005bb:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8005c2:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8005c9:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005d0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005d7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005de:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005e5:	84 c0                	test   %al,%al
  8005e7:	74 20                	je     800609 <cprintf+0x52>
  8005e9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005ed:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005f1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8005f5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8005f9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8005fd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800601:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800605:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800609:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800610:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800617:	00 00 00 
  80061a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800621:	00 00 00 
  800624:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800628:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80062f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800636:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80063d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800644:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80064b:	48 8b 0a             	mov    (%rdx),%rcx
  80064e:	48 89 08             	mov    %rcx,(%rax)
  800651:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800655:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800659:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80065d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800661:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800668:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80066f:	48 89 d6             	mov    %rdx,%rsi
  800672:	48 89 c7             	mov    %rax,%rdi
  800675:	48 b8 0b 05 80 00 00 	movabs $0x80050b,%rax
  80067c:	00 00 00 
  80067f:	ff d0                	callq  *%rax
  800681:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800687:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80068d:	c9                   	leaveq 
  80068e:	c3                   	retq   

000000000080068f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80068f:	55                   	push   %rbp
  800690:	48 89 e5             	mov    %rsp,%rbp
  800693:	53                   	push   %rbx
  800694:	48 83 ec 38          	sub    $0x38,%rsp
  800698:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80069c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8006a4:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8006a7:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8006ab:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006af:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8006b2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8006b6:	77 3b                	ja     8006f3 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006b8:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8006bb:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8006bf:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8006c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cb:	48 f7 f3             	div    %rbx
  8006ce:	48 89 c2             	mov    %rax,%rdx
  8006d1:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8006d4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006d7:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8006db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006df:	41 89 f9             	mov    %edi,%r9d
  8006e2:	48 89 c7             	mov    %rax,%rdi
  8006e5:	48 b8 8f 06 80 00 00 	movabs $0x80068f,%rax
  8006ec:	00 00 00 
  8006ef:	ff d0                	callq  *%rax
  8006f1:	eb 1e                	jmp    800711 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f3:	eb 12                	jmp    800707 <printnum+0x78>
			putch(padc, putdat);
  8006f5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006f9:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8006fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800700:	48 89 ce             	mov    %rcx,%rsi
  800703:	89 d7                	mov    %edx,%edi
  800705:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800707:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80070b:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80070f:	7f e4                	jg     8006f5 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800711:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800714:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800718:	ba 00 00 00 00       	mov    $0x0,%edx
  80071d:	48 f7 f1             	div    %rcx
  800720:	48 89 d0             	mov    %rdx,%rax
  800723:	48 ba 90 48 80 00 00 	movabs $0x804890,%rdx
  80072a:	00 00 00 
  80072d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800731:	0f be d0             	movsbl %al,%edx
  800734:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073c:	48 89 ce             	mov    %rcx,%rsi
  80073f:	89 d7                	mov    %edx,%edi
  800741:	ff d0                	callq  *%rax
}
  800743:	48 83 c4 38          	add    $0x38,%rsp
  800747:	5b                   	pop    %rbx
  800748:	5d                   	pop    %rbp
  800749:	c3                   	retq   

000000000080074a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80074a:	55                   	push   %rbp
  80074b:	48 89 e5             	mov    %rsp,%rbp
  80074e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800752:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800756:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800759:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80075d:	7e 52                	jle    8007b1 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80075f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800763:	8b 00                	mov    (%rax),%eax
  800765:	83 f8 30             	cmp    $0x30,%eax
  800768:	73 24                	jae    80078e <getuint+0x44>
  80076a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800772:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800776:	8b 00                	mov    (%rax),%eax
  800778:	89 c0                	mov    %eax,%eax
  80077a:	48 01 d0             	add    %rdx,%rax
  80077d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800781:	8b 12                	mov    (%rdx),%edx
  800783:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800786:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078a:	89 0a                	mov    %ecx,(%rdx)
  80078c:	eb 17                	jmp    8007a5 <getuint+0x5b>
  80078e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800792:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800796:	48 89 d0             	mov    %rdx,%rax
  800799:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80079d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007a5:	48 8b 00             	mov    (%rax),%rax
  8007a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007ac:	e9 a3 00 00 00       	jmpq   800854 <getuint+0x10a>
	else if (lflag)
  8007b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007b5:	74 4f                	je     800806 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8007b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bb:	8b 00                	mov    (%rax),%eax
  8007bd:	83 f8 30             	cmp    $0x30,%eax
  8007c0:	73 24                	jae    8007e6 <getuint+0x9c>
  8007c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ce:	8b 00                	mov    (%rax),%eax
  8007d0:	89 c0                	mov    %eax,%eax
  8007d2:	48 01 d0             	add    %rdx,%rax
  8007d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d9:	8b 12                	mov    (%rdx),%edx
  8007db:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e2:	89 0a                	mov    %ecx,(%rdx)
  8007e4:	eb 17                	jmp    8007fd <getuint+0xb3>
  8007e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ea:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007ee:	48 89 d0             	mov    %rdx,%rax
  8007f1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007fd:	48 8b 00             	mov    (%rax),%rax
  800800:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800804:	eb 4e                	jmp    800854 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800806:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080a:	8b 00                	mov    (%rax),%eax
  80080c:	83 f8 30             	cmp    $0x30,%eax
  80080f:	73 24                	jae    800835 <getuint+0xeb>
  800811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800815:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800819:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081d:	8b 00                	mov    (%rax),%eax
  80081f:	89 c0                	mov    %eax,%eax
  800821:	48 01 d0             	add    %rdx,%rax
  800824:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800828:	8b 12                	mov    (%rdx),%edx
  80082a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80082d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800831:	89 0a                	mov    %ecx,(%rdx)
  800833:	eb 17                	jmp    80084c <getuint+0x102>
  800835:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800839:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80083d:	48 89 d0             	mov    %rdx,%rax
  800840:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800844:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800848:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80084c:	8b 00                	mov    (%rax),%eax
  80084e:	89 c0                	mov    %eax,%eax
  800850:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800854:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800858:	c9                   	leaveq 
  800859:	c3                   	retq   

000000000080085a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80085a:	55                   	push   %rbp
  80085b:	48 89 e5             	mov    %rsp,%rbp
  80085e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800862:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800866:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800869:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80086d:	7e 52                	jle    8008c1 <getint+0x67>
		x=va_arg(*ap, long long);
  80086f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800873:	8b 00                	mov    (%rax),%eax
  800875:	83 f8 30             	cmp    $0x30,%eax
  800878:	73 24                	jae    80089e <getint+0x44>
  80087a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800882:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800886:	8b 00                	mov    (%rax),%eax
  800888:	89 c0                	mov    %eax,%eax
  80088a:	48 01 d0             	add    %rdx,%rax
  80088d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800891:	8b 12                	mov    (%rdx),%edx
  800893:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800896:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80089a:	89 0a                	mov    %ecx,(%rdx)
  80089c:	eb 17                	jmp    8008b5 <getint+0x5b>
  80089e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008a6:	48 89 d0             	mov    %rdx,%rax
  8008a9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008b5:	48 8b 00             	mov    (%rax),%rax
  8008b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008bc:	e9 a3 00 00 00       	jmpq   800964 <getint+0x10a>
	else if (lflag)
  8008c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008c5:	74 4f                	je     800916 <getint+0xbc>
		x=va_arg(*ap, long);
  8008c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008cb:	8b 00                	mov    (%rax),%eax
  8008cd:	83 f8 30             	cmp    $0x30,%eax
  8008d0:	73 24                	jae    8008f6 <getint+0x9c>
  8008d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008de:	8b 00                	mov    (%rax),%eax
  8008e0:	89 c0                	mov    %eax,%eax
  8008e2:	48 01 d0             	add    %rdx,%rax
  8008e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e9:	8b 12                	mov    (%rdx),%edx
  8008eb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f2:	89 0a                	mov    %ecx,(%rdx)
  8008f4:	eb 17                	jmp    80090d <getint+0xb3>
  8008f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008fe:	48 89 d0             	mov    %rdx,%rax
  800901:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800905:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800909:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80090d:	48 8b 00             	mov    (%rax),%rax
  800910:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800914:	eb 4e                	jmp    800964 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800916:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091a:	8b 00                	mov    (%rax),%eax
  80091c:	83 f8 30             	cmp    $0x30,%eax
  80091f:	73 24                	jae    800945 <getint+0xeb>
  800921:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800925:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800929:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092d:	8b 00                	mov    (%rax),%eax
  80092f:	89 c0                	mov    %eax,%eax
  800931:	48 01 d0             	add    %rdx,%rax
  800934:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800938:	8b 12                	mov    (%rdx),%edx
  80093a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80093d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800941:	89 0a                	mov    %ecx,(%rdx)
  800943:	eb 17                	jmp    80095c <getint+0x102>
  800945:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800949:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80094d:	48 89 d0             	mov    %rdx,%rax
  800950:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800954:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800958:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80095c:	8b 00                	mov    (%rax),%eax
  80095e:	48 98                	cltq   
  800960:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800964:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800968:	c9                   	leaveq 
  800969:	c3                   	retq   

000000000080096a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80096a:	55                   	push   %rbp
  80096b:	48 89 e5             	mov    %rsp,%rbp
  80096e:	41 54                	push   %r12
  800970:	53                   	push   %rbx
  800971:	48 83 ec 60          	sub    $0x60,%rsp
  800975:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800979:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80097d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800981:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800985:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800989:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80098d:	48 8b 0a             	mov    (%rdx),%rcx
  800990:	48 89 08             	mov    %rcx,(%rax)
  800993:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800997:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80099b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80099f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a3:	eb 17                	jmp    8009bc <vprintfmt+0x52>
			if (ch == '\0')
  8009a5:	85 db                	test   %ebx,%ebx
  8009a7:	0f 84 cc 04 00 00    	je     800e79 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8009ad:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009b1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b5:	48 89 d6             	mov    %rdx,%rsi
  8009b8:	89 df                	mov    %ebx,%edi
  8009ba:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009bc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009c0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009c4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009c8:	0f b6 00             	movzbl (%rax),%eax
  8009cb:	0f b6 d8             	movzbl %al,%ebx
  8009ce:	83 fb 25             	cmp    $0x25,%ebx
  8009d1:	75 d2                	jne    8009a5 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009d3:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009d7:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009de:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009ec:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009f3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009f7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009fb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009ff:	0f b6 00             	movzbl (%rax),%eax
  800a02:	0f b6 d8             	movzbl %al,%ebx
  800a05:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a08:	83 f8 55             	cmp    $0x55,%eax
  800a0b:	0f 87 34 04 00 00    	ja     800e45 <vprintfmt+0x4db>
  800a11:	89 c0                	mov    %eax,%eax
  800a13:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a1a:	00 
  800a1b:	48 b8 b8 48 80 00 00 	movabs $0x8048b8,%rax
  800a22:	00 00 00 
  800a25:	48 01 d0             	add    %rdx,%rax
  800a28:	48 8b 00             	mov    (%rax),%rax
  800a2b:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a2d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a31:	eb c0                	jmp    8009f3 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a33:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a37:	eb ba                	jmp    8009f3 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a39:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a40:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a43:	89 d0                	mov    %edx,%eax
  800a45:	c1 e0 02             	shl    $0x2,%eax
  800a48:	01 d0                	add    %edx,%eax
  800a4a:	01 c0                	add    %eax,%eax
  800a4c:	01 d8                	add    %ebx,%eax
  800a4e:	83 e8 30             	sub    $0x30,%eax
  800a51:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a54:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a58:	0f b6 00             	movzbl (%rax),%eax
  800a5b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a5e:	83 fb 2f             	cmp    $0x2f,%ebx
  800a61:	7e 0c                	jle    800a6f <vprintfmt+0x105>
  800a63:	83 fb 39             	cmp    $0x39,%ebx
  800a66:	7f 07                	jg     800a6f <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a68:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a6d:	eb d1                	jmp    800a40 <vprintfmt+0xd6>
			goto process_precision;
  800a6f:	eb 58                	jmp    800ac9 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800a71:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a74:	83 f8 30             	cmp    $0x30,%eax
  800a77:	73 17                	jae    800a90 <vprintfmt+0x126>
  800a79:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a80:	89 c0                	mov    %eax,%eax
  800a82:	48 01 d0             	add    %rdx,%rax
  800a85:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a88:	83 c2 08             	add    $0x8,%edx
  800a8b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a8e:	eb 0f                	jmp    800a9f <vprintfmt+0x135>
  800a90:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a94:	48 89 d0             	mov    %rdx,%rax
  800a97:	48 83 c2 08          	add    $0x8,%rdx
  800a9b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a9f:	8b 00                	mov    (%rax),%eax
  800aa1:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800aa4:	eb 23                	jmp    800ac9 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800aa6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aaa:	79 0c                	jns    800ab8 <vprintfmt+0x14e>
				width = 0;
  800aac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800ab3:	e9 3b ff ff ff       	jmpq   8009f3 <vprintfmt+0x89>
  800ab8:	e9 36 ff ff ff       	jmpq   8009f3 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800abd:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800ac4:	e9 2a ff ff ff       	jmpq   8009f3 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800ac9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800acd:	79 12                	jns    800ae1 <vprintfmt+0x177>
				width = precision, precision = -1;
  800acf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ad2:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800ad5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800adc:	e9 12 ff ff ff       	jmpq   8009f3 <vprintfmt+0x89>
  800ae1:	e9 0d ff ff ff       	jmpq   8009f3 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ae6:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800aea:	e9 04 ff ff ff       	jmpq   8009f3 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800aef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af2:	83 f8 30             	cmp    $0x30,%eax
  800af5:	73 17                	jae    800b0e <vprintfmt+0x1a4>
  800af7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800afb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800afe:	89 c0                	mov    %eax,%eax
  800b00:	48 01 d0             	add    %rdx,%rax
  800b03:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b06:	83 c2 08             	add    $0x8,%edx
  800b09:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b0c:	eb 0f                	jmp    800b1d <vprintfmt+0x1b3>
  800b0e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b12:	48 89 d0             	mov    %rdx,%rax
  800b15:	48 83 c2 08          	add    $0x8,%rdx
  800b19:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b1d:	8b 10                	mov    (%rax),%edx
  800b1f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b27:	48 89 ce             	mov    %rcx,%rsi
  800b2a:	89 d7                	mov    %edx,%edi
  800b2c:	ff d0                	callq  *%rax
			break;
  800b2e:	e9 40 03 00 00       	jmpq   800e73 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b33:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b36:	83 f8 30             	cmp    $0x30,%eax
  800b39:	73 17                	jae    800b52 <vprintfmt+0x1e8>
  800b3b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b3f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b42:	89 c0                	mov    %eax,%eax
  800b44:	48 01 d0             	add    %rdx,%rax
  800b47:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b4a:	83 c2 08             	add    $0x8,%edx
  800b4d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b50:	eb 0f                	jmp    800b61 <vprintfmt+0x1f7>
  800b52:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b56:	48 89 d0             	mov    %rdx,%rax
  800b59:	48 83 c2 08          	add    $0x8,%rdx
  800b5d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b61:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b63:	85 db                	test   %ebx,%ebx
  800b65:	79 02                	jns    800b69 <vprintfmt+0x1ff>
				err = -err;
  800b67:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b69:	83 fb 15             	cmp    $0x15,%ebx
  800b6c:	7f 16                	jg     800b84 <vprintfmt+0x21a>
  800b6e:	48 b8 e0 47 80 00 00 	movabs $0x8047e0,%rax
  800b75:	00 00 00 
  800b78:	48 63 d3             	movslq %ebx,%rdx
  800b7b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b7f:	4d 85 e4             	test   %r12,%r12
  800b82:	75 2e                	jne    800bb2 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b84:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8c:	89 d9                	mov    %ebx,%ecx
  800b8e:	48 ba a1 48 80 00 00 	movabs $0x8048a1,%rdx
  800b95:	00 00 00 
  800b98:	48 89 c7             	mov    %rax,%rdi
  800b9b:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba0:	49 b8 82 0e 80 00 00 	movabs $0x800e82,%r8
  800ba7:	00 00 00 
  800baa:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bad:	e9 c1 02 00 00       	jmpq   800e73 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bb2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bb6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bba:	4c 89 e1             	mov    %r12,%rcx
  800bbd:	48 ba aa 48 80 00 00 	movabs $0x8048aa,%rdx
  800bc4:	00 00 00 
  800bc7:	48 89 c7             	mov    %rax,%rdi
  800bca:	b8 00 00 00 00       	mov    $0x0,%eax
  800bcf:	49 b8 82 0e 80 00 00 	movabs $0x800e82,%r8
  800bd6:	00 00 00 
  800bd9:	41 ff d0             	callq  *%r8
			break;
  800bdc:	e9 92 02 00 00       	jmpq   800e73 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800be1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be4:	83 f8 30             	cmp    $0x30,%eax
  800be7:	73 17                	jae    800c00 <vprintfmt+0x296>
  800be9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf0:	89 c0                	mov    %eax,%eax
  800bf2:	48 01 d0             	add    %rdx,%rax
  800bf5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf8:	83 c2 08             	add    $0x8,%edx
  800bfb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bfe:	eb 0f                	jmp    800c0f <vprintfmt+0x2a5>
  800c00:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c04:	48 89 d0             	mov    %rdx,%rax
  800c07:	48 83 c2 08          	add    $0x8,%rdx
  800c0b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c0f:	4c 8b 20             	mov    (%rax),%r12
  800c12:	4d 85 e4             	test   %r12,%r12
  800c15:	75 0a                	jne    800c21 <vprintfmt+0x2b7>
				p = "(null)";
  800c17:	49 bc ad 48 80 00 00 	movabs $0x8048ad,%r12
  800c1e:	00 00 00 
			if (width > 0 && padc != '-')
  800c21:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c25:	7e 3f                	jle    800c66 <vprintfmt+0x2fc>
  800c27:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c2b:	74 39                	je     800c66 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c2d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c30:	48 98                	cltq   
  800c32:	48 89 c6             	mov    %rax,%rsi
  800c35:	4c 89 e7             	mov    %r12,%rdi
  800c38:	48 b8 2e 11 80 00 00 	movabs $0x80112e,%rax
  800c3f:	00 00 00 
  800c42:	ff d0                	callq  *%rax
  800c44:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c47:	eb 17                	jmp    800c60 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800c49:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c4d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c51:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c55:	48 89 ce             	mov    %rcx,%rsi
  800c58:	89 d7                	mov    %edx,%edi
  800c5a:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c5c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c60:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c64:	7f e3                	jg     800c49 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c66:	eb 37                	jmp    800c9f <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800c68:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c6c:	74 1e                	je     800c8c <vprintfmt+0x322>
  800c6e:	83 fb 1f             	cmp    $0x1f,%ebx
  800c71:	7e 05                	jle    800c78 <vprintfmt+0x30e>
  800c73:	83 fb 7e             	cmp    $0x7e,%ebx
  800c76:	7e 14                	jle    800c8c <vprintfmt+0x322>
					putch('?', putdat);
  800c78:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c80:	48 89 d6             	mov    %rdx,%rsi
  800c83:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c88:	ff d0                	callq  *%rax
  800c8a:	eb 0f                	jmp    800c9b <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800c8c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c90:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c94:	48 89 d6             	mov    %rdx,%rsi
  800c97:	89 df                	mov    %ebx,%edi
  800c99:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c9b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c9f:	4c 89 e0             	mov    %r12,%rax
  800ca2:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ca6:	0f b6 00             	movzbl (%rax),%eax
  800ca9:	0f be d8             	movsbl %al,%ebx
  800cac:	85 db                	test   %ebx,%ebx
  800cae:	74 10                	je     800cc0 <vprintfmt+0x356>
  800cb0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cb4:	78 b2                	js     800c68 <vprintfmt+0x2fe>
  800cb6:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800cba:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cbe:	79 a8                	jns    800c68 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cc0:	eb 16                	jmp    800cd8 <vprintfmt+0x36e>
				putch(' ', putdat);
  800cc2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cc6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cca:	48 89 d6             	mov    %rdx,%rsi
  800ccd:	bf 20 00 00 00       	mov    $0x20,%edi
  800cd2:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cd4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cd8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cdc:	7f e4                	jg     800cc2 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800cde:	e9 90 01 00 00       	jmpq   800e73 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ce3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ce7:	be 03 00 00 00       	mov    $0x3,%esi
  800cec:	48 89 c7             	mov    %rax,%rdi
  800cef:	48 b8 5a 08 80 00 00 	movabs $0x80085a,%rax
  800cf6:	00 00 00 
  800cf9:	ff d0                	callq  *%rax
  800cfb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800cff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d03:	48 85 c0             	test   %rax,%rax
  800d06:	79 1d                	jns    800d25 <vprintfmt+0x3bb>
				putch('-', putdat);
  800d08:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d0c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d10:	48 89 d6             	mov    %rdx,%rsi
  800d13:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d18:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d1e:	48 f7 d8             	neg    %rax
  800d21:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d25:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d2c:	e9 d5 00 00 00       	jmpq   800e06 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d31:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d35:	be 03 00 00 00       	mov    $0x3,%esi
  800d3a:	48 89 c7             	mov    %rax,%rdi
  800d3d:	48 b8 4a 07 80 00 00 	movabs $0x80074a,%rax
  800d44:	00 00 00 
  800d47:	ff d0                	callq  *%rax
  800d49:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d4d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d54:	e9 ad 00 00 00       	jmpq   800e06 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800d59:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d5d:	be 03 00 00 00       	mov    $0x3,%esi
  800d62:	48 89 c7             	mov    %rax,%rdi
  800d65:	48 b8 4a 07 80 00 00 	movabs $0x80074a,%rax
  800d6c:	00 00 00 
  800d6f:	ff d0                	callq  *%rax
  800d71:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800d75:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d7c:	e9 85 00 00 00       	jmpq   800e06 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800d81:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d85:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d89:	48 89 d6             	mov    %rdx,%rsi
  800d8c:	bf 30 00 00 00       	mov    $0x30,%edi
  800d91:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d93:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d97:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9b:	48 89 d6             	mov    %rdx,%rsi
  800d9e:	bf 78 00 00 00       	mov    $0x78,%edi
  800da3:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800da5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800da8:	83 f8 30             	cmp    $0x30,%eax
  800dab:	73 17                	jae    800dc4 <vprintfmt+0x45a>
  800dad:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800db1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800db4:	89 c0                	mov    %eax,%eax
  800db6:	48 01 d0             	add    %rdx,%rax
  800db9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dbc:	83 c2 08             	add    $0x8,%edx
  800dbf:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dc2:	eb 0f                	jmp    800dd3 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800dc4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dc8:	48 89 d0             	mov    %rdx,%rax
  800dcb:	48 83 c2 08          	add    $0x8,%rdx
  800dcf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dd3:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dd6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800dda:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800de1:	eb 23                	jmp    800e06 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800de3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800de7:	be 03 00 00 00       	mov    $0x3,%esi
  800dec:	48 89 c7             	mov    %rax,%rdi
  800def:	48 b8 4a 07 80 00 00 	movabs $0x80074a,%rax
  800df6:	00 00 00 
  800df9:	ff d0                	callq  *%rax
  800dfb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800dff:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e06:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e0b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e0e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e11:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e15:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e1d:	45 89 c1             	mov    %r8d,%r9d
  800e20:	41 89 f8             	mov    %edi,%r8d
  800e23:	48 89 c7             	mov    %rax,%rdi
  800e26:	48 b8 8f 06 80 00 00 	movabs $0x80068f,%rax
  800e2d:	00 00 00 
  800e30:	ff d0                	callq  *%rax
			break;
  800e32:	eb 3f                	jmp    800e73 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e34:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e3c:	48 89 d6             	mov    %rdx,%rsi
  800e3f:	89 df                	mov    %ebx,%edi
  800e41:	ff d0                	callq  *%rax
			break;
  800e43:	eb 2e                	jmp    800e73 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e45:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e49:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e4d:	48 89 d6             	mov    %rdx,%rsi
  800e50:	bf 25 00 00 00       	mov    $0x25,%edi
  800e55:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e57:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e5c:	eb 05                	jmp    800e63 <vprintfmt+0x4f9>
  800e5e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e63:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e67:	48 83 e8 01          	sub    $0x1,%rax
  800e6b:	0f b6 00             	movzbl (%rax),%eax
  800e6e:	3c 25                	cmp    $0x25,%al
  800e70:	75 ec                	jne    800e5e <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800e72:	90                   	nop
		}
	}
  800e73:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e74:	e9 43 fb ff ff       	jmpq   8009bc <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e79:	48 83 c4 60          	add    $0x60,%rsp
  800e7d:	5b                   	pop    %rbx
  800e7e:	41 5c                	pop    %r12
  800e80:	5d                   	pop    %rbp
  800e81:	c3                   	retq   

0000000000800e82 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e82:	55                   	push   %rbp
  800e83:	48 89 e5             	mov    %rsp,%rbp
  800e86:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e8d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e94:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e9b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ea2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ea9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800eb0:	84 c0                	test   %al,%al
  800eb2:	74 20                	je     800ed4 <printfmt+0x52>
  800eb4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800eb8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ebc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ec0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ec4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ec8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ecc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ed0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ed4:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800edb:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800ee2:	00 00 00 
  800ee5:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800eec:	00 00 00 
  800eef:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ef3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800efa:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f01:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f08:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f0f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f16:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f1d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f24:	48 89 c7             	mov    %rax,%rdi
  800f27:	48 b8 6a 09 80 00 00 	movabs $0x80096a,%rax
  800f2e:	00 00 00 
  800f31:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f33:	c9                   	leaveq 
  800f34:	c3                   	retq   

0000000000800f35 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f35:	55                   	push   %rbp
  800f36:	48 89 e5             	mov    %rsp,%rbp
  800f39:	48 83 ec 10          	sub    $0x10,%rsp
  800f3d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f40:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f48:	8b 40 10             	mov    0x10(%rax),%eax
  800f4b:	8d 50 01             	lea    0x1(%rax),%edx
  800f4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f52:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f59:	48 8b 10             	mov    (%rax),%rdx
  800f5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f60:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f64:	48 39 c2             	cmp    %rax,%rdx
  800f67:	73 17                	jae    800f80 <sprintputch+0x4b>
		*b->buf++ = ch;
  800f69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f6d:	48 8b 00             	mov    (%rax),%rax
  800f70:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f74:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f78:	48 89 0a             	mov    %rcx,(%rdx)
  800f7b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f7e:	88 10                	mov    %dl,(%rax)
}
  800f80:	c9                   	leaveq 
  800f81:	c3                   	retq   

0000000000800f82 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f82:	55                   	push   %rbp
  800f83:	48 89 e5             	mov    %rsp,%rbp
  800f86:	48 83 ec 50          	sub    $0x50,%rsp
  800f8a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f8e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f91:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f95:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f99:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f9d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800fa1:	48 8b 0a             	mov    (%rdx),%rcx
  800fa4:	48 89 08             	mov    %rcx,(%rax)
  800fa7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fab:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800faf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fb3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fb7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fbb:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800fbf:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800fc2:	48 98                	cltq   
  800fc4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800fc8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fcc:	48 01 d0             	add    %rdx,%rax
  800fcf:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800fd3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800fda:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800fdf:	74 06                	je     800fe7 <vsnprintf+0x65>
  800fe1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800fe5:	7f 07                	jg     800fee <vsnprintf+0x6c>
		return -E_INVAL;
  800fe7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fec:	eb 2f                	jmp    80101d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800fee:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ff2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ff6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ffa:	48 89 c6             	mov    %rax,%rsi
  800ffd:	48 bf 35 0f 80 00 00 	movabs $0x800f35,%rdi
  801004:	00 00 00 
  801007:	48 b8 6a 09 80 00 00 	movabs $0x80096a,%rax
  80100e:	00 00 00 
  801011:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801013:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801017:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80101a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80101d:	c9                   	leaveq 
  80101e:	c3                   	retq   

000000000080101f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80101f:	55                   	push   %rbp
  801020:	48 89 e5             	mov    %rsp,%rbp
  801023:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80102a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801031:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801037:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80103e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801045:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80104c:	84 c0                	test   %al,%al
  80104e:	74 20                	je     801070 <snprintf+0x51>
  801050:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801054:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801058:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80105c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801060:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801064:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801068:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80106c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801070:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801077:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80107e:	00 00 00 
  801081:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801088:	00 00 00 
  80108b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80108f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801096:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80109d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8010a4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8010ab:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8010b2:	48 8b 0a             	mov    (%rdx),%rcx
  8010b5:	48 89 08             	mov    %rcx,(%rax)
  8010b8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010bc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010c0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010c4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8010c8:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010cf:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010d6:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010dc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010e3:	48 89 c7             	mov    %rax,%rdi
  8010e6:	48 b8 82 0f 80 00 00 	movabs $0x800f82,%rax
  8010ed:	00 00 00 
  8010f0:	ff d0                	callq  *%rax
  8010f2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8010f8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8010fe:	c9                   	leaveq 
  8010ff:	c3                   	retq   

0000000000801100 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801100:	55                   	push   %rbp
  801101:	48 89 e5             	mov    %rsp,%rbp
  801104:	48 83 ec 18          	sub    $0x18,%rsp
  801108:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80110c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801113:	eb 09                	jmp    80111e <strlen+0x1e>
		n++;
  801115:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801119:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80111e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801122:	0f b6 00             	movzbl (%rax),%eax
  801125:	84 c0                	test   %al,%al
  801127:	75 ec                	jne    801115 <strlen+0x15>
		n++;
	return n;
  801129:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80112c:	c9                   	leaveq 
  80112d:	c3                   	retq   

000000000080112e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80112e:	55                   	push   %rbp
  80112f:	48 89 e5             	mov    %rsp,%rbp
  801132:	48 83 ec 20          	sub    $0x20,%rsp
  801136:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80113a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80113e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801145:	eb 0e                	jmp    801155 <strnlen+0x27>
		n++;
  801147:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80114b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801150:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801155:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80115a:	74 0b                	je     801167 <strnlen+0x39>
  80115c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801160:	0f b6 00             	movzbl (%rax),%eax
  801163:	84 c0                	test   %al,%al
  801165:	75 e0                	jne    801147 <strnlen+0x19>
		n++;
	return n;
  801167:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80116a:	c9                   	leaveq 
  80116b:	c3                   	retq   

000000000080116c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80116c:	55                   	push   %rbp
  80116d:	48 89 e5             	mov    %rsp,%rbp
  801170:	48 83 ec 20          	sub    $0x20,%rsp
  801174:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801178:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80117c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801180:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801184:	90                   	nop
  801185:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801189:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80118d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801191:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801195:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801199:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80119d:	0f b6 12             	movzbl (%rdx),%edx
  8011a0:	88 10                	mov    %dl,(%rax)
  8011a2:	0f b6 00             	movzbl (%rax),%eax
  8011a5:	84 c0                	test   %al,%al
  8011a7:	75 dc                	jne    801185 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8011a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011ad:	c9                   	leaveq 
  8011ae:	c3                   	retq   

00000000008011af <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011af:	55                   	push   %rbp
  8011b0:	48 89 e5             	mov    %rsp,%rbp
  8011b3:	48 83 ec 20          	sub    $0x20,%rsp
  8011b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8011bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c3:	48 89 c7             	mov    %rax,%rdi
  8011c6:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  8011cd:	00 00 00 
  8011d0:	ff d0                	callq  *%rax
  8011d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011d8:	48 63 d0             	movslq %eax,%rdx
  8011db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011df:	48 01 c2             	add    %rax,%rdx
  8011e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011e6:	48 89 c6             	mov    %rax,%rsi
  8011e9:	48 89 d7             	mov    %rdx,%rdi
  8011ec:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  8011f3:	00 00 00 
  8011f6:	ff d0                	callq  *%rax
	return dst;
  8011f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8011fc:	c9                   	leaveq 
  8011fd:	c3                   	retq   

00000000008011fe <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011fe:	55                   	push   %rbp
  8011ff:	48 89 e5             	mov    %rsp,%rbp
  801202:	48 83 ec 28          	sub    $0x28,%rsp
  801206:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80120a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80120e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801212:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801216:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80121a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801221:	00 
  801222:	eb 2a                	jmp    80124e <strncpy+0x50>
		*dst++ = *src;
  801224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801228:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80122c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801230:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801234:	0f b6 12             	movzbl (%rdx),%edx
  801237:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801239:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80123d:	0f b6 00             	movzbl (%rax),%eax
  801240:	84 c0                	test   %al,%al
  801242:	74 05                	je     801249 <strncpy+0x4b>
			src++;
  801244:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801249:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80124e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801252:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801256:	72 cc                	jb     801224 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801258:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80125c:	c9                   	leaveq 
  80125d:	c3                   	retq   

000000000080125e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80125e:	55                   	push   %rbp
  80125f:	48 89 e5             	mov    %rsp,%rbp
  801262:	48 83 ec 28          	sub    $0x28,%rsp
  801266:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80126a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80126e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801272:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801276:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80127a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80127f:	74 3d                	je     8012be <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801281:	eb 1d                	jmp    8012a0 <strlcpy+0x42>
			*dst++ = *src++;
  801283:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801287:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80128b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80128f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801293:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801297:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80129b:	0f b6 12             	movzbl (%rdx),%edx
  80129e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012a0:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8012a5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012aa:	74 0b                	je     8012b7 <strlcpy+0x59>
  8012ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012b0:	0f b6 00             	movzbl (%rax),%eax
  8012b3:	84 c0                	test   %al,%al
  8012b5:	75 cc                	jne    801283 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8012b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bb:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8012be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c6:	48 29 c2             	sub    %rax,%rdx
  8012c9:	48 89 d0             	mov    %rdx,%rax
}
  8012cc:	c9                   	leaveq 
  8012cd:	c3                   	retq   

00000000008012ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012ce:	55                   	push   %rbp
  8012cf:	48 89 e5             	mov    %rsp,%rbp
  8012d2:	48 83 ec 10          	sub    $0x10,%rsp
  8012d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012de:	eb 0a                	jmp    8012ea <strcmp+0x1c>
		p++, q++;
  8012e0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012e5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ee:	0f b6 00             	movzbl (%rax),%eax
  8012f1:	84 c0                	test   %al,%al
  8012f3:	74 12                	je     801307 <strcmp+0x39>
  8012f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f9:	0f b6 10             	movzbl (%rax),%edx
  8012fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801300:	0f b6 00             	movzbl (%rax),%eax
  801303:	38 c2                	cmp    %al,%dl
  801305:	74 d9                	je     8012e0 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801307:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130b:	0f b6 00             	movzbl (%rax),%eax
  80130e:	0f b6 d0             	movzbl %al,%edx
  801311:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801315:	0f b6 00             	movzbl (%rax),%eax
  801318:	0f b6 c0             	movzbl %al,%eax
  80131b:	29 c2                	sub    %eax,%edx
  80131d:	89 d0                	mov    %edx,%eax
}
  80131f:	c9                   	leaveq 
  801320:	c3                   	retq   

0000000000801321 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801321:	55                   	push   %rbp
  801322:	48 89 e5             	mov    %rsp,%rbp
  801325:	48 83 ec 18          	sub    $0x18,%rsp
  801329:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80132d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801331:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801335:	eb 0f                	jmp    801346 <strncmp+0x25>
		n--, p++, q++;
  801337:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80133c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801341:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801346:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80134b:	74 1d                	je     80136a <strncmp+0x49>
  80134d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801351:	0f b6 00             	movzbl (%rax),%eax
  801354:	84 c0                	test   %al,%al
  801356:	74 12                	je     80136a <strncmp+0x49>
  801358:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135c:	0f b6 10             	movzbl (%rax),%edx
  80135f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801363:	0f b6 00             	movzbl (%rax),%eax
  801366:	38 c2                	cmp    %al,%dl
  801368:	74 cd                	je     801337 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80136a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80136f:	75 07                	jne    801378 <strncmp+0x57>
		return 0;
  801371:	b8 00 00 00 00       	mov    $0x0,%eax
  801376:	eb 18                	jmp    801390 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801378:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137c:	0f b6 00             	movzbl (%rax),%eax
  80137f:	0f b6 d0             	movzbl %al,%edx
  801382:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801386:	0f b6 00             	movzbl (%rax),%eax
  801389:	0f b6 c0             	movzbl %al,%eax
  80138c:	29 c2                	sub    %eax,%edx
  80138e:	89 d0                	mov    %edx,%eax
}
  801390:	c9                   	leaveq 
  801391:	c3                   	retq   

0000000000801392 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801392:	55                   	push   %rbp
  801393:	48 89 e5             	mov    %rsp,%rbp
  801396:	48 83 ec 0c          	sub    $0xc,%rsp
  80139a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80139e:	89 f0                	mov    %esi,%eax
  8013a0:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013a3:	eb 17                	jmp    8013bc <strchr+0x2a>
		if (*s == c)
  8013a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a9:	0f b6 00             	movzbl (%rax),%eax
  8013ac:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013af:	75 06                	jne    8013b7 <strchr+0x25>
			return (char *) s;
  8013b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b5:	eb 15                	jmp    8013cc <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c0:	0f b6 00             	movzbl (%rax),%eax
  8013c3:	84 c0                	test   %al,%al
  8013c5:	75 de                	jne    8013a5 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8013c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013cc:	c9                   	leaveq 
  8013cd:	c3                   	retq   

00000000008013ce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013ce:	55                   	push   %rbp
  8013cf:	48 89 e5             	mov    %rsp,%rbp
  8013d2:	48 83 ec 0c          	sub    $0xc,%rsp
  8013d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013da:	89 f0                	mov    %esi,%eax
  8013dc:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013df:	eb 13                	jmp    8013f4 <strfind+0x26>
		if (*s == c)
  8013e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e5:	0f b6 00             	movzbl (%rax),%eax
  8013e8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013eb:	75 02                	jne    8013ef <strfind+0x21>
			break;
  8013ed:	eb 10                	jmp    8013ff <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f8:	0f b6 00             	movzbl (%rax),%eax
  8013fb:	84 c0                	test   %al,%al
  8013fd:	75 e2                	jne    8013e1 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8013ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801403:	c9                   	leaveq 
  801404:	c3                   	retq   

0000000000801405 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801405:	55                   	push   %rbp
  801406:	48 89 e5             	mov    %rsp,%rbp
  801409:	48 83 ec 18          	sub    $0x18,%rsp
  80140d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801411:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801414:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801418:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80141d:	75 06                	jne    801425 <memset+0x20>
		return v;
  80141f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801423:	eb 69                	jmp    80148e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801425:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801429:	83 e0 03             	and    $0x3,%eax
  80142c:	48 85 c0             	test   %rax,%rax
  80142f:	75 48                	jne    801479 <memset+0x74>
  801431:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801435:	83 e0 03             	and    $0x3,%eax
  801438:	48 85 c0             	test   %rax,%rax
  80143b:	75 3c                	jne    801479 <memset+0x74>
		c &= 0xFF;
  80143d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801444:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801447:	c1 e0 18             	shl    $0x18,%eax
  80144a:	89 c2                	mov    %eax,%edx
  80144c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80144f:	c1 e0 10             	shl    $0x10,%eax
  801452:	09 c2                	or     %eax,%edx
  801454:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801457:	c1 e0 08             	shl    $0x8,%eax
  80145a:	09 d0                	or     %edx,%eax
  80145c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80145f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801463:	48 c1 e8 02          	shr    $0x2,%rax
  801467:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80146a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80146e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801471:	48 89 d7             	mov    %rdx,%rdi
  801474:	fc                   	cld    
  801475:	f3 ab                	rep stos %eax,%es:(%rdi)
  801477:	eb 11                	jmp    80148a <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801479:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80147d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801480:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801484:	48 89 d7             	mov    %rdx,%rdi
  801487:	fc                   	cld    
  801488:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80148a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80148e:	c9                   	leaveq 
  80148f:	c3                   	retq   

0000000000801490 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801490:	55                   	push   %rbp
  801491:	48 89 e5             	mov    %rsp,%rbp
  801494:	48 83 ec 28          	sub    $0x28,%rsp
  801498:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80149c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8014a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8014ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8014b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014bc:	0f 83 88 00 00 00    	jae    80154a <memmove+0xba>
  8014c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014ca:	48 01 d0             	add    %rdx,%rax
  8014cd:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014d1:	76 77                	jbe    80154a <memmove+0xba>
		s += n;
  8014d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d7:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014df:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e7:	83 e0 03             	and    $0x3,%eax
  8014ea:	48 85 c0             	test   %rax,%rax
  8014ed:	75 3b                	jne    80152a <memmove+0x9a>
  8014ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f3:	83 e0 03             	and    $0x3,%eax
  8014f6:	48 85 c0             	test   %rax,%rax
  8014f9:	75 2f                	jne    80152a <memmove+0x9a>
  8014fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ff:	83 e0 03             	and    $0x3,%eax
  801502:	48 85 c0             	test   %rax,%rax
  801505:	75 23                	jne    80152a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801507:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150b:	48 83 e8 04          	sub    $0x4,%rax
  80150f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801513:	48 83 ea 04          	sub    $0x4,%rdx
  801517:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80151b:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80151f:	48 89 c7             	mov    %rax,%rdi
  801522:	48 89 d6             	mov    %rdx,%rsi
  801525:	fd                   	std    
  801526:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801528:	eb 1d                	jmp    801547 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80152a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801532:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801536:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80153a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153e:	48 89 d7             	mov    %rdx,%rdi
  801541:	48 89 c1             	mov    %rax,%rcx
  801544:	fd                   	std    
  801545:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801547:	fc                   	cld    
  801548:	eb 57                	jmp    8015a1 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80154a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154e:	83 e0 03             	and    $0x3,%eax
  801551:	48 85 c0             	test   %rax,%rax
  801554:	75 36                	jne    80158c <memmove+0xfc>
  801556:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80155a:	83 e0 03             	and    $0x3,%eax
  80155d:	48 85 c0             	test   %rax,%rax
  801560:	75 2a                	jne    80158c <memmove+0xfc>
  801562:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801566:	83 e0 03             	and    $0x3,%eax
  801569:	48 85 c0             	test   %rax,%rax
  80156c:	75 1e                	jne    80158c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80156e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801572:	48 c1 e8 02          	shr    $0x2,%rax
  801576:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801579:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801581:	48 89 c7             	mov    %rax,%rdi
  801584:	48 89 d6             	mov    %rdx,%rsi
  801587:	fc                   	cld    
  801588:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80158a:	eb 15                	jmp    8015a1 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80158c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801590:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801594:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801598:	48 89 c7             	mov    %rax,%rdi
  80159b:	48 89 d6             	mov    %rdx,%rsi
  80159e:	fc                   	cld    
  80159f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8015a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015a5:	c9                   	leaveq 
  8015a6:	c3                   	retq   

00000000008015a7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015a7:	55                   	push   %rbp
  8015a8:	48 89 e5             	mov    %rsp,%rbp
  8015ab:	48 83 ec 18          	sub    $0x18,%rsp
  8015af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015b7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8015bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015bf:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8015c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c7:	48 89 ce             	mov    %rcx,%rsi
  8015ca:	48 89 c7             	mov    %rax,%rdi
  8015cd:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  8015d4:	00 00 00 
  8015d7:	ff d0                	callq  *%rax
}
  8015d9:	c9                   	leaveq 
  8015da:	c3                   	retq   

00000000008015db <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015db:	55                   	push   %rbp
  8015dc:	48 89 e5             	mov    %rsp,%rbp
  8015df:	48 83 ec 28          	sub    $0x28,%rsp
  8015e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8015f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8015ff:	eb 36                	jmp    801637 <memcmp+0x5c>
		if (*s1 != *s2)
  801601:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801605:	0f b6 10             	movzbl (%rax),%edx
  801608:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160c:	0f b6 00             	movzbl (%rax),%eax
  80160f:	38 c2                	cmp    %al,%dl
  801611:	74 1a                	je     80162d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801613:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801617:	0f b6 00             	movzbl (%rax),%eax
  80161a:	0f b6 d0             	movzbl %al,%edx
  80161d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801621:	0f b6 00             	movzbl (%rax),%eax
  801624:	0f b6 c0             	movzbl %al,%eax
  801627:	29 c2                	sub    %eax,%edx
  801629:	89 d0                	mov    %edx,%eax
  80162b:	eb 20                	jmp    80164d <memcmp+0x72>
		s1++, s2++;
  80162d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801632:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801637:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80163f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801643:	48 85 c0             	test   %rax,%rax
  801646:	75 b9                	jne    801601 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801648:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80164d:	c9                   	leaveq 
  80164e:	c3                   	retq   

000000000080164f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80164f:	55                   	push   %rbp
  801650:	48 89 e5             	mov    %rsp,%rbp
  801653:	48 83 ec 28          	sub    $0x28,%rsp
  801657:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80165b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80165e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801662:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801666:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80166a:	48 01 d0             	add    %rdx,%rax
  80166d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801671:	eb 15                	jmp    801688 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801673:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801677:	0f b6 10             	movzbl (%rax),%edx
  80167a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80167d:	38 c2                	cmp    %al,%dl
  80167f:	75 02                	jne    801683 <memfind+0x34>
			break;
  801681:	eb 0f                	jmp    801692 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801683:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801688:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80168c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801690:	72 e1                	jb     801673 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801692:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801696:	c9                   	leaveq 
  801697:	c3                   	retq   

0000000000801698 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801698:	55                   	push   %rbp
  801699:	48 89 e5             	mov    %rsp,%rbp
  80169c:	48 83 ec 34          	sub    $0x34,%rsp
  8016a0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016a4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016a8:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8016ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8016b2:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8016b9:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016ba:	eb 05                	jmp    8016c1 <strtol+0x29>
		s++;
  8016bc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c5:	0f b6 00             	movzbl (%rax),%eax
  8016c8:	3c 20                	cmp    $0x20,%al
  8016ca:	74 f0                	je     8016bc <strtol+0x24>
  8016cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d0:	0f b6 00             	movzbl (%rax),%eax
  8016d3:	3c 09                	cmp    $0x9,%al
  8016d5:	74 e5                	je     8016bc <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016db:	0f b6 00             	movzbl (%rax),%eax
  8016de:	3c 2b                	cmp    $0x2b,%al
  8016e0:	75 07                	jne    8016e9 <strtol+0x51>
		s++;
  8016e2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016e7:	eb 17                	jmp    801700 <strtol+0x68>
	else if (*s == '-')
  8016e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ed:	0f b6 00             	movzbl (%rax),%eax
  8016f0:	3c 2d                	cmp    $0x2d,%al
  8016f2:	75 0c                	jne    801700 <strtol+0x68>
		s++, neg = 1;
  8016f4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801700:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801704:	74 06                	je     80170c <strtol+0x74>
  801706:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80170a:	75 28                	jne    801734 <strtol+0x9c>
  80170c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801710:	0f b6 00             	movzbl (%rax),%eax
  801713:	3c 30                	cmp    $0x30,%al
  801715:	75 1d                	jne    801734 <strtol+0x9c>
  801717:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171b:	48 83 c0 01          	add    $0x1,%rax
  80171f:	0f b6 00             	movzbl (%rax),%eax
  801722:	3c 78                	cmp    $0x78,%al
  801724:	75 0e                	jne    801734 <strtol+0x9c>
		s += 2, base = 16;
  801726:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80172b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801732:	eb 2c                	jmp    801760 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801734:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801738:	75 19                	jne    801753 <strtol+0xbb>
  80173a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173e:	0f b6 00             	movzbl (%rax),%eax
  801741:	3c 30                	cmp    $0x30,%al
  801743:	75 0e                	jne    801753 <strtol+0xbb>
		s++, base = 8;
  801745:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80174a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801751:	eb 0d                	jmp    801760 <strtol+0xc8>
	else if (base == 0)
  801753:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801757:	75 07                	jne    801760 <strtol+0xc8>
		base = 10;
  801759:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801760:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801764:	0f b6 00             	movzbl (%rax),%eax
  801767:	3c 2f                	cmp    $0x2f,%al
  801769:	7e 1d                	jle    801788 <strtol+0xf0>
  80176b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176f:	0f b6 00             	movzbl (%rax),%eax
  801772:	3c 39                	cmp    $0x39,%al
  801774:	7f 12                	jg     801788 <strtol+0xf0>
			dig = *s - '0';
  801776:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177a:	0f b6 00             	movzbl (%rax),%eax
  80177d:	0f be c0             	movsbl %al,%eax
  801780:	83 e8 30             	sub    $0x30,%eax
  801783:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801786:	eb 4e                	jmp    8017d6 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801788:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178c:	0f b6 00             	movzbl (%rax),%eax
  80178f:	3c 60                	cmp    $0x60,%al
  801791:	7e 1d                	jle    8017b0 <strtol+0x118>
  801793:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801797:	0f b6 00             	movzbl (%rax),%eax
  80179a:	3c 7a                	cmp    $0x7a,%al
  80179c:	7f 12                	jg     8017b0 <strtol+0x118>
			dig = *s - 'a' + 10;
  80179e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a2:	0f b6 00             	movzbl (%rax),%eax
  8017a5:	0f be c0             	movsbl %al,%eax
  8017a8:	83 e8 57             	sub    $0x57,%eax
  8017ab:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017ae:	eb 26                	jmp    8017d6 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8017b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b4:	0f b6 00             	movzbl (%rax),%eax
  8017b7:	3c 40                	cmp    $0x40,%al
  8017b9:	7e 48                	jle    801803 <strtol+0x16b>
  8017bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bf:	0f b6 00             	movzbl (%rax),%eax
  8017c2:	3c 5a                	cmp    $0x5a,%al
  8017c4:	7f 3d                	jg     801803 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8017c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ca:	0f b6 00             	movzbl (%rax),%eax
  8017cd:	0f be c0             	movsbl %al,%eax
  8017d0:	83 e8 37             	sub    $0x37,%eax
  8017d3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017d9:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017dc:	7c 02                	jl     8017e0 <strtol+0x148>
			break;
  8017de:	eb 23                	jmp    801803 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8017e0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017e5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017e8:	48 98                	cltq   
  8017ea:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8017ef:	48 89 c2             	mov    %rax,%rdx
  8017f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017f5:	48 98                	cltq   
  8017f7:	48 01 d0             	add    %rdx,%rax
  8017fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8017fe:	e9 5d ff ff ff       	jmpq   801760 <strtol+0xc8>

	if (endptr)
  801803:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801808:	74 0b                	je     801815 <strtol+0x17d>
		*endptr = (char *) s;
  80180a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80180e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801812:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801815:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801819:	74 09                	je     801824 <strtol+0x18c>
  80181b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80181f:	48 f7 d8             	neg    %rax
  801822:	eb 04                	jmp    801828 <strtol+0x190>
  801824:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801828:	c9                   	leaveq 
  801829:	c3                   	retq   

000000000080182a <strstr>:

char * strstr(const char *in, const char *str)
{
  80182a:	55                   	push   %rbp
  80182b:	48 89 e5             	mov    %rsp,%rbp
  80182e:	48 83 ec 30          	sub    $0x30,%rsp
  801832:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801836:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80183a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80183e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801842:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801846:	0f b6 00             	movzbl (%rax),%eax
  801849:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80184c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801850:	75 06                	jne    801858 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801852:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801856:	eb 6b                	jmp    8018c3 <strstr+0x99>

	len = strlen(str);
  801858:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80185c:	48 89 c7             	mov    %rax,%rdi
  80185f:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  801866:	00 00 00 
  801869:	ff d0                	callq  *%rax
  80186b:	48 98                	cltq   
  80186d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801871:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801875:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801879:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80187d:	0f b6 00             	movzbl (%rax),%eax
  801880:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801883:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801887:	75 07                	jne    801890 <strstr+0x66>
				return (char *) 0;
  801889:	b8 00 00 00 00       	mov    $0x0,%eax
  80188e:	eb 33                	jmp    8018c3 <strstr+0x99>
		} while (sc != c);
  801890:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801894:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801897:	75 d8                	jne    801871 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801899:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80189d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8018a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a5:	48 89 ce             	mov    %rcx,%rsi
  8018a8:	48 89 c7             	mov    %rax,%rdi
  8018ab:	48 b8 21 13 80 00 00 	movabs $0x801321,%rax
  8018b2:	00 00 00 
  8018b5:	ff d0                	callq  *%rax
  8018b7:	85 c0                	test   %eax,%eax
  8018b9:	75 b6                	jne    801871 <strstr+0x47>

	return (char *) (in - 1);
  8018bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018bf:	48 83 e8 01          	sub    $0x1,%rax
}
  8018c3:	c9                   	leaveq 
  8018c4:	c3                   	retq   

00000000008018c5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8018c5:	55                   	push   %rbp
  8018c6:	48 89 e5             	mov    %rsp,%rbp
  8018c9:	53                   	push   %rbx
  8018ca:	48 83 ec 48          	sub    $0x48,%rsp
  8018ce:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018d1:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018d4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018d8:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018dc:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018e0:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018e4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018e7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018eb:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018ef:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8018f3:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8018f7:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8018fb:	4c 89 c3             	mov    %r8,%rbx
  8018fe:	cd 30                	int    $0x30
  801900:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801904:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801908:	74 3e                	je     801948 <syscall+0x83>
  80190a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80190f:	7e 37                	jle    801948 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801911:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801915:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801918:	49 89 d0             	mov    %rdx,%r8
  80191b:	89 c1                	mov    %eax,%ecx
  80191d:	48 ba 68 4b 80 00 00 	movabs $0x804b68,%rdx
  801924:	00 00 00 
  801927:	be 24 00 00 00       	mov    $0x24,%esi
  80192c:	48 bf 85 4b 80 00 00 	movabs $0x804b85,%rdi
  801933:	00 00 00 
  801936:	b8 00 00 00 00       	mov    $0x0,%eax
  80193b:	49 b9 7e 03 80 00 00 	movabs $0x80037e,%r9
  801942:	00 00 00 
  801945:	41 ff d1             	callq  *%r9

	return ret;
  801948:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80194c:	48 83 c4 48          	add    $0x48,%rsp
  801950:	5b                   	pop    %rbx
  801951:	5d                   	pop    %rbp
  801952:	c3                   	retq   

0000000000801953 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801953:	55                   	push   %rbp
  801954:	48 89 e5             	mov    %rsp,%rbp
  801957:	48 83 ec 20          	sub    $0x20,%rsp
  80195b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80195f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801963:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801967:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80196b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801972:	00 
  801973:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801979:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80197f:	48 89 d1             	mov    %rdx,%rcx
  801982:	48 89 c2             	mov    %rax,%rdx
  801985:	be 00 00 00 00       	mov    $0x0,%esi
  80198a:	bf 00 00 00 00       	mov    $0x0,%edi
  80198f:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801996:	00 00 00 
  801999:	ff d0                	callq  *%rax
}
  80199b:	c9                   	leaveq 
  80199c:	c3                   	retq   

000000000080199d <sys_cgetc>:

int
sys_cgetc(void)
{
  80199d:	55                   	push   %rbp
  80199e:	48 89 e5             	mov    %rsp,%rbp
  8019a1:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8019a5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ac:	00 
  8019ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019be:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c3:	be 00 00 00 00       	mov    $0x0,%esi
  8019c8:	bf 01 00 00 00       	mov    $0x1,%edi
  8019cd:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  8019d4:	00 00 00 
  8019d7:	ff d0                	callq  *%rax
}
  8019d9:	c9                   	leaveq 
  8019da:	c3                   	retq   

00000000008019db <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019db:	55                   	push   %rbp
  8019dc:	48 89 e5             	mov    %rsp,%rbp
  8019df:	48 83 ec 10          	sub    $0x10,%rsp
  8019e3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8019e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019e9:	48 98                	cltq   
  8019eb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019f2:	00 
  8019f3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019f9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a04:	48 89 c2             	mov    %rax,%rdx
  801a07:	be 01 00 00 00       	mov    $0x1,%esi
  801a0c:	bf 03 00 00 00       	mov    $0x3,%edi
  801a11:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801a18:	00 00 00 
  801a1b:	ff d0                	callq  *%rax
}
  801a1d:	c9                   	leaveq 
  801a1e:	c3                   	retq   

0000000000801a1f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a1f:	55                   	push   %rbp
  801a20:	48 89 e5             	mov    %rsp,%rbp
  801a23:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a27:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a2e:	00 
  801a2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a40:	ba 00 00 00 00       	mov    $0x0,%edx
  801a45:	be 00 00 00 00       	mov    $0x0,%esi
  801a4a:	bf 02 00 00 00       	mov    $0x2,%edi
  801a4f:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801a56:	00 00 00 
  801a59:	ff d0                	callq  *%rax
}
  801a5b:	c9                   	leaveq 
  801a5c:	c3                   	retq   

0000000000801a5d <sys_yield>:


void
sys_yield(void)
{
  801a5d:	55                   	push   %rbp
  801a5e:	48 89 e5             	mov    %rsp,%rbp
  801a61:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a65:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a6c:	00 
  801a6d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a73:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a79:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a7e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a83:	be 00 00 00 00       	mov    $0x0,%esi
  801a88:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a8d:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801a94:	00 00 00 
  801a97:	ff d0                	callq  *%rax
}
  801a99:	c9                   	leaveq 
  801a9a:	c3                   	retq   

0000000000801a9b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a9b:	55                   	push   %rbp
  801a9c:	48 89 e5             	mov    %rsp,%rbp
  801a9f:	48 83 ec 20          	sub    $0x20,%rsp
  801aa3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aa6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801aaa:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801aad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ab0:	48 63 c8             	movslq %eax,%rcx
  801ab3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aba:	48 98                	cltq   
  801abc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ac3:	00 
  801ac4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aca:	49 89 c8             	mov    %rcx,%r8
  801acd:	48 89 d1             	mov    %rdx,%rcx
  801ad0:	48 89 c2             	mov    %rax,%rdx
  801ad3:	be 01 00 00 00       	mov    $0x1,%esi
  801ad8:	bf 04 00 00 00       	mov    $0x4,%edi
  801add:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801ae4:	00 00 00 
  801ae7:	ff d0                	callq  *%rax
}
  801ae9:	c9                   	leaveq 
  801aea:	c3                   	retq   

0000000000801aeb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801aeb:	55                   	push   %rbp
  801aec:	48 89 e5             	mov    %rsp,%rbp
  801aef:	48 83 ec 30          	sub    $0x30,%rsp
  801af3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801af6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801afa:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801afd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b01:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b05:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b08:	48 63 c8             	movslq %eax,%rcx
  801b0b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b0f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b12:	48 63 f0             	movslq %eax,%rsi
  801b15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b1c:	48 98                	cltq   
  801b1e:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b22:	49 89 f9             	mov    %rdi,%r9
  801b25:	49 89 f0             	mov    %rsi,%r8
  801b28:	48 89 d1             	mov    %rdx,%rcx
  801b2b:	48 89 c2             	mov    %rax,%rdx
  801b2e:	be 01 00 00 00       	mov    $0x1,%esi
  801b33:	bf 05 00 00 00       	mov    $0x5,%edi
  801b38:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801b3f:	00 00 00 
  801b42:	ff d0                	callq  *%rax
}
  801b44:	c9                   	leaveq 
  801b45:	c3                   	retq   

0000000000801b46 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b46:	55                   	push   %rbp
  801b47:	48 89 e5             	mov    %rsp,%rbp
  801b4a:	48 83 ec 20          	sub    $0x20,%rsp
  801b4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b55:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b5c:	48 98                	cltq   
  801b5e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b65:	00 
  801b66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b72:	48 89 d1             	mov    %rdx,%rcx
  801b75:	48 89 c2             	mov    %rax,%rdx
  801b78:	be 01 00 00 00       	mov    $0x1,%esi
  801b7d:	bf 06 00 00 00       	mov    $0x6,%edi
  801b82:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801b89:	00 00 00 
  801b8c:	ff d0                	callq  *%rax
}
  801b8e:	c9                   	leaveq 
  801b8f:	c3                   	retq   

0000000000801b90 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b90:	55                   	push   %rbp
  801b91:	48 89 e5             	mov    %rsp,%rbp
  801b94:	48 83 ec 10          	sub    $0x10,%rsp
  801b98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b9b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ba1:	48 63 d0             	movslq %eax,%rdx
  801ba4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ba7:	48 98                	cltq   
  801ba9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb0:	00 
  801bb1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bb7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bbd:	48 89 d1             	mov    %rdx,%rcx
  801bc0:	48 89 c2             	mov    %rax,%rdx
  801bc3:	be 01 00 00 00       	mov    $0x1,%esi
  801bc8:	bf 08 00 00 00       	mov    $0x8,%edi
  801bcd:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801bd4:	00 00 00 
  801bd7:	ff d0                	callq  *%rax
}
  801bd9:	c9                   	leaveq 
  801bda:	c3                   	retq   

0000000000801bdb <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801bdb:	55                   	push   %rbp
  801bdc:	48 89 e5             	mov    %rsp,%rbp
  801bdf:	48 83 ec 20          	sub    $0x20,%rsp
  801be3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801be6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801bea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bf1:	48 98                	cltq   
  801bf3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bfa:	00 
  801bfb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c01:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c07:	48 89 d1             	mov    %rdx,%rcx
  801c0a:	48 89 c2             	mov    %rax,%rdx
  801c0d:	be 01 00 00 00       	mov    $0x1,%esi
  801c12:	bf 09 00 00 00       	mov    $0x9,%edi
  801c17:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801c1e:	00 00 00 
  801c21:	ff d0                	callq  *%rax
}
  801c23:	c9                   	leaveq 
  801c24:	c3                   	retq   

0000000000801c25 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c25:	55                   	push   %rbp
  801c26:	48 89 e5             	mov    %rsp,%rbp
  801c29:	48 83 ec 20          	sub    $0x20,%rsp
  801c2d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c30:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c34:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c3b:	48 98                	cltq   
  801c3d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c44:	00 
  801c45:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c4b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c51:	48 89 d1             	mov    %rdx,%rcx
  801c54:	48 89 c2             	mov    %rax,%rdx
  801c57:	be 01 00 00 00       	mov    $0x1,%esi
  801c5c:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c61:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801c68:	00 00 00 
  801c6b:	ff d0                	callq  *%rax
}
  801c6d:	c9                   	leaveq 
  801c6e:	c3                   	retq   

0000000000801c6f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c6f:	55                   	push   %rbp
  801c70:	48 89 e5             	mov    %rsp,%rbp
  801c73:	48 83 ec 20          	sub    $0x20,%rsp
  801c77:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c7a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c7e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c82:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c85:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c88:	48 63 f0             	movslq %eax,%rsi
  801c8b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c92:	48 98                	cltq   
  801c94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c98:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c9f:	00 
  801ca0:	49 89 f1             	mov    %rsi,%r9
  801ca3:	49 89 c8             	mov    %rcx,%r8
  801ca6:	48 89 d1             	mov    %rdx,%rcx
  801ca9:	48 89 c2             	mov    %rax,%rdx
  801cac:	be 00 00 00 00       	mov    $0x0,%esi
  801cb1:	bf 0c 00 00 00       	mov    $0xc,%edi
  801cb6:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801cbd:	00 00 00 
  801cc0:	ff d0                	callq  *%rax
}
  801cc2:	c9                   	leaveq 
  801cc3:	c3                   	retq   

0000000000801cc4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801cc4:	55                   	push   %rbp
  801cc5:	48 89 e5             	mov    %rsp,%rbp
  801cc8:	48 83 ec 10          	sub    $0x10,%rsp
  801ccc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801cd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cd4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cdb:	00 
  801cdc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ced:	48 89 c2             	mov    %rax,%rdx
  801cf0:	be 01 00 00 00       	mov    $0x1,%esi
  801cf5:	bf 0d 00 00 00       	mov    $0xd,%edi
  801cfa:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801d01:	00 00 00 
  801d04:	ff d0                	callq  *%rax
}
  801d06:	c9                   	leaveq 
  801d07:	c3                   	retq   

0000000000801d08 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801d08:	55                   	push   %rbp
  801d09:	48 89 e5             	mov    %rsp,%rbp
  801d0c:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d10:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d17:	00 
  801d18:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d1e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d24:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d29:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2e:	be 00 00 00 00       	mov    $0x0,%esi
  801d33:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d38:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801d3f:	00 00 00 
  801d42:	ff d0                	callq  *%rax
}
  801d44:	c9                   	leaveq 
  801d45:	c3                   	retq   

0000000000801d46 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801d46:	55                   	push   %rbp
  801d47:	48 89 e5             	mov    %rsp,%rbp
  801d4a:	48 83 ec 20          	sub    $0x20,%rsp
  801d4e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d52:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801d55:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801d58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d5c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d63:	00 
  801d64:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d6a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d70:	48 89 d1             	mov    %rdx,%rcx
  801d73:	48 89 c2             	mov    %rax,%rdx
  801d76:	be 00 00 00 00       	mov    $0x0,%esi
  801d7b:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d80:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801d87:	00 00 00 
  801d8a:	ff d0                	callq  *%rax
}
  801d8c:	c9                   	leaveq 
  801d8d:	c3                   	retq   

0000000000801d8e <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801d8e:	55                   	push   %rbp
  801d8f:	48 89 e5             	mov    %rsp,%rbp
  801d92:	48 83 ec 20          	sub    $0x20,%rsp
  801d96:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d9a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801d9d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801da0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801da4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dab:	00 
  801dac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801db2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801db8:	48 89 d1             	mov    %rdx,%rcx
  801dbb:	48 89 c2             	mov    %rax,%rdx
  801dbe:	be 00 00 00 00       	mov    $0x0,%esi
  801dc3:	bf 10 00 00 00       	mov    $0x10,%edi
  801dc8:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801dcf:	00 00 00 
  801dd2:	ff d0                	callq  *%rax
}
  801dd4:	c9                   	leaveq 
  801dd5:	c3                   	retq   

0000000000801dd6 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801dd6:	55                   	push   %rbp
  801dd7:	48 89 e5             	mov    %rsp,%rbp
  801dda:	48 83 ec 30          	sub    $0x30,%rsp
  801dde:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801de1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801de5:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801de8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801dec:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801df0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801df3:	48 63 c8             	movslq %eax,%rcx
  801df6:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801dfa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dfd:	48 63 f0             	movslq %eax,%rsi
  801e00:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e07:	48 98                	cltq   
  801e09:	48 89 0c 24          	mov    %rcx,(%rsp)
  801e0d:	49 89 f9             	mov    %rdi,%r9
  801e10:	49 89 f0             	mov    %rsi,%r8
  801e13:	48 89 d1             	mov    %rdx,%rcx
  801e16:	48 89 c2             	mov    %rax,%rdx
  801e19:	be 00 00 00 00       	mov    $0x0,%esi
  801e1e:	bf 11 00 00 00       	mov    $0x11,%edi
  801e23:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801e2a:	00 00 00 
  801e2d:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801e2f:	c9                   	leaveq 
  801e30:	c3                   	retq   

0000000000801e31 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801e31:	55                   	push   %rbp
  801e32:	48 89 e5             	mov    %rsp,%rbp
  801e35:	48 83 ec 20          	sub    $0x20,%rsp
  801e39:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e3d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801e41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e49:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e50:	00 
  801e51:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e57:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e5d:	48 89 d1             	mov    %rdx,%rcx
  801e60:	48 89 c2             	mov    %rax,%rdx
  801e63:	be 00 00 00 00       	mov    $0x0,%esi
  801e68:	bf 12 00 00 00       	mov    $0x12,%edi
  801e6d:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801e74:	00 00 00 
  801e77:	ff d0                	callq  *%rax
}
  801e79:	c9                   	leaveq 
  801e7a:	c3                   	retq   

0000000000801e7b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e7b:	55                   	push   %rbp
  801e7c:	48 89 e5             	mov    %rsp,%rbp
  801e7f:	48 83 ec 08          	sub    $0x8,%rsp
  801e83:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e87:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e8b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e92:	ff ff ff 
  801e95:	48 01 d0             	add    %rdx,%rax
  801e98:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e9c:	c9                   	leaveq 
  801e9d:	c3                   	retq   

0000000000801e9e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e9e:	55                   	push   %rbp
  801e9f:	48 89 e5             	mov    %rsp,%rbp
  801ea2:	48 83 ec 08          	sub    $0x8,%rsp
  801ea6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801eaa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eae:	48 89 c7             	mov    %rax,%rdi
  801eb1:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  801eb8:	00 00 00 
  801ebb:	ff d0                	callq  *%rax
  801ebd:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ec3:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ec7:	c9                   	leaveq 
  801ec8:	c3                   	retq   

0000000000801ec9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ec9:	55                   	push   %rbp
  801eca:	48 89 e5             	mov    %rsp,%rbp
  801ecd:	48 83 ec 18          	sub    $0x18,%rsp
  801ed1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ed5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801edc:	eb 6b                	jmp    801f49 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801ede:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ee1:	48 98                	cltq   
  801ee3:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ee9:	48 c1 e0 0c          	shl    $0xc,%rax
  801eed:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801ef1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ef5:	48 c1 e8 15          	shr    $0x15,%rax
  801ef9:	48 89 c2             	mov    %rax,%rdx
  801efc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f03:	01 00 00 
  801f06:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f0a:	83 e0 01             	and    $0x1,%eax
  801f0d:	48 85 c0             	test   %rax,%rax
  801f10:	74 21                	je     801f33 <fd_alloc+0x6a>
  801f12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f16:	48 c1 e8 0c          	shr    $0xc,%rax
  801f1a:	48 89 c2             	mov    %rax,%rdx
  801f1d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f24:	01 00 00 
  801f27:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f2b:	83 e0 01             	and    $0x1,%eax
  801f2e:	48 85 c0             	test   %rax,%rax
  801f31:	75 12                	jne    801f45 <fd_alloc+0x7c>
			*fd_store = fd;
  801f33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f3b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f43:	eb 1a                	jmp    801f5f <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f45:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f49:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f4d:	7e 8f                	jle    801ede <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f53:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f5a:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f5f:	c9                   	leaveq 
  801f60:	c3                   	retq   

0000000000801f61 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f61:	55                   	push   %rbp
  801f62:	48 89 e5             	mov    %rsp,%rbp
  801f65:	48 83 ec 20          	sub    $0x20,%rsp
  801f69:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f6c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f70:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f74:	78 06                	js     801f7c <fd_lookup+0x1b>
  801f76:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f7a:	7e 07                	jle    801f83 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f81:	eb 6c                	jmp    801fef <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f83:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f86:	48 98                	cltq   
  801f88:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f8e:	48 c1 e0 0c          	shl    $0xc,%rax
  801f92:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f9a:	48 c1 e8 15          	shr    $0x15,%rax
  801f9e:	48 89 c2             	mov    %rax,%rdx
  801fa1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fa8:	01 00 00 
  801fab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801faf:	83 e0 01             	and    $0x1,%eax
  801fb2:	48 85 c0             	test   %rax,%rax
  801fb5:	74 21                	je     801fd8 <fd_lookup+0x77>
  801fb7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fbb:	48 c1 e8 0c          	shr    $0xc,%rax
  801fbf:	48 89 c2             	mov    %rax,%rdx
  801fc2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fc9:	01 00 00 
  801fcc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fd0:	83 e0 01             	and    $0x1,%eax
  801fd3:	48 85 c0             	test   %rax,%rax
  801fd6:	75 07                	jne    801fdf <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fd8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fdd:	eb 10                	jmp    801fef <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801fdf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fe3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801fe7:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801fea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fef:	c9                   	leaveq 
  801ff0:	c3                   	retq   

0000000000801ff1 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ff1:	55                   	push   %rbp
  801ff2:	48 89 e5             	mov    %rsp,%rbp
  801ff5:	48 83 ec 30          	sub    $0x30,%rsp
  801ff9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ffd:	89 f0                	mov    %esi,%eax
  801fff:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802002:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802006:	48 89 c7             	mov    %rax,%rdi
  802009:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  802010:	00 00 00 
  802013:	ff d0                	callq  *%rax
  802015:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802019:	48 89 d6             	mov    %rdx,%rsi
  80201c:	89 c7                	mov    %eax,%edi
  80201e:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  802025:	00 00 00 
  802028:	ff d0                	callq  *%rax
  80202a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80202d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802031:	78 0a                	js     80203d <fd_close+0x4c>
	    || fd != fd2)
  802033:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802037:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80203b:	74 12                	je     80204f <fd_close+0x5e>
		return (must_exist ? r : 0);
  80203d:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802041:	74 05                	je     802048 <fd_close+0x57>
  802043:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802046:	eb 05                	jmp    80204d <fd_close+0x5c>
  802048:	b8 00 00 00 00       	mov    $0x0,%eax
  80204d:	eb 69                	jmp    8020b8 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80204f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802053:	8b 00                	mov    (%rax),%eax
  802055:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802059:	48 89 d6             	mov    %rdx,%rsi
  80205c:	89 c7                	mov    %eax,%edi
  80205e:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  802065:	00 00 00 
  802068:	ff d0                	callq  *%rax
  80206a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80206d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802071:	78 2a                	js     80209d <fd_close+0xac>
		if (dev->dev_close)
  802073:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802077:	48 8b 40 20          	mov    0x20(%rax),%rax
  80207b:	48 85 c0             	test   %rax,%rax
  80207e:	74 16                	je     802096 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802080:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802084:	48 8b 40 20          	mov    0x20(%rax),%rax
  802088:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80208c:	48 89 d7             	mov    %rdx,%rdi
  80208f:	ff d0                	callq  *%rax
  802091:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802094:	eb 07                	jmp    80209d <fd_close+0xac>
		else
			r = 0;
  802096:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80209d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020a1:	48 89 c6             	mov    %rax,%rsi
  8020a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a9:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  8020b0:	00 00 00 
  8020b3:	ff d0                	callq  *%rax
	return r;
  8020b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020b8:	c9                   	leaveq 
  8020b9:	c3                   	retq   

00000000008020ba <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020ba:	55                   	push   %rbp
  8020bb:	48 89 e5             	mov    %rsp,%rbp
  8020be:	48 83 ec 20          	sub    $0x20,%rsp
  8020c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8020c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020d0:	eb 41                	jmp    802113 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8020d2:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020d9:	00 00 00 
  8020dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020df:	48 63 d2             	movslq %edx,%rdx
  8020e2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020e6:	8b 00                	mov    (%rax),%eax
  8020e8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8020eb:	75 22                	jne    80210f <dev_lookup+0x55>
			*dev = devtab[i];
  8020ed:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020f4:	00 00 00 
  8020f7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020fa:	48 63 d2             	movslq %edx,%rdx
  8020fd:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802101:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802105:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802108:	b8 00 00 00 00       	mov    $0x0,%eax
  80210d:	eb 60                	jmp    80216f <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80210f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802113:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80211a:	00 00 00 
  80211d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802120:	48 63 d2             	movslq %edx,%rdx
  802123:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802127:	48 85 c0             	test   %rax,%rax
  80212a:	75 a6                	jne    8020d2 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80212c:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802133:	00 00 00 
  802136:	48 8b 00             	mov    (%rax),%rax
  802139:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80213f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802142:	89 c6                	mov    %eax,%esi
  802144:	48 bf 98 4b 80 00 00 	movabs $0x804b98,%rdi
  80214b:	00 00 00 
  80214e:	b8 00 00 00 00       	mov    $0x0,%eax
  802153:	48 b9 b7 05 80 00 00 	movabs $0x8005b7,%rcx
  80215a:	00 00 00 
  80215d:	ff d1                	callq  *%rcx
	*dev = 0;
  80215f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802163:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80216a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80216f:	c9                   	leaveq 
  802170:	c3                   	retq   

0000000000802171 <close>:

int
close(int fdnum)
{
  802171:	55                   	push   %rbp
  802172:	48 89 e5             	mov    %rsp,%rbp
  802175:	48 83 ec 20          	sub    $0x20,%rsp
  802179:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80217c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802180:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802183:	48 89 d6             	mov    %rdx,%rsi
  802186:	89 c7                	mov    %eax,%edi
  802188:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  80218f:	00 00 00 
  802192:	ff d0                	callq  *%rax
  802194:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802197:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80219b:	79 05                	jns    8021a2 <close+0x31>
		return r;
  80219d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a0:	eb 18                	jmp    8021ba <close+0x49>
	else
		return fd_close(fd, 1);
  8021a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021a6:	be 01 00 00 00       	mov    $0x1,%esi
  8021ab:	48 89 c7             	mov    %rax,%rdi
  8021ae:	48 b8 f1 1f 80 00 00 	movabs $0x801ff1,%rax
  8021b5:	00 00 00 
  8021b8:	ff d0                	callq  *%rax
}
  8021ba:	c9                   	leaveq 
  8021bb:	c3                   	retq   

00000000008021bc <close_all>:

void
close_all(void)
{
  8021bc:	55                   	push   %rbp
  8021bd:	48 89 e5             	mov    %rsp,%rbp
  8021c0:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021cb:	eb 15                	jmp    8021e2 <close_all+0x26>
		close(i);
  8021cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021d0:	89 c7                	mov    %eax,%edi
  8021d2:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  8021d9:	00 00 00 
  8021dc:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8021de:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021e2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021e6:	7e e5                	jle    8021cd <close_all+0x11>
		close(i);
}
  8021e8:	c9                   	leaveq 
  8021e9:	c3                   	retq   

00000000008021ea <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8021ea:	55                   	push   %rbp
  8021eb:	48 89 e5             	mov    %rsp,%rbp
  8021ee:	48 83 ec 40          	sub    $0x40,%rsp
  8021f2:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8021f5:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8021f8:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8021fc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021ff:	48 89 d6             	mov    %rdx,%rsi
  802202:	89 c7                	mov    %eax,%edi
  802204:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  80220b:	00 00 00 
  80220e:	ff d0                	callq  *%rax
  802210:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802213:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802217:	79 08                	jns    802221 <dup+0x37>
		return r;
  802219:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80221c:	e9 70 01 00 00       	jmpq   802391 <dup+0x1a7>
	close(newfdnum);
  802221:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802224:	89 c7                	mov    %eax,%edi
  802226:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  80222d:	00 00 00 
  802230:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802232:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802235:	48 98                	cltq   
  802237:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80223d:	48 c1 e0 0c          	shl    $0xc,%rax
  802241:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802245:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802249:	48 89 c7             	mov    %rax,%rdi
  80224c:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  802253:	00 00 00 
  802256:	ff d0                	callq  *%rax
  802258:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80225c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802260:	48 89 c7             	mov    %rax,%rdi
  802263:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  80226a:	00 00 00 
  80226d:	ff d0                	callq  *%rax
  80226f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802273:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802277:	48 c1 e8 15          	shr    $0x15,%rax
  80227b:	48 89 c2             	mov    %rax,%rdx
  80227e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802285:	01 00 00 
  802288:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80228c:	83 e0 01             	and    $0x1,%eax
  80228f:	48 85 c0             	test   %rax,%rax
  802292:	74 73                	je     802307 <dup+0x11d>
  802294:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802298:	48 c1 e8 0c          	shr    $0xc,%rax
  80229c:	48 89 c2             	mov    %rax,%rdx
  80229f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022a6:	01 00 00 
  8022a9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022ad:	83 e0 01             	and    $0x1,%eax
  8022b0:	48 85 c0             	test   %rax,%rax
  8022b3:	74 52                	je     802307 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8022b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b9:	48 c1 e8 0c          	shr    $0xc,%rax
  8022bd:	48 89 c2             	mov    %rax,%rdx
  8022c0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022c7:	01 00 00 
  8022ca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022ce:	25 07 0e 00 00       	and    $0xe07,%eax
  8022d3:	89 c1                	mov    %eax,%ecx
  8022d5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022dd:	41 89 c8             	mov    %ecx,%r8d
  8022e0:	48 89 d1             	mov    %rdx,%rcx
  8022e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e8:	48 89 c6             	mov    %rax,%rsi
  8022eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8022f0:	48 b8 eb 1a 80 00 00 	movabs $0x801aeb,%rax
  8022f7:	00 00 00 
  8022fa:	ff d0                	callq  *%rax
  8022fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802303:	79 02                	jns    802307 <dup+0x11d>
			goto err;
  802305:	eb 57                	jmp    80235e <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802307:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80230b:	48 c1 e8 0c          	shr    $0xc,%rax
  80230f:	48 89 c2             	mov    %rax,%rdx
  802312:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802319:	01 00 00 
  80231c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802320:	25 07 0e 00 00       	and    $0xe07,%eax
  802325:	89 c1                	mov    %eax,%ecx
  802327:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80232b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80232f:	41 89 c8             	mov    %ecx,%r8d
  802332:	48 89 d1             	mov    %rdx,%rcx
  802335:	ba 00 00 00 00       	mov    $0x0,%edx
  80233a:	48 89 c6             	mov    %rax,%rsi
  80233d:	bf 00 00 00 00       	mov    $0x0,%edi
  802342:	48 b8 eb 1a 80 00 00 	movabs $0x801aeb,%rax
  802349:	00 00 00 
  80234c:	ff d0                	callq  *%rax
  80234e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802351:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802355:	79 02                	jns    802359 <dup+0x16f>
		goto err;
  802357:	eb 05                	jmp    80235e <dup+0x174>

	return newfdnum;
  802359:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80235c:	eb 33                	jmp    802391 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80235e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802362:	48 89 c6             	mov    %rax,%rsi
  802365:	bf 00 00 00 00       	mov    $0x0,%edi
  80236a:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  802371:	00 00 00 
  802374:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802376:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80237a:	48 89 c6             	mov    %rax,%rsi
  80237d:	bf 00 00 00 00       	mov    $0x0,%edi
  802382:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  802389:	00 00 00 
  80238c:	ff d0                	callq  *%rax
	return r;
  80238e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802391:	c9                   	leaveq 
  802392:	c3                   	retq   

0000000000802393 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802393:	55                   	push   %rbp
  802394:	48 89 e5             	mov    %rsp,%rbp
  802397:	48 83 ec 40          	sub    $0x40,%rsp
  80239b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80239e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023a2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023a6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023aa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023ad:	48 89 d6             	mov    %rdx,%rsi
  8023b0:	89 c7                	mov    %eax,%edi
  8023b2:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  8023b9:	00 00 00 
  8023bc:	ff d0                	callq  *%rax
  8023be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c5:	78 24                	js     8023eb <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023cb:	8b 00                	mov    (%rax),%eax
  8023cd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023d1:	48 89 d6             	mov    %rdx,%rsi
  8023d4:	89 c7                	mov    %eax,%edi
  8023d6:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  8023dd:	00 00 00 
  8023e0:	ff d0                	callq  *%rax
  8023e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e9:	79 05                	jns    8023f0 <read+0x5d>
		return r;
  8023eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ee:	eb 76                	jmp    802466 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8023f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f4:	8b 40 08             	mov    0x8(%rax),%eax
  8023f7:	83 e0 03             	and    $0x3,%eax
  8023fa:	83 f8 01             	cmp    $0x1,%eax
  8023fd:	75 3a                	jne    802439 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8023ff:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802406:	00 00 00 
  802409:	48 8b 00             	mov    (%rax),%rax
  80240c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802412:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802415:	89 c6                	mov    %eax,%esi
  802417:	48 bf b7 4b 80 00 00 	movabs $0x804bb7,%rdi
  80241e:	00 00 00 
  802421:	b8 00 00 00 00       	mov    $0x0,%eax
  802426:	48 b9 b7 05 80 00 00 	movabs $0x8005b7,%rcx
  80242d:	00 00 00 
  802430:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802432:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802437:	eb 2d                	jmp    802466 <read+0xd3>
	}
	if (!dev->dev_read)
  802439:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80243d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802441:	48 85 c0             	test   %rax,%rax
  802444:	75 07                	jne    80244d <read+0xba>
		return -E_NOT_SUPP;
  802446:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80244b:	eb 19                	jmp    802466 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80244d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802451:	48 8b 40 10          	mov    0x10(%rax),%rax
  802455:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802459:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80245d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802461:	48 89 cf             	mov    %rcx,%rdi
  802464:	ff d0                	callq  *%rax
}
  802466:	c9                   	leaveq 
  802467:	c3                   	retq   

0000000000802468 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802468:	55                   	push   %rbp
  802469:	48 89 e5             	mov    %rsp,%rbp
  80246c:	48 83 ec 30          	sub    $0x30,%rsp
  802470:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802473:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802477:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80247b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802482:	eb 49                	jmp    8024cd <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802484:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802487:	48 98                	cltq   
  802489:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80248d:	48 29 c2             	sub    %rax,%rdx
  802490:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802493:	48 63 c8             	movslq %eax,%rcx
  802496:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80249a:	48 01 c1             	add    %rax,%rcx
  80249d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024a0:	48 89 ce             	mov    %rcx,%rsi
  8024a3:	89 c7                	mov    %eax,%edi
  8024a5:	48 b8 93 23 80 00 00 	movabs $0x802393,%rax
  8024ac:	00 00 00 
  8024af:	ff d0                	callq  *%rax
  8024b1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8024b4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024b8:	79 05                	jns    8024bf <readn+0x57>
			return m;
  8024ba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024bd:	eb 1c                	jmp    8024db <readn+0x73>
		if (m == 0)
  8024bf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024c3:	75 02                	jne    8024c7 <readn+0x5f>
			break;
  8024c5:	eb 11                	jmp    8024d8 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024ca:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d0:	48 98                	cltq   
  8024d2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8024d6:	72 ac                	jb     802484 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8024d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024db:	c9                   	leaveq 
  8024dc:	c3                   	retq   

00000000008024dd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8024dd:	55                   	push   %rbp
  8024de:	48 89 e5             	mov    %rsp,%rbp
  8024e1:	48 83 ec 40          	sub    $0x40,%rsp
  8024e5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024e8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024ec:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024f0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024f4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024f7:	48 89 d6             	mov    %rdx,%rsi
  8024fa:	89 c7                	mov    %eax,%edi
  8024fc:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  802503:	00 00 00 
  802506:	ff d0                	callq  *%rax
  802508:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80250b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250f:	78 24                	js     802535 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802511:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802515:	8b 00                	mov    (%rax),%eax
  802517:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80251b:	48 89 d6             	mov    %rdx,%rsi
  80251e:	89 c7                	mov    %eax,%edi
  802520:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  802527:	00 00 00 
  80252a:	ff d0                	callq  *%rax
  80252c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802533:	79 05                	jns    80253a <write+0x5d>
		return r;
  802535:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802538:	eb 75                	jmp    8025af <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80253a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80253e:	8b 40 08             	mov    0x8(%rax),%eax
  802541:	83 e0 03             	and    $0x3,%eax
  802544:	85 c0                	test   %eax,%eax
  802546:	75 3a                	jne    802582 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802548:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80254f:	00 00 00 
  802552:	48 8b 00             	mov    (%rax),%rax
  802555:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80255b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80255e:	89 c6                	mov    %eax,%esi
  802560:	48 bf d3 4b 80 00 00 	movabs $0x804bd3,%rdi
  802567:	00 00 00 
  80256a:	b8 00 00 00 00       	mov    $0x0,%eax
  80256f:	48 b9 b7 05 80 00 00 	movabs $0x8005b7,%rcx
  802576:	00 00 00 
  802579:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80257b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802580:	eb 2d                	jmp    8025af <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802582:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802586:	48 8b 40 18          	mov    0x18(%rax),%rax
  80258a:	48 85 c0             	test   %rax,%rax
  80258d:	75 07                	jne    802596 <write+0xb9>
		return -E_NOT_SUPP;
  80258f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802594:	eb 19                	jmp    8025af <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802596:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80259a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80259e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025a2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025a6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025aa:	48 89 cf             	mov    %rcx,%rdi
  8025ad:	ff d0                	callq  *%rax
}
  8025af:	c9                   	leaveq 
  8025b0:	c3                   	retq   

00000000008025b1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8025b1:	55                   	push   %rbp
  8025b2:	48 89 e5             	mov    %rsp,%rbp
  8025b5:	48 83 ec 18          	sub    $0x18,%rsp
  8025b9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025bc:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025bf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025c6:	48 89 d6             	mov    %rdx,%rsi
  8025c9:	89 c7                	mov    %eax,%edi
  8025cb:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  8025d2:	00 00 00 
  8025d5:	ff d0                	callq  *%rax
  8025d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025de:	79 05                	jns    8025e5 <seek+0x34>
		return r;
  8025e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e3:	eb 0f                	jmp    8025f4 <seek+0x43>
	fd->fd_offset = offset;
  8025e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8025ec:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8025ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f4:	c9                   	leaveq 
  8025f5:	c3                   	retq   

00000000008025f6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025f6:	55                   	push   %rbp
  8025f7:	48 89 e5             	mov    %rsp,%rbp
  8025fa:	48 83 ec 30          	sub    $0x30,%rsp
  8025fe:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802601:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802604:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802608:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80260b:	48 89 d6             	mov    %rdx,%rsi
  80260e:	89 c7                	mov    %eax,%edi
  802610:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  802617:	00 00 00 
  80261a:	ff d0                	callq  *%rax
  80261c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802623:	78 24                	js     802649 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802625:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802629:	8b 00                	mov    (%rax),%eax
  80262b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80262f:	48 89 d6             	mov    %rdx,%rsi
  802632:	89 c7                	mov    %eax,%edi
  802634:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  80263b:	00 00 00 
  80263e:	ff d0                	callq  *%rax
  802640:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802643:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802647:	79 05                	jns    80264e <ftruncate+0x58>
		return r;
  802649:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264c:	eb 72                	jmp    8026c0 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80264e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802652:	8b 40 08             	mov    0x8(%rax),%eax
  802655:	83 e0 03             	and    $0x3,%eax
  802658:	85 c0                	test   %eax,%eax
  80265a:	75 3a                	jne    802696 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80265c:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802663:	00 00 00 
  802666:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802669:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80266f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802672:	89 c6                	mov    %eax,%esi
  802674:	48 bf f0 4b 80 00 00 	movabs $0x804bf0,%rdi
  80267b:	00 00 00 
  80267e:	b8 00 00 00 00       	mov    $0x0,%eax
  802683:	48 b9 b7 05 80 00 00 	movabs $0x8005b7,%rcx
  80268a:	00 00 00 
  80268d:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80268f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802694:	eb 2a                	jmp    8026c0 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802696:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80269a:	48 8b 40 30          	mov    0x30(%rax),%rax
  80269e:	48 85 c0             	test   %rax,%rax
  8026a1:	75 07                	jne    8026aa <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8026a3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026a8:	eb 16                	jmp    8026c0 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8026aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ae:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026b6:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8026b9:	89 ce                	mov    %ecx,%esi
  8026bb:	48 89 d7             	mov    %rdx,%rdi
  8026be:	ff d0                	callq  *%rax
}
  8026c0:	c9                   	leaveq 
  8026c1:	c3                   	retq   

00000000008026c2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8026c2:	55                   	push   %rbp
  8026c3:	48 89 e5             	mov    %rsp,%rbp
  8026c6:	48 83 ec 30          	sub    $0x30,%rsp
  8026ca:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026cd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026d1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026d5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026d8:	48 89 d6             	mov    %rdx,%rsi
  8026db:	89 c7                	mov    %eax,%edi
  8026dd:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  8026e4:	00 00 00 
  8026e7:	ff d0                	callq  *%rax
  8026e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f0:	78 24                	js     802716 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f6:	8b 00                	mov    (%rax),%eax
  8026f8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026fc:	48 89 d6             	mov    %rdx,%rsi
  8026ff:	89 c7                	mov    %eax,%edi
  802701:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  802708:	00 00 00 
  80270b:	ff d0                	callq  *%rax
  80270d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802710:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802714:	79 05                	jns    80271b <fstat+0x59>
		return r;
  802716:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802719:	eb 5e                	jmp    802779 <fstat+0xb7>
	if (!dev->dev_stat)
  80271b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80271f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802723:	48 85 c0             	test   %rax,%rax
  802726:	75 07                	jne    80272f <fstat+0x6d>
		return -E_NOT_SUPP;
  802728:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80272d:	eb 4a                	jmp    802779 <fstat+0xb7>
	stat->st_name[0] = 0;
  80272f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802733:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802736:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80273a:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802741:	00 00 00 
	stat->st_isdir = 0;
  802744:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802748:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80274f:	00 00 00 
	stat->st_dev = dev;
  802752:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802756:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80275a:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802761:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802765:	48 8b 40 28          	mov    0x28(%rax),%rax
  802769:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80276d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802771:	48 89 ce             	mov    %rcx,%rsi
  802774:	48 89 d7             	mov    %rdx,%rdi
  802777:	ff d0                	callq  *%rax
}
  802779:	c9                   	leaveq 
  80277a:	c3                   	retq   

000000000080277b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80277b:	55                   	push   %rbp
  80277c:	48 89 e5             	mov    %rsp,%rbp
  80277f:	48 83 ec 20          	sub    $0x20,%rsp
  802783:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802787:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80278b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278f:	be 00 00 00 00       	mov    $0x0,%esi
  802794:	48 89 c7             	mov    %rax,%rdi
  802797:	48 b8 69 28 80 00 00 	movabs $0x802869,%rax
  80279e:	00 00 00 
  8027a1:	ff d0                	callq  *%rax
  8027a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027aa:	79 05                	jns    8027b1 <stat+0x36>
		return fd;
  8027ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027af:	eb 2f                	jmp    8027e0 <stat+0x65>
	r = fstat(fd, stat);
  8027b1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b8:	48 89 d6             	mov    %rdx,%rsi
  8027bb:	89 c7                	mov    %eax,%edi
  8027bd:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  8027c4:	00 00 00 
  8027c7:	ff d0                	callq  *%rax
  8027c9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8027cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027cf:	89 c7                	mov    %eax,%edi
  8027d1:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  8027d8:	00 00 00 
  8027db:	ff d0                	callq  *%rax
	return r;
  8027dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8027e0:	c9                   	leaveq 
  8027e1:	c3                   	retq   

00000000008027e2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8027e2:	55                   	push   %rbp
  8027e3:	48 89 e5             	mov    %rsp,%rbp
  8027e6:	48 83 ec 10          	sub    $0x10,%rsp
  8027ea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8027f1:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8027f8:	00 00 00 
  8027fb:	8b 00                	mov    (%rax),%eax
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	75 1d                	jne    80281e <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802801:	bf 01 00 00 00       	mov    $0x1,%edi
  802806:	48 b8 ff 44 80 00 00 	movabs $0x8044ff,%rax
  80280d:	00 00 00 
  802810:	ff d0                	callq  *%rax
  802812:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  802819:	00 00 00 
  80281c:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80281e:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802825:	00 00 00 
  802828:	8b 00                	mov    (%rax),%eax
  80282a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80282d:	b9 07 00 00 00       	mov    $0x7,%ecx
  802832:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802839:	00 00 00 
  80283c:	89 c7                	mov    %eax,%edi
  80283e:	48 b8 f3 42 80 00 00 	movabs $0x8042f3,%rax
  802845:	00 00 00 
  802848:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80284a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284e:	ba 00 00 00 00       	mov    $0x0,%edx
  802853:	48 89 c6             	mov    %rax,%rsi
  802856:	bf 00 00 00 00       	mov    $0x0,%edi
  80285b:	48 b8 32 42 80 00 00 	movabs $0x804232,%rax
  802862:	00 00 00 
  802865:	ff d0                	callq  *%rax
}
  802867:	c9                   	leaveq 
  802868:	c3                   	retq   

0000000000802869 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802869:	55                   	push   %rbp
  80286a:	48 89 e5             	mov    %rsp,%rbp
  80286d:	48 83 ec 20          	sub    $0x20,%rsp
  802871:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802875:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802878:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80287c:	48 89 c7             	mov    %rax,%rdi
  80287f:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  802886:	00 00 00 
  802889:	ff d0                	callq  *%rax
  80288b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802890:	7e 0a                	jle    80289c <open+0x33>
		return -E_BAD_PATH;
  802892:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802897:	e9 a5 00 00 00       	jmpq   802941 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80289c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8028a0:	48 89 c7             	mov    %rax,%rdi
  8028a3:	48 b8 c9 1e 80 00 00 	movabs $0x801ec9,%rax
  8028aa:	00 00 00 
  8028ad:	ff d0                	callq  *%rax
  8028af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b6:	79 08                	jns    8028c0 <open+0x57>
		return r;
  8028b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028bb:	e9 81 00 00 00       	jmpq   802941 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8028c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c4:	48 89 c6             	mov    %rax,%rsi
  8028c7:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8028ce:	00 00 00 
  8028d1:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  8028d8:	00 00 00 
  8028db:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8028dd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028e4:	00 00 00 
  8028e7:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8028ea:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8028f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028f4:	48 89 c6             	mov    %rax,%rsi
  8028f7:	bf 01 00 00 00       	mov    $0x1,%edi
  8028fc:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802903:	00 00 00 
  802906:	ff d0                	callq  *%rax
  802908:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80290b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80290f:	79 1d                	jns    80292e <open+0xc5>
		fd_close(fd, 0);
  802911:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802915:	be 00 00 00 00       	mov    $0x0,%esi
  80291a:	48 89 c7             	mov    %rax,%rdi
  80291d:	48 b8 f1 1f 80 00 00 	movabs $0x801ff1,%rax
  802924:	00 00 00 
  802927:	ff d0                	callq  *%rax
		return r;
  802929:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80292c:	eb 13                	jmp    802941 <open+0xd8>
	}

	return fd2num(fd);
  80292e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802932:	48 89 c7             	mov    %rax,%rdi
  802935:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  80293c:	00 00 00 
  80293f:	ff d0                	callq  *%rax

}
  802941:	c9                   	leaveq 
  802942:	c3                   	retq   

0000000000802943 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802943:	55                   	push   %rbp
  802944:	48 89 e5             	mov    %rsp,%rbp
  802947:	48 83 ec 10          	sub    $0x10,%rsp
  80294b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80294f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802953:	8b 50 0c             	mov    0xc(%rax),%edx
  802956:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80295d:	00 00 00 
  802960:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802962:	be 00 00 00 00       	mov    $0x0,%esi
  802967:	bf 06 00 00 00       	mov    $0x6,%edi
  80296c:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802973:	00 00 00 
  802976:	ff d0                	callq  *%rax
}
  802978:	c9                   	leaveq 
  802979:	c3                   	retq   

000000000080297a <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80297a:	55                   	push   %rbp
  80297b:	48 89 e5             	mov    %rsp,%rbp
  80297e:	48 83 ec 30          	sub    $0x30,%rsp
  802982:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802986:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80298a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80298e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802992:	8b 50 0c             	mov    0xc(%rax),%edx
  802995:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80299c:	00 00 00 
  80299f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8029a1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029a8:	00 00 00 
  8029ab:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029af:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8029b3:	be 00 00 00 00       	mov    $0x0,%esi
  8029b8:	bf 03 00 00 00       	mov    $0x3,%edi
  8029bd:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  8029c4:	00 00 00 
  8029c7:	ff d0                	callq  *%rax
  8029c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d0:	79 08                	jns    8029da <devfile_read+0x60>
		return r;
  8029d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d5:	e9 a4 00 00 00       	jmpq   802a7e <devfile_read+0x104>
	assert(r <= n);
  8029da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029dd:	48 98                	cltq   
  8029df:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8029e3:	76 35                	jbe    802a1a <devfile_read+0xa0>
  8029e5:	48 b9 16 4c 80 00 00 	movabs $0x804c16,%rcx
  8029ec:	00 00 00 
  8029ef:	48 ba 1d 4c 80 00 00 	movabs $0x804c1d,%rdx
  8029f6:	00 00 00 
  8029f9:	be 86 00 00 00       	mov    $0x86,%esi
  8029fe:	48 bf 32 4c 80 00 00 	movabs $0x804c32,%rdi
  802a05:	00 00 00 
  802a08:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0d:	49 b8 7e 03 80 00 00 	movabs $0x80037e,%r8
  802a14:	00 00 00 
  802a17:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802a1a:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802a21:	7e 35                	jle    802a58 <devfile_read+0xde>
  802a23:	48 b9 3d 4c 80 00 00 	movabs $0x804c3d,%rcx
  802a2a:	00 00 00 
  802a2d:	48 ba 1d 4c 80 00 00 	movabs $0x804c1d,%rdx
  802a34:	00 00 00 
  802a37:	be 87 00 00 00       	mov    $0x87,%esi
  802a3c:	48 bf 32 4c 80 00 00 	movabs $0x804c32,%rdi
  802a43:	00 00 00 
  802a46:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4b:	49 b8 7e 03 80 00 00 	movabs $0x80037e,%r8
  802a52:	00 00 00 
  802a55:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  802a58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a5b:	48 63 d0             	movslq %eax,%rdx
  802a5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a62:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a69:	00 00 00 
  802a6c:	48 89 c7             	mov    %rax,%rdi
  802a6f:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  802a76:	00 00 00 
  802a79:	ff d0                	callq  *%rax
	return r;
  802a7b:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802a7e:	c9                   	leaveq 
  802a7f:	c3                   	retq   

0000000000802a80 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802a80:	55                   	push   %rbp
  802a81:	48 89 e5             	mov    %rsp,%rbp
  802a84:	48 83 ec 40          	sub    $0x40,%rsp
  802a88:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802a8c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a90:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802a94:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a98:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802a9c:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802aa3:	00 
  802aa4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aa8:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802aac:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802ab1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802ab5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ab9:	8b 50 0c             	mov    0xc(%rax),%edx
  802abc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ac3:	00 00 00 
  802ac6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802ac8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802acf:	00 00 00 
  802ad2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ad6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802ada:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ade:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ae2:	48 89 c6             	mov    %rax,%rsi
  802ae5:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802aec:	00 00 00 
  802aef:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  802af6:	00 00 00 
  802af9:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802afb:	be 00 00 00 00       	mov    $0x0,%esi
  802b00:	bf 04 00 00 00       	mov    $0x4,%edi
  802b05:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802b0c:	00 00 00 
  802b0f:	ff d0                	callq  *%rax
  802b11:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b14:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b18:	79 05                	jns    802b1f <devfile_write+0x9f>
		return r;
  802b1a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b1d:	eb 43                	jmp    802b62 <devfile_write+0xe2>
	assert(r <= n);
  802b1f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b22:	48 98                	cltq   
  802b24:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802b28:	76 35                	jbe    802b5f <devfile_write+0xdf>
  802b2a:	48 b9 16 4c 80 00 00 	movabs $0x804c16,%rcx
  802b31:	00 00 00 
  802b34:	48 ba 1d 4c 80 00 00 	movabs $0x804c1d,%rdx
  802b3b:	00 00 00 
  802b3e:	be a2 00 00 00       	mov    $0xa2,%esi
  802b43:	48 bf 32 4c 80 00 00 	movabs $0x804c32,%rdi
  802b4a:	00 00 00 
  802b4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b52:	49 b8 7e 03 80 00 00 	movabs $0x80037e,%r8
  802b59:	00 00 00 
  802b5c:	41 ff d0             	callq  *%r8
	return r;
  802b5f:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802b62:	c9                   	leaveq 
  802b63:	c3                   	retq   

0000000000802b64 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802b64:	55                   	push   %rbp
  802b65:	48 89 e5             	mov    %rsp,%rbp
  802b68:	48 83 ec 20          	sub    $0x20,%rsp
  802b6c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b70:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802b74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b78:	8b 50 0c             	mov    0xc(%rax),%edx
  802b7b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b82:	00 00 00 
  802b85:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802b87:	be 00 00 00 00       	mov    $0x0,%esi
  802b8c:	bf 05 00 00 00       	mov    $0x5,%edi
  802b91:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802b98:	00 00 00 
  802b9b:	ff d0                	callq  *%rax
  802b9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ba0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ba4:	79 05                	jns    802bab <devfile_stat+0x47>
		return r;
  802ba6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba9:	eb 56                	jmp    802c01 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802bab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802baf:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802bb6:	00 00 00 
  802bb9:	48 89 c7             	mov    %rax,%rdi
  802bbc:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  802bc3:	00 00 00 
  802bc6:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802bc8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bcf:	00 00 00 
  802bd2:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802bd8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bdc:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802be2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802be9:	00 00 00 
  802bec:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802bf2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bf6:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802bfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c01:	c9                   	leaveq 
  802c02:	c3                   	retq   

0000000000802c03 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802c03:	55                   	push   %rbp
  802c04:	48 89 e5             	mov    %rsp,%rbp
  802c07:	48 83 ec 10          	sub    $0x10,%rsp
  802c0b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c0f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802c12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c16:	8b 50 0c             	mov    0xc(%rax),%edx
  802c19:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c20:	00 00 00 
  802c23:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802c25:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c2c:	00 00 00 
  802c2f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802c32:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802c35:	be 00 00 00 00       	mov    $0x0,%esi
  802c3a:	bf 02 00 00 00       	mov    $0x2,%edi
  802c3f:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802c46:	00 00 00 
  802c49:	ff d0                	callq  *%rax
}
  802c4b:	c9                   	leaveq 
  802c4c:	c3                   	retq   

0000000000802c4d <remove>:

// Delete a file
int
remove(const char *path)
{
  802c4d:	55                   	push   %rbp
  802c4e:	48 89 e5             	mov    %rsp,%rbp
  802c51:	48 83 ec 10          	sub    $0x10,%rsp
  802c55:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802c59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c5d:	48 89 c7             	mov    %rax,%rdi
  802c60:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  802c67:	00 00 00 
  802c6a:	ff d0                	callq  *%rax
  802c6c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c71:	7e 07                	jle    802c7a <remove+0x2d>
		return -E_BAD_PATH;
  802c73:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c78:	eb 33                	jmp    802cad <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802c7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c7e:	48 89 c6             	mov    %rax,%rsi
  802c81:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c88:	00 00 00 
  802c8b:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  802c92:	00 00 00 
  802c95:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802c97:	be 00 00 00 00       	mov    $0x0,%esi
  802c9c:	bf 07 00 00 00       	mov    $0x7,%edi
  802ca1:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802ca8:	00 00 00 
  802cab:	ff d0                	callq  *%rax
}
  802cad:	c9                   	leaveq 
  802cae:	c3                   	retq   

0000000000802caf <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802caf:	55                   	push   %rbp
  802cb0:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802cb3:	be 00 00 00 00       	mov    $0x0,%esi
  802cb8:	bf 08 00 00 00       	mov    $0x8,%edi
  802cbd:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802cc4:	00 00 00 
  802cc7:	ff d0                	callq  *%rax
}
  802cc9:	5d                   	pop    %rbp
  802cca:	c3                   	retq   

0000000000802ccb <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802ccb:	55                   	push   %rbp
  802ccc:	48 89 e5             	mov    %rsp,%rbp
  802ccf:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802cd6:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802cdd:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802ce4:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802ceb:	be 00 00 00 00       	mov    $0x0,%esi
  802cf0:	48 89 c7             	mov    %rax,%rdi
  802cf3:	48 b8 69 28 80 00 00 	movabs $0x802869,%rax
  802cfa:	00 00 00 
  802cfd:	ff d0                	callq  *%rax
  802cff:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802d02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d06:	79 28                	jns    802d30 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802d08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d0b:	89 c6                	mov    %eax,%esi
  802d0d:	48 bf 49 4c 80 00 00 	movabs $0x804c49,%rdi
  802d14:	00 00 00 
  802d17:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1c:	48 ba b7 05 80 00 00 	movabs $0x8005b7,%rdx
  802d23:	00 00 00 
  802d26:	ff d2                	callq  *%rdx
		return fd_src;
  802d28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d2b:	e9 74 01 00 00       	jmpq   802ea4 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802d30:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802d37:	be 01 01 00 00       	mov    $0x101,%esi
  802d3c:	48 89 c7             	mov    %rax,%rdi
  802d3f:	48 b8 69 28 80 00 00 	movabs $0x802869,%rax
  802d46:	00 00 00 
  802d49:	ff d0                	callq  *%rax
  802d4b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802d4e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d52:	79 39                	jns    802d8d <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802d54:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d57:	89 c6                	mov    %eax,%esi
  802d59:	48 bf 5f 4c 80 00 00 	movabs $0x804c5f,%rdi
  802d60:	00 00 00 
  802d63:	b8 00 00 00 00       	mov    $0x0,%eax
  802d68:	48 ba b7 05 80 00 00 	movabs $0x8005b7,%rdx
  802d6f:	00 00 00 
  802d72:	ff d2                	callq  *%rdx
		close(fd_src);
  802d74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d77:	89 c7                	mov    %eax,%edi
  802d79:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  802d80:	00 00 00 
  802d83:	ff d0                	callq  *%rax
		return fd_dest;
  802d85:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d88:	e9 17 01 00 00       	jmpq   802ea4 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d8d:	eb 74                	jmp    802e03 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802d8f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d92:	48 63 d0             	movslq %eax,%rdx
  802d95:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d9c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d9f:	48 89 ce             	mov    %rcx,%rsi
  802da2:	89 c7                	mov    %eax,%edi
  802da4:	48 b8 dd 24 80 00 00 	movabs $0x8024dd,%rax
  802dab:	00 00 00 
  802dae:	ff d0                	callq  *%rax
  802db0:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802db3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802db7:	79 4a                	jns    802e03 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802db9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802dbc:	89 c6                	mov    %eax,%esi
  802dbe:	48 bf 79 4c 80 00 00 	movabs $0x804c79,%rdi
  802dc5:	00 00 00 
  802dc8:	b8 00 00 00 00       	mov    $0x0,%eax
  802dcd:	48 ba b7 05 80 00 00 	movabs $0x8005b7,%rdx
  802dd4:	00 00 00 
  802dd7:	ff d2                	callq  *%rdx
			close(fd_src);
  802dd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ddc:	89 c7                	mov    %eax,%edi
  802dde:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  802de5:	00 00 00 
  802de8:	ff d0                	callq  *%rax
			close(fd_dest);
  802dea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ded:	89 c7                	mov    %eax,%edi
  802def:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  802df6:	00 00 00 
  802df9:	ff d0                	callq  *%rax
			return write_size;
  802dfb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802dfe:	e9 a1 00 00 00       	jmpq   802ea4 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802e03:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802e0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e0d:	ba 00 02 00 00       	mov    $0x200,%edx
  802e12:	48 89 ce             	mov    %rcx,%rsi
  802e15:	89 c7                	mov    %eax,%edi
  802e17:	48 b8 93 23 80 00 00 	movabs $0x802393,%rax
  802e1e:	00 00 00 
  802e21:	ff d0                	callq  *%rax
  802e23:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802e26:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e2a:	0f 8f 5f ff ff ff    	jg     802d8f <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802e30:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e34:	79 47                	jns    802e7d <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802e36:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e39:	89 c6                	mov    %eax,%esi
  802e3b:	48 bf 8c 4c 80 00 00 	movabs $0x804c8c,%rdi
  802e42:	00 00 00 
  802e45:	b8 00 00 00 00       	mov    $0x0,%eax
  802e4a:	48 ba b7 05 80 00 00 	movabs $0x8005b7,%rdx
  802e51:	00 00 00 
  802e54:	ff d2                	callq  *%rdx
		close(fd_src);
  802e56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e59:	89 c7                	mov    %eax,%edi
  802e5b:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  802e62:	00 00 00 
  802e65:	ff d0                	callq  *%rax
		close(fd_dest);
  802e67:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e6a:	89 c7                	mov    %eax,%edi
  802e6c:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  802e73:	00 00 00 
  802e76:	ff d0                	callq  *%rax
		return read_size;
  802e78:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e7b:	eb 27                	jmp    802ea4 <copy+0x1d9>
	}
	close(fd_src);
  802e7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e80:	89 c7                	mov    %eax,%edi
  802e82:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  802e89:	00 00 00 
  802e8c:	ff d0                	callq  *%rax
	close(fd_dest);
  802e8e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e91:	89 c7                	mov    %eax,%edi
  802e93:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  802e9a:	00 00 00 
  802e9d:	ff d0                	callq  *%rax
	return 0;
  802e9f:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802ea4:	c9                   	leaveq 
  802ea5:	c3                   	retq   

0000000000802ea6 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802ea6:	55                   	push   %rbp
  802ea7:	48 89 e5             	mov    %rsp,%rbp
  802eaa:	48 83 ec 20          	sub    $0x20,%rsp
  802eae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802eb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb6:	8b 40 0c             	mov    0xc(%rax),%eax
  802eb9:	85 c0                	test   %eax,%eax
  802ebb:	7e 67                	jle    802f24 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802ebd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec1:	8b 40 04             	mov    0x4(%rax),%eax
  802ec4:	48 63 d0             	movslq %eax,%rdx
  802ec7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ecb:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802ecf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ed3:	8b 00                	mov    (%rax),%eax
  802ed5:	48 89 ce             	mov    %rcx,%rsi
  802ed8:	89 c7                	mov    %eax,%edi
  802eda:	48 b8 dd 24 80 00 00 	movabs $0x8024dd,%rax
  802ee1:	00 00 00 
  802ee4:	ff d0                	callq  *%rax
  802ee6:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802ee9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eed:	7e 13                	jle    802f02 <writebuf+0x5c>
			b->result += result;
  802eef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef3:	8b 50 08             	mov    0x8(%rax),%edx
  802ef6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef9:	01 c2                	add    %eax,%edx
  802efb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eff:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802f02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f06:	8b 40 04             	mov    0x4(%rax),%eax
  802f09:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802f0c:	74 16                	je     802f24 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802f0e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f17:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802f1b:	89 c2                	mov    %eax,%edx
  802f1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f21:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802f24:	c9                   	leaveq 
  802f25:	c3                   	retq   

0000000000802f26 <putch>:

static void
putch(int ch, void *thunk)
{
  802f26:	55                   	push   %rbp
  802f27:	48 89 e5             	mov    %rsp,%rbp
  802f2a:	48 83 ec 20          	sub    $0x20,%rsp
  802f2e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f31:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802f35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f39:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802f3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f41:	8b 40 04             	mov    0x4(%rax),%eax
  802f44:	8d 48 01             	lea    0x1(%rax),%ecx
  802f47:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f4b:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802f4e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f51:	89 d1                	mov    %edx,%ecx
  802f53:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f57:	48 98                	cltq   
  802f59:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802f5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f61:	8b 40 04             	mov    0x4(%rax),%eax
  802f64:	3d 00 01 00 00       	cmp    $0x100,%eax
  802f69:	75 1e                	jne    802f89 <putch+0x63>
		writebuf(b);
  802f6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f6f:	48 89 c7             	mov    %rax,%rdi
  802f72:	48 b8 a6 2e 80 00 00 	movabs $0x802ea6,%rax
  802f79:	00 00 00 
  802f7c:	ff d0                	callq  *%rax
		b->idx = 0;
  802f7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802f89:	c9                   	leaveq 
  802f8a:	c3                   	retq   

0000000000802f8b <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802f8b:	55                   	push   %rbp
  802f8c:	48 89 e5             	mov    %rsp,%rbp
  802f8f:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802f96:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802f9c:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802fa3:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802faa:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802fb0:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802fb6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802fbd:	00 00 00 
	b.result = 0;
  802fc0:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802fc7:	00 00 00 
	b.error = 1;
  802fca:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802fd1:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802fd4:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802fdb:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802fe2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802fe9:	48 89 c6             	mov    %rax,%rsi
  802fec:	48 bf 26 2f 80 00 00 	movabs $0x802f26,%rdi
  802ff3:	00 00 00 
  802ff6:	48 b8 6a 09 80 00 00 	movabs $0x80096a,%rax
  802ffd:	00 00 00 
  803000:	ff d0                	callq  *%rax
	if (b.idx > 0)
  803002:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  803008:	85 c0                	test   %eax,%eax
  80300a:	7e 16                	jle    803022 <vfprintf+0x97>
		writebuf(&b);
  80300c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803013:	48 89 c7             	mov    %rax,%rdi
  803016:	48 b8 a6 2e 80 00 00 	movabs $0x802ea6,%rax
  80301d:	00 00 00 
  803020:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  803022:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803028:	85 c0                	test   %eax,%eax
  80302a:	74 08                	je     803034 <vfprintf+0xa9>
  80302c:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803032:	eb 06                	jmp    80303a <vfprintf+0xaf>
  803034:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  80303a:	c9                   	leaveq 
  80303b:	c3                   	retq   

000000000080303c <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80303c:	55                   	push   %rbp
  80303d:	48 89 e5             	mov    %rsp,%rbp
  803040:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803047:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  80304d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803054:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80305b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803062:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803069:	84 c0                	test   %al,%al
  80306b:	74 20                	je     80308d <fprintf+0x51>
  80306d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803071:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803075:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803079:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80307d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803081:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803085:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803089:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80308d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803094:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  80309b:	00 00 00 
  80309e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8030a5:	00 00 00 
  8030a8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8030ac:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8030b3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8030ba:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8030c1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8030c8:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8030cf:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8030d5:	48 89 ce             	mov    %rcx,%rsi
  8030d8:	89 c7                	mov    %eax,%edi
  8030da:	48 b8 8b 2f 80 00 00 	movabs $0x802f8b,%rax
  8030e1:	00 00 00 
  8030e4:	ff d0                	callq  *%rax
  8030e6:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8030ec:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8030f2:	c9                   	leaveq 
  8030f3:	c3                   	retq   

00000000008030f4 <printf>:

int
printf(const char *fmt, ...)
{
  8030f4:	55                   	push   %rbp
  8030f5:	48 89 e5             	mov    %rsp,%rbp
  8030f8:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8030ff:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803106:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80310d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803114:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80311b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803122:	84 c0                	test   %al,%al
  803124:	74 20                	je     803146 <printf+0x52>
  803126:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80312a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80312e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803132:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803136:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80313a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80313e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803142:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803146:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80314d:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803154:	00 00 00 
  803157:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80315e:	00 00 00 
  803161:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803165:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80316c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803173:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)

	cnt = vfprintf(1, fmt, ap);
  80317a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803181:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803188:	48 89 c6             	mov    %rax,%rsi
  80318b:	bf 01 00 00 00       	mov    $0x1,%edi
  803190:	48 b8 8b 2f 80 00 00 	movabs $0x802f8b,%rax
  803197:	00 00 00 
  80319a:	ff d0                	callq  *%rax
  80319c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)

	va_end(ap);

	return cnt;
  8031a2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8031a8:	c9                   	leaveq 
  8031a9:	c3                   	retq   

00000000008031aa <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8031aa:	55                   	push   %rbp
  8031ab:	48 89 e5             	mov    %rsp,%rbp
  8031ae:	48 83 ec 20          	sub    $0x20,%rsp
  8031b2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8031b5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031bc:	48 89 d6             	mov    %rdx,%rsi
  8031bf:	89 c7                	mov    %eax,%edi
  8031c1:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  8031c8:	00 00 00 
  8031cb:	ff d0                	callq  *%rax
  8031cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031d4:	79 05                	jns    8031db <fd2sockid+0x31>
		return r;
  8031d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d9:	eb 24                	jmp    8031ff <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8031db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031df:	8b 10                	mov    (%rax),%edx
  8031e1:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  8031e8:	00 00 00 
  8031eb:	8b 00                	mov    (%rax),%eax
  8031ed:	39 c2                	cmp    %eax,%edx
  8031ef:	74 07                	je     8031f8 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8031f1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8031f6:	eb 07                	jmp    8031ff <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8031f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031fc:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8031ff:	c9                   	leaveq 
  803200:	c3                   	retq   

0000000000803201 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803201:	55                   	push   %rbp
  803202:	48 89 e5             	mov    %rsp,%rbp
  803205:	48 83 ec 20          	sub    $0x20,%rsp
  803209:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80320c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803210:	48 89 c7             	mov    %rax,%rdi
  803213:	48 b8 c9 1e 80 00 00 	movabs $0x801ec9,%rax
  80321a:	00 00 00 
  80321d:	ff d0                	callq  *%rax
  80321f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803222:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803226:	78 26                	js     80324e <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80322c:	ba 07 04 00 00       	mov    $0x407,%edx
  803231:	48 89 c6             	mov    %rax,%rsi
  803234:	bf 00 00 00 00       	mov    $0x0,%edi
  803239:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  803240:	00 00 00 
  803243:	ff d0                	callq  *%rax
  803245:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803248:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80324c:	79 16                	jns    803264 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  80324e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803251:	89 c7                	mov    %eax,%edi
  803253:	48 b8 0e 37 80 00 00 	movabs $0x80370e,%rax
  80325a:	00 00 00 
  80325d:	ff d0                	callq  *%rax
		return r;
  80325f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803262:	eb 3a                	jmp    80329e <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803264:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803268:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  80326f:	00 00 00 
  803272:	8b 12                	mov    (%rdx),%edx
  803274:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803276:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80327a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803281:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803285:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803288:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80328b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80328f:	48 89 c7             	mov    %rax,%rdi
  803292:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  803299:	00 00 00 
  80329c:	ff d0                	callq  *%rax
}
  80329e:	c9                   	leaveq 
  80329f:	c3                   	retq   

00000000008032a0 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8032a0:	55                   	push   %rbp
  8032a1:	48 89 e5             	mov    %rsp,%rbp
  8032a4:	48 83 ec 30          	sub    $0x30,%rsp
  8032a8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032af:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032b6:	89 c7                	mov    %eax,%edi
  8032b8:	48 b8 aa 31 80 00 00 	movabs $0x8031aa,%rax
  8032bf:	00 00 00 
  8032c2:	ff d0                	callq  *%rax
  8032c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032cb:	79 05                	jns    8032d2 <accept+0x32>
		return r;
  8032cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d0:	eb 3b                	jmp    80330d <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8032d2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032d6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8032da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032dd:	48 89 ce             	mov    %rcx,%rsi
  8032e0:	89 c7                	mov    %eax,%edi
  8032e2:	48 b8 eb 35 80 00 00 	movabs $0x8035eb,%rax
  8032e9:	00 00 00 
  8032ec:	ff d0                	callq  *%rax
  8032ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f5:	79 05                	jns    8032fc <accept+0x5c>
		return r;
  8032f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032fa:	eb 11                	jmp    80330d <accept+0x6d>
	return alloc_sockfd(r);
  8032fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ff:	89 c7                	mov    %eax,%edi
  803301:	48 b8 01 32 80 00 00 	movabs $0x803201,%rax
  803308:	00 00 00 
  80330b:	ff d0                	callq  *%rax
}
  80330d:	c9                   	leaveq 
  80330e:	c3                   	retq   

000000000080330f <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80330f:	55                   	push   %rbp
  803310:	48 89 e5             	mov    %rsp,%rbp
  803313:	48 83 ec 20          	sub    $0x20,%rsp
  803317:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80331a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80331e:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803321:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803324:	89 c7                	mov    %eax,%edi
  803326:	48 b8 aa 31 80 00 00 	movabs $0x8031aa,%rax
  80332d:	00 00 00 
  803330:	ff d0                	callq  *%rax
  803332:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803335:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803339:	79 05                	jns    803340 <bind+0x31>
		return r;
  80333b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80333e:	eb 1b                	jmp    80335b <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803340:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803343:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803347:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80334a:	48 89 ce             	mov    %rcx,%rsi
  80334d:	89 c7                	mov    %eax,%edi
  80334f:	48 b8 6a 36 80 00 00 	movabs $0x80366a,%rax
  803356:	00 00 00 
  803359:	ff d0                	callq  *%rax
}
  80335b:	c9                   	leaveq 
  80335c:	c3                   	retq   

000000000080335d <shutdown>:

int
shutdown(int s, int how)
{
  80335d:	55                   	push   %rbp
  80335e:	48 89 e5             	mov    %rsp,%rbp
  803361:	48 83 ec 20          	sub    $0x20,%rsp
  803365:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803368:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80336b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80336e:	89 c7                	mov    %eax,%edi
  803370:	48 b8 aa 31 80 00 00 	movabs $0x8031aa,%rax
  803377:	00 00 00 
  80337a:	ff d0                	callq  *%rax
  80337c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80337f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803383:	79 05                	jns    80338a <shutdown+0x2d>
		return r;
  803385:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803388:	eb 16                	jmp    8033a0 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80338a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80338d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803390:	89 d6                	mov    %edx,%esi
  803392:	89 c7                	mov    %eax,%edi
  803394:	48 b8 ce 36 80 00 00 	movabs $0x8036ce,%rax
  80339b:	00 00 00 
  80339e:	ff d0                	callq  *%rax
}
  8033a0:	c9                   	leaveq 
  8033a1:	c3                   	retq   

00000000008033a2 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8033a2:	55                   	push   %rbp
  8033a3:	48 89 e5             	mov    %rsp,%rbp
  8033a6:	48 83 ec 10          	sub    $0x10,%rsp
  8033aa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8033ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033b2:	48 89 c7             	mov    %rax,%rdi
  8033b5:	48 b8 71 45 80 00 00 	movabs $0x804571,%rax
  8033bc:	00 00 00 
  8033bf:	ff d0                	callq  *%rax
  8033c1:	83 f8 01             	cmp    $0x1,%eax
  8033c4:	75 17                	jne    8033dd <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8033c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033ca:	8b 40 0c             	mov    0xc(%rax),%eax
  8033cd:	89 c7                	mov    %eax,%edi
  8033cf:	48 b8 0e 37 80 00 00 	movabs $0x80370e,%rax
  8033d6:	00 00 00 
  8033d9:	ff d0                	callq  *%rax
  8033db:	eb 05                	jmp    8033e2 <devsock_close+0x40>
	else
		return 0;
  8033dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033e2:	c9                   	leaveq 
  8033e3:	c3                   	retq   

00000000008033e4 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8033e4:	55                   	push   %rbp
  8033e5:	48 89 e5             	mov    %rsp,%rbp
  8033e8:	48 83 ec 20          	sub    $0x20,%rsp
  8033ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033f3:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033f9:	89 c7                	mov    %eax,%edi
  8033fb:	48 b8 aa 31 80 00 00 	movabs $0x8031aa,%rax
  803402:	00 00 00 
  803405:	ff d0                	callq  *%rax
  803407:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80340a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80340e:	79 05                	jns    803415 <connect+0x31>
		return r;
  803410:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803413:	eb 1b                	jmp    803430 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803415:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803418:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80341c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80341f:	48 89 ce             	mov    %rcx,%rsi
  803422:	89 c7                	mov    %eax,%edi
  803424:	48 b8 3b 37 80 00 00 	movabs $0x80373b,%rax
  80342b:	00 00 00 
  80342e:	ff d0                	callq  *%rax
}
  803430:	c9                   	leaveq 
  803431:	c3                   	retq   

0000000000803432 <listen>:

int
listen(int s, int backlog)
{
  803432:	55                   	push   %rbp
  803433:	48 89 e5             	mov    %rsp,%rbp
  803436:	48 83 ec 20          	sub    $0x20,%rsp
  80343a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80343d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803440:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803443:	89 c7                	mov    %eax,%edi
  803445:	48 b8 aa 31 80 00 00 	movabs $0x8031aa,%rax
  80344c:	00 00 00 
  80344f:	ff d0                	callq  *%rax
  803451:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803454:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803458:	79 05                	jns    80345f <listen+0x2d>
		return r;
  80345a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80345d:	eb 16                	jmp    803475 <listen+0x43>
	return nsipc_listen(r, backlog);
  80345f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803462:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803465:	89 d6                	mov    %edx,%esi
  803467:	89 c7                	mov    %eax,%edi
  803469:	48 b8 9f 37 80 00 00 	movabs $0x80379f,%rax
  803470:	00 00 00 
  803473:	ff d0                	callq  *%rax
}
  803475:	c9                   	leaveq 
  803476:	c3                   	retq   

0000000000803477 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803477:	55                   	push   %rbp
  803478:	48 89 e5             	mov    %rsp,%rbp
  80347b:	48 83 ec 20          	sub    $0x20,%rsp
  80347f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803483:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803487:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80348b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80348f:	89 c2                	mov    %eax,%edx
  803491:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803495:	8b 40 0c             	mov    0xc(%rax),%eax
  803498:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80349c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8034a1:	89 c7                	mov    %eax,%edi
  8034a3:	48 b8 df 37 80 00 00 	movabs $0x8037df,%rax
  8034aa:	00 00 00 
  8034ad:	ff d0                	callq  *%rax
}
  8034af:	c9                   	leaveq 
  8034b0:	c3                   	retq   

00000000008034b1 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8034b1:	55                   	push   %rbp
  8034b2:	48 89 e5             	mov    %rsp,%rbp
  8034b5:	48 83 ec 20          	sub    $0x20,%rsp
  8034b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034c1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8034c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034c9:	89 c2                	mov    %eax,%edx
  8034cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034cf:	8b 40 0c             	mov    0xc(%rax),%eax
  8034d2:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8034d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8034db:	89 c7                	mov    %eax,%edi
  8034dd:	48 b8 ab 38 80 00 00 	movabs $0x8038ab,%rax
  8034e4:	00 00 00 
  8034e7:	ff d0                	callq  *%rax
}
  8034e9:	c9                   	leaveq 
  8034ea:	c3                   	retq   

00000000008034eb <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8034eb:	55                   	push   %rbp
  8034ec:	48 89 e5             	mov    %rsp,%rbp
  8034ef:	48 83 ec 10          	sub    $0x10,%rsp
  8034f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8034fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ff:	48 be a7 4c 80 00 00 	movabs $0x804ca7,%rsi
  803506:	00 00 00 
  803509:	48 89 c7             	mov    %rax,%rdi
  80350c:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  803513:	00 00 00 
  803516:	ff d0                	callq  *%rax
	return 0;
  803518:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80351d:	c9                   	leaveq 
  80351e:	c3                   	retq   

000000000080351f <socket>:

int
socket(int domain, int type, int protocol)
{
  80351f:	55                   	push   %rbp
  803520:	48 89 e5             	mov    %rsp,%rbp
  803523:	48 83 ec 20          	sub    $0x20,%rsp
  803527:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80352a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80352d:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803530:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803533:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803536:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803539:	89 ce                	mov    %ecx,%esi
  80353b:	89 c7                	mov    %eax,%edi
  80353d:	48 b8 63 39 80 00 00 	movabs $0x803963,%rax
  803544:	00 00 00 
  803547:	ff d0                	callq  *%rax
  803549:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80354c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803550:	79 05                	jns    803557 <socket+0x38>
		return r;
  803552:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803555:	eb 11                	jmp    803568 <socket+0x49>
	return alloc_sockfd(r);
  803557:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355a:	89 c7                	mov    %eax,%edi
  80355c:	48 b8 01 32 80 00 00 	movabs $0x803201,%rax
  803563:	00 00 00 
  803566:	ff d0                	callq  *%rax
}
  803568:	c9                   	leaveq 
  803569:	c3                   	retq   

000000000080356a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80356a:	55                   	push   %rbp
  80356b:	48 89 e5             	mov    %rsp,%rbp
  80356e:	48 83 ec 10          	sub    $0x10,%rsp
  803572:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803575:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80357c:	00 00 00 
  80357f:	8b 00                	mov    (%rax),%eax
  803581:	85 c0                	test   %eax,%eax
  803583:	75 1d                	jne    8035a2 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803585:	bf 02 00 00 00       	mov    $0x2,%edi
  80358a:	48 b8 ff 44 80 00 00 	movabs $0x8044ff,%rax
  803591:	00 00 00 
  803594:	ff d0                	callq  *%rax
  803596:	48 ba 08 70 80 00 00 	movabs $0x807008,%rdx
  80359d:	00 00 00 
  8035a0:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8035a2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8035a9:	00 00 00 
  8035ac:	8b 00                	mov    (%rax),%eax
  8035ae:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8035b1:	b9 07 00 00 00       	mov    $0x7,%ecx
  8035b6:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8035bd:	00 00 00 
  8035c0:	89 c7                	mov    %eax,%edi
  8035c2:	48 b8 f3 42 80 00 00 	movabs $0x8042f3,%rax
  8035c9:	00 00 00 
  8035cc:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8035ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8035d3:	be 00 00 00 00       	mov    $0x0,%esi
  8035d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8035dd:	48 b8 32 42 80 00 00 	movabs $0x804232,%rax
  8035e4:	00 00 00 
  8035e7:	ff d0                	callq  *%rax
}
  8035e9:	c9                   	leaveq 
  8035ea:	c3                   	retq   

00000000008035eb <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8035eb:	55                   	push   %rbp
  8035ec:	48 89 e5             	mov    %rsp,%rbp
  8035ef:	48 83 ec 30          	sub    $0x30,%rsp
  8035f3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8035fe:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803605:	00 00 00 
  803608:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80360b:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80360d:	bf 01 00 00 00       	mov    $0x1,%edi
  803612:	48 b8 6a 35 80 00 00 	movabs $0x80356a,%rax
  803619:	00 00 00 
  80361c:	ff d0                	callq  *%rax
  80361e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803621:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803625:	78 3e                	js     803665 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803627:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80362e:	00 00 00 
  803631:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803635:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803639:	8b 40 10             	mov    0x10(%rax),%eax
  80363c:	89 c2                	mov    %eax,%edx
  80363e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803642:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803646:	48 89 ce             	mov    %rcx,%rsi
  803649:	48 89 c7             	mov    %rax,%rdi
  80364c:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  803653:	00 00 00 
  803656:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803658:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80365c:	8b 50 10             	mov    0x10(%rax),%edx
  80365f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803663:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803665:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803668:	c9                   	leaveq 
  803669:	c3                   	retq   

000000000080366a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80366a:	55                   	push   %rbp
  80366b:	48 89 e5             	mov    %rsp,%rbp
  80366e:	48 83 ec 10          	sub    $0x10,%rsp
  803672:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803675:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803679:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80367c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803683:	00 00 00 
  803686:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803689:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80368b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80368e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803692:	48 89 c6             	mov    %rax,%rsi
  803695:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80369c:	00 00 00 
  80369f:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  8036a6:	00 00 00 
  8036a9:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8036ab:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036b2:	00 00 00 
  8036b5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036b8:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8036bb:	bf 02 00 00 00       	mov    $0x2,%edi
  8036c0:	48 b8 6a 35 80 00 00 	movabs $0x80356a,%rax
  8036c7:	00 00 00 
  8036ca:	ff d0                	callq  *%rax
}
  8036cc:	c9                   	leaveq 
  8036cd:	c3                   	retq   

00000000008036ce <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8036ce:	55                   	push   %rbp
  8036cf:	48 89 e5             	mov    %rsp,%rbp
  8036d2:	48 83 ec 10          	sub    $0x10,%rsp
  8036d6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036d9:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8036dc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036e3:	00 00 00 
  8036e6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036e9:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8036eb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036f2:	00 00 00 
  8036f5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036f8:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8036fb:	bf 03 00 00 00       	mov    $0x3,%edi
  803700:	48 b8 6a 35 80 00 00 	movabs $0x80356a,%rax
  803707:	00 00 00 
  80370a:	ff d0                	callq  *%rax
}
  80370c:	c9                   	leaveq 
  80370d:	c3                   	retq   

000000000080370e <nsipc_close>:

int
nsipc_close(int s)
{
  80370e:	55                   	push   %rbp
  80370f:	48 89 e5             	mov    %rsp,%rbp
  803712:	48 83 ec 10          	sub    $0x10,%rsp
  803716:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803719:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803720:	00 00 00 
  803723:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803726:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803728:	bf 04 00 00 00       	mov    $0x4,%edi
  80372d:	48 b8 6a 35 80 00 00 	movabs $0x80356a,%rax
  803734:	00 00 00 
  803737:	ff d0                	callq  *%rax
}
  803739:	c9                   	leaveq 
  80373a:	c3                   	retq   

000000000080373b <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80373b:	55                   	push   %rbp
  80373c:	48 89 e5             	mov    %rsp,%rbp
  80373f:	48 83 ec 10          	sub    $0x10,%rsp
  803743:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803746:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80374a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80374d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803754:	00 00 00 
  803757:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80375a:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80375c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80375f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803763:	48 89 c6             	mov    %rax,%rsi
  803766:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80376d:	00 00 00 
  803770:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  803777:	00 00 00 
  80377a:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80377c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803783:	00 00 00 
  803786:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803789:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80378c:	bf 05 00 00 00       	mov    $0x5,%edi
  803791:	48 b8 6a 35 80 00 00 	movabs $0x80356a,%rax
  803798:	00 00 00 
  80379b:	ff d0                	callq  *%rax
}
  80379d:	c9                   	leaveq 
  80379e:	c3                   	retq   

000000000080379f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80379f:	55                   	push   %rbp
  8037a0:	48 89 e5             	mov    %rsp,%rbp
  8037a3:	48 83 ec 10          	sub    $0x10,%rsp
  8037a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037aa:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8037ad:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037b4:	00 00 00 
  8037b7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037ba:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8037bc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037c3:	00 00 00 
  8037c6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037c9:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8037cc:	bf 06 00 00 00       	mov    $0x6,%edi
  8037d1:	48 b8 6a 35 80 00 00 	movabs $0x80356a,%rax
  8037d8:	00 00 00 
  8037db:	ff d0                	callq  *%rax
}
  8037dd:	c9                   	leaveq 
  8037de:	c3                   	retq   

00000000008037df <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8037df:	55                   	push   %rbp
  8037e0:	48 89 e5             	mov    %rsp,%rbp
  8037e3:	48 83 ec 30          	sub    $0x30,%rsp
  8037e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037ee:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8037f1:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8037f4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037fb:	00 00 00 
  8037fe:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803801:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803803:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80380a:	00 00 00 
  80380d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803810:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803813:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80381a:	00 00 00 
  80381d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803820:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803823:	bf 07 00 00 00       	mov    $0x7,%edi
  803828:	48 b8 6a 35 80 00 00 	movabs $0x80356a,%rax
  80382f:	00 00 00 
  803832:	ff d0                	callq  *%rax
  803834:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803837:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80383b:	78 69                	js     8038a6 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80383d:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803844:	7f 08                	jg     80384e <nsipc_recv+0x6f>
  803846:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803849:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80384c:	7e 35                	jle    803883 <nsipc_recv+0xa4>
  80384e:	48 b9 ae 4c 80 00 00 	movabs $0x804cae,%rcx
  803855:	00 00 00 
  803858:	48 ba c3 4c 80 00 00 	movabs $0x804cc3,%rdx
  80385f:	00 00 00 
  803862:	be 62 00 00 00       	mov    $0x62,%esi
  803867:	48 bf d8 4c 80 00 00 	movabs $0x804cd8,%rdi
  80386e:	00 00 00 
  803871:	b8 00 00 00 00       	mov    $0x0,%eax
  803876:	49 b8 7e 03 80 00 00 	movabs $0x80037e,%r8
  80387d:	00 00 00 
  803880:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803883:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803886:	48 63 d0             	movslq %eax,%rdx
  803889:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80388d:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803894:	00 00 00 
  803897:	48 89 c7             	mov    %rax,%rdi
  80389a:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  8038a1:	00 00 00 
  8038a4:	ff d0                	callq  *%rax
	}

	return r;
  8038a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038a9:	c9                   	leaveq 
  8038aa:	c3                   	retq   

00000000008038ab <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8038ab:	55                   	push   %rbp
  8038ac:	48 89 e5             	mov    %rsp,%rbp
  8038af:	48 83 ec 20          	sub    $0x20,%rsp
  8038b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038ba:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8038bd:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8038c0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038c7:	00 00 00 
  8038ca:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038cd:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8038cf:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8038d6:	7e 35                	jle    80390d <nsipc_send+0x62>
  8038d8:	48 b9 e4 4c 80 00 00 	movabs $0x804ce4,%rcx
  8038df:	00 00 00 
  8038e2:	48 ba c3 4c 80 00 00 	movabs $0x804cc3,%rdx
  8038e9:	00 00 00 
  8038ec:	be 6d 00 00 00       	mov    $0x6d,%esi
  8038f1:	48 bf d8 4c 80 00 00 	movabs $0x804cd8,%rdi
  8038f8:	00 00 00 
  8038fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803900:	49 b8 7e 03 80 00 00 	movabs $0x80037e,%r8
  803907:	00 00 00 
  80390a:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80390d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803910:	48 63 d0             	movslq %eax,%rdx
  803913:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803917:	48 89 c6             	mov    %rax,%rsi
  80391a:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803921:	00 00 00 
  803924:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  80392b:	00 00 00 
  80392e:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803930:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803937:	00 00 00 
  80393a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80393d:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803940:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803947:	00 00 00 
  80394a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80394d:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803950:	bf 08 00 00 00       	mov    $0x8,%edi
  803955:	48 b8 6a 35 80 00 00 	movabs $0x80356a,%rax
  80395c:	00 00 00 
  80395f:	ff d0                	callq  *%rax
}
  803961:	c9                   	leaveq 
  803962:	c3                   	retq   

0000000000803963 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803963:	55                   	push   %rbp
  803964:	48 89 e5             	mov    %rsp,%rbp
  803967:	48 83 ec 10          	sub    $0x10,%rsp
  80396b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80396e:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803971:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803974:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80397b:	00 00 00 
  80397e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803981:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803983:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80398a:	00 00 00 
  80398d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803990:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803993:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80399a:	00 00 00 
  80399d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8039a0:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8039a3:	bf 09 00 00 00       	mov    $0x9,%edi
  8039a8:	48 b8 6a 35 80 00 00 	movabs $0x80356a,%rax
  8039af:	00 00 00 
  8039b2:	ff d0                	callq  *%rax
}
  8039b4:	c9                   	leaveq 
  8039b5:	c3                   	retq   

00000000008039b6 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8039b6:	55                   	push   %rbp
  8039b7:	48 89 e5             	mov    %rsp,%rbp
  8039ba:	53                   	push   %rbx
  8039bb:	48 83 ec 38          	sub    $0x38,%rsp
  8039bf:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8039c3:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8039c7:	48 89 c7             	mov    %rax,%rdi
  8039ca:	48 b8 c9 1e 80 00 00 	movabs $0x801ec9,%rax
  8039d1:	00 00 00 
  8039d4:	ff d0                	callq  *%rax
  8039d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039dd:	0f 88 bf 01 00 00    	js     803ba2 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8039e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039e7:	ba 07 04 00 00       	mov    $0x407,%edx
  8039ec:	48 89 c6             	mov    %rax,%rsi
  8039ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8039f4:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  8039fb:	00 00 00 
  8039fe:	ff d0                	callq  *%rax
  803a00:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a03:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a07:	0f 88 95 01 00 00    	js     803ba2 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803a0d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803a11:	48 89 c7             	mov    %rax,%rdi
  803a14:	48 b8 c9 1e 80 00 00 	movabs $0x801ec9,%rax
  803a1b:	00 00 00 
  803a1e:	ff d0                	callq  *%rax
  803a20:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a23:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a27:	0f 88 5d 01 00 00    	js     803b8a <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a2d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a31:	ba 07 04 00 00       	mov    $0x407,%edx
  803a36:	48 89 c6             	mov    %rax,%rsi
  803a39:	bf 00 00 00 00       	mov    $0x0,%edi
  803a3e:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  803a45:	00 00 00 
  803a48:	ff d0                	callq  *%rax
  803a4a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a4d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a51:	0f 88 33 01 00 00    	js     803b8a <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803a57:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a5b:	48 89 c7             	mov    %rax,%rdi
  803a5e:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  803a65:	00 00 00 
  803a68:	ff d0                	callq  *%rax
  803a6a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a6e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a72:	ba 07 04 00 00       	mov    $0x407,%edx
  803a77:	48 89 c6             	mov    %rax,%rsi
  803a7a:	bf 00 00 00 00       	mov    $0x0,%edi
  803a7f:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  803a86:	00 00 00 
  803a89:	ff d0                	callq  *%rax
  803a8b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a8e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a92:	79 05                	jns    803a99 <pipe+0xe3>
		goto err2;
  803a94:	e9 d9 00 00 00       	jmpq   803b72 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a99:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a9d:	48 89 c7             	mov    %rax,%rdi
  803aa0:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  803aa7:	00 00 00 
  803aaa:	ff d0                	callq  *%rax
  803aac:	48 89 c2             	mov    %rax,%rdx
  803aaf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ab3:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803ab9:	48 89 d1             	mov    %rdx,%rcx
  803abc:	ba 00 00 00 00       	mov    $0x0,%edx
  803ac1:	48 89 c6             	mov    %rax,%rsi
  803ac4:	bf 00 00 00 00       	mov    $0x0,%edi
  803ac9:	48 b8 eb 1a 80 00 00 	movabs $0x801aeb,%rax
  803ad0:	00 00 00 
  803ad3:	ff d0                	callq  *%rax
  803ad5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ad8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803adc:	79 1b                	jns    803af9 <pipe+0x143>
		goto err3;
  803ade:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803adf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ae3:	48 89 c6             	mov    %rax,%rsi
  803ae6:	bf 00 00 00 00       	mov    $0x0,%edi
  803aeb:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  803af2:	00 00 00 
  803af5:	ff d0                	callq  *%rax
  803af7:	eb 79                	jmp    803b72 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803af9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803afd:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b04:	00 00 00 
  803b07:	8b 12                	mov    (%rdx),%edx
  803b09:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803b0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b0f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803b16:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b1a:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b21:	00 00 00 
  803b24:	8b 12                	mov    (%rdx),%edx
  803b26:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803b28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b2c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803b33:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b37:	48 89 c7             	mov    %rax,%rdi
  803b3a:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  803b41:	00 00 00 
  803b44:	ff d0                	callq  *%rax
  803b46:	89 c2                	mov    %eax,%edx
  803b48:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b4c:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803b4e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b52:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803b56:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b5a:	48 89 c7             	mov    %rax,%rdi
  803b5d:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  803b64:	00 00 00 
  803b67:	ff d0                	callq  *%rax
  803b69:	89 03                	mov    %eax,(%rbx)
	return 0;
  803b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  803b70:	eb 33                	jmp    803ba5 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803b72:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b76:	48 89 c6             	mov    %rax,%rsi
  803b79:	bf 00 00 00 00       	mov    $0x0,%edi
  803b7e:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  803b85:	00 00 00 
  803b88:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803b8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b8e:	48 89 c6             	mov    %rax,%rsi
  803b91:	bf 00 00 00 00       	mov    $0x0,%edi
  803b96:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  803b9d:	00 00 00 
  803ba0:	ff d0                	callq  *%rax
err:
	return r;
  803ba2:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803ba5:	48 83 c4 38          	add    $0x38,%rsp
  803ba9:	5b                   	pop    %rbx
  803baa:	5d                   	pop    %rbp
  803bab:	c3                   	retq   

0000000000803bac <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803bac:	55                   	push   %rbp
  803bad:	48 89 e5             	mov    %rsp,%rbp
  803bb0:	53                   	push   %rbx
  803bb1:	48 83 ec 28          	sub    $0x28,%rsp
  803bb5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803bb9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803bbd:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803bc4:	00 00 00 
  803bc7:	48 8b 00             	mov    (%rax),%rax
  803bca:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803bd0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803bd3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bd7:	48 89 c7             	mov    %rax,%rdi
  803bda:	48 b8 71 45 80 00 00 	movabs $0x804571,%rax
  803be1:	00 00 00 
  803be4:	ff d0                	callq  *%rax
  803be6:	89 c3                	mov    %eax,%ebx
  803be8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bec:	48 89 c7             	mov    %rax,%rdi
  803bef:	48 b8 71 45 80 00 00 	movabs $0x804571,%rax
  803bf6:	00 00 00 
  803bf9:	ff d0                	callq  *%rax
  803bfb:	39 c3                	cmp    %eax,%ebx
  803bfd:	0f 94 c0             	sete   %al
  803c00:	0f b6 c0             	movzbl %al,%eax
  803c03:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803c06:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803c0d:	00 00 00 
  803c10:	48 8b 00             	mov    (%rax),%rax
  803c13:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c19:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803c1c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c1f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c22:	75 05                	jne    803c29 <_pipeisclosed+0x7d>
			return ret;
  803c24:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c27:	eb 4f                	jmp    803c78 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803c29:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c2c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c2f:	74 42                	je     803c73 <_pipeisclosed+0xc7>
  803c31:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803c35:	75 3c                	jne    803c73 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803c37:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803c3e:	00 00 00 
  803c41:	48 8b 00             	mov    (%rax),%rax
  803c44:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803c4a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803c4d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c50:	89 c6                	mov    %eax,%esi
  803c52:	48 bf f5 4c 80 00 00 	movabs $0x804cf5,%rdi
  803c59:	00 00 00 
  803c5c:	b8 00 00 00 00       	mov    $0x0,%eax
  803c61:	49 b8 b7 05 80 00 00 	movabs $0x8005b7,%r8
  803c68:	00 00 00 
  803c6b:	41 ff d0             	callq  *%r8
	}
  803c6e:	e9 4a ff ff ff       	jmpq   803bbd <_pipeisclosed+0x11>
  803c73:	e9 45 ff ff ff       	jmpq   803bbd <_pipeisclosed+0x11>

}
  803c78:	48 83 c4 28          	add    $0x28,%rsp
  803c7c:	5b                   	pop    %rbx
  803c7d:	5d                   	pop    %rbp
  803c7e:	c3                   	retq   

0000000000803c7f <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803c7f:	55                   	push   %rbp
  803c80:	48 89 e5             	mov    %rsp,%rbp
  803c83:	48 83 ec 30          	sub    $0x30,%rsp
  803c87:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c8a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803c8e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803c91:	48 89 d6             	mov    %rdx,%rsi
  803c94:	89 c7                	mov    %eax,%edi
  803c96:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  803c9d:	00 00 00 
  803ca0:	ff d0                	callq  *%rax
  803ca2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ca5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ca9:	79 05                	jns    803cb0 <pipeisclosed+0x31>
		return r;
  803cab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cae:	eb 31                	jmp    803ce1 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803cb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cb4:	48 89 c7             	mov    %rax,%rdi
  803cb7:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  803cbe:	00 00 00 
  803cc1:	ff d0                	callq  *%rax
  803cc3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803cc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ccb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ccf:	48 89 d6             	mov    %rdx,%rsi
  803cd2:	48 89 c7             	mov    %rax,%rdi
  803cd5:	48 b8 ac 3b 80 00 00 	movabs $0x803bac,%rax
  803cdc:	00 00 00 
  803cdf:	ff d0                	callq  *%rax
}
  803ce1:	c9                   	leaveq 
  803ce2:	c3                   	retq   

0000000000803ce3 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803ce3:	55                   	push   %rbp
  803ce4:	48 89 e5             	mov    %rsp,%rbp
  803ce7:	48 83 ec 40          	sub    $0x40,%rsp
  803ceb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803cef:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803cf3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803cf7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cfb:	48 89 c7             	mov    %rax,%rdi
  803cfe:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  803d05:	00 00 00 
  803d08:	ff d0                	callq  *%rax
  803d0a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d0e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d12:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d16:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d1d:	00 
  803d1e:	e9 92 00 00 00       	jmpq   803db5 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803d23:	eb 41                	jmp    803d66 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803d25:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803d2a:	74 09                	je     803d35 <devpipe_read+0x52>
				return i;
  803d2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d30:	e9 92 00 00 00       	jmpq   803dc7 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803d35:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d3d:	48 89 d6             	mov    %rdx,%rsi
  803d40:	48 89 c7             	mov    %rax,%rdi
  803d43:	48 b8 ac 3b 80 00 00 	movabs $0x803bac,%rax
  803d4a:	00 00 00 
  803d4d:	ff d0                	callq  *%rax
  803d4f:	85 c0                	test   %eax,%eax
  803d51:	74 07                	je     803d5a <devpipe_read+0x77>
				return 0;
  803d53:	b8 00 00 00 00       	mov    $0x0,%eax
  803d58:	eb 6d                	jmp    803dc7 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803d5a:	48 b8 5d 1a 80 00 00 	movabs $0x801a5d,%rax
  803d61:	00 00 00 
  803d64:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803d66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d6a:	8b 10                	mov    (%rax),%edx
  803d6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d70:	8b 40 04             	mov    0x4(%rax),%eax
  803d73:	39 c2                	cmp    %eax,%edx
  803d75:	74 ae                	je     803d25 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803d77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d7b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803d7f:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803d83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d87:	8b 00                	mov    (%rax),%eax
  803d89:	99                   	cltd   
  803d8a:	c1 ea 1b             	shr    $0x1b,%edx
  803d8d:	01 d0                	add    %edx,%eax
  803d8f:	83 e0 1f             	and    $0x1f,%eax
  803d92:	29 d0                	sub    %edx,%eax
  803d94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d98:	48 98                	cltq   
  803d9a:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803d9f:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803da1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803da5:	8b 00                	mov    (%rax),%eax
  803da7:	8d 50 01             	lea    0x1(%rax),%edx
  803daa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dae:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803db0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803db5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803db9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803dbd:	0f 82 60 ff ff ff    	jb     803d23 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803dc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803dc7:	c9                   	leaveq 
  803dc8:	c3                   	retq   

0000000000803dc9 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803dc9:	55                   	push   %rbp
  803dca:	48 89 e5             	mov    %rsp,%rbp
  803dcd:	48 83 ec 40          	sub    $0x40,%rsp
  803dd1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803dd5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803dd9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803ddd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803de1:	48 89 c7             	mov    %rax,%rdi
  803de4:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  803deb:	00 00 00 
  803dee:	ff d0                	callq  *%rax
  803df0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803df4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803df8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803dfc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e03:	00 
  803e04:	e9 8e 00 00 00       	jmpq   803e97 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e09:	eb 31                	jmp    803e3c <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803e0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e13:	48 89 d6             	mov    %rdx,%rsi
  803e16:	48 89 c7             	mov    %rax,%rdi
  803e19:	48 b8 ac 3b 80 00 00 	movabs $0x803bac,%rax
  803e20:	00 00 00 
  803e23:	ff d0                	callq  *%rax
  803e25:	85 c0                	test   %eax,%eax
  803e27:	74 07                	je     803e30 <devpipe_write+0x67>
				return 0;
  803e29:	b8 00 00 00 00       	mov    $0x0,%eax
  803e2e:	eb 79                	jmp    803ea9 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803e30:	48 b8 5d 1a 80 00 00 	movabs $0x801a5d,%rax
  803e37:	00 00 00 
  803e3a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e40:	8b 40 04             	mov    0x4(%rax),%eax
  803e43:	48 63 d0             	movslq %eax,%rdx
  803e46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e4a:	8b 00                	mov    (%rax),%eax
  803e4c:	48 98                	cltq   
  803e4e:	48 83 c0 20          	add    $0x20,%rax
  803e52:	48 39 c2             	cmp    %rax,%rdx
  803e55:	73 b4                	jae    803e0b <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803e57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e5b:	8b 40 04             	mov    0x4(%rax),%eax
  803e5e:	99                   	cltd   
  803e5f:	c1 ea 1b             	shr    $0x1b,%edx
  803e62:	01 d0                	add    %edx,%eax
  803e64:	83 e0 1f             	and    $0x1f,%eax
  803e67:	29 d0                	sub    %edx,%eax
  803e69:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803e6d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803e71:	48 01 ca             	add    %rcx,%rdx
  803e74:	0f b6 0a             	movzbl (%rdx),%ecx
  803e77:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e7b:	48 98                	cltq   
  803e7d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803e81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e85:	8b 40 04             	mov    0x4(%rax),%eax
  803e88:	8d 50 01             	lea    0x1(%rax),%edx
  803e8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e8f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e92:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e9b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e9f:	0f 82 64 ff ff ff    	jb     803e09 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803ea5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803ea9:	c9                   	leaveq 
  803eaa:	c3                   	retq   

0000000000803eab <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803eab:	55                   	push   %rbp
  803eac:	48 89 e5             	mov    %rsp,%rbp
  803eaf:	48 83 ec 20          	sub    $0x20,%rsp
  803eb3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803eb7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803ebb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ebf:	48 89 c7             	mov    %rax,%rdi
  803ec2:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  803ec9:	00 00 00 
  803ecc:	ff d0                	callq  *%rax
  803ece:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803ed2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ed6:	48 be 08 4d 80 00 00 	movabs $0x804d08,%rsi
  803edd:	00 00 00 
  803ee0:	48 89 c7             	mov    %rax,%rdi
  803ee3:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  803eea:	00 00 00 
  803eed:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803eef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ef3:	8b 50 04             	mov    0x4(%rax),%edx
  803ef6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803efa:	8b 00                	mov    (%rax),%eax
  803efc:	29 c2                	sub    %eax,%edx
  803efe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f02:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803f08:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f0c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803f13:	00 00 00 
	stat->st_dev = &devpipe;
  803f16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f1a:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803f21:	00 00 00 
  803f24:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803f2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f30:	c9                   	leaveq 
  803f31:	c3                   	retq   

0000000000803f32 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803f32:	55                   	push   %rbp
  803f33:	48 89 e5             	mov    %rsp,%rbp
  803f36:	48 83 ec 10          	sub    $0x10,%rsp
  803f3a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  803f3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f42:	48 89 c6             	mov    %rax,%rsi
  803f45:	bf 00 00 00 00       	mov    $0x0,%edi
  803f4a:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  803f51:	00 00 00 
  803f54:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  803f56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f5a:	48 89 c7             	mov    %rax,%rdi
  803f5d:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  803f64:	00 00 00 
  803f67:	ff d0                	callq  *%rax
  803f69:	48 89 c6             	mov    %rax,%rsi
  803f6c:	bf 00 00 00 00       	mov    $0x0,%edi
  803f71:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  803f78:	00 00 00 
  803f7b:	ff d0                	callq  *%rax
}
  803f7d:	c9                   	leaveq 
  803f7e:	c3                   	retq   

0000000000803f7f <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803f7f:	55                   	push   %rbp
  803f80:	48 89 e5             	mov    %rsp,%rbp
  803f83:	48 83 ec 20          	sub    $0x20,%rsp
  803f87:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803f8a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f8d:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803f90:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803f94:	be 01 00 00 00       	mov    $0x1,%esi
  803f99:	48 89 c7             	mov    %rax,%rdi
  803f9c:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  803fa3:	00 00 00 
  803fa6:	ff d0                	callq  *%rax
}
  803fa8:	c9                   	leaveq 
  803fa9:	c3                   	retq   

0000000000803faa <getchar>:

int
getchar(void)
{
  803faa:	55                   	push   %rbp
  803fab:	48 89 e5             	mov    %rsp,%rbp
  803fae:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803fb2:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803fb6:	ba 01 00 00 00       	mov    $0x1,%edx
  803fbb:	48 89 c6             	mov    %rax,%rsi
  803fbe:	bf 00 00 00 00       	mov    $0x0,%edi
  803fc3:	48 b8 93 23 80 00 00 	movabs $0x802393,%rax
  803fca:	00 00 00 
  803fcd:	ff d0                	callq  *%rax
  803fcf:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803fd2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fd6:	79 05                	jns    803fdd <getchar+0x33>
		return r;
  803fd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fdb:	eb 14                	jmp    803ff1 <getchar+0x47>
	if (r < 1)
  803fdd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fe1:	7f 07                	jg     803fea <getchar+0x40>
		return -E_EOF;
  803fe3:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803fe8:	eb 07                	jmp    803ff1 <getchar+0x47>
	return c;
  803fea:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803fee:	0f b6 c0             	movzbl %al,%eax

}
  803ff1:	c9                   	leaveq 
  803ff2:	c3                   	retq   

0000000000803ff3 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803ff3:	55                   	push   %rbp
  803ff4:	48 89 e5             	mov    %rsp,%rbp
  803ff7:	48 83 ec 20          	sub    $0x20,%rsp
  803ffb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ffe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804002:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804005:	48 89 d6             	mov    %rdx,%rsi
  804008:	89 c7                	mov    %eax,%edi
  80400a:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  804011:	00 00 00 
  804014:	ff d0                	callq  *%rax
  804016:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804019:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80401d:	79 05                	jns    804024 <iscons+0x31>
		return r;
  80401f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804022:	eb 1a                	jmp    80403e <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804024:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804028:	8b 10                	mov    (%rax),%edx
  80402a:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  804031:	00 00 00 
  804034:	8b 00                	mov    (%rax),%eax
  804036:	39 c2                	cmp    %eax,%edx
  804038:	0f 94 c0             	sete   %al
  80403b:	0f b6 c0             	movzbl %al,%eax
}
  80403e:	c9                   	leaveq 
  80403f:	c3                   	retq   

0000000000804040 <opencons>:

int
opencons(void)
{
  804040:	55                   	push   %rbp
  804041:	48 89 e5             	mov    %rsp,%rbp
  804044:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804048:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80404c:	48 89 c7             	mov    %rax,%rdi
  80404f:	48 b8 c9 1e 80 00 00 	movabs $0x801ec9,%rax
  804056:	00 00 00 
  804059:	ff d0                	callq  *%rax
  80405b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80405e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804062:	79 05                	jns    804069 <opencons+0x29>
		return r;
  804064:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804067:	eb 5b                	jmp    8040c4 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804069:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80406d:	ba 07 04 00 00       	mov    $0x407,%edx
  804072:	48 89 c6             	mov    %rax,%rsi
  804075:	bf 00 00 00 00       	mov    $0x0,%edi
  80407a:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  804081:	00 00 00 
  804084:	ff d0                	callq  *%rax
  804086:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804089:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80408d:	79 05                	jns    804094 <opencons+0x54>
		return r;
  80408f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804092:	eb 30                	jmp    8040c4 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804094:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804098:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80409f:	00 00 00 
  8040a2:	8b 12                	mov    (%rdx),%edx
  8040a4:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8040a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040aa:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8040b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040b5:	48 89 c7             	mov    %rax,%rdi
  8040b8:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  8040bf:	00 00 00 
  8040c2:	ff d0                	callq  *%rax
}
  8040c4:	c9                   	leaveq 
  8040c5:	c3                   	retq   

00000000008040c6 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8040c6:	55                   	push   %rbp
  8040c7:	48 89 e5             	mov    %rsp,%rbp
  8040ca:	48 83 ec 30          	sub    $0x30,%rsp
  8040ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8040d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8040da:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8040df:	75 07                	jne    8040e8 <devcons_read+0x22>
		return 0;
  8040e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8040e6:	eb 4b                	jmp    804133 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8040e8:	eb 0c                	jmp    8040f6 <devcons_read+0x30>
		sys_yield();
  8040ea:	48 b8 5d 1a 80 00 00 	movabs $0x801a5d,%rax
  8040f1:	00 00 00 
  8040f4:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8040f6:	48 b8 9d 19 80 00 00 	movabs $0x80199d,%rax
  8040fd:	00 00 00 
  804100:	ff d0                	callq  *%rax
  804102:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804105:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804109:	74 df                	je     8040ea <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80410b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80410f:	79 05                	jns    804116 <devcons_read+0x50>
		return c;
  804111:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804114:	eb 1d                	jmp    804133 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804116:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80411a:	75 07                	jne    804123 <devcons_read+0x5d>
		return 0;
  80411c:	b8 00 00 00 00       	mov    $0x0,%eax
  804121:	eb 10                	jmp    804133 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804123:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804126:	89 c2                	mov    %eax,%edx
  804128:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80412c:	88 10                	mov    %dl,(%rax)
	return 1;
  80412e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804133:	c9                   	leaveq 
  804134:	c3                   	retq   

0000000000804135 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804135:	55                   	push   %rbp
  804136:	48 89 e5             	mov    %rsp,%rbp
  804139:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804140:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804147:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80414e:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804155:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80415c:	eb 76                	jmp    8041d4 <devcons_write+0x9f>
		m = n - tot;
  80415e:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804165:	89 c2                	mov    %eax,%edx
  804167:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80416a:	29 c2                	sub    %eax,%edx
  80416c:	89 d0                	mov    %edx,%eax
  80416e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804171:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804174:	83 f8 7f             	cmp    $0x7f,%eax
  804177:	76 07                	jbe    804180 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804179:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804180:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804183:	48 63 d0             	movslq %eax,%rdx
  804186:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804189:	48 63 c8             	movslq %eax,%rcx
  80418c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804193:	48 01 c1             	add    %rax,%rcx
  804196:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80419d:	48 89 ce             	mov    %rcx,%rsi
  8041a0:	48 89 c7             	mov    %rax,%rdi
  8041a3:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  8041aa:	00 00 00 
  8041ad:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8041af:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041b2:	48 63 d0             	movslq %eax,%rdx
  8041b5:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8041bc:	48 89 d6             	mov    %rdx,%rsi
  8041bf:	48 89 c7             	mov    %rax,%rdi
  8041c2:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  8041c9:	00 00 00 
  8041cc:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8041ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041d1:	01 45 fc             	add    %eax,-0x4(%rbp)
  8041d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041d7:	48 98                	cltq   
  8041d9:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8041e0:	0f 82 78 ff ff ff    	jb     80415e <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8041e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8041e9:	c9                   	leaveq 
  8041ea:	c3                   	retq   

00000000008041eb <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8041eb:	55                   	push   %rbp
  8041ec:	48 89 e5             	mov    %rsp,%rbp
  8041ef:	48 83 ec 08          	sub    $0x8,%rsp
  8041f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8041f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041fc:	c9                   	leaveq 
  8041fd:	c3                   	retq   

00000000008041fe <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8041fe:	55                   	push   %rbp
  8041ff:	48 89 e5             	mov    %rsp,%rbp
  804202:	48 83 ec 10          	sub    $0x10,%rsp
  804206:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80420a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80420e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804212:	48 be 14 4d 80 00 00 	movabs $0x804d14,%rsi
  804219:	00 00 00 
  80421c:	48 89 c7             	mov    %rax,%rdi
  80421f:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  804226:	00 00 00 
  804229:	ff d0                	callq  *%rax
	return 0;
  80422b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804230:	c9                   	leaveq 
  804231:	c3                   	retq   

0000000000804232 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804232:	55                   	push   %rbp
  804233:	48 89 e5             	mov    %rsp,%rbp
  804236:	48 83 ec 30          	sub    $0x30,%rsp
  80423a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80423e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804242:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  804246:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80424b:	75 0e                	jne    80425b <ipc_recv+0x29>
		pg = (void*) UTOP;
  80424d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804254:	00 00 00 
  804257:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  80425b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80425f:	48 89 c7             	mov    %rax,%rdi
  804262:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  804269:	00 00 00 
  80426c:	ff d0                	callq  *%rax
  80426e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804271:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804275:	79 27                	jns    80429e <ipc_recv+0x6c>
		if (from_env_store)
  804277:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80427c:	74 0a                	je     804288 <ipc_recv+0x56>
			*from_env_store = 0;
  80427e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804282:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  804288:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80428d:	74 0a                	je     804299 <ipc_recv+0x67>
			*perm_store = 0;
  80428f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804293:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  804299:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80429c:	eb 53                	jmp    8042f1 <ipc_recv+0xbf>
	}
	if (from_env_store)
  80429e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8042a3:	74 19                	je     8042be <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8042a5:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8042ac:	00 00 00 
  8042af:	48 8b 00             	mov    (%rax),%rax
  8042b2:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8042b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042bc:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8042be:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8042c3:	74 19                	je     8042de <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8042c5:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8042cc:	00 00 00 
  8042cf:	48 8b 00             	mov    (%rax),%rax
  8042d2:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8042d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042dc:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8042de:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8042e5:	00 00 00 
  8042e8:	48 8b 00             	mov    (%rax),%rax
  8042eb:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  8042f1:	c9                   	leaveq 
  8042f2:	c3                   	retq   

00000000008042f3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8042f3:	55                   	push   %rbp
  8042f4:	48 89 e5             	mov    %rsp,%rbp
  8042f7:	48 83 ec 30          	sub    $0x30,%rsp
  8042fb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8042fe:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804301:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804305:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804308:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80430d:	75 10                	jne    80431f <ipc_send+0x2c>
		pg = (void*) UTOP;
  80430f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804316:	00 00 00 
  804319:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80431d:	eb 0e                	jmp    80432d <ipc_send+0x3a>
  80431f:	eb 0c                	jmp    80432d <ipc_send+0x3a>
		sys_yield();
  804321:	48 b8 5d 1a 80 00 00 	movabs $0x801a5d,%rax
  804328:	00 00 00 
  80432b:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80432d:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804330:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804333:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804337:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80433a:	89 c7                	mov    %eax,%edi
  80433c:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  804343:	00 00 00 
  804346:	ff d0                	callq  *%rax
  804348:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80434b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80434f:	74 d0                	je     804321 <ipc_send+0x2e>
		sys_yield();
	}
	if (r < 0)
  804351:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804355:	79 30                	jns    804387 <ipc_send+0x94>
		panic("error in ipc_send: %e", r);
  804357:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80435a:	89 c1                	mov    %eax,%ecx
  80435c:	48 ba 1b 4d 80 00 00 	movabs $0x804d1b,%rdx
  804363:	00 00 00 
  804366:	be 47 00 00 00       	mov    $0x47,%esi
  80436b:	48 bf 31 4d 80 00 00 	movabs $0x804d31,%rdi
  804372:	00 00 00 
  804375:	b8 00 00 00 00       	mov    $0x0,%eax
  80437a:	49 b8 7e 03 80 00 00 	movabs $0x80037e,%r8
  804381:	00 00 00 
  804384:	41 ff d0             	callq  *%r8

}
  804387:	c9                   	leaveq 
  804388:	c3                   	retq   

0000000000804389 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  804389:	55                   	push   %rbp
  80438a:	48 89 e5             	mov    %rsp,%rbp
  80438d:	53                   	push   %rbx
  80438e:	48 83 ec 28          	sub    $0x28,%rsp
  804392:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  804396:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  80439d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  8043a4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8043a9:	75 0e                	jne    8043b9 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  8043ab:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8043b2:	00 00 00 
  8043b5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  8043b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043bd:	ba 07 00 00 00       	mov    $0x7,%edx
  8043c2:	48 89 c6             	mov    %rax,%rsi
  8043c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8043ca:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  8043d1:	00 00 00 
  8043d4:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8043d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043da:	48 c1 e8 0c          	shr    $0xc,%rax
  8043de:	48 89 c2             	mov    %rax,%rdx
  8043e1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8043e8:	01 00 00 
  8043eb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8043ef:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8043f5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  8043f9:	b8 03 00 00 00       	mov    $0x3,%eax
  8043fe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804402:	48 89 d3             	mov    %rdx,%rbx
  804405:	0f 01 c1             	vmcall 
  804408:	89 f2                	mov    %esi,%edx
  80440a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80440d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	/* cprintf("Returned IPC response from host: %d %d\n", r, -val);*/
	if (r < 0) {
  804410:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804414:	79 05                	jns    80441b <ipc_host_recv+0x92>
		return r;
  804416:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804419:	eb 03                	jmp    80441e <ipc_host_recv+0x95>
	}
	return val;
  80441b:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  80441e:	48 83 c4 28          	add    $0x28,%rsp
  804422:	5b                   	pop    %rbx
  804423:	5d                   	pop    %rbp
  804424:	c3                   	retq   

0000000000804425 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804425:	55                   	push   %rbp
  804426:	48 89 e5             	mov    %rsp,%rbp
  804429:	53                   	push   %rbx
  80442a:	48 83 ec 38          	sub    $0x38,%rsp
  80442e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804431:	89 75 d8             	mov    %esi,-0x28(%rbp)
  804434:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804438:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  80443b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  804442:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  804447:	75 0e                	jne    804457 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  804449:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804450:	00 00 00 
  804453:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804457:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80445b:	48 c1 e8 0c          	shr    $0xc,%rax
  80445f:	48 89 c2             	mov    %rax,%rdx
  804462:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804469:	01 00 00 
  80446c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804470:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804476:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  80447a:	b8 02 00 00 00       	mov    $0x2,%eax
  80447f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  804482:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804485:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804489:	8b 75 cc             	mov    -0x34(%rbp),%esi
  80448c:	89 fb                	mov    %edi,%ebx
  80448e:	0f 01 c1             	vmcall 
  804491:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804494:	eb 26                	jmp    8044bc <ipc_host_send+0x97>
		sys_yield();
  804496:	48 b8 5d 1a 80 00 00 	movabs $0x801a5d,%rax
  80449d:	00 00 00 
  8044a0:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8044a2:	b8 02 00 00 00       	mov    $0x2,%eax
  8044a7:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8044aa:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8044ad:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8044b1:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8044b4:	89 fb                	mov    %edi,%ebx
  8044b6:	0f 01 c1             	vmcall 
  8044b9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8044bc:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  8044c0:	74 d4                	je     804496 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  8044c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8044c6:	79 30                	jns    8044f8 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  8044c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044cb:	89 c1                	mov    %eax,%ecx
  8044cd:	48 ba 1b 4d 80 00 00 	movabs $0x804d1b,%rdx
  8044d4:	00 00 00 
  8044d7:	be 79 00 00 00       	mov    $0x79,%esi
  8044dc:	48 bf 31 4d 80 00 00 	movabs $0x804d31,%rdi
  8044e3:	00 00 00 
  8044e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8044eb:	49 b8 7e 03 80 00 00 	movabs $0x80037e,%r8
  8044f2:	00 00 00 
  8044f5:	41 ff d0             	callq  *%r8

}
  8044f8:	48 83 c4 38          	add    $0x38,%rsp
  8044fc:	5b                   	pop    %rbx
  8044fd:	5d                   	pop    %rbp
  8044fe:	c3                   	retq   

00000000008044ff <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8044ff:	55                   	push   %rbp
  804500:	48 89 e5             	mov    %rsp,%rbp
  804503:	48 83 ec 14          	sub    $0x14,%rsp
  804507:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80450a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804511:	eb 4e                	jmp    804561 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804513:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80451a:	00 00 00 
  80451d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804520:	48 98                	cltq   
  804522:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804529:	48 01 d0             	add    %rdx,%rax
  80452c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804532:	8b 00                	mov    (%rax),%eax
  804534:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804537:	75 24                	jne    80455d <ipc_find_env+0x5e>
			return envs[i].env_id;
  804539:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804540:	00 00 00 
  804543:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804546:	48 98                	cltq   
  804548:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80454f:	48 01 d0             	add    %rdx,%rax
  804552:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804558:	8b 40 08             	mov    0x8(%rax),%eax
  80455b:	eb 12                	jmp    80456f <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80455d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804561:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804568:	7e a9                	jle    804513 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80456a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80456f:	c9                   	leaveq 
  804570:	c3                   	retq   

0000000000804571 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804571:	55                   	push   %rbp
  804572:	48 89 e5             	mov    %rsp,%rbp
  804575:	48 83 ec 18          	sub    $0x18,%rsp
  804579:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80457d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804581:	48 c1 e8 15          	shr    $0x15,%rax
  804585:	48 89 c2             	mov    %rax,%rdx
  804588:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80458f:	01 00 00 
  804592:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804596:	83 e0 01             	and    $0x1,%eax
  804599:	48 85 c0             	test   %rax,%rax
  80459c:	75 07                	jne    8045a5 <pageref+0x34>
		return 0;
  80459e:	b8 00 00 00 00       	mov    $0x0,%eax
  8045a3:	eb 53                	jmp    8045f8 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8045a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045a9:	48 c1 e8 0c          	shr    $0xc,%rax
  8045ad:	48 89 c2             	mov    %rax,%rdx
  8045b0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8045b7:	01 00 00 
  8045ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8045be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8045c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045c6:	83 e0 01             	and    $0x1,%eax
  8045c9:	48 85 c0             	test   %rax,%rax
  8045cc:	75 07                	jne    8045d5 <pageref+0x64>
		return 0;
  8045ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8045d3:	eb 23                	jmp    8045f8 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8045d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045d9:	48 c1 e8 0c          	shr    $0xc,%rax
  8045dd:	48 89 c2             	mov    %rax,%rdx
  8045e0:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8045e7:	00 00 00 
  8045ea:	48 c1 e2 04          	shl    $0x4,%rdx
  8045ee:	48 01 d0             	add    %rdx,%rax
  8045f1:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8045f5:	0f b7 c0             	movzwl %ax,%eax
}
  8045f8:	c9                   	leaveq 
  8045f9:	c3                   	retq   
