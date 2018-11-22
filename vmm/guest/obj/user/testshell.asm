
vmm/guest/obj/user/testshell:     file format elf64-x86-64


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
  80003c:	e8 f5 07 00 00       	callq  800836 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void wrong(int, int, int);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;
	int pfds[2];

	close(0);
  800052:	bf 00 00 00 00       	mov    $0x0,%edi
  800057:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  80005e:	00 00 00 
  800061:	ff d0                	callq  *%rax
	close(1);
  800063:	bf 01 00 00 00       	mov    $0x1,%edi
  800068:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  80006f:	00 00 00 
  800072:	ff d0                	callq  *%rax
	opencons();
  800074:	48 b8 44 06 80 00 00 	movabs $0x800644,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
	opencons();
  800080:	48 b8 44 06 80 00 00 	movabs $0x800644,%rax
  800087:	00 00 00 
  80008a:	ff d0                	callq  *%rax

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80008c:	be 00 00 00 00       	mov    $0x0,%esi
  800091:	48 bf e0 58 80 00 00 	movabs $0x8058e0,%rdi
  800098:	00 00 00 
  80009b:	48 b8 dc 33 80 00 00 	movabs $0x8033dc,%rax
  8000a2:	00 00 00 
  8000a5:	ff d0                	callq  *%rax
  8000a7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8000ae:	79 30                	jns    8000e0 <umain+0x9d>
		panic("open testshell.sh: %e", rfd);
  8000b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000b3:	89 c1                	mov    %eax,%ecx
  8000b5:	48 ba ed 58 80 00 00 	movabs $0x8058ed,%rdx
  8000bc:	00 00 00 
  8000bf:	be 14 00 00 00       	mov    $0x14,%esi
  8000c4:	48 bf 03 59 80 00 00 	movabs $0x805903,%rdi
  8000cb:	00 00 00 
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  8000da:	00 00 00 
  8000dd:	41 ff d0             	callq  *%r8
	if ((wfd = pipe(pfds)) < 0)
  8000e0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8000e4:	48 89 c7             	mov    %rax,%rdi
  8000e7:	48 b8 8f 4d 80 00 00 	movabs $0x804d8f,%rax
  8000ee:	00 00 00 
  8000f1:	ff d0                	callq  *%rax
  8000f3:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8000fa:	79 30                	jns    80012c <umain+0xe9>
		panic("pipe: %e", wfd);
  8000fc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ff:	89 c1                	mov    %eax,%ecx
  800101:	48 ba 14 59 80 00 00 	movabs $0x805914,%rdx
  800108:	00 00 00 
  80010b:	be 16 00 00 00       	mov    $0x16,%esi
  800110:	48 bf 03 59 80 00 00 	movabs $0x805903,%rdi
  800117:	00 00 00 
  80011a:	b8 00 00 00 00       	mov    $0x0,%eax
  80011f:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  800126:	00 00 00 
  800129:	41 ff d0             	callq  *%r8
	wfd = pfds[1];
  80012c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80012f:	89 45 f0             	mov    %eax,-0x10(%rbp)

	cprintf("running sh -x < testshell.sh | cat\n");
  800132:	48 bf 20 59 80 00 00 	movabs $0x805920,%rdi
  800139:	00 00 00 
  80013c:	b8 00 00 00 00       	mov    $0x0,%eax
  800141:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  800148:	00 00 00 
  80014b:	ff d2                	callq  *%rdx
	if ((r = fork()) < 0)
  80014d:	48 b8 79 27 80 00 00 	movabs $0x802779,%rax
  800154:	00 00 00 
  800157:	ff d0                	callq  *%rax
  800159:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80015c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800160:	79 30                	jns    800192 <umain+0x14f>
		panic("fork: %e", r);
  800162:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800165:	89 c1                	mov    %eax,%ecx
  800167:	48 ba 44 59 80 00 00 	movabs $0x805944,%rdx
  80016e:	00 00 00 
  800171:	be 1b 00 00 00       	mov    $0x1b,%esi
  800176:	48 bf 03 59 80 00 00 	movabs $0x805903,%rdi
  80017d:	00 00 00 
  800180:	b8 00 00 00 00       	mov    $0x0,%eax
  800185:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  80018c:	00 00 00 
  80018f:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800192:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800196:	0f 85 fb 00 00 00    	jne    800297 <umain+0x254>
		dup(rfd, 0);
  80019c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
  8001a4:	89 c7                	mov    %eax,%edi
  8001a6:	48 b8 5d 2d 80 00 00 	movabs $0x802d5d,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax
		dup(wfd, 1);
  8001b2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001b5:	be 01 00 00 00       	mov    $0x1,%esi
  8001ba:	89 c7                	mov    %eax,%edi
  8001bc:	48 b8 5d 2d 80 00 00 	movabs $0x802d5d,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
		close(rfd);
  8001c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
		close(wfd);
  8001d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
		if ((r = spawnl("/bin/sh", "sh", "-x", 0)) < 0)
  8001ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ef:	48 ba 4d 59 80 00 00 	movabs $0x80594d,%rdx
  8001f6:	00 00 00 
  8001f9:	48 be 50 59 80 00 00 	movabs $0x805950,%rsi
  800200:	00 00 00 
  800203:	48 bf 53 59 80 00 00 	movabs $0x805953,%rdi
  80020a:	00 00 00 
  80020d:	b8 00 00 00 00       	mov    $0x0,%eax
  800212:	49 b8 6c 3d 80 00 00 	movabs $0x803d6c,%r8
  800219:	00 00 00 
  80021c:	41 ff d0             	callq  *%r8
  80021f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800222:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800226:	79 30                	jns    800258 <umain+0x215>
			panic("spawn: %e", r);
  800228:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80022b:	89 c1                	mov    %eax,%ecx
  80022d:	48 ba 5b 59 80 00 00 	movabs $0x80595b,%rdx
  800234:	00 00 00 
  800237:	be 22 00 00 00       	mov    $0x22,%esi
  80023c:	48 bf 03 59 80 00 00 	movabs $0x805903,%rdi
  800243:	00 00 00 
  800246:	b8 00 00 00 00       	mov    $0x0,%eax
  80024b:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  800252:	00 00 00 
  800255:	41 ff d0             	callq  *%r8
		close(0);
  800258:	bf 00 00 00 00       	mov    $0x0,%edi
  80025d:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  800264:	00 00 00 
  800267:	ff d0                	callq  *%rax
		close(1);
  800269:	bf 01 00 00 00       	mov    $0x1,%edi
  80026e:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  800275:	00 00 00 
  800278:	ff d0                	callq  *%rax
		wait(r);
  80027a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027d:	89 c7                	mov    %eax,%edi
  80027f:	48 b8 58 53 80 00 00 	movabs $0x805358,%rax
  800286:	00 00 00 
  800289:	ff d0                	callq  *%rax
		exit();
  80028b:	48 b8 b9 08 80 00 00 	movabs $0x8008b9,%rax
  800292:	00 00 00 
  800295:	ff d0                	callq  *%rax
	}
	close(rfd);
  800297:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029a:	89 c7                	mov    %eax,%edi
  80029c:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  8002a3:	00 00 00 
  8002a6:	ff d0                	callq  *%rax
	close(wfd);
  8002a8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002ab:	89 c7                	mov    %eax,%edi
  8002ad:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  8002b4:	00 00 00 
  8002b7:	ff d0                	callq  *%rax

	rfd = pfds[0];
  8002b9:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002bc:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002bf:	be 00 00 00 00       	mov    $0x0,%esi
  8002c4:	48 bf 65 59 80 00 00 	movabs $0x805965,%rdi
  8002cb:	00 00 00 
  8002ce:	48 b8 dc 33 80 00 00 	movabs $0x8033dc,%rax
  8002d5:	00 00 00 
  8002d8:	ff d0                	callq  *%rax
  8002da:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e1:	79 30                	jns    800313 <umain+0x2d0>
		panic("open testshell.key for reading: %e", kfd);
  8002e3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002e6:	89 c1                	mov    %eax,%ecx
  8002e8:	48 ba 78 59 80 00 00 	movabs $0x805978,%rdx
  8002ef:	00 00 00 
  8002f2:	be 2d 00 00 00       	mov    $0x2d,%esi
  8002f7:	48 bf 03 59 80 00 00 	movabs $0x805903,%rdi
  8002fe:	00 00 00 
  800301:	b8 00 00 00 00       	mov    $0x0,%eax
  800306:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  80030d:	00 00 00 
  800310:	41 ff d0             	callq  *%r8

	nloff = 0;
  800313:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	for (off=0;; off++) {
  80031a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		n1 = read(rfd, &c1, 1);
  800321:	48 8d 4d df          	lea    -0x21(%rbp),%rcx
  800325:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800328:	ba 01 00 00 00       	mov    $0x1,%edx
  80032d:	48 89 ce             	mov    %rcx,%rsi
  800330:	89 c7                	mov    %eax,%edi
  800332:	48 b8 06 2f 80 00 00 	movabs $0x802f06,%rax
  800339:	00 00 00 
  80033c:	ff d0                	callq  *%rax
  80033e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		n2 = read(kfd, &c2, 1);
  800341:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
  800345:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800348:	ba 01 00 00 00       	mov    $0x1,%edx
  80034d:	48 89 ce             	mov    %rcx,%rsi
  800350:	89 c7                	mov    %eax,%edi
  800352:	48 b8 06 2f 80 00 00 	movabs $0x802f06,%rax
  800359:	00 00 00 
  80035c:	ff d0                	callq  *%rax
  80035e:	89 45 e0             	mov    %eax,-0x20(%rbp)
		if (n1 < 0)
  800361:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800365:	79 30                	jns    800397 <umain+0x354>
			panic("reading testshell.out: %e", n1);
  800367:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036a:	89 c1                	mov    %eax,%ecx
  80036c:	48 ba 9b 59 80 00 00 	movabs $0x80599b,%rdx
  800373:	00 00 00 
  800376:	be 34 00 00 00       	mov    $0x34,%esi
  80037b:	48 bf 03 59 80 00 00 	movabs $0x805903,%rdi
  800382:	00 00 00 
  800385:	b8 00 00 00 00       	mov    $0x0,%eax
  80038a:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  800391:	00 00 00 
  800394:	41 ff d0             	callq  *%r8
		if (n2 < 0)
  800397:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80039b:	79 30                	jns    8003cd <umain+0x38a>
			panic("reading testshell.key: %e", n2);
  80039d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8003a0:	89 c1                	mov    %eax,%ecx
  8003a2:	48 ba b5 59 80 00 00 	movabs $0x8059b5,%rdx
  8003a9:	00 00 00 
  8003ac:	be 36 00 00 00       	mov    $0x36,%esi
  8003b1:	48 bf 03 59 80 00 00 	movabs $0x805903,%rdi
  8003b8:	00 00 00 
  8003bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c0:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  8003c7:	00 00 00 
  8003ca:	41 ff d0             	callq  *%r8
		if (n1 == 0 && n2 == 0)
  8003cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8003d1:	75 08                	jne    8003db <umain+0x398>
  8003d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8003d7:	75 02                	jne    8003db <umain+0x398>
			break;
  8003d9:	eb 4b                	jmp    800426 <umain+0x3e3>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8003db:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003df:	75 12                	jne    8003f3 <umain+0x3b0>
  8003e1:	83 7d e0 01          	cmpl   $0x1,-0x20(%rbp)
  8003e5:	75 0c                	jne    8003f3 <umain+0x3b0>
  8003e7:	0f b6 55 df          	movzbl -0x21(%rbp),%edx
  8003eb:	0f b6 45 de          	movzbl -0x22(%rbp),%eax
  8003ef:	38 c2                	cmp    %al,%dl
  8003f1:	74 19                	je     80040c <umain+0x3c9>
			wrong(rfd, kfd, nloff);
  8003f3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8003f6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8003f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8003fc:	89 ce                	mov    %ecx,%esi
  8003fe:	89 c7                	mov    %eax,%edi
  800400:	48 b8 44 04 80 00 00 	movabs $0x800444,%rax
  800407:	00 00 00 
  80040a:	ff d0                	callq  *%rax
		if (c1 == '\n')
  80040c:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  800410:	3c 0a                	cmp    $0xa,%al
  800412:	75 09                	jne    80041d <umain+0x3da>
			nloff = off+1;
  800414:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800417:	83 c0 01             	add    $0x1,%eax
  80041a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	rfd = pfds[0];
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
		panic("open testshell.key for reading: %e", kfd);

	nloff = 0;
	for (off=0;; off++) {
  80041d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
			wrong(rfd, kfd, nloff);
		if (c1 == '\n')
			nloff = off+1;
	}
  800421:	e9 fb fe ff ff       	jmpq   800321 <umain+0x2de>
	cprintf("shell ran correctly\n");
  800426:	48 bf cf 59 80 00 00 	movabs $0x8059cf,%rdi
  80042d:	00 00 00 
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
  800435:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  80043c:	00 00 00 
  80043f:	ff d2                	callq  *%rdx
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800441:	cc                   	int3   

	breakpoint();
}
  800442:	c9                   	leaveq 
  800443:	c3                   	retq   

0000000000800444 <wrong>:

void
wrong(int rfd, int kfd, int off)
{
  800444:	55                   	push   %rbp
  800445:	48 89 e5             	mov    %rsp,%rbp
  800448:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
  80044c:	89 7d 8c             	mov    %edi,-0x74(%rbp)
  80044f:	89 75 88             	mov    %esi,-0x78(%rbp)
  800452:	89 55 84             	mov    %edx,-0x7c(%rbp)
	char buf[100];
	int n;

	seek(rfd, off);
  800455:	8b 55 84             	mov    -0x7c(%rbp),%edx
  800458:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80045b:	89 d6                	mov    %edx,%esi
  80045d:	89 c7                	mov    %eax,%edi
  80045f:	48 b8 24 31 80 00 00 	movabs $0x803124,%rax
  800466:	00 00 00 
  800469:	ff d0                	callq  *%rax
	seek(kfd, off);
  80046b:	8b 55 84             	mov    -0x7c(%rbp),%edx
  80046e:	8b 45 88             	mov    -0x78(%rbp),%eax
  800471:	89 d6                	mov    %edx,%esi
  800473:	89 c7                	mov    %eax,%edi
  800475:	48 b8 24 31 80 00 00 	movabs $0x803124,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax

	cprintf("shell produced incorrect output.\n");
  800481:	48 bf e8 59 80 00 00 	movabs $0x8059e8,%rdi
  800488:	00 00 00 
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  800497:	00 00 00 
  80049a:	ff d2                	callq  *%rdx
	cprintf("expected:\n===\n");
  80049c:	48 bf 0a 5a 80 00 00 	movabs $0x805a0a,%rdi
  8004a3:	00 00 00 
  8004a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ab:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  8004b2:	00 00 00 
  8004b5:	ff d2                	callq  *%rdx
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004b7:	eb 1c                	jmp    8004d5 <wrong+0x91>
		sys_cputs(buf, n);
  8004b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004bc:	48 63 d0             	movslq %eax,%rdx
  8004bf:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8004c3:	48 89 d6             	mov    %rdx,%rsi
  8004c6:	48 89 c7             	mov    %rax,%rdi
  8004c9:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  8004d0:	00 00 00 
  8004d3:	ff d0                	callq  *%rax
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004d5:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  8004d9:	8b 45 88             	mov    -0x78(%rbp),%eax
  8004dc:	ba 63 00 00 00       	mov    $0x63,%edx
  8004e1:	48 89 ce             	mov    %rcx,%rsi
  8004e4:	89 c7                	mov    %eax,%edi
  8004e6:	48 b8 06 2f 80 00 00 	movabs $0x802f06,%rax
  8004ed:	00 00 00 
  8004f0:	ff d0                	callq  *%rax
  8004f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004f9:	7f be                	jg     8004b9 <wrong+0x75>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8004fb:	48 bf 19 5a 80 00 00 	movabs $0x805a19,%rdi
  800502:	00 00 00 
  800505:	b8 00 00 00 00       	mov    $0x0,%eax
  80050a:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  800511:	00 00 00 
  800514:	ff d2                	callq  *%rdx
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800516:	eb 1c                	jmp    800534 <wrong+0xf0>
		sys_cputs(buf, n);
  800518:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80051b:	48 63 d0             	movslq %eax,%rdx
  80051e:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  800522:	48 89 d6             	mov    %rdx,%rsi
  800525:	48 89 c7             	mov    %rax,%rdi
  800528:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  80052f:	00 00 00 
  800532:	ff d0                	callq  *%rax
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800534:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  800538:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80053b:	ba 63 00 00 00       	mov    $0x63,%edx
  800540:	48 89 ce             	mov    %rcx,%rsi
  800543:	89 c7                	mov    %eax,%edi
  800545:	48 b8 06 2f 80 00 00 	movabs $0x802f06,%rax
  80054c:	00 00 00 
  80054f:	ff d0                	callq  *%rax
  800551:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800554:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800558:	7f be                	jg     800518 <wrong+0xd4>
		sys_cputs(buf, n);
	cprintf("===\n");
  80055a:	48 bf 27 5a 80 00 00 	movabs $0x805a27,%rdi
  800561:	00 00 00 
  800564:	b8 00 00 00 00       	mov    $0x0,%eax
  800569:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  800570:	00 00 00 
  800573:	ff d2                	callq  *%rdx
	exit();
  800575:	48 b8 b9 08 80 00 00 	movabs $0x8008b9,%rax
  80057c:	00 00 00 
  80057f:	ff d0                	callq  *%rax
}
  800581:	c9                   	leaveq 
  800582:	c3                   	retq   

0000000000800583 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800583:	55                   	push   %rbp
  800584:	48 89 e5             	mov    %rsp,%rbp
  800587:	48 83 ec 20          	sub    $0x20,%rsp
  80058b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80058e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800591:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800594:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800598:	be 01 00 00 00       	mov    $0x1,%esi
  80059d:	48 89 c7             	mov    %rax,%rdi
  8005a0:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  8005a7:	00 00 00 
  8005aa:	ff d0                	callq  *%rax
}
  8005ac:	c9                   	leaveq 
  8005ad:	c3                   	retq   

00000000008005ae <getchar>:

int
getchar(void)
{
  8005ae:	55                   	push   %rbp
  8005af:	48 89 e5             	mov    %rsp,%rbp
  8005b2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8005b6:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8005ba:	ba 01 00 00 00       	mov    $0x1,%edx
  8005bf:	48 89 c6             	mov    %rax,%rsi
  8005c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8005c7:	48 b8 06 2f 80 00 00 	movabs $0x802f06,%rax
  8005ce:	00 00 00 
  8005d1:	ff d0                	callq  *%rax
  8005d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8005d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005da:	79 05                	jns    8005e1 <getchar+0x33>
		return r;
  8005dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005df:	eb 14                	jmp    8005f5 <getchar+0x47>
	if (r < 1)
  8005e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005e5:	7f 07                	jg     8005ee <getchar+0x40>
		return -E_EOF;
  8005e7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8005ec:	eb 07                	jmp    8005f5 <getchar+0x47>
	return c;
  8005ee:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8005f2:	0f b6 c0             	movzbl %al,%eax

}
  8005f5:	c9                   	leaveq 
  8005f6:	c3                   	retq   

00000000008005f7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8005f7:	55                   	push   %rbp
  8005f8:	48 89 e5             	mov    %rsp,%rbp
  8005fb:	48 83 ec 20          	sub    $0x20,%rsp
  8005ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800602:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800606:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800609:	48 89 d6             	mov    %rdx,%rsi
  80060c:	89 c7                	mov    %eax,%edi
  80060e:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  800615:	00 00 00 
  800618:	ff d0                	callq  *%rax
  80061a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80061d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800621:	79 05                	jns    800628 <iscons+0x31>
		return r;
  800623:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800626:	eb 1a                	jmp    800642 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800628:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062c:	8b 10                	mov    (%rax),%edx
  80062e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800635:	00 00 00 
  800638:	8b 00                	mov    (%rax),%eax
  80063a:	39 c2                	cmp    %eax,%edx
  80063c:	0f 94 c0             	sete   %al
  80063f:	0f b6 c0             	movzbl %al,%eax
}
  800642:	c9                   	leaveq 
  800643:	c3                   	retq   

0000000000800644 <opencons>:

int
opencons(void)
{
  800644:	55                   	push   %rbp
  800645:	48 89 e5             	mov    %rsp,%rbp
  800648:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80064c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800650:	48 89 c7             	mov    %rax,%rdi
  800653:	48 b8 3c 2a 80 00 00 	movabs $0x802a3c,%rax
  80065a:	00 00 00 
  80065d:	ff d0                	callq  *%rax
  80065f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800662:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800666:	79 05                	jns    80066d <opencons+0x29>
		return r;
  800668:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80066b:	eb 5b                	jmp    8006c8 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80066d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800671:	ba 07 04 00 00       	mov    $0x407,%edx
  800676:	48 89 c6             	mov    %rax,%rsi
  800679:	bf 00 00 00 00       	mov    $0x0,%edi
  80067e:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  800685:	00 00 00 
  800688:	ff d0                	callq  *%rax
  80068a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80068d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800691:	79 05                	jns    800698 <opencons+0x54>
		return r;
  800693:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800696:	eb 30                	jmp    8006c8 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  800698:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069c:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8006a3:	00 00 00 
  8006a6:	8b 12                	mov    (%rdx),%edx
  8006a8:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8006aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ae:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8006b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006b9:	48 89 c7             	mov    %rax,%rdi
  8006bc:	48 b8 ee 29 80 00 00 	movabs $0x8029ee,%rax
  8006c3:	00 00 00 
  8006c6:	ff d0                	callq  *%rax
}
  8006c8:	c9                   	leaveq 
  8006c9:	c3                   	retq   

00000000008006ca <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8006ca:	55                   	push   %rbp
  8006cb:	48 89 e5             	mov    %rsp,%rbp
  8006ce:	48 83 ec 30          	sub    $0x30,%rsp
  8006d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8006de:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8006e3:	75 07                	jne    8006ec <devcons_read+0x22>
		return 0;
  8006e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ea:	eb 4b                	jmp    800737 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8006ec:	eb 0c                	jmp    8006fa <devcons_read+0x30>
		sys_yield();
  8006ee:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  8006f5:	00 00 00 
  8006f8:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8006fa:	48 b8 fb 1e 80 00 00 	movabs $0x801efb,%rax
  800701:	00 00 00 
  800704:	ff d0                	callq  *%rax
  800706:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800709:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80070d:	74 df                	je     8006ee <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80070f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800713:	79 05                	jns    80071a <devcons_read+0x50>
		return c;
  800715:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800718:	eb 1d                	jmp    800737 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80071a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80071e:	75 07                	jne    800727 <devcons_read+0x5d>
		return 0;
  800720:	b8 00 00 00 00       	mov    $0x0,%eax
  800725:	eb 10                	jmp    800737 <devcons_read+0x6d>
	*(char*)vbuf = c;
  800727:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80072a:	89 c2                	mov    %eax,%edx
  80072c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800730:	88 10                	mov    %dl,(%rax)
	return 1;
  800732:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800737:	c9                   	leaveq 
  800738:	c3                   	retq   

0000000000800739 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800739:	55                   	push   %rbp
  80073a:	48 89 e5             	mov    %rsp,%rbp
  80073d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800744:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80074b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800752:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800759:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800760:	eb 76                	jmp    8007d8 <devcons_write+0x9f>
		m = n - tot;
  800762:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800769:	89 c2                	mov    %eax,%edx
  80076b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80076e:	29 c2                	sub    %eax,%edx
  800770:	89 d0                	mov    %edx,%eax
  800772:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  800775:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800778:	83 f8 7f             	cmp    $0x7f,%eax
  80077b:	76 07                	jbe    800784 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80077d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  800784:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800787:	48 63 d0             	movslq %eax,%rdx
  80078a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80078d:	48 63 c8             	movslq %eax,%rcx
  800790:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800797:	48 01 c1             	add    %rax,%rcx
  80079a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007a1:	48 89 ce             	mov    %rcx,%rsi
  8007a4:	48 89 c7             	mov    %rax,%rdi
  8007a7:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  8007ae:	00 00 00 
  8007b1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8007b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007b6:	48 63 d0             	movslq %eax,%rdx
  8007b9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007c0:	48 89 d6             	mov    %rdx,%rsi
  8007c3:	48 89 c7             	mov    %rax,%rdi
  8007c6:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  8007cd:	00 00 00 
  8007d0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8007d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007d5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8007d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007db:	48 98                	cltq   
  8007dd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8007e4:	0f 82 78 ff ff ff    	jb     800762 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8007ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8007ed:	c9                   	leaveq 
  8007ee:	c3                   	retq   

00000000008007ef <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8007ef:	55                   	push   %rbp
  8007f0:	48 89 e5             	mov    %rsp,%rbp
  8007f3:	48 83 ec 08          	sub    $0x8,%rsp
  8007f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800800:	c9                   	leaveq 
  800801:	c3                   	retq   

0000000000800802 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800802:	55                   	push   %rbp
  800803:	48 89 e5             	mov    %rsp,%rbp
  800806:	48 83 ec 10          	sub    $0x10,%rsp
  80080a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80080e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800812:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800816:	48 be 31 5a 80 00 00 	movabs $0x805a31,%rsi
  80081d:	00 00 00 
  800820:	48 89 c7             	mov    %rax,%rdi
  800823:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  80082a:	00 00 00 
  80082d:	ff d0                	callq  *%rax
	return 0;
  80082f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800834:	c9                   	leaveq 
  800835:	c3                   	retq   

0000000000800836 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800836:	55                   	push   %rbp
  800837:	48 89 e5             	mov    %rsp,%rbp
  80083a:	48 83 ec 10          	sub    $0x10,%rsp
  80083e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800841:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800845:	48 b8 7d 1f 80 00 00 	movabs $0x801f7d,%rax
  80084c:	00 00 00 
  80084f:	ff d0                	callq  *%rax
  800851:	25 ff 03 00 00       	and    $0x3ff,%eax
  800856:	48 98                	cltq   
  800858:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80085f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800866:	00 00 00 
  800869:	48 01 c2             	add    %rax,%rdx
  80086c:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  800873:	00 00 00 
  800876:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800879:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80087d:	7e 14                	jle    800893 <libmain+0x5d>
		binaryname = argv[0];
  80087f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800883:	48 8b 10             	mov    (%rax),%rdx
  800886:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  80088d:	00 00 00 
  800890:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800893:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800897:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80089a:	48 89 d6             	mov    %rdx,%rsi
  80089d:	89 c7                	mov    %eax,%edi
  80089f:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8008a6:	00 00 00 
  8008a9:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8008ab:	48 b8 b9 08 80 00 00 	movabs $0x8008b9,%rax
  8008b2:	00 00 00 
  8008b5:	ff d0                	callq  *%rax
}
  8008b7:	c9                   	leaveq 
  8008b8:	c3                   	retq   

00000000008008b9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8008b9:	55                   	push   %rbp
  8008ba:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8008bd:	48 b8 2f 2d 80 00 00 	movabs $0x802d2f,%rax
  8008c4:	00 00 00 
  8008c7:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8008c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8008ce:	48 b8 39 1f 80 00 00 	movabs $0x801f39,%rax
  8008d5:	00 00 00 
  8008d8:	ff d0                	callq  *%rax
}
  8008da:	5d                   	pop    %rbp
  8008db:	c3                   	retq   

00000000008008dc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8008dc:	55                   	push   %rbp
  8008dd:	48 89 e5             	mov    %rsp,%rbp
  8008e0:	53                   	push   %rbx
  8008e1:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8008e8:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8008ef:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8008f5:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8008fc:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800903:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80090a:	84 c0                	test   %al,%al
  80090c:	74 23                	je     800931 <_panic+0x55>
  80090e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800915:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800919:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80091d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800921:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800925:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800929:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80092d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800931:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800938:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80093f:	00 00 00 
  800942:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800949:	00 00 00 
  80094c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800950:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800957:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80095e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800965:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  80096c:	00 00 00 
  80096f:	48 8b 18             	mov    (%rax),%rbx
  800972:	48 b8 7d 1f 80 00 00 	movabs $0x801f7d,%rax
  800979:	00 00 00 
  80097c:	ff d0                	callq  *%rax
  80097e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800984:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80098b:	41 89 c8             	mov    %ecx,%r8d
  80098e:	48 89 d1             	mov    %rdx,%rcx
  800991:	48 89 da             	mov    %rbx,%rdx
  800994:	89 c6                	mov    %eax,%esi
  800996:	48 bf 48 5a 80 00 00 	movabs $0x805a48,%rdi
  80099d:	00 00 00 
  8009a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a5:	49 b9 15 0b 80 00 00 	movabs $0x800b15,%r9
  8009ac:	00 00 00 
  8009af:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8009b2:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8009b9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8009c0:	48 89 d6             	mov    %rdx,%rsi
  8009c3:	48 89 c7             	mov    %rax,%rdi
  8009c6:	48 b8 69 0a 80 00 00 	movabs $0x800a69,%rax
  8009cd:	00 00 00 
  8009d0:	ff d0                	callq  *%rax
	cprintf("\n");
  8009d2:	48 bf 6b 5a 80 00 00 	movabs $0x805a6b,%rdi
  8009d9:	00 00 00 
  8009dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e1:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  8009e8:	00 00 00 
  8009eb:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8009ed:	cc                   	int3   
  8009ee:	eb fd                	jmp    8009ed <_panic+0x111>

00000000008009f0 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8009f0:	55                   	push   %rbp
  8009f1:	48 89 e5             	mov    %rsp,%rbp
  8009f4:	48 83 ec 10          	sub    $0x10,%rsp
  8009f8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8009fb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8009ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a03:	8b 00                	mov    (%rax),%eax
  800a05:	8d 48 01             	lea    0x1(%rax),%ecx
  800a08:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a0c:	89 0a                	mov    %ecx,(%rdx)
  800a0e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a11:	89 d1                	mov    %edx,%ecx
  800a13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a17:	48 98                	cltq   
  800a19:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800a1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a21:	8b 00                	mov    (%rax),%eax
  800a23:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a28:	75 2c                	jne    800a56 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800a2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a2e:	8b 00                	mov    (%rax),%eax
  800a30:	48 98                	cltq   
  800a32:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a36:	48 83 c2 08          	add    $0x8,%rdx
  800a3a:	48 89 c6             	mov    %rax,%rsi
  800a3d:	48 89 d7             	mov    %rdx,%rdi
  800a40:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  800a47:	00 00 00 
  800a4a:	ff d0                	callq  *%rax
        b->idx = 0;
  800a4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a50:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800a56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a5a:	8b 40 04             	mov    0x4(%rax),%eax
  800a5d:	8d 50 01             	lea    0x1(%rax),%edx
  800a60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a64:	89 50 04             	mov    %edx,0x4(%rax)
}
  800a67:	c9                   	leaveq 
  800a68:	c3                   	retq   

