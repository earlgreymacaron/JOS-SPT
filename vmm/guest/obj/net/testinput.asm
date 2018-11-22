
vmm/guest/obj/net/testinput:     file format elf64-x86-64


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
  80003c:	e8 0a 0a 00 00       	callq  800a4b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <announce>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


    static void
announce(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 30          	sub    $0x30,%rsp
    // with ARP requests.  Ideally, we would use gratuitous ARP
    // for this, but QEMU's ARP implementation is dumb and only
    // listens for very specific ARP requests, such as requests
    // for the gateway IP.

    uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  80004b:	c6 45 e0 52          	movb   $0x52,-0x20(%rbp)
  80004f:	c6 45 e1 54          	movb   $0x54,-0x1f(%rbp)
  800053:	c6 45 e2 00          	movb   $0x0,-0x1e(%rbp)
  800057:	c6 45 e3 12          	movb   $0x12,-0x1d(%rbp)
  80005b:	c6 45 e4 34          	movb   $0x34,-0x1c(%rbp)
  80005f:	c6 45 e5 56          	movb   $0x56,-0x1b(%rbp)
    uint32_t myip = inet_addr(IP);
  800063:	48 bf 60 56 80 00 00 	movabs $0x805660,%rdi
  80006a:	00 00 00 
  80006d:	48 b8 a6 51 80 00 00 	movabs $0x8051a6,%rax
  800074:	00 00 00 
  800077:	ff d0                	callq  *%rax
  800079:	89 45 dc             	mov    %eax,-0x24(%rbp)
    uint32_t gwip = inet_addr(DEFAULT);
  80007c:	48 bf 6a 56 80 00 00 	movabs $0x80566a,%rdi
  800083:	00 00 00 
  800086:	48 b8 a6 51 80 00 00 	movabs $0x8051a6,%rax
  80008d:	00 00 00 
  800090:	ff d0                	callq  *%rax
  800092:	89 45 d8             	mov    %eax,-0x28(%rbp)
    int r;

    if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  800095:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80009c:	00 00 00 
  80009f:	48 8b 00             	mov    (%rax),%rax
  8000a2:	ba 07 00 00 00       	mov    $0x7,%edx
  8000a7:	48 89 c6             	mov    %rax,%rsi
  8000aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8000af:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  8000b6:	00 00 00 
  8000b9:	ff d0                	callq  *%rax
  8000bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000c2:	79 30                	jns    8000f4 <announce+0xb1>
        panic("sys_page_map: %e", r);
  8000c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c7:	89 c1                	mov    %eax,%ecx
  8000c9:	48 ba 73 56 80 00 00 	movabs $0x805673,%rdx
  8000d0:	00 00 00 
  8000d3:	be 1a 00 00 00       	mov    $0x1a,%esi
  8000d8:	48 bf 84 56 80 00 00 	movabs $0x805684,%rdi
  8000df:	00 00 00 
  8000e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e7:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  8000ee:	00 00 00 
  8000f1:	41 ff d0             	callq  *%r8

    struct etharp_hdr *arp = (struct etharp_hdr*)pkt->jp_data;
  8000f4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8000fb:	00 00 00 
  8000fe:	48 8b 00             	mov    (%rax),%rax
  800101:	48 83 c0 04          	add    $0x4,%rax
  800105:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    pkt->jp_len = sizeof(*arp);
  800109:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800110:	00 00 00 
  800113:	48 8b 00             	mov    (%rax),%rax
  800116:	c7 00 2a 00 00 00    	movl   $0x2a,(%rax)

    memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  80011c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800120:	ba 06 00 00 00       	mov    $0x6,%edx
  800125:	be ff 00 00 00       	mov    $0xff,%esi
  80012a:	48 89 c7             	mov    %rax,%rdi
  80012d:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
    memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  800139:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80013d:	48 8d 48 06          	lea    0x6(%rax),%rcx
  800141:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800145:	ba 06 00 00 00       	mov    $0x6,%edx
  80014a:	48 89 c6             	mov    %rax,%rsi
  80014d:	48 89 cf             	mov    %rcx,%rdi
  800150:	48 b8 1a 1d 80 00 00 	movabs $0x801d1a,%rax
  800157:	00 00 00 
  80015a:	ff d0                	callq  *%rax
    arp->ethhdr.type = htons(ETHTYPE_ARP);
  80015c:	bf 06 08 00 00       	mov    $0x806,%edi
  800161:	48 b8 b5 55 80 00 00 	movabs $0x8055b5,%rax
  800168:	00 00 00 
  80016b:	ff d0                	callq  *%rax
  80016d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800171:	66 89 42 0c          	mov    %ax,0xc(%rdx)
    arp->hwtype = htons(1); // Ethernet
  800175:	bf 01 00 00 00       	mov    $0x1,%edi
  80017a:	48 b8 b5 55 80 00 00 	movabs $0x8055b5,%rax
  800181:	00 00 00 
  800184:	ff d0                	callq  *%rax
  800186:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80018a:	66 89 42 0e          	mov    %ax,0xe(%rdx)
    arp->proto = htons(ETHTYPE_IP);
  80018e:	bf 00 08 00 00       	mov    $0x800,%edi
  800193:	48 b8 b5 55 80 00 00 	movabs $0x8055b5,%rax
  80019a:	00 00 00 
  80019d:	ff d0                	callq  *%rax
  80019f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001a3:	66 89 42 10          	mov    %ax,0x10(%rdx)
    arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  8001a7:	bf 04 06 00 00       	mov    $0x604,%edi
  8001ac:	48 b8 b5 55 80 00 00 	movabs $0x8055b5,%rax
  8001b3:	00 00 00 
  8001b6:	ff d0                	callq  *%rax
  8001b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001bc:	66 89 42 12          	mov    %ax,0x12(%rdx)
    arp->opcode = htons(ARP_REQUEST);
  8001c0:	bf 01 00 00 00       	mov    $0x1,%edi
  8001c5:	48 b8 b5 55 80 00 00 	movabs $0x8055b5,%rax
  8001cc:	00 00 00 
  8001cf:	ff d0                	callq  *%rax
  8001d1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d5:	66 89 42 14          	mov    %ax,0x14(%rdx)
    memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  8001d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001dd:	48 8d 48 16          	lea    0x16(%rax),%rcx
  8001e1:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8001e5:	ba 06 00 00 00       	mov    $0x6,%edx
  8001ea:	48 89 c6             	mov    %rax,%rsi
  8001ed:	48 89 cf             	mov    %rcx,%rdi
  8001f0:	48 b8 1a 1d 80 00 00 	movabs $0x801d1a,%rax
  8001f7:	00 00 00 
  8001fa:	ff d0                	callq  *%rax
    memcpy(arp->sipaddr.addrw, &myip, 4);
  8001fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800200:	48 8d 48 1c          	lea    0x1c(%rax),%rcx
  800204:	48 8d 45 dc          	lea    -0x24(%rbp),%rax
  800208:	ba 04 00 00 00       	mov    $0x4,%edx
  80020d:	48 89 c6             	mov    %rax,%rsi
  800210:	48 89 cf             	mov    %rcx,%rdi
  800213:	48 b8 1a 1d 80 00 00 	movabs $0x801d1a,%rax
  80021a:	00 00 00 
  80021d:	ff d0                	callq  *%rax
    memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  80021f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800223:	48 83 c0 20          	add    $0x20,%rax
  800227:	ba 06 00 00 00       	mov    $0x6,%edx
  80022c:	be 00 00 00 00       	mov    $0x0,%esi
  800231:	48 89 c7             	mov    %rax,%rdi
  800234:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  80023b:	00 00 00 
  80023e:	ff d0                	callq  *%rax
    memcpy(arp->dipaddr.addrw, &gwip, 4);
  800240:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800244:	48 8d 48 26          	lea    0x26(%rax),%rcx
  800248:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80024c:	ba 04 00 00 00       	mov    $0x4,%edx
  800251:	48 89 c6             	mov    %rax,%rsi
  800254:	48 89 cf             	mov    %rcx,%rdi
  800257:	48 b8 1a 1d 80 00 00 	movabs $0x801d1a,%rax
  80025e:	00 00 00 
  800261:	ff d0                	callq  *%rax

    ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  800263:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80026a:	00 00 00 
  80026d:	48 8b 10             	mov    (%rax),%rdx
  800270:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800277:	00 00 00 
  80027a:	8b 00                	mov    (%rax),%eax
  80027c:	b9 07 00 00 00       	mov    $0x7,%ecx
  800281:	be 0b 00 00 00       	mov    $0xb,%esi
  800286:	89 c7                	mov    %eax,%edi
  800288:	48 b8 c4 2c 80 00 00 	movabs $0x802cc4,%rax
  80028f:	00 00 00 
  800292:	ff d0                	callq  *%rax
    sys_page_unmap(0, pkt);
  800294:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80029b:	00 00 00 
  80029e:	48 8b 00             	mov    (%rax),%rax
  8002a1:	48 89 c6             	mov    %rax,%rsi
  8002a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8002a9:	48 b8 b9 22 80 00 00 	movabs $0x8022b9,%rax
  8002b0:	00 00 00 
  8002b3:	ff d0                	callq  *%rax
}
  8002b5:	c9                   	leaveq 
  8002b6:	c3                   	retq   

00000000008002b7 <hexdump>:

    static void
hexdump(const char *prefix, const void *data, int len)
{
  8002b7:	55                   	push   %rbp
  8002b8:	48 89 e5             	mov    %rsp,%rbp
  8002bb:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  8002c2:	48 89 7d 88          	mov    %rdi,-0x78(%rbp)
  8002c6:	48 89 75 80          	mov    %rsi,-0x80(%rbp)
  8002ca:	89 95 7c ff ff ff    	mov    %edx,-0x84(%rbp)
    int i;
    char buf[80];
    char *end = buf + sizeof(buf);
  8002d0:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8002d4:	48 83 c0 50          	add    $0x50,%rax
  8002d8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    char *out = NULL;
  8002dc:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8002e3:	00 
    for (i = 0; i < len; i++) {
  8002e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8002eb:	e9 41 01 00 00       	jmpq   800431 <hexdump+0x17a>
        if (i % 16 == 0)
  8002f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002f3:	83 e0 0f             	and    $0xf,%eax
  8002f6:	85 c0                	test   %eax,%eax
  8002f8:	75 4d                	jne    800347 <hexdump+0x90>
            out = buf + snprintf(buf, end - buf,
  8002fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8002fe:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  800302:	48 29 c2             	sub    %rax,%rdx
  800305:	48 89 d0             	mov    %rdx,%rax
  800308:	89 c6                	mov    %eax,%esi
  80030a:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80030d:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
  800311:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  800315:	41 89 c8             	mov    %ecx,%r8d
  800318:	48 89 d1             	mov    %rdx,%rcx
  80031b:	48 ba 94 56 80 00 00 	movabs $0x805694,%rdx
  800322:	00 00 00 
  800325:	48 89 c7             	mov    %rax,%rdi
  800328:	b8 00 00 00 00       	mov    $0x0,%eax
  80032d:	49 b9 92 17 80 00 00 	movabs $0x801792,%r9
  800334:	00 00 00 
  800337:	41 ff d1             	callq  *%r9
  80033a:	48 98                	cltq   
  80033c:	48 8d 55 90          	lea    -0x70(%rbp),%rdx
  800340:	48 01 d0             	add    %rdx,%rax
  800343:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
                    "%s%04x   ", prefix, i);
        out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  800347:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80034a:	48 63 d0             	movslq %eax,%rdx
  80034d:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800351:	48 01 d0             	add    %rdx,%rax
  800354:	0f b6 00             	movzbl (%rax),%eax
  800357:	0f b6 d0             	movzbl %al,%edx
  80035a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80035e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800362:	48 29 c1             	sub    %rax,%rcx
  800365:	48 89 c8             	mov    %rcx,%rax
  800368:	89 c6                	mov    %eax,%esi
  80036a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80036e:	89 d1                	mov    %edx,%ecx
  800370:	48 ba 9e 56 80 00 00 	movabs $0x80569e,%rdx
  800377:	00 00 00 
  80037a:	48 89 c7             	mov    %rax,%rdi
  80037d:	b8 00 00 00 00       	mov    $0x0,%eax
  800382:	49 b8 92 17 80 00 00 	movabs $0x801792,%r8
  800389:	00 00 00 
  80038c:	41 ff d0             	callq  *%r8
  80038f:	48 98                	cltq   
  800391:	48 01 45 f0          	add    %rax,-0x10(%rbp)
        if (i % 16 == 15 || i == len - 1)
  800395:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800398:	99                   	cltd   
  800399:	c1 ea 1c             	shr    $0x1c,%edx
  80039c:	01 d0                	add    %edx,%eax
  80039e:	83 e0 0f             	and    $0xf,%eax
  8003a1:	29 d0                	sub    %edx,%eax
  8003a3:	83 f8 0f             	cmp    $0xf,%eax
  8003a6:	74 0e                	je     8003b6 <hexdump+0xff>
  8003a8:	8b 85 7c ff ff ff    	mov    -0x84(%rbp),%eax
  8003ae:	83 e8 01             	sub    $0x1,%eax
  8003b1:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8003b4:	75 33                	jne    8003e9 <hexdump+0x132>
            cprintf("%.*s\n", out - buf, buf);
  8003b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ba:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8003be:	48 89 d1             	mov    %rdx,%rcx
  8003c1:	48 29 c1             	sub    %rax,%rcx
  8003c4:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8003c8:	48 89 c2             	mov    %rax,%rdx
  8003cb:	48 89 ce             	mov    %rcx,%rsi
  8003ce:	48 bf a3 56 80 00 00 	movabs $0x8056a3,%rdi
  8003d5:	00 00 00 
  8003d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8003dd:	48 b9 2a 0d 80 00 00 	movabs $0x800d2a,%rcx
  8003e4:	00 00 00 
  8003e7:	ff d1                	callq  *%rcx
        if (i % 2 == 1)
  8003e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ec:	99                   	cltd   
  8003ed:	c1 ea 1f             	shr    $0x1f,%edx
  8003f0:	01 d0                	add    %edx,%eax
  8003f2:	83 e0 01             	and    $0x1,%eax
  8003f5:	29 d0                	sub    %edx,%eax
  8003f7:	83 f8 01             	cmp    $0x1,%eax
  8003fa:	75 0f                	jne    80040b <hexdump+0x154>
            *(out++) = ' ';
  8003fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800400:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800404:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  800408:	c6 00 20             	movb   $0x20,(%rax)
        if (i % 16 == 7)
  80040b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80040e:	99                   	cltd   
  80040f:	c1 ea 1c             	shr    $0x1c,%edx
  800412:	01 d0                	add    %edx,%eax
  800414:	83 e0 0f             	and    $0xf,%eax
  800417:	29 d0                	sub    %edx,%eax
  800419:	83 f8 07             	cmp    $0x7,%eax
  80041c:	75 0f                	jne    80042d <hexdump+0x176>
            *(out++) = ' ';
  80041e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800422:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800426:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  80042a:	c6 00 20             	movb   $0x20,(%rax)
{
    int i;
    char buf[80];
    char *end = buf + sizeof(buf);
    char *out = NULL;
    for (i = 0; i < len; i++) {
  80042d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800431:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800434:	3b 85 7c ff ff ff    	cmp    -0x84(%rbp),%eax
  80043a:	0f 8c b0 fe ff ff    	jl     8002f0 <hexdump+0x39>
        if (i % 2 == 1)
            *(out++) = ' ';
        if (i % 16 == 7)
            *(out++) = ' ';
    }
}
  800440:	c9                   	leaveq 
  800441:	c3                   	retq   

0000000000800442 <umain>:

    void
umain(int argc, char **argv)
{
  800442:	55                   	push   %rbp
  800443:	48 89 e5             	mov    %rsp,%rbp
  800446:	53                   	push   %rbx
  800447:	48 83 ec 38          	sub    $0x38,%rsp
  80044b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80044e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
    envid_t ns_envid = sys_getenvid();
  800452:	48 b8 92 21 80 00 00 	movabs $0x802192,%rax
  800459:	00 00 00 
  80045c:	ff d0                	callq  *%rax
  80045e:	89 45 e8             	mov    %eax,-0x18(%rbp)
    int i, r, first = 1;
  800461:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)

    binaryname = "testinput";
  800468:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80046f:	00 00 00 
  800472:	48 bb a9 56 80 00 00 	movabs $0x8056a9,%rbx
  800479:	00 00 00 
  80047c:	48 89 18             	mov    %rbx,(%rax)

    output_envid = fork();
  80047f:	48 b8 8e 29 80 00 00 	movabs $0x80298e,%rax
  800486:	00 00 00 
  800489:	ff d0                	callq  *%rax
  80048b:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  800492:	00 00 00 
  800495:	89 02                	mov    %eax,(%rdx)
    if (output_envid < 0)
  800497:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80049e:	00 00 00 
  8004a1:	8b 00                	mov    (%rax),%eax
  8004a3:	85 c0                	test   %eax,%eax
  8004a5:	79 2a                	jns    8004d1 <umain+0x8f>
        panic("error forking");
  8004a7:	48 ba b3 56 80 00 00 	movabs $0x8056b3,%rdx
  8004ae:	00 00 00 
  8004b1:	be 4e 00 00 00       	mov    $0x4e,%esi
  8004b6:	48 bf 84 56 80 00 00 	movabs $0x805684,%rdi
  8004bd:	00 00 00 
  8004c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c5:	48 b9 f1 0a 80 00 00 	movabs $0x800af1,%rcx
  8004cc:	00 00 00 
  8004cf:	ff d1                	callq  *%rcx
    else if (output_envid == 0) {
  8004d1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8004d8:	00 00 00 
  8004db:	8b 00                	mov    (%rax),%eax
  8004dd:	85 c0                	test   %eax,%eax
  8004df:	75 16                	jne    8004f7 <umain+0xb5>
        output(ns_envid);
  8004e1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8004e4:	89 c7                	mov    %eax,%edi
  8004e6:	48 b8 34 09 80 00 00 	movabs $0x800934,%rax
  8004ed:	00 00 00 
  8004f0:	ff d0                	callq  *%rax
        return;
  8004f2:	e9 fb 01 00 00       	jmpq   8006f2 <umain+0x2b0>
    }

    input_envid = fork();
  8004f7:	48 b8 8e 29 80 00 00 	movabs $0x80298e,%rax
  8004fe:	00 00 00 
  800501:	ff d0                	callq  *%rax
  800503:	48 ba 04 90 80 00 00 	movabs $0x809004,%rdx
  80050a:	00 00 00 
  80050d:	89 02                	mov    %eax,(%rdx)
    if (input_envid < 0)
  80050f:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  800516:	00 00 00 
  800519:	8b 00                	mov    (%rax),%eax
  80051b:	85 c0                	test   %eax,%eax
  80051d:	79 2a                	jns    800549 <umain+0x107>
        panic("error forking");
  80051f:	48 ba b3 56 80 00 00 	movabs $0x8056b3,%rdx
  800526:	00 00 00 
  800529:	be 56 00 00 00       	mov    $0x56,%esi
  80052e:	48 bf 84 56 80 00 00 	movabs $0x805684,%rdi
  800535:	00 00 00 
  800538:	b8 00 00 00 00       	mov    $0x0,%eax
  80053d:	48 b9 f1 0a 80 00 00 	movabs $0x800af1,%rcx
  800544:	00 00 00 
  800547:	ff d1                	callq  *%rcx
    else if (input_envid == 0) {
  800549:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  800550:	00 00 00 
  800553:	8b 00                	mov    (%rax),%eax
  800555:	85 c0                	test   %eax,%eax
  800557:	75 16                	jne    80056f <umain+0x12d>
        input(ns_envid);
  800559:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80055c:	89 c7                	mov    %eax,%edi
  80055e:	48 b8 1a 08 80 00 00 	movabs $0x80081a,%rax
  800565:	00 00 00 
  800568:	ff d0                	callq  *%rax
        return;
  80056a:	e9 83 01 00 00       	jmpq   8006f2 <umain+0x2b0>
    }

    cprintf("Sending ARP announcement...\n");
  80056f:	48 bf c1 56 80 00 00 	movabs $0x8056c1,%rdi
  800576:	00 00 00 
  800579:	b8 00 00 00 00       	mov    $0x0,%eax
  80057e:	48 ba 2a 0d 80 00 00 	movabs $0x800d2a,%rdx
  800585:	00 00 00 
  800588:	ff d2                	callq  *%rdx
    announce();
  80058a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800591:	00 00 00 
  800594:	ff d0                	callq  *%rax

    while (1) {
        envid_t whom;
        int perm;

        int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  800596:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80059d:	00 00 00 
  8005a0:	48 8b 08             	mov    (%rax),%rcx
  8005a3:	48 8d 55 dc          	lea    -0x24(%rbp),%rdx
  8005a7:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8005ab:	48 89 ce             	mov    %rcx,%rsi
  8005ae:	48 89 c7             	mov    %rax,%rdi
  8005b1:	48 b8 03 2c 80 00 00 	movabs $0x802c03,%rax
  8005b8:	00 00 00 
  8005bb:	ff d0                	callq  *%rax
  8005bd:	89 45 e4             	mov    %eax,-0x1c(%rbp)
        if (req < 0)
  8005c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005c4:	79 30                	jns    8005f6 <umain+0x1b4>
            panic("ipc_recv: %e", req);
  8005c6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005c9:	89 c1                	mov    %eax,%ecx
  8005cb:	48 ba de 56 80 00 00 	movabs $0x8056de,%rdx
  8005d2:	00 00 00 
  8005d5:	be 65 00 00 00       	mov    $0x65,%esi
  8005da:	48 bf 84 56 80 00 00 	movabs $0x805684,%rdi
  8005e1:	00 00 00 
  8005e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e9:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  8005f0:	00 00 00 
  8005f3:	41 ff d0             	callq  *%r8
        if (whom != input_envid)
  8005f6:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8005f9:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  800600:	00 00 00 
  800603:	8b 00                	mov    (%rax),%eax
  800605:	39 c2                	cmp    %eax,%edx
  800607:	74 30                	je     800639 <umain+0x1f7>
            panic("IPC from unexpected environment %08x", whom);
  800609:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80060c:	89 c1                	mov    %eax,%ecx
  80060e:	48 ba f0 56 80 00 00 	movabs $0x8056f0,%rdx
  800615:	00 00 00 
  800618:	be 67 00 00 00       	mov    $0x67,%esi
  80061d:	48 bf 84 56 80 00 00 	movabs $0x805684,%rdi
  800624:	00 00 00 
  800627:	b8 00 00 00 00       	mov    $0x0,%eax
  80062c:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  800633:	00 00 00 
  800636:	41 ff d0             	callq  *%r8
        if (req != NSREQ_INPUT)
  800639:	83 7d e4 0a          	cmpl   $0xa,-0x1c(%rbp)
  80063d:	74 30                	je     80066f <umain+0x22d>
            panic("Unexpected IPC %d", req);
  80063f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800642:	89 c1                	mov    %eax,%ecx
  800644:	48 ba 15 57 80 00 00 	movabs $0x805715,%rdx
  80064b:	00 00 00 
  80064e:	be 69 00 00 00       	mov    $0x69,%esi
  800653:	48 bf 84 56 80 00 00 	movabs $0x805684,%rdi
  80065a:	00 00 00 
  80065d:	b8 00 00 00 00       	mov    $0x0,%eax
  800662:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  800669:	00 00 00 
  80066c:	41 ff d0             	callq  *%r8

        hexdump("input: ", pkt->jp_data, pkt->jp_len);
  80066f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800676:	00 00 00 
  800679:	48 8b 00             	mov    (%rax),%rax
  80067c:	8b 00                	mov    (%rax),%eax
  80067e:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  800685:	00 00 00 
  800688:	48 8b 12             	mov    (%rdx),%rdx
  80068b:	48 8d 4a 04          	lea    0x4(%rdx),%rcx
  80068f:	89 c2                	mov    %eax,%edx
  800691:	48 89 ce             	mov    %rcx,%rsi
  800694:	48 bf 27 57 80 00 00 	movabs $0x805727,%rdi
  80069b:	00 00 00 
  80069e:	48 b8 b7 02 80 00 00 	movabs $0x8002b7,%rax
  8006a5:	00 00 00 
  8006a8:	ff d0                	callq  *%rax
        cprintf("\n");
  8006aa:	48 bf 2f 57 80 00 00 	movabs $0x80572f,%rdi
  8006b1:	00 00 00 
  8006b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8006b9:	48 ba 2a 0d 80 00 00 	movabs $0x800d2a,%rdx
  8006c0:	00 00 00 
  8006c3:	ff d2                	callq  *%rdx

        // Only indicate that we're waiting for packets once
        // we've received the ARP reply
        if (first)
  8006c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8006c9:	74 1b                	je     8006e6 <umain+0x2a4>
            cprintf("Waiting for packets...\n");
  8006cb:	48 bf 31 57 80 00 00 	movabs $0x805731,%rdi
  8006d2:	00 00 00 
  8006d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006da:	48 ba 2a 0d 80 00 00 	movabs $0x800d2a,%rdx
  8006e1:	00 00 00 
  8006e4:	ff d2                	callq  *%rdx
        first = 0;
  8006e6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    }
  8006ed:	e9 a4 fe ff ff       	jmpq   800596 <umain+0x154>
}
  8006f2:	48 83 c4 38          	add    $0x38,%rsp
  8006f6:	5b                   	pop    %rbx
  8006f7:	5d                   	pop    %rbp
  8006f8:	c3                   	retq   

00000000008006f9 <timer>:

#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  8006f9:	55                   	push   %rbp
  8006fa:	48 89 e5             	mov    %rsp,%rbp
  8006fd:	53                   	push   %rbx
  8006fe:	48 83 ec 28          	sub    $0x28,%rsp
  800702:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800705:	89 75 d8             	mov    %esi,-0x28(%rbp)
    int r;
    uint32_t stop = sys_time_msec() + initial_to;
  800708:	48 b8 7b 24 80 00 00 	movabs $0x80247b,%rax
  80070f:	00 00 00 
  800712:	ff d0                	callq  *%rax
  800714:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800717:	01 d0                	add    %edx,%eax
  800719:	89 45 ec             	mov    %eax,-0x14(%rbp)

    binaryname = "ns_timer";
  80071c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800723:	00 00 00 
  800726:	48 bb 50 57 80 00 00 	movabs $0x805750,%rbx
  80072d:	00 00 00 
  800730:	48 89 18             	mov    %rbx,(%rax)

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800733:	eb 0c                	jmp    800741 <timer+0x48>
            sys_yield();
  800735:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  80073c:	00 00 00 
  80073f:	ff d0                	callq  *%rax
    uint32_t stop = sys_time_msec() + initial_to;

    binaryname = "ns_timer";

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800741:	48 b8 7b 24 80 00 00 	movabs $0x80247b,%rax
  800748:	00 00 00 
  80074b:	ff d0                	callq  *%rax
  80074d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800750:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800753:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800756:	73 06                	jae    80075e <timer+0x65>
  800758:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80075c:	79 d7                	jns    800735 <timer+0x3c>
            sys_yield();
        }
        if (r < 0)
  80075e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800762:	79 30                	jns    800794 <timer+0x9b>
            panic("sys_time_msec: %e", r);
  800764:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800767:	89 c1                	mov    %eax,%ecx
  800769:	48 ba 59 57 80 00 00 	movabs $0x805759,%rdx
  800770:	00 00 00 
  800773:	be 10 00 00 00       	mov    $0x10,%esi
  800778:	48 bf 6b 57 80 00 00 	movabs $0x80576b,%rdi
  80077f:	00 00 00 
  800782:	b8 00 00 00 00       	mov    $0x0,%eax
  800787:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  80078e:	00 00 00 
  800791:	41 ff d0             	callq  *%r8

        ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  800794:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800797:	b9 00 00 00 00       	mov    $0x0,%ecx
  80079c:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a1:	be 0c 00 00 00       	mov    $0xc,%esi
  8007a6:	89 c7                	mov    %eax,%edi
  8007a8:	48 b8 c4 2c 80 00 00 	movabs $0x802cc4,%rax
  8007af:	00 00 00 
  8007b2:	ff d0                	callq  *%rax

        while (1) {
            uint32_t to, whom;
            to = ipc_recv((int32_t *) &whom, 0, 0);
  8007b4:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8007b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bd:	be 00 00 00 00       	mov    $0x0,%esi
  8007c2:	48 89 c7             	mov    %rax,%rdi
  8007c5:	48 b8 03 2c 80 00 00 	movabs $0x802c03,%rax
  8007cc:	00 00 00 
  8007cf:	ff d0                	callq  *%rax
  8007d1:	89 45 e4             	mov    %eax,-0x1c(%rbp)

            if (whom != ns_envid) {
  8007d4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8007d7:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8007da:	39 c2                	cmp    %eax,%edx
  8007dc:	74 22                	je     800800 <timer+0x107>
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8007de:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8007e1:	89 c6                	mov    %eax,%esi
  8007e3:	48 bf 78 57 80 00 00 	movabs $0x805778,%rdi
  8007ea:	00 00 00 
  8007ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f2:	48 ba 2a 0d 80 00 00 	movabs $0x800d2a,%rdx
  8007f9:	00 00 00 
  8007fc:	ff d2                	callq  *%rdx
                continue;
            }

            stop = sys_time_msec() + to;
            break;
        }
  8007fe:	eb b4                	jmp    8007b4 <timer+0xbb>
            if (whom != ns_envid) {
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
                continue;
            }

            stop = sys_time_msec() + to;
  800800:	48 b8 7b 24 80 00 00 	movabs $0x80247b,%rax
  800807:	00 00 00 
  80080a:	ff d0                	callq  *%rax
  80080c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80080f:	01 d0                	add    %edx,%eax
  800811:	89 45 ec             	mov    %eax,-0x14(%rbp)
            break;
        }
    }
  800814:	90                   	nop
    uint32_t stop = sys_time_msec() + initial_to;

    binaryname = "ns_timer";

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800815:	e9 27 ff ff ff       	jmpq   800741 <timer+0x48>

000000000080081a <input>:

extern union Nsipc nsipcbuf;

    void
input(envid_t ns_envid)
{
  80081a:	55                   	push   %rbp
  80081b:	48 89 e5             	mov    %rsp,%rbp
  80081e:	53                   	push   %rbx
  80081f:	48 83 ec 28          	sub    $0x28,%rsp
  800823:	89 7d dc             	mov    %edi,-0x24(%rbp)
    binaryname = "ns_input";
  800826:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80082d:	00 00 00 
  800830:	48 bb b3 57 80 00 00 	movabs $0x8057b3,%rbx
  800837:	00 00 00 
  80083a:	48 89 18             	mov    %rbx,(%rax)

    while (1) {
        int r;
        if ((r = sys_page_alloc(0, &nsipcbuf, PTE_P|PTE_U|PTE_W)) < 0)
  80083d:	ba 07 00 00 00       	mov    $0x7,%edx
  800842:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  800849:	00 00 00 
  80084c:	bf 00 00 00 00       	mov    $0x0,%edi
  800851:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  800858:	00 00 00 
  80085b:	ff d0                	callq  *%rax
  80085d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800860:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800864:	79 30                	jns    800896 <input+0x7c>
            panic("sys_page_alloc: %e", r);
  800866:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800869:	89 c1                	mov    %eax,%ecx
  80086b:	48 ba bc 57 80 00 00 	movabs $0x8057bc,%rdx
  800872:	00 00 00 
  800875:	be 0e 00 00 00       	mov    $0xe,%esi
  80087a:	48 bf cf 57 80 00 00 	movabs $0x8057cf,%rdi
  800881:	00 00 00 
  800884:	b8 00 00 00 00       	mov    $0x0,%eax
  800889:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  800890:	00 00 00 
  800893:	41 ff d0             	callq  *%r8
        r = sys_net_receive(nsipcbuf.pkt.jp_data, 1518);
  800896:	be ee 05 00 00       	mov    $0x5ee,%esi
  80089b:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  8008a2:	00 00 00 
  8008a5:	48 b8 01 25 80 00 00 	movabs $0x802501,%rax
  8008ac:	00 00 00 
  8008af:	ff d0                	callq  *%rax
  8008b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (r == 0) {
  8008b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8008b8:	75 0e                	jne    8008c8 <input+0xae>
            sys_yield();
  8008ba:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  8008c1:	00 00 00 
  8008c4:	ff d0                	callq  *%rax
  8008c6:	eb 67                	jmp    80092f <input+0x115>
        } else if (r < 0) {
  8008c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8008cc:	79 22                	jns    8008f0 <input+0xd6>
            cprintf("Failed to receive packet: %e\n", r);
  8008ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008d1:	89 c6                	mov    %eax,%esi
  8008d3:	48 bf db 57 80 00 00 	movabs $0x8057db,%rdi
  8008da:	00 00 00 
  8008dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e2:	48 ba 2a 0d 80 00 00 	movabs $0x800d2a,%rdx
  8008e9:	00 00 00 
  8008ec:	ff d2                	callq  *%rdx
  8008ee:	eb 3f                	jmp    80092f <input+0x115>
        } else if (r > 0) {
  8008f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8008f4:	7e 39                	jle    80092f <input+0x115>
            nsipcbuf.pkt.jp_len = r;
  8008f6:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8008fd:	00 00 00 
  800900:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800903:	89 10                	mov    %edx,(%rax)
            ipc_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_U|PTE_P);
  800905:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800908:	b9 05 00 00 00       	mov    $0x5,%ecx
  80090d:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  800914:	00 00 00 
  800917:	be 0a 00 00 00       	mov    $0xa,%esi
  80091c:	89 c7                	mov    %eax,%edi
  80091e:	48 b8 c4 2c 80 00 00 	movabs $0x802cc4,%rax
  800925:	00 00 00 
  800928:	ff d0                	callq  *%rax
        }
    }
  80092a:	e9 0e ff ff ff       	jmpq   80083d <input+0x23>
  80092f:	e9 09 ff ff ff       	jmpq   80083d <input+0x23>

