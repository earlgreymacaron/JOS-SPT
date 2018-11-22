
vmm/guest/obj/fs/fs:     file format elf64-x86-64


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
  80003c:	e8 51 34 00 00       	callq  803492 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <ide_wait_ready>:
static int diskno = 1;


static int
ide_wait_ready(bool check_error)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 14          	sub    $0x14,%rsp
  80004b:	89 f8                	mov    %edi,%eax
  80004d:	88 45 ec             	mov    %al,-0x14(%rbp)
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800050:	90                   	nop
  800051:	c7 45 f8 f7 01 00 00 	movl   $0x1f7,-0x8(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800058:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80005b:	89 c2                	mov    %eax,%edx
  80005d:	ec                   	in     (%dx),%al
  80005e:	88 45 f7             	mov    %al,-0x9(%rbp)
	return data;
  800061:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800065:	0f b6 c0             	movzbl %al,%eax
  800068:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80006b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80006e:	25 c0 00 00 00       	and    $0xc0,%eax
  800073:	83 f8 40             	cmp    $0x40,%eax
  800076:	75 d9                	jne    800051 <ide_wait_ready+0xe>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  800078:	80 7d ec 00          	cmpb   $0x0,-0x14(%rbp)
  80007c:	74 11                	je     80008f <ide_wait_ready+0x4c>
  80007e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800081:	83 e0 21             	and    $0x21,%eax
  800084:	85 c0                	test   %eax,%eax
  800086:	74 07                	je     80008f <ide_wait_ready+0x4c>
		return -1;
  800088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80008d:	eb 05                	jmp    800094 <ide_wait_ready+0x51>
	return 0;
  80008f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800094:	c9                   	leaveq 
  800095:	c3                   	retq   

0000000000800096 <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  800096:	55                   	push   %rbp
  800097:	48 89 e5             	mov    %rsp,%rbp
  80009a:	48 83 ec 20          	sub    $0x20,%rsp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  80009e:	bf 00 00 00 00       	mov    $0x0,%edi
  8000a3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000aa:	00 00 00 
  8000ad:	ff d0                	callq  *%rax
  8000af:	c7 45 f4 f6 01 00 00 	movl   $0x1f6,-0xc(%rbp)
  8000b6:	c6 45 f3 f0          	movb   $0xf0,-0xd(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8000ba:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  8000be:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8000c1:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000c9:	eb 04                	jmp    8000cf <ide_probe_disk1+0x39>
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
	     x++)
  8000cb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000cf:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  8000d6:	7f 26                	jg     8000fe <ide_probe_disk1+0x68>
  8000d8:	c7 45 ec f7 01 00 00 	movl   $0x1f7,-0x14(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8000df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000e2:	89 c2                	mov    %eax,%edx
  8000e4:	ec                   	in     (%dx),%al
  8000e5:	88 45 eb             	mov    %al,-0x15(%rbp)
	return data;
  8000e8:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  8000ec:	0f b6 c0             	movzbl %al,%eax
  8000ef:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000f5:	25 a1 00 00 00       	and    $0xa1,%eax
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	75 cd                	jne    8000cb <ide_probe_disk1+0x35>
  8000fe:	c7 45 e4 f6 01 00 00 	movl   $0x1f6,-0x1c(%rbp)
  800105:	c6 45 e3 e0          	movb   $0xe0,-0x1d(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800109:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
  80010d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800110:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  800111:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  800118:	0f 9e c0             	setle  %al
  80011b:	0f b6 c0             	movzbl %al,%eax
  80011e:	89 c6                	mov    %eax,%esi
  800120:	48 bf e0 75 80 00 00 	movabs $0x8075e0,%rdi
  800127:	00 00 00 
  80012a:	b8 00 00 00 00       	mov    $0x0,%eax
  80012f:	48 ba 71 37 80 00 00 	movabs $0x803771,%rdx
  800136:	00 00 00 
  800139:	ff d2                	callq  *%rdx
	return (x < 1000);
  80013b:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  800142:	0f 9e c0             	setle  %al
}
  800145:	c9                   	leaveq 
  800146:	c3                   	retq   

0000000000800147 <ide_set_disk>:

void
ide_set_disk(int d)
{
  800147:	55                   	push   %rbp
  800148:	48 89 e5             	mov    %rsp,%rbp
  80014b:	48 83 ec 10          	sub    $0x10,%rsp
  80014f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	if (d != 0 && d != 1)
  800152:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800156:	74 30                	je     800188 <ide_set_disk+0x41>
  800158:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  80015c:	74 2a                	je     800188 <ide_set_disk+0x41>
		panic("bad disk number");
  80015e:	48 ba f7 75 80 00 00 	movabs $0x8075f7,%rdx
  800165:	00 00 00 
  800168:	be 3c 00 00 00       	mov    $0x3c,%esi
  80016d:	48 bf 07 76 80 00 00 	movabs $0x807607,%rdi
  800174:	00 00 00 
  800177:	b8 00 00 00 00       	mov    $0x0,%eax
  80017c:	48 b9 38 35 80 00 00 	movabs $0x803538,%rcx
  800183:	00 00 00 
  800186:	ff d1                	callq  *%rcx
	diskno = d;
  800188:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80018f:	00 00 00 
  800192:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800195:	89 10                	mov    %edx,(%rax)
}
  800197:	c9                   	leaveq 
  800198:	c3                   	retq   

0000000000800199 <ide_read>:


int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  800199:	55                   	push   %rbp
  80019a:	48 89 e5             	mov    %rsp,%rbp
  80019d:	48 83 ec 70          	sub    $0x70,%rsp
  8001a1:	89 7d ac             	mov    %edi,-0x54(%rbp)
  8001a4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8001a8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
	int r;

	assert(nsecs <= 256);
  8001ac:	48 81 7d 98 00 01 00 	cmpq   $0x100,-0x68(%rbp)
  8001b3:	00 
  8001b4:	76 35                	jbe    8001eb <ide_read+0x52>
  8001b6:	48 b9 10 76 80 00 00 	movabs $0x807610,%rcx
  8001bd:	00 00 00 
  8001c0:	48 ba 1d 76 80 00 00 	movabs $0x80761d,%rdx
  8001c7:	00 00 00 
  8001ca:	be 46 00 00 00       	mov    $0x46,%esi
  8001cf:	48 bf 07 76 80 00 00 	movabs $0x807607,%rdi
  8001d6:	00 00 00 
  8001d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001de:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  8001e5:	00 00 00 
  8001e8:	41 ff d0             	callq  *%r8


	ide_wait_ready(0);
  8001eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001f7:	00 00 00 
  8001fa:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  8001fc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800200:	0f b6 c0             	movzbl %al,%eax
  800203:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%rbp)
  80020a:	88 45 f7             	mov    %al,-0x9(%rbp)
  80020d:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800211:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800214:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  800215:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800218:	0f b6 c0             	movzbl %al,%eax
  80021b:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%rbp)
  800222:	88 45 ef             	mov    %al,-0x11(%rbp)
  800225:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  800229:	8b 55 f0             	mov    -0x10(%rbp),%edx
  80022c:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  80022d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800230:	c1 e8 08             	shr    $0x8,%eax
  800233:	0f b6 c0             	movzbl %al,%eax
  800236:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%rbp)
  80023d:	88 45 e7             	mov    %al,-0x19(%rbp)
  800240:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  800244:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800247:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  800248:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80024b:	c1 e8 10             	shr    $0x10,%eax
  80024e:	0f b6 c0             	movzbl %al,%eax
  800251:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%rbp)
  800258:	88 45 df             	mov    %al,-0x21(%rbp)
  80025b:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  80025f:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800262:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800263:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80026a:	00 00 00 
  80026d:	8b 00                	mov    (%rax),%eax
  80026f:	83 e0 01             	and    $0x1,%eax
  800272:	c1 e0 04             	shl    $0x4,%eax
  800275:	89 c2                	mov    %eax,%edx
  800277:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80027a:	c1 e8 18             	shr    $0x18,%eax
  80027d:	83 e0 0f             	and    $0xf,%eax
  800280:	09 d0                	or     %edx,%eax
  800282:	83 c8 e0             	or     $0xffffffe0,%eax
  800285:	0f b6 c0             	movzbl %al,%eax
  800288:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%rbp)
  80028f:	88 45 d7             	mov    %al,-0x29(%rbp)
  800292:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
  800296:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800299:	ee                   	out    %al,(%dx)
  80029a:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%rbp)
  8002a1:	c6 45 cf 20          	movb   $0x20,-0x31(%rbp)
  8002a5:	0f b6 45 cf          	movzbl -0x31(%rbp),%eax
  8002a9:	8b 55 d0             	mov    -0x30(%rbp),%edx
  8002ac:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8002ad:	eb 64                	jmp    800313 <ide_read+0x17a>
		if ((r = ide_wait_ready(1)) < 0)
  8002af:	bf 01 00 00 00       	mov    $0x1,%edi
  8002b4:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
  8002c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8002c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002c7:	79 05                	jns    8002ce <ide_read+0x135>
			return r;
  8002c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002cc:	eb 51                	jmp    80031f <ide_read+0x186>
  8002ce:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%rbp)
  8002d5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8002d9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8002dd:	c7 45 bc 00 01 00 00 	movl   $0x100,-0x44(%rbp)
}

static __inline void
insw(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsw"			:
  8002e4:	8b 55 c8             	mov    -0x38(%rbp),%edx
  8002e7:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8002eb:	8b 45 bc             	mov    -0x44(%rbp),%eax
  8002ee:	48 89 ce             	mov    %rcx,%rsi
  8002f1:	48 89 f7             	mov    %rsi,%rdi
  8002f4:	89 c1                	mov    %eax,%ecx
  8002f6:	fc                   	cld    
  8002f7:	f2 66 6d             	repnz insw (%dx),%es:(%rdi)
  8002fa:	89 c8                	mov    %ecx,%eax
  8002fc:	48 89 fe             	mov    %rdi,%rsi
  8002ff:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800303:	89 45 bc             	mov    %eax,-0x44(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800306:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80030b:	48 81 45 a0 00 02 00 	addq   $0x200,-0x60(%rbp)
  800312:	00 
  800313:	48 83 7d 98 00       	cmpq   $0x0,-0x68(%rbp)
  800318:	75 95                	jne    8002af <ide_read+0x116>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insw(0x1F0, dst, SECTSIZE/2);
	}

	return 0;
  80031a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80031f:	c9                   	leaveq 
  800320:	c3                   	retq   

0000000000800321 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  800321:	55                   	push   %rbp
  800322:	48 89 e5             	mov    %rsp,%rbp
  800325:	48 83 ec 70          	sub    $0x70,%rsp
  800329:	89 7d ac             	mov    %edi,-0x54(%rbp)
  80032c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800330:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
	int r;

	assert(nsecs <= 256);
  800334:	48 81 7d 98 00 01 00 	cmpq   $0x100,-0x68(%rbp)
  80033b:	00 
  80033c:	76 35                	jbe    800373 <ide_write+0x52>
  80033e:	48 b9 10 76 80 00 00 	movabs $0x807610,%rcx
  800345:	00 00 00 
  800348:	48 ba 1d 76 80 00 00 	movabs $0x80761d,%rdx
  80034f:	00 00 00 
  800352:	be 60 00 00 00       	mov    $0x60,%esi
  800357:	48 bf 07 76 80 00 00 	movabs $0x807607,%rdi
  80035e:	00 00 00 
  800361:	b8 00 00 00 00       	mov    $0x0,%eax
  800366:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  80036d:	00 00 00 
  800370:	41 ff d0             	callq  *%r8


	ide_wait_ready(0);
  800373:	bf 00 00 00 00       	mov    $0x0,%edi
  800378:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80037f:	00 00 00 
  800382:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  800384:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800388:	0f b6 c0             	movzbl %al,%eax
  80038b:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%rbp)
  800392:	88 45 f7             	mov    %al,-0x9(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800395:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800399:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80039c:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  80039d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003a0:	0f b6 c0             	movzbl %al,%eax
  8003a3:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%rbp)
  8003aa:	88 45 ef             	mov    %al,-0x11(%rbp)
  8003ad:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8003b1:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8003b4:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  8003b5:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003b8:	c1 e8 08             	shr    $0x8,%eax
  8003bb:	0f b6 c0             	movzbl %al,%eax
  8003be:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%rbp)
  8003c5:	88 45 e7             	mov    %al,-0x19(%rbp)
  8003c8:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8003cc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8003cf:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8003d0:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003d3:	c1 e8 10             	shr    $0x10,%eax
  8003d6:	0f b6 c0             	movzbl %al,%eax
  8003d9:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%rbp)
  8003e0:	88 45 df             	mov    %al,-0x21(%rbp)
  8003e3:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  8003e7:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8003ea:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  8003eb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8003f2:	00 00 00 
  8003f5:	8b 00                	mov    (%rax),%eax
  8003f7:	83 e0 01             	and    $0x1,%eax
  8003fa:	c1 e0 04             	shl    $0x4,%eax
  8003fd:	89 c2                	mov    %eax,%edx
  8003ff:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800402:	c1 e8 18             	shr    $0x18,%eax
  800405:	83 e0 0f             	and    $0xf,%eax
  800408:	09 d0                	or     %edx,%eax
  80040a:	83 c8 e0             	or     $0xffffffe0,%eax
  80040d:	0f b6 c0             	movzbl %al,%eax
  800410:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%rbp)
  800417:	88 45 d7             	mov    %al,-0x29(%rbp)
  80041a:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
  80041e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800421:	ee                   	out    %al,(%dx)
  800422:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%rbp)
  800429:	c6 45 cf 30          	movb   $0x30,-0x31(%rbp)
  80042d:	0f b6 45 cf          	movzbl -0x31(%rbp),%eax
  800431:	8b 55 d0             	mov    -0x30(%rbp),%edx
  800434:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800435:	eb 5e                	jmp    800495 <ide_write+0x174>
		if ((r = ide_wait_ready(1)) < 0)
  800437:	bf 01 00 00 00       	mov    $0x1,%edi
  80043c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800443:	00 00 00 
  800446:	ff d0                	callq  *%rax
  800448:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80044b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80044f:	79 05                	jns    800456 <ide_write+0x135>
			return r;
  800451:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800454:	eb 4b                	jmp    8004a1 <ide_write+0x180>
  800456:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%rbp)
  80045d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800461:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800465:	c7 45 bc 00 01 00 00 	movl   $0x100,-0x44(%rbp)
}

static __inline void
outsw(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsw"		:
  80046c:	8b 55 c8             	mov    -0x38(%rbp),%edx
  80046f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800473:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800476:	48 89 ce             	mov    %rcx,%rsi
  800479:	89 c1                	mov    %eax,%ecx
  80047b:	fc                   	cld    
  80047c:	f2 66 6f             	repnz outsw %ds:(%rsi),(%dx)
  80047f:	89 c8                	mov    %ecx,%eax
  800481:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800485:	89 45 bc             	mov    %eax,-0x44(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800488:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80048d:	48 81 45 a0 00 02 00 	addq   $0x200,-0x60(%rbp)
  800494:	00 
  800495:	48 83 7d 98 00       	cmpq   $0x0,-0x68(%rbp)
  80049a:	75 9b                	jne    800437 <ide_write+0x116>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsw(0x1F0, src, SECTSIZE/2);
	}

	return 0;
  80049c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004a1:	c9                   	leaveq 
  8004a2:	c3                   	retq   

00000000008004a3 <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint64_t blockno)
{
  8004a3:	55                   	push   %rbp
  8004a4:	48 89 e5             	mov    %rsp,%rbp
  8004a7:	48 83 ec 10          	sub    $0x10,%rsp
  8004ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8004af:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004b4:	74 2a                	je     8004e0 <diskaddr+0x3d>
  8004b6:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  8004bd:	00 00 00 
  8004c0:	48 8b 00             	mov    (%rax),%rax
  8004c3:	48 85 c0             	test   %rax,%rax
  8004c6:	74 4a                	je     800512 <diskaddr+0x6f>
  8004c8:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  8004cf:	00 00 00 
  8004d2:	48 8b 00             	mov    (%rax),%rax
  8004d5:	8b 40 04             	mov    0x4(%rax),%eax
  8004d8:	89 c0                	mov    %eax,%eax
  8004da:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004de:	77 32                	ja     800512 <diskaddr+0x6f>
		panic("bad block number %08x in diskaddr", blockno);
  8004e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004e4:	48 89 c1             	mov    %rax,%rcx
  8004e7:	48 ba 38 76 80 00 00 	movabs $0x807638,%rdx
  8004ee:	00 00 00 
  8004f1:	be 0a 00 00 00       	mov    $0xa,%esi
  8004f6:	48 bf 5a 76 80 00 00 	movabs $0x80765a,%rdi
  8004fd:	00 00 00 
  800500:	b8 00 00 00 00       	mov    $0x0,%eax
  800505:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  80050c:	00 00 00 
  80050f:	41 ff d0             	callq  *%r8
	return (char*) (DISKMAP + blockno * BLKSIZE);
  800512:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800516:	48 05 00 00 01 00    	add    $0x10000,%rax
  80051c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800520:	c9                   	leaveq 
  800521:	c3                   	retq   

0000000000800522 <va_is_mapped>:

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  800522:	55                   	push   %rbp
  800523:	48 89 e5             	mov    %rsp,%rbp
  800526:	48 83 ec 08          	sub    $0x8,%rsp
  80052a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpml4e[VPML4E(va)] & PTE_P) && (uvpde[VPDPE(va)] & PTE_P) && (uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  80052e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800532:	48 c1 e8 27          	shr    $0x27,%rax
  800536:	48 89 c2             	mov    %rax,%rdx
  800539:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  800540:	01 00 00 
  800543:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800547:	83 e0 01             	and    $0x1,%eax
  80054a:	48 85 c0             	test   %rax,%rax
  80054d:	74 6a                	je     8005b9 <va_is_mapped+0x97>
  80054f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800553:	48 c1 e8 1e          	shr    $0x1e,%rax
  800557:	48 89 c2             	mov    %rax,%rdx
  80055a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  800561:	01 00 00 
  800564:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800568:	83 e0 01             	and    $0x1,%eax
  80056b:	48 85 c0             	test   %rax,%rax
  80056e:	74 49                	je     8005b9 <va_is_mapped+0x97>
  800570:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800574:	48 c1 e8 15          	shr    $0x15,%rax
  800578:	48 89 c2             	mov    %rax,%rdx
  80057b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800582:	01 00 00 
  800585:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800589:	83 e0 01             	and    $0x1,%eax
  80058c:	48 85 c0             	test   %rax,%rax
  80058f:	74 28                	je     8005b9 <va_is_mapped+0x97>
  800591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800595:	48 c1 e8 0c          	shr    $0xc,%rax
  800599:	48 89 c2             	mov    %rax,%rdx
  80059c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005a3:	01 00 00 
  8005a6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005aa:	83 e0 01             	and    $0x1,%eax
  8005ad:	48 85 c0             	test   %rax,%rax
  8005b0:	74 07                	je     8005b9 <va_is_mapped+0x97>
  8005b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8005b7:	eb 05                	jmp    8005be <va_is_mapped+0x9c>
  8005b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005be:	83 e0 01             	and    $0x1,%eax
}
  8005c1:	c9                   	leaveq 
  8005c2:	c3                   	retq   

00000000008005c3 <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  8005c3:	55                   	push   %rbp
  8005c4:	48 89 e5             	mov    %rsp,%rbp
  8005c7:	48 83 ec 08          	sub    $0x8,%rsp
  8005cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  8005cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005d3:	48 c1 e8 0c          	shr    $0xc,%rax
  8005d7:	48 89 c2             	mov    %rax,%rdx
  8005da:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005e1:	01 00 00 
  8005e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005e8:	83 e0 40             	and    $0x40,%eax
  8005eb:	48 85 c0             	test   %rax,%rax
  8005ee:	0f 95 c0             	setne  %al
}
  8005f1:	c9                   	leaveq 
  8005f2:	c3                   	retq   

00000000008005f3 <bc_pgfault>:
// Fault any disk block that is read in to memory by
// loading it from disk.
// Hint: Use ide_read and BLKSECTS.
static void
bc_pgfault(struct UTrapframe *utf)
{
  8005f3:	55                   	push   %rbp
  8005f4:	48 89 e5             	mov    %rsp,%rbp
  8005f7:	48 83 ec 30          	sub    $0x30,%rsp
  8005fb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  8005ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800603:	48 8b 00             	mov    (%rax),%rax
  800606:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  80060a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80060e:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  800614:	48 c1 e8 0c          	shr    $0xc,%rax
  800618:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80061c:	48 81 7d f8 ff ff ff 	cmpq   $0xfffffff,-0x8(%rbp)
  800623:	0f 
  800624:	76 0b                	jbe    800631 <bc_pgfault+0x3e>
  800626:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  80062b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80062f:	76 4b                	jbe    80067c <bc_pgfault+0x89>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  800631:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800635:	48 8b 48 08          	mov    0x8(%rax),%rcx
  800639:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80063d:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  800644:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800648:	49 89 c9             	mov    %rcx,%r9
  80064b:	49 89 d0             	mov    %rdx,%r8
  80064e:	48 89 c1             	mov    %rax,%rcx
  800651:	48 ba 68 76 80 00 00 	movabs $0x807668,%rdx
  800658:	00 00 00 
  80065b:	be 29 00 00 00       	mov    $0x29,%esi
  800660:	48 bf 5a 76 80 00 00 	movabs $0x80765a,%rdi
  800667:	00 00 00 
  80066a:	b8 00 00 00 00       	mov    $0x0,%eax
  80066f:	49 ba 38 35 80 00 00 	movabs $0x803538,%r10
  800676:	00 00 00 
  800679:	41 ff d2             	callq  *%r10
		      utf->utf_rip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  80067c:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  800683:	00 00 00 
  800686:	48 8b 00             	mov    (%rax),%rax
  800689:	48 85 c0             	test   %rax,%rax
  80068c:	74 4a                	je     8006d8 <bc_pgfault+0xe5>
  80068e:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  800695:	00 00 00 
  800698:	48 8b 00             	mov    (%rax),%rax
  80069b:	8b 40 04             	mov    0x4(%rax),%eax
  80069e:	89 c0                	mov    %eax,%eax
  8006a0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8006a4:	77 32                	ja     8006d8 <bc_pgfault+0xe5>
		panic("reading non-existent block %08x\n", blockno);
  8006a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006aa:	48 89 c1             	mov    %rax,%rcx
  8006ad:	48 ba 98 76 80 00 00 	movabs $0x807698,%rdx
  8006b4:	00 00 00 
  8006b7:	be 2d 00 00 00       	mov    $0x2d,%esi
  8006bc:	48 bf 5a 76 80 00 00 	movabs $0x80765a,%rdi
  8006c3:	00 00 00 
  8006c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006cb:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  8006d2:	00 00 00 
  8006d5:	41 ff d0             	callq  *%r8
	// Allocate a page in the disk map region, read the contents
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary.
	//

	addr = ROUNDDOWN(addr, PGSIZE);
  8006d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006dc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8006e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8006ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if ((r = sys_page_alloc(0, addr, PTE_U|PTE_P|PTE_W)) < 0)
  8006ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006f2:	ba 07 00 00 00       	mov    $0x7,%edx
  8006f7:	48 89 c6             	mov    %rax,%rsi
  8006fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8006ff:	48 b8 55 4c 80 00 00 	movabs $0x804c55,%rax
  800706:	00 00 00 
  800709:	ff d0                	callq  *%rax
  80070b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80070e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800712:	79 30                	jns    800744 <bc_pgfault+0x151>
		panic("in bc_pgfault, sys_page_alloc: %e", r);
  800714:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800717:	89 c1                	mov    %eax,%ecx
  800719:	48 ba c0 76 80 00 00 	movabs $0x8076c0,%rdx
  800720:	00 00 00 
  800723:	be 36 00 00 00       	mov    $0x36,%esi
  800728:	48 bf 5a 76 80 00 00 	movabs $0x80765a,%rdi
  80072f:	00 00 00 
  800732:	b8 00 00 00 00       	mov    $0x0,%eax
  800737:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  80073e:	00 00 00 
  800741:	41 ff d0             	callq  *%r8

#else  // VMM GUEST


	/* FIXME DP: Should be lab 8 */
	if ((r = host_read(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
  800744:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800748:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  80074f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800753:	ba 08 00 00 00       	mov    $0x8,%edx
  800758:	48 89 c6             	mov    %rax,%rsi
  80075b:	89 cf                	mov    %ecx,%edi
  80075d:	48 b8 74 31 80 00 00 	movabs $0x803174,%rax
  800764:	00 00 00 
  800767:	ff d0                	callq  *%rax
  800769:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80076c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800770:	79 30                	jns    8007a2 <bc_pgfault+0x1af>
		panic("in bc_pgfault, host_read: %e", r);
  800772:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800775:	89 c1                	mov    %eax,%ecx
  800777:	48 ba e2 76 80 00 00 	movabs $0x8076e2,%rdx
  80077e:	00 00 00 
  800781:	be 48 00 00 00       	mov    $0x48,%esi
  800786:	48 bf 5a 76 80 00 00 	movabs $0x80765a,%rdi
  80078d:	00 00 00 
  800790:	b8 00 00 00 00       	mov    $0x0,%eax
  800795:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  80079c:	00 00 00 
  80079f:	41 ff d0             	callq  *%r8

#endif // VMM_GUEST



	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8007a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007a6:	48 c1 e8 0c          	shr    $0xc,%rax
  8007aa:	48 89 c2             	mov    %rax,%rdx
  8007ad:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8007b4:	01 00 00 
  8007b7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007bb:	25 07 0e 00 00       	and    $0xe07,%eax
  8007c0:	89 c1                	mov    %eax,%ecx
  8007c2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8007c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007ca:	41 89 c8             	mov    %ecx,%r8d
  8007cd:	48 89 d1             	mov    %rdx,%rcx
  8007d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d5:	48 89 c6             	mov    %rax,%rsi
  8007d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8007dd:	48 b8 a5 4c 80 00 00 	movabs $0x804ca5,%rax
  8007e4:	00 00 00 
  8007e7:	ff d0                	callq  *%rax
  8007e9:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8007ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007f0:	79 30                	jns    800822 <bc_pgfault+0x22f>
		panic("in bc_pgfault, sys_page_map: %e", r);
  8007f2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8007f5:	89 c1                	mov    %eax,%ecx
  8007f7:	48 ba 00 77 80 00 00 	movabs $0x807700,%rdx
  8007fe:	00 00 00 
  800801:	be 4f 00 00 00       	mov    $0x4f,%esi
  800806:	48 bf 5a 76 80 00 00 	movabs $0x80765a,%rdi
  80080d:	00 00 00 
  800810:	b8 00 00 00 00       	mov    $0x0,%eax
  800815:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  80081c:	00 00 00 
  80081f:	41 ff d0             	callq  *%r8

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  800822:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
  800829:	00 00 00 
  80082c:	48 8b 00             	mov    (%rax),%rax
  80082f:	48 85 c0             	test   %rax,%rax
  800832:	74 48                	je     80087c <bc_pgfault+0x289>
  800834:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800838:	89 c7                	mov    %eax,%edi
  80083a:	48 b8 2c 0d 80 00 00 	movabs $0x800d2c,%rax
  800841:	00 00 00 
  800844:	ff d0                	callq  *%rax
  800846:	84 c0                	test   %al,%al
  800848:	74 32                	je     80087c <bc_pgfault+0x289>
		panic("reading free block %08x\n", blockno);
  80084a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80084e:	48 89 c1             	mov    %rax,%rcx
  800851:	48 ba 20 77 80 00 00 	movabs $0x807720,%rdx
  800858:	00 00 00 
  80085b:	be 55 00 00 00       	mov    $0x55,%esi
  800860:	48 bf 5a 76 80 00 00 	movabs $0x80765a,%rdi
  800867:	00 00 00 
  80086a:	b8 00 00 00 00       	mov    $0x0,%eax
  80086f:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  800876:	00 00 00 
  800879:	41 ff d0             	callq  *%r8
}
  80087c:	c9                   	leaveq 
  80087d:	c3                   	retq   

000000000080087e <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  80087e:	55                   	push   %rbp
  80087f:	48 89 e5             	mov    %rsp,%rbp
  800882:	48 83 ec 20          	sub    $0x20,%rsp
  800886:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  80088a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088e:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  800894:	48 c1 e8 0c          	shr    $0xc,%rax
  800898:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80089c:	48 81 7d e8 ff ff ff 	cmpq   $0xfffffff,-0x18(%rbp)
  8008a3:	0f 
  8008a4:	76 0b                	jbe    8008b1 <flush_block+0x33>
  8008a6:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  8008ab:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  8008af:	76 32                	jbe    8008e3 <flush_block+0x65>
		panic("flush_block of bad va %08x", addr);
  8008b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b5:	48 89 c1             	mov    %rax,%rcx
  8008b8:	48 ba 39 77 80 00 00 	movabs $0x807739,%rdx
  8008bf:	00 00 00 
  8008c2:	be 65 00 00 00       	mov    $0x65,%esi
  8008c7:	48 bf 5a 76 80 00 00 	movabs $0x80765a,%rdi
  8008ce:	00 00 00 
  8008d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d6:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  8008dd:	00 00 00 
  8008e0:	41 ff d0             	callq  *%r8


	if (!va_is_mapped(addr) || !va_is_dirty(addr))
  8008e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e7:	48 89 c7             	mov    %rax,%rdi
  8008ea:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  8008f1:	00 00 00 
  8008f4:	ff d0                	callq  *%rax
  8008f6:	83 f0 01             	xor    $0x1,%eax
  8008f9:	84 c0                	test   %al,%al
  8008fb:	75 1a                	jne    800917 <flush_block+0x99>
  8008fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800901:	48 89 c7             	mov    %rax,%rdi
  800904:	48 b8 c3 05 80 00 00 	movabs $0x8005c3,%rax
  80090b:	00 00 00 
  80090e:	ff d0                	callq  *%rax
  800910:	83 f0 01             	xor    $0x1,%eax
  800913:	84 c0                	test   %al,%al
  800915:	74 05                	je     80091c <flush_block+0x9e>
		return;
  800917:	e9 82 00 00 00       	jmpq   80099e <flush_block+0x120>

	// Write the disk block and clear PTE_D.
	addr = ROUNDDOWN(addr, BLKSIZE);
  80091c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800920:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800924:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800928:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80092e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
#ifndef VMM_GUEST
	ide_write(blockno * BLKSECTS, (void*) addr, BLKSECTS);
#else

	/* FIXME DP: Should be lab 8 */
	host_write(blockno * BLKSECTS, (void*) addr, BLKSECTS);
  800932:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800936:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  80093d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800941:	ba 08 00 00 00       	mov    $0x8,%edx
  800946:	48 89 c6             	mov    %rax,%rsi
  800949:	89 cf                	mov    %ecx,%edi
  80094b:	48 b8 6c 32 80 00 00 	movabs $0x80326c,%rax
  800952:	00 00 00 
  800955:	ff d0                	callq  *%rax

#endif
	sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL);
  800957:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095b:	48 c1 e8 0c          	shr    $0xc,%rax
  80095f:	48 89 c2             	mov    %rax,%rdx
  800962:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800969:	01 00 00 
  80096c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800970:	25 07 0e 00 00       	and    $0xe07,%eax
  800975:	89 c1                	mov    %eax,%ecx
  800977:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097f:	41 89 c8             	mov    %ecx,%r8d
  800982:	48 89 d1             	mov    %rdx,%rcx
  800985:	ba 00 00 00 00       	mov    $0x0,%edx
  80098a:	48 89 c6             	mov    %rax,%rsi
  80098d:	bf 00 00 00 00       	mov    $0x0,%edi
  800992:	48 b8 a5 4c 80 00 00 	movabs $0x804ca5,%rax
  800999:	00 00 00 
  80099c:	ff d0                	callq  *%rax

}
  80099e:	c9                   	leaveq 
  80099f:	c3                   	retq   

00000000008009a0 <check_bc>:

// Test that the block cache works, by smashing the superblock and
// reading it back.
static void
check_bc(void)
{
  8009a0:	55                   	push   %rbp
  8009a1:	48 89 e5             	mov    %rsp,%rbp
  8009a4:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  8009ab:	bf 01 00 00 00       	mov    $0x1,%edi
  8009b0:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8009b7:	00 00 00 
  8009ba:	ff d0                	callq  *%rax
  8009bc:	48 89 c1             	mov    %rax,%rcx
  8009bf:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8009c6:	ba 08 01 00 00       	mov    $0x108,%edx
  8009cb:	48 89 ce             	mov    %rcx,%rsi
  8009ce:	48 89 c7             	mov    %rax,%rdi
  8009d1:	48 b8 4a 46 80 00 00 	movabs $0x80464a,%rax
  8009d8:	00 00 00 
  8009db:	ff d0                	callq  *%rax

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  8009dd:	bf 01 00 00 00       	mov    $0x1,%edi
  8009e2:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8009e9:	00 00 00 
  8009ec:	ff d0                	callq  *%rax
  8009ee:	48 be 54 77 80 00 00 	movabs $0x807754,%rsi
  8009f5:	00 00 00 
  8009f8:	48 89 c7             	mov    %rax,%rdi
  8009fb:	48 b8 26 43 80 00 00 	movabs $0x804326,%rax
  800a02:	00 00 00 
  800a05:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800a07:	bf 01 00 00 00       	mov    $0x1,%edi
  800a0c:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a13:	00 00 00 
  800a16:	ff d0                	callq  *%rax
  800a18:	48 89 c7             	mov    %rax,%rdi
  800a1b:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  800a22:	00 00 00 
  800a25:	ff d0                	callq  *%rax
	assert(va_is_mapped(diskaddr(1)));
  800a27:	bf 01 00 00 00       	mov    $0x1,%edi
  800a2c:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a33:	00 00 00 
  800a36:	ff d0                	callq  *%rax
  800a38:	48 89 c7             	mov    %rax,%rdi
  800a3b:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  800a42:	00 00 00 
  800a45:	ff d0                	callq  *%rax
  800a47:	83 f0 01             	xor    $0x1,%eax
  800a4a:	84 c0                	test   %al,%al
  800a4c:	74 35                	je     800a83 <check_bc+0xe3>
  800a4e:	48 b9 5b 77 80 00 00 	movabs $0x80775b,%rcx
  800a55:	00 00 00 
  800a58:	48 ba 75 77 80 00 00 	movabs $0x807775,%rdx
  800a5f:	00 00 00 
  800a62:	be 86 00 00 00       	mov    $0x86,%esi
  800a67:	48 bf 5a 76 80 00 00 	movabs $0x80765a,%rdi
  800a6e:	00 00 00 
  800a71:	b8 00 00 00 00       	mov    $0x0,%eax
  800a76:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  800a7d:	00 00 00 
  800a80:	41 ff d0             	callq  *%r8
	assert(!va_is_dirty(diskaddr(1)));
  800a83:	bf 01 00 00 00       	mov    $0x1,%edi
  800a88:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a8f:	00 00 00 
  800a92:	ff d0                	callq  *%rax
  800a94:	48 89 c7             	mov    %rax,%rdi
  800a97:	48 b8 c3 05 80 00 00 	movabs $0x8005c3,%rax
  800a9e:	00 00 00 
  800aa1:	ff d0                	callq  *%rax
  800aa3:	84 c0                	test   %al,%al
  800aa5:	74 35                	je     800adc <check_bc+0x13c>
  800aa7:	48 b9 8a 77 80 00 00 	movabs $0x80778a,%rcx
  800aae:	00 00 00 
  800ab1:	48 ba 75 77 80 00 00 	movabs $0x807775,%rdx
  800ab8:	00 00 00 
  800abb:	be 87 00 00 00       	mov    $0x87,%esi
  800ac0:	48 bf 5a 76 80 00 00 	movabs $0x80765a,%rdi
  800ac7:	00 00 00 
  800aca:	b8 00 00 00 00       	mov    $0x0,%eax
  800acf:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  800ad6:	00 00 00 
  800ad9:	41 ff d0             	callq  *%r8

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  800adc:	bf 01 00 00 00       	mov    $0x1,%edi
  800ae1:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800ae8:	00 00 00 
  800aeb:	ff d0                	callq  *%rax
  800aed:	48 89 c6             	mov    %rax,%rsi
  800af0:	bf 00 00 00 00       	mov    $0x0,%edi
  800af5:	48 b8 00 4d 80 00 00 	movabs $0x804d00,%rax
  800afc:	00 00 00 
  800aff:	ff d0                	callq  *%rax
	assert(!va_is_mapped(diskaddr(1)));
  800b01:	bf 01 00 00 00       	mov    $0x1,%edi
  800b06:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800b0d:	00 00 00 
  800b10:	ff d0                	callq  *%rax
  800b12:	48 89 c7             	mov    %rax,%rdi
  800b15:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  800b1c:	00 00 00 
  800b1f:	ff d0                	callq  *%rax
  800b21:	84 c0                	test   %al,%al
  800b23:	74 35                	je     800b5a <check_bc+0x1ba>
  800b25:	48 b9 a4 77 80 00 00 	movabs $0x8077a4,%rcx
  800b2c:	00 00 00 
  800b2f:	48 ba 75 77 80 00 00 	movabs $0x807775,%rdx
  800b36:	00 00 00 
  800b39:	be 8b 00 00 00       	mov    $0x8b,%esi
  800b3e:	48 bf 5a 76 80 00 00 	movabs $0x80765a,%rdi
  800b45:	00 00 00 
  800b48:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4d:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  800b54:	00 00 00 
  800b57:	41 ff d0             	callq  *%r8

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800b5a:	bf 01 00 00 00       	mov    $0x1,%edi
  800b5f:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800b66:	00 00 00 
  800b69:	ff d0                	callq  *%rax
  800b6b:	48 be 54 77 80 00 00 	movabs $0x807754,%rsi
  800b72:	00 00 00 
  800b75:	48 89 c7             	mov    %rax,%rdi
  800b78:	48 b8 88 44 80 00 00 	movabs $0x804488,%rax
  800b7f:	00 00 00 
  800b82:	ff d0                	callq  *%rax
  800b84:	85 c0                	test   %eax,%eax
  800b86:	74 35                	je     800bbd <check_bc+0x21d>
  800b88:	48 b9 c0 77 80 00 00 	movabs $0x8077c0,%rcx
  800b8f:	00 00 00 
  800b92:	48 ba 75 77 80 00 00 	movabs $0x807775,%rdx
  800b99:	00 00 00 
  800b9c:	be 8e 00 00 00       	mov    $0x8e,%esi
  800ba1:	48 bf 5a 76 80 00 00 	movabs $0x80765a,%rdi
  800ba8:	00 00 00 
  800bab:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb0:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  800bb7:	00 00 00 
  800bba:	41 ff d0             	callq  *%r8

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  800bbd:	bf 01 00 00 00       	mov    $0x1,%edi
  800bc2:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800bc9:	00 00 00 
  800bcc:	ff d0                	callq  *%rax
  800bce:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  800bd5:	ba 08 01 00 00       	mov    $0x108,%edx
  800bda:	48 89 ce             	mov    %rcx,%rsi
  800bdd:	48 89 c7             	mov    %rax,%rdi
  800be0:	48 b8 4a 46 80 00 00 	movabs $0x80464a,%rax
  800be7:	00 00 00 
  800bea:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800bec:	bf 01 00 00 00       	mov    $0x1,%edi
  800bf1:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800bf8:	00 00 00 
  800bfb:	ff d0                	callq  *%rax
  800bfd:	48 89 c7             	mov    %rax,%rdi
  800c00:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  800c07:	00 00 00 
  800c0a:	ff d0                	callq  *%rax

	cprintf("block cache is good\n");
  800c0c:	48 bf e4 77 80 00 00 	movabs $0x8077e4,%rdi
  800c13:	00 00 00 
  800c16:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1b:	48 ba 71 37 80 00 00 	movabs $0x803771,%rdx
  800c22:	00 00 00 
  800c25:	ff d2                	callq  *%rdx
}
  800c27:	c9                   	leaveq 
  800c28:	c3                   	retq   

0000000000800c29 <bc_init>:

void
bc_init(void)
{
  800c29:	55                   	push   %rbp
  800c2a:	48 89 e5             	mov    %rsp,%rbp
  800c2d:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800c34:	48 bf f3 05 80 00 00 	movabs $0x8005f3,%rdi
  800c3b:	00 00 00 
  800c3e:	48 b8 35 50 80 00 00 	movabs $0x805035,%rax
  800c45:	00 00 00 
  800c48:	ff d0                	callq  *%rax
	check_bc();
  800c4a:	48 b8 a0 09 80 00 00 	movabs $0x8009a0,%rax
  800c51:	00 00 00 
  800c54:	ff d0                	callq  *%rax

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800c56:	bf 01 00 00 00       	mov    $0x1,%edi
  800c5b:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800c62:	00 00 00 
  800c65:	ff d0                	callq  *%rax
  800c67:	48 89 c1             	mov    %rax,%rcx
  800c6a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800c71:	ba 08 01 00 00       	mov    $0x108,%edx
  800c76:	48 89 ce             	mov    %rcx,%rsi
  800c79:	48 89 c7             	mov    %rax,%rdi
  800c7c:	48 b8 4a 46 80 00 00 	movabs $0x80464a,%rax
  800c83:	00 00 00 
  800c86:	ff d0                	callq  *%rax
}
  800c88:	c9                   	leaveq 
  800c89:	c3                   	retq   

0000000000800c8a <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  800c8a:	55                   	push   %rbp
  800c8b:	48 89 e5             	mov    %rsp,%rbp
	if (super->s_magic != FS_MAGIC)
  800c8e:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  800c95:	00 00 00 
  800c98:	48 8b 00             	mov    (%rax),%rax
  800c9b:	8b 00                	mov    (%rax),%eax
  800c9d:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  800ca2:	74 2a                	je     800cce <check_super+0x44>
		panic("bad file system magic number");
  800ca4:	48 ba f9 77 80 00 00 	movabs $0x8077f9,%rdx
  800cab:	00 00 00 
  800cae:	be 10 00 00 00       	mov    $0x10,%esi
  800cb3:	48 bf 16 78 80 00 00 	movabs $0x807816,%rdi
  800cba:	00 00 00 
  800cbd:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc2:	48 b9 38 35 80 00 00 	movabs $0x803538,%rcx
  800cc9:	00 00 00 
  800ccc:	ff d1                	callq  *%rcx

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800cce:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  800cd5:	00 00 00 
  800cd8:	48 8b 00             	mov    (%rax),%rax
  800cdb:	8b 40 04             	mov    0x4(%rax),%eax
  800cde:	3d 00 00 0c 00       	cmp    $0xc0000,%eax
  800ce3:	76 2a                	jbe    800d0f <check_super+0x85>
		panic("file system is too large");
  800ce5:	48 ba 1e 78 80 00 00 	movabs $0x80781e,%rdx
  800cec:	00 00 00 
  800cef:	be 13 00 00 00       	mov    $0x13,%esi
  800cf4:	48 bf 16 78 80 00 00 	movabs $0x807816,%rdi
  800cfb:	00 00 00 
  800cfe:	b8 00 00 00 00       	mov    $0x0,%eax
  800d03:	48 b9 38 35 80 00 00 	movabs $0x803538,%rcx
  800d0a:	00 00 00 
  800d0d:	ff d1                	callq  *%rcx

	cprintf("superblock is good\n");
  800d0f:	48 bf 37 78 80 00 00 	movabs $0x807837,%rdi
  800d16:	00 00 00 
  800d19:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1e:	48 ba 71 37 80 00 00 	movabs $0x803771,%rdx
  800d25:	00 00 00 
  800d28:	ff d2                	callq  *%rdx
}
  800d2a:	5d                   	pop    %rbp
  800d2b:	c3                   	retq   

0000000000800d2c <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800d2c:	55                   	push   %rbp
  800d2d:	48 89 e5             	mov    %rsp,%rbp
  800d30:	48 83 ec 04          	sub    $0x4,%rsp
  800d34:	89 7d fc             	mov    %edi,-0x4(%rbp)
	if (super == 0 || blockno >= super->s_nblocks)
  800d37:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  800d3e:	00 00 00 
  800d41:	48 8b 00             	mov    (%rax),%rax
  800d44:	48 85 c0             	test   %rax,%rax
  800d47:	74 15                	je     800d5e <block_is_free+0x32>
  800d49:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  800d50:	00 00 00 
  800d53:	48 8b 00             	mov    (%rax),%rax
  800d56:	8b 40 04             	mov    0x4(%rax),%eax
  800d59:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800d5c:	77 07                	ja     800d65 <block_is_free+0x39>
		return 0;
  800d5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d63:	eb 41                	jmp    800da6 <block_is_free+0x7a>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  800d65:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
  800d6c:	00 00 00 
  800d6f:	48 8b 00             	mov    (%rax),%rax
  800d72:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d75:	c1 ea 05             	shr    $0x5,%edx
  800d78:	89 d2                	mov    %edx,%edx
  800d7a:	48 c1 e2 02          	shl    $0x2,%rdx
  800d7e:	48 01 d0             	add    %rdx,%rax
  800d81:	8b 10                	mov    (%rax),%edx
  800d83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d86:	83 e0 1f             	and    $0x1f,%eax
  800d89:	be 01 00 00 00       	mov    $0x1,%esi
  800d8e:	89 c1                	mov    %eax,%ecx
  800d90:	d3 e6                	shl    %cl,%esi
  800d92:	89 f0                	mov    %esi,%eax
  800d94:	21 d0                	and    %edx,%eax
  800d96:	85 c0                	test   %eax,%eax
  800d98:	74 07                	je     800da1 <block_is_free+0x75>
		return 1;
  800d9a:	b8 01 00 00 00       	mov    $0x1,%eax
  800d9f:	eb 05                	jmp    800da6 <block_is_free+0x7a>
	return 0;
  800da1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da6:	c9                   	leaveq 
  800da7:	c3                   	retq   

0000000000800da8 <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800da8:	55                   	push   %rbp
  800da9:	48 89 e5             	mov    %rsp,%rbp
  800dac:	48 83 ec 10          	sub    $0x10,%rsp
  800db0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  800db3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800db7:	75 2a                	jne    800de3 <free_block+0x3b>
		panic("attempt to free zero block");
  800db9:	48 ba 4b 78 80 00 00 	movabs $0x80784b,%rdx
  800dc0:	00 00 00 
  800dc3:	be 2e 00 00 00       	mov    $0x2e,%esi
  800dc8:	48 bf 16 78 80 00 00 	movabs $0x807816,%rdi
  800dcf:	00 00 00 
  800dd2:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd7:	48 b9 38 35 80 00 00 	movabs $0x803538,%rcx
  800dde:	00 00 00 
  800de1:	ff d1                	callq  *%rcx
	bitmap[blockno/32] |= 1<<(blockno%32);
  800de3:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
  800dea:	00 00 00 
  800ded:	48 8b 10             	mov    (%rax),%rdx
  800df0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800df3:	c1 e8 05             	shr    $0x5,%eax
  800df6:	89 c1                	mov    %eax,%ecx
  800df8:	48 c1 e1 02          	shl    $0x2,%rcx
  800dfc:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  800e00:	48 ba 10 60 81 00 00 	movabs $0x816010,%rdx
  800e07:	00 00 00 
  800e0a:	48 8b 12             	mov    (%rdx),%rdx
  800e0d:	89 c0                	mov    %eax,%eax
  800e0f:	48 c1 e0 02          	shl    $0x2,%rax
  800e13:	48 01 d0             	add    %rdx,%rax
  800e16:	8b 10                	mov    (%rax),%edx
  800e18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e1b:	83 e0 1f             	and    $0x1f,%eax
  800e1e:	bf 01 00 00 00       	mov    $0x1,%edi
  800e23:	89 c1                	mov    %eax,%ecx
  800e25:	d3 e7                	shl    %cl,%edi
  800e27:	89 f8                	mov    %edi,%eax
  800e29:	09 d0                	or     %edx,%eax
  800e2b:	89 06                	mov    %eax,(%rsi)
}
  800e2d:	c9                   	leaveq 
  800e2e:	c3                   	retq   

0000000000800e2f <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  800e2f:	55                   	push   %rbp
  800e30:	48 89 e5             	mov    %rsp,%rbp
  800e33:	48 83 ec 10          	sub    $0x10,%rsp
	// The bitmap consists of one or more blocks.  A single bitmap block
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.


	int i = 0, j;
  800e37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	static int lastalloc;

	for (i = 0; i < super->s_nblocks; i++) {
  800e3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e45:	e9 ee 00 00 00       	jmpq   800f38 <alloc_block+0x109>
		j = (lastalloc+i)%super->s_nblocks;
  800e4a:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  800e51:	00 00 00 
  800e54:	8b 10                	mov    (%rax),%edx
  800e56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e59:	01 d0                	add    %edx,%eax
  800e5b:	48 ba 18 60 81 00 00 	movabs $0x816018,%rdx
  800e62:	00 00 00 
  800e65:	48 8b 12             	mov    (%rdx),%rdx
  800e68:	8b 4a 04             	mov    0x4(%rdx),%ecx
  800e6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e70:	f7 f1                	div    %ecx
  800e72:	89 d0                	mov    %edx,%eax
  800e74:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (block_is_free(j)) {
  800e77:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800e7a:	89 c7                	mov    %eax,%edi
  800e7c:	48 b8 2c 0d 80 00 00 	movabs $0x800d2c,%rax
  800e83:	00 00 00 
  800e86:	ff d0                	callq  *%rax
  800e88:	84 c0                	test   %al,%al
  800e8a:	0f 84 a4 00 00 00    	je     800f34 <alloc_block+0x105>
			bitmap[j/32] &= ~(1<<(j%32));
  800e90:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
  800e97:	00 00 00 
  800e9a:	48 8b 10             	mov    (%rax),%rdx
  800e9d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800ea0:	8d 48 1f             	lea    0x1f(%rax),%ecx
  800ea3:	85 c0                	test   %eax,%eax
  800ea5:	0f 48 c1             	cmovs  %ecx,%eax
  800ea8:	c1 f8 05             	sar    $0x5,%eax
  800eab:	48 63 c8             	movslq %eax,%rcx
  800eae:	48 c1 e1 02          	shl    $0x2,%rcx
  800eb2:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  800eb6:	48 ba 10 60 81 00 00 	movabs $0x816010,%rdx
  800ebd:	00 00 00 
  800ec0:	48 8b 12             	mov    (%rdx),%rdx
  800ec3:	48 98                	cltq   
  800ec5:	48 c1 e0 02          	shl    $0x2,%rax
  800ec9:	48 01 d0             	add    %rdx,%rax
  800ecc:	8b 38                	mov    (%rax),%edi
  800ece:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800ed1:	99                   	cltd   
  800ed2:	c1 ea 1b             	shr    $0x1b,%edx
  800ed5:	01 d0                	add    %edx,%eax
  800ed7:	83 e0 1f             	and    $0x1f,%eax
  800eda:	29 d0                	sub    %edx,%eax
  800edc:	ba 01 00 00 00       	mov    $0x1,%edx
  800ee1:	89 c1                	mov    %eax,%ecx
  800ee3:	d3 e2                	shl    %cl,%edx
  800ee5:	89 d0                	mov    %edx,%eax
  800ee7:	f7 d0                	not    %eax
  800ee9:	21 f8                	and    %edi,%eax
  800eeb:	89 06                	mov    %eax,(%rsi)
			flush_block(&bitmap[j/32]);
  800eed:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
  800ef4:	00 00 00 
  800ef7:	48 8b 10             	mov    (%rax),%rdx
  800efa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800efd:	8d 48 1f             	lea    0x1f(%rax),%ecx
  800f00:	85 c0                	test   %eax,%eax
  800f02:	0f 48 c1             	cmovs  %ecx,%eax
  800f05:	c1 f8 05             	sar    $0x5,%eax
  800f08:	48 98                	cltq   
  800f0a:	48 c1 e0 02          	shl    $0x2,%rax
  800f0e:	48 01 d0             	add    %rdx,%rax
  800f11:	48 89 c7             	mov    %rax,%rdi
  800f14:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  800f1b:	00 00 00 
  800f1e:	ff d0                	callq  *%rax
			lastalloc = j;
  800f20:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  800f27:	00 00 00 
  800f2a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800f2d:	89 10                	mov    %edx,(%rax)
			return j;
  800f2f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800f32:	eb 24                	jmp    800f58 <alloc_block+0x129>


	int i = 0, j;
	static int lastalloc;

	for (i = 0; i < super->s_nblocks; i++) {
  800f34:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800f38:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f3b:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  800f42:	00 00 00 
  800f45:	48 8b 00             	mov    (%rax),%rax
  800f48:	8b 40 04             	mov    0x4(%rax),%eax
  800f4b:	39 c2                	cmp    %eax,%edx
  800f4d:	0f 82 f7 fe ff ff    	jb     800e4a <alloc_block+0x1b>
			lastalloc = j;
			return j;
		}
	}

	return -E_NO_DISK;
  800f53:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800f58:	c9                   	leaveq 
  800f59:	c3                   	retq   

0000000000800f5a <check_bitmap>:
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
  800f5a:	55                   	push   %rbp
  800f5b:	48 89 e5             	mov    %rsp,%rbp
  800f5e:	48 83 ec 10          	sub    $0x10,%rsp
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800f62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f69:	eb 51                	jmp    800fbc <check_bitmap+0x62>
		assert(!block_is_free(2+i));
  800f6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f6e:	83 c0 02             	add    $0x2,%eax
  800f71:	89 c7                	mov    %eax,%edi
  800f73:	48 b8 2c 0d 80 00 00 	movabs $0x800d2c,%rax
  800f7a:	00 00 00 
  800f7d:	ff d0                	callq  *%rax
  800f7f:	84 c0                	test   %al,%al
  800f81:	74 35                	je     800fb8 <check_bitmap+0x5e>
  800f83:	48 b9 66 78 80 00 00 	movabs $0x807866,%rcx
  800f8a:	00 00 00 
  800f8d:	48 ba 7a 78 80 00 00 	movabs $0x80787a,%rdx
  800f94:	00 00 00 
  800f97:	be 5d 00 00 00       	mov    $0x5d,%esi
  800f9c:	48 bf 16 78 80 00 00 	movabs $0x807816,%rdi
  800fa3:	00 00 00 
  800fa6:	b8 00 00 00 00       	mov    $0x0,%eax
  800fab:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  800fb2:	00 00 00 
  800fb5:	41 ff d0             	callq  *%r8
check_bitmap(void)
{
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800fb8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800fbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fbf:	c1 e0 0f             	shl    $0xf,%eax
  800fc2:	89 c2                	mov    %eax,%edx
  800fc4:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  800fcb:	00 00 00 
  800fce:	48 8b 00             	mov    (%rax),%rax
  800fd1:	8b 40 04             	mov    0x4(%rax),%eax
  800fd4:	39 c2                	cmp    %eax,%edx
  800fd6:	72 93                	jb     800f6b <check_bitmap+0x11>
		assert(!block_is_free(2+i));

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  800fd8:	bf 00 00 00 00       	mov    $0x0,%edi
  800fdd:	48 b8 2c 0d 80 00 00 	movabs $0x800d2c,%rax
  800fe4:	00 00 00 
  800fe7:	ff d0                	callq  *%rax
  800fe9:	84 c0                	test   %al,%al
  800feb:	74 35                	je     801022 <check_bitmap+0xc8>
  800fed:	48 b9 8f 78 80 00 00 	movabs $0x80788f,%rcx
  800ff4:	00 00 00 
  800ff7:	48 ba 7a 78 80 00 00 	movabs $0x80787a,%rdx
  800ffe:	00 00 00 
  801001:	be 60 00 00 00       	mov    $0x60,%esi
  801006:	48 bf 16 78 80 00 00 	movabs $0x807816,%rdi
  80100d:	00 00 00 
  801010:	b8 00 00 00 00       	mov    $0x0,%eax
  801015:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  80101c:	00 00 00 
  80101f:	41 ff d0             	callq  *%r8
	assert(!block_is_free(1));
  801022:	bf 01 00 00 00       	mov    $0x1,%edi
  801027:	48 b8 2c 0d 80 00 00 	movabs $0x800d2c,%rax
  80102e:	00 00 00 
  801031:	ff d0                	callq  *%rax
  801033:	84 c0                	test   %al,%al
  801035:	74 35                	je     80106c <check_bitmap+0x112>
  801037:	48 b9 a1 78 80 00 00 	movabs $0x8078a1,%rcx
  80103e:	00 00 00 
  801041:	48 ba 7a 78 80 00 00 	movabs $0x80787a,%rdx
  801048:	00 00 00 
  80104b:	be 61 00 00 00       	mov    $0x61,%esi
  801050:	48 bf 16 78 80 00 00 	movabs $0x807816,%rdi
  801057:	00 00 00 
  80105a:	b8 00 00 00 00       	mov    $0x0,%eax
  80105f:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  801066:	00 00 00 
  801069:	41 ff d0             	callq  *%r8

	cprintf("bitmap is good\n");
  80106c:	48 bf b3 78 80 00 00 	movabs $0x8078b3,%rdi
  801073:	00 00 00 
  801076:	b8 00 00 00 00       	mov    $0x0,%eax
  80107b:	48 ba 71 37 80 00 00 	movabs $0x803771,%rdx
  801082:	00 00 00 
  801085:	ff d2                	callq  *%rdx
}
  801087:	c9                   	leaveq 
  801088:	c3                   	retq   

0000000000801089 <fs_init>:


// Initialize the file system
void
fs_init(void)
{
  801089:	55                   	push   %rbp
  80108a:	48 89 e5             	mov    %rsp,%rbp
	if (ide_probe_disk1())
		ide_set_disk(1);
	else
		ide_set_disk(0);
#else
	host_ipc_init();
  80108d:	b8 00 00 00 00       	mov    $0x0,%eax
  801092:	48 ba 61 33 80 00 00 	movabs $0x803361,%rdx
  801099:	00 00 00 
  80109c:	ff d2                	callq  *%rdx
#endif



	bc_init();
  80109e:	48 b8 29 0c 80 00 00 	movabs $0x800c29,%rax
  8010a5:	00 00 00 
  8010a8:	ff d0                	callq  *%rax

	// Set "super" to point to the super block.
	super = diskaddr(1);
  8010aa:	bf 01 00 00 00       	mov    $0x1,%edi
  8010af:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8010b6:	00 00 00 
  8010b9:	ff d0                	callq  *%rax
  8010bb:	48 ba 18 60 81 00 00 	movabs $0x816018,%rdx
  8010c2:	00 00 00 
  8010c5:	48 89 02             	mov    %rax,(%rdx)
	check_super();
  8010c8:	48 b8 8a 0c 80 00 00 	movabs $0x800c8a,%rax
  8010cf:	00 00 00 
  8010d2:	ff d0                	callq  *%rax

	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  8010d4:	bf 02 00 00 00       	mov    $0x2,%edi
  8010d9:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8010e0:	00 00 00 
  8010e3:	ff d0                	callq  *%rax
  8010e5:	48 ba 10 60 81 00 00 	movabs $0x816010,%rdx
  8010ec:	00 00 00 
  8010ef:	48 89 02             	mov    %rax,(%rdx)
	check_bitmap();
  8010f2:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  8010f9:	00 00 00 
  8010fc:	ff d0                	callq  *%rax
}
  8010fe:	5d                   	pop    %rbp
  8010ff:	c3                   	retq   

0000000000801100 <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  801100:	55                   	push   %rbp
  801101:	48 89 e5             	mov    %rsp,%rbp
  801104:	48 83 ec 30          	sub    $0x30,%rsp
  801108:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80110c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80110f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801113:	89 c8                	mov    %ecx,%eax
  801115:	88 45 e0             	mov    %al,-0x20(%rbp)

	int r;
	uint32_t *ptr;
	char *blk;

	if (filebno < NDIRECT)
  801118:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  80111c:	77 23                	ja     801141 <file_block_walk+0x41>
		ptr = &f->f_direct[filebno];
  80111e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801121:	48 83 c0 20          	add    $0x20,%rax
  801125:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  80112c:	00 
  80112d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801131:	48 01 d0             	add    %rdx,%rax
  801134:	48 83 c0 08          	add    $0x8,%rax
  801138:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80113c:	e9 bd 00 00 00       	jmpq   8011fe <file_block_walk+0xfe>
	else if (filebno < NDIRECT + NINDIRECT) {
  801141:	81 7d e4 09 04 00 00 	cmpl   $0x409,-0x1c(%rbp)
  801148:	0f 87 a9 00 00 00    	ja     8011f7 <file_block_walk+0xf7>
		if (f->f_indirect == 0) {
  80114e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801152:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801158:	85 c0                	test   %eax,%eax
  80115a:	75 6c                	jne    8011c8 <file_block_walk+0xc8>
			if (alloc == 0)
  80115c:	0f b6 45 e0          	movzbl -0x20(%rbp),%eax
  801160:	83 f0 01             	xor    $0x1,%eax
  801163:	84 c0                	test   %al,%al
  801165:	74 0a                	je     801171 <file_block_walk+0x71>
				return -E_NOT_FOUND;
  801167:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  80116c:	e9 9d 00 00 00       	jmpq   80120e <file_block_walk+0x10e>
			if ((r = alloc_block()) < 0)
  801171:	48 b8 2f 0e 80 00 00 	movabs $0x800e2f,%rax
  801178:	00 00 00 
  80117b:	ff d0                	callq  *%rax
  80117d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801180:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801184:	79 08                	jns    80118e <file_block_walk+0x8e>
				return r;
  801186:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801189:	e9 80 00 00 00       	jmpq   80120e <file_block_walk+0x10e>
			f->f_indirect = r;
  80118e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801191:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801195:	89 90 b0 00 00 00    	mov    %edx,0xb0(%rax)
			memset(diskaddr(r), 0, BLKSIZE);
  80119b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80119e:	48 98                	cltq   
  8011a0:	48 89 c7             	mov    %rax,%rdi
  8011a3:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8011aa:	00 00 00 
  8011ad:	ff d0                	callq  *%rax
  8011af:	ba 00 10 00 00       	mov    $0x1000,%edx
  8011b4:	be 00 00 00 00       	mov    $0x0,%esi
  8011b9:	48 89 c7             	mov    %rax,%rdi
  8011bc:	48 b8 bf 45 80 00 00 	movabs $0x8045bf,%rax
  8011c3:	00 00 00 
  8011c6:	ff d0                	callq  *%rax
		}
		ptr = (uint32_t*)diskaddr(f->f_indirect) + filebno - NDIRECT;
  8011c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011cc:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  8011d2:	89 c0                	mov    %eax,%eax
  8011d4:	48 89 c7             	mov    %rax,%rdi
  8011d7:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8011de:	00 00 00 
  8011e1:	ff d0                	callq  *%rax
  8011e3:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8011e6:	48 c1 e2 02          	shl    $0x2,%rdx
  8011ea:	48 83 ea 28          	sub    $0x28,%rdx
  8011ee:	48 01 d0             	add    %rdx,%rax
  8011f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8011f5:	eb 07                	jmp    8011fe <file_block_walk+0xfe>
	} else
		return -E_INVAL;
  8011f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011fc:	eb 10                	jmp    80120e <file_block_walk+0x10e>

	*ppdiskbno = ptr;
  8011fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801202:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801206:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801209:	b8 00 00 00 00       	mov    $0x0,%eax

}
  80120e:	c9                   	leaveq 
  80120f:	c3                   	retq   

0000000000801210 <file_get_block>:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_INVAL if filebno is out of range.
//
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  801210:	55                   	push   %rbp
  801211:	48 89 e5             	mov    %rsp,%rbp
  801214:	48 83 ec 30          	sub    $0x30,%rsp
  801218:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80121c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80121f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 1)) < 0)
  801223:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801227:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80122a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122e:	b9 01 00 00 00       	mov    $0x1,%ecx
  801233:	48 89 c7             	mov    %rax,%rdi
  801236:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  80123d:	00 00 00 
  801240:	ff d0                	callq  *%rax
  801242:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801245:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801249:	79 05                	jns    801250 <file_get_block+0x40>
		return r;
  80124b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80124e:	eb 50                	jmp    8012a0 <file_get_block+0x90>
	if (*ptr == 0) {
  801250:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801254:	8b 00                	mov    (%rax),%eax
  801256:	85 c0                	test   %eax,%eax
  801258:	75 23                	jne    80127d <file_get_block+0x6d>
		if ((r = alloc_block()) < 0)
  80125a:	48 b8 2f 0e 80 00 00 	movabs $0x800e2f,%rax
  801261:	00 00 00 
  801264:	ff d0                	callq  *%rax
  801266:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801269:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80126d:	79 05                	jns    801274 <file_get_block+0x64>
			return r;
  80126f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801272:	eb 2c                	jmp    8012a0 <file_get_block+0x90>
		*ptr = r;
  801274:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801278:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80127b:	89 10                	mov    %edx,(%rax)
	}
	*blk = diskaddr(*ptr);
  80127d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801281:	8b 00                	mov    (%rax),%eax
  801283:	89 c0                	mov    %eax,%eax
  801285:	48 89 c7             	mov    %rax,%rdi
  801288:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  80128f:	00 00 00 
  801292:	ff d0                	callq  *%rax
  801294:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801298:	48 89 02             	mov    %rax,(%rdx)
	return 0;
  80129b:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8012a0:	c9                   	leaveq 
  8012a1:	c3                   	retq   

00000000008012a2 <dir_lookup>:
//
// Returns 0 and sets *file on success, < 0 on error.  Errors are:
//	-E_NOT_FOUND if the file is not found
static int
dir_lookup(struct File *dir, const char *name, struct File **file)
{
  8012a2:	55                   	push   %rbp
  8012a3:	48 89 e5             	mov    %rsp,%rbp
  8012a6:	48 83 ec 40          	sub    $0x40,%rsp
  8012aa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8012ae:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8012b2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  8012b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ba:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8012c0:	25 ff 0f 00 00       	and    $0xfff,%eax
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	74 35                	je     8012fe <dir_lookup+0x5c>
  8012c9:	48 b9 c3 78 80 00 00 	movabs $0x8078c3,%rcx
  8012d0:	00 00 00 
  8012d3:	48 ba 7a 78 80 00 00 	movabs $0x80787a,%rdx
  8012da:	00 00 00 
  8012dd:	be e3 00 00 00       	mov    $0xe3,%esi
  8012e2:	48 bf 16 78 80 00 00 	movabs $0x807816,%rdi
  8012e9:	00 00 00 
  8012ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f1:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  8012f8:	00 00 00 
  8012fb:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  8012fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801302:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801308:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  80130e:	85 c0                	test   %eax,%eax
  801310:	0f 48 c2             	cmovs  %edx,%eax
  801313:	c1 f8 0c             	sar    $0xc,%eax
  801316:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  801319:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801320:	e9 93 00 00 00       	jmpq   8013b8 <dir_lookup+0x116>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801325:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  801329:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80132c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801330:	89 ce                	mov    %ecx,%esi
  801332:	48 89 c7             	mov    %rax,%rdi
  801335:	48 b8 10 12 80 00 00 	movabs $0x801210,%rax
  80133c:	00 00 00 
  80133f:	ff d0                	callq  *%rax
  801341:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801344:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801348:	79 05                	jns    80134f <dir_lookup+0xad>
			return r;
  80134a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80134d:	eb 7a                	jmp    8013c9 <dir_lookup+0x127>
		f = (struct File*) blk;
  80134f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801353:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  801357:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  80135e:	eb 4e                	jmp    8013ae <dir_lookup+0x10c>
			if (strcmp(f[j].f_name, name) == 0) {
  801360:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801363:	48 c1 e0 08          	shl    $0x8,%rax
  801367:	48 89 c2             	mov    %rax,%rdx
  80136a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136e:	48 01 d0             	add    %rdx,%rax
  801371:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801375:	48 89 d6             	mov    %rdx,%rsi
  801378:	48 89 c7             	mov    %rax,%rdi
  80137b:	48 b8 88 44 80 00 00 	movabs $0x804488,%rax
  801382:	00 00 00 
  801385:	ff d0                	callq  *%rax
  801387:	85 c0                	test   %eax,%eax
  801389:	75 1f                	jne    8013aa <dir_lookup+0x108>
				*file = &f[j];
  80138b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80138e:	48 c1 e0 08          	shl    $0x8,%rax
  801392:	48 89 c2             	mov    %rax,%rdx
  801395:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801399:	48 01 c2             	add    %rax,%rdx
  80139c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013a0:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  8013a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a8:	eb 1f                	jmp    8013c9 <dir_lookup+0x127>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  8013aa:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8013ae:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  8013b2:	76 ac                	jbe    801360 <dir_lookup+0xbe>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  8013b4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8013b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013bb:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8013be:	0f 82 61 ff ff ff    	jb     801325 <dir_lookup+0x83>
			if (strcmp(f[j].f_name, name) == 0) {
				*file = &f[j];
				return 0;
			}
	}
	return -E_NOT_FOUND;
  8013c4:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
}
  8013c9:	c9                   	leaveq 
  8013ca:	c3                   	retq   

00000000008013cb <dir_alloc_file>:

// Set *file to point at a free File structure in dir.  The caller is
// responsible for filling in the File fields.
static int
dir_alloc_file(struct File *dir, struct File **file)
{
  8013cb:	55                   	push   %rbp
  8013cc:	48 89 e5             	mov    %rsp,%rbp
  8013cf:	48 83 ec 30          	sub    $0x30,%rsp
  8013d3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013d7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  8013db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013df:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8013e5:	25 ff 0f 00 00       	and    $0xfff,%eax
  8013ea:	85 c0                	test   %eax,%eax
  8013ec:	74 35                	je     801423 <dir_alloc_file+0x58>
  8013ee:	48 b9 c3 78 80 00 00 	movabs $0x8078c3,%rcx
  8013f5:	00 00 00 
  8013f8:	48 ba 7a 78 80 00 00 	movabs $0x80787a,%rdx
  8013ff:	00 00 00 
  801402:	be fc 00 00 00       	mov    $0xfc,%esi
  801407:	48 bf 16 78 80 00 00 	movabs $0x807816,%rdi
  80140e:	00 00 00 
  801411:	b8 00 00 00 00       	mov    $0x0,%eax
  801416:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  80141d:	00 00 00 
  801420:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  801423:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801427:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  80142d:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801433:	85 c0                	test   %eax,%eax
  801435:	0f 48 c2             	cmovs  %edx,%eax
  801438:	c1 f8 0c             	sar    $0xc,%eax
  80143b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  80143e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801445:	e9 83 00 00 00       	jmpq   8014cd <dir_alloc_file+0x102>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  80144a:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80144e:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801451:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801455:	89 ce                	mov    %ecx,%esi
  801457:	48 89 c7             	mov    %rax,%rdi
  80145a:	48 b8 10 12 80 00 00 	movabs $0x801210,%rax
  801461:	00 00 00 
  801464:	ff d0                	callq  *%rax
  801466:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801469:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80146d:	79 08                	jns    801477 <dir_alloc_file+0xac>
			return r;
  80146f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801472:	e9 be 00 00 00       	jmpq   801535 <dir_alloc_file+0x16a>
		f = (struct File*) blk;
  801477:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80147b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  80147f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  801486:	eb 3b                	jmp    8014c3 <dir_alloc_file+0xf8>
			if (f[j].f_name[0] == '\0') {
  801488:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80148b:	48 c1 e0 08          	shl    $0x8,%rax
  80148f:	48 89 c2             	mov    %rax,%rdx
  801492:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801496:	48 01 d0             	add    %rdx,%rax
  801499:	0f b6 00             	movzbl (%rax),%eax
  80149c:	84 c0                	test   %al,%al
  80149e:	75 1f                	jne    8014bf <dir_alloc_file+0xf4>
				*file = &f[j];
  8014a0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014a3:	48 c1 e0 08          	shl    $0x8,%rax
  8014a7:	48 89 c2             	mov    %rax,%rdx
  8014aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ae:	48 01 c2             	add    %rax,%rdx
  8014b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014b5:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  8014b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bd:	eb 76                	jmp    801535 <dir_alloc_file+0x16a>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  8014bf:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8014c3:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  8014c7:	76 bf                	jbe    801488 <dir_alloc_file+0xbd>
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  8014c9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8014cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014d0:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8014d3:	0f 82 71 ff ff ff    	jb     80144a <dir_alloc_file+0x7f>
			if (f[j].f_name[0] == '\0') {
				*file = &f[j];
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
  8014d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014dd:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8014e3:	8d 90 00 10 00 00    	lea    0x1000(%rax),%edx
  8014e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ed:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	if ((r = file_get_block(dir, i, &blk)) < 0)
  8014f3:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  8014f7:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8014fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fe:	89 ce                	mov    %ecx,%esi
  801500:	48 89 c7             	mov    %rax,%rdi
  801503:	48 b8 10 12 80 00 00 	movabs $0x801210,%rax
  80150a:	00 00 00 
  80150d:	ff d0                	callq  *%rax
  80150f:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801512:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801516:	79 05                	jns    80151d <dir_alloc_file+0x152>
		return r;
  801518:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80151b:	eb 18                	jmp    801535 <dir_alloc_file+0x16a>
	f = (struct File*) blk;
  80151d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801521:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	*file = &f[0];
  801525:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801529:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80152d:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801530:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801535:	c9                   	leaveq 
  801536:	c3                   	retq   

0000000000801537 <skip_slash>:

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
  801537:	55                   	push   %rbp
  801538:	48 89 e5             	mov    %rsp,%rbp
  80153b:	48 83 ec 08          	sub    $0x8,%rsp
  80153f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	while (*p == '/')
  801543:	eb 05                	jmp    80154a <skip_slash+0x13>
		p++;
  801545:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  80154a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154e:	0f b6 00             	movzbl (%rax),%eax
  801551:	3c 2f                	cmp    $0x2f,%al
  801553:	74 f0                	je     801545 <skip_slash+0xe>
		p++;
	return p;
  801555:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801559:	c9                   	leaveq 
  80155a:	c3                   	retq   

000000000080155b <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  80155b:	55                   	push   %rbp
  80155c:	48 89 e5             	mov    %rsp,%rbp
  80155f:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  801566:	48 89 bd 48 ff ff ff 	mov    %rdi,-0xb8(%rbp)
  80156d:	48 89 b5 40 ff ff ff 	mov    %rsi,-0xc0(%rbp)
  801574:	48 89 95 38 ff ff ff 	mov    %rdx,-0xc8(%rbp)
  80157b:	48 89 8d 30 ff ff ff 	mov    %rcx,-0xd0(%rbp)
	struct File *dir, *f;
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
  801582:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801589:	48 89 c7             	mov    %rax,%rdi
  80158c:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  801593:	00 00 00 
  801596:	ff d0                	callq  *%rax
  801598:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	f = &super->s_root;
  80159f:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  8015a6:	00 00 00 
  8015a9:	48 8b 00             	mov    (%rax),%rax
  8015ac:	48 83 c0 08          	add    $0x8,%rax
  8015b0:	48 89 85 58 ff ff ff 	mov    %rax,-0xa8(%rbp)
	dir = 0;
  8015b7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8015be:	00 
	name[0] = 0;
  8015bf:	c6 85 60 ff ff ff 00 	movb   $0x0,-0xa0(%rbp)

	if (pdir)
  8015c6:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  8015cd:	00 
  8015ce:	74 0e                	je     8015de <walk_path+0x83>
		*pdir = 0;
  8015d0:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  8015d7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*pf = 0;
  8015de:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8015e5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	while (*path != '\0') {
  8015ec:	e9 73 01 00 00       	jmpq   801764 <walk_path+0x209>
		dir = f;
  8015f1:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8015f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		p = path;
  8015fc:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801603:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		while (*path != '/' && *path != '\0')
  801607:	eb 08                	jmp    801611 <walk_path+0xb6>
			path++;
  801609:	48 83 85 48 ff ff ff 	addq   $0x1,-0xb8(%rbp)
  801610:	01 
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  801611:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801618:	0f b6 00             	movzbl (%rax),%eax
  80161b:	3c 2f                	cmp    $0x2f,%al
  80161d:	74 0e                	je     80162d <walk_path+0xd2>
  80161f:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801626:	0f b6 00             	movzbl (%rax),%eax
  801629:	84 c0                	test   %al,%al
  80162b:	75 dc                	jne    801609 <walk_path+0xae>
			path++;
		if (path - p >= MAXNAMELEN)
  80162d:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801634:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801638:	48 29 c2             	sub    %rax,%rdx
  80163b:	48 89 d0             	mov    %rdx,%rax
  80163e:	48 83 f8 7f          	cmp    $0x7f,%rax
  801642:	7e 0a                	jle    80164e <walk_path+0xf3>
			return -E_BAD_PATH;
  801644:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801649:	e9 56 01 00 00       	jmpq   8017a4 <walk_path+0x249>
		memmove(name, p, path - p);
  80164e:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801655:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801659:	48 29 c2             	sub    %rax,%rdx
  80165c:	48 89 d0             	mov    %rdx,%rax
  80165f:	48 89 c2             	mov    %rax,%rdx
  801662:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801666:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
  80166d:	48 89 ce             	mov    %rcx,%rsi
  801670:	48 89 c7             	mov    %rax,%rdi
  801673:	48 b8 4a 46 80 00 00 	movabs $0x80464a,%rax
  80167a:	00 00 00 
  80167d:	ff d0                	callq  *%rax
		name[path - p] = '\0';
  80167f:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801686:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80168a:	48 29 c2             	sub    %rax,%rdx
  80168d:	48 89 d0             	mov    %rdx,%rax
  801690:	c6 84 05 60 ff ff ff 	movb   $0x0,-0xa0(%rbp,%rax,1)
  801697:	00 
		path = skip_slash(path);
  801698:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80169f:	48 89 c7             	mov    %rax,%rdi
  8016a2:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  8016a9:	00 00 00 
  8016ac:	ff d0                	callq  *%rax
  8016ae:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)

		if (dir->f_type != FTYPE_DIR)
  8016b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b9:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  8016bf:	83 f8 01             	cmp    $0x1,%eax
  8016c2:	74 0a                	je     8016ce <walk_path+0x173>
			return -E_NOT_FOUND;
  8016c4:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8016c9:	e9 d6 00 00 00       	jmpq   8017a4 <walk_path+0x249>

		if ((r = dir_lookup(dir, name, &f)) < 0) {
  8016ce:	48 8d 95 58 ff ff ff 	lea    -0xa8(%rbp),%rdx
  8016d5:	48 8d 8d 60 ff ff ff 	lea    -0xa0(%rbp),%rcx
  8016dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e0:	48 89 ce             	mov    %rcx,%rsi
  8016e3:	48 89 c7             	mov    %rax,%rdi
  8016e6:	48 b8 a2 12 80 00 00 	movabs $0x8012a2,%rax
  8016ed:	00 00 00 
  8016f0:	ff d0                	callq  *%rax
  8016f2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8016f9:	79 69                	jns    801764 <walk_path+0x209>
			if (r == -E_NOT_FOUND && *path == '\0') {
  8016fb:	83 7d ec f4          	cmpl   $0xfffffff4,-0x14(%rbp)
  8016ff:	75 5e                	jne    80175f <walk_path+0x204>
  801701:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801708:	0f b6 00             	movzbl (%rax),%eax
  80170b:	84 c0                	test   %al,%al
  80170d:	75 50                	jne    80175f <walk_path+0x204>
				if (pdir)
  80170f:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  801716:	00 
  801717:	74 0e                	je     801727 <walk_path+0x1cc>
					*pdir = dir;
  801719:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  801720:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801724:	48 89 10             	mov    %rdx,(%rax)
				if (lastelem)
  801727:	48 83 bd 30 ff ff ff 	cmpq   $0x0,-0xd0(%rbp)
  80172e:	00 
  80172f:	74 20                	je     801751 <walk_path+0x1f6>
					strcpy(lastelem, name);
  801731:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  801738:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
  80173f:	48 89 d6             	mov    %rdx,%rsi
  801742:	48 89 c7             	mov    %rax,%rdi
  801745:	48 b8 26 43 80 00 00 	movabs $0x804326,%rax
  80174c:	00 00 00 
  80174f:	ff d0                	callq  *%rax
				*pf = 0;
  801751:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  801758:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
			}
			return r;
  80175f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801762:	eb 40                	jmp    8017a4 <walk_path+0x249>
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  801764:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80176b:	0f b6 00             	movzbl (%rax),%eax
  80176e:	84 c0                	test   %al,%al
  801770:	0f 85 7b fe ff ff    	jne    8015f1 <walk_path+0x96>
			}
			return r;
		}
	}

	if (pdir)
  801776:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  80177d:	00 
  80177e:	74 0e                	je     80178e <walk_path+0x233>
		*pdir = dir;
  801780:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  801787:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80178b:	48 89 10             	mov    %rdx,(%rax)
	*pf = f;
  80178e:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  801795:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  80179c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80179f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a4:	c9                   	leaveq 
  8017a5:	c3                   	retq   

00000000008017a6 <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  8017a6:	55                   	push   %rbp
  8017a7:	48 89 e5             	mov    %rsp,%rbp
  8017aa:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8017b1:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  8017b8:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  8017bf:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  8017c6:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  8017cd:	48 8d b5 68 ff ff ff 	lea    -0x98(%rbp),%rsi
  8017d4:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8017db:	48 89 c7             	mov    %rax,%rdi
  8017de:	48 b8 5b 15 80 00 00 	movabs $0x80155b,%rax
  8017e5:	00 00 00 
  8017e8:	ff d0                	callq  *%rax
  8017ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8017ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017f1:	75 0a                	jne    8017fd <file_create+0x57>
		return -E_FILE_EXISTS;
  8017f3:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8017f8:	e9 91 00 00 00       	jmpq   80188e <file_create+0xe8>
	if (r != -E_NOT_FOUND || dir == 0)
  8017fd:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  801801:	75 0c                	jne    80180f <file_create+0x69>
  801803:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80180a:	48 85 c0             	test   %rax,%rax
  80180d:	75 05                	jne    801814 <file_create+0x6e>
		return r;
  80180f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801812:	eb 7a                	jmp    80188e <file_create+0xe8>
	if ((r = dir_alloc_file(dir, &f)) < 0)
  801814:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80181b:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  801822:	48 89 d6             	mov    %rdx,%rsi
  801825:	48 89 c7             	mov    %rax,%rdi
  801828:	48 b8 cb 13 80 00 00 	movabs $0x8013cb,%rax
  80182f:	00 00 00 
  801832:	ff d0                	callq  *%rax
  801834:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801837:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80183b:	79 05                	jns    801842 <file_create+0x9c>
		return r;
  80183d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801840:	eb 4c                	jmp    80188e <file_create+0xe8>
	strcpy(f->f_name, name);
  801842:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801849:	48 8d 95 70 ff ff ff 	lea    -0x90(%rbp),%rdx
  801850:	48 89 d6             	mov    %rdx,%rsi
  801853:	48 89 c7             	mov    %rax,%rdi
  801856:	48 b8 26 43 80 00 00 	movabs $0x804326,%rax
  80185d:	00 00 00 
  801860:	ff d0                	callq  *%rax
	*pf = f;
  801862:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  801869:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  801870:	48 89 10             	mov    %rdx,(%rax)
	file_flush(dir);
  801873:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80187a:	48 89 c7             	mov    %rax,%rdi
  80187d:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  801884:	00 00 00 
  801887:	ff d0                	callq  *%rax
	return 0;
  801889:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80188e:	c9                   	leaveq 
  80188f:	c3                   	retq   

0000000000801890 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  801890:	55                   	push   %rbp
  801891:	48 89 e5             	mov    %rsp,%rbp
  801894:	48 83 ec 10          	sub    $0x10,%rsp
  801898:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80189c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return walk_path(path, 0, pf, 0);
  8018a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018a8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018ad:	be 00 00 00 00       	mov    $0x0,%esi
  8018b2:	48 89 c7             	mov    %rax,%rdi
  8018b5:	48 b8 5b 15 80 00 00 	movabs $0x80155b,%rax
  8018bc:	00 00 00 
  8018bf:	ff d0                	callq  *%rax
}
  8018c1:	c9                   	leaveq 
  8018c2:	c3                   	retq   

00000000008018c3 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  8018c3:	55                   	push   %rbp
  8018c4:	48 89 e5             	mov    %rsp,%rbp
  8018c7:	48 83 ec 60          	sub    $0x60,%rsp
  8018cb:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  8018cf:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  8018d3:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  8018d7:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  8018da:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8018de:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8018e4:	3b 45 a4             	cmp    -0x5c(%rbp),%eax
  8018e7:	7f 0a                	jg     8018f3 <file_read+0x30>
		return 0;
  8018e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ee:	e9 24 01 00 00       	jmpq   801a17 <file_read+0x154>

	count = MIN(count, f->f_size - offset);
  8018f3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8018f7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8018fb:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8018ff:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801905:	2b 45 a4             	sub    -0x5c(%rbp),%eax
  801908:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80190b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80190e:	48 63 d0             	movslq %eax,%rdx
  801911:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801915:	48 39 c2             	cmp    %rax,%rdx
  801918:	48 0f 46 c2          	cmovbe %rdx,%rax
  80191c:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	for (pos = offset; pos < offset + count; ) {
  801920:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  801923:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801926:	e9 cd 00 00 00       	jmpq   8019f8 <file_read+0x135>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  80192b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80192e:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801934:	85 c0                	test   %eax,%eax
  801936:	0f 48 c2             	cmovs  %edx,%eax
  801939:	c1 f8 0c             	sar    $0xc,%eax
  80193c:	89 c1                	mov    %eax,%ecx
  80193e:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  801942:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801946:	89 ce                	mov    %ecx,%esi
  801948:	48 89 c7             	mov    %rax,%rdi
  80194b:	48 b8 10 12 80 00 00 	movabs $0x801210,%rax
  801952:	00 00 00 
  801955:	ff d0                	callq  *%rax
  801957:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80195a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80195e:	79 08                	jns    801968 <file_read+0xa5>
			return r;
  801960:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801963:	e9 af 00 00 00       	jmpq   801a17 <file_read+0x154>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801968:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80196b:	99                   	cltd   
  80196c:	c1 ea 14             	shr    $0x14,%edx
  80196f:	01 d0                	add    %edx,%eax
  801971:	25 ff 0f 00 00       	and    $0xfff,%eax
  801976:	29 d0                	sub    %edx,%eax
  801978:	ba 00 10 00 00       	mov    $0x1000,%edx
  80197d:	29 c2                	sub    %eax,%edx
  80197f:	89 d0                	mov    %edx,%eax
  801981:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  801984:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  801987:	48 63 d0             	movslq %eax,%rdx
  80198a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80198e:	48 01 c2             	add    %rax,%rdx
  801991:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801994:	48 98                	cltq   
  801996:	48 29 c2             	sub    %rax,%rdx
  801999:	48 89 d0             	mov    %rdx,%rax
  80199c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8019a0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019a3:	48 63 d0             	movslq %eax,%rdx
  8019a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019aa:	48 39 c2             	cmp    %rax,%rdx
  8019ad:	48 0f 46 c2          	cmovbe %rdx,%rax
  8019b1:	89 45 d4             	mov    %eax,-0x2c(%rbp)
		memmove(buf, blk + pos % BLKSIZE, bn);
  8019b4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8019b7:	48 63 c8             	movslq %eax,%rcx
  8019ba:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8019be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019c1:	99                   	cltd   
  8019c2:	c1 ea 14             	shr    $0x14,%edx
  8019c5:	01 d0                	add    %edx,%eax
  8019c7:	25 ff 0f 00 00       	and    $0xfff,%eax
  8019cc:	29 d0                	sub    %edx,%eax
  8019ce:	48 98                	cltq   
  8019d0:	48 01 c6             	add    %rax,%rsi
  8019d3:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8019d7:	48 89 ca             	mov    %rcx,%rdx
  8019da:	48 89 c7             	mov    %rax,%rdi
  8019dd:	48 b8 4a 46 80 00 00 	movabs $0x80464a,%rax
  8019e4:	00 00 00 
  8019e7:	ff d0                	callq  *%rax
		pos += bn;
  8019e9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8019ec:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  8019ef:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8019f2:	48 98                	cltq   
  8019f4:	48 01 45 b0          	add    %rax,-0x50(%rbp)
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  8019f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019fb:	48 98                	cltq   
  8019fd:	8b 55 a4             	mov    -0x5c(%rbp),%edx
  801a00:	48 63 ca             	movslq %edx,%rcx
  801a03:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801a07:	48 01 ca             	add    %rcx,%rdx
  801a0a:	48 39 d0             	cmp    %rdx,%rax
  801a0d:	0f 82 18 ff ff ff    	jb     80192b <file_read+0x68>
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801a13:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
}
  801a17:	c9                   	leaveq 
  801a18:	c3                   	retq   

0000000000801a19 <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  801a19:	55                   	push   %rbp
  801a1a:	48 89 e5             	mov    %rsp,%rbp
  801a1d:	48 83 ec 50          	sub    $0x50,%rsp
  801a21:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801a25:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  801a29:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801a2d:	89 4d b4             	mov    %ecx,-0x4c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
  801a30:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801a33:	48 63 d0             	movslq %eax,%rdx
  801a36:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a3a:	48 01 c2             	add    %rax,%rdx
  801a3d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a41:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801a47:	48 98                	cltq   
  801a49:	48 39 c2             	cmp    %rax,%rdx
  801a4c:	76 33                	jbe    801a81 <file_write+0x68>
		if ((r = file_set_size(f, offset + count)) < 0)
  801a4e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a52:	89 c2                	mov    %eax,%edx
  801a54:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801a57:	01 d0                	add    %edx,%eax
  801a59:	89 c2                	mov    %eax,%edx
  801a5b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a5f:	89 d6                	mov    %edx,%esi
  801a61:	48 89 c7             	mov    %rax,%rdi
  801a64:	48 b8 bf 1c 80 00 00 	movabs $0x801cbf,%rax
  801a6b:	00 00 00 
  801a6e:	ff d0                	callq  *%rax
  801a70:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801a73:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801a77:	79 08                	jns    801a81 <file_write+0x68>
			return r;
  801a79:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a7c:	e9 f8 00 00 00       	jmpq   801b79 <file_write+0x160>

	for (pos = offset; pos < offset + count; ) {
  801a81:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801a84:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a87:	e9 ce 00 00 00       	jmpq   801b5a <file_write+0x141>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801a8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a8f:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801a95:	85 c0                	test   %eax,%eax
  801a97:	0f 48 c2             	cmovs  %edx,%eax
  801a9a:	c1 f8 0c             	sar    $0xc,%eax
  801a9d:	89 c1                	mov    %eax,%ecx
  801a9f:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801aa3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801aa7:	89 ce                	mov    %ecx,%esi
  801aa9:	48 89 c7             	mov    %rax,%rdi
  801aac:	48 b8 10 12 80 00 00 	movabs $0x801210,%rax
  801ab3:	00 00 00 
  801ab6:	ff d0                	callq  *%rax
  801ab8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801abb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801abf:	79 08                	jns    801ac9 <file_write+0xb0>
			return r;
  801ac1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ac4:	e9 b0 00 00 00       	jmpq   801b79 <file_write+0x160>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801ac9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801acc:	99                   	cltd   
  801acd:	c1 ea 14             	shr    $0x14,%edx
  801ad0:	01 d0                	add    %edx,%eax
  801ad2:	25 ff 0f 00 00       	and    $0xfff,%eax
  801ad7:	29 d0                	sub    %edx,%eax
  801ad9:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ade:	29 c2                	sub    %eax,%edx
  801ae0:	89 d0                	mov    %edx,%eax
  801ae2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801ae5:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801ae8:	48 63 d0             	movslq %eax,%rdx
  801aeb:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801aef:	48 01 c2             	add    %rax,%rdx
  801af2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af5:	48 98                	cltq   
  801af7:	48 29 c2             	sub    %rax,%rdx
  801afa:	48 89 d0             	mov    %rdx,%rax
  801afd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801b01:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801b04:	48 63 d0             	movslq %eax,%rdx
  801b07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b0b:	48 39 c2             	cmp    %rax,%rdx
  801b0e:	48 0f 46 c2          	cmovbe %rdx,%rax
  801b12:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		memmove(blk + pos % BLKSIZE, buf, bn);
  801b15:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b18:	48 63 c8             	movslq %eax,%rcx
  801b1b:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801b1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b22:	99                   	cltd   
  801b23:	c1 ea 14             	shr    $0x14,%edx
  801b26:	01 d0                	add    %edx,%eax
  801b28:	25 ff 0f 00 00       	and    $0xfff,%eax
  801b2d:	29 d0                	sub    %edx,%eax
  801b2f:	48 98                	cltq   
  801b31:	48 8d 3c 06          	lea    (%rsi,%rax,1),%rdi
  801b35:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801b39:	48 89 ca             	mov    %rcx,%rdx
  801b3c:	48 89 c6             	mov    %rax,%rsi
  801b3f:	48 b8 4a 46 80 00 00 	movabs $0x80464a,%rax
  801b46:	00 00 00 
  801b49:	ff d0                	callq  *%rax
		pos += bn;
  801b4b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b4e:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  801b51:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b54:	48 98                	cltq   
  801b56:	48 01 45 c0          	add    %rax,-0x40(%rbp)
	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
  801b5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b5d:	48 98                	cltq   
  801b5f:	8b 55 b4             	mov    -0x4c(%rbp),%edx
  801b62:	48 63 ca             	movslq %edx,%rcx
  801b65:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801b69:	48 01 ca             	add    %rcx,%rdx
  801b6c:	48 39 d0             	cmp    %rdx,%rax
  801b6f:	0f 82 17 ff ff ff    	jb     801a8c <file_write+0x73>
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801b75:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
}
  801b79:	c9                   	leaveq 
  801b7a:	c3                   	retq   

0000000000801b7b <file_free_block>:

// Remove a block from file f.  If it's not there, just silently succeed.
// Returns 0 on success, < 0 on error.
static int
file_free_block(struct File *f, uint32_t filebno)
{
  801b7b:	55                   	push   %rbp
  801b7c:	48 89 e5             	mov    %rsp,%rbp
  801b7f:	48 83 ec 20          	sub    $0x20,%rsp
  801b83:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b87:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  801b8a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801b8e:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  801b91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b95:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b9a:	48 89 c7             	mov    %rax,%rdi
  801b9d:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  801ba4:	00 00 00 
  801ba7:	ff d0                	callq  *%rax
  801ba9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bb0:	79 05                	jns    801bb7 <file_free_block+0x3c>
		return r;
  801bb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb5:	eb 2d                	jmp    801be4 <file_free_block+0x69>
	if (*ptr) {
  801bb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bbb:	8b 00                	mov    (%rax),%eax
  801bbd:	85 c0                	test   %eax,%eax
  801bbf:	74 1e                	je     801bdf <file_free_block+0x64>
		free_block(*ptr);
  801bc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bc5:	8b 00                	mov    (%rax),%eax
  801bc7:	89 c7                	mov    %eax,%edi
  801bc9:	48 b8 a8 0d 80 00 00 	movabs $0x800da8,%rax
  801bd0:	00 00 00 
  801bd3:	ff d0                	callq  *%rax
		*ptr = 0;
  801bd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bd9:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	return 0;
  801bdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be4:	c9                   	leaveq 
  801be5:	c3                   	retq   

0000000000801be6 <file_truncate_blocks>:
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
static void
file_truncate_blocks(struct File *f, off_t newsize)
{
  801be6:	55                   	push   %rbp
  801be7:	48 89 e5             	mov    %rsp,%rbp
  801bea:	48 83 ec 20          	sub    $0x20,%rsp
  801bee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bf2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  801bf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bf9:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801bff:	05 ff 0f 00 00       	add    $0xfff,%eax
  801c04:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801c0a:	85 c0                	test   %eax,%eax
  801c0c:	0f 48 c2             	cmovs  %edx,%eax
  801c0f:	c1 f8 0c             	sar    $0xc,%eax
  801c12:	89 45 f8             	mov    %eax,-0x8(%rbp)
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  801c15:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c18:	05 ff 0f 00 00       	add    $0xfff,%eax
  801c1d:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801c23:	85 c0                	test   %eax,%eax
  801c25:	0f 48 c2             	cmovs  %edx,%eax
  801c28:	c1 f8 0c             	sar    $0xc,%eax
  801c2b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801c2e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c34:	eb 45                	jmp    801c7b <file_truncate_blocks+0x95>
		if ((r = file_free_block(f, bno)) < 0)
  801c36:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c3d:	89 d6                	mov    %edx,%esi
  801c3f:	48 89 c7             	mov    %rax,%rdi
  801c42:	48 b8 7b 1b 80 00 00 	movabs $0x801b7b,%rax
  801c49:	00 00 00 
  801c4c:	ff d0                	callq  *%rax
  801c4e:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801c51:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801c55:	79 20                	jns    801c77 <file_truncate_blocks+0x91>
			cprintf("warning: file_free_block: %e", r);
  801c57:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801c5a:	89 c6                	mov    %eax,%esi
  801c5c:	48 bf e0 78 80 00 00 	movabs $0x8078e0,%rdi
  801c63:	00 00 00 
  801c66:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6b:	48 ba 71 37 80 00 00 	movabs $0x803771,%rdx
  801c72:	00 00 00 
  801c75:	ff d2                	callq  *%rdx
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801c77:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801c7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c7e:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  801c81:	72 b3                	jb     801c36 <file_truncate_blocks+0x50>
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  801c83:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  801c87:	77 34                	ja     801cbd <file_truncate_blocks+0xd7>
  801c89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c8d:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801c93:	85 c0                	test   %eax,%eax
  801c95:	74 26                	je     801cbd <file_truncate_blocks+0xd7>
		free_block(f->f_indirect);
  801c97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c9b:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801ca1:	89 c7                	mov    %eax,%edi
  801ca3:	48 b8 a8 0d 80 00 00 	movabs $0x800da8,%rax
  801caa:	00 00 00 
  801cad:	ff d0                	callq  *%rax
		f->f_indirect = 0;
  801caf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cb3:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%rax)
  801cba:	00 00 00 
	}
}
  801cbd:	c9                   	leaveq 
  801cbe:	c3                   	retq   

0000000000801cbf <file_set_size>:

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  801cbf:	55                   	push   %rbp
  801cc0:	48 89 e5             	mov    %rsp,%rbp
  801cc3:	48 83 ec 10          	sub    $0x10,%rsp
  801cc7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ccb:	89 75 f4             	mov    %esi,-0xc(%rbp)
	if (f->f_size > newsize)
  801cce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cd2:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801cd8:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801cdb:	7e 18                	jle    801cf5 <file_set_size+0x36>
		file_truncate_blocks(f, newsize);
  801cdd:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801ce0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ce4:	89 d6                	mov    %edx,%esi
  801ce6:	48 89 c7             	mov    %rax,%rdi
  801ce9:	48 b8 e6 1b 80 00 00 	movabs $0x801be6,%rax
  801cf0:	00 00 00 
  801cf3:	ff d0                	callq  *%rax
	f->f_size = newsize;
  801cf5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cf9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801cfc:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	flush_block(f);
  801d02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d06:	48 89 c7             	mov    %rax,%rdi
  801d09:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  801d10:	00 00 00 
  801d13:	ff d0                	callq  *%rax
	return 0;
  801d15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d1a:	c9                   	leaveq 
  801d1b:	c3                   	retq   

0000000000801d1c <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  801d1c:	55                   	push   %rbp
  801d1d:	48 89 e5             	mov    %rsp,%rbp
  801d20:	48 83 ec 20          	sub    $0x20,%rsp
  801d24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801d28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d2f:	eb 62                	jmp    801d93 <file_flush+0x77>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801d31:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d34:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801d38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d3c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d41:	48 89 c7             	mov    %rax,%rdi
  801d44:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  801d4b:	00 00 00 
  801d4e:	ff d0                	callq  *%rax
  801d50:	85 c0                	test   %eax,%eax
  801d52:	78 13                	js     801d67 <file_flush+0x4b>
		    pdiskbno == NULL || *pdiskbno == 0)
  801d54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801d58:	48 85 c0             	test   %rax,%rax
  801d5b:	74 0a                	je     801d67 <file_flush+0x4b>
		    pdiskbno == NULL || *pdiskbno == 0)
  801d5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d61:	8b 00                	mov    (%rax),%eax
  801d63:	85 c0                	test   %eax,%eax
  801d65:	75 02                	jne    801d69 <file_flush+0x4d>
			continue;
  801d67:	eb 26                	jmp    801d8f <file_flush+0x73>
		flush_block(diskaddr(*pdiskbno));
  801d69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d6d:	8b 00                	mov    (%rax),%eax
  801d6f:	89 c0                	mov    %eax,%eax
  801d71:	48 89 c7             	mov    %rax,%rdi
  801d74:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801d7b:	00 00 00 
  801d7e:	ff d0                	callq  *%rax
  801d80:	48 89 c7             	mov    %rax,%rdi
  801d83:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  801d8a:	00 00 00 
  801d8d:	ff d0                	callq  *%rax
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801d8f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d97:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801d9d:	05 ff 0f 00 00       	add    $0xfff,%eax
  801da2:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801da8:	85 c0                	test   %eax,%eax
  801daa:	0f 48 c2             	cmovs  %edx,%eax
  801dad:	c1 f8 0c             	sar    $0xc,%eax
  801db0:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  801db3:	0f 8f 78 ff ff ff    	jg     801d31 <file_flush+0x15>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  801db9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dbd:	48 89 c7             	mov    %rax,%rdi
  801dc0:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  801dc7:	00 00 00 
  801dca:	ff d0                	callq  *%rax
	if (f->f_indirect)
  801dcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd0:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801dd6:	85 c0                	test   %eax,%eax
  801dd8:	74 2a                	je     801e04 <file_flush+0xe8>
		flush_block(diskaddr(f->f_indirect));
  801dda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dde:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801de4:	89 c0                	mov    %eax,%eax
  801de6:	48 89 c7             	mov    %rax,%rdi
  801de9:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801df0:	00 00 00 
  801df3:	ff d0                	callq  *%rax
  801df5:	48 89 c7             	mov    %rax,%rdi
  801df8:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  801dff:	00 00 00 
  801e02:	ff d0                	callq  *%rax
}
  801e04:	c9                   	leaveq 
  801e05:	c3                   	retq   

0000000000801e06 <file_remove>:

// Remove a file by truncating it and then zeroing the name.
int
file_remove(const char *path)
{
  801e06:	55                   	push   %rbp
  801e07:	48 89 e5             	mov    %rsp,%rbp
  801e0a:	48 83 ec 20          	sub    $0x20,%rsp
  801e0e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;
	struct File *f;

	if ((r = walk_path(path, 0, &f, 0)) < 0)
  801e12:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e1a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e1f:	be 00 00 00 00       	mov    $0x0,%esi
  801e24:	48 89 c7             	mov    %rax,%rdi
  801e27:	48 b8 5b 15 80 00 00 	movabs $0x80155b,%rax
  801e2e:	00 00 00 
  801e31:	ff d0                	callq  *%rax
  801e33:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e36:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e3a:	79 05                	jns    801e41 <file_remove+0x3b>
		return r;
  801e3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e3f:	eb 45                	jmp    801e86 <file_remove+0x80>

	file_truncate_blocks(f, 0);
  801e41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e45:	be 00 00 00 00       	mov    $0x0,%esi
  801e4a:	48 89 c7             	mov    %rax,%rdi
  801e4d:	48 b8 e6 1b 80 00 00 	movabs $0x801be6,%rax
  801e54:	00 00 00 
  801e57:	ff d0                	callq  *%rax
	f->f_name[0] = '\0';
  801e59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e5d:	c6 00 00             	movb   $0x0,(%rax)
	f->f_size = 0;
  801e60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e64:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  801e6b:	00 00 00 
	flush_block(f);
  801e6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e72:	48 89 c7             	mov    %rax,%rdi
  801e75:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  801e7c:	00 00 00 
  801e7f:	ff d0                	callq  *%rax

	return 0;
  801e81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e86:	c9                   	leaveq 
  801e87:	c3                   	retq   

0000000000801e88 <fs_sync>:

// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  801e88:	55                   	push   %rbp
  801e89:	48 89 e5             	mov    %rsp,%rbp
  801e8c:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801e90:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  801e97:	eb 27                	jmp    801ec0 <fs_sync+0x38>
		flush_block(diskaddr(i));
  801e99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e9c:	48 98                	cltq   
  801e9e:	48 89 c7             	mov    %rax,%rdi
  801ea1:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801ea8:	00 00 00 
  801eab:	ff d0                	callq  *%rax
  801ead:	48 89 c7             	mov    %rax,%rdi
  801eb0:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  801eb7:	00 00 00 
  801eba:	ff d0                	callq  *%rax
// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801ebc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ec0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ec3:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  801eca:	00 00 00 
  801ecd:	48 8b 00             	mov    (%rax),%rax
  801ed0:	8b 40 04             	mov    0x4(%rax),%eax
  801ed3:	39 c2                	cmp    %eax,%edx
  801ed5:	72 c2                	jb     801e99 <fs_sync+0x11>
		flush_block(diskaddr(i));
}
  801ed7:	c9                   	leaveq 
  801ed8:	c3                   	retq   

0000000000801ed9 <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  801ed9:	55                   	push   %rbp
  801eda:	48 89 e5             	mov    %rsp,%rbp
  801edd:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	uintptr_t va = FILEVA;
  801ee1:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
  801ee6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < MAXOPEN; i++) {
  801eea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ef1:	eb 4b                	jmp    801f3e <serve_init+0x65>
		opentab[i].o_fileid = i;
  801ef3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef6:	48 ba 20 a0 80 00 00 	movabs $0x80a020,%rdx
  801efd:	00 00 00 
  801f00:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801f03:	48 63 c9             	movslq %ecx,%rcx
  801f06:	48 c1 e1 05          	shl    $0x5,%rcx
  801f0a:	48 01 ca             	add    %rcx,%rdx
  801f0d:	89 02                	mov    %eax,(%rdx)
		opentab[i].o_fd = (struct Fd*) va;
  801f0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f13:	48 ba 20 a0 80 00 00 	movabs $0x80a020,%rdx
  801f1a:	00 00 00 
  801f1d:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801f20:	48 63 c9             	movslq %ecx,%rcx
  801f23:	48 c1 e1 05          	shl    $0x5,%rcx
  801f27:	48 01 ca             	add    %rcx,%rdx
  801f2a:	48 83 c2 10          	add    $0x10,%rdx
  801f2e:	48 89 42 08          	mov    %rax,0x8(%rdx)
		va += PGSIZE;
  801f32:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
  801f39:	00 
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  801f3a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f3e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  801f45:	7e ac                	jle    801ef3 <serve_init+0x1a>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  801f47:	c9                   	leaveq 
  801f48:	c3                   	retq   

0000000000801f49 <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  801f49:	55                   	push   %rbp
  801f4a:	48 89 e5             	mov    %rsp,%rbp
  801f4d:	53                   	push   %rbx
  801f4e:	48 83 ec 28          	sub    $0x28,%rsp
  801f52:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  801f56:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  801f5d:	e9 02 02 00 00       	jmpq   802164 <openfile_alloc+0x21b>
		switch (pageref(opentab[i].o_fd)) {
  801f62:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  801f69:	00 00 00 
  801f6c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f6f:	48 63 d2             	movslq %edx,%rdx
  801f72:	48 c1 e2 05          	shl    $0x5,%rdx
  801f76:	48 01 d0             	add    %rdx,%rax
  801f79:	48 83 c0 10          	add    $0x10,%rax
  801f7d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f81:	48 89 c7             	mov    %rax,%rdi
  801f84:	48 b8 c7 64 80 00 00 	movabs $0x8064c7,%rax
  801f8b:	00 00 00 
  801f8e:	ff d0                	callq  *%rax
  801f90:	85 c0                	test   %eax,%eax
  801f92:	74 0e                	je     801fa2 <openfile_alloc+0x59>
  801f94:	83 f8 01             	cmp    $0x1,%eax
  801f97:	0f 84 ec 00 00 00    	je     802089 <openfile_alloc+0x140>
  801f9d:	e9 be 01 00 00       	jmpq   802160 <openfile_alloc+0x217>

		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  801fa2:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  801fa9:	00 00 00 
  801fac:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801faf:	48 63 d2             	movslq %edx,%rdx
  801fb2:	48 c1 e2 05          	shl    $0x5,%rdx
  801fb6:	48 01 d0             	add    %rdx,%rax
  801fb9:	48 83 c0 10          	add    $0x10,%rax
  801fbd:	48 8b 40 08          	mov    0x8(%rax),%rax
  801fc1:	ba 07 00 00 00       	mov    $0x7,%edx
  801fc6:	48 89 c6             	mov    %rax,%rsi
  801fc9:	bf 00 00 00 00       	mov    $0x0,%edi
  801fce:	48 b8 55 4c 80 00 00 	movabs $0x804c55,%rax
  801fd5:	00 00 00 
  801fd8:	ff d0                	callq  *%rax
  801fda:	89 45 e8             	mov    %eax,-0x18(%rbp)
  801fdd:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801fe1:	79 08                	jns    801feb <openfile_alloc+0xa2>
				return r;
  801fe3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801fe6:	e9 8b 01 00 00       	jmpq   802176 <openfile_alloc+0x22d>

#ifdef VMM_GUEST
			opentab[i].o_fileid += MAXOPEN;
  801feb:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  801ff2:	00 00 00 
  801ff5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ff8:	48 63 d2             	movslq %edx,%rdx
  801ffb:	48 c1 e2 05          	shl    $0x5,%rdx
  801fff:	48 01 d0             	add    %rdx,%rax
  802002:	8b 00                	mov    (%rax),%eax
  802004:	8d 90 00 04 00 00    	lea    0x400(%rax),%edx
  80200a:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802011:	00 00 00 
  802014:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  802017:	48 63 c9             	movslq %ecx,%rcx
  80201a:	48 c1 e1 05          	shl    $0x5,%rcx
  80201e:	48 01 c8             	add    %rcx,%rax
  802021:	89 10                	mov    %edx,(%rax)
			*o = &opentab[i];
  802023:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802026:	48 98                	cltq   
  802028:	48 c1 e0 05          	shl    $0x5,%rax
  80202c:	48 89 c2             	mov    %rax,%rdx
  80202f:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802036:	00 00 00 
  802039:	48 01 c2             	add    %rax,%rdx
  80203c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802040:	48 89 10             	mov    %rdx,(%rax)
			memset(opentab[i].o_fd, 0, PGSIZE);
  802043:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  80204a:	00 00 00 
  80204d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802050:	48 63 d2             	movslq %edx,%rdx
  802053:	48 c1 e2 05          	shl    $0x5,%rdx
  802057:	48 01 d0             	add    %rdx,%rax
  80205a:	48 83 c0 10          	add    $0x10,%rax
  80205e:	48 8b 40 08          	mov    0x8(%rax),%rax
  802062:	ba 00 10 00 00       	mov    $0x1000,%edx
  802067:	be 00 00 00 00       	mov    $0x0,%esi
  80206c:	48 89 c7             	mov    %rax,%rdi
  80206f:	48 b8 bf 45 80 00 00 	movabs $0x8045bf,%rax
  802076:	00 00 00 
  802079:	ff d0                	callq  *%rax
			return (*o)->o_fileid;
  80207b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80207f:	48 8b 00             	mov    (%rax),%rax
  802082:	8b 00                	mov    (%rax),%eax
  802084:	e9 ed 00 00 00       	jmpq   802176 <openfile_alloc+0x22d>
#endif // VMM_GUEST

		case 1:

#ifdef VMM_GUEST
			if ((uint64_t) opentab[i].o_fd != get_host_fd()) {
  802089:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802090:	00 00 00 
  802093:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802096:	48 63 d2             	movslq %edx,%rdx
  802099:	48 c1 e2 05          	shl    $0x5,%rdx
  80209d:	48 01 d0             	add    %rdx,%rax
  8020a0:	48 83 c0 10          	add    $0x10,%rax
  8020a4:	48 8b 40 08          	mov    0x8(%rax),%rax
  8020a8:	48 89 c3             	mov    %rax,%rbx
  8020ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b0:	48 ba 61 31 80 00 00 	movabs $0x803161,%rdx
  8020b7:	00 00 00 
  8020ba:	ff d2                	callq  *%rdx
  8020bc:	48 39 c3             	cmp    %rax,%rbx
  8020bf:	0f 84 9b 00 00 00    	je     802160 <openfile_alloc+0x217>
#endif // VMM_GUEST


			opentab[i].o_fileid += MAXOPEN;
  8020c5:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  8020cc:	00 00 00 
  8020cf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020d2:	48 63 d2             	movslq %edx,%rdx
  8020d5:	48 c1 e2 05          	shl    $0x5,%rdx
  8020d9:	48 01 d0             	add    %rdx,%rax
  8020dc:	8b 00                	mov    (%rax),%eax
  8020de:	8d 90 00 04 00 00    	lea    0x400(%rax),%edx
  8020e4:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  8020eb:	00 00 00 
  8020ee:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  8020f1:	48 63 c9             	movslq %ecx,%rcx
  8020f4:	48 c1 e1 05          	shl    $0x5,%rcx
  8020f8:	48 01 c8             	add    %rcx,%rax
  8020fb:	89 10                	mov    %edx,(%rax)
			*o = &opentab[i];
  8020fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802100:	48 98                	cltq   
  802102:	48 c1 e0 05          	shl    $0x5,%rax
  802106:	48 89 c2             	mov    %rax,%rdx
  802109:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802110:	00 00 00 
  802113:	48 01 c2             	add    %rax,%rdx
  802116:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80211a:	48 89 10             	mov    %rdx,(%rax)
			memset(opentab[i].o_fd, 0, PGSIZE);
  80211d:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802124:	00 00 00 
  802127:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80212a:	48 63 d2             	movslq %edx,%rdx
  80212d:	48 c1 e2 05          	shl    $0x5,%rdx
  802131:	48 01 d0             	add    %rdx,%rax
  802134:	48 83 c0 10          	add    $0x10,%rax
  802138:	48 8b 40 08          	mov    0x8(%rax),%rax
  80213c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802141:	be 00 00 00 00       	mov    $0x0,%esi
  802146:	48 89 c7             	mov    %rax,%rdi
  802149:	48 b8 bf 45 80 00 00 	movabs $0x8045bf,%rax
  802150:	00 00 00 
  802153:	ff d0                	callq  *%rax
			return (*o)->o_fileid;
  802155:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802159:	48 8b 00             	mov    (%rax),%rax
  80215c:	8b 00                	mov    (%rax),%eax
  80215e:	eb 16                	jmp    802176 <openfile_alloc+0x22d>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  802160:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  802164:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%rbp)
  80216b:	0f 8e f1 fd ff ff    	jle    801f62 <openfile_alloc+0x19>
		        }
#endif // VMM_GUEST

	         }
        }
	return -E_MAX_OPEN;
  802171:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802176:	48 83 c4 28          	add    $0x28,%rsp
  80217a:	5b                   	pop    %rbx
  80217b:	5d                   	pop    %rbp
  80217c:	c3                   	retq   

000000000080217d <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  80217d:	55                   	push   %rbp
  80217e:	48 89 e5             	mov    %rsp,%rbp
  802181:	48 83 ec 20          	sub    $0x20,%rsp
  802185:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802188:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80218b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  80218f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802192:	25 ff 03 00 00       	and    $0x3ff,%eax
  802197:	89 c0                	mov    %eax,%eax
  802199:	48 c1 e0 05          	shl    $0x5,%rax
  80219d:	48 89 c2             	mov    %rax,%rdx
  8021a0:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  8021a7:	00 00 00 
  8021aa:	48 01 d0             	add    %rdx,%rax
  8021ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  8021b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021b5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8021b9:	48 89 c7             	mov    %rax,%rdi
  8021bc:	48 b8 c7 64 80 00 00 	movabs $0x8064c7,%rax
  8021c3:	00 00 00 
  8021c6:	ff d0                	callq  *%rax
  8021c8:	83 f8 01             	cmp    $0x1,%eax
  8021cb:	74 0b                	je     8021d8 <openfile_lookup+0x5b>
  8021cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021d1:	8b 00                	mov    (%rax),%eax
  8021d3:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8021d6:	74 07                	je     8021df <openfile_lookup+0x62>
		return -E_INVAL;
  8021d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021dd:	eb 10                	jmp    8021ef <openfile_lookup+0x72>
	*po = o;
  8021df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021e3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021e7:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8021ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ef:	c9                   	leaveq 
  8021f0:	c3                   	retq   

00000000008021f1 <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  8021f1:	55                   	push   %rbp
  8021f2:	48 89 e5             	mov    %rsp,%rbp
  8021f5:	48 81 ec 40 04 00 00 	sub    $0x440,%rsp
  8021fc:	89 bd dc fb ff ff    	mov    %edi,-0x424(%rbp)
  802202:	48 89 b5 d0 fb ff ff 	mov    %rsi,-0x430(%rbp)
  802209:	48 89 95 c8 fb ff ff 	mov    %rdx,-0x438(%rbp)
  802210:	48 89 8d c0 fb ff ff 	mov    %rcx,-0x440(%rbp)

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  802217:	48 8b 8d d0 fb ff ff 	mov    -0x430(%rbp),%rcx
  80221e:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  802225:	ba 00 04 00 00       	mov    $0x400,%edx
  80222a:	48 89 ce             	mov    %rcx,%rsi
  80222d:	48 89 c7             	mov    %rax,%rdi
  802230:	48 b8 4a 46 80 00 00 	movabs $0x80464a,%rax
  802237:	00 00 00 
  80223a:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  80223c:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  802240:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  802247:	48 89 c7             	mov    %rax,%rdi
  80224a:	48 b8 49 1f 80 00 00 	movabs $0x801f49,%rax
  802251:	00 00 00 
  802254:	ff d0                	callq  *%rax
  802256:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802259:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80225d:	79 08                	jns    802267 <serve_open+0x76>
		if (debug)
			cprintf("openfile_alloc failed: %e", r);
		return r;
  80225f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802262:	e9 7c 01 00 00       	jmpq   8023e3 <serve_open+0x1f2>
	}
	fileid = r;
  802267:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80226a:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// Open the file
	if (req->req_omode & O_CREAT) {
  80226d:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  802274:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  80227a:	25 00 01 00 00       	and    $0x100,%eax
  80227f:	85 c0                	test   %eax,%eax
  802281:	74 4f                	je     8022d2 <serve_open+0xe1>
		if ((r = file_create(path, &f)) < 0) {
  802283:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  80228a:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  802291:	48 89 d6             	mov    %rdx,%rsi
  802294:	48 89 c7             	mov    %rax,%rdi
  802297:	48 b8 a6 17 80 00 00 	movabs $0x8017a6,%rax
  80229e:	00 00 00 
  8022a1:	ff d0                	callq  *%rax
  8022a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022aa:	79 57                	jns    802303 <serve_open+0x112>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  8022ac:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  8022b3:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  8022b9:	25 00 04 00 00       	and    $0x400,%eax
  8022be:	85 c0                	test   %eax,%eax
  8022c0:	75 08                	jne    8022ca <serve_open+0xd9>
  8022c2:	83 7d fc f2          	cmpl   $0xfffffff2,-0x4(%rbp)
  8022c6:	75 02                	jne    8022ca <serve_open+0xd9>
				goto try_open;
  8022c8:	eb 08                	jmp    8022d2 <serve_open+0xe1>
			if (debug)
				cprintf("file_create failed: %e", r);
			return r;
  8022ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022cd:	e9 11 01 00 00       	jmpq   8023e3 <serve_open+0x1f2>
		}
	} else {
try_open:
		if ((r = file_open(path, &f)) < 0) {
  8022d2:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  8022d9:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  8022e0:	48 89 d6             	mov    %rdx,%rsi
  8022e3:	48 89 c7             	mov    %rax,%rdi
  8022e6:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  8022ed:	00 00 00 
  8022f0:	ff d0                	callq  *%rax
  8022f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022f9:	79 08                	jns    802303 <serve_open+0x112>
			if (debug)
				cprintf("file_open failed: %e", r);
			return r;
  8022fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022fe:	e9 e0 00 00 00       	jmpq   8023e3 <serve_open+0x1f2>
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  802303:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  80230a:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  802310:	25 00 02 00 00       	and    $0x200,%eax
  802315:	85 c0                	test   %eax,%eax
  802317:	74 2c                	je     802345 <serve_open+0x154>
		if ((r = file_set_size(f, 0)) < 0) {
  802319:	48 8b 85 e8 fb ff ff 	mov    -0x418(%rbp),%rax
  802320:	be 00 00 00 00       	mov    $0x0,%esi
  802325:	48 89 c7             	mov    %rax,%rdi
  802328:	48 b8 bf 1c 80 00 00 	movabs $0x801cbf,%rax
  80232f:	00 00 00 
  802332:	ff d0                	callq  *%rax
  802334:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802337:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80233b:	79 08                	jns    802345 <serve_open+0x154>
			if (debug)
				cprintf("file_set_size failed: %e", r);
			return r;
  80233d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802340:	e9 9e 00 00 00       	jmpq   8023e3 <serve_open+0x1f2>
		}
	}

	// Save the file pointer
	o->o_file = f;
  802345:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  80234c:	48 8b 95 e8 fb ff ff 	mov    -0x418(%rbp),%rdx
  802353:	48 89 50 08          	mov    %rdx,0x8(%rax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  802357:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  80235e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802362:	48 8b 95 e0 fb ff ff 	mov    -0x420(%rbp),%rdx
  802369:	8b 12                	mov    (%rdx),%edx
  80236b:	89 50 0c             	mov    %edx,0xc(%rax)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  80236e:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802375:	48 8b 40 18          	mov    0x18(%rax),%rax
  802379:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  802380:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  802386:	83 e2 03             	and    $0x3,%edx
  802389:	89 50 08             	mov    %edx,0x8(%rax)
	o->o_fd->fd_dev_id = devfile.dev_id;
  80238c:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802393:	48 8b 40 18          	mov    0x18(%rax),%rax
  802397:	48 ba e0 20 81 00 00 	movabs $0x8120e0,%rdx
  80239e:	00 00 00 
  8023a1:	8b 12                	mov    (%rdx),%edx
  8023a3:	89 10                	mov    %edx,(%rax)
	o->o_mode = req->req_omode;
  8023a5:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8023ac:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  8023b3:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  8023b9:	89 50 10             	mov    %edx,0x10(%rax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  8023bc:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8023c3:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8023c7:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  8023ce:	48 89 10             	mov    %rdx,(%rax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  8023d1:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  8023d8:	c7 00 07 04 00 00    	movl   $0x407,(%rax)

	return 0;
  8023de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023e3:	c9                   	leaveq 
  8023e4:	c3                   	retq   

00000000008023e5 <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  8023e5:	55                   	push   %rbp
  8023e6:	48 89 e5             	mov    %rsp,%rbp
  8023e9:	48 83 ec 20          	sub    $0x20,%rsp
  8023ed:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8023f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023f8:	8b 00                	mov    (%rax),%eax
  8023fa:	89 c1                	mov    %eax,%ecx
  8023fc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802400:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802403:	89 ce                	mov    %ecx,%esi
  802405:	89 c7                	mov    %eax,%edi
  802407:	48 b8 7d 21 80 00 00 	movabs $0x80217d,%rax
  80240e:	00 00 00 
  802411:	ff d0                	callq  *%rax
  802413:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802416:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80241a:	79 05                	jns    802421 <serve_set_size+0x3c>
		return r;
  80241c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241f:	eb 20                	jmp    802441 <serve_set_size+0x5c>

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  802421:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802425:	8b 50 04             	mov    0x4(%rax),%edx
  802428:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80242c:	48 8b 40 08          	mov    0x8(%rax),%rax
  802430:	89 d6                	mov    %edx,%esi
  802432:	48 89 c7             	mov    %rax,%rdi
  802435:	48 b8 bf 1c 80 00 00 	movabs $0x801cbf,%rax
  80243c:	00 00 00 
  80243f:	ff d0                	callq  *%rax
}
  802441:	c9                   	leaveq 
  802442:	c3                   	retq   

0000000000802443 <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  802443:	55                   	push   %rbp
  802444:	48 89 e5             	mov    %rsp,%rbp
  802447:	48 83 ec 40          	sub    $0x40,%rsp
  80244b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80244e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	struct Fsreq_read *req = &ipc->read;
  802452:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802456:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_read *ret = &ipc->readRet;
  80245a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80245e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//

	struct OpenFile *o;
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802462:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802466:	8b 00                	mov    (%rax),%eax
  802468:	89 c1                	mov    %eax,%ecx
  80246a:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  80246e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802471:	89 ce                	mov    %ecx,%esi
  802473:	89 c7                	mov    %eax,%edi
  802475:	48 b8 7d 21 80 00 00 	movabs $0x80217d,%rax
  80247c:	00 00 00 
  80247f:	ff d0                	callq  *%rax
  802481:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802484:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802488:	79 05                	jns    80248f <serve_read+0x4c>
		return r;
  80248a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80248d:	eb 76                	jmp    802505 <serve_read+0xc2>

	if ((r = file_read(o->o_file, ret->ret_buf,
			   MIN(req->req_n, sizeof ret->ret_buf),
			   o->o_fd->fd_offset)) < 0)
  80248f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802493:	48 8b 40 18          	mov    0x18(%rax),%rax
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
		return r;

	if ((r = file_read(o->o_file, ret->ret_buf,
  802497:	8b 48 04             	mov    0x4(%rax),%ecx
			   MIN(req->req_n, sizeof ret->ret_buf),
  80249a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80249e:	48 8b 40 08          	mov    0x8(%rax),%rax
  8024a2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8024a6:	48 c7 45 d8 00 10 00 	movq   $0x1000,-0x28(%rbp)
  8024ad:	00 
  8024ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024b2:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
  8024b6:	48 0f 46 45 e0       	cmovbe -0x20(%rbp),%rax
  8024bb:	48 89 c2             	mov    %rax,%rdx
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
		return r;

	if ((r = file_read(o->o_file, ret->ret_buf,
  8024be:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8024c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024c6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8024ca:	48 89 c7             	mov    %rax,%rdi
  8024cd:	48 b8 c3 18 80 00 00 	movabs $0x8018c3,%rax
  8024d4:	00 00 00 
  8024d7:	ff d0                	callq  *%rax
  8024d9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8024dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8024e0:	79 05                	jns    8024e7 <serve_read+0xa4>
			   MIN(req->req_n, sizeof ret->ret_buf),
			   o->o_fd->fd_offset)) < 0)
		return r;
  8024e2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024e5:	eb 1e                	jmp    802505 <serve_read+0xc2>

	o->o_fd->fd_offset += r;
  8024e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024eb:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024ef:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8024f3:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  8024f7:	8b 4a 04             	mov    0x4(%rdx),%ecx
  8024fa:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8024fd:	01 ca                	add    %ecx,%edx
  8024ff:	89 50 04             	mov    %edx,0x4(%rax)
	return r;
  802502:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802505:	c9                   	leaveq 
  802506:	c3                   	retq   

0000000000802507 <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  802507:	55                   	push   %rbp
  802508:	48 89 e5             	mov    %rsp,%rbp
  80250b:	48 83 ec 20          	sub    $0x20,%rsp
  80250f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802512:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)


	struct OpenFile *o;
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802516:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80251a:	8b 00                	mov    (%rax),%eax
  80251c:	89 c1                	mov    %eax,%ecx
  80251e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802522:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802525:	89 ce                	mov    %ecx,%esi
  802527:	89 c7                	mov    %eax,%edi
  802529:	48 b8 7d 21 80 00 00 	movabs $0x80217d,%rax
  802530:	00 00 00 
  802533:	ff d0                	callq  *%rax
  802535:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802538:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80253c:	79 05                	jns    802543 <serve_write+0x3c>
		return r;
  80253e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802541:	eb 75                	jmp    8025b8 <serve_write+0xb1>

	if (req->req_n > sizeof(req->req_buf))
  802543:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802547:	48 8b 40 08          	mov    0x8(%rax),%rax
  80254b:	48 3d f4 0f 00 00    	cmp    $0xff4,%rax
  802551:	76 07                	jbe    80255a <serve_write+0x53>
		return -E_INVAL;
  802553:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802558:	eb 5e                	jmp    8025b8 <serve_write+0xb1>

	if ((r = file_write(o->o_file, req->req_buf, req->req_n, o->o_fd->fd_offset)) < 0)
  80255a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80255e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802562:	8b 48 04             	mov    0x4(%rax),%ecx
  802565:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802569:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80256d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802571:	48 8d 70 10          	lea    0x10(%rax),%rsi
  802575:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802579:	48 8b 40 08          	mov    0x8(%rax),%rax
  80257d:	48 89 c7             	mov    %rax,%rdi
  802580:	48 b8 19 1a 80 00 00 	movabs $0x801a19,%rax
  802587:	00 00 00 
  80258a:	ff d0                	callq  *%rax
  80258c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80258f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802593:	79 05                	jns    80259a <serve_write+0x93>
		return r;
  802595:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802598:	eb 1e                	jmp    8025b8 <serve_write+0xb1>

	o->o_fd->fd_offset += r;
  80259a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80259e:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025a6:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  8025aa:	8b 4a 04             	mov    0x4(%rdx),%ecx
  8025ad:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025b0:	01 ca                	add    %ecx,%edx
  8025b2:	89 50 04             	mov    %edx,0x4(%rax)
	return r;
  8025b5:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8025b8:	c9                   	leaveq 
  8025b9:	c3                   	retq   

00000000008025ba <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  8025ba:	55                   	push   %rbp
  8025bb:	48 89 e5             	mov    %rsp,%rbp
  8025be:	48 83 ec 30          	sub    $0x30,%rsp
  8025c2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025c5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	struct Fsreq_stat *req = &ipc->stat;
  8025c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025cd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_stat *ret = &ipc->statRet;
  8025d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025d5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8025d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025dd:	8b 00                	mov    (%rax),%eax
  8025df:	89 c1                	mov    %eax,%ecx
  8025e1:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  8025e5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025e8:	89 ce                	mov    %ecx,%esi
  8025ea:	89 c7                	mov    %eax,%edi
  8025ec:	48 b8 7d 21 80 00 00 	movabs $0x80217d,%rax
  8025f3:	00 00 00 
  8025f6:	ff d0                	callq  *%rax
  8025f8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8025fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8025ff:	79 05                	jns    802606 <serve_stat+0x4c>
		return r;
  802601:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802604:	eb 5f                	jmp    802665 <serve_stat+0xab>

	strcpy(ret->ret_name, o->o_file->f_name);
  802606:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80260a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80260e:	48 89 c2             	mov    %rax,%rdx
  802611:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802615:	48 89 d6             	mov    %rdx,%rsi
  802618:	48 89 c7             	mov    %rax,%rdi
  80261b:	48 b8 26 43 80 00 00 	movabs $0x804326,%rax
  802622:	00 00 00 
  802625:	ff d0                	callq  *%rax
	ret->ret_size = o->o_file->f_size;
  802627:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80262b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80262f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802635:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802639:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  80263f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802643:	48 8b 40 08          	mov    0x8(%rax),%rax
  802647:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  80264d:	83 f8 01             	cmp    $0x1,%eax
  802650:	0f 94 c0             	sete   %al
  802653:	0f b6 d0             	movzbl %al,%edx
  802656:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80265a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802660:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802665:	c9                   	leaveq 
  802666:	c3                   	retq   

0000000000802667 <serve_flush>:

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  802667:	55                   	push   %rbp
  802668:	48 89 e5             	mov    %rsp,%rbp
  80266b:	48 83 ec 20          	sub    $0x20,%rsp
  80266f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802672:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802676:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80267a:	8b 00                	mov    (%rax),%eax
  80267c:	89 c1                	mov    %eax,%ecx
  80267e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802682:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802685:	89 ce                	mov    %ecx,%esi
  802687:	89 c7                	mov    %eax,%edi
  802689:	48 b8 7d 21 80 00 00 	movabs $0x80217d,%rax
  802690:	00 00 00 
  802693:	ff d0                	callq  *%rax
  802695:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802698:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80269c:	79 05                	jns    8026a3 <serve_flush+0x3c>
		return r;
  80269e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a1:	eb 1c                	jmp    8026bf <serve_flush+0x58>
	file_flush(o->o_file);
  8026a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8026ab:	48 89 c7             	mov    %rax,%rdi
  8026ae:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  8026b5:	00 00 00 
  8026b8:	ff d0                	callq  *%rax
	return 0;
  8026ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026bf:	c9                   	leaveq 
  8026c0:	c3                   	retq   

00000000008026c1 <serve_remove>:

// Remove the file req->req_path.
int
serve_remove(envid_t envid, struct Fsreq_remove *req)
{
  8026c1:	55                   	push   %rbp
  8026c2:	48 89 e5             	mov    %rsp,%rbp
  8026c5:	48 81 ec 10 04 00 00 	sub    $0x410,%rsp
  8026cc:	89 bd fc fb ff ff    	mov    %edi,-0x404(%rbp)
  8026d2:	48 89 b5 f0 fb ff ff 	mov    %rsi,-0x410(%rbp)

	// Delete the named file.
	// Note: This request doesn't refer to an open file.

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  8026d9:	48 8b 8d f0 fb ff ff 	mov    -0x410(%rbp),%rcx
  8026e0:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  8026e7:	ba 00 04 00 00       	mov    $0x400,%edx
  8026ec:	48 89 ce             	mov    %rcx,%rsi
  8026ef:	48 89 c7             	mov    %rax,%rdi
  8026f2:	48 b8 4a 46 80 00 00 	movabs $0x80464a,%rax
  8026f9:	00 00 00 
  8026fc:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  8026fe:	c6 45 ff 00          	movb   $0x0,-0x1(%rbp)

	// Delete the specified file
	return file_remove(path);
  802702:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  802709:	48 89 c7             	mov    %rax,%rdi
  80270c:	48 b8 06 1e 80 00 00 	movabs $0x801e06,%rax
  802713:	00 00 00 
  802716:	ff d0                	callq  *%rax
}
  802718:	c9                   	leaveq 
  802719:	c3                   	retq   

000000000080271a <serve_sync>:

// Sync the file system.
int
serve_sync(envid_t envid, union Fsipc *req)
{
  80271a:	55                   	push   %rbp
  80271b:	48 89 e5             	mov    %rsp,%rbp
  80271e:	48 83 ec 10          	sub    $0x10,%rsp
  802722:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802725:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	fs_sync();
  802729:	48 b8 88 1e 80 00 00 	movabs $0x801e88,%rax
  802730:	00 00 00 
  802733:	ff d0                	callq  *%rax
	return 0;
  802735:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80273a:	c9                   	leaveq 
  80273b:	c3                   	retq   

000000000080273c <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  80273c:	55                   	push   %rbp
  80273d:	48 89 e5             	mov    %rsp,%rbp
  802740:	48 83 ec 20          	sub    $0x20,%rsp
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  802744:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  80274b:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  802752:	00 00 00 
  802755:	48 8b 08             	mov    (%rax),%rcx
  802758:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80275c:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
  802760:	48 89 ce             	mov    %rcx,%rsi
  802763:	48 89 c7             	mov    %rax,%rdi
  802766:	48 b8 5d 51 80 00 00 	movabs $0x80515d,%rax
  80276d:	00 00 00 
  802770:	ff d0                	callq  *%rax
  802772:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  802775:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802778:	83 e0 01             	and    $0x1,%eax
  80277b:	85 c0                	test   %eax,%eax
  80277d:	75 23                	jne    8027a2 <serve+0x66>
			cprintf("Invalid request from %08x: no argument page\n",
  80277f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802782:	89 c6                	mov    %eax,%esi
  802784:	48 bf 00 79 80 00 00 	movabs $0x807900,%rdi
  80278b:	00 00 00 
  80278e:	b8 00 00 00 00       	mov    $0x0,%eax
  802793:	48 ba 71 37 80 00 00 	movabs $0x803771,%rdx
  80279a:	00 00 00 
  80279d:	ff d2                	callq  *%rdx
				whom);
			continue; // just leave it hanging...
  80279f:	90                   	nop
		}
		ipc_send(whom, r, pg, perm);
		if(debug)
			cprintf("FS: Sent response %d to %x\n", r, whom);
		sys_page_unmap(0, fsreq);
	}
  8027a0:	eb a2                	jmp    802744 <serve+0x8>
			cprintf("Invalid request from %08x: no argument page\n",
				whom);
			continue; // just leave it hanging...
		}

		pg = NULL;
  8027a2:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8027a9:	00 
		if (req == FSREQ_OPEN) {
  8027aa:	83 7d f8 01          	cmpl   $0x1,-0x8(%rbp)
  8027ae:	75 2b                	jne    8027db <serve+0x9f>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  8027b0:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  8027b7:	00 00 00 
  8027ba:	48 8b 30             	mov    (%rax),%rsi
  8027bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8027c0:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  8027c4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027c8:	89 c7                	mov    %eax,%edi
  8027ca:	48 b8 f1 21 80 00 00 	movabs $0x8021f1,%rax
  8027d1:	00 00 00 
  8027d4:	ff d0                	callq  *%rax
  8027d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d9:	eb 73                	jmp    80284e <serve+0x112>
		} else if (req < NHANDLERS && handlers[req]) {
  8027db:	83 7d f8 08          	cmpl   $0x8,-0x8(%rbp)
  8027df:	77 43                	ja     802824 <serve+0xe8>
  8027e1:	48 b8 40 20 81 00 00 	movabs $0x812040,%rax
  8027e8:	00 00 00 
  8027eb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8027ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027f2:	48 85 c0             	test   %rax,%rax
  8027f5:	74 2d                	je     802824 <serve+0xe8>
			r = handlers[req](whom, fsreq);
  8027f7:	48 b8 40 20 81 00 00 	movabs $0x812040,%rax
  8027fe:	00 00 00 
  802801:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802804:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802808:	48 ba 20 20 81 00 00 	movabs $0x812020,%rdx
  80280f:	00 00 00 
  802812:	48 8b 0a             	mov    (%rdx),%rcx
  802815:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802818:	48 89 ce             	mov    %rcx,%rsi
  80281b:	89 d7                	mov    %edx,%edi
  80281d:	ff d0                	callq  *%rax
  80281f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802822:	eb 2a                	jmp    80284e <serve+0x112>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  802824:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802827:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80282a:	89 c6                	mov    %eax,%esi
  80282c:	48 bf 30 79 80 00 00 	movabs $0x807930,%rdi
  802833:	00 00 00 
  802836:	b8 00 00 00 00       	mov    $0x0,%eax
  80283b:	48 b9 71 37 80 00 00 	movabs $0x803771,%rcx
  802842:	00 00 00 
  802845:	ff d1                	callq  *%rcx
			r = -E_INVAL;
  802847:	c7 45 fc fd ff ff ff 	movl   $0xfffffffd,-0x4(%rbp)
		}
		ipc_send(whom, r, pg, perm);
  80284e:	8b 4d f0             	mov    -0x10(%rbp),%ecx
  802851:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802855:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802858:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80285b:	89 c7                	mov    %eax,%edi
  80285d:	48 b8 1e 52 80 00 00 	movabs $0x80521e,%rax
  802864:	00 00 00 
  802867:	ff d0                	callq  *%rax
		if(debug)
			cprintf("FS: Sent response %d to %x\n", r, whom);
		sys_page_unmap(0, fsreq);
  802869:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  802870:	00 00 00 
  802873:	48 8b 00             	mov    (%rax),%rax
  802876:	48 89 c6             	mov    %rax,%rsi
  802879:	bf 00 00 00 00       	mov    $0x0,%edi
  80287e:	48 b8 00 4d 80 00 00 	movabs $0x804d00,%rax
  802885:	00 00 00 
  802888:	ff d0                	callq  *%rax
	}
  80288a:	e9 b5 fe ff ff       	jmpq   802744 <serve+0x8>

000000000080288f <umain>:
}

void
umain(int argc, char **argv)
{
  80288f:	55                   	push   %rbp
  802890:	48 89 e5             	mov    %rsp,%rbp
  802893:	48 83 ec 20          	sub    $0x20,%rsp
  802897:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80289a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  80289e:	48 b8 90 20 81 00 00 	movabs $0x812090,%rax
  8028a5:	00 00 00 
  8028a8:	48 b9 53 79 80 00 00 	movabs $0x807953,%rcx
  8028af:	00 00 00 
  8028b2:	48 89 08             	mov    %rcx,(%rax)
	cprintf("FS is running\n");
  8028b5:	48 bf 56 79 80 00 00 	movabs $0x807956,%rdi
  8028bc:	00 00 00 
  8028bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c4:	48 ba 71 37 80 00 00 	movabs $0x803771,%rdx
  8028cb:	00 00 00 
  8028ce:	ff d2                	callq  *%rdx
  8028d0:	c7 45 fc 00 8a 00 00 	movl   $0x8a00,-0x4(%rbp)
  8028d7:	66 c7 45 fa 00 8a    	movw   $0x8a00,-0x6(%rbp)
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  8028dd:	0f b7 45 fa          	movzwl -0x6(%rbp),%eax
  8028e1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028e4:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  8028e6:	48 bf 65 79 80 00 00 	movabs $0x807965,%rdi
  8028ed:	00 00 00 
  8028f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f5:	48 ba 71 37 80 00 00 	movabs $0x803771,%rdx
  8028fc:	00 00 00 
  8028ff:	ff d2                	callq  *%rdx

	serve_init();
  802901:	48 b8 d9 1e 80 00 00 	movabs $0x801ed9,%rax
  802908:	00 00 00 
  80290b:	ff d0                	callq  *%rax
	fs_init();
  80290d:	48 b8 89 10 80 00 00 	movabs $0x801089,%rax
  802914:	00 00 00 
  802917:	ff d0                	callq  *%rax

	serve();
  802919:	48 b8 3c 27 80 00 00 	movabs $0x80273c,%rax
  802920:	00 00 00 
  802923:	ff d0                	callq  *%rax
}
  802925:	c9                   	leaveq 
  802926:	c3                   	retq   

0000000000802927 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  802927:	55                   	push   %rbp
  802928:	48 89 e5             	mov    %rsp,%rbp
  80292b:	48 83 ec 20          	sub    $0x20,%rsp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  80292f:	ba 07 00 00 00       	mov    $0x7,%edx
  802934:	be 00 10 00 00       	mov    $0x1000,%esi
  802939:	bf 00 00 00 00       	mov    $0x0,%edi
  80293e:	48 b8 55 4c 80 00 00 	movabs $0x804c55,%rax
  802945:	00 00 00 
  802948:	ff d0                	callq  *%rax
  80294a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80294d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802951:	79 30                	jns    802983 <fs_test+0x5c>
		panic("sys_page_alloc: %e", r);
  802953:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802956:	89 c1                	mov    %eax,%ecx
  802958:	48 ba 9e 79 80 00 00 	movabs $0x80799e,%rdx
  80295f:	00 00 00 
  802962:	be 14 00 00 00       	mov    $0x14,%esi
  802967:	48 bf b1 79 80 00 00 	movabs $0x8079b1,%rdi
  80296e:	00 00 00 
  802971:	b8 00 00 00 00       	mov    $0x0,%eax
  802976:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  80297d:	00 00 00 
  802980:	41 ff d0             	callq  *%r8
	bits = (uint32_t*) PGSIZE;
  802983:	48 c7 45 f0 00 10 00 	movq   $0x1000,-0x10(%rbp)
  80298a:	00 
	memmove(bits, bitmap, PGSIZE);
  80298b:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
  802992:	00 00 00 
  802995:	48 8b 08             	mov    (%rax),%rcx
  802998:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80299c:	ba 00 10 00 00       	mov    $0x1000,%edx
  8029a1:	48 89 ce             	mov    %rcx,%rsi
  8029a4:	48 89 c7             	mov    %rax,%rdi
  8029a7:	48 b8 4a 46 80 00 00 	movabs $0x80464a,%rax
  8029ae:	00 00 00 
  8029b1:	ff d0                	callq  *%rax
	// allocate block
	if ((r = alloc_block()) < 0)
  8029b3:	48 b8 2f 0e 80 00 00 	movabs $0x800e2f,%rax
  8029ba:	00 00 00 
  8029bd:	ff d0                	callq  *%rax
  8029bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029c6:	79 30                	jns    8029f8 <fs_test+0xd1>
		panic("alloc_block: %e", r);
  8029c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029cb:	89 c1                	mov    %eax,%ecx
  8029cd:	48 ba bb 79 80 00 00 	movabs $0x8079bb,%rdx
  8029d4:	00 00 00 
  8029d7:	be 19 00 00 00       	mov    $0x19,%esi
  8029dc:	48 bf b1 79 80 00 00 	movabs $0x8079b1,%rdi
  8029e3:	00 00 00 
  8029e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029eb:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  8029f2:	00 00 00 
  8029f5:	41 ff d0             	callq  *%r8
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  8029f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029fb:	8d 50 1f             	lea    0x1f(%rax),%edx
  8029fe:	85 c0                	test   %eax,%eax
  802a00:	0f 48 c2             	cmovs  %edx,%eax
  802a03:	c1 f8 05             	sar    $0x5,%eax
  802a06:	48 98                	cltq   
  802a08:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  802a0f:	00 
  802a10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a14:	48 01 d0             	add    %rdx,%rax
  802a17:	8b 30                	mov    (%rax),%esi
  802a19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1c:	99                   	cltd   
  802a1d:	c1 ea 1b             	shr    $0x1b,%edx
  802a20:	01 d0                	add    %edx,%eax
  802a22:	83 e0 1f             	and    $0x1f,%eax
  802a25:	29 d0                	sub    %edx,%eax
  802a27:	ba 01 00 00 00       	mov    $0x1,%edx
  802a2c:	89 c1                	mov    %eax,%ecx
  802a2e:	d3 e2                	shl    %cl,%edx
  802a30:	89 d0                	mov    %edx,%eax
  802a32:	21 f0                	and    %esi,%eax
  802a34:	85 c0                	test   %eax,%eax
  802a36:	75 35                	jne    802a6d <fs_test+0x146>
  802a38:	48 b9 cb 79 80 00 00 	movabs $0x8079cb,%rcx
  802a3f:	00 00 00 
  802a42:	48 ba e6 79 80 00 00 	movabs $0x8079e6,%rdx
  802a49:	00 00 00 
  802a4c:	be 1b 00 00 00       	mov    $0x1b,%esi
  802a51:	48 bf b1 79 80 00 00 	movabs $0x8079b1,%rdi
  802a58:	00 00 00 
  802a5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a60:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  802a67:	00 00 00 
  802a6a:	41 ff d0             	callq  *%r8
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  802a6d:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
  802a74:	00 00 00 
  802a77:	48 8b 10             	mov    (%rax),%rdx
  802a7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a7d:	8d 48 1f             	lea    0x1f(%rax),%ecx
  802a80:	85 c0                	test   %eax,%eax
  802a82:	0f 48 c1             	cmovs  %ecx,%eax
  802a85:	c1 f8 05             	sar    $0x5,%eax
  802a88:	48 98                	cltq   
  802a8a:	48 c1 e0 02          	shl    $0x2,%rax
  802a8e:	48 01 d0             	add    %rdx,%rax
  802a91:	8b 30                	mov    (%rax),%esi
  802a93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a96:	99                   	cltd   
  802a97:	c1 ea 1b             	shr    $0x1b,%edx
  802a9a:	01 d0                	add    %edx,%eax
  802a9c:	83 e0 1f             	and    $0x1f,%eax
  802a9f:	29 d0                	sub    %edx,%eax
  802aa1:	ba 01 00 00 00       	mov    $0x1,%edx
  802aa6:	89 c1                	mov    %eax,%ecx
  802aa8:	d3 e2                	shl    %cl,%edx
  802aaa:	89 d0                	mov    %edx,%eax
  802aac:	21 f0                	and    %esi,%eax
  802aae:	85 c0                	test   %eax,%eax
  802ab0:	74 35                	je     802ae7 <fs_test+0x1c0>
  802ab2:	48 b9 00 7a 80 00 00 	movabs $0x807a00,%rcx
  802ab9:	00 00 00 
  802abc:	48 ba e6 79 80 00 00 	movabs $0x8079e6,%rdx
  802ac3:	00 00 00 
  802ac6:	be 1d 00 00 00       	mov    $0x1d,%esi
  802acb:	48 bf b1 79 80 00 00 	movabs $0x8079b1,%rdi
  802ad2:	00 00 00 
  802ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  802ada:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  802ae1:	00 00 00 
  802ae4:	41 ff d0             	callq  *%r8
	cprintf("alloc_block is good\n");
  802ae7:	48 bf 20 7a 80 00 00 	movabs $0x807a20,%rdi
  802aee:	00 00 00 
  802af1:	b8 00 00 00 00       	mov    $0x0,%eax
  802af6:	48 ba 71 37 80 00 00 	movabs $0x803771,%rdx
  802afd:	00 00 00 
  802b00:	ff d2                	callq  *%rdx

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  802b02:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802b06:	48 89 c6             	mov    %rax,%rsi
  802b09:	48 bf 35 7a 80 00 00 	movabs $0x807a35,%rdi
  802b10:	00 00 00 
  802b13:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  802b1a:	00 00 00 
  802b1d:	ff d0                	callq  *%rax
  802b1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b26:	79 36                	jns    802b5e <fs_test+0x237>
  802b28:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  802b2c:	74 30                	je     802b5e <fs_test+0x237>
		panic("file_open /not-found: %e", r);
  802b2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b31:	89 c1                	mov    %eax,%ecx
  802b33:	48 ba 40 7a 80 00 00 	movabs $0x807a40,%rdx
  802b3a:	00 00 00 
  802b3d:	be 21 00 00 00       	mov    $0x21,%esi
  802b42:	48 bf b1 79 80 00 00 	movabs $0x8079b1,%rdi
  802b49:	00 00 00 
  802b4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b51:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  802b58:	00 00 00 
  802b5b:	41 ff d0             	callq  *%r8
	else if (r == 0)
  802b5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b62:	75 2a                	jne    802b8e <fs_test+0x267>
		panic("file_open /not-found succeeded!");
  802b64:	48 ba 60 7a 80 00 00 	movabs $0x807a60,%rdx
  802b6b:	00 00 00 
  802b6e:	be 23 00 00 00       	mov    $0x23,%esi
  802b73:	48 bf b1 79 80 00 00 	movabs $0x8079b1,%rdi
  802b7a:	00 00 00 
  802b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b82:	48 b9 38 35 80 00 00 	movabs $0x803538,%rcx
  802b89:	00 00 00 
  802b8c:	ff d1                	callq  *%rcx
	if ((r = file_open("/newmotd", &f)) < 0)
  802b8e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802b92:	48 89 c6             	mov    %rax,%rsi
  802b95:	48 bf 80 7a 80 00 00 	movabs $0x807a80,%rdi
  802b9c:	00 00 00 
  802b9f:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  802ba6:	00 00 00 
  802ba9:	ff d0                	callq  *%rax
  802bab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb2:	79 30                	jns    802be4 <fs_test+0x2bd>
		panic("file_open /newmotd: %e", r);
  802bb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb7:	89 c1                	mov    %eax,%ecx
  802bb9:	48 ba 89 7a 80 00 00 	movabs $0x807a89,%rdx
  802bc0:	00 00 00 
  802bc3:	be 25 00 00 00       	mov    $0x25,%esi
  802bc8:	48 bf b1 79 80 00 00 	movabs $0x8079b1,%rdi
  802bcf:	00 00 00 
  802bd2:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd7:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  802bde:	00 00 00 
  802be1:	41 ff d0             	callq  *%r8
	cprintf("file_open is good\n");
  802be4:	48 bf a0 7a 80 00 00 	movabs $0x807aa0,%rdi
  802beb:	00 00 00 
  802bee:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf3:	48 ba 71 37 80 00 00 	movabs $0x803771,%rdx
  802bfa:	00 00 00 
  802bfd:	ff d2                	callq  *%rdx

	if ((r = file_get_block(f, 0, &blk)) < 0)
  802bff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c03:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802c07:	be 00 00 00 00       	mov    $0x0,%esi
  802c0c:	48 89 c7             	mov    %rax,%rdi
  802c0f:	48 b8 10 12 80 00 00 	movabs $0x801210,%rax
  802c16:	00 00 00 
  802c19:	ff d0                	callq  *%rax
  802c1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c22:	79 30                	jns    802c54 <fs_test+0x32d>
		panic("file_get_block: %e", r);
  802c24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c27:	89 c1                	mov    %eax,%ecx
  802c29:	48 ba b3 7a 80 00 00 	movabs $0x807ab3,%rdx
  802c30:	00 00 00 
  802c33:	be 29 00 00 00       	mov    $0x29,%esi
  802c38:	48 bf b1 79 80 00 00 	movabs $0x8079b1,%rdi
  802c3f:	00 00 00 
  802c42:	b8 00 00 00 00       	mov    $0x0,%eax
  802c47:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  802c4e:	00 00 00 
  802c51:	41 ff d0             	callq  *%r8
	if (strcmp(blk, msg) != 0)
  802c54:	48 b8 88 20 81 00 00 	movabs $0x812088,%rax
  802c5b:	00 00 00 
  802c5e:	48 8b 10             	mov    (%rax),%rdx
  802c61:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c65:	48 89 d6             	mov    %rdx,%rsi
  802c68:	48 89 c7             	mov    %rax,%rdi
  802c6b:	48 b8 88 44 80 00 00 	movabs $0x804488,%rax
  802c72:	00 00 00 
  802c75:	ff d0                	callq  *%rax
  802c77:	85 c0                	test   %eax,%eax
  802c79:	74 2a                	je     802ca5 <fs_test+0x37e>
		panic("file_get_block returned wrong data");
  802c7b:	48 ba c8 7a 80 00 00 	movabs $0x807ac8,%rdx
  802c82:	00 00 00 
  802c85:	be 2b 00 00 00       	mov    $0x2b,%esi
  802c8a:	48 bf b1 79 80 00 00 	movabs $0x8079b1,%rdi
  802c91:	00 00 00 
  802c94:	b8 00 00 00 00       	mov    $0x0,%eax
  802c99:	48 b9 38 35 80 00 00 	movabs $0x803538,%rcx
  802ca0:	00 00 00 
  802ca3:	ff d1                	callq  *%rcx
	cprintf("file_get_block is good\n");
  802ca5:	48 bf eb 7a 80 00 00 	movabs $0x807aeb,%rdi
  802cac:	00 00 00 
  802caf:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb4:	48 ba 71 37 80 00 00 	movabs $0x803771,%rdx
  802cbb:	00 00 00 
  802cbe:	ff d2                	callq  *%rdx

	*(volatile char*)blk = *(volatile char*)blk;
  802cc0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cc4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cc8:	0f b6 12             	movzbl (%rdx),%edx
  802ccb:	88 10                	mov    %dl,(%rax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  802ccd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cd1:	48 c1 e8 0c          	shr    $0xc,%rax
  802cd5:	48 89 c2             	mov    %rax,%rdx
  802cd8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cdf:	01 00 00 
  802ce2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ce6:	83 e0 40             	and    $0x40,%eax
  802ce9:	48 85 c0             	test   %rax,%rax
  802cec:	75 35                	jne    802d23 <fs_test+0x3fc>
  802cee:	48 b9 03 7b 80 00 00 	movabs $0x807b03,%rcx
  802cf5:	00 00 00 
  802cf8:	48 ba e6 79 80 00 00 	movabs $0x8079e6,%rdx
  802cff:	00 00 00 
  802d02:	be 2f 00 00 00       	mov    $0x2f,%esi
  802d07:	48 bf b1 79 80 00 00 	movabs $0x8079b1,%rdi
  802d0e:	00 00 00 
  802d11:	b8 00 00 00 00       	mov    $0x0,%eax
  802d16:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  802d1d:	00 00 00 
  802d20:	41 ff d0             	callq  *%r8
	file_flush(f);
  802d23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d27:	48 89 c7             	mov    %rax,%rdi
  802d2a:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  802d31:	00 00 00 
  802d34:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  802d36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d3a:	48 c1 e8 0c          	shr    $0xc,%rax
  802d3e:	48 89 c2             	mov    %rax,%rdx
  802d41:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d48:	01 00 00 
  802d4b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d4f:	83 e0 40             	and    $0x40,%eax
  802d52:	48 85 c0             	test   %rax,%rax
  802d55:	74 35                	je     802d8c <fs_test+0x465>
  802d57:	48 b9 1e 7b 80 00 00 	movabs $0x807b1e,%rcx
  802d5e:	00 00 00 
  802d61:	48 ba e6 79 80 00 00 	movabs $0x8079e6,%rdx
  802d68:	00 00 00 
  802d6b:	be 31 00 00 00       	mov    $0x31,%esi
  802d70:	48 bf b1 79 80 00 00 	movabs $0x8079b1,%rdi
  802d77:	00 00 00 
  802d7a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d7f:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  802d86:	00 00 00 
  802d89:	41 ff d0             	callq  *%r8
	cprintf("file_flush is good\n");
  802d8c:	48 bf 3a 7b 80 00 00 	movabs $0x807b3a,%rdi
  802d93:	00 00 00 
  802d96:	b8 00 00 00 00       	mov    $0x0,%eax
  802d9b:	48 ba 71 37 80 00 00 	movabs $0x803771,%rdx
  802da2:	00 00 00 
  802da5:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, 0)) < 0)
  802da7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dab:	be 00 00 00 00       	mov    $0x0,%esi
  802db0:	48 89 c7             	mov    %rax,%rdi
  802db3:	48 b8 bf 1c 80 00 00 	movabs $0x801cbf,%rax
  802dba:	00 00 00 
  802dbd:	ff d0                	callq  *%rax
  802dbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc6:	79 30                	jns    802df8 <fs_test+0x4d1>
		panic("file_set_size: %e", r);
  802dc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dcb:	89 c1                	mov    %eax,%ecx
  802dcd:	48 ba 4e 7b 80 00 00 	movabs $0x807b4e,%rdx
  802dd4:	00 00 00 
  802dd7:	be 35 00 00 00       	mov    $0x35,%esi
  802ddc:	48 bf b1 79 80 00 00 	movabs $0x8079b1,%rdi
  802de3:	00 00 00 
  802de6:	b8 00 00 00 00       	mov    $0x0,%eax
  802deb:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  802df2:	00 00 00 
  802df5:	41 ff d0             	callq  *%r8
	assert(f->f_direct[0] == 0);
  802df8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dfc:	8b 80 88 00 00 00    	mov    0x88(%rax),%eax
  802e02:	85 c0                	test   %eax,%eax
  802e04:	74 35                	je     802e3b <fs_test+0x514>
  802e06:	48 b9 60 7b 80 00 00 	movabs $0x807b60,%rcx
  802e0d:	00 00 00 
  802e10:	48 ba e6 79 80 00 00 	movabs $0x8079e6,%rdx
  802e17:	00 00 00 
  802e1a:	be 36 00 00 00       	mov    $0x36,%esi
  802e1f:	48 bf b1 79 80 00 00 	movabs $0x8079b1,%rdi
  802e26:	00 00 00 
  802e29:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2e:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  802e35:	00 00 00 
  802e38:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802e3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e3f:	48 c1 e8 0c          	shr    $0xc,%rax
  802e43:	48 89 c2             	mov    %rax,%rdx
  802e46:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e4d:	01 00 00 
  802e50:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e54:	83 e0 40             	and    $0x40,%eax
  802e57:	48 85 c0             	test   %rax,%rax
  802e5a:	74 35                	je     802e91 <fs_test+0x56a>
  802e5c:	48 b9 74 7b 80 00 00 	movabs $0x807b74,%rcx
  802e63:	00 00 00 
  802e66:	48 ba e6 79 80 00 00 	movabs $0x8079e6,%rdx
  802e6d:	00 00 00 
  802e70:	be 37 00 00 00       	mov    $0x37,%esi
  802e75:	48 bf b1 79 80 00 00 	movabs $0x8079b1,%rdi
  802e7c:	00 00 00 
  802e7f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e84:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  802e8b:	00 00 00 
  802e8e:	41 ff d0             	callq  *%r8
	cprintf("file_truncate is good\n");
  802e91:	48 bf 8e 7b 80 00 00 	movabs $0x807b8e,%rdi
  802e98:	00 00 00 
  802e9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea0:	48 ba 71 37 80 00 00 	movabs $0x803771,%rdx
  802ea7:	00 00 00 
  802eaa:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, strlen(msg))) < 0)
  802eac:	48 b8 88 20 81 00 00 	movabs $0x812088,%rax
  802eb3:	00 00 00 
  802eb6:	48 8b 00             	mov    (%rax),%rax
  802eb9:	48 89 c7             	mov    %rax,%rdi
  802ebc:	48 b8 ba 42 80 00 00 	movabs $0x8042ba,%rax
  802ec3:	00 00 00 
  802ec6:	ff d0                	callq  *%rax
  802ec8:	89 c2                	mov    %eax,%edx
  802eca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ece:	89 d6                	mov    %edx,%esi
  802ed0:	48 89 c7             	mov    %rax,%rdi
  802ed3:	48 b8 bf 1c 80 00 00 	movabs $0x801cbf,%rax
  802eda:	00 00 00 
  802edd:	ff d0                	callq  *%rax
  802edf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ee2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee6:	79 30                	jns    802f18 <fs_test+0x5f1>
		panic("file_set_size 2: %e", r);
  802ee8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eeb:	89 c1                	mov    %eax,%ecx
  802eed:	48 ba a5 7b 80 00 00 	movabs $0x807ba5,%rdx
  802ef4:	00 00 00 
  802ef7:	be 3b 00 00 00       	mov    $0x3b,%esi
  802efc:	48 bf b1 79 80 00 00 	movabs $0x8079b1,%rdi
  802f03:	00 00 00 
  802f06:	b8 00 00 00 00       	mov    $0x0,%eax
  802f0b:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  802f12:	00 00 00 
  802f15:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802f18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f1c:	48 c1 e8 0c          	shr    $0xc,%rax
  802f20:	48 89 c2             	mov    %rax,%rdx
  802f23:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f2a:	01 00 00 
  802f2d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f31:	83 e0 40             	and    $0x40,%eax
  802f34:	48 85 c0             	test   %rax,%rax
  802f37:	74 35                	je     802f6e <fs_test+0x647>
  802f39:	48 b9 74 7b 80 00 00 	movabs $0x807b74,%rcx
  802f40:	00 00 00 
  802f43:	48 ba e6 79 80 00 00 	movabs $0x8079e6,%rdx
  802f4a:	00 00 00 
  802f4d:	be 3c 00 00 00       	mov    $0x3c,%esi
  802f52:	48 bf b1 79 80 00 00 	movabs $0x8079b1,%rdi
  802f59:	00 00 00 
  802f5c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f61:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  802f68:	00 00 00 
  802f6b:	41 ff d0             	callq  *%r8
	if ((r = file_get_block(f, 0, &blk)) < 0)
  802f6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f72:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802f76:	be 00 00 00 00       	mov    $0x0,%esi
  802f7b:	48 89 c7             	mov    %rax,%rdi
  802f7e:	48 b8 10 12 80 00 00 	movabs $0x801210,%rax
  802f85:	00 00 00 
  802f88:	ff d0                	callq  *%rax
  802f8a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f91:	79 30                	jns    802fc3 <fs_test+0x69c>
		panic("file_get_block 2: %e", r);
  802f93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f96:	89 c1                	mov    %eax,%ecx
  802f98:	48 ba b9 7b 80 00 00 	movabs $0x807bb9,%rdx
  802f9f:	00 00 00 
  802fa2:	be 3e 00 00 00       	mov    $0x3e,%esi
  802fa7:	48 bf b1 79 80 00 00 	movabs $0x8079b1,%rdi
  802fae:	00 00 00 
  802fb1:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb6:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  802fbd:	00 00 00 
  802fc0:	41 ff d0             	callq  *%r8
	strcpy(blk, msg);
  802fc3:	48 b8 88 20 81 00 00 	movabs $0x812088,%rax
  802fca:	00 00 00 
  802fcd:	48 8b 10             	mov    (%rax),%rdx
  802fd0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fd4:	48 89 d6             	mov    %rdx,%rsi
  802fd7:	48 89 c7             	mov    %rax,%rdi
  802fda:	48 b8 26 43 80 00 00 	movabs $0x804326,%rax
  802fe1:	00 00 00 
  802fe4:	ff d0                	callq  *%rax
	assert((uvpt[PGNUM(blk)] & PTE_D));
  802fe6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fea:	48 c1 e8 0c          	shr    $0xc,%rax
  802fee:	48 89 c2             	mov    %rax,%rdx
  802ff1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ff8:	01 00 00 
  802ffb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802fff:	83 e0 40             	and    $0x40,%eax
  803002:	48 85 c0             	test   %rax,%rax
  803005:	75 35                	jne    80303c <fs_test+0x715>
  803007:	48 b9 03 7b 80 00 00 	movabs $0x807b03,%rcx
  80300e:	00 00 00 
  803011:	48 ba e6 79 80 00 00 	movabs $0x8079e6,%rdx
  803018:	00 00 00 
  80301b:	be 40 00 00 00       	mov    $0x40,%esi
  803020:	48 bf b1 79 80 00 00 	movabs $0x8079b1,%rdi
  803027:	00 00 00 
  80302a:	b8 00 00 00 00       	mov    $0x0,%eax
  80302f:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  803036:	00 00 00 
  803039:	41 ff d0             	callq  *%r8
	file_flush(f);
  80303c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803040:	48 89 c7             	mov    %rax,%rdi
  803043:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  80304a:	00 00 00 
  80304d:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  80304f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803053:	48 c1 e8 0c          	shr    $0xc,%rax
  803057:	48 89 c2             	mov    %rax,%rdx
  80305a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803061:	01 00 00 
  803064:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803068:	83 e0 40             	and    $0x40,%eax
  80306b:	48 85 c0             	test   %rax,%rax
  80306e:	74 35                	je     8030a5 <fs_test+0x77e>
  803070:	48 b9 1e 7b 80 00 00 	movabs $0x807b1e,%rcx
  803077:	00 00 00 
  80307a:	48 ba e6 79 80 00 00 	movabs $0x8079e6,%rdx
  803081:	00 00 00 
  803084:	be 42 00 00 00       	mov    $0x42,%esi
  803089:	48 bf b1 79 80 00 00 	movabs $0x8079b1,%rdi
  803090:	00 00 00 
  803093:	b8 00 00 00 00       	mov    $0x0,%eax
  803098:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  80309f:	00 00 00 
  8030a2:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8030a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030a9:	48 c1 e8 0c          	shr    $0xc,%rax
  8030ad:	48 89 c2             	mov    %rax,%rdx
  8030b0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8030b7:	01 00 00 
  8030ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8030be:	83 e0 40             	and    $0x40,%eax
  8030c1:	48 85 c0             	test   %rax,%rax
  8030c4:	74 35                	je     8030fb <fs_test+0x7d4>
  8030c6:	48 b9 74 7b 80 00 00 	movabs $0x807b74,%rcx
  8030cd:	00 00 00 
  8030d0:	48 ba e6 79 80 00 00 	movabs $0x8079e6,%rdx
  8030d7:	00 00 00 
  8030da:	be 43 00 00 00       	mov    $0x43,%esi
  8030df:	48 bf b1 79 80 00 00 	movabs $0x8079b1,%rdi
  8030e6:	00 00 00 
  8030e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ee:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  8030f5:	00 00 00 
  8030f8:	41 ff d0             	callq  *%r8
	cprintf("file rewrite is good\n");
  8030fb:	48 bf ce 7b 80 00 00 	movabs $0x807bce,%rdi
  803102:	00 00 00 
  803105:	b8 00 00 00 00       	mov    $0x0,%eax
  80310a:	48 ba 71 37 80 00 00 	movabs $0x803771,%rdx
  803111:	00 00 00 
  803114:	ff d2                	callq  *%rdx
}
  803116:	c9                   	leaveq 
  803117:	c3                   	retq   

0000000000803118 <host_fsipc>:
static struct Fd *host_fd;
static union Fsipc host_fsipcbuf __attribute__((aligned(PGSIZE)));

static int
host_fsipc(unsigned type, void *dstva)
{
  803118:	55                   	push   %rbp
  803119:	48 89 e5             	mov    %rsp,%rbp
  80311c:	48 83 ec 10          	sub    $0x10,%rsp
  803120:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803123:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	ipc_host_send(VMX_HOST_FS_ENV, type, &host_fsipcbuf, PTE_P | PTE_W | PTE_U);
  803127:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80312a:	b9 07 00 00 00       	mov    $0x7,%ecx
  80312f:	48 ba 00 50 81 00 00 	movabs $0x815000,%rdx
  803136:	00 00 00 
  803139:	89 c6                	mov    %eax,%esi
  80313b:	bf 01 00 00 00       	mov    $0x1,%edi
  803140:	48 b8 50 53 80 00 00 	movabs $0x805350,%rax
  803147:	00 00 00 
  80314a:	ff d0                	callq  *%rax
	return ipc_host_recv(dstva);
  80314c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803150:	48 89 c7             	mov    %rax,%rdi
  803153:	48 b8 b4 52 80 00 00 	movabs $0x8052b4,%rax
  80315a:	00 00 00 
  80315d:	ff d0                	callq  *%rax
}
  80315f:	c9                   	leaveq 
  803160:	c3                   	retq   

0000000000803161 <get_host_fd>:


uint64_t
get_host_fd()
{
  803161:	55                   	push   %rbp
  803162:	48 89 e5             	mov    %rsp,%rbp
	return (uint64_t) host_fd;
  803165:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  80316c:	00 00 00 
  80316f:	48 8b 00             	mov    (%rax),%rax
}
  803172:	5d                   	pop    %rbp
  803173:	c3                   	retq   

0000000000803174 <host_read>:

int
host_read(uint32_t secno, void *dst, size_t nsecs)
{
  803174:	55                   	push   %rbp
  803175:	48 89 e5             	mov    %rsp,%rbp
  803178:	48 83 ec 30          	sub    $0x30,%rsp
  80317c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80317f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803183:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r, read = 0;
  803187:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	if(host_fd->fd_file.id == 0) {
  80318e:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  803195:	00 00 00 
  803198:	48 8b 00             	mov    (%rax),%rax
  80319b:	8b 40 0c             	mov    0xc(%rax),%eax
  80319e:	85 c0                	test   %eax,%eax
  8031a0:	75 11                	jne    8031b3 <host_read+0x3f>
		host_ipc_init();
  8031a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a7:	48 ba 61 33 80 00 00 	movabs $0x803361,%rdx
  8031ae:	00 00 00 
  8031b1:	ff d2                	callq  *%rdx
	}

	host_fd->fd_offset = secno * SECTSIZE;
  8031b3:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  8031ba:	00 00 00 
  8031bd:	48 8b 00             	mov    (%rax),%rax
  8031c0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031c3:	c1 e2 09             	shl    $0x9,%edx
  8031c6:	89 50 04             	mov    %edx,0x4(%rax)
	// read from the host, 2 sectors at a time.
	for(; nsecs > 0; nsecs-=2) {
  8031c9:	e9 8c 00 00 00       	jmpq   80325a <host_read+0xe6>

		host_fsipcbuf.read.req_fileid = host_fd->fd_file.id;
  8031ce:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  8031d5:	00 00 00 
  8031d8:	48 8b 00             	mov    (%rax),%rax
  8031db:	8b 50 0c             	mov    0xc(%rax),%edx
  8031de:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  8031e5:	00 00 00 
  8031e8:	89 10                	mov    %edx,(%rax)
		host_fsipcbuf.read.req_n = SECTSIZE * 2;
  8031ea:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  8031f1:	00 00 00 
  8031f4:	48 c7 40 08 00 04 00 	movq   $0x400,0x8(%rax)
  8031fb:	00 
		if ((r = host_fsipc(FSREQ_READ, NULL)) < 0)
  8031fc:	be 00 00 00 00       	mov    $0x0,%esi
  803201:	bf 03 00 00 00       	mov    $0x3,%edi
  803206:	48 b8 18 31 80 00 00 	movabs $0x803118,%rax
  80320d:	00 00 00 
  803210:	ff d0                	callq  *%rax
  803212:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803215:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803219:	79 05                	jns    803220 <host_read+0xac>
			return r;
  80321b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80321e:	eb 4a                	jmp    80326a <host_read+0xf6>
		// FIXME: Handle case where r < SECTSIZE * 2;
		memmove(dst+read, &host_fsipcbuf, r);
  803220:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803223:	48 98                	cltq   
  803225:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803228:	48 63 ca             	movslq %edx,%rcx
  80322b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80322f:	48 01 d1             	add    %rdx,%rcx
  803232:	48 89 c2             	mov    %rax,%rdx
  803235:	48 be 00 50 81 00 00 	movabs $0x815000,%rsi
  80323c:	00 00 00 
  80323f:	48 89 cf             	mov    %rcx,%rdi
  803242:	48 b8 4a 46 80 00 00 	movabs $0x80464a,%rax
  803249:	00 00 00 
  80324c:	ff d0                	callq  *%rax
		read += SECTSIZE * 2;
  80324e:	81 45 fc 00 04 00 00 	addl   $0x400,-0x4(%rbp)
		host_ipc_init();
	}

	host_fd->fd_offset = secno * SECTSIZE;
	// read from the host, 2 sectors at a time.
	for(; nsecs > 0; nsecs-=2) {
  803255:	48 83 6d d8 02       	subq   $0x2,-0x28(%rbp)
  80325a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80325f:	0f 85 69 ff ff ff    	jne    8031ce <host_read+0x5a>
		// FIXME: Handle case where r < SECTSIZE * 2;
		memmove(dst+read, &host_fsipcbuf, r);
		read += SECTSIZE * 2;
	}

	return 0;
  803265:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80326a:	c9                   	leaveq 
  80326b:	c3                   	retq   

000000000080326c <host_write>:

int
host_write(uint32_t secno, const void *src, size_t nsecs)
{
  80326c:	55                   	push   %rbp
  80326d:	48 89 e5             	mov    %rsp,%rbp
  803270:	48 83 ec 30          	sub    $0x30,%rsp
  803274:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803277:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80327b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r, written = 0;
  80327f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	if(host_fd->fd_file.id == 0) {
  803286:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  80328d:	00 00 00 
  803290:	48 8b 00             	mov    (%rax),%rax
  803293:	8b 40 0c             	mov    0xc(%rax),%eax
  803296:	85 c0                	test   %eax,%eax
  803298:	75 11                	jne    8032ab <host_write+0x3f>
		host_ipc_init();
  80329a:	b8 00 00 00 00       	mov    $0x0,%eax
  80329f:	48 ba 61 33 80 00 00 	movabs $0x803361,%rdx
  8032a6:	00 00 00 
  8032a9:	ff d2                	callq  *%rdx
	}

	host_fd->fd_offset = secno * SECTSIZE;
  8032ab:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  8032b2:	00 00 00 
  8032b5:	48 8b 00             	mov    (%rax),%rax
  8032b8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032bb:	c1 e2 09             	shl    $0x9,%edx
  8032be:	89 50 04             	mov    %edx,0x4(%rax)
	for(; nsecs > 0; nsecs-=2) {
  8032c1:	e9 89 00 00 00       	jmpq   80334f <host_write+0xe3>
		host_fsipcbuf.write.req_fileid = host_fd->fd_file.id;
  8032c6:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  8032cd:	00 00 00 
  8032d0:	48 8b 00             	mov    (%rax),%rax
  8032d3:	8b 50 0c             	mov    0xc(%rax),%edx
  8032d6:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  8032dd:	00 00 00 
  8032e0:	89 10                	mov    %edx,(%rax)
		host_fsipcbuf.write.req_n = SECTSIZE * 2;
  8032e2:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  8032e9:	00 00 00 
  8032ec:	48 c7 40 08 00 04 00 	movq   $0x400,0x8(%rax)
  8032f3:	00 
		memmove(host_fsipcbuf.write.req_buf, src+written, SECTSIZE * 2);
  8032f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f7:	48 63 d0             	movslq %eax,%rdx
  8032fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032fe:	48 01 d0             	add    %rdx,%rax
  803301:	ba 00 04 00 00       	mov    $0x400,%edx
  803306:	48 89 c6             	mov    %rax,%rsi
  803309:	48 bf 10 50 81 00 00 	movabs $0x815010,%rdi
  803310:	00 00 00 
  803313:	48 b8 4a 46 80 00 00 	movabs $0x80464a,%rax
  80331a:	00 00 00 
  80331d:	ff d0                	callq  *%rax
		if ((r = host_fsipc(FSREQ_WRITE, NULL)) < 0)
  80331f:	be 00 00 00 00       	mov    $0x0,%esi
  803324:	bf 04 00 00 00       	mov    $0x4,%edi
  803329:	48 b8 18 31 80 00 00 	movabs $0x803118,%rax
  803330:	00 00 00 
  803333:	ff d0                	callq  *%rax
  803335:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803338:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80333c:	79 05                	jns    803343 <host_write+0xd7>
			return r;
  80333e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803341:	eb 1c                	jmp    80335f <host_write+0xf3>
		written += SECTSIZE * 2;
  803343:	81 45 fc 00 04 00 00 	addl   $0x400,-0x4(%rbp)
	if(host_fd->fd_file.id == 0) {
		host_ipc_init();
	}

	host_fd->fd_offset = secno * SECTSIZE;
	for(; nsecs > 0; nsecs-=2) {
  80334a:	48 83 6d d8 02       	subq   $0x2,-0x28(%rbp)
  80334f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803354:	0f 85 6c ff ff ff    	jne    8032c6 <host_write+0x5a>
		memmove(host_fsipcbuf.write.req_buf, src+written, SECTSIZE * 2);
		if ((r = host_fsipc(FSREQ_WRITE, NULL)) < 0)
			return r;
		written += SECTSIZE * 2;
	}
	return 0;
  80335a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80335f:	c9                   	leaveq 
  803360:	c3                   	retq   

0000000000803361 <host_ipc_init>:

void
host_ipc_init()
{
  803361:	55                   	push   %rbp
  803362:	48 89 e5             	mov    %rsp,%rbp
  803365:	48 83 ec 40          	sub    $0x40,%rsp
	int r;
	int vmdisk_number;
	char path_string[50];
	if ((r = fd_alloc(&host_fd)) < 0)
  803369:	48 bf 00 40 81 00 00 	movabs $0x814000,%rdi
  803370:	00 00 00 
  803373:	48 b8 ea 54 80 00 00 	movabs $0x8054ea,%rax
  80337a:	00 00 00 
  80337d:	ff d0                	callq  *%rax
  80337f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803382:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803386:	79 2a                	jns    8033b2 <host_ipc_init+0x51>
		panic("Couldn't allocate an fd!");
  803388:	48 ba e4 7b 80 00 00 	movabs $0x807be4,%rdx
  80338f:	00 00 00 
  803392:	be 53 00 00 00       	mov    $0x53,%esi
  803397:	48 bf fd 7b 80 00 00 	movabs $0x807bfd,%rdi
  80339e:	00 00 00 
  8033a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a6:	48 b9 38 35 80 00 00 	movabs $0x803538,%rcx
  8033ad:	00 00 00 
  8033b0:	ff d1                	callq  *%rcx
	asm("vmcall":"=a"(vmdisk_number): "0"(VMX_VMCALL_GETDISKIMGNUM));
  8033b2:	b8 06 00 00 00       	mov    $0x6,%eax
  8033b7:	0f 01 c1             	vmcall 
  8033ba:	89 45 f8             	mov    %eax,-0x8(%rbp)
	snprintf(path_string, 50, "/vmm/fs%d.img", vmdisk_number);
  8033bd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033c0:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  8033c4:	89 d1                	mov    %edx,%ecx
  8033c6:	48 ba 0b 7c 80 00 00 	movabs $0x807c0b,%rdx
  8033cd:	00 00 00 
  8033d0:	be 32 00 00 00       	mov    $0x32,%esi
  8033d5:	48 89 c7             	mov    %rax,%rdi
  8033d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8033dd:	49 b8 d9 41 80 00 00 	movabs $0x8041d9,%r8
  8033e4:	00 00 00 
  8033e7:	41 ff d0             	callq  *%r8
	strcpy(host_fsipcbuf.open.req_path, path_string);
  8033ea:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  8033ee:	48 89 c6             	mov    %rax,%rsi
  8033f1:	48 bf 00 50 81 00 00 	movabs $0x815000,%rdi
  8033f8:	00 00 00 
  8033fb:	48 b8 26 43 80 00 00 	movabs $0x804326,%rax
  803402:	00 00 00 
  803405:	ff d0                	callq  *%rax
	host_fsipcbuf.open.req_omode = O_RDWR;
  803407:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  80340e:	00 00 00 
  803411:	c7 80 00 04 00 00 02 	movl   $0x2,0x400(%rax)
  803418:	00 00 00 

	if ((r = host_fsipc(FSREQ_OPEN, host_fd)) < 0) {
  80341b:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  803422:	00 00 00 
  803425:	48 8b 00             	mov    (%rax),%rax
  803428:	48 89 c6             	mov    %rax,%rsi
  80342b:	bf 01 00 00 00       	mov    $0x1,%edi
  803430:	48 b8 18 31 80 00 00 	movabs $0x803118,%rax
  803437:	00 00 00 
  80343a:	ff d0                	callq  *%rax
  80343c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80343f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803443:	79 4b                	jns    803490 <host_ipc_init+0x12f>
		fd_close(host_fd, 0);
  803445:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  80344c:	00 00 00 
  80344f:	48 8b 00             	mov    (%rax),%rax
  803452:	be 00 00 00 00       	mov    $0x0,%esi
  803457:	48 89 c7             	mov    %rax,%rdi
  80345a:	48 b8 12 56 80 00 00 	movabs $0x805612,%rax
  803461:	00 00 00 
  803464:	ff d0                	callq  *%rax
		panic("Couldn't open host file!");
  803466:	48 ba 19 7c 80 00 00 	movabs $0x807c19,%rdx
  80346d:	00 00 00 
  803470:	be 5b 00 00 00       	mov    $0x5b,%esi
  803475:	48 bf fd 7b 80 00 00 	movabs $0x807bfd,%rdi
  80347c:	00 00 00 
  80347f:	b8 00 00 00 00       	mov    $0x0,%eax
  803484:	48 b9 38 35 80 00 00 	movabs $0x803538,%rcx
  80348b:	00 00 00 
  80348e:	ff d1                	callq  *%rcx
	}

}
  803490:	c9                   	leaveq 
  803491:	c3                   	retq   

0000000000803492 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  803492:	55                   	push   %rbp
  803493:	48 89 e5             	mov    %rsp,%rbp
  803496:	48 83 ec 10          	sub    $0x10,%rsp
  80349a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80349d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  8034a1:	48 b8 d9 4b 80 00 00 	movabs $0x804bd9,%rax
  8034a8:	00 00 00 
  8034ab:	ff d0                	callq  *%rax
  8034ad:	25 ff 03 00 00       	and    $0x3ff,%eax
  8034b2:	48 98                	cltq   
  8034b4:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8034bb:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8034c2:	00 00 00 
  8034c5:	48 01 c2             	add    %rax,%rdx
  8034c8:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  8034cf:	00 00 00 
  8034d2:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8034d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034d9:	7e 14                	jle    8034ef <libmain+0x5d>
		binaryname = argv[0];
  8034db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034df:	48 8b 10             	mov    (%rax),%rdx
  8034e2:	48 b8 90 20 81 00 00 	movabs $0x812090,%rax
  8034e9:	00 00 00 
  8034ec:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8034ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f6:	48 89 d6             	mov    %rdx,%rsi
  8034f9:	89 c7                	mov    %eax,%edi
  8034fb:	48 b8 8f 28 80 00 00 	movabs $0x80288f,%rax
  803502:	00 00 00 
  803505:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  803507:	48 b8 15 35 80 00 00 	movabs $0x803515,%rax
  80350e:	00 00 00 
  803511:	ff d0                	callq  *%rax
}
  803513:	c9                   	leaveq 
  803514:	c3                   	retq   

0000000000803515 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  803515:	55                   	push   %rbp
  803516:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  803519:	48 b8 dd 57 80 00 00 	movabs $0x8057dd,%rax
  803520:	00 00 00 
  803523:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  803525:	bf 00 00 00 00       	mov    $0x0,%edi
  80352a:	48 b8 95 4b 80 00 00 	movabs $0x804b95,%rax
  803531:	00 00 00 
  803534:	ff d0                	callq  *%rax
}
  803536:	5d                   	pop    %rbp
  803537:	c3                   	retq   

0000000000803538 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803538:	55                   	push   %rbp
  803539:	48 89 e5             	mov    %rsp,%rbp
  80353c:	53                   	push   %rbx
  80353d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803544:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80354b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803551:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803558:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80355f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803566:	84 c0                	test   %al,%al
  803568:	74 23                	je     80358d <_panic+0x55>
  80356a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803571:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803575:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803579:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80357d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803581:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803585:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803589:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80358d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803594:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80359b:	00 00 00 
  80359e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8035a5:	00 00 00 
  8035a8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8035ac:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8035b3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8035ba:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8035c1:	48 b8 90 20 81 00 00 	movabs $0x812090,%rax
  8035c8:	00 00 00 
  8035cb:	48 8b 18             	mov    (%rax),%rbx
  8035ce:	48 b8 d9 4b 80 00 00 	movabs $0x804bd9,%rax
  8035d5:	00 00 00 
  8035d8:	ff d0                	callq  *%rax
  8035da:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8035e0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8035e7:	41 89 c8             	mov    %ecx,%r8d
  8035ea:	48 89 d1             	mov    %rdx,%rcx
  8035ed:	48 89 da             	mov    %rbx,%rdx
  8035f0:	89 c6                	mov    %eax,%esi
  8035f2:	48 bf 40 7c 80 00 00 	movabs $0x807c40,%rdi
  8035f9:	00 00 00 
  8035fc:	b8 00 00 00 00       	mov    $0x0,%eax
  803601:	49 b9 71 37 80 00 00 	movabs $0x803771,%r9
  803608:	00 00 00 
  80360b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80360e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803615:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80361c:	48 89 d6             	mov    %rdx,%rsi
  80361f:	48 89 c7             	mov    %rax,%rdi
  803622:	48 b8 c5 36 80 00 00 	movabs $0x8036c5,%rax
  803629:	00 00 00 
  80362c:	ff d0                	callq  *%rax
	cprintf("\n");
  80362e:	48 bf 63 7c 80 00 00 	movabs $0x807c63,%rdi
  803635:	00 00 00 
  803638:	b8 00 00 00 00       	mov    $0x0,%eax
  80363d:	48 ba 71 37 80 00 00 	movabs $0x803771,%rdx
  803644:	00 00 00 
  803647:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803649:	cc                   	int3   
  80364a:	eb fd                	jmp    803649 <_panic+0x111>

000000000080364c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80364c:	55                   	push   %rbp
  80364d:	48 89 e5             	mov    %rsp,%rbp
  803650:	48 83 ec 10          	sub    $0x10,%rsp
  803654:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803657:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80365b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80365f:	8b 00                	mov    (%rax),%eax
  803661:	8d 48 01             	lea    0x1(%rax),%ecx
  803664:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803668:	89 0a                	mov    %ecx,(%rdx)
  80366a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80366d:	89 d1                	mov    %edx,%ecx
  80366f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803673:	48 98                	cltq   
  803675:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  803679:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80367d:	8b 00                	mov    (%rax),%eax
  80367f:	3d ff 00 00 00       	cmp    $0xff,%eax
  803684:	75 2c                	jne    8036b2 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  803686:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80368a:	8b 00                	mov    (%rax),%eax
  80368c:	48 98                	cltq   
  80368e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803692:	48 83 c2 08          	add    $0x8,%rdx
  803696:	48 89 c6             	mov    %rax,%rsi
  803699:	48 89 d7             	mov    %rdx,%rdi
  80369c:	48 b8 0d 4b 80 00 00 	movabs $0x804b0d,%rax
  8036a3:	00 00 00 
  8036a6:	ff d0                	callq  *%rax
        b->idx = 0;
  8036a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ac:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8036b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b6:	8b 40 04             	mov    0x4(%rax),%eax
  8036b9:	8d 50 01             	lea    0x1(%rax),%edx
  8036bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c0:	89 50 04             	mov    %edx,0x4(%rax)
}
  8036c3:	c9                   	leaveq 
  8036c4:	c3                   	retq   

00000000008036c5 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8036c5:	55                   	push   %rbp
  8036c6:	48 89 e5             	mov    %rsp,%rbp
  8036c9:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8036d0:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8036d7:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8036de:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8036e5:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8036ec:	48 8b 0a             	mov    (%rdx),%rcx
  8036ef:	48 89 08             	mov    %rcx,(%rax)
  8036f2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8036f6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8036fa:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8036fe:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  803702:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  803709:	00 00 00 
    b.cnt = 0;
  80370c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  803713:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  803716:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80371d:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  803724:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80372b:	48 89 c6             	mov    %rax,%rsi
  80372e:	48 bf 4c 36 80 00 00 	movabs $0x80364c,%rdi
  803735:	00 00 00 
  803738:	48 b8 24 3b 80 00 00 	movabs $0x803b24,%rax
  80373f:	00 00 00 
  803742:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  803744:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80374a:	48 98                	cltq   
  80374c:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  803753:	48 83 c2 08          	add    $0x8,%rdx
  803757:	48 89 c6             	mov    %rax,%rsi
  80375a:	48 89 d7             	mov    %rdx,%rdi
  80375d:	48 b8 0d 4b 80 00 00 	movabs $0x804b0d,%rax
  803764:	00 00 00 
  803767:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  803769:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80376f:	c9                   	leaveq 
  803770:	c3                   	retq   

0000000000803771 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  803771:	55                   	push   %rbp
  803772:	48 89 e5             	mov    %rsp,%rbp
  803775:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80377c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803783:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80378a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803791:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803798:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80379f:	84 c0                	test   %al,%al
  8037a1:	74 20                	je     8037c3 <cprintf+0x52>
  8037a3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8037a7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8037ab:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8037af:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8037b3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8037b7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8037bb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8037bf:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8037c3:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8037ca:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8037d1:	00 00 00 
  8037d4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8037db:	00 00 00 
  8037de:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8037e2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8037e9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8037f0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8037f7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8037fe:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803805:	48 8b 0a             	mov    (%rdx),%rcx
  803808:	48 89 08             	mov    %rcx,(%rax)
  80380b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80380f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803813:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803817:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80381b:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  803822:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803829:	48 89 d6             	mov    %rdx,%rsi
  80382c:	48 89 c7             	mov    %rax,%rdi
  80382f:	48 b8 c5 36 80 00 00 	movabs $0x8036c5,%rax
  803836:	00 00 00 
  803839:	ff d0                	callq  *%rax
  80383b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  803841:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803847:	c9                   	leaveq 
  803848:	c3                   	retq   

0000000000803849 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  803849:	55                   	push   %rbp
  80384a:	48 89 e5             	mov    %rsp,%rbp
  80384d:	53                   	push   %rbx
  80384e:	48 83 ec 38          	sub    $0x38,%rsp
  803852:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803856:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80385a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80385e:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  803861:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  803865:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  803869:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80386c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803870:	77 3b                	ja     8038ad <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  803872:	8b 45 d0             	mov    -0x30(%rbp),%eax
  803875:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  803879:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80387c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803880:	ba 00 00 00 00       	mov    $0x0,%edx
  803885:	48 f7 f3             	div    %rbx
  803888:	48 89 c2             	mov    %rax,%rdx
  80388b:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80388e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  803891:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  803895:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803899:	41 89 f9             	mov    %edi,%r9d
  80389c:	48 89 c7             	mov    %rax,%rdi
  80389f:	48 b8 49 38 80 00 00 	movabs $0x803849,%rax
  8038a6:	00 00 00 
  8038a9:	ff d0                	callq  *%rax
  8038ab:	eb 1e                	jmp    8038cb <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8038ad:	eb 12                	jmp    8038c1 <printnum+0x78>
			putch(padc, putdat);
  8038af:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8038b3:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8038b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038ba:	48 89 ce             	mov    %rcx,%rsi
  8038bd:	89 d7                	mov    %edx,%edi
  8038bf:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8038c1:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8038c5:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8038c9:	7f e4                	jg     8038af <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8038cb:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8038ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8038d7:	48 f7 f1             	div    %rcx
  8038da:	48 89 d0             	mov    %rdx,%rax
  8038dd:	48 ba 70 7e 80 00 00 	movabs $0x807e70,%rdx
  8038e4:	00 00 00 
  8038e7:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8038eb:	0f be d0             	movsbl %al,%edx
  8038ee:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8038f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038f6:	48 89 ce             	mov    %rcx,%rsi
  8038f9:	89 d7                	mov    %edx,%edi
  8038fb:	ff d0                	callq  *%rax
}
  8038fd:	48 83 c4 38          	add    $0x38,%rsp
  803901:	5b                   	pop    %rbx
  803902:	5d                   	pop    %rbp
  803903:	c3                   	retq   

0000000000803904 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  803904:	55                   	push   %rbp
  803905:	48 89 e5             	mov    %rsp,%rbp
  803908:	48 83 ec 1c          	sub    $0x1c,%rsp
  80390c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803910:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  803913:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  803917:	7e 52                	jle    80396b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  803919:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80391d:	8b 00                	mov    (%rax),%eax
  80391f:	83 f8 30             	cmp    $0x30,%eax
  803922:	73 24                	jae    803948 <getuint+0x44>
  803924:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803928:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80392c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803930:	8b 00                	mov    (%rax),%eax
  803932:	89 c0                	mov    %eax,%eax
  803934:	48 01 d0             	add    %rdx,%rax
  803937:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80393b:	8b 12                	mov    (%rdx),%edx
  80393d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803940:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803944:	89 0a                	mov    %ecx,(%rdx)
  803946:	eb 17                	jmp    80395f <getuint+0x5b>
  803948:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80394c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803950:	48 89 d0             	mov    %rdx,%rax
  803953:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803957:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80395b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80395f:	48 8b 00             	mov    (%rax),%rax
  803962:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803966:	e9 a3 00 00 00       	jmpq   803a0e <getuint+0x10a>
	else if (lflag)
  80396b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80396f:	74 4f                	je     8039c0 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  803971:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803975:	8b 00                	mov    (%rax),%eax
  803977:	83 f8 30             	cmp    $0x30,%eax
  80397a:	73 24                	jae    8039a0 <getuint+0x9c>
  80397c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803980:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803984:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803988:	8b 00                	mov    (%rax),%eax
  80398a:	89 c0                	mov    %eax,%eax
  80398c:	48 01 d0             	add    %rdx,%rax
  80398f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803993:	8b 12                	mov    (%rdx),%edx
  803995:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803998:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80399c:	89 0a                	mov    %ecx,(%rdx)
  80399e:	eb 17                	jmp    8039b7 <getuint+0xb3>
  8039a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039a4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8039a8:	48 89 d0             	mov    %rdx,%rax
  8039ab:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8039af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039b3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8039b7:	48 8b 00             	mov    (%rax),%rax
  8039ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8039be:	eb 4e                	jmp    803a0e <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8039c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039c4:	8b 00                	mov    (%rax),%eax
  8039c6:	83 f8 30             	cmp    $0x30,%eax
  8039c9:	73 24                	jae    8039ef <getuint+0xeb>
  8039cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039cf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8039d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039d7:	8b 00                	mov    (%rax),%eax
  8039d9:	89 c0                	mov    %eax,%eax
  8039db:	48 01 d0             	add    %rdx,%rax
  8039de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039e2:	8b 12                	mov    (%rdx),%edx
  8039e4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8039e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039eb:	89 0a                	mov    %ecx,(%rdx)
  8039ed:	eb 17                	jmp    803a06 <getuint+0x102>
  8039ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039f3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8039f7:	48 89 d0             	mov    %rdx,%rax
  8039fa:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8039fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a02:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803a06:	8b 00                	mov    (%rax),%eax
  803a08:	89 c0                	mov    %eax,%eax
  803a0a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803a0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a12:	c9                   	leaveq 
  803a13:	c3                   	retq   

0000000000803a14 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  803a14:	55                   	push   %rbp
  803a15:	48 89 e5             	mov    %rsp,%rbp
  803a18:	48 83 ec 1c          	sub    $0x1c,%rsp
  803a1c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a20:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  803a23:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  803a27:	7e 52                	jle    803a7b <getint+0x67>
		x=va_arg(*ap, long long);
  803a29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a2d:	8b 00                	mov    (%rax),%eax
  803a2f:	83 f8 30             	cmp    $0x30,%eax
  803a32:	73 24                	jae    803a58 <getint+0x44>
  803a34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a38:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803a3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a40:	8b 00                	mov    (%rax),%eax
  803a42:	89 c0                	mov    %eax,%eax
  803a44:	48 01 d0             	add    %rdx,%rax
  803a47:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a4b:	8b 12                	mov    (%rdx),%edx
  803a4d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803a50:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a54:	89 0a                	mov    %ecx,(%rdx)
  803a56:	eb 17                	jmp    803a6f <getint+0x5b>
  803a58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a5c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803a60:	48 89 d0             	mov    %rdx,%rax
  803a63:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803a67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a6b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803a6f:	48 8b 00             	mov    (%rax),%rax
  803a72:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803a76:	e9 a3 00 00 00       	jmpq   803b1e <getint+0x10a>
	else if (lflag)
  803a7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803a7f:	74 4f                	je     803ad0 <getint+0xbc>
		x=va_arg(*ap, long);
  803a81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a85:	8b 00                	mov    (%rax),%eax
  803a87:	83 f8 30             	cmp    $0x30,%eax
  803a8a:	73 24                	jae    803ab0 <getint+0x9c>
  803a8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a90:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803a94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a98:	8b 00                	mov    (%rax),%eax
  803a9a:	89 c0                	mov    %eax,%eax
  803a9c:	48 01 d0             	add    %rdx,%rax
  803a9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803aa3:	8b 12                	mov    (%rdx),%edx
  803aa5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803aa8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803aac:	89 0a                	mov    %ecx,(%rdx)
  803aae:	eb 17                	jmp    803ac7 <getint+0xb3>
  803ab0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ab4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803ab8:	48 89 d0             	mov    %rdx,%rax
  803abb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803abf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ac3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803ac7:	48 8b 00             	mov    (%rax),%rax
  803aca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803ace:	eb 4e                	jmp    803b1e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  803ad0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ad4:	8b 00                	mov    (%rax),%eax
  803ad6:	83 f8 30             	cmp    $0x30,%eax
  803ad9:	73 24                	jae    803aff <getint+0xeb>
  803adb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803adf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803ae3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ae7:	8b 00                	mov    (%rax),%eax
  803ae9:	89 c0                	mov    %eax,%eax
  803aeb:	48 01 d0             	add    %rdx,%rax
  803aee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803af2:	8b 12                	mov    (%rdx),%edx
  803af4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803af7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803afb:	89 0a                	mov    %ecx,(%rdx)
  803afd:	eb 17                	jmp    803b16 <getint+0x102>
  803aff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b03:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803b07:	48 89 d0             	mov    %rdx,%rax
  803b0a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803b0e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b12:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803b16:	8b 00                	mov    (%rax),%eax
  803b18:	48 98                	cltq   
  803b1a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803b1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b22:	c9                   	leaveq 
  803b23:	c3                   	retq   

0000000000803b24 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  803b24:	55                   	push   %rbp
  803b25:	48 89 e5             	mov    %rsp,%rbp
  803b28:	41 54                	push   %r12
  803b2a:	53                   	push   %rbx
  803b2b:	48 83 ec 60          	sub    $0x60,%rsp
  803b2f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  803b33:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  803b37:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803b3b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  803b3f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803b43:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  803b47:	48 8b 0a             	mov    (%rdx),%rcx
  803b4a:	48 89 08             	mov    %rcx,(%rax)
  803b4d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803b51:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803b55:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803b59:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803b5d:	eb 17                	jmp    803b76 <vprintfmt+0x52>
			if (ch == '\0')
  803b5f:	85 db                	test   %ebx,%ebx
  803b61:	0f 84 cc 04 00 00    	je     804033 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  803b67:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803b6b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b6f:	48 89 d6             	mov    %rdx,%rsi
  803b72:	89 df                	mov    %ebx,%edi
  803b74:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803b76:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803b7a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803b7e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803b82:	0f b6 00             	movzbl (%rax),%eax
  803b85:	0f b6 d8             	movzbl %al,%ebx
  803b88:	83 fb 25             	cmp    $0x25,%ebx
  803b8b:	75 d2                	jne    803b5f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  803b8d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  803b91:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  803b98:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  803b9f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  803ba6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  803bad:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803bb1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803bb5:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803bb9:	0f b6 00             	movzbl (%rax),%eax
  803bbc:	0f b6 d8             	movzbl %al,%ebx
  803bbf:	8d 43 dd             	lea    -0x23(%rbx),%eax
  803bc2:	83 f8 55             	cmp    $0x55,%eax
  803bc5:	0f 87 34 04 00 00    	ja     803fff <vprintfmt+0x4db>
  803bcb:	89 c0                	mov    %eax,%eax
  803bcd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803bd4:	00 
  803bd5:	48 b8 98 7e 80 00 00 	movabs $0x807e98,%rax
  803bdc:	00 00 00 
  803bdf:	48 01 d0             	add    %rdx,%rax
  803be2:	48 8b 00             	mov    (%rax),%rax
  803be5:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  803be7:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  803beb:	eb c0                	jmp    803bad <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  803bed:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  803bf1:	eb ba                	jmp    803bad <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803bf3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  803bfa:	8b 55 d8             	mov    -0x28(%rbp),%edx
  803bfd:	89 d0                	mov    %edx,%eax
  803bff:	c1 e0 02             	shl    $0x2,%eax
  803c02:	01 d0                	add    %edx,%eax
  803c04:	01 c0                	add    %eax,%eax
  803c06:	01 d8                	add    %ebx,%eax
  803c08:	83 e8 30             	sub    $0x30,%eax
  803c0b:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  803c0e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803c12:	0f b6 00             	movzbl (%rax),%eax
  803c15:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  803c18:	83 fb 2f             	cmp    $0x2f,%ebx
  803c1b:	7e 0c                	jle    803c29 <vprintfmt+0x105>
  803c1d:	83 fb 39             	cmp    $0x39,%ebx
  803c20:	7f 07                	jg     803c29 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803c22:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  803c27:	eb d1                	jmp    803bfa <vprintfmt+0xd6>
			goto process_precision;
  803c29:	eb 58                	jmp    803c83 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  803c2b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803c2e:	83 f8 30             	cmp    $0x30,%eax
  803c31:	73 17                	jae    803c4a <vprintfmt+0x126>
  803c33:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803c37:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803c3a:	89 c0                	mov    %eax,%eax
  803c3c:	48 01 d0             	add    %rdx,%rax
  803c3f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803c42:	83 c2 08             	add    $0x8,%edx
  803c45:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803c48:	eb 0f                	jmp    803c59 <vprintfmt+0x135>
  803c4a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803c4e:	48 89 d0             	mov    %rdx,%rax
  803c51:	48 83 c2 08          	add    $0x8,%rdx
  803c55:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803c59:	8b 00                	mov    (%rax),%eax
  803c5b:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  803c5e:	eb 23                	jmp    803c83 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  803c60:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803c64:	79 0c                	jns    803c72 <vprintfmt+0x14e>
				width = 0;
  803c66:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  803c6d:	e9 3b ff ff ff       	jmpq   803bad <vprintfmt+0x89>
  803c72:	e9 36 ff ff ff       	jmpq   803bad <vprintfmt+0x89>

		case '#':
			altflag = 1;
  803c77:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  803c7e:	e9 2a ff ff ff       	jmpq   803bad <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  803c83:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803c87:	79 12                	jns    803c9b <vprintfmt+0x177>
				width = precision, precision = -1;
  803c89:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803c8c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  803c8f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  803c96:	e9 12 ff ff ff       	jmpq   803bad <vprintfmt+0x89>
  803c9b:	e9 0d ff ff ff       	jmpq   803bad <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  803ca0:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  803ca4:	e9 04 ff ff ff       	jmpq   803bad <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  803ca9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803cac:	83 f8 30             	cmp    $0x30,%eax
  803caf:	73 17                	jae    803cc8 <vprintfmt+0x1a4>
  803cb1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803cb5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803cb8:	89 c0                	mov    %eax,%eax
  803cba:	48 01 d0             	add    %rdx,%rax
  803cbd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803cc0:	83 c2 08             	add    $0x8,%edx
  803cc3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803cc6:	eb 0f                	jmp    803cd7 <vprintfmt+0x1b3>
  803cc8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803ccc:	48 89 d0             	mov    %rdx,%rax
  803ccf:	48 83 c2 08          	add    $0x8,%rdx
  803cd3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803cd7:	8b 10                	mov    (%rax),%edx
  803cd9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803cdd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ce1:	48 89 ce             	mov    %rcx,%rsi
  803ce4:	89 d7                	mov    %edx,%edi
  803ce6:	ff d0                	callq  *%rax
			break;
  803ce8:	e9 40 03 00 00       	jmpq   80402d <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  803ced:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803cf0:	83 f8 30             	cmp    $0x30,%eax
  803cf3:	73 17                	jae    803d0c <vprintfmt+0x1e8>
  803cf5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803cf9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803cfc:	89 c0                	mov    %eax,%eax
  803cfe:	48 01 d0             	add    %rdx,%rax
  803d01:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803d04:	83 c2 08             	add    $0x8,%edx
  803d07:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803d0a:	eb 0f                	jmp    803d1b <vprintfmt+0x1f7>
  803d0c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803d10:	48 89 d0             	mov    %rdx,%rax
  803d13:	48 83 c2 08          	add    $0x8,%rdx
  803d17:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803d1b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  803d1d:	85 db                	test   %ebx,%ebx
  803d1f:	79 02                	jns    803d23 <vprintfmt+0x1ff>
				err = -err;
  803d21:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  803d23:	83 fb 15             	cmp    $0x15,%ebx
  803d26:	7f 16                	jg     803d3e <vprintfmt+0x21a>
  803d28:	48 b8 c0 7d 80 00 00 	movabs $0x807dc0,%rax
  803d2f:	00 00 00 
  803d32:	48 63 d3             	movslq %ebx,%rdx
  803d35:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  803d39:	4d 85 e4             	test   %r12,%r12
  803d3c:	75 2e                	jne    803d6c <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  803d3e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803d42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803d46:	89 d9                	mov    %ebx,%ecx
  803d48:	48 ba 81 7e 80 00 00 	movabs $0x807e81,%rdx
  803d4f:	00 00 00 
  803d52:	48 89 c7             	mov    %rax,%rdi
  803d55:	b8 00 00 00 00       	mov    $0x0,%eax
  803d5a:	49 b8 3c 40 80 00 00 	movabs $0x80403c,%r8
  803d61:	00 00 00 
  803d64:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  803d67:	e9 c1 02 00 00       	jmpq   80402d <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  803d6c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803d70:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803d74:	4c 89 e1             	mov    %r12,%rcx
  803d77:	48 ba 8a 7e 80 00 00 	movabs $0x807e8a,%rdx
  803d7e:	00 00 00 
  803d81:	48 89 c7             	mov    %rax,%rdi
  803d84:	b8 00 00 00 00       	mov    $0x0,%eax
  803d89:	49 b8 3c 40 80 00 00 	movabs $0x80403c,%r8
  803d90:	00 00 00 
  803d93:	41 ff d0             	callq  *%r8
			break;
  803d96:	e9 92 02 00 00       	jmpq   80402d <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  803d9b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803d9e:	83 f8 30             	cmp    $0x30,%eax
  803da1:	73 17                	jae    803dba <vprintfmt+0x296>
  803da3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803da7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803daa:	89 c0                	mov    %eax,%eax
  803dac:	48 01 d0             	add    %rdx,%rax
  803daf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803db2:	83 c2 08             	add    $0x8,%edx
  803db5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803db8:	eb 0f                	jmp    803dc9 <vprintfmt+0x2a5>
  803dba:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803dbe:	48 89 d0             	mov    %rdx,%rax
  803dc1:	48 83 c2 08          	add    $0x8,%rdx
  803dc5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803dc9:	4c 8b 20             	mov    (%rax),%r12
  803dcc:	4d 85 e4             	test   %r12,%r12
  803dcf:	75 0a                	jne    803ddb <vprintfmt+0x2b7>
				p = "(null)";
  803dd1:	49 bc 8d 7e 80 00 00 	movabs $0x807e8d,%r12
  803dd8:	00 00 00 
			if (width > 0 && padc != '-')
  803ddb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803ddf:	7e 3f                	jle    803e20 <vprintfmt+0x2fc>
  803de1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  803de5:	74 39                	je     803e20 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  803de7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803dea:	48 98                	cltq   
  803dec:	48 89 c6             	mov    %rax,%rsi
  803def:	4c 89 e7             	mov    %r12,%rdi
  803df2:	48 b8 e8 42 80 00 00 	movabs $0x8042e8,%rax
  803df9:	00 00 00 
  803dfc:	ff d0                	callq  *%rax
  803dfe:	29 45 dc             	sub    %eax,-0x24(%rbp)
  803e01:	eb 17                	jmp    803e1a <vprintfmt+0x2f6>
					putch(padc, putdat);
  803e03:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  803e07:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803e0b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803e0f:	48 89 ce             	mov    %rcx,%rsi
  803e12:	89 d7                	mov    %edx,%edi
  803e14:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  803e16:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803e1a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803e1e:	7f e3                	jg     803e03 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803e20:	eb 37                	jmp    803e59 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  803e22:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  803e26:	74 1e                	je     803e46 <vprintfmt+0x322>
  803e28:	83 fb 1f             	cmp    $0x1f,%ebx
  803e2b:	7e 05                	jle    803e32 <vprintfmt+0x30e>
  803e2d:	83 fb 7e             	cmp    $0x7e,%ebx
  803e30:	7e 14                	jle    803e46 <vprintfmt+0x322>
					putch('?', putdat);
  803e32:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803e36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803e3a:	48 89 d6             	mov    %rdx,%rsi
  803e3d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  803e42:	ff d0                	callq  *%rax
  803e44:	eb 0f                	jmp    803e55 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  803e46:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803e4a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803e4e:	48 89 d6             	mov    %rdx,%rsi
  803e51:	89 df                	mov    %ebx,%edi
  803e53:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803e55:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803e59:	4c 89 e0             	mov    %r12,%rax
  803e5c:	4c 8d 60 01          	lea    0x1(%rax),%r12
  803e60:	0f b6 00             	movzbl (%rax),%eax
  803e63:	0f be d8             	movsbl %al,%ebx
  803e66:	85 db                	test   %ebx,%ebx
  803e68:	74 10                	je     803e7a <vprintfmt+0x356>
  803e6a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803e6e:	78 b2                	js     803e22 <vprintfmt+0x2fe>
  803e70:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  803e74:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803e78:	79 a8                	jns    803e22 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803e7a:	eb 16                	jmp    803e92 <vprintfmt+0x36e>
				putch(' ', putdat);
  803e7c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803e80:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803e84:	48 89 d6             	mov    %rdx,%rsi
  803e87:	bf 20 00 00 00       	mov    $0x20,%edi
  803e8c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803e8e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803e92:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803e96:	7f e4                	jg     803e7c <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  803e98:	e9 90 01 00 00       	jmpq   80402d <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  803e9d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803ea1:	be 03 00 00 00       	mov    $0x3,%esi
  803ea6:	48 89 c7             	mov    %rax,%rdi
  803ea9:	48 b8 14 3a 80 00 00 	movabs $0x803a14,%rax
  803eb0:	00 00 00 
  803eb3:	ff d0                	callq  *%rax
  803eb5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  803eb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ebd:	48 85 c0             	test   %rax,%rax
  803ec0:	79 1d                	jns    803edf <vprintfmt+0x3bb>
				putch('-', putdat);
  803ec2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803ec6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803eca:	48 89 d6             	mov    %rdx,%rsi
  803ecd:	bf 2d 00 00 00       	mov    $0x2d,%edi
  803ed2:	ff d0                	callq  *%rax
				num = -(long long) num;
  803ed4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ed8:	48 f7 d8             	neg    %rax
  803edb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  803edf:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803ee6:	e9 d5 00 00 00       	jmpq   803fc0 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  803eeb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803eef:	be 03 00 00 00       	mov    $0x3,%esi
  803ef4:	48 89 c7             	mov    %rax,%rdi
  803ef7:	48 b8 04 39 80 00 00 	movabs $0x803904,%rax
  803efe:	00 00 00 
  803f01:	ff d0                	callq  *%rax
  803f03:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  803f07:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803f0e:	e9 ad 00 00 00       	jmpq   803fc0 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  803f13:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803f17:	be 03 00 00 00       	mov    $0x3,%esi
  803f1c:	48 89 c7             	mov    %rax,%rdi
  803f1f:	48 b8 04 39 80 00 00 	movabs $0x803904,%rax
  803f26:	00 00 00 
  803f29:	ff d0                	callq  *%rax
  803f2b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  803f2f:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  803f36:	e9 85 00 00 00       	jmpq   803fc0 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  803f3b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803f3f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803f43:	48 89 d6             	mov    %rdx,%rsi
  803f46:	bf 30 00 00 00       	mov    $0x30,%edi
  803f4b:	ff d0                	callq  *%rax
			putch('x', putdat);
  803f4d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803f51:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803f55:	48 89 d6             	mov    %rdx,%rsi
  803f58:	bf 78 00 00 00       	mov    $0x78,%edi
  803f5d:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803f5f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803f62:	83 f8 30             	cmp    $0x30,%eax
  803f65:	73 17                	jae    803f7e <vprintfmt+0x45a>
  803f67:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803f6b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803f6e:	89 c0                	mov    %eax,%eax
  803f70:	48 01 d0             	add    %rdx,%rax
  803f73:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803f76:	83 c2 08             	add    $0x8,%edx
  803f79:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803f7c:	eb 0f                	jmp    803f8d <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  803f7e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803f82:	48 89 d0             	mov    %rdx,%rax
  803f85:	48 83 c2 08          	add    $0x8,%rdx
  803f89:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803f8d:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803f90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  803f94:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  803f9b:	eb 23                	jmp    803fc0 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  803f9d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803fa1:	be 03 00 00 00       	mov    $0x3,%esi
  803fa6:	48 89 c7             	mov    %rax,%rdi
  803fa9:	48 b8 04 39 80 00 00 	movabs $0x803904,%rax
  803fb0:	00 00 00 
  803fb3:	ff d0                	callq  *%rax
  803fb5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  803fb9:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  803fc0:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  803fc5:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803fc8:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803fcb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803fcf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803fd3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803fd7:	45 89 c1             	mov    %r8d,%r9d
  803fda:	41 89 f8             	mov    %edi,%r8d
  803fdd:	48 89 c7             	mov    %rax,%rdi
  803fe0:	48 b8 49 38 80 00 00 	movabs $0x803849,%rax
  803fe7:	00 00 00 
  803fea:	ff d0                	callq  *%rax
			break;
  803fec:	eb 3f                	jmp    80402d <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  803fee:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803ff2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ff6:	48 89 d6             	mov    %rdx,%rsi
  803ff9:	89 df                	mov    %ebx,%edi
  803ffb:	ff d0                	callq  *%rax
			break;
  803ffd:	eb 2e                	jmp    80402d <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  803fff:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  804003:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804007:	48 89 d6             	mov    %rdx,%rsi
  80400a:	bf 25 00 00 00       	mov    $0x25,%edi
  80400f:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  804011:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  804016:	eb 05                	jmp    80401d <vprintfmt+0x4f9>
  804018:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80401d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  804021:	48 83 e8 01          	sub    $0x1,%rax
  804025:	0f b6 00             	movzbl (%rax),%eax
  804028:	3c 25                	cmp    $0x25,%al
  80402a:	75 ec                	jne    804018 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  80402c:	90                   	nop
		}
	}
  80402d:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80402e:	e9 43 fb ff ff       	jmpq   803b76 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  804033:	48 83 c4 60          	add    $0x60,%rsp
  804037:	5b                   	pop    %rbx
  804038:	41 5c                	pop    %r12
  80403a:	5d                   	pop    %rbp
  80403b:	c3                   	retq   

000000000080403c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80403c:	55                   	push   %rbp
  80403d:	48 89 e5             	mov    %rsp,%rbp
  804040:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  804047:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80404e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  804055:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80405c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  804063:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80406a:	84 c0                	test   %al,%al
  80406c:	74 20                	je     80408e <printfmt+0x52>
  80406e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804072:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804076:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80407a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80407e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804082:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804086:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80408a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80408e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  804095:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80409c:	00 00 00 
  80409f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8040a6:	00 00 00 
  8040a9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8040ad:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8040b4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8040bb:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8040c2:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8040c9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8040d0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8040d7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8040de:	48 89 c7             	mov    %rax,%rdi
  8040e1:	48 b8 24 3b 80 00 00 	movabs $0x803b24,%rax
  8040e8:	00 00 00 
  8040eb:	ff d0                	callq  *%rax
	va_end(ap);
}
  8040ed:	c9                   	leaveq 
  8040ee:	c3                   	retq   

00000000008040ef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8040ef:	55                   	push   %rbp
  8040f0:	48 89 e5             	mov    %rsp,%rbp
  8040f3:	48 83 ec 10          	sub    $0x10,%rsp
  8040f7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8040fa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8040fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804102:	8b 40 10             	mov    0x10(%rax),%eax
  804105:	8d 50 01             	lea    0x1(%rax),%edx
  804108:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80410c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80410f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804113:	48 8b 10             	mov    (%rax),%rdx
  804116:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80411a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80411e:	48 39 c2             	cmp    %rax,%rdx
  804121:	73 17                	jae    80413a <sprintputch+0x4b>
		*b->buf++ = ch;
  804123:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804127:	48 8b 00             	mov    (%rax),%rax
  80412a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80412e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804132:	48 89 0a             	mov    %rcx,(%rdx)
  804135:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804138:	88 10                	mov    %dl,(%rax)
}
  80413a:	c9                   	leaveq 
  80413b:	c3                   	retq   

000000000080413c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80413c:	55                   	push   %rbp
  80413d:	48 89 e5             	mov    %rsp,%rbp
  804140:	48 83 ec 50          	sub    $0x50,%rsp
  804144:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  804148:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80414b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80414f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  804153:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  804157:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80415b:	48 8b 0a             	mov    (%rdx),%rcx
  80415e:	48 89 08             	mov    %rcx,(%rax)
  804161:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  804165:	48 89 48 08          	mov    %rcx,0x8(%rax)
  804169:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80416d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  804171:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804175:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  804179:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80417c:	48 98                	cltq   
  80417e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  804182:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804186:	48 01 d0             	add    %rdx,%rax
  804189:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80418d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  804194:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  804199:	74 06                	je     8041a1 <vsnprintf+0x65>
  80419b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80419f:	7f 07                	jg     8041a8 <vsnprintf+0x6c>
		return -E_INVAL;
  8041a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8041a6:	eb 2f                	jmp    8041d7 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8041a8:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8041ac:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8041b0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8041b4:	48 89 c6             	mov    %rax,%rsi
  8041b7:	48 bf ef 40 80 00 00 	movabs $0x8040ef,%rdi
  8041be:	00 00 00 
  8041c1:	48 b8 24 3b 80 00 00 	movabs $0x803b24,%rax
  8041c8:	00 00 00 
  8041cb:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8041cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041d1:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8041d4:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8041d7:	c9                   	leaveq 
  8041d8:	c3                   	retq   

00000000008041d9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8041d9:	55                   	push   %rbp
  8041da:	48 89 e5             	mov    %rsp,%rbp
  8041dd:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8041e4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8041eb:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8041f1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8041f8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8041ff:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  804206:	84 c0                	test   %al,%al
  804208:	74 20                	je     80422a <snprintf+0x51>
  80420a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80420e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804212:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  804216:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80421a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80421e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804222:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  804226:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80422a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  804231:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  804238:	00 00 00 
  80423b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804242:	00 00 00 
  804245:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804249:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804250:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804257:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80425e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  804265:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80426c:	48 8b 0a             	mov    (%rdx),%rcx
  80426f:	48 89 08             	mov    %rcx,(%rax)
  804272:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  804276:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80427a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80427e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  804282:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  804289:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  804290:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  804296:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80429d:	48 89 c7             	mov    %rax,%rdi
  8042a0:	48 b8 3c 41 80 00 00 	movabs $0x80413c,%rax
  8042a7:	00 00 00 
  8042aa:	ff d0                	callq  *%rax
  8042ac:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8042b2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8042b8:	c9                   	leaveq 
  8042b9:	c3                   	retq   

00000000008042ba <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8042ba:	55                   	push   %rbp
  8042bb:	48 89 e5             	mov    %rsp,%rbp
  8042be:	48 83 ec 18          	sub    $0x18,%rsp
  8042c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8042c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8042cd:	eb 09                	jmp    8042d8 <strlen+0x1e>
		n++;
  8042cf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8042d3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8042d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042dc:	0f b6 00             	movzbl (%rax),%eax
  8042df:	84 c0                	test   %al,%al
  8042e1:	75 ec                	jne    8042cf <strlen+0x15>
		n++;
	return n;
  8042e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8042e6:	c9                   	leaveq 
  8042e7:	c3                   	retq   

00000000008042e8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8042e8:	55                   	push   %rbp
  8042e9:	48 89 e5             	mov    %rsp,%rbp
  8042ec:	48 83 ec 20          	sub    $0x20,%rsp
  8042f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8042f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8042f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8042ff:	eb 0e                	jmp    80430f <strnlen+0x27>
		n++;
  804301:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  804305:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80430a:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80430f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804314:	74 0b                	je     804321 <strnlen+0x39>
  804316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80431a:	0f b6 00             	movzbl (%rax),%eax
  80431d:	84 c0                	test   %al,%al
  80431f:	75 e0                	jne    804301 <strnlen+0x19>
		n++;
	return n;
  804321:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804324:	c9                   	leaveq 
  804325:	c3                   	retq   

0000000000804326 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  804326:	55                   	push   %rbp
  804327:	48 89 e5             	mov    %rsp,%rbp
  80432a:	48 83 ec 20          	sub    $0x20,%rsp
  80432e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804332:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  804336:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80433a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80433e:	90                   	nop
  80433f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804343:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804347:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80434b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80434f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  804353:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  804357:	0f b6 12             	movzbl (%rdx),%edx
  80435a:	88 10                	mov    %dl,(%rax)
  80435c:	0f b6 00             	movzbl (%rax),%eax
  80435f:	84 c0                	test   %al,%al
  804361:	75 dc                	jne    80433f <strcpy+0x19>
		/* do nothing */;
	return ret;
  804363:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804367:	c9                   	leaveq 
  804368:	c3                   	retq   

0000000000804369 <strcat>:

char *
strcat(char *dst, const char *src)
{
  804369:	55                   	push   %rbp
  80436a:	48 89 e5             	mov    %rsp,%rbp
  80436d:	48 83 ec 20          	sub    $0x20,%rsp
  804371:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804375:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  804379:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80437d:	48 89 c7             	mov    %rax,%rdi
  804380:	48 b8 ba 42 80 00 00 	movabs $0x8042ba,%rax
  804387:	00 00 00 
  80438a:	ff d0                	callq  *%rax
  80438c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80438f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804392:	48 63 d0             	movslq %eax,%rdx
  804395:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804399:	48 01 c2             	add    %rax,%rdx
  80439c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043a0:	48 89 c6             	mov    %rax,%rsi
  8043a3:	48 89 d7             	mov    %rdx,%rdi
  8043a6:	48 b8 26 43 80 00 00 	movabs $0x804326,%rax
  8043ad:	00 00 00 
  8043b0:	ff d0                	callq  *%rax
	return dst;
  8043b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8043b6:	c9                   	leaveq 
  8043b7:	c3                   	retq   

00000000008043b8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8043b8:	55                   	push   %rbp
  8043b9:	48 89 e5             	mov    %rsp,%rbp
  8043bc:	48 83 ec 28          	sub    $0x28,%rsp
  8043c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043c8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8043cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043d0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8043d4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8043db:	00 
  8043dc:	eb 2a                	jmp    804408 <strncpy+0x50>
		*dst++ = *src;
  8043de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043e2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8043e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8043ea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8043ee:	0f b6 12             	movzbl (%rdx),%edx
  8043f1:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8043f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043f7:	0f b6 00             	movzbl (%rax),%eax
  8043fa:	84 c0                	test   %al,%al
  8043fc:	74 05                	je     804403 <strncpy+0x4b>
			src++;
  8043fe:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  804403:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804408:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80440c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  804410:	72 cc                	jb     8043de <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  804412:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  804416:	c9                   	leaveq 
  804417:	c3                   	retq   

0000000000804418 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  804418:	55                   	push   %rbp
  804419:	48 89 e5             	mov    %rsp,%rbp
  80441c:	48 83 ec 28          	sub    $0x28,%rsp
  804420:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804424:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804428:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80442c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804430:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  804434:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804439:	74 3d                	je     804478 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80443b:	eb 1d                	jmp    80445a <strlcpy+0x42>
			*dst++ = *src++;
  80443d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804441:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804445:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804449:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80444d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  804451:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  804455:	0f b6 12             	movzbl (%rdx),%edx
  804458:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80445a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80445f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804464:	74 0b                	je     804471 <strlcpy+0x59>
  804466:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80446a:	0f b6 00             	movzbl (%rax),%eax
  80446d:	84 c0                	test   %al,%al
  80446f:	75 cc                	jne    80443d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  804471:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804475:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  804478:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80447c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804480:	48 29 c2             	sub    %rax,%rdx
  804483:	48 89 d0             	mov    %rdx,%rax
}
  804486:	c9                   	leaveq 
  804487:	c3                   	retq   

0000000000804488 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  804488:	55                   	push   %rbp
  804489:	48 89 e5             	mov    %rsp,%rbp
  80448c:	48 83 ec 10          	sub    $0x10,%rsp
  804490:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804494:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  804498:	eb 0a                	jmp    8044a4 <strcmp+0x1c>
		p++, q++;
  80449a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80449f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8044a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044a8:	0f b6 00             	movzbl (%rax),%eax
  8044ab:	84 c0                	test   %al,%al
  8044ad:	74 12                	je     8044c1 <strcmp+0x39>
  8044af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044b3:	0f b6 10             	movzbl (%rax),%edx
  8044b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044ba:	0f b6 00             	movzbl (%rax),%eax
  8044bd:	38 c2                	cmp    %al,%dl
  8044bf:	74 d9                	je     80449a <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8044c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044c5:	0f b6 00             	movzbl (%rax),%eax
  8044c8:	0f b6 d0             	movzbl %al,%edx
  8044cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044cf:	0f b6 00             	movzbl (%rax),%eax
  8044d2:	0f b6 c0             	movzbl %al,%eax
  8044d5:	29 c2                	sub    %eax,%edx
  8044d7:	89 d0                	mov    %edx,%eax
}
  8044d9:	c9                   	leaveq 
  8044da:	c3                   	retq   

00000000008044db <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8044db:	55                   	push   %rbp
  8044dc:	48 89 e5             	mov    %rsp,%rbp
  8044df:	48 83 ec 18          	sub    $0x18,%rsp
  8044e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8044e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8044eb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8044ef:	eb 0f                	jmp    804500 <strncmp+0x25>
		n--, p++, q++;
  8044f1:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8044f6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8044fb:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  804500:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804505:	74 1d                	je     804524 <strncmp+0x49>
  804507:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80450b:	0f b6 00             	movzbl (%rax),%eax
  80450e:	84 c0                	test   %al,%al
  804510:	74 12                	je     804524 <strncmp+0x49>
  804512:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804516:	0f b6 10             	movzbl (%rax),%edx
  804519:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80451d:	0f b6 00             	movzbl (%rax),%eax
  804520:	38 c2                	cmp    %al,%dl
  804522:	74 cd                	je     8044f1 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  804524:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804529:	75 07                	jne    804532 <strncmp+0x57>
		return 0;
  80452b:	b8 00 00 00 00       	mov    $0x0,%eax
  804530:	eb 18                	jmp    80454a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  804532:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804536:	0f b6 00             	movzbl (%rax),%eax
  804539:	0f b6 d0             	movzbl %al,%edx
  80453c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804540:	0f b6 00             	movzbl (%rax),%eax
  804543:	0f b6 c0             	movzbl %al,%eax
  804546:	29 c2                	sub    %eax,%edx
  804548:	89 d0                	mov    %edx,%eax
}
  80454a:	c9                   	leaveq 
  80454b:	c3                   	retq   

000000000080454c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80454c:	55                   	push   %rbp
  80454d:	48 89 e5             	mov    %rsp,%rbp
  804550:	48 83 ec 0c          	sub    $0xc,%rsp
  804554:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804558:	89 f0                	mov    %esi,%eax
  80455a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80455d:	eb 17                	jmp    804576 <strchr+0x2a>
		if (*s == c)
  80455f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804563:	0f b6 00             	movzbl (%rax),%eax
  804566:	3a 45 f4             	cmp    -0xc(%rbp),%al
  804569:	75 06                	jne    804571 <strchr+0x25>
			return (char *) s;
  80456b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80456f:	eb 15                	jmp    804586 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  804571:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804576:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80457a:	0f b6 00             	movzbl (%rax),%eax
  80457d:	84 c0                	test   %al,%al
  80457f:	75 de                	jne    80455f <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  804581:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804586:	c9                   	leaveq 
  804587:	c3                   	retq   

0000000000804588 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  804588:	55                   	push   %rbp
  804589:	48 89 e5             	mov    %rsp,%rbp
  80458c:	48 83 ec 0c          	sub    $0xc,%rsp
  804590:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804594:	89 f0                	mov    %esi,%eax
  804596:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  804599:	eb 13                	jmp    8045ae <strfind+0x26>
		if (*s == c)
  80459b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80459f:	0f b6 00             	movzbl (%rax),%eax
  8045a2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8045a5:	75 02                	jne    8045a9 <strfind+0x21>
			break;
  8045a7:	eb 10                	jmp    8045b9 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8045a9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8045ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045b2:	0f b6 00             	movzbl (%rax),%eax
  8045b5:	84 c0                	test   %al,%al
  8045b7:	75 e2                	jne    80459b <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8045b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8045bd:	c9                   	leaveq 
  8045be:	c3                   	retq   

00000000008045bf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8045bf:	55                   	push   %rbp
  8045c0:	48 89 e5             	mov    %rsp,%rbp
  8045c3:	48 83 ec 18          	sub    $0x18,%rsp
  8045c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8045cb:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8045ce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8045d2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8045d7:	75 06                	jne    8045df <memset+0x20>
		return v;
  8045d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045dd:	eb 69                	jmp    804648 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8045df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045e3:	83 e0 03             	and    $0x3,%eax
  8045e6:	48 85 c0             	test   %rax,%rax
  8045e9:	75 48                	jne    804633 <memset+0x74>
  8045eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045ef:	83 e0 03             	and    $0x3,%eax
  8045f2:	48 85 c0             	test   %rax,%rax
  8045f5:	75 3c                	jne    804633 <memset+0x74>
		c &= 0xFF;
  8045f7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8045fe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804601:	c1 e0 18             	shl    $0x18,%eax
  804604:	89 c2                	mov    %eax,%edx
  804606:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804609:	c1 e0 10             	shl    $0x10,%eax
  80460c:	09 c2                	or     %eax,%edx
  80460e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804611:	c1 e0 08             	shl    $0x8,%eax
  804614:	09 d0                	or     %edx,%eax
  804616:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  804619:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80461d:	48 c1 e8 02          	shr    $0x2,%rax
  804621:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  804624:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804628:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80462b:	48 89 d7             	mov    %rdx,%rdi
  80462e:	fc                   	cld    
  80462f:	f3 ab                	rep stos %eax,%es:(%rdi)
  804631:	eb 11                	jmp    804644 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  804633:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804637:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80463a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80463e:	48 89 d7             	mov    %rdx,%rdi
  804641:	fc                   	cld    
  804642:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  804644:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804648:	c9                   	leaveq 
  804649:	c3                   	retq   

000000000080464a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80464a:	55                   	push   %rbp
  80464b:	48 89 e5             	mov    %rsp,%rbp
  80464e:	48 83 ec 28          	sub    $0x28,%rsp
  804652:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804656:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80465a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80465e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804662:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  804666:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80466a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80466e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804672:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  804676:	0f 83 88 00 00 00    	jae    804704 <memmove+0xba>
  80467c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804680:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804684:	48 01 d0             	add    %rdx,%rax
  804687:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80468b:	76 77                	jbe    804704 <memmove+0xba>
		s += n;
  80468d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804691:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  804695:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804699:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80469d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046a1:	83 e0 03             	and    $0x3,%eax
  8046a4:	48 85 c0             	test   %rax,%rax
  8046a7:	75 3b                	jne    8046e4 <memmove+0x9a>
  8046a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046ad:	83 e0 03             	and    $0x3,%eax
  8046b0:	48 85 c0             	test   %rax,%rax
  8046b3:	75 2f                	jne    8046e4 <memmove+0x9a>
  8046b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046b9:	83 e0 03             	and    $0x3,%eax
  8046bc:	48 85 c0             	test   %rax,%rax
  8046bf:	75 23                	jne    8046e4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8046c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046c5:	48 83 e8 04          	sub    $0x4,%rax
  8046c9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8046cd:	48 83 ea 04          	sub    $0x4,%rdx
  8046d1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8046d5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8046d9:	48 89 c7             	mov    %rax,%rdi
  8046dc:	48 89 d6             	mov    %rdx,%rsi
  8046df:	fd                   	std    
  8046e0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8046e2:	eb 1d                	jmp    804701 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8046e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046e8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8046ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046f0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8046f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046f8:	48 89 d7             	mov    %rdx,%rdi
  8046fb:	48 89 c1             	mov    %rax,%rcx
  8046fe:	fd                   	std    
  8046ff:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  804701:	fc                   	cld    
  804702:	eb 57                	jmp    80475b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  804704:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804708:	83 e0 03             	and    $0x3,%eax
  80470b:	48 85 c0             	test   %rax,%rax
  80470e:	75 36                	jne    804746 <memmove+0xfc>
  804710:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804714:	83 e0 03             	and    $0x3,%eax
  804717:	48 85 c0             	test   %rax,%rax
  80471a:	75 2a                	jne    804746 <memmove+0xfc>
  80471c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804720:	83 e0 03             	and    $0x3,%eax
  804723:	48 85 c0             	test   %rax,%rax
  804726:	75 1e                	jne    804746 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  804728:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80472c:	48 c1 e8 02          	shr    $0x2,%rax
  804730:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  804733:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804737:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80473b:	48 89 c7             	mov    %rax,%rdi
  80473e:	48 89 d6             	mov    %rdx,%rsi
  804741:	fc                   	cld    
  804742:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  804744:	eb 15                	jmp    80475b <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  804746:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80474a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80474e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804752:	48 89 c7             	mov    %rax,%rdi
  804755:	48 89 d6             	mov    %rdx,%rsi
  804758:	fc                   	cld    
  804759:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80475b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80475f:	c9                   	leaveq 
  804760:	c3                   	retq   

0000000000804761 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  804761:	55                   	push   %rbp
  804762:	48 89 e5             	mov    %rsp,%rbp
  804765:	48 83 ec 18          	sub    $0x18,%rsp
  804769:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80476d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804771:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  804775:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804779:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80477d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804781:	48 89 ce             	mov    %rcx,%rsi
  804784:	48 89 c7             	mov    %rax,%rdi
  804787:	48 b8 4a 46 80 00 00 	movabs $0x80464a,%rax
  80478e:	00 00 00 
  804791:	ff d0                	callq  *%rax
}
  804793:	c9                   	leaveq 
  804794:	c3                   	retq   

0000000000804795 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  804795:	55                   	push   %rbp
  804796:	48 89 e5             	mov    %rsp,%rbp
  804799:	48 83 ec 28          	sub    $0x28,%rsp
  80479d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8047a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8047a5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8047a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8047b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8047b9:	eb 36                	jmp    8047f1 <memcmp+0x5c>
		if (*s1 != *s2)
  8047bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047bf:	0f b6 10             	movzbl (%rax),%edx
  8047c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047c6:	0f b6 00             	movzbl (%rax),%eax
  8047c9:	38 c2                	cmp    %al,%dl
  8047cb:	74 1a                	je     8047e7 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8047cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047d1:	0f b6 00             	movzbl (%rax),%eax
  8047d4:	0f b6 d0             	movzbl %al,%edx
  8047d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047db:	0f b6 00             	movzbl (%rax),%eax
  8047de:	0f b6 c0             	movzbl %al,%eax
  8047e1:	29 c2                	sub    %eax,%edx
  8047e3:	89 d0                	mov    %edx,%eax
  8047e5:	eb 20                	jmp    804807 <memcmp+0x72>
		s1++, s2++;
  8047e7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8047ec:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8047f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047f5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8047f9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8047fd:	48 85 c0             	test   %rax,%rax
  804800:	75 b9                	jne    8047bb <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  804802:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804807:	c9                   	leaveq 
  804808:	c3                   	retq   

0000000000804809 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  804809:	55                   	push   %rbp
  80480a:	48 89 e5             	mov    %rsp,%rbp
  80480d:	48 83 ec 28          	sub    $0x28,%rsp
  804811:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804815:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  804818:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80481c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804820:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804824:	48 01 d0             	add    %rdx,%rax
  804827:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80482b:	eb 15                	jmp    804842 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80482d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804831:	0f b6 10             	movzbl (%rax),%edx
  804834:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804837:	38 c2                	cmp    %al,%dl
  804839:	75 02                	jne    80483d <memfind+0x34>
			break;
  80483b:	eb 0f                	jmp    80484c <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80483d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  804842:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804846:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80484a:	72 e1                	jb     80482d <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80484c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804850:	c9                   	leaveq 
  804851:	c3                   	retq   

0000000000804852 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  804852:	55                   	push   %rbp
  804853:	48 89 e5             	mov    %rsp,%rbp
  804856:	48 83 ec 34          	sub    $0x34,%rsp
  80485a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80485e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804862:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  804865:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80486c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  804873:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  804874:	eb 05                	jmp    80487b <strtol+0x29>
		s++;
  804876:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80487b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80487f:	0f b6 00             	movzbl (%rax),%eax
  804882:	3c 20                	cmp    $0x20,%al
  804884:	74 f0                	je     804876 <strtol+0x24>
  804886:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80488a:	0f b6 00             	movzbl (%rax),%eax
  80488d:	3c 09                	cmp    $0x9,%al
  80488f:	74 e5                	je     804876 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  804891:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804895:	0f b6 00             	movzbl (%rax),%eax
  804898:	3c 2b                	cmp    $0x2b,%al
  80489a:	75 07                	jne    8048a3 <strtol+0x51>
		s++;
  80489c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8048a1:	eb 17                	jmp    8048ba <strtol+0x68>
	else if (*s == '-')
  8048a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048a7:	0f b6 00             	movzbl (%rax),%eax
  8048aa:	3c 2d                	cmp    $0x2d,%al
  8048ac:	75 0c                	jne    8048ba <strtol+0x68>
		s++, neg = 1;
  8048ae:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8048b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8048ba:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8048be:	74 06                	je     8048c6 <strtol+0x74>
  8048c0:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8048c4:	75 28                	jne    8048ee <strtol+0x9c>
  8048c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048ca:	0f b6 00             	movzbl (%rax),%eax
  8048cd:	3c 30                	cmp    $0x30,%al
  8048cf:	75 1d                	jne    8048ee <strtol+0x9c>
  8048d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048d5:	48 83 c0 01          	add    $0x1,%rax
  8048d9:	0f b6 00             	movzbl (%rax),%eax
  8048dc:	3c 78                	cmp    $0x78,%al
  8048de:	75 0e                	jne    8048ee <strtol+0x9c>
		s += 2, base = 16;
  8048e0:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8048e5:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8048ec:	eb 2c                	jmp    80491a <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8048ee:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8048f2:	75 19                	jne    80490d <strtol+0xbb>
  8048f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048f8:	0f b6 00             	movzbl (%rax),%eax
  8048fb:	3c 30                	cmp    $0x30,%al
  8048fd:	75 0e                	jne    80490d <strtol+0xbb>
		s++, base = 8;
  8048ff:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  804904:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80490b:	eb 0d                	jmp    80491a <strtol+0xc8>
	else if (base == 0)
  80490d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  804911:	75 07                	jne    80491a <strtol+0xc8>
		base = 10;
  804913:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80491a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80491e:	0f b6 00             	movzbl (%rax),%eax
  804921:	3c 2f                	cmp    $0x2f,%al
  804923:	7e 1d                	jle    804942 <strtol+0xf0>
  804925:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804929:	0f b6 00             	movzbl (%rax),%eax
  80492c:	3c 39                	cmp    $0x39,%al
  80492e:	7f 12                	jg     804942 <strtol+0xf0>
			dig = *s - '0';
  804930:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804934:	0f b6 00             	movzbl (%rax),%eax
  804937:	0f be c0             	movsbl %al,%eax
  80493a:	83 e8 30             	sub    $0x30,%eax
  80493d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804940:	eb 4e                	jmp    804990 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  804942:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804946:	0f b6 00             	movzbl (%rax),%eax
  804949:	3c 60                	cmp    $0x60,%al
  80494b:	7e 1d                	jle    80496a <strtol+0x118>
  80494d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804951:	0f b6 00             	movzbl (%rax),%eax
  804954:	3c 7a                	cmp    $0x7a,%al
  804956:	7f 12                	jg     80496a <strtol+0x118>
			dig = *s - 'a' + 10;
  804958:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80495c:	0f b6 00             	movzbl (%rax),%eax
  80495f:	0f be c0             	movsbl %al,%eax
  804962:	83 e8 57             	sub    $0x57,%eax
  804965:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804968:	eb 26                	jmp    804990 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80496a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80496e:	0f b6 00             	movzbl (%rax),%eax
  804971:	3c 40                	cmp    $0x40,%al
  804973:	7e 48                	jle    8049bd <strtol+0x16b>
  804975:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804979:	0f b6 00             	movzbl (%rax),%eax
  80497c:	3c 5a                	cmp    $0x5a,%al
  80497e:	7f 3d                	jg     8049bd <strtol+0x16b>
			dig = *s - 'A' + 10;
  804980:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804984:	0f b6 00             	movzbl (%rax),%eax
  804987:	0f be c0             	movsbl %al,%eax
  80498a:	83 e8 37             	sub    $0x37,%eax
  80498d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  804990:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804993:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  804996:	7c 02                	jl     80499a <strtol+0x148>
			break;
  804998:	eb 23                	jmp    8049bd <strtol+0x16b>
		s++, val = (val * base) + dig;
  80499a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80499f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8049a2:	48 98                	cltq   
  8049a4:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8049a9:	48 89 c2             	mov    %rax,%rdx
  8049ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8049af:	48 98                	cltq   
  8049b1:	48 01 d0             	add    %rdx,%rax
  8049b4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8049b8:	e9 5d ff ff ff       	jmpq   80491a <strtol+0xc8>

	if (endptr)
  8049bd:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8049c2:	74 0b                	je     8049cf <strtol+0x17d>
		*endptr = (char *) s;
  8049c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8049c8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8049cc:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8049cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049d3:	74 09                	je     8049de <strtol+0x18c>
  8049d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049d9:	48 f7 d8             	neg    %rax
  8049dc:	eb 04                	jmp    8049e2 <strtol+0x190>
  8049de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8049e2:	c9                   	leaveq 
  8049e3:	c3                   	retq   

00000000008049e4 <strstr>:

char * strstr(const char *in, const char *str)
{
  8049e4:	55                   	push   %rbp
  8049e5:	48 89 e5             	mov    %rsp,%rbp
  8049e8:	48 83 ec 30          	sub    $0x30,%rsp
  8049ec:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8049f0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8049f4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8049f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8049fc:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804a00:	0f b6 00             	movzbl (%rax),%eax
  804a03:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  804a06:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  804a0a:	75 06                	jne    804a12 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  804a0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a10:	eb 6b                	jmp    804a7d <strstr+0x99>

	len = strlen(str);
  804a12:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804a16:	48 89 c7             	mov    %rax,%rdi
  804a19:	48 b8 ba 42 80 00 00 	movabs $0x8042ba,%rax
  804a20:	00 00 00 
  804a23:	ff d0                	callq  *%rax
  804a25:	48 98                	cltq   
  804a27:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  804a2b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a2f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804a33:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  804a37:	0f b6 00             	movzbl (%rax),%eax
  804a3a:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  804a3d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  804a41:	75 07                	jne    804a4a <strstr+0x66>
				return (char *) 0;
  804a43:	b8 00 00 00 00       	mov    $0x0,%eax
  804a48:	eb 33                	jmp    804a7d <strstr+0x99>
		} while (sc != c);
  804a4a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  804a4e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  804a51:	75 d8                	jne    804a2b <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  804a53:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a57:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  804a5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a5f:	48 89 ce             	mov    %rcx,%rsi
  804a62:	48 89 c7             	mov    %rax,%rdi
  804a65:	48 b8 db 44 80 00 00 	movabs $0x8044db,%rax
  804a6c:	00 00 00 
  804a6f:	ff d0                	callq  *%rax
  804a71:	85 c0                	test   %eax,%eax
  804a73:	75 b6                	jne    804a2b <strstr+0x47>

	return (char *) (in - 1);
  804a75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a79:	48 83 e8 01          	sub    $0x1,%rax
}
  804a7d:	c9                   	leaveq 
  804a7e:	c3                   	retq   

0000000000804a7f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  804a7f:	55                   	push   %rbp
  804a80:	48 89 e5             	mov    %rsp,%rbp
  804a83:	53                   	push   %rbx
  804a84:	48 83 ec 48          	sub    $0x48,%rsp
  804a88:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804a8b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  804a8e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804a92:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  804a96:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  804a9a:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  804a9e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804aa1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  804aa5:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  804aa9:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  804aad:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  804ab1:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  804ab5:	4c 89 c3             	mov    %r8,%rbx
  804ab8:	cd 30                	int    $0x30
  804aba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  804abe:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  804ac2:	74 3e                	je     804b02 <syscall+0x83>
  804ac4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804ac9:	7e 37                	jle    804b02 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  804acb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804acf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804ad2:	49 89 d0             	mov    %rdx,%r8
  804ad5:	89 c1                	mov    %eax,%ecx
  804ad7:	48 ba 48 81 80 00 00 	movabs $0x808148,%rdx
  804ade:	00 00 00 
  804ae1:	be 24 00 00 00       	mov    $0x24,%esi
  804ae6:	48 bf 65 81 80 00 00 	movabs $0x808165,%rdi
  804aed:	00 00 00 
  804af0:	b8 00 00 00 00       	mov    $0x0,%eax
  804af5:	49 b9 38 35 80 00 00 	movabs $0x803538,%r9
  804afc:	00 00 00 
  804aff:	41 ff d1             	callq  *%r9

	return ret;
  804b02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804b06:	48 83 c4 48          	add    $0x48,%rsp
  804b0a:	5b                   	pop    %rbx
  804b0b:	5d                   	pop    %rbp
  804b0c:	c3                   	retq   

0000000000804b0d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  804b0d:	55                   	push   %rbp
  804b0e:	48 89 e5             	mov    %rsp,%rbp
  804b11:	48 83 ec 20          	sub    $0x20,%rsp
  804b15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804b19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  804b1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b21:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b25:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804b2c:	00 
  804b2d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804b33:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804b39:	48 89 d1             	mov    %rdx,%rcx
  804b3c:	48 89 c2             	mov    %rax,%rdx
  804b3f:	be 00 00 00 00       	mov    $0x0,%esi
  804b44:	bf 00 00 00 00       	mov    $0x0,%edi
  804b49:	48 b8 7f 4a 80 00 00 	movabs $0x804a7f,%rax
  804b50:	00 00 00 
  804b53:	ff d0                	callq  *%rax
}
  804b55:	c9                   	leaveq 
  804b56:	c3                   	retq   

0000000000804b57 <sys_cgetc>:

int
sys_cgetc(void)
{
  804b57:	55                   	push   %rbp
  804b58:	48 89 e5             	mov    %rsp,%rbp
  804b5b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  804b5f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804b66:	00 
  804b67:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804b6d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804b73:	b9 00 00 00 00       	mov    $0x0,%ecx
  804b78:	ba 00 00 00 00       	mov    $0x0,%edx
  804b7d:	be 00 00 00 00       	mov    $0x0,%esi
  804b82:	bf 01 00 00 00       	mov    $0x1,%edi
  804b87:	48 b8 7f 4a 80 00 00 	movabs $0x804a7f,%rax
  804b8e:	00 00 00 
  804b91:	ff d0                	callq  *%rax
}
  804b93:	c9                   	leaveq 
  804b94:	c3                   	retq   

0000000000804b95 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  804b95:	55                   	push   %rbp
  804b96:	48 89 e5             	mov    %rsp,%rbp
  804b99:	48 83 ec 10          	sub    $0x10,%rsp
  804b9d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  804ba0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ba3:	48 98                	cltq   
  804ba5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804bac:	00 
  804bad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804bb3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804bb9:	b9 00 00 00 00       	mov    $0x0,%ecx
  804bbe:	48 89 c2             	mov    %rax,%rdx
  804bc1:	be 01 00 00 00       	mov    $0x1,%esi
  804bc6:	bf 03 00 00 00       	mov    $0x3,%edi
  804bcb:	48 b8 7f 4a 80 00 00 	movabs $0x804a7f,%rax
  804bd2:	00 00 00 
  804bd5:	ff d0                	callq  *%rax
}
  804bd7:	c9                   	leaveq 
  804bd8:	c3                   	retq   

0000000000804bd9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  804bd9:	55                   	push   %rbp
  804bda:	48 89 e5             	mov    %rsp,%rbp
  804bdd:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  804be1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804be8:	00 
  804be9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804bef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804bf5:	b9 00 00 00 00       	mov    $0x0,%ecx
  804bfa:	ba 00 00 00 00       	mov    $0x0,%edx
  804bff:	be 00 00 00 00       	mov    $0x0,%esi
  804c04:	bf 02 00 00 00       	mov    $0x2,%edi
  804c09:	48 b8 7f 4a 80 00 00 	movabs $0x804a7f,%rax
  804c10:	00 00 00 
  804c13:	ff d0                	callq  *%rax
}
  804c15:	c9                   	leaveq 
  804c16:	c3                   	retq   

0000000000804c17 <sys_yield>:


void
sys_yield(void)
{
  804c17:	55                   	push   %rbp
  804c18:	48 89 e5             	mov    %rsp,%rbp
  804c1b:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  804c1f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804c26:	00 
  804c27:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804c2d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804c33:	b9 00 00 00 00       	mov    $0x0,%ecx
  804c38:	ba 00 00 00 00       	mov    $0x0,%edx
  804c3d:	be 00 00 00 00       	mov    $0x0,%esi
  804c42:	bf 0b 00 00 00       	mov    $0xb,%edi
  804c47:	48 b8 7f 4a 80 00 00 	movabs $0x804a7f,%rax
  804c4e:	00 00 00 
  804c51:	ff d0                	callq  *%rax
}
  804c53:	c9                   	leaveq 
  804c54:	c3                   	retq   

0000000000804c55 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  804c55:	55                   	push   %rbp
  804c56:	48 89 e5             	mov    %rsp,%rbp
  804c59:	48 83 ec 20          	sub    $0x20,%rsp
  804c5d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804c60:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804c64:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  804c67:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804c6a:	48 63 c8             	movslq %eax,%rcx
  804c6d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804c71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c74:	48 98                	cltq   
  804c76:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804c7d:	00 
  804c7e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804c84:	49 89 c8             	mov    %rcx,%r8
  804c87:	48 89 d1             	mov    %rdx,%rcx
  804c8a:	48 89 c2             	mov    %rax,%rdx
  804c8d:	be 01 00 00 00       	mov    $0x1,%esi
  804c92:	bf 04 00 00 00       	mov    $0x4,%edi
  804c97:	48 b8 7f 4a 80 00 00 	movabs $0x804a7f,%rax
  804c9e:	00 00 00 
  804ca1:	ff d0                	callq  *%rax
}
  804ca3:	c9                   	leaveq 
  804ca4:	c3                   	retq   

0000000000804ca5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  804ca5:	55                   	push   %rbp
  804ca6:	48 89 e5             	mov    %rsp,%rbp
  804ca9:	48 83 ec 30          	sub    $0x30,%rsp
  804cad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804cb0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804cb4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804cb7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  804cbb:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  804cbf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804cc2:	48 63 c8             	movslq %eax,%rcx
  804cc5:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  804cc9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804ccc:	48 63 f0             	movslq %eax,%rsi
  804ccf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804cd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804cd6:	48 98                	cltq   
  804cd8:	48 89 0c 24          	mov    %rcx,(%rsp)
  804cdc:	49 89 f9             	mov    %rdi,%r9
  804cdf:	49 89 f0             	mov    %rsi,%r8
  804ce2:	48 89 d1             	mov    %rdx,%rcx
  804ce5:	48 89 c2             	mov    %rax,%rdx
  804ce8:	be 01 00 00 00       	mov    $0x1,%esi
  804ced:	bf 05 00 00 00       	mov    $0x5,%edi
  804cf2:	48 b8 7f 4a 80 00 00 	movabs $0x804a7f,%rax
  804cf9:	00 00 00 
  804cfc:	ff d0                	callq  *%rax
}
  804cfe:	c9                   	leaveq 
  804cff:	c3                   	retq   

0000000000804d00 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  804d00:	55                   	push   %rbp
  804d01:	48 89 e5             	mov    %rsp,%rbp
  804d04:	48 83 ec 20          	sub    $0x20,%rsp
  804d08:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804d0b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  804d0f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804d13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d16:	48 98                	cltq   
  804d18:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804d1f:	00 
  804d20:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804d26:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804d2c:	48 89 d1             	mov    %rdx,%rcx
  804d2f:	48 89 c2             	mov    %rax,%rdx
  804d32:	be 01 00 00 00       	mov    $0x1,%esi
  804d37:	bf 06 00 00 00       	mov    $0x6,%edi
  804d3c:	48 b8 7f 4a 80 00 00 	movabs $0x804a7f,%rax
  804d43:	00 00 00 
  804d46:	ff d0                	callq  *%rax
}
  804d48:	c9                   	leaveq 
  804d49:	c3                   	retq   

0000000000804d4a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  804d4a:	55                   	push   %rbp
  804d4b:	48 89 e5             	mov    %rsp,%rbp
  804d4e:	48 83 ec 10          	sub    $0x10,%rsp
  804d52:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804d55:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  804d58:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804d5b:	48 63 d0             	movslq %eax,%rdx
  804d5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d61:	48 98                	cltq   
  804d63:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804d6a:	00 
  804d6b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804d71:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804d77:	48 89 d1             	mov    %rdx,%rcx
  804d7a:	48 89 c2             	mov    %rax,%rdx
  804d7d:	be 01 00 00 00       	mov    $0x1,%esi
  804d82:	bf 08 00 00 00       	mov    $0x8,%edi
  804d87:	48 b8 7f 4a 80 00 00 	movabs $0x804a7f,%rax
  804d8e:	00 00 00 
  804d91:	ff d0                	callq  *%rax
}
  804d93:	c9                   	leaveq 
  804d94:	c3                   	retq   

0000000000804d95 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  804d95:	55                   	push   %rbp
  804d96:	48 89 e5             	mov    %rsp,%rbp
  804d99:	48 83 ec 20          	sub    $0x20,%rsp
  804d9d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804da0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  804da4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804da8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804dab:	48 98                	cltq   
  804dad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804db4:	00 
  804db5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804dbb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804dc1:	48 89 d1             	mov    %rdx,%rcx
  804dc4:	48 89 c2             	mov    %rax,%rdx
  804dc7:	be 01 00 00 00       	mov    $0x1,%esi
  804dcc:	bf 09 00 00 00       	mov    $0x9,%edi
  804dd1:	48 b8 7f 4a 80 00 00 	movabs $0x804a7f,%rax
  804dd8:	00 00 00 
  804ddb:	ff d0                	callq  *%rax
}
  804ddd:	c9                   	leaveq 
  804dde:	c3                   	retq   

0000000000804ddf <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  804ddf:	55                   	push   %rbp
  804de0:	48 89 e5             	mov    %rsp,%rbp
  804de3:	48 83 ec 20          	sub    $0x20,%rsp
  804de7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804dea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  804dee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804df2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804df5:	48 98                	cltq   
  804df7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804dfe:	00 
  804dff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804e05:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804e0b:	48 89 d1             	mov    %rdx,%rcx
  804e0e:	48 89 c2             	mov    %rax,%rdx
  804e11:	be 01 00 00 00       	mov    $0x1,%esi
  804e16:	bf 0a 00 00 00       	mov    $0xa,%edi
  804e1b:	48 b8 7f 4a 80 00 00 	movabs $0x804a7f,%rax
  804e22:	00 00 00 
  804e25:	ff d0                	callq  *%rax
}
  804e27:	c9                   	leaveq 
  804e28:	c3                   	retq   

0000000000804e29 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  804e29:	55                   	push   %rbp
  804e2a:	48 89 e5             	mov    %rsp,%rbp
  804e2d:	48 83 ec 20          	sub    $0x20,%rsp
  804e31:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804e34:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804e38:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804e3c:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  804e3f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804e42:	48 63 f0             	movslq %eax,%rsi
  804e45:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804e49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e4c:	48 98                	cltq   
  804e4e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804e52:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804e59:	00 
  804e5a:	49 89 f1             	mov    %rsi,%r9
  804e5d:	49 89 c8             	mov    %rcx,%r8
  804e60:	48 89 d1             	mov    %rdx,%rcx
  804e63:	48 89 c2             	mov    %rax,%rdx
  804e66:	be 00 00 00 00       	mov    $0x0,%esi
  804e6b:	bf 0c 00 00 00       	mov    $0xc,%edi
  804e70:	48 b8 7f 4a 80 00 00 	movabs $0x804a7f,%rax
  804e77:	00 00 00 
  804e7a:	ff d0                	callq  *%rax
}
  804e7c:	c9                   	leaveq 
  804e7d:	c3                   	retq   

0000000000804e7e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  804e7e:	55                   	push   %rbp
  804e7f:	48 89 e5             	mov    %rsp,%rbp
  804e82:	48 83 ec 10          	sub    $0x10,%rsp
  804e86:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  804e8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804e8e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804e95:	00 
  804e96:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804e9c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804ea2:	b9 00 00 00 00       	mov    $0x0,%ecx
  804ea7:	48 89 c2             	mov    %rax,%rdx
  804eaa:	be 01 00 00 00       	mov    $0x1,%esi
  804eaf:	bf 0d 00 00 00       	mov    $0xd,%edi
  804eb4:	48 b8 7f 4a 80 00 00 	movabs $0x804a7f,%rax
  804ebb:	00 00 00 
  804ebe:	ff d0                	callq  *%rax
}
  804ec0:	c9                   	leaveq 
  804ec1:	c3                   	retq   

0000000000804ec2 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  804ec2:	55                   	push   %rbp
  804ec3:	48 89 e5             	mov    %rsp,%rbp
  804ec6:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  804eca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804ed1:	00 
  804ed2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804ed8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804ede:	b9 00 00 00 00       	mov    $0x0,%ecx
  804ee3:	ba 00 00 00 00       	mov    $0x0,%edx
  804ee8:	be 00 00 00 00       	mov    $0x0,%esi
  804eed:	bf 0e 00 00 00       	mov    $0xe,%edi
  804ef2:	48 b8 7f 4a 80 00 00 	movabs $0x804a7f,%rax
  804ef9:	00 00 00 
  804efc:	ff d0                	callq  *%rax
}
  804efe:	c9                   	leaveq 
  804eff:	c3                   	retq   

0000000000804f00 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  804f00:	55                   	push   %rbp
  804f01:	48 89 e5             	mov    %rsp,%rbp
  804f04:	48 83 ec 20          	sub    $0x20,%rsp
  804f08:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804f0c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  804f0f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804f12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f16:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804f1d:	00 
  804f1e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804f24:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804f2a:	48 89 d1             	mov    %rdx,%rcx
  804f2d:	48 89 c2             	mov    %rax,%rdx
  804f30:	be 00 00 00 00       	mov    $0x0,%esi
  804f35:	bf 0f 00 00 00       	mov    $0xf,%edi
  804f3a:	48 b8 7f 4a 80 00 00 	movabs $0x804a7f,%rax
  804f41:	00 00 00 
  804f44:	ff d0                	callq  *%rax
}
  804f46:	c9                   	leaveq 
  804f47:	c3                   	retq   

0000000000804f48 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  804f48:	55                   	push   %rbp
  804f49:	48 89 e5             	mov    %rsp,%rbp
  804f4c:	48 83 ec 20          	sub    $0x20,%rsp
  804f50:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804f54:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  804f57:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804f5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f5e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804f65:	00 
  804f66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804f6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804f72:	48 89 d1             	mov    %rdx,%rcx
  804f75:	48 89 c2             	mov    %rax,%rdx
  804f78:	be 00 00 00 00       	mov    $0x0,%esi
  804f7d:	bf 10 00 00 00       	mov    $0x10,%edi
  804f82:	48 b8 7f 4a 80 00 00 	movabs $0x804a7f,%rax
  804f89:	00 00 00 
  804f8c:	ff d0                	callq  *%rax
}
  804f8e:	c9                   	leaveq 
  804f8f:	c3                   	retq   

0000000000804f90 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  804f90:	55                   	push   %rbp
  804f91:	48 89 e5             	mov    %rsp,%rbp
  804f94:	48 83 ec 30          	sub    $0x30,%rsp
  804f98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804f9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804f9f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804fa2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  804fa6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  804faa:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804fad:	48 63 c8             	movslq %eax,%rcx
  804fb0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  804fb4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804fb7:	48 63 f0             	movslq %eax,%rsi
  804fba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804fbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804fc1:	48 98                	cltq   
  804fc3:	48 89 0c 24          	mov    %rcx,(%rsp)
  804fc7:	49 89 f9             	mov    %rdi,%r9
  804fca:	49 89 f0             	mov    %rsi,%r8
  804fcd:	48 89 d1             	mov    %rdx,%rcx
  804fd0:	48 89 c2             	mov    %rax,%rdx
  804fd3:	be 00 00 00 00       	mov    $0x0,%esi
  804fd8:	bf 11 00 00 00       	mov    $0x11,%edi
  804fdd:	48 b8 7f 4a 80 00 00 	movabs $0x804a7f,%rax
  804fe4:	00 00 00 
  804fe7:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  804fe9:	c9                   	leaveq 
  804fea:	c3                   	retq   

0000000000804feb <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  804feb:	55                   	push   %rbp
  804fec:	48 89 e5             	mov    %rsp,%rbp
  804fef:	48 83 ec 20          	sub    $0x20,%rsp
  804ff3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804ff7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  804ffb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804fff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805003:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80500a:	00 
  80500b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  805011:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  805017:	48 89 d1             	mov    %rdx,%rcx
  80501a:	48 89 c2             	mov    %rax,%rdx
  80501d:	be 00 00 00 00       	mov    $0x0,%esi
  805022:	bf 12 00 00 00       	mov    $0x12,%edi
  805027:	48 b8 7f 4a 80 00 00 	movabs $0x804a7f,%rax
  80502e:	00 00 00 
  805031:	ff d0                	callq  *%rax
}
  805033:	c9                   	leaveq 
  805034:	c3                   	retq   

0000000000805035 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  805035:	55                   	push   %rbp
  805036:	48 89 e5             	mov    %rsp,%rbp
  805039:	48 83 ec 20          	sub    $0x20,%rsp
  80503d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  805041:	48 b8 28 60 81 00 00 	movabs $0x816028,%rax
  805048:	00 00 00 
  80504b:	48 8b 00             	mov    (%rax),%rax
  80504e:	48 85 c0             	test   %rax,%rax
  805051:	75 6f                	jne    8050c2 <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  805053:	ba 07 00 00 00       	mov    $0x7,%edx
  805058:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80505d:	bf 00 00 00 00       	mov    $0x0,%edi
  805062:	48 b8 55 4c 80 00 00 	movabs $0x804c55,%rax
  805069:	00 00 00 
  80506c:	ff d0                	callq  *%rax
  80506e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805071:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805075:	79 30                	jns    8050a7 <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  805077:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80507a:	89 c1                	mov    %eax,%ecx
  80507c:	48 ba 78 81 80 00 00 	movabs $0x808178,%rdx
  805083:	00 00 00 
  805086:	be 22 00 00 00       	mov    $0x22,%esi
  80508b:	48 bf 97 81 80 00 00 	movabs $0x808197,%rdi
  805092:	00 00 00 
  805095:	b8 00 00 00 00       	mov    $0x0,%eax
  80509a:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  8050a1:	00 00 00 
  8050a4:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  8050a7:	48 be d5 50 80 00 00 	movabs $0x8050d5,%rsi
  8050ae:	00 00 00 
  8050b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8050b6:	48 b8 df 4d 80 00 00 	movabs $0x804ddf,%rax
  8050bd:	00 00 00 
  8050c0:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8050c2:	48 b8 28 60 81 00 00 	movabs $0x816028,%rax
  8050c9:	00 00 00 
  8050cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8050d0:	48 89 10             	mov    %rdx,(%rax)
}
  8050d3:	c9                   	leaveq 
  8050d4:	c3                   	retq   

00000000008050d5 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8050d5:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8050d8:	48 a1 28 60 81 00 00 	movabs 0x816028,%rax
  8050df:	00 00 00 
call *%rax
  8050e2:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  8050e4:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  8050eb:	00 08 
    movq 152(%rsp), %rax
  8050ed:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  8050f4:	00 
    movq 136(%rsp), %rbx
  8050f5:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8050fc:	00 
movq %rbx, (%rax)
  8050fd:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  805100:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  805104:	4c 8b 3c 24          	mov    (%rsp),%r15
  805108:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80510d:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  805112:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  805117:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80511c:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  805121:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  805126:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80512b:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  805130:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  805135:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80513a:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80513f:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  805144:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  805149:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80514e:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  805152:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  805156:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  805157:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  80515c:	c3                   	retq   

000000000080515d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80515d:	55                   	push   %rbp
  80515e:	48 89 e5             	mov    %rsp,%rbp
  805161:	48 83 ec 30          	sub    $0x30,%rsp
  805165:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805169:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80516d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  805171:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805176:	75 0e                	jne    805186 <ipc_recv+0x29>
		pg = (void*) UTOP;
  805178:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80517f:	00 00 00 
  805182:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  805186:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80518a:	48 89 c7             	mov    %rax,%rdi
  80518d:	48 b8 7e 4e 80 00 00 	movabs $0x804e7e,%rax
  805194:	00 00 00 
  805197:	ff d0                	callq  *%rax
  805199:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80519c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8051a0:	79 27                	jns    8051c9 <ipc_recv+0x6c>
		if (from_env_store)
  8051a2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8051a7:	74 0a                	je     8051b3 <ipc_recv+0x56>
			*from_env_store = 0;
  8051a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8051ad:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8051b3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8051b8:	74 0a                	je     8051c4 <ipc_recv+0x67>
			*perm_store = 0;
  8051ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8051be:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8051c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051c7:	eb 53                	jmp    80521c <ipc_recv+0xbf>
	}
	if (from_env_store)
  8051c9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8051ce:	74 19                	je     8051e9 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8051d0:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  8051d7:	00 00 00 
  8051da:	48 8b 00             	mov    (%rax),%rax
  8051dd:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8051e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8051e7:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8051e9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8051ee:	74 19                	je     805209 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8051f0:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  8051f7:	00 00 00 
  8051fa:	48 8b 00             	mov    (%rax),%rax
  8051fd:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  805203:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805207:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  805209:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  805210:	00 00 00 
  805213:	48 8b 00             	mov    (%rax),%rax
  805216:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  80521c:	c9                   	leaveq 
  80521d:	c3                   	retq   

000000000080521e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80521e:	55                   	push   %rbp
  80521f:	48 89 e5             	mov    %rsp,%rbp
  805222:	48 83 ec 30          	sub    $0x30,%rsp
  805226:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805229:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80522c:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  805230:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  805233:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805238:	75 10                	jne    80524a <ipc_send+0x2c>
		pg = (void*) UTOP;
  80523a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805241:	00 00 00 
  805244:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  805248:	eb 0e                	jmp    805258 <ipc_send+0x3a>
  80524a:	eb 0c                	jmp    805258 <ipc_send+0x3a>
		sys_yield();
  80524c:	48 b8 17 4c 80 00 00 	movabs $0x804c17,%rax
  805253:	00 00 00 
  805256:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  805258:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80525b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80525e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805262:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805265:	89 c7                	mov    %eax,%edi
  805267:	48 b8 29 4e 80 00 00 	movabs $0x804e29,%rax
  80526e:	00 00 00 
  805271:	ff d0                	callq  *%rax
  805273:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805276:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80527a:	74 d0                	je     80524c <ipc_send+0x2e>
		sys_yield();
	}
	if (r < 0)
  80527c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805280:	79 30                	jns    8052b2 <ipc_send+0x94>
		panic("error in ipc_send: %e", r);
  805282:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805285:	89 c1                	mov    %eax,%ecx
  805287:	48 ba a5 81 80 00 00 	movabs $0x8081a5,%rdx
  80528e:	00 00 00 
  805291:	be 47 00 00 00       	mov    $0x47,%esi
  805296:	48 bf bb 81 80 00 00 	movabs $0x8081bb,%rdi
  80529d:	00 00 00 
  8052a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8052a5:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  8052ac:	00 00 00 
  8052af:	41 ff d0             	callq  *%r8

}
  8052b2:	c9                   	leaveq 
  8052b3:	c3                   	retq   

00000000008052b4 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8052b4:	55                   	push   %rbp
  8052b5:	48 89 e5             	mov    %rsp,%rbp
  8052b8:	53                   	push   %rbx
  8052b9:	48 83 ec 28          	sub    $0x28,%rsp
  8052bd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  8052c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8052c8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  8052cf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8052d4:	75 0e                	jne    8052e4 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  8052d6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8052dd:	00 00 00 
  8052e0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  8052e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8052e8:	ba 07 00 00 00       	mov    $0x7,%edx
  8052ed:	48 89 c6             	mov    %rax,%rsi
  8052f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8052f5:	48 b8 55 4c 80 00 00 	movabs $0x804c55,%rax
  8052fc:	00 00 00 
  8052ff:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  805301:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805305:	48 c1 e8 0c          	shr    $0xc,%rax
  805309:	48 89 c2             	mov    %rax,%rdx
  80530c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805313:	01 00 00 
  805316:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80531a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  805320:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  805324:	b8 03 00 00 00       	mov    $0x3,%eax
  805329:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80532d:	48 89 d3             	mov    %rdx,%rbx
  805330:	0f 01 c1             	vmcall 
  805333:	89 f2                	mov    %esi,%edx
  805335:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805338:	89 55 e8             	mov    %edx,-0x18(%rbp)
	/* cprintf("Returned IPC response from host: %d %d\n", r, -val);*/
	if (r < 0) {
  80533b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80533f:	79 05                	jns    805346 <ipc_host_recv+0x92>
		return r;
  805341:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805344:	eb 03                	jmp    805349 <ipc_host_recv+0x95>
	}
	return val;
  805346:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  805349:	48 83 c4 28          	add    $0x28,%rsp
  80534d:	5b                   	pop    %rbx
  80534e:	5d                   	pop    %rbp
  80534f:	c3                   	retq   

0000000000805350 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  805350:	55                   	push   %rbp
  805351:	48 89 e5             	mov    %rsp,%rbp
  805354:	53                   	push   %rbx
  805355:	48 83 ec 38          	sub    $0x38,%rsp
  805359:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80535c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80535f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  805363:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  805366:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  80536d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  805372:	75 0e                	jne    805382 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  805374:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80537b:	00 00 00 
  80537e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  805382:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805386:	48 c1 e8 0c          	shr    $0xc,%rax
  80538a:	48 89 c2             	mov    %rax,%rdx
  80538d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805394:	01 00 00 
  805397:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80539b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8053a1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8053a5:	b8 02 00 00 00       	mov    $0x2,%eax
  8053aa:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8053ad:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8053b0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8053b4:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8053b7:	89 fb                	mov    %edi,%ebx
  8053b9:	0f 01 c1             	vmcall 
  8053bc:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8053bf:	eb 26                	jmp    8053e7 <ipc_host_send+0x97>
		sys_yield();
  8053c1:	48 b8 17 4c 80 00 00 	movabs $0x804c17,%rax
  8053c8:	00 00 00 
  8053cb:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8053cd:	b8 02 00 00 00       	mov    $0x2,%eax
  8053d2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8053d5:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8053d8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8053dc:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8053df:	89 fb                	mov    %edi,%ebx
  8053e1:	0f 01 c1             	vmcall 
  8053e4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8053e7:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  8053eb:	74 d4                	je     8053c1 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  8053ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8053f1:	79 30                	jns    805423 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  8053f3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8053f6:	89 c1                	mov    %eax,%ecx
  8053f8:	48 ba a5 81 80 00 00 	movabs $0x8081a5,%rdx
  8053ff:	00 00 00 
  805402:	be 79 00 00 00       	mov    $0x79,%esi
  805407:	48 bf bb 81 80 00 00 	movabs $0x8081bb,%rdi
  80540e:	00 00 00 
  805411:	b8 00 00 00 00       	mov    $0x0,%eax
  805416:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  80541d:	00 00 00 
  805420:	41 ff d0             	callq  *%r8

}
  805423:	48 83 c4 38          	add    $0x38,%rsp
  805427:	5b                   	pop    %rbx
  805428:	5d                   	pop    %rbp
  805429:	c3                   	retq   

000000000080542a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80542a:	55                   	push   %rbp
  80542b:	48 89 e5             	mov    %rsp,%rbp
  80542e:	48 83 ec 14          	sub    $0x14,%rsp
  805432:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  805435:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80543c:	eb 4e                	jmp    80548c <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  80543e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805445:	00 00 00 
  805448:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80544b:	48 98                	cltq   
  80544d:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  805454:	48 01 d0             	add    %rdx,%rax
  805457:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80545d:	8b 00                	mov    (%rax),%eax
  80545f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805462:	75 24                	jne    805488 <ipc_find_env+0x5e>
			return envs[i].env_id;
  805464:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80546b:	00 00 00 
  80546e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805471:	48 98                	cltq   
  805473:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80547a:	48 01 d0             	add    %rdx,%rax
  80547d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  805483:	8b 40 08             	mov    0x8(%rax),%eax
  805486:	eb 12                	jmp    80549a <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  805488:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80548c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  805493:	7e a9                	jle    80543e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  805495:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80549a:	c9                   	leaveq 
  80549b:	c3                   	retq   

000000000080549c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80549c:	55                   	push   %rbp
  80549d:	48 89 e5             	mov    %rsp,%rbp
  8054a0:	48 83 ec 08          	sub    $0x8,%rsp
  8054a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8054a8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8054ac:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8054b3:	ff ff ff 
  8054b6:	48 01 d0             	add    %rdx,%rax
  8054b9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8054bd:	c9                   	leaveq 
  8054be:	c3                   	retq   

00000000008054bf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8054bf:	55                   	push   %rbp
  8054c0:	48 89 e5             	mov    %rsp,%rbp
  8054c3:	48 83 ec 08          	sub    $0x8,%rsp
  8054c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8054cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8054cf:	48 89 c7             	mov    %rax,%rdi
  8054d2:	48 b8 9c 54 80 00 00 	movabs $0x80549c,%rax
  8054d9:	00 00 00 
  8054dc:	ff d0                	callq  *%rax
  8054de:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8054e4:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8054e8:	c9                   	leaveq 
  8054e9:	c3                   	retq   

00000000008054ea <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8054ea:	55                   	push   %rbp
  8054eb:	48 89 e5             	mov    %rsp,%rbp
  8054ee:	48 83 ec 18          	sub    $0x18,%rsp
  8054f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8054f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8054fd:	eb 6b                	jmp    80556a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8054ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805502:	48 98                	cltq   
  805504:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80550a:	48 c1 e0 0c          	shl    $0xc,%rax
  80550e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  805512:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805516:	48 c1 e8 15          	shr    $0x15,%rax
  80551a:	48 89 c2             	mov    %rax,%rdx
  80551d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805524:	01 00 00 
  805527:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80552b:	83 e0 01             	and    $0x1,%eax
  80552e:	48 85 c0             	test   %rax,%rax
  805531:	74 21                	je     805554 <fd_alloc+0x6a>
  805533:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805537:	48 c1 e8 0c          	shr    $0xc,%rax
  80553b:	48 89 c2             	mov    %rax,%rdx
  80553e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805545:	01 00 00 
  805548:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80554c:	83 e0 01             	and    $0x1,%eax
  80554f:	48 85 c0             	test   %rax,%rax
  805552:	75 12                	jne    805566 <fd_alloc+0x7c>
			*fd_store = fd;
  805554:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805558:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80555c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80555f:	b8 00 00 00 00       	mov    $0x0,%eax
  805564:	eb 1a                	jmp    805580 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  805566:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80556a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80556e:	7e 8f                	jle    8054ff <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  805570:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805574:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80557b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  805580:	c9                   	leaveq 
  805581:	c3                   	retq   

0000000000805582 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  805582:	55                   	push   %rbp
  805583:	48 89 e5             	mov    %rsp,%rbp
  805586:	48 83 ec 20          	sub    $0x20,%rsp
  80558a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80558d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  805591:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805595:	78 06                	js     80559d <fd_lookup+0x1b>
  805597:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80559b:	7e 07                	jle    8055a4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80559d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8055a2:	eb 6c                	jmp    805610 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8055a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8055a7:	48 98                	cltq   
  8055a9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8055af:	48 c1 e0 0c          	shl    $0xc,%rax
  8055b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8055b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055bb:	48 c1 e8 15          	shr    $0x15,%rax
  8055bf:	48 89 c2             	mov    %rax,%rdx
  8055c2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8055c9:	01 00 00 
  8055cc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8055d0:	83 e0 01             	and    $0x1,%eax
  8055d3:	48 85 c0             	test   %rax,%rax
  8055d6:	74 21                	je     8055f9 <fd_lookup+0x77>
  8055d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055dc:	48 c1 e8 0c          	shr    $0xc,%rax
  8055e0:	48 89 c2             	mov    %rax,%rdx
  8055e3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8055ea:	01 00 00 
  8055ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8055f1:	83 e0 01             	and    $0x1,%eax
  8055f4:	48 85 c0             	test   %rax,%rax
  8055f7:	75 07                	jne    805600 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8055f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8055fe:	eb 10                	jmp    805610 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  805600:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805604:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805608:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80560b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805610:	c9                   	leaveq 
  805611:	c3                   	retq   

0000000000805612 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  805612:	55                   	push   %rbp
  805613:	48 89 e5             	mov    %rsp,%rbp
  805616:	48 83 ec 30          	sub    $0x30,%rsp
  80561a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80561e:	89 f0                	mov    %esi,%eax
  805620:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  805623:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805627:	48 89 c7             	mov    %rax,%rdi
  80562a:	48 b8 9c 54 80 00 00 	movabs $0x80549c,%rax
  805631:	00 00 00 
  805634:	ff d0                	callq  *%rax
  805636:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80563a:	48 89 d6             	mov    %rdx,%rsi
  80563d:	89 c7                	mov    %eax,%edi
  80563f:	48 b8 82 55 80 00 00 	movabs $0x805582,%rax
  805646:	00 00 00 
  805649:	ff d0                	callq  *%rax
  80564b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80564e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805652:	78 0a                	js     80565e <fd_close+0x4c>
	    || fd != fd2)
  805654:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805658:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80565c:	74 12                	je     805670 <fd_close+0x5e>
		return (must_exist ? r : 0);
  80565e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  805662:	74 05                	je     805669 <fd_close+0x57>
  805664:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805667:	eb 05                	jmp    80566e <fd_close+0x5c>
  805669:	b8 00 00 00 00       	mov    $0x0,%eax
  80566e:	eb 69                	jmp    8056d9 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  805670:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805674:	8b 00                	mov    (%rax),%eax
  805676:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80567a:	48 89 d6             	mov    %rdx,%rsi
  80567d:	89 c7                	mov    %eax,%edi
  80567f:	48 b8 db 56 80 00 00 	movabs $0x8056db,%rax
  805686:	00 00 00 
  805689:	ff d0                	callq  *%rax
  80568b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80568e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805692:	78 2a                	js     8056be <fd_close+0xac>
		if (dev->dev_close)
  805694:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805698:	48 8b 40 20          	mov    0x20(%rax),%rax
  80569c:	48 85 c0             	test   %rax,%rax
  80569f:	74 16                	je     8056b7 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8056a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8056a5:	48 8b 40 20          	mov    0x20(%rax),%rax
  8056a9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8056ad:	48 89 d7             	mov    %rdx,%rdi
  8056b0:	ff d0                	callq  *%rax
  8056b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8056b5:	eb 07                	jmp    8056be <fd_close+0xac>
		else
			r = 0;
  8056b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8056be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8056c2:	48 89 c6             	mov    %rax,%rsi
  8056c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8056ca:	48 b8 00 4d 80 00 00 	movabs $0x804d00,%rax
  8056d1:	00 00 00 
  8056d4:	ff d0                	callq  *%rax
	return r;
  8056d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8056d9:	c9                   	leaveq 
  8056da:	c3                   	retq   

00000000008056db <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8056db:	55                   	push   %rbp
  8056dc:	48 89 e5             	mov    %rsp,%rbp
  8056df:	48 83 ec 20          	sub    $0x20,%rsp
  8056e3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8056e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8056ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8056f1:	eb 41                	jmp    805734 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8056f3:	48 b8 a0 20 81 00 00 	movabs $0x8120a0,%rax
  8056fa:	00 00 00 
  8056fd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805700:	48 63 d2             	movslq %edx,%rdx
  805703:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805707:	8b 00                	mov    (%rax),%eax
  805709:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80570c:	75 22                	jne    805730 <dev_lookup+0x55>
			*dev = devtab[i];
  80570e:	48 b8 a0 20 81 00 00 	movabs $0x8120a0,%rax
  805715:	00 00 00 
  805718:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80571b:	48 63 d2             	movslq %edx,%rdx
  80571e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  805722:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805726:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  805729:	b8 00 00 00 00       	mov    $0x0,%eax
  80572e:	eb 60                	jmp    805790 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  805730:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805734:	48 b8 a0 20 81 00 00 	movabs $0x8120a0,%rax
  80573b:	00 00 00 
  80573e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805741:	48 63 d2             	movslq %edx,%rdx
  805744:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805748:	48 85 c0             	test   %rax,%rax
  80574b:	75 a6                	jne    8056f3 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80574d:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  805754:	00 00 00 
  805757:	48 8b 00             	mov    (%rax),%rax
  80575a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805760:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805763:	89 c6                	mov    %eax,%esi
  805765:	48 bf c8 81 80 00 00 	movabs $0x8081c8,%rdi
  80576c:	00 00 00 
  80576f:	b8 00 00 00 00       	mov    $0x0,%eax
  805774:	48 b9 71 37 80 00 00 	movabs $0x803771,%rcx
  80577b:	00 00 00 
  80577e:	ff d1                	callq  *%rcx
	*dev = 0;
  805780:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805784:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80578b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  805790:	c9                   	leaveq 
  805791:	c3                   	retq   

0000000000805792 <close>:

int
close(int fdnum)
{
  805792:	55                   	push   %rbp
  805793:	48 89 e5             	mov    %rsp,%rbp
  805796:	48 83 ec 20          	sub    $0x20,%rsp
  80579a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80579d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8057a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8057a4:	48 89 d6             	mov    %rdx,%rsi
  8057a7:	89 c7                	mov    %eax,%edi
  8057a9:	48 b8 82 55 80 00 00 	movabs $0x805582,%rax
  8057b0:	00 00 00 
  8057b3:	ff d0                	callq  *%rax
  8057b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8057b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8057bc:	79 05                	jns    8057c3 <close+0x31>
		return r;
  8057be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8057c1:	eb 18                	jmp    8057db <close+0x49>
	else
		return fd_close(fd, 1);
  8057c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8057c7:	be 01 00 00 00       	mov    $0x1,%esi
  8057cc:	48 89 c7             	mov    %rax,%rdi
  8057cf:	48 b8 12 56 80 00 00 	movabs $0x805612,%rax
  8057d6:	00 00 00 
  8057d9:	ff d0                	callq  *%rax
}
  8057db:	c9                   	leaveq 
  8057dc:	c3                   	retq   

00000000008057dd <close_all>:

void
close_all(void)
{
  8057dd:	55                   	push   %rbp
  8057de:	48 89 e5             	mov    %rsp,%rbp
  8057e1:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8057e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8057ec:	eb 15                	jmp    805803 <close_all+0x26>
		close(i);
  8057ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8057f1:	89 c7                	mov    %eax,%edi
  8057f3:	48 b8 92 57 80 00 00 	movabs $0x805792,%rax
  8057fa:	00 00 00 
  8057fd:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8057ff:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805803:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  805807:	7e e5                	jle    8057ee <close_all+0x11>
		close(i);
}
  805809:	c9                   	leaveq 
  80580a:	c3                   	retq   

000000000080580b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80580b:	55                   	push   %rbp
  80580c:	48 89 e5             	mov    %rsp,%rbp
  80580f:	48 83 ec 40          	sub    $0x40,%rsp
  805813:	89 7d cc             	mov    %edi,-0x34(%rbp)
  805816:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  805819:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80581d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  805820:	48 89 d6             	mov    %rdx,%rsi
  805823:	89 c7                	mov    %eax,%edi
  805825:	48 b8 82 55 80 00 00 	movabs $0x805582,%rax
  80582c:	00 00 00 
  80582f:	ff d0                	callq  *%rax
  805831:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805834:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805838:	79 08                	jns    805842 <dup+0x37>
		return r;
  80583a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80583d:	e9 70 01 00 00       	jmpq   8059b2 <dup+0x1a7>
	close(newfdnum);
  805842:	8b 45 c8             	mov    -0x38(%rbp),%eax
  805845:	89 c7                	mov    %eax,%edi
  805847:	48 b8 92 57 80 00 00 	movabs $0x805792,%rax
  80584e:	00 00 00 
  805851:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  805853:	8b 45 c8             	mov    -0x38(%rbp),%eax
  805856:	48 98                	cltq   
  805858:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80585e:	48 c1 e0 0c          	shl    $0xc,%rax
  805862:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  805866:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80586a:	48 89 c7             	mov    %rax,%rdi
  80586d:	48 b8 bf 54 80 00 00 	movabs $0x8054bf,%rax
  805874:	00 00 00 
  805877:	ff d0                	callq  *%rax
  805879:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80587d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805881:	48 89 c7             	mov    %rax,%rdi
  805884:	48 b8 bf 54 80 00 00 	movabs $0x8054bf,%rax
  80588b:	00 00 00 
  80588e:	ff d0                	callq  *%rax
  805890:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  805894:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805898:	48 c1 e8 15          	shr    $0x15,%rax
  80589c:	48 89 c2             	mov    %rax,%rdx
  80589f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8058a6:	01 00 00 
  8058a9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8058ad:	83 e0 01             	and    $0x1,%eax
  8058b0:	48 85 c0             	test   %rax,%rax
  8058b3:	74 73                	je     805928 <dup+0x11d>
  8058b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8058b9:	48 c1 e8 0c          	shr    $0xc,%rax
  8058bd:	48 89 c2             	mov    %rax,%rdx
  8058c0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8058c7:	01 00 00 
  8058ca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8058ce:	83 e0 01             	and    $0x1,%eax
  8058d1:	48 85 c0             	test   %rax,%rax
  8058d4:	74 52                	je     805928 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8058d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8058da:	48 c1 e8 0c          	shr    $0xc,%rax
  8058de:	48 89 c2             	mov    %rax,%rdx
  8058e1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8058e8:	01 00 00 
  8058eb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8058ef:	25 07 0e 00 00       	and    $0xe07,%eax
  8058f4:	89 c1                	mov    %eax,%ecx
  8058f6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8058fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8058fe:	41 89 c8             	mov    %ecx,%r8d
  805901:	48 89 d1             	mov    %rdx,%rcx
  805904:	ba 00 00 00 00       	mov    $0x0,%edx
  805909:	48 89 c6             	mov    %rax,%rsi
  80590c:	bf 00 00 00 00       	mov    $0x0,%edi
  805911:	48 b8 a5 4c 80 00 00 	movabs $0x804ca5,%rax
  805918:	00 00 00 
  80591b:	ff d0                	callq  *%rax
  80591d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805920:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805924:	79 02                	jns    805928 <dup+0x11d>
			goto err;
  805926:	eb 57                	jmp    80597f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  805928:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80592c:	48 c1 e8 0c          	shr    $0xc,%rax
  805930:	48 89 c2             	mov    %rax,%rdx
  805933:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80593a:	01 00 00 
  80593d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805941:	25 07 0e 00 00       	and    $0xe07,%eax
  805946:	89 c1                	mov    %eax,%ecx
  805948:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80594c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805950:	41 89 c8             	mov    %ecx,%r8d
  805953:	48 89 d1             	mov    %rdx,%rcx
  805956:	ba 00 00 00 00       	mov    $0x0,%edx
  80595b:	48 89 c6             	mov    %rax,%rsi
  80595e:	bf 00 00 00 00       	mov    $0x0,%edi
  805963:	48 b8 a5 4c 80 00 00 	movabs $0x804ca5,%rax
  80596a:	00 00 00 
  80596d:	ff d0                	callq  *%rax
  80596f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805972:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805976:	79 02                	jns    80597a <dup+0x16f>
		goto err;
  805978:	eb 05                	jmp    80597f <dup+0x174>

	return newfdnum;
  80597a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80597d:	eb 33                	jmp    8059b2 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80597f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805983:	48 89 c6             	mov    %rax,%rsi
  805986:	bf 00 00 00 00       	mov    $0x0,%edi
  80598b:	48 b8 00 4d 80 00 00 	movabs $0x804d00,%rax
  805992:	00 00 00 
  805995:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  805997:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80599b:	48 89 c6             	mov    %rax,%rsi
  80599e:	bf 00 00 00 00       	mov    $0x0,%edi
  8059a3:	48 b8 00 4d 80 00 00 	movabs $0x804d00,%rax
  8059aa:	00 00 00 
  8059ad:	ff d0                	callq  *%rax
	return r;
  8059af:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8059b2:	c9                   	leaveq 
  8059b3:	c3                   	retq   

00000000008059b4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8059b4:	55                   	push   %rbp
  8059b5:	48 89 e5             	mov    %rsp,%rbp
  8059b8:	48 83 ec 40          	sub    $0x40,%rsp
  8059bc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8059bf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8059c3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8059c7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8059cb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8059ce:	48 89 d6             	mov    %rdx,%rsi
  8059d1:	89 c7                	mov    %eax,%edi
  8059d3:	48 b8 82 55 80 00 00 	movabs $0x805582,%rax
  8059da:	00 00 00 
  8059dd:	ff d0                	callq  *%rax
  8059df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8059e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8059e6:	78 24                	js     805a0c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8059e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8059ec:	8b 00                	mov    (%rax),%eax
  8059ee:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8059f2:	48 89 d6             	mov    %rdx,%rsi
  8059f5:	89 c7                	mov    %eax,%edi
  8059f7:	48 b8 db 56 80 00 00 	movabs $0x8056db,%rax
  8059fe:	00 00 00 
  805a01:	ff d0                	callq  *%rax
  805a03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805a06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805a0a:	79 05                	jns    805a11 <read+0x5d>
		return r;
  805a0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a0f:	eb 76                	jmp    805a87 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  805a11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805a15:	8b 40 08             	mov    0x8(%rax),%eax
  805a18:	83 e0 03             	and    $0x3,%eax
  805a1b:	83 f8 01             	cmp    $0x1,%eax
  805a1e:	75 3a                	jne    805a5a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  805a20:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  805a27:	00 00 00 
  805a2a:	48 8b 00             	mov    (%rax),%rax
  805a2d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805a33:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805a36:	89 c6                	mov    %eax,%esi
  805a38:	48 bf e7 81 80 00 00 	movabs $0x8081e7,%rdi
  805a3f:	00 00 00 
  805a42:	b8 00 00 00 00       	mov    $0x0,%eax
  805a47:	48 b9 71 37 80 00 00 	movabs $0x803771,%rcx
  805a4e:	00 00 00 
  805a51:	ff d1                	callq  *%rcx
		return -E_INVAL;
  805a53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805a58:	eb 2d                	jmp    805a87 <read+0xd3>
	}
	if (!dev->dev_read)
  805a5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a5e:	48 8b 40 10          	mov    0x10(%rax),%rax
  805a62:	48 85 c0             	test   %rax,%rax
  805a65:	75 07                	jne    805a6e <read+0xba>
		return -E_NOT_SUPP;
  805a67:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805a6c:	eb 19                	jmp    805a87 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  805a6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a72:	48 8b 40 10          	mov    0x10(%rax),%rax
  805a76:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  805a7a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  805a7e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  805a82:	48 89 cf             	mov    %rcx,%rdi
  805a85:	ff d0                	callq  *%rax
}
  805a87:	c9                   	leaveq 
  805a88:	c3                   	retq   

0000000000805a89 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  805a89:	55                   	push   %rbp
  805a8a:	48 89 e5             	mov    %rsp,%rbp
  805a8d:	48 83 ec 30          	sub    $0x30,%rsp
  805a91:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805a94:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805a98:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  805a9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805aa3:	eb 49                	jmp    805aee <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  805aa5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805aa8:	48 98                	cltq   
  805aaa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805aae:	48 29 c2             	sub    %rax,%rdx
  805ab1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805ab4:	48 63 c8             	movslq %eax,%rcx
  805ab7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805abb:	48 01 c1             	add    %rax,%rcx
  805abe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805ac1:	48 89 ce             	mov    %rcx,%rsi
  805ac4:	89 c7                	mov    %eax,%edi
  805ac6:	48 b8 b4 59 80 00 00 	movabs $0x8059b4,%rax
  805acd:	00 00 00 
  805ad0:	ff d0                	callq  *%rax
  805ad2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  805ad5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805ad9:	79 05                	jns    805ae0 <readn+0x57>
			return m;
  805adb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805ade:	eb 1c                	jmp    805afc <readn+0x73>
		if (m == 0)
  805ae0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805ae4:	75 02                	jne    805ae8 <readn+0x5f>
			break;
  805ae6:	eb 11                	jmp    805af9 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  805ae8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805aeb:	01 45 fc             	add    %eax,-0x4(%rbp)
  805aee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805af1:	48 98                	cltq   
  805af3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  805af7:	72 ac                	jb     805aa5 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  805af9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805afc:	c9                   	leaveq 
  805afd:	c3                   	retq   

0000000000805afe <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  805afe:	55                   	push   %rbp
  805aff:	48 89 e5             	mov    %rsp,%rbp
  805b02:	48 83 ec 40          	sub    $0x40,%rsp
  805b06:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805b09:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805b0d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  805b11:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805b15:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805b18:	48 89 d6             	mov    %rdx,%rsi
  805b1b:	89 c7                	mov    %eax,%edi
  805b1d:	48 b8 82 55 80 00 00 	movabs $0x805582,%rax
  805b24:	00 00 00 
  805b27:	ff d0                	callq  *%rax
  805b29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805b2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805b30:	78 24                	js     805b56 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805b32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805b36:	8b 00                	mov    (%rax),%eax
  805b38:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805b3c:	48 89 d6             	mov    %rdx,%rsi
  805b3f:	89 c7                	mov    %eax,%edi
  805b41:	48 b8 db 56 80 00 00 	movabs $0x8056db,%rax
  805b48:	00 00 00 
  805b4b:	ff d0                	callq  *%rax
  805b4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805b50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805b54:	79 05                	jns    805b5b <write+0x5d>
		return r;
  805b56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805b59:	eb 75                	jmp    805bd0 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  805b5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805b5f:	8b 40 08             	mov    0x8(%rax),%eax
  805b62:	83 e0 03             	and    $0x3,%eax
  805b65:	85 c0                	test   %eax,%eax
  805b67:	75 3a                	jne    805ba3 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  805b69:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  805b70:	00 00 00 
  805b73:	48 8b 00             	mov    (%rax),%rax
  805b76:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805b7c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805b7f:	89 c6                	mov    %eax,%esi
  805b81:	48 bf 03 82 80 00 00 	movabs $0x808203,%rdi
  805b88:	00 00 00 
  805b8b:	b8 00 00 00 00       	mov    $0x0,%eax
  805b90:	48 b9 71 37 80 00 00 	movabs $0x803771,%rcx
  805b97:	00 00 00 
  805b9a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  805b9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805ba1:	eb 2d                	jmp    805bd0 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  805ba3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805ba7:	48 8b 40 18          	mov    0x18(%rax),%rax
  805bab:	48 85 c0             	test   %rax,%rax
  805bae:	75 07                	jne    805bb7 <write+0xb9>
		return -E_NOT_SUPP;
  805bb0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805bb5:	eb 19                	jmp    805bd0 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  805bb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805bbb:	48 8b 40 18          	mov    0x18(%rax),%rax
  805bbf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  805bc3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  805bc7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  805bcb:	48 89 cf             	mov    %rcx,%rdi
  805bce:	ff d0                	callq  *%rax
}
  805bd0:	c9                   	leaveq 
  805bd1:	c3                   	retq   

0000000000805bd2 <seek>:

int
seek(int fdnum, off_t offset)
{
  805bd2:	55                   	push   %rbp
  805bd3:	48 89 e5             	mov    %rsp,%rbp
  805bd6:	48 83 ec 18          	sub    $0x18,%rsp
  805bda:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805bdd:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  805be0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805be4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805be7:	48 89 d6             	mov    %rdx,%rsi
  805bea:	89 c7                	mov    %eax,%edi
  805bec:	48 b8 82 55 80 00 00 	movabs $0x805582,%rax
  805bf3:	00 00 00 
  805bf6:	ff d0                	callq  *%rax
  805bf8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805bfb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805bff:	79 05                	jns    805c06 <seek+0x34>
		return r;
  805c01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c04:	eb 0f                	jmp    805c15 <seek+0x43>
	fd->fd_offset = offset;
  805c06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805c0a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805c0d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  805c10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805c15:	c9                   	leaveq 
  805c16:	c3                   	retq   

0000000000805c17 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  805c17:	55                   	push   %rbp
  805c18:	48 89 e5             	mov    %rsp,%rbp
  805c1b:	48 83 ec 30          	sub    $0x30,%rsp
  805c1f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805c22:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  805c25:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805c29:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805c2c:	48 89 d6             	mov    %rdx,%rsi
  805c2f:	89 c7                	mov    %eax,%edi
  805c31:	48 b8 82 55 80 00 00 	movabs $0x805582,%rax
  805c38:	00 00 00 
  805c3b:	ff d0                	callq  *%rax
  805c3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805c40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805c44:	78 24                	js     805c6a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805c46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805c4a:	8b 00                	mov    (%rax),%eax
  805c4c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805c50:	48 89 d6             	mov    %rdx,%rsi
  805c53:	89 c7                	mov    %eax,%edi
  805c55:	48 b8 db 56 80 00 00 	movabs $0x8056db,%rax
  805c5c:	00 00 00 
  805c5f:	ff d0                	callq  *%rax
  805c61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805c64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805c68:	79 05                	jns    805c6f <ftruncate+0x58>
		return r;
  805c6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c6d:	eb 72                	jmp    805ce1 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  805c6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805c73:	8b 40 08             	mov    0x8(%rax),%eax
  805c76:	83 e0 03             	and    $0x3,%eax
  805c79:	85 c0                	test   %eax,%eax
  805c7b:	75 3a                	jne    805cb7 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  805c7d:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  805c84:	00 00 00 
  805c87:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  805c8a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805c90:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805c93:	89 c6                	mov    %eax,%esi
  805c95:	48 bf 20 82 80 00 00 	movabs $0x808220,%rdi
  805c9c:	00 00 00 
  805c9f:	b8 00 00 00 00       	mov    $0x0,%eax
  805ca4:	48 b9 71 37 80 00 00 	movabs $0x803771,%rcx
  805cab:	00 00 00 
  805cae:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  805cb0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805cb5:	eb 2a                	jmp    805ce1 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  805cb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805cbb:	48 8b 40 30          	mov    0x30(%rax),%rax
  805cbf:	48 85 c0             	test   %rax,%rax
  805cc2:	75 07                	jne    805ccb <ftruncate+0xb4>
		return -E_NOT_SUPP;
  805cc4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805cc9:	eb 16                	jmp    805ce1 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  805ccb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805ccf:	48 8b 40 30          	mov    0x30(%rax),%rax
  805cd3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805cd7:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  805cda:	89 ce                	mov    %ecx,%esi
  805cdc:	48 89 d7             	mov    %rdx,%rdi
  805cdf:	ff d0                	callq  *%rax
}
  805ce1:	c9                   	leaveq 
  805ce2:	c3                   	retq   

0000000000805ce3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  805ce3:	55                   	push   %rbp
  805ce4:	48 89 e5             	mov    %rsp,%rbp
  805ce7:	48 83 ec 30          	sub    $0x30,%rsp
  805ceb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805cee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  805cf2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805cf6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805cf9:	48 89 d6             	mov    %rdx,%rsi
  805cfc:	89 c7                	mov    %eax,%edi
  805cfe:	48 b8 82 55 80 00 00 	movabs $0x805582,%rax
  805d05:	00 00 00 
  805d08:	ff d0                	callq  *%rax
  805d0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805d0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805d11:	78 24                	js     805d37 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805d13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805d17:	8b 00                	mov    (%rax),%eax
  805d19:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805d1d:	48 89 d6             	mov    %rdx,%rsi
  805d20:	89 c7                	mov    %eax,%edi
  805d22:	48 b8 db 56 80 00 00 	movabs $0x8056db,%rax
  805d29:	00 00 00 
  805d2c:	ff d0                	callq  *%rax
  805d2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805d31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805d35:	79 05                	jns    805d3c <fstat+0x59>
		return r;
  805d37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805d3a:	eb 5e                	jmp    805d9a <fstat+0xb7>
	if (!dev->dev_stat)
  805d3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805d40:	48 8b 40 28          	mov    0x28(%rax),%rax
  805d44:	48 85 c0             	test   %rax,%rax
  805d47:	75 07                	jne    805d50 <fstat+0x6d>
		return -E_NOT_SUPP;
  805d49:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805d4e:	eb 4a                	jmp    805d9a <fstat+0xb7>
	stat->st_name[0] = 0;
  805d50:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805d54:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  805d57:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805d5b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  805d62:	00 00 00 
	stat->st_isdir = 0;
  805d65:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805d69:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  805d70:	00 00 00 
	stat->st_dev = dev;
  805d73:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805d77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805d7b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  805d82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805d86:	48 8b 40 28          	mov    0x28(%rax),%rax
  805d8a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805d8e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  805d92:	48 89 ce             	mov    %rcx,%rsi
  805d95:	48 89 d7             	mov    %rdx,%rdi
  805d98:	ff d0                	callq  *%rax
}
  805d9a:	c9                   	leaveq 
  805d9b:	c3                   	retq   

0000000000805d9c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  805d9c:	55                   	push   %rbp
  805d9d:	48 89 e5             	mov    %rsp,%rbp
  805da0:	48 83 ec 20          	sub    $0x20,%rsp
  805da4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805da8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  805dac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805db0:	be 00 00 00 00       	mov    $0x0,%esi
  805db5:	48 89 c7             	mov    %rax,%rdi
  805db8:	48 b8 8a 5e 80 00 00 	movabs $0x805e8a,%rax
  805dbf:	00 00 00 
  805dc2:	ff d0                	callq  *%rax
  805dc4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805dc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805dcb:	79 05                	jns    805dd2 <stat+0x36>
		return fd;
  805dcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805dd0:	eb 2f                	jmp    805e01 <stat+0x65>
	r = fstat(fd, stat);
  805dd2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805dd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805dd9:	48 89 d6             	mov    %rdx,%rsi
  805ddc:	89 c7                	mov    %eax,%edi
  805dde:	48 b8 e3 5c 80 00 00 	movabs $0x805ce3,%rax
  805de5:	00 00 00 
  805de8:	ff d0                	callq  *%rax
  805dea:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  805ded:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805df0:	89 c7                	mov    %eax,%edi
  805df2:	48 b8 92 57 80 00 00 	movabs $0x805792,%rax
  805df9:	00 00 00 
  805dfc:	ff d0                	callq  *%rax
	return r;
  805dfe:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  805e01:	c9                   	leaveq 
  805e02:	c3                   	retq   

0000000000805e03 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  805e03:	55                   	push   %rbp
  805e04:	48 89 e5             	mov    %rsp,%rbp
  805e07:	48 83 ec 10          	sub    $0x10,%rsp
  805e0b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805e0e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  805e12:	48 b8 08 60 81 00 00 	movabs $0x816008,%rax
  805e19:	00 00 00 
  805e1c:	8b 00                	mov    (%rax),%eax
  805e1e:	85 c0                	test   %eax,%eax
  805e20:	75 1d                	jne    805e3f <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  805e22:	bf 01 00 00 00       	mov    $0x1,%edi
  805e27:	48 b8 2a 54 80 00 00 	movabs $0x80542a,%rax
  805e2e:	00 00 00 
  805e31:	ff d0                	callq  *%rax
  805e33:	48 ba 08 60 81 00 00 	movabs $0x816008,%rdx
  805e3a:	00 00 00 
  805e3d:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  805e3f:	48 b8 08 60 81 00 00 	movabs $0x816008,%rax
  805e46:	00 00 00 
  805e49:	8b 00                	mov    (%rax),%eax
  805e4b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  805e4e:	b9 07 00 00 00       	mov    $0x7,%ecx
  805e53:	48 ba 00 70 81 00 00 	movabs $0x817000,%rdx
  805e5a:	00 00 00 
  805e5d:	89 c7                	mov    %eax,%edi
  805e5f:	48 b8 1e 52 80 00 00 	movabs $0x80521e,%rax
  805e66:	00 00 00 
  805e69:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  805e6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805e6f:	ba 00 00 00 00       	mov    $0x0,%edx
  805e74:	48 89 c6             	mov    %rax,%rsi
  805e77:	bf 00 00 00 00       	mov    $0x0,%edi
  805e7c:	48 b8 5d 51 80 00 00 	movabs $0x80515d,%rax
  805e83:	00 00 00 
  805e86:	ff d0                	callq  *%rax
}
  805e88:	c9                   	leaveq 
  805e89:	c3                   	retq   

0000000000805e8a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  805e8a:	55                   	push   %rbp
  805e8b:	48 89 e5             	mov    %rsp,%rbp
  805e8e:	48 83 ec 20          	sub    $0x20,%rsp
  805e92:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805e96:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  805e99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805e9d:	48 89 c7             	mov    %rax,%rdi
  805ea0:	48 b8 ba 42 80 00 00 	movabs $0x8042ba,%rax
  805ea7:	00 00 00 
  805eaa:	ff d0                	callq  *%rax
  805eac:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  805eb1:	7e 0a                	jle    805ebd <open+0x33>
		return -E_BAD_PATH;
  805eb3:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  805eb8:	e9 a5 00 00 00       	jmpq   805f62 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  805ebd:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  805ec1:	48 89 c7             	mov    %rax,%rdi
  805ec4:	48 b8 ea 54 80 00 00 	movabs $0x8054ea,%rax
  805ecb:	00 00 00 
  805ece:	ff d0                	callq  *%rax
  805ed0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805ed3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805ed7:	79 08                	jns    805ee1 <open+0x57>
		return r;
  805ed9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805edc:	e9 81 00 00 00       	jmpq   805f62 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  805ee1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805ee5:	48 89 c6             	mov    %rax,%rsi
  805ee8:	48 bf 00 70 81 00 00 	movabs $0x817000,%rdi
  805eef:	00 00 00 
  805ef2:	48 b8 26 43 80 00 00 	movabs $0x804326,%rax
  805ef9:	00 00 00 
  805efc:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  805efe:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  805f05:	00 00 00 
  805f08:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  805f0b:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  805f11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805f15:	48 89 c6             	mov    %rax,%rsi
  805f18:	bf 01 00 00 00       	mov    $0x1,%edi
  805f1d:	48 b8 03 5e 80 00 00 	movabs $0x805e03,%rax
  805f24:	00 00 00 
  805f27:	ff d0                	callq  *%rax
  805f29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805f2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805f30:	79 1d                	jns    805f4f <open+0xc5>
		fd_close(fd, 0);
  805f32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805f36:	be 00 00 00 00       	mov    $0x0,%esi
  805f3b:	48 89 c7             	mov    %rax,%rdi
  805f3e:	48 b8 12 56 80 00 00 	movabs $0x805612,%rax
  805f45:	00 00 00 
  805f48:	ff d0                	callq  *%rax
		return r;
  805f4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805f4d:	eb 13                	jmp    805f62 <open+0xd8>
	}

	return fd2num(fd);
  805f4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805f53:	48 89 c7             	mov    %rax,%rdi
  805f56:	48 b8 9c 54 80 00 00 	movabs $0x80549c,%rax
  805f5d:	00 00 00 
  805f60:	ff d0                	callq  *%rax

}
  805f62:	c9                   	leaveq 
  805f63:	c3                   	retq   

0000000000805f64 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  805f64:	55                   	push   %rbp
  805f65:	48 89 e5             	mov    %rsp,%rbp
  805f68:	48 83 ec 10          	sub    $0x10,%rsp
  805f6c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  805f70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805f74:	8b 50 0c             	mov    0xc(%rax),%edx
  805f77:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  805f7e:	00 00 00 
  805f81:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  805f83:	be 00 00 00 00       	mov    $0x0,%esi
  805f88:	bf 06 00 00 00       	mov    $0x6,%edi
  805f8d:	48 b8 03 5e 80 00 00 	movabs $0x805e03,%rax
  805f94:	00 00 00 
  805f97:	ff d0                	callq  *%rax
}
  805f99:	c9                   	leaveq 
  805f9a:	c3                   	retq   

0000000000805f9b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  805f9b:	55                   	push   %rbp
  805f9c:	48 89 e5             	mov    %rsp,%rbp
  805f9f:	48 83 ec 30          	sub    $0x30,%rsp
  805fa3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805fa7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805fab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  805faf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805fb3:	8b 50 0c             	mov    0xc(%rax),%edx
  805fb6:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  805fbd:	00 00 00 
  805fc0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  805fc2:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  805fc9:	00 00 00 
  805fcc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805fd0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  805fd4:	be 00 00 00 00       	mov    $0x0,%esi
  805fd9:	bf 03 00 00 00       	mov    $0x3,%edi
  805fde:	48 b8 03 5e 80 00 00 	movabs $0x805e03,%rax
  805fe5:	00 00 00 
  805fe8:	ff d0                	callq  *%rax
  805fea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805fed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805ff1:	79 08                	jns    805ffb <devfile_read+0x60>
		return r;
  805ff3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805ff6:	e9 a4 00 00 00       	jmpq   80609f <devfile_read+0x104>
	assert(r <= n);
  805ffb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805ffe:	48 98                	cltq   
  806000:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  806004:	76 35                	jbe    80603b <devfile_read+0xa0>
  806006:	48 b9 46 82 80 00 00 	movabs $0x808246,%rcx
  80600d:	00 00 00 
  806010:	48 ba 4d 82 80 00 00 	movabs $0x80824d,%rdx
  806017:	00 00 00 
  80601a:	be 86 00 00 00       	mov    $0x86,%esi
  80601f:	48 bf 62 82 80 00 00 	movabs $0x808262,%rdi
  806026:	00 00 00 
  806029:	b8 00 00 00 00       	mov    $0x0,%eax
  80602e:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  806035:	00 00 00 
  806038:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  80603b:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  806042:	7e 35                	jle    806079 <devfile_read+0xde>
  806044:	48 b9 6d 82 80 00 00 	movabs $0x80826d,%rcx
  80604b:	00 00 00 
  80604e:	48 ba 4d 82 80 00 00 	movabs $0x80824d,%rdx
  806055:	00 00 00 
  806058:	be 87 00 00 00       	mov    $0x87,%esi
  80605d:	48 bf 62 82 80 00 00 	movabs $0x808262,%rdi
  806064:	00 00 00 
  806067:	b8 00 00 00 00       	mov    $0x0,%eax
  80606c:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  806073:	00 00 00 
  806076:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  806079:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80607c:	48 63 d0             	movslq %eax,%rdx
  80607f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806083:	48 be 00 70 81 00 00 	movabs $0x817000,%rsi
  80608a:	00 00 00 
  80608d:	48 89 c7             	mov    %rax,%rdi
  806090:	48 b8 4a 46 80 00 00 	movabs $0x80464a,%rax
  806097:	00 00 00 
  80609a:	ff d0                	callq  *%rax
	return r;
  80609c:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  80609f:	c9                   	leaveq 
  8060a0:	c3                   	retq   

00000000008060a1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8060a1:	55                   	push   %rbp
  8060a2:	48 89 e5             	mov    %rsp,%rbp
  8060a5:	48 83 ec 40          	sub    $0x40,%rsp
  8060a9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8060ad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8060b1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8060b5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8060b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8060bd:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  8060c4:	00 
  8060c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8060c9:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8060cd:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  8060d2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8060d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8060da:	8b 50 0c             	mov    0xc(%rax),%edx
  8060dd:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  8060e4:	00 00 00 
  8060e7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8060e9:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  8060f0:	00 00 00 
  8060f3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8060f7:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8060fb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8060ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806103:	48 89 c6             	mov    %rax,%rsi
  806106:	48 bf 10 70 81 00 00 	movabs $0x817010,%rdi
  80610d:	00 00 00 
  806110:	48 b8 4a 46 80 00 00 	movabs $0x80464a,%rax
  806117:	00 00 00 
  80611a:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80611c:	be 00 00 00 00       	mov    $0x0,%esi
  806121:	bf 04 00 00 00       	mov    $0x4,%edi
  806126:	48 b8 03 5e 80 00 00 	movabs $0x805e03,%rax
  80612d:	00 00 00 
  806130:	ff d0                	callq  *%rax
  806132:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806135:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806139:	79 05                	jns    806140 <devfile_write+0x9f>
		return r;
  80613b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80613e:	eb 43                	jmp    806183 <devfile_write+0xe2>
	assert(r <= n);
  806140:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806143:	48 98                	cltq   
  806145:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  806149:	76 35                	jbe    806180 <devfile_write+0xdf>
  80614b:	48 b9 46 82 80 00 00 	movabs $0x808246,%rcx
  806152:	00 00 00 
  806155:	48 ba 4d 82 80 00 00 	movabs $0x80824d,%rdx
  80615c:	00 00 00 
  80615f:	be a2 00 00 00       	mov    $0xa2,%esi
  806164:	48 bf 62 82 80 00 00 	movabs $0x808262,%rdi
  80616b:	00 00 00 
  80616e:	b8 00 00 00 00       	mov    $0x0,%eax
  806173:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  80617a:	00 00 00 
  80617d:	41 ff d0             	callq  *%r8
	return r;
  806180:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  806183:	c9                   	leaveq 
  806184:	c3                   	retq   

0000000000806185 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  806185:	55                   	push   %rbp
  806186:	48 89 e5             	mov    %rsp,%rbp
  806189:	48 83 ec 20          	sub    $0x20,%rsp
  80618d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  806191:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  806195:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806199:	8b 50 0c             	mov    0xc(%rax),%edx
  80619c:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  8061a3:	00 00 00 
  8061a6:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8061a8:	be 00 00 00 00       	mov    $0x0,%esi
  8061ad:	bf 05 00 00 00       	mov    $0x5,%edi
  8061b2:	48 b8 03 5e 80 00 00 	movabs $0x805e03,%rax
  8061b9:	00 00 00 
  8061bc:	ff d0                	callq  *%rax
  8061be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8061c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8061c5:	79 05                	jns    8061cc <devfile_stat+0x47>
		return r;
  8061c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8061ca:	eb 56                	jmp    806222 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8061cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8061d0:	48 be 00 70 81 00 00 	movabs $0x817000,%rsi
  8061d7:	00 00 00 
  8061da:	48 89 c7             	mov    %rax,%rdi
  8061dd:	48 b8 26 43 80 00 00 	movabs $0x804326,%rax
  8061e4:	00 00 00 
  8061e7:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8061e9:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  8061f0:	00 00 00 
  8061f3:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8061f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8061fd:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  806203:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  80620a:	00 00 00 
  80620d:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  806213:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806217:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80621d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806222:	c9                   	leaveq 
  806223:	c3                   	retq   

0000000000806224 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  806224:	55                   	push   %rbp
  806225:	48 89 e5             	mov    %rsp,%rbp
  806228:	48 83 ec 10          	sub    $0x10,%rsp
  80622c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  806230:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  806233:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806237:	8b 50 0c             	mov    0xc(%rax),%edx
  80623a:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  806241:	00 00 00 
  806244:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  806246:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  80624d:	00 00 00 
  806250:	8b 55 f4             	mov    -0xc(%rbp),%edx
  806253:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  806256:	be 00 00 00 00       	mov    $0x0,%esi
  80625b:	bf 02 00 00 00       	mov    $0x2,%edi
  806260:	48 b8 03 5e 80 00 00 	movabs $0x805e03,%rax
  806267:	00 00 00 
  80626a:	ff d0                	callq  *%rax
}
  80626c:	c9                   	leaveq 
  80626d:	c3                   	retq   

000000000080626e <remove>:

// Delete a file
int
remove(const char *path)
{
  80626e:	55                   	push   %rbp
  80626f:	48 89 e5             	mov    %rsp,%rbp
  806272:	48 83 ec 10          	sub    $0x10,%rsp
  806276:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80627a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80627e:	48 89 c7             	mov    %rax,%rdi
  806281:	48 b8 ba 42 80 00 00 	movabs $0x8042ba,%rax
  806288:	00 00 00 
  80628b:	ff d0                	callq  *%rax
  80628d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  806292:	7e 07                	jle    80629b <remove+0x2d>
		return -E_BAD_PATH;
  806294:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  806299:	eb 33                	jmp    8062ce <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80629b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80629f:	48 89 c6             	mov    %rax,%rsi
  8062a2:	48 bf 00 70 81 00 00 	movabs $0x817000,%rdi
  8062a9:	00 00 00 
  8062ac:	48 b8 26 43 80 00 00 	movabs $0x804326,%rax
  8062b3:	00 00 00 
  8062b6:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8062b8:	be 00 00 00 00       	mov    $0x0,%esi
  8062bd:	bf 07 00 00 00       	mov    $0x7,%edi
  8062c2:	48 b8 03 5e 80 00 00 	movabs $0x805e03,%rax
  8062c9:	00 00 00 
  8062cc:	ff d0                	callq  *%rax
}
  8062ce:	c9                   	leaveq 
  8062cf:	c3                   	retq   

00000000008062d0 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8062d0:	55                   	push   %rbp
  8062d1:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8062d4:	be 00 00 00 00       	mov    $0x0,%esi
  8062d9:	bf 08 00 00 00       	mov    $0x8,%edi
  8062de:	48 b8 03 5e 80 00 00 	movabs $0x805e03,%rax
  8062e5:	00 00 00 
  8062e8:	ff d0                	callq  *%rax
}
  8062ea:	5d                   	pop    %rbp
  8062eb:	c3                   	retq   

00000000008062ec <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8062ec:	55                   	push   %rbp
  8062ed:	48 89 e5             	mov    %rsp,%rbp
  8062f0:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8062f7:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8062fe:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  806305:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80630c:	be 00 00 00 00       	mov    $0x0,%esi
  806311:	48 89 c7             	mov    %rax,%rdi
  806314:	48 b8 8a 5e 80 00 00 	movabs $0x805e8a,%rax
  80631b:	00 00 00 
  80631e:	ff d0                	callq  *%rax
  806320:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  806323:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806327:	79 28                	jns    806351 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  806329:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80632c:	89 c6                	mov    %eax,%esi
  80632e:	48 bf 79 82 80 00 00 	movabs $0x808279,%rdi
  806335:	00 00 00 
  806338:	b8 00 00 00 00       	mov    $0x0,%eax
  80633d:	48 ba 71 37 80 00 00 	movabs $0x803771,%rdx
  806344:	00 00 00 
  806347:	ff d2                	callq  *%rdx
		return fd_src;
  806349:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80634c:	e9 74 01 00 00       	jmpq   8064c5 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  806351:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  806358:	be 01 01 00 00       	mov    $0x101,%esi
  80635d:	48 89 c7             	mov    %rax,%rdi
  806360:	48 b8 8a 5e 80 00 00 	movabs $0x805e8a,%rax
  806367:	00 00 00 
  80636a:	ff d0                	callq  *%rax
  80636c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80636f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  806373:	79 39                	jns    8063ae <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  806375:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806378:	89 c6                	mov    %eax,%esi
  80637a:	48 bf 8f 82 80 00 00 	movabs $0x80828f,%rdi
  806381:	00 00 00 
  806384:	b8 00 00 00 00       	mov    $0x0,%eax
  806389:	48 ba 71 37 80 00 00 	movabs $0x803771,%rdx
  806390:	00 00 00 
  806393:	ff d2                	callq  *%rdx
		close(fd_src);
  806395:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806398:	89 c7                	mov    %eax,%edi
  80639a:	48 b8 92 57 80 00 00 	movabs $0x805792,%rax
  8063a1:	00 00 00 
  8063a4:	ff d0                	callq  *%rax
		return fd_dest;
  8063a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8063a9:	e9 17 01 00 00       	jmpq   8064c5 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8063ae:	eb 74                	jmp    806424 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8063b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8063b3:	48 63 d0             	movslq %eax,%rdx
  8063b6:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8063bd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8063c0:	48 89 ce             	mov    %rcx,%rsi
  8063c3:	89 c7                	mov    %eax,%edi
  8063c5:	48 b8 fe 5a 80 00 00 	movabs $0x805afe,%rax
  8063cc:	00 00 00 
  8063cf:	ff d0                	callq  *%rax
  8063d1:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8063d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8063d8:	79 4a                	jns    806424 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8063da:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8063dd:	89 c6                	mov    %eax,%esi
  8063df:	48 bf a9 82 80 00 00 	movabs $0x8082a9,%rdi
  8063e6:	00 00 00 
  8063e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8063ee:	48 ba 71 37 80 00 00 	movabs $0x803771,%rdx
  8063f5:	00 00 00 
  8063f8:	ff d2                	callq  *%rdx
			close(fd_src);
  8063fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8063fd:	89 c7                	mov    %eax,%edi
  8063ff:	48 b8 92 57 80 00 00 	movabs $0x805792,%rax
  806406:	00 00 00 
  806409:	ff d0                	callq  *%rax
			close(fd_dest);
  80640b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80640e:	89 c7                	mov    %eax,%edi
  806410:	48 b8 92 57 80 00 00 	movabs $0x805792,%rax
  806417:	00 00 00 
  80641a:	ff d0                	callq  *%rax
			return write_size;
  80641c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80641f:	e9 a1 00 00 00       	jmpq   8064c5 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  806424:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80642b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80642e:	ba 00 02 00 00       	mov    $0x200,%edx
  806433:	48 89 ce             	mov    %rcx,%rsi
  806436:	89 c7                	mov    %eax,%edi
  806438:	48 b8 b4 59 80 00 00 	movabs $0x8059b4,%rax
  80643f:	00 00 00 
  806442:	ff d0                	callq  *%rax
  806444:	89 45 f4             	mov    %eax,-0xc(%rbp)
  806447:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80644b:	0f 8f 5f ff ff ff    	jg     8063b0 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  806451:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  806455:	79 47                	jns    80649e <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  806457:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80645a:	89 c6                	mov    %eax,%esi
  80645c:	48 bf bc 82 80 00 00 	movabs $0x8082bc,%rdi
  806463:	00 00 00 
  806466:	b8 00 00 00 00       	mov    $0x0,%eax
  80646b:	48 ba 71 37 80 00 00 	movabs $0x803771,%rdx
  806472:	00 00 00 
  806475:	ff d2                	callq  *%rdx
		close(fd_src);
  806477:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80647a:	89 c7                	mov    %eax,%edi
  80647c:	48 b8 92 57 80 00 00 	movabs $0x805792,%rax
  806483:	00 00 00 
  806486:	ff d0                	callq  *%rax
		close(fd_dest);
  806488:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80648b:	89 c7                	mov    %eax,%edi
  80648d:	48 b8 92 57 80 00 00 	movabs $0x805792,%rax
  806494:	00 00 00 
  806497:	ff d0                	callq  *%rax
		return read_size;
  806499:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80649c:	eb 27                	jmp    8064c5 <copy+0x1d9>
	}
	close(fd_src);
  80649e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8064a1:	89 c7                	mov    %eax,%edi
  8064a3:	48 b8 92 57 80 00 00 	movabs $0x805792,%rax
  8064aa:	00 00 00 
  8064ad:	ff d0                	callq  *%rax
	close(fd_dest);
  8064af:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8064b2:	89 c7                	mov    %eax,%edi
  8064b4:	48 b8 92 57 80 00 00 	movabs $0x805792,%rax
  8064bb:	00 00 00 
  8064be:	ff d0                	callq  *%rax
	return 0;
  8064c0:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8064c5:	c9                   	leaveq 
  8064c6:	c3                   	retq   

00000000008064c7 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  8064c7:	55                   	push   %rbp
  8064c8:	48 89 e5             	mov    %rsp,%rbp
  8064cb:	48 83 ec 18          	sub    $0x18,%rsp
  8064cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8064d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8064d7:	48 c1 e8 15          	shr    $0x15,%rax
  8064db:	48 89 c2             	mov    %rax,%rdx
  8064de:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8064e5:	01 00 00 
  8064e8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8064ec:	83 e0 01             	and    $0x1,%eax
  8064ef:	48 85 c0             	test   %rax,%rax
  8064f2:	75 07                	jne    8064fb <pageref+0x34>
		return 0;
  8064f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8064f9:	eb 53                	jmp    80654e <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8064fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8064ff:	48 c1 e8 0c          	shr    $0xc,%rax
  806503:	48 89 c2             	mov    %rax,%rdx
  806506:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80650d:	01 00 00 
  806510:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806514:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  806518:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80651c:	83 e0 01             	and    $0x1,%eax
  80651f:	48 85 c0             	test   %rax,%rax
  806522:	75 07                	jne    80652b <pageref+0x64>
		return 0;
  806524:	b8 00 00 00 00       	mov    $0x0,%eax
  806529:	eb 23                	jmp    80654e <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80652b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80652f:	48 c1 e8 0c          	shr    $0xc,%rax
  806533:	48 89 c2             	mov    %rax,%rdx
  806536:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80653d:	00 00 00 
  806540:	48 c1 e2 04          	shl    $0x4,%rdx
  806544:	48 01 d0             	add    %rdx,%rax
  806547:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80654b:	0f b7 c0             	movzwl %ax,%eax
}
  80654e:	c9                   	leaveq 
  80654f:	c3                   	retq   

0000000000806550 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  806550:	55                   	push   %rbp
  806551:	48 89 e5             	mov    %rsp,%rbp
  806554:	48 83 ec 20          	sub    $0x20,%rsp
  806558:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80655b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80655f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806562:	48 89 d6             	mov    %rdx,%rsi
  806565:	89 c7                	mov    %eax,%edi
  806567:	48 b8 82 55 80 00 00 	movabs $0x805582,%rax
  80656e:	00 00 00 
  806571:	ff d0                	callq  *%rax
  806573:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806576:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80657a:	79 05                	jns    806581 <fd2sockid+0x31>
		return r;
  80657c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80657f:	eb 24                	jmp    8065a5 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  806581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806585:	8b 10                	mov    (%rax),%edx
  806587:	48 b8 20 21 81 00 00 	movabs $0x812120,%rax
  80658e:	00 00 00 
  806591:	8b 00                	mov    (%rax),%eax
  806593:	39 c2                	cmp    %eax,%edx
  806595:	74 07                	je     80659e <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  806597:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80659c:	eb 07                	jmp    8065a5 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80659e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8065a2:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8065a5:	c9                   	leaveq 
  8065a6:	c3                   	retq   

00000000008065a7 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8065a7:	55                   	push   %rbp
  8065a8:	48 89 e5             	mov    %rsp,%rbp
  8065ab:	48 83 ec 20          	sub    $0x20,%rsp
  8065af:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8065b2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8065b6:	48 89 c7             	mov    %rax,%rdi
  8065b9:	48 b8 ea 54 80 00 00 	movabs $0x8054ea,%rax
  8065c0:	00 00 00 
  8065c3:	ff d0                	callq  *%rax
  8065c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8065c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8065cc:	78 26                	js     8065f4 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8065ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8065d2:	ba 07 04 00 00       	mov    $0x407,%edx
  8065d7:	48 89 c6             	mov    %rax,%rsi
  8065da:	bf 00 00 00 00       	mov    $0x0,%edi
  8065df:	48 b8 55 4c 80 00 00 	movabs $0x804c55,%rax
  8065e6:	00 00 00 
  8065e9:	ff d0                	callq  *%rax
  8065eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8065ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8065f2:	79 16                	jns    80660a <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8065f4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8065f7:	89 c7                	mov    %eax,%edi
  8065f9:	48 b8 b4 6a 80 00 00 	movabs $0x806ab4,%rax
  806600:	00 00 00 
  806603:	ff d0                	callq  *%rax
		return r;
  806605:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806608:	eb 3a                	jmp    806644 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80660a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80660e:	48 ba 20 21 81 00 00 	movabs $0x812120,%rdx
  806615:	00 00 00 
  806618:	8b 12                	mov    (%rdx),%edx
  80661a:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80661c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806620:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  806627:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80662b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80662e:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  806631:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806635:	48 89 c7             	mov    %rax,%rdi
  806638:	48 b8 9c 54 80 00 00 	movabs $0x80549c,%rax
  80663f:	00 00 00 
  806642:	ff d0                	callq  *%rax
}
  806644:	c9                   	leaveq 
  806645:	c3                   	retq   

0000000000806646 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  806646:	55                   	push   %rbp
  806647:	48 89 e5             	mov    %rsp,%rbp
  80664a:	48 83 ec 30          	sub    $0x30,%rsp
  80664e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806651:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806655:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  806659:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80665c:	89 c7                	mov    %eax,%edi
  80665e:	48 b8 50 65 80 00 00 	movabs $0x806550,%rax
  806665:	00 00 00 
  806668:	ff d0                	callq  *%rax
  80666a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80666d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806671:	79 05                	jns    806678 <accept+0x32>
		return r;
  806673:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806676:	eb 3b                	jmp    8066b3 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  806678:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80667c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  806680:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806683:	48 89 ce             	mov    %rcx,%rsi
  806686:	89 c7                	mov    %eax,%edi
  806688:	48 b8 91 69 80 00 00 	movabs $0x806991,%rax
  80668f:	00 00 00 
  806692:	ff d0                	callq  *%rax
  806694:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806697:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80669b:	79 05                	jns    8066a2 <accept+0x5c>
		return r;
  80669d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8066a0:	eb 11                	jmp    8066b3 <accept+0x6d>
	return alloc_sockfd(r);
  8066a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8066a5:	89 c7                	mov    %eax,%edi
  8066a7:	48 b8 a7 65 80 00 00 	movabs $0x8065a7,%rax
  8066ae:	00 00 00 
  8066b1:	ff d0                	callq  *%rax
}
  8066b3:	c9                   	leaveq 
  8066b4:	c3                   	retq   

00000000008066b5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8066b5:	55                   	push   %rbp
  8066b6:	48 89 e5             	mov    %rsp,%rbp
  8066b9:	48 83 ec 20          	sub    $0x20,%rsp
  8066bd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8066c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8066c4:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8066c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8066ca:	89 c7                	mov    %eax,%edi
  8066cc:	48 b8 50 65 80 00 00 	movabs $0x806550,%rax
  8066d3:	00 00 00 
  8066d6:	ff d0                	callq  *%rax
  8066d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8066db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8066df:	79 05                	jns    8066e6 <bind+0x31>
		return r;
  8066e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8066e4:	eb 1b                	jmp    806701 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8066e6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8066e9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8066ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8066f0:	48 89 ce             	mov    %rcx,%rsi
  8066f3:	89 c7                	mov    %eax,%edi
  8066f5:	48 b8 10 6a 80 00 00 	movabs $0x806a10,%rax
  8066fc:	00 00 00 
  8066ff:	ff d0                	callq  *%rax
}
  806701:	c9                   	leaveq 
  806702:	c3                   	retq   

0000000000806703 <shutdown>:

int
shutdown(int s, int how)
{
  806703:	55                   	push   %rbp
  806704:	48 89 e5             	mov    %rsp,%rbp
  806707:	48 83 ec 20          	sub    $0x20,%rsp
  80670b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80670e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  806711:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806714:	89 c7                	mov    %eax,%edi
  806716:	48 b8 50 65 80 00 00 	movabs $0x806550,%rax
  80671d:	00 00 00 
  806720:	ff d0                	callq  *%rax
  806722:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806725:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806729:	79 05                	jns    806730 <shutdown+0x2d>
		return r;
  80672b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80672e:	eb 16                	jmp    806746 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  806730:	8b 55 e8             	mov    -0x18(%rbp),%edx
  806733:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806736:	89 d6                	mov    %edx,%esi
  806738:	89 c7                	mov    %eax,%edi
  80673a:	48 b8 74 6a 80 00 00 	movabs $0x806a74,%rax
  806741:	00 00 00 
  806744:	ff d0                	callq  *%rax
}
  806746:	c9                   	leaveq 
  806747:	c3                   	retq   

0000000000806748 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  806748:	55                   	push   %rbp
  806749:	48 89 e5             	mov    %rsp,%rbp
  80674c:	48 83 ec 10          	sub    $0x10,%rsp
  806750:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  806754:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806758:	48 89 c7             	mov    %rax,%rdi
  80675b:	48 b8 c7 64 80 00 00 	movabs $0x8064c7,%rax
  806762:	00 00 00 
  806765:	ff d0                	callq  *%rax
  806767:	83 f8 01             	cmp    $0x1,%eax
  80676a:	75 17                	jne    806783 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80676c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806770:	8b 40 0c             	mov    0xc(%rax),%eax
  806773:	89 c7                	mov    %eax,%edi
  806775:	48 b8 b4 6a 80 00 00 	movabs $0x806ab4,%rax
  80677c:	00 00 00 
  80677f:	ff d0                	callq  *%rax
  806781:	eb 05                	jmp    806788 <devsock_close+0x40>
	else
		return 0;
  806783:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806788:	c9                   	leaveq 
  806789:	c3                   	retq   

000000000080678a <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80678a:	55                   	push   %rbp
  80678b:	48 89 e5             	mov    %rsp,%rbp
  80678e:	48 83 ec 20          	sub    $0x20,%rsp
  806792:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806795:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806799:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80679c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80679f:	89 c7                	mov    %eax,%edi
  8067a1:	48 b8 50 65 80 00 00 	movabs $0x806550,%rax
  8067a8:	00 00 00 
  8067ab:	ff d0                	callq  *%rax
  8067ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8067b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8067b4:	79 05                	jns    8067bb <connect+0x31>
		return r;
  8067b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8067b9:	eb 1b                	jmp    8067d6 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8067bb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8067be:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8067c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8067c5:	48 89 ce             	mov    %rcx,%rsi
  8067c8:	89 c7                	mov    %eax,%edi
  8067ca:	48 b8 e1 6a 80 00 00 	movabs $0x806ae1,%rax
  8067d1:	00 00 00 
  8067d4:	ff d0                	callq  *%rax
}
  8067d6:	c9                   	leaveq 
  8067d7:	c3                   	retq   

00000000008067d8 <listen>:

int
listen(int s, int backlog)
{
  8067d8:	55                   	push   %rbp
  8067d9:	48 89 e5             	mov    %rsp,%rbp
  8067dc:	48 83 ec 20          	sub    $0x20,%rsp
  8067e0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8067e3:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8067e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8067e9:	89 c7                	mov    %eax,%edi
  8067eb:	48 b8 50 65 80 00 00 	movabs $0x806550,%rax
  8067f2:	00 00 00 
  8067f5:	ff d0                	callq  *%rax
  8067f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8067fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8067fe:	79 05                	jns    806805 <listen+0x2d>
		return r;
  806800:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806803:	eb 16                	jmp    80681b <listen+0x43>
	return nsipc_listen(r, backlog);
  806805:	8b 55 e8             	mov    -0x18(%rbp),%edx
  806808:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80680b:	89 d6                	mov    %edx,%esi
  80680d:	89 c7                	mov    %eax,%edi
  80680f:	48 b8 45 6b 80 00 00 	movabs $0x806b45,%rax
  806816:	00 00 00 
  806819:	ff d0                	callq  *%rax
}
  80681b:	c9                   	leaveq 
  80681c:	c3                   	retq   

000000000080681d <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80681d:	55                   	push   %rbp
  80681e:	48 89 e5             	mov    %rsp,%rbp
  806821:	48 83 ec 20          	sub    $0x20,%rsp
  806825:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  806829:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80682d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  806831:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806835:	89 c2                	mov    %eax,%edx
  806837:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80683b:	8b 40 0c             	mov    0xc(%rax),%eax
  80683e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  806842:	b9 00 00 00 00       	mov    $0x0,%ecx
  806847:	89 c7                	mov    %eax,%edi
  806849:	48 b8 85 6b 80 00 00 	movabs $0x806b85,%rax
  806850:	00 00 00 
  806853:	ff d0                	callq  *%rax
}
  806855:	c9                   	leaveq 
  806856:	c3                   	retq   

0000000000806857 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  806857:	55                   	push   %rbp
  806858:	48 89 e5             	mov    %rsp,%rbp
  80685b:	48 83 ec 20          	sub    $0x20,%rsp
  80685f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  806863:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  806867:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80686b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80686f:	89 c2                	mov    %eax,%edx
  806871:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806875:	8b 40 0c             	mov    0xc(%rax),%eax
  806878:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80687c:	b9 00 00 00 00       	mov    $0x0,%ecx
  806881:	89 c7                	mov    %eax,%edi
  806883:	48 b8 51 6c 80 00 00 	movabs $0x806c51,%rax
  80688a:	00 00 00 
  80688d:	ff d0                	callq  *%rax
}
  80688f:	c9                   	leaveq 
  806890:	c3                   	retq   

0000000000806891 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  806891:	55                   	push   %rbp
  806892:	48 89 e5             	mov    %rsp,%rbp
  806895:	48 83 ec 10          	sub    $0x10,%rsp
  806899:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80689d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8068a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8068a5:	48 be d7 82 80 00 00 	movabs $0x8082d7,%rsi
  8068ac:	00 00 00 
  8068af:	48 89 c7             	mov    %rax,%rdi
  8068b2:	48 b8 26 43 80 00 00 	movabs $0x804326,%rax
  8068b9:	00 00 00 
  8068bc:	ff d0                	callq  *%rax
	return 0;
  8068be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8068c3:	c9                   	leaveq 
  8068c4:	c3                   	retq   

00000000008068c5 <socket>:

int
socket(int domain, int type, int protocol)
{
  8068c5:	55                   	push   %rbp
  8068c6:	48 89 e5             	mov    %rsp,%rbp
  8068c9:	48 83 ec 20          	sub    $0x20,%rsp
  8068cd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8068d0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8068d3:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8068d6:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8068d9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8068dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8068df:	89 ce                	mov    %ecx,%esi
  8068e1:	89 c7                	mov    %eax,%edi
  8068e3:	48 b8 09 6d 80 00 00 	movabs $0x806d09,%rax
  8068ea:	00 00 00 
  8068ed:	ff d0                	callq  *%rax
  8068ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8068f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8068f6:	79 05                	jns    8068fd <socket+0x38>
		return r;
  8068f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8068fb:	eb 11                	jmp    80690e <socket+0x49>
	return alloc_sockfd(r);
  8068fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806900:	89 c7                	mov    %eax,%edi
  806902:	48 b8 a7 65 80 00 00 	movabs $0x8065a7,%rax
  806909:	00 00 00 
  80690c:	ff d0                	callq  *%rax
}
  80690e:	c9                   	leaveq 
  80690f:	c3                   	retq   

0000000000806910 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  806910:	55                   	push   %rbp
  806911:	48 89 e5             	mov    %rsp,%rbp
  806914:	48 83 ec 10          	sub    $0x10,%rsp
  806918:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80691b:	48 b8 0c 60 81 00 00 	movabs $0x81600c,%rax
  806922:	00 00 00 
  806925:	8b 00                	mov    (%rax),%eax
  806927:	85 c0                	test   %eax,%eax
  806929:	75 1d                	jne    806948 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80692b:	bf 02 00 00 00       	mov    $0x2,%edi
  806930:	48 b8 2a 54 80 00 00 	movabs $0x80542a,%rax
  806937:	00 00 00 
  80693a:	ff d0                	callq  *%rax
  80693c:	48 ba 0c 60 81 00 00 	movabs $0x81600c,%rdx
  806943:	00 00 00 
  806946:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  806948:	48 b8 0c 60 81 00 00 	movabs $0x81600c,%rax
  80694f:	00 00 00 
  806952:	8b 00                	mov    (%rax),%eax
  806954:	8b 75 fc             	mov    -0x4(%rbp),%esi
  806957:	b9 07 00 00 00       	mov    $0x7,%ecx
  80695c:	48 ba 00 90 81 00 00 	movabs $0x819000,%rdx
  806963:	00 00 00 
  806966:	89 c7                	mov    %eax,%edi
  806968:	48 b8 1e 52 80 00 00 	movabs $0x80521e,%rax
  80696f:	00 00 00 
  806972:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  806974:	ba 00 00 00 00       	mov    $0x0,%edx
  806979:	be 00 00 00 00       	mov    $0x0,%esi
  80697e:	bf 00 00 00 00       	mov    $0x0,%edi
  806983:	48 b8 5d 51 80 00 00 	movabs $0x80515d,%rax
  80698a:	00 00 00 
  80698d:	ff d0                	callq  *%rax
}
  80698f:	c9                   	leaveq 
  806990:	c3                   	retq   

0000000000806991 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  806991:	55                   	push   %rbp
  806992:	48 89 e5             	mov    %rsp,%rbp
  806995:	48 83 ec 30          	sub    $0x30,%rsp
  806999:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80699c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8069a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8069a4:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  8069ab:	00 00 00 
  8069ae:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8069b1:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8069b3:	bf 01 00 00 00       	mov    $0x1,%edi
  8069b8:	48 b8 10 69 80 00 00 	movabs $0x806910,%rax
  8069bf:	00 00 00 
  8069c2:	ff d0                	callq  *%rax
  8069c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8069c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8069cb:	78 3e                	js     806a0b <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8069cd:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  8069d4:	00 00 00 
  8069d7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8069db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8069df:	8b 40 10             	mov    0x10(%rax),%eax
  8069e2:	89 c2                	mov    %eax,%edx
  8069e4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8069e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8069ec:	48 89 ce             	mov    %rcx,%rsi
  8069ef:	48 89 c7             	mov    %rax,%rdi
  8069f2:	48 b8 4a 46 80 00 00 	movabs $0x80464a,%rax
  8069f9:	00 00 00 
  8069fc:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8069fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806a02:	8b 50 10             	mov    0x10(%rax),%edx
  806a05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806a09:	89 10                	mov    %edx,(%rax)
	}
	return r;
  806a0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  806a0e:	c9                   	leaveq 
  806a0f:	c3                   	retq   

0000000000806a10 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  806a10:	55                   	push   %rbp
  806a11:	48 89 e5             	mov    %rsp,%rbp
  806a14:	48 83 ec 10          	sub    $0x10,%rsp
  806a18:	89 7d fc             	mov    %edi,-0x4(%rbp)
  806a1b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  806a1f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  806a22:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806a29:	00 00 00 
  806a2c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806a2f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  806a31:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806a34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806a38:	48 89 c6             	mov    %rax,%rsi
  806a3b:	48 bf 04 90 81 00 00 	movabs $0x819004,%rdi
  806a42:	00 00 00 
  806a45:	48 b8 4a 46 80 00 00 	movabs $0x80464a,%rax
  806a4c:	00 00 00 
  806a4f:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  806a51:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806a58:	00 00 00 
  806a5b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806a5e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  806a61:	bf 02 00 00 00       	mov    $0x2,%edi
  806a66:	48 b8 10 69 80 00 00 	movabs $0x806910,%rax
  806a6d:	00 00 00 
  806a70:	ff d0                	callq  *%rax
}
  806a72:	c9                   	leaveq 
  806a73:	c3                   	retq   

0000000000806a74 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  806a74:	55                   	push   %rbp
  806a75:	48 89 e5             	mov    %rsp,%rbp
  806a78:	48 83 ec 10          	sub    $0x10,%rsp
  806a7c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  806a7f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  806a82:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806a89:	00 00 00 
  806a8c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806a8f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  806a91:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806a98:	00 00 00 
  806a9b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806a9e:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  806aa1:	bf 03 00 00 00       	mov    $0x3,%edi
  806aa6:	48 b8 10 69 80 00 00 	movabs $0x806910,%rax
  806aad:	00 00 00 
  806ab0:	ff d0                	callq  *%rax
}
  806ab2:	c9                   	leaveq 
  806ab3:	c3                   	retq   

0000000000806ab4 <nsipc_close>:

int
nsipc_close(int s)
{
  806ab4:	55                   	push   %rbp
  806ab5:	48 89 e5             	mov    %rsp,%rbp
  806ab8:	48 83 ec 10          	sub    $0x10,%rsp
  806abc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  806abf:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806ac6:	00 00 00 
  806ac9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806acc:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  806ace:	bf 04 00 00 00       	mov    $0x4,%edi
  806ad3:	48 b8 10 69 80 00 00 	movabs $0x806910,%rax
  806ada:	00 00 00 
  806add:	ff d0                	callq  *%rax
}
  806adf:	c9                   	leaveq 
  806ae0:	c3                   	retq   

0000000000806ae1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  806ae1:	55                   	push   %rbp
  806ae2:	48 89 e5             	mov    %rsp,%rbp
  806ae5:	48 83 ec 10          	sub    $0x10,%rsp
  806ae9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  806aec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  806af0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  806af3:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806afa:	00 00 00 
  806afd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806b00:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  806b02:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806b05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806b09:	48 89 c6             	mov    %rax,%rsi
  806b0c:	48 bf 04 90 81 00 00 	movabs $0x819004,%rdi
  806b13:	00 00 00 
  806b16:	48 b8 4a 46 80 00 00 	movabs $0x80464a,%rax
  806b1d:	00 00 00 
  806b20:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  806b22:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806b29:	00 00 00 
  806b2c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806b2f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  806b32:	bf 05 00 00 00       	mov    $0x5,%edi
  806b37:	48 b8 10 69 80 00 00 	movabs $0x806910,%rax
  806b3e:	00 00 00 
  806b41:	ff d0                	callq  *%rax
}
  806b43:	c9                   	leaveq 
  806b44:	c3                   	retq   

0000000000806b45 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  806b45:	55                   	push   %rbp
  806b46:	48 89 e5             	mov    %rsp,%rbp
  806b49:	48 83 ec 10          	sub    $0x10,%rsp
  806b4d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  806b50:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  806b53:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806b5a:	00 00 00 
  806b5d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806b60:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  806b62:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806b69:	00 00 00 
  806b6c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806b6f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  806b72:	bf 06 00 00 00       	mov    $0x6,%edi
  806b77:	48 b8 10 69 80 00 00 	movabs $0x806910,%rax
  806b7e:	00 00 00 
  806b81:	ff d0                	callq  *%rax
}
  806b83:	c9                   	leaveq 
  806b84:	c3                   	retq   

0000000000806b85 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  806b85:	55                   	push   %rbp
  806b86:	48 89 e5             	mov    %rsp,%rbp
  806b89:	48 83 ec 30          	sub    $0x30,%rsp
  806b8d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806b90:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806b94:	89 55 e8             	mov    %edx,-0x18(%rbp)
  806b97:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  806b9a:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806ba1:	00 00 00 
  806ba4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  806ba7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  806ba9:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806bb0:	00 00 00 
  806bb3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  806bb6:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  806bb9:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806bc0:	00 00 00 
  806bc3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  806bc6:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  806bc9:	bf 07 00 00 00       	mov    $0x7,%edi
  806bce:	48 b8 10 69 80 00 00 	movabs $0x806910,%rax
  806bd5:	00 00 00 
  806bd8:	ff d0                	callq  *%rax
  806bda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806bdd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806be1:	78 69                	js     806c4c <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  806be3:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  806bea:	7f 08                	jg     806bf4 <nsipc_recv+0x6f>
  806bec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806bef:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  806bf2:	7e 35                	jle    806c29 <nsipc_recv+0xa4>
  806bf4:	48 b9 de 82 80 00 00 	movabs $0x8082de,%rcx
  806bfb:	00 00 00 
  806bfe:	48 ba f3 82 80 00 00 	movabs $0x8082f3,%rdx
  806c05:	00 00 00 
  806c08:	be 62 00 00 00       	mov    $0x62,%esi
  806c0d:	48 bf 08 83 80 00 00 	movabs $0x808308,%rdi
  806c14:	00 00 00 
  806c17:	b8 00 00 00 00       	mov    $0x0,%eax
  806c1c:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  806c23:	00 00 00 
  806c26:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  806c29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806c2c:	48 63 d0             	movslq %eax,%rdx
  806c2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806c33:	48 be 00 90 81 00 00 	movabs $0x819000,%rsi
  806c3a:	00 00 00 
  806c3d:	48 89 c7             	mov    %rax,%rdi
  806c40:	48 b8 4a 46 80 00 00 	movabs $0x80464a,%rax
  806c47:	00 00 00 
  806c4a:	ff d0                	callq  *%rax
	}

	return r;
  806c4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  806c4f:	c9                   	leaveq 
  806c50:	c3                   	retq   

0000000000806c51 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  806c51:	55                   	push   %rbp
  806c52:	48 89 e5             	mov    %rsp,%rbp
  806c55:	48 83 ec 20          	sub    $0x20,%rsp
  806c59:	89 7d fc             	mov    %edi,-0x4(%rbp)
  806c5c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  806c60:	89 55 f8             	mov    %edx,-0x8(%rbp)
  806c63:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  806c66:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806c6d:	00 00 00 
  806c70:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806c73:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  806c75:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  806c7c:	7e 35                	jle    806cb3 <nsipc_send+0x62>
  806c7e:	48 b9 14 83 80 00 00 	movabs $0x808314,%rcx
  806c85:	00 00 00 
  806c88:	48 ba f3 82 80 00 00 	movabs $0x8082f3,%rdx
  806c8f:	00 00 00 
  806c92:	be 6d 00 00 00       	mov    $0x6d,%esi
  806c97:	48 bf 08 83 80 00 00 	movabs $0x808308,%rdi
  806c9e:	00 00 00 
  806ca1:	b8 00 00 00 00       	mov    $0x0,%eax
  806ca6:	49 b8 38 35 80 00 00 	movabs $0x803538,%r8
  806cad:	00 00 00 
  806cb0:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  806cb3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806cb6:	48 63 d0             	movslq %eax,%rdx
  806cb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806cbd:	48 89 c6             	mov    %rax,%rsi
  806cc0:	48 bf 0c 90 81 00 00 	movabs $0x81900c,%rdi
  806cc7:	00 00 00 
  806cca:	48 b8 4a 46 80 00 00 	movabs $0x80464a,%rax
  806cd1:	00 00 00 
  806cd4:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  806cd6:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806cdd:	00 00 00 
  806ce0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806ce3:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  806ce6:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806ced:	00 00 00 
  806cf0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  806cf3:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  806cf6:	bf 08 00 00 00       	mov    $0x8,%edi
  806cfb:	48 b8 10 69 80 00 00 	movabs $0x806910,%rax
  806d02:	00 00 00 
  806d05:	ff d0                	callq  *%rax
}
  806d07:	c9                   	leaveq 
  806d08:	c3                   	retq   

0000000000806d09 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  806d09:	55                   	push   %rbp
  806d0a:	48 89 e5             	mov    %rsp,%rbp
  806d0d:	48 83 ec 10          	sub    $0x10,%rsp
  806d11:	89 7d fc             	mov    %edi,-0x4(%rbp)
  806d14:	89 75 f8             	mov    %esi,-0x8(%rbp)
  806d17:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  806d1a:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806d21:	00 00 00 
  806d24:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806d27:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  806d29:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806d30:	00 00 00 
  806d33:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806d36:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  806d39:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806d40:	00 00 00 
  806d43:	8b 55 f4             	mov    -0xc(%rbp),%edx
  806d46:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  806d49:	bf 09 00 00 00       	mov    $0x9,%edi
  806d4e:	48 b8 10 69 80 00 00 	movabs $0x806910,%rax
  806d55:	00 00 00 
  806d58:	ff d0                	callq  *%rax
}
  806d5a:	c9                   	leaveq 
  806d5b:	c3                   	retq   

0000000000806d5c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  806d5c:	55                   	push   %rbp
  806d5d:	48 89 e5             	mov    %rsp,%rbp
  806d60:	53                   	push   %rbx
  806d61:	48 83 ec 38          	sub    $0x38,%rsp
  806d65:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  806d69:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  806d6d:	48 89 c7             	mov    %rax,%rdi
  806d70:	48 b8 ea 54 80 00 00 	movabs $0x8054ea,%rax
  806d77:	00 00 00 
  806d7a:	ff d0                	callq  *%rax
  806d7c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806d7f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806d83:	0f 88 bf 01 00 00    	js     806f48 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806d89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806d8d:	ba 07 04 00 00       	mov    $0x407,%edx
  806d92:	48 89 c6             	mov    %rax,%rsi
  806d95:	bf 00 00 00 00       	mov    $0x0,%edi
  806d9a:	48 b8 55 4c 80 00 00 	movabs $0x804c55,%rax
  806da1:	00 00 00 
  806da4:	ff d0                	callq  *%rax
  806da6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806da9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806dad:	0f 88 95 01 00 00    	js     806f48 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  806db3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  806db7:	48 89 c7             	mov    %rax,%rdi
  806dba:	48 b8 ea 54 80 00 00 	movabs $0x8054ea,%rax
  806dc1:	00 00 00 
  806dc4:	ff d0                	callq  *%rax
  806dc6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806dc9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806dcd:	0f 88 5d 01 00 00    	js     806f30 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806dd3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806dd7:	ba 07 04 00 00       	mov    $0x407,%edx
  806ddc:	48 89 c6             	mov    %rax,%rsi
  806ddf:	bf 00 00 00 00       	mov    $0x0,%edi
  806de4:	48 b8 55 4c 80 00 00 	movabs $0x804c55,%rax
  806deb:	00 00 00 
  806dee:	ff d0                	callq  *%rax
  806df0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806df3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806df7:	0f 88 33 01 00 00    	js     806f30 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  806dfd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806e01:	48 89 c7             	mov    %rax,%rdi
  806e04:	48 b8 bf 54 80 00 00 	movabs $0x8054bf,%rax
  806e0b:	00 00 00 
  806e0e:	ff d0                	callq  *%rax
  806e10:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806e14:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806e18:	ba 07 04 00 00       	mov    $0x407,%edx
  806e1d:	48 89 c6             	mov    %rax,%rsi
  806e20:	bf 00 00 00 00       	mov    $0x0,%edi
  806e25:	48 b8 55 4c 80 00 00 	movabs $0x804c55,%rax
  806e2c:	00 00 00 
  806e2f:	ff d0                	callq  *%rax
  806e31:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806e34:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806e38:	79 05                	jns    806e3f <pipe+0xe3>
		goto err2;
  806e3a:	e9 d9 00 00 00       	jmpq   806f18 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806e3f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806e43:	48 89 c7             	mov    %rax,%rdi
  806e46:	48 b8 bf 54 80 00 00 	movabs $0x8054bf,%rax
  806e4d:	00 00 00 
  806e50:	ff d0                	callq  *%rax
  806e52:	48 89 c2             	mov    %rax,%rdx
  806e55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806e59:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  806e5f:	48 89 d1             	mov    %rdx,%rcx
  806e62:	ba 00 00 00 00       	mov    $0x0,%edx
  806e67:	48 89 c6             	mov    %rax,%rsi
  806e6a:	bf 00 00 00 00       	mov    $0x0,%edi
  806e6f:	48 b8 a5 4c 80 00 00 	movabs $0x804ca5,%rax
  806e76:	00 00 00 
  806e79:	ff d0                	callq  *%rax
  806e7b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806e7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806e82:	79 1b                	jns    806e9f <pipe+0x143>
		goto err3;
  806e84:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  806e85:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806e89:	48 89 c6             	mov    %rax,%rsi
  806e8c:	bf 00 00 00 00       	mov    $0x0,%edi
  806e91:	48 b8 00 4d 80 00 00 	movabs $0x804d00,%rax
  806e98:	00 00 00 
  806e9b:	ff d0                	callq  *%rax
  806e9d:	eb 79                	jmp    806f18 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  806e9f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806ea3:	48 ba 60 21 81 00 00 	movabs $0x812160,%rdx
  806eaa:	00 00 00 
  806ead:	8b 12                	mov    (%rdx),%edx
  806eaf:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  806eb1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806eb5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  806ebc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806ec0:	48 ba 60 21 81 00 00 	movabs $0x812160,%rdx
  806ec7:	00 00 00 
  806eca:	8b 12                	mov    (%rdx),%edx
  806ecc:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  806ece:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806ed2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  806ed9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806edd:	48 89 c7             	mov    %rax,%rdi
  806ee0:	48 b8 9c 54 80 00 00 	movabs $0x80549c,%rax
  806ee7:	00 00 00 
  806eea:	ff d0                	callq  *%rax
  806eec:	89 c2                	mov    %eax,%edx
  806eee:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  806ef2:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  806ef4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  806ef8:	48 8d 58 04          	lea    0x4(%rax),%rbx
  806efc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806f00:	48 89 c7             	mov    %rax,%rdi
  806f03:	48 b8 9c 54 80 00 00 	movabs $0x80549c,%rax
  806f0a:	00 00 00 
  806f0d:	ff d0                	callq  *%rax
  806f0f:	89 03                	mov    %eax,(%rbx)
	return 0;
  806f11:	b8 00 00 00 00       	mov    $0x0,%eax
  806f16:	eb 33                	jmp    806f4b <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  806f18:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806f1c:	48 89 c6             	mov    %rax,%rsi
  806f1f:	bf 00 00 00 00       	mov    $0x0,%edi
  806f24:	48 b8 00 4d 80 00 00 	movabs $0x804d00,%rax
  806f2b:	00 00 00 
  806f2e:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  806f30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806f34:	48 89 c6             	mov    %rax,%rsi
  806f37:	bf 00 00 00 00       	mov    $0x0,%edi
  806f3c:	48 b8 00 4d 80 00 00 	movabs $0x804d00,%rax
  806f43:	00 00 00 
  806f46:	ff d0                	callq  *%rax
err:
	return r;
  806f48:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  806f4b:	48 83 c4 38          	add    $0x38,%rsp
  806f4f:	5b                   	pop    %rbx
  806f50:	5d                   	pop    %rbp
  806f51:	c3                   	retq   

0000000000806f52 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  806f52:	55                   	push   %rbp
  806f53:	48 89 e5             	mov    %rsp,%rbp
  806f56:	53                   	push   %rbx
  806f57:	48 83 ec 28          	sub    $0x28,%rsp
  806f5b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  806f5f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  806f63:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  806f6a:	00 00 00 
  806f6d:	48 8b 00             	mov    (%rax),%rax
  806f70:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  806f76:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  806f79:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806f7d:	48 89 c7             	mov    %rax,%rdi
  806f80:	48 b8 c7 64 80 00 00 	movabs $0x8064c7,%rax
  806f87:	00 00 00 
  806f8a:	ff d0                	callq  *%rax
  806f8c:	89 c3                	mov    %eax,%ebx
  806f8e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806f92:	48 89 c7             	mov    %rax,%rdi
  806f95:	48 b8 c7 64 80 00 00 	movabs $0x8064c7,%rax
  806f9c:	00 00 00 
  806f9f:	ff d0                	callq  *%rax
  806fa1:	39 c3                	cmp    %eax,%ebx
  806fa3:	0f 94 c0             	sete   %al
  806fa6:	0f b6 c0             	movzbl %al,%eax
  806fa9:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  806fac:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  806fb3:	00 00 00 
  806fb6:	48 8b 00             	mov    (%rax),%rax
  806fb9:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  806fbf:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  806fc2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806fc5:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806fc8:	75 05                	jne    806fcf <_pipeisclosed+0x7d>
			return ret;
  806fca:	8b 45 e8             	mov    -0x18(%rbp),%eax
  806fcd:	eb 4f                	jmp    80701e <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  806fcf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806fd2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806fd5:	74 42                	je     807019 <_pipeisclosed+0xc7>
  806fd7:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  806fdb:	75 3c                	jne    807019 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  806fdd:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  806fe4:	00 00 00 
  806fe7:	48 8b 00             	mov    (%rax),%rax
  806fea:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  806ff0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  806ff3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806ff6:	89 c6                	mov    %eax,%esi
  806ff8:	48 bf 25 83 80 00 00 	movabs $0x808325,%rdi
  806fff:	00 00 00 
  807002:	b8 00 00 00 00       	mov    $0x0,%eax
  807007:	49 b8 71 37 80 00 00 	movabs $0x803771,%r8
  80700e:	00 00 00 
  807011:	41 ff d0             	callq  *%r8
	}
  807014:	e9 4a ff ff ff       	jmpq   806f63 <_pipeisclosed+0x11>
  807019:	e9 45 ff ff ff       	jmpq   806f63 <_pipeisclosed+0x11>

}
  80701e:	48 83 c4 28          	add    $0x28,%rsp
  807022:	5b                   	pop    %rbx
  807023:	5d                   	pop    %rbp
  807024:	c3                   	retq   

0000000000807025 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  807025:	55                   	push   %rbp
  807026:	48 89 e5             	mov    %rsp,%rbp
  807029:	48 83 ec 30          	sub    $0x30,%rsp
  80702d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  807030:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  807034:	8b 45 dc             	mov    -0x24(%rbp),%eax
  807037:	48 89 d6             	mov    %rdx,%rsi
  80703a:	89 c7                	mov    %eax,%edi
  80703c:	48 b8 82 55 80 00 00 	movabs $0x805582,%rax
  807043:	00 00 00 
  807046:	ff d0                	callq  *%rax
  807048:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80704b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80704f:	79 05                	jns    807056 <pipeisclosed+0x31>
		return r;
  807051:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807054:	eb 31                	jmp    807087 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  807056:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80705a:	48 89 c7             	mov    %rax,%rdi
  80705d:	48 b8 bf 54 80 00 00 	movabs $0x8054bf,%rax
  807064:	00 00 00 
  807067:	ff d0                	callq  *%rax
  807069:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80706d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  807071:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  807075:	48 89 d6             	mov    %rdx,%rsi
  807078:	48 89 c7             	mov    %rax,%rdi
  80707b:	48 b8 52 6f 80 00 00 	movabs $0x806f52,%rax
  807082:	00 00 00 
  807085:	ff d0                	callq  *%rax
}
  807087:	c9                   	leaveq 
  807088:	c3                   	retq   

0000000000807089 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  807089:	55                   	push   %rbp
  80708a:	48 89 e5             	mov    %rsp,%rbp
  80708d:	48 83 ec 40          	sub    $0x40,%rsp
  807091:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  807095:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  807099:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80709d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8070a1:	48 89 c7             	mov    %rax,%rdi
  8070a4:	48 b8 bf 54 80 00 00 	movabs $0x8054bf,%rax
  8070ab:	00 00 00 
  8070ae:	ff d0                	callq  *%rax
  8070b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8070b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8070b8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8070bc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8070c3:	00 
  8070c4:	e9 92 00 00 00       	jmpq   80715b <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8070c9:	eb 41                	jmp    80710c <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8070cb:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8070d0:	74 09                	je     8070db <devpipe_read+0x52>
				return i;
  8070d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8070d6:	e9 92 00 00 00       	jmpq   80716d <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8070db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8070df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8070e3:	48 89 d6             	mov    %rdx,%rsi
  8070e6:	48 89 c7             	mov    %rax,%rdi
  8070e9:	48 b8 52 6f 80 00 00 	movabs $0x806f52,%rax
  8070f0:	00 00 00 
  8070f3:	ff d0                	callq  *%rax
  8070f5:	85 c0                	test   %eax,%eax
  8070f7:	74 07                	je     807100 <devpipe_read+0x77>
				return 0;
  8070f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8070fe:	eb 6d                	jmp    80716d <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  807100:	48 b8 17 4c 80 00 00 	movabs $0x804c17,%rax
  807107:	00 00 00 
  80710a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80710c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807110:	8b 10                	mov    (%rax),%edx
  807112:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807116:	8b 40 04             	mov    0x4(%rax),%eax
  807119:	39 c2                	cmp    %eax,%edx
  80711b:	74 ae                	je     8070cb <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80711d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  807121:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  807125:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  807129:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80712d:	8b 00                	mov    (%rax),%eax
  80712f:	99                   	cltd   
  807130:	c1 ea 1b             	shr    $0x1b,%edx
  807133:	01 d0                	add    %edx,%eax
  807135:	83 e0 1f             	and    $0x1f,%eax
  807138:	29 d0                	sub    %edx,%eax
  80713a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80713e:	48 98                	cltq   
  807140:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  807145:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  807147:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80714b:	8b 00                	mov    (%rax),%eax
  80714d:	8d 50 01             	lea    0x1(%rax),%edx
  807150:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807154:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  807156:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80715b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80715f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  807163:	0f 82 60 ff ff ff    	jb     8070c9 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  807169:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80716d:	c9                   	leaveq 
  80716e:	c3                   	retq   

000000000080716f <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80716f:	55                   	push   %rbp
  807170:	48 89 e5             	mov    %rsp,%rbp
  807173:	48 83 ec 40          	sub    $0x40,%rsp
  807177:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80717b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80717f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  807183:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  807187:	48 89 c7             	mov    %rax,%rdi
  80718a:	48 b8 bf 54 80 00 00 	movabs $0x8054bf,%rax
  807191:	00 00 00 
  807194:	ff d0                	callq  *%rax
  807196:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80719a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80719e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8071a2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8071a9:	00 
  8071aa:	e9 8e 00 00 00       	jmpq   80723d <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8071af:	eb 31                	jmp    8071e2 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8071b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8071b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8071b9:	48 89 d6             	mov    %rdx,%rsi
  8071bc:	48 89 c7             	mov    %rax,%rdi
  8071bf:	48 b8 52 6f 80 00 00 	movabs $0x806f52,%rax
  8071c6:	00 00 00 
  8071c9:	ff d0                	callq  *%rax
  8071cb:	85 c0                	test   %eax,%eax
  8071cd:	74 07                	je     8071d6 <devpipe_write+0x67>
				return 0;
  8071cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8071d4:	eb 79                	jmp    80724f <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8071d6:	48 b8 17 4c 80 00 00 	movabs $0x804c17,%rax
  8071dd:	00 00 00 
  8071e0:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8071e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8071e6:	8b 40 04             	mov    0x4(%rax),%eax
  8071e9:	48 63 d0             	movslq %eax,%rdx
  8071ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8071f0:	8b 00                	mov    (%rax),%eax
  8071f2:	48 98                	cltq   
  8071f4:	48 83 c0 20          	add    $0x20,%rax
  8071f8:	48 39 c2             	cmp    %rax,%rdx
  8071fb:	73 b4                	jae    8071b1 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8071fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807201:	8b 40 04             	mov    0x4(%rax),%eax
  807204:	99                   	cltd   
  807205:	c1 ea 1b             	shr    $0x1b,%edx
  807208:	01 d0                	add    %edx,%eax
  80720a:	83 e0 1f             	and    $0x1f,%eax
  80720d:	29 d0                	sub    %edx,%eax
  80720f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  807213:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  807217:	48 01 ca             	add    %rcx,%rdx
  80721a:	0f b6 0a             	movzbl (%rdx),%ecx
  80721d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  807221:	48 98                	cltq   
  807223:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  807227:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80722b:	8b 40 04             	mov    0x4(%rax),%eax
  80722e:	8d 50 01             	lea    0x1(%rax),%edx
  807231:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807235:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  807238:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80723d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  807241:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  807245:	0f 82 64 ff ff ff    	jb     8071af <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80724b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80724f:	c9                   	leaveq 
  807250:	c3                   	retq   

0000000000807251 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  807251:	55                   	push   %rbp
  807252:	48 89 e5             	mov    %rsp,%rbp
  807255:	48 83 ec 20          	sub    $0x20,%rsp
  807259:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80725d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  807261:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  807265:	48 89 c7             	mov    %rax,%rdi
  807268:	48 b8 bf 54 80 00 00 	movabs $0x8054bf,%rax
  80726f:	00 00 00 
  807272:	ff d0                	callq  *%rax
  807274:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  807278:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80727c:	48 be 38 83 80 00 00 	movabs $0x808338,%rsi
  807283:	00 00 00 
  807286:	48 89 c7             	mov    %rax,%rdi
  807289:	48 b8 26 43 80 00 00 	movabs $0x804326,%rax
  807290:	00 00 00 
  807293:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  807295:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  807299:	8b 50 04             	mov    0x4(%rax),%edx
  80729c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8072a0:	8b 00                	mov    (%rax),%eax
  8072a2:	29 c2                	sub    %eax,%edx
  8072a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8072a8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8072ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8072b2:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8072b9:	00 00 00 
	stat->st_dev = &devpipe;
  8072bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8072c0:	48 b9 60 21 81 00 00 	movabs $0x812160,%rcx
  8072c7:	00 00 00 
  8072ca:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8072d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8072d6:	c9                   	leaveq 
  8072d7:	c3                   	retq   

00000000008072d8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8072d8:	55                   	push   %rbp
  8072d9:	48 89 e5             	mov    %rsp,%rbp
  8072dc:	48 83 ec 10          	sub    $0x10,%rsp
  8072e0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  8072e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8072e8:	48 89 c6             	mov    %rax,%rsi
  8072eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8072f0:	48 b8 00 4d 80 00 00 	movabs $0x804d00,%rax
  8072f7:	00 00 00 
  8072fa:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  8072fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  807300:	48 89 c7             	mov    %rax,%rdi
  807303:	48 b8 bf 54 80 00 00 	movabs $0x8054bf,%rax
  80730a:	00 00 00 
  80730d:	ff d0                	callq  *%rax
  80730f:	48 89 c6             	mov    %rax,%rsi
  807312:	bf 00 00 00 00       	mov    $0x0,%edi
  807317:	48 b8 00 4d 80 00 00 	movabs $0x804d00,%rax
  80731e:	00 00 00 
  807321:	ff d0                	callq  *%rax
}
  807323:	c9                   	leaveq 
  807324:	c3                   	retq   

0000000000807325 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  807325:	55                   	push   %rbp
  807326:	48 89 e5             	mov    %rsp,%rbp
  807329:	48 83 ec 20          	sub    $0x20,%rsp
  80732d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  807330:	8b 45 ec             	mov    -0x14(%rbp),%eax
  807333:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  807336:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80733a:	be 01 00 00 00       	mov    $0x1,%esi
  80733f:	48 89 c7             	mov    %rax,%rdi
  807342:	48 b8 0d 4b 80 00 00 	movabs $0x804b0d,%rax
  807349:	00 00 00 
  80734c:	ff d0                	callq  *%rax
}
  80734e:	c9                   	leaveq 
  80734f:	c3                   	retq   

0000000000807350 <getchar>:

int
getchar(void)
{
  807350:	55                   	push   %rbp
  807351:	48 89 e5             	mov    %rsp,%rbp
  807354:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  807358:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80735c:	ba 01 00 00 00       	mov    $0x1,%edx
  807361:	48 89 c6             	mov    %rax,%rsi
  807364:	bf 00 00 00 00       	mov    $0x0,%edi
  807369:	48 b8 b4 59 80 00 00 	movabs $0x8059b4,%rax
  807370:	00 00 00 
  807373:	ff d0                	callq  *%rax
  807375:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  807378:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80737c:	79 05                	jns    807383 <getchar+0x33>
		return r;
  80737e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807381:	eb 14                	jmp    807397 <getchar+0x47>
	if (r < 1)
  807383:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807387:	7f 07                	jg     807390 <getchar+0x40>
		return -E_EOF;
  807389:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80738e:	eb 07                	jmp    807397 <getchar+0x47>
	return c;
  807390:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  807394:	0f b6 c0             	movzbl %al,%eax

}
  807397:	c9                   	leaveq 
  807398:	c3                   	retq   

0000000000807399 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  807399:	55                   	push   %rbp
  80739a:	48 89 e5             	mov    %rsp,%rbp
  80739d:	48 83 ec 20          	sub    $0x20,%rsp
  8073a1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8073a4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8073a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8073ab:	48 89 d6             	mov    %rdx,%rsi
  8073ae:	89 c7                	mov    %eax,%edi
  8073b0:	48 b8 82 55 80 00 00 	movabs $0x805582,%rax
  8073b7:	00 00 00 
  8073ba:	ff d0                	callq  *%rax
  8073bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8073bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8073c3:	79 05                	jns    8073ca <iscons+0x31>
		return r;
  8073c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8073c8:	eb 1a                	jmp    8073e4 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8073ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8073ce:	8b 10                	mov    (%rax),%edx
  8073d0:	48 b8 a0 21 81 00 00 	movabs $0x8121a0,%rax
  8073d7:	00 00 00 
  8073da:	8b 00                	mov    (%rax),%eax
  8073dc:	39 c2                	cmp    %eax,%edx
  8073de:	0f 94 c0             	sete   %al
  8073e1:	0f b6 c0             	movzbl %al,%eax
}
  8073e4:	c9                   	leaveq 
  8073e5:	c3                   	retq   

00000000008073e6 <opencons>:

int
opencons(void)
{
  8073e6:	55                   	push   %rbp
  8073e7:	48 89 e5             	mov    %rsp,%rbp
  8073ea:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8073ee:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8073f2:	48 89 c7             	mov    %rax,%rdi
  8073f5:	48 b8 ea 54 80 00 00 	movabs $0x8054ea,%rax
  8073fc:	00 00 00 
  8073ff:	ff d0                	callq  *%rax
  807401:	89 45 fc             	mov    %eax,-0x4(%rbp)
  807404:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807408:	79 05                	jns    80740f <opencons+0x29>
		return r;
  80740a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80740d:	eb 5b                	jmp    80746a <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80740f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807413:	ba 07 04 00 00       	mov    $0x407,%edx
  807418:	48 89 c6             	mov    %rax,%rsi
  80741b:	bf 00 00 00 00       	mov    $0x0,%edi
  807420:	48 b8 55 4c 80 00 00 	movabs $0x804c55,%rax
  807427:	00 00 00 
  80742a:	ff d0                	callq  *%rax
  80742c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80742f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807433:	79 05                	jns    80743a <opencons+0x54>
		return r;
  807435:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807438:	eb 30                	jmp    80746a <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80743a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80743e:	48 ba a0 21 81 00 00 	movabs $0x8121a0,%rdx
  807445:	00 00 00 
  807448:	8b 12                	mov    (%rdx),%edx
  80744a:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80744c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807450:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  807457:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80745b:	48 89 c7             	mov    %rax,%rdi
  80745e:	48 b8 9c 54 80 00 00 	movabs $0x80549c,%rax
  807465:	00 00 00 
  807468:	ff d0                	callq  *%rax
}
  80746a:	c9                   	leaveq 
  80746b:	c3                   	retq   

000000000080746c <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80746c:	55                   	push   %rbp
  80746d:	48 89 e5             	mov    %rsp,%rbp
  807470:	48 83 ec 30          	sub    $0x30,%rsp
  807474:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  807478:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80747c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  807480:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  807485:	75 07                	jne    80748e <devcons_read+0x22>
		return 0;
  807487:	b8 00 00 00 00       	mov    $0x0,%eax
  80748c:	eb 4b                	jmp    8074d9 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80748e:	eb 0c                	jmp    80749c <devcons_read+0x30>
		sys_yield();
  807490:	48 b8 17 4c 80 00 00 	movabs $0x804c17,%rax
  807497:	00 00 00 
  80749a:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80749c:	48 b8 57 4b 80 00 00 	movabs $0x804b57,%rax
  8074a3:	00 00 00 
  8074a6:	ff d0                	callq  *%rax
  8074a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8074ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8074af:	74 df                	je     807490 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8074b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8074b5:	79 05                	jns    8074bc <devcons_read+0x50>
		return c;
  8074b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8074ba:	eb 1d                	jmp    8074d9 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8074bc:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8074c0:	75 07                	jne    8074c9 <devcons_read+0x5d>
		return 0;
  8074c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8074c7:	eb 10                	jmp    8074d9 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8074c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8074cc:	89 c2                	mov    %eax,%edx
  8074ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8074d2:	88 10                	mov    %dl,(%rax)
	return 1;
  8074d4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8074d9:	c9                   	leaveq 
  8074da:	c3                   	retq   

00000000008074db <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8074db:	55                   	push   %rbp
  8074dc:	48 89 e5             	mov    %rsp,%rbp
  8074df:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8074e6:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8074ed:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8074f4:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8074fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  807502:	eb 76                	jmp    80757a <devcons_write+0x9f>
		m = n - tot;
  807504:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80750b:	89 c2                	mov    %eax,%edx
  80750d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807510:	29 c2                	sub    %eax,%edx
  807512:	89 d0                	mov    %edx,%eax
  807514:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  807517:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80751a:	83 f8 7f             	cmp    $0x7f,%eax
  80751d:	76 07                	jbe    807526 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80751f:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  807526:	8b 45 f8             	mov    -0x8(%rbp),%eax
  807529:	48 63 d0             	movslq %eax,%rdx
  80752c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80752f:	48 63 c8             	movslq %eax,%rcx
  807532:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  807539:	48 01 c1             	add    %rax,%rcx
  80753c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  807543:	48 89 ce             	mov    %rcx,%rsi
  807546:	48 89 c7             	mov    %rax,%rdi
  807549:	48 b8 4a 46 80 00 00 	movabs $0x80464a,%rax
  807550:	00 00 00 
  807553:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  807555:	8b 45 f8             	mov    -0x8(%rbp),%eax
  807558:	48 63 d0             	movslq %eax,%rdx
  80755b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  807562:	48 89 d6             	mov    %rdx,%rsi
  807565:	48 89 c7             	mov    %rax,%rdi
  807568:	48 b8 0d 4b 80 00 00 	movabs $0x804b0d,%rax
  80756f:	00 00 00 
  807572:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  807574:	8b 45 f8             	mov    -0x8(%rbp),%eax
  807577:	01 45 fc             	add    %eax,-0x4(%rbp)
  80757a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80757d:	48 98                	cltq   
  80757f:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  807586:	0f 82 78 ff ff ff    	jb     807504 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80758c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80758f:	c9                   	leaveq 
  807590:	c3                   	retq   

0000000000807591 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  807591:	55                   	push   %rbp
  807592:	48 89 e5             	mov    %rsp,%rbp
  807595:	48 83 ec 08          	sub    $0x8,%rsp
  807599:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80759d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8075a2:	c9                   	leaveq 
  8075a3:	c3                   	retq   

00000000008075a4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8075a4:	55                   	push   %rbp
  8075a5:	48 89 e5             	mov    %rsp,%rbp
  8075a8:	48 83 ec 10          	sub    $0x10,%rsp
  8075ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8075b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8075b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8075b8:	48 be 44 83 80 00 00 	movabs $0x808344,%rsi
  8075bf:	00 00 00 
  8075c2:	48 89 c7             	mov    %rax,%rdi
  8075c5:	48 b8 26 43 80 00 00 	movabs $0x804326,%rax
  8075cc:	00 00 00 
  8075cf:	ff d0                	callq  *%rax
	return 0;
  8075d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8075d6:	c9                   	leaveq 
  8075d7:	c3                   	retq   