0000000000800a69 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800a69:	55                   	push   %rbp
  800a6a:	48 89 e5             	mov    %rsp,%rbp
  800a6d:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800a74:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800a7b:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800a82:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800a89:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800a90:	48 8b 0a             	mov    (%rdx),%rcx
  800a93:	48 89 08             	mov    %rcx,(%rax)
  800a96:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a9a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a9e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800aa2:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800aa6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800aad:	00 00 00 
    b.cnt = 0;
  800ab0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800ab7:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800aba:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800ac1:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800ac8:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800acf:	48 89 c6             	mov    %rax,%rsi
  800ad2:	48 bf f0 09 80 00 00 	movabs $0x8009f0,%rdi
  800ad9:	00 00 00 
  800adc:	48 b8 c8 0e 80 00 00 	movabs $0x800ec8,%rax
  800ae3:	00 00 00 
  800ae6:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800ae8:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800aee:	48 98                	cltq   
  800af0:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800af7:	48 83 c2 08          	add    $0x8,%rdx
  800afb:	48 89 c6             	mov    %rax,%rsi
  800afe:	48 89 d7             	mov    %rdx,%rdi
  800b01:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  800b08:	00 00 00 
  800b0b:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800b0d:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800b13:	c9                   	leaveq 
  800b14:	c3                   	retq   

0000000000800b15 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800b15:	55                   	push   %rbp
  800b16:	48 89 e5             	mov    %rsp,%rbp
  800b19:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800b20:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800b27:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800b2e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b35:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b3c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b43:	84 c0                	test   %al,%al
  800b45:	74 20                	je     800b67 <cprintf+0x52>
  800b47:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b4b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b4f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b53:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b57:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b5b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b5f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b63:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b67:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800b6e:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800b75:	00 00 00 
  800b78:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800b7f:	00 00 00 
  800b82:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b86:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800b8d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800b94:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800b9b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ba2:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ba9:	48 8b 0a             	mov    (%rdx),%rcx
  800bac:	48 89 08             	mov    %rcx,(%rax)
  800baf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bb3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bb7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bbb:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800bbf:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800bc6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800bcd:	48 89 d6             	mov    %rdx,%rsi
  800bd0:	48 89 c7             	mov    %rax,%rdi
  800bd3:	48 b8 69 0a 80 00 00 	movabs $0x800a69,%rax
  800bda:	00 00 00 
  800bdd:	ff d0                	callq  *%rax
  800bdf:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800be5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800beb:	c9                   	leaveq 
  800bec:	c3                   	retq   

0000000000800bed <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bed:	55                   	push   %rbp
  800bee:	48 89 e5             	mov    %rsp,%rbp
  800bf1:	53                   	push   %rbx
  800bf2:	48 83 ec 38          	sub    $0x38,%rsp
  800bf6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800bfa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800bfe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800c02:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800c05:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800c09:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c0d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800c10:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800c14:	77 3b                	ja     800c51 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c16:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800c19:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800c1d:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800c20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800c24:	ba 00 00 00 00       	mov    $0x0,%edx
  800c29:	48 f7 f3             	div    %rbx
  800c2c:	48 89 c2             	mov    %rax,%rdx
  800c2f:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800c32:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800c35:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800c39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c3d:	41 89 f9             	mov    %edi,%r9d
  800c40:	48 89 c7             	mov    %rax,%rdi
  800c43:	48 b8 ed 0b 80 00 00 	movabs $0x800bed,%rax
  800c4a:	00 00 00 
  800c4d:	ff d0                	callq  *%rax
  800c4f:	eb 1e                	jmp    800c6f <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c51:	eb 12                	jmp    800c65 <printnum+0x78>
			putch(padc, putdat);
  800c53:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800c57:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800c5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c5e:	48 89 ce             	mov    %rcx,%rsi
  800c61:	89 d7                	mov    %edx,%edi
  800c63:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c65:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800c69:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800c6d:	7f e4                	jg     800c53 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c6f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800c72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800c76:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7b:	48 f7 f1             	div    %rcx
  800c7e:	48 89 d0             	mov    %rdx,%rax
  800c81:	48 ba 70 5c 80 00 00 	movabs $0x805c70,%rdx
  800c88:	00 00 00 
  800c8b:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800c8f:	0f be d0             	movsbl %al,%edx
  800c92:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800c96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c9a:	48 89 ce             	mov    %rcx,%rsi
  800c9d:	89 d7                	mov    %edx,%edi
  800c9f:	ff d0                	callq  *%rax
}
  800ca1:	48 83 c4 38          	add    $0x38,%rsp
  800ca5:	5b                   	pop    %rbx
  800ca6:	5d                   	pop    %rbp
  800ca7:	c3                   	retq   

0000000000800ca8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ca8:	55                   	push   %rbp
  800ca9:	48 89 e5             	mov    %rsp,%rbp
  800cac:	48 83 ec 1c          	sub    $0x1c,%rsp
  800cb0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800cb4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800cb7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800cbb:	7e 52                	jle    800d0f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800cbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cc1:	8b 00                	mov    (%rax),%eax
  800cc3:	83 f8 30             	cmp    $0x30,%eax
  800cc6:	73 24                	jae    800cec <getuint+0x44>
  800cc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ccc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cd4:	8b 00                	mov    (%rax),%eax
  800cd6:	89 c0                	mov    %eax,%eax
  800cd8:	48 01 d0             	add    %rdx,%rax
  800cdb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cdf:	8b 12                	mov    (%rdx),%edx
  800ce1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ce4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ce8:	89 0a                	mov    %ecx,(%rdx)
  800cea:	eb 17                	jmp    800d03 <getuint+0x5b>
  800cec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cf0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800cf4:	48 89 d0             	mov    %rdx,%rax
  800cf7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800cfb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cff:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d03:	48 8b 00             	mov    (%rax),%rax
  800d06:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d0a:	e9 a3 00 00 00       	jmpq   800db2 <getuint+0x10a>
	else if (lflag)
  800d0f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800d13:	74 4f                	je     800d64 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800d15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d19:	8b 00                	mov    (%rax),%eax
  800d1b:	83 f8 30             	cmp    $0x30,%eax
  800d1e:	73 24                	jae    800d44 <getuint+0x9c>
  800d20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d24:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d2c:	8b 00                	mov    (%rax),%eax
  800d2e:	89 c0                	mov    %eax,%eax
  800d30:	48 01 d0             	add    %rdx,%rax
  800d33:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d37:	8b 12                	mov    (%rdx),%edx
  800d39:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d3c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d40:	89 0a                	mov    %ecx,(%rdx)
  800d42:	eb 17                	jmp    800d5b <getuint+0xb3>
  800d44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d48:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d4c:	48 89 d0             	mov    %rdx,%rax
  800d4f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d53:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d57:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d5b:	48 8b 00             	mov    (%rax),%rax
  800d5e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d62:	eb 4e                	jmp    800db2 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800d64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d68:	8b 00                	mov    (%rax),%eax
  800d6a:	83 f8 30             	cmp    $0x30,%eax
  800d6d:	73 24                	jae    800d93 <getuint+0xeb>
  800d6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d73:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d7b:	8b 00                	mov    (%rax),%eax
  800d7d:	89 c0                	mov    %eax,%eax
  800d7f:	48 01 d0             	add    %rdx,%rax
  800d82:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d86:	8b 12                	mov    (%rdx),%edx
  800d88:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d8b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d8f:	89 0a                	mov    %ecx,(%rdx)
  800d91:	eb 17                	jmp    800daa <getuint+0x102>
  800d93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d97:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d9b:	48 89 d0             	mov    %rdx,%rax
  800d9e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800da2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800da6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800daa:	8b 00                	mov    (%rax),%eax
  800dac:	89 c0                	mov    %eax,%eax
  800dae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800db2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800db6:	c9                   	leaveq 
  800db7:	c3                   	retq   

0000000000800db8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800db8:	55                   	push   %rbp
  800db9:	48 89 e5             	mov    %rsp,%rbp
  800dbc:	48 83 ec 1c          	sub    $0x1c,%rsp
  800dc0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dc4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800dc7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800dcb:	7e 52                	jle    800e1f <getint+0x67>
		x=va_arg(*ap, long long);
  800dcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd1:	8b 00                	mov    (%rax),%eax
  800dd3:	83 f8 30             	cmp    $0x30,%eax
  800dd6:	73 24                	jae    800dfc <getint+0x44>
  800dd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ddc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800de0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de4:	8b 00                	mov    (%rax),%eax
  800de6:	89 c0                	mov    %eax,%eax
  800de8:	48 01 d0             	add    %rdx,%rax
  800deb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800def:	8b 12                	mov    (%rdx),%edx
  800df1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800df4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800df8:	89 0a                	mov    %ecx,(%rdx)
  800dfa:	eb 17                	jmp    800e13 <getint+0x5b>
  800dfc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e00:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e04:	48 89 d0             	mov    %rdx,%rax
  800e07:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e0b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e0f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e13:	48 8b 00             	mov    (%rax),%rax
  800e16:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e1a:	e9 a3 00 00 00       	jmpq   800ec2 <getint+0x10a>
	else if (lflag)
  800e1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800e23:	74 4f                	je     800e74 <getint+0xbc>
		x=va_arg(*ap, long);
  800e25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e29:	8b 00                	mov    (%rax),%eax
  800e2b:	83 f8 30             	cmp    $0x30,%eax
  800e2e:	73 24                	jae    800e54 <getint+0x9c>
  800e30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e34:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e3c:	8b 00                	mov    (%rax),%eax
  800e3e:	89 c0                	mov    %eax,%eax
  800e40:	48 01 d0             	add    %rdx,%rax
  800e43:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e47:	8b 12                	mov    (%rdx),%edx
  800e49:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e4c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e50:	89 0a                	mov    %ecx,(%rdx)
  800e52:	eb 17                	jmp    800e6b <getint+0xb3>
  800e54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e58:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e5c:	48 89 d0             	mov    %rdx,%rax
  800e5f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e63:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e67:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e6b:	48 8b 00             	mov    (%rax),%rax
  800e6e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e72:	eb 4e                	jmp    800ec2 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800e74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e78:	8b 00                	mov    (%rax),%eax
  800e7a:	83 f8 30             	cmp    $0x30,%eax
  800e7d:	73 24                	jae    800ea3 <getint+0xeb>
  800e7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e83:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8b:	8b 00                	mov    (%rax),%eax
  800e8d:	89 c0                	mov    %eax,%eax
  800e8f:	48 01 d0             	add    %rdx,%rax
  800e92:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e96:	8b 12                	mov    (%rdx),%edx
  800e98:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e9b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e9f:	89 0a                	mov    %ecx,(%rdx)
  800ea1:	eb 17                	jmp    800eba <getint+0x102>
  800ea3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800eab:	48 89 d0             	mov    %rdx,%rax
  800eae:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800eb2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eb6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800eba:	8b 00                	mov    (%rax),%eax
  800ebc:	48 98                	cltq   
  800ebe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ec2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ec6:	c9                   	leaveq 
  800ec7:	c3                   	retq   

0000000000800ec8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ec8:	55                   	push   %rbp
  800ec9:	48 89 e5             	mov    %rsp,%rbp
  800ecc:	41 54                	push   %r12
  800ece:	53                   	push   %rbx
  800ecf:	48 83 ec 60          	sub    $0x60,%rsp
  800ed3:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800ed7:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800edb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800edf:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800ee3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ee7:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800eeb:	48 8b 0a             	mov    (%rdx),%rcx
  800eee:	48 89 08             	mov    %rcx,(%rax)
  800ef1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ef5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ef9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800efd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f01:	eb 17                	jmp    800f1a <vprintfmt+0x52>
			if (ch == '\0')
  800f03:	85 db                	test   %ebx,%ebx
  800f05:	0f 84 cc 04 00 00    	je     8013d7 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800f0b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f0f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f13:	48 89 d6             	mov    %rdx,%rsi
  800f16:	89 df                	mov    %ebx,%edi
  800f18:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f1a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f1e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f22:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f26:	0f b6 00             	movzbl (%rax),%eax
  800f29:	0f b6 d8             	movzbl %al,%ebx
  800f2c:	83 fb 25             	cmp    $0x25,%ebx
  800f2f:	75 d2                	jne    800f03 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f31:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800f35:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800f3c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800f43:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800f4a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f51:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f55:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f59:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f5d:	0f b6 00             	movzbl (%rax),%eax
  800f60:	0f b6 d8             	movzbl %al,%ebx
  800f63:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800f66:	83 f8 55             	cmp    $0x55,%eax
  800f69:	0f 87 34 04 00 00    	ja     8013a3 <vprintfmt+0x4db>
  800f6f:	89 c0                	mov    %eax,%eax
  800f71:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800f78:	00 
  800f79:	48 b8 98 5c 80 00 00 	movabs $0x805c98,%rax
  800f80:	00 00 00 
  800f83:	48 01 d0             	add    %rdx,%rax
  800f86:	48 8b 00             	mov    (%rax),%rax
  800f89:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800f8b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800f8f:	eb c0                	jmp    800f51 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f91:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800f95:	eb ba                	jmp    800f51 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f97:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800f9e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800fa1:	89 d0                	mov    %edx,%eax
  800fa3:	c1 e0 02             	shl    $0x2,%eax
  800fa6:	01 d0                	add    %edx,%eax
  800fa8:	01 c0                	add    %eax,%eax
  800faa:	01 d8                	add    %ebx,%eax
  800fac:	83 e8 30             	sub    $0x30,%eax
  800faf:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800fb2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fb6:	0f b6 00             	movzbl (%rax),%eax
  800fb9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800fbc:	83 fb 2f             	cmp    $0x2f,%ebx
  800fbf:	7e 0c                	jle    800fcd <vprintfmt+0x105>
  800fc1:	83 fb 39             	cmp    $0x39,%ebx
  800fc4:	7f 07                	jg     800fcd <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fc6:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800fcb:	eb d1                	jmp    800f9e <vprintfmt+0xd6>
			goto process_precision;
  800fcd:	eb 58                	jmp    801027 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800fcf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fd2:	83 f8 30             	cmp    $0x30,%eax
  800fd5:	73 17                	jae    800fee <vprintfmt+0x126>
  800fd7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800fdb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fde:	89 c0                	mov    %eax,%eax
  800fe0:	48 01 d0             	add    %rdx,%rax
  800fe3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fe6:	83 c2 08             	add    $0x8,%edx
  800fe9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800fec:	eb 0f                	jmp    800ffd <vprintfmt+0x135>
  800fee:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ff2:	48 89 d0             	mov    %rdx,%rax
  800ff5:	48 83 c2 08          	add    $0x8,%rdx
  800ff9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ffd:	8b 00                	mov    (%rax),%eax
  800fff:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801002:	eb 23                	jmp    801027 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  801004:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801008:	79 0c                	jns    801016 <vprintfmt+0x14e>
				width = 0;
  80100a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801011:	e9 3b ff ff ff       	jmpq   800f51 <vprintfmt+0x89>
  801016:	e9 36 ff ff ff       	jmpq   800f51 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80101b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801022:	e9 2a ff ff ff       	jmpq   800f51 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  801027:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80102b:	79 12                	jns    80103f <vprintfmt+0x177>
				width = precision, precision = -1;
  80102d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801030:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801033:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80103a:	e9 12 ff ff ff       	jmpq   800f51 <vprintfmt+0x89>
  80103f:	e9 0d ff ff ff       	jmpq   800f51 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801044:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801048:	e9 04 ff ff ff       	jmpq   800f51 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80104d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801050:	83 f8 30             	cmp    $0x30,%eax
  801053:	73 17                	jae    80106c <vprintfmt+0x1a4>
  801055:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801059:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80105c:	89 c0                	mov    %eax,%eax
  80105e:	48 01 d0             	add    %rdx,%rax
  801061:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801064:	83 c2 08             	add    $0x8,%edx
  801067:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80106a:	eb 0f                	jmp    80107b <vprintfmt+0x1b3>
  80106c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801070:	48 89 d0             	mov    %rdx,%rax
  801073:	48 83 c2 08          	add    $0x8,%rdx
  801077:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80107b:	8b 10                	mov    (%rax),%edx
  80107d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801081:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801085:	48 89 ce             	mov    %rcx,%rsi
  801088:	89 d7                	mov    %edx,%edi
  80108a:	ff d0                	callq  *%rax
			break;
  80108c:	e9 40 03 00 00       	jmpq   8013d1 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  801091:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801094:	83 f8 30             	cmp    $0x30,%eax
  801097:	73 17                	jae    8010b0 <vprintfmt+0x1e8>
  801099:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80109d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010a0:	89 c0                	mov    %eax,%eax
  8010a2:	48 01 d0             	add    %rdx,%rax
  8010a5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8010a8:	83 c2 08             	add    $0x8,%edx
  8010ab:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8010ae:	eb 0f                	jmp    8010bf <vprintfmt+0x1f7>
  8010b0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8010b4:	48 89 d0             	mov    %rdx,%rax
  8010b7:	48 83 c2 08          	add    $0x8,%rdx
  8010bb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8010bf:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8010c1:	85 db                	test   %ebx,%ebx
  8010c3:	79 02                	jns    8010c7 <vprintfmt+0x1ff>
				err = -err;
  8010c5:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8010c7:	83 fb 15             	cmp    $0x15,%ebx
  8010ca:	7f 16                	jg     8010e2 <vprintfmt+0x21a>
  8010cc:	48 b8 c0 5b 80 00 00 	movabs $0x805bc0,%rax
  8010d3:	00 00 00 
  8010d6:	48 63 d3             	movslq %ebx,%rdx
  8010d9:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8010dd:	4d 85 e4             	test   %r12,%r12
  8010e0:	75 2e                	jne    801110 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8010e2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010e6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010ea:	89 d9                	mov    %ebx,%ecx
  8010ec:	48 ba 81 5c 80 00 00 	movabs $0x805c81,%rdx
  8010f3:	00 00 00 
  8010f6:	48 89 c7             	mov    %rax,%rdi
  8010f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fe:	49 b8 e0 13 80 00 00 	movabs $0x8013e0,%r8
  801105:	00 00 00 
  801108:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80110b:	e9 c1 02 00 00       	jmpq   8013d1 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801110:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801114:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801118:	4c 89 e1             	mov    %r12,%rcx
  80111b:	48 ba 8a 5c 80 00 00 	movabs $0x805c8a,%rdx
  801122:	00 00 00 
  801125:	48 89 c7             	mov    %rax,%rdi
  801128:	b8 00 00 00 00       	mov    $0x0,%eax
  80112d:	49 b8 e0 13 80 00 00 	movabs $0x8013e0,%r8
  801134:	00 00 00 
  801137:	41 ff d0             	callq  *%r8
			break;
  80113a:	e9 92 02 00 00       	jmpq   8013d1 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80113f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801142:	83 f8 30             	cmp    $0x30,%eax
  801145:	73 17                	jae    80115e <vprintfmt+0x296>
  801147:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80114b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80114e:	89 c0                	mov    %eax,%eax
  801150:	48 01 d0             	add    %rdx,%rax
  801153:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801156:	83 c2 08             	add    $0x8,%edx
  801159:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80115c:	eb 0f                	jmp    80116d <vprintfmt+0x2a5>
  80115e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801162:	48 89 d0             	mov    %rdx,%rax
  801165:	48 83 c2 08          	add    $0x8,%rdx
  801169:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80116d:	4c 8b 20             	mov    (%rax),%r12
  801170:	4d 85 e4             	test   %r12,%r12
  801173:	75 0a                	jne    80117f <vprintfmt+0x2b7>
				p = "(null)";
  801175:	49 bc 8d 5c 80 00 00 	movabs $0x805c8d,%r12
  80117c:	00 00 00 
			if (width > 0 && padc != '-')
  80117f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801183:	7e 3f                	jle    8011c4 <vprintfmt+0x2fc>
  801185:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801189:	74 39                	je     8011c4 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80118b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80118e:	48 98                	cltq   
  801190:	48 89 c6             	mov    %rax,%rsi
  801193:	4c 89 e7             	mov    %r12,%rdi
  801196:	48 b8 8c 16 80 00 00 	movabs $0x80168c,%rax
  80119d:	00 00 00 
  8011a0:	ff d0                	callq  *%rax
  8011a2:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8011a5:	eb 17                	jmp    8011be <vprintfmt+0x2f6>
					putch(padc, putdat);
  8011a7:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8011ab:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8011af:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011b3:	48 89 ce             	mov    %rcx,%rsi
  8011b6:	89 d7                	mov    %edx,%edi
  8011b8:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8011ba:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8011be:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011c2:	7f e3                	jg     8011a7 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011c4:	eb 37                	jmp    8011fd <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8011c6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8011ca:	74 1e                	je     8011ea <vprintfmt+0x322>
  8011cc:	83 fb 1f             	cmp    $0x1f,%ebx
  8011cf:	7e 05                	jle    8011d6 <vprintfmt+0x30e>
  8011d1:	83 fb 7e             	cmp    $0x7e,%ebx
  8011d4:	7e 14                	jle    8011ea <vprintfmt+0x322>
					putch('?', putdat);
  8011d6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011da:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011de:	48 89 d6             	mov    %rdx,%rsi
  8011e1:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8011e6:	ff d0                	callq  *%rax
  8011e8:	eb 0f                	jmp    8011f9 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8011ea:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011ee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011f2:	48 89 d6             	mov    %rdx,%rsi
  8011f5:	89 df                	mov    %ebx,%edi
  8011f7:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011f9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8011fd:	4c 89 e0             	mov    %r12,%rax
  801200:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801204:	0f b6 00             	movzbl (%rax),%eax
  801207:	0f be d8             	movsbl %al,%ebx
  80120a:	85 db                	test   %ebx,%ebx
  80120c:	74 10                	je     80121e <vprintfmt+0x356>
  80120e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801212:	78 b2                	js     8011c6 <vprintfmt+0x2fe>
  801214:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801218:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80121c:	79 a8                	jns    8011c6 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80121e:	eb 16                	jmp    801236 <vprintfmt+0x36e>
				putch(' ', putdat);
  801220:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801224:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801228:	48 89 d6             	mov    %rdx,%rsi
  80122b:	bf 20 00 00 00       	mov    $0x20,%edi
  801230:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801232:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801236:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80123a:	7f e4                	jg     801220 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80123c:	e9 90 01 00 00       	jmpq   8013d1 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801241:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801245:	be 03 00 00 00       	mov    $0x3,%esi
  80124a:	48 89 c7             	mov    %rax,%rdi
  80124d:	48 b8 b8 0d 80 00 00 	movabs $0x800db8,%rax
  801254:	00 00 00 
  801257:	ff d0                	callq  *%rax
  801259:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80125d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801261:	48 85 c0             	test   %rax,%rax
  801264:	79 1d                	jns    801283 <vprintfmt+0x3bb>
				putch('-', putdat);
  801266:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80126a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80126e:	48 89 d6             	mov    %rdx,%rsi
  801271:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801276:	ff d0                	callq  *%rax
				num = -(long long) num;
  801278:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127c:	48 f7 d8             	neg    %rax
  80127f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801283:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80128a:	e9 d5 00 00 00       	jmpq   801364 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80128f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801293:	be 03 00 00 00       	mov    $0x3,%esi
  801298:	48 89 c7             	mov    %rax,%rdi
  80129b:	48 b8 a8 0c 80 00 00 	movabs $0x800ca8,%rax
  8012a2:	00 00 00 
  8012a5:	ff d0                	callq  *%rax
  8012a7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8012ab:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8012b2:	e9 ad 00 00 00       	jmpq   801364 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  8012b7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012bb:	be 03 00 00 00       	mov    $0x3,%esi
  8012c0:	48 89 c7             	mov    %rax,%rdi
  8012c3:	48 b8 a8 0c 80 00 00 	movabs $0x800ca8,%rax
  8012ca:	00 00 00 
  8012cd:	ff d0                	callq  *%rax
  8012cf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8012d3:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8012da:	e9 85 00 00 00       	jmpq   801364 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  8012df:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012e3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012e7:	48 89 d6             	mov    %rdx,%rsi
  8012ea:	bf 30 00 00 00       	mov    $0x30,%edi
  8012ef:	ff d0                	callq  *%rax
			putch('x', putdat);
  8012f1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012f5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012f9:	48 89 d6             	mov    %rdx,%rsi
  8012fc:	bf 78 00 00 00       	mov    $0x78,%edi
  801301:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801303:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801306:	83 f8 30             	cmp    $0x30,%eax
  801309:	73 17                	jae    801322 <vprintfmt+0x45a>
  80130b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80130f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801312:	89 c0                	mov    %eax,%eax
  801314:	48 01 d0             	add    %rdx,%rax
  801317:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80131a:	83 c2 08             	add    $0x8,%edx
  80131d:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801320:	eb 0f                	jmp    801331 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801322:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801326:	48 89 d0             	mov    %rdx,%rax
  801329:	48 83 c2 08          	add    $0x8,%rdx
  80132d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801331:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801334:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801338:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80133f:	eb 23                	jmp    801364 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801341:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801345:	be 03 00 00 00       	mov    $0x3,%esi
  80134a:	48 89 c7             	mov    %rax,%rdi
  80134d:	48 b8 a8 0c 80 00 00 	movabs $0x800ca8,%rax
  801354:	00 00 00 
  801357:	ff d0                	callq  *%rax
  801359:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80135d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801364:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801369:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80136c:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80136f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801373:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801377:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80137b:	45 89 c1             	mov    %r8d,%r9d
  80137e:	41 89 f8             	mov    %edi,%r8d
  801381:	48 89 c7             	mov    %rax,%rdi
  801384:	48 b8 ed 0b 80 00 00 	movabs $0x800bed,%rax
  80138b:	00 00 00 
  80138e:	ff d0                	callq  *%rax
			break;
  801390:	eb 3f                	jmp    8013d1 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801392:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801396:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80139a:	48 89 d6             	mov    %rdx,%rsi
  80139d:	89 df                	mov    %ebx,%edi
  80139f:	ff d0                	callq  *%rax
			break;
  8013a1:	eb 2e                	jmp    8013d1 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8013a3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013a7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013ab:	48 89 d6             	mov    %rdx,%rsi
  8013ae:	bf 25 00 00 00       	mov    $0x25,%edi
  8013b3:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8013b5:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8013ba:	eb 05                	jmp    8013c1 <vprintfmt+0x4f9>
  8013bc:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8013c1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8013c5:	48 83 e8 01          	sub    $0x1,%rax
  8013c9:	0f b6 00             	movzbl (%rax),%eax
  8013cc:	3c 25                	cmp    $0x25,%al
  8013ce:	75 ec                	jne    8013bc <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8013d0:	90                   	nop
		}
	}
  8013d1:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8013d2:	e9 43 fb ff ff       	jmpq   800f1a <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8013d7:	48 83 c4 60          	add    $0x60,%rsp
  8013db:	5b                   	pop    %rbx
  8013dc:	41 5c                	pop    %r12
  8013de:	5d                   	pop    %rbp
  8013df:	c3                   	retq   

00000000008013e0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8013e0:	55                   	push   %rbp
  8013e1:	48 89 e5             	mov    %rsp,%rbp
  8013e4:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8013eb:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8013f2:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8013f9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801400:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801407:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80140e:	84 c0                	test   %al,%al
  801410:	74 20                	je     801432 <printfmt+0x52>
  801412:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801416:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80141a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80141e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801422:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801426:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80142a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80142e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801432:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801439:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801440:	00 00 00 
  801443:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80144a:	00 00 00 
  80144d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801451:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801458:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80145f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801466:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80146d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801474:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80147b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801482:	48 89 c7             	mov    %rax,%rdi
  801485:	48 b8 c8 0e 80 00 00 	movabs $0x800ec8,%rax
  80148c:	00 00 00 
  80148f:	ff d0                	callq  *%rax
	va_end(ap);
}
  801491:	c9                   	leaveq 
  801492:	c3                   	retq   

0000000000801493 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801493:	55                   	push   %rbp
  801494:	48 89 e5             	mov    %rsp,%rbp
  801497:	48 83 ec 10          	sub    $0x10,%rsp
  80149b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80149e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8014a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a6:	8b 40 10             	mov    0x10(%rax),%eax
  8014a9:	8d 50 01             	lea    0x1(%rax),%edx
  8014ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b0:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8014b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b7:	48 8b 10             	mov    (%rax),%rdx
  8014ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014be:	48 8b 40 08          	mov    0x8(%rax),%rax
  8014c2:	48 39 c2             	cmp    %rax,%rdx
  8014c5:	73 17                	jae    8014de <sprintputch+0x4b>
		*b->buf++ = ch;
  8014c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014cb:	48 8b 00             	mov    (%rax),%rax
  8014ce:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8014d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8014d6:	48 89 0a             	mov    %rcx,(%rdx)
  8014d9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8014dc:	88 10                	mov    %dl,(%rax)
}
  8014de:	c9                   	leaveq 
  8014df:	c3                   	retq   

00000000008014e0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8014e0:	55                   	push   %rbp
  8014e1:	48 89 e5             	mov    %rsp,%rbp
  8014e4:	48 83 ec 50          	sub    $0x50,%rsp
  8014e8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8014ec:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8014ef:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8014f3:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8014f7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8014fb:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8014ff:	48 8b 0a             	mov    (%rdx),%rcx
  801502:	48 89 08             	mov    %rcx,(%rax)
  801505:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801509:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80150d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801511:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801515:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801519:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80151d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801520:	48 98                	cltq   
  801522:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801526:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80152a:	48 01 d0             	add    %rdx,%rax
  80152d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801531:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801538:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80153d:	74 06                	je     801545 <vsnprintf+0x65>
  80153f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801543:	7f 07                	jg     80154c <vsnprintf+0x6c>
		return -E_INVAL;
  801545:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80154a:	eb 2f                	jmp    80157b <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80154c:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801550:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801554:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801558:	48 89 c6             	mov    %rax,%rsi
  80155b:	48 bf 93 14 80 00 00 	movabs $0x801493,%rdi
  801562:	00 00 00 
  801565:	48 b8 c8 0e 80 00 00 	movabs $0x800ec8,%rax
  80156c:	00 00 00 
  80156f:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801571:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801575:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801578:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80157b:	c9                   	leaveq 
  80157c:	c3                   	retq   

000000000080157d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80157d:	55                   	push   %rbp
  80157e:	48 89 e5             	mov    %rsp,%rbp
  801581:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801588:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80158f:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801595:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80159c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8015a3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8015aa:	84 c0                	test   %al,%al
  8015ac:	74 20                	je     8015ce <snprintf+0x51>
  8015ae:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8015b2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8015b6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8015ba:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8015be:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8015c2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8015c6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8015ca:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8015ce:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8015d5:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8015dc:	00 00 00 
  8015df:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8015e6:	00 00 00 
  8015e9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8015ed:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8015f4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8015fb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801602:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801609:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801610:	48 8b 0a             	mov    (%rdx),%rcx
  801613:	48 89 08             	mov    %rcx,(%rax)
  801616:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80161a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80161e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801622:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801626:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80162d:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801634:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80163a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801641:	48 89 c7             	mov    %rax,%rdi
  801644:	48 b8 e0 14 80 00 00 	movabs $0x8014e0,%rax
  80164b:	00 00 00 
  80164e:	ff d0                	callq  *%rax
  801650:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801656:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80165c:	c9                   	leaveq 
  80165d:	c3                   	retq   