0000000000800934 <output>:

extern union Nsipc nsipcbuf;

    void
output(envid_t ns_envid)
{
  800934:	55                   	push   %rbp
  800935:	48 89 e5             	mov    %rsp,%rbp
  800938:	53                   	push   %rbx
  800939:	48 83 ec 28          	sub    $0x28,%rsp
  80093d:	89 7d dc             	mov    %edi,-0x24(%rbp)
    binaryname = "ns_output";
  800940:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800947:	00 00 00 
  80094a:	48 bb 00 58 80 00 00 	movabs $0x805800,%rbx
  800951:	00 00 00 
  800954:	48 89 18             	mov    %rbx,(%rax)

    int r;

    while (1) {
        int32_t req, whom;
        req = ipc_recv(&whom, &nsipcbuf, NULL);
  800957:	48 8d 45 e4          	lea    -0x1c(%rbp),%rax
  80095b:	ba 00 00 00 00       	mov    $0x0,%edx
  800960:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  800967:	00 00 00 
  80096a:	48 89 c7             	mov    %rax,%rdi
  80096d:	48 b8 03 2c 80 00 00 	movabs $0x802c03,%rax
  800974:	00 00 00 
  800977:	ff d0                	callq  *%rax
  800979:	89 45 ec             	mov    %eax,-0x14(%rbp)
        assert(whom == ns_envid);
  80097c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80097f:	3b 45 dc             	cmp    -0x24(%rbp),%eax
  800982:	74 35                	je     8009b9 <output+0x85>
  800984:	48 b9 0a 58 80 00 00 	movabs $0x80580a,%rcx
  80098b:	00 00 00 
  80098e:	48 ba 1b 58 80 00 00 	movabs $0x80581b,%rdx
  800995:	00 00 00 
  800998:	be 11 00 00 00       	mov    $0x11,%esi
  80099d:	48 bf 30 58 80 00 00 	movabs $0x805830,%rdi
  8009a4:	00 00 00 
  8009a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ac:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  8009b3:	00 00 00 
  8009b6:	41 ff d0             	callq  *%r8
        assert(req == NSREQ_OUTPUT);
  8009b9:	83 7d ec 0b          	cmpl   $0xb,-0x14(%rbp)
  8009bd:	74 35                	je     8009f4 <output+0xc0>
  8009bf:	48 b9 3d 58 80 00 00 	movabs $0x80583d,%rcx
  8009c6:	00 00 00 
  8009c9:	48 ba 1b 58 80 00 00 	movabs $0x80581b,%rdx
  8009d0:	00 00 00 
  8009d3:	be 12 00 00 00       	mov    $0x12,%esi
  8009d8:	48 bf 30 58 80 00 00 	movabs $0x805830,%rdi
  8009df:	00 00 00 
  8009e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e7:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  8009ee:	00 00 00 
  8009f1:	41 ff d0             	callq  *%r8
        if ((r = sys_net_transmit(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len)) < 0)
  8009f4:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8009fb:	00 00 00 
  8009fe:	8b 00                	mov    (%rax),%eax
  800a00:	89 c6                	mov    %eax,%esi
  800a02:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  800a09:	00 00 00 
  800a0c:	48 b8 b9 24 80 00 00 	movabs $0x8024b9,%rax
  800a13:	00 00 00 
  800a16:	ff d0                	callq  *%rax
  800a18:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800a1b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800a1f:	79 25                	jns    800a46 <output+0x112>
            cprintf("Failed to transmit packet: %e\n", r);
  800a21:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800a24:	89 c6                	mov    %eax,%esi
  800a26:	48 bf 58 58 80 00 00 	movabs $0x805858,%rdi
  800a2d:	00 00 00 
  800a30:	b8 00 00 00 00       	mov    $0x0,%eax
  800a35:	48 ba 2a 0d 80 00 00 	movabs $0x800d2a,%rdx
  800a3c:	00 00 00 
  800a3f:	ff d2                	callq  *%rdx
    }
  800a41:	e9 11 ff ff ff       	jmpq   800957 <output+0x23>
  800a46:	e9 0c ff ff ff       	jmpq   800957 <output+0x23>

0000000000800a4b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a4b:	55                   	push   %rbp
  800a4c:	48 89 e5             	mov    %rsp,%rbp
  800a4f:	48 83 ec 10          	sub    $0x10,%rsp
  800a53:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a56:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800a5a:	48 b8 92 21 80 00 00 	movabs $0x802192,%rax
  800a61:	00 00 00 
  800a64:	ff d0                	callq  *%rax
  800a66:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a6b:	48 98                	cltq   
  800a6d:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800a74:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800a7b:	00 00 00 
  800a7e:	48 01 c2             	add    %rax,%rdx
  800a81:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  800a88:	00 00 00 
  800a8b:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a92:	7e 14                	jle    800aa8 <libmain+0x5d>
		binaryname = argv[0];
  800a94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a98:	48 8b 10             	mov    (%rax),%rdx
  800a9b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800aa2:	00 00 00 
  800aa5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800aa8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800aac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800aaf:	48 89 d6             	mov    %rdx,%rsi
  800ab2:	89 c7                	mov    %eax,%edi
  800ab4:	48 b8 42 04 80 00 00 	movabs $0x800442,%rax
  800abb:	00 00 00 
  800abe:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800ac0:	48 b8 ce 0a 80 00 00 	movabs $0x800ace,%rax
  800ac7:	00 00 00 
  800aca:	ff d0                	callq  *%rax
}
  800acc:	c9                   	leaveq 
  800acd:	c3                   	retq   

0000000000800ace <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800ace:	55                   	push   %rbp
  800acf:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800ad2:	48 b8 83 32 80 00 00 	movabs $0x803283,%rax
  800ad9:	00 00 00 
  800adc:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800ade:	bf 00 00 00 00       	mov    $0x0,%edi
  800ae3:	48 b8 4e 21 80 00 00 	movabs $0x80214e,%rax
  800aea:	00 00 00 
  800aed:	ff d0                	callq  *%rax
}
  800aef:	5d                   	pop    %rbp
  800af0:	c3                   	retq   

0000000000800af1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800af1:	55                   	push   %rbp
  800af2:	48 89 e5             	mov    %rsp,%rbp
  800af5:	53                   	push   %rbx
  800af6:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800afd:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800b04:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800b0a:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800b11:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800b18:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800b1f:	84 c0                	test   %al,%al
  800b21:	74 23                	je     800b46 <_panic+0x55>
  800b23:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800b2a:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800b2e:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800b32:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800b36:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800b3a:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800b3e:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800b42:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800b46:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b4d:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800b54:	00 00 00 
  800b57:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800b5e:	00 00 00 
  800b61:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b65:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800b6c:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800b73:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800b7a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800b81:	00 00 00 
  800b84:	48 8b 18             	mov    (%rax),%rbx
  800b87:	48 b8 92 21 80 00 00 	movabs $0x802192,%rax
  800b8e:	00 00 00 
  800b91:	ff d0                	callq  *%rax
  800b93:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800b99:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ba0:	41 89 c8             	mov    %ecx,%r8d
  800ba3:	48 89 d1             	mov    %rdx,%rcx
  800ba6:	48 89 da             	mov    %rbx,%rdx
  800ba9:	89 c6                	mov    %eax,%esi
  800bab:	48 bf 88 58 80 00 00 	movabs $0x805888,%rdi
  800bb2:	00 00 00 
  800bb5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bba:	49 b9 2a 0d 80 00 00 	movabs $0x800d2a,%r9
  800bc1:	00 00 00 
  800bc4:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800bc7:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800bce:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800bd5:	48 89 d6             	mov    %rdx,%rsi
  800bd8:	48 89 c7             	mov    %rax,%rdi
  800bdb:	48 b8 7e 0c 80 00 00 	movabs $0x800c7e,%rax
  800be2:	00 00 00 
  800be5:	ff d0                	callq  *%rax
	cprintf("\n");
  800be7:	48 bf ab 58 80 00 00 	movabs $0x8058ab,%rdi
  800bee:	00 00 00 
  800bf1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf6:	48 ba 2a 0d 80 00 00 	movabs $0x800d2a,%rdx
  800bfd:	00 00 00 
  800c00:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800c02:	cc                   	int3   
  800c03:	eb fd                	jmp    800c02 <_panic+0x111>

0000000000800c05 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800c05:	55                   	push   %rbp
  800c06:	48 89 e5             	mov    %rsp,%rbp
  800c09:	48 83 ec 10          	sub    $0x10,%rsp
  800c0d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c10:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800c14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c18:	8b 00                	mov    (%rax),%eax
  800c1a:	8d 48 01             	lea    0x1(%rax),%ecx
  800c1d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c21:	89 0a                	mov    %ecx,(%rdx)
  800c23:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c26:	89 d1                	mov    %edx,%ecx
  800c28:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c2c:	48 98                	cltq   
  800c2e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800c32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c36:	8b 00                	mov    (%rax),%eax
  800c38:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c3d:	75 2c                	jne    800c6b <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800c3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c43:	8b 00                	mov    (%rax),%eax
  800c45:	48 98                	cltq   
  800c47:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c4b:	48 83 c2 08          	add    $0x8,%rdx
  800c4f:	48 89 c6             	mov    %rax,%rsi
  800c52:	48 89 d7             	mov    %rdx,%rdi
  800c55:	48 b8 c6 20 80 00 00 	movabs $0x8020c6,%rax
  800c5c:	00 00 00 
  800c5f:	ff d0                	callq  *%rax
        b->idx = 0;
  800c61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c65:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800c6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c6f:	8b 40 04             	mov    0x4(%rax),%eax
  800c72:	8d 50 01             	lea    0x1(%rax),%edx
  800c75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c79:	89 50 04             	mov    %edx,0x4(%rax)
}
  800c7c:	c9                   	leaveq 
  800c7d:	c3                   	retq   

0000000000800c7e <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800c7e:	55                   	push   %rbp
  800c7f:	48 89 e5             	mov    %rsp,%rbp
  800c82:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800c89:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800c90:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800c97:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800c9e:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800ca5:	48 8b 0a             	mov    (%rdx),%rcx
  800ca8:	48 89 08             	mov    %rcx,(%rax)
  800cab:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800caf:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cb3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cb7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800cbb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800cc2:	00 00 00 
    b.cnt = 0;
  800cc5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800ccc:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800ccf:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800cd6:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800cdd:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800ce4:	48 89 c6             	mov    %rax,%rsi
  800ce7:	48 bf 05 0c 80 00 00 	movabs $0x800c05,%rdi
  800cee:	00 00 00 
  800cf1:	48 b8 dd 10 80 00 00 	movabs $0x8010dd,%rax
  800cf8:	00 00 00 
  800cfb:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800cfd:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800d03:	48 98                	cltq   
  800d05:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800d0c:	48 83 c2 08          	add    $0x8,%rdx
  800d10:	48 89 c6             	mov    %rax,%rsi
  800d13:	48 89 d7             	mov    %rdx,%rdi
  800d16:	48 b8 c6 20 80 00 00 	movabs $0x8020c6,%rax
  800d1d:	00 00 00 
  800d20:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800d22:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800d28:	c9                   	leaveq 
  800d29:	c3                   	retq   

0000000000800d2a <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800d2a:	55                   	push   %rbp
  800d2b:	48 89 e5             	mov    %rsp,%rbp
  800d2e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800d35:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800d3c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800d43:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d4a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d51:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d58:	84 c0                	test   %al,%al
  800d5a:	74 20                	je     800d7c <cprintf+0x52>
  800d5c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d60:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d64:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d68:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d6c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d70:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d74:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d78:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d7c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800d83:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800d8a:	00 00 00 
  800d8d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d94:	00 00 00 
  800d97:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d9b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800da2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800da9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800db0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800db7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800dbe:	48 8b 0a             	mov    (%rdx),%rcx
  800dc1:	48 89 08             	mov    %rcx,(%rax)
  800dc4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dc8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dcc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dd0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800dd4:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800ddb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800de2:	48 89 d6             	mov    %rdx,%rsi
  800de5:	48 89 c7             	mov    %rax,%rdi
  800de8:	48 b8 7e 0c 80 00 00 	movabs $0x800c7e,%rax
  800def:	00 00 00 
  800df2:	ff d0                	callq  *%rax
  800df4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800dfa:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e00:	c9                   	leaveq 
  800e01:	c3                   	retq   

0000000000800e02 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800e02:	55                   	push   %rbp
  800e03:	48 89 e5             	mov    %rsp,%rbp
  800e06:	53                   	push   %rbx
  800e07:	48 83 ec 38          	sub    $0x38,%rsp
  800e0b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e0f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800e13:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800e17:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800e1a:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800e1e:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e22:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800e25:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800e29:	77 3b                	ja     800e66 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e2b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800e2e:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800e32:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800e35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800e39:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3e:	48 f7 f3             	div    %rbx
  800e41:	48 89 c2             	mov    %rax,%rdx
  800e44:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800e47:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800e4a:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800e4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e52:	41 89 f9             	mov    %edi,%r9d
  800e55:	48 89 c7             	mov    %rax,%rdi
  800e58:	48 b8 02 0e 80 00 00 	movabs $0x800e02,%rax
  800e5f:	00 00 00 
  800e62:	ff d0                	callq  *%rax
  800e64:	eb 1e                	jmp    800e84 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e66:	eb 12                	jmp    800e7a <printnum+0x78>
			putch(padc, putdat);
  800e68:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800e6c:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800e6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e73:	48 89 ce             	mov    %rcx,%rsi
  800e76:	89 d7                	mov    %edx,%edi
  800e78:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e7a:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800e7e:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800e82:	7f e4                	jg     800e68 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e84:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800e87:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800e8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e90:	48 f7 f1             	div    %rcx
  800e93:	48 89 d0             	mov    %rdx,%rax
  800e96:	48 ba b0 5a 80 00 00 	movabs $0x805ab0,%rdx
  800e9d:	00 00 00 
  800ea0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800ea4:	0f be d0             	movsbl %al,%edx
  800ea7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800eab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eaf:	48 89 ce             	mov    %rcx,%rsi
  800eb2:	89 d7                	mov    %edx,%edi
  800eb4:	ff d0                	callq  *%rax
}
  800eb6:	48 83 c4 38          	add    $0x38,%rsp
  800eba:	5b                   	pop    %rbx
  800ebb:	5d                   	pop    %rbp
  800ebc:	c3                   	retq   

0000000000800ebd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ebd:	55                   	push   %rbp
  800ebe:	48 89 e5             	mov    %rsp,%rbp
  800ec1:	48 83 ec 1c          	sub    $0x1c,%rsp
  800ec5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ec9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800ecc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ed0:	7e 52                	jle    800f24 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800ed2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed6:	8b 00                	mov    (%rax),%eax
  800ed8:	83 f8 30             	cmp    $0x30,%eax
  800edb:	73 24                	jae    800f01 <getuint+0x44>
  800edd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ee5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee9:	8b 00                	mov    (%rax),%eax
  800eeb:	89 c0                	mov    %eax,%eax
  800eed:	48 01 d0             	add    %rdx,%rax
  800ef0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ef4:	8b 12                	mov    (%rdx),%edx
  800ef6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ef9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800efd:	89 0a                	mov    %ecx,(%rdx)
  800eff:	eb 17                	jmp    800f18 <getuint+0x5b>
  800f01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f05:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f09:	48 89 d0             	mov    %rdx,%rax
  800f0c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f10:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f14:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f18:	48 8b 00             	mov    (%rax),%rax
  800f1b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f1f:	e9 a3 00 00 00       	jmpq   800fc7 <getuint+0x10a>
	else if (lflag)
  800f24:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800f28:	74 4f                	je     800f79 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800f2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f2e:	8b 00                	mov    (%rax),%eax
  800f30:	83 f8 30             	cmp    $0x30,%eax
  800f33:	73 24                	jae    800f59 <getuint+0x9c>
  800f35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f39:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f41:	8b 00                	mov    (%rax),%eax
  800f43:	89 c0                	mov    %eax,%eax
  800f45:	48 01 d0             	add    %rdx,%rax
  800f48:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f4c:	8b 12                	mov    (%rdx),%edx
  800f4e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f51:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f55:	89 0a                	mov    %ecx,(%rdx)
  800f57:	eb 17                	jmp    800f70 <getuint+0xb3>
  800f59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f61:	48 89 d0             	mov    %rdx,%rax
  800f64:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f68:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f6c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f70:	48 8b 00             	mov    (%rax),%rax
  800f73:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f77:	eb 4e                	jmp    800fc7 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800f79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7d:	8b 00                	mov    (%rax),%eax
  800f7f:	83 f8 30             	cmp    $0x30,%eax
  800f82:	73 24                	jae    800fa8 <getuint+0xeb>
  800f84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f88:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f90:	8b 00                	mov    (%rax),%eax
  800f92:	89 c0                	mov    %eax,%eax
  800f94:	48 01 d0             	add    %rdx,%rax
  800f97:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f9b:	8b 12                	mov    (%rdx),%edx
  800f9d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800fa0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fa4:	89 0a                	mov    %ecx,(%rdx)
  800fa6:	eb 17                	jmp    800fbf <getuint+0x102>
  800fa8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fac:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800fb0:	48 89 d0             	mov    %rdx,%rax
  800fb3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800fb7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fbb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800fbf:	8b 00                	mov    (%rax),%eax
  800fc1:	89 c0                	mov    %eax,%eax
  800fc3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800fc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fcb:	c9                   	leaveq 
  800fcc:	c3                   	retq   

0000000000800fcd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800fcd:	55                   	push   %rbp
  800fce:	48 89 e5             	mov    %rsp,%rbp
  800fd1:	48 83 ec 1c          	sub    $0x1c,%rsp
  800fd5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fd9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800fdc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800fe0:	7e 52                	jle    801034 <getint+0x67>
		x=va_arg(*ap, long long);
  800fe2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe6:	8b 00                	mov    (%rax),%eax
  800fe8:	83 f8 30             	cmp    $0x30,%eax
  800feb:	73 24                	jae    801011 <getint+0x44>
  800fed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ff5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff9:	8b 00                	mov    (%rax),%eax
  800ffb:	89 c0                	mov    %eax,%eax
  800ffd:	48 01 d0             	add    %rdx,%rax
  801000:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801004:	8b 12                	mov    (%rdx),%edx
  801006:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801009:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80100d:	89 0a                	mov    %ecx,(%rdx)
  80100f:	eb 17                	jmp    801028 <getint+0x5b>
  801011:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801015:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801019:	48 89 d0             	mov    %rdx,%rax
  80101c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801020:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801024:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801028:	48 8b 00             	mov    (%rax),%rax
  80102b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80102f:	e9 a3 00 00 00       	jmpq   8010d7 <getint+0x10a>
	else if (lflag)
  801034:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801038:	74 4f                	je     801089 <getint+0xbc>
		x=va_arg(*ap, long);
  80103a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103e:	8b 00                	mov    (%rax),%eax
  801040:	83 f8 30             	cmp    $0x30,%eax
  801043:	73 24                	jae    801069 <getint+0x9c>
  801045:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801049:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80104d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801051:	8b 00                	mov    (%rax),%eax
  801053:	89 c0                	mov    %eax,%eax
  801055:	48 01 d0             	add    %rdx,%rax
  801058:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80105c:	8b 12                	mov    (%rdx),%edx
  80105e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801061:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801065:	89 0a                	mov    %ecx,(%rdx)
  801067:	eb 17                	jmp    801080 <getint+0xb3>
  801069:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801071:	48 89 d0             	mov    %rdx,%rax
  801074:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801078:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80107c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801080:	48 8b 00             	mov    (%rax),%rax
  801083:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801087:	eb 4e                	jmp    8010d7 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  801089:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108d:	8b 00                	mov    (%rax),%eax
  80108f:	83 f8 30             	cmp    $0x30,%eax
  801092:	73 24                	jae    8010b8 <getint+0xeb>
  801094:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801098:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80109c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a0:	8b 00                	mov    (%rax),%eax
  8010a2:	89 c0                	mov    %eax,%eax
  8010a4:	48 01 d0             	add    %rdx,%rax
  8010a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010ab:	8b 12                	mov    (%rdx),%edx
  8010ad:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8010b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010b4:	89 0a                	mov    %ecx,(%rdx)
  8010b6:	eb 17                	jmp    8010cf <getint+0x102>
  8010b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8010c0:	48 89 d0             	mov    %rdx,%rax
  8010c3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8010c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010cb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8010cf:	8b 00                	mov    (%rax),%eax
  8010d1:	48 98                	cltq   
  8010d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8010d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010db:	c9                   	leaveq 
  8010dc:	c3                   	retq   

00000000008010dd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010dd:	55                   	push   %rbp
  8010de:	48 89 e5             	mov    %rsp,%rbp
  8010e1:	41 54                	push   %r12
  8010e3:	53                   	push   %rbx
  8010e4:	48 83 ec 60          	sub    $0x60,%rsp
  8010e8:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8010ec:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8010f0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8010f4:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8010f8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010fc:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  801100:	48 8b 0a             	mov    (%rdx),%rcx
  801103:	48 89 08             	mov    %rcx,(%rax)
  801106:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80110a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80110e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801112:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801116:	eb 17                	jmp    80112f <vprintfmt+0x52>
			if (ch == '\0')
  801118:	85 db                	test   %ebx,%ebx
  80111a:	0f 84 cc 04 00 00    	je     8015ec <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  801120:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801124:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801128:	48 89 d6             	mov    %rdx,%rsi
  80112b:	89 df                	mov    %ebx,%edi
  80112d:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80112f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801133:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801137:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80113b:	0f b6 00             	movzbl (%rax),%eax
  80113e:	0f b6 d8             	movzbl %al,%ebx
  801141:	83 fb 25             	cmp    $0x25,%ebx
  801144:	75 d2                	jne    801118 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801146:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80114a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801151:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801158:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80115f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801166:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80116a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80116e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801172:	0f b6 00             	movzbl (%rax),%eax
  801175:	0f b6 d8             	movzbl %al,%ebx
  801178:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80117b:	83 f8 55             	cmp    $0x55,%eax
  80117e:	0f 87 34 04 00 00    	ja     8015b8 <vprintfmt+0x4db>
  801184:	89 c0                	mov    %eax,%eax
  801186:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80118d:	00 
  80118e:	48 b8 d8 5a 80 00 00 	movabs $0x805ad8,%rax
  801195:	00 00 00 
  801198:	48 01 d0             	add    %rdx,%rax
  80119b:	48 8b 00             	mov    (%rax),%rax
  80119e:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8011a0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8011a4:	eb c0                	jmp    801166 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8011a6:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8011aa:	eb ba                	jmp    801166 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011ac:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8011b3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8011b6:	89 d0                	mov    %edx,%eax
  8011b8:	c1 e0 02             	shl    $0x2,%eax
  8011bb:	01 d0                	add    %edx,%eax
  8011bd:	01 c0                	add    %eax,%eax
  8011bf:	01 d8                	add    %ebx,%eax
  8011c1:	83 e8 30             	sub    $0x30,%eax
  8011c4:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8011c7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8011cb:	0f b6 00             	movzbl (%rax),%eax
  8011ce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011d1:	83 fb 2f             	cmp    $0x2f,%ebx
  8011d4:	7e 0c                	jle    8011e2 <vprintfmt+0x105>
  8011d6:	83 fb 39             	cmp    $0x39,%ebx
  8011d9:	7f 07                	jg     8011e2 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011db:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011e0:	eb d1                	jmp    8011b3 <vprintfmt+0xd6>
			goto process_precision;
  8011e2:	eb 58                	jmp    80123c <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8011e4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011e7:	83 f8 30             	cmp    $0x30,%eax
  8011ea:	73 17                	jae    801203 <vprintfmt+0x126>
  8011ec:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8011f0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011f3:	89 c0                	mov    %eax,%eax
  8011f5:	48 01 d0             	add    %rdx,%rax
  8011f8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8011fb:	83 c2 08             	add    $0x8,%edx
  8011fe:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801201:	eb 0f                	jmp    801212 <vprintfmt+0x135>
  801203:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801207:	48 89 d0             	mov    %rdx,%rax
  80120a:	48 83 c2 08          	add    $0x8,%rdx
  80120e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801212:	8b 00                	mov    (%rax),%eax
  801214:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801217:	eb 23                	jmp    80123c <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  801219:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80121d:	79 0c                	jns    80122b <vprintfmt+0x14e>
				width = 0;
  80121f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801226:	e9 3b ff ff ff       	jmpq   801166 <vprintfmt+0x89>
  80122b:	e9 36 ff ff ff       	jmpq   801166 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801230:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801237:	e9 2a ff ff ff       	jmpq   801166 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80123c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801240:	79 12                	jns    801254 <vprintfmt+0x177>
				width = precision, precision = -1;
  801242:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801245:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801248:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80124f:	e9 12 ff ff ff       	jmpq   801166 <vprintfmt+0x89>
  801254:	e9 0d ff ff ff       	jmpq   801166 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801259:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80125d:	e9 04 ff ff ff       	jmpq   801166 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801262:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801265:	83 f8 30             	cmp    $0x30,%eax
  801268:	73 17                	jae    801281 <vprintfmt+0x1a4>
  80126a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80126e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801271:	89 c0                	mov    %eax,%eax
  801273:	48 01 d0             	add    %rdx,%rax
  801276:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801279:	83 c2 08             	add    $0x8,%edx
  80127c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80127f:	eb 0f                	jmp    801290 <vprintfmt+0x1b3>
  801281:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801285:	48 89 d0             	mov    %rdx,%rax
  801288:	48 83 c2 08          	add    $0x8,%rdx
  80128c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801290:	8b 10                	mov    (%rax),%edx
  801292:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801296:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80129a:	48 89 ce             	mov    %rcx,%rsi
  80129d:	89 d7                	mov    %edx,%edi
  80129f:	ff d0                	callq  *%rax
			break;
  8012a1:	e9 40 03 00 00       	jmpq   8015e6 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8012a6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012a9:	83 f8 30             	cmp    $0x30,%eax
  8012ac:	73 17                	jae    8012c5 <vprintfmt+0x1e8>
  8012ae:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8012b2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012b5:	89 c0                	mov    %eax,%eax
  8012b7:	48 01 d0             	add    %rdx,%rax
  8012ba:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012bd:	83 c2 08             	add    $0x8,%edx
  8012c0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8012c3:	eb 0f                	jmp    8012d4 <vprintfmt+0x1f7>
  8012c5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8012c9:	48 89 d0             	mov    %rdx,%rax
  8012cc:	48 83 c2 08          	add    $0x8,%rdx
  8012d0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8012d4:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8012d6:	85 db                	test   %ebx,%ebx
  8012d8:	79 02                	jns    8012dc <vprintfmt+0x1ff>
				err = -err;
  8012da:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8012dc:	83 fb 15             	cmp    $0x15,%ebx
  8012df:	7f 16                	jg     8012f7 <vprintfmt+0x21a>
  8012e1:	48 b8 00 5a 80 00 00 	movabs $0x805a00,%rax
  8012e8:	00 00 00 
  8012eb:	48 63 d3             	movslq %ebx,%rdx
  8012ee:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8012f2:	4d 85 e4             	test   %r12,%r12
  8012f5:	75 2e                	jne    801325 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8012f7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8012fb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012ff:	89 d9                	mov    %ebx,%ecx
  801301:	48 ba c1 5a 80 00 00 	movabs $0x805ac1,%rdx
  801308:	00 00 00 
  80130b:	48 89 c7             	mov    %rax,%rdi
  80130e:	b8 00 00 00 00       	mov    $0x0,%eax
  801313:	49 b8 f5 15 80 00 00 	movabs $0x8015f5,%r8
  80131a:	00 00 00 
  80131d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801320:	e9 c1 02 00 00       	jmpq   8015e6 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801325:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801329:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80132d:	4c 89 e1             	mov    %r12,%rcx
  801330:	48 ba ca 5a 80 00 00 	movabs $0x805aca,%rdx
  801337:	00 00 00 
  80133a:	48 89 c7             	mov    %rax,%rdi
  80133d:	b8 00 00 00 00       	mov    $0x0,%eax
  801342:	49 b8 f5 15 80 00 00 	movabs $0x8015f5,%r8
  801349:	00 00 00 
  80134c:	41 ff d0             	callq  *%r8
			break;
  80134f:	e9 92 02 00 00       	jmpq   8015e6 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801354:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801357:	83 f8 30             	cmp    $0x30,%eax
  80135a:	73 17                	jae    801373 <vprintfmt+0x296>
  80135c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801360:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801363:	89 c0                	mov    %eax,%eax
  801365:	48 01 d0             	add    %rdx,%rax
  801368:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80136b:	83 c2 08             	add    $0x8,%edx
  80136e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801371:	eb 0f                	jmp    801382 <vprintfmt+0x2a5>
  801373:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801377:	48 89 d0             	mov    %rdx,%rax
  80137a:	48 83 c2 08          	add    $0x8,%rdx
  80137e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801382:	4c 8b 20             	mov    (%rax),%r12
  801385:	4d 85 e4             	test   %r12,%r12
  801388:	75 0a                	jne    801394 <vprintfmt+0x2b7>
				p = "(null)";
  80138a:	49 bc cd 5a 80 00 00 	movabs $0x805acd,%r12
  801391:	00 00 00 
			if (width > 0 && padc != '-')
  801394:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801398:	7e 3f                	jle    8013d9 <vprintfmt+0x2fc>
  80139a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80139e:	74 39                	je     8013d9 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8013a0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8013a3:	48 98                	cltq   
  8013a5:	48 89 c6             	mov    %rax,%rsi
  8013a8:	4c 89 e7             	mov    %r12,%rdi
  8013ab:	48 b8 a1 18 80 00 00 	movabs $0x8018a1,%rax
  8013b2:	00 00 00 
  8013b5:	ff d0                	callq  *%rax
  8013b7:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8013ba:	eb 17                	jmp    8013d3 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8013bc:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8013c0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8013c4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013c8:	48 89 ce             	mov    %rcx,%rsi
  8013cb:	89 d7                	mov    %edx,%edi
  8013cd:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013cf:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8013d3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8013d7:	7f e3                	jg     8013bc <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013d9:	eb 37                	jmp    801412 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8013db:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8013df:	74 1e                	je     8013ff <vprintfmt+0x322>
  8013e1:	83 fb 1f             	cmp    $0x1f,%ebx
  8013e4:	7e 05                	jle    8013eb <vprintfmt+0x30e>
  8013e6:	83 fb 7e             	cmp    $0x7e,%ebx
  8013e9:	7e 14                	jle    8013ff <vprintfmt+0x322>
					putch('?', putdat);
  8013eb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013ef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013f3:	48 89 d6             	mov    %rdx,%rsi
  8013f6:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8013fb:	ff d0                	callq  *%rax
  8013fd:	eb 0f                	jmp    80140e <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8013ff:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801403:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801407:	48 89 d6             	mov    %rdx,%rsi
  80140a:	89 df                	mov    %ebx,%edi
  80140c:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80140e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801412:	4c 89 e0             	mov    %r12,%rax
  801415:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801419:	0f b6 00             	movzbl (%rax),%eax
  80141c:	0f be d8             	movsbl %al,%ebx
  80141f:	85 db                	test   %ebx,%ebx
  801421:	74 10                	je     801433 <vprintfmt+0x356>
  801423:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801427:	78 b2                	js     8013db <vprintfmt+0x2fe>
  801429:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80142d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801431:	79 a8                	jns    8013db <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801433:	eb 16                	jmp    80144b <vprintfmt+0x36e>
				putch(' ', putdat);
  801435:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801439:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80143d:	48 89 d6             	mov    %rdx,%rsi
  801440:	bf 20 00 00 00       	mov    $0x20,%edi
  801445:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801447:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80144b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80144f:	7f e4                	jg     801435 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  801451:	e9 90 01 00 00       	jmpq   8015e6 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801456:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80145a:	be 03 00 00 00       	mov    $0x3,%esi
  80145f:	48 89 c7             	mov    %rax,%rdi
  801462:	48 b8 cd 0f 80 00 00 	movabs $0x800fcd,%rax
  801469:	00 00 00 
  80146c:	ff d0                	callq  *%rax
  80146e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801472:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801476:	48 85 c0             	test   %rax,%rax
  801479:	79 1d                	jns    801498 <vprintfmt+0x3bb>
				putch('-', putdat);
  80147b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80147f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801483:	48 89 d6             	mov    %rdx,%rsi
  801486:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80148b:	ff d0                	callq  *%rax
				num = -(long long) num;
  80148d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801491:	48 f7 d8             	neg    %rax
  801494:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801498:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80149f:	e9 d5 00 00 00       	jmpq   801579 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8014a4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8014a8:	be 03 00 00 00       	mov    $0x3,%esi
  8014ad:	48 89 c7             	mov    %rax,%rdi
  8014b0:	48 b8 bd 0e 80 00 00 	movabs $0x800ebd,%rax
  8014b7:	00 00 00 
  8014ba:	ff d0                	callq  *%rax
  8014bc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8014c0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8014c7:	e9 ad 00 00 00       	jmpq   801579 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  8014cc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8014d0:	be 03 00 00 00       	mov    $0x3,%esi
  8014d5:	48 89 c7             	mov    %rax,%rdi
  8014d8:	48 b8 bd 0e 80 00 00 	movabs $0x800ebd,%rax
  8014df:	00 00 00 
  8014e2:	ff d0                	callq  *%rax
  8014e4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8014e8:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8014ef:	e9 85 00 00 00       	jmpq   801579 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  8014f4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014f8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014fc:	48 89 d6             	mov    %rdx,%rsi
  8014ff:	bf 30 00 00 00       	mov    $0x30,%edi
  801504:	ff d0                	callq  *%rax
			putch('x', putdat);
  801506:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80150a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80150e:	48 89 d6             	mov    %rdx,%rsi
  801511:	bf 78 00 00 00       	mov    $0x78,%edi
  801516:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801518:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80151b:	83 f8 30             	cmp    $0x30,%eax
  80151e:	73 17                	jae    801537 <vprintfmt+0x45a>
  801520:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801524:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801527:	89 c0                	mov    %eax,%eax
  801529:	48 01 d0             	add    %rdx,%rax
  80152c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80152f:	83 c2 08             	add    $0x8,%edx
  801532:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801535:	eb 0f                	jmp    801546 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801537:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80153b:	48 89 d0             	mov    %rdx,%rax
  80153e:	48 83 c2 08          	add    $0x8,%rdx
  801542:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801546:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801549:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80154d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801554:	eb 23                	jmp    801579 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801556:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80155a:	be 03 00 00 00       	mov    $0x3,%esi
  80155f:	48 89 c7             	mov    %rax,%rdi
  801562:	48 b8 bd 0e 80 00 00 	movabs $0x800ebd,%rax
  801569:	00 00 00 
  80156c:	ff d0                	callq  *%rax
  80156e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801572:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801579:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80157e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801581:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801584:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801588:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80158c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801590:	45 89 c1             	mov    %r8d,%r9d
  801593:	41 89 f8             	mov    %edi,%r8d
  801596:	48 89 c7             	mov    %rax,%rdi
  801599:	48 b8 02 0e 80 00 00 	movabs $0x800e02,%rax
  8015a0:	00 00 00 
  8015a3:	ff d0                	callq  *%rax
			break;
  8015a5:	eb 3f                	jmp    8015e6 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8015a7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015ab:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015af:	48 89 d6             	mov    %rdx,%rsi
  8015b2:	89 df                	mov    %ebx,%edi
  8015b4:	ff d0                	callq  *%rax
			break;
  8015b6:	eb 2e                	jmp    8015e6 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8015b8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015bc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015c0:	48 89 d6             	mov    %rdx,%rsi
  8015c3:	bf 25 00 00 00       	mov    $0x25,%edi
  8015c8:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8015ca:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8015cf:	eb 05                	jmp    8015d6 <vprintfmt+0x4f9>
  8015d1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8015d6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8015da:	48 83 e8 01          	sub    $0x1,%rax
  8015de:	0f b6 00             	movzbl (%rax),%eax
  8015e1:	3c 25                	cmp    $0x25,%al
  8015e3:	75 ec                	jne    8015d1 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8015e5:	90                   	nop
		}
	}
  8015e6:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8015e7:	e9 43 fb ff ff       	jmpq   80112f <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8015ec:	48 83 c4 60          	add    $0x60,%rsp
  8015f0:	5b                   	pop    %rbx
  8015f1:	41 5c                	pop    %r12
  8015f3:	5d                   	pop    %rbp
  8015f4:	c3                   	retq   