000000000080165e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80165e:	55                   	push   %rbp
  80165f:	48 89 e5             	mov    %rsp,%rbp
  801662:	48 83 ec 18          	sub    $0x18,%rsp
  801666:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80166a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801671:	eb 09                	jmp    80167c <strlen+0x1e>
		n++;
  801673:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801677:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80167c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801680:	0f b6 00             	movzbl (%rax),%eax
  801683:	84 c0                	test   %al,%al
  801685:	75 ec                	jne    801673 <strlen+0x15>
		n++;
	return n;
  801687:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80168a:	c9                   	leaveq 
  80168b:	c3                   	retq   

000000000080168c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80168c:	55                   	push   %rbp
  80168d:	48 89 e5             	mov    %rsp,%rbp
  801690:	48 83 ec 20          	sub    $0x20,%rsp
  801694:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801698:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80169c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8016a3:	eb 0e                	jmp    8016b3 <strnlen+0x27>
		n++;
  8016a5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016a9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016ae:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8016b3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8016b8:	74 0b                	je     8016c5 <strnlen+0x39>
  8016ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016be:	0f b6 00             	movzbl (%rax),%eax
  8016c1:	84 c0                	test   %al,%al
  8016c3:	75 e0                	jne    8016a5 <strnlen+0x19>
		n++;
	return n;
  8016c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8016c8:	c9                   	leaveq 
  8016c9:	c3                   	retq   

00000000008016ca <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016ca:	55                   	push   %rbp
  8016cb:	48 89 e5             	mov    %rsp,%rbp
  8016ce:	48 83 ec 20          	sub    $0x20,%rsp
  8016d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8016da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8016e2:	90                   	nop
  8016e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016eb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8016ef:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8016f3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8016f7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8016fb:	0f b6 12             	movzbl (%rdx),%edx
  8016fe:	88 10                	mov    %dl,(%rax)
  801700:	0f b6 00             	movzbl (%rax),%eax
  801703:	84 c0                	test   %al,%al
  801705:	75 dc                	jne    8016e3 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801707:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80170b:	c9                   	leaveq 
  80170c:	c3                   	retq   

000000000080170d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80170d:	55                   	push   %rbp
  80170e:	48 89 e5             	mov    %rsp,%rbp
  801711:	48 83 ec 20          	sub    $0x20,%rsp
  801715:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801719:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80171d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801721:	48 89 c7             	mov    %rax,%rdi
  801724:	48 b8 5e 16 80 00 00 	movabs $0x80165e,%rax
  80172b:	00 00 00 
  80172e:	ff d0                	callq  *%rax
  801730:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801733:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801736:	48 63 d0             	movslq %eax,%rdx
  801739:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80173d:	48 01 c2             	add    %rax,%rdx
  801740:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801744:	48 89 c6             	mov    %rax,%rsi
  801747:	48 89 d7             	mov    %rdx,%rdi
  80174a:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  801751:	00 00 00 
  801754:	ff d0                	callq  *%rax
	return dst;
  801756:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80175a:	c9                   	leaveq 
  80175b:	c3                   	retq   

000000000080175c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80175c:	55                   	push   %rbp
  80175d:	48 89 e5             	mov    %rsp,%rbp
  801760:	48 83 ec 28          	sub    $0x28,%rsp
  801764:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801768:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80176c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801770:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801774:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801778:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80177f:	00 
  801780:	eb 2a                	jmp    8017ac <strncpy+0x50>
		*dst++ = *src;
  801782:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801786:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80178a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80178e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801792:	0f b6 12             	movzbl (%rdx),%edx
  801795:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801797:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80179b:	0f b6 00             	movzbl (%rax),%eax
  80179e:	84 c0                	test   %al,%al
  8017a0:	74 05                	je     8017a7 <strncpy+0x4b>
			src++;
  8017a2:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8017a7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8017b4:	72 cc                	jb     801782 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8017b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017ba:	c9                   	leaveq 
  8017bb:	c3                   	retq   

00000000008017bc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8017bc:	55                   	push   %rbp
  8017bd:	48 89 e5             	mov    %rsp,%rbp
  8017c0:	48 83 ec 28          	sub    $0x28,%rsp
  8017c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017cc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8017d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8017d8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8017dd:	74 3d                	je     80181c <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8017df:	eb 1d                	jmp    8017fe <strlcpy+0x42>
			*dst++ = *src++;
  8017e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017e5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017e9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8017ed:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8017f1:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8017f5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8017f9:	0f b6 12             	movzbl (%rdx),%edx
  8017fc:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8017fe:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801803:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801808:	74 0b                	je     801815 <strlcpy+0x59>
  80180a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80180e:	0f b6 00             	movzbl (%rax),%eax
  801811:	84 c0                	test   %al,%al
  801813:	75 cc                	jne    8017e1 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801815:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801819:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80181c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801820:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801824:	48 29 c2             	sub    %rax,%rdx
  801827:	48 89 d0             	mov    %rdx,%rax
}
  80182a:	c9                   	leaveq 
  80182b:	c3                   	retq   

000000000080182c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80182c:	55                   	push   %rbp
  80182d:	48 89 e5             	mov    %rsp,%rbp
  801830:	48 83 ec 10          	sub    $0x10,%rsp
  801834:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801838:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80183c:	eb 0a                	jmp    801848 <strcmp+0x1c>
		p++, q++;
  80183e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801843:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801848:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80184c:	0f b6 00             	movzbl (%rax),%eax
  80184f:	84 c0                	test   %al,%al
  801851:	74 12                	je     801865 <strcmp+0x39>
  801853:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801857:	0f b6 10             	movzbl (%rax),%edx
  80185a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80185e:	0f b6 00             	movzbl (%rax),%eax
  801861:	38 c2                	cmp    %al,%dl
  801863:	74 d9                	je     80183e <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801865:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801869:	0f b6 00             	movzbl (%rax),%eax
  80186c:	0f b6 d0             	movzbl %al,%edx
  80186f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801873:	0f b6 00             	movzbl (%rax),%eax
  801876:	0f b6 c0             	movzbl %al,%eax
  801879:	29 c2                	sub    %eax,%edx
  80187b:	89 d0                	mov    %edx,%eax
}
  80187d:	c9                   	leaveq 
  80187e:	c3                   	retq   

000000000080187f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80187f:	55                   	push   %rbp
  801880:	48 89 e5             	mov    %rsp,%rbp
  801883:	48 83 ec 18          	sub    $0x18,%rsp
  801887:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80188b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80188f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801893:	eb 0f                	jmp    8018a4 <strncmp+0x25>
		n--, p++, q++;
  801895:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80189a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80189f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8018a4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018a9:	74 1d                	je     8018c8 <strncmp+0x49>
  8018ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018af:	0f b6 00             	movzbl (%rax),%eax
  8018b2:	84 c0                	test   %al,%al
  8018b4:	74 12                	je     8018c8 <strncmp+0x49>
  8018b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018ba:	0f b6 10             	movzbl (%rax),%edx
  8018bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c1:	0f b6 00             	movzbl (%rax),%eax
  8018c4:	38 c2                	cmp    %al,%dl
  8018c6:	74 cd                	je     801895 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8018c8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018cd:	75 07                	jne    8018d6 <strncmp+0x57>
		return 0;
  8018cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d4:	eb 18                	jmp    8018ee <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018da:	0f b6 00             	movzbl (%rax),%eax
  8018dd:	0f b6 d0             	movzbl %al,%edx
  8018e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018e4:	0f b6 00             	movzbl (%rax),%eax
  8018e7:	0f b6 c0             	movzbl %al,%eax
  8018ea:	29 c2                	sub    %eax,%edx
  8018ec:	89 d0                	mov    %edx,%eax
}
  8018ee:	c9                   	leaveq 
  8018ef:	c3                   	retq   

00000000008018f0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018f0:	55                   	push   %rbp
  8018f1:	48 89 e5             	mov    %rsp,%rbp
  8018f4:	48 83 ec 0c          	sub    $0xc,%rsp
  8018f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018fc:	89 f0                	mov    %esi,%eax
  8018fe:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801901:	eb 17                	jmp    80191a <strchr+0x2a>
		if (*s == c)
  801903:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801907:	0f b6 00             	movzbl (%rax),%eax
  80190a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80190d:	75 06                	jne    801915 <strchr+0x25>
			return (char *) s;
  80190f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801913:	eb 15                	jmp    80192a <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801915:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80191a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80191e:	0f b6 00             	movzbl (%rax),%eax
  801921:	84 c0                	test   %al,%al
  801923:	75 de                	jne    801903 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801925:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80192a:	c9                   	leaveq 
  80192b:	c3                   	retq   

000000000080192c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80192c:	55                   	push   %rbp
  80192d:	48 89 e5             	mov    %rsp,%rbp
  801930:	48 83 ec 0c          	sub    $0xc,%rsp
  801934:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801938:	89 f0                	mov    %esi,%eax
  80193a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80193d:	eb 13                	jmp    801952 <strfind+0x26>
		if (*s == c)
  80193f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801943:	0f b6 00             	movzbl (%rax),%eax
  801946:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801949:	75 02                	jne    80194d <strfind+0x21>
			break;
  80194b:	eb 10                	jmp    80195d <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80194d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801952:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801956:	0f b6 00             	movzbl (%rax),%eax
  801959:	84 c0                	test   %al,%al
  80195b:	75 e2                	jne    80193f <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80195d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801961:	c9                   	leaveq 
  801962:	c3                   	retq   

0000000000801963 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801963:	55                   	push   %rbp
  801964:	48 89 e5             	mov    %rsp,%rbp
  801967:	48 83 ec 18          	sub    $0x18,%rsp
  80196b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80196f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801972:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801976:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80197b:	75 06                	jne    801983 <memset+0x20>
		return v;
  80197d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801981:	eb 69                	jmp    8019ec <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801983:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801987:	83 e0 03             	and    $0x3,%eax
  80198a:	48 85 c0             	test   %rax,%rax
  80198d:	75 48                	jne    8019d7 <memset+0x74>
  80198f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801993:	83 e0 03             	and    $0x3,%eax
  801996:	48 85 c0             	test   %rax,%rax
  801999:	75 3c                	jne    8019d7 <memset+0x74>
		c &= 0xFF;
  80199b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8019a2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019a5:	c1 e0 18             	shl    $0x18,%eax
  8019a8:	89 c2                	mov    %eax,%edx
  8019aa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019ad:	c1 e0 10             	shl    $0x10,%eax
  8019b0:	09 c2                	or     %eax,%edx
  8019b2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019b5:	c1 e0 08             	shl    $0x8,%eax
  8019b8:	09 d0                	or     %edx,%eax
  8019ba:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8019bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019c1:	48 c1 e8 02          	shr    $0x2,%rax
  8019c5:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8019c8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019cc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019cf:	48 89 d7             	mov    %rdx,%rdi
  8019d2:	fc                   	cld    
  8019d3:	f3 ab                	rep stos %eax,%es:(%rdi)
  8019d5:	eb 11                	jmp    8019e8 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8019d7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019de:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019e2:	48 89 d7             	mov    %rdx,%rdi
  8019e5:	fc                   	cld    
  8019e6:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8019e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019ec:	c9                   	leaveq 
  8019ed:	c3                   	retq   

00000000008019ee <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8019ee:	55                   	push   %rbp
  8019ef:	48 89 e5             	mov    %rsp,%rbp
  8019f2:	48 83 ec 28          	sub    $0x28,%rsp
  8019f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019fe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801a02:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a06:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801a0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a0e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801a12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a16:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a1a:	0f 83 88 00 00 00    	jae    801aa8 <memmove+0xba>
  801a20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a24:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a28:	48 01 d0             	add    %rdx,%rax
  801a2b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a2f:	76 77                	jbe    801aa8 <memmove+0xba>
		s += n;
  801a31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a35:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801a39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3d:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801a41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a45:	83 e0 03             	and    $0x3,%eax
  801a48:	48 85 c0             	test   %rax,%rax
  801a4b:	75 3b                	jne    801a88 <memmove+0x9a>
  801a4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a51:	83 e0 03             	and    $0x3,%eax
  801a54:	48 85 c0             	test   %rax,%rax
  801a57:	75 2f                	jne    801a88 <memmove+0x9a>
  801a59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a5d:	83 e0 03             	and    $0x3,%eax
  801a60:	48 85 c0             	test   %rax,%rax
  801a63:	75 23                	jne    801a88 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801a65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a69:	48 83 e8 04          	sub    $0x4,%rax
  801a6d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a71:	48 83 ea 04          	sub    $0x4,%rdx
  801a75:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801a79:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801a7d:	48 89 c7             	mov    %rax,%rdi
  801a80:	48 89 d6             	mov    %rdx,%rsi
  801a83:	fd                   	std    
  801a84:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801a86:	eb 1d                	jmp    801aa5 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801a88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a8c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801a90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a94:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801a98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a9c:	48 89 d7             	mov    %rdx,%rdi
  801a9f:	48 89 c1             	mov    %rax,%rcx
  801aa2:	fd                   	std    
  801aa3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801aa5:	fc                   	cld    
  801aa6:	eb 57                	jmp    801aff <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801aa8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aac:	83 e0 03             	and    $0x3,%eax
  801aaf:	48 85 c0             	test   %rax,%rax
  801ab2:	75 36                	jne    801aea <memmove+0xfc>
  801ab4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ab8:	83 e0 03             	and    $0x3,%eax
  801abb:	48 85 c0             	test   %rax,%rax
  801abe:	75 2a                	jne    801aea <memmove+0xfc>
  801ac0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac4:	83 e0 03             	and    $0x3,%eax
  801ac7:	48 85 c0             	test   %rax,%rax
  801aca:	75 1e                	jne    801aea <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801acc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad0:	48 c1 e8 02          	shr    $0x2,%rax
  801ad4:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801ad7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801adb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801adf:	48 89 c7             	mov    %rax,%rdi
  801ae2:	48 89 d6             	mov    %rdx,%rsi
  801ae5:	fc                   	cld    
  801ae6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801ae8:	eb 15                	jmp    801aff <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801aea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801af2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801af6:	48 89 c7             	mov    %rax,%rdi
  801af9:	48 89 d6             	mov    %rdx,%rsi
  801afc:	fc                   	cld    
  801afd:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801aff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b03:	c9                   	leaveq 
  801b04:	c3                   	retq   

0000000000801b05 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801b05:	55                   	push   %rbp
  801b06:	48 89 e5             	mov    %rsp,%rbp
  801b09:	48 83 ec 18          	sub    $0x18,%rsp
  801b0d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b15:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801b19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b1d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801b21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b25:	48 89 ce             	mov    %rcx,%rsi
  801b28:	48 89 c7             	mov    %rax,%rdi
  801b2b:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  801b32:	00 00 00 
  801b35:	ff d0                	callq  *%rax
}
  801b37:	c9                   	leaveq 
  801b38:	c3                   	retq   

0000000000801b39 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801b39:	55                   	push   %rbp
  801b3a:	48 89 e5             	mov    %rsp,%rbp
  801b3d:	48 83 ec 28          	sub    $0x28,%rsp
  801b41:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b45:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b49:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801b4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b51:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801b55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b59:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801b5d:	eb 36                	jmp    801b95 <memcmp+0x5c>
		if (*s1 != *s2)
  801b5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b63:	0f b6 10             	movzbl (%rax),%edx
  801b66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b6a:	0f b6 00             	movzbl (%rax),%eax
  801b6d:	38 c2                	cmp    %al,%dl
  801b6f:	74 1a                	je     801b8b <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801b71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b75:	0f b6 00             	movzbl (%rax),%eax
  801b78:	0f b6 d0             	movzbl %al,%edx
  801b7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b7f:	0f b6 00             	movzbl (%rax),%eax
  801b82:	0f b6 c0             	movzbl %al,%eax
  801b85:	29 c2                	sub    %eax,%edx
  801b87:	89 d0                	mov    %edx,%eax
  801b89:	eb 20                	jmp    801bab <memcmp+0x72>
		s1++, s2++;
  801b8b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b90:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801b95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b99:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801b9d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ba1:	48 85 c0             	test   %rax,%rax
  801ba4:	75 b9                	jne    801b5f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801ba6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bab:	c9                   	leaveq 
  801bac:	c3                   	retq   

0000000000801bad <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801bad:	55                   	push   %rbp
  801bae:	48 89 e5             	mov    %rsp,%rbp
  801bb1:	48 83 ec 28          	sub    $0x28,%rsp
  801bb5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bb9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801bbc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801bc0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bc4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bc8:	48 01 d0             	add    %rdx,%rax
  801bcb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801bcf:	eb 15                	jmp    801be6 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801bd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bd5:	0f b6 10             	movzbl (%rax),%edx
  801bd8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bdb:	38 c2                	cmp    %al,%dl
  801bdd:	75 02                	jne    801be1 <memfind+0x34>
			break;
  801bdf:	eb 0f                	jmp    801bf0 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801be1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801be6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bea:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801bee:	72 e1                	jb     801bd1 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801bf0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bf4:	c9                   	leaveq 
  801bf5:	c3                   	retq   

0000000000801bf6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801bf6:	55                   	push   %rbp
  801bf7:	48 89 e5             	mov    %rsp,%rbp
  801bfa:	48 83 ec 34          	sub    $0x34,%rsp
  801bfe:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c02:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801c06:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801c09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801c10:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801c17:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c18:	eb 05                	jmp    801c1f <strtol+0x29>
		s++;
  801c1a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c23:	0f b6 00             	movzbl (%rax),%eax
  801c26:	3c 20                	cmp    $0x20,%al
  801c28:	74 f0                	je     801c1a <strtol+0x24>
  801c2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c2e:	0f b6 00             	movzbl (%rax),%eax
  801c31:	3c 09                	cmp    $0x9,%al
  801c33:	74 e5                	je     801c1a <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c39:	0f b6 00             	movzbl (%rax),%eax
  801c3c:	3c 2b                	cmp    $0x2b,%al
  801c3e:	75 07                	jne    801c47 <strtol+0x51>
		s++;
  801c40:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c45:	eb 17                	jmp    801c5e <strtol+0x68>
	else if (*s == '-')
  801c47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c4b:	0f b6 00             	movzbl (%rax),%eax
  801c4e:	3c 2d                	cmp    $0x2d,%al
  801c50:	75 0c                	jne    801c5e <strtol+0x68>
		s++, neg = 1;
  801c52:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c57:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c5e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801c62:	74 06                	je     801c6a <strtol+0x74>
  801c64:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801c68:	75 28                	jne    801c92 <strtol+0x9c>
  801c6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c6e:	0f b6 00             	movzbl (%rax),%eax
  801c71:	3c 30                	cmp    $0x30,%al
  801c73:	75 1d                	jne    801c92 <strtol+0x9c>
  801c75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c79:	48 83 c0 01          	add    $0x1,%rax
  801c7d:	0f b6 00             	movzbl (%rax),%eax
  801c80:	3c 78                	cmp    $0x78,%al
  801c82:	75 0e                	jne    801c92 <strtol+0x9c>
		s += 2, base = 16;
  801c84:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801c89:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801c90:	eb 2c                	jmp    801cbe <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801c92:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801c96:	75 19                	jne    801cb1 <strtol+0xbb>
  801c98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c9c:	0f b6 00             	movzbl (%rax),%eax
  801c9f:	3c 30                	cmp    $0x30,%al
  801ca1:	75 0e                	jne    801cb1 <strtol+0xbb>
		s++, base = 8;
  801ca3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ca8:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801caf:	eb 0d                	jmp    801cbe <strtol+0xc8>
	else if (base == 0)
  801cb1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801cb5:	75 07                	jne    801cbe <strtol+0xc8>
		base = 10;
  801cb7:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801cbe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cc2:	0f b6 00             	movzbl (%rax),%eax
  801cc5:	3c 2f                	cmp    $0x2f,%al
  801cc7:	7e 1d                	jle    801ce6 <strtol+0xf0>
  801cc9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ccd:	0f b6 00             	movzbl (%rax),%eax
  801cd0:	3c 39                	cmp    $0x39,%al
  801cd2:	7f 12                	jg     801ce6 <strtol+0xf0>
			dig = *s - '0';
  801cd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd8:	0f b6 00             	movzbl (%rax),%eax
  801cdb:	0f be c0             	movsbl %al,%eax
  801cde:	83 e8 30             	sub    $0x30,%eax
  801ce1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ce4:	eb 4e                	jmp    801d34 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801ce6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cea:	0f b6 00             	movzbl (%rax),%eax
  801ced:	3c 60                	cmp    $0x60,%al
  801cef:	7e 1d                	jle    801d0e <strtol+0x118>
  801cf1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cf5:	0f b6 00             	movzbl (%rax),%eax
  801cf8:	3c 7a                	cmp    $0x7a,%al
  801cfa:	7f 12                	jg     801d0e <strtol+0x118>
			dig = *s - 'a' + 10;
  801cfc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d00:	0f b6 00             	movzbl (%rax),%eax
  801d03:	0f be c0             	movsbl %al,%eax
  801d06:	83 e8 57             	sub    $0x57,%eax
  801d09:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d0c:	eb 26                	jmp    801d34 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801d0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d12:	0f b6 00             	movzbl (%rax),%eax
  801d15:	3c 40                	cmp    $0x40,%al
  801d17:	7e 48                	jle    801d61 <strtol+0x16b>
  801d19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d1d:	0f b6 00             	movzbl (%rax),%eax
  801d20:	3c 5a                	cmp    $0x5a,%al
  801d22:	7f 3d                	jg     801d61 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801d24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d28:	0f b6 00             	movzbl (%rax),%eax
  801d2b:	0f be c0             	movsbl %al,%eax
  801d2e:	83 e8 37             	sub    $0x37,%eax
  801d31:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801d34:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d37:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801d3a:	7c 02                	jl     801d3e <strtol+0x148>
			break;
  801d3c:	eb 23                	jmp    801d61 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801d3e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d43:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801d46:	48 98                	cltq   
  801d48:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801d4d:	48 89 c2             	mov    %rax,%rdx
  801d50:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d53:	48 98                	cltq   
  801d55:	48 01 d0             	add    %rdx,%rax
  801d58:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801d5c:	e9 5d ff ff ff       	jmpq   801cbe <strtol+0xc8>

	if (endptr)
  801d61:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801d66:	74 0b                	je     801d73 <strtol+0x17d>
		*endptr = (char *) s;
  801d68:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d6c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801d70:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801d73:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d77:	74 09                	je     801d82 <strtol+0x18c>
  801d79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d7d:	48 f7 d8             	neg    %rax
  801d80:	eb 04                	jmp    801d86 <strtol+0x190>
  801d82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801d86:	c9                   	leaveq 
  801d87:	c3                   	retq   

0000000000801d88 <strstr>:

char * strstr(const char *in, const char *str)
{
  801d88:	55                   	push   %rbp
  801d89:	48 89 e5             	mov    %rsp,%rbp
  801d8c:	48 83 ec 30          	sub    $0x30,%rsp
  801d90:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801d94:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801d98:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d9c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801da0:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801da4:	0f b6 00             	movzbl (%rax),%eax
  801da7:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801daa:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801dae:	75 06                	jne    801db6 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801db0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801db4:	eb 6b                	jmp    801e21 <strstr+0x99>

	len = strlen(str);
  801db6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dba:	48 89 c7             	mov    %rax,%rdi
  801dbd:	48 b8 5e 16 80 00 00 	movabs $0x80165e,%rax
  801dc4:	00 00 00 
  801dc7:	ff d0                	callq  *%rax
  801dc9:	48 98                	cltq   
  801dcb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801dcf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dd3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801dd7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ddb:	0f b6 00             	movzbl (%rax),%eax
  801dde:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801de1:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801de5:	75 07                	jne    801dee <strstr+0x66>
				return (char *) 0;
  801de7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dec:	eb 33                	jmp    801e21 <strstr+0x99>
		} while (sc != c);
  801dee:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801df2:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801df5:	75 d8                	jne    801dcf <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801df7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dfb:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801dff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e03:	48 89 ce             	mov    %rcx,%rsi
  801e06:	48 89 c7             	mov    %rax,%rdi
  801e09:	48 b8 7f 18 80 00 00 	movabs $0x80187f,%rax
  801e10:	00 00 00 
  801e13:	ff d0                	callq  *%rax
  801e15:	85 c0                	test   %eax,%eax
  801e17:	75 b6                	jne    801dcf <strstr+0x47>

	return (char *) (in - 1);
  801e19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e1d:	48 83 e8 01          	sub    $0x1,%rax
}
  801e21:	c9                   	leaveq 
  801e22:	c3                   	retq   

0000000000801e23 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801e23:	55                   	push   %rbp
  801e24:	48 89 e5             	mov    %rsp,%rbp
  801e27:	53                   	push   %rbx
  801e28:	48 83 ec 48          	sub    $0x48,%rsp
  801e2c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801e2f:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801e32:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801e36:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801e3a:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801e3e:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e42:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e45:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801e49:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801e4d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801e51:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801e55:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801e59:	4c 89 c3             	mov    %r8,%rbx
  801e5c:	cd 30                	int    $0x30
  801e5e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801e62:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801e66:	74 3e                	je     801ea6 <syscall+0x83>
  801e68:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801e6d:	7e 37                	jle    801ea6 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801e6f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e73:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e76:	49 89 d0             	mov    %rdx,%r8
  801e79:	89 c1                	mov    %eax,%ecx
  801e7b:	48 ba 48 5f 80 00 00 	movabs $0x805f48,%rdx
  801e82:	00 00 00 
  801e85:	be 24 00 00 00       	mov    $0x24,%esi
  801e8a:	48 bf 65 5f 80 00 00 	movabs $0x805f65,%rdi
  801e91:	00 00 00 
  801e94:	b8 00 00 00 00       	mov    $0x0,%eax
  801e99:	49 b9 dc 08 80 00 00 	movabs $0x8008dc,%r9
  801ea0:	00 00 00 
  801ea3:	41 ff d1             	callq  *%r9

	return ret;
  801ea6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801eaa:	48 83 c4 48          	add    $0x48,%rsp
  801eae:	5b                   	pop    %rbx
  801eaf:	5d                   	pop    %rbp
  801eb0:	c3                   	retq   

0000000000801eb1 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801eb1:	55                   	push   %rbp
  801eb2:	48 89 e5             	mov    %rsp,%rbp
  801eb5:	48 83 ec 20          	sub    $0x20,%rsp
  801eb9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ebd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801ec1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ec5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ec9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ed0:	00 
  801ed1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ed7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801edd:	48 89 d1             	mov    %rdx,%rcx
  801ee0:	48 89 c2             	mov    %rax,%rdx
  801ee3:	be 00 00 00 00       	mov    $0x0,%esi
  801ee8:	bf 00 00 00 00       	mov    $0x0,%edi
  801eed:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  801ef4:	00 00 00 
  801ef7:	ff d0                	callq  *%rax
}
  801ef9:	c9                   	leaveq 
  801efa:	c3                   	retq   

0000000000801efb <sys_cgetc>:

int
sys_cgetc(void)
{
  801efb:	55                   	push   %rbp
  801efc:	48 89 e5             	mov    %rsp,%rbp
  801eff:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801f03:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f0a:	00 
  801f0b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f11:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f17:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f21:	be 00 00 00 00       	mov    $0x0,%esi
  801f26:	bf 01 00 00 00       	mov    $0x1,%edi
  801f2b:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  801f32:	00 00 00 
  801f35:	ff d0                	callq  *%rax
}
  801f37:	c9                   	leaveq 
  801f38:	c3                   	retq   

0000000000801f39 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801f39:	55                   	push   %rbp
  801f3a:	48 89 e5             	mov    %rsp,%rbp
  801f3d:	48 83 ec 10          	sub    $0x10,%rsp
  801f41:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801f44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f47:	48 98                	cltq   
  801f49:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f50:	00 
  801f51:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f57:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f5d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f62:	48 89 c2             	mov    %rax,%rdx
  801f65:	be 01 00 00 00       	mov    $0x1,%esi
  801f6a:	bf 03 00 00 00       	mov    $0x3,%edi
  801f6f:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  801f76:	00 00 00 
  801f79:	ff d0                	callq  *%rax
}
  801f7b:	c9                   	leaveq 
  801f7c:	c3                   	retq   

0000000000801f7d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801f7d:	55                   	push   %rbp
  801f7e:	48 89 e5             	mov    %rsp,%rbp
  801f81:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801f85:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f8c:	00 
  801f8d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f93:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f99:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa3:	be 00 00 00 00       	mov    $0x0,%esi
  801fa8:	bf 02 00 00 00       	mov    $0x2,%edi
  801fad:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  801fb4:	00 00 00 
  801fb7:	ff d0                	callq  *%rax
}
  801fb9:	c9                   	leaveq 
  801fba:	c3                   	retq   

0000000000801fbb <sys_yield>:


void
sys_yield(void)
{
  801fbb:	55                   	push   %rbp
  801fbc:	48 89 e5             	mov    %rsp,%rbp
  801fbf:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801fc3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fca:	00 
  801fcb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fd1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fd7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fdc:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe1:	be 00 00 00 00       	mov    $0x0,%esi
  801fe6:	bf 0b 00 00 00       	mov    $0xb,%edi
  801feb:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  801ff2:	00 00 00 
  801ff5:	ff d0                	callq  *%rax
}
  801ff7:	c9                   	leaveq 
  801ff8:	c3                   	retq   

0000000000801ff9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801ff9:	55                   	push   %rbp
  801ffa:	48 89 e5             	mov    %rsp,%rbp
  801ffd:	48 83 ec 20          	sub    $0x20,%rsp
  802001:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802004:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802008:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80200b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80200e:	48 63 c8             	movslq %eax,%rcx
  802011:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802015:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802018:	48 98                	cltq   
  80201a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802021:	00 
  802022:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802028:	49 89 c8             	mov    %rcx,%r8
  80202b:	48 89 d1             	mov    %rdx,%rcx
  80202e:	48 89 c2             	mov    %rax,%rdx
  802031:	be 01 00 00 00       	mov    $0x1,%esi
  802036:	bf 04 00 00 00       	mov    $0x4,%edi
  80203b:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  802042:	00 00 00 
  802045:	ff d0                	callq  *%rax
}
  802047:	c9                   	leaveq 
  802048:	c3                   	retq   

0000000000802049 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802049:	55                   	push   %rbp
  80204a:	48 89 e5             	mov    %rsp,%rbp
  80204d:	48 83 ec 30          	sub    $0x30,%rsp
  802051:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802054:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802058:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80205b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80205f:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802063:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802066:	48 63 c8             	movslq %eax,%rcx
  802069:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80206d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802070:	48 63 f0             	movslq %eax,%rsi
  802073:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802077:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80207a:	48 98                	cltq   
  80207c:	48 89 0c 24          	mov    %rcx,(%rsp)
  802080:	49 89 f9             	mov    %rdi,%r9
  802083:	49 89 f0             	mov    %rsi,%r8
  802086:	48 89 d1             	mov    %rdx,%rcx
  802089:	48 89 c2             	mov    %rax,%rdx
  80208c:	be 01 00 00 00       	mov    $0x1,%esi
  802091:	bf 05 00 00 00       	mov    $0x5,%edi
  802096:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  80209d:	00 00 00 
  8020a0:	ff d0                	callq  *%rax
}
  8020a2:	c9                   	leaveq 
  8020a3:	c3                   	retq   

00000000008020a4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8020a4:	55                   	push   %rbp
  8020a5:	48 89 e5             	mov    %rsp,%rbp
  8020a8:	48 83 ec 20          	sub    $0x20,%rsp
  8020ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8020b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ba:	48 98                	cltq   
  8020bc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020c3:	00 
  8020c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020d0:	48 89 d1             	mov    %rdx,%rcx
  8020d3:	48 89 c2             	mov    %rax,%rdx
  8020d6:	be 01 00 00 00       	mov    $0x1,%esi
  8020db:	bf 06 00 00 00       	mov    $0x6,%edi
  8020e0:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  8020e7:	00 00 00 
  8020ea:	ff d0                	callq  *%rax
}
  8020ec:	c9                   	leaveq 
  8020ed:	c3                   	retq   

00000000008020ee <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8020ee:	55                   	push   %rbp
  8020ef:	48 89 e5             	mov    %rsp,%rbp
  8020f2:	48 83 ec 10          	sub    $0x10,%rsp
  8020f6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020f9:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8020fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020ff:	48 63 d0             	movslq %eax,%rdx
  802102:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802105:	48 98                	cltq   
  802107:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80210e:	00 
  80210f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802115:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80211b:	48 89 d1             	mov    %rdx,%rcx
  80211e:	48 89 c2             	mov    %rax,%rdx
  802121:	be 01 00 00 00       	mov    $0x1,%esi
  802126:	bf 08 00 00 00       	mov    $0x8,%edi
  80212b:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  802132:	00 00 00 
  802135:	ff d0                	callq  *%rax
}
  802137:	c9                   	leaveq 
  802138:	c3                   	retq   

0000000000802139 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802139:	55                   	push   %rbp
  80213a:	48 89 e5             	mov    %rsp,%rbp
  80213d:	48 83 ec 20          	sub    $0x20,%rsp
  802141:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802144:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802148:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80214c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80214f:	48 98                	cltq   
  802151:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802158:	00 
  802159:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80215f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802165:	48 89 d1             	mov    %rdx,%rcx
  802168:	48 89 c2             	mov    %rax,%rdx
  80216b:	be 01 00 00 00       	mov    $0x1,%esi
  802170:	bf 09 00 00 00       	mov    $0x9,%edi
  802175:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  80217c:	00 00 00 
  80217f:	ff d0                	callq  *%rax
}
  802181:	c9                   	leaveq 
  802182:	c3                   	retq   

0000000000802183 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802183:	55                   	push   %rbp
  802184:	48 89 e5             	mov    %rsp,%rbp
  802187:	48 83 ec 20          	sub    $0x20,%rsp
  80218b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80218e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802192:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802196:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802199:	48 98                	cltq   
  80219b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021a2:	00 
  8021a3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021af:	48 89 d1             	mov    %rdx,%rcx
  8021b2:	48 89 c2             	mov    %rax,%rdx
  8021b5:	be 01 00 00 00       	mov    $0x1,%esi
  8021ba:	bf 0a 00 00 00       	mov    $0xa,%edi
  8021bf:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  8021c6:	00 00 00 
  8021c9:	ff d0                	callq  *%rax
}
  8021cb:	c9                   	leaveq 
  8021cc:	c3                   	retq   

00000000008021cd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8021cd:	55                   	push   %rbp
  8021ce:	48 89 e5             	mov    %rsp,%rbp
  8021d1:	48 83 ec 20          	sub    $0x20,%rsp
  8021d5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8021dc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8021e0:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8021e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021e6:	48 63 f0             	movslq %eax,%rsi
  8021e9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8021ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f0:	48 98                	cltq   
  8021f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021f6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021fd:	00 
  8021fe:	49 89 f1             	mov    %rsi,%r9
  802201:	49 89 c8             	mov    %rcx,%r8
  802204:	48 89 d1             	mov    %rdx,%rcx
  802207:	48 89 c2             	mov    %rax,%rdx
  80220a:	be 00 00 00 00       	mov    $0x0,%esi
  80220f:	bf 0c 00 00 00       	mov    $0xc,%edi
  802214:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  80221b:	00 00 00 
  80221e:	ff d0                	callq  *%rax
}
  802220:	c9                   	leaveq 
  802221:	c3                   	retq   

0000000000802222 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802222:	55                   	push   %rbp
  802223:	48 89 e5             	mov    %rsp,%rbp
  802226:	48 83 ec 10          	sub    $0x10,%rsp
  80222a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80222e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802232:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802239:	00 
  80223a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802240:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802246:	b9 00 00 00 00       	mov    $0x0,%ecx
  80224b:	48 89 c2             	mov    %rax,%rdx
  80224e:	be 01 00 00 00       	mov    $0x1,%esi
  802253:	bf 0d 00 00 00       	mov    $0xd,%edi
  802258:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  80225f:	00 00 00 
  802262:	ff d0                	callq  *%rax
}
  802264:	c9                   	leaveq 
  802265:	c3                   	retq   

0000000000802266 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  802266:	55                   	push   %rbp
  802267:	48 89 e5             	mov    %rsp,%rbp
  80226a:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  80226e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802275:	00 
  802276:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80227c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802282:	b9 00 00 00 00       	mov    $0x0,%ecx
  802287:	ba 00 00 00 00       	mov    $0x0,%edx
  80228c:	be 00 00 00 00       	mov    $0x0,%esi
  802291:	bf 0e 00 00 00       	mov    $0xe,%edi
  802296:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  80229d:	00 00 00 
  8022a0:	ff d0                	callq  *%rax
}
  8022a2:	c9                   	leaveq 
  8022a3:	c3                   	retq   

00000000008022a4 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  8022a4:	55                   	push   %rbp
  8022a5:	48 89 e5             	mov    %rsp,%rbp
  8022a8:	48 83 ec 20          	sub    $0x20,%rsp
  8022ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8022b0:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  8022b3:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8022b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022c1:	00 
  8022c2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022c8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022ce:	48 89 d1             	mov    %rdx,%rcx
  8022d1:	48 89 c2             	mov    %rax,%rdx
  8022d4:	be 00 00 00 00       	mov    $0x0,%esi
  8022d9:	bf 0f 00 00 00       	mov    $0xf,%edi
  8022de:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  8022e5:	00 00 00 
  8022e8:	ff d0                	callq  *%rax
}
  8022ea:	c9                   	leaveq 
  8022eb:	c3                   	retq   

00000000008022ec <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  8022ec:	55                   	push   %rbp
  8022ed:	48 89 e5             	mov    %rsp,%rbp
  8022f0:	48 83 ec 20          	sub    $0x20,%rsp
  8022f4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8022f8:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  8022fb:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8022fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802302:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802309:	00 
  80230a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802310:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802316:	48 89 d1             	mov    %rdx,%rcx
  802319:	48 89 c2             	mov    %rax,%rdx
  80231c:	be 00 00 00 00       	mov    $0x0,%esi
  802321:	bf 10 00 00 00       	mov    $0x10,%edi
  802326:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  80232d:	00 00 00 
  802330:	ff d0                	callq  *%rax
}
  802332:	c9                   	leaveq 
  802333:	c3                   	retq   

0000000000802334 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802334:	55                   	push   %rbp
  802335:	48 89 e5             	mov    %rsp,%rbp
  802338:	48 83 ec 30          	sub    $0x30,%rsp
  80233c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80233f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802343:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802346:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80234a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  80234e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802351:	48 63 c8             	movslq %eax,%rcx
  802354:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802358:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80235b:	48 63 f0             	movslq %eax,%rsi
  80235e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802362:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802365:	48 98                	cltq   
  802367:	48 89 0c 24          	mov    %rcx,(%rsp)
  80236b:	49 89 f9             	mov    %rdi,%r9
  80236e:	49 89 f0             	mov    %rsi,%r8
  802371:	48 89 d1             	mov    %rdx,%rcx
  802374:	48 89 c2             	mov    %rax,%rdx
  802377:	be 00 00 00 00       	mov    $0x0,%esi
  80237c:	bf 11 00 00 00       	mov    $0x11,%edi
  802381:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  802388:	00 00 00 
  80238b:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  80238d:	c9                   	leaveq 
  80238e:	c3                   	retq   

000000000080238f <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  80238f:	55                   	push   %rbp
  802390:	48 89 e5             	mov    %rsp,%rbp
  802393:	48 83 ec 20          	sub    $0x20,%rsp
  802397:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80239b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  80239f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023a7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023ae:	00 
  8023af:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023b5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023bb:	48 89 d1             	mov    %rdx,%rcx
  8023be:	48 89 c2             	mov    %rax,%rdx
  8023c1:	be 00 00 00 00       	mov    $0x0,%esi
  8023c6:	bf 12 00 00 00       	mov    $0x12,%edi
  8023cb:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  8023d2:	00 00 00 
  8023d5:	ff d0                	callq  *%rax
}
  8023d7:	c9                   	leaveq 
  8023d8:	c3                   	retq   

00000000008023d9 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8023d9:	55                   	push   %rbp
  8023da:	48 89 e5             	mov    %rsp,%rbp
  8023dd:	48 83 ec 30          	sub    $0x30,%rsp
  8023e1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  8023e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023e9:	48 8b 00             	mov    (%rax),%rax
  8023ec:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  8023f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023f4:	48 8b 40 08          	mov    0x8(%rax),%rax
  8023f8:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  8023fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023fe:	83 e0 02             	and    $0x2,%eax
  802401:	85 c0                	test   %eax,%eax
  802403:	75 40                	jne    802445 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  802405:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802409:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  802410:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802414:	49 89 d0             	mov    %rdx,%r8
  802417:	48 89 c1             	mov    %rax,%rcx
  80241a:	48 ba 78 5f 80 00 00 	movabs $0x805f78,%rdx
  802421:	00 00 00 
  802424:	be 1f 00 00 00       	mov    $0x1f,%esi
  802429:	48 bf 91 5f 80 00 00 	movabs $0x805f91,%rdi
  802430:	00 00 00 
  802433:	b8 00 00 00 00       	mov    $0x0,%eax
  802438:	49 b9 dc 08 80 00 00 	movabs $0x8008dc,%r9
  80243f:	00 00 00 
  802442:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  802445:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802449:	48 c1 e8 0c          	shr    $0xc,%rax
  80244d:	48 89 c2             	mov    %rax,%rdx
  802450:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802457:	01 00 00 
  80245a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80245e:	25 07 08 00 00       	and    $0x807,%eax
  802463:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  802469:	74 4e                	je     8024b9 <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  80246b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80246f:	48 c1 e8 0c          	shr    $0xc,%rax
  802473:	48 89 c2             	mov    %rax,%rdx
  802476:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80247d:	01 00 00 
  802480:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802484:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802488:	49 89 d0             	mov    %rdx,%r8
  80248b:	48 89 c1             	mov    %rax,%rcx
  80248e:	48 ba a0 5f 80 00 00 	movabs $0x805fa0,%rdx
  802495:	00 00 00 
  802498:	be 22 00 00 00       	mov    $0x22,%esi
  80249d:	48 bf 91 5f 80 00 00 	movabs $0x805f91,%rdi
  8024a4:	00 00 00 
  8024a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ac:	49 b9 dc 08 80 00 00 	movabs $0x8008dc,%r9
  8024b3:	00 00 00 
  8024b6:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8024b9:	ba 07 00 00 00       	mov    $0x7,%edx
  8024be:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8024c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8024c8:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  8024cf:	00 00 00 
  8024d2:	ff d0                	callq  *%rax
  8024d4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8024d7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024db:	79 30                	jns    80250d <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  8024dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024e0:	89 c1                	mov    %eax,%ecx
  8024e2:	48 ba cb 5f 80 00 00 	movabs $0x805fcb,%rdx
  8024e9:	00 00 00 
  8024ec:	be 28 00 00 00       	mov    $0x28,%esi
  8024f1:	48 bf 91 5f 80 00 00 	movabs $0x805f91,%rdi
  8024f8:	00 00 00 
  8024fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802500:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  802507:	00 00 00 
  80250a:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  80250d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802511:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802515:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802519:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80251f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802524:	48 89 c6             	mov    %rax,%rsi
  802527:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80252c:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  802533:	00 00 00 
  802536:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802538:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80253c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802540:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802544:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80254a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802550:	48 89 c1             	mov    %rax,%rcx
  802553:	ba 00 00 00 00       	mov    $0x0,%edx
  802558:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80255d:	bf 00 00 00 00       	mov    $0x0,%edi
  802562:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802569:	00 00 00 
  80256c:	ff d0                	callq  *%rax
  80256e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802571:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802575:	79 30                	jns    8025a7 <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  802577:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80257a:	89 c1                	mov    %eax,%ecx
  80257c:	48 ba de 5f 80 00 00 	movabs $0x805fde,%rdx
  802583:	00 00 00 
  802586:	be 2d 00 00 00       	mov    $0x2d,%esi
  80258b:	48 bf 91 5f 80 00 00 	movabs $0x805f91,%rdi
  802592:	00 00 00 
  802595:	b8 00 00 00 00       	mov    $0x0,%eax
  80259a:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  8025a1:	00 00 00 
  8025a4:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  8025a7:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8025ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b1:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  8025b8:	00 00 00 
  8025bb:	ff d0                	callq  *%rax
  8025bd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8025c0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8025c4:	79 30                	jns    8025f6 <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  8025c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025c9:	89 c1                	mov    %eax,%ecx
  8025cb:	48 ba ef 5f 80 00 00 	movabs $0x805fef,%rdx
  8025d2:	00 00 00 
  8025d5:	be 31 00 00 00       	mov    $0x31,%esi
  8025da:	48 bf 91 5f 80 00 00 	movabs $0x805f91,%rdi
  8025e1:	00 00 00 
  8025e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e9:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  8025f0:	00 00 00 
  8025f3:	41 ff d0             	callq  *%r8

}
  8025f6:	c9                   	leaveq 
  8025f7:	c3                   	retq   

00000000008025f8 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8025f8:	55                   	push   %rbp
  8025f9:	48 89 e5             	mov    %rsp,%rbp
  8025fc:	48 83 ec 30          	sub    $0x30,%rsp
  802600:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802603:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  802606:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802609:	c1 e0 0c             	shl    $0xc,%eax
  80260c:	89 c0                	mov    %eax,%eax
  80260e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  802612:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802619:	01 00 00 
  80261c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80261f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802623:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  802627:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80262b:	25 02 08 00 00       	and    $0x802,%eax
  802630:	48 85 c0             	test   %rax,%rax
  802633:	74 0e                	je     802643 <duppage+0x4b>
  802635:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802639:	25 00 04 00 00       	and    $0x400,%eax
  80263e:	48 85 c0             	test   %rax,%rax
  802641:	74 70                	je     8026b3 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  802643:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802647:	25 07 0e 00 00       	and    $0xe07,%eax
  80264c:	89 c6                	mov    %eax,%esi
  80264e:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802652:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802655:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802659:	41 89 f0             	mov    %esi,%r8d
  80265c:	48 89 c6             	mov    %rax,%rsi
  80265f:	bf 00 00 00 00       	mov    $0x0,%edi
  802664:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  80266b:	00 00 00 
  80266e:	ff d0                	callq  *%rax
  802670:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802673:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802677:	79 30                	jns    8026a9 <duppage+0xb1>
			panic("sys_page_map: %e", r);
  802679:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80267c:	89 c1                	mov    %eax,%ecx
  80267e:	48 ba de 5f 80 00 00 	movabs $0x805fde,%rdx
  802685:	00 00 00 
  802688:	be 50 00 00 00       	mov    $0x50,%esi
  80268d:	48 bf 91 5f 80 00 00 	movabs $0x805f91,%rdi
  802694:	00 00 00 
  802697:	b8 00 00 00 00       	mov    $0x0,%eax
  80269c:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  8026a3:	00 00 00 
  8026a6:	41 ff d0             	callq  *%r8
		return 0;
  8026a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ae:	e9 c4 00 00 00       	jmpq   802777 <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  8026b3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8026b7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026be:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8026c4:	48 89 c6             	mov    %rax,%rsi
  8026c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8026cc:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  8026d3:	00 00 00 
  8026d6:	ff d0                	callq  *%rax
  8026d8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8026db:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8026df:	79 30                	jns    802711 <duppage+0x119>
		panic("sys_page_map: %e", r);
  8026e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026e4:	89 c1                	mov    %eax,%ecx
  8026e6:	48 ba de 5f 80 00 00 	movabs $0x805fde,%rdx
  8026ed:	00 00 00 
  8026f0:	be 64 00 00 00       	mov    $0x64,%esi
  8026f5:	48 bf 91 5f 80 00 00 	movabs $0x805f91,%rdi
  8026fc:	00 00 00 
  8026ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802704:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  80270b:	00 00 00 
  80270e:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802711:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802715:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802719:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  80271f:	48 89 d1             	mov    %rdx,%rcx
  802722:	ba 00 00 00 00       	mov    $0x0,%edx
  802727:	48 89 c6             	mov    %rax,%rsi
  80272a:	bf 00 00 00 00       	mov    $0x0,%edi
  80272f:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802736:	00 00 00 
  802739:	ff d0                	callq  *%rax
  80273b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80273e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802742:	79 30                	jns    802774 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  802744:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802747:	89 c1                	mov    %eax,%ecx
  802749:	48 ba de 5f 80 00 00 	movabs $0x805fde,%rdx
  802750:	00 00 00 
  802753:	be 66 00 00 00       	mov    $0x66,%esi
  802758:	48 bf 91 5f 80 00 00 	movabs $0x805f91,%rdi
  80275f:	00 00 00 
  802762:	b8 00 00 00 00       	mov    $0x0,%eax
  802767:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  80276e:	00 00 00 
  802771:	41 ff d0             	callq  *%r8
	return r;
  802774:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802777:	c9                   	leaveq 
  802778:	c3                   	retq   

0000000000802779 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802779:	55                   	push   %rbp
  80277a:	48 89 e5             	mov    %rsp,%rbp
  80277d:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  802781:	48 bf d9 23 80 00 00 	movabs $0x8023d9,%rdi
  802788:	00 00 00 
  80278b:	48 b8 ed 53 80 00 00 	movabs $0x8053ed,%rax
  802792:	00 00 00 
  802795:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802797:	b8 07 00 00 00       	mov    $0x7,%eax
  80279c:	cd 30                	int    $0x30
  80279e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8027a1:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  8027a4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  8027a7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027ab:	79 08                	jns    8027b5 <fork+0x3c>
		return envid;
  8027ad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027b0:	e9 09 02 00 00       	jmpq   8029be <fork+0x245>
	if (envid == 0) {
  8027b5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027b9:	75 3e                	jne    8027f9 <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  8027bb:	48 b8 7d 1f 80 00 00 	movabs $0x801f7d,%rax
  8027c2:	00 00 00 
  8027c5:	ff d0                	callq  *%rax
  8027c7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8027cc:	48 98                	cltq   
  8027ce:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8027d5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8027dc:	00 00 00 
  8027df:	48 01 c2             	add    %rax,%rdx
  8027e2:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8027e9:	00 00 00 
  8027ec:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8027ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f4:	e9 c5 01 00 00       	jmpq   8029be <fork+0x245>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  8027f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802800:	e9 a4 00 00 00       	jmpq   8028a9 <fork+0x130>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  802805:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802808:	c1 f8 12             	sar    $0x12,%eax
  80280b:	89 c2                	mov    %eax,%edx
  80280d:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802814:	01 00 00 
  802817:	48 63 d2             	movslq %edx,%rdx
  80281a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80281e:	83 e0 01             	and    $0x1,%eax
  802821:	48 85 c0             	test   %rax,%rax
  802824:	74 21                	je     802847 <fork+0xce>
  802826:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802829:	c1 f8 09             	sar    $0x9,%eax
  80282c:	89 c2                	mov    %eax,%edx
  80282e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802835:	01 00 00 
  802838:	48 63 d2             	movslq %edx,%rdx
  80283b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80283f:	83 e0 01             	and    $0x1,%eax
  802842:	48 85 c0             	test   %rax,%rax
  802845:	75 09                	jne    802850 <fork+0xd7>
			pn += NPTENTRIES;
  802847:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  80284e:	eb 59                	jmp    8028a9 <fork+0x130>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802850:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802853:	05 00 02 00 00       	add    $0x200,%eax
  802858:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80285b:	eb 44                	jmp    8028a1 <fork+0x128>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  80285d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802864:	01 00 00 
  802867:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80286a:	48 63 d2             	movslq %edx,%rdx
  80286d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802871:	83 e0 05             	and    $0x5,%eax
  802874:	48 83 f8 05          	cmp    $0x5,%rax
  802878:	74 02                	je     80287c <fork+0x103>
				continue;
  80287a:	eb 21                	jmp    80289d <fork+0x124>
			if (pn == PPN(UXSTACKTOP - 1))
  80287c:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  802883:	75 02                	jne    802887 <fork+0x10e>
				continue;
  802885:	eb 16                	jmp    80289d <fork+0x124>
			duppage(envid, pn);
  802887:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80288a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80288d:	89 d6                	mov    %edx,%esi
  80288f:	89 c7                	mov    %eax,%edi
  802891:	48 b8 f8 25 80 00 00 	movabs $0x8025f8,%rax
  802898:	00 00 00 
  80289b:	ff d0                	callq  *%rax
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  80289d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8028a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a4:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8028a7:	7c b4                	jl     80285d <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  8028a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ac:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  8028b1:	0f 86 4e ff ff ff    	jbe    802805 <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  8028b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028ba:	ba 07 00 00 00       	mov    $0x7,%edx
  8028bf:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8028c4:	89 c7                	mov    %eax,%edi
  8028c6:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  8028cd:	00 00 00 
  8028d0:	ff d0                	callq  *%rax
  8028d2:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8028d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8028d9:	79 30                	jns    80290b <fork+0x192>
		panic("allocating exception stack: %e", r);
  8028db:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8028de:	89 c1                	mov    %eax,%ecx
  8028e0:	48 ba 08 60 80 00 00 	movabs $0x806008,%rdx
  8028e7:	00 00 00 
  8028ea:	be 9e 00 00 00       	mov    $0x9e,%esi
  8028ef:	48 bf 91 5f 80 00 00 	movabs $0x805f91,%rdi
  8028f6:	00 00 00 
  8028f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028fe:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  802905:	00 00 00 
  802908:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  80290b:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802912:	00 00 00 
  802915:	48 8b 00             	mov    (%rax),%rax
  802918:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80291f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802922:	48 89 d6             	mov    %rdx,%rsi
  802925:	89 c7                	mov    %eax,%edi
  802927:	48 b8 83 21 80 00 00 	movabs $0x802183,%rax
  80292e:	00 00 00 
  802931:	ff d0                	callq  *%rax
  802933:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802936:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80293a:	79 30                	jns    80296c <fork+0x1f3>
		panic("sys_env_set_pgfault_upcall: %e", r);
  80293c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80293f:	89 c1                	mov    %eax,%ecx
  802941:	48 ba 28 60 80 00 00 	movabs $0x806028,%rdx
  802948:	00 00 00 
  80294b:	be a2 00 00 00       	mov    $0xa2,%esi
  802950:	48 bf 91 5f 80 00 00 	movabs $0x805f91,%rdi
  802957:	00 00 00 
  80295a:	b8 00 00 00 00       	mov    $0x0,%eax
  80295f:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  802966:	00 00 00 
  802969:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80296c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80296f:	be 02 00 00 00       	mov    $0x2,%esi
  802974:	89 c7                	mov    %eax,%edi
  802976:	48 b8 ee 20 80 00 00 	movabs $0x8020ee,%rax
  80297d:	00 00 00 
  802980:	ff d0                	callq  *%rax
  802982:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802985:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802989:	79 30                	jns    8029bb <fork+0x242>
		panic("sys_env_set_status: %e", r);
  80298b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80298e:	89 c1                	mov    %eax,%ecx
  802990:	48 ba 47 60 80 00 00 	movabs $0x806047,%rdx
  802997:	00 00 00 
  80299a:	be a7 00 00 00       	mov    $0xa7,%esi
  80299f:	48 bf 91 5f 80 00 00 	movabs $0x805f91,%rdi
  8029a6:	00 00 00 
  8029a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ae:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  8029b5:	00 00 00 
  8029b8:	41 ff d0             	callq  *%r8

	return envid;
  8029bb:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  8029be:	c9                   	leaveq 
  8029bf:	c3                   	retq   

00000000008029c0 <sfork>:

// Challenge!
int
sfork(void)
{
  8029c0:	55                   	push   %rbp
  8029c1:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8029c4:	48 ba 5e 60 80 00 00 	movabs $0x80605e,%rdx
  8029cb:	00 00 00 
  8029ce:	be b1 00 00 00       	mov    $0xb1,%esi
  8029d3:	48 bf 91 5f 80 00 00 	movabs $0x805f91,%rdi
  8029da:	00 00 00 
  8029dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e2:	48 b9 dc 08 80 00 00 	movabs $0x8008dc,%rcx
  8029e9:	00 00 00 
  8029ec:	ff d1                	callq  *%rcx

00000000008029ee <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8029ee:	55                   	push   %rbp
  8029ef:	48 89 e5             	mov    %rsp,%rbp
  8029f2:	48 83 ec 08          	sub    $0x8,%rsp
  8029f6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8029fa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8029fe:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802a05:	ff ff ff 
  802a08:	48 01 d0             	add    %rdx,%rax
  802a0b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802a0f:	c9                   	leaveq 
  802a10:	c3                   	retq   

0000000000802a11 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802a11:	55                   	push   %rbp
  802a12:	48 89 e5             	mov    %rsp,%rbp
  802a15:	48 83 ec 08          	sub    $0x8,%rsp
  802a19:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802a1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a21:	48 89 c7             	mov    %rax,%rdi
  802a24:	48 b8 ee 29 80 00 00 	movabs $0x8029ee,%rax
  802a2b:	00 00 00 
  802a2e:	ff d0                	callq  *%rax
  802a30:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802a36:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802a3a:	c9                   	leaveq 
  802a3b:	c3                   	retq   

0000000000802a3c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802a3c:	55                   	push   %rbp
  802a3d:	48 89 e5             	mov    %rsp,%rbp
  802a40:	48 83 ec 18          	sub    $0x18,%rsp
  802a44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802a48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a4f:	eb 6b                	jmp    802abc <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802a51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a54:	48 98                	cltq   
  802a56:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a5c:	48 c1 e0 0c          	shl    $0xc,%rax
  802a60:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802a64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a68:	48 c1 e8 15          	shr    $0x15,%rax
  802a6c:	48 89 c2             	mov    %rax,%rdx
  802a6f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a76:	01 00 00 
  802a79:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a7d:	83 e0 01             	and    $0x1,%eax
  802a80:	48 85 c0             	test   %rax,%rax
  802a83:	74 21                	je     802aa6 <fd_alloc+0x6a>
  802a85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a89:	48 c1 e8 0c          	shr    $0xc,%rax
  802a8d:	48 89 c2             	mov    %rax,%rdx
  802a90:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a97:	01 00 00 
  802a9a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a9e:	83 e0 01             	and    $0x1,%eax
  802aa1:	48 85 c0             	test   %rax,%rax
  802aa4:	75 12                	jne    802ab8 <fd_alloc+0x7c>
			*fd_store = fd;
  802aa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aaa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802aae:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802ab1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab6:	eb 1a                	jmp    802ad2 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802ab8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802abc:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802ac0:	7e 8f                	jle    802a51 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802ac2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802acd:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802ad2:	c9                   	leaveq 
  802ad3:	c3                   	retq   

0000000000802ad4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802ad4:	55                   	push   %rbp
  802ad5:	48 89 e5             	mov    %rsp,%rbp
  802ad8:	48 83 ec 20          	sub    $0x20,%rsp
  802adc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802adf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802ae3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ae7:	78 06                	js     802aef <fd_lookup+0x1b>
  802ae9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802aed:	7e 07                	jle    802af6 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802aef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802af4:	eb 6c                	jmp    802b62 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802af6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802af9:	48 98                	cltq   
  802afb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b01:	48 c1 e0 0c          	shl    $0xc,%rax
  802b05:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802b09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b0d:	48 c1 e8 15          	shr    $0x15,%rax
  802b11:	48 89 c2             	mov    %rax,%rdx
  802b14:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b1b:	01 00 00 
  802b1e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b22:	83 e0 01             	and    $0x1,%eax
  802b25:	48 85 c0             	test   %rax,%rax
  802b28:	74 21                	je     802b4b <fd_lookup+0x77>
  802b2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b2e:	48 c1 e8 0c          	shr    $0xc,%rax
  802b32:	48 89 c2             	mov    %rax,%rdx
  802b35:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b3c:	01 00 00 
  802b3f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b43:	83 e0 01             	and    $0x1,%eax
  802b46:	48 85 c0             	test   %rax,%rax
  802b49:	75 07                	jne    802b52 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b50:	eb 10                	jmp    802b62 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802b52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b56:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b5a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802b5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b62:	c9                   	leaveq 
  802b63:	c3                   	retq   

0000000000802b64 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802b64:	55                   	push   %rbp
  802b65:	48 89 e5             	mov    %rsp,%rbp
  802b68:	48 83 ec 30          	sub    $0x30,%rsp
  802b6c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b70:	89 f0                	mov    %esi,%eax
  802b72:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802b75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b79:	48 89 c7             	mov    %rax,%rdi
  802b7c:	48 b8 ee 29 80 00 00 	movabs $0x8029ee,%rax
  802b83:	00 00 00 
  802b86:	ff d0                	callq  *%rax
  802b88:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b8c:	48 89 d6             	mov    %rdx,%rsi
  802b8f:	89 c7                	mov    %eax,%edi
  802b91:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  802b98:	00 00 00 
  802b9b:	ff d0                	callq  *%rax
  802b9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ba0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ba4:	78 0a                	js     802bb0 <fd_close+0x4c>
	    || fd != fd2)
  802ba6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802baa:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802bae:	74 12                	je     802bc2 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802bb0:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802bb4:	74 05                	je     802bbb <fd_close+0x57>
  802bb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb9:	eb 05                	jmp    802bc0 <fd_close+0x5c>
  802bbb:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc0:	eb 69                	jmp    802c2b <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802bc2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bc6:	8b 00                	mov    (%rax),%eax
  802bc8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bcc:	48 89 d6             	mov    %rdx,%rsi
  802bcf:	89 c7                	mov    %eax,%edi
  802bd1:	48 b8 2d 2c 80 00 00 	movabs $0x802c2d,%rax
  802bd8:	00 00 00 
  802bdb:	ff d0                	callq  *%rax
  802bdd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be4:	78 2a                	js     802c10 <fd_close+0xac>
		if (dev->dev_close)
  802be6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bea:	48 8b 40 20          	mov    0x20(%rax),%rax
  802bee:	48 85 c0             	test   %rax,%rax
  802bf1:	74 16                	je     802c09 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802bf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf7:	48 8b 40 20          	mov    0x20(%rax),%rax
  802bfb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bff:	48 89 d7             	mov    %rdx,%rdi
  802c02:	ff d0                	callq  *%rax
  802c04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c07:	eb 07                	jmp    802c10 <fd_close+0xac>
		else
			r = 0;
  802c09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802c10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c14:	48 89 c6             	mov    %rax,%rsi
  802c17:	bf 00 00 00 00       	mov    $0x0,%edi
  802c1c:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802c23:	00 00 00 
  802c26:	ff d0                	callq  *%rax
	return r;
  802c28:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c2b:	c9                   	leaveq 
  802c2c:	c3                   	retq   

0000000000802c2d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802c2d:	55                   	push   %rbp
  802c2e:	48 89 e5             	mov    %rsp,%rbp
  802c31:	48 83 ec 20          	sub    $0x20,%rsp
  802c35:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c38:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802c3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c43:	eb 41                	jmp    802c86 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802c45:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  802c4c:	00 00 00 
  802c4f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c52:	48 63 d2             	movslq %edx,%rdx
  802c55:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c59:	8b 00                	mov    (%rax),%eax
  802c5b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802c5e:	75 22                	jne    802c82 <dev_lookup+0x55>
			*dev = devtab[i];
  802c60:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  802c67:	00 00 00 
  802c6a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c6d:	48 63 d2             	movslq %edx,%rdx
  802c70:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802c74:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c78:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c80:	eb 60                	jmp    802ce2 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802c82:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802c86:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  802c8d:	00 00 00 
  802c90:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c93:	48 63 d2             	movslq %edx,%rdx
  802c96:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c9a:	48 85 c0             	test   %rax,%rax
  802c9d:	75 a6                	jne    802c45 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802c9f:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802ca6:	00 00 00 
  802ca9:	48 8b 00             	mov    (%rax),%rax
  802cac:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cb2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802cb5:	89 c6                	mov    %eax,%esi
  802cb7:	48 bf 78 60 80 00 00 	movabs $0x806078,%rdi
  802cbe:	00 00 00 
  802cc1:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc6:	48 b9 15 0b 80 00 00 	movabs $0x800b15,%rcx
  802ccd:	00 00 00 
  802cd0:	ff d1                	callq  *%rcx
	*dev = 0;
  802cd2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cd6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802cdd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802ce2:	c9                   	leaveq 
  802ce3:	c3                   	retq   

0000000000802ce4 <close>:

int
close(int fdnum)
{
  802ce4:	55                   	push   %rbp
  802ce5:	48 89 e5             	mov    %rsp,%rbp
  802ce8:	48 83 ec 20          	sub    $0x20,%rsp
  802cec:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cef:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cf3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cf6:	48 89 d6             	mov    %rdx,%rsi
  802cf9:	89 c7                	mov    %eax,%edi
  802cfb:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  802d02:	00 00 00 
  802d05:	ff d0                	callq  *%rax
  802d07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d0e:	79 05                	jns    802d15 <close+0x31>
		return r;
  802d10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d13:	eb 18                	jmp    802d2d <close+0x49>
	else
		return fd_close(fd, 1);
  802d15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d19:	be 01 00 00 00       	mov    $0x1,%esi
  802d1e:	48 89 c7             	mov    %rax,%rdi
  802d21:	48 b8 64 2b 80 00 00 	movabs $0x802b64,%rax
  802d28:	00 00 00 
  802d2b:	ff d0                	callq  *%rax
}
  802d2d:	c9                   	leaveq 
  802d2e:	c3                   	retq   

0000000000802d2f <close_all>:

void
close_all(void)
{
  802d2f:	55                   	push   %rbp
  802d30:	48 89 e5             	mov    %rsp,%rbp
  802d33:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802d37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d3e:	eb 15                	jmp    802d55 <close_all+0x26>
		close(i);
  802d40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d43:	89 c7                	mov    %eax,%edi
  802d45:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  802d4c:	00 00 00 
  802d4f:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802d51:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802d55:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802d59:	7e e5                	jle    802d40 <close_all+0x11>
		close(i);
}
  802d5b:	c9                   	leaveq 
  802d5c:	c3                   	retq   

0000000000802d5d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802d5d:	55                   	push   %rbp
  802d5e:	48 89 e5             	mov    %rsp,%rbp
  802d61:	48 83 ec 40          	sub    $0x40,%rsp
  802d65:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802d68:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802d6b:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802d6f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802d72:	48 89 d6             	mov    %rdx,%rsi
  802d75:	89 c7                	mov    %eax,%edi
  802d77:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  802d7e:	00 00 00 
  802d81:	ff d0                	callq  *%rax
  802d83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8a:	79 08                	jns    802d94 <dup+0x37>
		return r;
  802d8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d8f:	e9 70 01 00 00       	jmpq   802f04 <dup+0x1a7>
	close(newfdnum);
  802d94:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d97:	89 c7                	mov    %eax,%edi
  802d99:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  802da0:	00 00 00 
  802da3:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802da5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802da8:	48 98                	cltq   
  802daa:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802db0:	48 c1 e0 0c          	shl    $0xc,%rax
  802db4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802db8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dbc:	48 89 c7             	mov    %rax,%rdi
  802dbf:	48 b8 11 2a 80 00 00 	movabs $0x802a11,%rax
  802dc6:	00 00 00 
  802dc9:	ff d0                	callq  *%rax
  802dcb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802dcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd3:	48 89 c7             	mov    %rax,%rdi
  802dd6:	48 b8 11 2a 80 00 00 	movabs $0x802a11,%rax
  802ddd:	00 00 00 
  802de0:	ff d0                	callq  *%rax
  802de2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802de6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dea:	48 c1 e8 15          	shr    $0x15,%rax
  802dee:	48 89 c2             	mov    %rax,%rdx
  802df1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802df8:	01 00 00 
  802dfb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802dff:	83 e0 01             	and    $0x1,%eax
  802e02:	48 85 c0             	test   %rax,%rax
  802e05:	74 73                	je     802e7a <dup+0x11d>
  802e07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e0b:	48 c1 e8 0c          	shr    $0xc,%rax
  802e0f:	48 89 c2             	mov    %rax,%rdx
  802e12:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e19:	01 00 00 
  802e1c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e20:	83 e0 01             	and    $0x1,%eax
  802e23:	48 85 c0             	test   %rax,%rax
  802e26:	74 52                	je     802e7a <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802e28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e2c:	48 c1 e8 0c          	shr    $0xc,%rax
  802e30:	48 89 c2             	mov    %rax,%rdx
  802e33:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e3a:	01 00 00 
  802e3d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e41:	25 07 0e 00 00       	and    $0xe07,%eax
  802e46:	89 c1                	mov    %eax,%ecx
  802e48:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e50:	41 89 c8             	mov    %ecx,%r8d
  802e53:	48 89 d1             	mov    %rdx,%rcx
  802e56:	ba 00 00 00 00       	mov    $0x0,%edx
  802e5b:	48 89 c6             	mov    %rax,%rsi
  802e5e:	bf 00 00 00 00       	mov    $0x0,%edi
  802e63:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802e6a:	00 00 00 
  802e6d:	ff d0                	callq  *%rax
  802e6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e76:	79 02                	jns    802e7a <dup+0x11d>
			goto err;
  802e78:	eb 57                	jmp    802ed1 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802e7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e7e:	48 c1 e8 0c          	shr    $0xc,%rax
  802e82:	48 89 c2             	mov    %rax,%rdx
  802e85:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e8c:	01 00 00 
  802e8f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e93:	25 07 0e 00 00       	and    $0xe07,%eax
  802e98:	89 c1                	mov    %eax,%ecx
  802e9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e9e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ea2:	41 89 c8             	mov    %ecx,%r8d
  802ea5:	48 89 d1             	mov    %rdx,%rcx
  802ea8:	ba 00 00 00 00       	mov    $0x0,%edx
  802ead:	48 89 c6             	mov    %rax,%rsi
  802eb0:	bf 00 00 00 00       	mov    $0x0,%edi
  802eb5:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802ebc:	00 00 00 
  802ebf:	ff d0                	callq  *%rax
  802ec1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ec4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec8:	79 02                	jns    802ecc <dup+0x16f>
		goto err;
  802eca:	eb 05                	jmp    802ed1 <dup+0x174>

	return newfdnum;
  802ecc:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802ecf:	eb 33                	jmp    802f04 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802ed1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed5:	48 89 c6             	mov    %rax,%rsi
  802ed8:	bf 00 00 00 00       	mov    $0x0,%edi
  802edd:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802ee4:	00 00 00 
  802ee7:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802ee9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eed:	48 89 c6             	mov    %rax,%rsi
  802ef0:	bf 00 00 00 00       	mov    $0x0,%edi
  802ef5:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802efc:	00 00 00 
  802eff:	ff d0                	callq  *%rax
	return r;
  802f01:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f04:	c9                   	leaveq 
  802f05:	c3                   	retq   

0000000000802f06 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802f06:	55                   	push   %rbp
  802f07:	48 89 e5             	mov    %rsp,%rbp
  802f0a:	48 83 ec 40          	sub    $0x40,%rsp
  802f0e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f11:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f15:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f19:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f1d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f20:	48 89 d6             	mov    %rdx,%rsi
  802f23:	89 c7                	mov    %eax,%edi
  802f25:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  802f2c:	00 00 00 
  802f2f:	ff d0                	callq  *%rax
  802f31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f38:	78 24                	js     802f5e <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f3e:	8b 00                	mov    (%rax),%eax
  802f40:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f44:	48 89 d6             	mov    %rdx,%rsi
  802f47:	89 c7                	mov    %eax,%edi
  802f49:	48 b8 2d 2c 80 00 00 	movabs $0x802c2d,%rax
  802f50:	00 00 00 
  802f53:	ff d0                	callq  *%rax
  802f55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f5c:	79 05                	jns    802f63 <read+0x5d>
		return r;
  802f5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f61:	eb 76                	jmp    802fd9 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802f63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f67:	8b 40 08             	mov    0x8(%rax),%eax
  802f6a:	83 e0 03             	and    $0x3,%eax
  802f6d:	83 f8 01             	cmp    $0x1,%eax
  802f70:	75 3a                	jne    802fac <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802f72:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802f79:	00 00 00 
  802f7c:	48 8b 00             	mov    (%rax),%rax
  802f7f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f85:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f88:	89 c6                	mov    %eax,%esi
  802f8a:	48 bf 97 60 80 00 00 	movabs $0x806097,%rdi
  802f91:	00 00 00 
  802f94:	b8 00 00 00 00       	mov    $0x0,%eax
  802f99:	48 b9 15 0b 80 00 00 	movabs $0x800b15,%rcx
  802fa0:	00 00 00 
  802fa3:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802fa5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802faa:	eb 2d                	jmp    802fd9 <read+0xd3>
	}
	if (!dev->dev_read)
  802fac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb0:	48 8b 40 10          	mov    0x10(%rax),%rax
  802fb4:	48 85 c0             	test   %rax,%rax
  802fb7:	75 07                	jne    802fc0 <read+0xba>
		return -E_NOT_SUPP;
  802fb9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fbe:	eb 19                	jmp    802fd9 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802fc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc4:	48 8b 40 10          	mov    0x10(%rax),%rax
  802fc8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802fcc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802fd0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802fd4:	48 89 cf             	mov    %rcx,%rdi
  802fd7:	ff d0                	callq  *%rax
}
  802fd9:	c9                   	leaveq 
  802fda:	c3                   	retq   