00000000008015f5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8015f5:	55                   	push   %rbp
  8015f6:	48 89 e5             	mov    %rsp,%rbp
  8015f9:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801600:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801607:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80160e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801615:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80161c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801623:	84 c0                	test   %al,%al
  801625:	74 20                	je     801647 <printfmt+0x52>
  801627:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80162b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80162f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801633:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801637:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80163b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80163f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801643:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801647:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80164e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801655:	00 00 00 
  801658:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80165f:	00 00 00 
  801662:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801666:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80166d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801674:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80167b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801682:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801689:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801690:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801697:	48 89 c7             	mov    %rax,%rdi
  80169a:	48 b8 dd 10 80 00 00 	movabs $0x8010dd,%rax
  8016a1:	00 00 00 
  8016a4:	ff d0                	callq  *%rax
	va_end(ap);
}
  8016a6:	c9                   	leaveq 
  8016a7:	c3                   	retq   

00000000008016a8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8016a8:	55                   	push   %rbp
  8016a9:	48 89 e5             	mov    %rsp,%rbp
  8016ac:	48 83 ec 10          	sub    $0x10,%rsp
  8016b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8016b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8016b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016bb:	8b 40 10             	mov    0x10(%rax),%eax
  8016be:	8d 50 01             	lea    0x1(%rax),%edx
  8016c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c5:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8016c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016cc:	48 8b 10             	mov    (%rax),%rdx
  8016cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8016d7:	48 39 c2             	cmp    %rax,%rdx
  8016da:	73 17                	jae    8016f3 <sprintputch+0x4b>
		*b->buf++ = ch;
  8016dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e0:	48 8b 00             	mov    (%rax),%rax
  8016e3:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8016e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016eb:	48 89 0a             	mov    %rcx,(%rdx)
  8016ee:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8016f1:	88 10                	mov    %dl,(%rax)
}
  8016f3:	c9                   	leaveq 
  8016f4:	c3                   	retq   

00000000008016f5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8016f5:	55                   	push   %rbp
  8016f6:	48 89 e5             	mov    %rsp,%rbp
  8016f9:	48 83 ec 50          	sub    $0x50,%rsp
  8016fd:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801701:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801704:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801708:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80170c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801710:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801714:	48 8b 0a             	mov    (%rdx),%rcx
  801717:	48 89 08             	mov    %rcx,(%rax)
  80171a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80171e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801722:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801726:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80172a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80172e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801732:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801735:	48 98                	cltq   
  801737:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80173b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80173f:	48 01 d0             	add    %rdx,%rax
  801742:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801746:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80174d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801752:	74 06                	je     80175a <vsnprintf+0x65>
  801754:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801758:	7f 07                	jg     801761 <vsnprintf+0x6c>
		return -E_INVAL;
  80175a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80175f:	eb 2f                	jmp    801790 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801761:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801765:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801769:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80176d:	48 89 c6             	mov    %rax,%rsi
  801770:	48 bf a8 16 80 00 00 	movabs $0x8016a8,%rdi
  801777:	00 00 00 
  80177a:	48 b8 dd 10 80 00 00 	movabs $0x8010dd,%rax
  801781:	00 00 00 
  801784:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801786:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80178a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80178d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801790:	c9                   	leaveq 
  801791:	c3                   	retq   

0000000000801792 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801792:	55                   	push   %rbp
  801793:	48 89 e5             	mov    %rsp,%rbp
  801796:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80179d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8017a4:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8017aa:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8017b1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8017b8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8017bf:	84 c0                	test   %al,%al
  8017c1:	74 20                	je     8017e3 <snprintf+0x51>
  8017c3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8017c7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8017cb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8017cf:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8017d3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8017d7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8017db:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8017df:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8017e3:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8017ea:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8017f1:	00 00 00 
  8017f4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8017fb:	00 00 00 
  8017fe:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801802:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801809:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801810:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801817:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80181e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801825:	48 8b 0a             	mov    (%rdx),%rcx
  801828:	48 89 08             	mov    %rcx,(%rax)
  80182b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80182f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801833:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801837:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80183b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801842:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801849:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80184f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801856:	48 89 c7             	mov    %rax,%rdi
  801859:	48 b8 f5 16 80 00 00 	movabs $0x8016f5,%rax
  801860:	00 00 00 
  801863:	ff d0                	callq  *%rax
  801865:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80186b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801871:	c9                   	leaveq 
  801872:	c3                   	retq   

0000000000801873 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801873:	55                   	push   %rbp
  801874:	48 89 e5             	mov    %rsp,%rbp
  801877:	48 83 ec 18          	sub    $0x18,%rsp
  80187b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80187f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801886:	eb 09                	jmp    801891 <strlen+0x1e>
		n++;
  801888:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80188c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801891:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801895:	0f b6 00             	movzbl (%rax),%eax
  801898:	84 c0                	test   %al,%al
  80189a:	75 ec                	jne    801888 <strlen+0x15>
		n++;
	return n;
  80189c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80189f:	c9                   	leaveq 
  8018a0:	c3                   	retq   

00000000008018a1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8018a1:	55                   	push   %rbp
  8018a2:	48 89 e5             	mov    %rsp,%rbp
  8018a5:	48 83 ec 20          	sub    $0x20,%rsp
  8018a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8018b8:	eb 0e                	jmp    8018c8 <strnlen+0x27>
		n++;
  8018ba:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018be:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018c3:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8018c8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8018cd:	74 0b                	je     8018da <strnlen+0x39>
  8018cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018d3:	0f b6 00             	movzbl (%rax),%eax
  8018d6:	84 c0                	test   %al,%al
  8018d8:	75 e0                	jne    8018ba <strnlen+0x19>
		n++;
	return n;
  8018da:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8018dd:	c9                   	leaveq 
  8018de:	c3                   	retq   

00000000008018df <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018df:	55                   	push   %rbp
  8018e0:	48 89 e5             	mov    %rsp,%rbp
  8018e3:	48 83 ec 20          	sub    $0x20,%rsp
  8018e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018eb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8018ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8018f7:	90                   	nop
  8018f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018fc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801900:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801904:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801908:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80190c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801910:	0f b6 12             	movzbl (%rdx),%edx
  801913:	88 10                	mov    %dl,(%rax)
  801915:	0f b6 00             	movzbl (%rax),%eax
  801918:	84 c0                	test   %al,%al
  80191a:	75 dc                	jne    8018f8 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80191c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801920:	c9                   	leaveq 
  801921:	c3                   	retq   

0000000000801922 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801922:	55                   	push   %rbp
  801923:	48 89 e5             	mov    %rsp,%rbp
  801926:	48 83 ec 20          	sub    $0x20,%rsp
  80192a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80192e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801932:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801936:	48 89 c7             	mov    %rax,%rdi
  801939:	48 b8 73 18 80 00 00 	movabs $0x801873,%rax
  801940:	00 00 00 
  801943:	ff d0                	callq  *%rax
  801945:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801948:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80194b:	48 63 d0             	movslq %eax,%rdx
  80194e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801952:	48 01 c2             	add    %rax,%rdx
  801955:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801959:	48 89 c6             	mov    %rax,%rsi
  80195c:	48 89 d7             	mov    %rdx,%rdi
  80195f:	48 b8 df 18 80 00 00 	movabs $0x8018df,%rax
  801966:	00 00 00 
  801969:	ff d0                	callq  *%rax
	return dst;
  80196b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80196f:	c9                   	leaveq 
  801970:	c3                   	retq   

0000000000801971 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801971:	55                   	push   %rbp
  801972:	48 89 e5             	mov    %rsp,%rbp
  801975:	48 83 ec 28          	sub    $0x28,%rsp
  801979:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80197d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801981:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801985:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801989:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80198d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801994:	00 
  801995:	eb 2a                	jmp    8019c1 <strncpy+0x50>
		*dst++ = *src;
  801997:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80199b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80199f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019a3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8019a7:	0f b6 12             	movzbl (%rdx),%edx
  8019aa:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8019ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019b0:	0f b6 00             	movzbl (%rax),%eax
  8019b3:	84 c0                	test   %al,%al
  8019b5:	74 05                	je     8019bc <strncpy+0x4b>
			src++;
  8019b7:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8019bc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019c5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8019c9:	72 cc                	jb     801997 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8019cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019cf:	c9                   	leaveq 
  8019d0:	c3                   	retq   

00000000008019d1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8019d1:	55                   	push   %rbp
  8019d2:	48 89 e5             	mov    %rsp,%rbp
  8019d5:	48 83 ec 28          	sub    $0x28,%rsp
  8019d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8019e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8019ed:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8019f2:	74 3d                	je     801a31 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8019f4:	eb 1d                	jmp    801a13 <strlcpy+0x42>
			*dst++ = *src++;
  8019f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019fa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019fe:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a02:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801a06:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801a0a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801a0e:	0f b6 12             	movzbl (%rdx),%edx
  801a11:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801a13:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801a18:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a1d:	74 0b                	je     801a2a <strlcpy+0x59>
  801a1f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a23:	0f b6 00             	movzbl (%rax),%eax
  801a26:	84 c0                	test   %al,%al
  801a28:	75 cc                	jne    8019f6 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801a2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a2e:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801a31:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a39:	48 29 c2             	sub    %rax,%rdx
  801a3c:	48 89 d0             	mov    %rdx,%rax
}
  801a3f:	c9                   	leaveq 
  801a40:	c3                   	retq   

0000000000801a41 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a41:	55                   	push   %rbp
  801a42:	48 89 e5             	mov    %rsp,%rbp
  801a45:	48 83 ec 10          	sub    $0x10,%rsp
  801a49:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a4d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801a51:	eb 0a                	jmp    801a5d <strcmp+0x1c>
		p++, q++;
  801a53:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a58:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a61:	0f b6 00             	movzbl (%rax),%eax
  801a64:	84 c0                	test   %al,%al
  801a66:	74 12                	je     801a7a <strcmp+0x39>
  801a68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a6c:	0f b6 10             	movzbl (%rax),%edx
  801a6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a73:	0f b6 00             	movzbl (%rax),%eax
  801a76:	38 c2                	cmp    %al,%dl
  801a78:	74 d9                	je     801a53 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a7e:	0f b6 00             	movzbl (%rax),%eax
  801a81:	0f b6 d0             	movzbl %al,%edx
  801a84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a88:	0f b6 00             	movzbl (%rax),%eax
  801a8b:	0f b6 c0             	movzbl %al,%eax
  801a8e:	29 c2                	sub    %eax,%edx
  801a90:	89 d0                	mov    %edx,%eax
}
  801a92:	c9                   	leaveq 
  801a93:	c3                   	retq   

0000000000801a94 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801a94:	55                   	push   %rbp
  801a95:	48 89 e5             	mov    %rsp,%rbp
  801a98:	48 83 ec 18          	sub    $0x18,%rsp
  801a9c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801aa0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801aa4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801aa8:	eb 0f                	jmp    801ab9 <strncmp+0x25>
		n--, p++, q++;
  801aaa:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801aaf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801ab4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801ab9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801abe:	74 1d                	je     801add <strncmp+0x49>
  801ac0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ac4:	0f b6 00             	movzbl (%rax),%eax
  801ac7:	84 c0                	test   %al,%al
  801ac9:	74 12                	je     801add <strncmp+0x49>
  801acb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801acf:	0f b6 10             	movzbl (%rax),%edx
  801ad2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ad6:	0f b6 00             	movzbl (%rax),%eax
  801ad9:	38 c2                	cmp    %al,%dl
  801adb:	74 cd                	je     801aaa <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801add:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ae2:	75 07                	jne    801aeb <strncmp+0x57>
		return 0;
  801ae4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae9:	eb 18                	jmp    801b03 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801aeb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aef:	0f b6 00             	movzbl (%rax),%eax
  801af2:	0f b6 d0             	movzbl %al,%edx
  801af5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801af9:	0f b6 00             	movzbl (%rax),%eax
  801afc:	0f b6 c0             	movzbl %al,%eax
  801aff:	29 c2                	sub    %eax,%edx
  801b01:	89 d0                	mov    %edx,%eax
}
  801b03:	c9                   	leaveq 
  801b04:	c3                   	retq   

0000000000801b05 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801b05:	55                   	push   %rbp
  801b06:	48 89 e5             	mov    %rsp,%rbp
  801b09:	48 83 ec 0c          	sub    $0xc,%rsp
  801b0d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b11:	89 f0                	mov    %esi,%eax
  801b13:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b16:	eb 17                	jmp    801b2f <strchr+0x2a>
		if (*s == c)
  801b18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b1c:	0f b6 00             	movzbl (%rax),%eax
  801b1f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b22:	75 06                	jne    801b2a <strchr+0x25>
			return (char *) s;
  801b24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b28:	eb 15                	jmp    801b3f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b2a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b33:	0f b6 00             	movzbl (%rax),%eax
  801b36:	84 c0                	test   %al,%al
  801b38:	75 de                	jne    801b18 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801b3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b3f:	c9                   	leaveq 
  801b40:	c3                   	retq   

0000000000801b41 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801b41:	55                   	push   %rbp
  801b42:	48 89 e5             	mov    %rsp,%rbp
  801b45:	48 83 ec 0c          	sub    $0xc,%rsp
  801b49:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b4d:	89 f0                	mov    %esi,%eax
  801b4f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b52:	eb 13                	jmp    801b67 <strfind+0x26>
		if (*s == c)
  801b54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b58:	0f b6 00             	movzbl (%rax),%eax
  801b5b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b5e:	75 02                	jne    801b62 <strfind+0x21>
			break;
  801b60:	eb 10                	jmp    801b72 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801b62:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b6b:	0f b6 00             	movzbl (%rax),%eax
  801b6e:	84 c0                	test   %al,%al
  801b70:	75 e2                	jne    801b54 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801b72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b76:	c9                   	leaveq 
  801b77:	c3                   	retq   

0000000000801b78 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801b78:	55                   	push   %rbp
  801b79:	48 89 e5             	mov    %rsp,%rbp
  801b7c:	48 83 ec 18          	sub    $0x18,%rsp
  801b80:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b84:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801b87:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801b8b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b90:	75 06                	jne    801b98 <memset+0x20>
		return v;
  801b92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b96:	eb 69                	jmp    801c01 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801b98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b9c:	83 e0 03             	and    $0x3,%eax
  801b9f:	48 85 c0             	test   %rax,%rax
  801ba2:	75 48                	jne    801bec <memset+0x74>
  801ba4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ba8:	83 e0 03             	and    $0x3,%eax
  801bab:	48 85 c0             	test   %rax,%rax
  801bae:	75 3c                	jne    801bec <memset+0x74>
		c &= 0xFF;
  801bb0:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801bb7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bba:	c1 e0 18             	shl    $0x18,%eax
  801bbd:	89 c2                	mov    %eax,%edx
  801bbf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bc2:	c1 e0 10             	shl    $0x10,%eax
  801bc5:	09 c2                	or     %eax,%edx
  801bc7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bca:	c1 e0 08             	shl    $0x8,%eax
  801bcd:	09 d0                	or     %edx,%eax
  801bcf:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801bd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bd6:	48 c1 e8 02          	shr    $0x2,%rax
  801bda:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801bdd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801be1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801be4:	48 89 d7             	mov    %rdx,%rdi
  801be7:	fc                   	cld    
  801be8:	f3 ab                	rep stos %eax,%es:(%rdi)
  801bea:	eb 11                	jmp    801bfd <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801bec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bf0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bf3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bf7:	48 89 d7             	mov    %rdx,%rdi
  801bfa:	fc                   	cld    
  801bfb:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801bfd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801c01:	c9                   	leaveq 
  801c02:	c3                   	retq   

0000000000801c03 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801c03:	55                   	push   %rbp
  801c04:	48 89 e5             	mov    %rsp,%rbp
  801c07:	48 83 ec 28          	sub    $0x28,%rsp
  801c0b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c0f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c13:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801c17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c1b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801c1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c23:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801c27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c2b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c2f:	0f 83 88 00 00 00    	jae    801cbd <memmove+0xba>
  801c35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c39:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c3d:	48 01 d0             	add    %rdx,%rax
  801c40:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c44:	76 77                	jbe    801cbd <memmove+0xba>
		s += n;
  801c46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c4a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801c4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c52:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801c56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c5a:	83 e0 03             	and    $0x3,%eax
  801c5d:	48 85 c0             	test   %rax,%rax
  801c60:	75 3b                	jne    801c9d <memmove+0x9a>
  801c62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c66:	83 e0 03             	and    $0x3,%eax
  801c69:	48 85 c0             	test   %rax,%rax
  801c6c:	75 2f                	jne    801c9d <memmove+0x9a>
  801c6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c72:	83 e0 03             	and    $0x3,%eax
  801c75:	48 85 c0             	test   %rax,%rax
  801c78:	75 23                	jne    801c9d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801c7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c7e:	48 83 e8 04          	sub    $0x4,%rax
  801c82:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c86:	48 83 ea 04          	sub    $0x4,%rdx
  801c8a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801c8e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801c92:	48 89 c7             	mov    %rax,%rdi
  801c95:	48 89 d6             	mov    %rdx,%rsi
  801c98:	fd                   	std    
  801c99:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801c9b:	eb 1d                	jmp    801cba <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801c9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ca1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801ca5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ca9:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801cad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cb1:	48 89 d7             	mov    %rdx,%rdi
  801cb4:	48 89 c1             	mov    %rax,%rcx
  801cb7:	fd                   	std    
  801cb8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801cba:	fc                   	cld    
  801cbb:	eb 57                	jmp    801d14 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801cbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cc1:	83 e0 03             	and    $0x3,%eax
  801cc4:	48 85 c0             	test   %rax,%rax
  801cc7:	75 36                	jne    801cff <memmove+0xfc>
  801cc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ccd:	83 e0 03             	and    $0x3,%eax
  801cd0:	48 85 c0             	test   %rax,%rax
  801cd3:	75 2a                	jne    801cff <memmove+0xfc>
  801cd5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd9:	83 e0 03             	and    $0x3,%eax
  801cdc:	48 85 c0             	test   %rax,%rax
  801cdf:	75 1e                	jne    801cff <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801ce1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ce5:	48 c1 e8 02          	shr    $0x2,%rax
  801ce9:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801cec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cf0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cf4:	48 89 c7             	mov    %rax,%rdi
  801cf7:	48 89 d6             	mov    %rdx,%rsi
  801cfa:	fc                   	cld    
  801cfb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801cfd:	eb 15                	jmp    801d14 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801cff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d03:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d07:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801d0b:	48 89 c7             	mov    %rax,%rdi
  801d0e:	48 89 d6             	mov    %rdx,%rsi
  801d11:	fc                   	cld    
  801d12:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801d14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d18:	c9                   	leaveq 
  801d19:	c3                   	retq   

0000000000801d1a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d1a:	55                   	push   %rbp
  801d1b:	48 89 e5             	mov    %rsp,%rbp
  801d1e:	48 83 ec 18          	sub    $0x18,%rsp
  801d22:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d26:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d2a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801d2e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d32:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d3a:	48 89 ce             	mov    %rcx,%rsi
  801d3d:	48 89 c7             	mov    %rax,%rdi
  801d40:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  801d47:	00 00 00 
  801d4a:	ff d0                	callq  *%rax
}
  801d4c:	c9                   	leaveq 
  801d4d:	c3                   	retq   

0000000000801d4e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d4e:	55                   	push   %rbp
  801d4f:	48 89 e5             	mov    %rsp,%rbp
  801d52:	48 83 ec 28          	sub    $0x28,%rsp
  801d56:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d5a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d5e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801d62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d66:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801d6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d6e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801d72:	eb 36                	jmp    801daa <memcmp+0x5c>
		if (*s1 != *s2)
  801d74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d78:	0f b6 10             	movzbl (%rax),%edx
  801d7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d7f:	0f b6 00             	movzbl (%rax),%eax
  801d82:	38 c2                	cmp    %al,%dl
  801d84:	74 1a                	je     801da0 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801d86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d8a:	0f b6 00             	movzbl (%rax),%eax
  801d8d:	0f b6 d0             	movzbl %al,%edx
  801d90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d94:	0f b6 00             	movzbl (%rax),%eax
  801d97:	0f b6 c0             	movzbl %al,%eax
  801d9a:	29 c2                	sub    %eax,%edx
  801d9c:	89 d0                	mov    %edx,%eax
  801d9e:	eb 20                	jmp    801dc0 <memcmp+0x72>
		s1++, s2++;
  801da0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801da5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801daa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dae:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801db2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801db6:	48 85 c0             	test   %rax,%rax
  801db9:	75 b9                	jne    801d74 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801dbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc0:	c9                   	leaveq 
  801dc1:	c3                   	retq   

0000000000801dc2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dc2:	55                   	push   %rbp
  801dc3:	48 89 e5             	mov    %rsp,%rbp
  801dc6:	48 83 ec 28          	sub    $0x28,%rsp
  801dca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801dce:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801dd1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801dd5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dd9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801ddd:	48 01 d0             	add    %rdx,%rax
  801de0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801de4:	eb 15                	jmp    801dfb <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801de6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dea:	0f b6 10             	movzbl (%rax),%edx
  801ded:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801df0:	38 c2                	cmp    %al,%dl
  801df2:	75 02                	jne    801df6 <memfind+0x34>
			break;
  801df4:	eb 0f                	jmp    801e05 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801df6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801dfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dff:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801e03:	72 e1                	jb     801de6 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801e05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801e09:	c9                   	leaveq 
  801e0a:	c3                   	retq   

0000000000801e0b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801e0b:	55                   	push   %rbp
  801e0c:	48 89 e5             	mov    %rsp,%rbp
  801e0f:	48 83 ec 34          	sub    $0x34,%rsp
  801e13:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e17:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801e1b:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801e1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801e25:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801e2c:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e2d:	eb 05                	jmp    801e34 <strtol+0x29>
		s++;
  801e2f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e34:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e38:	0f b6 00             	movzbl (%rax),%eax
  801e3b:	3c 20                	cmp    $0x20,%al
  801e3d:	74 f0                	je     801e2f <strtol+0x24>
  801e3f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e43:	0f b6 00             	movzbl (%rax),%eax
  801e46:	3c 09                	cmp    $0x9,%al
  801e48:	74 e5                	je     801e2f <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801e4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e4e:	0f b6 00             	movzbl (%rax),%eax
  801e51:	3c 2b                	cmp    $0x2b,%al
  801e53:	75 07                	jne    801e5c <strtol+0x51>
		s++;
  801e55:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e5a:	eb 17                	jmp    801e73 <strtol+0x68>
	else if (*s == '-')
  801e5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e60:	0f b6 00             	movzbl (%rax),%eax
  801e63:	3c 2d                	cmp    $0x2d,%al
  801e65:	75 0c                	jne    801e73 <strtol+0x68>
		s++, neg = 1;
  801e67:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e6c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e73:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e77:	74 06                	je     801e7f <strtol+0x74>
  801e79:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801e7d:	75 28                	jne    801ea7 <strtol+0x9c>
  801e7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e83:	0f b6 00             	movzbl (%rax),%eax
  801e86:	3c 30                	cmp    $0x30,%al
  801e88:	75 1d                	jne    801ea7 <strtol+0x9c>
  801e8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e8e:	48 83 c0 01          	add    $0x1,%rax
  801e92:	0f b6 00             	movzbl (%rax),%eax
  801e95:	3c 78                	cmp    $0x78,%al
  801e97:	75 0e                	jne    801ea7 <strtol+0x9c>
		s += 2, base = 16;
  801e99:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801e9e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801ea5:	eb 2c                	jmp    801ed3 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801ea7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801eab:	75 19                	jne    801ec6 <strtol+0xbb>
  801ead:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eb1:	0f b6 00             	movzbl (%rax),%eax
  801eb4:	3c 30                	cmp    $0x30,%al
  801eb6:	75 0e                	jne    801ec6 <strtol+0xbb>
		s++, base = 8;
  801eb8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ebd:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801ec4:	eb 0d                	jmp    801ed3 <strtol+0xc8>
	else if (base == 0)
  801ec6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801eca:	75 07                	jne    801ed3 <strtol+0xc8>
		base = 10;
  801ecc:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ed3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed7:	0f b6 00             	movzbl (%rax),%eax
  801eda:	3c 2f                	cmp    $0x2f,%al
  801edc:	7e 1d                	jle    801efb <strtol+0xf0>
  801ede:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee2:	0f b6 00             	movzbl (%rax),%eax
  801ee5:	3c 39                	cmp    $0x39,%al
  801ee7:	7f 12                	jg     801efb <strtol+0xf0>
			dig = *s - '0';
  801ee9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eed:	0f b6 00             	movzbl (%rax),%eax
  801ef0:	0f be c0             	movsbl %al,%eax
  801ef3:	83 e8 30             	sub    $0x30,%eax
  801ef6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ef9:	eb 4e                	jmp    801f49 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801efb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eff:	0f b6 00             	movzbl (%rax),%eax
  801f02:	3c 60                	cmp    $0x60,%al
  801f04:	7e 1d                	jle    801f23 <strtol+0x118>
  801f06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f0a:	0f b6 00             	movzbl (%rax),%eax
  801f0d:	3c 7a                	cmp    $0x7a,%al
  801f0f:	7f 12                	jg     801f23 <strtol+0x118>
			dig = *s - 'a' + 10;
  801f11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f15:	0f b6 00             	movzbl (%rax),%eax
  801f18:	0f be c0             	movsbl %al,%eax
  801f1b:	83 e8 57             	sub    $0x57,%eax
  801f1e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f21:	eb 26                	jmp    801f49 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801f23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f27:	0f b6 00             	movzbl (%rax),%eax
  801f2a:	3c 40                	cmp    $0x40,%al
  801f2c:	7e 48                	jle    801f76 <strtol+0x16b>
  801f2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f32:	0f b6 00             	movzbl (%rax),%eax
  801f35:	3c 5a                	cmp    $0x5a,%al
  801f37:	7f 3d                	jg     801f76 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801f39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f3d:	0f b6 00             	movzbl (%rax),%eax
  801f40:	0f be c0             	movsbl %al,%eax
  801f43:	83 e8 37             	sub    $0x37,%eax
  801f46:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801f49:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f4c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801f4f:	7c 02                	jl     801f53 <strtol+0x148>
			break;
  801f51:	eb 23                	jmp    801f76 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801f53:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801f58:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f5b:	48 98                	cltq   
  801f5d:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801f62:	48 89 c2             	mov    %rax,%rdx
  801f65:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f68:	48 98                	cltq   
  801f6a:	48 01 d0             	add    %rdx,%rax
  801f6d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801f71:	e9 5d ff ff ff       	jmpq   801ed3 <strtol+0xc8>

	if (endptr)
  801f76:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801f7b:	74 0b                	je     801f88 <strtol+0x17d>
		*endptr = (char *) s;
  801f7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f81:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f85:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801f88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f8c:	74 09                	je     801f97 <strtol+0x18c>
  801f8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f92:	48 f7 d8             	neg    %rax
  801f95:	eb 04                	jmp    801f9b <strtol+0x190>
  801f97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801f9b:	c9                   	leaveq 
  801f9c:	c3                   	retq   

0000000000801f9d <strstr>:

char * strstr(const char *in, const char *str)
{
  801f9d:	55                   	push   %rbp
  801f9e:	48 89 e5             	mov    %rsp,%rbp
  801fa1:	48 83 ec 30          	sub    $0x30,%rsp
  801fa5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801fa9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801fad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fb1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801fb5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801fb9:	0f b6 00             	movzbl (%rax),%eax
  801fbc:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801fbf:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801fc3:	75 06                	jne    801fcb <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801fc5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fc9:	eb 6b                	jmp    802036 <strstr+0x99>

	len = strlen(str);
  801fcb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fcf:	48 89 c7             	mov    %rax,%rdi
  801fd2:	48 b8 73 18 80 00 00 	movabs $0x801873,%rax
  801fd9:	00 00 00 
  801fdc:	ff d0                	callq  *%rax
  801fde:	48 98                	cltq   
  801fe0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801fe4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fe8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801fec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ff0:	0f b6 00             	movzbl (%rax),%eax
  801ff3:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801ff6:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801ffa:	75 07                	jne    802003 <strstr+0x66>
				return (char *) 0;
  801ffc:	b8 00 00 00 00       	mov    $0x0,%eax
  802001:	eb 33                	jmp    802036 <strstr+0x99>
		} while (sc != c);
  802003:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  802007:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80200a:	75 d8                	jne    801fe4 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80200c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802010:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802014:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802018:	48 89 ce             	mov    %rcx,%rsi
  80201b:	48 89 c7             	mov    %rax,%rdi
  80201e:	48 b8 94 1a 80 00 00 	movabs $0x801a94,%rax
  802025:	00 00 00 
  802028:	ff d0                	callq  *%rax
  80202a:	85 c0                	test   %eax,%eax
  80202c:	75 b6                	jne    801fe4 <strstr+0x47>

	return (char *) (in - 1);
  80202e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802032:	48 83 e8 01          	sub    $0x1,%rax
}
  802036:	c9                   	leaveq 
  802037:	c3                   	retq   

0000000000802038 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  802038:	55                   	push   %rbp
  802039:	48 89 e5             	mov    %rsp,%rbp
  80203c:	53                   	push   %rbx
  80203d:	48 83 ec 48          	sub    $0x48,%rsp
  802041:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802044:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802047:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80204b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80204f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  802053:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802057:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80205a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80205e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  802062:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  802066:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80206a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80206e:	4c 89 c3             	mov    %r8,%rbx
  802071:	cd 30                	int    $0x30
  802073:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  802077:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80207b:	74 3e                	je     8020bb <syscall+0x83>
  80207d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802082:	7e 37                	jle    8020bb <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  802084:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802088:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80208b:	49 89 d0             	mov    %rdx,%r8
  80208e:	89 c1                	mov    %eax,%ecx
  802090:	48 ba 88 5d 80 00 00 	movabs $0x805d88,%rdx
  802097:	00 00 00 
  80209a:	be 24 00 00 00       	mov    $0x24,%esi
  80209f:	48 bf a5 5d 80 00 00 	movabs $0x805da5,%rdi
  8020a6:	00 00 00 
  8020a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ae:	49 b9 f1 0a 80 00 00 	movabs $0x800af1,%r9
  8020b5:	00 00 00 
  8020b8:	41 ff d1             	callq  *%r9

	return ret;
  8020bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8020bf:	48 83 c4 48          	add    $0x48,%rsp
  8020c3:	5b                   	pop    %rbx
  8020c4:	5d                   	pop    %rbp
  8020c5:	c3                   	retq   

00000000008020c6 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8020c6:	55                   	push   %rbp
  8020c7:	48 89 e5             	mov    %rsp,%rbp
  8020ca:	48 83 ec 20          	sub    $0x20,%rsp
  8020ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8020d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8020d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020de:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020e5:	00 
  8020e6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020f2:	48 89 d1             	mov    %rdx,%rcx
  8020f5:	48 89 c2             	mov    %rax,%rdx
  8020f8:	be 00 00 00 00       	mov    $0x0,%esi
  8020fd:	bf 00 00 00 00       	mov    $0x0,%edi
  802102:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  802109:	00 00 00 
  80210c:	ff d0                	callq  *%rax
}
  80210e:	c9                   	leaveq 
  80210f:	c3                   	retq   

0000000000802110 <sys_cgetc>:

int
sys_cgetc(void)
{
  802110:	55                   	push   %rbp
  802111:	48 89 e5             	mov    %rsp,%rbp
  802114:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802118:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80211f:	00 
  802120:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802126:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80212c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802131:	ba 00 00 00 00       	mov    $0x0,%edx
  802136:	be 00 00 00 00       	mov    $0x0,%esi
  80213b:	bf 01 00 00 00       	mov    $0x1,%edi
  802140:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  802147:	00 00 00 
  80214a:	ff d0                	callq  *%rax
}
  80214c:	c9                   	leaveq 
  80214d:	c3                   	retq   

000000000080214e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80214e:	55                   	push   %rbp
  80214f:	48 89 e5             	mov    %rsp,%rbp
  802152:	48 83 ec 10          	sub    $0x10,%rsp
  802156:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802159:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80215c:	48 98                	cltq   
  80215e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802165:	00 
  802166:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80216c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802172:	b9 00 00 00 00       	mov    $0x0,%ecx
  802177:	48 89 c2             	mov    %rax,%rdx
  80217a:	be 01 00 00 00       	mov    $0x1,%esi
  80217f:	bf 03 00 00 00       	mov    $0x3,%edi
  802184:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  80218b:	00 00 00 
  80218e:	ff d0                	callq  *%rax
}
  802190:	c9                   	leaveq 
  802191:	c3                   	retq   

0000000000802192 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802192:	55                   	push   %rbp
  802193:	48 89 e5             	mov    %rsp,%rbp
  802196:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80219a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021a1:	00 
  8021a2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021a8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b8:	be 00 00 00 00       	mov    $0x0,%esi
  8021bd:	bf 02 00 00 00       	mov    $0x2,%edi
  8021c2:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  8021c9:	00 00 00 
  8021cc:	ff d0                	callq  *%rax
}
  8021ce:	c9                   	leaveq 
  8021cf:	c3                   	retq   

00000000008021d0 <sys_yield>:


void
sys_yield(void)
{
  8021d0:	55                   	push   %rbp
  8021d1:	48 89 e5             	mov    %rsp,%rbp
  8021d4:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8021d8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021df:	00 
  8021e0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021e6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8021f6:	be 00 00 00 00       	mov    $0x0,%esi
  8021fb:	bf 0b 00 00 00       	mov    $0xb,%edi
  802200:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  802207:	00 00 00 
  80220a:	ff d0                	callq  *%rax
}
  80220c:	c9                   	leaveq 
  80220d:	c3                   	retq   

000000000080220e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80220e:	55                   	push   %rbp
  80220f:	48 89 e5             	mov    %rsp,%rbp
  802212:	48 83 ec 20          	sub    $0x20,%rsp
  802216:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802219:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80221d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802220:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802223:	48 63 c8             	movslq %eax,%rcx
  802226:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80222a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80222d:	48 98                	cltq   
  80222f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802236:	00 
  802237:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80223d:	49 89 c8             	mov    %rcx,%r8
  802240:	48 89 d1             	mov    %rdx,%rcx
  802243:	48 89 c2             	mov    %rax,%rdx
  802246:	be 01 00 00 00       	mov    $0x1,%esi
  80224b:	bf 04 00 00 00       	mov    $0x4,%edi
  802250:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  802257:	00 00 00 
  80225a:	ff d0                	callq  *%rax
}
  80225c:	c9                   	leaveq 
  80225d:	c3                   	retq   

000000000080225e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80225e:	55                   	push   %rbp
  80225f:	48 89 e5             	mov    %rsp,%rbp
  802262:	48 83 ec 30          	sub    $0x30,%rsp
  802266:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802269:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80226d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802270:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802274:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802278:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80227b:	48 63 c8             	movslq %eax,%rcx
  80227e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802282:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802285:	48 63 f0             	movslq %eax,%rsi
  802288:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80228c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80228f:	48 98                	cltq   
  802291:	48 89 0c 24          	mov    %rcx,(%rsp)
  802295:	49 89 f9             	mov    %rdi,%r9
  802298:	49 89 f0             	mov    %rsi,%r8
  80229b:	48 89 d1             	mov    %rdx,%rcx
  80229e:	48 89 c2             	mov    %rax,%rdx
  8022a1:	be 01 00 00 00       	mov    $0x1,%esi
  8022a6:	bf 05 00 00 00       	mov    $0x5,%edi
  8022ab:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  8022b2:	00 00 00 
  8022b5:	ff d0                	callq  *%rax
}
  8022b7:	c9                   	leaveq 
  8022b8:	c3                   	retq   

00000000008022b9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8022b9:	55                   	push   %rbp
  8022ba:	48 89 e5             	mov    %rsp,%rbp
  8022bd:	48 83 ec 20          	sub    $0x20,%rsp
  8022c1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022c4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8022c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022cf:	48 98                	cltq   
  8022d1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022d8:	00 
  8022d9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022e5:	48 89 d1             	mov    %rdx,%rcx
  8022e8:	48 89 c2             	mov    %rax,%rdx
  8022eb:	be 01 00 00 00       	mov    $0x1,%esi
  8022f0:	bf 06 00 00 00       	mov    $0x6,%edi
  8022f5:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  8022fc:	00 00 00 
  8022ff:	ff d0                	callq  *%rax
}
  802301:	c9                   	leaveq 
  802302:	c3                   	retq   

0000000000802303 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802303:	55                   	push   %rbp
  802304:	48 89 e5             	mov    %rsp,%rbp
  802307:	48 83 ec 10          	sub    $0x10,%rsp
  80230b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80230e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802311:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802314:	48 63 d0             	movslq %eax,%rdx
  802317:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80231a:	48 98                	cltq   
  80231c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802323:	00 
  802324:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80232a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802330:	48 89 d1             	mov    %rdx,%rcx
  802333:	48 89 c2             	mov    %rax,%rdx
  802336:	be 01 00 00 00       	mov    $0x1,%esi
  80233b:	bf 08 00 00 00       	mov    $0x8,%edi
  802340:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  802347:	00 00 00 
  80234a:	ff d0                	callq  *%rax
}
  80234c:	c9                   	leaveq 
  80234d:	c3                   	retq   

000000000080234e <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80234e:	55                   	push   %rbp
  80234f:	48 89 e5             	mov    %rsp,%rbp
  802352:	48 83 ec 20          	sub    $0x20,%rsp
  802356:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802359:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80235d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802361:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802364:	48 98                	cltq   
  802366:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80236d:	00 
  80236e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802374:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80237a:	48 89 d1             	mov    %rdx,%rcx
  80237d:	48 89 c2             	mov    %rax,%rdx
  802380:	be 01 00 00 00       	mov    $0x1,%esi
  802385:	bf 09 00 00 00       	mov    $0x9,%edi
  80238a:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  802391:	00 00 00 
  802394:	ff d0                	callq  *%rax
}
  802396:	c9                   	leaveq 
  802397:	c3                   	retq   

0000000000802398 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802398:	55                   	push   %rbp
  802399:	48 89 e5             	mov    %rsp,%rbp
  80239c:	48 83 ec 20          	sub    $0x20,%rsp
  8023a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8023a7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ae:	48 98                	cltq   
  8023b0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023b7:	00 
  8023b8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023be:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023c4:	48 89 d1             	mov    %rdx,%rcx
  8023c7:	48 89 c2             	mov    %rax,%rdx
  8023ca:	be 01 00 00 00       	mov    $0x1,%esi
  8023cf:	bf 0a 00 00 00       	mov    $0xa,%edi
  8023d4:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  8023db:	00 00 00 
  8023de:	ff d0                	callq  *%rax
}
  8023e0:	c9                   	leaveq 
  8023e1:	c3                   	retq   

00000000008023e2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8023e2:	55                   	push   %rbp
  8023e3:	48 89 e5             	mov    %rsp,%rbp
  8023e6:	48 83 ec 20          	sub    $0x20,%rsp
  8023ea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8023f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8023f5:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8023f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023fb:	48 63 f0             	movslq %eax,%rsi
  8023fe:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802402:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802405:	48 98                	cltq   
  802407:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80240b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802412:	00 
  802413:	49 89 f1             	mov    %rsi,%r9
  802416:	49 89 c8             	mov    %rcx,%r8
  802419:	48 89 d1             	mov    %rdx,%rcx
  80241c:	48 89 c2             	mov    %rax,%rdx
  80241f:	be 00 00 00 00       	mov    $0x0,%esi
  802424:	bf 0c 00 00 00       	mov    $0xc,%edi
  802429:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  802430:	00 00 00 
  802433:	ff d0                	callq  *%rax
}
  802435:	c9                   	leaveq 
  802436:	c3                   	retq   

0000000000802437 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802437:	55                   	push   %rbp
  802438:	48 89 e5             	mov    %rsp,%rbp
  80243b:	48 83 ec 10          	sub    $0x10,%rsp
  80243f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802443:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802447:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80244e:	00 
  80244f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802455:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80245b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802460:	48 89 c2             	mov    %rax,%rdx
  802463:	be 01 00 00 00       	mov    $0x1,%esi
  802468:	bf 0d 00 00 00       	mov    $0xd,%edi
  80246d:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  802474:	00 00 00 
  802477:	ff d0                	callq  *%rax
}
  802479:	c9                   	leaveq 
  80247a:	c3                   	retq   

000000000080247b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  80247b:	55                   	push   %rbp
  80247c:	48 89 e5             	mov    %rsp,%rbp
  80247f:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802483:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80248a:	00 
  80248b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802491:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802497:	b9 00 00 00 00       	mov    $0x0,%ecx
  80249c:	ba 00 00 00 00       	mov    $0x0,%edx
  8024a1:	be 00 00 00 00       	mov    $0x0,%esi
  8024a6:	bf 0e 00 00 00       	mov    $0xe,%edi
  8024ab:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  8024b2:	00 00 00 
  8024b5:	ff d0                	callq  *%rax
}
  8024b7:	c9                   	leaveq 
  8024b8:	c3                   	retq   

00000000008024b9 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  8024b9:	55                   	push   %rbp
  8024ba:	48 89 e5             	mov    %rsp,%rbp
  8024bd:	48 83 ec 20          	sub    $0x20,%rsp
  8024c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8024c5:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  8024c8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8024cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024cf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8024d6:	00 
  8024d7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8024dd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8024e3:	48 89 d1             	mov    %rdx,%rcx
  8024e6:	48 89 c2             	mov    %rax,%rdx
  8024e9:	be 00 00 00 00       	mov    $0x0,%esi
  8024ee:	bf 0f 00 00 00       	mov    $0xf,%edi
  8024f3:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  8024fa:	00 00 00 
  8024fd:	ff d0                	callq  *%rax
}
  8024ff:	c9                   	leaveq 
  802500:	c3                   	retq   

0000000000802501 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  802501:	55                   	push   %rbp
  802502:	48 89 e5             	mov    %rsp,%rbp
  802505:	48 83 ec 20          	sub    $0x20,%rsp
  802509:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80250d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  802510:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802513:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802517:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80251e:	00 
  80251f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802525:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80252b:	48 89 d1             	mov    %rdx,%rcx
  80252e:	48 89 c2             	mov    %rax,%rdx
  802531:	be 00 00 00 00       	mov    $0x0,%esi
  802536:	bf 10 00 00 00       	mov    $0x10,%edi
  80253b:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  802542:	00 00 00 
  802545:	ff d0                	callq  *%rax
}
  802547:	c9                   	leaveq 
  802548:	c3                   	retq   

0000000000802549 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802549:	55                   	push   %rbp
  80254a:	48 89 e5             	mov    %rsp,%rbp
  80254d:	48 83 ec 30          	sub    $0x30,%rsp
  802551:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802554:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802558:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80255b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80255f:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802563:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802566:	48 63 c8             	movslq %eax,%rcx
  802569:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80256d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802570:	48 63 f0             	movslq %eax,%rsi
  802573:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802577:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80257a:	48 98                	cltq   
  80257c:	48 89 0c 24          	mov    %rcx,(%rsp)
  802580:	49 89 f9             	mov    %rdi,%r9
  802583:	49 89 f0             	mov    %rsi,%r8
  802586:	48 89 d1             	mov    %rdx,%rcx
  802589:	48 89 c2             	mov    %rax,%rdx
  80258c:	be 00 00 00 00       	mov    $0x0,%esi
  802591:	bf 11 00 00 00       	mov    $0x11,%edi
  802596:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  80259d:	00 00 00 
  8025a0:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  8025a2:	c9                   	leaveq 
  8025a3:	c3                   	retq   

00000000008025a4 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  8025a4:	55                   	push   %rbp
  8025a5:	48 89 e5             	mov    %rsp,%rbp
  8025a8:	48 83 ec 20          	sub    $0x20,%rsp
  8025ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8025b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  8025b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025bc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8025c3:	00 
  8025c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8025ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025d0:	48 89 d1             	mov    %rdx,%rcx
  8025d3:	48 89 c2             	mov    %rax,%rdx
  8025d6:	be 00 00 00 00       	mov    $0x0,%esi
  8025db:	bf 12 00 00 00       	mov    $0x12,%edi
  8025e0:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  8025e7:	00 00 00 
  8025ea:	ff d0                	callq  *%rax
}
  8025ec:	c9                   	leaveq 
  8025ed:	c3                   	retq   

00000000008025ee <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8025ee:	55                   	push   %rbp
  8025ef:	48 89 e5             	mov    %rsp,%rbp
  8025f2:	48 83 ec 30          	sub    $0x30,%rsp
  8025f6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  8025fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025fe:	48 8b 00             	mov    (%rax),%rax
  802601:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  802605:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802609:	48 8b 40 08          	mov    0x8(%rax),%rax
  80260d:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  802610:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802613:	83 e0 02             	and    $0x2,%eax
  802616:	85 c0                	test   %eax,%eax
  802618:	75 40                	jne    80265a <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  80261a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80261e:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  802625:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802629:	49 89 d0             	mov    %rdx,%r8
  80262c:	48 89 c1             	mov    %rax,%rcx
  80262f:	48 ba b8 5d 80 00 00 	movabs $0x805db8,%rdx
  802636:	00 00 00 
  802639:	be 1f 00 00 00       	mov    $0x1f,%esi
  80263e:	48 bf d1 5d 80 00 00 	movabs $0x805dd1,%rdi
  802645:	00 00 00 
  802648:	b8 00 00 00 00       	mov    $0x0,%eax
  80264d:	49 b9 f1 0a 80 00 00 	movabs $0x800af1,%r9
  802654:	00 00 00 
  802657:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  80265a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80265e:	48 c1 e8 0c          	shr    $0xc,%rax
  802662:	48 89 c2             	mov    %rax,%rdx
  802665:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80266c:	01 00 00 
  80266f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802673:	25 07 08 00 00       	and    $0x807,%eax
  802678:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  80267e:	74 4e                	je     8026ce <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  802680:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802684:	48 c1 e8 0c          	shr    $0xc,%rax
  802688:	48 89 c2             	mov    %rax,%rdx
  80268b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802692:	01 00 00 
  802695:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802699:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80269d:	49 89 d0             	mov    %rdx,%r8
  8026a0:	48 89 c1             	mov    %rax,%rcx
  8026a3:	48 ba e0 5d 80 00 00 	movabs $0x805de0,%rdx
  8026aa:	00 00 00 
  8026ad:	be 22 00 00 00       	mov    $0x22,%esi
  8026b2:	48 bf d1 5d 80 00 00 	movabs $0x805dd1,%rdi
  8026b9:	00 00 00 
  8026bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c1:	49 b9 f1 0a 80 00 00 	movabs $0x800af1,%r9
  8026c8:	00 00 00 
  8026cb:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8026ce:	ba 07 00 00 00       	mov    $0x7,%edx
  8026d3:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8026d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8026dd:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  8026e4:	00 00 00 
  8026e7:	ff d0                	callq  *%rax
  8026e9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8026ec:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8026f0:	79 30                	jns    802722 <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  8026f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026f5:	89 c1                	mov    %eax,%ecx
  8026f7:	48 ba 0b 5e 80 00 00 	movabs $0x805e0b,%rdx
  8026fe:	00 00 00 
  802701:	be 28 00 00 00       	mov    $0x28,%esi
  802706:	48 bf d1 5d 80 00 00 	movabs $0x805dd1,%rdi
  80270d:	00 00 00 
  802710:	b8 00 00 00 00       	mov    $0x0,%eax
  802715:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  80271c:	00 00 00 
  80271f:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  802722:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802726:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  80272a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80272e:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802734:	ba 00 10 00 00       	mov    $0x1000,%edx
  802739:	48 89 c6             	mov    %rax,%rsi
  80273c:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802741:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  802748:	00 00 00 
  80274b:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80274d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802751:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802755:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802759:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80275f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802765:	48 89 c1             	mov    %rax,%rcx
  802768:	ba 00 00 00 00       	mov    $0x0,%edx
  80276d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802772:	bf 00 00 00 00       	mov    $0x0,%edi
  802777:	48 b8 5e 22 80 00 00 	movabs $0x80225e,%rax
  80277e:	00 00 00 
  802781:	ff d0                	callq  *%rax
  802783:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802786:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80278a:	79 30                	jns    8027bc <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  80278c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80278f:	89 c1                	mov    %eax,%ecx
  802791:	48 ba 1e 5e 80 00 00 	movabs $0x805e1e,%rdx
  802798:	00 00 00 
  80279b:	be 2d 00 00 00       	mov    $0x2d,%esi
  8027a0:	48 bf d1 5d 80 00 00 	movabs $0x805dd1,%rdi
  8027a7:	00 00 00 
  8027aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8027af:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  8027b6:	00 00 00 
  8027b9:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  8027bc:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8027c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8027c6:	48 b8 b9 22 80 00 00 	movabs $0x8022b9,%rax
  8027cd:	00 00 00 
  8027d0:	ff d0                	callq  *%rax
  8027d2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8027d5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027d9:	79 30                	jns    80280b <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  8027db:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027de:	89 c1                	mov    %eax,%ecx
  8027e0:	48 ba 2f 5e 80 00 00 	movabs $0x805e2f,%rdx
  8027e7:	00 00 00 
  8027ea:	be 31 00 00 00       	mov    $0x31,%esi
  8027ef:	48 bf d1 5d 80 00 00 	movabs $0x805dd1,%rdi
  8027f6:	00 00 00 
  8027f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fe:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  802805:	00 00 00 
  802808:	41 ff d0             	callq  *%r8

}
  80280b:	c9                   	leaveq 
  80280c:	c3                   	retq   

000000000080280d <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80280d:	55                   	push   %rbp
  80280e:	48 89 e5             	mov    %rsp,%rbp
  802811:	48 83 ec 30          	sub    $0x30,%rsp
  802815:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802818:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  80281b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80281e:	c1 e0 0c             	shl    $0xc,%eax
  802821:	89 c0                	mov    %eax,%eax
  802823:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  802827:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80282e:	01 00 00 
  802831:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802834:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802838:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  80283c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802840:	25 02 08 00 00       	and    $0x802,%eax
  802845:	48 85 c0             	test   %rax,%rax
  802848:	74 0e                	je     802858 <duppage+0x4b>
  80284a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284e:	25 00 04 00 00       	and    $0x400,%eax
  802853:	48 85 c0             	test   %rax,%rax
  802856:	74 70                	je     8028c8 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  802858:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80285c:	25 07 0e 00 00       	and    $0xe07,%eax
  802861:	89 c6                	mov    %eax,%esi
  802863:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802867:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80286a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80286e:	41 89 f0             	mov    %esi,%r8d
  802871:	48 89 c6             	mov    %rax,%rsi
  802874:	bf 00 00 00 00       	mov    $0x0,%edi
  802879:	48 b8 5e 22 80 00 00 	movabs $0x80225e,%rax
  802880:	00 00 00 
  802883:	ff d0                	callq  *%rax
  802885:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802888:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80288c:	79 30                	jns    8028be <duppage+0xb1>
			panic("sys_page_map: %e", r);
  80288e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802891:	89 c1                	mov    %eax,%ecx
  802893:	48 ba 1e 5e 80 00 00 	movabs $0x805e1e,%rdx
  80289a:	00 00 00 
  80289d:	be 50 00 00 00       	mov    $0x50,%esi
  8028a2:	48 bf d1 5d 80 00 00 	movabs $0x805dd1,%rdi
  8028a9:	00 00 00 
  8028ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b1:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  8028b8:	00 00 00 
  8028bb:	41 ff d0             	callq  *%r8
		return 0;
  8028be:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c3:	e9 c4 00 00 00       	jmpq   80298c <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  8028c8:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8028cc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028d3:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8028d9:	48 89 c6             	mov    %rax,%rsi
  8028dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8028e1:	48 b8 5e 22 80 00 00 	movabs $0x80225e,%rax
  8028e8:	00 00 00 
  8028eb:	ff d0                	callq  *%rax
  8028ed:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8028f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8028f4:	79 30                	jns    802926 <duppage+0x119>
		panic("sys_page_map: %e", r);
  8028f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028f9:	89 c1                	mov    %eax,%ecx
  8028fb:	48 ba 1e 5e 80 00 00 	movabs $0x805e1e,%rdx
  802902:	00 00 00 
  802905:	be 64 00 00 00       	mov    $0x64,%esi
  80290a:	48 bf d1 5d 80 00 00 	movabs $0x805dd1,%rdi
  802911:	00 00 00 
  802914:	b8 00 00 00 00       	mov    $0x0,%eax
  802919:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  802920:	00 00 00 
  802923:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802926:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80292a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80292e:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802934:	48 89 d1             	mov    %rdx,%rcx
  802937:	ba 00 00 00 00       	mov    $0x0,%edx
  80293c:	48 89 c6             	mov    %rax,%rsi
  80293f:	bf 00 00 00 00       	mov    $0x0,%edi
  802944:	48 b8 5e 22 80 00 00 	movabs $0x80225e,%rax
  80294b:	00 00 00 
  80294e:	ff d0                	callq  *%rax
  802950:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802953:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802957:	79 30                	jns    802989 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  802959:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80295c:	89 c1                	mov    %eax,%ecx
  80295e:	48 ba 1e 5e 80 00 00 	movabs $0x805e1e,%rdx
  802965:	00 00 00 
  802968:	be 66 00 00 00       	mov    $0x66,%esi
  80296d:	48 bf d1 5d 80 00 00 	movabs $0x805dd1,%rdi
  802974:	00 00 00 
  802977:	b8 00 00 00 00       	mov    $0x0,%eax
  80297c:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  802983:	00 00 00 
  802986:	41 ff d0             	callq  *%r8
	return r;
  802989:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  80298c:	c9                   	leaveq 
  80298d:	c3                   	retq   

000000000080298e <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80298e:	55                   	push   %rbp
  80298f:	48 89 e5             	mov    %rsp,%rbp
  802992:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  802996:	48 bf ee 25 80 00 00 	movabs $0x8025ee,%rdi
  80299d:	00 00 00 
  8029a0:	48 b8 f5 4f 80 00 00 	movabs $0x804ff5,%rax
  8029a7:	00 00 00 
  8029aa:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8029ac:	b8 07 00 00 00       	mov    $0x7,%eax
  8029b1:	cd 30                	int    $0x30
  8029b3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8029b6:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  8029b9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  8029bc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029c0:	79 08                	jns    8029ca <fork+0x3c>
		return envid;
  8029c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029c5:	e9 09 02 00 00       	jmpq   802bd3 <fork+0x245>
	if (envid == 0) {
  8029ca:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029ce:	75 3e                	jne    802a0e <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  8029d0:	48 b8 92 21 80 00 00 	movabs $0x802192,%rax
  8029d7:	00 00 00 
  8029da:	ff d0                	callq  *%rax
  8029dc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8029e1:	48 98                	cltq   
  8029e3:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8029ea:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8029f1:	00 00 00 
  8029f4:	48 01 c2             	add    %rax,%rdx
  8029f7:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8029fe:	00 00 00 
  802a01:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802a04:	b8 00 00 00 00       	mov    $0x0,%eax
  802a09:	e9 c5 01 00 00       	jmpq   802bd3 <fork+0x245>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  802a0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a15:	e9 a4 00 00 00       	jmpq   802abe <fork+0x130>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  802a1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1d:	c1 f8 12             	sar    $0x12,%eax
  802a20:	89 c2                	mov    %eax,%edx
  802a22:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802a29:	01 00 00 
  802a2c:	48 63 d2             	movslq %edx,%rdx
  802a2f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a33:	83 e0 01             	and    $0x1,%eax
  802a36:	48 85 c0             	test   %rax,%rax
  802a39:	74 21                	je     802a5c <fork+0xce>
  802a3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3e:	c1 f8 09             	sar    $0x9,%eax
  802a41:	89 c2                	mov    %eax,%edx
  802a43:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a4a:	01 00 00 
  802a4d:	48 63 d2             	movslq %edx,%rdx
  802a50:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a54:	83 e0 01             	and    $0x1,%eax
  802a57:	48 85 c0             	test   %rax,%rax
  802a5a:	75 09                	jne    802a65 <fork+0xd7>
			pn += NPTENTRIES;
  802a5c:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  802a63:	eb 59                	jmp    802abe <fork+0x130>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802a65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a68:	05 00 02 00 00       	add    $0x200,%eax
  802a6d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802a70:	eb 44                	jmp    802ab6 <fork+0x128>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  802a72:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a79:	01 00 00 
  802a7c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a7f:	48 63 d2             	movslq %edx,%rdx
  802a82:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a86:	83 e0 05             	and    $0x5,%eax
  802a89:	48 83 f8 05          	cmp    $0x5,%rax
  802a8d:	74 02                	je     802a91 <fork+0x103>
				continue;
  802a8f:	eb 21                	jmp    802ab2 <fork+0x124>
			if (pn == PPN(UXSTACKTOP - 1))
  802a91:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  802a98:	75 02                	jne    802a9c <fork+0x10e>
				continue;
  802a9a:	eb 16                	jmp    802ab2 <fork+0x124>
			duppage(envid, pn);
  802a9c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a9f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802aa2:	89 d6                	mov    %edx,%esi
  802aa4:	89 c7                	mov    %eax,%edi
  802aa6:	48 b8 0d 28 80 00 00 	movabs $0x80280d,%rax
  802aad:	00 00 00 
  802ab0:	ff d0                	callq  *%rax
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802ab2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ab6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab9:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  802abc:	7c b4                	jl     802a72 <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  802abe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac1:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  802ac6:	0f 86 4e ff ff ff    	jbe    802a1a <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802acc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802acf:	ba 07 00 00 00       	mov    $0x7,%edx
  802ad4:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802ad9:	89 c7                	mov    %eax,%edi
  802adb:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  802ae2:	00 00 00 
  802ae5:	ff d0                	callq  *%rax
  802ae7:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802aea:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802aee:	79 30                	jns    802b20 <fork+0x192>
		panic("allocating exception stack: %e", r);
  802af0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802af3:	89 c1                	mov    %eax,%ecx
  802af5:	48 ba 48 5e 80 00 00 	movabs $0x805e48,%rdx
  802afc:	00 00 00 
  802aff:	be 9e 00 00 00       	mov    $0x9e,%esi
  802b04:	48 bf d1 5d 80 00 00 	movabs $0x805dd1,%rdi
  802b0b:	00 00 00 
  802b0e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b13:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  802b1a:	00 00 00 
  802b1d:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  802b20:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802b27:	00 00 00 
  802b2a:	48 8b 00             	mov    (%rax),%rax
  802b2d:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802b34:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b37:	48 89 d6             	mov    %rdx,%rsi
  802b3a:	89 c7                	mov    %eax,%edi
  802b3c:	48 b8 98 23 80 00 00 	movabs $0x802398,%rax
  802b43:	00 00 00 
  802b46:	ff d0                	callq  *%rax
  802b48:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802b4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802b4f:	79 30                	jns    802b81 <fork+0x1f3>
		panic("sys_env_set_pgfault_upcall: %e", r);
  802b51:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b54:	89 c1                	mov    %eax,%ecx
  802b56:	48 ba 68 5e 80 00 00 	movabs $0x805e68,%rdx
  802b5d:	00 00 00 
  802b60:	be a2 00 00 00       	mov    $0xa2,%esi
  802b65:	48 bf d1 5d 80 00 00 	movabs $0x805dd1,%rdi
  802b6c:	00 00 00 
  802b6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b74:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  802b7b:	00 00 00 
  802b7e:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  802b81:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b84:	be 02 00 00 00       	mov    $0x2,%esi
  802b89:	89 c7                	mov    %eax,%edi
  802b8b:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  802b92:	00 00 00 
  802b95:	ff d0                	callq  *%rax
  802b97:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802b9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802b9e:	79 30                	jns    802bd0 <fork+0x242>
		panic("sys_env_set_status: %e", r);
  802ba0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802ba3:	89 c1                	mov    %eax,%ecx
  802ba5:	48 ba 87 5e 80 00 00 	movabs $0x805e87,%rdx
  802bac:	00 00 00 
  802baf:	be a7 00 00 00       	mov    $0xa7,%esi
  802bb4:	48 bf d1 5d 80 00 00 	movabs $0x805dd1,%rdi
  802bbb:	00 00 00 
  802bbe:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc3:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  802bca:	00 00 00 
  802bcd:	41 ff d0             	callq  *%r8

	return envid;
  802bd0:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  802bd3:	c9                   	leaveq 
  802bd4:	c3                   	retq   

0000000000802bd5 <sfork>:

// Challenge!
int
sfork(void)
{
  802bd5:	55                   	push   %rbp
  802bd6:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802bd9:	48 ba 9e 5e 80 00 00 	movabs $0x805e9e,%rdx
  802be0:	00 00 00 
  802be3:	be b1 00 00 00       	mov    $0xb1,%esi
  802be8:	48 bf d1 5d 80 00 00 	movabs $0x805dd1,%rdi
  802bef:	00 00 00 
  802bf2:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf7:	48 b9 f1 0a 80 00 00 	movabs $0x800af1,%rcx
  802bfe:	00 00 00 
  802c01:	ff d1                	callq  *%rcx

0000000000802c03 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802c03:	55                   	push   %rbp
  802c04:	48 89 e5             	mov    %rsp,%rbp
  802c07:	48 83 ec 30          	sub    $0x30,%rsp
  802c0b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c0f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c13:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  802c17:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c1c:	75 0e                	jne    802c2c <ipc_recv+0x29>
		pg = (void*) UTOP;
  802c1e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802c25:	00 00 00 
  802c28:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  802c2c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c30:	48 89 c7             	mov    %rax,%rdi
  802c33:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  802c3a:	00 00 00 
  802c3d:	ff d0                	callq  *%rax
  802c3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c46:	79 27                	jns    802c6f <ipc_recv+0x6c>
		if (from_env_store)
  802c48:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802c4d:	74 0a                	je     802c59 <ipc_recv+0x56>
			*from_env_store = 0;
  802c4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c53:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  802c59:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802c5e:	74 0a                	je     802c6a <ipc_recv+0x67>
			*perm_store = 0;
  802c60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c64:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  802c6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c6d:	eb 53                	jmp    802cc2 <ipc_recv+0xbf>
	}
	if (from_env_store)
  802c6f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802c74:	74 19                	je     802c8f <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  802c76:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802c7d:	00 00 00 
  802c80:	48 8b 00             	mov    (%rax),%rax
  802c83:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802c89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c8d:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  802c8f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802c94:	74 19                	je     802caf <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  802c96:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802c9d:	00 00 00 
  802ca0:	48 8b 00             	mov    (%rax),%rax
  802ca3:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802ca9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cad:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  802caf:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802cb6:	00 00 00 
  802cb9:	48 8b 00             	mov    (%rax),%rax
  802cbc:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  802cc2:	c9                   	leaveq 
  802cc3:	c3                   	retq   

0000000000802cc4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802cc4:	55                   	push   %rbp
  802cc5:	48 89 e5             	mov    %rsp,%rbp
  802cc8:	48 83 ec 30          	sub    $0x30,%rsp
  802ccc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ccf:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802cd2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802cd6:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  802cd9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802cde:	75 10                	jne    802cf0 <ipc_send+0x2c>
		pg = (void*) UTOP;
  802ce0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802ce7:	00 00 00 
  802cea:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802cee:	eb 0e                	jmp    802cfe <ipc_send+0x3a>
  802cf0:	eb 0c                	jmp    802cfe <ipc_send+0x3a>
		sys_yield();
  802cf2:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  802cf9:	00 00 00 
  802cfc:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802cfe:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802d01:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802d04:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d08:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d0b:	89 c7                	mov    %eax,%edi
  802d0d:	48 b8 e2 23 80 00 00 	movabs $0x8023e2,%rax
  802d14:	00 00 00 
  802d17:	ff d0                	callq  *%rax
  802d19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d1c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802d20:	74 d0                	je     802cf2 <ipc_send+0x2e>
		sys_yield();
	}
	if (r < 0)
  802d22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d26:	79 30                	jns    802d58 <ipc_send+0x94>
		panic("error in ipc_send: %e", r);
  802d28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d2b:	89 c1                	mov    %eax,%ecx
  802d2d:	48 ba b4 5e 80 00 00 	movabs $0x805eb4,%rdx
  802d34:	00 00 00 
  802d37:	be 47 00 00 00       	mov    $0x47,%esi
  802d3c:	48 bf ca 5e 80 00 00 	movabs $0x805eca,%rdi
  802d43:	00 00 00 
  802d46:	b8 00 00 00 00       	mov    $0x0,%eax
  802d4b:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  802d52:	00 00 00 
  802d55:	41 ff d0             	callq  *%r8

}
  802d58:	c9                   	leaveq 
  802d59:	c3                   	retq   