0000000000802fdb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802fdb:	55                   	push   %rbp
  802fdc:	48 89 e5             	mov    %rsp,%rbp
  802fdf:	48 83 ec 30          	sub    $0x30,%rsp
  802fe3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fe6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802fee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ff5:	eb 49                	jmp    803040 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ff7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ffa:	48 98                	cltq   
  802ffc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803000:	48 29 c2             	sub    %rax,%rdx
  803003:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803006:	48 63 c8             	movslq %eax,%rcx
  803009:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80300d:	48 01 c1             	add    %rax,%rcx
  803010:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803013:	48 89 ce             	mov    %rcx,%rsi
  803016:	89 c7                	mov    %eax,%edi
  803018:	48 b8 06 2f 80 00 00 	movabs $0x802f06,%rax
  80301f:	00 00 00 
  803022:	ff d0                	callq  *%rax
  803024:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803027:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80302b:	79 05                	jns    803032 <readn+0x57>
			return m;
  80302d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803030:	eb 1c                	jmp    80304e <readn+0x73>
		if (m == 0)
  803032:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803036:	75 02                	jne    80303a <readn+0x5f>
			break;
  803038:	eb 11                	jmp    80304b <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80303a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80303d:	01 45 fc             	add    %eax,-0x4(%rbp)
  803040:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803043:	48 98                	cltq   
  803045:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803049:	72 ac                	jb     802ff7 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80304b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80304e:	c9                   	leaveq 
  80304f:	c3                   	retq   

0000000000803050 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803050:	55                   	push   %rbp
  803051:	48 89 e5             	mov    %rsp,%rbp
  803054:	48 83 ec 40          	sub    $0x40,%rsp
  803058:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80305b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80305f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803063:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803067:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80306a:	48 89 d6             	mov    %rdx,%rsi
  80306d:	89 c7                	mov    %eax,%edi
  80306f:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  803076:	00 00 00 
  803079:	ff d0                	callq  *%rax
  80307b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80307e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803082:	78 24                	js     8030a8 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803084:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803088:	8b 00                	mov    (%rax),%eax
  80308a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80308e:	48 89 d6             	mov    %rdx,%rsi
  803091:	89 c7                	mov    %eax,%edi
  803093:	48 b8 2d 2c 80 00 00 	movabs $0x802c2d,%rax
  80309a:	00 00 00 
  80309d:	ff d0                	callq  *%rax
  80309f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a6:	79 05                	jns    8030ad <write+0x5d>
		return r;
  8030a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ab:	eb 75                	jmp    803122 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8030ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b1:	8b 40 08             	mov    0x8(%rax),%eax
  8030b4:	83 e0 03             	and    $0x3,%eax
  8030b7:	85 c0                	test   %eax,%eax
  8030b9:	75 3a                	jne    8030f5 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8030bb:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8030c2:	00 00 00 
  8030c5:	48 8b 00             	mov    (%rax),%rax
  8030c8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8030ce:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8030d1:	89 c6                	mov    %eax,%esi
  8030d3:	48 bf b3 60 80 00 00 	movabs $0x8060b3,%rdi
  8030da:	00 00 00 
  8030dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8030e2:	48 b9 15 0b 80 00 00 	movabs $0x800b15,%rcx
  8030e9:	00 00 00 
  8030ec:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8030ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030f3:	eb 2d                	jmp    803122 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8030f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030f9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8030fd:	48 85 c0             	test   %rax,%rax
  803100:	75 07                	jne    803109 <write+0xb9>
		return -E_NOT_SUPP;
  803102:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803107:	eb 19                	jmp    803122 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  803109:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80310d:	48 8b 40 18          	mov    0x18(%rax),%rax
  803111:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803115:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803119:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80311d:	48 89 cf             	mov    %rcx,%rdi
  803120:	ff d0                	callq  *%rax
}
  803122:	c9                   	leaveq 
  803123:	c3                   	retq   

0000000000803124 <seek>:

int
seek(int fdnum, off_t offset)
{
  803124:	55                   	push   %rbp
  803125:	48 89 e5             	mov    %rsp,%rbp
  803128:	48 83 ec 18          	sub    $0x18,%rsp
  80312c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80312f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803132:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803136:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803139:	48 89 d6             	mov    %rdx,%rsi
  80313c:	89 c7                	mov    %eax,%edi
  80313e:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  803145:	00 00 00 
  803148:	ff d0                	callq  *%rax
  80314a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80314d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803151:	79 05                	jns    803158 <seek+0x34>
		return r;
  803153:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803156:	eb 0f                	jmp    803167 <seek+0x43>
	fd->fd_offset = offset;
  803158:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80315c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80315f:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803162:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803167:	c9                   	leaveq 
  803168:	c3                   	retq   

0000000000803169 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803169:	55                   	push   %rbp
  80316a:	48 89 e5             	mov    %rsp,%rbp
  80316d:	48 83 ec 30          	sub    $0x30,%rsp
  803171:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803174:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803177:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80317b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80317e:	48 89 d6             	mov    %rdx,%rsi
  803181:	89 c7                	mov    %eax,%edi
  803183:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  80318a:	00 00 00 
  80318d:	ff d0                	callq  *%rax
  80318f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803192:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803196:	78 24                	js     8031bc <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803198:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80319c:	8b 00                	mov    (%rax),%eax
  80319e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031a2:	48 89 d6             	mov    %rdx,%rsi
  8031a5:	89 c7                	mov    %eax,%edi
  8031a7:	48 b8 2d 2c 80 00 00 	movabs $0x802c2d,%rax
  8031ae:	00 00 00 
  8031b1:	ff d0                	callq  *%rax
  8031b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031ba:	79 05                	jns    8031c1 <ftruncate+0x58>
		return r;
  8031bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031bf:	eb 72                	jmp    803233 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8031c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031c5:	8b 40 08             	mov    0x8(%rax),%eax
  8031c8:	83 e0 03             	and    $0x3,%eax
  8031cb:	85 c0                	test   %eax,%eax
  8031cd:	75 3a                	jne    803209 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8031cf:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8031d6:	00 00 00 
  8031d9:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8031dc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8031e2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8031e5:	89 c6                	mov    %eax,%esi
  8031e7:	48 bf d0 60 80 00 00 	movabs $0x8060d0,%rdi
  8031ee:	00 00 00 
  8031f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f6:	48 b9 15 0b 80 00 00 	movabs $0x800b15,%rcx
  8031fd:	00 00 00 
  803200:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803202:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803207:	eb 2a                	jmp    803233 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803209:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80320d:	48 8b 40 30          	mov    0x30(%rax),%rax
  803211:	48 85 c0             	test   %rax,%rax
  803214:	75 07                	jne    80321d <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803216:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80321b:	eb 16                	jmp    803233 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80321d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803221:	48 8b 40 30          	mov    0x30(%rax),%rax
  803225:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803229:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80322c:	89 ce                	mov    %ecx,%esi
  80322e:	48 89 d7             	mov    %rdx,%rdi
  803231:	ff d0                	callq  *%rax
}
  803233:	c9                   	leaveq 
  803234:	c3                   	retq   

0000000000803235 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803235:	55                   	push   %rbp
  803236:	48 89 e5             	mov    %rsp,%rbp
  803239:	48 83 ec 30          	sub    $0x30,%rsp
  80323d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803240:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803244:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803248:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80324b:	48 89 d6             	mov    %rdx,%rsi
  80324e:	89 c7                	mov    %eax,%edi
  803250:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  803257:	00 00 00 
  80325a:	ff d0                	callq  *%rax
  80325c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80325f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803263:	78 24                	js     803289 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803265:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803269:	8b 00                	mov    (%rax),%eax
  80326b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80326f:	48 89 d6             	mov    %rdx,%rsi
  803272:	89 c7                	mov    %eax,%edi
  803274:	48 b8 2d 2c 80 00 00 	movabs $0x802c2d,%rax
  80327b:	00 00 00 
  80327e:	ff d0                	callq  *%rax
  803280:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803283:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803287:	79 05                	jns    80328e <fstat+0x59>
		return r;
  803289:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80328c:	eb 5e                	jmp    8032ec <fstat+0xb7>
	if (!dev->dev_stat)
  80328e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803292:	48 8b 40 28          	mov    0x28(%rax),%rax
  803296:	48 85 c0             	test   %rax,%rax
  803299:	75 07                	jne    8032a2 <fstat+0x6d>
		return -E_NOT_SUPP;
  80329b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8032a0:	eb 4a                	jmp    8032ec <fstat+0xb7>
	stat->st_name[0] = 0;
  8032a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032a6:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8032a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032ad:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8032b4:	00 00 00 
	stat->st_isdir = 0;
  8032b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032bb:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8032c2:	00 00 00 
	stat->st_dev = dev;
  8032c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032cd:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8032d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032d8:	48 8b 40 28          	mov    0x28(%rax),%rax
  8032dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032e0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8032e4:	48 89 ce             	mov    %rcx,%rsi
  8032e7:	48 89 d7             	mov    %rdx,%rdi
  8032ea:	ff d0                	callq  *%rax
}
  8032ec:	c9                   	leaveq 
  8032ed:	c3                   	retq   

00000000008032ee <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8032ee:	55                   	push   %rbp
  8032ef:	48 89 e5             	mov    %rsp,%rbp
  8032f2:	48 83 ec 20          	sub    $0x20,%rsp
  8032f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8032fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803302:	be 00 00 00 00       	mov    $0x0,%esi
  803307:	48 89 c7             	mov    %rax,%rdi
  80330a:	48 b8 dc 33 80 00 00 	movabs $0x8033dc,%rax
  803311:	00 00 00 
  803314:	ff d0                	callq  *%rax
  803316:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803319:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80331d:	79 05                	jns    803324 <stat+0x36>
		return fd;
  80331f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803322:	eb 2f                	jmp    803353 <stat+0x65>
	r = fstat(fd, stat);
  803324:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803328:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80332b:	48 89 d6             	mov    %rdx,%rsi
  80332e:	89 c7                	mov    %eax,%edi
  803330:	48 b8 35 32 80 00 00 	movabs $0x803235,%rax
  803337:	00 00 00 
  80333a:	ff d0                	callq  *%rax
  80333c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80333f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803342:	89 c7                	mov    %eax,%edi
  803344:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  80334b:	00 00 00 
  80334e:	ff d0                	callq  *%rax
	return r;
  803350:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803353:	c9                   	leaveq 
  803354:	c3                   	retq   

0000000000803355 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803355:	55                   	push   %rbp
  803356:	48 89 e5             	mov    %rsp,%rbp
  803359:	48 83 ec 10          	sub    $0x10,%rsp
  80335d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803360:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803364:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80336b:	00 00 00 
  80336e:	8b 00                	mov    (%rax),%eax
  803370:	85 c0                	test   %eax,%eax
  803372:	75 1d                	jne    803391 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803374:	bf 01 00 00 00       	mov    $0x1,%edi
  803379:	48 b8 e2 57 80 00 00 	movabs $0x8057e2,%rax
  803380:	00 00 00 
  803383:	ff d0                	callq  *%rax
  803385:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  80338c:	00 00 00 
  80338f:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803391:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803398:	00 00 00 
  80339b:	8b 00                	mov    (%rax),%eax
  80339d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8033a0:	b9 07 00 00 00       	mov    $0x7,%ecx
  8033a5:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8033ac:	00 00 00 
  8033af:	89 c7                	mov    %eax,%edi
  8033b1:	48 b8 d6 55 80 00 00 	movabs $0x8055d6,%rax
  8033b8:	00 00 00 
  8033bb:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8033bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8033c6:	48 89 c6             	mov    %rax,%rsi
  8033c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8033ce:	48 b8 15 55 80 00 00 	movabs $0x805515,%rax
  8033d5:	00 00 00 
  8033d8:	ff d0                	callq  *%rax
}
  8033da:	c9                   	leaveq 
  8033db:	c3                   	retq   

00000000008033dc <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8033dc:	55                   	push   %rbp
  8033dd:	48 89 e5             	mov    %rsp,%rbp
  8033e0:	48 83 ec 20          	sub    $0x20,%rsp
  8033e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033e8:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8033eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ef:	48 89 c7             	mov    %rax,%rdi
  8033f2:	48 b8 5e 16 80 00 00 	movabs $0x80165e,%rax
  8033f9:	00 00 00 
  8033fc:	ff d0                	callq  *%rax
  8033fe:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803403:	7e 0a                	jle    80340f <open+0x33>
		return -E_BAD_PATH;
  803405:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80340a:	e9 a5 00 00 00       	jmpq   8034b4 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80340f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803413:	48 89 c7             	mov    %rax,%rdi
  803416:	48 b8 3c 2a 80 00 00 	movabs $0x802a3c,%rax
  80341d:	00 00 00 
  803420:	ff d0                	callq  *%rax
  803422:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803425:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803429:	79 08                	jns    803433 <open+0x57>
		return r;
  80342b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80342e:	e9 81 00 00 00       	jmpq   8034b4 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  803433:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803437:	48 89 c6             	mov    %rax,%rsi
  80343a:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  803441:	00 00 00 
  803444:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  80344b:	00 00 00 
  80344e:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  803450:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803457:	00 00 00 
  80345a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80345d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  803463:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803467:	48 89 c6             	mov    %rax,%rsi
  80346a:	bf 01 00 00 00       	mov    $0x1,%edi
  80346f:	48 b8 55 33 80 00 00 	movabs $0x803355,%rax
  803476:	00 00 00 
  803479:	ff d0                	callq  *%rax
  80347b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80347e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803482:	79 1d                	jns    8034a1 <open+0xc5>
		fd_close(fd, 0);
  803484:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803488:	be 00 00 00 00       	mov    $0x0,%esi
  80348d:	48 89 c7             	mov    %rax,%rdi
  803490:	48 b8 64 2b 80 00 00 	movabs $0x802b64,%rax
  803497:	00 00 00 
  80349a:	ff d0                	callq  *%rax
		return r;
  80349c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80349f:	eb 13                	jmp    8034b4 <open+0xd8>
	}

	return fd2num(fd);
  8034a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034a5:	48 89 c7             	mov    %rax,%rdi
  8034a8:	48 b8 ee 29 80 00 00 	movabs $0x8029ee,%rax
  8034af:	00 00 00 
  8034b2:	ff d0                	callq  *%rax

}
  8034b4:	c9                   	leaveq 
  8034b5:	c3                   	retq   

00000000008034b6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8034b6:	55                   	push   %rbp
  8034b7:	48 89 e5             	mov    %rsp,%rbp
  8034ba:	48 83 ec 10          	sub    $0x10,%rsp
  8034be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8034c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034c6:	8b 50 0c             	mov    0xc(%rax),%edx
  8034c9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034d0:	00 00 00 
  8034d3:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8034d5:	be 00 00 00 00       	mov    $0x0,%esi
  8034da:	bf 06 00 00 00       	mov    $0x6,%edi
  8034df:	48 b8 55 33 80 00 00 	movabs $0x803355,%rax
  8034e6:	00 00 00 
  8034e9:	ff d0                	callq  *%rax
}
  8034eb:	c9                   	leaveq 
  8034ec:	c3                   	retq   

00000000008034ed <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8034ed:	55                   	push   %rbp
  8034ee:	48 89 e5             	mov    %rsp,%rbp
  8034f1:	48 83 ec 30          	sub    $0x30,%rsp
  8034f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803501:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803505:	8b 50 0c             	mov    0xc(%rax),%edx
  803508:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80350f:	00 00 00 
  803512:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803514:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80351b:	00 00 00 
  80351e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803522:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803526:	be 00 00 00 00       	mov    $0x0,%esi
  80352b:	bf 03 00 00 00       	mov    $0x3,%edi
  803530:	48 b8 55 33 80 00 00 	movabs $0x803355,%rax
  803537:	00 00 00 
  80353a:	ff d0                	callq  *%rax
  80353c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80353f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803543:	79 08                	jns    80354d <devfile_read+0x60>
		return r;
  803545:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803548:	e9 a4 00 00 00       	jmpq   8035f1 <devfile_read+0x104>
	assert(r <= n);
  80354d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803550:	48 98                	cltq   
  803552:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803556:	76 35                	jbe    80358d <devfile_read+0xa0>
  803558:	48 b9 f6 60 80 00 00 	movabs $0x8060f6,%rcx
  80355f:	00 00 00 
  803562:	48 ba fd 60 80 00 00 	movabs $0x8060fd,%rdx
  803569:	00 00 00 
  80356c:	be 86 00 00 00       	mov    $0x86,%esi
  803571:	48 bf 12 61 80 00 00 	movabs $0x806112,%rdi
  803578:	00 00 00 
  80357b:	b8 00 00 00 00       	mov    $0x0,%eax
  803580:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  803587:	00 00 00 
  80358a:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  80358d:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  803594:	7e 35                	jle    8035cb <devfile_read+0xde>
  803596:	48 b9 1d 61 80 00 00 	movabs $0x80611d,%rcx
  80359d:	00 00 00 
  8035a0:	48 ba fd 60 80 00 00 	movabs $0x8060fd,%rdx
  8035a7:	00 00 00 
  8035aa:	be 87 00 00 00       	mov    $0x87,%esi
  8035af:	48 bf 12 61 80 00 00 	movabs $0x806112,%rdi
  8035b6:	00 00 00 
  8035b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8035be:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  8035c5:	00 00 00 
  8035c8:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8035cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ce:	48 63 d0             	movslq %eax,%rdx
  8035d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035d5:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8035dc:	00 00 00 
  8035df:	48 89 c7             	mov    %rax,%rdi
  8035e2:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  8035e9:	00 00 00 
  8035ec:	ff d0                	callq  *%rax
	return r;
  8035ee:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8035f1:	c9                   	leaveq 
  8035f2:	c3                   	retq   

00000000008035f3 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8035f3:	55                   	push   %rbp
  8035f4:	48 89 e5             	mov    %rsp,%rbp
  8035f7:	48 83 ec 40          	sub    $0x40,%rsp
  8035fb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035ff:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803603:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  803607:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80360b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80360f:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  803616:	00 
  803617:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80361b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80361f:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  803624:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803628:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80362c:	8b 50 0c             	mov    0xc(%rax),%edx
  80362f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803636:	00 00 00 
  803639:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80363b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803642:	00 00 00 
  803645:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803649:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  80364d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803651:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803655:	48 89 c6             	mov    %rax,%rsi
  803658:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  80365f:	00 00 00 
  803662:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  803669:	00 00 00 
  80366c:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80366e:	be 00 00 00 00       	mov    $0x0,%esi
  803673:	bf 04 00 00 00       	mov    $0x4,%edi
  803678:	48 b8 55 33 80 00 00 	movabs $0x803355,%rax
  80367f:	00 00 00 
  803682:	ff d0                	callq  *%rax
  803684:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803687:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80368b:	79 05                	jns    803692 <devfile_write+0x9f>
		return r;
  80368d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803690:	eb 43                	jmp    8036d5 <devfile_write+0xe2>
	assert(r <= n);
  803692:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803695:	48 98                	cltq   
  803697:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80369b:	76 35                	jbe    8036d2 <devfile_write+0xdf>
  80369d:	48 b9 f6 60 80 00 00 	movabs $0x8060f6,%rcx
  8036a4:	00 00 00 
  8036a7:	48 ba fd 60 80 00 00 	movabs $0x8060fd,%rdx
  8036ae:	00 00 00 
  8036b1:	be a2 00 00 00       	mov    $0xa2,%esi
  8036b6:	48 bf 12 61 80 00 00 	movabs $0x806112,%rdi
  8036bd:	00 00 00 
  8036c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c5:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  8036cc:	00 00 00 
  8036cf:	41 ff d0             	callq  *%r8
	return r;
  8036d2:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8036d5:	c9                   	leaveq 
  8036d6:	c3                   	retq   

00000000008036d7 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8036d7:	55                   	push   %rbp
  8036d8:	48 89 e5             	mov    %rsp,%rbp
  8036db:	48 83 ec 20          	sub    $0x20,%rsp
  8036df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8036e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036eb:	8b 50 0c             	mov    0xc(%rax),%edx
  8036ee:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036f5:	00 00 00 
  8036f8:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8036fa:	be 00 00 00 00       	mov    $0x0,%esi
  8036ff:	bf 05 00 00 00       	mov    $0x5,%edi
  803704:	48 b8 55 33 80 00 00 	movabs $0x803355,%rax
  80370b:	00 00 00 
  80370e:	ff d0                	callq  *%rax
  803710:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803713:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803717:	79 05                	jns    80371e <devfile_stat+0x47>
		return r;
  803719:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80371c:	eb 56                	jmp    803774 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80371e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803722:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803729:	00 00 00 
  80372c:	48 89 c7             	mov    %rax,%rdi
  80372f:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  803736:	00 00 00 
  803739:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80373b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803742:	00 00 00 
  803745:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80374b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80374f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803755:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80375c:	00 00 00 
  80375f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803765:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803769:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80376f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803774:	c9                   	leaveq 
  803775:	c3                   	retq   