0000000000802d5a <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  802d5a:	55                   	push   %rbp
  802d5b:	48 89 e5             	mov    %rsp,%rbp
  802d5e:	53                   	push   %rbx
  802d5f:	48 83 ec 28          	sub    $0x28,%rsp
  802d63:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  802d67:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  802d6e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  802d75:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d7a:	75 0e                	jne    802d8a <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  802d7c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802d83:	00 00 00 
  802d86:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  802d8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d8e:	ba 07 00 00 00       	mov    $0x7,%edx
  802d93:	48 89 c6             	mov    %rax,%rsi
  802d96:	bf 00 00 00 00       	mov    $0x0,%edi
  802d9b:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  802da2:	00 00 00 
  802da5:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  802da7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dab:	48 c1 e8 0c          	shr    $0xc,%rax
  802daf:	48 89 c2             	mov    %rax,%rdx
  802db2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802db9:	01 00 00 
  802dbc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802dc0:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802dc6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  802dca:	b8 03 00 00 00       	mov    $0x3,%eax
  802dcf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802dd3:	48 89 d3             	mov    %rdx,%rbx
  802dd6:	0f 01 c1             	vmcall 
  802dd9:	89 f2                	mov    %esi,%edx
  802ddb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802dde:	89 55 e8             	mov    %edx,-0x18(%rbp)
	/* cprintf("Returned IPC response from host: %d %d\n", r, -val);*/
	if (r < 0) {
  802de1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802de5:	79 05                	jns    802dec <ipc_host_recv+0x92>
		return r;
  802de7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dea:	eb 03                	jmp    802def <ipc_host_recv+0x95>
	}
	return val;
  802dec:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  802def:	48 83 c4 28          	add    $0x28,%rsp
  802df3:	5b                   	pop    %rbx
  802df4:	5d                   	pop    %rbp
  802df5:	c3                   	retq   

0000000000802df6 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802df6:	55                   	push   %rbp
  802df7:	48 89 e5             	mov    %rsp,%rbp
  802dfa:	53                   	push   %rbx
  802dfb:	48 83 ec 38          	sub    $0x38,%rsp
  802dff:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e02:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802e05:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802e09:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  802e0c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  802e13:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  802e18:	75 0e                	jne    802e28 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  802e1a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802e21:	00 00 00 
  802e24:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  802e28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e2c:	48 c1 e8 0c          	shr    $0xc,%rax
  802e30:	48 89 c2             	mov    %rax,%rdx
  802e33:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e3a:	01 00 00 
  802e3d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e41:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802e47:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  802e4b:	b8 02 00 00 00       	mov    $0x2,%eax
  802e50:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802e53:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802e56:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e5a:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802e5d:	89 fb                	mov    %edi,%ebx
  802e5f:	0f 01 c1             	vmcall 
  802e62:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  802e65:	eb 26                	jmp    802e8d <ipc_host_send+0x97>
		sys_yield();
  802e67:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  802e6e:	00 00 00 
  802e71:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  802e73:	b8 02 00 00 00       	mov    $0x2,%eax
  802e78:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802e7b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802e7e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e82:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802e85:	89 fb                	mov    %edi,%ebx
  802e87:	0f 01 c1             	vmcall 
  802e8a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  802e8d:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  802e91:	74 d4                	je     802e67 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  802e93:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e97:	79 30                	jns    802ec9 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  802e99:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e9c:	89 c1                	mov    %eax,%ecx
  802e9e:	48 ba b4 5e 80 00 00 	movabs $0x805eb4,%rdx
  802ea5:	00 00 00 
  802ea8:	be 79 00 00 00       	mov    $0x79,%esi
  802ead:	48 bf ca 5e 80 00 00 	movabs $0x805eca,%rdi
  802eb4:	00 00 00 
  802eb7:	b8 00 00 00 00       	mov    $0x0,%eax
  802ebc:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  802ec3:	00 00 00 
  802ec6:	41 ff d0             	callq  *%r8

}
  802ec9:	48 83 c4 38          	add    $0x38,%rsp
  802ecd:	5b                   	pop    %rbx
  802ece:	5d                   	pop    %rbp
  802ecf:	c3                   	retq   

0000000000802ed0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802ed0:	55                   	push   %rbp
  802ed1:	48 89 e5             	mov    %rsp,%rbp
  802ed4:	48 83 ec 14          	sub    $0x14,%rsp
  802ed8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802edb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ee2:	eb 4e                	jmp    802f32 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  802ee4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802eeb:	00 00 00 
  802eee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef1:	48 98                	cltq   
  802ef3:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802efa:	48 01 d0             	add    %rdx,%rax
  802efd:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802f03:	8b 00                	mov    (%rax),%eax
  802f05:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802f08:	75 24                	jne    802f2e <ipc_find_env+0x5e>
			return envs[i].env_id;
  802f0a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802f11:	00 00 00 
  802f14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f17:	48 98                	cltq   
  802f19:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802f20:	48 01 d0             	add    %rdx,%rax
  802f23:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802f29:	8b 40 08             	mov    0x8(%rax),%eax
  802f2c:	eb 12                	jmp    802f40 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802f2e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802f32:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802f39:	7e a9                	jle    802ee4 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802f3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f40:	c9                   	leaveq 
  802f41:	c3                   	retq   

0000000000802f42 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802f42:	55                   	push   %rbp
  802f43:	48 89 e5             	mov    %rsp,%rbp
  802f46:	48 83 ec 08          	sub    $0x8,%rsp
  802f4a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802f4e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f52:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802f59:	ff ff ff 
  802f5c:	48 01 d0             	add    %rdx,%rax
  802f5f:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802f63:	c9                   	leaveq 
  802f64:	c3                   	retq   

0000000000802f65 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802f65:	55                   	push   %rbp
  802f66:	48 89 e5             	mov    %rsp,%rbp
  802f69:	48 83 ec 08          	sub    $0x8,%rsp
  802f6d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802f71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f75:	48 89 c7             	mov    %rax,%rdi
  802f78:	48 b8 42 2f 80 00 00 	movabs $0x802f42,%rax
  802f7f:	00 00 00 
  802f82:	ff d0                	callq  *%rax
  802f84:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802f8a:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802f8e:	c9                   	leaveq 
  802f8f:	c3                   	retq   

0000000000802f90 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802f90:	55                   	push   %rbp
  802f91:	48 89 e5             	mov    %rsp,%rbp
  802f94:	48 83 ec 18          	sub    $0x18,%rsp
  802f98:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802f9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802fa3:	eb 6b                	jmp    803010 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802fa5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa8:	48 98                	cltq   
  802faa:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802fb0:	48 c1 e0 0c          	shl    $0xc,%rax
  802fb4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802fb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fbc:	48 c1 e8 15          	shr    $0x15,%rax
  802fc0:	48 89 c2             	mov    %rax,%rdx
  802fc3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802fca:	01 00 00 
  802fcd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802fd1:	83 e0 01             	and    $0x1,%eax
  802fd4:	48 85 c0             	test   %rax,%rax
  802fd7:	74 21                	je     802ffa <fd_alloc+0x6a>
  802fd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fdd:	48 c1 e8 0c          	shr    $0xc,%rax
  802fe1:	48 89 c2             	mov    %rax,%rdx
  802fe4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802feb:	01 00 00 
  802fee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ff2:	83 e0 01             	and    $0x1,%eax
  802ff5:	48 85 c0             	test   %rax,%rax
  802ff8:	75 12                	jne    80300c <fd_alloc+0x7c>
			*fd_store = fd;
  802ffa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ffe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803002:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  803005:	b8 00 00 00 00       	mov    $0x0,%eax
  80300a:	eb 1a                	jmp    803026 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80300c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803010:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  803014:	7e 8f                	jle    802fa5 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  803016:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80301a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  803021:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  803026:	c9                   	leaveq 
  803027:	c3                   	retq   

0000000000803028 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  803028:	55                   	push   %rbp
  803029:	48 89 e5             	mov    %rsp,%rbp
  80302c:	48 83 ec 20          	sub    $0x20,%rsp
  803030:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803033:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  803037:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80303b:	78 06                	js     803043 <fd_lookup+0x1b>
  80303d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  803041:	7e 07                	jle    80304a <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  803043:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803048:	eb 6c                	jmp    8030b6 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80304a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80304d:	48 98                	cltq   
  80304f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803055:	48 c1 e0 0c          	shl    $0xc,%rax
  803059:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80305d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803061:	48 c1 e8 15          	shr    $0x15,%rax
  803065:	48 89 c2             	mov    %rax,%rdx
  803068:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80306f:	01 00 00 
  803072:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803076:	83 e0 01             	and    $0x1,%eax
  803079:	48 85 c0             	test   %rax,%rax
  80307c:	74 21                	je     80309f <fd_lookup+0x77>
  80307e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803082:	48 c1 e8 0c          	shr    $0xc,%rax
  803086:	48 89 c2             	mov    %rax,%rdx
  803089:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803090:	01 00 00 
  803093:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803097:	83 e0 01             	and    $0x1,%eax
  80309a:	48 85 c0             	test   %rax,%rax
  80309d:	75 07                	jne    8030a6 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80309f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030a4:	eb 10                	jmp    8030b6 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8030a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030aa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8030ae:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8030b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030b6:	c9                   	leaveq 
  8030b7:	c3                   	retq   

00000000008030b8 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8030b8:	55                   	push   %rbp
  8030b9:	48 89 e5             	mov    %rsp,%rbp
  8030bc:	48 83 ec 30          	sub    $0x30,%rsp
  8030c0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8030c4:	89 f0                	mov    %esi,%eax
  8030c6:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8030c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030cd:	48 89 c7             	mov    %rax,%rdi
  8030d0:	48 b8 42 2f 80 00 00 	movabs $0x802f42,%rax
  8030d7:	00 00 00 
  8030da:	ff d0                	callq  *%rax
  8030dc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030e0:	48 89 d6             	mov    %rdx,%rsi
  8030e3:	89 c7                	mov    %eax,%edi
  8030e5:	48 b8 28 30 80 00 00 	movabs $0x803028,%rax
  8030ec:	00 00 00 
  8030ef:	ff d0                	callq  *%rax
  8030f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030f8:	78 0a                	js     803104 <fd_close+0x4c>
	    || fd != fd2)
  8030fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030fe:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  803102:	74 12                	je     803116 <fd_close+0x5e>
		return (must_exist ? r : 0);
  803104:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  803108:	74 05                	je     80310f <fd_close+0x57>
  80310a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80310d:	eb 05                	jmp    803114 <fd_close+0x5c>
  80310f:	b8 00 00 00 00       	mov    $0x0,%eax
  803114:	eb 69                	jmp    80317f <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  803116:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80311a:	8b 00                	mov    (%rax),%eax
  80311c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803120:	48 89 d6             	mov    %rdx,%rsi
  803123:	89 c7                	mov    %eax,%edi
  803125:	48 b8 81 31 80 00 00 	movabs $0x803181,%rax
  80312c:	00 00 00 
  80312f:	ff d0                	callq  *%rax
  803131:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803134:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803138:	78 2a                	js     803164 <fd_close+0xac>
		if (dev->dev_close)
  80313a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80313e:	48 8b 40 20          	mov    0x20(%rax),%rax
  803142:	48 85 c0             	test   %rax,%rax
  803145:	74 16                	je     80315d <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  803147:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80314b:	48 8b 40 20          	mov    0x20(%rax),%rax
  80314f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803153:	48 89 d7             	mov    %rdx,%rdi
  803156:	ff d0                	callq  *%rax
  803158:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80315b:	eb 07                	jmp    803164 <fd_close+0xac>
		else
			r = 0;
  80315d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  803164:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803168:	48 89 c6             	mov    %rax,%rsi
  80316b:	bf 00 00 00 00       	mov    $0x0,%edi
  803170:	48 b8 b9 22 80 00 00 	movabs $0x8022b9,%rax
  803177:	00 00 00 
  80317a:	ff d0                	callq  *%rax
	return r;
  80317c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80317f:	c9                   	leaveq 
  803180:	c3                   	retq   

0000000000803181 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  803181:	55                   	push   %rbp
  803182:	48 89 e5             	mov    %rsp,%rbp
  803185:	48 83 ec 20          	sub    $0x20,%rsp
  803189:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80318c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  803190:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803197:	eb 41                	jmp    8031da <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  803199:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8031a0:	00 00 00 
  8031a3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031a6:	48 63 d2             	movslq %edx,%rdx
  8031a9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8031ad:	8b 00                	mov    (%rax),%eax
  8031af:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8031b2:	75 22                	jne    8031d6 <dev_lookup+0x55>
			*dev = devtab[i];
  8031b4:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8031bb:	00 00 00 
  8031be:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031c1:	48 63 d2             	movslq %edx,%rdx
  8031c4:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8031c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031cc:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8031cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8031d4:	eb 60                	jmp    803236 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8031d6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8031da:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8031e1:	00 00 00 
  8031e4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031e7:	48 63 d2             	movslq %edx,%rdx
  8031ea:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8031ee:	48 85 c0             	test   %rax,%rax
  8031f1:	75 a6                	jne    803199 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8031f3:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8031fa:	00 00 00 
  8031fd:	48 8b 00             	mov    (%rax),%rax
  803200:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803206:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803209:	89 c6                	mov    %eax,%esi
  80320b:	48 bf d8 5e 80 00 00 	movabs $0x805ed8,%rdi
  803212:	00 00 00 
  803215:	b8 00 00 00 00       	mov    $0x0,%eax
  80321a:	48 b9 2a 0d 80 00 00 	movabs $0x800d2a,%rcx
  803221:	00 00 00 
  803224:	ff d1                	callq  *%rcx
	*dev = 0;
  803226:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80322a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  803231:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  803236:	c9                   	leaveq 
  803237:	c3                   	retq   

0000000000803238 <close>:

int
close(int fdnum)
{
  803238:	55                   	push   %rbp
  803239:	48 89 e5             	mov    %rsp,%rbp
  80323c:	48 83 ec 20          	sub    $0x20,%rsp
  803240:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803243:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803247:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80324a:	48 89 d6             	mov    %rdx,%rsi
  80324d:	89 c7                	mov    %eax,%edi
  80324f:	48 b8 28 30 80 00 00 	movabs $0x803028,%rax
  803256:	00 00 00 
  803259:	ff d0                	callq  *%rax
  80325b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80325e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803262:	79 05                	jns    803269 <close+0x31>
		return r;
  803264:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803267:	eb 18                	jmp    803281 <close+0x49>
	else
		return fd_close(fd, 1);
  803269:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80326d:	be 01 00 00 00       	mov    $0x1,%esi
  803272:	48 89 c7             	mov    %rax,%rdi
  803275:	48 b8 b8 30 80 00 00 	movabs $0x8030b8,%rax
  80327c:	00 00 00 
  80327f:	ff d0                	callq  *%rax
}
  803281:	c9                   	leaveq 
  803282:	c3                   	retq   

0000000000803283 <close_all>:

void
close_all(void)
{
  803283:	55                   	push   %rbp
  803284:	48 89 e5             	mov    %rsp,%rbp
  803287:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80328b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803292:	eb 15                	jmp    8032a9 <close_all+0x26>
		close(i);
  803294:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803297:	89 c7                	mov    %eax,%edi
  803299:	48 b8 38 32 80 00 00 	movabs $0x803238,%rax
  8032a0:	00 00 00 
  8032a3:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8032a5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8032a9:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8032ad:	7e e5                	jle    803294 <close_all+0x11>
		close(i);
}
  8032af:	c9                   	leaveq 
  8032b0:	c3                   	retq   

00000000008032b1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8032b1:	55                   	push   %rbp
  8032b2:	48 89 e5             	mov    %rsp,%rbp
  8032b5:	48 83 ec 40          	sub    $0x40,%rsp
  8032b9:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8032bc:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8032bf:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8032c3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8032c6:	48 89 d6             	mov    %rdx,%rsi
  8032c9:	89 c7                	mov    %eax,%edi
  8032cb:	48 b8 28 30 80 00 00 	movabs $0x803028,%rax
  8032d2:	00 00 00 
  8032d5:	ff d0                	callq  *%rax
  8032d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032de:	79 08                	jns    8032e8 <dup+0x37>
		return r;
  8032e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e3:	e9 70 01 00 00       	jmpq   803458 <dup+0x1a7>
	close(newfdnum);
  8032e8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8032eb:	89 c7                	mov    %eax,%edi
  8032ed:	48 b8 38 32 80 00 00 	movabs $0x803238,%rax
  8032f4:	00 00 00 
  8032f7:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8032f9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8032fc:	48 98                	cltq   
  8032fe:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803304:	48 c1 e0 0c          	shl    $0xc,%rax
  803308:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80330c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803310:	48 89 c7             	mov    %rax,%rdi
  803313:	48 b8 65 2f 80 00 00 	movabs $0x802f65,%rax
  80331a:	00 00 00 
  80331d:	ff d0                	callq  *%rax
  80331f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  803323:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803327:	48 89 c7             	mov    %rax,%rdi
  80332a:	48 b8 65 2f 80 00 00 	movabs $0x802f65,%rax
  803331:	00 00 00 
  803334:	ff d0                	callq  *%rax
  803336:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80333a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80333e:	48 c1 e8 15          	shr    $0x15,%rax
  803342:	48 89 c2             	mov    %rax,%rdx
  803345:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80334c:	01 00 00 
  80334f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803353:	83 e0 01             	and    $0x1,%eax
  803356:	48 85 c0             	test   %rax,%rax
  803359:	74 73                	je     8033ce <dup+0x11d>
  80335b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80335f:	48 c1 e8 0c          	shr    $0xc,%rax
  803363:	48 89 c2             	mov    %rax,%rdx
  803366:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80336d:	01 00 00 
  803370:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803374:	83 e0 01             	and    $0x1,%eax
  803377:	48 85 c0             	test   %rax,%rax
  80337a:	74 52                	je     8033ce <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80337c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803380:	48 c1 e8 0c          	shr    $0xc,%rax
  803384:	48 89 c2             	mov    %rax,%rdx
  803387:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80338e:	01 00 00 
  803391:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803395:	25 07 0e 00 00       	and    $0xe07,%eax
  80339a:	89 c1                	mov    %eax,%ecx
  80339c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8033a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033a4:	41 89 c8             	mov    %ecx,%r8d
  8033a7:	48 89 d1             	mov    %rdx,%rcx
  8033aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8033af:	48 89 c6             	mov    %rax,%rsi
  8033b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8033b7:	48 b8 5e 22 80 00 00 	movabs $0x80225e,%rax
  8033be:	00 00 00 
  8033c1:	ff d0                	callq  *%rax
  8033c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ca:	79 02                	jns    8033ce <dup+0x11d>
			goto err;
  8033cc:	eb 57                	jmp    803425 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8033ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033d2:	48 c1 e8 0c          	shr    $0xc,%rax
  8033d6:	48 89 c2             	mov    %rax,%rdx
  8033d9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8033e0:	01 00 00 
  8033e3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8033e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8033ec:	89 c1                	mov    %eax,%ecx
  8033ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033f6:	41 89 c8             	mov    %ecx,%r8d
  8033f9:	48 89 d1             	mov    %rdx,%rcx
  8033fc:	ba 00 00 00 00       	mov    $0x0,%edx
  803401:	48 89 c6             	mov    %rax,%rsi
  803404:	bf 00 00 00 00       	mov    $0x0,%edi
  803409:	48 b8 5e 22 80 00 00 	movabs $0x80225e,%rax
  803410:	00 00 00 
  803413:	ff d0                	callq  *%rax
  803415:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803418:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80341c:	79 02                	jns    803420 <dup+0x16f>
		goto err;
  80341e:	eb 05                	jmp    803425 <dup+0x174>

	return newfdnum;
  803420:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803423:	eb 33                	jmp    803458 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  803425:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803429:	48 89 c6             	mov    %rax,%rsi
  80342c:	bf 00 00 00 00       	mov    $0x0,%edi
  803431:	48 b8 b9 22 80 00 00 	movabs $0x8022b9,%rax
  803438:	00 00 00 
  80343b:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80343d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803441:	48 89 c6             	mov    %rax,%rsi
  803444:	bf 00 00 00 00       	mov    $0x0,%edi
  803449:	48 b8 b9 22 80 00 00 	movabs $0x8022b9,%rax
  803450:	00 00 00 
  803453:	ff d0                	callq  *%rax
	return r;
  803455:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803458:	c9                   	leaveq 
  803459:	c3                   	retq   

000000000080345a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80345a:	55                   	push   %rbp
  80345b:	48 89 e5             	mov    %rsp,%rbp
  80345e:	48 83 ec 40          	sub    $0x40,%rsp
  803462:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803465:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803469:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80346d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803471:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803474:	48 89 d6             	mov    %rdx,%rsi
  803477:	89 c7                	mov    %eax,%edi
  803479:	48 b8 28 30 80 00 00 	movabs $0x803028,%rax
  803480:	00 00 00 
  803483:	ff d0                	callq  *%rax
  803485:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803488:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80348c:	78 24                	js     8034b2 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80348e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803492:	8b 00                	mov    (%rax),%eax
  803494:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803498:	48 89 d6             	mov    %rdx,%rsi
  80349b:	89 c7                	mov    %eax,%edi
  80349d:	48 b8 81 31 80 00 00 	movabs $0x803181,%rax
  8034a4:	00 00 00 
  8034a7:	ff d0                	callq  *%rax
  8034a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034b0:	79 05                	jns    8034b7 <read+0x5d>
		return r;
  8034b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034b5:	eb 76                	jmp    80352d <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8034b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034bb:	8b 40 08             	mov    0x8(%rax),%eax
  8034be:	83 e0 03             	and    $0x3,%eax
  8034c1:	83 f8 01             	cmp    $0x1,%eax
  8034c4:	75 3a                	jne    803500 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8034c6:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8034cd:	00 00 00 
  8034d0:	48 8b 00             	mov    (%rax),%rax
  8034d3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8034d9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8034dc:	89 c6                	mov    %eax,%esi
  8034de:	48 bf f7 5e 80 00 00 	movabs $0x805ef7,%rdi
  8034e5:	00 00 00 
  8034e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ed:	48 b9 2a 0d 80 00 00 	movabs $0x800d2a,%rcx
  8034f4:	00 00 00 
  8034f7:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8034f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8034fe:	eb 2d                	jmp    80352d <read+0xd3>
	}
	if (!dev->dev_read)
  803500:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803504:	48 8b 40 10          	mov    0x10(%rax),%rax
  803508:	48 85 c0             	test   %rax,%rax
  80350b:	75 07                	jne    803514 <read+0xba>
		return -E_NOT_SUPP;
  80350d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803512:	eb 19                	jmp    80352d <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  803514:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803518:	48 8b 40 10          	mov    0x10(%rax),%rax
  80351c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803520:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803524:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803528:	48 89 cf             	mov    %rcx,%rdi
  80352b:	ff d0                	callq  *%rax
}
  80352d:	c9                   	leaveq 
  80352e:	c3                   	retq   

000000000080352f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80352f:	55                   	push   %rbp
  803530:	48 89 e5             	mov    %rsp,%rbp
  803533:	48 83 ec 30          	sub    $0x30,%rsp
  803537:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80353a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80353e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803542:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803549:	eb 49                	jmp    803594 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80354b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80354e:	48 98                	cltq   
  803550:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803554:	48 29 c2             	sub    %rax,%rdx
  803557:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355a:	48 63 c8             	movslq %eax,%rcx
  80355d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803561:	48 01 c1             	add    %rax,%rcx
  803564:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803567:	48 89 ce             	mov    %rcx,%rsi
  80356a:	89 c7                	mov    %eax,%edi
  80356c:	48 b8 5a 34 80 00 00 	movabs $0x80345a,%rax
  803573:	00 00 00 
  803576:	ff d0                	callq  *%rax
  803578:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80357b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80357f:	79 05                	jns    803586 <readn+0x57>
			return m;
  803581:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803584:	eb 1c                	jmp    8035a2 <readn+0x73>
		if (m == 0)
  803586:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80358a:	75 02                	jne    80358e <readn+0x5f>
			break;
  80358c:	eb 11                	jmp    80359f <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80358e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803591:	01 45 fc             	add    %eax,-0x4(%rbp)
  803594:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803597:	48 98                	cltq   
  803599:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80359d:	72 ac                	jb     80354b <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80359f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8035a2:	c9                   	leaveq 
  8035a3:	c3                   	retq   

00000000008035a4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8035a4:	55                   	push   %rbp
  8035a5:	48 89 e5             	mov    %rsp,%rbp
  8035a8:	48 83 ec 40          	sub    $0x40,%rsp
  8035ac:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8035af:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035b3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8035b7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8035bb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8035be:	48 89 d6             	mov    %rdx,%rsi
  8035c1:	89 c7                	mov    %eax,%edi
  8035c3:	48 b8 28 30 80 00 00 	movabs $0x803028,%rax
  8035ca:	00 00 00 
  8035cd:	ff d0                	callq  *%rax
  8035cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035d6:	78 24                	js     8035fc <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8035d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035dc:	8b 00                	mov    (%rax),%eax
  8035de:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8035e2:	48 89 d6             	mov    %rdx,%rsi
  8035e5:	89 c7                	mov    %eax,%edi
  8035e7:	48 b8 81 31 80 00 00 	movabs $0x803181,%rax
  8035ee:	00 00 00 
  8035f1:	ff d0                	callq  *%rax
  8035f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035fa:	79 05                	jns    803601 <write+0x5d>
		return r;
  8035fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ff:	eb 75                	jmp    803676 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803605:	8b 40 08             	mov    0x8(%rax),%eax
  803608:	83 e0 03             	and    $0x3,%eax
  80360b:	85 c0                	test   %eax,%eax
  80360d:	75 3a                	jne    803649 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80360f:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803616:	00 00 00 
  803619:	48 8b 00             	mov    (%rax),%rax
  80361c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803622:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803625:	89 c6                	mov    %eax,%esi
  803627:	48 bf 13 5f 80 00 00 	movabs $0x805f13,%rdi
  80362e:	00 00 00 
  803631:	b8 00 00 00 00       	mov    $0x0,%eax
  803636:	48 b9 2a 0d 80 00 00 	movabs $0x800d2a,%rcx
  80363d:	00 00 00 
  803640:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803642:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803647:	eb 2d                	jmp    803676 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803649:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80364d:	48 8b 40 18          	mov    0x18(%rax),%rax
  803651:	48 85 c0             	test   %rax,%rax
  803654:	75 07                	jne    80365d <write+0xb9>
		return -E_NOT_SUPP;
  803656:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80365b:	eb 19                	jmp    803676 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80365d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803661:	48 8b 40 18          	mov    0x18(%rax),%rax
  803665:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803669:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80366d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803671:	48 89 cf             	mov    %rcx,%rdi
  803674:	ff d0                	callq  *%rax
}
  803676:	c9                   	leaveq 
  803677:	c3                   	retq   

0000000000803678 <seek>:

int
seek(int fdnum, off_t offset)
{
  803678:	55                   	push   %rbp
  803679:	48 89 e5             	mov    %rsp,%rbp
  80367c:	48 83 ec 18          	sub    $0x18,%rsp
  803680:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803683:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803686:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80368a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80368d:	48 89 d6             	mov    %rdx,%rsi
  803690:	89 c7                	mov    %eax,%edi
  803692:	48 b8 28 30 80 00 00 	movabs $0x803028,%rax
  803699:	00 00 00 
  80369c:	ff d0                	callq  *%rax
  80369e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036a5:	79 05                	jns    8036ac <seek+0x34>
		return r;
  8036a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036aa:	eb 0f                	jmp    8036bb <seek+0x43>
	fd->fd_offset = offset;
  8036ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036b3:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8036b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036bb:	c9                   	leaveq 
  8036bc:	c3                   	retq   

00000000008036bd <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8036bd:	55                   	push   %rbp
  8036be:	48 89 e5             	mov    %rsp,%rbp
  8036c1:	48 83 ec 30          	sub    $0x30,%rsp
  8036c5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8036c8:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8036cb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8036cf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8036d2:	48 89 d6             	mov    %rdx,%rsi
  8036d5:	89 c7                	mov    %eax,%edi
  8036d7:	48 b8 28 30 80 00 00 	movabs $0x803028,%rax
  8036de:	00 00 00 
  8036e1:	ff d0                	callq  *%rax
  8036e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ea:	78 24                	js     803710 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8036ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036f0:	8b 00                	mov    (%rax),%eax
  8036f2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8036f6:	48 89 d6             	mov    %rdx,%rsi
  8036f9:	89 c7                	mov    %eax,%edi
  8036fb:	48 b8 81 31 80 00 00 	movabs $0x803181,%rax
  803702:	00 00 00 
  803705:	ff d0                	callq  *%rax
  803707:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80370a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80370e:	79 05                	jns    803715 <ftruncate+0x58>
		return r;
  803710:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803713:	eb 72                	jmp    803787 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803715:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803719:	8b 40 08             	mov    0x8(%rax),%eax
  80371c:	83 e0 03             	and    $0x3,%eax
  80371f:	85 c0                	test   %eax,%eax
  803721:	75 3a                	jne    80375d <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803723:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80372a:	00 00 00 
  80372d:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803730:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803736:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803739:	89 c6                	mov    %eax,%esi
  80373b:	48 bf 30 5f 80 00 00 	movabs $0x805f30,%rdi
  803742:	00 00 00 
  803745:	b8 00 00 00 00       	mov    $0x0,%eax
  80374a:	48 b9 2a 0d 80 00 00 	movabs $0x800d2a,%rcx
  803751:	00 00 00 
  803754:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803756:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80375b:	eb 2a                	jmp    803787 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80375d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803761:	48 8b 40 30          	mov    0x30(%rax),%rax
  803765:	48 85 c0             	test   %rax,%rax
  803768:	75 07                	jne    803771 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80376a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80376f:	eb 16                	jmp    803787 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803771:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803775:	48 8b 40 30          	mov    0x30(%rax),%rax
  803779:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80377d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803780:	89 ce                	mov    %ecx,%esi
  803782:	48 89 d7             	mov    %rdx,%rdi
  803785:	ff d0                	callq  *%rax
}
  803787:	c9                   	leaveq 
  803788:	c3                   	retq   

0000000000803789 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803789:	55                   	push   %rbp
  80378a:	48 89 e5             	mov    %rsp,%rbp
  80378d:	48 83 ec 30          	sub    $0x30,%rsp
  803791:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803794:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803798:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80379c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80379f:	48 89 d6             	mov    %rdx,%rsi
  8037a2:	89 c7                	mov    %eax,%edi
  8037a4:	48 b8 28 30 80 00 00 	movabs $0x803028,%rax
  8037ab:	00 00 00 
  8037ae:	ff d0                	callq  *%rax
  8037b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037b7:	78 24                	js     8037dd <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8037b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037bd:	8b 00                	mov    (%rax),%eax
  8037bf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8037c3:	48 89 d6             	mov    %rdx,%rsi
  8037c6:	89 c7                	mov    %eax,%edi
  8037c8:	48 b8 81 31 80 00 00 	movabs $0x803181,%rax
  8037cf:	00 00 00 
  8037d2:	ff d0                	callq  *%rax
  8037d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037db:	79 05                	jns    8037e2 <fstat+0x59>
		return r;
  8037dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e0:	eb 5e                	jmp    803840 <fstat+0xb7>
	if (!dev->dev_stat)
  8037e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037e6:	48 8b 40 28          	mov    0x28(%rax),%rax
  8037ea:	48 85 c0             	test   %rax,%rax
  8037ed:	75 07                	jne    8037f6 <fstat+0x6d>
		return -E_NOT_SUPP;
  8037ef:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8037f4:	eb 4a                	jmp    803840 <fstat+0xb7>
	stat->st_name[0] = 0;
  8037f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037fa:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8037fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803801:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803808:	00 00 00 
	stat->st_isdir = 0;
  80380b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80380f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803816:	00 00 00 
	stat->st_dev = dev;
  803819:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80381d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803821:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803828:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80382c:	48 8b 40 28          	mov    0x28(%rax),%rax
  803830:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803834:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803838:	48 89 ce             	mov    %rcx,%rsi
  80383b:	48 89 d7             	mov    %rdx,%rdi
  80383e:	ff d0                	callq  *%rax
}
  803840:	c9                   	leaveq 
  803841:	c3                   	retq   

0000000000803842 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803842:	55                   	push   %rbp
  803843:	48 89 e5             	mov    %rsp,%rbp
  803846:	48 83 ec 20          	sub    $0x20,%rsp
  80384a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80384e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803852:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803856:	be 00 00 00 00       	mov    $0x0,%esi
  80385b:	48 89 c7             	mov    %rax,%rdi
  80385e:	48 b8 30 39 80 00 00 	movabs $0x803930,%rax
  803865:	00 00 00 
  803868:	ff d0                	callq  *%rax
  80386a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80386d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803871:	79 05                	jns    803878 <stat+0x36>
		return fd;
  803873:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803876:	eb 2f                	jmp    8038a7 <stat+0x65>
	r = fstat(fd, stat);
  803878:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80387c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80387f:	48 89 d6             	mov    %rdx,%rsi
  803882:	89 c7                	mov    %eax,%edi
  803884:	48 b8 89 37 80 00 00 	movabs $0x803789,%rax
  80388b:	00 00 00 
  80388e:	ff d0                	callq  *%rax
  803890:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803893:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803896:	89 c7                	mov    %eax,%edi
  803898:	48 b8 38 32 80 00 00 	movabs $0x803238,%rax
  80389f:	00 00 00 
  8038a2:	ff d0                	callq  *%rax
	return r;
  8038a4:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8038a7:	c9                   	leaveq 
  8038a8:	c3                   	retq   

00000000008038a9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8038a9:	55                   	push   %rbp
  8038aa:	48 89 e5             	mov    %rsp,%rbp
  8038ad:	48 83 ec 10          	sub    $0x10,%rsp
  8038b1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8038b8:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8038bf:	00 00 00 
  8038c2:	8b 00                	mov    (%rax),%eax
  8038c4:	85 c0                	test   %eax,%eax
  8038c6:	75 1d                	jne    8038e5 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8038c8:	bf 01 00 00 00       	mov    $0x1,%edi
  8038cd:	48 b8 d0 2e 80 00 00 	movabs $0x802ed0,%rax
  8038d4:	00 00 00 
  8038d7:	ff d0                	callq  *%rax
  8038d9:	48 ba 08 90 80 00 00 	movabs $0x809008,%rdx
  8038e0:	00 00 00 
  8038e3:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8038e5:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8038ec:	00 00 00 
  8038ef:	8b 00                	mov    (%rax),%eax
  8038f1:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8038f4:	b9 07 00 00 00       	mov    $0x7,%ecx
  8038f9:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803900:	00 00 00 
  803903:	89 c7                	mov    %eax,%edi
  803905:	48 b8 c4 2c 80 00 00 	movabs $0x802cc4,%rax
  80390c:	00 00 00 
  80390f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803911:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803915:	ba 00 00 00 00       	mov    $0x0,%edx
  80391a:	48 89 c6             	mov    %rax,%rsi
  80391d:	bf 00 00 00 00       	mov    $0x0,%edi
  803922:	48 b8 03 2c 80 00 00 	movabs $0x802c03,%rax
  803929:	00 00 00 
  80392c:	ff d0                	callq  *%rax
}
  80392e:	c9                   	leaveq 
  80392f:	c3                   	retq   

0000000000803930 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803930:	55                   	push   %rbp
  803931:	48 89 e5             	mov    %rsp,%rbp
  803934:	48 83 ec 20          	sub    $0x20,%rsp
  803938:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80393c:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80393f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803943:	48 89 c7             	mov    %rax,%rdi
  803946:	48 b8 73 18 80 00 00 	movabs $0x801873,%rax
  80394d:	00 00 00 
  803950:	ff d0                	callq  *%rax
  803952:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803957:	7e 0a                	jle    803963 <open+0x33>
		return -E_BAD_PATH;
  803959:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80395e:	e9 a5 00 00 00       	jmpq   803a08 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  803963:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803967:	48 89 c7             	mov    %rax,%rdi
  80396a:	48 b8 90 2f 80 00 00 	movabs $0x802f90,%rax
  803971:	00 00 00 
  803974:	ff d0                	callq  *%rax
  803976:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803979:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80397d:	79 08                	jns    803987 <open+0x57>
		return r;
  80397f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803982:	e9 81 00 00 00       	jmpq   803a08 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  803987:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80398b:	48 89 c6             	mov    %rax,%rsi
  80398e:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  803995:	00 00 00 
  803998:	48 b8 df 18 80 00 00 	movabs $0x8018df,%rax
  80399f:	00 00 00 
  8039a2:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8039a4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039ab:	00 00 00 
  8039ae:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8039b1:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8039b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039bb:	48 89 c6             	mov    %rax,%rsi
  8039be:	bf 01 00 00 00       	mov    $0x1,%edi
  8039c3:	48 b8 a9 38 80 00 00 	movabs $0x8038a9,%rax
  8039ca:	00 00 00 
  8039cd:	ff d0                	callq  *%rax
  8039cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039d6:	79 1d                	jns    8039f5 <open+0xc5>
		fd_close(fd, 0);
  8039d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039dc:	be 00 00 00 00       	mov    $0x0,%esi
  8039e1:	48 89 c7             	mov    %rax,%rdi
  8039e4:	48 b8 b8 30 80 00 00 	movabs $0x8030b8,%rax
  8039eb:	00 00 00 
  8039ee:	ff d0                	callq  *%rax
		return r;
  8039f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f3:	eb 13                	jmp    803a08 <open+0xd8>
	}

	return fd2num(fd);
  8039f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f9:	48 89 c7             	mov    %rax,%rdi
  8039fc:	48 b8 42 2f 80 00 00 	movabs $0x802f42,%rax
  803a03:	00 00 00 
  803a06:	ff d0                	callq  *%rax

}
  803a08:	c9                   	leaveq 
  803a09:	c3                   	retq   

0000000000803a0a <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803a0a:	55                   	push   %rbp
  803a0b:	48 89 e5             	mov    %rsp,%rbp
  803a0e:	48 83 ec 10          	sub    $0x10,%rsp
  803a12:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803a16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a1a:	8b 50 0c             	mov    0xc(%rax),%edx
  803a1d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a24:	00 00 00 
  803a27:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803a29:	be 00 00 00 00       	mov    $0x0,%esi
  803a2e:	bf 06 00 00 00       	mov    $0x6,%edi
  803a33:	48 b8 a9 38 80 00 00 	movabs $0x8038a9,%rax
  803a3a:	00 00 00 
  803a3d:	ff d0                	callq  *%rax
}
  803a3f:	c9                   	leaveq 
  803a40:	c3                   	retq   

0000000000803a41 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803a41:	55                   	push   %rbp
  803a42:	48 89 e5             	mov    %rsp,%rbp
  803a45:	48 83 ec 30          	sub    $0x30,%rsp
  803a49:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a4d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a51:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803a55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a59:	8b 50 0c             	mov    0xc(%rax),%edx
  803a5c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a63:	00 00 00 
  803a66:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803a68:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a6f:	00 00 00 
  803a72:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803a76:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803a7a:	be 00 00 00 00       	mov    $0x0,%esi
  803a7f:	bf 03 00 00 00       	mov    $0x3,%edi
  803a84:	48 b8 a9 38 80 00 00 	movabs $0x8038a9,%rax
  803a8b:	00 00 00 
  803a8e:	ff d0                	callq  *%rax
  803a90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a97:	79 08                	jns    803aa1 <devfile_read+0x60>
		return r;
  803a99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a9c:	e9 a4 00 00 00       	jmpq   803b45 <devfile_read+0x104>
	assert(r <= n);
  803aa1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa4:	48 98                	cltq   
  803aa6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803aaa:	76 35                	jbe    803ae1 <devfile_read+0xa0>
  803aac:	48 b9 56 5f 80 00 00 	movabs $0x805f56,%rcx
  803ab3:	00 00 00 
  803ab6:	48 ba 5d 5f 80 00 00 	movabs $0x805f5d,%rdx
  803abd:	00 00 00 
  803ac0:	be 86 00 00 00       	mov    $0x86,%esi
  803ac5:	48 bf 72 5f 80 00 00 	movabs $0x805f72,%rdi
  803acc:	00 00 00 
  803acf:	b8 00 00 00 00       	mov    $0x0,%eax
  803ad4:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  803adb:	00 00 00 
  803ade:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803ae1:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  803ae8:	7e 35                	jle    803b1f <devfile_read+0xde>
  803aea:	48 b9 7d 5f 80 00 00 	movabs $0x805f7d,%rcx
  803af1:	00 00 00 
  803af4:	48 ba 5d 5f 80 00 00 	movabs $0x805f5d,%rdx
  803afb:	00 00 00 
  803afe:	be 87 00 00 00       	mov    $0x87,%esi
  803b03:	48 bf 72 5f 80 00 00 	movabs $0x805f72,%rdi
  803b0a:	00 00 00 
  803b0d:	b8 00 00 00 00       	mov    $0x0,%eax
  803b12:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  803b19:	00 00 00 
  803b1c:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  803b1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b22:	48 63 d0             	movslq %eax,%rdx
  803b25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b29:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803b30:	00 00 00 
  803b33:	48 89 c7             	mov    %rax,%rdi
  803b36:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  803b3d:	00 00 00 
  803b40:	ff d0                	callq  *%rax
	return r;
  803b42:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  803b45:	c9                   	leaveq 
  803b46:	c3                   	retq   

0000000000803b47 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803b47:	55                   	push   %rbp
  803b48:	48 89 e5             	mov    %rsp,%rbp
  803b4b:	48 83 ec 40          	sub    $0x40,%rsp
  803b4f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b53:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b57:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  803b5b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b5f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803b63:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  803b6a:	00 
  803b6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b6f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803b73:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  803b78:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803b7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b80:	8b 50 0c             	mov    0xc(%rax),%edx
  803b83:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b8a:	00 00 00 
  803b8d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803b8f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b96:	00 00 00 
  803b99:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803b9d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803ba1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803ba5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ba9:	48 89 c6             	mov    %rax,%rsi
  803bac:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  803bb3:	00 00 00 
  803bb6:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  803bbd:	00 00 00 
  803bc0:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803bc2:	be 00 00 00 00       	mov    $0x0,%esi
  803bc7:	bf 04 00 00 00       	mov    $0x4,%edi
  803bcc:	48 b8 a9 38 80 00 00 	movabs $0x8038a9,%rax
  803bd3:	00 00 00 
  803bd6:	ff d0                	callq  *%rax
  803bd8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bdb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bdf:	79 05                	jns    803be6 <devfile_write+0x9f>
		return r;
  803be1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803be4:	eb 43                	jmp    803c29 <devfile_write+0xe2>
	assert(r <= n);
  803be6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803be9:	48 98                	cltq   
  803beb:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803bef:	76 35                	jbe    803c26 <devfile_write+0xdf>
  803bf1:	48 b9 56 5f 80 00 00 	movabs $0x805f56,%rcx
  803bf8:	00 00 00 
  803bfb:	48 ba 5d 5f 80 00 00 	movabs $0x805f5d,%rdx
  803c02:	00 00 00 
  803c05:	be a2 00 00 00       	mov    $0xa2,%esi
  803c0a:	48 bf 72 5f 80 00 00 	movabs $0x805f72,%rdi
  803c11:	00 00 00 
  803c14:	b8 00 00 00 00       	mov    $0x0,%eax
  803c19:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  803c20:	00 00 00 
  803c23:	41 ff d0             	callq  *%r8
	return r;
  803c26:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  803c29:	c9                   	leaveq 
  803c2a:	c3                   	retq   

0000000000803c2b <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803c2b:	55                   	push   %rbp
  803c2c:	48 89 e5             	mov    %rsp,%rbp
  803c2f:	48 83 ec 20          	sub    $0x20,%rsp
  803c33:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c37:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803c3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c3f:	8b 50 0c             	mov    0xc(%rax),%edx
  803c42:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c49:	00 00 00 
  803c4c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803c4e:	be 00 00 00 00       	mov    $0x0,%esi
  803c53:	bf 05 00 00 00       	mov    $0x5,%edi
  803c58:	48 b8 a9 38 80 00 00 	movabs $0x8038a9,%rax
  803c5f:	00 00 00 
  803c62:	ff d0                	callq  *%rax
  803c64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c6b:	79 05                	jns    803c72 <devfile_stat+0x47>
		return r;
  803c6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c70:	eb 56                	jmp    803cc8 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803c72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c76:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803c7d:	00 00 00 
  803c80:	48 89 c7             	mov    %rax,%rdi
  803c83:	48 b8 df 18 80 00 00 	movabs $0x8018df,%rax
  803c8a:	00 00 00 
  803c8d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803c8f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c96:	00 00 00 
  803c99:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803c9f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ca3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803ca9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803cb0:	00 00 00 
  803cb3:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803cb9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cbd:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803cc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cc8:	c9                   	leaveq 
  803cc9:	c3                   	retq   

0000000000803cca <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803cca:	55                   	push   %rbp
  803ccb:	48 89 e5             	mov    %rsp,%rbp
  803cce:	48 83 ec 10          	sub    $0x10,%rsp
  803cd2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803cd6:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803cd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cdd:	8b 50 0c             	mov    0xc(%rax),%edx
  803ce0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ce7:	00 00 00 
  803cea:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803cec:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803cf3:	00 00 00 
  803cf6:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803cf9:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803cfc:	be 00 00 00 00       	mov    $0x0,%esi
  803d01:	bf 02 00 00 00       	mov    $0x2,%edi
  803d06:	48 b8 a9 38 80 00 00 	movabs $0x8038a9,%rax
  803d0d:	00 00 00 
  803d10:	ff d0                	callq  *%rax
}
  803d12:	c9                   	leaveq 
  803d13:	c3                   	retq   

0000000000803d14 <remove>:

// Delete a file
int
remove(const char *path)
{
  803d14:	55                   	push   %rbp
  803d15:	48 89 e5             	mov    %rsp,%rbp
  803d18:	48 83 ec 10          	sub    $0x10,%rsp
  803d1c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803d20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d24:	48 89 c7             	mov    %rax,%rdi
  803d27:	48 b8 73 18 80 00 00 	movabs $0x801873,%rax
  803d2e:	00 00 00 
  803d31:	ff d0                	callq  *%rax
  803d33:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803d38:	7e 07                	jle    803d41 <remove+0x2d>
		return -E_BAD_PATH;
  803d3a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803d3f:	eb 33                	jmp    803d74 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803d41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d45:	48 89 c6             	mov    %rax,%rsi
  803d48:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  803d4f:	00 00 00 
  803d52:	48 b8 df 18 80 00 00 	movabs $0x8018df,%rax
  803d59:	00 00 00 
  803d5c:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803d5e:	be 00 00 00 00       	mov    $0x0,%esi
  803d63:	bf 07 00 00 00       	mov    $0x7,%edi
  803d68:	48 b8 a9 38 80 00 00 	movabs $0x8038a9,%rax
  803d6f:	00 00 00 
  803d72:	ff d0                	callq  *%rax
}
  803d74:	c9                   	leaveq 
  803d75:	c3                   	retq   

0000000000803d76 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803d76:	55                   	push   %rbp
  803d77:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803d7a:	be 00 00 00 00       	mov    $0x0,%esi
  803d7f:	bf 08 00 00 00       	mov    $0x8,%edi
  803d84:	48 b8 a9 38 80 00 00 	movabs $0x8038a9,%rax
  803d8b:	00 00 00 
  803d8e:	ff d0                	callq  *%rax
}
  803d90:	5d                   	pop    %rbp
  803d91:	c3                   	retq   

0000000000803d92 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803d92:	55                   	push   %rbp
  803d93:	48 89 e5             	mov    %rsp,%rbp
  803d96:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803d9d:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803da4:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803dab:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803db2:	be 00 00 00 00       	mov    $0x0,%esi
  803db7:	48 89 c7             	mov    %rax,%rdi
  803dba:	48 b8 30 39 80 00 00 	movabs $0x803930,%rax
  803dc1:	00 00 00 
  803dc4:	ff d0                	callq  *%rax
  803dc6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803dc9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dcd:	79 28                	jns    803df7 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803dcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dd2:	89 c6                	mov    %eax,%esi
  803dd4:	48 bf 89 5f 80 00 00 	movabs $0x805f89,%rdi
  803ddb:	00 00 00 
  803dde:	b8 00 00 00 00       	mov    $0x0,%eax
  803de3:	48 ba 2a 0d 80 00 00 	movabs $0x800d2a,%rdx
  803dea:	00 00 00 
  803ded:	ff d2                	callq  *%rdx
		return fd_src;
  803def:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803df2:	e9 74 01 00 00       	jmpq   803f6b <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803df7:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803dfe:	be 01 01 00 00       	mov    $0x101,%esi
  803e03:	48 89 c7             	mov    %rax,%rdi
  803e06:	48 b8 30 39 80 00 00 	movabs $0x803930,%rax
  803e0d:	00 00 00 
  803e10:	ff d0                	callq  *%rax
  803e12:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803e15:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803e19:	79 39                	jns    803e54 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803e1b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e1e:	89 c6                	mov    %eax,%esi
  803e20:	48 bf 9f 5f 80 00 00 	movabs $0x805f9f,%rdi
  803e27:	00 00 00 
  803e2a:	b8 00 00 00 00       	mov    $0x0,%eax
  803e2f:	48 ba 2a 0d 80 00 00 	movabs $0x800d2a,%rdx
  803e36:	00 00 00 
  803e39:	ff d2                	callq  *%rdx
		close(fd_src);
  803e3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e3e:	89 c7                	mov    %eax,%edi
  803e40:	48 b8 38 32 80 00 00 	movabs $0x803238,%rax
  803e47:	00 00 00 
  803e4a:	ff d0                	callq  *%rax
		return fd_dest;
  803e4c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e4f:	e9 17 01 00 00       	jmpq   803f6b <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803e54:	eb 74                	jmp    803eca <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803e56:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803e59:	48 63 d0             	movslq %eax,%rdx
  803e5c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803e63:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e66:	48 89 ce             	mov    %rcx,%rsi
  803e69:	89 c7                	mov    %eax,%edi
  803e6b:	48 b8 a4 35 80 00 00 	movabs $0x8035a4,%rax
  803e72:	00 00 00 
  803e75:	ff d0                	callq  *%rax
  803e77:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803e7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803e7e:	79 4a                	jns    803eca <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803e80:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803e83:	89 c6                	mov    %eax,%esi
  803e85:	48 bf b9 5f 80 00 00 	movabs $0x805fb9,%rdi
  803e8c:	00 00 00 
  803e8f:	b8 00 00 00 00       	mov    $0x0,%eax
  803e94:	48 ba 2a 0d 80 00 00 	movabs $0x800d2a,%rdx
  803e9b:	00 00 00 
  803e9e:	ff d2                	callq  *%rdx
			close(fd_src);
  803ea0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ea3:	89 c7                	mov    %eax,%edi
  803ea5:	48 b8 38 32 80 00 00 	movabs $0x803238,%rax
  803eac:	00 00 00 
  803eaf:	ff d0                	callq  *%rax
			close(fd_dest);
  803eb1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803eb4:	89 c7                	mov    %eax,%edi
  803eb6:	48 b8 38 32 80 00 00 	movabs $0x803238,%rax
  803ebd:	00 00 00 
  803ec0:	ff d0                	callq  *%rax
			return write_size;
  803ec2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803ec5:	e9 a1 00 00 00       	jmpq   803f6b <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803eca:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803ed1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ed4:	ba 00 02 00 00       	mov    $0x200,%edx
  803ed9:	48 89 ce             	mov    %rcx,%rsi
  803edc:	89 c7                	mov    %eax,%edi
  803ede:	48 b8 5a 34 80 00 00 	movabs $0x80345a,%rax
  803ee5:	00 00 00 
  803ee8:	ff d0                	callq  *%rax
  803eea:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803eed:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803ef1:	0f 8f 5f ff ff ff    	jg     803e56 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803ef7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803efb:	79 47                	jns    803f44 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803efd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803f00:	89 c6                	mov    %eax,%esi
  803f02:	48 bf cc 5f 80 00 00 	movabs $0x805fcc,%rdi
  803f09:	00 00 00 
  803f0c:	b8 00 00 00 00       	mov    $0x0,%eax
  803f11:	48 ba 2a 0d 80 00 00 	movabs $0x800d2a,%rdx
  803f18:	00 00 00 
  803f1b:	ff d2                	callq  *%rdx
		close(fd_src);
  803f1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f20:	89 c7                	mov    %eax,%edi
  803f22:	48 b8 38 32 80 00 00 	movabs $0x803238,%rax
  803f29:	00 00 00 
  803f2c:	ff d0                	callq  *%rax
		close(fd_dest);
  803f2e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f31:	89 c7                	mov    %eax,%edi
  803f33:	48 b8 38 32 80 00 00 	movabs $0x803238,%rax
  803f3a:	00 00 00 
  803f3d:	ff d0                	callq  *%rax
		return read_size;
  803f3f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803f42:	eb 27                	jmp    803f6b <copy+0x1d9>
	}
	close(fd_src);
  803f44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f47:	89 c7                	mov    %eax,%edi
  803f49:	48 b8 38 32 80 00 00 	movabs $0x803238,%rax
  803f50:	00 00 00 
  803f53:	ff d0                	callq  *%rax
	close(fd_dest);
  803f55:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f58:	89 c7                	mov    %eax,%edi
  803f5a:	48 b8 38 32 80 00 00 	movabs $0x803238,%rax
  803f61:	00 00 00 
  803f64:	ff d0                	callq  *%rax
	return 0;
  803f66:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803f6b:	c9                   	leaveq 
  803f6c:	c3                   	retq   

0000000000803f6d <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803f6d:	55                   	push   %rbp
  803f6e:	48 89 e5             	mov    %rsp,%rbp
  803f71:	48 83 ec 20          	sub    $0x20,%rsp
  803f75:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803f78:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803f7c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f7f:	48 89 d6             	mov    %rdx,%rsi
  803f82:	89 c7                	mov    %eax,%edi
  803f84:	48 b8 28 30 80 00 00 	movabs $0x803028,%rax
  803f8b:	00 00 00 
  803f8e:	ff d0                	callq  *%rax
  803f90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f97:	79 05                	jns    803f9e <fd2sockid+0x31>
		return r;
  803f99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f9c:	eb 24                	jmp    803fc2 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803f9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fa2:	8b 10                	mov    (%rax),%edx
  803fa4:	48 b8 a0 80 80 00 00 	movabs $0x8080a0,%rax
  803fab:	00 00 00 
  803fae:	8b 00                	mov    (%rax),%eax
  803fb0:	39 c2                	cmp    %eax,%edx
  803fb2:	74 07                	je     803fbb <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803fb4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803fb9:	eb 07                	jmp    803fc2 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803fbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fbf:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803fc2:	c9                   	leaveq 
  803fc3:	c3                   	retq   

0000000000803fc4 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803fc4:	55                   	push   %rbp
  803fc5:	48 89 e5             	mov    %rsp,%rbp
  803fc8:	48 83 ec 20          	sub    $0x20,%rsp
  803fcc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803fcf:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803fd3:	48 89 c7             	mov    %rax,%rdi
  803fd6:	48 b8 90 2f 80 00 00 	movabs $0x802f90,%rax
  803fdd:	00 00 00 
  803fe0:	ff d0                	callq  *%rax
  803fe2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fe5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fe9:	78 26                	js     804011 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803feb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fef:	ba 07 04 00 00       	mov    $0x407,%edx
  803ff4:	48 89 c6             	mov    %rax,%rsi
  803ff7:	bf 00 00 00 00       	mov    $0x0,%edi
  803ffc:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  804003:	00 00 00 
  804006:	ff d0                	callq  *%rax
  804008:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80400b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80400f:	79 16                	jns    804027 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  804011:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804014:	89 c7                	mov    %eax,%edi
  804016:	48 b8 d1 44 80 00 00 	movabs $0x8044d1,%rax
  80401d:	00 00 00 
  804020:	ff d0                	callq  *%rax
		return r;
  804022:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804025:	eb 3a                	jmp    804061 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  804027:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80402b:	48 ba a0 80 80 00 00 	movabs $0x8080a0,%rdx
  804032:	00 00 00 
  804035:	8b 12                	mov    (%rdx),%edx
  804037:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  804039:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80403d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  804044:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804048:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80404b:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80404e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804052:	48 89 c7             	mov    %rax,%rdi
  804055:	48 b8 42 2f 80 00 00 	movabs $0x802f42,%rax
  80405c:	00 00 00 
  80405f:	ff d0                	callq  *%rax
}
  804061:	c9                   	leaveq 
  804062:	c3                   	retq   

0000000000804063 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804063:	55                   	push   %rbp
  804064:	48 89 e5             	mov    %rsp,%rbp
  804067:	48 83 ec 30          	sub    $0x30,%rsp
  80406b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80406e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804072:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804076:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804079:	89 c7                	mov    %eax,%edi
  80407b:	48 b8 6d 3f 80 00 00 	movabs $0x803f6d,%rax
  804082:	00 00 00 
  804085:	ff d0                	callq  *%rax
  804087:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80408a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80408e:	79 05                	jns    804095 <accept+0x32>
		return r;
  804090:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804093:	eb 3b                	jmp    8040d0 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  804095:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804099:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80409d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040a0:	48 89 ce             	mov    %rcx,%rsi
  8040a3:	89 c7                	mov    %eax,%edi
  8040a5:	48 b8 ae 43 80 00 00 	movabs $0x8043ae,%rax
  8040ac:	00 00 00 
  8040af:	ff d0                	callq  *%rax
  8040b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040b8:	79 05                	jns    8040bf <accept+0x5c>
		return r;
  8040ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040bd:	eb 11                	jmp    8040d0 <accept+0x6d>
	return alloc_sockfd(r);
  8040bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040c2:	89 c7                	mov    %eax,%edi
  8040c4:	48 b8 c4 3f 80 00 00 	movabs $0x803fc4,%rax
  8040cb:	00 00 00 
  8040ce:	ff d0                	callq  *%rax
}
  8040d0:	c9                   	leaveq 
  8040d1:	c3                   	retq   

00000000008040d2 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8040d2:	55                   	push   %rbp
  8040d3:	48 89 e5             	mov    %rsp,%rbp
  8040d6:	48 83 ec 20          	sub    $0x20,%rsp
  8040da:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8040dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8040e1:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8040e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040e7:	89 c7                	mov    %eax,%edi
  8040e9:	48 b8 6d 3f 80 00 00 	movabs $0x803f6d,%rax
  8040f0:	00 00 00 
  8040f3:	ff d0                	callq  *%rax
  8040f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040fc:	79 05                	jns    804103 <bind+0x31>
		return r;
  8040fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804101:	eb 1b                	jmp    80411e <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  804103:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804106:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80410a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80410d:	48 89 ce             	mov    %rcx,%rsi
  804110:	89 c7                	mov    %eax,%edi
  804112:	48 b8 2d 44 80 00 00 	movabs $0x80442d,%rax
  804119:	00 00 00 
  80411c:	ff d0                	callq  *%rax
}
  80411e:	c9                   	leaveq 
  80411f:	c3                   	retq   

0000000000804120 <shutdown>:

int
shutdown(int s, int how)
{
  804120:	55                   	push   %rbp
  804121:	48 89 e5             	mov    %rsp,%rbp
  804124:	48 83 ec 20          	sub    $0x20,%rsp
  804128:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80412b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80412e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804131:	89 c7                	mov    %eax,%edi
  804133:	48 b8 6d 3f 80 00 00 	movabs $0x803f6d,%rax
  80413a:	00 00 00 
  80413d:	ff d0                	callq  *%rax
  80413f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804142:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804146:	79 05                	jns    80414d <shutdown+0x2d>
		return r;
  804148:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80414b:	eb 16                	jmp    804163 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80414d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804150:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804153:	89 d6                	mov    %edx,%esi
  804155:	89 c7                	mov    %eax,%edi
  804157:	48 b8 91 44 80 00 00 	movabs $0x804491,%rax
  80415e:	00 00 00 
  804161:	ff d0                	callq  *%rax
}
  804163:	c9                   	leaveq 
  804164:	c3                   	retq   