0000000000803776 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803776:	55                   	push   %rbp
  803777:	48 89 e5             	mov    %rsp,%rbp
  80377a:	48 83 ec 10          	sub    $0x10,%rsp
  80377e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803782:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803785:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803789:	8b 50 0c             	mov    0xc(%rax),%edx
  80378c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803793:	00 00 00 
  803796:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803798:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80379f:	00 00 00 
  8037a2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8037a5:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8037a8:	be 00 00 00 00       	mov    $0x0,%esi
  8037ad:	bf 02 00 00 00       	mov    $0x2,%edi
  8037b2:	48 b8 55 33 80 00 00 	movabs $0x803355,%rax
  8037b9:	00 00 00 
  8037bc:	ff d0                	callq  *%rax
}
  8037be:	c9                   	leaveq 
  8037bf:	c3                   	retq   

00000000008037c0 <remove>:

// Delete a file
int
remove(const char *path)
{
  8037c0:	55                   	push   %rbp
  8037c1:	48 89 e5             	mov    %rsp,%rbp
  8037c4:	48 83 ec 10          	sub    $0x10,%rsp
  8037c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8037cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037d0:	48 89 c7             	mov    %rax,%rdi
  8037d3:	48 b8 5e 16 80 00 00 	movabs $0x80165e,%rax
  8037da:	00 00 00 
  8037dd:	ff d0                	callq  *%rax
  8037df:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8037e4:	7e 07                	jle    8037ed <remove+0x2d>
		return -E_BAD_PATH;
  8037e6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8037eb:	eb 33                	jmp    803820 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8037ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f1:	48 89 c6             	mov    %rax,%rsi
  8037f4:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  8037fb:	00 00 00 
  8037fe:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  803805:	00 00 00 
  803808:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80380a:	be 00 00 00 00       	mov    $0x0,%esi
  80380f:	bf 07 00 00 00       	mov    $0x7,%edi
  803814:	48 b8 55 33 80 00 00 	movabs $0x803355,%rax
  80381b:	00 00 00 
  80381e:	ff d0                	callq  *%rax
}
  803820:	c9                   	leaveq 
  803821:	c3                   	retq   

0000000000803822 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803822:	55                   	push   %rbp
  803823:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803826:	be 00 00 00 00       	mov    $0x0,%esi
  80382b:	bf 08 00 00 00       	mov    $0x8,%edi
  803830:	48 b8 55 33 80 00 00 	movabs $0x803355,%rax
  803837:	00 00 00 
  80383a:	ff d0                	callq  *%rax
}
  80383c:	5d                   	pop    %rbp
  80383d:	c3                   	retq   

000000000080383e <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80383e:	55                   	push   %rbp
  80383f:	48 89 e5             	mov    %rsp,%rbp
  803842:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803849:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803850:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803857:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80385e:	be 00 00 00 00       	mov    $0x0,%esi
  803863:	48 89 c7             	mov    %rax,%rdi
  803866:	48 b8 dc 33 80 00 00 	movabs $0x8033dc,%rax
  80386d:	00 00 00 
  803870:	ff d0                	callq  *%rax
  803872:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803875:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803879:	79 28                	jns    8038a3 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80387b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80387e:	89 c6                	mov    %eax,%esi
  803880:	48 bf 29 61 80 00 00 	movabs $0x806129,%rdi
  803887:	00 00 00 
  80388a:	b8 00 00 00 00       	mov    $0x0,%eax
  80388f:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  803896:	00 00 00 
  803899:	ff d2                	callq  *%rdx
		return fd_src;
  80389b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80389e:	e9 74 01 00 00       	jmpq   803a17 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8038a3:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8038aa:	be 01 01 00 00       	mov    $0x101,%esi
  8038af:	48 89 c7             	mov    %rax,%rdi
  8038b2:	48 b8 dc 33 80 00 00 	movabs $0x8033dc,%rax
  8038b9:	00 00 00 
  8038bc:	ff d0                	callq  *%rax
  8038be:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8038c1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8038c5:	79 39                	jns    803900 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8038c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038ca:	89 c6                	mov    %eax,%esi
  8038cc:	48 bf 3f 61 80 00 00 	movabs $0x80613f,%rdi
  8038d3:	00 00 00 
  8038d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8038db:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  8038e2:	00 00 00 
  8038e5:	ff d2                	callq  *%rdx
		close(fd_src);
  8038e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ea:	89 c7                	mov    %eax,%edi
  8038ec:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  8038f3:	00 00 00 
  8038f6:	ff d0                	callq  *%rax
		return fd_dest;
  8038f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038fb:	e9 17 01 00 00       	jmpq   803a17 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803900:	eb 74                	jmp    803976 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803902:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803905:	48 63 d0             	movslq %eax,%rdx
  803908:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80390f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803912:	48 89 ce             	mov    %rcx,%rsi
  803915:	89 c7                	mov    %eax,%edi
  803917:	48 b8 50 30 80 00 00 	movabs $0x803050,%rax
  80391e:	00 00 00 
  803921:	ff d0                	callq  *%rax
  803923:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803926:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80392a:	79 4a                	jns    803976 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80392c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80392f:	89 c6                	mov    %eax,%esi
  803931:	48 bf 59 61 80 00 00 	movabs $0x806159,%rdi
  803938:	00 00 00 
  80393b:	b8 00 00 00 00       	mov    $0x0,%eax
  803940:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  803947:	00 00 00 
  80394a:	ff d2                	callq  *%rdx
			close(fd_src);
  80394c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80394f:	89 c7                	mov    %eax,%edi
  803951:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  803958:	00 00 00 
  80395b:	ff d0                	callq  *%rax
			close(fd_dest);
  80395d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803960:	89 c7                	mov    %eax,%edi
  803962:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  803969:	00 00 00 
  80396c:	ff d0                	callq  *%rax
			return write_size;
  80396e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803971:	e9 a1 00 00 00       	jmpq   803a17 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803976:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80397d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803980:	ba 00 02 00 00       	mov    $0x200,%edx
  803985:	48 89 ce             	mov    %rcx,%rsi
  803988:	89 c7                	mov    %eax,%edi
  80398a:	48 b8 06 2f 80 00 00 	movabs $0x802f06,%rax
  803991:	00 00 00 
  803994:	ff d0                	callq  *%rax
  803996:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803999:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80399d:	0f 8f 5f ff ff ff    	jg     803902 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8039a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8039a7:	79 47                	jns    8039f0 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8039a9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8039ac:	89 c6                	mov    %eax,%esi
  8039ae:	48 bf 6c 61 80 00 00 	movabs $0x80616c,%rdi
  8039b5:	00 00 00 
  8039b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8039bd:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  8039c4:	00 00 00 
  8039c7:	ff d2                	callq  *%rdx
		close(fd_src);
  8039c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039cc:	89 c7                	mov    %eax,%edi
  8039ce:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  8039d5:	00 00 00 
  8039d8:	ff d0                	callq  *%rax
		close(fd_dest);
  8039da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039dd:	89 c7                	mov    %eax,%edi
  8039df:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  8039e6:	00 00 00 
  8039e9:	ff d0                	callq  *%rax
		return read_size;
  8039eb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8039ee:	eb 27                	jmp    803a17 <copy+0x1d9>
	}
	close(fd_src);
  8039f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f3:	89 c7                	mov    %eax,%edi
  8039f5:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  8039fc:	00 00 00 
  8039ff:	ff d0                	callq  *%rax
	close(fd_dest);
  803a01:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a04:	89 c7                	mov    %eax,%edi
  803a06:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  803a0d:	00 00 00 
  803a10:	ff d0                	callq  *%rax
	return 0;
  803a12:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803a17:	c9                   	leaveq 
  803a18:	c3                   	retq   

0000000000803a19 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  803a19:	55                   	push   %rbp
  803a1a:	48 89 e5             	mov    %rsp,%rbp
  803a1d:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  803a24:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  803a2b:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  803a32:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  803a39:	be 00 00 00 00       	mov    $0x0,%esi
  803a3e:	48 89 c7             	mov    %rax,%rdi
  803a41:	48 b8 dc 33 80 00 00 	movabs $0x8033dc,%rax
  803a48:	00 00 00 
  803a4b:	ff d0                	callq  *%rax
  803a4d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803a50:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803a54:	79 08                	jns    803a5e <spawn+0x45>
		return r;
  803a56:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a59:	e9 0c 03 00 00       	jmpq   803d6a <spawn+0x351>
	fd = r;
  803a5e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a61:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  803a64:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  803a6b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  803a6f:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  803a76:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803a79:	ba 00 02 00 00       	mov    $0x200,%edx
  803a7e:	48 89 ce             	mov    %rcx,%rsi
  803a81:	89 c7                	mov    %eax,%edi
  803a83:	48 b8 db 2f 80 00 00 	movabs $0x802fdb,%rax
  803a8a:	00 00 00 
  803a8d:	ff d0                	callq  *%rax
  803a8f:	3d 00 02 00 00       	cmp    $0x200,%eax
  803a94:	75 0d                	jne    803aa3 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  803a96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a9a:	8b 00                	mov    (%rax),%eax
  803a9c:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  803aa1:	74 43                	je     803ae6 <spawn+0xcd>
		close(fd);
  803aa3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803aa6:	89 c7                	mov    %eax,%edi
  803aa8:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  803aaf:	00 00 00 
  803ab2:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  803ab4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ab8:	8b 00                	mov    (%rax),%eax
  803aba:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  803abf:	89 c6                	mov    %eax,%esi
  803ac1:	48 bf 88 61 80 00 00 	movabs $0x806188,%rdi
  803ac8:	00 00 00 
  803acb:	b8 00 00 00 00       	mov    $0x0,%eax
  803ad0:	48 b9 15 0b 80 00 00 	movabs $0x800b15,%rcx
  803ad7:	00 00 00 
  803ada:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  803adc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803ae1:	e9 84 02 00 00       	jmpq   803d6a <spawn+0x351>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803ae6:	b8 07 00 00 00       	mov    $0x7,%eax
  803aeb:	cd 30                	int    $0x30
  803aed:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803af0:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803af3:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803af6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803afa:	79 08                	jns    803b04 <spawn+0xeb>
		return r;
  803afc:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803aff:	e9 66 02 00 00       	jmpq   803d6a <spawn+0x351>
	child = r;
  803b04:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b07:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  803b0a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803b0d:	25 ff 03 00 00       	and    $0x3ff,%eax
  803b12:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803b19:	00 00 00 
  803b1c:	48 98                	cltq   
  803b1e:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803b25:	48 01 d0             	add    %rdx,%rax
  803b28:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803b2f:	48 89 c6             	mov    %rax,%rsi
  803b32:	b8 18 00 00 00       	mov    $0x18,%eax
  803b37:	48 89 d7             	mov    %rdx,%rdi
  803b3a:	48 89 c1             	mov    %rax,%rcx
  803b3d:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803b40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b44:	48 8b 40 18          	mov    0x18(%rax),%rax
  803b48:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803b4f:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803b56:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803b5d:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  803b64:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803b67:	48 89 ce             	mov    %rcx,%rsi
  803b6a:	89 c7                	mov    %eax,%edi
  803b6c:	48 b8 d4 3f 80 00 00 	movabs $0x803fd4,%rax
  803b73:	00 00 00 
  803b76:	ff d0                	callq  *%rax
  803b78:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803b7b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803b7f:	79 08                	jns    803b89 <spawn+0x170>
		return r;
  803b81:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b84:	e9 e1 01 00 00       	jmpq   803d6a <spawn+0x351>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  803b89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b8d:	48 8b 40 20          	mov    0x20(%rax),%rax
  803b91:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  803b98:	48 01 d0             	add    %rdx,%rax
  803b9b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803b9f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ba6:	e9 a3 00 00 00       	jmpq   803c4e <spawn+0x235>
		if (ph->p_type != ELF_PROG_LOAD)
  803bab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803baf:	8b 00                	mov    (%rax),%eax
  803bb1:	83 f8 01             	cmp    $0x1,%eax
  803bb4:	74 05                	je     803bbb <spawn+0x1a2>
			continue;
  803bb6:	e9 8a 00 00 00       	jmpq   803c45 <spawn+0x22c>
		perm = PTE_P | PTE_U;
  803bbb:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803bc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bc6:	8b 40 04             	mov    0x4(%rax),%eax
  803bc9:	83 e0 02             	and    $0x2,%eax
  803bcc:	85 c0                	test   %eax,%eax
  803bce:	74 04                	je     803bd4 <spawn+0x1bb>
			perm |= PTE_W;
  803bd0:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803bd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bd8:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803bdc:	41 89 c1             	mov    %eax,%r9d
  803bdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803be3:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803be7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803beb:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803bef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bf3:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803bf7:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803bfa:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803bfd:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803c00:	89 3c 24             	mov    %edi,(%rsp)
  803c03:	89 c7                	mov    %eax,%edi
  803c05:	48 b8 7d 42 80 00 00 	movabs $0x80427d,%rax
  803c0c:	00 00 00 
  803c0f:	ff d0                	callq  *%rax
  803c11:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803c14:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803c18:	79 2b                	jns    803c45 <spawn+0x22c>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803c1a:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803c1b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803c1e:	89 c7                	mov    %eax,%edi
  803c20:	48 b8 39 1f 80 00 00 	movabs $0x801f39,%rax
  803c27:	00 00 00 
  803c2a:	ff d0                	callq  *%rax
	close(fd);
  803c2c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803c2f:	89 c7                	mov    %eax,%edi
  803c31:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  803c38:	00 00 00 
  803c3b:	ff d0                	callq  *%rax
	return r;
  803c3d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c40:	e9 25 01 00 00       	jmpq   803d6a <spawn+0x351>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803c45:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803c49:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803c4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c52:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803c56:	0f b7 c0             	movzwl %ax,%eax
  803c59:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803c5c:	0f 8f 49 ff ff ff    	jg     803bab <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803c62:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803c65:	89 c7                	mov    %eax,%edi
  803c67:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  803c6e:	00 00 00 
  803c71:	ff d0                	callq  *%rax
	fd = -1;
  803c73:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)


	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  803c7a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803c7d:	89 c7                	mov    %eax,%edi
  803c7f:	48 b8 69 44 80 00 00 	movabs $0x804469,%rax
  803c86:	00 00 00 
  803c89:	ff d0                	callq  *%rax
  803c8b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803c8e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803c92:	79 30                	jns    803cc4 <spawn+0x2ab>
		panic("copy_shared_pages: %e", r);
  803c94:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c97:	89 c1                	mov    %eax,%ecx
  803c99:	48 ba a2 61 80 00 00 	movabs $0x8061a2,%rdx
  803ca0:	00 00 00 
  803ca3:	be 86 00 00 00       	mov    $0x86,%esi
  803ca8:	48 bf b8 61 80 00 00 	movabs $0x8061b8,%rdi
  803caf:	00 00 00 
  803cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  803cb7:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  803cbe:	00 00 00 
  803cc1:	41 ff d0             	callq  *%r8


	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803cc4:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803ccb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803cce:	48 89 d6             	mov    %rdx,%rsi
  803cd1:	89 c7                	mov    %eax,%edi
  803cd3:	48 b8 39 21 80 00 00 	movabs $0x802139,%rax
  803cda:	00 00 00 
  803cdd:	ff d0                	callq  *%rax
  803cdf:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803ce2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803ce6:	79 30                	jns    803d18 <spawn+0x2ff>
		panic("sys_env_set_trapframe: %e", r);
  803ce8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803ceb:	89 c1                	mov    %eax,%ecx
  803ced:	48 ba c4 61 80 00 00 	movabs $0x8061c4,%rdx
  803cf4:	00 00 00 
  803cf7:	be 8a 00 00 00       	mov    $0x8a,%esi
  803cfc:	48 bf b8 61 80 00 00 	movabs $0x8061b8,%rdi
  803d03:	00 00 00 
  803d06:	b8 00 00 00 00       	mov    $0x0,%eax
  803d0b:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  803d12:	00 00 00 
  803d15:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803d18:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803d1b:	be 02 00 00 00       	mov    $0x2,%esi
  803d20:	89 c7                	mov    %eax,%edi
  803d22:	48 b8 ee 20 80 00 00 	movabs $0x8020ee,%rax
  803d29:	00 00 00 
  803d2c:	ff d0                	callq  *%rax
  803d2e:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803d31:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803d35:	79 30                	jns    803d67 <spawn+0x34e>
		panic("sys_env_set_status: %e", r);
  803d37:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803d3a:	89 c1                	mov    %eax,%ecx
  803d3c:	48 ba de 61 80 00 00 	movabs $0x8061de,%rdx
  803d43:	00 00 00 
  803d46:	be 8d 00 00 00       	mov    $0x8d,%esi
  803d4b:	48 bf b8 61 80 00 00 	movabs $0x8061b8,%rdi
  803d52:	00 00 00 
  803d55:	b8 00 00 00 00       	mov    $0x0,%eax
  803d5a:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  803d61:	00 00 00 
  803d64:	41 ff d0             	callq  *%r8

	return child;
  803d67:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  803d6a:	c9                   	leaveq 
  803d6b:	c3                   	retq   

0000000000803d6c <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803d6c:	55                   	push   %rbp
  803d6d:	48 89 e5             	mov    %rsp,%rbp
  803d70:	41 55                	push   %r13
  803d72:	41 54                	push   %r12
  803d74:	53                   	push   %rbx
  803d75:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803d7c:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803d83:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  803d8a:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803d91:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  803d98:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803d9f:	84 c0                	test   %al,%al
  803da1:	74 26                	je     803dc9 <spawnl+0x5d>
  803da3:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  803daa:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803db1:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803db5:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  803db9:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  803dbd:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803dc1:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803dc5:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  803dc9:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803dd0:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803dd7:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803dda:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803de1:	00 00 00 
  803de4:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803deb:	00 00 00 
  803dee:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803df2:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803df9:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803e00:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803e07:	eb 07                	jmp    803e10 <spawnl+0xa4>
		argc++;
  803e09:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803e10:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803e16:	83 f8 30             	cmp    $0x30,%eax
  803e19:	73 23                	jae    803e3e <spawnl+0xd2>
  803e1b:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803e22:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803e28:	89 c0                	mov    %eax,%eax
  803e2a:	48 01 d0             	add    %rdx,%rax
  803e2d:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803e33:	83 c2 08             	add    $0x8,%edx
  803e36:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803e3c:	eb 15                	jmp    803e53 <spawnl+0xe7>
  803e3e:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803e45:	48 89 d0             	mov    %rdx,%rax
  803e48:	48 83 c2 08          	add    $0x8,%rdx
  803e4c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803e53:	48 8b 00             	mov    (%rax),%rax
  803e56:	48 85 c0             	test   %rax,%rax
  803e59:	75 ae                	jne    803e09 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803e5b:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803e61:	83 c0 02             	add    $0x2,%eax
  803e64:	48 89 e2             	mov    %rsp,%rdx
  803e67:	48 89 d3             	mov    %rdx,%rbx
  803e6a:	48 63 d0             	movslq %eax,%rdx
  803e6d:	48 83 ea 01          	sub    $0x1,%rdx
  803e71:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803e78:	48 63 d0             	movslq %eax,%rdx
  803e7b:	49 89 d4             	mov    %rdx,%r12
  803e7e:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803e84:	48 63 d0             	movslq %eax,%rdx
  803e87:	49 89 d2             	mov    %rdx,%r10
  803e8a:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803e90:	48 98                	cltq   
  803e92:	48 c1 e0 03          	shl    $0x3,%rax
  803e96:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803e9a:	b8 10 00 00 00       	mov    $0x10,%eax
  803e9f:	48 83 e8 01          	sub    $0x1,%rax
  803ea3:	48 01 d0             	add    %rdx,%rax
  803ea6:	bf 10 00 00 00       	mov    $0x10,%edi
  803eab:	ba 00 00 00 00       	mov    $0x0,%edx
  803eb0:	48 f7 f7             	div    %rdi
  803eb3:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803eb7:	48 29 c4             	sub    %rax,%rsp
  803eba:	48 89 e0             	mov    %rsp,%rax
  803ebd:	48 83 c0 07          	add    $0x7,%rax
  803ec1:	48 c1 e8 03          	shr    $0x3,%rax
  803ec5:	48 c1 e0 03          	shl    $0x3,%rax
  803ec9:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803ed0:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803ed7:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803ede:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803ee1:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803ee7:	8d 50 01             	lea    0x1(%rax),%edx
  803eea:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803ef1:	48 63 d2             	movslq %edx,%rdx
  803ef4:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803efb:	00 

	va_start(vl, arg0);
  803efc:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803f03:	00 00 00 
  803f06:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803f0d:	00 00 00 
  803f10:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803f14:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803f1b:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803f22:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803f29:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803f30:	00 00 00 
  803f33:	eb 63                	jmp    803f98 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803f35:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803f3b:	8d 70 01             	lea    0x1(%rax),%esi
  803f3e:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803f44:	83 f8 30             	cmp    $0x30,%eax
  803f47:	73 23                	jae    803f6c <spawnl+0x200>
  803f49:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803f50:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803f56:	89 c0                	mov    %eax,%eax
  803f58:	48 01 d0             	add    %rdx,%rax
  803f5b:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803f61:	83 c2 08             	add    $0x8,%edx
  803f64:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803f6a:	eb 15                	jmp    803f81 <spawnl+0x215>
  803f6c:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803f73:	48 89 d0             	mov    %rdx,%rax
  803f76:	48 83 c2 08          	add    $0x8,%rdx
  803f7a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803f81:	48 8b 08             	mov    (%rax),%rcx
  803f84:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803f8b:	89 f2                	mov    %esi,%edx
  803f8d:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803f91:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803f98:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803f9e:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803fa4:	77 8f                	ja     803f35 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803fa6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803fad:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803fb4:	48 89 d6             	mov    %rdx,%rsi
  803fb7:	48 89 c7             	mov    %rax,%rdi
  803fba:	48 b8 19 3a 80 00 00 	movabs $0x803a19,%rax
  803fc1:	00 00 00 
  803fc4:	ff d0                	callq  *%rax
  803fc6:	48 89 dc             	mov    %rbx,%rsp
}
  803fc9:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803fcd:	5b                   	pop    %rbx
  803fce:	41 5c                	pop    %r12
  803fd0:	41 5d                	pop    %r13
  803fd2:	5d                   	pop    %rbp
  803fd3:	c3                   	retq   

0000000000803fd4 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803fd4:	55                   	push   %rbp
  803fd5:	48 89 e5             	mov    %rsp,%rbp
  803fd8:	48 83 ec 50          	sub    $0x50,%rsp
  803fdc:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803fdf:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803fe3:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803fe7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803fee:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803fef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803ff6:	eb 33                	jmp    80402b <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803ff8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ffb:	48 98                	cltq   
  803ffd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804004:	00 
  804005:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804009:	48 01 d0             	add    %rdx,%rax
  80400c:	48 8b 00             	mov    (%rax),%rax
  80400f:	48 89 c7             	mov    %rax,%rdi
  804012:	48 b8 5e 16 80 00 00 	movabs $0x80165e,%rax
  804019:	00 00 00 
  80401c:	ff d0                	callq  *%rax
  80401e:	83 c0 01             	add    $0x1,%eax
  804021:	48 98                	cltq   
  804023:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  804027:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  80402b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80402e:	48 98                	cltq   
  804030:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804037:	00 
  804038:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80403c:	48 01 d0             	add    %rdx,%rax
  80403f:	48 8b 00             	mov    (%rax),%rax
  804042:	48 85 c0             	test   %rax,%rax
  804045:	75 b1                	jne    803ff8 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  804047:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80404b:	48 f7 d8             	neg    %rax
  80404e:	48 05 00 10 40 00    	add    $0x401000,%rax
  804054:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  804058:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80405c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  804060:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804064:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  804068:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80406b:	83 c2 01             	add    $0x1,%edx
  80406e:	c1 e2 03             	shl    $0x3,%edx
  804071:	48 63 d2             	movslq %edx,%rdx
  804074:	48 f7 da             	neg    %rdx
  804077:	48 01 d0             	add    %rdx,%rax
  80407a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80407e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804082:	48 83 e8 10          	sub    $0x10,%rax
  804086:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  80408c:	77 0a                	ja     804098 <init_stack+0xc4>
		return -E_NO_MEM;
  80408e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  804093:	e9 e3 01 00 00       	jmpq   80427b <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  804098:	ba 07 00 00 00       	mov    $0x7,%edx
  80409d:	be 00 00 40 00       	mov    $0x400000,%esi
  8040a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8040a7:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  8040ae:	00 00 00 
  8040b1:	ff d0                	callq  *%rax
  8040b3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8040b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8040ba:	79 08                	jns    8040c4 <init_stack+0xf0>
		return r;
  8040bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040bf:	e9 b7 01 00 00       	jmpq   80427b <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8040c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8040cb:	e9 8a 00 00 00       	jmpq   80415a <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  8040d0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8040d3:	48 98                	cltq   
  8040d5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8040dc:	00 
  8040dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040e1:	48 01 c2             	add    %rax,%rdx
  8040e4:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8040e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040ed:	48 01 c8             	add    %rcx,%rax
  8040f0:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8040f6:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  8040f9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8040fc:	48 98                	cltq   
  8040fe:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804105:	00 
  804106:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80410a:	48 01 d0             	add    %rdx,%rax
  80410d:	48 8b 10             	mov    (%rax),%rdx
  804110:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804114:	48 89 d6             	mov    %rdx,%rsi
  804117:	48 89 c7             	mov    %rax,%rdi
  80411a:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  804121:	00 00 00 
  804124:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  804126:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804129:	48 98                	cltq   
  80412b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804132:	00 
  804133:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804137:	48 01 d0             	add    %rdx,%rax
  80413a:	48 8b 00             	mov    (%rax),%rax
  80413d:	48 89 c7             	mov    %rax,%rdi
  804140:	48 b8 5e 16 80 00 00 	movabs $0x80165e,%rax
  804147:	00 00 00 
  80414a:	ff d0                	callq  *%rax
  80414c:	48 98                	cltq   
  80414e:	48 83 c0 01          	add    $0x1,%rax
  804152:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  804156:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  80415a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80415d:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  804160:	0f 8c 6a ff ff ff    	jl     8040d0 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  804166:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804169:	48 98                	cltq   
  80416b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804172:	00 
  804173:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804177:	48 01 d0             	add    %rdx,%rax
  80417a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  804181:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  804188:	00 
  804189:	74 35                	je     8041c0 <init_stack+0x1ec>
  80418b:	48 b9 f8 61 80 00 00 	movabs $0x8061f8,%rcx
  804192:	00 00 00 
  804195:	48 ba 1e 62 80 00 00 	movabs $0x80621e,%rdx
  80419c:	00 00 00 
  80419f:	be f6 00 00 00       	mov    $0xf6,%esi
  8041a4:	48 bf b8 61 80 00 00 	movabs $0x8061b8,%rdi
  8041ab:	00 00 00 
  8041ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8041b3:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  8041ba:	00 00 00 
  8041bd:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8041c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041c4:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  8041c8:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8041cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041d1:	48 01 c8             	add    %rcx,%rax
  8041d4:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8041da:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  8041dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041e1:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  8041e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8041e8:	48 98                	cltq   
  8041ea:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8041ed:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  8041f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041f6:	48 01 d0             	add    %rdx,%rax
  8041f9:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8041ff:	48 89 c2             	mov    %rax,%rdx
  804202:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804206:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  804209:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80420c:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  804212:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804217:	89 c2                	mov    %eax,%edx
  804219:	be 00 00 40 00       	mov    $0x400000,%esi
  80421e:	bf 00 00 00 00       	mov    $0x0,%edi
  804223:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  80422a:	00 00 00 
  80422d:	ff d0                	callq  *%rax
  80422f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804232:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804236:	79 02                	jns    80423a <init_stack+0x266>
		goto error;
  804238:	eb 28                	jmp    804262 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80423a:	be 00 00 40 00       	mov    $0x400000,%esi
  80423f:	bf 00 00 00 00       	mov    $0x0,%edi
  804244:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  80424b:	00 00 00 
  80424e:	ff d0                	callq  *%rax
  804250:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804253:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804257:	79 02                	jns    80425b <init_stack+0x287>
		goto error;
  804259:	eb 07                	jmp    804262 <init_stack+0x28e>

	return 0;
  80425b:	b8 00 00 00 00       	mov    $0x0,%eax
  804260:	eb 19                	jmp    80427b <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  804262:	be 00 00 40 00       	mov    $0x400000,%esi
  804267:	bf 00 00 00 00       	mov    $0x0,%edi
  80426c:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  804273:	00 00 00 
  804276:	ff d0                	callq  *%rax
	return r;
  804278:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80427b:	c9                   	leaveq 
  80427c:	c3                   	retq   

000000000080427d <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  80427d:	55                   	push   %rbp
  80427e:	48 89 e5             	mov    %rsp,%rbp
  804281:	48 83 ec 50          	sub    $0x50,%rsp
  804285:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804288:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80428c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  804290:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  804293:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  804297:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  80429b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80429f:	25 ff 0f 00 00       	and    $0xfff,%eax
  8042a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042ab:	74 21                	je     8042ce <map_segment+0x51>
		va -= i;
  8042ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042b0:	48 98                	cltq   
  8042b2:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  8042b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042b9:	48 98                	cltq   
  8042bb:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  8042bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042c2:	48 98                	cltq   
  8042c4:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8042c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042cb:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8042ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8042d5:	e9 79 01 00 00       	jmpq   804453 <map_segment+0x1d6>
		if (i >= filesz) {
  8042da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042dd:	48 98                	cltq   
  8042df:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8042e3:	72 3c                	jb     804321 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8042e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042e8:	48 63 d0             	movslq %eax,%rdx
  8042eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042ef:	48 01 d0             	add    %rdx,%rax
  8042f2:	48 89 c1             	mov    %rax,%rcx
  8042f5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8042f8:	8b 55 10             	mov    0x10(%rbp),%edx
  8042fb:	48 89 ce             	mov    %rcx,%rsi
  8042fe:	89 c7                	mov    %eax,%edi
  804300:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  804307:	00 00 00 
  80430a:	ff d0                	callq  *%rax
  80430c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80430f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804313:	0f 89 33 01 00 00    	jns    80444c <map_segment+0x1cf>
				return r;
  804319:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80431c:	e9 46 01 00 00       	jmpq   804467 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  804321:	ba 07 00 00 00       	mov    $0x7,%edx
  804326:	be 00 00 40 00       	mov    $0x400000,%esi
  80432b:	bf 00 00 00 00       	mov    $0x0,%edi
  804330:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  804337:	00 00 00 
  80433a:	ff d0                	callq  *%rax
  80433c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80433f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804343:	79 08                	jns    80434d <map_segment+0xd0>
				return r;
  804345:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804348:	e9 1a 01 00 00       	jmpq   804467 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  80434d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804350:	8b 55 bc             	mov    -0x44(%rbp),%edx
  804353:	01 c2                	add    %eax,%edx
  804355:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804358:	89 d6                	mov    %edx,%esi
  80435a:	89 c7                	mov    %eax,%edi
  80435c:	48 b8 24 31 80 00 00 	movabs $0x803124,%rax
  804363:	00 00 00 
  804366:	ff d0                	callq  *%rax
  804368:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80436b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80436f:	79 08                	jns    804379 <map_segment+0xfc>
				return r;
  804371:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804374:	e9 ee 00 00 00       	jmpq   804467 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  804379:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  804380:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804383:	48 98                	cltq   
  804385:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804389:	48 29 c2             	sub    %rax,%rdx
  80438c:	48 89 d0             	mov    %rdx,%rax
  80438f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  804393:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804396:	48 63 d0             	movslq %eax,%rdx
  804399:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80439d:	48 39 c2             	cmp    %rax,%rdx
  8043a0:	48 0f 47 d0          	cmova  %rax,%rdx
  8043a4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8043a7:	be 00 00 40 00       	mov    $0x400000,%esi
  8043ac:	89 c7                	mov    %eax,%edi
  8043ae:	48 b8 db 2f 80 00 00 	movabs $0x802fdb,%rax
  8043b5:	00 00 00 
  8043b8:	ff d0                	callq  *%rax
  8043ba:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8043bd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8043c1:	79 08                	jns    8043cb <map_segment+0x14e>
				return r;
  8043c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8043c6:	e9 9c 00 00 00       	jmpq   804467 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8043cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043ce:	48 63 d0             	movslq %eax,%rdx
  8043d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043d5:	48 01 d0             	add    %rdx,%rax
  8043d8:	48 89 c2             	mov    %rax,%rdx
  8043db:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8043de:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8043e2:	48 89 d1             	mov    %rdx,%rcx
  8043e5:	89 c2                	mov    %eax,%edx
  8043e7:	be 00 00 40 00       	mov    $0x400000,%esi
  8043ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8043f1:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  8043f8:	00 00 00 
  8043fb:	ff d0                	callq  *%rax
  8043fd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804400:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804404:	79 30                	jns    804436 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  804406:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804409:	89 c1                	mov    %eax,%ecx
  80440b:	48 ba 33 62 80 00 00 	movabs $0x806233,%rdx
  804412:	00 00 00 
  804415:	be 29 01 00 00       	mov    $0x129,%esi
  80441a:	48 bf b8 61 80 00 00 	movabs $0x8061b8,%rdi
  804421:	00 00 00 
  804424:	b8 00 00 00 00       	mov    $0x0,%eax
  804429:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  804430:	00 00 00 
  804433:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  804436:	be 00 00 40 00       	mov    $0x400000,%esi
  80443b:	bf 00 00 00 00       	mov    $0x0,%edi
  804440:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  804447:	00 00 00 
  80444a:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80444c:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  804453:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804456:	48 98                	cltq   
  804458:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80445c:	0f 82 78 fe ff ff    	jb     8042da <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  804462:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804467:	c9                   	leaveq 
  804468:	c3                   	retq   

0000000000804469 <copy_shared_pages>:


// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  804469:	55                   	push   %rbp
  80446a:	48 89 e5             	mov    %rsp,%rbp
  80446d:	48 83 ec 30          	sub    $0x30,%rsp
  804471:	89 7d dc             	mov    %edi,-0x24(%rbp)

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  804474:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80447b:	00 
  80447c:	e9 eb 00 00 00       	jmpq   80456c <copy_shared_pages+0x103>
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
  804481:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804485:	48 c1 f8 12          	sar    $0x12,%rax
  804489:	48 89 c2             	mov    %rax,%rdx
  80448c:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  804493:	01 00 00 
  804496:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80449a:	83 e0 01             	and    $0x1,%eax
  80449d:	48 85 c0             	test   %rax,%rax
  8044a0:	74 21                	je     8044c3 <copy_shared_pages+0x5a>
  8044a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044a6:	48 c1 f8 09          	sar    $0x9,%rax
  8044aa:	48 89 c2             	mov    %rax,%rdx
  8044ad:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8044b4:	01 00 00 
  8044b7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044bb:	83 e0 01             	and    $0x1,%eax
  8044be:	48 85 c0             	test   %rax,%rax
  8044c1:	75 0d                	jne    8044d0 <copy_shared_pages+0x67>
			pn += NPTENTRIES;
  8044c3:	48 81 45 f8 00 02 00 	addq   $0x200,-0x8(%rbp)
  8044ca:	00 
  8044cb:	e9 9c 00 00 00       	jmpq   80456c <copy_shared_pages+0x103>
		else {
			last_pn = pn + NPTENTRIES;
  8044d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044d4:	48 05 00 02 00 00    	add    $0x200,%rax
  8044da:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
			for (; pn < last_pn; pn++)
  8044de:	eb 7e                	jmp    80455e <copy_shared_pages+0xf5>
				if ((uvpt[pn] & (PTE_P | PTE_SHARE)) == (PTE_P | PTE_SHARE)) {
  8044e0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8044e7:	01 00 00 
  8044ea:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8044ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044f2:	25 01 04 00 00       	and    $0x401,%eax
  8044f7:	48 3d 01 04 00 00    	cmp    $0x401,%rax
  8044fd:	75 5a                	jne    804559 <copy_shared_pages+0xf0>
					va = (void*) (pn << PGSHIFT);
  8044ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804503:	48 c1 e0 0c          	shl    $0xc,%rax
  804507:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
					if ((r = sys_page_map(0, va, child, va, uvpt[pn] & PTE_SYSCALL)) < 0)
  80450b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804512:	01 00 00 
  804515:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804519:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80451d:	25 07 0e 00 00       	and    $0xe07,%eax
  804522:	89 c6                	mov    %eax,%esi
  804524:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804528:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80452b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80452f:	41 89 f0             	mov    %esi,%r8d
  804532:	48 89 c6             	mov    %rax,%rsi
  804535:	bf 00 00 00 00       	mov    $0x0,%edi
  80453a:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  804541:	00 00 00 
  804544:	ff d0                	callq  *%rax
  804546:	48 98                	cltq   
  804548:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80454c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804551:	79 06                	jns    804559 <copy_shared_pages+0xf0>
						return r;
  804553:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804557:	eb 28                	jmp    804581 <copy_shared_pages+0x118>
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
			pn += NPTENTRIES;
		else {
			last_pn = pn + NPTENTRIES;
			for (; pn < last_pn; pn++)
  804559:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80455e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804562:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  804566:	0f 8c 74 ff ff ff    	jl     8044e0 <copy_shared_pages+0x77>
{

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  80456c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804570:	48 3d ff 07 00 08    	cmp    $0x80007ff,%rax
  804576:	0f 86 05 ff ff ff    	jbe    804481 <copy_shared_pages+0x18>
						return r;
				}
		}
	}

	return 0;
  80457c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804581:	c9                   	leaveq 
  804582:	c3                   	retq   

0000000000804583 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  804583:	55                   	push   %rbp
  804584:	48 89 e5             	mov    %rsp,%rbp
  804587:	48 83 ec 20          	sub    $0x20,%rsp
  80458b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80458e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804592:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804595:	48 89 d6             	mov    %rdx,%rsi
  804598:	89 c7                	mov    %eax,%edi
  80459a:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  8045a1:	00 00 00 
  8045a4:	ff d0                	callq  *%rax
  8045a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045ad:	79 05                	jns    8045b4 <fd2sockid+0x31>
		return r;
  8045af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045b2:	eb 24                	jmp    8045d8 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8045b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045b8:	8b 10                	mov    (%rax),%edx
  8045ba:	48 b8 c0 80 80 00 00 	movabs $0x8080c0,%rax
  8045c1:	00 00 00 
  8045c4:	8b 00                	mov    (%rax),%eax
  8045c6:	39 c2                	cmp    %eax,%edx
  8045c8:	74 07                	je     8045d1 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8045ca:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8045cf:	eb 07                	jmp    8045d8 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8045d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045d5:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8045d8:	c9                   	leaveq 
  8045d9:	c3                   	retq   

00000000008045da <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8045da:	55                   	push   %rbp
  8045db:	48 89 e5             	mov    %rsp,%rbp
  8045de:	48 83 ec 20          	sub    $0x20,%rsp
  8045e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8045e5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8045e9:	48 89 c7             	mov    %rax,%rdi
  8045ec:	48 b8 3c 2a 80 00 00 	movabs $0x802a3c,%rax
  8045f3:	00 00 00 
  8045f6:	ff d0                	callq  *%rax
  8045f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045ff:	78 26                	js     804627 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  804601:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804605:	ba 07 04 00 00       	mov    $0x407,%edx
  80460a:	48 89 c6             	mov    %rax,%rsi
  80460d:	bf 00 00 00 00       	mov    $0x0,%edi
  804612:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  804619:	00 00 00 
  80461c:	ff d0                	callq  *%rax
  80461e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804621:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804625:	79 16                	jns    80463d <alloc_sockfd+0x63>
		nsipc_close(sockid);
  804627:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80462a:	89 c7                	mov    %eax,%edi
  80462c:	48 b8 e7 4a 80 00 00 	movabs $0x804ae7,%rax
  804633:	00 00 00 
  804636:	ff d0                	callq  *%rax
		return r;
  804638:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80463b:	eb 3a                	jmp    804677 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80463d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804641:	48 ba c0 80 80 00 00 	movabs $0x8080c0,%rdx
  804648:	00 00 00 
  80464b:	8b 12                	mov    (%rdx),%edx
  80464d:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80464f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804653:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80465a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80465e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804661:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  804664:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804668:	48 89 c7             	mov    %rax,%rdi
  80466b:	48 b8 ee 29 80 00 00 	movabs $0x8029ee,%rax
  804672:	00 00 00 
  804675:	ff d0                	callq  *%rax
}
  804677:	c9                   	leaveq 
  804678:	c3                   	retq   

0000000000804679 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804679:	55                   	push   %rbp
  80467a:	48 89 e5             	mov    %rsp,%rbp
  80467d:	48 83 ec 30          	sub    $0x30,%rsp
  804681:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804684:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804688:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80468c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80468f:	89 c7                	mov    %eax,%edi
  804691:	48 b8 83 45 80 00 00 	movabs $0x804583,%rax
  804698:	00 00 00 
  80469b:	ff d0                	callq  *%rax
  80469d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046a4:	79 05                	jns    8046ab <accept+0x32>
		return r;
  8046a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046a9:	eb 3b                	jmp    8046e6 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8046ab:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8046af:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8046b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046b6:	48 89 ce             	mov    %rcx,%rsi
  8046b9:	89 c7                	mov    %eax,%edi
  8046bb:	48 b8 c4 49 80 00 00 	movabs $0x8049c4,%rax
  8046c2:	00 00 00 
  8046c5:	ff d0                	callq  *%rax
  8046c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046ce:	79 05                	jns    8046d5 <accept+0x5c>
		return r;
  8046d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046d3:	eb 11                	jmp    8046e6 <accept+0x6d>
	return alloc_sockfd(r);
  8046d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046d8:	89 c7                	mov    %eax,%edi
  8046da:	48 b8 da 45 80 00 00 	movabs $0x8045da,%rax
  8046e1:	00 00 00 
  8046e4:	ff d0                	callq  *%rax
}
  8046e6:	c9                   	leaveq 
  8046e7:	c3                   	retq   

00000000008046e8 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8046e8:	55                   	push   %rbp
  8046e9:	48 89 e5             	mov    %rsp,%rbp
  8046ec:	48 83 ec 20          	sub    $0x20,%rsp
  8046f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8046f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8046f7:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8046fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8046fd:	89 c7                	mov    %eax,%edi
  8046ff:	48 b8 83 45 80 00 00 	movabs $0x804583,%rax
  804706:	00 00 00 
  804709:	ff d0                	callq  *%rax
  80470b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80470e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804712:	79 05                	jns    804719 <bind+0x31>
		return r;
  804714:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804717:	eb 1b                	jmp    804734 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  804719:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80471c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804720:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804723:	48 89 ce             	mov    %rcx,%rsi
  804726:	89 c7                	mov    %eax,%edi
  804728:	48 b8 43 4a 80 00 00 	movabs $0x804a43,%rax
  80472f:	00 00 00 
  804732:	ff d0                	callq  *%rax
}
  804734:	c9                   	leaveq 
  804735:	c3                   	retq   

0000000000804736 <shutdown>:

int
shutdown(int s, int how)
{
  804736:	55                   	push   %rbp
  804737:	48 89 e5             	mov    %rsp,%rbp
  80473a:	48 83 ec 20          	sub    $0x20,%rsp
  80473e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804741:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804744:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804747:	89 c7                	mov    %eax,%edi
  804749:	48 b8 83 45 80 00 00 	movabs $0x804583,%rax
  804750:	00 00 00 
  804753:	ff d0                	callq  *%rax
  804755:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804758:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80475c:	79 05                	jns    804763 <shutdown+0x2d>
		return r;
  80475e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804761:	eb 16                	jmp    804779 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  804763:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804766:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804769:	89 d6                	mov    %edx,%esi
  80476b:	89 c7                	mov    %eax,%edi
  80476d:	48 b8 a7 4a 80 00 00 	movabs $0x804aa7,%rax
  804774:	00 00 00 
  804777:	ff d0                	callq  *%rax
}
  804779:	c9                   	leaveq 
  80477a:	c3                   	retq   

000000000080477b <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80477b:	55                   	push   %rbp
  80477c:	48 89 e5             	mov    %rsp,%rbp
  80477f:	48 83 ec 10          	sub    $0x10,%rsp
  804783:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  804787:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80478b:	48 89 c7             	mov    %rax,%rdi
  80478e:	48 b8 54 58 80 00 00 	movabs $0x805854,%rax
  804795:	00 00 00 
  804798:	ff d0                	callq  *%rax
  80479a:	83 f8 01             	cmp    $0x1,%eax
  80479d:	75 17                	jne    8047b6 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80479f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047a3:	8b 40 0c             	mov    0xc(%rax),%eax
  8047a6:	89 c7                	mov    %eax,%edi
  8047a8:	48 b8 e7 4a 80 00 00 	movabs $0x804ae7,%rax
  8047af:	00 00 00 
  8047b2:	ff d0                	callq  *%rax
  8047b4:	eb 05                	jmp    8047bb <devsock_close+0x40>
	else
		return 0;
  8047b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8047bb:	c9                   	leaveq 
  8047bc:	c3                   	retq   

00000000008047bd <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8047bd:	55                   	push   %rbp
  8047be:	48 89 e5             	mov    %rsp,%rbp
  8047c1:	48 83 ec 20          	sub    $0x20,%rsp
  8047c5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8047c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8047cc:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8047cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8047d2:	89 c7                	mov    %eax,%edi
  8047d4:	48 b8 83 45 80 00 00 	movabs $0x804583,%rax
  8047db:	00 00 00 
  8047de:	ff d0                	callq  *%rax
  8047e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047e7:	79 05                	jns    8047ee <connect+0x31>
		return r;
  8047e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047ec:	eb 1b                	jmp    804809 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8047ee:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8047f1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8047f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047f8:	48 89 ce             	mov    %rcx,%rsi
  8047fb:	89 c7                	mov    %eax,%edi
  8047fd:	48 b8 14 4b 80 00 00 	movabs $0x804b14,%rax
  804804:	00 00 00 
  804807:	ff d0                	callq  *%rax
}
  804809:	c9                   	leaveq 
  80480a:	c3                   	retq   

000000000080480b <listen>:

int
listen(int s, int backlog)
{
  80480b:	55                   	push   %rbp
  80480c:	48 89 e5             	mov    %rsp,%rbp
  80480f:	48 83 ec 20          	sub    $0x20,%rsp
  804813:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804816:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804819:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80481c:	89 c7                	mov    %eax,%edi
  80481e:	48 b8 83 45 80 00 00 	movabs $0x804583,%rax
  804825:	00 00 00 
  804828:	ff d0                	callq  *%rax
  80482a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80482d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804831:	79 05                	jns    804838 <listen+0x2d>
		return r;
  804833:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804836:	eb 16                	jmp    80484e <listen+0x43>
	return nsipc_listen(r, backlog);
  804838:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80483b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80483e:	89 d6                	mov    %edx,%esi
  804840:	89 c7                	mov    %eax,%edi
  804842:	48 b8 78 4b 80 00 00 	movabs $0x804b78,%rax
  804849:	00 00 00 
  80484c:	ff d0                	callq  *%rax
}
  80484e:	c9                   	leaveq 
  80484f:	c3                   	retq   

0000000000804850 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  804850:	55                   	push   %rbp
  804851:	48 89 e5             	mov    %rsp,%rbp
  804854:	48 83 ec 20          	sub    $0x20,%rsp
  804858:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80485c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804860:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  804864:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804868:	89 c2                	mov    %eax,%edx
  80486a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80486e:	8b 40 0c             	mov    0xc(%rax),%eax
  804871:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  804875:	b9 00 00 00 00       	mov    $0x0,%ecx
  80487a:	89 c7                	mov    %eax,%edi
  80487c:	48 b8 b8 4b 80 00 00 	movabs $0x804bb8,%rax
  804883:	00 00 00 
  804886:	ff d0                	callq  *%rax
}
  804888:	c9                   	leaveq 
  804889:	c3                   	retq   

000000000080488a <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80488a:	55                   	push   %rbp
  80488b:	48 89 e5             	mov    %rsp,%rbp
  80488e:	48 83 ec 20          	sub    $0x20,%rsp
  804892:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804896:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80489a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80489e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048a2:	89 c2                	mov    %eax,%edx
  8048a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048a8:	8b 40 0c             	mov    0xc(%rax),%eax
  8048ab:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8048af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8048b4:	89 c7                	mov    %eax,%edi
  8048b6:	48 b8 84 4c 80 00 00 	movabs $0x804c84,%rax
  8048bd:	00 00 00 
  8048c0:	ff d0                	callq  *%rax
}
  8048c2:	c9                   	leaveq 
  8048c3:	c3                   	retq   

00000000008048c4 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8048c4:	55                   	push   %rbp
  8048c5:	48 89 e5             	mov    %rsp,%rbp
  8048c8:	48 83 ec 10          	sub    $0x10,%rsp
  8048cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8048d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8048d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048d8:	48 be 55 62 80 00 00 	movabs $0x806255,%rsi
  8048df:	00 00 00 
  8048e2:	48 89 c7             	mov    %rax,%rdi
  8048e5:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  8048ec:	00 00 00 
  8048ef:	ff d0                	callq  *%rax
	return 0;
  8048f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8048f6:	c9                   	leaveq 
  8048f7:	c3                   	retq   

00000000008048f8 <socket>:

int
socket(int domain, int type, int protocol)
{
  8048f8:	55                   	push   %rbp
  8048f9:	48 89 e5             	mov    %rsp,%rbp
  8048fc:	48 83 ec 20          	sub    $0x20,%rsp
  804900:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804903:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804906:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  804909:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80490c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80490f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804912:	89 ce                	mov    %ecx,%esi
  804914:	89 c7                	mov    %eax,%edi
  804916:	48 b8 3c 4d 80 00 00 	movabs $0x804d3c,%rax
  80491d:	00 00 00 
  804920:	ff d0                	callq  *%rax
  804922:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804925:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804929:	79 05                	jns    804930 <socket+0x38>
		return r;
  80492b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80492e:	eb 11                	jmp    804941 <socket+0x49>
	return alloc_sockfd(r);
  804930:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804933:	89 c7                	mov    %eax,%edi
  804935:	48 b8 da 45 80 00 00 	movabs $0x8045da,%rax
  80493c:	00 00 00 
  80493f:	ff d0                	callq  *%rax
}
  804941:	c9                   	leaveq 
  804942:	c3                   	retq   

0000000000804943 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  804943:	55                   	push   %rbp
  804944:	48 89 e5             	mov    %rsp,%rbp
  804947:	48 83 ec 10          	sub    $0x10,%rsp
  80494b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80494e:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  804955:	00 00 00 
  804958:	8b 00                	mov    (%rax),%eax
  80495a:	85 c0                	test   %eax,%eax
  80495c:	75 1d                	jne    80497b <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80495e:	bf 02 00 00 00       	mov    $0x2,%edi
  804963:	48 b8 e2 57 80 00 00 	movabs $0x8057e2,%rax
  80496a:	00 00 00 
  80496d:	ff d0                	callq  *%rax
  80496f:	48 ba 04 90 80 00 00 	movabs $0x809004,%rdx
  804976:	00 00 00 
  804979:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80497b:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  804982:	00 00 00 
  804985:	8b 00                	mov    (%rax),%eax
  804987:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80498a:	b9 07 00 00 00       	mov    $0x7,%ecx
  80498f:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  804996:	00 00 00 
  804999:	89 c7                	mov    %eax,%edi
  80499b:	48 b8 d6 55 80 00 00 	movabs $0x8055d6,%rax
  8049a2:	00 00 00 
  8049a5:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8049a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8049ac:	be 00 00 00 00       	mov    $0x0,%esi
  8049b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8049b6:	48 b8 15 55 80 00 00 	movabs $0x805515,%rax
  8049bd:	00 00 00 
  8049c0:	ff d0                	callq  *%rax
}
  8049c2:	c9                   	leaveq 
  8049c3:	c3                   	retq   

00000000008049c4 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8049c4:	55                   	push   %rbp
  8049c5:	48 89 e5             	mov    %rsp,%rbp
  8049c8:	48 83 ec 30          	sub    $0x30,%rsp
  8049cc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8049cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8049d3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8049d7:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8049de:	00 00 00 
  8049e1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8049e4:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8049e6:	bf 01 00 00 00       	mov    $0x1,%edi
  8049eb:	48 b8 43 49 80 00 00 	movabs $0x804943,%rax
  8049f2:	00 00 00 
  8049f5:	ff d0                	callq  *%rax
  8049f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049fe:	78 3e                	js     804a3e <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  804a00:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804a07:	00 00 00 
  804a0a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  804a0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a12:	8b 40 10             	mov    0x10(%rax),%eax
  804a15:	89 c2                	mov    %eax,%edx
  804a17:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  804a1b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a1f:	48 89 ce             	mov    %rcx,%rsi
  804a22:	48 89 c7             	mov    %rax,%rdi
  804a25:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  804a2c:	00 00 00 
  804a2f:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  804a31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a35:	8b 50 10             	mov    0x10(%rax),%edx
  804a38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a3c:	89 10                	mov    %edx,(%rax)
	}
	return r;
  804a3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804a41:	c9                   	leaveq 
  804a42:	c3                   	retq   

0000000000804a43 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  804a43:	55                   	push   %rbp
  804a44:	48 89 e5             	mov    %rsp,%rbp
  804a47:	48 83 ec 10          	sub    $0x10,%rsp
  804a4b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804a4e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804a52:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  804a55:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804a5c:	00 00 00 
  804a5f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804a62:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  804a64:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804a67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a6b:	48 89 c6             	mov    %rax,%rsi
  804a6e:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  804a75:	00 00 00 
  804a78:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  804a7f:	00 00 00 
  804a82:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  804a84:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804a8b:	00 00 00 
  804a8e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804a91:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  804a94:	bf 02 00 00 00       	mov    $0x2,%edi
  804a99:	48 b8 43 49 80 00 00 	movabs $0x804943,%rax
  804aa0:	00 00 00 
  804aa3:	ff d0                	callq  *%rax
}
  804aa5:	c9                   	leaveq 
  804aa6:	c3                   	retq   

0000000000804aa7 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  804aa7:	55                   	push   %rbp
  804aa8:	48 89 e5             	mov    %rsp,%rbp
  804aab:	48 83 ec 10          	sub    $0x10,%rsp
  804aaf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804ab2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  804ab5:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804abc:	00 00 00 
  804abf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804ac2:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  804ac4:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804acb:	00 00 00 
  804ace:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804ad1:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  804ad4:	bf 03 00 00 00       	mov    $0x3,%edi
  804ad9:	48 b8 43 49 80 00 00 	movabs $0x804943,%rax
  804ae0:	00 00 00 
  804ae3:	ff d0                	callq  *%rax
}
  804ae5:	c9                   	leaveq 
  804ae6:	c3                   	retq   

0000000000804ae7 <nsipc_close>:

int
nsipc_close(int s)
{
  804ae7:	55                   	push   %rbp
  804ae8:	48 89 e5             	mov    %rsp,%rbp
  804aeb:	48 83 ec 10          	sub    $0x10,%rsp
  804aef:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  804af2:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804af9:	00 00 00 
  804afc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804aff:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  804b01:	bf 04 00 00 00       	mov    $0x4,%edi
  804b06:	48 b8 43 49 80 00 00 	movabs $0x804943,%rax
  804b0d:	00 00 00 
  804b10:	ff d0                	callq  *%rax
}
  804b12:	c9                   	leaveq 
  804b13:	c3                   	retq   

0000000000804b14 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804b14:	55                   	push   %rbp
  804b15:	48 89 e5             	mov    %rsp,%rbp
  804b18:	48 83 ec 10          	sub    $0x10,%rsp
  804b1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804b1f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804b23:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  804b26:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b2d:	00 00 00 
  804b30:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804b33:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  804b35:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804b38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b3c:	48 89 c6             	mov    %rax,%rsi
  804b3f:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  804b46:	00 00 00 
  804b49:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  804b50:	00 00 00 
  804b53:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  804b55:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b5c:	00 00 00 
  804b5f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804b62:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  804b65:	bf 05 00 00 00       	mov    $0x5,%edi
  804b6a:	48 b8 43 49 80 00 00 	movabs $0x804943,%rax
  804b71:	00 00 00 
  804b74:	ff d0                	callq  *%rax
}
  804b76:	c9                   	leaveq 
  804b77:	c3                   	retq   

0000000000804b78 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  804b78:	55                   	push   %rbp
  804b79:	48 89 e5             	mov    %rsp,%rbp
  804b7c:	48 83 ec 10          	sub    $0x10,%rsp
  804b80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804b83:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  804b86:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b8d:	00 00 00 
  804b90:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804b93:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  804b95:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b9c:	00 00 00 
  804b9f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804ba2:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  804ba5:	bf 06 00 00 00       	mov    $0x6,%edi
  804baa:	48 b8 43 49 80 00 00 	movabs $0x804943,%rax
  804bb1:	00 00 00 
  804bb4:	ff d0                	callq  *%rax
}
  804bb6:	c9                   	leaveq 
  804bb7:	c3                   	retq   

0000000000804bb8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  804bb8:	55                   	push   %rbp
  804bb9:	48 89 e5             	mov    %rsp,%rbp
  804bbc:	48 83 ec 30          	sub    $0x30,%rsp
  804bc0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804bc3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804bc7:	89 55 e8             	mov    %edx,-0x18(%rbp)
  804bca:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  804bcd:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804bd4:	00 00 00 
  804bd7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804bda:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  804bdc:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804be3:	00 00 00 
  804be6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804be9:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804bec:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804bf3:	00 00 00 
  804bf6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804bf9:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804bfc:	bf 07 00 00 00       	mov    $0x7,%edi
  804c01:	48 b8 43 49 80 00 00 	movabs $0x804943,%rax
  804c08:	00 00 00 
  804c0b:	ff d0                	callq  *%rax
  804c0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804c10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804c14:	78 69                	js     804c7f <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  804c16:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  804c1d:	7f 08                	jg     804c27 <nsipc_recv+0x6f>
  804c1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c22:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  804c25:	7e 35                	jle    804c5c <nsipc_recv+0xa4>
  804c27:	48 b9 5c 62 80 00 00 	movabs $0x80625c,%rcx
  804c2e:	00 00 00 
  804c31:	48 ba 71 62 80 00 00 	movabs $0x806271,%rdx
  804c38:	00 00 00 
  804c3b:	be 62 00 00 00       	mov    $0x62,%esi
  804c40:	48 bf 86 62 80 00 00 	movabs $0x806286,%rdi
  804c47:	00 00 00 
  804c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  804c4f:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  804c56:	00 00 00 
  804c59:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804c5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c5f:	48 63 d0             	movslq %eax,%rdx
  804c62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804c66:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  804c6d:	00 00 00 
  804c70:	48 89 c7             	mov    %rax,%rdi
  804c73:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  804c7a:	00 00 00 
  804c7d:	ff d0                	callq  *%rax
	}

	return r;
  804c7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804c82:	c9                   	leaveq 
  804c83:	c3                   	retq   

0000000000804c84 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804c84:	55                   	push   %rbp
  804c85:	48 89 e5             	mov    %rsp,%rbp
  804c88:	48 83 ec 20          	sub    $0x20,%rsp
  804c8c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804c8f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804c93:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804c96:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  804c99:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804ca0:	00 00 00 
  804ca3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804ca6:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  804ca8:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  804caf:	7e 35                	jle    804ce6 <nsipc_send+0x62>
  804cb1:	48 b9 92 62 80 00 00 	movabs $0x806292,%rcx
  804cb8:	00 00 00 
  804cbb:	48 ba 71 62 80 00 00 	movabs $0x806271,%rdx
  804cc2:	00 00 00 
  804cc5:	be 6d 00 00 00       	mov    $0x6d,%esi
  804cca:	48 bf 86 62 80 00 00 	movabs $0x806286,%rdi
  804cd1:	00 00 00 
  804cd4:	b8 00 00 00 00       	mov    $0x0,%eax
  804cd9:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  804ce0:	00 00 00 
  804ce3:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804ce6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804ce9:	48 63 d0             	movslq %eax,%rdx
  804cec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cf0:	48 89 c6             	mov    %rax,%rsi
  804cf3:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  804cfa:	00 00 00 
  804cfd:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  804d04:	00 00 00 
  804d07:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804d09:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804d10:	00 00 00 
  804d13:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804d16:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804d19:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804d20:	00 00 00 
  804d23:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804d26:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804d29:	bf 08 00 00 00       	mov    $0x8,%edi
  804d2e:	48 b8 43 49 80 00 00 	movabs $0x804943,%rax
  804d35:	00 00 00 
  804d38:	ff d0                	callq  *%rax
}
  804d3a:	c9                   	leaveq 
  804d3b:	c3                   	retq   

0000000000804d3c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804d3c:	55                   	push   %rbp
  804d3d:	48 89 e5             	mov    %rsp,%rbp
  804d40:	48 83 ec 10          	sub    $0x10,%rsp
  804d44:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804d47:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804d4a:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804d4d:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804d54:	00 00 00 
  804d57:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804d5a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804d5c:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804d63:	00 00 00 
  804d66:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804d69:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804d6c:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804d73:	00 00 00 
  804d76:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804d79:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804d7c:	bf 09 00 00 00       	mov    $0x9,%edi
  804d81:	48 b8 43 49 80 00 00 	movabs $0x804943,%rax
  804d88:	00 00 00 
  804d8b:	ff d0                	callq  *%rax
}
  804d8d:	c9                   	leaveq 
  804d8e:	c3                   	retq   