0000000000804165 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  804165:	55                   	push   %rbp
  804166:	48 89 e5             	mov    %rsp,%rbp
  804169:	48 83 ec 10          	sub    $0x10,%rsp
  80416d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  804171:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804175:	48 89 c7             	mov    %rax,%rdi
  804178:	48 b8 1d 51 80 00 00 	movabs $0x80511d,%rax
  80417f:	00 00 00 
  804182:	ff d0                	callq  *%rax
  804184:	83 f8 01             	cmp    $0x1,%eax
  804187:	75 17                	jne    8041a0 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  804189:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80418d:	8b 40 0c             	mov    0xc(%rax),%eax
  804190:	89 c7                	mov    %eax,%edi
  804192:	48 b8 d1 44 80 00 00 	movabs $0x8044d1,%rax
  804199:	00 00 00 
  80419c:	ff d0                	callq  *%rax
  80419e:	eb 05                	jmp    8041a5 <devsock_close+0x40>
	else
		return 0;
  8041a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041a5:	c9                   	leaveq 
  8041a6:	c3                   	retq   

00000000008041a7 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8041a7:	55                   	push   %rbp
  8041a8:	48 89 e5             	mov    %rsp,%rbp
  8041ab:	48 83 ec 20          	sub    $0x20,%rsp
  8041af:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8041b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8041b6:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8041b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041bc:	89 c7                	mov    %eax,%edi
  8041be:	48 b8 6d 3f 80 00 00 	movabs $0x803f6d,%rax
  8041c5:	00 00 00 
  8041c8:	ff d0                	callq  *%rax
  8041ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041d1:	79 05                	jns    8041d8 <connect+0x31>
		return r;
  8041d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041d6:	eb 1b                	jmp    8041f3 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8041d8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8041db:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8041df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041e2:	48 89 ce             	mov    %rcx,%rsi
  8041e5:	89 c7                	mov    %eax,%edi
  8041e7:	48 b8 fe 44 80 00 00 	movabs $0x8044fe,%rax
  8041ee:	00 00 00 
  8041f1:	ff d0                	callq  *%rax
}
  8041f3:	c9                   	leaveq 
  8041f4:	c3                   	retq   

00000000008041f5 <listen>:

int
listen(int s, int backlog)
{
  8041f5:	55                   	push   %rbp
  8041f6:	48 89 e5             	mov    %rsp,%rbp
  8041f9:	48 83 ec 20          	sub    $0x20,%rsp
  8041fd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804200:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804203:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804206:	89 c7                	mov    %eax,%edi
  804208:	48 b8 6d 3f 80 00 00 	movabs $0x803f6d,%rax
  80420f:	00 00 00 
  804212:	ff d0                	callq  *%rax
  804214:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804217:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80421b:	79 05                	jns    804222 <listen+0x2d>
		return r;
  80421d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804220:	eb 16                	jmp    804238 <listen+0x43>
	return nsipc_listen(r, backlog);
  804222:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804225:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804228:	89 d6                	mov    %edx,%esi
  80422a:	89 c7                	mov    %eax,%edi
  80422c:	48 b8 62 45 80 00 00 	movabs $0x804562,%rax
  804233:	00 00 00 
  804236:	ff d0                	callq  *%rax
}
  804238:	c9                   	leaveq 
  804239:	c3                   	retq   

000000000080423a <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80423a:	55                   	push   %rbp
  80423b:	48 89 e5             	mov    %rsp,%rbp
  80423e:	48 83 ec 20          	sub    $0x20,%rsp
  804242:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804246:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80424a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80424e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804252:	89 c2                	mov    %eax,%edx
  804254:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804258:	8b 40 0c             	mov    0xc(%rax),%eax
  80425b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80425f:	b9 00 00 00 00       	mov    $0x0,%ecx
  804264:	89 c7                	mov    %eax,%edi
  804266:	48 b8 a2 45 80 00 00 	movabs $0x8045a2,%rax
  80426d:	00 00 00 
  804270:	ff d0                	callq  *%rax
}
  804272:	c9                   	leaveq 
  804273:	c3                   	retq   

0000000000804274 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  804274:	55                   	push   %rbp
  804275:	48 89 e5             	mov    %rsp,%rbp
  804278:	48 83 ec 20          	sub    $0x20,%rsp
  80427c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804280:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804284:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  804288:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80428c:	89 c2                	mov    %eax,%edx
  80428e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804292:	8b 40 0c             	mov    0xc(%rax),%eax
  804295:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  804299:	b9 00 00 00 00       	mov    $0x0,%ecx
  80429e:	89 c7                	mov    %eax,%edi
  8042a0:	48 b8 6e 46 80 00 00 	movabs $0x80466e,%rax
  8042a7:	00 00 00 
  8042aa:	ff d0                	callq  *%rax
}
  8042ac:	c9                   	leaveq 
  8042ad:	c3                   	retq   

00000000008042ae <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8042ae:	55                   	push   %rbp
  8042af:	48 89 e5             	mov    %rsp,%rbp
  8042b2:	48 83 ec 10          	sub    $0x10,%rsp
  8042b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8042ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8042be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042c2:	48 be e7 5f 80 00 00 	movabs $0x805fe7,%rsi
  8042c9:	00 00 00 
  8042cc:	48 89 c7             	mov    %rax,%rdi
  8042cf:	48 b8 df 18 80 00 00 	movabs $0x8018df,%rax
  8042d6:	00 00 00 
  8042d9:	ff d0                	callq  *%rax
	return 0;
  8042db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042e0:	c9                   	leaveq 
  8042e1:	c3                   	retq   

00000000008042e2 <socket>:

int
socket(int domain, int type, int protocol)
{
  8042e2:	55                   	push   %rbp
  8042e3:	48 89 e5             	mov    %rsp,%rbp
  8042e6:	48 83 ec 20          	sub    $0x20,%rsp
  8042ea:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8042ed:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8042f0:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8042f3:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8042f6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8042f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042fc:	89 ce                	mov    %ecx,%esi
  8042fe:	89 c7                	mov    %eax,%edi
  804300:	48 b8 26 47 80 00 00 	movabs $0x804726,%rax
  804307:	00 00 00 
  80430a:	ff d0                	callq  *%rax
  80430c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80430f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804313:	79 05                	jns    80431a <socket+0x38>
		return r;
  804315:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804318:	eb 11                	jmp    80432b <socket+0x49>
	return alloc_sockfd(r);
  80431a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80431d:	89 c7                	mov    %eax,%edi
  80431f:	48 b8 c4 3f 80 00 00 	movabs $0x803fc4,%rax
  804326:	00 00 00 
  804329:	ff d0                	callq  *%rax
}
  80432b:	c9                   	leaveq 
  80432c:	c3                   	retq   

000000000080432d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80432d:	55                   	push   %rbp
  80432e:	48 89 e5             	mov    %rsp,%rbp
  804331:	48 83 ec 10          	sub    $0x10,%rsp
  804335:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  804338:	48 b8 0c 90 80 00 00 	movabs $0x80900c,%rax
  80433f:	00 00 00 
  804342:	8b 00                	mov    (%rax),%eax
  804344:	85 c0                	test   %eax,%eax
  804346:	75 1d                	jne    804365 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  804348:	bf 02 00 00 00       	mov    $0x2,%edi
  80434d:	48 b8 d0 2e 80 00 00 	movabs $0x802ed0,%rax
  804354:	00 00 00 
  804357:	ff d0                	callq  *%rax
  804359:	48 ba 0c 90 80 00 00 	movabs $0x80900c,%rdx
  804360:	00 00 00 
  804363:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  804365:	48 b8 0c 90 80 00 00 	movabs $0x80900c,%rax
  80436c:	00 00 00 
  80436f:	8b 00                	mov    (%rax),%eax
  804371:	8b 75 fc             	mov    -0x4(%rbp),%esi
  804374:	b9 07 00 00 00       	mov    $0x7,%ecx
  804379:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  804380:	00 00 00 
  804383:	89 c7                	mov    %eax,%edi
  804385:	48 b8 c4 2c 80 00 00 	movabs $0x802cc4,%rax
  80438c:	00 00 00 
  80438f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  804391:	ba 00 00 00 00       	mov    $0x0,%edx
  804396:	be 00 00 00 00       	mov    $0x0,%esi
  80439b:	bf 00 00 00 00       	mov    $0x0,%edi
  8043a0:	48 b8 03 2c 80 00 00 	movabs $0x802c03,%rax
  8043a7:	00 00 00 
  8043aa:	ff d0                	callq  *%rax
}
  8043ac:	c9                   	leaveq 
  8043ad:	c3                   	retq   

00000000008043ae <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8043ae:	55                   	push   %rbp
  8043af:	48 89 e5             	mov    %rsp,%rbp
  8043b2:	48 83 ec 30          	sub    $0x30,%rsp
  8043b6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8043b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043bd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8043c1:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8043c8:	00 00 00 
  8043cb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8043ce:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8043d0:	bf 01 00 00 00       	mov    $0x1,%edi
  8043d5:	48 b8 2d 43 80 00 00 	movabs $0x80432d,%rax
  8043dc:	00 00 00 
  8043df:	ff d0                	callq  *%rax
  8043e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043e8:	78 3e                	js     804428 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8043ea:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8043f1:	00 00 00 
  8043f4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8043f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043fc:	8b 40 10             	mov    0x10(%rax),%eax
  8043ff:	89 c2                	mov    %eax,%edx
  804401:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  804405:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804409:	48 89 ce             	mov    %rcx,%rsi
  80440c:	48 89 c7             	mov    %rax,%rdi
  80440f:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  804416:	00 00 00 
  804419:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80441b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80441f:	8b 50 10             	mov    0x10(%rax),%edx
  804422:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804426:	89 10                	mov    %edx,(%rax)
	}
	return r;
  804428:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80442b:	c9                   	leaveq 
  80442c:	c3                   	retq   

000000000080442d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80442d:	55                   	push   %rbp
  80442e:	48 89 e5             	mov    %rsp,%rbp
  804431:	48 83 ec 10          	sub    $0x10,%rsp
  804435:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804438:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80443c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80443f:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804446:	00 00 00 
  804449:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80444c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80444e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804451:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804455:	48 89 c6             	mov    %rax,%rsi
  804458:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  80445f:	00 00 00 
  804462:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  804469:	00 00 00 
  80446c:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80446e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804475:	00 00 00 
  804478:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80447b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80447e:	bf 02 00 00 00       	mov    $0x2,%edi
  804483:	48 b8 2d 43 80 00 00 	movabs $0x80432d,%rax
  80448a:	00 00 00 
  80448d:	ff d0                	callq  *%rax
}
  80448f:	c9                   	leaveq 
  804490:	c3                   	retq   

0000000000804491 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  804491:	55                   	push   %rbp
  804492:	48 89 e5             	mov    %rsp,%rbp
  804495:	48 83 ec 10          	sub    $0x10,%rsp
  804499:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80449c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80449f:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8044a6:	00 00 00 
  8044a9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8044ac:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8044ae:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8044b5:	00 00 00 
  8044b8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8044bb:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8044be:	bf 03 00 00 00       	mov    $0x3,%edi
  8044c3:	48 b8 2d 43 80 00 00 	movabs $0x80432d,%rax
  8044ca:	00 00 00 
  8044cd:	ff d0                	callq  *%rax
}
  8044cf:	c9                   	leaveq 
  8044d0:	c3                   	retq   

00000000008044d1 <nsipc_close>:

int
nsipc_close(int s)
{
  8044d1:	55                   	push   %rbp
  8044d2:	48 89 e5             	mov    %rsp,%rbp
  8044d5:	48 83 ec 10          	sub    $0x10,%rsp
  8044d9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8044dc:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8044e3:	00 00 00 
  8044e6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8044e9:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8044eb:	bf 04 00 00 00       	mov    $0x4,%edi
  8044f0:	48 b8 2d 43 80 00 00 	movabs $0x80432d,%rax
  8044f7:	00 00 00 
  8044fa:	ff d0                	callq  *%rax
}
  8044fc:	c9                   	leaveq 
  8044fd:	c3                   	retq   

00000000008044fe <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8044fe:	55                   	push   %rbp
  8044ff:	48 89 e5             	mov    %rsp,%rbp
  804502:	48 83 ec 10          	sub    $0x10,%rsp
  804506:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804509:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80450d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  804510:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804517:	00 00 00 
  80451a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80451d:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80451f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804522:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804526:	48 89 c6             	mov    %rax,%rsi
  804529:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  804530:	00 00 00 
  804533:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  80453a:	00 00 00 
  80453d:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80453f:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804546:	00 00 00 
  804549:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80454c:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80454f:	bf 05 00 00 00       	mov    $0x5,%edi
  804554:	48 b8 2d 43 80 00 00 	movabs $0x80432d,%rax
  80455b:	00 00 00 
  80455e:	ff d0                	callq  *%rax
}
  804560:	c9                   	leaveq 
  804561:	c3                   	retq   

0000000000804562 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  804562:	55                   	push   %rbp
  804563:	48 89 e5             	mov    %rsp,%rbp
  804566:	48 83 ec 10          	sub    $0x10,%rsp
  80456a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80456d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  804570:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804577:	00 00 00 
  80457a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80457d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80457f:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804586:	00 00 00 
  804589:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80458c:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80458f:	bf 06 00 00 00       	mov    $0x6,%edi
  804594:	48 b8 2d 43 80 00 00 	movabs $0x80432d,%rax
  80459b:	00 00 00 
  80459e:	ff d0                	callq  *%rax
}
  8045a0:	c9                   	leaveq 
  8045a1:	c3                   	retq   

00000000008045a2 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8045a2:	55                   	push   %rbp
  8045a3:	48 89 e5             	mov    %rsp,%rbp
  8045a6:	48 83 ec 30          	sub    $0x30,%rsp
  8045aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8045ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8045b1:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8045b4:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8045b7:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8045be:	00 00 00 
  8045c1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8045c4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8045c6:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8045cd:	00 00 00 
  8045d0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8045d3:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8045d6:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8045dd:	00 00 00 
  8045e0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8045e3:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8045e6:	bf 07 00 00 00       	mov    $0x7,%edi
  8045eb:	48 b8 2d 43 80 00 00 	movabs $0x80432d,%rax
  8045f2:	00 00 00 
  8045f5:	ff d0                	callq  *%rax
  8045f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045fe:	78 69                	js     804669 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  804600:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  804607:	7f 08                	jg     804611 <nsipc_recv+0x6f>
  804609:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80460c:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80460f:	7e 35                	jle    804646 <nsipc_recv+0xa4>
  804611:	48 b9 ee 5f 80 00 00 	movabs $0x805fee,%rcx
  804618:	00 00 00 
  80461b:	48 ba 03 60 80 00 00 	movabs $0x806003,%rdx
  804622:	00 00 00 
  804625:	be 62 00 00 00       	mov    $0x62,%esi
  80462a:	48 bf 18 60 80 00 00 	movabs $0x806018,%rdi
  804631:	00 00 00 
  804634:	b8 00 00 00 00       	mov    $0x0,%eax
  804639:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  804640:	00 00 00 
  804643:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804646:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804649:	48 63 d0             	movslq %eax,%rdx
  80464c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804650:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  804657:	00 00 00 
  80465a:	48 89 c7             	mov    %rax,%rdi
  80465d:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  804664:	00 00 00 
  804667:	ff d0                	callq  *%rax
	}

	return r;
  804669:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80466c:	c9                   	leaveq 
  80466d:	c3                   	retq   

000000000080466e <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80466e:	55                   	push   %rbp
  80466f:	48 89 e5             	mov    %rsp,%rbp
  804672:	48 83 ec 20          	sub    $0x20,%rsp
  804676:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804679:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80467d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804680:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  804683:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80468a:	00 00 00 
  80468d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804690:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  804692:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  804699:	7e 35                	jle    8046d0 <nsipc_send+0x62>
  80469b:	48 b9 24 60 80 00 00 	movabs $0x806024,%rcx
  8046a2:	00 00 00 
  8046a5:	48 ba 03 60 80 00 00 	movabs $0x806003,%rdx
  8046ac:	00 00 00 
  8046af:	be 6d 00 00 00       	mov    $0x6d,%esi
  8046b4:	48 bf 18 60 80 00 00 	movabs $0x806018,%rdi
  8046bb:	00 00 00 
  8046be:	b8 00 00 00 00       	mov    $0x0,%eax
  8046c3:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  8046ca:	00 00 00 
  8046cd:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8046d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8046d3:	48 63 d0             	movslq %eax,%rdx
  8046d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046da:	48 89 c6             	mov    %rax,%rsi
  8046dd:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  8046e4:	00 00 00 
  8046e7:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  8046ee:	00 00 00 
  8046f1:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8046f3:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8046fa:	00 00 00 
  8046fd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804700:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804703:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80470a:	00 00 00 
  80470d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804710:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804713:	bf 08 00 00 00       	mov    $0x8,%edi
  804718:	48 b8 2d 43 80 00 00 	movabs $0x80432d,%rax
  80471f:	00 00 00 
  804722:	ff d0                	callq  *%rax
}
  804724:	c9                   	leaveq 
  804725:	c3                   	retq   

0000000000804726 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804726:	55                   	push   %rbp
  804727:	48 89 e5             	mov    %rsp,%rbp
  80472a:	48 83 ec 10          	sub    $0x10,%rsp
  80472e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804731:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804734:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804737:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80473e:	00 00 00 
  804741:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804744:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804746:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80474d:	00 00 00 
  804750:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804753:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804756:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80475d:	00 00 00 
  804760:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804763:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804766:	bf 09 00 00 00       	mov    $0x9,%edi
  80476b:	48 b8 2d 43 80 00 00 	movabs $0x80432d,%rax
  804772:	00 00 00 
  804775:	ff d0                	callq  *%rax
}
  804777:	c9                   	leaveq 
  804778:	c3                   	retq   

0000000000804779 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804779:	55                   	push   %rbp
  80477a:	48 89 e5             	mov    %rsp,%rbp
  80477d:	53                   	push   %rbx
  80477e:	48 83 ec 38          	sub    $0x38,%rsp
  804782:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804786:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80478a:	48 89 c7             	mov    %rax,%rdi
  80478d:	48 b8 90 2f 80 00 00 	movabs $0x802f90,%rax
  804794:	00 00 00 
  804797:	ff d0                	callq  *%rax
  804799:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80479c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8047a0:	0f 88 bf 01 00 00    	js     804965 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8047a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047aa:	ba 07 04 00 00       	mov    $0x407,%edx
  8047af:	48 89 c6             	mov    %rax,%rsi
  8047b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8047b7:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  8047be:	00 00 00 
  8047c1:	ff d0                	callq  *%rax
  8047c3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8047c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8047ca:	0f 88 95 01 00 00    	js     804965 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8047d0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8047d4:	48 89 c7             	mov    %rax,%rdi
  8047d7:	48 b8 90 2f 80 00 00 	movabs $0x802f90,%rax
  8047de:	00 00 00 
  8047e1:	ff d0                	callq  *%rax
  8047e3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8047e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8047ea:	0f 88 5d 01 00 00    	js     80494d <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8047f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8047f4:	ba 07 04 00 00       	mov    $0x407,%edx
  8047f9:	48 89 c6             	mov    %rax,%rsi
  8047fc:	bf 00 00 00 00       	mov    $0x0,%edi
  804801:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  804808:	00 00 00 
  80480b:	ff d0                	callq  *%rax
  80480d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804810:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804814:	0f 88 33 01 00 00    	js     80494d <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80481a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80481e:	48 89 c7             	mov    %rax,%rdi
  804821:	48 b8 65 2f 80 00 00 	movabs $0x802f65,%rax
  804828:	00 00 00 
  80482b:	ff d0                	callq  *%rax
  80482d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804831:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804835:	ba 07 04 00 00       	mov    $0x407,%edx
  80483a:	48 89 c6             	mov    %rax,%rsi
  80483d:	bf 00 00 00 00       	mov    $0x0,%edi
  804842:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  804849:	00 00 00 
  80484c:	ff d0                	callq  *%rax
  80484e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804851:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804855:	79 05                	jns    80485c <pipe+0xe3>
		goto err2;
  804857:	e9 d9 00 00 00       	jmpq   804935 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80485c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804860:	48 89 c7             	mov    %rax,%rdi
  804863:	48 b8 65 2f 80 00 00 	movabs $0x802f65,%rax
  80486a:	00 00 00 
  80486d:	ff d0                	callq  *%rax
  80486f:	48 89 c2             	mov    %rax,%rdx
  804872:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804876:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80487c:	48 89 d1             	mov    %rdx,%rcx
  80487f:	ba 00 00 00 00       	mov    $0x0,%edx
  804884:	48 89 c6             	mov    %rax,%rsi
  804887:	bf 00 00 00 00       	mov    $0x0,%edi
  80488c:	48 b8 5e 22 80 00 00 	movabs $0x80225e,%rax
  804893:	00 00 00 
  804896:	ff d0                	callq  *%rax
  804898:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80489b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80489f:	79 1b                	jns    8048bc <pipe+0x143>
		goto err3;
  8048a1:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8048a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048a6:	48 89 c6             	mov    %rax,%rsi
  8048a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8048ae:	48 b8 b9 22 80 00 00 	movabs $0x8022b9,%rax
  8048b5:	00 00 00 
  8048b8:	ff d0                	callq  *%rax
  8048ba:	eb 79                	jmp    804935 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8048bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048c0:	48 ba e0 80 80 00 00 	movabs $0x8080e0,%rdx
  8048c7:	00 00 00 
  8048ca:	8b 12                	mov    (%rdx),%edx
  8048cc:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8048ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8048d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8048dd:	48 ba e0 80 80 00 00 	movabs $0x8080e0,%rdx
  8048e4:	00 00 00 
  8048e7:	8b 12                	mov    (%rdx),%edx
  8048e9:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8048eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8048ef:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8048f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048fa:	48 89 c7             	mov    %rax,%rdi
  8048fd:	48 b8 42 2f 80 00 00 	movabs $0x802f42,%rax
  804904:	00 00 00 
  804907:	ff d0                	callq  *%rax
  804909:	89 c2                	mov    %eax,%edx
  80490b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80490f:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804911:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804915:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804919:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80491d:	48 89 c7             	mov    %rax,%rdi
  804920:	48 b8 42 2f 80 00 00 	movabs $0x802f42,%rax
  804927:	00 00 00 
  80492a:	ff d0                	callq  *%rax
  80492c:	89 03                	mov    %eax,(%rbx)
	return 0;
  80492e:	b8 00 00 00 00       	mov    $0x0,%eax
  804933:	eb 33                	jmp    804968 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804935:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804939:	48 89 c6             	mov    %rax,%rsi
  80493c:	bf 00 00 00 00       	mov    $0x0,%edi
  804941:	48 b8 b9 22 80 00 00 	movabs $0x8022b9,%rax
  804948:	00 00 00 
  80494b:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80494d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804951:	48 89 c6             	mov    %rax,%rsi
  804954:	bf 00 00 00 00       	mov    $0x0,%edi
  804959:	48 b8 b9 22 80 00 00 	movabs $0x8022b9,%rax
  804960:	00 00 00 
  804963:	ff d0                	callq  *%rax
err:
	return r;
  804965:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804968:	48 83 c4 38          	add    $0x38,%rsp
  80496c:	5b                   	pop    %rbx
  80496d:	5d                   	pop    %rbp
  80496e:	c3                   	retq   

000000000080496f <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80496f:	55                   	push   %rbp
  804970:	48 89 e5             	mov    %rsp,%rbp
  804973:	53                   	push   %rbx
  804974:	48 83 ec 28          	sub    $0x28,%rsp
  804978:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80497c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804980:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  804987:	00 00 00 
  80498a:	48 8b 00             	mov    (%rax),%rax
  80498d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804993:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804996:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80499a:	48 89 c7             	mov    %rax,%rdi
  80499d:	48 b8 1d 51 80 00 00 	movabs $0x80511d,%rax
  8049a4:	00 00 00 
  8049a7:	ff d0                	callq  *%rax
  8049a9:	89 c3                	mov    %eax,%ebx
  8049ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8049af:	48 89 c7             	mov    %rax,%rdi
  8049b2:	48 b8 1d 51 80 00 00 	movabs $0x80511d,%rax
  8049b9:	00 00 00 
  8049bc:	ff d0                	callq  *%rax
  8049be:	39 c3                	cmp    %eax,%ebx
  8049c0:	0f 94 c0             	sete   %al
  8049c3:	0f b6 c0             	movzbl %al,%eax
  8049c6:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8049c9:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8049d0:	00 00 00 
  8049d3:	48 8b 00             	mov    (%rax),%rax
  8049d6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8049dc:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8049df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8049e2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8049e5:	75 05                	jne    8049ec <_pipeisclosed+0x7d>
			return ret;
  8049e7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8049ea:	eb 4f                	jmp    804a3b <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8049ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8049ef:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8049f2:	74 42                	je     804a36 <_pipeisclosed+0xc7>
  8049f4:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8049f8:	75 3c                	jne    804a36 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8049fa:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  804a01:	00 00 00 
  804a04:	48 8b 00             	mov    (%rax),%rax
  804a07:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804a0d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804a10:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a13:	89 c6                	mov    %eax,%esi
  804a15:	48 bf 35 60 80 00 00 	movabs $0x806035,%rdi
  804a1c:	00 00 00 
  804a1f:	b8 00 00 00 00       	mov    $0x0,%eax
  804a24:	49 b8 2a 0d 80 00 00 	movabs $0x800d2a,%r8
  804a2b:	00 00 00 
  804a2e:	41 ff d0             	callq  *%r8
	}
  804a31:	e9 4a ff ff ff       	jmpq   804980 <_pipeisclosed+0x11>
  804a36:	e9 45 ff ff ff       	jmpq   804980 <_pipeisclosed+0x11>

}
  804a3b:	48 83 c4 28          	add    $0x28,%rsp
  804a3f:	5b                   	pop    %rbx
  804a40:	5d                   	pop    %rbp
  804a41:	c3                   	retq   

0000000000804a42 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804a42:	55                   	push   %rbp
  804a43:	48 89 e5             	mov    %rsp,%rbp
  804a46:	48 83 ec 30          	sub    $0x30,%rsp
  804a4a:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804a4d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804a51:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804a54:	48 89 d6             	mov    %rdx,%rsi
  804a57:	89 c7                	mov    %eax,%edi
  804a59:	48 b8 28 30 80 00 00 	movabs $0x803028,%rax
  804a60:	00 00 00 
  804a63:	ff d0                	callq  *%rax
  804a65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a6c:	79 05                	jns    804a73 <pipeisclosed+0x31>
		return r;
  804a6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a71:	eb 31                	jmp    804aa4 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804a73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a77:	48 89 c7             	mov    %rax,%rdi
  804a7a:	48 b8 65 2f 80 00 00 	movabs $0x802f65,%rax
  804a81:	00 00 00 
  804a84:	ff d0                	callq  *%rax
  804a86:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804a8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a8e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a92:	48 89 d6             	mov    %rdx,%rsi
  804a95:	48 89 c7             	mov    %rax,%rdi
  804a98:	48 b8 6f 49 80 00 00 	movabs $0x80496f,%rax
  804a9f:	00 00 00 
  804aa2:	ff d0                	callq  *%rax
}
  804aa4:	c9                   	leaveq 
  804aa5:	c3                   	retq   

0000000000804aa6 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804aa6:	55                   	push   %rbp
  804aa7:	48 89 e5             	mov    %rsp,%rbp
  804aaa:	48 83 ec 40          	sub    $0x40,%rsp
  804aae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804ab2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804ab6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804aba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804abe:	48 89 c7             	mov    %rax,%rdi
  804ac1:	48 b8 65 2f 80 00 00 	movabs $0x802f65,%rax
  804ac8:	00 00 00 
  804acb:	ff d0                	callq  *%rax
  804acd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804ad1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804ad5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804ad9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804ae0:	00 
  804ae1:	e9 92 00 00 00       	jmpq   804b78 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804ae6:	eb 41                	jmp    804b29 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804ae8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804aed:	74 09                	je     804af8 <devpipe_read+0x52>
				return i;
  804aef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804af3:	e9 92 00 00 00       	jmpq   804b8a <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804af8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804afc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b00:	48 89 d6             	mov    %rdx,%rsi
  804b03:	48 89 c7             	mov    %rax,%rdi
  804b06:	48 b8 6f 49 80 00 00 	movabs $0x80496f,%rax
  804b0d:	00 00 00 
  804b10:	ff d0                	callq  *%rax
  804b12:	85 c0                	test   %eax,%eax
  804b14:	74 07                	je     804b1d <devpipe_read+0x77>
				return 0;
  804b16:	b8 00 00 00 00       	mov    $0x0,%eax
  804b1b:	eb 6d                	jmp    804b8a <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804b1d:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  804b24:	00 00 00 
  804b27:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804b29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b2d:	8b 10                	mov    (%rax),%edx
  804b2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b33:	8b 40 04             	mov    0x4(%rax),%eax
  804b36:	39 c2                	cmp    %eax,%edx
  804b38:	74 ae                	je     804ae8 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804b3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b3e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804b42:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804b46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b4a:	8b 00                	mov    (%rax),%eax
  804b4c:	99                   	cltd   
  804b4d:	c1 ea 1b             	shr    $0x1b,%edx
  804b50:	01 d0                	add    %edx,%eax
  804b52:	83 e0 1f             	and    $0x1f,%eax
  804b55:	29 d0                	sub    %edx,%eax
  804b57:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b5b:	48 98                	cltq   
  804b5d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804b62:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804b64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b68:	8b 00                	mov    (%rax),%eax
  804b6a:	8d 50 01             	lea    0x1(%rax),%edx
  804b6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b71:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804b73:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804b78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b7c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804b80:	0f 82 60 ff ff ff    	jb     804ae6 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804b86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804b8a:	c9                   	leaveq 
  804b8b:	c3                   	retq   

0000000000804b8c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804b8c:	55                   	push   %rbp
  804b8d:	48 89 e5             	mov    %rsp,%rbp
  804b90:	48 83 ec 40          	sub    $0x40,%rsp
  804b94:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804b98:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804b9c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804ba0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ba4:	48 89 c7             	mov    %rax,%rdi
  804ba7:	48 b8 65 2f 80 00 00 	movabs $0x802f65,%rax
  804bae:	00 00 00 
  804bb1:	ff d0                	callq  *%rax
  804bb3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804bb7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804bbb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804bbf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804bc6:	00 
  804bc7:	e9 8e 00 00 00       	jmpq   804c5a <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804bcc:	eb 31                	jmp    804bff <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804bce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804bd2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804bd6:	48 89 d6             	mov    %rdx,%rsi
  804bd9:	48 89 c7             	mov    %rax,%rdi
  804bdc:	48 b8 6f 49 80 00 00 	movabs $0x80496f,%rax
  804be3:	00 00 00 
  804be6:	ff d0                	callq  *%rax
  804be8:	85 c0                	test   %eax,%eax
  804bea:	74 07                	je     804bf3 <devpipe_write+0x67>
				return 0;
  804bec:	b8 00 00 00 00       	mov    $0x0,%eax
  804bf1:	eb 79                	jmp    804c6c <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804bf3:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  804bfa:	00 00 00 
  804bfd:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804bff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c03:	8b 40 04             	mov    0x4(%rax),%eax
  804c06:	48 63 d0             	movslq %eax,%rdx
  804c09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c0d:	8b 00                	mov    (%rax),%eax
  804c0f:	48 98                	cltq   
  804c11:	48 83 c0 20          	add    $0x20,%rax
  804c15:	48 39 c2             	cmp    %rax,%rdx
  804c18:	73 b4                	jae    804bce <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804c1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c1e:	8b 40 04             	mov    0x4(%rax),%eax
  804c21:	99                   	cltd   
  804c22:	c1 ea 1b             	shr    $0x1b,%edx
  804c25:	01 d0                	add    %edx,%eax
  804c27:	83 e0 1f             	and    $0x1f,%eax
  804c2a:	29 d0                	sub    %edx,%eax
  804c2c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804c30:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804c34:	48 01 ca             	add    %rcx,%rdx
  804c37:	0f b6 0a             	movzbl (%rdx),%ecx
  804c3a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804c3e:	48 98                	cltq   
  804c40:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804c44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c48:	8b 40 04             	mov    0x4(%rax),%eax
  804c4b:	8d 50 01             	lea    0x1(%rax),%edx
  804c4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c52:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804c55:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804c5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c5e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804c62:	0f 82 64 ff ff ff    	jb     804bcc <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804c68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804c6c:	c9                   	leaveq 
  804c6d:	c3                   	retq   