0000000000804d8f <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804d8f:	55                   	push   %rbp
  804d90:	48 89 e5             	mov    %rsp,%rbp
  804d93:	53                   	push   %rbx
  804d94:	48 83 ec 38          	sub    $0x38,%rsp
  804d98:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804d9c:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804da0:	48 89 c7             	mov    %rax,%rdi
  804da3:	48 b8 3c 2a 80 00 00 	movabs $0x802a3c,%rax
  804daa:	00 00 00 
  804dad:	ff d0                	callq  *%rax
  804daf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804db2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804db6:	0f 88 bf 01 00 00    	js     804f7b <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804dbc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804dc0:	ba 07 04 00 00       	mov    $0x407,%edx
  804dc5:	48 89 c6             	mov    %rax,%rsi
  804dc8:	bf 00 00 00 00       	mov    $0x0,%edi
  804dcd:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  804dd4:	00 00 00 
  804dd7:	ff d0                	callq  *%rax
  804dd9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804ddc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804de0:	0f 88 95 01 00 00    	js     804f7b <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804de6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804dea:	48 89 c7             	mov    %rax,%rdi
  804ded:	48 b8 3c 2a 80 00 00 	movabs $0x802a3c,%rax
  804df4:	00 00 00 
  804df7:	ff d0                	callq  *%rax
  804df9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804dfc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804e00:	0f 88 5d 01 00 00    	js     804f63 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804e06:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804e0a:	ba 07 04 00 00       	mov    $0x407,%edx
  804e0f:	48 89 c6             	mov    %rax,%rsi
  804e12:	bf 00 00 00 00       	mov    $0x0,%edi
  804e17:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  804e1e:	00 00 00 
  804e21:	ff d0                	callq  *%rax
  804e23:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804e26:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804e2a:	0f 88 33 01 00 00    	js     804f63 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804e30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804e34:	48 89 c7             	mov    %rax,%rdi
  804e37:	48 b8 11 2a 80 00 00 	movabs $0x802a11,%rax
  804e3e:	00 00 00 
  804e41:	ff d0                	callq  *%rax
  804e43:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804e47:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e4b:	ba 07 04 00 00       	mov    $0x407,%edx
  804e50:	48 89 c6             	mov    %rax,%rsi
  804e53:	bf 00 00 00 00       	mov    $0x0,%edi
  804e58:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  804e5f:	00 00 00 
  804e62:	ff d0                	callq  *%rax
  804e64:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804e67:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804e6b:	79 05                	jns    804e72 <pipe+0xe3>
		goto err2;
  804e6d:	e9 d9 00 00 00       	jmpq   804f4b <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804e72:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804e76:	48 89 c7             	mov    %rax,%rdi
  804e79:	48 b8 11 2a 80 00 00 	movabs $0x802a11,%rax
  804e80:	00 00 00 
  804e83:	ff d0                	callq  *%rax
  804e85:	48 89 c2             	mov    %rax,%rdx
  804e88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e8c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804e92:	48 89 d1             	mov    %rdx,%rcx
  804e95:	ba 00 00 00 00       	mov    $0x0,%edx
  804e9a:	48 89 c6             	mov    %rax,%rsi
  804e9d:	bf 00 00 00 00       	mov    $0x0,%edi
  804ea2:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  804ea9:	00 00 00 
  804eac:	ff d0                	callq  *%rax
  804eae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804eb1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804eb5:	79 1b                	jns    804ed2 <pipe+0x143>
		goto err3;
  804eb7:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804eb8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804ebc:	48 89 c6             	mov    %rax,%rsi
  804ebf:	bf 00 00 00 00       	mov    $0x0,%edi
  804ec4:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  804ecb:	00 00 00 
  804ece:	ff d0                	callq  *%rax
  804ed0:	eb 79                	jmp    804f4b <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804ed2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ed6:	48 ba 00 81 80 00 00 	movabs $0x808100,%rdx
  804edd:	00 00 00 
  804ee0:	8b 12                	mov    (%rdx),%edx
  804ee2:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804ee4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ee8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804eef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804ef3:	48 ba 00 81 80 00 00 	movabs $0x808100,%rdx
  804efa:	00 00 00 
  804efd:	8b 12                	mov    (%rdx),%edx
  804eff:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804f01:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f05:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804f0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804f10:	48 89 c7             	mov    %rax,%rdi
  804f13:	48 b8 ee 29 80 00 00 	movabs $0x8029ee,%rax
  804f1a:	00 00 00 
  804f1d:	ff d0                	callq  *%rax
  804f1f:	89 c2                	mov    %eax,%edx
  804f21:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804f25:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804f27:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804f2b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804f2f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f33:	48 89 c7             	mov    %rax,%rdi
  804f36:	48 b8 ee 29 80 00 00 	movabs $0x8029ee,%rax
  804f3d:	00 00 00 
  804f40:	ff d0                	callq  *%rax
  804f42:	89 03                	mov    %eax,(%rbx)
	return 0;
  804f44:	b8 00 00 00 00       	mov    $0x0,%eax
  804f49:	eb 33                	jmp    804f7e <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804f4b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f4f:	48 89 c6             	mov    %rax,%rsi
  804f52:	bf 00 00 00 00       	mov    $0x0,%edi
  804f57:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  804f5e:	00 00 00 
  804f61:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804f63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804f67:	48 89 c6             	mov    %rax,%rsi
  804f6a:	bf 00 00 00 00       	mov    $0x0,%edi
  804f6f:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  804f76:	00 00 00 
  804f79:	ff d0                	callq  *%rax
err:
	return r;
  804f7b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804f7e:	48 83 c4 38          	add    $0x38,%rsp
  804f82:	5b                   	pop    %rbx
  804f83:	5d                   	pop    %rbp
  804f84:	c3                   	retq   

0000000000804f85 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804f85:	55                   	push   %rbp
  804f86:	48 89 e5             	mov    %rsp,%rbp
  804f89:	53                   	push   %rbx
  804f8a:	48 83 ec 28          	sub    $0x28,%rsp
  804f8e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804f92:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804f96:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804f9d:	00 00 00 
  804fa0:	48 8b 00             	mov    (%rax),%rax
  804fa3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804fa9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804fac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804fb0:	48 89 c7             	mov    %rax,%rdi
  804fb3:	48 b8 54 58 80 00 00 	movabs $0x805854,%rax
  804fba:	00 00 00 
  804fbd:	ff d0                	callq  *%rax
  804fbf:	89 c3                	mov    %eax,%ebx
  804fc1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804fc5:	48 89 c7             	mov    %rax,%rdi
  804fc8:	48 b8 54 58 80 00 00 	movabs $0x805854,%rax
  804fcf:	00 00 00 
  804fd2:	ff d0                	callq  *%rax
  804fd4:	39 c3                	cmp    %eax,%ebx
  804fd6:	0f 94 c0             	sete   %al
  804fd9:	0f b6 c0             	movzbl %al,%eax
  804fdc:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804fdf:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804fe6:	00 00 00 
  804fe9:	48 8b 00             	mov    (%rax),%rax
  804fec:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804ff2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804ff5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804ff8:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804ffb:	75 05                	jne    805002 <_pipeisclosed+0x7d>
			return ret;
  804ffd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  805000:	eb 4f                	jmp    805051 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  805002:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805005:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  805008:	74 42                	je     80504c <_pipeisclosed+0xc7>
  80500a:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80500e:	75 3c                	jne    80504c <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  805010:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  805017:	00 00 00 
  80501a:	48 8b 00             	mov    (%rax),%rax
  80501d:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  805023:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  805026:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805029:	89 c6                	mov    %eax,%esi
  80502b:	48 bf a3 62 80 00 00 	movabs $0x8062a3,%rdi
  805032:	00 00 00 
  805035:	b8 00 00 00 00       	mov    $0x0,%eax
  80503a:	49 b8 15 0b 80 00 00 	movabs $0x800b15,%r8
  805041:	00 00 00 
  805044:	41 ff d0             	callq  *%r8
	}
  805047:	e9 4a ff ff ff       	jmpq   804f96 <_pipeisclosed+0x11>
  80504c:	e9 45 ff ff ff       	jmpq   804f96 <_pipeisclosed+0x11>

}
  805051:	48 83 c4 28          	add    $0x28,%rsp
  805055:	5b                   	pop    %rbx
  805056:	5d                   	pop    %rbp
  805057:	c3                   	retq   

0000000000805058 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  805058:	55                   	push   %rbp
  805059:	48 89 e5             	mov    %rsp,%rbp
  80505c:	48 83 ec 30          	sub    $0x30,%rsp
  805060:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  805063:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805067:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80506a:	48 89 d6             	mov    %rdx,%rsi
  80506d:	89 c7                	mov    %eax,%edi
  80506f:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  805076:	00 00 00 
  805079:	ff d0                	callq  *%rax
  80507b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80507e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805082:	79 05                	jns    805089 <pipeisclosed+0x31>
		return r;
  805084:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805087:	eb 31                	jmp    8050ba <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  805089:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80508d:	48 89 c7             	mov    %rax,%rdi
  805090:	48 b8 11 2a 80 00 00 	movabs $0x802a11,%rax
  805097:	00 00 00 
  80509a:	ff d0                	callq  *%rax
  80509c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8050a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8050a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8050a8:	48 89 d6             	mov    %rdx,%rsi
  8050ab:	48 89 c7             	mov    %rax,%rdi
  8050ae:	48 b8 85 4f 80 00 00 	movabs $0x804f85,%rax
  8050b5:	00 00 00 
  8050b8:	ff d0                	callq  *%rax
}
  8050ba:	c9                   	leaveq 
  8050bb:	c3                   	retq   

00000000008050bc <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8050bc:	55                   	push   %rbp
  8050bd:	48 89 e5             	mov    %rsp,%rbp
  8050c0:	48 83 ec 40          	sub    $0x40,%rsp
  8050c4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8050c8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8050cc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8050d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8050d4:	48 89 c7             	mov    %rax,%rdi
  8050d7:	48 b8 11 2a 80 00 00 	movabs $0x802a11,%rax
  8050de:	00 00 00 
  8050e1:	ff d0                	callq  *%rax
  8050e3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8050e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8050eb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8050ef:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8050f6:	00 
  8050f7:	e9 92 00 00 00       	jmpq   80518e <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8050fc:	eb 41                	jmp    80513f <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8050fe:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  805103:	74 09                	je     80510e <devpipe_read+0x52>
				return i;
  805105:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805109:	e9 92 00 00 00       	jmpq   8051a0 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80510e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805112:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805116:	48 89 d6             	mov    %rdx,%rsi
  805119:	48 89 c7             	mov    %rax,%rdi
  80511c:	48 b8 85 4f 80 00 00 	movabs $0x804f85,%rax
  805123:	00 00 00 
  805126:	ff d0                	callq  *%rax
  805128:	85 c0                	test   %eax,%eax
  80512a:	74 07                	je     805133 <devpipe_read+0x77>
				return 0;
  80512c:	b8 00 00 00 00       	mov    $0x0,%eax
  805131:	eb 6d                	jmp    8051a0 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  805133:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  80513a:	00 00 00 
  80513d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80513f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805143:	8b 10                	mov    (%rax),%edx
  805145:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805149:	8b 40 04             	mov    0x4(%rax),%eax
  80514c:	39 c2                	cmp    %eax,%edx
  80514e:	74 ae                	je     8050fe <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  805150:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805154:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805158:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80515c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805160:	8b 00                	mov    (%rax),%eax
  805162:	99                   	cltd   
  805163:	c1 ea 1b             	shr    $0x1b,%edx
  805166:	01 d0                	add    %edx,%eax
  805168:	83 e0 1f             	and    $0x1f,%eax
  80516b:	29 d0                	sub    %edx,%eax
  80516d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805171:	48 98                	cltq   
  805173:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  805178:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80517a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80517e:	8b 00                	mov    (%rax),%eax
  805180:	8d 50 01             	lea    0x1(%rax),%edx
  805183:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805187:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  805189:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80518e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805192:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  805196:	0f 82 60 ff ff ff    	jb     8050fc <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80519c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8051a0:	c9                   	leaveq 
  8051a1:	c3                   	retq   

00000000008051a2 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8051a2:	55                   	push   %rbp
  8051a3:	48 89 e5             	mov    %rsp,%rbp
  8051a6:	48 83 ec 40          	sub    $0x40,%rsp
  8051aa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8051ae:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8051b2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8051b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8051ba:	48 89 c7             	mov    %rax,%rdi
  8051bd:	48 b8 11 2a 80 00 00 	movabs $0x802a11,%rax
  8051c4:	00 00 00 
  8051c7:	ff d0                	callq  *%rax
  8051c9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8051cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8051d1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8051d5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8051dc:	00 
  8051dd:	e9 8e 00 00 00       	jmpq   805270 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8051e2:	eb 31                	jmp    805215 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8051e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8051e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8051ec:	48 89 d6             	mov    %rdx,%rsi
  8051ef:	48 89 c7             	mov    %rax,%rdi
  8051f2:	48 b8 85 4f 80 00 00 	movabs $0x804f85,%rax
  8051f9:	00 00 00 
  8051fc:	ff d0                	callq  *%rax
  8051fe:	85 c0                	test   %eax,%eax
  805200:	74 07                	je     805209 <devpipe_write+0x67>
				return 0;
  805202:	b8 00 00 00 00       	mov    $0x0,%eax
  805207:	eb 79                	jmp    805282 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  805209:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  805210:	00 00 00 
  805213:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  805215:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805219:	8b 40 04             	mov    0x4(%rax),%eax
  80521c:	48 63 d0             	movslq %eax,%rdx
  80521f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805223:	8b 00                	mov    (%rax),%eax
  805225:	48 98                	cltq   
  805227:	48 83 c0 20          	add    $0x20,%rax
  80522b:	48 39 c2             	cmp    %rax,%rdx
  80522e:	73 b4                	jae    8051e4 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  805230:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805234:	8b 40 04             	mov    0x4(%rax),%eax
  805237:	99                   	cltd   
  805238:	c1 ea 1b             	shr    $0x1b,%edx
  80523b:	01 d0                	add    %edx,%eax
  80523d:	83 e0 1f             	and    $0x1f,%eax
  805240:	29 d0                	sub    %edx,%eax
  805242:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805246:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80524a:	48 01 ca             	add    %rcx,%rdx
  80524d:	0f b6 0a             	movzbl (%rdx),%ecx
  805250:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805254:	48 98                	cltq   
  805256:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80525a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80525e:	8b 40 04             	mov    0x4(%rax),%eax
  805261:	8d 50 01             	lea    0x1(%rax),%edx
  805264:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805268:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80526b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805270:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805274:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  805278:	0f 82 64 ff ff ff    	jb     8051e2 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80527e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  805282:	c9                   	leaveq 
  805283:	c3                   	retq   

0000000000805284 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  805284:	55                   	push   %rbp
  805285:	48 89 e5             	mov    %rsp,%rbp
  805288:	48 83 ec 20          	sub    $0x20,%rsp
  80528c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805290:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  805294:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805298:	48 89 c7             	mov    %rax,%rdi
  80529b:	48 b8 11 2a 80 00 00 	movabs $0x802a11,%rax
  8052a2:	00 00 00 
  8052a5:	ff d0                	callq  *%rax
  8052a7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8052ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8052af:	48 be b6 62 80 00 00 	movabs $0x8062b6,%rsi
  8052b6:	00 00 00 
  8052b9:	48 89 c7             	mov    %rax,%rdi
  8052bc:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  8052c3:	00 00 00 
  8052c6:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8052c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8052cc:	8b 50 04             	mov    0x4(%rax),%edx
  8052cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8052d3:	8b 00                	mov    (%rax),%eax
  8052d5:	29 c2                	sub    %eax,%edx
  8052d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8052db:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8052e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8052e5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8052ec:	00 00 00 
	stat->st_dev = &devpipe;
  8052ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8052f3:	48 b9 00 81 80 00 00 	movabs $0x808100,%rcx
  8052fa:	00 00 00 
  8052fd:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  805304:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805309:	c9                   	leaveq 
  80530a:	c3                   	retq   

000000000080530b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80530b:	55                   	push   %rbp
  80530c:	48 89 e5             	mov    %rsp,%rbp
  80530f:	48 83 ec 10          	sub    $0x10,%rsp
  805313:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  805317:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80531b:	48 89 c6             	mov    %rax,%rsi
  80531e:	bf 00 00 00 00       	mov    $0x0,%edi
  805323:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  80532a:	00 00 00 
  80532d:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  80532f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805333:	48 89 c7             	mov    %rax,%rdi
  805336:	48 b8 11 2a 80 00 00 	movabs $0x802a11,%rax
  80533d:	00 00 00 
  805340:	ff d0                	callq  *%rax
  805342:	48 89 c6             	mov    %rax,%rsi
  805345:	bf 00 00 00 00       	mov    $0x0,%edi
  80534a:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  805351:	00 00 00 
  805354:	ff d0                	callq  *%rax
}
  805356:	c9                   	leaveq 
  805357:	c3                   	retq   

0000000000805358 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  805358:	55                   	push   %rbp
  805359:	48 89 e5             	mov    %rsp,%rbp
  80535c:	48 83 ec 20          	sub    $0x20,%rsp
  805360:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  805363:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805367:	75 35                	jne    80539e <wait+0x46>
  805369:	48 b9 bd 62 80 00 00 	movabs $0x8062bd,%rcx
  805370:	00 00 00 
  805373:	48 ba c8 62 80 00 00 	movabs $0x8062c8,%rdx
  80537a:	00 00 00 
  80537d:	be 0a 00 00 00       	mov    $0xa,%esi
  805382:	48 bf dd 62 80 00 00 	movabs $0x8062dd,%rdi
  805389:	00 00 00 
  80538c:	b8 00 00 00 00       	mov    $0x0,%eax
  805391:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  805398:	00 00 00 
  80539b:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  80539e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8053a1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8053a6:	48 98                	cltq   
  8053a8:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8053af:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8053b6:	00 00 00 
  8053b9:	48 01 d0             	add    %rdx,%rax
  8053bc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8053c0:	eb 0c                	jmp    8053ce <wait+0x76>
		sys_yield();
  8053c2:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  8053c9:	00 00 00 
  8053cc:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8053ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8053d2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8053d8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8053db:	75 0e                	jne    8053eb <wait+0x93>
  8053dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8053e1:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8053e7:	85 c0                	test   %eax,%eax
  8053e9:	75 d7                	jne    8053c2 <wait+0x6a>
		sys_yield();
}
  8053eb:	c9                   	leaveq 
  8053ec:	c3                   	retq   

00000000008053ed <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8053ed:	55                   	push   %rbp
  8053ee:	48 89 e5             	mov    %rsp,%rbp
  8053f1:	48 83 ec 20          	sub    $0x20,%rsp
  8053f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8053f9:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805400:	00 00 00 
  805403:	48 8b 00             	mov    (%rax),%rax
  805406:	48 85 c0             	test   %rax,%rax
  805409:	75 6f                	jne    80547a <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80540b:	ba 07 00 00 00       	mov    $0x7,%edx
  805410:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  805415:	bf 00 00 00 00       	mov    $0x0,%edi
  80541a:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  805421:	00 00 00 
  805424:	ff d0                	callq  *%rax
  805426:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805429:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80542d:	79 30                	jns    80545f <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  80542f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805432:	89 c1                	mov    %eax,%ecx
  805434:	48 ba e8 62 80 00 00 	movabs $0x8062e8,%rdx
  80543b:	00 00 00 
  80543e:	be 22 00 00 00       	mov    $0x22,%esi
  805443:	48 bf 07 63 80 00 00 	movabs $0x806307,%rdi
  80544a:	00 00 00 
  80544d:	b8 00 00 00 00       	mov    $0x0,%eax
  805452:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  805459:	00 00 00 
  80545c:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  80545f:	48 be 8d 54 80 00 00 	movabs $0x80548d,%rsi
  805466:	00 00 00 
  805469:	bf 00 00 00 00       	mov    $0x0,%edi
  80546e:	48 b8 83 21 80 00 00 	movabs $0x802183,%rax
  805475:	00 00 00 
  805478:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80547a:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805481:	00 00 00 
  805484:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805488:	48 89 10             	mov    %rdx,(%rax)
}
  80548b:	c9                   	leaveq 
  80548c:	c3                   	retq   

000000000080548d <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80548d:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  805490:	48 a1 00 d0 80 00 00 	movabs 0x80d000,%rax
  805497:	00 00 00 
call *%rax
  80549a:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  80549c:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  8054a3:	00 08 
    movq 152(%rsp), %rax
  8054a5:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  8054ac:	00 
    movq 136(%rsp), %rbx
  8054ad:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8054b4:	00 
movq %rbx, (%rax)
  8054b5:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  8054b8:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  8054bc:	4c 8b 3c 24          	mov    (%rsp),%r15
  8054c0:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8054c5:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8054ca:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8054cf:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8054d4:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8054d9:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8054de:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8054e3:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8054e8:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8054ed:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8054f2:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8054f7:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8054fc:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  805501:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  805506:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  80550a:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  80550e:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  80550f:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  805514:	c3                   	retq   

0000000000805515 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  805515:	55                   	push   %rbp
  805516:	48 89 e5             	mov    %rsp,%rbp
  805519:	48 83 ec 30          	sub    $0x30,%rsp
  80551d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805521:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805525:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  805529:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80552e:	75 0e                	jne    80553e <ipc_recv+0x29>
		pg = (void*) UTOP;
  805530:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805537:	00 00 00 
  80553a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  80553e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805542:	48 89 c7             	mov    %rax,%rdi
  805545:	48 b8 22 22 80 00 00 	movabs $0x802222,%rax
  80554c:	00 00 00 
  80554f:	ff d0                	callq  *%rax
  805551:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805554:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805558:	79 27                	jns    805581 <ipc_recv+0x6c>
		if (from_env_store)
  80555a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80555f:	74 0a                	je     80556b <ipc_recv+0x56>
			*from_env_store = 0;
  805561:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805565:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  80556b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805570:	74 0a                	je     80557c <ipc_recv+0x67>
			*perm_store = 0;
  805572:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805576:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  80557c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80557f:	eb 53                	jmp    8055d4 <ipc_recv+0xbf>
	}
	if (from_env_store)
  805581:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805586:	74 19                	je     8055a1 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  805588:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80558f:	00 00 00 
  805592:	48 8b 00             	mov    (%rax),%rax
  805595:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80559b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80559f:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8055a1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8055a6:	74 19                	je     8055c1 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8055a8:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8055af:	00 00 00 
  8055b2:	48 8b 00             	mov    (%rax),%rax
  8055b5:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8055bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8055bf:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8055c1:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8055c8:	00 00 00 
  8055cb:	48 8b 00             	mov    (%rax),%rax
  8055ce:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  8055d4:	c9                   	leaveq 
  8055d5:	c3                   	retq   

00000000008055d6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8055d6:	55                   	push   %rbp
  8055d7:	48 89 e5             	mov    %rsp,%rbp
  8055da:	48 83 ec 30          	sub    $0x30,%rsp
  8055de:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8055e1:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8055e4:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8055e8:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  8055eb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8055f0:	75 10                	jne    805602 <ipc_send+0x2c>
		pg = (void*) UTOP;
  8055f2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8055f9:	00 00 00 
  8055fc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  805600:	eb 0e                	jmp    805610 <ipc_send+0x3a>
  805602:	eb 0c                	jmp    805610 <ipc_send+0x3a>
		sys_yield();
  805604:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  80560b:	00 00 00 
  80560e:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  805610:	8b 75 e8             	mov    -0x18(%rbp),%esi
  805613:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  805616:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80561a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80561d:	89 c7                	mov    %eax,%edi
  80561f:	48 b8 cd 21 80 00 00 	movabs $0x8021cd,%rax
  805626:	00 00 00 
  805629:	ff d0                	callq  *%rax
  80562b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80562e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  805632:	74 d0                	je     805604 <ipc_send+0x2e>
		sys_yield();
	}
	if (r < 0)
  805634:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805638:	79 30                	jns    80566a <ipc_send+0x94>
		panic("error in ipc_send: %e", r);
  80563a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80563d:	89 c1                	mov    %eax,%ecx
  80563f:	48 ba 15 63 80 00 00 	movabs $0x806315,%rdx
  805646:	00 00 00 
  805649:	be 47 00 00 00       	mov    $0x47,%esi
  80564e:	48 bf 2b 63 80 00 00 	movabs $0x80632b,%rdi
  805655:	00 00 00 
  805658:	b8 00 00 00 00       	mov    $0x0,%eax
  80565d:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  805664:	00 00 00 
  805667:	41 ff d0             	callq  *%r8

}
  80566a:	c9                   	leaveq 
  80566b:	c3                   	retq   

000000000080566c <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  80566c:	55                   	push   %rbp
  80566d:	48 89 e5             	mov    %rsp,%rbp
  805670:	53                   	push   %rbx
  805671:	48 83 ec 28          	sub    $0x28,%rsp
  805675:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  805679:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  805680:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  805687:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80568c:	75 0e                	jne    80569c <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  80568e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805695:	00 00 00 
  805698:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  80569c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8056a0:	ba 07 00 00 00       	mov    $0x7,%edx
  8056a5:	48 89 c6             	mov    %rax,%rsi
  8056a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8056ad:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  8056b4:	00 00 00 
  8056b7:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8056b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8056bd:	48 c1 e8 0c          	shr    $0xc,%rax
  8056c1:	48 89 c2             	mov    %rax,%rdx
  8056c4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8056cb:	01 00 00 
  8056ce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8056d2:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8056d8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  8056dc:	b8 03 00 00 00       	mov    $0x3,%eax
  8056e1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8056e5:	48 89 d3             	mov    %rdx,%rbx
  8056e8:	0f 01 c1             	vmcall 
  8056eb:	89 f2                	mov    %esi,%edx
  8056ed:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8056f0:	89 55 e8             	mov    %edx,-0x18(%rbp)
	/* cprintf("Returned IPC response from host: %d %d\n", r, -val);*/
	if (r < 0) {
  8056f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8056f7:	79 05                	jns    8056fe <ipc_host_recv+0x92>
		return r;
  8056f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8056fc:	eb 03                	jmp    805701 <ipc_host_recv+0x95>
	}
	return val;
  8056fe:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  805701:	48 83 c4 28          	add    $0x28,%rsp
  805705:	5b                   	pop    %rbx
  805706:	5d                   	pop    %rbp
  805707:	c3                   	retq   

0000000000805708 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  805708:	55                   	push   %rbp
  805709:	48 89 e5             	mov    %rsp,%rbp
  80570c:	53                   	push   %rbx
  80570d:	48 83 ec 38          	sub    $0x38,%rsp
  805711:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805714:	89 75 d8             	mov    %esi,-0x28(%rbp)
  805717:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80571b:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  80571e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  805725:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80572a:	75 0e                	jne    80573a <ipc_host_send+0x32>
		pg = (void*) UTOP;
  80572c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805733:	00 00 00 
  805736:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  80573a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80573e:	48 c1 e8 0c          	shr    $0xc,%rax
  805742:	48 89 c2             	mov    %rax,%rdx
  805745:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80574c:	01 00 00 
  80574f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805753:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  805759:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  80575d:	b8 02 00 00 00       	mov    $0x2,%eax
  805762:	8b 7d dc             	mov    -0x24(%rbp),%edi
  805765:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  805768:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80576c:	8b 75 cc             	mov    -0x34(%rbp),%esi
  80576f:	89 fb                	mov    %edi,%ebx
  805771:	0f 01 c1             	vmcall 
  805774:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  805777:	eb 26                	jmp    80579f <ipc_host_send+0x97>
		sys_yield();
  805779:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  805780:	00 00 00 
  805783:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  805785:	b8 02 00 00 00       	mov    $0x2,%eax
  80578a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80578d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  805790:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805794:	8b 75 cc             	mov    -0x34(%rbp),%esi
  805797:	89 fb                	mov    %edi,%ebx
  805799:	0f 01 c1             	vmcall 
  80579c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  80579f:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  8057a3:	74 d4                	je     805779 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  8057a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8057a9:	79 30                	jns    8057db <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  8057ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8057ae:	89 c1                	mov    %eax,%ecx
  8057b0:	48 ba 15 63 80 00 00 	movabs $0x806315,%rdx
  8057b7:	00 00 00 
  8057ba:	be 79 00 00 00       	mov    $0x79,%esi
  8057bf:	48 bf 2b 63 80 00 00 	movabs $0x80632b,%rdi
  8057c6:	00 00 00 
  8057c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8057ce:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  8057d5:	00 00 00 
  8057d8:	41 ff d0             	callq  *%r8

}
  8057db:	48 83 c4 38          	add    $0x38,%rsp
  8057df:	5b                   	pop    %rbx
  8057e0:	5d                   	pop    %rbp
  8057e1:	c3                   	retq   

00000000008057e2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8057e2:	55                   	push   %rbp
  8057e3:	48 89 e5             	mov    %rsp,%rbp
  8057e6:	48 83 ec 14          	sub    $0x14,%rsp
  8057ea:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8057ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8057f4:	eb 4e                	jmp    805844 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8057f6:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8057fd:	00 00 00 
  805800:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805803:	48 98                	cltq   
  805805:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80580c:	48 01 d0             	add    %rdx,%rax
  80580f:	48 05 d0 00 00 00    	add    $0xd0,%rax
  805815:	8b 00                	mov    (%rax),%eax
  805817:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80581a:	75 24                	jne    805840 <ipc_find_env+0x5e>
			return envs[i].env_id;
  80581c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805823:	00 00 00 
  805826:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805829:	48 98                	cltq   
  80582b:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  805832:	48 01 d0             	add    %rdx,%rax
  805835:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80583b:	8b 40 08             	mov    0x8(%rax),%eax
  80583e:	eb 12                	jmp    805852 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  805840:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805844:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80584b:	7e a9                	jle    8057f6 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80584d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805852:	c9                   	leaveq 
  805853:	c3                   	retq   

0000000000805854 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  805854:	55                   	push   %rbp
  805855:	48 89 e5             	mov    %rsp,%rbp
  805858:	48 83 ec 18          	sub    $0x18,%rsp
  80585c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  805860:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805864:	48 c1 e8 15          	shr    $0x15,%rax
  805868:	48 89 c2             	mov    %rax,%rdx
  80586b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805872:	01 00 00 
  805875:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805879:	83 e0 01             	and    $0x1,%eax
  80587c:	48 85 c0             	test   %rax,%rax
  80587f:	75 07                	jne    805888 <pageref+0x34>
		return 0;
  805881:	b8 00 00 00 00       	mov    $0x0,%eax
  805886:	eb 53                	jmp    8058db <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  805888:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80588c:	48 c1 e8 0c          	shr    $0xc,%rax
  805890:	48 89 c2             	mov    %rax,%rdx
  805893:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80589a:	01 00 00 
  80589d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8058a1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8058a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8058a9:	83 e0 01             	and    $0x1,%eax
  8058ac:	48 85 c0             	test   %rax,%rax
  8058af:	75 07                	jne    8058b8 <pageref+0x64>
		return 0;
  8058b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8058b6:	eb 23                	jmp    8058db <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8058b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8058bc:	48 c1 e8 0c          	shr    $0xc,%rax
  8058c0:	48 89 c2             	mov    %rax,%rdx
  8058c3:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8058ca:	00 00 00 
  8058cd:	48 c1 e2 04          	shl    $0x4,%rdx
  8058d1:	48 01 d0             	add    %rdx,%rax
  8058d4:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8058d8:	0f b7 c0             	movzwl %ax,%eax
}
  8058db:	c9                   	leaveq 
  8058dc:	c3                   	retq   