0000000000804c6e <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804c6e:	55                   	push   %rbp
  804c6f:	48 89 e5             	mov    %rsp,%rbp
  804c72:	48 83 ec 20          	sub    $0x20,%rsp
  804c76:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804c7a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804c7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c82:	48 89 c7             	mov    %rax,%rdi
  804c85:	48 b8 65 2f 80 00 00 	movabs $0x802f65,%rax
  804c8c:	00 00 00 
  804c8f:	ff d0                	callq  *%rax
  804c91:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804c95:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804c99:	48 be 48 60 80 00 00 	movabs $0x806048,%rsi
  804ca0:	00 00 00 
  804ca3:	48 89 c7             	mov    %rax,%rdi
  804ca6:	48 b8 df 18 80 00 00 	movabs $0x8018df,%rax
  804cad:	00 00 00 
  804cb0:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804cb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804cb6:	8b 50 04             	mov    0x4(%rax),%edx
  804cb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804cbd:	8b 00                	mov    (%rax),%eax
  804cbf:	29 c2                	sub    %eax,%edx
  804cc1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804cc5:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804ccb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804ccf:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804cd6:	00 00 00 
	stat->st_dev = &devpipe;
  804cd9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804cdd:	48 b9 e0 80 80 00 00 	movabs $0x8080e0,%rcx
  804ce4:	00 00 00 
  804ce7:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804cee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804cf3:	c9                   	leaveq 
  804cf4:	c3                   	retq   

0000000000804cf5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804cf5:	55                   	push   %rbp
  804cf6:	48 89 e5             	mov    %rsp,%rbp
  804cf9:	48 83 ec 10          	sub    $0x10,%rsp
  804cfd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  804d01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d05:	48 89 c6             	mov    %rax,%rsi
  804d08:	bf 00 00 00 00       	mov    $0x0,%edi
  804d0d:	48 b8 b9 22 80 00 00 	movabs $0x8022b9,%rax
  804d14:	00 00 00 
  804d17:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804d19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d1d:	48 89 c7             	mov    %rax,%rdi
  804d20:	48 b8 65 2f 80 00 00 	movabs $0x802f65,%rax
  804d27:	00 00 00 
  804d2a:	ff d0                	callq  *%rax
  804d2c:	48 89 c6             	mov    %rax,%rsi
  804d2f:	bf 00 00 00 00       	mov    $0x0,%edi
  804d34:	48 b8 b9 22 80 00 00 	movabs $0x8022b9,%rax
  804d3b:	00 00 00 
  804d3e:	ff d0                	callq  *%rax
}
  804d40:	c9                   	leaveq 
  804d41:	c3                   	retq   

0000000000804d42 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804d42:	55                   	push   %rbp
  804d43:	48 89 e5             	mov    %rsp,%rbp
  804d46:	48 83 ec 20          	sub    $0x20,%rsp
  804d4a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804d4d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804d50:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804d53:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804d57:	be 01 00 00 00       	mov    $0x1,%esi
  804d5c:	48 89 c7             	mov    %rax,%rdi
  804d5f:	48 b8 c6 20 80 00 00 	movabs $0x8020c6,%rax
  804d66:	00 00 00 
  804d69:	ff d0                	callq  *%rax
}
  804d6b:	c9                   	leaveq 
  804d6c:	c3                   	retq   

0000000000804d6d <getchar>:

int
getchar(void)
{
  804d6d:	55                   	push   %rbp
  804d6e:	48 89 e5             	mov    %rsp,%rbp
  804d71:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804d75:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804d79:	ba 01 00 00 00       	mov    $0x1,%edx
  804d7e:	48 89 c6             	mov    %rax,%rsi
  804d81:	bf 00 00 00 00       	mov    $0x0,%edi
  804d86:	48 b8 5a 34 80 00 00 	movabs $0x80345a,%rax
  804d8d:	00 00 00 
  804d90:	ff d0                	callq  *%rax
  804d92:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804d95:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d99:	79 05                	jns    804da0 <getchar+0x33>
		return r;
  804d9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d9e:	eb 14                	jmp    804db4 <getchar+0x47>
	if (r < 1)
  804da0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804da4:	7f 07                	jg     804dad <getchar+0x40>
		return -E_EOF;
  804da6:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804dab:	eb 07                	jmp    804db4 <getchar+0x47>
	return c;
  804dad:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804db1:	0f b6 c0             	movzbl %al,%eax

}
  804db4:	c9                   	leaveq 
  804db5:	c3                   	retq   

0000000000804db6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804db6:	55                   	push   %rbp
  804db7:	48 89 e5             	mov    %rsp,%rbp
  804dba:	48 83 ec 20          	sub    $0x20,%rsp
  804dbe:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804dc1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804dc5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804dc8:	48 89 d6             	mov    %rdx,%rsi
  804dcb:	89 c7                	mov    %eax,%edi
  804dcd:	48 b8 28 30 80 00 00 	movabs $0x803028,%rax
  804dd4:	00 00 00 
  804dd7:	ff d0                	callq  *%rax
  804dd9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804ddc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804de0:	79 05                	jns    804de7 <iscons+0x31>
		return r;
  804de2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804de5:	eb 1a                	jmp    804e01 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804de7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804deb:	8b 10                	mov    (%rax),%edx
  804ded:	48 b8 20 81 80 00 00 	movabs $0x808120,%rax
  804df4:	00 00 00 
  804df7:	8b 00                	mov    (%rax),%eax
  804df9:	39 c2                	cmp    %eax,%edx
  804dfb:	0f 94 c0             	sete   %al
  804dfe:	0f b6 c0             	movzbl %al,%eax
}
  804e01:	c9                   	leaveq 
  804e02:	c3                   	retq   

0000000000804e03 <opencons>:

int
opencons(void)
{
  804e03:	55                   	push   %rbp
  804e04:	48 89 e5             	mov    %rsp,%rbp
  804e07:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804e0b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804e0f:	48 89 c7             	mov    %rax,%rdi
  804e12:	48 b8 90 2f 80 00 00 	movabs $0x802f90,%rax
  804e19:	00 00 00 
  804e1c:	ff d0                	callq  *%rax
  804e1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804e21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e25:	79 05                	jns    804e2c <opencons+0x29>
		return r;
  804e27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e2a:	eb 5b                	jmp    804e87 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804e2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e30:	ba 07 04 00 00       	mov    $0x407,%edx
  804e35:	48 89 c6             	mov    %rax,%rsi
  804e38:	bf 00 00 00 00       	mov    $0x0,%edi
  804e3d:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  804e44:	00 00 00 
  804e47:	ff d0                	callq  *%rax
  804e49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804e4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e50:	79 05                	jns    804e57 <opencons+0x54>
		return r;
  804e52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e55:	eb 30                	jmp    804e87 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804e57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e5b:	48 ba 20 81 80 00 00 	movabs $0x808120,%rdx
  804e62:	00 00 00 
  804e65:	8b 12                	mov    (%rdx),%edx
  804e67:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804e69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e6d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804e74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e78:	48 89 c7             	mov    %rax,%rdi
  804e7b:	48 b8 42 2f 80 00 00 	movabs $0x802f42,%rax
  804e82:	00 00 00 
  804e85:	ff d0                	callq  *%rax
}
  804e87:	c9                   	leaveq 
  804e88:	c3                   	retq   

0000000000804e89 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804e89:	55                   	push   %rbp
  804e8a:	48 89 e5             	mov    %rsp,%rbp
  804e8d:	48 83 ec 30          	sub    $0x30,%rsp
  804e91:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804e95:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804e99:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804e9d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804ea2:	75 07                	jne    804eab <devcons_read+0x22>
		return 0;
  804ea4:	b8 00 00 00 00       	mov    $0x0,%eax
  804ea9:	eb 4b                	jmp    804ef6 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804eab:	eb 0c                	jmp    804eb9 <devcons_read+0x30>
		sys_yield();
  804ead:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  804eb4:	00 00 00 
  804eb7:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804eb9:	48 b8 10 21 80 00 00 	movabs $0x802110,%rax
  804ec0:	00 00 00 
  804ec3:	ff d0                	callq  *%rax
  804ec5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804ec8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ecc:	74 df                	je     804ead <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804ece:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ed2:	79 05                	jns    804ed9 <devcons_read+0x50>
		return c;
  804ed4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ed7:	eb 1d                	jmp    804ef6 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804ed9:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804edd:	75 07                	jne    804ee6 <devcons_read+0x5d>
		return 0;
  804edf:	b8 00 00 00 00       	mov    $0x0,%eax
  804ee4:	eb 10                	jmp    804ef6 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804ee6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ee9:	89 c2                	mov    %eax,%edx
  804eeb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804eef:	88 10                	mov    %dl,(%rax)
	return 1;
  804ef1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804ef6:	c9                   	leaveq 
  804ef7:	c3                   	retq   

0000000000804ef8 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804ef8:	55                   	push   %rbp
  804ef9:	48 89 e5             	mov    %rsp,%rbp
  804efc:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804f03:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804f0a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804f11:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804f18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804f1f:	eb 76                	jmp    804f97 <devcons_write+0x9f>
		m = n - tot;
  804f21:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804f28:	89 c2                	mov    %eax,%edx
  804f2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f2d:	29 c2                	sub    %eax,%edx
  804f2f:	89 d0                	mov    %edx,%eax
  804f31:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804f34:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804f37:	83 f8 7f             	cmp    $0x7f,%eax
  804f3a:	76 07                	jbe    804f43 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804f3c:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804f43:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804f46:	48 63 d0             	movslq %eax,%rdx
  804f49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f4c:	48 63 c8             	movslq %eax,%rcx
  804f4f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804f56:	48 01 c1             	add    %rax,%rcx
  804f59:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804f60:	48 89 ce             	mov    %rcx,%rsi
  804f63:	48 89 c7             	mov    %rax,%rdi
  804f66:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  804f6d:	00 00 00 
  804f70:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804f72:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804f75:	48 63 d0             	movslq %eax,%rdx
  804f78:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804f7f:	48 89 d6             	mov    %rdx,%rsi
  804f82:	48 89 c7             	mov    %rax,%rdi
  804f85:	48 b8 c6 20 80 00 00 	movabs $0x8020c6,%rax
  804f8c:	00 00 00 
  804f8f:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804f91:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804f94:	01 45 fc             	add    %eax,-0x4(%rbp)
  804f97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f9a:	48 98                	cltq   
  804f9c:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804fa3:	0f 82 78 ff ff ff    	jb     804f21 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804fa9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804fac:	c9                   	leaveq 
  804fad:	c3                   	retq   

0000000000804fae <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804fae:	55                   	push   %rbp
  804faf:	48 89 e5             	mov    %rsp,%rbp
  804fb2:	48 83 ec 08          	sub    $0x8,%rsp
  804fb6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804fba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804fbf:	c9                   	leaveq 
  804fc0:	c3                   	retq   

0000000000804fc1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804fc1:	55                   	push   %rbp
  804fc2:	48 89 e5             	mov    %rsp,%rbp
  804fc5:	48 83 ec 10          	sub    $0x10,%rsp
  804fc9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804fcd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804fd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804fd5:	48 be 54 60 80 00 00 	movabs $0x806054,%rsi
  804fdc:	00 00 00 
  804fdf:	48 89 c7             	mov    %rax,%rdi
  804fe2:	48 b8 df 18 80 00 00 	movabs $0x8018df,%rax
  804fe9:	00 00 00 
  804fec:	ff d0                	callq  *%rax
	return 0;
  804fee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804ff3:	c9                   	leaveq 
  804ff4:	c3                   	retq   

0000000000804ff5 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804ff5:	55                   	push   %rbp
  804ff6:	48 89 e5             	mov    %rsp,%rbp
  804ff9:	48 83 ec 20          	sub    $0x20,%rsp
  804ffd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  805001:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805008:	00 00 00 
  80500b:	48 8b 00             	mov    (%rax),%rax
  80500e:	48 85 c0             	test   %rax,%rax
  805011:	75 6f                	jne    805082 <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  805013:	ba 07 00 00 00       	mov    $0x7,%edx
  805018:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80501d:	bf 00 00 00 00       	mov    $0x0,%edi
  805022:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  805029:	00 00 00 
  80502c:	ff d0                	callq  *%rax
  80502e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805031:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805035:	79 30                	jns    805067 <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  805037:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80503a:	89 c1                	mov    %eax,%ecx
  80503c:	48 ba 60 60 80 00 00 	movabs $0x806060,%rdx
  805043:	00 00 00 
  805046:	be 22 00 00 00       	mov    $0x22,%esi
  80504b:	48 bf 7f 60 80 00 00 	movabs $0x80607f,%rdi
  805052:	00 00 00 
  805055:	b8 00 00 00 00       	mov    $0x0,%eax
  80505a:	49 b8 f1 0a 80 00 00 	movabs $0x800af1,%r8
  805061:	00 00 00 
  805064:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  805067:	48 be 95 50 80 00 00 	movabs $0x805095,%rsi
  80506e:	00 00 00 
  805071:	bf 00 00 00 00       	mov    $0x0,%edi
  805076:	48 b8 98 23 80 00 00 	movabs $0x802398,%rax
  80507d:	00 00 00 
  805080:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  805082:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805089:	00 00 00 
  80508c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805090:	48 89 10             	mov    %rdx,(%rax)
}
  805093:	c9                   	leaveq 
  805094:	c3                   	retq   

0000000000805095 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  805095:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  805098:	48 a1 00 d0 80 00 00 	movabs 0x80d000,%rax
  80509f:	00 00 00 
call *%rax
  8050a2:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  8050a4:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  8050ab:	00 08 
    movq 152(%rsp), %rax
  8050ad:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  8050b4:	00 
    movq 136(%rsp), %rbx
  8050b5:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8050bc:	00 
movq %rbx, (%rax)
  8050bd:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  8050c0:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  8050c4:	4c 8b 3c 24          	mov    (%rsp),%r15
  8050c8:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8050cd:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8050d2:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8050d7:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8050dc:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8050e1:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8050e6:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8050eb:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8050f0:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8050f5:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8050fa:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8050ff:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  805104:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  805109:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80510e:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  805112:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  805116:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  805117:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  80511c:	c3                   	retq   

000000000080511d <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  80511d:	55                   	push   %rbp
  80511e:	48 89 e5             	mov    %rsp,%rbp
  805121:	48 83 ec 18          	sub    $0x18,%rsp
  805125:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  805129:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80512d:	48 c1 e8 15          	shr    $0x15,%rax
  805131:	48 89 c2             	mov    %rax,%rdx
  805134:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80513b:	01 00 00 
  80513e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805142:	83 e0 01             	and    $0x1,%eax
  805145:	48 85 c0             	test   %rax,%rax
  805148:	75 07                	jne    805151 <pageref+0x34>
		return 0;
  80514a:	b8 00 00 00 00       	mov    $0x0,%eax
  80514f:	eb 53                	jmp    8051a4 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  805151:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805155:	48 c1 e8 0c          	shr    $0xc,%rax
  805159:	48 89 c2             	mov    %rax,%rdx
  80515c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805163:	01 00 00 
  805166:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80516a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80516e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805172:	83 e0 01             	and    $0x1,%eax
  805175:	48 85 c0             	test   %rax,%rax
  805178:	75 07                	jne    805181 <pageref+0x64>
		return 0;
  80517a:	b8 00 00 00 00       	mov    $0x0,%eax
  80517f:	eb 23                	jmp    8051a4 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  805181:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805185:	48 c1 e8 0c          	shr    $0xc,%rax
  805189:	48 89 c2             	mov    %rax,%rdx
  80518c:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805193:	00 00 00 
  805196:	48 c1 e2 04          	shl    $0x4,%rdx
  80519a:	48 01 d0             	add    %rdx,%rax
  80519d:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8051a1:	0f b7 c0             	movzwl %ax,%eax
}
  8051a4:	c9                   	leaveq 
  8051a5:	c3                   	retq   

00000000008051a6 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  8051a6:	55                   	push   %rbp
  8051a7:	48 89 e5             	mov    %rsp,%rbp
  8051aa:	48 83 ec 20          	sub    $0x20,%rsp
  8051ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  8051b2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8051b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8051ba:	48 89 d6             	mov    %rdx,%rsi
  8051bd:	48 89 c7             	mov    %rax,%rdi
  8051c0:	48 b8 dc 51 80 00 00 	movabs $0x8051dc,%rax
  8051c7:	00 00 00 
  8051ca:	ff d0                	callq  *%rax
  8051cc:	85 c0                	test   %eax,%eax
  8051ce:	74 05                	je     8051d5 <inet_addr+0x2f>
    return (val.s_addr);
  8051d0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8051d3:	eb 05                	jmp    8051da <inet_addr+0x34>
  }
  return (INADDR_NONE);
  8051d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  8051da:	c9                   	leaveq 
  8051db:	c3                   	retq   

00000000008051dc <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  8051dc:	55                   	push   %rbp
  8051dd:	48 89 e5             	mov    %rsp,%rbp
  8051e0:	48 83 ec 40          	sub    $0x40,%rsp
  8051e4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8051e8:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  8051ec:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8051f0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  8051f4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8051f8:	0f b6 00             	movzbl (%rax),%eax
  8051fb:	0f be c0             	movsbl %al,%eax
  8051fe:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  805201:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805204:	3c 2f                	cmp    $0x2f,%al
  805206:	76 07                	jbe    80520f <inet_aton+0x33>
  805208:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80520b:	3c 39                	cmp    $0x39,%al
  80520d:	76 0a                	jbe    805219 <inet_aton+0x3d>
      return (0);
  80520f:	b8 00 00 00 00       	mov    $0x0,%eax
  805214:	e9 68 02 00 00       	jmpq   805481 <inet_aton+0x2a5>
    val = 0;
  805219:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  805220:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  805227:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  80522b:	75 40                	jne    80526d <inet_aton+0x91>
      c = *++cp;
  80522d:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  805232:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805236:	0f b6 00             	movzbl (%rax),%eax
  805239:	0f be c0             	movsbl %al,%eax
  80523c:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  80523f:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  805243:	74 06                	je     80524b <inet_aton+0x6f>
  805245:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  805249:	75 1b                	jne    805266 <inet_aton+0x8a>
        base = 16;
  80524b:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  805252:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  805257:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80525b:	0f b6 00             	movzbl (%rax),%eax
  80525e:	0f be c0             	movsbl %al,%eax
  805261:	89 45 f4             	mov    %eax,-0xc(%rbp)
  805264:	eb 07                	jmp    80526d <inet_aton+0x91>
      } else
        base = 8;
  805266:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  80526d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805270:	3c 2f                	cmp    $0x2f,%al
  805272:	76 2f                	jbe    8052a3 <inet_aton+0xc7>
  805274:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805277:	3c 39                	cmp    $0x39,%al
  805279:	77 28                	ja     8052a3 <inet_aton+0xc7>
        val = (val * base) + (int)(c - '0');
  80527b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80527e:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  805282:	89 c2                	mov    %eax,%edx
  805284:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805287:	01 d0                	add    %edx,%eax
  805289:	83 e8 30             	sub    $0x30,%eax
  80528c:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  80528f:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  805294:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805298:	0f b6 00             	movzbl (%rax),%eax
  80529b:	0f be c0             	movsbl %al,%eax
  80529e:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else if (base == 16 && isxdigit(c)) {
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
  8052a1:	eb ca                	jmp    80526d <inet_aton+0x91>
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  8052a3:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  8052a7:	75 72                	jne    80531b <inet_aton+0x13f>
  8052a9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052ac:	3c 2f                	cmp    $0x2f,%al
  8052ae:	76 07                	jbe    8052b7 <inet_aton+0xdb>
  8052b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052b3:	3c 39                	cmp    $0x39,%al
  8052b5:	76 1c                	jbe    8052d3 <inet_aton+0xf7>
  8052b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052ba:	3c 60                	cmp    $0x60,%al
  8052bc:	76 07                	jbe    8052c5 <inet_aton+0xe9>
  8052be:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052c1:	3c 66                	cmp    $0x66,%al
  8052c3:	76 0e                	jbe    8052d3 <inet_aton+0xf7>
  8052c5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052c8:	3c 40                	cmp    $0x40,%al
  8052ca:	76 4f                	jbe    80531b <inet_aton+0x13f>
  8052cc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052cf:	3c 46                	cmp    $0x46,%al
  8052d1:	77 48                	ja     80531b <inet_aton+0x13f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8052d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8052d6:	c1 e0 04             	shl    $0x4,%eax
  8052d9:	89 c2                	mov    %eax,%edx
  8052db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052de:	8d 48 0a             	lea    0xa(%rax),%ecx
  8052e1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052e4:	3c 60                	cmp    $0x60,%al
  8052e6:	76 0e                	jbe    8052f6 <inet_aton+0x11a>
  8052e8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052eb:	3c 7a                	cmp    $0x7a,%al
  8052ed:	77 07                	ja     8052f6 <inet_aton+0x11a>
  8052ef:	b8 61 00 00 00       	mov    $0x61,%eax
  8052f4:	eb 05                	jmp    8052fb <inet_aton+0x11f>
  8052f6:	b8 41 00 00 00       	mov    $0x41,%eax
  8052fb:	29 c1                	sub    %eax,%ecx
  8052fd:	89 c8                	mov    %ecx,%eax
  8052ff:	09 d0                	or     %edx,%eax
  805301:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  805304:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  805309:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80530d:	0f b6 00             	movzbl (%rax),%eax
  805310:	0f be c0             	movsbl %al,%eax
  805313:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  805316:	e9 52 ff ff ff       	jmpq   80526d <inet_aton+0x91>
    if (c == '.') {
  80531b:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  80531f:	75 40                	jne    805361 <inet_aton+0x185>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  805321:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  805325:	48 83 c0 0c          	add    $0xc,%rax
  805329:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  80532d:	72 0a                	jb     805339 <inet_aton+0x15d>
        return (0);
  80532f:	b8 00 00 00 00       	mov    $0x0,%eax
  805334:	e9 48 01 00 00       	jmpq   805481 <inet_aton+0x2a5>
      *pp++ = val;
  805339:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80533d:	48 8d 50 04          	lea    0x4(%rax),%rdx
  805341:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  805345:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805348:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  80534a:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  80534f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805353:	0f b6 00             	movzbl (%rax),%eax
  805356:	0f be c0             	movsbl %al,%eax
  805359:	89 45 f4             	mov    %eax,-0xc(%rbp)
    } else
      break;
  }
  80535c:	e9 a0 fe ff ff       	jmpq   805201 <inet_aton+0x25>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  805361:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  805362:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  805366:	74 3c                	je     8053a4 <inet_aton+0x1c8>
  805368:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80536b:	3c 1f                	cmp    $0x1f,%al
  80536d:	76 2b                	jbe    80539a <inet_aton+0x1be>
  80536f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805372:	84 c0                	test   %al,%al
  805374:	78 24                	js     80539a <inet_aton+0x1be>
  805376:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  80537a:	74 28                	je     8053a4 <inet_aton+0x1c8>
  80537c:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  805380:	74 22                	je     8053a4 <inet_aton+0x1c8>
  805382:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  805386:	74 1c                	je     8053a4 <inet_aton+0x1c8>
  805388:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  80538c:	74 16                	je     8053a4 <inet_aton+0x1c8>
  80538e:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  805392:	74 10                	je     8053a4 <inet_aton+0x1c8>
  805394:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  805398:	74 0a                	je     8053a4 <inet_aton+0x1c8>
    return (0);
  80539a:	b8 00 00 00 00       	mov    $0x0,%eax
  80539f:	e9 dd 00 00 00       	jmpq   805481 <inet_aton+0x2a5>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  8053a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8053a8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8053ac:	48 29 c2             	sub    %rax,%rdx
  8053af:	48 89 d0             	mov    %rdx,%rax
  8053b2:	48 c1 f8 02          	sar    $0x2,%rax
  8053b6:	83 c0 01             	add    $0x1,%eax
  8053b9:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  8053bc:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  8053c0:	0f 87 98 00 00 00    	ja     80545e <inet_aton+0x282>
  8053c6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8053c9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8053d0:	00 
  8053d1:	48 b8 90 60 80 00 00 	movabs $0x806090,%rax
  8053d8:	00 00 00 
  8053db:	48 01 d0             	add    %rdx,%rax
  8053de:	48 8b 00             	mov    (%rax),%rax
  8053e1:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  8053e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8053e8:	e9 94 00 00 00       	jmpq   805481 <inet_aton+0x2a5>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  8053ed:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  8053f4:	76 0a                	jbe    805400 <inet_aton+0x224>
      return (0);
  8053f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8053fb:	e9 81 00 00 00       	jmpq   805481 <inet_aton+0x2a5>
    val |= parts[0] << 24;
  805400:	8b 45 d0             	mov    -0x30(%rbp),%eax
  805403:	c1 e0 18             	shl    $0x18,%eax
  805406:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  805409:	eb 53                	jmp    80545e <inet_aton+0x282>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  80540b:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  805412:	76 07                	jbe    80541b <inet_aton+0x23f>
      return (0);
  805414:	b8 00 00 00 00       	mov    $0x0,%eax
  805419:	eb 66                	jmp    805481 <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16);
  80541b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80541e:	c1 e0 18             	shl    $0x18,%eax
  805421:	89 c2                	mov    %eax,%edx
  805423:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  805426:	c1 e0 10             	shl    $0x10,%eax
  805429:	09 d0                	or     %edx,%eax
  80542b:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80542e:	eb 2e                	jmp    80545e <inet_aton+0x282>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  805430:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  805437:	76 07                	jbe    805440 <inet_aton+0x264>
      return (0);
  805439:	b8 00 00 00 00       	mov    $0x0,%eax
  80543e:	eb 41                	jmp    805481 <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  805440:	8b 45 d0             	mov    -0x30(%rbp),%eax
  805443:	c1 e0 18             	shl    $0x18,%eax
  805446:	89 c2                	mov    %eax,%edx
  805448:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80544b:	c1 e0 10             	shl    $0x10,%eax
  80544e:	09 c2                	or     %eax,%edx
  805450:	8b 45 d8             	mov    -0x28(%rbp),%eax
  805453:	c1 e0 08             	shl    $0x8,%eax
  805456:	09 d0                	or     %edx,%eax
  805458:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80545b:	eb 01                	jmp    80545e <inet_aton+0x282>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  80545d:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  80545e:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  805463:	74 17                	je     80547c <inet_aton+0x2a0>
    addr->s_addr = htonl(val);
  805465:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805468:	89 c7                	mov    %eax,%edi
  80546a:	48 b8 fa 55 80 00 00 	movabs $0x8055fa,%rax
  805471:	00 00 00 
  805474:	ff d0                	callq  *%rax
  805476:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80547a:	89 02                	mov    %eax,(%rdx)
  return (1);
  80547c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  805481:	c9                   	leaveq 
  805482:	c3                   	retq   

0000000000805483 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  805483:	55                   	push   %rbp
  805484:	48 89 e5             	mov    %rsp,%rbp
  805487:	48 83 ec 30          	sub    $0x30,%rsp
  80548b:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80548e:	8b 45 d0             	mov    -0x30(%rbp),%eax
  805491:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  805494:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  80549b:	00 00 00 
  80549e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  8054a2:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8054a6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  8054aa:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  8054ae:	e9 e0 00 00 00       	jmpq   805593 <inet_ntoa+0x110>
    i = 0;
  8054b3:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  8054b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8054bb:	0f b6 08             	movzbl (%rax),%ecx
  8054be:	0f b6 d1             	movzbl %cl,%edx
  8054c1:	89 d0                	mov    %edx,%eax
  8054c3:	c1 e0 02             	shl    $0x2,%eax
  8054c6:	01 d0                	add    %edx,%eax
  8054c8:	c1 e0 03             	shl    $0x3,%eax
  8054cb:	01 d0                	add    %edx,%eax
  8054cd:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8054d4:	01 d0                	add    %edx,%eax
  8054d6:	66 c1 e8 08          	shr    $0x8,%ax
  8054da:	c0 e8 03             	shr    $0x3,%al
  8054dd:	88 45 ed             	mov    %al,-0x13(%rbp)
  8054e0:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  8054e4:	89 d0                	mov    %edx,%eax
  8054e6:	c1 e0 02             	shl    $0x2,%eax
  8054e9:	01 d0                	add    %edx,%eax
  8054eb:	01 c0                	add    %eax,%eax
  8054ed:	29 c1                	sub    %eax,%ecx
  8054ef:	89 c8                	mov    %ecx,%eax
  8054f1:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  8054f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8054f8:	0f b6 00             	movzbl (%rax),%eax
  8054fb:	0f b6 d0             	movzbl %al,%edx
  8054fe:	89 d0                	mov    %edx,%eax
  805500:	c1 e0 02             	shl    $0x2,%eax
  805503:	01 d0                	add    %edx,%eax
  805505:	c1 e0 03             	shl    $0x3,%eax
  805508:	01 d0                	add    %edx,%eax
  80550a:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  805511:	01 d0                	add    %edx,%eax
  805513:	66 c1 e8 08          	shr    $0x8,%ax
  805517:	89 c2                	mov    %eax,%edx
  805519:	c0 ea 03             	shr    $0x3,%dl
  80551c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805520:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  805522:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  805526:	8d 50 01             	lea    0x1(%rax),%edx
  805529:	88 55 ee             	mov    %dl,-0x12(%rbp)
  80552c:	0f b6 c0             	movzbl %al,%eax
  80552f:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  805533:	83 c2 30             	add    $0x30,%edx
  805536:	48 98                	cltq   
  805538:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  80553c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805540:	0f b6 00             	movzbl (%rax),%eax
  805543:	84 c0                	test   %al,%al
  805545:	0f 85 6c ff ff ff    	jne    8054b7 <inet_ntoa+0x34>
    while(i--)
  80554b:	eb 1a                	jmp    805567 <inet_ntoa+0xe4>
      *rp++ = inv[i];
  80554d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805551:	48 8d 50 01          	lea    0x1(%rax),%rdx
  805555:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  805559:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  80555d:	48 63 d2             	movslq %edx,%rdx
  805560:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  805565:	88 10                	mov    %dl,(%rax)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  805567:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  80556b:	8d 50 ff             	lea    -0x1(%rax),%edx
  80556e:	88 55 ee             	mov    %dl,-0x12(%rbp)
  805571:	84 c0                	test   %al,%al
  805573:	75 d8                	jne    80554d <inet_ntoa+0xca>
      *rp++ = inv[i];
    *rp++ = '.';
  805575:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805579:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80557d:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  805581:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  805584:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  805589:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80558d:	83 c0 01             	add    $0x1,%eax
  805590:	88 45 ef             	mov    %al,-0x11(%rbp)
  805593:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  805597:	0f 86 16 ff ff ff    	jbe    8054b3 <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  80559d:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  8055a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055a6:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  8055a9:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  8055b0:	00 00 00 
}
  8055b3:	c9                   	leaveq 
  8055b4:	c3                   	retq   

00000000008055b5 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8055b5:	55                   	push   %rbp
  8055b6:	48 89 e5             	mov    %rsp,%rbp
  8055b9:	48 83 ec 04          	sub    $0x4,%rsp
  8055bd:	89 f8                	mov    %edi,%eax
  8055bf:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8055c3:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8055c7:	c1 e0 08             	shl    $0x8,%eax
  8055ca:	89 c2                	mov    %eax,%edx
  8055cc:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8055d0:	66 c1 e8 08          	shr    $0x8,%ax
  8055d4:	09 d0                	or     %edx,%eax
}
  8055d6:	c9                   	leaveq 
  8055d7:	c3                   	retq   

00000000008055d8 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8055d8:	55                   	push   %rbp
  8055d9:	48 89 e5             	mov    %rsp,%rbp
  8055dc:	48 83 ec 08          	sub    $0x8,%rsp
  8055e0:	89 f8                	mov    %edi,%eax
  8055e2:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  8055e6:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8055ea:	89 c7                	mov    %eax,%edi
  8055ec:	48 b8 b5 55 80 00 00 	movabs $0x8055b5,%rax
  8055f3:	00 00 00 
  8055f6:	ff d0                	callq  *%rax
}
  8055f8:	c9                   	leaveq 
  8055f9:	c3                   	retq   

00000000008055fa <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8055fa:	55                   	push   %rbp
  8055fb:	48 89 e5             	mov    %rsp,%rbp
  8055fe:	48 83 ec 04          	sub    $0x4,%rsp
  805602:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  805605:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805608:	c1 e0 18             	shl    $0x18,%eax
  80560b:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  80560d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805610:	25 00 ff 00 00       	and    $0xff00,%eax
  805615:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  805618:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  80561a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80561d:	25 00 00 ff 00       	and    $0xff0000,%eax
  805622:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  805626:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  805628:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80562b:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80562e:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  805630:	c9                   	leaveq 
  805631:	c3                   	retq   

0000000000805632 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  805632:	55                   	push   %rbp
  805633:	48 89 e5             	mov    %rsp,%rbp
  805636:	48 83 ec 08          	sub    $0x8,%rsp
  80563a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  80563d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805640:	89 c7                	mov    %eax,%edi
  805642:	48 b8 fa 55 80 00 00 	movabs $0x8055fa,%rax
  805649:	00 00 00 
  80564c:	ff d0                	callq  *%rax
}
  80564e:	c9                   	leaveq 
  80564f:	c3                   	retq   
